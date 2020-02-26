// random weapon
//=====================
//
// This file works primarily with random weapon generation of AITypes when they spawn in.
// 



#include animscripts\Utility;
#include maps\_utility;
#include common_scripts\Utility;

#insert raw\common_scripts\utility.gsh;

// Should only be run during the first init of the animscripts
// Build the array of weapons that the AI can drop based on it's current weapon
create_weapon_drop_array() //self == global anim object
{
	flag_init("weapon_drop_arrays_built");
	level thread override_weapon_drop_weights_by_level();
	
	//-- All of the non-level-specific weapons
	primary_weapons = array( 	"spectre", "uzi", "mp5k", "mac11", "skorpion", "kiparis", "mpl", "pm63", "ak74u", "aug",
														"galil", "enfield", "m14", "ak47", "famas", "commando", "g11", "m16", "fnfal",
														"m60", "stoner63", "hk21", "rpk" );
	
	//-- split because array() maxes at 26 params													
	primary_weapons_2 = array("asp", "cz75", "m1911", "makarov", "python",
														"psg1", "wa2000", "dragunov", "l96a1",
														"ithaca", "hs10", "spas", "rottweil71" );

	primary_weapons = ArrayCombine(primary_weapons, primary_weapons_2, true, false);
	
	//-- all of the available attachments and alternate weapons														
	primary_weapon_attachments = [];
	primary_weapon_attachments["sites"] = array( "acog", "elbit", "ir", "reflex");
	primary_weapon_attachments["ammo"] = array( "extclip", "dualclip" );
	primary_weapon_attachments["barrel"] = array( "silencer" );
	primary_weapon_attachments["auto"] = array( "auto" );
	primary_weapon_alts = array( "ft", "gl", "mk" );
	
	_sp = "_sp"; //-- for adding to the weapon name
	
	anim.droppable_weapons = [];
	
	attachment_categories = array("sites", "ammo", "barrel", "auto");
	
	for(i = 0; i < primary_weapons.size; i++)
	{	
		base_weapon = primary_weapons[i] + _sp;
		anim.droppable_weapons[ base_weapon ] = [];
		
		for(l = 0; l < attachment_categories.size; l++ )
		{
			anim.droppable_weapons[ base_weapon ][ attachment_categories[l] ] = [];
			
			for(j = 0; j < primary_weapon_attachments[attachment_categories[l]].size; j++)
			{
				new_weapon = primary_weapons[i] + "_" + primary_weapon_attachments[attachment_categories[l]][j] + _sp;
				if(IsAssetLoaded("weapon", new_weapon))
				{
					ARRAY_ADD(anim.droppable_weapons[base_weapon][attachment_categories[l]], new_weapon);
				}
			}
		}
			
		anim.droppable_weapons[base_weapon]["alt_weapon"] = [];
		
		for(j = 0; j < primary_weapon_alts.size; j++)
		{
			new_weapon = primary_weapon_alts[j] + "_" + primary_weapons[i] + _sp;
			
			if(IsAssetLoaded("weapon", new_weapon))
			{
				//ARRAY_ADD(anim.droppable_weapons[base_weapon]["alt_weapon"], new_weapon);
				
				//-- re-assemble the new weapon into the non-attachment version
				new_weapon = primary_weapons[i] + "_" + primary_weapon_alts[j] + _sp;
				ARRAY_ADD(anim.droppable_weapons[base_weapon]["alt_weapon"], new_weapon);
			}
		}
	}
	
	
	//-- build the weighted arrays for each ai class ( "VC", "NVA", "Spetsnaz", "RU", "CU" )
	//build_weight_arrays_by_ai_class( _ai_class, _overwrite, _base_weapon, _scoped_attachment, _ammo_attachment, _alt_weapon )
	build_weight_arrays_by_ai_class( "VC", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "NVA", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "Spetsnaz", false, 50, 25, 25, 25 );
	build_weight_arrays_by_ai_class( "RU", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "CU", false, 50, 25, 25, 10 );
	
	// allies
	build_weight_arrays_by_ai_class( "Marines", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "Blackops", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "Specops", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "UWB", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "Rebels", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "Prisoners", false, 50, 25, 25, 10 );
	build_weight_arrays_by_ai_class( "hazmat", false, 50, 25, 25, 10 );
	
	
	//-- vars for controlling the drops
	if(!IsDefined(level.rw_enabled))
	{
		level.rw_enabled = true;
	}
	
	if(!IsDefined(level.rw_attachments_allowed))
	{
		level.rw_attachments_allowed = false;
	}
	
	if(!IsDefined(level.rw_gl_allowed))
	{
		level.rw_gl_allowed = true;
	}
	
	if(!IsDefined(level.rw_mk_allowed))
	{
		level.rw_mk_allowed = true;
	}
	
	if(!IsDefined(level.rw_ft_allowed))
	{
		level.rw_ft_allowed = true;
	}
	
	flag_set("weapon_drop_arrays_built");
	
}



