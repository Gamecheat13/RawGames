#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 


/#

init()
{
	SetDvar( "zombie_devgui", "" );
	SetDvar( "scr_force_weapon", "" );
	SetDvar( "scr_zombie_round", "1" );
	SetDvar( "scr_zombie_dogs", "1" );
	SetDvar( "scr_spawn_tesla", "" );
	SetDvar( "scr_force_quantum_bomb_result", "" );

	level thread zombie_devgui_think();

	thread zombie_devgui_player_commands();

	thread diable_fog_in_noclip();

}


zombie_devgui_player_commands()
{
	flag_wait( "start_zombie_round_logic" ); 

	wait 1;

	players = GET_PLAYERS();
	for ( i=0; i<players.size; i++ )
	{
		ip1 = i+1;
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Give Money:1\" \"set zombie_devgui player" +ip1+ "_money\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Invulnerable:2\" \"set zombie_devgui player" +ip1+ "_invul_on\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Vulnerable:3\" \"set zombie_devgui player" +ip1+ "_invul_off\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Toggle Ignored:4\" \"set zombie_devgui player" +ip1+ "_ignore\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Mega Health:5\" \"set zombie_devgui player" +ip1+ "_health\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Down:6\" \"set zombie_devgui player" +ip1+ "_kill\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Revive:7\" \"set zombie_devgui player" +ip1+ "_revive\" \n");
		AddDebugCommand( "devgui_cmd \"Zombies:1/Players:1/Player/" +players[i].name+ "/Turn Player:8\" \"set zombie_devgui player" +ip1+ "_turnplayer\" \n");
	}
}


