#include maps\_utility; 
#include common_scripts\utility;
#include maps\_zombiemode_utility;

init()
{
	init_weapons();
	init_weapon_upgrade();
	init_weapon_cabinet();
	treasure_chest_init();
}

add_zombie_weapon( weapon_name, hint, cost, ammo_cost )
{
	if( IsDefined( level.zombie_include_weapons ) && !IsDefined( level.zombie_include_weapons[weapon_name] ) )
	{
		return;
	}

	// Check the table first
	table = "mp/zombiemode.csv";
	table_cost = TableLookUp( table, 0, weapon_name, 1 );
	table_ammo_cost = TableLookUp( table, 0, weapon_name, 2 );

	if( IsDefined( table_cost ) && table_cost != "" )
	{
		cost = round_up_to_ten( int( table_cost ) );
	}

	if( IsDefined( table_ammo_cost ) && table_ammo_cost != "" )
	{
		ammo_cost = round_up_to_ten( int( table_ammo_cost ) );
	}

	PrecacheItem( weapon_name );
	PrecacheString( hint );

	struct = SpawnStruct();
	
	if( !IsDefined( level.zombie_weapons ) )
	{
		level.zombie_weapons = [];
	}

	struct.weapon_name = weapon_name;
	struct.weapon_classname = "weapon_" + weapon_name;
	struct.hint = hint;
	struct.cost = cost;

	if( !IsDefined( ammo_cost ) )
	{
		ammo_cost = round_up_to_ten( int( cost * 0.5 ) );
	}

	struct.ammo_cost = ammo_cost;

	level.zombie_weapons[weapon_name] = struct;
}

include_zombie_weapon( weapon_name )
{
	if( !IsDefined( level.zombie_include_weapons ) )
	{
		level.zombie_include_weapons = [];
	}

	level.zombie_include_weapons[weapon_name] = true;
}

