main()
{
}

setup_variables()
{
	american_names 	= 60;
	british_names 	= 60;
	german_names 	= 51;
	russian_firstnames_male 	= 27;
	russian_firstnames_female 	= 23;
	russian_lastnames_male 		= 138;
	russian_lastnames_female 	= 31;
	
	if ( !(isdefined (game["americannames"]) ) )
		game["americannames"] = randomint (american_names);
	if ( !(isdefined (game["britishnames"]) ) )
		game["britishnames"] = randomint (british_names);
	if ( !(isdefined (game["germannames"]) ) )
		game["germannames"] = randomint (german_names);
	if ( !(isdefined (game["russian_firstnames_male"]) ) )
		game["russian_firstnames_male"] = randomint (russian_firstnames_male);
	if ( !(isdefined (game["russian_firstnames_female"]) ) )
		game["russian_firstnames_female"] = randomint (russian_firstnames_female);
	if ( !(isdefined (game["russian_lastnames_male"]) ) )
		game["russian_lastnames_male"] = randomint (russian_lastnames_male);
	if ( !(isdefined (game["russian_lastnames_female"]) ) )
		game["russian_lastnames_female"] = randomint (russian_lastnames_female);
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
		game["germannames"]++;
		get_german_name();
	}
	else if (self.voice == "british")
	{
		game["britishnames"]++;
		get_british_name();
	}
	else if (self.voice == "russian")
	{
		if (self.model == "xmodel/character_russian_diana_medic")
		{
			game["russian_firstnames_female"]++;
			game["russian_lastnames_female"]++;
		}
		else
		{
			game["russian_firstnames_male"]++;
			game["russian_lastnames_male"]++;
		}
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
		case  1: self.name = "Walton";break;
		case  2: self.name = "Glasco";break;
		case  3: self.name = "West";break;
		case  4: self.name = "Bennett";break;
		case  5: self.name = "Messerly";break;
		case  6: self.name = "Pearson";break;
		case  7: self.name = "Doornink";break;
		case  8: self.name = "Smith";break;
		case  9: self.name = "Gigliotti";break;
		case 10: self.name = "Rieke";break;
		case 11: self.name = "Rice";break;
		case 12: self.name = "Barb";break;
		case 13: self.name = "Boswell";break;
		case 14: self.name = "Michael";break;
		case 15: self.name = "Collier";break;
		case 16: self.name = "McCandlish";break;
		case 17: self.name = "Dominguez";break;
		case 18: self.name = "Peas";break;
		case 19: self.name = "McManus";break;
		case 20: self.name = "Gaines";break;
		case 21: self.name = "Heath";break;
		case 22: self.name = "Porter";break;
		case 23: self.name = "Vaughn";break;
		case 24: self.name = "Grenier";break;
		case 25: self.name = "Alderman";break;
		case 26: self.name = "McKnight";break;
		case 27: self.name = "Lopez";break;
		case 28: self.name = "Lamia";break;
		case 29: self.name = "Pacelli";break;
		case 30: self.name = "Matisse";break;
		case 31: self.name = "Griffen";break;
		case 32: self.name = "Fisher";break;
		case 33: self.name = "Ganus";break;
		case 34: self.name = "Swanson";break;
		case 35: self.name = "Miller";break;
		case 36: self.name = "Kuhn";break;
		case 37: self.name = "Johnsen";break;
		case 38: self.name = "Spears";break;
		case 39: self.name = "Emslie";break;
		case 40: self.name = "Zampella";break;
		case 41: self.name = "Allen";break;
		case 42: self.name = "Houle";break;
		case 43: self.name = "Lyman";break;
		case 44: self.name = "Hammon";break;
		case 45: self.name = "Glenn";break;
		case 46: self.name = "Hagerty";break;
		case 47: self.name = "Kirschenbaum";break;
		case 48: self.name = "Alavi";break;
		case 49: self.name = "Grossman";break;
		case 50: self.name = "Barb";break;
		case 51: self.name = "McLeod";break;
		case 52: self.name = "Vantine";break;
		case 53: self.name = "Weaver";break;
		case 54: self.name = "Goldberg";break;
		case 55: self.name = "Perlman";break;
		case 56: self.name = "Shiring";break;
		case 57: self.name = "Mantarro";break;
		case 58: self.name = "Escher";break;
		case 59: self.name = "Fincher";break;
		case 60: self.name = "Hassell";game["americannames"] = 0;break;
	}

	if (self.model == "xmodel/character_us_ranger_cpl_a")
			self.name = "Cpl. " + self.name;
	else if (self.model == "xmodel/character_us_ranger_lt_coffey")
		self.name = "Lt. " + self.name;
	else if (self.model == "xmodel/character_us_ranger_sgt_randall")
		self.name = "Sgt. " + self.name;
	else
		self.name = "Pvt. " + self.name;

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

	if (self.model == "xmodel/character_british_normandy_a")
	{
		self.name = "Pvt. " + self.name;
	}
	else if (self.model == "xmodel/character_british_normandy_b")
	{
		self.name = "Cpl. " + self.name;
	}
	else
	{
		rank = randomint (100);
		if (rank > 50)
			self.name = "Pvt. " + self.name;
		else
		if (rank > 20)
			self.name = "Cpl. " + self.name;
		else
			self.name = "Sgt. " + self.name;
	}
}