zombie_devgui_think()
{
	for ( ;; )
	{
		cmd = GetDvar( "zombie_devgui" );

		switch ( cmd )
		{
		case "money":
			players = GET_PLAYERS();
			array_thread( players, ::zombie_devgui_give_money );
			/*if ( players.size > 1 )
			{
				for ( i=0; i<level.team_pool.size; i++ )
				{
					level.team_pool[i].score += 100000;
					level.team_pool[i].old_score += 100000;
					level.team_pool[i] maps\mp\zombies\_zm_score::set_team_score_hud(); 
				}
			}*/
			break;
		case "player1_money":
			players = GET_PLAYERS();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_give_money();	
			break;
		case "player2_money":
			players = GET_PLAYERS();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_give_money();	
			break;
		case "player3_money":
			players = GET_PLAYERS();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_give_money();	
			break;
		case "player4_money":
			players = GET_PLAYERS();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_give_money();	
			break;

		case "health":
			array_thread( GET_PLAYERS(), ::zombie_devgui_give_health );	
			break;
		case "player1_health":
			players = GET_PLAYERS();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_give_health();	
			break;
		case "player2_health":
			players = GET_PLAYERS();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_give_health();	
			break;
		case "player3_health":
			players = GET_PLAYERS();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_give_health();	
			break;
		case "player4_health":
			players = GET_PLAYERS();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_give_health();	
			break;

		case "ignore":
			array_thread( GET_PLAYERS(), ::zombie_devgui_toggle_ignore );	
			break;
		case "player1_ignore":
			players = GET_PLAYERS();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_toggle_ignore();	
			break;
		case "player2_ignore":
			players = GET_PLAYERS();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_toggle_ignore();	
			break;
		case "player3_ignore":
			players = GET_PLAYERS();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_toggle_ignore();	
			break;
		case "player4_ignore":
			players = GET_PLAYERS();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_toggle_ignore();	
			break;

		case "player1_invul_on":
			zombie_devgui_invulnerable( 0, true ); 
			break;
		case "player1_invul_off":
			zombie_devgui_invulnerable( 0, false ); 
			break;
		case "player2_invul_on":
			zombie_devgui_invulnerable( 1, true ); 
			break;
		case "player2_invul_off":
			zombie_devgui_invulnerable( 1, false ); 
			break;
		case "player3_invul_on":
			zombie_devgui_invulnerable( 2, true ); 
			break;
		case "player3_invul_off":
			zombie_devgui_invulnerable( 2, false ); 
			break;
		case "player4_invul_on":
			zombie_devgui_invulnerable( 3, true ); 
			break;
		case "player4_invul_off":
			zombie_devgui_invulnerable( 3, false ); 
			break;

		case "revive_all":
			array_thread( GET_PLAYERS(), ::zombie_devgui_revive );	
			break;
		case "player1_revive":
			players = GET_PLAYERS();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_revive();	
			break;
		case "player2_revive":
			players = GET_PLAYERS();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_revive();	
			break;
		case "player3_revive":
			players = GET_PLAYERS();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_revive();	
			break;
		case "player4_revive":
			players = GET_PLAYERS();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_revive();	
			break;
			
		case "player1_kill":
			players = GET_PLAYERS();
			if ( players.size >= 1 )
				players[0] thread zombie_devgui_kill();	
			break;
		case "player2_kill":
			players = GET_PLAYERS();
			if ( players.size >= 2 )
				players[1] thread zombie_devgui_kill();	
			break;
		case "player3_kill":
			players = GET_PLAYERS();
			if ( players.size >= 3 )
				players[2] thread zombie_devgui_kill();	
			break;
		case "player4_kill":
			players = GET_PLAYERS();
			if ( players.size >= 4 )
				players[3] thread zombie_devgui_kill();	
			break;
			
		case "spawn_friendly_bot":
			player = GetHostPlayer();
			team = player.team;

			devgui_bot_spawn( team );
			break;

		case "specialty_armorvest":
		case "specialty_quickrevive":
		case "specialty_fastreload":
		case "specialty_rof":
		case "specialty_longersprint":
		case "specialty_flakjacket":
		case "specialty_deadshot":
		case "specialty_additionalprimaryweapon":
		case "specialty_scavenger":
			zombie_devgui_give_perk( cmd );
			break;

		case "turnplayer":
			zombie_devgui_turn_player();
			break;
		case "player1_turnplayer":
			zombie_devgui_turn_player(0);
			break;
		case "player2_turnplayer":
			zombie_devgui_turn_player(1);
			break;
		case "player3_turnplayer":
			zombie_devgui_turn_player(2);
			break;
		case "player4_turnplayer":
			zombie_devgui_turn_player(3);
			break;

		case "nuke":
		case "insta_kill":
		case "double_points":
		case "full_ammo":
		case "carpenter":
		case "fire_sale":
		case "bonfire_sale":
		case "minigun":
		case "free_perk":
		case "tesla":
		case "random_weapon":
		case "bonus_points_player":
		case "bonus_points_team":
		case "lose_points_team":
		case "lose_perk":
		case "empty_clip":
			zombie_devgui_give_powerup( cmd, true );
			break;

		case "next_nuke":
		case "next_insta_kill":
		case "next_double_points":
		case "next_full_ammo":
		case "next_carpenter":
		case "next_fire_sale":
		case "next_bonfire_sale":
		case "next_minigun":
		case "next_free_perk":
		case "next_tesla":
		case "next_random_weapon":
		case "next_bonus_points_player":
		case "next_bonus_points_team":
		case "next_lose_points_team":
		case "next_lose_perk":
		case "next_empty_clip":
			zombie_devgui_give_powerup( GetSubStr( cmd, 5 ), false );
			break;

		case "round":
			zombie_devgui_goto_round( GetDvarInt( "scr_zombie_round" ) );
			break;
		case "round_next":
			zombie_devgui_goto_round( level.round_number + 1 );
			break;
		case "round_prev":
			zombie_devgui_goto_round( level.round_number - 1 );
			break;

		case "chest_move":
			if ( IsDefined( level.chest_accessed ) )
			{
				//iprintln( "Teddy bear will spawn on next open" );
				level notify( "devgui_chest_end_monitor" );
				level.chest_accessed = 100;
			}
			break;

		case "chest_never_move":
			if ( IsDefined( level.chest_accessed ) )
			{
				//iprintln( "Setting chest to never move" );
				level thread zombie_devgui_chest_never_move();
			}
			break;

		case "chest":
			if( IsDefined( level.zombie_weapons[ GetDvar( "scr_force_weapon" ) ] ) )
			{
				//iprintln( GetDvar( "scr_force_weapon" ) + " will spawn on next open" );
			}
			break;

		case "quantum_bomb_random_result":
			// clears the dvar so that we'll go back to getting random results
			SetDvar( "scr_force_quantum_bomb_result", "" );
			break;

		case "give_gasmask":
			array_thread( GET_PLAYERS(), ::zombie_devgui_equipment_give, "equip_gasmask_zm" );
			break;

		case "give_hacker":
			array_thread( GET_PLAYERS(), ::zombie_devgui_equipment_give, "equip_hacker_zm" );
			break;
			
		case "give_turbine":
			array_thread( GET_PLAYERS(), ::zombie_devgui_equipment_give, "equip_turbine_zm" );
			break;
			
		case "give_turret":
			array_thread( GET_PLAYERS(), ::zombie_devgui_equipment_give, "equip_turret_zm" );
			break;
			
		case "give_electrictrap":
			array_thread( GET_PLAYERS(), ::zombie_devgui_equipment_give, "equip_electrictrap_zm" );
			break;

		case "give_monkey":
			array_thread( GET_PLAYERS(), ::zombie_devgui_give_monkey );
			break;

		case "give_black_hole_bomb":
			array_thread( GET_PLAYERS(), ::zombie_devgui_give_black_hole_bomb );
			break;

		case "give_dolls":
			array_thread( GET_PLAYERS(), ::zombie_devgui_give_dolls );
			break;

		case "give_quantum_bomb":
			array_thread( GET_PLAYERS(), ::zombie_devgui_give_quantum_bomb );
			break;

		case "give_emp_bomb":
			array_thread( GET_PLAYERS(), ::zombie_devgui_give_emp_bomb );
			break;

		case "monkey_round":
			zombie_devgui_monkey_round();
			break;

		case "thief_round":
			zombie_devgui_thief_round();
			break;

		case "dog_round":
			zombie_devgui_dog_round( GetDvarInt( "scr_zombie_dogs" ) );
			break;

		case "dog_round_skip":
			zombie_devgui_dog_round_skip();
			break;

		case "print_variables":
			zombie_devgui_dump_zombie_vars();
			break;
			
		case "pack_current_weapon":
			zombie_devgui_pack_current_weapon();
			break;

		case "power_on":
			flag_set( "power_on" );
			break;

		case "director_easy":
			zombie_devgui_director_easy();
			break;
			
		case "open_sesame":
			zombie_devgui_open_sesame();
			break;

		case "allow_fog":
			zombie_devgui_allow_fog();
			break;

		case "disable_kill_thread_toggle":
			zombie_devgui_disable_kill_thread_toggle();
			break;

		case "check_kill_thread_every_frame_toggle":
			zombie_devgui_check_kill_thread_every_frame_toggle();
			break;
			
		case "zombie_failsafe_debug_flush":
			level notify( "zombie_failsafe_debug_flush" );
			break;

		case "":
			break;

		default:
			if ( IsDefined( level.custom_devgui ) )
			{
				[[level.custom_devgui]]( cmd );
			}
			else
			{
				//iprintln( "Unknown devgui command: '" + cmd + "'" );
			}
			break;
		}
	
		SetDvar( "zombie_devgui", "" );
		wait( 0.5 );
	}
}


