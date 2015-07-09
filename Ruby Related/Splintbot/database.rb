require 'json'
require 'net/http'
require 'thread'

class Database
	def initialize(channel)
		$channel = channel
		$dbname = "#{$channel[1..-1]}_DB.json"
		$defaultTemplate = JSON.parse(File.read("database.json"))
		loadDatabase
		createtoplist
		checkForRank
	end

	def getfulluserlist
		uri = URI("http://tmi.twitch.tv/group/user/#{$channel[1..-1]}/chatters")
		res = Net::HTTP.get_response(uri)
		$list = []
		$list << JSON.parse(res.body)["chatters"]["moderators"]
		$list << JSON.parse(res.body)["chatters"]["viewers"]
		$list.flatten!
		return $list
	end

	def showStats username
		if checkForUser username
			return "[#{@database["users"][username]["rank"]}] #{@database["users"][username]["displayname"].capitalize} - #{@database["users"][username]["points"]} Points"
		else
			return "User not registered yet"
		end
	end

	def checkForUser username
		begin
			return @database["users"].include?(username.downcase)
		rescue
			return false
		end
	end

	def setPoints username,points
		if checkForUser username
			@database["users"][username]["points"] = points.to_i
			puts "points of #{username} set to #{points}"
			saveDatabase @database
		else
			puts "Benutzer existiert nicht"
		end
	end

	def addpoint username
		@database["users"][username]["points"] += 5
		saveDatabase @database
	end
	
	def createtoplist
		Thread.new{
			$toplist = []
			@database["users"].each{
				|key,value|
				if value["displayname"] =~ /#.*/
				else
					$toplist << [value["displayname"],value["points"],value["rank"]]
				end
			}
			$toplist.sort_by!{|a,b| b}
			$toplist.reverse!
		}
	end

	def getranks
		newlist = []
		file = File.new("#{$defaultPath}#{$channel[1..-1]}/ranks.cfg","r")
		ranks = file.readlines
		ranks.each{ |rank|
			rank = rank.gsub(/\n/,"")
			rank = rank.gsub(/\r/,"")
			newlist << rank.split(";")
		}
		file.close
		return newlist
	end
	
	def checkForRank
		Thread.new{
			loop do
				$ranklist = getranks
				$ranklist.each {|points,rank|
					@database["users"].each{|user|
						if user[1]["points"] >= points.to_i
							if user[1]["displayname"] =~ /#.*/
								@database["users"][user[1]["displayname"][1..-1].downcase]["rank"] = rank
							else
								@database["users"][user[1]["displayname"].downcase]["rank"] = rank
							end
						end
					}
					saveDatabase @database
				}
				sleep(30)
			end
		}
	end

	def loadDatabase
		if File.exist?("#{$dbPath}#{$dbname}")
			puts "DATABASE LOADING ...."
			content = File.read("#{$dbPath}#{$dbname}")
			@database = JSON.parse(content) if !content.empty?
		else
			gen_database
		end		
	end

	def gen_database
		File.new("#{$dbPath}#{$dbname}","w")
		puts $defaultTemplate
		File.write($dbname,JSON.pretty_generate($defaultTemplate))
	end

	def writeNewUser username
		username = username.downcase
		@database["users"]["#{username}"] = {}
		@database["users"]["#{username}"]["displayname"] = username.capitalize
		@database["users"]["#{username}"]["points"] = 1
		@database["users"]["#{username}"]["rank"] = "Unranked"
		saveDatabase @database
	end

	def saveDatabase hash
		dbFile = File.write("#{$dbPath}#{$dbname}",JSON.pretty_generate(hash))
	end
end