#system("clear")
require 'socket'
require 'thread'
require 'net/http'
require 'json'

require_relative 'database'
load "config.cfg"

$threads = []
$channel = ARGV[0]
$db = Database.new($channel)

def init
	system("mkdir #{$defaultPath}#{$channel[1..-1]}")

	if !File.exist?("#{$defaultPath}#{$channel[1..-1]}/cmds.cfg")
		File.new("#{$defaultPath}#{$channel[1..-1]}/cmds.cfg","w") 
	end
	if !File.exist?("#{$defaultPath}#{$channel[1..-1]}/msgs.cfg")
		File.new("#{$defaultPath}#{$channel[1..-1]}/msgs.cfg","w")
	end
	if !File.exist?("#{$defaultPath}#{$channel[1..-1]}/ranks.cfg")
		File.new("#{$defaultPath}#{$channel[1..-1]}/ranks.cfg","w")
	end
	if !File.exist?("#{$defaultPath}#{$channel[1..-1]}/nowplaying.txt")
		File.new("#{$defaultPath}#{$channel[1..-1]}/nowplaying.txt","w")
	end
	
	$s = TCPSocket.open $server, $port
	$s.puts "PASS #{$pw}"
	$s.puts "NICK #{$nick}"
	$s.puts "USER #{$nick} 0 * :totally a human!"
	$s.puts "JOIN #{$channel}"

	#init HTTP Socket
	
	$permitted = {}

	regular_pong
	load_configs
	get_mods
	userlist
	checkifpersist

	until $s.eof? do
		raw = $s.gets
		puts raw
		pure = encode_msg(raw)
		invoker = get_name(raw)
		cmds = ["-> !fq","!game","!points [name]","!top","!music","!uptime"]
		if raw.match(/PING :(.*)$/)
			puts "PONG :tmi.twitch.tv"
			$s.puts "PONG :tmi.twitch.tv"
			next
		end
		if !pure.nil?
			if !check_link(pure,invoker)
				if !check_caps(pure,invoker)
					if checkop invoker
						case pure
						when /^!permit (\w*)/
							send "#{$~[1]} darf einen Link senden"
							permit $~[1]
						when /^!start/
							if $threads.empty?
								init_loopmsg
								send "Nachrichten wurden gestartet"
							else
								send "Nachrichten schon aktiv, !restart zum neustarten"
							end
						when /^!gm/
							getmods
						when /^!cc/
							send "/clear"
							send "The chat was cleared!"
						when /^!cd (\w*)/
							countdown $~[1]
						when /^!ranks/
							$db.getranks
						when /^!sp (.*)/
							args = $~[1].split(" ")
							$db.setPoints(args[0].downcase,args[1])
						when /^!reload/
							$ranklist = $db.getranks
							load_configs
							send "Config reloaded!"
						when /^!restart/
							if $threads.empty?
								init_loopmsg
							else
								$threads.each do |thread|
									thread.stop
								end
								init_loopmsg
							end
							send "Nachrichten neu gestartet"
						when /^!stop/
							if $threads.empty?
								send "Nachrichten nicht aktiv, !start zum starten"
							else
								$threads.each do |thread|
									thread.exit
								end
								send "Nachrichten wurden gestoppt"
							end
							$threads = []
						end
					end
					case pure
					when /^!game/
						res = Net::HTTP.get_response(URI("http://apis.rtainc.co/twitchbot/status?user=#{$channel[1..-1]}")).body
						if res.match(/playing (\w*) for/)
							send "Current game: #{$~[1]}"
						else
							send "The channel is not live."
						end
					when /^!top/
						$db.createtoplist
						showtoplist
					when /^!music/
						send "Playing: #{check_music}"
					when /^!points ?(\w*)/
						if $~[1] == ""
							send $db.showStats(invoker.downcase)
						else
							send $db.showStats($~[1].downcase)
						end
					when /^!fq (.*)/
						fq $~[1]
						send "Your request has been sent"
					when /^!help/
						$cmds.each do |line|
							if line.match(/^(!.*);(.*)/)
								cmds << $~[1]
							end
						end
						send cmds.join(" ; ")
					when /^!uptime/
						send check_uptime
					end
					$cmds.each do |line|
						if line.match(/^(!.*);(.*)/)
							case pure
							when "#{$~[1]}"
								send $~[2]
							end
						end
					end
				end
			end
		end
	end
end

def check_music
	music = File.read("#{$defaultPath}#{$channel[1..-1]}/nowplaying.txt")
	return music
end

