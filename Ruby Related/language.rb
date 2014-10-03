def ext_conf(i)
	language = i.gsub("\n","")
	if language == "de"
	@string_Start_Question1 = "Wie viele Zeichen soll das Passwort beinhalten?"

	@string_symbol_Question1 = "Welche Symbole sollen benutzt werden?"
	@string_symbol_Hint1 = "Druecke ENTER nach jedem Eintrag"
	@string_symbol_special = "Sonderzeichen"
	@string_symbol_Hint2 = "Fortfahren mit ENTER"

	@string_end_finished = "Generiertes Passwort:"
	
	
	
	elsif language == "en"
	@string_Start_Question1 = "How long should the password be?"

	@string_symbol_Question1 = "What symbols should be used?"
	@string_symbol_Hint1 = "Press ENTER after every entry"
	@string_symbol_special = "Special charakters"
	@string_symbol_Hint2 = "Continue with ENTER"

	@string_end_finished = "Generated password:"
	end
end