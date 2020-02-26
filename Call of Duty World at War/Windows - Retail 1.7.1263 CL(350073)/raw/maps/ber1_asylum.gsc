// scripting by Bloodlust
// level design by BSouds

#include maps\_anim;
#include maps\_utility;
#include maps\ber1_util;
#include maps\pel2_util;
#include common_scripts\utility;
#include maps\_music;


#using_animtree("generic_human");

main()
{

	// flag set on trigger
	flag_wait( "asylum_start" );
	
	collectible_corpse();
	
	//Tuey Set music state to ASYLUM
	setmusicstate("ASYLUM");

	maps\_debug::set_event_printname( "Asylum" );

	level thread event2_rejoin_squad();

	level thread hero_chain_start();

	// Wii optimizations
	if( !level.wii && !NumRemoteClients())
	{
		//ambient retreaters
		level thread distant_retreaters();
	}

	level thread fallingdebris_think();	

	//VO threads
	level thread dialogue_waittills();

	//trigger wait and spawns for AI
	level thread enemy_trigspawn();

	//cleared aigroup calls for color chain movement
	level thread rooftop_cleared();
	level thread front_bathroom_cleared();
	level thread back_bathroom_cleared();
	level thread front_mg_room_cleared();
	level thread mg_room_cleared();
	level thread autosave_near_stairs();
	
	//using multiple triggers with flagsets to have both paths move up appropriately
	level thread color_chain_cleanup();
	level thread color_chain_cleanup_2();
	level thread first_floor_chain_delete();
	level thread courtyard_color_chain();

}



second_floor_threads()
{
	
	level thread autosave_after_balcony();
	
	//panzer guys on roof and window
	level thread roof_panzer_guy();
	level thread window_panzer();	

	//kill off funcs
	level thread kill_off_rooftop_germans();	
	
	//popnrun
	level thread mg_room_popnrun();
	level thread hallway_popnrun();	
	
	//bathroom event
	level thread bathroom_ambush();	

	level thread last_defenders_cleared();

	//sets up the ending event.
	level thread prepare_tankride();
	
}



autosave_near_stairs()
{
	flag_wait( "stair_vo_override" );
	autosave_by_name( "Ber1 asylum stairs" );
}


autosave_after_balcony()
{

	trigger_wait( "hallway_color_chain", "targetname" );
	autosave_by_name( "Ber1 after balcony" );
	
}