init_weapons()
{
	// Zombify
	PrecacheItem( "zombie_melee" );
	
	// Pistols
	add_zombie_weapon( "colt", 									&"ZOMBIE_WEAPON_COLT_50", 					50 );
	add_zombie_weapon( "colt_dirty_harry", 						&"ZOMBIE_WEAPON_COLT_DH_100", 				100 );
	add_zombie_weapon( "nambu", 								&"ZOMBIE_WEAPON_NAMBU_50", 					50 );
	add_zombie_weapon( "sw_357", 								&"ZOMBIE_WEAPON_SW357_100", 				100 );
	add_zombie_weapon( "tokarev", 								&"ZOMBIE_WEAPON_TOKAREV_50", 				50 );
	add_zombie_weapon( "walther", 								&"ZOMBIE_WEAPON_WALTHER_50", 				50 );
	add_zombie_weapon( "zombie_colt", 							&"ZOMBIE_WEAPON_ZOMBIECOLT_25", 			25 );
                                                        		
	// Bolt Action                                      		
	add_zombie_weapon( "kar98k", 								&"ZOMBIE_WEAPON_KAR98K_200", 				200 );
	add_zombie_weapon( "kar98k_bayonet", 						&"ZOMBIE_WEAPON_KAR98K_B_200", 				200 );
	add_zombie_weapon( "mosin_rifle", 							&"ZOMBIE_WEAPON_MOSIN_200", 				200 );
	add_zombie_weapon( "mosin_rifle_bayonet", 					&"ZOMBIE_WEAPON_MOSIN_B_200", 				200 );
	add_zombie_weapon( "springfield", 							&"ZOMBIE_WEAPON_SPRINGFIELD_200", 			200 );
	add_zombie_weapon( "springfield_bayonet", 					&"ZOMBIE_WEAPON_SPRINGFIELD_B_200", 		200 );
	add_zombie_weapon( "type99_rifle", 							&"ZOMBIE_WEAPON_TYPE99_200", 				200 );
	add_zombie_weapon( "type99_rifle_bayonet", 					&"ZOMBIE_WEAPON_TYPE99_B_200", 				200 );
                                                        		
	// Semi Auto                                        		
	add_zombie_weapon( "gewehr43", 								&"ZOMBIE_WEAPON_GEWEHR43_600", 				600 );
	add_zombie_weapon( "m1carbine", 							&"ZOMBIE_WEAPON_M1CARBINE_600",				600 );
	add_zombie_weapon( "m1carbine_bayonet", 					&"ZOMBIE_WEAPON_M1CARBINE_B_600", 			600 );
	add_zombie_weapon( "m1garand", 								&"ZOMBIE_WEAPON_M1GARAND_600", 				600 );
	add_zombie_weapon( "m1garand_bayonet", 						&"ZOMBIE_WEAPON_M1GARAND_B_600", 			600 );
	add_zombie_weapon( "svt40", 								&"ZOMBIE_WEAPON_SVT40_600", 				600 );
                                                        		
	// Grenades                                         		
	add_zombie_weapon( "fraggrenade", 							&"ZOMBIE_WEAPON_FRAGGRENADE_250", 			250 );
	add_zombie_weapon( "molotov", 								&"ZOMBIE_WEAPON_MOLOTOV_200", 				200 );
	add_zombie_weapon( "stick_grenade", 						&"ZOMBIE_WEAPON_STICKGRENADE_250", 			250 );
	add_zombie_weapon( "stielhandgranate", 						&"ZOMBIE_WEAPON_STIELHANDGRANATE_250", 		250 );
	add_zombie_weapon( "type97_frag", 							&"ZOMBIE_WEAPON_TYPE97FRAG_250", 			250 );

	// Scoped
	add_zombie_weapon( "kar98k_scoped_zombie", 					&"ZOMBIE_WEAPON_KAR98K_S_750", 				750 );
	add_zombie_weapon( "kar98k_scoped_bayonet_zombie", 			&"ZOMBIE_WEAPON_KAR98K_S_B_750", 			750 );
	add_zombie_weapon( "mosin_rifle_scoped_zombie", 			&"ZOMBIE_WEAPON_MOSIN_S_750", 				750 );
	add_zombie_weapon( "mosin_rifle_scoped_bayonet_zombie", 	&"ZOMBIE_WEAPON_MOSIN_S_B_750", 			750 );
	add_zombie_weapon( "ptrs41_zombie", 						&"ZOMBIE_WEAPON_PTRS41_750", 				750 );
	add_zombie_weapon( "springfield_scoped_zombie", 			&"ZOMBIE_WEAPON_SPRINGFIELD_S_750", 		750 );
	add_zombie_weapon( "springfield_scoped_bayonet_zombie", 	&"ZOMBIE_WEAPON_SPRINGFIELD_S_B_750", 		750 );
	add_zombie_weapon( "type99_rifle_scoped_zombie", 			&"ZOMBIE_WEAPON_TYPE99_S_750", 				750 );
	add_zombie_weapon( "type99_rifle_scoped_bayonet_zombie", 	&"ZOMBIE_WEAPON_TYPE99_S_B_750", 			750 );
                                                                                                	
	// Full Auto                                                                                	
	add_zombie_weapon( "mp40", 								&"ZOMBIE_WEAPON_MP40_1000", 				1000 );
	add_zombie_weapon( "ppsh", 								&"ZOMBIE_WEAPON_PPSH_2000", 				2000 );
	add_zombie_weapon( "stg44", 							&"ZOMBIE_WEAPON_STG44_1200", 				1200 );
	add_zombie_weapon( "thompson", 							&"ZOMBIE_WEAPON_THOMPSON_1500", 			1500 );
	add_zombie_weapon( "type100_smg", 						&"ZOMBIE_WEAPON_TYPE100_1000", 				1000 );
                                                        	
	// Shotguns                                         	
	add_zombie_weapon( "doublebarrel", 						&"ZOMBIE_WEAPON_DOUBLEBARREL_1200", 		1200 );
	add_zombie_weapon( "doublebarrel_sawed_grip", 			&"ZOMBIE_WEAPON_DOUBLEBARREL_SAWED_1200", 	1200 );
	add_zombie_weapon( "shotgun", 							&"ZOMBIE_WEAPON_SHOTGUN_1500", 				1500 );
                                                        	
	// Heavy Machineguns                                	
	add_zombie_weapon( "30cal", 							&"ZOMBIE_WEAPON_30CAL_3000", 				3000 );
	add_zombie_weapon( "bar", 								&"ZOMBIE_WEAPON_BAR_1800", 					1800 );
	add_zombie_weapon( "dp28", 								&"ZOMBIE_WEAPON_DP28_2250", 				2250 );
	add_zombie_weapon( "fg42", 								&"ZOMBIE_WEAPON_FG42_1200", 				1500 );
	add_zombie_weapon( "fg42_scoped", 						&"ZOMBIE_WEAPON_FG42_S_1200", 				1500 );
	add_zombie_weapon( "mg42", 								&"ZOMBIE_WEAPON_MG42_1200", 				3000 );
	add_zombie_weapon( "type99_lmg", 						&"ZOMBIE_WEAPON_TYPE99_LMG_1750", 			1750 );
                                                        	
	// Grenade Launcher                                 	
	add_zombie_weapon( "m1garand_gl_zombie", 						&"ZOMBIE_WEAPON_M1GARAND_GL_1200", 			1200 );
	add_zombie_weapon( "mosin_launcher_zombie", 					&"ZOMBIE_WEAPON_MOSIN_GL_1200", 			1200 );
	                                        				
	// Bipods                               				
	add_zombie_weapon( "30cal_bipod", 						&"ZOMBIE_WEAPON_30CAL_BIPOD_3500", 			3500 );
	add_zombie_weapon( "bar_bipod", 						&"ZOMBIE_WEAPON_BAR_BIPOD_2500", 			2500 );
	add_zombie_weapon( "dp28_bipod", 						&"ZOMBIE_WEAPON_DP28_BIPOD_2500", 			2500 );
	add_zombie_weapon( "fg42_bipod", 						&"ZOMBIE_WEAPON_FG42_BIPOD_2000", 			2000 );
	add_zombie_weapon( "mg42_bipod", 						&"ZOMBIE_WEAPON_MG42_BIPOD_3250", 			3250 );
	add_zombie_weapon( "type99_lmg_bipod", 					&"ZOMBIE_WEAPON_TYPE99_LMG_BIPOD_2250", 	2250 );
	
	// Rocket Launchers
	add_zombie_weapon( "bazooka", 							&"ZOMBIE_WEAPON_BAZOOKA_2000", 				2000 );
	add_zombie_weapon( "panzerschrek", 						&"ZOMBIE_WEAPON_PANZERSCHREK_2000", 		2000 );
	                                                    	
	// Flamethrower                                     	
	add_zombie_weapon( "m2_flamethrower_zombie", 			&"ZOMBIE_WEAPON_M2_FLAMETHROWER_3000", 		3000 );	
                                                        	
	// Special                                          	
	add_zombie_weapon( "mortar_round", 						&"ZOMBIE_WEAPON_MORTARROUND_2000", 			2000 );
	add_zombie_weapon( "satchel_charge", 					&"ZOMBIE_WEAPON_SATCHEL_2000", 				2000 );
	add_zombie_weapon( "ray_gun", 							&"ZOMBIE_WEAPON_RAYGUN_10000", 				10000 );

	// ONLY 1 OF THE BELOW SHOULD BE ALLOWED
	add_limited_weapon( "m2_flamethrower_zombie", 1 );
}             

