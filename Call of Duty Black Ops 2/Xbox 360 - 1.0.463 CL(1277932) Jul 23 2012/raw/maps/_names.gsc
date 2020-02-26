main()
{
}

setup_names()
{
	assert( !IsDefined( level.names ) );

	//Init arrays
	level.names = [];
	level.namesIndex = [];

	//Setup default names list
	initialize_nationality( "american" );
}

initialize_nationality( str_nationality )
{
	//Check if the nationality list has been created yet. If not, make it now
	if( !isdefined(level.names[str_nationality] ) )
	{
		level.names[str_nationality] = [];
		
		if( str_nationality != "civilian" )
		{
			add_nationality_names( str_nationality );
		}

		randomize_name_list( str_nationality );
		level.nameIndex[str_nationality] = 0;
	}
}

add_nationality_names( str_nationality )
{
	switch( str_nationality )
	{
		case "american":
			american_names();
			break;
			
		case "british":
			british_names();
			break;
			
		case "russian":
			russian_names();
			break;
			
		case "japanese":
			japanese_names();
			break;
			
		case "german":
			german_names();
			break;
			
		case "afghan":
			afghan_names();
			break;
			
		case "angolan":
			angolan_names();
			break;
			
		case "cuban":
			cuban_names();
			break;
			
		case "pakistani":
			pakistani_names();
			break;
		
		case "panamanian":
			panamanian_names();
			break;
			
		case "yemeni":
			yemeni_names();
			break;
			
		case "agent":
			agent_names();
			break;
			
		case "police":
			police_names();
			break;
			
		case "seal":
			seal_names();
			break;
			
		case "security":
			security_names();
			break;

		default:
			AssertMsg("Name list does not exist for " + str_nationality);
			break;
	}
}

american_names()
{
	// Generic Names
	add_name( "american", "Adams" );
	add_name( "american", "Allen" );
	add_name( "american", "Baker" );
	add_name( "american", "Brown" );
	add_name( "american", "Cook" );
	add_name( "american", "Clarkson" );
	add_name( "american", "Davis" );
	add_name( "american", "Edwards" );
	add_name( "american", "Fletcher" );
	add_name( "american", "Groves" );
	add_name( "american", "Grant" );
	add_name( "american", "Hammond" );
	add_name( "american", "Hacker" );
	add_name( "american", "Howard" );
	add_name( "american", "Jackson" );
	add_name( "american", "Jones" );
	add_name( "american", "Lamia" );
	add_name( "american", "Livingstone" );
	add_name( "american", "Moore" );
	add_name( "american", "Mitchell" );
	add_name( "american", "Nelson" );
	add_name( "american", "Nash" );
	add_name( "american", "Osborne" );
	add_name( "american", "Paige" );
	add_name( "american", "Pearce" );
	add_name( "american", "Pepper" );
	add_name( "american", "Ross" );
	add_name( "american", "Saxon" );
	add_name( "american", "Slone" );
	add_name( "american", "Scott" );
	add_name( "american", "Stohl" );
	add_name( "american", "Suarez" );
	add_name( "american", "Thompson" );
	add_name( "american", "Welch" );
	
	// DevTeam Names:

	// Publisher Names:

	// Friend Names:
}

russian_names()
{
	add_name( "russian", "Avtamonov" );
	add_name( "russian", "Barzilovich" );
	add_name( "russian", "Blyakher" );
	add_name( "russian", "Bulenkov" );
	add_name( "russian", "Datsyuk" );
	add_name( "russian", "Diakov" );
	add_name( "russian", "Dvilyansky" );
	add_name( "russian", "Dymarsky" );
	add_name( "russian", "Fedorova" );
	add_name( "russian", "Gerasimov" );
	add_name( "russian", "Ilyin" );
	add_name( "russian", "Ikonnikov" );
	add_name( "russian", "Kosteltsev" );
	add_name( "russian", "Krasilnikov" );
	add_name( "russian", "Lukin" );
	add_name( "russian", "Maximov" );
	add_name( "russian", "Melnikov" );
	add_name( "russian", "Nesterov" );
	add_name( "russian", "Pelov" );
	add_name( "russian", "Polubencev" );
	add_name( "russian", "Pokrovsky" );
	add_name( "russian", "Repin" );
	add_name( "russian", "Romanenko" );
	add_name( "russian", "Saslovsky" );
	add_name( "russian", "Sidorenko" );
	add_name( "russian", "Touevsky" );
	add_name( "russian", "Vakhitov" );
	add_name( "russian", "Yakubov");
	add_name( "russian", "Yoslov");
	add_name( "russian", "Zubarev");

	// Friend Names

}