collectible_corpse()
{

	orig = getstruct( "orig_collectible_loop", "targetname" );

	corpse = spawn( "script_model", orig.origin );
	corpse.angles = orig.angles;
	corpse character\char_ger_wrmcht_k98::main();
	corpse detach( corpse.gearModel );
	corpse UseAnimTree( #animtree );
	corpse.animname = "collectible";
	corpse.targetname = "collectible_corpse";

	level thread anim_loop_solo( corpse, "collectible_loop", undefined, "stop_collectible_loop", orig );
	
}



setup_crows()
{

	trigger_wait( "trig_spawn_crows", "targetname" );

	level thread atrium_crow_damage_trig();
	level thread atrium_crows();
	level thread indoor_crow_damage_trig();
	level thread indoor_crows();

}



wait_for_staircase_trig()
{
	level endon( "kill_staircase_spawn_trig" );

	self waittill( "trigger" );
	
	set_color_chain( "green_chain_before_stairs" );

//	simple_spawn( "staircase_germs" );
	//yellow in radiant


//	simple_floodspawn( "stair_fs_wave1" );

	flag_set( "kill_staircase_spawn_trig" );

}



staircase_floodspawn_func()
{

	trig = getentarray( "staircase_wave2_trig", "targetname" );
//	trig waittill( "trigger" );
	trig_1 = trig[0];
	trig_2 = trig[1];

	trig_1 thread wait_for_wave2_trig();
	trig_2 thread wait_for_wave2_trig();
	
}



wait_for_wave2_trig()
{

	level endon( "kill_wave2_trig" );

	self waittill( "trigger" );

	set_color_chain( "yellow_chain_moveup_atrium" );

//	simple_floodspawn( "stair_fs_wave2" );

	flag_set( "kill_wave2_trig" );

}



hero_chain_start()
{

	hero_chain_trig = getent( "go_upstairs", "script_noteworthy" );
	hero_chain_trig waittill( "trigger" );
	
	allies = getaiarray( "allies" );

	for( i = 0; i < allies.size; i++ )
	{
		allies[i] set_force_color( "g" );
	}

	set_color_heroes( "o" );
	
	set_color_chain( "orange_hero_chain" );
	

}



color_chain_cleanup()
{

//	level endon( "atrium_color_chain" );
	
	chain_trig = getent( "chain_before_stairs", "script_noteworthy" );
	chain_trig waittill( "trigger" );

	flag_set( "atrium_color_chain" );

}



color_chain_cleanup_2()
{

//	level endon( "indoor_chain" );
	
	chain_trig = getent( "flag_indoor_chain", "script_noteworthy" );
	chain_trig waittill( "trigger" );

	flag_set( "indoor_chain" );

}



delete_route1_fs()
{
	route1_trig = getent( "route1_fs_backup", "script_noteworthy" );

	delete_trig = getent( "delete_route1_trig", "script_noteworthy" );
	delete_trig waittill( "trigger" );

	if( isdefined( route1_trig ) )
	{
		route1_trig delete();
	}

}



back_hallway_battle()
{

//	flag_wait( "panzer_guy_fire" );
//	simple_floodspawn( "balcony_guard" );
//
//	trig = getent( "back_hall_germ_trig", "script_noteworthy" );
//	trig waittill( "trigger" );
//	
//	simple_spawn( "back_hall_germs" );

}



enemy_trigspawn()
{

	//handles spawning of guys in the room just before mg
//	hallway_defender_trig = getent( "hallway_defender_trig", "script_noteworthy" );
//	hallway_defender_trig waittill( "trigger" );
	hallway_defender_trig = getent( "window_panzer_wait", "targetname" );
	hallway_defender_trig waittill( "trigger" );
//	simple_spawn( "hallway_defenders" );
	simple_floodspawn( "hallway_defenders_fs" );
	
	//rooftop spawns
	//deleted roof_top trig and using a existing trigger to save ents
//	rooftop_trig = getent( "rooftop_trig", "targetname" );
//	rooftop_trig waittill( "trigger" );

	roof_trig = getent( "panzer_wait", "targetname" );
	roof_trig waittill( "trigger" );
	
	simple_floodspawn( "rooftop_panzers", ::rooftop_germ_behaviour);
	simple_floodspawn( "terrace_germ" );
	simple_floodspawn( "rooftop_panzers_fs", ::roof_panzer_behaviour  );

	mg_gunner_trig = getent( "mg_gunner_trig", "script_noteworthy" );
	mg_gunner_trig waittill( "trigger" );
	thread mg_setup();
	simple_floodspawn( "mg_gunner", ::mg_gunner_behavior );



	mg_spawn_room_trig = getent( "mg_spawn_room_trig", "targetname" );
	mg_spawn_room_trig waittill( "trigger" );
	simple_floodspawn( "mg_room_spawners" );


//	//flood_spawners in the room just before mg
//	mg_room_spawners_trig = getent( "mg_room_spawners_trig", "script_noteworthy" );
//	mg_room_spawners_trig waittill( "trigger" );
//	simple_floodspawn( "mg_room_spawners" );

	last_defenders_trig = getent( "trig_last_defenders", "script_noteworthy" );
	last_defenders_trig waittill( "trigger" );
	simple_floodspawn( "last_defenders" );

	berlin_runner_trig = getent( "berlin_runner_trig", "targetname" );
	berlin_runner_trig waittill( "trigger" );

	// Wii optimizations
	if( !level.wii && !NumRemoteClients())
	{
		simple_spawn( "berlin_runners", ::berlin_runner_behaviour );
	}

	simple_floodspawn( "last_defenders_back" );

}



mg_gunner_behavior()
{

	self endon( "death" );

	self.goalradius = 16;

	self.ignoreall = true;
	self.ignoreme = true;
	self.pacifist = 1;
	self waittill("goal");
	
	// flag set on trigger
	flag_wait( "begin_mg_event" );

	self.pacifist = 0;
	self.ignoreall = false;
	self.ignoreme = false;

//	self thread mg_shooting();

}



mg_shooting()
{
	
	self endon( "death" );

	mg_targets = getentarray( "mg_targets", "targetname" );
	
	for( i=0; i < mg_targets.size; i++ )
	{
		self SetEntityTarget( mg_targets[randomint( mg_targets.size)], 0.5 );
	}
}



mg_setup()
{

	hallway_mg = getent( "hallway_mg", "targetname" );
//	hallway_mg setmode( "auto_ai" );
	hallway_mg setturretignoregoals( true );	

}



first_floor_chain_delete()
{
	
	upstairs_chain = getent( "go_upstairs", "script_noteworthy" );
	right_chain = getent( "chain_before_stairs", "script_noteworthy" );
	atrium_chain = getent( "flag_indoor_chain", "script_noteworthy" );

	upstairs_chain waittill( "trigger" );

//	if( isdefined( upstairs_chain ) )
//	{
		if( isdefined( right_chain ) )
		{
			right_chain delete();
		}
	
	
		if( isdefined( atrium_chain ) )
		{
			atrium_chain delete();
		}

//	}

}

courtyard_color_chain()
{
	
	//trig to delete
	delete_trig = getent( "yellow_courtyard_trig", "targetname" );


	//trig if hit deletes 
	wait_trig = getent( "asylum_entry_vo", "targetname" );
	wait_trig waittill( "trigger" );

	if( isdefined( delete_trig ) )
	{
		delete_trig delete();
	}


}


front_bathroom_cleared()
{

	waittill_aigroupcleared( "front_bathroom_spawners" );

	front_bathroom_chain = getent( "front_bathroom_chain", "targetname" );
	if( isdefined( front_bathroom_chain ) )
	{
		front_bathroom_chain notify( "trigger" );
	}

}



back_bathroom_cleared()
{

	waittill_aigroupcleared( "back_bathroom_spawners" );

	front_bathroom_chain = getent( "front_bathroom_chain", "targetname" );
	if( isdefined( front_bathroom_chain ) )
	{
		front_bathroom_chain notify( "trigger" );
	}

	back_bathroom_chain = getent( "back_bathroom_chain", "targetname" );
	if( isdefined( back_bathroom_chain ) )
	{
		back_bathroom_chain notify( "trigger" );	
	}
}



rooftop_cleared()
{
	
	waittill_aigroupcleared( "rooftop_germans" );

	chain_trig = getent( "hallway_color_chain", "targetname" );
	if( isdefined( chain_trig ) )
	{
		chain_trig notify( "trigger" );	
	}


}



///////////////////
//
// once all the guys at the asylum exit are cleared, advance up the squad
//
///////////////////////////////

last_defenders_cleared()
{

	waittill_aigroupcleared( "last_defenders" );

	chain_trig = getent( "color_chain_exit_asylum", "script_noteworthy" );
	if( isdefined( chain_trig ) )
	{
		chain_trig delete();
	}
	
	wait( randomfloatrange( 1.25, 3.0 ) );
	
	exit_trig = getent( "trig_asylum_exit", "script_noteworthy" );
	if( isdefined( exit_trig ) )
	{
		exit_trig notify( "trigger" );	
	}

}



front_mg_room_cleared()
{

	waittill_aigroupcleared( "front_mg_germs" );

	chain_trig = getent( "green_chain_team2", "targetname" );
	if( isdefined( chain_trig ) )
	{
		chain_trig notify( "trigger" );	
	}

}



mg_room_cleared()
{

	waittill_aigroupcleared( "mg_room_germs" );


//	chain_trig = getent( "green_chain_test", "targetname" );
//	if( isdefined( chain_trig ) )
//	{
//		chain_trig notify( "trigger" );	
//	}

	chain_trig = getent( "green_chain_team2", "targetname" );
	if( isdefined( chain_trig ) )
	{
		chain_trig notify( "trigger" );	
	}

	chain_trig = getent( "yellow_chain_team2", "targetname" );
	if( isdefined( chain_trig ) )
	{
		chain_trig notify( "trigger" );	
	}
}



roof_panzer_guy()
{

	panzer_target = getstruct( "panzer_guy_target", "targetname" );


	//rumble stucts
//	rumble_structs = getstructarray( "panzer_guy_target_rumble", "targetname" );

//	target_rumble = getstruct( "panzer_guy_target_rumble", "targetname" );
//	target_rumble2 = getstruct( "panzer_guy_target_rumble2", "targetname" );
//	target_rumble3 = getstruct( "panzer_guy_target_rumble3", "targetname" );

	trigger = getent( "panzer_wait", "targetname" );
	trigger waittill( "trigger" );

	simple_spawn( "berlin_panzer_guy", ::roof_panzer_guy_behaviour );

	earthquake_trig = getent( "earthquake_trig", "targetname" );
	earthquake_trig waittill( "trigger" );

	touch_trig = getent( "earthquake_touch_trig", "targetname" );
	players = getplayers();

	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i] ) && players[i] IsTouching( touch_trig ) )
		{
			PlayRumbleOnPosition( "grenade_rumble", players[i].origin );
		}
	}

