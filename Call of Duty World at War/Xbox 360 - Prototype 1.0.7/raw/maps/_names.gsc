main()
{
}

setup_variables()
{
	american_names 	= 73;
	british_names 	= 60;
	arab_names 	= 29;
	russian_names 	= 27;
	
	if ( !(isdefined (game["americannames"]) ) )
		game["americannames"] = randomint (american_names);
	if ( !(isdefined (game["britishnames"]) ) )
		game["britishnames"] = randomint (british_names);
	if ( !(isdefined (game["arabnames"]) ) )
		game["arabnames"] = randomint (arab_names);
	if ( !(isdefined (game["russian_firstnames_male"]) ) )
		game["russiannames"] = randomint (russian_names);
}

get_name(override)
{
	if (!isdefined (override))
	{
		if (level.script == "credits")
			return;
	}
	
	if (isdefined (self.script_friendname))
	{
		if (self.script_friendname == "none")
			return;
		self.name = self.script_friendname;
		self notify ("set name and rank");
		return;
	}		
	
	setup_variables();

	if (self.team == "axis")
	{
		game["arabnames"]++;
		get_arab_name();
	}
	else if (self.voice == "british")
	{
		game["britishnames"]++;
		get_british_name();
	}
	else if (self.voice == "russian")
	{
		game["russiannames"]++;
		get_russian_name();
	}
	else
	{
		game["americannames"]++;
		get_american_name();
	}

	self notify ("set name and rank");
}

get_american_name()
{
	switch (game["americannames"])
	{
		case  1: self.name = "Eady";break;       
		case  2: self.name = "Ganus";break;      
		case  3: self.name = "Kuhn";break;       
		case  4: self.name = "Allen";break;      
		case  5: self.name = "Haggerty";break;   
		case  6: self.name = "Barb";break;       
		case  7: self.name = "Hatch";break;      
		case  8: self.name = "Cade";break;       
		case  9: self.name = "Bowling";break;    
		case 10: self.name = "Becerra";break;    
		case 11: self.name = "Cherubini";break;  
		case 12: self.name = "Emslie";break;     
		case 13: self.name = "Fukuda";break;     
		case 14: self.name = "Gilman";break;     
		case 15: self.name = "Lowis";break;      
		case 16: self.name = "Glenn";break;      
		case 17: self.name = "Gompert";break;    
		case 18: self.name = "Rule";break;       
		case 19: self.name = "Griffen";break;    
		case 20: self.name = "Grigsby";break;    
		case 21: self.name = "Abrahamsson";break;
		case 22: self.name = "Bell";break;       
		case 23: self.name = "Cayetano";break;   
		case 24: self.name = "Alderman";break;   
		case 25: self.name = "McCoy";break;      
		case 26: self.name = "Harmer";break;     
		case 27: self.name = "Rosemeier";break;  
		case 28: self.name = "Rich";break;       
		case 29: self.name = "Gaines";break;     
		case 30: self.name = "Chen";break;       
		case 31: self.name = "West";break;       
		case 32: self.name = "Volker";break;     
		case 33: self.name = "Heath";break;      
		case 34: self.name = "Johnsen";break;    
		case 35: self.name = "Kriegler";break;   
		case 36: self.name = "Sharrigan";break;  
		case 37: self.name = "Lastimosa";break;  
		case 38: self.name = "Ojeda";break;      
		case 39: self.name = "Gigliotti";break;  
		case 40: self.name = "Lopez";break;      
		case 41: self.name = "Baker";break;     
		case 42: self.name = "Lyman";break;      
		case 43: self.name = "McCandlish";break; 
		case 44: self.name = "Alavi";break;      
		case 45: self.name = "Campbell";break;    
		case 46: self.name = "McLeod";break;     
		case 47: self.name = "Smith";break;      
		case 48: self.name = "Miller";break;     
		case 49: self.name = "Yang";break;       
		case 50: self.name = "Niebel";break;     
		case 51: self.name = "Oh";break;         
		case 52: self.name = "Kar";break;        
		case 53: self.name = "Onur";break;       
		case 54: self.name = "Pelayo";break;     
		case 55: self.name = "Porter";break;     
		case 56: self.name = "Son";break;        
		case 57: self.name = "Keating";break;    
		case 58: self.name = "Rieke";break;      
		case 59: self.name = "Hammon";break;     
		case 60: self.name = "Lister";break;     
		case 61: self.name = "Messerly";break;  
		case 62: self.name = "Roycewicz";break;  
		case 63: self.name = "Rubin";break;      
		case 64: self.name = "Glasco";break;     
		case 65: self.name = "Shiring";break;    
		case 66: self.name = "Zampella";break;
		case 67: self.name = "Sue";break;        
		case 68: self.name = "Harris";break;     
		case 69: self.name = "Turner";break;     
		case 70: self.name = "Vinson";break;     
		case 71: self.name = "Grenier";break;    
		case 72: self.name = "Wolf";break;
		case 73: self.name = "Hawkins";    
		game["americannames"] = 0;
	}

	rank = randomint (100);
	if (rank > 50)
		self.name = "Pvt. " + self.name;
	else
	if (rank > 20)
		self.name = "Cpl. " + self.name;
	else
		self.name = "Sgt. " + self.name;
}