devgui_bot_spawn( team )
{
	player = GetHostPlayer();

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	direction_vec = player.origin - trace["position"];
	direction = VectorToAngles( direction_vec );
	
	bot = AddTestClient();

	if ( !IsDefined( bot ) )
	{
		println( "Could not add test client" );
		return;
	}
			
	bot.pers["isBot"] = true;
	bot.equipment_enabled = false;
	//bot thread bot_spawn_think( team );

	yaw = direction[1];
	bot thread devgui_bot_spawn_think( trace[ "position" ], yaw );
}

devgui_bot_spawn_think( origin, yaw )
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self SetOrigin( origin );

		angles = ( 0, yaw, 0 );
		self SetPlayerAngles( angles );
	}
}


zombie_devgui_open_sesame()
{
	SetDvar("zombie_unlock_all",1);
	
	//turn on the power first
	flag_set( "power_on" );
	
	//give everyone money
	players = GET_PLAYERS();
	array_thread( players, ::zombie_devgui_give_money );
	
	//get all the door triggers and trigger them
	// DOORS ----------------------------------------------------------------------------- //
	zombie_doors = GetEntArray( "zombie_door", "targetname" ); 

	for( i = 0; i < zombie_doors.size; i++ )
	{
		zombie_doors[i] notify("trigger",players[0]);
		
		if ( is_true( zombie_doors[i].power_door_ignore_flag_wait ) )
		{
			zombie_doors[i] notify( "power_on" );
		}
		
		wait(.05);
	}

	// AIRLOCK DOORS ----------------------------------------------------------------------------- //
	zombie_airlock_doors = GetEntArray( "zombie_airlock_buy", "targetname" ); 

	for( i = 0; i < zombie_airlock_doors.size; i++ )
	{
		zombie_airlock_doors[i] notify("trigger",players[0]);
		wait(.05);
	}

	// DEBRIS ---------------------------------------------------------------------------- //
	zombie_debris = GetEntArray( "zombie_debris", "targetname" ); 

	for( i = 0; i < zombie_debris.size; i++ )
	{
		zombie_debris[i] notify("trigger",players[0]); 
		wait(.05);
	}

	// BUILDABLES ---------------------------------------------------------------------------- //
	foreach( buildable in level.zombie_buildables )
	{
		buildable.buildableZone notify("built",players[0]);
		wait(.05);
	}

	level notify("open_sesame");
	wait( 1 );			
	SetDvar( "zombie_unlock_all", 0 );
}