//	for( i = 0; i < rumble_structs.size; i ++ )
//	{
//
//		rumble_structs[i] thread rumble();
//	}

	//note: Earthquake( <scale>, <duration>, <source>, <radius> )
//	PlayRumbleOnPosition( "grenade_rumble", target_rumble.origin );
//	PlayRumbleOnPosition( "grenade_rumble", target_rumble2.origin );
//	PlayRumbleOnPosition( "grenade_rumble", target_rumble3.origin );
	earthquake(0.5, 1.5, panzer_target.origin, 512);
}



roof_panzer_guy_behaviour()
{
	self endon( "death" );

	//the ability to set how many rockets a panzershreck guy can have
	//guy.a.rockets = 1;	
	self.a.rockets = 1;
	self.goalradius = 16;

	self.ignoresuppression = 1;
	self.ignoreall = true;
	self.ignoreme = true;
	self.pacifist = 1;

	node = getnode( "panzer_wait_fire", "targetname" );

	wait_trig = getent( "panzer_wait", "targetname" );
//	fire_trig = getent( "panzer_guy_fire", "targetname" );

	wait_trig waittill( "trigger" );

	self setgoalnode( node );
	self waittill("goal");
//	self allowedstances( "stand" );

	flag_wait( "panzer_guy_fire" );

	self.pacifist = 0;
	self.ignoresuppression = 0;
	self.ignoreall = false;
	self.ignoreme = false;

	self panzer_fire();
}