get_british_name()
{
	switch (game["britishnames"])
	{
		case  1: self.name = "Abbot";break;
		case  2: self.name = "Collins";break;
		case  3: self.name = "Macdonald";break;
		case  4: self.name = "Heath";break;
		case  5: self.name = "Compton";break;
		case  6: self.name = "Boyd";break;
		case  7: self.name = "Moore";break;
		case  8: self.name = "Pearce";break;
		case  9: self.name = "Henderson";break;
		case 10: self.name = "Maxwell";break;
		case 11: self.name = "Field";break;
		case 12: self.name = "Reed";break;
		case 13: self.name = "Lipton";break;
		case 14: self.name = "Stuart";break;
		case 15: self.name = "Dowd";break;
		case 16: self.name = "Roth";break;
		case 17: self.name = "Carlyle";break;
		case 18: self.name = "Smith";break;
		case 19: self.name = "Welsh";break;
		case 20: self.name = "McQuarrie";break;
		case 21: self.name = "Ross";break;
		case 22: self.name = "Wallace";break;
		case 23: self.name = "Statham";break;
		case 24: self.name = "Griffin";break;
		case 25: self.name = "Boyle";break;
		case 26: self.name = "Fletcher";break;
		case 27: self.name = "Carver";break;
		case 28: self.name = "Bartlett";break;
		case 29: self.name = "Plumber";break;
		case 30: self.name = "Grant";break;
		case 31: self.name = "Wallcroft";break; 
		case 32: self.name = "Pritchard";break;
		case 33: self.name = "Veale";break;
		case 34: self.name = "Stevenson";break;
		case 35: self.name = "Greaves";break;
		case 36: self.name = "Flynn";break;
		case 37: self.name = "Thompson";break;
		case 38: self.name = "Mitchell";break;
		case 39: self.name = "Harris";break;
		case 40: self.name = "Cook";break;
		case 41: self.name = "Field";break;
		case 42: self.name = "Bremner";break;
		case 43: self.name = "Miller";break;
		case 44: self.name = "Harrison";break;
		case 45: self.name = "Adams";break;
		case 46: self.name = "Connolly";break;
		case 47: self.name = "Hopkins";break;
		case 48: self.name = "Kent";break;
		case 49: self.name = "Boon";break;
		case 50: self.name = "Ritchie";break;
		case 51: self.name = "Hoyt";break;
		case 52: self.name = "Murphy";break;
		case 53: self.name = "Lewis";break;
		case 54: self.name = "Murray";break;
		case 55: self.name = "Wells";break;
		case 56: self.name = "Rankin";break;
		case 57: self.name = "Clarke";break;
		case 58: self.name = "Sullivan";break;
		case 59: self.name = "Cheek";break;
		case 60: self.name = "Fleming";
		game["britishnames"] = 0;break;
	}

	rank = randomint (100);
	if (rank > 50)
		self.name = "Pvt. " + self.name;
	else
	if (rank > 20)
		self.name = "Cpl. " + self.name;
	else
		self.name = "Sgt. " + self.name;
}