diable_fog_in_noclip()
{
	level.fog_disabled_in_noclip = 1;
	level endon("allowfoginnoclip");
	flag_wait( "start_zombie_round_logic" ); 
	while (1)
	{
		while(!GET_PLAYERS()[0] IsInMoveMode( "ufo", "noclip" ) )
			wait 1;
		setdvar( "scr_fog_disable", "1" );
		setdvar( "r_fog_disable", "1" );
		while(GET_PLAYERS()[0] IsInMoveMode( "ufo", "noclip" ) )
			wait 1;
		setdvar( "scr_fog_disable", "0" );
		setdvar( "r_fog_disable", "0" );
	}
}

zombie_devgui_allow_fog()
{
	if ( level.fog_disabled_in_noclip )
	{
		level notify("allowfoginnoclip");
		level.fog_disabled_in_noclip = 0;
		setdvar( "scr_fog_disable", "0" );
		setdvar( "r_fog_disable", "0" );
	}
	else
	{
		thread diable_fog_in_noclip();
	}
}


zombie_devgui_give_money()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;
	
	self maps\mp\zombies\_zm_score::add_to_player_score( 100000 );
}

zombie_devgui_turn_player( index )
{
	players = GET_PLAYERS();
	if ( !IsDefined(index) || index >= players.size )
	{
		player = players[0];
	}
	else
	{
		player = players[index];
	}

	assert( IsDefined( player ) );
	assert( IsPlayer( player ) );
	assert( IsAlive( player ) );
	
	level.devcheater = 1;
	
	if( player HasPerk( "specialty_noname" ) )
	{
		println( "Player turned HUMAN" );
		player maps\mp\zombies\_zm_turned::turn_to_human();
	}
	else
	{
		println( "Player turned ZOMBIE" );
		player maps\mp\zombies\_zm_turned::turn_to_zombie();
	}
}


