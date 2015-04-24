require 'Socket'
$port = 80
$id = 1

class String
	def black;          "\033[30m#{self}\033[0m" end
	def red;            "\033[31m#{self}\033[0m" end
	def green;          "\033[32m#{self}\033[0m" end
	def brown;          "\033[33m#{self}\033[0m" end
	def blue;           "\033[34m#{self}\033[0m" end
	def magenta;        "\033[35m#{self}\033[0m" end
	def cyan;           "\033[36m#{self}\033[0m" end
	def gray;           "\033[37m#{self}\033[0m" end
	def bg_black;       "\033[40m#{self}\033[0m" end
	def bg_red;         "\033[41m#{self}\033[0m" end
	def bg_green;       "\033[42m#{self}\033[0m" end
	def bg_brown;       "\033[43m#{self}\033[0m" end
	def bg_blue;        "\033[44m#{self}\033[0m" end
	def bg_magenta;     "\033[45m#{self}\033[0m" end
	def bg_cyan;        "\033[46m#{self}\033[0m" end
	def bg_gray;        "\033[47m#{self}\033[0m" end
	def bold;           "\033[1m#{self}\033[22m" end
	def reverse_color;  "\033[7m#{self}\033[27m" end
end

def ausgabe(x)
	y = Array.new
	x.each do |stat|
		if stat == $ply1sym
			y += [stat.green]
		elsif stat == $ply2sym
			y += [stat.red]
		else
			y += [stat]
		end
	end
	y.flatten
	puts "╔═══╦═══╦═══╗".cyan
	puts "║ ".cyan + y[0] + " ║ ".cyan + y[1] + " ║ ".cyan + y[2] + " ║".cyan
	puts "╠═══╬═══╬═══╣".cyan
	puts "║ ".cyan + y[3] + " ║ ".cyan + y[4] + " ║ ".cyan + y[5] + " ║".cyan
	puts "╠═══╬═══╬═══╣".cyan
	puts "║ ".cyan + y[6] + " ║ ".cyan + y[7] + " ║ ".cyan + y[8] + " ║".cyan
	puts "╚═══╩═══╩═══╝".cyan
end

def design(str)
	hash = "#".red
	max = 30
	if str.length%2 == 0
		spaces = ((max-str.length)/2)-1
		spaces2 = ((max-str.length)/2)-1
	else
		spaces = ((max-str.length)/2)
		spaces2 = ((max-str.length)/2)-1
	end
	puts hash*max
	puts hash + " "*(max-2) + hash
	puts hash + " "*(max-2) + hash
	puts hash + " "*spaces + str.green + " "*spaces2 + hash
	puts hash + " "*(max-2) + hash
	puts hash + " "*(max-2) + hash
	puts hash*max
end

def mpmenu
	system("cls")
	design("Mehrspieler")
	puts
	puts "1 - Zum Server verbinden"
	puts "2 - Server erstellen"
	puts
	puts "0 - Zurueck"
	print "Eingabe: "
	eingabe = gets.to_i
	if eingabe == 1
		connect
	elsif eingabe == 2
		startsv
	elsif eingabe == 0
		home
	else
		puts "Verfügbare Eingabe: 1-2"
		mpmenu
	end
end

def connect
	$id = 2
	system("cls")
	design("Mehrspieler")
	puts
	puts "Gebe die " + "IP-Adresse".green + " oder den " + "PC-Namen".green + " deines Mitspielers an."
	puts "Format: " + "127.0.0.1".green + " / " + "COMPUTER1".green
	puts "Schreibe " + "EXIT".red + " zum Abbrechen"
	print "-> "
	$hostname = gets.chop
	if $hostname == "EXIT"
		home
	end
	begin
		puts $hostname
		
		s = TCPSocket.open($hostname,$port)
		puts "Connected"
	rescue
		puts "Verbindung fehlgeschlagen!"
		puts "erneut versuchen? ja/nein"
		eingabe = gets.chop
		if eingabe == "ja"
			connect
		else
			home
		end
	end
	while line = s.gets
		$id = line.chop
	end
	s.close
	startmp($id)
end