//-- BO2 new block
afghan_names()
{
	add_name( "afghan", "Arenja" );
	add_name( "afghan", "Busri" );
	add_name( "afghan", "Chicher" );
	add_name( "afghan", "Dhawan" );
	add_name( "afghan", "Gawri" );
	add_name( "afghan", "Jaidhara" );
	add_name( "afghan", "Khanna" );
	add_name( "afghan", "Luthra" );
	add_name( "afghan", "Muthreja" );
	add_name( "afghan", "Popat" );
	add_name( "afghan", "Soni" );
	add_name( "afghan", "Taneja" );
	add_name( "afghan", "Vovra" );
	add_name( "afghan", "Vijh" );
	add_name( "afghan", "Wadhwa" );
}

agent_names()
{
	add_name( "agent", "Bailey" );
	add_name( "agent", "Campbell" );
	add_name( "agent", "Collins" );
	add_name( "agent", "Cook" );
	add_name( "agent", "Cooper" );
	add_name( "agent", "Edwards" );
	add_name( "agent", "Evans" );
	add_name( "agent", "Gray" );
	add_name( "agent", "Howard" );
	add_name( "agent", "Morgan" );
	add_name( "agent", "Morris" );
	add_name( "agent", "Murphy" );
	add_name( "agent", "Phillips" );
	add_name( "agent", "Rivera" );
	add_name( "agent", "Roberts" );
	add_name( "agent", "Rogers" );
	add_name( "agent", "Stewart" );
	add_name( "agent", "Torres" );
	add_name( "agent", "Turner" );
	add_name( "agent", "Ward" );
}

angolan_names()
{
	add_name( "angolan", "Santos" );
	add_name( "angolan", "Samakuva" );
	add_name( "angolan", "Neto" );
	add_name( "angolan", "Roberto" );
	add_name( "angolan", "Lando" );
	add_name( "angolan", "Pasos" );
	add_name( "angolan", "Cacete" );
	add_name( "angolan", "Chipenda" );
	add_name( "angolan", "Pereira" );
	add_name( "angolan", "Constantino" );
	add_name( "angolan", "Botelho" );
	add_name( "angolan", "Diniz" );
	add_name( "angolan", "Rapaso" );
	add_name( "angolan", "Azavedo" );
	add_name( "angolan", "Catulo" );
	add_name( "angolan", "Teles" );
}

cuban_names()
{
	add_name( "cuban", "Martinez" );
	add_name( "cuban", "Perez" );
	add_name( "cuban", "Lopez" );
	add_name( "cuban", "Garcia" );
	add_name( "cuban", "Vasquez" );
	add_name( "cuban", "Rodriguez" );
	add_name( "cuban", "Sardina" );
	add_name( "cuban", "Aldama" );
	add_name( "cuban", "Bacigalupi" );
	add_name( "cuban", "Novoa" );
	add_name( "cuban", "Hornedo" );
	add_name( "cuban", "Foca" );
	add_name( "cuban", "Villa" );
	add_name( "cuban", "Castellanos" );
	add_name( "cuban", "Estrada" );
	add_name( "cuban", "Sotolongo" );
	add_name( "cuban", "Fuentes" );
	add_name( "cuban", "Sanchez" );
	add_name( "cuban", "Lima" );
	add_name( "cuban", "Mendez" );
	add_name( "cuban", "Moreno" );
	add_name( "cuban", "Hernandez" );
}

pakistani_names()
{
	add_name( "pakistani", "Afrida" );
	add_name( "pakistani", "Awan" );
	add_name( "pakistani", "Baqri" );
	add_name( "pakistani", "Bilgrami" );
	add_name( "pakistani", "Chaudhri" );
	add_name( "pakistani", "Edhi" );
	add_name( "pakistani", "Farooqi" );
	add_name( "pakistani", "Jaffri" );
	add_name( "pakistani", "Khan" );
	add_name( "pakistani", "Laghari" );
	add_name( "pakistani", "Mirza" );
	add_name( "pakistani", "Naqvi" );
	add_name( "pakistani", "Panjwani" );
	add_name( "pakistani", "Qadri" );
	add_name( "pakistani", "Rehmani" );
	add_name( "pakistani", "Saigal" );
	add_name( "pakistani", "Singh" );
	add_name( "pakistani", "Taqvi" );
	add_name( "pakistani", "Usmani" );
	add_name( "pakistani", "Zaidi" );
}

