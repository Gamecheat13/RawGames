#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;
#include maps\pel1b_event2_util;
#include maps\_music;
#using_animtree ("generic_human");


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
=================
 Sumeet - New section for event 2 - Pretty much copy from Alex's work , just a bit tuned.
=================
*/

event2_main_function()
{

	// flags setup for flame event
	flag_init("flaming_left1_done");
	flag_init("flaming_right1_done");
	flag_init("flaming_left2_done");
	flag_init("flaming_right2_done");
	flag_init("flaming_left3_done");
	flag_init( "cave_artillery_active" );

	// initial setup for plane and napalm drops
	level.plane_bomb_model[ "p51" ] = "aircraft_bomb";
	level.plane_bomb_fx[ "p51" ] 	= level._effect["napalm_explosion"];
	level.plane_bomb_sound[ "p51" ] = "temp_sound"; // temp
	maps\_planeweapons::build_bomb_explosions( "p51", randomfloatrange(.3,.5), 3, 5000, 700, 250, 1000 );


	// threat bias groups
	createthreatbiasgroup( "oblivious_enemies" );
	setthreatbias( "players", "oblivious_enemies", -1000000 );
	setthreatbias( "heroes", "oblivious_enemies", 0 );

	// spawn functions for sumeets event2
	level thread setup_spawn_functions();

	// setup to change the colors of hero characters
	level thread change_heros_colors();

	// first napalm drop
	level thread initial_plane_napalm_drop();
	// second napalm drop
	level thread second_plane_napalm_drop();

	// Flame tank gets into the second area
	level.flametank thread flametank_carnage_event();

	// thread the objective for event2
	level thread setup_objectives();

	// main function for cave effects
	level thread cave_effects();

	// Dialogue setup
	level thread dialogue_setup();
}

// Give heros individual colors
change_heros_colors()
{
	trigger = getent("ev2_pacing_starts", "targetname");
	trigger waittill("trigger");

	// disable the heros coler first and then assign colors again
	level.sarge disable_ai_color();
	level.walker disable_ai_color();
	
	level.sarge set_force_color( "o" );
	level.walker set_force_color( "g" );

	// CO-OP Optimization
	if(!NumRemoteClients())
	{
		// Spawn the friendlies only in non-coop 2 player mode
		trig1 = getent("ev2_allies_reinforcements_trig","targetname");
		trig1 notify("trigger");
	
		trig2 = getent("ev2_allies_reinforcementsb_trig","targetname");
		trig2 notify("trigger");
	}
	else if( NumRemoteClients() == 1 ) // only one remote client
	{
		// only spawn the guys on the other side of the tank
		trig2 = getent("ev2_allies_reinforcementsb_trig","targetname");
		trig2 notify("trigger");
	}
	
}

//////////////// First napalm drop event
initial_plane_napalm_drop()
{
	trigger = getent( "ev2_initial_plane_spawn", "targetname" );
	trigger waittill( "trigger" );
	
	level notify( "event2_bombing_starts" );

	wait( 0.5 );

	plane1 = getent( "event2_bombing_plane_01", "targetname" );
	plane2 = getent( "event2_bombing_plane_02", "targetname" );

	// thread a sound of planes going by
	plane1 thread bomber_sound_flyby("auto4986", 0.1 );
	plane2 thread bomber_sound_flyby("auto4984", 0.1 );
	
	plane1 thread load_bombs( 6 );
	plane2 thread load_bombs( 6 );	

	wait( 0.7 );

	plane1 thread drop_bombs( "event2_bombing_drop_011", false, 1 );
	plane1 thread drop_bombs( "event2_bombing_drop_012", false, 1 );
	plane1 thread drop_bombs( "event2_bombing_drop_013", false, 1 );

	plane2 thread drop_bombs( "event2_bombing_drop_021", false, 1 );
	plane2 thread drop_bombs( "event2_bombing_drop_022", false, 1 );
	plane2 thread drop_bombs( "event2_bombing_drop_023", false, 1 );

	level waittill( "event2_bombing_drop_011" );

	// Added this to support the network traffic
	thread drop_bombs_rumble();

	// set the battlechatter on
	thread battlechatter_on( "allies" );
	thread battlechatter_on( "axis" );

	level thread napalm_chain( "initial_napalm_drops_chain" );

	level waittill( "ev2_blow_up_stuff" );
	level thread initial_napalm_drones1();

	level waittill( "ev2_blow_up_stuff2" );
	level thread initial_napalm_drones2	();

	radiusdamage( ( 44310, 5649, 200 ), 50, 5000, 5000 );
	
	wait( 4 ); 
	PlayFx( level._effect["fireball_explosion"], ( 44012, 4927, 214.4 ) );	

	trigger = getent( "ev2_plane_strafe_trigger", "targetname" );
	trigger notify( "trigger" );

}