get_russian_name()
{
	if (self.model != "xmodel/character_russian_diana_medic")
	{
		switch (game["russian_firstnames_male"])
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
			case 27: self.name = "Yakov"; game["russian_firstnames_male"] = 0;break;
		}

		self.name += " ";

		switch (game["russian_lastnames_male"])
		{
			case   1: self.name += "Ivanov";break;
			case   2: self.name += "Smirnov";break;
			case   3: self.name += "Vasilev";break;
			case   4: self.name += "Petrov";break;
			case   5: self.name += "Kyznetsov";break;
			case   6: self.name += "Fedorov";break;
			case   7: self.name += "Mikhailov";break;
			case   8: self.name += "Sokolov";break;
			case   9: self.name += "Filatov";break;
			case  10: self.name += "Leonov";break;
			case  11: self.name += "Danilov";break;
			case  12: self.name += "Zaitsev";break;
			case  13: self.name += "Ilin";break;
			case  14: self.name += "Semenov";break;
			case  15: self.name += "Lebedev";break;
			case  16: self.name += "Golubev";break;
			case  17: self.name += "Lukin";break;
			case  18: self.name += "Zhuravlev";break;
			case  19: self.name += "Gerasimov";break;
			case  20: self.name += "Petrenko";break;
			case  21: self.name += "Nikitin";break;
			case  22: self.name += "Andropov";break;
			case  23: self.name += "Chernenko";break;
			case  24: self.name += "Brezhnev";break;
			case  25: self.name += "Kalinin";break;
			case  26: self.name += "Shvernik";break;
			case  27: self.name += "Voroshilov";break;
			case  28: self.name += "Mikoyan";break;
			case  29: self.name += "Podgorniy";break;
			case  30: self.name += "Kuznetsov";break;
			case  31: self.name += "Grombyo";break;
			case  32: self.name += "Rykov";break;
			case  33: self.name += "Malenkov";break;
			case  34: self.name += "Bulganin";break;
			case  35: self.name += "Kosygin";break;
			case  36: self.name += "Tikhonov";break;
			case  37: self.name += "Ryzhkov";break;
			case  38: self.name += "Vyshinskiy";break;
			case  39: self.name += "Shevardnadze";break;
			case  40: self.name += "Shepilov";break;
			case  41: self.name += "Bessmertnykh";break;
			case  42: self.name += "Pankin";break;
			case  43: self.name += "Litvinov";break;
			case  44: self.name += "Merkulov";break;
			case  45: self.name += "Ogoltsov";break;
			case  46: self.name += "Fedorchuk";break;
			case  47: self.name += "Bakatin";break;
			case  48: self.name += "Shebarshin";break;
			case  49: self.name += "Semichastniy";break;
			case  50: self.name += "Serov";break;
			case  51: self.name += "Ustinov";break;
			case  52: self.name += "Yazov";break;
			case  53: self.name += "Grechko";break;
			case  54: self.name += "Aleksandrov";break;
			case  55: self.name += "Shatalov";break;
			case  56: self.name += "Shonin";break;
			case  57: self.name += "Filipchenko";break;
			case  58: self.name += "Kubasov";break;
			case  59: self.name += "Gorbatko";break;
			case  60: self.name += "Volkov";break;
			case  61: self.name += "Yeliseyev";break;
			case  62: self.name += "Feoktistov";break;
			case  63: self.name += "Tereshkov";break;
			case  64: self.name += "Bykovsky";break;
			case  65: self.name += "Artyukhin";break;
			case  66: self.name += "Beregovy";break;
			case  67: self.name += "Berezovoy";break;
			case  68: self.name += "Demin";break;
			case  69: self.name += "Jahn";break;
			case  70: self.name += "Khrunov";break;
			case  71: self.name += "Kovalyonok";break;
			case  72: self.name += "Lazarev";break;
			case  73: self.name += "Leonov";break;
			case  74: self.name += "Popovich";break;
			case  75: self.name += "Romanenko";break;
			case  76: self.name += "Rozhdestvensky";break;
			case  77: self.name += "Rukavishnikov";break;
			case  78: self.name += "Ryumin";break;
			case  79: self.name += "Savinykh";break;
			case  80: self.name += "Sevastyanov";break;
			case  81: self.name += "Titov";break;
			case  82: self.name += "Yeliseyev";break;
			case  83: self.name += "Gagarin";break;
			case  84: self.name += "Kinski";break;
			case  85: self.name += "Todoroff";break;
			case  86: self.name += "Goernshtein";break;
			case  87: self.name += "Bondarachuk";break;
			case  88: self.name += "Banionis";break;
			case  89: self.name += "Solonitsyn";break;
			case  90: self.name += "Grinko";break;
			case  91: self.name += "Kerdimun";break;
			case  92: self.name += "Kizilov";break;
			case  93: self.name += "Malykh";break;
			case  94: self.name += "Oganesyan";break;
			case  95: self.name += "Ogorodnikov";break;
			case  96: self.name += "Sargsyan";break;
			case  97: self.name += "Semyonov";break;
			case  98: self.name += "Statsinski";break;
			case  99: self.name += "Sumenov";break;
			case  100: self.name += "Tejkh";break;
			case  101: self.name += "Tarasov";break;
			case  102: self.name += "Artemyev";break;
			case  103: self.name += "Ovchinnikov";break;
			case  104: self.name += "Yusov";break;
			case  105: self.name += "Kushneryov";break;
			case  106: self.name += "Tarkovsky";break;
			case  107: self.name += "Chugunov";break;
			case  108: self.name += "Murashko";break;
			case  109: self.name += "Nevsky";break;
			case  110: self.name += "Paramanov";break;
			case  111: self.name += "Shvedov";break;
			case  112: self.name += "Tarkovsky";break;
			case  113: self.name += "Glushenko";break;
			case  114: self.name += "Chernogolov";break;
			case  115: self.name += "Afanasyev";break;
			case  116: self.name += "Bondarenko";break;
			case  117: self.name += "Voronov";break;
			case  118: self.name += "Gridin";break;
			case  119: self.name += "Kiselev";break;
			case  120: self.name += "Sarayev";break;
			case  121: self.name += "Svirin";break;
			case  122: self.name += "Sabgaida";break;
			case  123: self.name += "Chernyshenko";break;
			case  124: self.name += "Dovzhenko";break;
			case  125: self.name += "Ivashenko";break;
			case  126: self.name += "Shapovalov";break;
			case  127: self.name += "Yakimenko";break;
			case  128: self.name += "Masijashvili";break;
			case  129: self.name += "Murzaev";break;
			case  130: self.name += "Turdyev";break;
			case  131: self.name += "Ramazanov";break;
			case  132: self.name += "Avagimov";break;
			case  133: self.name += "Demchenko";break;
			case  134: self.name += "Stepanoshvili";break;
			case  135: self.name += "Shkuratov";break;
			case  136: self.name += "Yefremov";break;
			case  137: self.name += "Ulyanov";break;
			case  138: self.name += "Semenov"; game["russian_lastnames_male"] = 0;break;
		}
	}
	else
	{
		switch (game["russian_firstnames_female"])
		{
			case  1: self.name = "Ekaterina";break;
			case  2: self.name = "Tania";break;
			case  3: self.name = "Tatyana";break;
			case  4: self.name = "Evgenia";break;
			case  5: self.name = "Zina";break;
			case  6: self.name = "Aleksandra";break;
			case  7: self.name = "Irina";break;
			case  8: self.name = "Natalia";break;
			case  9: self.name = "Toma";break;
			case 10: self.name = "Ludmila";break;
			case 11: self.name = "Sonya";break;
			case 12: self.name = "Olga";break;
			case 13: self.name = "Oksana";break;
			case 14: self.name = "Sashenka";break;
			case 15: self.name = "Lena";break;
			case 16: self.name = "Feodora";break;
			case 17: self.name = "Stasya";break;
			case 18: self.name = "Anya";break;
			case 19: self.name = "Anna";break;
			case 20: self.name = "Sofia";break;
			case 21: self.name = "Nadia";break;
			case 22: self.name = "Svetlana";break;
			case 23: self.name = "Katya"; game["russian_firstnames_female"] = 0;break;
		}
	
		self.name += " ";

		switch (game["russian_lastnames_female"])
		{
			case   1: self.name += "Ivanova";break;
			case   2: self.name += "Smirnova";break;
			case   3: self.name += "Petrova";break;
			case   4: self.name += "Kyznetsova";break;
			case   5: self.name += "Fedorova";break;
			case   6: self.name += "Mikhailova";break;
			case   7: self.name += "Sokolova";break;
			case   8: self.name += "Filatova";break;
			case   9: self.name += "Leonova";break;
			case  10: self.name += "Danilova";break;
			case  11: self.name += "Semenova";break;
			case  12: self.name += "Gerasimova";break;
			case  13: self.name += "Andropova";break;
			case  14: self.name += "Kalinina";break;
			case  15: self.name += "Voroshilova";break;
			case  16: self.name += "Kuznetsova";break;
			case  17: self.name += "Malenkova";break;
			case  18: self.name += "Bulganina";break;
			case  19: self.name += "Kosygina";break;
			case  20: self.name += "Tikhonova";break;
			case  21: self.name += "Ryzhkova";break;
			case  22: self.name += "Shepilova";break;
			case  23: self.name += "Litvinova";break;
			case  24: self.name += "Merkulova";break;
			case  25: self.name += "Ogoltsova";break;
			case  26: self.name += "Serova";break;
			case  27: self.name += "Aleksandrova";break;
			case  28: self.name += "Volkova";break;
			case  29: self.name += "Tereshkova";break;
			case  30: self.name += "Lazareva";break;
			case  31: self.name += "Ulyanova"; game["russian_lastnames_female"] = 0;break;
		}
	}

	if ( isDefined( self.hatmodel) && self.hatmodel == "xmodel/helmet_russian_trench_b_hat")
	{
		self.name = "Cpl. " + self.name;
	}
	else
	{
		rank = randomint (100);
		if (rank > 50)
			self.name = "Pvt. " + self.name;
		else if (rank > 20)
			self.name = "Cpl. " + self.name;
		else
			self.name = "Sgt. " + self.name;
	}
}