panzer_fire()
{

	self endon( "death" );

	panzer_target = getstruct( "panzer_guy_target", "targetname" );
	panzer_target_ent = spawn( "script_origin", panzer_target.origin );
	panzer_target_ent.health = 1000000;

	self SetEntityTarget( panzer_target_ent );

}



rumble()
{
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
}



window_panzer()
{
	window_target = getstruct( "window_panzer_target", "targetname" );

	//rumble structs
//	rumble_structs = getstructarray( "window_panzer_rumble", "targetname" );
//	window_rumble = getstruct( "window_panzer_rumble", "targetname" );
//	window_rumble2 = getstruct( "window_panzer_rumble2", "targetname" );
//	window_rumble3 = getstruct( "window_panzer_rumble3", "targetname" );

	trigger = getent( "window_panzer_wait", "targetname" );
	trigger waittill( "trigger" );

	simple_spawn( "window_panzer", ::window_panzer_behaviour );

	earthquake_trig_2 = getent( "earthquake_trig_2", "targetname" );
	earthquake_trig_2 waittill( "trigger" );


	touch_trig = getent( "earthquake_touch_trig", "targetname" );
	players = getplayers();

	for( i = 0; i < players.size; i++ )
	{
		if( IsDefined( players[i] ) && players[i] IsTouching( touch_trig ) )
		{
			PlayRumbleOnPosition( "grenade_rumble", players[i].origin );
		}
	}

//	for( i = 0; i < rumble_structs.size; i ++ )
//	{
//
//		rumble_structs[i] thread rumble();
//	}

//	PlayRumbleOnPosition( "grenade_rumble", window_rumble.origin );
//	PlayRumbleOnPosition( "grenade_rumble", window_rumble2.origin );
//	PlayRumbleOnPosition( "grenade_rumble", window_rumble3.origin );
	earthquake(0.5, 1.5, window_target.origin, 512);

}



window_panzer_behaviour()
{
	self endon( "death" );

	self.a.rockets = 1;
	self.goalradius = 16;

	self.ignoreall = true;
	self.ignoreme = true;
	self.pacifist = 1;
	self waittill("goal");

	flag_wait( "window_guy_fire" );

	self.pacifist = 0;
	self.ignoreall = false;
	self.ignoreme = false;

	self window_panzer_fire();

}



window_panzer_fire()
{
	self endon( "death" );

	window_panzer_target = getstruct( "window_panzer_target", "targetname" );
	window_panzer_target_ent = spawn( "script_origin", window_panzer_target.origin );
	window_panzer_target_ent.health = 1000000;

	self SetEntityTarget( window_panzer_target_ent );
}



first_runners_func()
{

	self endon( "death" );

	self.pacifist = 1;
	self.ignoresuppression = 1;
	self.goalradius = 64;
	self.ignoreall = true;
//	self.ignoreme = true;

	delete_node = getnode( "first_runner_delete_node", "targetname" );
	
	self setgoalnode( delete_node );
	self waittill( "goal" );
	
	self delete();

}



coward_spawn_func()
{

	self endon( "death" );	

	self.pacifist = 1;
	self.ignoresuppression = 1;
	self.goalradius = 64;
	self.ignoreall = true;
	self.ignoreme = true;

	delete_node = getnode( "delete_coward_germs", "targetname" );
	
	self setgoalnode( delete_node );
	self waittill( "goal" );
	
	self delete();


}



distant_retreaters()
{
	
	flag_wait( "panzer_guy_fire" );

	//deleted this trigger. using a flag_set in the same spot
//	trig = getent( "distant_retreater_trig", "script_noteworthy" );
//	trig waittill( "trigger" );
	
//	simple_spawn( "roof_jumpdown_germs" );
	simple_spawn( "distant_retreaters", :: distant_retreater_setup );

}



