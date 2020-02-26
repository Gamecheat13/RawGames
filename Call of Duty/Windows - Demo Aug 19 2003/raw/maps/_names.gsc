main()
{
}

get_name()
{
	if ((level.script == "stalingrad") || (level.script == "stalingrad_nolight"))
		return;
	
	if (isdefined (self.script_friendname))
	{
		self.name = self.script_friendname;
		return;
	}		
	
	american_names 	= 120;
	british_names 	= 138;
	russian_names 	= 138;
	
	if ( !(isdefined (game["americannames"]) ) )
		game["americannames"] = randomint (american_names);
	if ( !(isdefined (game["britishnames"]) ) )
		game["britishnames"] = randomint (british_names);
	if ( !(isdefined (game["russiannames"]) ) )
		game["russiannames"] = randomint (russian_names);


	if (level.campaign == "british")
	{
		game["britishnames"]++;
		get_british_name();
	}
	else
	if (level.campaign == "russian")
	{
		game["russiannames"]++;
		get_russian_name();
	}
	else
	{
		game["americannames"]++;
		get_american_name();
	}
}

get_american_name()
{
	switch (game["americannames"])
	{
		case  1: self.name = "Pvt. Weir";break;
		case  2: self.name = "Sgt. Perlman";break;
		case  3: self.name = "Pvt. Holm";break;
		case  4: self.name = "Pvt. Avery";break;
		case  5: self.name = "Pvt. Fincher";break;
		case  6: self.name = "Pvt. McManus";break;
		case  7: self.name = "Pvt. Roe";break;
		case  8: self.name = "Pvt. Jacobs";break;
		case  9: self.name = "Pvt. Scott";break;
		case 10: self.name = "Sgt. Vickers";break;
		case 11: self.name = "Pvt. Vaughn";break;
		case 12: self.name = "Pvt. Fisher";break;
		case 13: self.name = "Pvt. Ross";break;
		case 14: self.name = "Pvt. Barrett";break;
		case 15: self.name = "Pvt. Ellis";break;
		case 16: self.name = "Pvt. Irwin";break;
		case 17: self.name = "Sgt. Matisse";break;
		case 18: self.name = "Pvt. Limon";break;
		case 19: self.name = "Pvt. Weaver";break;
		case 20: self.name = "Sgt. Kaplan";break;
		case 21: self.name = "Pvt. Hicks";break;
		case 22: self.name = "Pvt. McKinny";break;
		case 23: self.name = "Sgt. Erickson";break;
		case 24: self.name = "Pvt. Swanson";break;
		case 25: self.name = "Pvt. Blackwell";break;
		case 26: self.name = "Pvt. Caputo";break;
		case 27: self.name = "Pvt. Doherty";break;
		case 28: self.name = "Pvt. Franklin";break;
		case 29: self.name = "Pvt. Jenkins";break;
		case 30: self.name = "Pvt. Manne";break;
		case 31: self.name = "Sgt. Little";break;
		case 32: self.name = "Pvt. Mills";break;
		case 33: self.name = "Pvt. Olsen";break;
		case 34: self.name = "Pvt. Rice";break;
		case 35: self.name = "Pvt. Sawyer";break;
		case 36: self.name = "Lt. Pearson";break;
		case 37: self.name = "Sgt. Post";break;
		case 38: self.name = "Pvt. Sweet";break;
		case 39: self.name = "Pvt. Dominguez";break;
		case 40: self.name = "Pvt. O'Doyle";break;
		case 41: self.name = "Pvt. Delarosa";break;
		case 42: self.name = "Pvt. Smith";break;
		case 43: self.name = "Sgt. Jones";break;
		case 44: self.name = "Pvt. Roosevelt";break;
		case 45: self.name = "Pvt. Carter";break;
		case 46: self.name = "Pvt. Baker";break;
		case 47: self.name = "Pvt. Wilson";break;
		case 48: self.name = "Sgt. Walton";break;
		case 49: self.name = "Pvt. Fletcher";break;
		case 50: self.name = "Pvt. Johnson";break;
		case 51: self.name = "Pvt. O'Neill";break;
		case 52: self.name = "Pvt. Goldberg";break;
		case 53: self.name = "Pvt. Svendson";break;
		case 54: self.name = "Sgt. Pierce";break;
		case 55: self.name = "Pvt. Robertson";break;
		case 56: self.name = "Pvt. Pinkerton";break;
		case 57: self.name = "Pvt. Kane";break;
		case 58: self.name = "Pvt. Bales";break;
		case 59: self.name = "Pvt. Lopresti";break;
		case 60: self.name = "Pvt. Reagan";break;
		case 61: self.name = "Lt. Hawking";break;
		case 62: self.name = "Pvt. Peterson";break;	
		case 63: self.name = "Pvt. Rogers";break;
		case 64: self.name = "Pvt. Cutler";break;
		case 65: self.name = "Sgt. Custer";break;
		case 66: self.name = "Pvt. Manning";break;
		case 67: self.name = "Pvt. Chevrier";break;
		case 68: self.name = "Pvt. O'Toole";break;
		case 69: self.name = "Sgt. Lyman";break;
		case 70: self.name = "Pvt. Rutledge";break;
		case 71: self.name = "Pvt. Norman";break;
		case 72: self.name = "Sgt. Harper";break;
		case 73: self.name = "Pvt. Walker";break;
		case 74: self.name = "Sgt. Pendleton";break;
		case 75: self.name = "Pvt. MacDonald";break;
		case 76: self.name = "Pvt. King";break;
		case 77: self.name = "Pvt. Butler";break;
		case 78: self.name = "Lt. Welch";break;
		case 79: self.name = "Pvt. Irons";break;
		case 80: self.name = "Pvt. Fishbourne";break;
		case 81: self.name = "Pvt. Ford";break;
		case 82: self.name = "Sgt. O'Brian";break;
		case 83: self.name = "Pvt. Boswell";break;
		case 84: self.name = "Pvt. Spears";break;
		case 85: self.name = "Pvt. Rooney";break;
		case 86: self.name = "Sgt. Zampella";break;
		case 87: self.name = "Pvt. Peas";break;
		case 88: self.name = "Pvt. Alderman";break;
		case 89: self.name = "Pvt. Glenn";break;
		case 90: self.name = "Pvt. Silvers";break;
		case 91: self.name = "Pvt. McCandlish";break;
		case 92: self.name = "Pvt. Bell";break;
		case 93: self.name = "Sgt. West";break;
		case 94: self.name = "Pvt. Hammon";break;
		case 95: self.name = "Pvt. Field";break;
		case 96: self.name = "Pvt. Glave";break;
		case 97: self.name = "Pvt. Gigliotti";break;
		case 98: self.name = "Pvt. Bennett";break;
		case 99: self.name = "Pvt. Messerly";break;
		case 100: self.name = "Pvt. Glasco";break;
		case 101: self.name = "Sgt. Thomas";break;
		case 102: self.name = "Pvt. Jury";break;
		case 103: self.name = "Pvt. Allen";break;
		case 104: self.name = "Pvt. Heath";break;
		case 105: self.name = "Lt. Collier";break;
		case 106: self.name = "Sgt. Turner";break;
		case 107: self.name = "Pvt. Grenier";break;
		case 108: self.name = "Pvt. Wright";break;
		case 109: self.name = "Pvt. Hewitt";break;
		case 110: self.name = "Pvt. Avalos";break;
		case 111: self.name = "Lt. Dornik";break;
		case 112: self.name = "Pvt. Grossman";break;
		case 113: self.name = "Pvt. Hagerty";break;
		case 114: self.name = "Sgt. Callaway";break;
		case 115: self.name = "Lt. Lamia";break;
		case 116: self.name = "Pvt. Kirshenbaum";break;
		case 117: self.name = "Pvt. Oxnard";break;
		case 118: self.name = "Pvt. Johnsen";break;
		case 119: self.name = "Pvt. DeMaria";break;
		case 120: self.name = "Pvt. Saltzman"; game["americannames"] = 0;break;
	}
}