//-- Add an entry to anim.droppable_weapons[ _ai_class ] that holds the weights for the different attachment types
build_weight_arrays_by_ai_class( _ai_class, _overwrite, _base_weapon, _scoped_attachment, _ammo_attachment, _alt_weapon )
{
	if(IsDefined(anim.droppable_weapons[_ai_class]) && !_overwrite)
	{
		return;
	}
	
	anim.droppable_weapons[ _ai_class ] = [];
	anim.droppable_weapons[ _ai_class ][ "base" ] = _base_weapon;
	anim.droppable_weapons[ _ai_class ][ "sites" ] = _scoped_attachment;
	anim.droppable_weapons[ _ai_class ][ "ammo" ] = _ammo_attachment;
	anim.droppable_weapons[ _ai_class ][ "alt_weapon" ] = _alt_weapon;
}



get_weapon_name_with_attachments(weapon_name)
{
	//-- an AI that has not been spawned and shows up before the player does
	if(!IsDefined(anim.droppable_weapons))
	{
		return weapon_name;
	}
	
	//-- Level Designer disabled this feature
	if(!level.rw_enabled)
	{
		return weapon_name;
	}
	
	//-- if no alternates for this weapon then return base weapon
	if(!IsDefined(anim.droppable_weapons[weapon_name]) || anim.droppable_weapons[weapon_name].size == 0)
	{
		return weapon_name;
	}
	
	//-- if ai class does not have a weight array defined then return base weapon
	ai_class = get_ai_class_for_weapon_drop( self.classname );
	if(ai_class == "not_defined" || !IsDefined(anim.droppable_weapons[ai_class]))
	{
		return weapon_name;
	}
	
	//-- choose a weapon based on the weight table
	//keys = GetArrayKeys(anim.droppable_weapons[ai_class]);
	keys = array( "base", "sites", "ammo", "alt_weapon" ); //-- "alt_weapon" needs to be last
	
	total_weight = 0;
	for(i=0; i<keys.size; i++)
	{
		if(keys[i] == "alt_weapon")
		{
			if(level.rw_attachments_allowed)
			{
				total_weight += anim.droppable_weapons[ ai_class ][ keys[i] ]; //-- only add attachments if this level var is set to true
			}
			/*
			else
			{
			 	don't add this to the weight.  This only works as long as attachments are always the last category
			}
			*/
		}
		else
		{
			total_weight += anim.droppable_weapons[ ai_class ][ keys[i] ];
		}
	}
								 
	//-- if the total weight of all the attachment types is 0 then return the bas weapon
	if(total_weight == 0)
	{
		
		return weapon_name;
	}
	
	//-- total weight is not zero, so try and find an appropriate weapon
	random_choice = RandomInt(total_weight);
	
	current_key = "none";
	current_weight = 0;
	for(i = 0; i < keys.size; i++)
	{
		current_key = keys[i];
		current_weight += anim.droppable_weapons[ai_class][keys[i]];
		if(random_choice < current_weight)
		{
			break;
		}
	}
	
	//-- it chose the base weapon!
	if(current_key == "base")
	{
		return weapon_name;
	}
	
	//-- If there are no options for this key, then return the base weapon
	if(anim.droppable_weapons[weapon_name][current_key].size == 0)
	{
		return weapon_name;
	}
	
	
	//-- return a weapon with an attachment
	if( current_key != "alt_weapon" )
	{
		random_weap_int = RandomInt(anim.droppable_weapons[weapon_name][current_key].size);	
		return anim.droppable_weapons[weapon_name][current_key][random_weap_int];
	}
	else //-- this is specific for alternate weapons to make sure each type is allowed
	{
		assert( level.rw_attachments_allowed, "Trying to give an attachment that is not valid.  Talk to GLocke if you hit this assert." );
		
		possible_alt_weapons = anim.droppable_weapons[weapon_name][current_key];
		
		//-- construct allowed drops array
		if( !level.rw_gl_allowed )
		{
			for( x = 0; x < possible_alt_weapons.size; x++)
			{
				if( IsSubStr( possible_alt_weapons[x], "_gl_" ) )
				{
					ArrayRemoveValue( possible_alt_weapons, possible_alt_weapons[x] );
					break;
				}
			}
		}
		
		if( !level.rw_mk_allowed )
		{
			for( x = 0; x < possible_alt_weapons.size; x++)
			{
				if( IsSubStr( possible_alt_weapons[x], "_mk_" ) )
				{
					ArrayRemoveValue( possible_alt_weapons, possible_alt_weapons[x] );
					break;
				}
			}
		}
	
		if( !level.rw_ft_allowed )
		{
			for( x = 0; x < possible_alt_weapons.size; x++)
			{
				if( IsSubStr( possible_alt_weapons[x], "_ft_" ) )
				{
					ArrayRemoveValue( possible_alt_weapons, possible_alt_weapons[x] );
					break;
				}
			}
		}
		
		if(possible_alt_weapons.size == 0)
		{
			return weapon_name;
		}
		else
		{
			random_weapon_int = RandomInt(possible_alt_weapons.size);
			return possible_alt_weapons[random_weapon_int];
		}
	}
}