distant_retreater_setup()
{
	
	self endon( "death" );

	delete_node = getnode( "retreater_delete", "targetname" );
	
	self.pacifist = 1;
	self.ignoresuppression = 1;
	self.goalradius = 64;
	self.ignoreall = true;
	self.ignoreme = true;

	self setgoalnode( delete_node );
	self waittill( "goal" );

	self delete();
}



courtyard_patroller_behavior()
{
	self endon( "death" );

	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;

	patroller_node = getnode( "patroller_node", "targetname" );
	self setgoalnode( patroller_node );
	self waittill("goal");

	self.script_goalvolume = 144;
	self.ignoreall = false;
	self.ignoreme = false;



}



mg_room_popnrun()
{
	
	// flag set on trigger
	flag_wait( "begin_mg_event" );
	simple_spawn( "pop_germ" );

}



run_germ_setup()
{

	self endon( "death" );

	self.goalradius = 32;
	self.ignoreall = true;
	self.ignoreme = true;
	self.pacifist = 1;
	self.ignoresuppression = 1;

	//deleted this node's targetname and gave it a script_fallback of 216.
	goal_node = getnode( "run_germ_node", "targetname" );
	self setgoalnode( goal_node );
	self waittill("goal");

	self.pacifist = 0;
	self.ignoresuppression = 0;
	self.ignoreall = false;
	self.ignoreme = false;

}



//for guy running away in the hallway and guy popping out of corner
hallway_popnrun()
{
	trig = getent( "window_panzer_wait", "targetname" );
	trig waittill( "trigger" );

	// Wii optimizations
	if( !level.wii && !NumRemoteClients())
	{
		simple_spawn( "corner_killer" );
		simple_spawn( "attic_germ" );
	}

}



bathroom_ambush()
{

	spawn_trig = getent( "wc_suprise_trig", "targetname" );
	spawn_trig waittill( "trigger" );

	simple_spawn( "wc_suprise_germans", ::ambush_behaviour_setup );

	wait( 0.05 );
	thread begin_ambush_early();

	//this trigger sets off the ambush
	ambush_trig = getent( "ambush_trig", "script_noteworthy" );
	ambush_trig waittill( "trigger" );

	level notify( "start_ambush" );

}



begin_ambush_early()
{
	level waittill( "start_ambush" );
	level notify( "ambush_started" );

	//all the spawners in the ambush reverse their pacifist behavior to engage the player
	ambush_guys = getentarray( "shower_ambush", "script_noteworthy" );
	array_thread( ambush_guys, ::begin_ambush );

	simple_floodspawn( "bathroom_spawners" );
	simple_spawn( "backup_germs" );

	//Shabs - OLD STUFF 8/05/2008
//	simple_spawn( "middle_backup_germ" );
//	simple_spawn( "bathroom_back_spawner" );
//	back_ambush_guys = getentarray( "wc_suprise_germans_back", "targetname" );
//	array_thread( back_ambush_guys, ::begin_ambush );
//	middle_backup_trig = getent( "middle_backup_trig", "targetname" );
//	middle_backup_trig waittill( "trigger" );
//
//	simple_spawn( "middle_backup_germ" );


}



ambush_damage_checker()
{

	level endon( "ambush_started" );
	self waittill( "damage" );

	level notify( "start_ambush" );


}



begin_ambush()
{

	self endon( "death" );

//	wait( RandomIntRange( 0.5, 1.2 ) );

	if( IsDefined( self) && IsAlive( self ) )
	{

//		 wait( RandomIntRange( 0, 2 ) );

		wait( RandomFloatRange( 0.15, 1.25 ) );

		self allowedstances ( "stand" );
//		self.a.pose = "stand";
		self.ignoresuppression = 0;
		self.goalradius = 128;
		self.grenadeawareness = 0.2;
		self.disableArrivals = false;
		self.disableExits = false;
		self.drawoncompass = true;
		self.activatecrosshair = true;
		self.ignoreall = false;
		self.ignoreme = false;
		self enableaimassist();
		self.pacifist = 0;
	}

}



ambush_behaviour_setup()
{
	self endon( "death" );

	self allowedstances ( "prone" );
	self.a.pose = "prone"; 
	self.ignoresuppression = 1;
	self.goalradius = 16;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self.ignoreall = true;
	self.ignoreme = true;
	self disableaimassist();
	self.pacifist = 1;
	self.pacifistwait = 0.05;

	self thread ambush_damage_checker();

}



rooftop_germ_behaviour()
{

	self endon( "death" );

//	self thread damage_check_ragdoll();

//	TODO: speak with jesse on why typed removed is not an entity assert
//	appears after AI dies with skipdeathanim set to true
//	self.skipdeathanim = true;
	self.ignoresuppression = 1;
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self waittill("goal");

	self.ignoresuppression = 0;
	self.ignoreall = false;
	self.ignoreme = false;
}



