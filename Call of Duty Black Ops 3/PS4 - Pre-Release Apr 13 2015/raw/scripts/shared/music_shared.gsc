    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace name;

function setup()
{
	assert( !isdefined( level.names ) );

	//Init arrays
	level.names = [];
	level.namesIndex = [];
	
	if( !isdefined( level.script ) )
	{
		level.script = toLower( GetDvarString( "mapname" ) );	
	}

	//Setup default names list
	initialize_nationality( "american" );
}

function initialize_nationality( str_nationality )
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

//*7-22-13* Please note, some old nationalities have been cleaned up. If you need names for any of the nationalities commented below,
//please check the p4 history and bring back what you need as those names have likely been approved by legal(but will need to be done again).
// Afghan
// Angolan
// British
// Cuban
// German
// Japanese
// Nicaraguan
// Pakastani
// Panamanian
// Yemeni
function add_nationality_names( str_nationality )
{
	switch( str_nationality )
	{
		case "american":
			american_names();
			break;
			
		case "chinese":
			chinese_names();
			break;
			
		case "russian":
			russian_names();
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
			
		case "navy":
			navy_names();
			break;
			
		case "security":
			security_names();
			break;

		default:
			AssertMsg("Name list does not exist for " + str_nationality);
			break;
	}
}

function american_names()
{
	// Generic Names
	add_name( "american", "Adams" );
	add_name( "american", "Allen" );
	add_name( "american", "Anthony" );
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

function russian_names()
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
function agent_names()
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


function chinese_names()
{
	add_name( "chinese", "Chan" );
	add_name( "chinese", "Cheng" );
	add_name( "chinese", "Chiang" );
	add_name( "chinese", "Feng" );
	add_name( "chinese", "Guan" );
	add_name( "chinese", "Hu" );
	add_name( "chinese", "Lai" );
	add_name( "chinese", "Leung" );
	add_name( "chinese", "Wu" );
	add_name( "chinese", "Zheng" );
}

function navy_names()
{
	add_name( "navy", "Buckner" );
	add_name( "navy", "Coffey" );
	add_name( "navy", "Dashnaw" );
	add_name( "navy", "Dobson" );
	add_name( "navy", "Frank" );
	add_name( "navy", "Frey" );
	add_name( "navy", "Howe" );
	add_name( "navy", "Johns" );
	add_name( "navy", "Lee" );
	add_name( "navy", "Lockhart" );
	add_name( "navy", "Moon" );
	add_name( "navy", "Paiser" );
	add_name( "navy", "Preston" );
	add_name( "navy", "Reyes" );
	add_name( "navy", "Slater" );
	add_name( "navy", "Waller" );
	add_name( "navy", "Wong" );
	add_name( "navy", "Velasquez" );
	add_name( "navy", "York" );
}

function police_names()
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

function security_names()
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

function seal_names()
{
	add_name( "seal", "Adams" );
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
	add_name( "seal", "Maestas" );
	add_name( "seal", "Mitchell" );
	add_name( "seal", "Nelson" );
	add_name( "seal", "Rodriguez" );
	add_name( "seal", "Scott" );
	add_name( "seal", "Walker" );
	add_name( "seal", "Weichert" );
	add_name( "seal", "Wright" );
	add_name( "seal", "Young" );
}

//Begin name functions

function add_name( nationality, thename )
{
	level.names[nationality][level.names[nationality].size] = thename;
}

function randomize_name_list( nationality )
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

function get( override )
{
	if( !isdefined( override ) && level.script == "credits" )
	{
		self.airank = "private";
		self notify( "set name and rank" );
		return;
	}
	
	if( isdefined( self.script_friendname ) )
	{
		if( self.script_friendname == "none" )
		{
			self.properName = "";
		}
		else
		{
			self.properName = self.script_friendname;
			getRankFromName( self.properName );
		}
		self notify( "set name and rank" );
		return;
	}
	
	assert( isdefined( level.names ) );
	
	str_classname = self get_ai_classname();
	str_nationality = "american";//Default nationality
	
	if( IsSubStr( str_classname, "_civilian_" ) )//Civilian
	{
		self.airank = "none";
		str_nationality = "civilian";
	}
	else if( self is_special_agent_member(str_classname) )//Special Agent
	{
		str_nationality = "agent";
	}
	else if( IsSubStr( str_classname, "_sco_" ) )	//Chinese
	{
		self.airank = "none";
		str_nationality = "chinese";
	}
	else if( self is_police_member(str_classname) )//Police
	{
		str_nationality = "police";
	}
	else if( self is_seal_member(str_classname) )//SEAL
	{
		str_nationality = "seal";
	}
	else if( self is_navy_member(str_classname) )//NAVY
	{
		str_nationality = "navy";
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

	initialize_nationality( str_nationality );
	get_name_for_nationality( str_nationality );//Defaults to 'American'
	
	self notify( "set name and rank" );
}

function get_ai_classname()
{
	if( isdefined( self.dr_ai_classname ) )
	{
		str_classname = tolower( self.dr_ai_classname );
	}
	else
	{
		str_classname = tolower( self.classname );
	}
	
	return str_classname;
}

function add_override_name_func(nationality, func)
{
	if( !isdefined(level._override_name_funcs) )
	{
		level._override_name_funcs = [];
	}

	assert( !isdefined(level._override_name_funcs[nationality]), "Setting a name override function twice.");

	level._override_name_funcs[nationality] = func;
}

function get_name_for_nationality( nationality )
{
	assert( isdefined( level.nameIndex[nationality] ), nationality );

	//kdrew 6/1/2010 - Added overloading name functions for nationalities
	if( isdefined( level._override_name_funcs) && isdefined( level._override_name_funcs[nationality] ) )
	{
		self.properName = [[ level._override_name_funcs[nationality] ]]();

		//a rank must be assigned for squadmanager
		self.airank = "";

		return;
	}
	
	if( nationality == "civilian" )
	{
		self.properName = "";
		return;
	}
	
	level.nameIndex[nationality] = ( level.nameIndex[nationality] + 1 ) % level.names[nationality].size;
	lastname = level.names[nationality][level.nameIndex[nationality]];

	if(!isdefined(lastname))
	{
		lastname = "";
	}

	if (isdefined(level._override_rank_func))
	{
		self [[level._override_rank_func]](lastname);
	}
	else if( isdefined(self.airank) && self.airank == "none")
	{
		self.properName = lastname;
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
		else if ( nationality == "navy" )
		{
			if( rank > 60 )
			{
				fullname = "SN " + lastname;
				self.airank = "seaman";
			}
			else if( rank > 20 )
			{
				fullname = "PO " + lastname;
				self.airank = "petty officer";
			}
			else
			{
				fullname = "CPO " + lastname;
				self.airank = "chief petty officer";
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
			fullname = "Officer " + lastname;
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
			self.properName = fullname;
		}*/
		
		self.properName = fullname;
	}
}

function is_seal_member(str_classname)
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

function is_navy_member(str_classname)
{
	if( IsSubStr( str_classname, "_navy_" ) )
	{
		return true;
	}
	else
	{
		return false;
	}
}

function is_police_member(str_classname)
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

function is_security_member( str_classname )
{
	if( IsSubStr( str_classname, "_security_" ) )
	{
		return true;
	}
	
	return false;
}

function is_special_agent_member(str_classname)
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

function getRankFromName( name )
{
	if( !isdefined( name ) )
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

function issubstr_match_any( str_match, str_search_array)
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