panamanian_names()
{
	add_name( "panamanian", "Martinelli" );
	add_name( "panamanian", "Varela" );
	add_name( "panamanian", "Mulino" );
	add_name( "panamanian", "Suarez" );
	add_name( "panamanian", "Vergara" );
	add_name( "panamanian", "Aquilar" );
	add_name( "panamanian", "Sierra" );
	add_name( "panamanian", "Benitez" );
	add_name( "panamanian", "Burillo" );
	add_name( "panamanian", "Clement" );
}

police_names()
{
	add_name( "police", "Anderson" );
	add_name( "police", "Brown" );
	add_name( "police", "Davis" );
	add_name( "police", "Garcia" );
	add_name( "police", "Harris" );
	add_name( "police", "Jackson" );
	add_name( "police", "Johnson" );
	add_name( "police", "Jones" );
	add_name( "police", "Martin" );
	add_name( "police", "Martinez" );
	add_name( "police", "Miller" );
	add_name( "police", "Moore" );
	add_name( "police", "Robinson" );
	add_name( "police", "Smith" );
	add_name( "police", "Taylor" );
	add_name( "police", "Thomas" );
	add_name( "police", "Thompson" );
	add_name( "police", "White" );
	add_name( "police", "Williams" );
	add_name( "police", "Wilson" );
}

security_names()
{
	add_name( "security", "Anderson" );
	add_name( "security", "Brown" );
	add_name( "security", "Davis" );
	add_name( "security", "Garcia" );
	add_name( "security", "Harris" );
	add_name( "security", "Jackson" );
	add_name( "security", "Johnson" );
	add_name( "security", "Jones" );
	add_name( "security", "Martin" );
	add_name( "security", "Martinez" );
	add_name( "security", "Miller" );
	add_name( "security", "Moore" );
	add_name( "security", "Robinson" );
	add_name( "security", "Smith" );
	add_name( "security", "Taylor" );
	add_name( "security", "Thomas" );
	add_name( "security", "Thompson" );
	add_name( "security", "White" );
	add_name( "security", "Williams" );
	add_name( "security", "Wilson" );
}

seal_names()
{
	add_name( "seal", "Adams" );
	add_name( "seal", "Allen" );
	add_name( "seal", "Baker" );
	add_name( "seal", "Carter" );
	add_name( "seal", "Gonzalez" );
	add_name( "seal", "Green" );
	add_name( "seal", "Hall" );
	add_name( "seal", "Hill" );
	add_name( "seal", "Hernandez" );
	add_name( "seal", "King" );
	add_name( "seal", "Lee" );
	add_name( "seal", "Lewis" );
	add_name( "seal", "Lopez" );
	add_name( "seal", "Mitchell" );
	add_name( "seal", "Nelson" );
	add_name( "seal", "Rodriguez" );
	add_name( "seal", "Scott" );
	add_name( "seal", "Walker" );
	add_name( "seal", "Young" );
	add_name( "seal", "Wright" );
	
	// Make A Wish Names:
	add_name( "seal", "Focht" );
}

yemeni_names()
{
	add_name( "yemeni", "Haddad" );
	add_name( "yemeni", "Matar" );
	add_name( "yemeni", "Shehab" );
	add_name( "yemeni", "Abda" );
	add_name( "yemeni", "Abed" );
	add_name( "yemeni", "Laham" );
	add_name( "yemeni", "Saleh" );
	add_name( "yemeni", "Shamlan" );
	add_name( "yemeni", "Hadi" );
	add_name( "yemeni", "Beidh" );
	add_name( "yemeni", "Sayed" );
}

//Unused names

