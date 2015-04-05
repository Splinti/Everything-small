require 'teamspeak-ruby'


# CONFIG - MODIFY HERE
@afkid = 1192 # DB_ID of the AFK-Channel
@usegroup = true # Whether to use the non-move group system or not
@nomove = 796 # DB_ID of the non-move group
Querypw = 'Password' # PW of the Query-Login
@botname = "Splintis Bot" #Name of the bot
@serv_ip = 'localhost'
@serv_port = '10011'



# PROGRAM - DO NOT MODIFY
@history = Array.new
def checkuser
	while true
		if @usegroup then @clientlist = @ts.command('servergroupclientlist', {'sgid' => @nomove}) end
		@ts.command('clientlist').each do |user|
			@userclid = user['clid']
		  	clientinfo =  @ts.command('clientinfo', {'clid' => @userclid})
		  	if not clientinfo['client_nickname'] =~ /serveradmin.*/
		  		if not clientinfo['client_nickname'] =~ /#{@botname}.*/
		  			if @usegroup
		  				@clientlist.each do |client|
		  					if client['cldbid'] == clientinfo['client_database_id']
		  						@group = false
		  					end
		  				end
		  			end
		  			if @group
		  				if clientinfo['client_output_muted'] == 1
		  					@usercid = clientinfo['cid']
		  					x = @history.index{|e| e == @userclid }
		  					if x.nil?
		  							@history.push(@userclid,@usercid)
		  						begin
		  							@ts.command('clientmove', {'clid' => @userclid, 'cid' => @afkid})
		  						rescue
		  							puts "#{$!}"
		  						end
		  					end
		  				end
		  			end
		  			@group = true
		  		end
		  	end
		end
		if not @history.empty?
			checkstatus
		end
	end
end

def checkstatus
	u = 0
	for i in 1..@history.size/2
		begin
	  		clientinfo = @ts.command('clientinfo', {'clid' => @history[u] })
	  		if clientinfo['client_output_muted'] == 0
	  			usercid = clientinfo['cid']
	  			begin
	  				@ts.command('clientmove', {'clid' => @history[u], 'cid' => @history[u+1]})
	  				@history.delete_at(u)
	  				@history.delete_at(u)
	  				u = 0
	  			rescue
	  			end
	  		end
	  		u += 2
	  	rescue
	  		u = 0
	  	end
	end
end

def disconnect
	puts @ts.command('hostinfo')['host_timestamp_utc']
	@ts.disconnect
end


@ts = Teamspeak::Client.new(@serv_ip,@serv_port)
@ts.login('serveradmin', Querypw)
@ts.command('use', {'sid' => 1})
@ts.command('clientupdate', {'client_nickname' => @botname})
checkuser

