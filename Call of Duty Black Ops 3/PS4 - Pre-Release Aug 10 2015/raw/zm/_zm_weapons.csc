#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;
#using scripts\zm\_zm_utility;

#namespace zm_weapons;

function is_weapon_included( weapon )
{
	if ( !isdefined( level._included_weapons ) )
	{
		return false;
	}

	return IsDefined( level._included_weapons[weapon.rootWeapon] );
}


function include_weapon( weapon_name, display_in_box )
{
	if ( !isdefined( level._included_weapons ) )
	{
		level._included_weapons = [];
	}

	weapon = GetWeapon( weapon_name );
	level._included_weapons[weapon] = weapon;

	if ( isdefined( display_in_box ) && !display_in_box )
	{
		return;
	}

	if ( !isdefined( level._resetZombieBoxWeapons ) )
	{
		level._resetZombieBoxWeapons = true;
		ResetZombieBoxWeapons();
	}
	
	if (!IsDefined(weapon.worldModel))
	{
		thread util::error( "Missing worldmodel for weapon " + weapon_name + " (or weapon may be missing from fastfile)." );
		return;
	}
	
	AddZombieBoxWeapon( weapon, weapon.worldModel, weapon.isDualWield );
}

function init()
{
	spawn_list = [];
	spawnable_weapon_spawns = struct::get_array( "weapon_upgrade", "targetname" );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "bowie_upgrade", "targetname" ), true, false );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "sickle_upgrade", "targetname" ), true, false );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "tazer_upgrade", "targetname" ), true, false );
	spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "buildable_wallbuy", "targetname" ), true, false );
	
	if ( ( isdefined( level.use_autofill_wallbuy ) && level.use_autofill_wallbuy ) )
	{
		spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, level.active_autofill_wallbuys, true, false );
	}
	
	if ( !( isdefined( level.headshots_only ) && level.headshots_only ) )
	{
		spawnable_weapon_spawns = ArrayCombine( spawnable_weapon_spawns, struct::get_array( "claymore_purchase", "targetname" ), true, false );
	}
	
	location = level.scr_zm_map_start_location;
	if ( (location == "default" || location == "") && IsDefined( level.default_start_location ) )
	{
		location = level.default_start_location;
	}	

	match_string = level.scr_zm_ui_gametype;
	if ( "" != location )
	{
		match_string = match_string + "_" + location;
	}
	match_string_plus_space = " " + match_string;

	for ( i = 0; i < spawnable_weapon_spawns.size; i++ )
	{
		spawnable_weapon = spawnable_weapon_spawns[i];

		spawnable_weapon.weapon = GetWeapon( spawnable_weapon.zombie_weapon_upgrade );
		if ( isDefined( spawnable_weapon.zombie_weapon_upgrade ) && spawnable_weapon.weapon.isGrenadeWeapon && ( isdefined( level.headshots_only ) && level.headshots_only ) )
		{
			continue;
		}
		
		if ( !isdefined( spawnable_weapon.script_noteworthy ) || spawnable_weapon.script_noteworthy == "" )
		{
			spawn_list[spawn_list.size] = spawnable_weapon;
		}
		else
		{
			matches = strTok( spawnable_weapon.script_noteworthy, "," );

			for ( j = 0; j < matches.size; j++ )
			{
				if ( matches[j] == match_string || matches[j] == match_string_plus_space )
				{
					spawn_list[spawn_list.size] = spawnable_weapon;
				}
			}
			
		}
	}

	level._active_wallbuys = [];
	
	for ( i = 0; i < spawn_list.size; i++ )
	{
		spawn_list[i].script_label = spawn_list[i].zombie_weapon_upgrade + "_" + spawn_list[i].origin;
		
		level._active_wallbuys[spawn_list[i].script_label] = spawn_list[i];

		numBits = 2;
		
		if ( isdefined( level._wallbuy_override_num_bits ) )
		{
			numBits = level._wallbuy_override_num_bits;
		}

		clientfield::register( "world", spawn_list[i].script_label, 1, numBits, "int", &wallbuy_callback, !true, true ); // 2 bit int client field - bit 1 : 0 = not bought 1 = bought.  bit 2: 0 = not hacked 1 = hacked.
		
		target_struct = struct::get( spawn_list[i].target, "targetname" );
		
		if ( spawn_list[i].targetname == "buildable_wallbuy" )
		{
			bits = 4;
			if ( IsDefined( level.buildable_wallbuy_weapons ) )
			{
				bits = GetMinBitCountForNum( level.buildable_wallbuy_weapons.size + 1 );
			}
			clientfield::register( "world", spawn_list[i].script_label + "_idx", 1, bits, "int", &wallbuy_callback_idx, !true, true ); 
		}
	}

	callback::on_localclient_connect( &wallbuy_player_connect );
}