add_limited_weapon( weapon_name, amount )
{
	if( !IsDefined( level.limited_weapons ) )
	{
		level.limited_weapons = [];
	}

	level.limited_weapons[weapon_name] = amount;
}                                          	

// For buying weapon upgrades in the environment
init_weapon_upgrade()
{
	weapon_spawns = GetEntArray( "weapon_upgrade", "targetname" ); 

	for( i = 0; i < weapon_spawns.size; i++ )
	{
		hint_string = get_weapon_hint( weapon_spawns[i].zombie_weapon_upgrade ); 

		weapon_spawns[i] SetHintString( hint_string ); 
		weapon_spawns[i] setCursorHint( "HINT_NOICON" ); 
		weapon_spawns[i] UseTriggerRequireLookAt();

		weapon_spawns[i] thread weapon_spawn_think(); 
		model = getent( weapon_spawns[i].target, "targetname" ); 
		model hide(); 
	}
}

// weapon cabinets which open on use
init_weapon_cabinet()
{
	// the triggers which are targeted at doors
	weapon_cabs = GetEntArray( "weapon_cabinet_use", "targetname" ); 
	
	for( i = 0; i < weapon_cabs.size; i++ )
	{
	
		weapon_cabs[i] SetHintString( &"ZOMBIE_CABINET_OPEN_1500" ); 
		weapon_cabs[i] setCursorHint( "HINT_NOICON" ); 
		weapon_cabs[i] UseTriggerRequireLookAt();
	}

	array_thread( weapon_cabs, ::weapon_cabinet_think ); 
}