initial_napalm_drones1()
{
	// CO-OP Optimization
	if( !NumRemoteClients() || ( NumRemoteClients() == 1 ) )
	{
		// only spawn drones in two player co-op or single player 
		level thread play_explosion_death_anim( "ev2_blow_up_guys_3", "script_noteworthy" );
		wait_network_frame();
		level thread play_explosion_death_anim( "ev2_blow_up_guys_4", "script_noteworthy" );
	}

}

initial_napalm_drones2()
{
	// CO-OP Optimization
	if( !NumRemoteClients() || ( NumRemoteClients() == 1 ) )
	{
		// only spawn drones in two player co-op or single player 
		level thread play_explosion_death_anim( "ev2_blow_up_guys_1", "script_noteworthy" );
		wait_network_frame();
		level thread play_explosion_death_anim( "ev2_blow_up_guys_2", "script_noteworthy" );
	}
}



second_plane_napalm_drop()
{
	// planes are spawned and moved by this trigger
	trigger = getent( "ev2_plane_strafe_trigger", "targetname" );
	trigger waittill( "trigger" );

	// tells the tank to start moving
	level notify( "plane_strafe_start" );

	wait( 0.1 );

	plane1 = getent( "event2_bombing_plane_1", "targetname" );
	plane2 = getent( "event2_bombing_plane_2", "targetname" );
	plane3 = getent( "event2_bombing_plane_3", "targetname" );

	// thread a sound of planes going by	
	plane1 thread bomber_sound_flyby("auto2598", 0.1 );
	plane2 thread bomber_sound_flyby("auto3941", 0.1 );
	plane3 thread bomber_sound_flyby("auto3946", 0.1 );
	

	plane1 thread load_bombs( 2 );
	plane2 thread load_bombs( 2 );	
	plane3 thread load_bombs( 2 );	

	plane1 thread drop_bombs( "event2_bombing_drop_1", true );
	plane2 thread drop_bombs( "event2_bombing_drop_2", true );
	plane3 thread drop_bombs( "event2_bombing_drop_3", true );

	level thread additional_bomb( "plane_drop_bomb_extra", "event2_bombing_drop_3" );

	// spawn enemies when the first bomb is dropped
	level waittill( "event2_bombing_drop_1" );

	// Added this to support the network traffic
	thread drop_bombs_rumble();

	// leave some residual fire effects
	wait( 1 );

	fire_points = getstructarray( "naplam_battle_residual_fire", "targetname" );
	for( i = 0; i < fire_points.size; i++ )
	{
		playfx( level._effect["fire_foliage_large"], fire_points[i].origin );
	}

	level notify( "bombing_complete" );
}

bomber_sound_flyby( vehiclenode_targetname, wait_time )
{
	node = getvehiclenode( vehiclenode_targetname, "targetname" );
	node waittill("trigger");
	
	if ( isdefined(wait_time) )
	{
		wait(wait_time);
	}
		
	self playsound( "p51_bomber_by" );
}

//////////////// First napalm drop event end