get_ai_class_for_weapon_drop( _classname )
{
	
	//-- Possibilities: "VC", "NVA", "Spetsnaz", "RU", "CU"
	if(IsSubStr( _classname, "Spetsnaz_e"))
	{
		return("Spetsnaz");
	}
	else if(IsSubStr( _classname, "NVA_e" ))
	{
		return("NVA");
	}
	else if(IsSubStr( _classname, "VC_e" ))
	{
		return("VC");
	}
	else if(IsSubStr( _classname, "RU_e" ))
	{
		return("RU");
	}
	else if(IsSubStr( _classname, "CU_e"))
	{
		return("CU");
	}
	else if(IsSubstr( _classname,"USMarines"))
	{
		return("Marines");
	}
	else if(IsSubstr( _classname,"USBlackops"))
	{
		return("Blackops");
	}
	else if(IsSubstr( _classname,"USSpecs"))
	{
		return("Specops");
	}
	else if(IsSubstr( _classname,"UWB"))
	{
		return("UWB");
	}
	else if(IsSubstr( _classname,"CU_a"))
	{
		return("Rebels");
	}
	else if(IsSubstr( _classname,"Prisoner"))
	{
		return("Prisoners");
	}
	else if(IsSubstr( _classname,"a_hazmat"))
	{
		return("hazmat");
	}	
	
	return( "not_defined" );
}