// returns the trigger hint string for the given weapon
get_weapon_hint( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].hint;
}

get_weapon_cost( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].cost;
}

get_ammo_cost( weapon_name )
{
	AssertEx( IsDefined( level.zombie_weapons[weapon_name] ), weapon_name + " was not included or is not part of the zombie weapon list." );

	return level.zombie_weapons[weapon_name].ammo_cost;
}

// for the random weapon chest
treasure_chest_init()
{
	// the triggers which are targeted at chests
	chests = GetEntArray( "treasure_chest_use", "targetname" ); 

	array_thread( chests, ::treasure_chest_think ); 
}

set_treasure_chest_cost( cost )
{
	level.zombie_treasure_chest_cost = cost;
}

treasure_chest_think()
{
	cost = 950;
	if( IsDefined( level.zombie_treasure_chest_cost ) )
	{
		cost = level.zombie_treasure_chest_cost;
	}

	self set_hint_string( self, "default_treasure_chest_" + cost );
	self setCursorHint( "HINT_NOICON" );
	
	// waittill someuses uses this
	user = undefined;
	while( 1 )
	{
		self waittill( "trigger", user ); 

		if( user in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		// make sure the user is a player, and that they can afford it
		if( is_player_valid( user ) && user.score >= self.zombie_cost )
		{
			user maps\_zombiemode_score::minus_to_player_score( self.zombie_cost ); 
			break; 
		}
		
		wait 0.05; 
	}
	
	// trigger_use->script_brushmodel lid->script_origin in radiant
	lid = getent( self.target, "targetname" ); 
	weapon_spawn_org = getent( lid.target, "targetname" ); 
	
	//open the lid
	lid thread treasure_chest_lid_open();
	
	// SRS 9/3/2008: added to help other functions know if we timed out on grabbing the item
	self.timedOut = false;
	
	// mario kart style weapon spawning
	weapon_spawn_org thread treasure_chest_weapon_spawn( self, user ); 
	
	// the glowfx	
	weapon_spawn_org thread treasure_chest_glowfx(); 
	
	// take away usability until model is done randomizing
	self disable_trigger(); 
	
	weapon_spawn_org waittill( "randomization_done" ); 

	self.grab_weapon_hint = true;
	level thread treasure_chest_user_hint( self, user );
	self sethintstring( &"ZOMBIE_TRADE_WEAPONS" ); 
	self setCursorHint( "HINT_NOICON" ); 
	self setvisibletoplayer( user );
	
	self enable_trigger(); 
	self thread treasure_chest_timeout();
	
	// make sure the guy that spent the money gets the item
	// SRS 9/3/2008: ...or item goes back into the box if we time out
	while( 1 )
	{
		self waittill( "trigger", grabber ); 
		
		if( grabber == user || grabber == level )
		{
			if( grabber == user && is_player_valid( user ) )
			{
				self notify( "user_grabbed_weapon" );
				user thread treasure_chest_give_weapon( weapon_spawn_org.weapon_string );
				break; 
			}
			else if( grabber == level )
			{
				// it timed out
				self.timedOut = true;
				break;
			}
		}
		
		wait 0.05; 
	}
	self.grab_weapon_hint = false;
	
	weapon_spawn_org notify( "weapon_grabbed" ); 
	
	self disable_trigger(); 
		
	// spend cash here...
	// give weapon here...
	lid thread treasure_chest_lid_close( self.timedOut ); 
	
	wait 3; 
	self enable_trigger(); 	
	self setvisibletoall();
	self thread treasure_chest_think(); 
}

treasure_chest_user_hint( trigger, user )
{
	dist = 128 * 128;
	while( 1 )
	{
		if( !IsDefined( trigger ) )
		{
			break;
		}

		if( trigger.grab_weapon_hint )
		{
			break;
		}

		players = get_players();
		for( i = 0; i < players.size; i++ )
		{
			if( players[i] == user )
			{
				continue;
			}

			if( DistanceSquared( players[i].origin, trigger.origin ) < dist )
			{
				players[i].ignoreTriggers = true;
			}
		}

		wait( 0.1 );
	}
}

treasure_chest_timeout()
{
	self endon( "user_grabbed_weapon" );
	
	wait( 12 );
	self notify( "trigger", level ); 
}

treasure_chest_lid_open()
{
	openRoll = 105;
	openTime = 0.5;
	
	self RotateRoll( 105, openTime, ( openTime * 0.5 ) );
	
	play_sound_at_pos( "open_chest", self.origin );
	play_sound_at_pos( "music_chest", self.origin );
}

treasure_chest_lid_close( timedOut )
{
	closeRoll = -105;
	closeTime = 0.5;
	
	self RotateRoll( closeRoll, closeTime, ( closeTime * 0.5 ) );
	play_sound_at_pos( "close_chest", self.origin );
}

treasure_chest_ChooseRandomWeapon( player )
{
	keys = GetArrayKeys( level.zombie_weapons );

	// Filter out any weapons the player already has
	filtered = [];
	for( i = 0; i < keys.size; i++ )
	{
		if( player HasWeapon( keys[i] ) )
		{
			continue;
		}
		
		//chrisP - make sure the chest doesn't give the player a bouncing betty
		if(keys[i] == "mine_bouncing_betty")
		{
			continue;
		}

		filtered[filtered.size] = keys[i];
	}

	// Filter out the limited weapons
	if( IsDefined( level.limited_weapons ) )
	{
		keys2 = GetArrayKeys( level.limited_weapons );
		players = get_players();
		for( q = 0; q < keys2.size; q++ )
		{
			count = 0;
			for( i = 0; i < players.size; i++ )
			{
				if( players[i] HasWeapon( keys2[q] ) )
				{
					count++;
				}
				
				// check for last stand weapons that might not be on the player at the time
				if (players[i] maps\_laststand::player_is_in_laststand())
				{
					for( m = 0; m < players[i].weaponInventory.size; m++ )
					{
						if (players[i].weaponInventory[m] == keys2[q])
						{
							count++;
						}
					}
				}
			}
	
			if( count == level.limited_weapons[keys2[q]] )
			{
				filtered = array_remove( filtered, keys2[q] );
			}
		}
	}

	return filtered[RandomInt( filtered.size )];
}

treasure_chest_weapon_spawn( chest, player )
{
	assert(IsDefined(player));
	// spawn the model
	model = spawn( "script_model", self.origin ); 
	model.angles = self.angles +( 0, 90, 0 );
	
	floatHeight = 40;
	
	//move it up
	model moveto( model.origin +( 0, 0, floatHeight ), 3, 2, 0.9 ); 

	// rotation would go here

	// make with the mario kart
	modelname = undefined; 
	rand = undefined; 
	for( i = 0; i < 40; i++ )
	{
		rand = treasure_chest_ChooseRandomWeapon( player );
		modelname = GetWeaponModel( rand );
		model setmodel( modelname ); 
		
		if( i < 20 )
		{
			wait( 0.05 ); 
		}
		else if( i < 30 )
		{
			wait( 0.1 ); 
		}
		else if( i < 35 )
		{
			wait( 0.2 ); 
		}
		else if( i < 38 )
		{
			wait( 0.3 ); 
		}
	}

	self notify( "randomization_done" ); 
	self.weapon_string = rand; // here's where the org get it's weapon type for the give function
	
	self waittill( "weapon_grabbed" );
	
	if( !chest.timedOut )
	{
		model Delete();
	}
	// SRS 9/3/2008: if we timed out, move the weapon back into the box instead of deleting it
	else
	{
		putBackTime = 0.3;

		model MoveTo( model.origin - ( 0, 0, floatHeight ), putBackTime, ( putBackTime * 0.5 ) );
		wait( putBackTime );
		
		model Delete();
	}
}

treasure_chest_glowfx()
{
	fxObj = spawn( "script_model", self.origin +( 0, 0, 0 ) ); 
	fxobj setmodel( "tag_origin" ); 
	fxobj.angles = self.angles +( 90, 0, 0 ); 
	
	playfxontag( level._effect["chest_light"], fxObj, "tag_origin"  ); 

	self waittill( "weapon_grabbed" ); 
	
	fxobj delete(); 
}

// self is the player string comes from the randomization function
treasure_chest_give_weapon( weapon_string )
{
	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = undefined; 

	// This should never be true for the first time.
	if( primaryWeapons.size >= 2 ) // he has two weapons
	{
		current_weapon = self getCurrentWeapon(); // get hiss current weapon

		if( isdefined( current_weapon ) )
		{
			if( !( weapon_string == "fraggrenade" || weapon_string == "stielhandgranate" || weapon_string == "molotov" ) )
			self TakeWeapon( current_weapon ); 
		} 
	} 

	if( IsDefined( primaryWeapons ) && !isDefined( current_weapon ) )
	{
		for( i = 0; i < primaryWeapons.size; i++ )
		{
			if( primaryWeapons[i] == "zombie_colt" )
			{
				continue; 
			}

			if( weapon_string != "fraggrenade" && weapon_string != "stielhandgranate" && weapon_string != "molotov" )
			{
				self TakeWeapon( primaryWeapons[i] ); 
			}
		}
	}

	self play_sound_on_ent( "purchase" ); 

	self GiveWeapon( weapon_string, 0 );
	self GiveMaxAmmo( weapon_string );
	self SwitchToWeapon( weapon_string ); 
}

weapon_cabinet_think()
{
	weapons = getentarray( "cabinet_weapon", "targetname" ); 

	doors = getentarray( self.target, "targetname" );
	for( i = 0; i < doors.size; i++ )
	{
		doors[i] NotSolid();
	}
		
	self.has_been_used_once = false; 
	
	while( 1 )
	{
		self waittill( "trigger", player );

		if( player in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}

		cost = 1500;
		if( self.has_been_used_once )
		{
			cost = get_weapon_cost( self.zombie_weapon_upgrade );
		}
		else
		{
			if( IsDefined( self.zombie_cost ) )
			{
				cost = self.zombie_cost;
			}
		}

		ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
			
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}
	
		if( self.has_been_used_once )
		{
			player_has_weapon = false; 
			weapons = player GetWeaponsList(); 
			if( IsDefined( weapons ) )
			{
				for( i = 0; i < weapons.size; i++ )
				{
					if( weapons[i] == self.zombie_weapon_upgrade )
					{
						player_has_weapon = true; 
					}
				}
			}

			if( !player_has_weapon )
			{
				if( player.score >= cost )
				{
					self play_sound_on_ent( "purchase" );
					player maps\_zombiemode_score::minus_to_player_score( cost ); 
					player weapon_give( self.zombie_weapon_upgrade ); 
				}
				else // not enough money
				{
					play_sound_on_ent( "no_purchase" );
				}			
			}
			else if ( player.score >= ammo_cost )
			{
				ammo_given = player ammo_give( self.zombie_weapon_upgrade ); 
				if( ammo_given )
				{
					self play_sound_on_ent( "purchase" );
					player maps\_zombiemode_score::minus_to_player_score( ammo_cost ); // this give him ammo to early
				}
			}
			else // not enough money
			{
				play_sound_on_ent( "no_purchase" );
			}
		}
		else if( player.score >= cost ) // First time the player opens the cabinet
		{
			self.has_been_used_once = true;

			self play_sound_on_ent( "purchase" ); 
			
			self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
	//		self SetHintString( get_weapon_hint( self.zombie_weapon_upgrade ) );
			self setCursorHint( "HINT_NOICON" ); 
			player maps\_zombiemode_score::minus_to_player_score( self.zombie_cost ); 
			
			doors = getentarray( self.target, "targetname" ); 
		
			for( i = 0; i < doors.size; i++ )
			{
				if( doors[i].model == "dest_test_cabinet_ldoor_dmg0" )
				{
					doors[i] thread weapon_cabinet_door_open( "left" ); 
				}
				else if( doors[i].model == "dest_test_cabinet_rdoor_dmg0" )
				{
					doors[i] thread weapon_cabinet_door_open( "right" ); 
				}
			}

			player_has_weapon = false; 
			weapons = player GetWeaponsList(); 
			if( IsDefined( weapons ) )
			{
				for( i = 0; i < weapons.size; i++ )
				{
					if( weapons[i] == self.zombie_weapon_upgrade )
					{
						player_has_weapon = true; 
					}
				}
			}

			if( !player_has_weapon )
			{
				player weapon_give( self.zombie_weapon_upgrade ); 
			}
			else
			{
				player ammo_give( self.zombie_weapon_upgrade ); 
			}	
		}
		else // not enough money
		{
			 play_sound_on_ent( "no_purchase" );
		}		
	}
}