damage_check_ragdoll()
{

	self waittill( "damage" );

	self.skipdeathanim = true;
	self setcandamage( true );
	self startragdoll();

}



roof_panzer_behaviour()
{
	self endon( "death" );

	self.ignoresuppression = 1;
	self.goalradius = 16;
	self.ignoreall = true;
//	self.ignoreme = true;
	self waittill("goal");

	self.ignoresuppression = 0;
	self.ignoreall = false;
//	self.ignoreme = false;
}



ghost_german_setup()
{
	self endon( "death" );

	self.ignoresuppression = 1;
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;

	ghost_delete_node = getnode( "ghost_delete_node", "targetname" );
	self setgoalnode( ghost_delete_node );

	self waittill("goal");

	self delete();
}



deserter_behaviour()
{

	self endon( "death" );

	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self.ignoresuppression = 1;
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self.pacifist = true;

	self waittill("goal");
	self delete();

}



ghost_german_behavior()
{
	self endon( "death" );

	wait_node = getnode( "wait_for_shadow_trig", "targetname" );
	self setgoalnode( wait_node );
	self waittill( "goal" );

	self disableaimassist();
	self.script_goalvolume = 127;
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self.grenadeawareness = 0;
	self.disableArrivals = true;
	self.disableExits = true;
	self.drawoncompass = false;
	self allowedstances( "crouch" );

	shadow_trig = getent( "shadow_trig", "targetname" );
	shadow_trig waittill( "trigger" );

	self allowedstances( "stand" );

	ghost_node = getnode( "ghost_node", "targetname" );
	self setgoalnode( ghost_node );
	self waittill("goal");
	self allowedstances( "stand", "crouch" );

	ambush_trig = getent( "ambush_trig", "script_noteworthy" );
	ambush_trig waittill( "trigger" );

	self allowedstances ( "crouch", "stand" );
	self enableaimassist();
	self.goalradius = 128;
	self.ignoreall = false;
	self.ignoreme = false;
	self.grenadeawareness = 1;
	self.disableArrivals = false;
	self.disableExits = false;
	self.drawoncompass = true;

	fight_node = getnode( "ghost_node_fight", "targetname" );
	self setgoalnode( fight_node );
//	self waittill("goal");

//	self delete();

}



stair_behaviour()
{
	self endon( "death" );

	self.ignoresuppression = 1;
	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self waittill("goal");
	self delete();
}



runner_behaviour()
{
	
	self endon( "death" );

	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self waittill("goal");

	self.ignoreall = false;
	self.ignoreme = false;
}



// rejoin the squad on the Green color group
event2_rejoin_squad()
{
//	trigger = getEnt("asylum_grounds_split_squad", "targetname");
//	trigger waittill("trigger");
	
//	// start Green color chain for the asylum
//	trigger = getEnt("colortrig_g0", "targetname");
//	trigger notify("trigger");
	
//	// start Blue color chain to delete extra guys
//	trigger = getEnt("colortrig_o0", "targetname");
//	trigger notify("trigger");

	aidudes = getAIArray("allies");

//	for(i = 0; i < aidudes.size; i++)
//	{
//		aidudes[i] thread main_squad();
//	}

	for( i = 0; i < aidudes.size; i++ )
	{

		if (i % 2 == 0)
		{
			aidudes[i] set_force_color("g");
		}
		else // odd
		{
			aidudes[i] set_force_color("y");
		}
	
	}
	
	set_color_heroes( "o" );

	set_color_chain( "chain_asylum_start" );

//
//	allies = getaiarray("allies");
////	iprintln( allies.size );
//	for (i = 0; i < allies.size; i++)
//	{
//		// if is an even number of the array
//		if (i % 2 == 0)
//		{
//			allies[i] set_force_color("g");
//		}
//		else // odd
//		{
//			allies[i] set_force_color("o");
//		}

		
}



atrium_crow_damage_trig()
{

//	level endon( "fly_crow_fly" );

	damage_trig = getent( "crows_fly_trig", "targetname" );
	damage_trig waittill( "trigger" );

	flag_set( "fly_crow_fly" );


}



#using_animtree( "ber1_crows" );
atrium_crows()
{

//	level thread maps\ber1_anim::main();

	level thread crow2_atrium();
	level thread crow3_atrium();
	level thread crow4_atrium();
	level thread crow5_atrium();
	level thread crow6_atrium();
	level thread crow7_atrium();
	level thread crow8_atrium();

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow1_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow1_outro", undefined, crow_spot );

	crow delete();

}



crow2_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow2_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow2_outro", undefined, crow_spot );

	crow delete();
}