def startsv
	$id = 1
	system("cls")
	design("Mehrspieler")
	puts
	puts "Soll in einem LAN gespielt werden?"
	puts "1 - ja"
	puts "2 - nein"
	lan = gets.to_i
	ip = Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]
	system("cls")
	design("Mehrspieler")
	puts
	puts "Lasse deinen Mehrspieler-Partner mit deinem Spiel verbinden."
	if lan == 1
	    puts "Hostname: #{Socket.gethostname.green}"
		puts "IP zum Verbinden: #{ip.green}"
	elsif lan == 2
		puts "IP zum Verbinden: #{ip.green}"
	else
		puts "Verfügbare Auswahl: 1-2"
		sleep(2)
		startsv
	end
	puts "STRG + C".red + " zum Abbrechen"
	puts "Warte auf Verbindung..."
	server = TCPServer.open($port)
	client = server.accept
	if lan == 1
		$hostname = client.remote_address.getnameinfo[0]
	elsif lan == 2
		$hostname = client.remote_address.ip_unpack[0].to_s.gsub(/%[1-9]/,"")
	end
	client.puts $id+1
	client.close
	server.close
	startmp($id)
end

def waitformsg
	begin
		sleep(0.5)
		s = TCPSocket.open($hostname,$port)
		while line = s.gets
			int = line
		end
	rescue
		sleep(0.5)
		int = waitformsg
	end
	begin
	s.close
	rescue 
		puts "#{$!}"
	end
	return int
end

def sendmsg(integer)
	server = TCPServer.open($port)
	client = server.accept
	client.puts integer
	client.close
	server.close
end

def setzen(arr,pos,name)
	arr[pos-1] = name
	return arr
end

def check(arr,name)
	#waagerecht
	if arr[0] == name && arr[1] == name && arr[2] == name then return name elsif
	   arr[3] == name && arr[4] == name && arr[5] == name then return name elsif
	   arr[6] == name && arr[7] == name && arr[8] == name then return name elsif

	#senkrecht
	   arr[0] == name && arr[3] == name && arr[6] == name then return name elsif
	   arr[1] == name && arr[4] == name && arr[7] == name then return name elsif
	   arr[2] == name && arr[5] == name && arr[8] == name then return name elsif

	#diagonal
	   arr[0] == name && arr[4] == name && arr[8] == name then return name elsif
	   arr[2] == name && arr[4] == name && arr[6] == name then return name else
	   return "" end
end

def addtable(array,del = false)
	maxTab = 15
	kd = (array[1].to_f/array[2].to_f).round(2)
	if kd.infinite? then kd = array[1].to_f.round(2) end
	if del
		$counter += 1
		puts $counter.to_s + " "*(maxTab-$counter.to_s.length) + " | " + array[0] + " "*(maxTab-array[0].length) + " | " + array[1] + " "*(maxTab-array[1].length) + " | " + array[2].chop + " "*(maxTab-array[2].length) + " | " + kd.to_s
	else
		puts array[0] + " "*(maxTab-array[0].length) + " | " + array[1] + " "*(maxTab-array[1].length) + " | " + array[2].chop + " "*(maxTab-array[2].length) + " | " + kd.to_s
	end
end

def bestmenu
	system("cls")
	design("Bestenliste - Menue")
	puts
	puts "1 - Bestenliste anzeigen"
	puts "2 - Bestenlisten-eintrag loeschen"
	puts
	puts "0 - Zurueck"
	print "Eingabe: "
	eingabe = gets.to_i
	if eingabe == 0
		home
	elsif eingabe == 1
		showbest
	elsif eingabe == 2
		modifybest
	else
		puts "Verfügbare Eingabe 0-2"
		sleep(1)
		bestmenu
	end
end

def modifybest
	system("cls")
	$counter = 0
	@sorted = Array.new
	y = 0
	x = 0
	design("Bestenliste")
	puts
	puts "ID              | Name            | Gewonnen        | Verloren"
	puts "-"*((20*4)-1)
	highscores = File.new("highscore.txt","r")
	list = highscores.readlines
	highscores.close
	files = list.flatten
	files.each do |stat|
    	@sorted = @sorted + [stat.to_s.split(",")]
		addtable(@sorted[y], true)
		y += 1
	end
	puts
	puts "Gebe die ID eines Benutzers ein"
	puts "Zurueck mit " + "EXIT".red
	eingabe = gets.chop
	if eingabe == "EXIT"
		bestmenu
	elsif eingabe =~ /[0-9]/
		list.delete_at(eingabe.to_i-1)
		savefile(list)
	else
		modifybest
	end
end

def savefile(array)
	file = File.new("highscore.txt","w")
	file.puts array
	file.close
	modifybest
end

def showbest(dest = 0)
	system("cls")
	@sorted = Array.new
	y = 0
	x = 0
	design("Bestenliste")
	puts
	puts "Name            | Gewonnen        | Verloren        | Gewinnrate"
	puts "-"*((20*4)-1)
	highscores = File.new("highscore.txt","r")
	list = highscores.readlines
	highscores.close
	files = list.flatten
	files.each do |stat|
    	@sorted = @sorted + [stat.to_s.split(",")]
		addtable(@sorted[y])
		y += 1
	end
	puts
	puts "Zurueck mit beliebiger Taste"
	gets
	bestmenu
