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
	add_name( "american", "Sloan" ); 
	add_name( "american", "Scott" ); 
	add_name( "american", "Stohl" ); 
	add_name( "american", "Suarez" ); 
	add_name( "american", "Thompson" ); 
	add_name( "american", "Welch" ); 
	
	// DevTeam Names:

	// Publisher Names:

	// Friend Names:
}

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
	else if( self.voice == "russian" || self.voice == "russian_english" )
	{
		get_name_for_nationality( "russian" ); 
	}
	else
	{
		get_name_for_nationality( "american" ); 
	}
	
	self notify( "set name and rank" ); 
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
	else
	{
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