/*------------------------------------
levels can have their own weights 


------------------------------------*/
override_weapon_drop_weights_by_level()
{

	//wait for the level script to load and for the weight arrays to be initialized
	while( !isDefined(level.script) || !flag("weapon_drop_arrays_built") )
	{
		wait(.1);
	}
	
	switch(level.script)
	{		
		case "cuba":
				level.rw_attachments_allowed = true;
				//build_weight_arrays_by_ai_class( _ai_class, _overwrite, _base_weapon, _scoped_attachment, _ammo_attachment, _alt_weapon )
				build_weight_arrays_by_ai_class( "CU", true, 50, 20, 75, 20);
				build_weight_arrays_by_ai_class( "Rebels", true, 50, 10, 50, 15 );
			break;		
		
		case "vorkuta":		
				level.rw_attachments_allowed = true;
				build_weight_arrays_by_ai_class( "RU", true, 50, 0, 60, 40);
				build_weight_arrays_by_ai_class( "Prisoners", true, 50, 0, 60, 40 );
			break;	
	
		case "flashpoint":
				level.rw_attachments_allowed = true;
				build_weight_arrays_by_ai_class( "RU", true, 50, 30, 40, 10);
				build_weight_arrays_by_ai_class( "Spetsnaz", true, 50, 30, 40, 10);
			break;	
		
		case "khe_sanh":
				level.rw_attachments_allowed = true;
				build_weight_arrays_by_ai_class( "NVA", true, 40, 20, 50, 20);
				build_weight_arrays_by_ai_class( "Marines", true, 40, 60, 40, 30);
			break;			
		
		case "hue_city":	
				level.rw_attachments_allowed = true;	
				build_weight_arrays_by_ai_class( "Marines", true, 40, 25, 25, 15);
				build_weight_arrays_by_ai_class( "NVA", true, 50, 25, 25, 40 );
			break;
			
		case "kowloon":		
				build_weight_arrays_by_ai_class( "Spetsnaz", true, 50, 40, 60, 15);
				build_weight_arrays_by_ai_class( "Blackops", true, 50, 40, 60, 15 );
			break;

		case "creek_1":	
				level.rw_attachments_allowed = true;	
				build_weight_arrays_by_ai_class( "Marines", true, 40, 45, 40, 10);
				build_weight_arrays_by_ai_class( "VC", true, 40, 20, 70, 15 );
			break;
						
		case "river":	
				level.rw_attachments_allowed = true;	
				build_weight_arrays_by_ai_class( "Marines", true, 40, 35, 15, 10);
				build_weight_arrays_by_ai_class( "VC", true, 60, 15, 15, 15 );
			break;
		
		case "pow": 
				level.rw_attachments_allowed = true;
				build_weight_arrays_by_ai_class( "RU", true, 40, 35, 20, 10);
				build_weight_arrays_by_ai_class( "VC", true, 40, 35, 20, 10 );
				build_weight_arrays_by_ai_class( "Spetsnaz", true, 30, 50, 35, 10 );
				build_weight_arrays_by_ai_class( "Marines", true, 40, 35, 20, 10 );
			break;
			
		case "fullahead":		
			break;
			
		case "wmd":
		case "wmd_sr71":
				level.rw_attachments_allowed = true;
				build_weight_arrays_by_ai_class( "RU", true, 50, 20, 15, 10);
				build_weight_arrays_by_ai_class( "Spetsnaz", true, 50, 20, 15, 10 );
				build_weight_arrays_by_ai_class( "Blackops", true, 0, 100, 15, 10 );
			break;
			
		case "rebirth":
				level.rw_attachments_allowed = true;	
				build_weight_arrays_by_ai_class( "RU", true, 30, 40, 30, 20);
				build_weight_arrays_by_ai_class( "Spetsnaz", true, 30, 40, 20, 15 );
				build_weight_arrays_by_ai_class( "hazmat", true, 0, 100, 100, 10 );
			break;

		case "underwaterbase":
				level.rw_attachments_allowed = true;	
				build_weight_arrays_by_ai_class( "RU", true, 30, 50, 50, 20);
				build_weight_arrays_by_ai_class( "Spetsnaz", true, 40, 30, 50, 20 );
				build_weight_arrays_by_ai_class( "UWB", true, 30, 50, 50, 20 );
			break;
			
		case "default":
			break;						
	}
}


