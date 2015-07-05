def design(str)
	hash = "#"
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
	puts hash + " "*spaces + str + " "*spaces2 + hash
	puts hash + " "*(max-2) + hash
	puts hash + " "*(max-2) + hash
	puts hash*max
end

system("cls")
@dontbreak = false
@symbols = Array.new

design("PwGen")
puts "Language? Available:"
puts "- de"
puts "- en"
@lang = gets().to_s
system("cls")



begin
	require_relative 'language.rb'
	ext_conf(@lang)
rescue
	puts "Config could not be loaded! Using default Strings!"
	sleep(1)
	system("cls")
end


design("PwGen")
puts @string_Start_Question1
@length = gets().to_i

system("cls")
design("PwGen")
puts @string_symbol_Question1
puts @string_symbol_Hint1
puts "1: A-Z"
puts "2: a-z"
puts "3: 0-9"
puts "4: #{@string_symbol_special}"
puts @string_symbol_Hint2
until @dontbreak
	randomnmbr = 0
	auswahl = []
	@zeichen = gets().to_i
	if @zeichen == 1
		@symbols.push("A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z")
		@randomnmbr = @randomnmbr.to_i + 26
	elsif @zeichen == 2
		@symbols.push("a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z")
		@randomnmbr = @randomnmbr.to_i + 26
	elsif @zeichen == 3
		@symbols.push("0","1","2","3","4","5","6","7","8","9")
		@randomnmbr = @randomnmbr.to_i + 10
	elsif @zeichen == 4
		@symbols.push("!","$","%","&","/","(",")","=","?","#","+")
		@randomnmbr = @randomnmbr.to_i + 11
	else
	 break if @zeichen == 0
	end
end
system("cls")
design("PwGen")
puts 
while @length > 0
	@length = @length.to_i - 1
	pw = pw.to_s + @symbols[rand(@randomnmbr)].to_s
end
puts @string_end_finished
puts pw
gets