function wallbuy_player_connect( localClientNum )
{
	keys = GetArrayKeys( level._active_wallbuys );
	
	/# println( "Wallbuy connect cb : " + localClientNum ); #/
	
	for ( i = 0; i < keys.size; i++ )
	{
		wallbuy = level._active_wallbuys[keys[i]];

		fx = level._effect["870mcs_zm_fx"];

		if ( isdefined( level._effect[wallbuy.zombie_weapon_upgrade + "_fx"] ) )
		{
			fx = level._effect[wallbuy.zombie_weapon_upgrade + "_fx"];
		}

//TEMP Comment out until we get a glow FX without outline.
//		wallbuy.fx[localClientNum] = playfx( localClientNum, fx, wallbuy.origin, AnglesToForward( wallbuy.angles ), AnglesToUp( wallbuy.angles ), 0.1 );

		target_struct = struct::get( wallbuy.target, "targetname" );

		target_model = zm_utility::spawn_buildkit_weapon_model( localClientNum, wallbuy.weapon, undefined, target_struct.origin, target_struct.angles );
		target_model Hide();
		target_model.parent_struct = target_struct;

		wallbuy.models[localClientNum] = target_model;
	}
}

function wallbuy_callback( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( bInitialSnap )
	{
		while ( !isdefined( level._active_wallbuys ) || !isdefined( level._active_wallbuys[fieldName] ) )
		{
			wait 0.05;
		}
	}
	
	struct = level._active_wallbuys[fieldName];

	/# println("wallbuy callback " + localClientNum); #/
	
	switch ( newVal )
	{
		case 0:
			struct.models[localClientNum].origin = struct.models[localClientNum].parent_struct.origin;
			struct.models[localClientNum].angles = struct.models[localClientNum].parent_struct.angles;
			struct.models[localClientNum] hide();			
		break;
			
		case 1:
			if ( bInitialSnap )
			{
				if ( !isdefined( struct.models ) )
				{
					while ( !isdefined( struct.models ) )
					{
						wait( 0.05 );	// When hot joining, buildable wallbuys may not have executed their callback yet, which will set up the model arrays... wait til it has.
					}
					
					while ( !isdefined( struct.models[localClientNum] ) )
					{
						wait( 0.05 );	// When hot joining, buildable wallbuys may not have executed their callback yet, which will set up the model arrays... wait til it has.
					}
					                               	
				}
				
				struct.models[localClientNum] show();
				struct.models[localClientNum].origin = struct.models[localClientNum].parent_struct.origin;
			}
			else
			{
				wait( 0.05 );
	
				if ( localClientNum == 0 )
				{
					playsound( 0, "zmb_weap_wall", struct.origin );
				}
				
				vec_offset = (0,0,0);
				
				if ( isDefined( struct.models[localClientNum].parent_struct.script_vector ) )
				{
					vec_offset = struct.models[localClientNum].parent_struct.script_vector;
				}
				
				struct.models[localClientNum].origin = struct.models[localClientNum].parent_struct.origin + (AnglesToRight( struct.models[localClientNum].angles + vec_offset) * 8);
				struct.models[localClientNum] show();
				struct.models[localClientNum] moveto( struct.models[localClientNum].parent_struct.origin, 1 );
			}			
		break;
		
		case 2:
			if ( isdefined( level.wallbuy_callback_hack_override ) )
			{
				struct.models[localClientNum] [[ level.wallbuy_callback_hack_override ]]();
			}
		break;
	}
}