get_british_name()
{
	switch (game["britishnames"])
	{
		case  1: self.name = "Pvt. Baker";break;
		case  2: self.name = "Sgt. Heacock";break;
		case  3: self.name = "Pvt. Farmer";break;
		case  4: self.name = "Pvt. Dowd";break;
		case  5: self.name = "Pvt. Fitzroy";break;
		case  6: self.name = "Pvt. Tennyson";break;
		case  7: self.name = "Pvt. Bartlett";break;
		case  8: self.name = "Pvt. Plumber";break;
		case  9: self.name = "Pvt. Blair";break;
		case  10: self.name = "Pvt. Heath";break;
		case  11: self.name = "Pvt. Neeson";break;
		case  12: self.name = "Pvt. Wallace";break;
		case  13: self.name = "Pvt. Hopkins";break;
		case  14: self.name = "Pvt. Thompson";break;
		case  15: self.name = "Pvt. Grant";break;
		case  16: self.name = "Pvt. Carter";break;
		case  17: self.name = "Pvt. Ackroyd";break;
		case  18: self.name = "Pvt. Adams";break;
		case  19: self.name = "Pvt. Moore";break;
		case  20: self.name = "Pvt. Griffin";break;
		case  21: self.name = "Pvt. Boyd";break;
		case  22: self.name = "Pvt. Harris";break;
		case  23: self.name = "Pvt. Burton";break;
		case  24: self.name = "Pvt. Montgomery";break;
		case  25: self.name = "Pvt. Matthews";break;
		case  26: self.name = "Pvt. Astor";break;
		case  27: self.name = "Pvt. Bishop";break;
		case  28: self.name = "Pvt. Compton";break;
		case  29: self.name = "Pvt. Hawksford";break;
		case  30: self.name = "Pvt. Hoyt";break;
		case  31: self.name = "Pvt. Kent";break;
		case  32: self.name = "Pvt. Rothes";break;
		case  33: self.name = "Pvt. Ross";break;
		case  34: self.name = "Pvt. Smith";break;
		case  35: self.name = "Pvt. Brown";break;
		case  36: self.name = "Pvt. Buttler";break;
		case  37: self.name = "Pvt. Caldwell";break;
		case  38: self.name = "Pvt. Cotterhill";break;
		case  39: self.name = "Pvt. Dowton";break;
		case  40: self.name = "Pvt. Walcroft";break;
		case  41: self.name = "Pvt. Wells";break;
		case  42: self.name = "Pvt. Weisz";break;
		case  43: self.name = "Pvt. Watt";break;
		case  44: self.name = "Pvt. Veale";break;
		case  45: self.name = "Pvt. Abbott";break;
		case  46: self.name = "Pvt. Bowen";break;
		case  47: self.name = "Pvt. Carver";break;
		case  48: self.name = "Pvt. Brocklebank";break;
		case  49: self.name = "Pvt. Peacock";break;
		case  50: self.name = "Pvt. Pearce";break;
		case  51: self.name = "Pvt. Reed";break;
		case  52: self.name = "Pvt. Rogers";break;
		case  53: self.name = "Pvt. Major";break;
		case  54: self.name = "Pvt. Horrocks";break;
		case  55: self.name = "Pvt. Law";break;
		case  56: self.name = "Pvt. Ritchie";break;
		case  57: self.name = "Pvt. Beck";break;
		case  58: self.name = "Pvt. James";break;
		case  59: self.name = "Pvt. Jones";break;
		case  60: self.name = "Pvt. Harrison";break;
		case  61: self.name = "Pvt. Statham";break;
		case  62: self.name = "Pvt. Fletcher";break;
		case  63: self.name = "Pvt. Mackintosh";break;
		case  64: self.name = "Pvt. Sweeney";break;
		case  65: self.name = "Pvt. Moriarty";break;
		case  66: self.name = "Pvt. Leaver";break;
		case  67: self.name = "Pvt. McGregor";break;
		case  68: self.name = "Pvt. Bremner";break;
		case  69: self.name = "Pvt. Miller";break;
		case  70: self.name = "Pvt. Macdonald";break;
		case  71: self.name = "Pvt. Henderson";break;
		case  72: self.name = "Pvt. McQuarrie";break;
		case  73: self.name = "Pvt. Welsh";break;
		case  74: self.name = "Pvt. Murphy";break;
		case  75: self.name = "Pvt. Carlyle";break;
		case  76: self.name = "Pvt. Ross";break;
		case  77: self.name = "Pvt. Eadie";break;
		case  78: self.name = "Pvt. Nestor";break;
		case  79: self.name = "Pvt. Hodge";break;
		case  80: self.name = "Pvt. Fleming";break;
		case  81: self.name = "Pvt. Figg";break;
		case  82: self.name = "Pvt. Donnely";break;
		case  83: self.name = "Pvt. Bell";break;
		case  84: self.name = "Pvt. Browne";break;
		case  85: self.name = "Pvt. Boyle";break;
		case  86: self.name = "Pvt. Burke";break;
		case  87: self.name = "Pvt. Byrne";break;
		case  88: self.name = "Pvt. Nolan";break;
		case  89: self.name = "Pvt. Carroll";break;
		case  90: self.name = "Pvt. Clarke";break;
		case  91: self.name = "Pvt. Collins";break;
		case  92: self.name = "Pvt. Connolly";break;
		case  93: self.name = "Pvt. Connor";break;
		case  94: self.name = "Pvt. Fitzgerald";break;
		case  95: self.name = "Pvt. Flynn";break;
		case  96: self.name = "Pvt. Hughes";break;
		case  97: self.name = "Pvt. Kennedy";break;
		case  98: self.name = "Pvt. Murray";break;
		case  99: self.name = "Pvt. Ryan";break;
		case  100: self.name = "Pvt. Quinn";break;
		case  101: self.name = "Pvt. Shea";break;
		case  102: self.name = "Pvt. Sullivan";break;
		case  103: self.name = "Pvt. Lewis";break;
		case  104: self.name = "Pvt. Walsh";break;
		case  105: self.name = "Pvt. Connery";break;
		case  106: self.name = "Pvt. White";break;
		case  107: self.name = "Pvt. DeWitt";break;
		case  108: self.name = "Pvt. Stewart";break;
		case  109: self.name = "Pvt. Stevenson";break;
		case  110: self.name = "Pvt. Rankin";break;
		case  111: self.name = "Pvt. McDiarmid";break;
		case  112: self.name = "Pvt. Maxwell";break;
		case  113: self.name = "Pvt. Livingstone";break;
		case  114: self.name = "Pvt. Lipton";break;
		case  115: self.name = "Pvt. Liddell";break;
		case  116: self.name = "Pvt. Lennox";break;
		case  117: self.name = "Pvt. Kidd";break;
		case  118: self.name = "Pvt. Hamilton";break;
		case  119: self.name = "Pvt. Coltrane";break;
		case  120: self.name = "Pvt. Burns";break;
		case  121: self.name = "Pvt. Anderson";break;
		case  122: self.name = "Pvt. Lindsay";break;
		case  123: self.name = "Pvt. MacLeod";break;
		case  124: self.name = "Pvt. Sherman";break;
		case  125: self.name = "Pvt. Williamson";break;
		case  126: self.name = "Pvt. Kilgour";break;
		case  127: self.name = "Pvt. Watson";break;
		case  128: self.name = "Pvt. Holmes";break;
		case  129: self.name = "Sgt. Boon";break;
		case  130: self.name = "Pvt. Pritchard";break;
		case  131: self.name = "Pvt. Cook";break;
		case  132: self.name = "Pvt. Mitchell";break;
		case  133: self.name = "Pvt. Kilpatrick";break;
		case  134: self.name = "Sgt. Murphy";break;
		case  135: self.name = "Pvt. Brest";break;
		case  136: self.name = "Pvt. Rockhill";break;
		case  137: self.name = "Pvt. Riley";break;
		case  138: self.name = "Pvt. Ricketts"; game["britishnames"] = 0;break;
	}
}