british_names()
{
	// Generic Names
	add_name( "british", "Abbot" );
/*	add_name( "british", "Bartlett" );
	add_name( "british", "Boyd" );
	add_name( "british", "Boyle" );
	add_name( "british", "Bremner" );
	add_name( "british", "Carlyle" );
	add_name( "british", "Carver" );
	add_name( "british", "Clarke" );
	add_name( "british", "Collins" );
	add_name( "british", "Compton" );
	add_name( "british", "Connolly" );
	add_name( "british", "Cook" );
	add_name( "british", "Dowd" );
	add_name( "british", "Field" );
	add_name( "british", "Fleming" );
	add_name( "british", "Fletcher" );
	add_name( "british", "Flynn" );
	add_name( "british", "Greaves" );
	add_name( "british", "Griffin" );
	add_name( "british", "Harrison" );
	add_name( "british", "Hopkins" );
	add_name( "british", "Hoyt" );
	add_name( "british", "Kent" );
	add_name( "british", "Lewis" );
	add_name( "british", "Lipton" );
	add_name( "british", "Macdonald" );
	add_name( "british", "Maxwell" );
	add_name( "british", "McQuarrie" );
	add_name( "british", "Mitton" );
	add_name( "british", "Murray" );
	add_name( "british", "Pearce" );
	add_name( "british", "Pierro" );
	add_name( "british", "Plumber" );
	add_name( "british", "Pritchard" );
	add_name( "british", "Rankin" );
	add_name( "british", "Ritchie" );
	add_name( "british", "Roth" );
	add_name( "british", "Statham" );
	add_name( "british", "Stevenson" );
	add_name( "british", "Sullivan" );
	add_name( "british", "Thompson" );
	add_name( "british", "Veale" );
	add_name( "british", "Wallace" );
	add_name( "british", "Wallcroft" );
	add_name( "british", "Wells" );
	add_name( "british", "Welsh" );  */

	// DevTeam Names:

	// Friend Names:
}

german_names()
{
	// Generic Names
	add_name( "german", "Adler" );
/*	add_name( "german", "Bader" );
	add_name( "german", "Bauer" );
	add_name( "german", "Baumann" );
	add_name( "german", "Becker" );
	add_name( "german", "Bergmann" );
	add_name( "german", "Beyer" );
	add_name( "german", "Brandt" );
	add_name( "german", "Brauer" );
	add_name( "german", "Broemel" );
	add_name( "german", "Faerber" );
	add_name( "german", "Fiedler" );
	add_name( "german", "Fischer" );
	add_name( "german", "Fleischer" );
	add_name( "german", "Gross" );
	add_name( "german", "Hahn" );
	add_name( "german", "Hohmann" );
	add_name( "german", "Jaeger" );
	add_name( "german", "Kahn" );
	add_name( "german", "Kaltenbach" );
	add_name( "german", "Kaufmann" );
	add_name( "german", "Kessler" );
	add_name( "german", "Koch" );
	add_name( "german", "Koehler" );
	add_name( "german", "Koenig" );
	add_name( "german", "Kraemer" );
	add_name( "german", "Krieger" );
	add_name( "german", "Kunze" );
	add_name( "german", "Neuberger" );
	add_name( "german", "Neumann" );
	add_name( "german", "Pfeffer" );
	add_name( "german", "Reichmann" );
	add_name( "german", "Reimann" );
	add_name( "german", "Reiniger" );
	add_name( "german", "Reiter" );
	add_name( "german", "Sauer" );
	add_name( "german", "Schaefer" );
	add_name( "german", "Schlueter" );
	add_name( "german", "Schmidt" );
	add_name( "german", "Schneider" );
	add_name( "german", "Schrader" );
	add_name( "german", "Schreiber" );
	add_name( "german", "Schroeder" );
	add_name( "german", "Schuhmann" );
	add_name( "german", "Schultz" );
	add_name( "german", "Schwarz" );
	add_name( "german", "Steinhauer" );
	add_name( "german", "Wagner" );
	add_name( "german", "Weber" );  */

	// Friend Names:
}