zombie_devgui_equipment_give( equipment )
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	level.devcheater = 1;
	
	self maps\mp\zombies\_zm_equipment::equipment_give( equipment );
}


zombie_devgui_give_monkey()
{
	self notify( "give_tactical_granade_thread" );
	self endon( "give_tactical_granade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_cymbal_monkey_give ) )
	{
		self [[ level.zombiemode_devgui_cymbal_monkey_give ]]();
		while( true )
		{
			self GiveMaxAmmo( "zombie_cymbal_monkey" );
			wait( 1 );
		}
	}
}

zombie_devgui_give_black_hole_bomb()
{
	self notify( "give_tactical_granade_thread" );
	self endon( "give_tactical_granade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_black_hole_bomb_give ) )
	{
		self [[ level.zombiemode_devgui_black_hole_bomb_give ]]();
		while( true )
		{
			self GiveMaxAmmo( "zombie_black_hole_bomb" );
			wait( 1 );
		}
	}
}

zombie_devgui_give_dolls()
{
	self notify( "give_tactical_granade_thread" );
	self endon( "give_tactical_granade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_nesting_dolls_give ) )
	{
		self [[ level.zombiemode_devgui_nesting_dolls_give ]]();
		while( true )
		{
			self GiveMaxAmmo( "zombie_nesting_dolls" );
			wait( 1 );
		}
	}
}

zombie_devgui_give_quantum_bomb()
{
	self notify( "give_tactical_granade_thread" );
	self endon( "give_tactical_granade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_quantum_bomb_give ) )
	{
		self [[ level.zombiemode_devgui_quantum_bomb_give ]]();
		while( true )
		{
			self GiveMaxAmmo( "zombie_quantum_bomb" );
			wait( 1 );
		}
	}
}

zombie_devgui_give_emp_bomb()
{
	self notify( "give_tactical_granade_thread" );
	self endon( "give_tactical_granade_thread" );
	
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	level.devcheater = 1;

	if ( isdefined( self get_player_tactical_grenade() ) )
	{
		self TakeWeapon( self get_player_tactical_grenade() );
	}

	if ( IsDefined( level.zombiemode_devgui_emp_bomb_give ) )
	{
		self [[ level.zombiemode_devgui_emp_bomb_give ]]();
		while( true )
		{
			self GiveMaxAmmo( "emp_grenade_zm" );
			wait( 1 );
		}
	}
}

zombie_devgui_invulnerable( playerindex, onoff )
{
	players = GET_PLAYERS();
	if ( players.size > playerindex )
	{
		if (onoff)
			players[playerindex] EnableInvulnerability();
		else
			players[playerindex] DisableInvulnerability();
	}
}

zombie_devgui_kill()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self DisableInvulnerability();
	self dodamage(self.health + 666, self.origin);
}

zombie_devgui_toggle_ignore()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self.ignoreme = !self.ignoreme;
}

zombie_devgui_revive()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );
	
	self reviveplayer(); 
	self notify( "stop_revive_trigger" );
	if (isdefined(self.revivetrigger) )
	{
		self.revivetrigger delete();
		self.revivetrigger = undefined;
	}
	self AllowJump( true );
	
	self.ignoreme = false;
	self.laststand = undefined;
	self notify("player_revived",self);
}

zombie_devgui_give_health()
{
	assert( IsDefined( self ) );
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	self notify( "devgui_health" );
	self endon( "devgui_health" );
	self endon( "disconnect" );
	self endon( "death" );
		
	level.devcheater = 1;

	while ( 1 )
	{
		self.maxhealth = 100000;
		self.health = 100000;

		self waittill_any( "player_revived", "perk_used", "spawned_player" );	
		wait( 2 );
	}
}