//cammo types ( 0-14 )
//0,camo,cammo_gunmetal,cammo_gunplastic,cammo_wood_tile_red,od_green_aug,cammo_tan_enfield,,,
//1,camo,solid_camo_dusty,solid_camo_dusty,solid_camo_dusty,solid_camo_dusty,solid_camo_dusty,,,
//2,camo,solid_camo_ice,solid_camo_ice,solid_camo_ice,solid_camo_ice,solid_camo_ice,,,
//3,camo,cammo_red,cammo_red,cammo_red,cammo_red,cammo_red,,,
//4,camo,solid_camo_od,solid_camo_od,solid_camo_od,solid_camo_od,solid_camo_od,,,
//5,camo,camo_desert_nevada,solid_camo_desert_nevada,solid_camo_desert_nevada,camo_desert_nevada,camo_desert_nevada,,,
//6,camo,camo_desert_sahara,solid_camo_desert_sahara,solid_camo_desert_sahara,camo_desert_sahara,camo_desert_sahara,,,
//7,camo,camo_jungle_erdl,solid_camo_jungle_erdl,solid_camo_jungle_erdl,camo_jungle_erdl,camo_jungle_erdl,,,
//8,camo,camo_jungle_tiger,solid_camo_jungle_tiger,solid_camo_jungle_tiger,camo_jungle_tiger,camo_jungle_tiger,,,
//9,camo,camo_urban_german,solid_camo_urban_german,solid_camo_urban_german,camo_urban_german,camo_urban_german,,,
//10,camo,camo_urban_warsaw,solid_camo_urban_warsaw,solid_camo_urban_warsaw,camo_urban_warsaw,camo_urban_warsaw,,,
//11,camo,camo_winter_siberia,solid_camo_winter_siberia,solid_camo_winter_siberia,camo_winter_siberia,camo_winter_siberia,,,
//12,camo,camo_winter_yukon,solid_camo_winter_yukon,solid_camo_winter_yukon,camo_winter_yukon,camo_winter_yukon,,,
//13,camo,camo_woodland,solid_camo_woodland,solid_camo_woodland,camo_woodland,camo_woodland,,,
//14,camo,camo_woodland_flora,solid_camo_woodland_flora,solid_camo_woodland_flora,camo_woodland_flora,camo_woodland_flora,,,