weapon_cabinet_door_open( left_or_right )
{
	if( left_or_right == "left" )
	{
		self rotateyaw( 120, 0.3, 0.2, 0.1 ); 	
	}
	else if( left_or_right == "right" )
	{
		self rotateyaw( -120, 0.3, 0.2, 0.1 ); 	
	}	
}

weapon_spawn_think()
{
	cost = get_weapon_cost( self.zombie_weapon_upgrade );
	ammo_cost = get_ammo_cost( self.zombie_weapon_upgrade );
	is_grenade = (WeaponType( self.zombie_weapon_upgrade ) == "grenade");


	self.first_time_triggered = false; 
	for( ;; )
	{
		self waittill( "trigger", player ); 		
		// if not first time and they have the weapon give ammo
		
		if( !is_player_valid( player ) )
		{
			player thread ignore_triggers( 0.5 );
			continue;
		}

		if( player in_revive_trigger() )
		{
			wait( 0.1 );
			continue;
		}
		
		player_has_weapon = false; 
		weapons = player GetWeaponsList(); 
		if( IsDefined( weapons ) )
		{
			for( i = 0; i < weapons.size; i++ )
			{
				if( weapons[i] == self.zombie_weapon_upgrade )
				{
					player_has_weapon = true; 
				}
			}
		}		
		
		if( !player_has_weapon )
		{
			// else make the weapon show and give it
			if( player.score >= cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
//					model show(); 
					model thread weapon_show( player ); 
					self.first_time_triggered = true; 
					
					if(!is_grenade)
					{
						self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
					}
				}
			
				player maps\_zombiemode_score::minus_to_player_score( cost ); 

				player weapon_give( self.zombie_weapon_upgrade ); 
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
			}
		}
		else
		{
			// if the player does have this then give him ammo.
			if( player.score >= ammo_cost )
			{
				if( self.first_time_triggered == false )
				{
					model = getent( self.target, "targetname" ); 
//					model show(); 
					model thread weapon_show( player ); 
					self.first_time_triggered = true;
					if(!is_grenade)
					{ 
						self SetHintString( &"ZOMBIE_WEAPONCOSTAMMO", cost, ammo_cost ); 
					}
				}
				
				ammo_given = player ammo_give( self.zombie_weapon_upgrade ); 
				if( ammo_given )
				{
					if(is_grenade)
					{
						player maps\_zombiemode_score::minus_to_player_score( cost ); // this give him ammo to early
					}
					else
					{
						player maps\_zombiemode_score::minus_to_player_score( ammo_cost ); // this give him ammo to early
					}
				}
			}
			else
			{
				play_sound_on_ent( "no_purchase" );
			}
		}
	}
}