///////////////////////////Spawn Function
setup_spawn_functions()
{
	// guys in the trench ignoring the player.
	ignore_players_guy = getentarray( "ignore_player_guy", "script_noteworthy" );
	array_thread( ignore_players_guy, ::add_spawn_function, ::force_to_goal_ignore_player );

	// spawn in friendlies in event 2
	friendlies = getentarray( "ev2_allies_reinforcements", "script_noteworthy" );
	array_thread( friendlies, ::add_spawn_function, ::friendlies_setup );

	// spawn in radio guy
	radio_guy = getentarray( "ev2_radio_guy", "script_noteworthy" );
	array_thread( radio_guy, ::add_spawn_function, ::radio_guy_setup );

}


// event 2 friendlies setup
friendlies_setup()
{
	// put a magic bullet shield 
	self thread magic_bullet_shield();
}

// radio guy setup
radio_guy_setup()
{
	// put a magic bullet shield 
	self thread magic_bullet_shield();
	level.radio_guy = self;
}

/////////////////////// spawn functions end
flametank_carnage_event()
{
	self endon("death");

		
	// waittill the flametank is in the second area
	// unless this happens the second event cant take control of the tank
	flag_wait("flametank_in_second_area");
	
	// Additionalwait to make sure the player has reached around the area of the flametank.
	flag_wait("flametank_visible_by_player");

	// let the trench guys know that players are here
	wait(1);
	setthreatbias( "players", "oblivious_enemies", 0 );
	
	// set the turretturn rate slow to show the weight of the tanks and flame.
	level.flametank.turretrotscale = 1; 

	// start the flametank
	self setspeed(4,5,8);

	// move the tank along the path
	trigger = getvehiclenode( "auto3964", "targetname" );
	trigger waittill( "trigger" );

	//TUEY setmusicstate DROP_OFF
	setmusicstate("DROP_OFF");
	
	// Flame guys on the left 1 , near to napalm drop
	self thread flame_battle_left1();

	// flame guys on the right 1, before the tree sniper	
	self thread flame_battle_right1();

	// TODO : Add sniper flame event

	// flame guys on the left 2, after the tree sniper	
	self thread flame_battle_left2();

	// flame guys on the right 2
	self thread flame_battle_right2();

	// flame guys on the right 2- actually near the caves
	self thread flame_battle_left3();

	//setup for tank tree sniper	
	self thread flametank_tree_sniper();
}

// Flame events of the flame tanks 

flametank_tree_sniper()
{
	// get the tree where sniper will be
	tree = getent( "test_tree", "script_noteworthy" );

	tree thread flame_notify();

	model_tag_origin = spawn( "script_model", tree.origin );
	model_tag_origin setmodel("tag_origin");
	model_tag_origin linkto( tree, "tag_origin", ( 0, 0, 0 ), ( 0, 0, 0 ) );
	
	// let the flametank come near the tank
	node = getvehiclenode("auto5390","targetname");
	node waittill("trigger");

	// play the leaf effect
	playfxontag( level._effect["sniper_leaf_loop"], model_tag_origin, "TAG_ORIGIN" );
	
	// stop the tank
	level.flametank setspeed( 0, 10, 10 );
	
	// spawn the sniper guy
	sniper_spawner = getent( "ev2_tree_sniper", "targetname" );
	sniper = force_spawn_guy( sniper_spawner );
	
	wait(0.05);
	if ( isdefined(sniper) && isalive(sniper))	
	{

		level.flametank clearturrettarget();
		// set the guy as the tank target
		level.flametank setturrettargetent( sniper );
		
		// fire the flame
		level.flametank fireweapon();
	}

	wait(5);

	// start moving again
	level.flametank setspeed( 0, 10, 10 );
	level.flametank clearturrettarget();
	
	// stop firing the flame
	level.flametank stopfireweapon();
	level.flametank setspeed( 4, 5, 8 );
	
	
}

flame_notify()
{
	
	node = getvehiclenode("auto5390","targetname");
	node waittill("trigger");

	wait( 0.05 );

	guy = get_ai_group_ai( "tree_guy" )[0];
	
	if( isdefined(guy) && isalive(guy))
	{
		self waittill( "broken", broken_notify, attacker );
		guy animscripts\death::flame_death_fx();
	
		// get the struct and spawn in the rope
		node = getent("auto17", "targetname");
		createrope( node.origin, (0,0,0), 100, guy, "j_ankle_ri" );
	
		wait(0.05);
		
		// he should hang now		
		guy startragdoll();
		
		// kill the guy
		guy dodamage(guy.health + 300, guy.origin, attacker );
	}
	
}