get_german_name()
{
	switch (game["germannames"])
	{
		case  1: self.ainame = "Schuhmann";break;
		case  2: self.ainame = "Brauer";break;
		case  3: self.ainame = "Schroeder";break;
		case  4: self.ainame = "Krieger";break;
		case  5: self.ainame = "Schwarz";break;
		case  6: self.ainame = "Pfeffer";break;
		case  7: self.ainame = "Kahn";break;
		case  8: self.ainame = "Schmidt";break;
		case  9: self.ainame = "Fischer";break;
		case 10: self.ainame = "Schneider";break;
		case 11: self.ainame = "Becker";break;
		case 12: self.ainame = "Schumann";break;
		case 13: self.ainame = "Koehler";break;
		case 14: self.ainame = "Beyer";break;
		case 15: self.ainame = "Adler";break;
		case 16: self.ainame = "Schultz";break;
		case 17: self.ainame = "Koenig";break;
		case 18: self.ainame = "Faerber";break;
		case 19: self.ainame = "Schlueter";break;
		case 20: self.ainame = "Reiniger";break;
		case 21: self.ainame = "Meier";break;
		case 22: self.ainame = "Neumann";break;
		case 23: self.ainame = "Kraemer";break;
		case 24: self.ainame = "Broemel";break;
		case 25: self.ainame = "Reiter";break;
		case 26: self.ainame = "Brandt";break;
		case 27: self.ainame = "Koch";break;
		case 28: self.ainame = "Baumann";break;
		case 29: self.ainame = "Steinhauer";break;
		case 30: self.ainame = "Kunze";break;
		case 31: self.ainame = "Fleischer";break;
		case 32: self.ainame = "Neuberger";break;
		case 33: self.ainame = "Hohmann";break;
		case 34: self.ainame = "Reimann";break;
		case 35: self.ainame = "Gross";break;
		case 36: self.ainame = "Jaeger";break;
		case 37: self.ainame = "Sauer";break;
		case 38: self.ainame = "Bader";break;
		case 39: self.ainame = "Wagner";break;
		case 40: self.ainame = "Weber";break;
		case 41: self.ainame = "Bauer";break;
		case 42: self.ainame = "Kaltenbach";break;
		case 43: self.ainame = "Reichmann";break;
		case 44: self.ainame = "Schreiber";break;
		case 45: self.ainame = "Hahn";break;
		case 46: self.ainame = "Schaefer";break;
		case 47: self.ainame = "Kaufmann";break;
		case 48: self.ainame = "Fiedler";break;
		case 49: self.ainame = "Kessler";break;
		case 50: self.ainame = "Schrader";break;
		case 51: self.ainame = "Bergmann";
	 	game["germannames"] = 0;break;
	}

	rank = randomint (100);
	if (rank > 40)
		self.ainame = "Pvt. " + self.ainame;
	else if (rank > 20)
		self.ainame = "Cpl. " + self.ainame;
	else
		self.ainame = "Sgt. " + self.ainame;
}








