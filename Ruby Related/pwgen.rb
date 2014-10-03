system("cls")
@dontbreak = false
@symbols = Array.new

interface =     "#############################" \
			+ "\n#                           #" \
			+ "\n#       Passwort Gen        #" \
			+ "\n#                           #" \
			+ "\n#############################"

puts interface
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


puts interface
puts @string_Start_Question1
@length = gets().to_i

system("cls")
puts interface
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
puts interface
puts 
while @length > 0
	@length = @length.to_i - 1
	pw = pw.to_s + @symbols[rand(@randomnmbr)].to_s
end
puts @string_end_finished
puts pw