///////////// Event left 1
flame_battle_left1()
{
	// next event waits on this notification
	level endon("flaming_left1_done");

	// start firing at this node
	start_fire_node = getvehiclenode("auto3718", "targetname");
	start_fire_node waittill("trigger");

	// set the turret target to first struct of the zig zag pattern, tank is still moving
	self thread set_turret_target_by_name( "fire_point_left_1" );
	self fireweapon();

	// tell the level that flametank owns the show
	level notify("flametank_started_flaming");

	// now that it targeted in the area, start a thread that will target specific guys in the area
	self thread fire_guys_in_area( "flaming_left1_done", "axis_area_trig_left1", "axis_area_goal_left1" );

	// stop at this node, fire at a zig zag pattern
	stop_n_fire_node = getvehiclenode("auto3731", "targetname");
	stop_n_fire_node waittill("trigger");
	self setspeed(0,10,10);
}


///////////// Event right1
flame_battle_right1()
{
	level endon("flaming_right1_done");

	//wailtill first event is done
	level waittill("flaming_left1_done");

	// tell the tank to move ahead
	self setspeed(4,5,8);
	
	// start firing at this node
	start_fire_node = getvehiclenode("auto5206", "targetname");
	start_fire_node waittill("trigger");

	// set the turret target to first struct of the zig zag pattern, tank is still moving
	self thread set_turret_target_by_name( "fire_point_right_1" );
	self fireweapon();

	// now that it targeted in the area, start a thread that will target specific guys in the area
	self thread fire_guys_in_area( "flaming_right1_done", "axis_area_trig_right1", "axis_area_goal_right1" );

	// stop at this node, fire at a zig zag pattern
	stop_n_fire_node = getvehiclenode("auto3721", "targetname");
	stop_n_fire_node waittill("trigger");
	self setspeed(0,10,10);
}


///////////// Event left 1
flame_battle_left2()
{
	level endon("flaming_left2_done");

	// next event waits on this notification
	level waittill("flaming_right1_done");

	// trigger the flame guys to get flamed
	trigger = getent("event2_japs_flow_left_2", "script_noteworthy");
	trigger notify("trigger");

	// tell the tank to move ahead
	self setspeed(4,5,8);
	
	// start firing at this node
	start_fire_node = getvehiclenode("auto5200", "targetname");
	start_fire_node waittill("trigger");

	// set the turret target to first struct of the zig zag pattern, tank is still moving
	self thread set_turret_target_by_name( "fire_point_left_2" );
	self fireweapon();

	// now that it targeted in the area, start a thread that will target specific guys in the area
	self thread fire_guys_in_area( "flaming_left2_done", "axis_area_trig_left2", "axis_area_goal_left2" );

	// stop at this node, fire at a zig zag pattern
	stop_n_fire_node = getvehiclenode("auto5199", "targetname");
	stop_n_fire_node waittill("trigger");
	self setspeed(0,10,10);
}

///////////// Event right1
flame_battle_right2()
{
	level endon("flaming_right2_done");

	//wailtill first event is done
	level waittill("flaming_left2_done");
	
	// trigger the flame guys to get flamed
	trigger = getent("event2_japs_flow_right_2", "script_noteworthy");
	trigger notify("trigger");

	// tell the tank to move ahead
	self setspeed(4,5,8);
	
	// start firing at this node
	start_fire_node = getvehiclenode("auto5228", "targetname");
	start_fire_node waittill("trigger");

	// set the turret target to first struct of the zig zag pattern, tank is still moving
	self thread set_turret_target_by_name( "fire_point_right_2" );
	self fireweapon();

	// now that it targeted in the area, start a thread that will target specific guys in the area
	self thread fire_guys_in_area( "flaming_right2_done", "axis_area_trig_right2", "axis_area_goal_right2" );

	// stop at this node, fire at a zig zag pattern
	stop_n_fire_node = getvehiclenode("auto5227", "targetname");
	stop_n_fire_node waittill("trigger");
	self setspeed(0,10,10);
}