weapon_show( player )
{
	player_angles = VectorToAngles( player.origin - self.origin ); 

	player_yaw = player_angles[1]; 
	weapon_yaw = self.angles[1]; 

	yaw_diff = AngleClamp180( player_yaw - weapon_yaw ); 

	if( yaw_diff > 0 )
	{
		yaw = weapon_yaw - 90; 
	}
	else
	{
		yaw = weapon_yaw + 90; 
	}

	self.og_origin = self.origin; 
	self.origin = self.origin +( AnglesToForward( ( 0, yaw, 0 ) ) * 8 ); 

	wait( 0.05 ); 
	self Show(); 

	play_sound_at_pos( "weapon_show", self.origin, self );

	time = 1; 
	self MoveTo( self.og_origin, time ); 
}

weapon_give( weapon )
{

	primaryWeapons = self GetWeaponsListPrimaries(); 
	current_weapon = undefined; 

	// This should never be true for the first time.
	if( primaryWeapons.size >= 2 ) // he has two weapons
	{
		current_weapon = self getCurrentWeapon(); // get his current weapon

		if( isdefined( current_weapon ) )
		{
			if( !( weapon == "fraggrenade" || weapon == "stielhandgranate" || weapon == "molotov" ) )
			{
				self TakeWeapon( current_weapon ); 
			}
		} 
	} 

	if( IsDefined( primaryWeapons ) && !isDefined( current_weapon ) )
	{
		for( i = 0; i < primaryWeapons.size; i++ )
		{
			if( primaryWeapons[i] == "zombie_colt" )
			{
				continue; 
			}

			if( weapon != "fraggrenade" && weapon != "stielhandgranate" && weapon != "molotov" )
			{
				self TakeWeapon( primaryWeapons[i] ); 
			}
		}
	}

	self play_sound_on_ent( "purchase" );
	self GiveWeapon( weapon, 0 ); 
	self GiveMaxAmmo( weapon ); 
	self SwitchToWeapon( weapon ); 

}