get_russian_name()
{
	switch (game["russiannames"])
	{
		case  1: self.name = "Pvt. Ivanov";break;
		case  2: self.name = "Sgt. Smirnov";break;
		case  3: self.name = "Pvt. Vasilev";break;
		case  4: self.name = "Pvt. Petrov";break;
		case  5: self.name = "Pvt. Kyznetsov";break;
		case  6: self.name = "Pvt. Fedorov";break;
		case  7: self.name = "Pvt. Mikhailov";break;
		case  8: self.name = "Pvt. Sokolov";break;
		case  9: self.name = "Pvt. Filatov";break;
		case  10: self.name = "Pvt. Leonov";break;
		case  11: self.name = "Pvt. Danilov";break;
		case  12: self.name = "Pvt. Zaitsev";break;
		case  13: self.name = "Pvt. Ilin";break;
		case  14: self.name = "Pvt. Semenov";break;
		case  15: self.name = "Pvt. Lebedev";break;
		case  16: self.name = "Pvt. Golubev";break;
		case  17: self.name = "Pvt. Lukin";break;
		case  18: self.name = "Pvt. Zhuravlev";break;
		case  19: self.name = "Pvt. Gerasimov";break;
		case  20: self.name = "Pvt. Petrenko";break;
		case  21: self.name = "Pvt. Nikitin";break;
		case  22: self.name = "Pvt. Andropov";break;
		case  23: self.name = "Pvt. Chernenko";break;
		case  24: self.name = "Pvt. Brezhnev";break;
		case  25: self.name = "Pvt. Kalinin";break;
		case  26: self.name = "Pvt. Shvernik";break;
		case  27: self.name = "Pvt. Voroshilov";break;
		case  28: self.name = "Pvt. Mikoyan";break;
		case  29: self.name = "Pvt. Podgorniy";break;
		case  30: self.name = "Pvt. Kuznetsov";break;
		case  31: self.name = "Pvt. Grombyo";break;
		case  32: self.name = "Pvt. Rykov";break;
		case  33: self.name = "Pvt. Malenkov";break;
		case  34: self.name = "Pvt. Bulganin";break;
		case  35: self.name = "Pvt. Kosygin";break;
		case  36: self.name = "Pvt. Tikhonov";break;
		case  37: self.name = "Pvt. Ryzhkov";break;
		case  38: self.name = "Pvt. Vyshinskiy";break;
		case  39: self.name = "Pvt. Shevardnadze";break;
		case  40: self.name = "Pvt. Shepilov";break;
		case  41: self.name = "Pvt. Bessmertnykh";break;
		case  42: self.name = "Pvt. Pankin";break;
		case  43: self.name = "Pvt. Litvinov";break;
		case  44: self.name = "Pvt. Merkulov";break;
		case  45: self.name = "Pvt. Ogoltsov";break;
		case  46: self.name = "Pvt. Fedorchuk";break;
		case  47: self.name = "Pvt. Bakatin";break;
		case  48: self.name = "Pvt. Shebarshin";break;
		case  49: self.name = "Pvt. Semichastniy";break;
		case  50: self.name = "Pvt. Serov";break;
		case  51: self.name = "Pvt. Ustinov";break;
		case  52: self.name = "Pvt. Yazov";break;
		case  53: self.name = "Pvt. Grechko";break;
		case  54: self.name = "Pvt. Aleksandrov";break;
		case  55: self.name = "Pvt. Shatalov";break;
		case  56: self.name = "Pvt. Shonin";break;
		case  57: self.name = "Pvt. Filipchenko";break;
		case  58: self.name = "Pvt. Kubasov";break;
		case  59: self.name = "Pvt. Gorbatko";break;
		case  60: self.name = "Pvt. Volkov";break;
		case  61: self.name = "Pvt. Yeliseyev";break;
		case  62: self.name = "Pvt. Feoktistov";break;
		case  63: self.name = "Pvt. Tereshkov";break;
		case  64: self.name = "Pvt. Bykovsky";break;
		case  65: self.name = "Pvt. Artyukhin";break;
		case  66: self.name = "Pvt. Beregovy";break;
		case  67: self.name = "Pvt. Berezovoy";break;
		case  68: self.name = "Pvt. Demin";break;
		case  69: self.name = "Pvt. Jahn";break;
		case  70: self.name = "Pvt. Khrunov";break;
		case  71: self.name = "Pvt. Kovalyonok";break;
		case  72: self.name = "Pvt. Lazarev";break;
		case  73: self.name = "Pvt. Leonov";break;
		case  74: self.name = "Pvt. Popovich";break;
		case  75: self.name = "Pvt. Romanenko";break;
		case  76: self.name = "Pvt. Rozhdestvensky";break;
		case  77: self.name = "Pvt. Rukavishnikov";break;
		case  78: self.name = "Pvt. Ryumin";break;
		case  79: self.name = "Pvt. Savinykh";break;
		case  80: self.name = "Pvt. Sevastyanov";break;
		case  81: self.name = "Pvt. Titov";break;
		case  82: self.name = "Pvt. Yeliseyev";break;
		case  83: self.name = "Pvt. Gagarin";break;
		case  84: self.name = "Pvt. Kinski";break;
		case  85: self.name = "Pvt. Todoroff";break;
		case  86: self.name = "Pvt. Goernshtein";break;
		case  87: self.name = "Pvt. Bondarachuk";break;
		case  88: self.name = "Pvt. Banionis";break;
		case  89: self.name = "Pvt. Solonitsyn";break;
		case  90: self.name = "Pvt. Grinko";break;
		case  91: self.name = "Pvt. Kerdimun";break;
		case  92: self.name = "Pvt. Kizilov";break;
		case  93: self.name = "Pvt. Malykh";break;
		case  94: self.name = "Pvt. Oganesyan";break;
		case  95: self.name = "Pvt. Ogorodnikov";break;
		case  96: self.name = "Pvt. Sargsyan";break;
		case  97: self.name = "Pvt. Semyonov";break;
		case  98: self.name = "Pvt. Statsinski";break;
		case  99: self.name = "Pvt. Sumenov";break;
		case  100: self.name = "Pvt. Tejkh";break;
		case  101: self.name = "Pvt. Tarasov";break;
		case  102: self.name = "Pvt. Artemyev";break;
		case  103: self.name = "Pvt. Ovchinnikov";break;
		case  104: self.name = "Pvt. Yusov";break;
		case  105: self.name = "Pvt. Kushneryov";break;
		case  106: self.name = "Pvt. Tarkovsky";break;
		case  107: self.name = "Pvt. Chugunov";break;
		case  108: self.name = "Pvt. Murashko";break;
		case  109: self.name = "Pvt. Nevsky";break;
		case  110: self.name = "Pvt. Paramanov";break;
		case  111: self.name = "Pvt. Shvedov";break;
		case  112: self.name = "Pvt. Tarkovsky";break;
		case  113: self.name = "Pvt. Glushenko";break;
		case  114: self.name = "Pvt. Chernogolov";break;
		case  115: self.name = "Pvt. Afanasyev";break;
		case  116: self.name = "Pvt. Bondarenko";break;
		case  117: self.name = "Pvt. Voronov";break;
		case  118: self.name = "Pvt. Gridin";break;
		case  119: self.name = "Pvt. Kiselev";break;
		case  120: self.name = "Pvt. Sarayev";break;
		case  121: self.name = "Pvt. Svirin";break;
		case  122: self.name = "Pvt. Sabgaida";break;
		case  123: self.name = "Pvt. Chernyshenko";break;
		case  124: self.name = "Pvt. Dovzhenko";break;
		case  125: self.name = "Pvt. Ivashenko";break;
		case  126: self.name = "Pvt. Shapovalov";break;
		case  127: self.name = "Pvt. Yakimenko";break;
		case  128: self.name = "Pvt. Masijashvili";break;
		case  129: self.name = "Pvt. Murzaev";break;
		case  130: self.name = "Pvt. Turdyev";break;
		case  131: self.name = "Pvt. Ramazanov";break;
		case  132: self.name = "Pvt. Avagimov";break;
		case  133: self.name = "Pvt. Demchenko";break;
		case  134: self.name = "Pvt. Stepanoshvili";break;
		case  135: self.name = "Pvt. Shkuratov";break;
		case  136: self.name = "Pvt. Yefremov";break;
		case  137: self.name = "Pvt. Ulyanova";break;
		case  138: self.name = "Pvt. Semenov"; game["russiannames"] = 0;break;
	}
}