#include maps\_utility;
main()
{
	//maps\_sherman::main( "vehicle_american_sherman" );
	maps\_jeep::main( "test_willysjeep_cod3" );
	maps\_load::main();
	maps\coop_test1_fx::main();

	level.maxfriendlies = 4;
	setup_friendlies();

	set_objective( 0 );

	level thread autosave_test();
	level thread event2();

//	array_thread( get_players(), ::temp_loadout );

	PrecacheModel( "fx" ); // TEMP
	level.mortar = LoadFx( "explosions/fx_mortarExp_dirt" );
	level thread mortar_loop();
	
	level.useable_jeep = getent("player_jeep","targetname");
	level.useable_jeep makevehicleusable();
	level.useable_jeep.team = "allies";
	
	level.countdown_bypass = undefined;
	
	level.remaining_bombs = 3;
	
	level thread jeep_health_regen();
}

autosave_test()
{
	wait( 20 );
	autosave_by_name( "Coop_Test1_Save1" );
}

setup_friendlies()
{
	players = get_players();

	node = GetNode( "event1_chain1", "targetname" );
	players[0] SetFriendlyChain( node );

	guys = GetAiArray( "allies" );
	for( i = 0; i < guys.size; i++ )
	{
		guys[i] SetGoalEntity( players[0] );
	}
}

event2()
{
	trigger = GetEnt( "event2", "targetname" );
	trigger waittill( "trigger" );

	level thread set_bomb_objective( "bomb_set1", 5, 201 );
	//level thread event1_wall_damage_trig();
	
	set_objective( 1 );
		
	level waittill( "explode_bomb_set1" );
	PhysicsExplosionSphere( ( -1536, -2456, -64 ), 256, 128, 0.5 );

	set_objective( 2 );
	
	level thread end_game_setup();

	more_bombs = GetEntArray( "trigger_use", "classname" );
	for( i = 0; i < more_bombs.size; i++ )
	{
		// only use the triggers with a groupname of "event2_bombs"
		if( IsDefined( more_bombs[i].groupname ) && more_bombs[i].groupname == "event2_bombs" )
		{
			level thread set_bomb_objective( more_bombs[i].targetname, 5 );
		}
	}
	
	level thread set_bomb_objective( "bomb_set2", 5, 210 );
	//level thread event2_wall_damage_trig();
	level waittill( "explode_bomb_set2" );
	PhysicsExplosionSphere( ( -728, -672, -128 ), 256, 128, 0.5 );
	
	level thread set_bomb_objective( "bomb_set3", 5, 220 );
	//level thread event3_wall_damage_trig();
	level waittill( "explode_bomb_set3" );
	PhysicsExplosionSphere( ( -744, -560, -134 ), 256, 128, 0.5 );

}

end_game_setup()
{
	level thread set_bomb_objective( "bomb_set4", 5, 230 );
	level waittill( "explode_bomb_set4" );
	PhysicsExplosionSphere( ( 1072, -1192, -178 ), 256, 128, 0.5 );
	missionsuccess("coop_test1", 0);
}
//
//event1_wall_damage_trig()
//{
//	level endon ("explode_bomb_set1");
//	
//	getent("wall_1_damage_trig","targetname") waittill ("trigger", attacker);
//	//level notify( "explode_bomb_set1");
//	level.countdown_bypass = 0.1;
//	owner = undefined;
//	use_trigs = getentarray("bomb_set1","targetname");
//	
//	if (attacker.classname == "script_vehicle")
//	{
//		owner = attacker GetVehicleowner(); 
//	}
//	
//	for (i = 0; i < use_trigs.size; i++)
//	{
//		use_trigs[i] useby (owner);
//	}
//}
//
//
//event2_wall_damage_trig()
//{
//	level endon ("explode_bomb_set2");
//	
//	getent("wall_2_damage_trig","targetname") waittill ("trigger", attacker);
//	//level notify( "explode_bomb_set1");
//	level.countdown_bypass = 0.1;
//	owner = undefined;
//	use_trigs = getentarray("bomb_set2","targetname");
//	
//	if (attacker.classname == "script_vehicle")
//	{
//		owner = attacker GetVehicleowner(); 
//	}
//	
//	for (i = 0; i < use_trigs.size; i++)
//	{
//		use_trigs[i] useby (owner);
//	}
//}
//
//event3_wall_damage_trig()
//{
//	level endon ("explode_bomb_set3");
//	
//	getent("wall_3_damage_trig","targetname") waittill ("trigger", attacker);
//	//level notify( "explode_bomb_set1");
//	level.countdown_bypass = 0.1;
//	owner = undefined;
//	use_trigs = getentarray("bomb_set3","targetname");
//	
//	if (attacker.classname == "script_vehicle")
//	{
//		owner = attacker GetVehicleowner(); 
//	}
//	
//	for (i = 0; i < use_trigs.size; i++)
//	{
//		use_trigs[i] useby (owner);
//	}
//}