japanese_names()
{
	// Generic Names
	add_name( "japanese", "Aichi" );
/*	add_name( "japanese", "Akita" );
	add_name( "japanese", "Aomori" );
	add_name( "japanese", "Chiba" );
	add_name( "japanese", "Ehime" );
	add_name( "japanese", "Fukui" );
	add_name( "japanese", "Fukuoka" );
	add_name( "japanese", "Fukushima" );
	add_name( "japanese", "Gifu" );
	add_name( "japanese", "Gunma" );
	add_name( "japanese", "Hiroshima" );
	add_name( "japanese", "Hokkaido" );
	add_name( "japanese", "Hyogo" );
	add_name( "japanese", "Ibaraki" );
	add_name( "japanese", "Ishikawa" );
	add_name( "japanese", "Iwate" );
	add_name( "japanese", "Kagawa" );
	add_name( "japanese", "Kagoshima" );
	add_name( "japanese", "Kanagawa" );
	add_name( "japanese", "Kochi" );
	add_name( "japanese", "Kumamoto" );
	add_name( "japanese", "Kyoto" );
	add_name( "japanese", "Mie" );
	add_name( "japanese", "Miyagi" );
	add_name( "japanese", "Miyazaki" );
	add_name( "japanese", "Nagano" );
	add_name( "japanese", "Nagasaki" );
	add_name( "japanese", "Nara" );
	add_name( "japanese", "Niigata" );
	add_name( "japanese", "Oita" );
	add_name( "japanese", "Okayama" );
	add_name( "japanese", "Okinawa" );
	add_name( "japanese", "Osaka" );
	add_name( "japanese", "Saga" );
	add_name( "japanese", "Saitama" );
	add_name( "japanese", "Shiga" );
	add_name( "japanese", "Shimane" );
	add_name( "japanese", "Shizuoka" );
	add_name( "japanese", "Tochigi" );
	add_name( "japanese", "Tokushima" );
	add_name( "japanese", "Tokyo" );
	add_name( "japanese", "Tottori" );
	add_name( "japanese", "Toyama" );
	add_name( "japanese", "Wakayama" );
	add_name( "japanese", "Yamagata" );
	add_name( "japanese", "Yamaguchi" );
	add_name( "japanese", "Yamanashi" ); */
}

//Begin name functions

add_name( nationality, thename )
{
	level.names[nationality][level.names[nationality].size] = thename;
}

randomize_name_list( nationality )
{
	size = level.names[nationality].size;
	for( i = 0; i < size; i++ )
	{
		switchwith = RandomInt( size );
		temp = level.names[nationality][i];
		level.names[nationality][i] = level.names[nationality][switchwith];
		level.names[nationality][switchwith] = temp;
	}
}

get_name( override )
{
	/*if( self.team == "axis" )//Axis doesn't get names
	{
		self.name = "";
		self notify( "set name and rank" );
		return;
	}*/
	
	if( !IsDefined( override ) && level.script == "credits" )
	{
		self.airank = "private";
		self notify( "set name and rank" );
		return;
	}
	
	if( IsDefined( self.script_friendname ) )
	{
		if( self.script_friendname == "none" )
		{
			self.name = "";
		}
		else
		{
			self.name = self.script_friendname;
			getRankFromName( self.name );
		}
		self notify( "set name and rank" );
		return;
	}
	
	assert( IsDefined( level.names ) );
	
	str_classname = self get_ai_classname();
	str_nationality = "american";//Default nationality
	
	//-- BO2 stuff (work in progress)
	if( IsSubStr( str_classname, "_civilian_" ) )//Civilian
	{
		self.airank = "none";
		str_nationality = "civilian";
	}
	else if( IsSubStr( str_classname, "_muj_" ) )//Afghan
	{
		self.airank = "none";
		str_nationality = "afghan";
	}
	else if( self is_special_agent_member(str_classname) )//Special Agent
	{
		str_nationality = "agent";
	}
	else if( IsSubStr( str_classname, "_unita_" ) )//Angolan
	{
		self.airank = "none";
		str_nationality = "angolan";
	}
	else if( IsSubStr( str_classname, "_cuban_" ) )//Cuban
	{
		self.airank = "none";
		str_nationality = "cuban";
	}
	else if( IsSubStr( str_classname, "_isi_" ) || IsSubStr( str_classname, "_let_" ) )//Pakistani
	{
		self.airank = "none";
		str_nationality = "pakistani";
	}
	else if( IsSubStr( str_classname, "_pdf_" ) || IsSubStr( str_classname, "_digbat_" ) || IsSubStr( str_classname, "_panama_" ) )//Panamanian
	{
		self.airank = "none";
		str_nationality = "panamanian";
	}
	else if( self is_lapd_member(str_classname) )//LAPD
	{
		str_nationality = "police";
	}
	else if( self is_seal_member(str_classname) )//SEAL
	{
		str_nationality = "seal";
	}
	else if ( self is_security_member( str_classname ) )
	{
		str_nationality = "security";
	}
	else if( IsSubStr( str_classname, "_soviet_" ))//Russian
	{
		self.airank = "none";
		str_nationality = "russian";
	}
	else if( IsSubStr( str_classname, "_yemeni_" ) || IsSubStr( str_classname, "_terrorist_yemen_" ) )//Yemeni
	{
		self.airank = "none";
		str_nationality = "yemeni";
	}

	initialize_nationality( str_nationality );
	get_name_for_nationality( str_nationality );//Defaults to 'American'
	
	self notify( "set name and rank" );
}