function wallbuy_callback_idx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	basefield = GetSubStr( fieldName, 0, fieldName.size - 4 );
	struct = level._active_wallbuys[basefield];

	if ( newVal == 0 )
	{
		if ( isdefined( struct.models[localClientNum] ) )
		{
			struct.models[localClientNum] hide();
		}
	}
	else if ( newVal > 0 )
	{
		weaponname = level.buildable_wallbuy_weapons[newVal - 1];
		weapon = GetWeapon( weaponname );
		
		if ( !isdefined( struct.models ) )
		{
			struct.models = [];
		}

		if ( !isdefined( struct.models[localClientNum] ) )
		{
			target_struct = struct::get( struct.target, "targetname" );
			
			model = undefined;
			if ( isdefined( level.buildable_wallbuy_weapon_models[weaponname] ) )
			{
				model = level.buildable_wallbuy_weapon_models[weaponname];
			}

			angles = target_struct.angles;
			if ( isdefined(level.buildable_wallbuy_weapon_angles[weaponname] ) )
			{
				switch ( level.buildable_wallbuy_weapon_angles[weaponname] )
				{
					case 90:  angles = VectorToAngles( AnglesToRight( angles ) ); break;
					case 180: angles = VectorToAngles( -AnglesToForward( angles ) ); break;
					case 270: angles = VectorToAngles( -AnglesToRight( angles ) ); break;
				}
			}
			
			target_model = zm_utility::spawn_buildkit_weapon_model( localClientNum, weapon, undefined, target_struct.origin, angles); 
			target_model Hide();
			target_model.parent_struct = target_struct;
			
			struct.models[localClientNum] = target_model;
			if ( isdefined(struct.fx[localClientNum] ) )
			{
				StopFX( localClientNum, struct.fx[localClientNum] );
				struct.fx[localClientNum] = undefined;
			}
			
			fx = level._effect["870mcs_zm_fx"];
			
			if ( isdefined( level._effect[weaponname + "_fx"] ) )
			{
				fx = level._effect[weaponname + "_fx"];
			}
			
			struct.fx[localClientNum] = playfx( localClientNum, fx, struct.origin, AnglesToForward( struct.angles ), AnglesToUp( struct.angles ), 0.1 );
			
			level notify( "wallbuy_updated" );
		}
	}
}


















	
function checkStringValid( str )
{
	if( str != "" )
		return str;
	return undefined;
}

function load_weapon_spec_from_table( table, first_row )
{
	gametype = GetDvarString( "ui_gametype" );
	index = 1;
	row = TableLookupRow( table, index );
	while ( isdefined( row ) )
	{
		//Get this weapons data from the current tablerow
		weapon_name 		= checkStringValid( row[0] );
		upgrade_name 		= checkStringValid( row[1] );
		hint 				= checkStringValid( row[2] );
		cost 				= int( row[3] );
		weaponVO			= checkStringValid( row[4] );
		weaponVOresp 		= checkStringValid( row[5] );
		ammo_cost 			= int( row[6] );
		create_vox 			= checkStringValid( row[7] );
		is_zcleansed 		= (ToLower( row[8] ) == "true");
		in_box 				= (ToLower( row[9] ) == "true");
		upgrade_in_box 		= (ToLower( row[10] ) == "true");
		is_limited 			= (ToLower( row[11] ) == "true");
		limit 				= int( row[12] );
		upgrade_limit 		= int( row[13] );
		content_restrict 	= row[14];
		wallbuy_autospawn 	= (ToLower( row[15] ) == "true");
		weapon_class 		= checkStringValid( row[16] );

		//Now use this data to include the weapon
		zm_weapons::include_weapon( weapon_name, in_box );
		if ( isdefined( upgrade_name ) )
		{
			zm_weapons::include_weapon( upgrade_name, upgrade_in_box );
		}
		
		/*
		weapon = GetWeapon( weapon_name );
		if ( !isdefined( level.wallbuy_autofill_weapons ) )
		{
			level.wallbuy_autofill_weapons = [];
			level.wallbuy_autofill_weapons["all"] = [];
		}
		level.wallbuy_autofill_weapons["all"][weapon] = wallbuy_autospawn;
		
		if ( weapon_class != "" )
		{
			if ( !isdefined( level.wallbuy_autofill_weapons[weapon_class] ) )
			{
				level.wallbuy_autofill_weapons[weapon_class] = [];
			}
			level.wallbuy_autofill_weapons[weapon_class][weapon] = weapon;
		}
		*/

		index++;
		row = TableLookupRow( table, index );
	}
}