end

def names(player)
	system("cls")
	design("Spielernamen")
	puts
	print "Spieler 1: "
	name1 = gets
	if player == 2
		print "Spieler 2: "
		name2 = gets
		return name1,name2
	else
		return name1
	end
end

def menu1
	system("cls")
	name = ""
	design("Gegnerwahl")
	puts
	puts "1 - Spieler vs Spieler"
	puts "2 - Spieler vs Computer"
	puts ""
	puts "0 - Zurueck"
	print "Eingabe: "
	eingabe = gets.chop

	if eingabe == "1"
		startgame
	elsif eingabe == "2"
		startgame(true)
	elsif eingabe == "0"
		home
	else
		puts "Verfügbare Eingabe: 0-2"
		sleep(1)
		menu1
	end
end

def cputurn(arr,eingabe,maxturn)
	done = false
	if maxturn <= 4
	until done
		pos = rand(1..9)
		system("cls")
		if @array[pos-1] == $ply1sym
			done = false
		else
			if @array[pos-1] == $ply2sym
			else
				if pos == eingabe.to_i
				else
					setzen(@array,pos,$ply2sym)
					done = true
				end
			end
		end
	end
	return arr
	end
end

def writebest(name,win,loss)
  	a = File.new("highscore.txt", "r")
  	list = a.readlines
  	a.close
  	x = list.index{|e| e =~ /#{Regexp.quote(name)}.*/ }
  	unless x.nil?
  		new = list[x].split(",")
  		list = list + [new[0].to_s + "," + (new[1].to_i+win).to_s + "," + (new[2].to_i+loss).to_s]
  		list.delete_at(x)
  	else
 		list = list + [name.to_s + "," + win.to_s + "," + loss.to_s]
  	end
  	b = File.new("highscore.txt", "w")
  	b.puts list
  	b.close
end

def symbol(players)
	system("cls")
	design("Symbolauswahl")
	puts
	if players == 1
		puts "Was für ein Symbol möchtest du benutzen?"
		$ply1sym = gets.chop
	elsif players == 2
		print "Spieler 1: "
		$ply1sym = gets.chop
		print "Spieler 2: "
		$ply2sym = gets.chop
	end
end

def startmp(id)
	begin
		File.new("highscore.txt", "r")
	rescue
		File.new("highscore.txt", "w")
	end
	File.new("highscore.txt","r")
	@array = ["1","2","3","4","5","6","7","8","9"]
	$wins = ""
	x = 0
	ueber = false
	$id = $id.to_i
	system("cls")
	design("Mehrspieler")
	puts "Wie soll dein Name lauten?"
	username = gets.chop
	if $id == 1
		turn = $ply1sym
		opp = $ply2sym
		maxturn = 5
	else
		turn = $ply2sym
		opp = $ply1sym
		maxturn = 4
	end
	array = @array
	while $wins.chop == ""
		system("cls")
		$wins = check(@array,turn)
		$wins = check(@array,opp)
		if $wins == ""
			if x == maxturn
				puts "Unentschieden!"
				puts "Noch eine Runde spielen? ja/nein"
				eingabe = gets.chop
				if eingabe == "ja"
					mpmenu
					home
				else
					system("cls")
					home
				end
			end
		else
			design("Mehrspieler")
			if $wins == turn
				writebest(username,1,0)
				puts
				puts "Du hat das Spiel gewonnen!"
			else
				writebest(username,0,1)
				puts
				puts "Dein Gegner hat das Spiel gewonnen!"
			end
			puts "Noch eine Runde spielen? ja/nein"
			eingabe = gets.chop
			if eingabe == "ja"
				mpmenu
			else
				home
			end
		end
		if $id == 1
			ausgabe(@array)
			puts "Du bist am Zug!"
			puts "Welches Feld soll gesetzt werden?"
			print "Eingabe: "
			eingabe = gets.chop
			if eingabe.to_s =~ /[1-9]/
				if @array[(eingabe.to_i)-1] == $ply1sym or @array[(eingabe.to_i)-1] == $ply2sym
					puts "Du kannst kein Feld überschreiben!"
					ueber = true
					sleep(1)
				else
					x += 1
					@array = setzen(array,eingabe.to_i,turn)
					ueber = false
					sendmsg(eingabe.to_i)
					$id = 2
				end
			else
				puts "Verfuegbare Eingabe: 1-9"
				ueber = true
				sleep(1)
			end
		else
			$wins = check(@array,opp)
			$wins = check(@array,turn)
			if $wins == ""
				ausgabe(@array)
				puts "Dein Gegner ist am Zug!"
				@array = setzen(@array,waitformsg.to_i,opp)
				system("cls")
				ausgabe(@array)
				$id = 1
			else
				design("Mehrspieler")
				if $wins == turn
					writebest(username,1,0)
					puts
					puts "Du hast das Spiel gewonnen!"
				else
					writebest(username,0,1)
					puts
					puts "Dein Gegner hat das Spiel gewonnen!"
				end
				puts "Noch eine Runde spielen? ja/nein"
				eingabe = gets.chop
				if eingabe == "ja"
					mpmenu
				else
					home
				end
			end
		end
	end
end

def startgame(cpu = false)
	begin
		File.new("highscore.txt", "r")
	rescue
		File.new("highscore.txt", "w")
	end
	File.new("highscore.txt","r")
	@array = ["1","2","3","4","5","6","7","8","9"]
	$wins = ""
	if !cpu
		maxrounds = 9
	else
		maxrounds = 5
	end
	x = 0
	ueber = false
	wrong = false
	array = @array
	if cpu
		name1 = names(1).chop
		name2 = "CPU"
		maxturn = 5
		turn2 = name1
		symbol(1)
		turn = $ply1sym
	else
		nam = names(2)
		name1 = nam[0].chop
		name2 = nam[1].chop
		maxturn = 9
		turn2 = name2
		symbol(2)
		turn = $ply2sym
	end
	while $wins.chop == ""
		system("cls")
		ausgabe(array)
		if ueber == false
			if !cpu
				if turn == $ply1sym then turn = $ply2sym else turn = $ply1sym end
				if turn2 == name1 then turn2 = name2 else turn2 = name1 end
			end
		end
		if $wins == ""
			if x == maxturn
				puts "Unentschieden!"
				puts "Noch eine Runde spielen? ja/nein"
				eingabe = gets.chop
				if eingabe == "ja"
					menu1
				else
					system("cls")
					home
				end
			end
		else
			if turn2 == name1 then turn2 = name2 else turn2 = name1 end
			if turn2 == name1
				writebest(name1,1,0)
				writebest(name2,0,1)
			else
				writebest(name1,0,1)
				writebest(name2,1,0)
			end
			if cpu then if $wins == "O" then turn2 = name2 else turn2 = name1 end end
			puts "#{turn2} hat das Spiel gewonnen!"
			puts "Noch eine Runde spielen? ja/nein"
			eingabe = gets.chop
			if eingabe == "ja"
				menu1
			else
				home
			end
		end
		puts "#{turn2} ist am Zug."
		puts "Welches Feld soll gesetzt werden?"
		print "Eingabe: "
		eingabe = gets.chop
		if eingabe.to_s =~ /[1-9]/
			if @array[(eingabe.to_i)-1] == $ply1sym or @array[(eingabe.to_i)-1] == $ply2sym
				puts "Du kannst kein Feld überschreiben!"
				wrong = true
				ueber = true
				sleep(1)
			else
				x += 1
				@array = setzen(array,eingabe.to_i,turn)
				$wins = check(@array,turn)
				wrong = false
				ueber = false
			end
		else
			puts "Verfuegbare Eingabe: 1-9"
			ueber = true
			wrong = true
			sleep(1)
		end
		if $wins == ""
			if cpu
				if wrong == false
					if turn2 == name1 then turn2 = name2 else turn2 = name1 end
					cputurn(@array,eingabe,x)
					$wins = check(@array,"O")
					wrong = true
				end
			end
		end
	end
end

def home
	$ply1sym = "X"
	$ply2sym = "O"
	begin
		File.new("highscore.txt", "r")
	rescue
		File.new("highscore.txt", "w")
	end
	system("cls")
	design("TicTacToe")
	puts
	puts "1 - Spiel starten"
	puts "2 - Mehrspieler"
	puts "3 - Bestenliste"
	puts
	puts "0 - Spiel beenden"
	print "Eingabe: "
	eingabe = gets.chop
	if eingabe == "1"
		menu1
	elsif eingabe == "2"
		mpmenu
	elsif eingabe == "3"
		bestmenu
	elsif eingabe == "0"
		system("cls")
		exit
	else
		puts "Verfügbare Eingabe: 0-3"
		sleep(1)
		home
	end
end

home