get_russian_name()
{
	switch (game["russiannames"])
	{
		case  1: self.name = "Sasha";break;
		case  2: self.name = "Aleksei";break;
		case  3: self.name = "Boris";break;
		case  4: self.name = "Dima";break;
		case  5: self.name = "Oleg";break;
		case  6: self.name = "Pyotr";break;
		case  7: self.name = "Petya";break;
		case  8: self.name = "Alyosha";break;
		case  9: self.name = "Sergei";break;
		case 10: self.name = "Viktor";break;
		case 11: self.name = "Misha";break;
		case 12: self.name = "Borya";break;
		case 13: self.name = "Anatoly";break;
		case 14: self.name = "Kolya";break;
		case 15: self.name = "Nikolai";break;
		case 16: self.name = "Vladimir";break;
		case 17: self.name = "Pavel";break;
		case 18: self.name = "Volodya";break;
		case 19: self.name = "Yuri";break;
		case 20: self.name = "Dmitri";break;
		case 21: self.name = "Vanya";break;
		case 22: self.name = "Mikhail";break;
		case 23: self.name = "Ivan";break;
		case 24: self.name = "Kostya";break;
		case 25: self.name = "Konstantin";break;
		case 26: self.name = "Aleksandr";break;
		case 27: self.name = "Yakov"; 
		game["russian_names"] = 0;break;
	}

	rank = randomint (100);
	if (rank > 50)
		self.name = "Pvt. " + self.name;
	else if (rank > 20)
		self.name = "Cpl. " + self.name;
	else
		self.name = "Sgt. " + self.name;
}

get_arab_name()
{
	switch (game["arabnames"])
	{
		case  1: self.ainame = "Abdulaziz";break;
		case  2: self.ainame = "Abdullah";break; 
		case  3: self.ainame = "Ali";break;      
		case  4: self.ainame = "Amin";break;     
		case  5: self.ainame = "Bassam";break;   
		case  6: self.ainame = "Fahd";break;     
		case  7: self.ainame = "Faris";break;    
		case  8: self.ainame = "Fouad";break;    
		case  9: self.ainame = "Habib";break;    
		case 10: self.ainame = "Hakem";break;    
		case 11: self.ainame = "Hassan";break;   
		case 12: self.ainame = "Ibrahim";break;  
		case 13: self.ainame = "Imad";break;     
		case 14: self.ainame = "Jabbar";break;   
		case 15: self.ainame = "Kareem";break;   
		case 16: self.ainame = "Khalid";break;   
		case 17: self.ainame = "Malik";break;    
		case 18: self.ainame = "Muhammad";break; 
		case 19: self.ainame = "Nasir";break;    
		case 20: self.ainame = "Omar";break;     
		case 21: self.ainame = "Rafiq";break;    
		case 22: self.ainame = "Rami";break;     
		case 23: self.ainame = "Said";break;     
		case 24: self.ainame = "Salim";break;    
		case 25: self.ainame = "Samir";break;    
		case 26: self.ainame = "Talib";break;    
		case 27: self.ainame = "Tariq";break;    
		case 28: self.ainame = "Youssef";break;  
		case 29: self.ainame = "Ziad";
		game["arabnames"] = 0;break;
	}

	rank = randomint (100);
	if (rank > 40)
		self.ainame = "Pvt. " + self.ainame;
	else if (rank > 20)
		self.ainame = "Cpl. " + self.ainame;
	else
		self.ainame = "Sgt. " + self.ainame;
}