function autofill_wallbuys_init()
{
	wallbuys = struct::get_array("wallbuy_autofill","targetname");
	

	if (!isdefined(wallbuys) || wallbuys.size == 0 || !isdefined(level.wallbuy_autofill_weapons) || level.wallbuy_autofill_weapons.size == 0 )
		return;
	
	level.use_autofill_wallbuy = true;
	
	array_keys["all"] = GetArrayKeys(level.wallbuy_autofill_weapons["all"]);
	index = 0;
	class_all = [];
	
	level.active_autofill_wallbuys = [];

	//Loop through all autospawn wallbuys
	foreach (wallbuy in wallbuys)
	{
		weapon_class= wallbuy.script_string;
		weapon = undefined;
		
		//If this wallbuy needs a specific weapon_class of weapons
		if (isdefined(weapon_class) && weapon_class != "")
		{
			//Check if there's any weapon of this weapon_class included
			if (!isdefined(array_keys[weapon_class]) && isdefined(level.wallbuy_autofill_weapons[weapon_class]))
				array_keys[weapon_class] = GetArrayKeys(level.wallbuy_autofill_weapons[weapon_class]);
			if (isdefined(array_keys[weapon_class]))
			{
				//Find the first not spawned weapon of this type
				for (i = 0 ; i < array_keys[weapon_class].size; i ++)
				{
					if (level.wallbuy_autofill_weapons["all"][array_keys[weapon_class][i]])
					{
						weapon = array_keys[weapon_class][i];
						//Mark this weapon spawned
						level.wallbuy_autofill_weapons["all"][weapon] = false;
						break;
					}
				}
			}
			else
			{
				continue;
			}
		}
		else
		{
			class_all[class_all.size] = wallbuy;
			continue;
			//Find the first available weapon in all weapons included
		}
		
		//No more weapon can be assigned to this wallbuy, skip it
		if (!isdefined(weapon))
			continue;
		
		wallbuy.zombie_weapon_upgrade = weapon.name;
		wallbuy.weapon = weapon;
		
		//Fix for the blue light effect
		right = AnglesToRight(wallbuy.angles);
		wallbuy.origin -= right * 2;
		
		wallbuy.target = "autofill_wallbuy_" + index;
			
		target_struct = SpawnStruct();
		target_struct.targetname = wallbuy.target;
		target_struct.angles = wallbuy.angles;
		target_struct.origin = wallbuy.origin;
		
		model = wallbuy.weapon.worldModel;
		target_struct.model = model;
		target_struct struct::init();
		level.active_autofill_wallbuys[level.active_autofill_wallbuys.size] = wallbuy;
		index ++;
		
	}
	
	foreach (wallbuy in class_all)
	{
		weapon_name = undefined;
		for (i = 0 ; i < array_keys["all"].size; i ++)
		{
			if (level.wallbuy_autofill_weapons["all"][array_keys["all"][i]])
			{
				weapon = array_keys["all"][i];
				level.wallbuy_autofill_weapons["all"][weapon] = false;
				break;
			}
		}
		
		if (!isdefined(weapon))
			break;
		
		wallbuy.zombie_weapon_upgrade = weapon.name;
		wallbuy.weapon = weapon;
		
		//Fix for the blue light effect
		right = AnglesToRight(wallbuy.angles);
		wallbuy.origin -= right * 2;
		
		wallbuy.target = "autofill_wallbuy_" + index;
			
		target_struct = SpawnStruct();
		target_struct.targetname = wallbuy.target;
		target_struct.angles = wallbuy.angles;
		target_struct.origin = wallbuy.origin;
		
		model = wallbuy.weapon.worldModel;
		target_struct.model = model;
		target_struct struct::init();
		level.active_autofill_wallbuys[level.active_autofill_wallbuys.size] = wallbuy;
		index ++;
	}
}