set_objective( num )
{
	if( num == 0 )
	{
		objective_add( 0, "active", "Assault Town", ( -824, -3664, -181 ) );
		objective_current( 0 );
	}
	else if (num == 1)
	{
		objective_state (0, "done");
		objective_add( 1, "active", "Destroy the wall", ( -2136, -2504, -168 ) );
		objective_current( 1 );
		objective_string(1 , "Destroy the wall", " [", level.remaining_bombs, " of ", 3, " remaining]");
	}
	else if (num == 1.1)
	{
		objective_string(1 , "Destroy the wall", " [", level.remaining_bombs, " of ", 3, " remaining]");		
	}
	else if (num == 2)
	{
		objective_state (1, "done");
		objective_add( 2, "active", "Destroy the AAA Gun", ( 1072, -1192, -178 ) );
		objective_current( 2 );
	}
}

temp_loadout()
{
	self GiveWeapon( "m1garand" );
	self GiveWeapon( "thompson" );
	self SwitchToWeapon( "m1garand" );
	self GiveWeapon( "fraggrenade" );
}

mortar_loop()
{
	mortars = getentarray( "mortar", "targetname" );

	if( !IsDefined( level.mortar ) )
	{
		error ("level.mortar not defined. define in level script");
	}

	if( !Isdefined( level.mortar_min_delay ) )
	{
		level.mortar_min_delay = 0.5;
	}

	if( !Isdefined( level.mortar_max_delay ) )
	{
		level.mortar_max_delay = 2;
	}

	if( !IsDefined( level.mortar_player_min_range ) )
	{
		level.mortar_player_min_range = 350;
	}

	if( !IsDefined( level.mortar_player_max_range ) )
	{
		level.mortar_player_max_range = 4000;
	}

	lastmortar = -1;
	while( 1 )
	{
		wait( RandomFloat( level.mortar_min_delay ) + RandomFloat( level.mortar_max_delay ) );

		r = RandomInt( mortars.size );

		for( i = 0; i < mortars.size; i++ )
		{
			c = ( i + r ) % mortars.size;

			if( c == lastmortar )
			{
				continue;
			}

			players = get_players();

			do_mortar = false;
			for( q = 0; q < players.size; q++ )
			{
				dist = Distance( players[q].origin, mortars[c].origin);
				if( dist < level.mortar_player_max_range )
				{
					do_mortar = true;
				}

				if( dist < level.mortar_player_min_range )
				{
					do_mortar = false;
				}
			}

			if( do_mortar )
			{
				mortars[c] maps\_mortar::activate_mortar( undefined, undefined, undefined, undefined, undefined, undefined, false );
				lastmortar = c;
				break;
			}
		}
	}
}

set_bomb_objective( name, countdown, exploder_num )
{
	triggers = GetEntArray( name, "targetname" );

	if( !IsDefined( level.bombs_planted ) )
	{
		level.bombs_planted = [];
	}

	level.bombs_planted[name] = 0;
	
	bomb_origins = [];
	bombs = [];
	for( i = 0; i < triggers.size; i++ )
	{
		bomb = GetEnt( triggers[i].target, "targetname" );
		triggers[i] thread bomb_plant_thread( triggers.size, bomb, name );

		if( !IsDefined( exploder_num ) )
		{
			exploder_num = bomb.script_noteworthy;
		}

		bombs[bombs.size] = bomb;
		
		if (name == "bomb_set1")
		{
			Objective_Add(i+2, "active","", bomb.origin);
			Objective_State(i+2, "current");
			bomb.objnum = i+2;
		}
	}

	level waittill( name + "_all_bombs_planted" );
	bombs_countdown( countdown );

	level notify( "explode_" + name );
	activate_exploder( exploder_num );

	for( i = 0; i < bombs.size; i++ )
	{
		PlayFx( level._effect[name], bombs[i].origin ); 
//		play_sound_in_space( "soundalias", bombs_origins[i] ); 

		PhysicsExplosionSphere( bombs[i].origin, 256, 128, 0.5 );

		bombs[i] Delete();
	}
}

bomb_plant_thread( total_bombs, bomb, name )
{
	self waittill( "trigger" );

	bomb SetModel( "fx" );

	level.remaining_bombs = level.remaining_bombs - 1;
	
	if (name == "bomb_set1")
	{
		objective_delete (bomb.objnum);
		set_objective( 1.1 );
	}
	
	level.bombs_planted[name]++;
	if( level.bombs_planted[name] == total_bombs )
	{
		level notify( name + "_all_bombs_planted" );
	}

	self Delete();
}

bombs_countdown( timer )
{
	if (!isdefined (level.countdown_bypass))
	{
		count_down( timer );
	}
	else
	{
			count_down( level.countdown_bypass );
	}
}

count_down( time )
{
	x = 580;
	y = 240;
	scale = 1.5;

	hud = NewHudElem();
	hud.x = x;
	hud.y = y;
	hud.fontScale = scale;
	hud.alpha = 1;

	hud SetTimer( time );

	wait( time );
	hud Destroy();
	level.countdown_bypass = undefined;
}

jeep_health_regen()
{
		while (1)
		{
				level.useable_jeep.health = 999999999;
				level.useable_jeep makevehicleusable();
				wait 1;
		}
}