ammo_give( weapon )
{
	// We assume before calling this function we already checked to see if the player has this weapon...

	// Should we give ammo to the player
	give_ammo = false; 

	// Check to see if ammo belongs to a primary weapon
	if( weapon != "fraggrenade" && weapon != "stielhandgranate" && weapon != "molotov" )
	{
		if( isdefined( weapon ) )  
		{
			// get the max allowed ammo on the current weapon
			stockMax = WeaponMaxAmmo( weapon ); 
	
			// Get the current weapon clip count
			clipCount = self GetWeaponAmmoClip( weapon ); 
	
			// compare it with the ammo player actually has, if more or equal just dont give the ammo, else do
			if( ( self getammocount( weapon ) - clipcount ) >= stockMax )	
			{
				give_ammo = false; 
			}
			else
			{
				give_ammo = true; // give the ammo to the player
			}
		}
				
	}
	else
	{
		// Ammo belongs to secondary weapon
		if( self hasweapon( weapon ) )
		{
			// Check if the player has less than max stock, if no give ammo
			if( self getammocount( weapon ) < WeaponMaxAmmo( weapon ) )
			{
				// give the ammo to the player
				give_ammo = true; 					
			}
		}		
	}	


	if( give_ammo )
	{
		self playsound( "cha_ching" ); 
		self GivemaxAmmo( weapon ); 
		return true;
	}

	if( !give_ammo )
	{
		return false;
	}
}