zombie_devgui_give_perk( perk )
{
	vending_triggers = GetEntArray( "zombie_vending", "targetname" );
	player = GET_PLAYERS()[0];
		
	level.devcheater = 1;

	if ( vending_triggers.size < 1 )
	{
		//iprintln( "Map does not contain any perks machines" );
		return;
	}

	for ( i = 0; i < vending_triggers.size; i++ )
	{
		if ( vending_triggers[i].script_noteworthy == perk )
		{
			vending_triggers[i] notify( "trigger", player );
			return;
		}
	}

	//iprintln( "Map does not contain perks machine with perk: " + perk );
}

zombie_devgui_give_powerup( powerup_name, now )
{
	player = GET_PLAYERS()[0];
	found = false;
		
	level.devcheater = 1;

	for ( i = 0; i < level.zombie_powerup_array.size; i++ )
	{
		if ( level.zombie_powerup_array[i] == powerup_name )
		{
			level.zombie_powerup_index = i;
			found = true;
			break;
		}
	}

	if ( !found )
	{
		//iprintln( "Powerup not found: " + powerup_name );
		return;
	}

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = (direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale);

	// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );
	level.zombie_devgui_power = 1;
	level.zombie_vars["zombie_drop_item"] = 1;
	level.powerup_drop_count = 0;
	if ( !IsDefined(now) || now )
		level thread maps\mp\zombies\_zm_powerups::powerup_drop( trace["position"] );
}


zombie_devgui_goto_round( target_round )
{
	player = GET_PLAYERS()[0];

	if ( target_round < 1 )
	{
		target_round = 1;
	}
	
	level.devcheater = 1;

	level.zombie_total = 0;
	maps\mp\zombies\_zm::ai_calculate_health( target_round );
	level.round_number = target_round - 1;

	level notify( "kill_round" );

	// fix up the hud
// 	if( IsDefined( level.chalk_hud2 ) )
// 	{
// 		level.chalk_hud2 maps\_zombiemode_utility::destroy_hud();
// 
// 		if ( level.round_number < 11 )
// 		{
// 			level.chalk_hud2 = maps\_zombiemode::create_chalk_hud( 64 );
// 		}
// 	}
// 
// 	if ( IsDefined( level.chalk_hud1 ) ) 
// 	{
// 		level.chalk_hud1 maps\_zombiemode_utility::destroy_hud();
// 		level.chalk_hud1 = maps\_zombiemode::create_chalk_hud();
// 
// 		switch( level.round_number )
// 		{
// 		case 0:
// 		case 1:
// 			level.chalk_hud1 SetShader( "hud_chalk_1", 64, 64 );
// 			break;
// 		case 2:
// 			level.chalk_hud1 SetShader( "hud_chalk_2", 64, 64 );
// 			break;
// 		case 3:
// 			level.chalk_hud1 SetShader( "hud_chalk_3", 64, 64 );
// 			break;
// 		case 4:
// 			level.chalk_hud1 SetShader( "hud_chalk_4", 64, 64 );
// 			break;
// 		default:
// 			level.chalk_hud1 SetShader( "hud_chalk_5", 64, 64 );
// 			break;
// 		}
// 	}
	
	//iprintln( "Jumping to round: " + target_round );
	wait( 1 );
	
	// kill all active zombies
	zombies = GetAiSpeciesArray( "axis", "all" );

	if ( IsDefined( zombies ) )
	{
		for (i = 0; i < zombies.size; i++)
		{
			if ( is_true( zombies[i].ignore_devgui_death ) )
			{
				continue;
			}
			zombies[i] dodamage(zombies[i].health + 666, zombies[i].origin);
		}
	}
}


zombie_devgui_monkey_round()
{
	if ( IsDefined( level.next_monkey_round ) )
	{
		zombie_devgui_goto_round( level.next_monkey_round );
	}
}