///////////// Event left 3 - actually this event flames guys coming out of caves.
flame_battle_left3()
{
	level endon("flaming_left3_done");

	// next event waits on this notification
	level waittill("flaming_right2_done");

	// trigger the flame guys to get flamed
	trigger = getent("event2_japs_flow_left_3a", "script_noteworthy");
	trigger notify("trigger");

	// wait for a frame approx - to avoide too many ents in the snapshot
	wait(0.05);

	// trigger the flame guys to get flamed
	trigger = getent("event2_japs_flow_left_3b", "script_noteworthy");
	trigger notify("trigger");


	// tell the tank to move ahead
	self setspeed(4,5,8);
	
	// start firing at this node
	start_fire_node = getvehiclenode("auto5231", "targetname");
	start_fire_node waittill("trigger");

	// set the turret target to first struct of the zig zag pattern, tank is still moving
	self thread set_turret_target_by_name( "fire_point_left_3" );
	self fireweapon();

	// now that it targeted in the area, start a thread that will target specific guys in the area
	self thread fire_guys_in_area( "flaming_left3_done", "axis_area_trig_left3", "axis_area_goal_left3" );

	// stop at this node, fire at a zig zag pattern
	stop_n_fire_node = getvehiclenode("auto3724", "targetname");
	stop_n_fire_node waittill("trigger");
	self setspeed(0,10,10);
}

///////////Flame tank AI
// Decides how flametank will behave, whom it will shoot, and when to start with the next flame event
fire_guys_in_area( event_flag, trigger_targetname, goal_volume )
{
	// get the actual trigger
	area_trigger = getent( trigger_targetname, "targetname");

	// start a thread to check how many guys are alive in the area
	self thread check_ai_existance( event_flag, area_trigger, goal_volume );

	// failsafe progression break avoider - if tank cant kill guys somehow it will go ahead
	self thread should_move_ahead( randomintrange(15, 20), event_flag );

	// find all AI touching the trigger, and target them 
	while(!flag(event_flag))
	{
		// clear the old target if it has one 
		self clearturrettarget();

		// get AI array
		axis_guys = getAIarrayTouchingVolume( "axis", goal_volume );
		
		// intialize i
		i = 0;

		if ( axis_guys.size >= 2 )
			i = randomintrange( 0, axis_guys.size - 1 ); // pick up a random guy in the crowd
		

		// only if there is anymore left
		if ( axis_guys.size >= 1 )
		{ 
			// check if he is alive and touching the trigger
			if( !flag(event_flag) && isalive( axis_guys[i] ) && axis_guys[i] istouching( area_trigger ) )
			{
				// target the guy
				self setturrettargetent( axis_guys[i], ( 0, 0, randomintrange(30, 60) ) );
				self waittill_notify_or_timeout( "turret_on_target", randomintrange(3,5));
			}
		}
		else if( !flag(event_flag) )
		{
			// set the flag 
			flag_set( event_flag );
			
			// notify the level, in case
			level notify(event_flag);		
			
			// stop firing the flame, clear the target
			self stopfireweapon();
			self clearturrettarget();
		}
			
	}

	// send a notification to the level, same as setting the flag
	level notify(event_flag);
	
}

// checks the existance of guys in a perticular area trigger
check_ai_existance( event_flag, area_trigger, goal_volume )
{
	while(!flag(event_flag))
	{
		// count how many guys are in the trigger right now
		ai_count = 0;
		
		// get AI array
		axis_guys = getAIarrayTouchingVolume( "axis", goal_volume );
		
		// loop through guys
		for( i = 0; i< axis_guys.size; i++ )
		{
			// check if he is alive and touching the trigger
			if( isalive( axis_guys[i] ) && axis_guys[i] istouching( area_trigger ) )
				ai_count++;
		}

		// if there are only couple left then move further
		if ( ai_count == 0 &&  !flag(event_flag) )
		{
			
			// set the flag 
			flag_set( event_flag );
			
			// notify the level, in case
			level notify(event_flag);		
			
			// stop firing the flame, clear the target
			self stopfireweapon();
			self clearturrettarget();
		}
		

		wait(0.01);
	}

}

