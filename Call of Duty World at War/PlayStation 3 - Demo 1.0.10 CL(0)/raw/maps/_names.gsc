main()
{
}

setup_names()
{
	assert( !IsDefined( level.names ) ); 

	nationalities = []; 
	nationalities[0] = "american"; 
	nationalities[1] = "british"; 
	nationalities[2] = "russian"; 
	nationalities[3] = "german"; 
	nationalities[4] = "japanese"; 
	
	for( i = 0; i < nationalities.size; i++ )
	{
		level.names[nationalities[i]] = []; 
	}

	// Allies
	american_names(); 
	british_names(); 
	russian_names(); 

	// Axis
	japanese_names(); 
	german_names(); 

	for( i = 0; i < nationalities.size; i++ )
	{
		randomize_name_list( nationalities[i] ); 
		level.nameIndex[nationalities[i]] = 0; 
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
	add_name( "american", "Clark" ); 
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
	add_name( "american", "Lee" ); 
	add_name( "american", "Moore" ); 
	add_name( "american", "Mitchell" ); 
	add_name( "american", "Nelson" ); 
	add_name( "american", "Nash" ); 
	add_name( "american", "Osborne" ); 
	add_name( "american", "Paige" ); 
	add_name( "american", "Pepper" ); 
	add_name( "american", "Ross" ); 
	add_name( "american", "Saxon" ); 
	add_name( "american", "Sloan" ); 
	add_name( "american", "Scott" ); 
	add_name( "american", "Thompson" ); 
	
	// DevTeam Names:
	add_name( "american", "Anderson" ); 
	add_name( "american", "Anthony" ); 
	add_name( "american", "Bickell" ); 
	add_name( "american", "Bing" ); 
	add_name( "american", "Bojorquez" ); 
	add_name( "american", "Brainerd" ); 
	add_name( "american", "Buffaloe" ); 
	add_name( "american", "Bunting" );
	add_name( "american", "Conserva" ); 
	add_name( "american", "Curran" );
	add_name( "american", "DeHart" );
	add_name( "american", "Denny" ); 
	add_name( "american", "Dickinson" ); 
	add_name( "american", "Dionne" ); 
	add_name( "american", "Donlon" ); 
	add_name( "american", "Doron" ); 
	add_name( "american", "Draeger" ); 
	add_name( "american", "Dwyer" ); 
	add_name( "american", "Farrelly" ); 
	add_name( "american", "Feltrin" ); 
	add_name( "american", "Flamer" ); 
	add_name( "american", "Golding" ); 
	add_name( "american", "Grace" ); 
	add_name( "american", "Griffith" ); 
	add_name( "american", "Guzzo" ); 
	add_name( "american", "Houston" ); 
	add_name( "american", "James" ); 
	add_name( "american", "Joyal" ); 
	add_name( "american", "Keegan" ); 
	add_name( "american", "Keeney" ); 	
	add_name( "american", "King" ); 
	add_name( "american", "Kramer" ); 
	add_name( "american", "Krauss" ); 
	add_name( "american", "Kraeer" );
	add_name( "american", "Lamia" ); 
	add_name( "american", "Laufer" );
	add_name( "american", "Lehmkuhl" ); 
	add_name( "american", "Locke" );
	add_name( "american", "Lozano" );
	add_name( "american", "Mattis" );
	add_name( "american", "McCaul" ); 
	add_name( "american", "McCawley" ); 
	add_name( "american", "McGinley" ); 
	add_name( "american", "Morelli" ); 
	add_name( "american", "Mulcahy" ); 
	add_name( "american", "Niebel" ); 
	add_name( "american", "Nouriani" ); 
	add_name( "american", "Oughton" ); 
	add_name( "american", "Petty" ); 
	add_name( "american", "Pierce" ); 
	add_name( "american", "Pierro" ); 
	add_name( "american", "Porter" ); 
	add_name( "american", "Roche" ); 
	add_name( "american", "Romo" ); 
	add_name( "american", "Sandler" ); 
	add_name( "american", "Schoonover" ); 
	add_name( "american", "Seibert" ); 
	add_name( "american", "Shubert" ); 
	add_name( "american", "Slayback" ); 
	add_name( "american", "Snider" ); 
	add_name( "american", "Snyder" ); 
	add_name( "american", "Souders" ); 
	add_name( "american", "Stastny" ); 
	add_name( "american", "Stoll" ); 
	add_name( "american", "Takacs" ); 
	add_name( "american", "Thompkins" ); 
	add_name( "american", "Tuey" ); 
	add_name( "american", "Vonderhaar" ); 	
	add_name( "american", "Walker" ); 
	add_name( "american", "Westfield" ); 
	add_name( "american", "Whitney" );
	add_name( "american", "Zaring" ); 
	add_name( "american", "Zide" ); 	
	add_name( "american", "Zielinski" ); 

	// Publisher Names:
	add_name( "american", "Arrasmith" );
	add_name( "american", "Chassereau" );
	add_name( "american", "Dalbotten" ); 
	add_name( "american", "Doornink" ); 
	add_name( "american", "Griffith" ); 
	add_name( "american", "Heller" ); 
	add_name( "american", "Livingston" );
	add_name( "american", "Lyman" ); 
	add_name( "american", "Malamed" ); 
	add_name( "american", "Racca" );
	add_name( "american", "Stohl" );
	add_name( "american", "Suarez" );
	add_name( "american", "Tippl" ); 
	add_name( "american", "Taubel" );
	add_name( "american", "Thompson" );
	add_name( "american", "Welch" );

	// Friend Names:
	add_name( "american", "Alderson" ); 
	add_name( "american", "Beunafe" ); 
	add_name( "american", "Christensen" ); 
	add_name( "american", "Duran" ); 
	add_name( "american", "Frazier" ); 
	add_name( "american", "Freeman" ); 
	add_name( "american", "Hanrahan" ); 
	add_name( "american", "Gage" ); 
	add_name( "american", "Grijalva" ); 
	add_name( "american", "Keys" );
	add_name( "american", "Klein" ); 
	add_name( "american", "Lingwood" ); 
	add_name( "american", "Menslage" );
	add_name( "american", "Misun" );
	add_name( "american", "O'Neill" );
	add_name( "american", "Parker" ); 
	add_name( "american", "Post" ); 
	add_name( "american", "Rickabaugh" ); 
	add_name( "american", "Salem" ); 
	add_name( "american", "Scarpa" ); 
	add_name( "american", "Southgate" );
	add_name( "american", "Wallace" );
	add_name( "american", "Westman" );
	add_name( "american", "Wilson" );

	// Contest Winner Names:
	add_name( "american", "Aholt" ); 
	add_name( "american", "Halmich" ); 
	add_name( "american", "Hamann" ); 
	add_name( "american", "Thornton" ); 
}

british_names()
{
	// Generic Names
	add_name( "british", "Abbot" ); 
	add_name( "british", "Bartlett" ); 
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
	add_name( "british", "Welsh" ); 

	// DevTeam Names:
	add_name( "british", "Adams" ); 
	add_name( "british", "Gascoine" ); 
	add_name( "british", "Houston" ); 

	// Friend Names:
	add_name( "british", "Alexander" );
	add_name( "british", "Baker" );
	add_name( "british", "Browne" ); 
	add_name( "british", "DiCarlo" ); 
	add_name( "british", "Dilley" );
	add_name( "british", "Duffy" ); 
	add_name( "british", "Galbraith" );
	add_name( "british", "Gregory" );
	add_name( "british", "Hunter" ); 
	add_name( "british", "Jones" );
	add_name( "british", "MacKriell" );
	add_name( "british", "Mckenzie" );
	add_name( "british", "Salem" ); 
}

german_names()
{
	// Generic Names
	add_name( "german", "Adler" ); 
	add_name( "german", "Bader" ); 
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
	add_name( "german", "Weber" ); 

	// Friend Names:
	add_name( "german", "Leister" ); 
	add_name( "german", "Meyer" ); 
	add_name( "german", "Roser" ); 
	add_name( "german", "Shreckengost" ); 
}

japanese_names()
{
	// Generic Names
	add_name( "japanese", "Aichi" ); 
	add_name( "japanese", "Akita" ); 
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
	add_name( "japanese", "Yamanashi" ); 
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
	add_name( "russian", "Bockovich" ); 
	add_name( "russian", "Chihoski" ); 
	add_name( "russian", "Grzegorzek" );
	add_name( "russian", "Mehalek" ); 
	add_name( "russian", "Venesky" ); 
}

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
	if( !IsDefined( override ) && level.script == "credits" )
	{
		self.airank = "private"; 
		return; 
	}
	
	if( IsDefined( self.script_friendname ) )
	{
		if( self.script_friendname == "none" )
		{
			return; 
		}
		self.name = self.script_friendname; 
		getRankFromName( self.name ); 
		self notify( "set name and rank" ); 
		return; 
	}
	
	assert( IsDefined( level.names ) ); 
	
	if( self.team == "axis" )
	{
		if( self.voice == "japanese" )
		{
			get_name_for_nationality( "japanese" ); 
		}
		else
		{
			get_name_for_nationality( "german" ); 
		}
	}
	else if( self.voice == "british" )
	{
		get_name_for_nationality( "british" ); 
	}
	else if( self.voice == "russian" )
	{
		get_name_for_nationality( "russian" ); 
	}
	else
	{
		get_name_for_nationality( "american" ); 
	}
	
	self notify( "set name and rank" ); 
}

get_name_for_nationality( nationality )
{
	assertex( IsDefined( level.nameIndex[nationality] ), nationality ); 
	
	level.nameIndex[nationality] = ( level.nameIndex[nationality] + 1 ) % level.names[nationality].size; 
	lastname = level.names[nationality][level.nameIndex[nationality]]; 

	rank = RandomInt( 100 ); 
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
	
	if( self.team == "axis" )
	{
		self.ainame = fullname; 
	}
	else
	{
		self.name = fullname; 
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
		println( "sentient has invalid rank " + shortRank + "!" ); 
		self.airank = "private"; 
		break; 
	}
}