zombie_devgui_thief_round()
{
	if ( IsDefined( level.next_thief_round ) )
	{
		zombie_devgui_goto_round( level.next_thief_round );
	}
}

zombie_devgui_dog_round( num_dogs )
{
	if( !IsDefined( level.dogs_enabled ) || !level.dogs_enabled )
	{
		//iprintln( "Dogs not enabled in this map" );
		return;
	}

	if( !IsDefined( level.dog_rounds_enabled ) || !level.dog_rounds_enabled )
	{
		//iprintln( "Dog rounds not enabled in this map" );
		return;
	}

	if( !IsDefined( level.enemy_dog_spawns ) || level.enemy_dog_spawns.size < 1 )
	{
		//iprintln( "Dog spawners not found in this map" );
		return;
	}
	
	if ( !flag( "dog_round" ) )
	{
		//iprintln( "Spawning " + num_dogs + " dogs" );
		SetDvar( "force_dogs", num_dogs );
	}
	else
	{
		//iprintln( "Removing dogs" );
	}

	zombie_devgui_goto_round( level.round_number + 1 );
}

zombie_devgui_dog_round_skip()
{
	if ( IsDefined( level.next_dog_round ) )
	{
		zombie_devgui_goto_round( level.next_dog_round );
	}
}


zombie_devgui_dump_zombie_vars()
{
	if ( !IsDefined( level.zombie_vars ) )
	{
		return;
	}
		

	if( level.zombie_vars.size > 0 )
	{
		//iprintln( "Zombie Variables Sent to Console" );
		println( "#### Zombie Variables ####");
	}
	else
	{
		return;
	}
	
	var_names = GetArrayKeys( level.zombie_vars );
	
	for( i = 0; i < level.zombie_vars.size; i++ )
	{
		key = var_names[i];
		println( key + ":     " + level.zombie_vars[key] );
	}

	println( "##### End Zombie Variables #####");
}

zombie_devgui_pack_current_weapon()
{
	players = GET_PLAYERS();
	reviver = players[0];

	level.devcheater = 1;

	for ( i = 0; i < players.size; i++ )
	{
		if ( !players[i] maps\mp\zombies\_zm_laststand::player_is_in_laststand() )
		{
			weap = players[i] getcurrentweapon();
			if(!players[i] maps\mp\zombies\_zm_weapons::has_upgrade( weap ) )
			{
				weapon = get_upgrade( weap );
				if(isDefined(weapon))
				{
					players[i] GiveWeapon( weapon, 0, players[i] maps\mp\zombies\_zm_weapons::get_pack_a_punch_weapon_options( weapon ) );
					players[i] GiveStartAmmo( weapon );
					players[i] SwitchToWeapon( weapon );	
				}
			}
			
		}
	}
}

get_upgrade( weaponname )
{

	if( IsDefined(level.zombie_weapons[weaponname]) && IsDefined(level.zombie_weapons[weaponname].upgrade_name) )
	{
		return level.zombie_weapons[weaponname].upgrade_name ;

	}
	else
	{
		return undefined;
	}
}

zombie_devgui_director_easy()
{
	if ( IsDefined( level.director_devgui_health ) )
	{
		[[ level.director_devgui_health ]]();
	}
}


zombie_devgui_chest_never_move()
{
	level notify( "devgui_chest_end_monitor" );
	level endon( "devgui_chest_end_monitor" );

	for ( ;; )
	{
		level.chest_accessed = 0;
		wait( 5 );
	}
}


zombie_devgui_disable_kill_thread_toggle()
{
	if ( !is_true( level.disable_kill_thread ) )
	{
		level.disable_kill_thread = true;
	}
	else
	{
		level.disable_kill_thread = false;
	}
}


zombie_devgui_check_kill_thread_every_frame_toggle()
{
	if ( !is_true( level.check_kill_thread_every_frame ) )
	{
		level.check_kill_thread_every_frame = true;
	}
	else
	{
		level.check_kill_thread_every_frame = false;
	}
}


#/
