system("cls")
@dontbreak = false
@auswahl = Array.new

interface =     "#############################" \
			+ "\n#                           #" \
			+ "\n#       Passwort Gen        #" \
			+ "\n#                           #" \
			+ "\n#############################"

puts interface
puts "Wie lang soll das Passwort sein ?"
@length = gets().to_i

system("cls")
puts interface
puts "Welche Symbole sollen benutzt werden?"
puts "1: A-Z"
puts "2: a-z"
puts "3: 0-9"
puts "4: Sonderzeichen"
puts "Fortfahren mit ENTER"
until @dontbreak
	randomnmbr = 0
	auswahl = []
	@zeichen = gets().to_i
	if @zeichen == 1
		@auswahl.push("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
		@randomnmbr = @randomnmbr.to_i + 26
	elsif @zeichen == 2
		@auswahl.push("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
		@randomnmbr = @randomnmbr.to_i + 26
	elsif @zeichen == 3
		@auswahl.push("0","1","2","3","4","5","6","7","8","9")
		@randomnmbr = @randomnmbr.to_i + 10
	elsif @zeichen == 4
		@auswahl.push("!","§","$","%","&","/","(",")","=","?","#","+")
		@randomnmbr = @randomnmbr.to_i + 10
	else
	 break if @zeichen == 0
	end
end

while @length > 0
	@length = @length.to_i - 1
	pw = pw.to_s + @auswahl[rand(@randomnmbr)].to_s
end

puts pw