def regular_pong
	Thread.new{
		while true do
			$s.puts "PING :tmi.twitch.tv"
			sleep(180)
		end
	}
end

def checkifpersist
	Thread.new{
		loop do
			oldlist = $db.getfulluserlist
			sleep(1800)
			$db.getfulluserlist.each do |user|
				if oldlist.include?(user)
					if check_uptime != "The channel is not live."
						$db.addpoint user
					end
				end
			end
		end
	}
end

def newusers
	$userlist.each do |user|
		if !$db.checkForUser user
			$db.writeNewUser user
		else
		end
	end
end

def userlist
	Thread.new{
		loop do
			$userlist = $db.getfulluserlist
			newusers
			sleep(20)
		end	
	}
end

def init_loopmsg
	mainThread = Thread.new{
		puts "AutoMessages started"
		$lines.each do |msg|
			if msg.match(/(.*);(.*)/)
				puts "Message: #{$~[2]}"
				sleep($~[1].to_i)
				send $~[2]
			end
		end
	}
end

def countdown seconds
	@cd_seconds = seconds.to_i
	Thread.new{
		max = 0
		while @cd_seconds > max
			send "Seconds remaining: #{@cd_seconds}"
			sleep(1)
			@cd_seconds -= 1
		end
		send "--- Countdown Finished ---"
		Thread.exit
	}
end

def get_mods
	modthread = Thread.new{
		loop do
			$mods = JSON.parse(Net::HTTP.get_response(URI("http://tmi.twitch.tv/group/user/#{$channel[1..-1]}/chatters")).body)
			sleep(60)
		end
	}
end

def fq msg
	lines = Array.new
	begin
		lines = File.read("FeatureRequests.cfg")
	rescue
	end
	file2 = File.new("FeatureRequests.cfg","w")
	file2.puts lines << msg
	file2.close
end

def check_uptime
	return Net::HTTP.get_response(URI("http://nightdev.com/hosted/uptime.php?channel=#{$channel[1..-1]}")).body
end

def check_if_permit invoker
	return $permitted.include?(invoker.downcase)
end

def if_link(msg)
	case msg
	when /.*http:\/\/.*/
		return true
	when /.*www\..*/
		return true
	when /^.*\.\w{2,3}/
		return true
	else
		return false
	end	
end

def check_link(msg,invoker)
	if !checkop(invoker)
		if !check_if_permit(invoker)
			case msg
			when /.*http:\/\/.*/
				send "/timeout #{invoker} 1"
				send "Frage, bevor du einen Link postest #{invoker}!"
			when /.*www\..*/
				send "/timeout #{invoker} 1"
				send "Frage, bevor du einen Link postest #{invoker}!"
			when /.*\.\w{2,3}/
				send "/timeout #{invoker} 1"
				send "Frage, bevor du einen Link postest #{invoker}!"
			end
		else
			if if_link(msg)
				$permitted.delete_at($permitted.index(invoker.downcase))
			end
		end
	end
end

def showtoplist
	Thread.new{
		i = 1
		$toplist.each do
			|entry|
			send "#{i} - [#{entry[2]}] #{entry[0]} - #{entry[1]}"
			sleep(0.5)
			i+=1
			break if i >5
		end
	}
end

def load_configs
	cmd_file = File.new("#{$defaultPath}#{$channel[1..-1]}/cmds.cfg","r")
	$cmds = cmd_file.readlines
	cmd_file.close
	file = File.new("#{$defaultPath}#{$channel[1..-1]}/msgs.cfg","r")
	$lines = file.readlines
	file.close
end

def send msg
	$s.puts "PRIVMSG #{$channel} :#{msg}"
end

def check_caps(puremsg,invoker)
	if puremsg.length >= 5
		if !checkop invoker
			capletters = puremsg.scan(/[A-Z]/).join().length()
			if ((capletters.to_f/puremsg.length.to_f)*100).to_i > 60
				send "/timeout #{invoker} 1"
				send "Your message shall not pass! #{invoker}"
				return true
			else
				return false
			end
		end
	else
		return false
	end
end

def permit user
	$permitted << user.downcase
end

def checkop invoker
	return $mods["chatters"]["moderators"].include?(invoker.downcase)
end

def encode_msg msg
	if newm = msg.match(/PRIVMSG #{$channel} :(.*)/)
		encoded = newm[1..-1].join(" ").chop.to_s
		return encoded
	end
end

def get_name msg
	if name = msg.match(/!(.*)@.*/)
		return name[1].capitalize
	end
end

init