// if in given time tank cant kill everyone in goalvolume then it will just move ahead
should_move_ahead( timeout, event_flag )
{
	wait( timeout );
	
	// if the flag is not already set then set it and let the tank move further
	if( !flag(event_flag) )
	{
		flag_set(event_flag);
		// notify the level
		level notify( event_flag );
		
		// stop firing the flame, and clear ent target
		self stopfireweapon();
		self clearturrettarget();
	}
}


///////////////////////////////////////////////////////////////////////////
//////////////////// Outro animation sequence
pel1b_outro()
{

	// get the guys to do the outro animation
	guys = [];
	guys[0] = level.walker; // roebuck
	guys[1] = level.sarge; // polonsky
	guys[2] = level.radio_guy; 

	guys[0].animname = "walker";
	guys[1].animname = "sarge";
	guys[2].animname = "radio_guy";

	guys[0] disable_ai_color();
	guys[1] disable_ai_color();
	guys[2] disable_ai_color();

	guys[0].ignoreall = true;
	guys[1].ignoreall = true;
	guys[2].ignoreall = true;
	
	anim_struct = getstruct( "outro_anim", "targetname" );

	goal_node_roebuck = getnode( "roebuck_outro", "targetname" );
	goal_node_polonsky = getnode( "polonsky_outro", "targetname" );
	goal_node_radio = getnode( "radio_outro", "targetname" );


	//TUEY Set Music State to LEVEL_END
	setmusicstate("LEVEL_END");

	guys[0] thread pacing_vignette_in_place_think( anim_struct, "roebuck_reached_outro", "outro_in", "outro_loop" );
	guys[1] thread pacing_vignette_in_place_think( anim_struct, "polonsky_reached_outro", "outro_in", "outro_loop" );
	guys[2] thread pacing_vignette_in_place_think( anim_struct, "radio_guy_reached_outro", "outro_in", "outro_loop" );

	flag_wait_all( "roebuck_reached_outro", "polonsky_reached_outro", "radio_guy_reached_outro" );

	//-- Check and see if the player is close by, if he is, then run the outro
	players = get_players();
	player_close = false;
	while(!player_close)
	{
		for( i=0; i < players.size; i++ )
		{
			if( distancesquared(players[i].origin, guys[0].origin) < 400*400 )
			{
				player_close = true;
			}
		}
		
		wait(0.05);
	}

	//-- Take away weapons and make players immune
	for( i=0; i < players.size; i++ )
	{
		players[i] DisableWeapons();
		players[i] EnableInvulnerability();
	}
	

	guys[2] notify( "radio_anim_starting" );
	anim_single( guys, "outro",  undefined, undefined, anim_struct );
			
	objective_state( 7, "done" );

	//nextmission();
}


pacing_vignette_in_place_think( goal_node, flag_name, anim_in, anim_looping )
{
	//-- plays the animation	
	startorg = getstartOrigin( goal_node.origin, goal_node.angles, level.scr_anim[self.animname][anim_in] );
	startang = getstartAngles( goal_node.origin, goal_node.angles, level.scr_anim[self.animname][anim_in] );
	
	self.goalradius = 32;
	//self setgoalnode( goal_node );
	self SetGoalPos( startorg, startang );
	self disable_ai_color();
	self PushPlayer( true );

	self waittill( "goal" );
	self waittill_notify_or_timeout( "orientdone", 1 );
	
	wait(0.75);
	
	anim_single_solo( self, anim_in, undefined, undefined, goal_node );
	thread anim_loop_solo( self, anim_looping, undefined, undefined, goal_node );
	
	if(self.animname == "radio_guy")
	{
		self thread outro_animate_radio_model(goal_node);	
	}
	
	flag_set( flag_name );
}

