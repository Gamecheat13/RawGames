#include maps\_utility;
#include maps\pel2_util;
#include maps\pel2_fx;


main()
{
	
	maps\_tiger::main("vehicle_tiger_woodland");
	//maps\_panzer2::main("vehicle_panzer_ii_winter");
	//maps\_stuka::main("vehicle_stuka_flying");
	maps\_sherman::main("vehicle_american_sherman");
	maps\_mganim::main();
	
	add_start( "mangrove_exit", ::start_mangrove_exit );
	add_start( "tank_mantle", ::start_tank_mantle );
	add_start( "town", ::start_town );
	add_start( "airfield", ::start_airfield );
	//add_start( "right_bottom", ::start_event5 );
	default_start( ::mangrove );
	
	maps\_load::main();
	
	maps\pel2_status::main();
	
	precacheFX();
	
	setup_guzzo_hud();

	// setup player and friendlies
	setup_players();
	setup_friendlies();
	setup_objectives();
	
}


mangrove()
{
	
	maps\_status::show_task( "Event1" );
	
	level thread setup_bunkers();
	level thread vehicle_spawn_notif();
	level thread vehicle_spawn_move();	
	
}

start_mangrove_exit()
{

	quick_text( "start_mangrove_exit", 4 );

	start_teleport_players( "orig_start_mangrove_exit" );	
	start_teleport_ai( "orig_start_mangrove_exit" );	
	
	set_player_chain( "auto147" );
	
}

start_tank_mantle()
{
}

start_town()
{
	
	quick_text( "start_town", 4 );

	start_teleport_players( "orig_start_town" );	
	start_teleport_ai( "orig_start_town" );	
	
	maps\pel2_town::main();
	
}

start_airfield()
{
	
	quick_text( "start_airfield", 4 );

	start_teleport_players( "orig_start_airfield" );	
	start_teleport_ai( "orig_start_airfield" );	
	
	set_player_chain( "node_airfield_chain" );

	maps\pel2_airfield::main();

}

vehicle_spawn_notif()
{
	
	trig = getent( "trig_spawn_beach_tank", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "spawn_tank" );
	
}

vehicle_spawn_move()
{
	
	trig = getent( "trig_move_beach_tank", "targetname" );
	trig waittill( "trigger" );	
	
	quick_text( "move_tank" );

	// have tank stop so it blocks the path	
	tank = getent( "bunker_tank", "targetname" );

	wait_node = getvehiclenode( "node_tank_reverse", "targetname" );
	
	tank setWaitNode( wait_node );
	tank waittill( "reached_wait_node" );		

	tank setSpeed( 0, 2, 2 );
	
	quick_text( "tank_stopping" );
	
	// handle the mantling of the tank
	level thread bunker_tank_mantle();
	
}

bunker_tank_mantle()
{

	// TODO make this coop compatible
	players = get_players();
	
	trig = getent( "trig_tank_mantle", "targetname" );

	while( 1 )
	{
		
		if( isalive( players[0] ) )
		{
				
			if( players[0] istouching( trig ) )
			{
			
				quick_text( "press fire to mantle tank!" );
			
				if( players[0] ButtonPressed( "mouse1" ) )
				{
				
					break;
				
				}
				
			}
					
		}
		wait ( 0.05 );
		
	}
	
	quick_text( "tank_mantled!" );

	tank = getent( "bunker_tank", "targetname" );

	// blow it up!
	playfx( level._effect["grenadeExp_dirt"], tank.origin + ( 0, 0, 100 ) );
	playfx( level._effect["grenadeExp_dirt"], tank.origin + ( 50, -50, 0 ) );
	playfx( level._effect["large_vehicle_explosion"], tank.origin );

	wait ( 1 );

	// move it out of the way so the squad can advance
	tank setSpeed( 5, 2, 2 );

	wait ( 2 );
	
	set_player_chain( "node_town_chain" );
	
}


setup_players()
{

	players = get_players();

	for( i = 0; i < players.size; i++ )
	{
		players[i] GiveWeapon( "m1garand" );
		players[i] GiveWeapon( "thompson" );
		players[i] GiveWeapon( "fraggrenade" );
		players[i] SwitchToWeapon( "m1garand" );
	}
	
}

setup_friendlies()
{

	level.totalfriends = 4;
	level.maxfriendlies = 4;	// max number of friendly ai spawned at a time

	// start the first friendly chain
	set_player_chain( "node_chain_1" );


	array_thread( getentarray( "friendly_squad", "targetname" ), ::friendly_setup_thread );

}

friendly_setup_thread()
{

	self setgoalentity ( get_random_player() );
	self thread magic_bullet_shield();
	
	self.script_noteworthy = "friendly_squad_ai";
	
}


setup_bunkers()
{

	trig = getent( "trig_setup_bunkers", "targetname" );
	trig waittill( "trigger" );
	
	quick_text( "setup_bunkers" );

	simple_spawn( "bunker_gun_1_spawners" );
	simple_spawn( "bunker_1_spawners" );
	
}


setup_objectives()
{
	
	objective_add( 0, "active", "Secure Mangrove area", ( 0, 0, 0 ) ); 
	objective_current ( 0 ); 
	
	level waittill( "obj_mangrove_complete" );
	
	objective_state ( 0, "done" );
	

}