get_ai_classname()
{
	if( IsDefined( self.dr_ai_classname ) )
	{
		str_classname = tolower( self.dr_ai_classname );
	}
	else
	{
		str_classname = tolower( self.classname );
	}
	
	return str_classname;
}

add_override_name_func(nationality, func)
{
	if( !IsDefined(level._override_name_funcs) )
	{
		level._override_name_funcs = [];
	}

	assert( !IsDefined(level._override_name_funcs[nationality]), "Setting a name override function twice.");

	level._override_name_funcs[nationality] = func;
}

get_name_for_nationality( nationality )
{
	assert( IsDefined( level.nameIndex[nationality] ), nationality );

	//kdrew 6/1/2010 - Added overloading name functions for nationalities
	if( IsDefined( level._override_name_funcs) && IsDefined( level._override_name_funcs[nationality] ) )
	{
		self.name = [[ level._override_name_funcs[nationality] ]]();

		//a rank must be assigned for squadmanager
		self.airank = "";

		return;
	}
	
	if( nationality == "civilian" )
	{
		self.name = "";
		return;
	}
	
	level.nameIndex[nationality] = ( level.nameIndex[nationality] + 1 ) % level.names[nationality].size;
	lastname = level.names[nationality][level.nameIndex[nationality]];

	if(!IsDefined(lastname))
	{
		lastname = "";
	}

	if (IsDefined(level._override_rank_func))
	{
		self [[level._override_rank_func]](lastname);
	}
	else if( IsDefined(self.airank) && self.airank == "none")
	{
		self.name = lastname;
		return;
	}
	else
	{
		rank = RandomInt( 100 );
		
		if ( nationality == "seal" )
		{
			if( rank > 20 )
			{
				fullname = "PO " + lastname;
				self.airank = "petty officer";
			}
			else if( rank > 10 )
			{
				fullname = "CPO " + lastname;
				self.airank = "chief petty officer";
			}
			else
			{
				fullname = "Lt. " + lastname;
				self.airank = "lieutenant";
			}
		}
		else if ( nationality == "police" )
		{
			fullname = "Officer " + lastname;
			self.airank = "police officer";
		}
		else if ( nationality == "agent" )
		{
			fullname = "Agent " + lastname;
			self.airank = "special agent";
		}
		else if ( nationality == "security" )
		{
			fullname = "Guard " + lastname;
		}
		else //catch all for remaining for now so script doesn't break on new types
		{
			if( rank > 20 )
			{
				fullname = "Pvt. " + lastname;
				self.airank = "private";
			}
			else if( rank > 10 )
			{
				fullname = "Cpl. " + lastname;
				self.airank = "corporal";
			}
			else
			{
				fullname = "Sgt. " + lastname;
				self.airank = "sergeant";
			}
		}
	
	/*	if( self.team == "axis" )
		{
			self.ainame = fullname;
		}
		else
		{
			self.name = fullname;
		}*/
		
		self.name = fullname;
	}
}

is_seal_member(str_classname)
{
	if( IsSubStr( str_classname, "_seal_" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

is_lapd_member(str_classname)
{
	if( IsSubStr( str_classname, "_lapd_" ) || IsSubStr( str_classname, "_swat_" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

is_security_member( str_classname )
{
	if( IsSubStr( str_classname, "_security_" ) )
	{
		return true;
	}
	
	return false;
}

is_special_agent_member(str_classname)
{
	if( IsSubStr( str_classname, "_sstactical_" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

getRankFromName( name )
{
	if( !IsDefined( name ) )
	{
		self.airank = ( "private" );
	}
	
	tokens = Strtok( name, " " );
	assert( tokens.size );
	shortRank = tokens[0];

	switch( shortRank )
	{
	case "Pvt.":
		self.airank = "private";
		break;
	case "Pfc.":
		self.airank = "private";
		break;
	case "Cpl.":
		self.airank = "corporal";
		break;
	case "Sgt.":
		self.airank = "sergeant";
		break;
	case "Lt.":
		self.airank = "lieutenant";
		break;
	case "Cpt.":
		self.airank = "captain";
		break;
	default:
		/#println( "sentient has invalid rank " + shortRank + "!" ); #/
		self.airank = "private";
		break;
	}
}

issubstr_match_any( str_match, str_search_array)
{
	assert( str_search_array.size, "String array is empty" );
	
	foreach( str_search in str_search_array )
	{
		if( IsSubStr( str_match, str_search ) )
		{
			return true;
		}
	}
	return false;
}