/*------------------------------------
when an AI dies and drops their weapon they now have a chance to drop cammo based on level and weapon specific percentages
------------------------------------*/
set_random_cammo_drop()
{

	while( isDefined(self) )
	{
		self waittill("dropweapon",weapon);
		
		if(!isDefined(weapon) || !isDefined(weapon.classname))
		{
			continue;
		}
		
		weapon_class = get_weapon_type(weapon.classname);
		
		if(!isDefined(weapon_class))
		{
			return;
		}
		
		name = tolower(weapon.classname);
		
		switch(level.script)
		{		
			case "cuba":
					
				if(weapon_class == "assault")
				{
					if(randomint(100) >74)
					{
						weapon ItemWeaponSetOptions(9);
					}
				}
				else if(weapon_class == "lmg")
				{
					if( IsSubstr( name ,"rpk") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(14);
						}
					}
					else if( IsSubstr( name ,"m60") )
					{
						if(randomint(100) > 24)
						{
							weapon ItemWeaponSetOptions(9);
						}
					}				
				}
				else if( weapon_class == "launcher")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(14);
					}
				}								
				break;		
	//------------------------------------------------------------------		
			case "vorkuta":
			
				if(weapon_class == "assault" || weapon_class == "shotgun")
				{
					if(randomint(100) > 89)
					{
						weapon ItemWeaponSetOptions(12);
					}
				}			
				break;
	//------------------------------------------------------------------	
	
			case "flashpoint":
			
				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"ak47") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(14);
						}
					}
					else if( IsSubstr( name ,"mp5k") )
					{
						weapon ItemWeaponSetOptions(1);
					}				
				}
				
				else if(weapon_class == "smg")
				{
					if(randomint(100) > 74 )
					{
						weapon ItemWeaponSetOptions(5);
					}
				}
				
				else if(weapon_class == "sniper")
				{
					if(randomint(100) > 49 )
					{
						weapon ItemWeaponSetOptions(5);
					}
				}
				else if(weapon_class == "launcher")
				{
					weapon ItemWeaponSetOptions(6);
				}	
							
				break;
	//------------------------------------------------------------------	
			
			case "khe_sanh":
			
				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"m16") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(1);
						}
					}
					else if( IsSubstr( name ,"m14") )
					{
						if(randomint(100) > 56)
						{
							weapon ItemWeaponSetOptions(1);
						}
					}
					else if( IsSubstr( name ,"ak74") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(7);
						}
					}			
				}
	
				else if(weapon_class == "launcher")
				{
					if( IsSubstr( name ,"china") )
					{
						if(randomint(100) > 49)
						{
							weapon ItemWeaponSetOptions(6);
						}
					}
					else if( IsSubstr( name ,"tow") )
					{
						weapon ItemWeaponSetOptions(6);
					}
					else if( IsSubstr( name ,"law") )
					{
						weapon ItemWeaponSetOptions(1);
					}
					else if( IsSubstr( name ,"rpg") )
					{
						weapon ItemWeaponSetOptions(7);
					}		
				}
				
				else if(weapon_class == "shotgun")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(1);
					}
				}
				else if(weapon_class == "lmg")
				{
					if( IsSubstr( name ,"rpk") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(7);
						}
					}
					else if( isSubstr(name,"m60"))
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(1);
						}
					}
				}
				break;
	//------------------------------------------------------------------	
			
			case "hue_city":
				if(weapon_class == "shotgun")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(7);
					}
				}
				else if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"commando") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(9);
						}
					}
					else if( IsSubstr( name ,"fnfal") )
					{
						if(randomint(100) > 74)
						{
							weapon ItemWeaponSetOptions(7);
						}
					}
				}
				else if(weapon_class == "lmg")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(7);
					}
				}			
				break;
	//------------------------------------------------------------------	
				
			case "kowloon":
				break;
	
	//------------------------------------------------------------------	
	
			case "creek_1":	
				if(weapon_class == "sniper")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(9);
					}
				}	
				else if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"commando") )
					{
						if(randomint(100) > 79)
						{
							weapon ItemWeaponSetOptions(8);
						}
					}
					else if( IsSubstr( name ,"ak47") )
					{
						if(randomint(100) > 79)
						{
							weapon ItemWeaponSetOptions(13);
						}
					}
				}
	
				break;
	//------------------------------------------------------------------	
							
			case "river":		
				
				if(weapon_class == "sniper")
				{
					if(randomint(100) > 74)
					{
						weapon ItemWeaponSetOptions(9);
					}
				}	
				else if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"commando") )
					{
						weapon ItemWeaponSetOptions(13);
					}
					else if( IsSubstr( name ,"ak74") )
					{
						if(randomint(100) > 79)
						{
							weapon ItemWeaponSetOptions(9);
						}
					}
					else if( IsSubstr( name ,"m16") )
					{
						if(randomint(100) > 19)
						{
							weapon ItemWeaponSetOptions(13);
						}
					}
				}					
				else if(weapon_class == "smg")
				{
					if(randomint(100) > 49)
					{
						weapon ItemWeaponSetOptions(9);
					}
				}	
				else if(weapon_class == "shotgun")
				{
					if(randomint(100) > 49)
					{
						weapon ItemWeaponSetOptions(13);
					}
				}	
				else if(weapon_class == "launcher")
				{
					if(randomint(100) > 59)
					{
						weapon ItemWeaponSetOptions(13);
					}
				}	
				break;
	//------------------------------------------------------------------	

			case "pow": 

				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"ak47") || IsSubstr( name ,"galil") )
					{
						if(randomint(100) > 39)
						{
							weapon ItemWeaponSetOptions(14);
						}
					}
				}					
				else if(weapon_class == "smg")
				{
					if(randomint(100) > 49)
					{
						weapon ItemWeaponSetOptions(14);
					}
				}	
				else if(weapon_class == "shotgun")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(9);
					}
				}
				else if(weapon_class == "lmg")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(13);
					}
				}	
	
				break;
				
	//------------------------------------------------------------------	

			case "fullahead":
							
				weapon ItemWeaponSetOptions(2);					
				break;
	//------------------------------------------------------------------	
	
			case "wmd":
			case "wmd_sr71":
			
				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"famas") )
					{
						if(randomint(100) > 39)
						{
							weapon ItemWeaponSetOptions(2);
						}
					}
				}
				else if(weapon_class == "shotgun")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(11);
					}
				}
				else if(weapon_class == "lmg")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(11);
					}
				}
				else if(weapon_class == "smg")
				{
					if(randomint(100) > 39)
					{
						weapon ItemWeaponSetOptions(2);
					}
				}					
				break;
	//------------------------------------------------------------------	
	
			case "rebirth":		
				if(weapon_class == "launcher")
				{
					weapon ItemWeaponSetOptions(7);
				}
				else if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"enfield")  )
					{
						weapon ItemWeaponSetOptions(7);
					}
				}
				else if(weapon_class == "lmg")
				{
					if( IsSubstr( name ,"hk21")  )
					{
						weapon ItemWeaponSetOptions(7);
					}
				}
				break;
		//------------------------------------------------------------------	

			case "underwaterbase":		
				if(weapon_class == "assault")
				{
					if( IsSubstr( name ,"ak74")  )
					{
						weapon ItemWeaponSetOptions(7);
					}
				}
				break;
	//------------------------------------------------------------------	
			
			case "default":
				break;						
		}

	}
	

}