#using_animtree( "animated_props" );
outro_animate_radio_model(goal_node)
{
	radio_model = spawn( "script_model", self.origin );
	radio_model setmodel( "char_usa_marine_radiohandset" );
	radio_model linkto( self, "tag_weapon_left", (0,0,0), (0,0,0) );
	
	radio_model UseAnimTree( #animtree );
	radio_model.animname = "radio";
	
	thread anim_loop_solo( radio_model, "outro_loop", undefined, undefined, goal_node );
	
	self waittill( "radio_anim_starting" );
	anim_single_solo( radio_model, "outro", undefined, undefined, goal_node );
	
	radio_model delete();
}

//////////////////////////////////////////////////////////////// 
///////// Setup objectives - also sets the checkpoints
setup_objectives()
{
	// initial objective: Flank the enemy base	
	objective_add( 3, "current", &"PEL1B_OBJECTIVE_EV2_FLANK", ( 43393.7, 4060.1, 168.2 ) );

	// air raid starts: Hold position till end of bombing
	trigger = getent( "ev2_initial_plane_spawn", "targetname" );
	trigger waittill( "trigger" );

	objective_state( 3, "done" );	
	objective_delete( 3 );

	// autosave
	autosave_by_name( "airstrike done" );

	// add the flametank follow objective
	objective_add( 4, "current", &"PEL1B_OBJECTIVE_EV2_FOLLOW_FLAME" );
	Objective_additionalPosition(4, 0, level.flametank);
	level.flametank thread objective_follow_me( 4, "tank_destroyed" );
	//objective_OnEntity( 4, level.flametank );
	// end of air raid: support follow flame tank
	level thread trigger_wait_with_notify( "cave_entrance_trigger", "targetname", "tank_destroyed" );
	// When tank dies or when player hits the tunnel entrance trigger: Reach the mountain top through caves
	level waittill( "tank_destroyed" );
	objective_state( 4, "done" ); //

	// autosave
	autosave_by_name( "flametank dead" );

	// assault the cave entrance
	objective_add( 5, "current", &"PEL1B_OBJECTIVE_EV2_ASSAULT_CAVE" );
	// When tank dies or when player hits the tunnel entrance trigger: Reach the mountain top through caves
	// At the last room: clear enemies at artillery
	cave_entrance_trigger = getent( "cave_entrance", "targetname" );
	cave_entrance_trigger waittill( "trigger" );	
	objective_state( 5, "done" );

	// autosave
	autosave_by_name( "cave entrance" );

	objective_add( 6, "current", &"PEL1B_OBJECTIVE_EV2_CAVE_CLEAR", ( 40871.2, -218.9, 885.508 ) );
	// At the last room: clear enemies at artillery
	final_trigger = getent( "last_cave_room_reached", "targetname" );
	final_trigger waittill( "trigger" );

	// autosave
	autosave_by_name( "artillery room" );

	// change the objective string to clear the artillery room
	objective_string( 6, &"PEL1B_OBJECTIVE_EV2_ART_CLEAR" );
	// when the room is cleared. Obj is done
	final_room = getent( "final_room_trigger", "targetname" );
	wait( 5 );
	while( 1 )
	{
		cleared = true;
		axis_guys = GetAiArray( "axis" );
		for( i = 0; i < axis_guys.size; i++ )
		{
			if( axis_guys[i] istouching( final_room ) )
			{
				cleared = false;
			}
		}

		if( cleared )
		{
			break;
		}	

		wait( 1 );
	}
	objective_state( 6, "done" );

	
	// set the battlechatter on
	thread battlechatter_off( "allies" );
	thread battlechatter_off( "axis" );

	// Final outro objective
	objective_add( 7, "current", &"PEL1B_OBJECTIVE_FOLLOW_SQUAD", ( 41063.2, -538.3, 857.6 ) );

	
		
	// start the outro
	level thread pel1b_outro();
}

objective_monitor_endon(num, endon_str)
{
	self endon("stop objective monitor");
	level waittill(endon_str);
	
	Objective_additionalPosition( num, 0, (0,0,0) );
	
	self notify("stop objective monitor");	
}

objective_monitor_death(num)
{
	self endon("stop objective monitor");
	self waittill("death");

	Objective_additionalPosition( num, 0, (0,0,0) );

	self notify("stop objective monitor");	
}

objective_follow_me( num, endon_str )
{
	self thread objective_monitor_endon(num, endon_str);
	self thread objective_monitor_death(num);
/*	level endon( endon_str );
	self endon("death");
	
	while(1)
	{
		Objective_Position( num, self.origin );
		wait(0.1);
	}*/
	
	
}

/////////////////////Effects section for caves
cave_effects()
{

	// waittill player makes the cave entrace close enough
	trigger1 = getent( "ev2_start_art_dust", "targetname" );
	trigger1 waittill( "trigger" );
	flag_set( "cave_artillery_active" );
	level notify( "cave_artillery_active" );
	
	// start debri falling effects
	level thread cave_dust_fx_loop();

	// waittill player makes the cave entrace close enough, stop rumble.
	trigger1 = getent( "ev2_stop_art_dust", "targetname" );
	trigger1 waittill( "trigger" );
	
	flag_clear( "cave_artillery_active" );
}


cave_dust_fx_loop()
{
	level endon( "stop_dust_fx" );

	//TUEY Set music state to CAVE
	setmusicstate("CAVE");

	while( flag( "cave_artillery_active" ) )
	{
		wait( randomfloat( 3 ) + 3 );
		playsoundatposition( "mortar_dirt", ( 41063.2, -538.3, 857.6 ) );
		
		// dust effects around the players
		level thread play_dust_fx_near_players();
	}
}


//////////////////////////////////////////////////////////////////////////////////
/////////////////////////// Sumeet Dialogue section 
dialogue_setup()
{
	level thread ev2_pacing_dialog();
	level thread ev2_bombing_dialog();
	level thread ev2_wait_for_tank_dialog();
	level thread ev2_tank_move_up_dialog();
	level thread ev2_stay_behind_tank_dialog();
	level thread ev2_enter_tunnel_dialog();
}

say_dialogue( theLine )
{
	self.og_animname = self.animname;
	self.animname = "generic";
	self anim_single_solo( self, theLine );
	self.animname = self.og_animname;
}

ev2_pacing_dialog()
{
	wait( 8 );
	
	level.sarge say_dialogue( "good_work" );
	level.sarge say_dialogue( "move_gully" );
	level.walker say_dialogue( "watch_trees" );
	level.sarge say_dialogue( "keep_tight" );
}

ev2_bombing_dialog()
{
	level waittill( "ev2_blow_up_stuff2" );
	wait( 1 );

	level.walker say_dialogue( "airforce_know" );
	level.sarge say_dialogue( "heads_down" );
}

ev2_wait_for_tank_dialog()
{
	trigger = getent( "ev2_plane_strafe_trigger", "targetname" );
	trigger waittill( "trigger" );
	wait( 1 );

	level.sarge say_dialogue( "tanks_cover" );
	level.sarge say_dialogue( "help_clear" );
	level.sarge say_dialogue( "stay_cover" );
}

ev2_tank_move_up_dialog()
{
	level waittill("flametank_started_flaming");

	level.walker say_dialogue( "tank_move_up" );
	level.sarge say_dialogue( "move_with_it" );
	level.sarge say_dialogue( "go_now" );
	level.sarge say_dialogue( "stay_with" );
}

ev2_stay_behind_tank_dialog()
{
	trigger = getent( "flametank_middle", "targetname" );
	trigger waittill( "trigger" );
	
	if ( isdefined(level.flametank) && isalive( level.flametank ) )
		level.sarge say_dialogue( "watch_tank" );
}

ev2_enter_tunnel_dialog()
{
	trigger = getent( "cave_entrance", "targetname" );
	trigger waittill( "trigger" );

	level.sarge say_dialogue( "take_left" );
	level.walker say_dialogue( "hear_you" );
	level.sarge say_dialogue( "this_is_it" );
	level.sarge say_dialogue( "clear_caves" );
}