crow3_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow3_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow3_outro", undefined, crow_spot );

	crow delete();

}



crow4_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow4_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow4_outro", undefined, crow_spot );

	crow delete();

}



crow5_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow5_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow5_outro", undefined, crow_spot );

	crow delete();

}



crow6_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow6_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow6_outro", undefined, crow_spot );

	crow delete();

}



crow7_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow7_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow7_outro", undefined, crow_spot );

	crow delete();

}



crow8_atrium()
{

	crow_spot = getnode("atrium_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "crow8_loop", undefined, undefined, crow_spot );

	flag_wait( "fly_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "crow8_outro", undefined, crow_spot );

	crow delete();

}



indoor_crow_damage_trig()
{

//	level endon( "indoor_crow_fly" );

	damage_trig = getent( "indoor_crows_fly_trig", "targetname" );
	damage_trig waittill( "trigger" );

	flag_set( "indoor_crow_fly" );

}



indoor_crows()
{

	level thread indoor_crow2();
	level thread indoor_crow3();
	level thread indoor_crow4();

	crow_spot = getnode("hole_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "indoor_crow1_loop", undefined, undefined, crow_spot );

	flag_wait( "indoor_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "indoor_crow1_outro", undefined, crow_spot );

	crow delete();

}



indoor_crow2()
{

	crow_spot = getnode("hole_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "indoor_crow2_loop", undefined, undefined, crow_spot );

	flag_wait( "indoor_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "indoor_crow2_outro", undefined, crow_spot );

	crow delete();

}



indoor_crow3()
{
	crow_spot = getnode("hole_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "indoor_crow3_loop", undefined, undefined, crow_spot );

	flag_wait( "indoor_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "indoor_crow3_outro", undefined, crow_spot );

	crow delete();

}



indoor_crow4()
{

	crow_spot = getnode("hole_crow_spot", "targetname");
	crow = spawn("script_model", crow_spot.origin);
	crow setmodel ("anim_berlin_crow");

	crow UseAnimTree(#animtree);
	crow.animname = "crow";
	//note: anim_loop_solo( guy, anime, tag, ender, entity )
	level thread anim_loop_solo(crow, "indoor_crow4_loop", undefined, undefined, crow_spot );

	flag_wait( "indoor_crow_fly" );

	rand = randomintrange(1,3);
	if (rand == 1)
	{
		crow playsound("raven_fly_away_a");
	}
	if (rand == 2)
	{
		crow playsound("raven_fly_away_b");
	}
	if (rand == 3)
	{
		crow playsound("raven_fly_away_c");
	}

	anim_single_solo(crow, "indoor_crow4_outro", undefined, crow_spot );

	crow delete();

}



#using_animtree("generic_human");
kill_off_rooftop_germans()
{

	kill_trig = getent( "kill_off_rooftop_germans", "targetname" );
	kill_trig waittill( "trigger" );

	rooftop_germans = get_ai_group_ai( "rooftop_germans" );

	for( i = 0; i < rooftop_germans.size; i++ )
	{
	
		if( IsDefined( rooftop_germans[i] ) && Isalive( rooftop_germans[i] ) )
		{
			rooftop_germans[i] thread bloody_death();
		}
	}

}



berlin_runner_behaviour()
{
	self endon( "death" );

	self.goalradius = 16;
	self.ignoreall = true;
	self.ignoreme = true;
	self waittill("goal");
	self.ignoreall = false;
	self.ignoreme = false;

	self thread bloody_death();
}



fallingdebris_think()
{
	
	trig = GetEnt( "debris_fall_trig", "targetname" );
	trig waittill( "trigger" );
	
	level thread second_floor_threads();
	
	ASSERTEX( IsDefined( trig.target ), "falling debris target not found for trigger at origin " + trig.origin );
	debrisGroup = GetEntArray( trig.target, "targetname" );
	
	if( !IsDefined( debrisGroup ) || debrisGroup.size <= 0 )
	{
		ASSERTMSG( "falling debris not found for trigger at origin " + trig.origin );
		return;
	}
	
	earthquake_struct = getstruct( "earthquake_struct", "targetname" );
	Earthquake( 0.3, 2, earthquake_struct.origin, 500 );
	
	array_thread( debrisGroup, ::fallingdebris_drop );
	
	trig Delete();
}



// self = a piece of debris
fallingdebris_drop()
{
	if( IsDefined( self.script_delay ) && self.script_delay >= 0 )
	{
		wait( self.script_delay );
	}
	else
	{
//		wait( RandomFloatRange( 0.15, 0.45 ) );
		wait( 0.10 );
	}
	
	// TODO if any AIs are underneath, have them cover up for a sec
	
	PlayFX( level._effect["fallingboards_fire"], self.origin );
//	wait( 0.25 );
	
	// turn off collision so we don't damage AIs
	self NotSolid();
	
	self PhysicsLaunch( ( RandomInt( 50 ), RandomInt( 50 ), RandomInt( 50 ) ), ( 0, 0, -15 ) );
}



prepare_tankride()
{
	
	flag_wait( "berlin_retreaters_trig" );
	
	level thread maps\ber1_tankride::main();
	
}



dialogue_waittills()
{

//	entry_vo_trig = getent( "asylum_entry_vo", "targetname" );
//	entry_vo_trig waittill( "trigger" );
	
	thread wait_for_entry_vo();
	thread wait_for_creepy_vo();
//	thread asylum_entry_vo();

	upstairs_vo_trig = getent( "go_upstairs", "script_noteworthy" );
	upstairs_vo_trig waittill( "trigger" );

	thread asylum_stairs_vo();

	balcony_vo_trig = getent( "balcony_vo_trig", "targetname" );
	balcony_vo_trig waittill( "trigger" );

	thread asylum_balcony_vo();

	moveup_vo_trig = getent( "hallway_color_chain", "targetname" );
	moveup_vo_trig waittill( "trigger" );

	thread move_up_vo();

	// flag set on trigger
	flag_wait( "begin_mg_event" );

	thread asylum_mg_vo();

}



move_up_vo()
{

	level endon( "begin_mg_event" );

	battlechatter_off();

	play_vo( level.reznov, "vo", "Good_hunting!" );

	wait( 0.20 );

	play_vo( level.reznov, "vo", "Lets_move!" );

	battlechatter_on();

}



wait_for_entry_vo()
{

	flag_wait( "indoor_crow_fly" );

	level thread asylum_entry_vo();

}



asylum_entry_vo()
{

	level endon( "stair_vo_override" );

	battlechatter_off();

	wait( RandomFloatRange( 4, 5 ) );

	play_vo( level.reznov, "vo", "this_place_reeks" );
	
	wait( 3.3 );
	
	play_vo( level.reznov, "vo", "only_the_insane" );	
	
	wait( 4 );
	
	play_vo( level.reznov, "vo", "keep_moving_keep" );	

	battlechatter_on();
	
}



asylum_stairs_vo()
{
	
	level endon( "creepy_vo_trig" );
	
	battlechatter_off();

	level thread kill_all_axis_ai( 0.05 );

	level thread delete_drones();	

	play_vo( level.reznov, "vo", "this_way_upstairs" );

	wait( 1.5 );

	play_vo( level.reznov, "vo", "Grab_a_shotgun!" );

	wait( 1 );

	play_vo( level.reznov, "vo", "close_quarters!" );

	battlechatter_on();	
}



wait_for_creepy_vo()
{

	// flag set on trigger
	flag_wait( "creepy_vo_trig" );
	level thread creepy_vO();

}



creepy_vo()
{

	battlechatter_off();

	play_vo( level.reznov, "vo", "shhh" );
	
	wait( 1.0 );
	
	play_vo( level.chernov, "vo", "do_you_hear" );
	
	wait( 1.75 );
	
	play_vo( level.reznov, "vo", "no..." );
	
	wait( 1.2 );
	
	play_vo( level.reznov, "vo", "i_am_suspicious" );
	
	wait( 2.6 );
	
	play_vo( level.reznov, "vo", "move_carefully" );
	
	battlechatter_on();
	
}



asylum_balcony_vo()
{

	level endon( "override_balcony_vo" );

	// this is a frantic battle, so we should leave BC on
//	battlechatter_off();

	wait( RandomFloatRange( 3.0, 4.5 ) );

	play_vo( level.reznov, "vo", "get_on_that_mg" );
	
	wait( 2.5 );
	
	play_vo( level.reznov, "vo", "use_their_weapons" );
	
	
	wait( RandomFloatRange( 6.25, 8.5 ) );
	
	play_vo( level.chernov, "vo", "there_on_the_roof" );
	
	wait( 3 );
	
	play_vo( level.commissar, "vo", "kill_them_all" );
	
	wait( RandomIntRange( 6, 8 ) );
	
	play_vo( level.commissar, "vo", "pick_them_off" );
	
//	battlechatter_on();
}



asylum_mg_vo()
{

	battlechatter_off();

	play_vo( level.reznov, "vo", "follow_me!" );
	
	wait( 2.5 );
	
	play_vo( level.reznov, "vo", "mg_has_hallway" );
	
	wait( 3 );
	
	play_vo( level.reznov, "vo", "dimitri_take_it" );	

	battlechatter_on();
		
}