get_weapon_type(weapon_name)
{	
	//shotgun
	_classname = tolower(weapon_name);	
	
	if( IsSubstr( _classname,"ks23") || IsSubstr( _classname,"rottweil") || IsSubstr( _classname,"ithaca") || isSubstr(_classname,"spas"))
	{
		return "shotgun";
	}
		
	//assault rifle
	else if( IsSubstr( _classname,"m16") || IsSubstr( _classname,"fnfal") || IsSubstr( _classname,"ak47") ||IsSubstr( _classname,"ak74")|| isSubstr(_classname,"mp5k") || isSubstr(_classname,"m14") || IsSubstr( _classname,"commando") || IsSubstr( _classname,"g11") || IsSubstr( _classname,"aug")|| IsSubstr( _classname,"famas") || IsSubstr( _classname,"galil") || IsSubstr( _classname,"enfield"))
	{
		return "assault";
	}
	
	//smg
	else if( IsSubstr( _classname,"skorpion") || IsSubstr( _classname,"pm63") || IsSubstr( _classname,"kiparis") ||IsSubstr( _classname,"spectre")|| isSubstr(_classname,"uzi") || isSubstr(_classname,"ppsh") || IsSubstr( _classname,"mp40") || IsSubstr( _classname,"sten") || IsSubstr( _classname,"mp44")|| IsSubstr( _classname,"mac11"))
	{
		return "smg";
	}
	
	//lmg
	else if( IsSubstr( _classname,"rpk") || IsSubstr( _classname,"m60") || IsSubstr( _classname,"hk21") ||IsSubstr( _classname,"mg42")|| isSubstr(_classname,"stoner") )
	{
		return "lmg";
	}
	
	//sniper
	else if( IsSubstr( _classname,"dragon") || IsSubstr( _classname,"wa2000") || IsSubstr( _classname,"psg") )
	{
		return "sniper";
	}
		
	//launcher
	else if( IsSubstr( _classname,"tow") || IsSubstr( _classname,"rpg") || IsSubstr( _classname,"fhj18") ||IsSubstr( _classname,"strela") ||IsSubstr( _classname,"panzer")|| isSubstr(_classname,"china") || IsSubstr( _classname,"m202") || IsSubstr( _classname,"law"))
	{
		return "launcher";
	}	
		
}