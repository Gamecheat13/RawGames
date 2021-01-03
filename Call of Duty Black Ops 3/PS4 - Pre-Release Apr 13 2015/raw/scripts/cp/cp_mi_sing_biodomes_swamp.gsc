#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_message_shared;
#using scripts\shared\laststand_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\teamgather_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_biodomes_util;
#using scripts\cp\cp_mi_sing_biodomes_supertrees;

function main()
{
	setup_scenes();
}

function setup_scenes()
{
	scene::add_scene_func( "cin_bio_15_02_player_vign_ontoboat_portnear", &scene_player_onto_boat_play, "play" );
	scene::add_scene_func( "cin_bio_15_02_player_vign_ontoboat_starboardnear", &scene_player_onto_boat_play, "play" );
}

//Swamps
function objective_swamps_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_swamps_init" );
	
	objectives::set( "cp_level_biodomes_escape", struct::get( "airboat_waypoint" ) );
	
	if ( b_starting )
	{
		cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
		level flag::set( "hendricks_dive" );
		
		level thread airboat_spawn();
		level thread dock_guard();
		level thread hunter_fuel_truck();
		level thread cp_mi_sing_biodomes_supertrees::supertrees_hunter( true );
		
		exploder::exploder( "fx_supertree_boat_exp" );
		exploder::exploder( "fx_supertree_ext_fire" );
	}
	
	level.vehicle_main_callback["hunter"] = &hunter_callback;
	
	t_underwater = GetEnt( "trigger_dock", "targetname" );
	
	t_underwater thread check_players_underwater();
	level thread player_protection();
	level thread airboat_jump_wasp();
	level thread airboat_kill_wasp();
	level thread swamp_guard_1();
	level thread outpost_tower_destroy();
	level thread bridge_guard_1();
	level thread bridge_guard_2();
	level thread swamp_guard_2();
	level thread swamp_guard_3();
	level thread wasp_swarm();
	level thread wasp_plane();
	//level thread wasp_chaser_1();
	//level thread wasp_chaser_2();
	level thread outpost_crash();
	level thread destroy_ferriswheel();
	
	//bullets for when player is in the water
	exploder::exploder( "fx_swamp_dive_bullet_bubble" );
	
	level thread dialog::remote( "kane_stay_with_it_beat_0", 3 ); //"Stay with it. (beat) I’m getting you out of here."
			
	t_city_land = GetEnt( "trigger_store_crash", "targetname" );
	
	foreach( player in level.players )
	{
		player thread jump_land_city( t_city_land );
	}
}

function destroy_ferriswheel()
{
	trigger::wait_till( "trigger_ferriswheel_collapse" );
	
	//bring a hunter in to fire at the ferris wheel
	hunter_ferriswheel = spawner::simple_spawn_single( "hunter_swamp_ferriswheel", &hunter_ferriswheel_spawn );
}

//self is the spawned hunter that approaches the ferris wheel
function hunter_ferriswheel_spawn()
{
	self endon( "death" );
	
	self SetForceNoCull();
	
	nd_start = GetVehicleNode( self.target, "targetname" );
	
	self thread vehicle::get_on_and_go_path( nd_start );
	
	self waittill( "hunter_fire_ferriswheel" );

	self cp_mi_sing_biodomes_supertrees::hunter_missile_volley( "hunter_ferriswheel_fire_dest", 1, 7, 0.5, 0.5 );
	wait 1; //slight delay after rocket fire before destroying ferris wheel
	
	//some rockets happen to hit the ferris wheel, causing it to collapse
	level clientfield::set( "ferriswheel_fall_play", 1 );
	
	//Add some rumble with the ferris wheel collapse
	s_ferriswheel = struct::get( "hunter_ferriswheel_fire_dest_7", "targetname" );
	Assert( isdefined( s_ferriswheel ), "Collapsing ferris wheel location is undefined" );
	
	//start off with long, light rumble for a few seconds as it cracks
	Earthquake( 0.1, 6, s_ferriswheel.origin, 6000 );
	fx::play( "explosion_dome", s_ferriswheel.origin);
	
	//level waittill ( "cab1_impacts_window" );
	wait 8; //TODO temp until I find a good notetrack for when ferris wheel hits the ground
	
	//short heavy rumble as it lands
	Earthquake( 0.45, 2, s_ferriswheel.origin, 6000);
}

function exploder_triggers()
{
	a_triggers1 = GetEntArray( "trigger_exploder_1", "targetname" );
	a_triggers2 = GetEntArray( "trigger_exploder_2", "targetname" );
	
	foreach( t_exploder1 in a_triggers1 )
	{
		t_exploder1 thread exploder_play( level.vh_boat1 );
	}
	
	foreach( t_exploder2 in a_triggers2 )
	{
		t_exploder2 thread exploder_play( level.vh_boat2 );
	}
}

function exploder_play( vh_boat )  //self = trigger
{
	while( 1 )
	{
		self waittill( "trigger", vh_triggerer );
		
		if ( vh_triggerer == vh_boat )
		{
			exploder::exploder( self.script_noteworthy );
			
			if ( isdefined( self.target ) )
			{
				a_ents = GetEntArray( self.target, "targetname" );
				
				foreach( ent in a_ents )
				{
					ent PhysicsLaunch( ent.origin, ( AnglesToForward( vh_boat.angles ) * 10 ) + ( 0, 0, 20 ) );
				}
			}
			
			break;
		}
	}
}

function objective_swamps_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_swamps_done" );
	
	objectives::complete( "cp_level_biodomes_extract" );
}

function depth_charges()
{
	level endon( "reached_dock" );
	
	s_missile = struct::get( "missile_fire" );
	a_s_explosions = struct::get_array( "underwater_exp_pos" );
	
	weapon = GetWeapon( "smaw" );
	
	trigger::wait_till( "trigger_dive_done" );
	
	while( 1 )
	{
		s_target = a_s_explosions[RandomInt( a_s_explosions.size )];
		
		e_target = Spawn( "script_model", s_target.origin );
		
		v_offset = ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), 0 );
		
		e_missile = MagicBullet( weapon, s_missile.origin, e_target.origin, undefined, e_target, v_offset );
		e_missile thread underwater_explosion( s_target );
				
		wait RandomFloatRange( 0.5, 1.5 );
		
		e_target Delete();
	}
}

function underwater_explosion( s_target )  //self = missile
{
	self waittill( "death" );
	
	fx::play( "depth_charge", s_target.origin );
}

//self is trigger_dock
function check_players_underwater()
{
	level endon( "reached_dock" );
	
	n_ondock = 0;
	
	foreach( player in level.players )
	{
		player.b_dock = false;	
	}
	
	while( isdefined ( self ) )
	{
		self trigger::wait_till();
		
		player = self.who;
		
		if ( !player.b_dock )
		{
			player.b_dock = true;

			n_ondock++;

			if ( n_ondock == level.players.size )
			{
				level flag::set( "reached_dock" );
			}
		}
	}
}

function ambient_missile_fire()
{
	trigger::wait_till( "trigger_dock" );
	
	s_missile = struct::get( "missile_fire" );
	a_s_explosions = struct::get_array( "water_exp_pos" );
	
	weapon = GetWeapon( "smaw" );
	
	while ( !level flag::get( "boats_go" ) )
	{
		s_target = a_s_explosions[RandomInt( a_s_explosions.size )];
		
		e_target = Spawn( "script_model", s_target.origin );
		
		v_offset = ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), 0 );
		
		e_missile = MagicBullet( weapon, s_missile.origin, e_target.origin, undefined, e_target, v_offset );
		e_missile thread underwater_explosion( s_target );
				
		wait RandomFloatRange( 0.5, 1.5 );
		
		e_target Delete();
	}
}

function airboat_spawn()
{
	level.n_boarded = 0;
	
	level.vh_boat1 = vehicle::simple_spawn_single( "airboat_1" );
	level.vh_boat2 = vehicle::simple_spawn_single( "airboat_2" );
	
	level.vh_boat1 SetCanDamage( false );
	level.vh_boat2 SetCanDamage( false );
	
	level thread check_player_boarding();
	
	boat_setup_seats();
	
	level.vh_boat1 thread hendricks_board();
	
	level.vh_boat1 MakeVehicleUsable();
	level.vh_boat2 MakeVehicleUsable();

	level thread airboat_jump_land();
	level thread airboat_rumbler();
	level thread tall_grass();
	level thread igc_end();
		
	level.vh_boat1 thread airboat_depart();
	level.vh_boat2 thread airboat_depart();
	level.vh_boat2 thread boat_scrape();
	
	level thread airboat_icon();
	level thread exploder_triggers();
}

function airboat_icon()
{
	v_offset = ( 0, 0, 0 );
	
	a_t_boats = GetEntArray( "trigger_boat" , "targetname" );
		
	foreach( t_boat in a_t_boats )
	{
		t_boat.gobj_visuals = [];
		
		t_boat.e_use_object = gameobjects::create_use_object( "allies" , t_boat, t_boat.gobj_visuals, v_offset , undefined );
		t_boat.e_use_object gameobjects::set_visible_team( "any" );
		t_boat.e_use_object gameobjects::set_3d_icon( "friendly", "t7_hud_prompt_push_64" );	
		t_boat.e_use_object thread gameobjects::hide_icon_distance_and_los( (1,1,1), 800, false );
	}
	
	level flag::wait_till( "boats_go" );
	
	objectives::set( "cp_level_biodomes_extract" );
	
	foreach( t_boat in a_t_boats )
	{
		t_boat.e_use_object gameobjects::disable_object();
		t_boat Delete();
	}
}

function tall_grass()
{
	clientfield::set( "tall_grass_init", 1 );
	
	trigger::wait_till( "trigger_tall_grass" );
	
	clientfield::set( "tall_grass_play", 1 );
}

function airboat_rumbler()  //self = airboat
{
	a_t_rumble = GetEntArray( "trigger_boat_rumble", "targetname" );
	
	foreach( t_rumble in a_t_rumble )
	{
		t_rumble thread rumble_airboat_passengers();
	}
}

function rumble_airboat_passengers()  //self = trigger
{
	level endon( "ride_over" );
	
	while( 1 )
	{
		self waittill( "trigger", player );
	
		player PlayRumbleOnEntity( "damage_heavy" );
		Earthquake( 0.5, 2.0, player.origin, 400 );
		
		wait 0.3;
		
		while( player IsTouching( self ) )
		{
			player PlayRumbleOnEntity( "damage_heavy" );
		
			wait 0.1;
		}
			
		player StopRumble( "damage_heavy" );
		Earthquake( 0.5, 2.0, player.origin, 400 );
	}
}

function boat_scrape()  //self = boat 2
{
	t_boat = GetEnt( "trigger_boat_scrape", "targetname" );
	t_boat waittill( "trigger" );
	
	while( self IsTouching( t_boat ) )
	{
		v_forward = self.origin + AnglesToForward( self.angles ) * 150;
		v_pos = self.origin + v_forward;
		
		fx::play( "boat_sparks", v_forward );
		
		wait 0.1;
	}
}

function boat_setup_seats()
{
	level.vh_boat1 SetSeatOccupied( 0 );
	level.vh_boat2 SetSeatOccupied( 0 );
	
	if ( level.players.size == 2 )
	{
		level.vh_boat1 SetSeatOccupied( 1 ); //this forces players to split up onto different boats
		level.vh_boat2 SetSeatOccupied( 2 );
	}
}

function force_player_onboard()  //self = player
{
	a_riders1 = [];
	a_riders1 = level.vh_boat1 GetVehOccupants();
	a_riders2 = [];
	a_riders2 = level.vh_boat2 GetVehOccupants();
	
	if ( !a_riders1.size )
	{
		level.vh_boat1 UseVehicle( self, 1 );
	}
	else if ( a_riders1.size < 2 )
	{
		n_seat = level.vh_boat1 GetOccupantSeat( a_riders1[0] );
		
		if ( n_seat == 1 )
		{
			level.vh_boat1 UseVehicle( self, 2 );
		}
		else
		{
			level.vh_boat1 UseVehicle( self, 1 );
		}
	}
	else if ( !a_riders2.size )
	{
		level.vh_boat2 UseVehicle( self, 1 );
	}
	else
	{
		n_seat = level.vh_boat2 GetOccupantSeat( a_riders2[0] );
		
		if ( n_seat == 1 )
		{
			level.vh_boat2 UseVehicle( self, 2 );
		}
		else
		{
			level.vh_boat2 UseVehicle( self, 1 );
		}
	}
}

function hendricks_board()  //self = boat
{
	level endon( "hendricks_onboard" );
	
	level flag::wait_till( "hendricks_dive" );
	
	s_scene = struct::get( "tag_align_hendricks_swim" );
	
	s_scene thread scene::play( "cin_bio_15_01_waterpark_swim" );
	
	trigger::wait_till( "trigger_dock" );
	
	//breaks Hendricks out of waiting loop
	s_scene thread scene::stop( "cin_bio_15_01_waterpark_swim" );
	s_scene scene::init( "cin_bio_15_01_waterpark_vign_kill" );
	
	wait 0.25;
	
	//spawns an AI nearby, gets killed by Hendricks, and Hendricks moves up onto dock
	s_scene scene::play( "cin_bio_15_01_waterpark_vign_kill" );
	
	level.ai_hendricks notify( "stop_following" );
	
	s_board = struct::get( "hendricks_board" );
	
	level.ai_hendricks thread vo_swamp();
	
	//make sure Hendricks runs and fires on his way to the boat
	level.ai_hendricks.goalradius = 4;
	level.ai_hendricks ai::set_ignoreme( false );
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::disable_pain();
	
	level.ai_hendricks SetGoal( s_board.origin, true );
	level.ai_hendricks waittill( "goal" );
	
	level.ai_hendricks thread hendricks_geton_boat();
}

function vo_swamp()  //self = hendricks
{	
	level flag::wait_till( "hendricks_onboard" );
	
	if ( !level flag::get( "boats_go" ) )
	{
		
	}
	
	level flag::wait_till( "boats_go" );
	
	//boat starts off slowly
	self thread dialog::say( "We're not gonna get through here alive at this speed!" );
	
	level.vh_boat1 waittill( "boat_speed_up" ); //notify is set on spline node in radiant
	
	level dialog::remote( "kane_i_ll_focus_on_the_dr_0" );  //I’ll take care of the driving! Just keep them off your tail!
	
	level flag::wait_till( "fuel_truck" );
	
	self dialog::say( "hend_they_re_trying_to_bu_0" );  //They’re trying to burn us out!
	
	level flag::wait_till( "wasps_upahead" );
	
	trigger::wait_till( "trigger_swamp_1" );
	
	trigger::wait_till( "trigger_chaser_1" );
	
	trigger::wait_till( "trigger_hunter_corner" );
	
	level waittill( "collide_island" );
	
	level waittill( "get_out" );
}

function force_hendricks_onboard()
{
	level endon( "hendricks_onboard" );
	
	wait 10;  //if hendricks hasn't reach the boat by this time, teleport him onboard
	
	level.ai_hendricks thread hendricks_geton_boat();
}

function hendricks_geton_boat()  //self = hendricks
{
	level scene::play( "cin_bio_15_02_hendricks_vign_ontoboat" );
	
	level flag::set( "hendricks_onboard" );
	
	level thread scene::play( "cin_bio_15_03_waterpark_vign_shoot_center" );
	
	wait 0.1;  //allow scene to start before linking
	
	level.ai_hendricks LinkTo( level.vh_boat1 );
}

//self is player
function player_onto_boat_tracking()
{
	self endon( "death" );
	level endon( "boats_departed" );
	
	while ( true )
	{
		//play scene of player getting on a boat whenever they enter
		if ( self IsInVehicle() && !self flag::get( "player_on_boat" ) )
		{
			//add check just in case player remote hijacks something, which counts as being in a vehicle
			e_vehicle = self GetVehicleOccupied();
			if ( e_vehicle === level.vh_boat1 || e_vehicle === level.vh_boat2 )
			{
				self player_boards_boat( e_vehicle );
			}
		}
		else if ( !self IsInVehicle() && self flag::get( "player_on_boat" ) )
		{
			//leaving the boat
			self flag::clear( "player_on_boat" );
		}
		
		wait 0.05;
	}
}

//self is player
function player_boards_boat( e_boat )
{	
	self endon ( "death" );
	
	//find out which seat player is on now, since they will temporarily get kicked out when scene starts
	n_seat = e_boat GetOccupantSeat( self );
	
	self thread reserve_seat_during_boat_anim( e_boat, n_seat );
	
	//TODO starboardfar and portfar animations exist if player is trying to board seat from opposite side
	//would need extra logic to support those situations
	if ( n_seat == 1 )
	{
		//left (port) seat
		e_boat scene::play( "cin_bio_15_02_player_vign_ontoboat_portnear", self );
	}
	else
	{
		//right (starboard) seat
		e_boat scene::play( "cin_bio_15_02_player_vign_ontoboat_starboardnear", self );
	}

	//free up seat again to put now done animating player into it
	e_boat SetSeatOccupied( n_seat, false );
	e_boat UseVehicle( self, n_seat );
	
	self flag::set( "player_on_boat" );
}

function scene_player_onto_boat_play( a_ents )
{
	a_ents[ "player 1" ] notify( "started_boat_anim" );
}

//self is a player
function reserve_seat_during_boat_anim( e_boat, n_seat )
{
	self waittill( "started_boat_anim" );
	
	e_boat SetSeatOccupied( n_seat, true );
}

function check_player_boarding()
{
	level endon( "boats_departed" );
	
	while( 1 )
	{	
		level.n_boarded = 0;
		
		foreach ( player in level.players )
		{
			//this thread can run before the player spawns and initializes flag, make sure it exists first
			if ( player flag::exists( "player_on_boat" ) )
			{
				if ( player flag::get( "player_on_boat" ) )
				{
					level.n_boarded++;
				}
			}
		}
		
		if ( level.n_boarded == level.players.size )
		{
			level thread force_hendricks_onboard();
			
			level flag::set( "boats_go" );
			level flag::set( "fuel_truck" );
		}
		else
		{
			if ( level flag::get( "boats_go" ) )
			{
				level flag::clear( "boats_go" );
			}
			
			if ( level flag::get( "fuel_truck" ) )
			{
				level flag::clear( "fuel_truck" );
			}
		}
		
		wait 0.05;
	}
}

function airboat_depart()  //self = airboat
{
	level flag::wait_till( "hendricks_onboard" );
	level flag::wait_till( "boats_go" );
		
	self MakeVehicleUnusable();
	
	wait 1;
	
	//TODO - VO and stuff goes here before departure
	
	self thread airboat_sounds();
			
	self.nd_start = GetVehicleNode( self.target, "targetname" );
	
	if ( self.targetname == level.vh_boat2.targetname )
	{
		wait 1; //second boat lags behind first boat a bit
	}
	
	self fx::play( "boat_trail", undefined, undefined, "remove_boat_trail", true, "tag_origin_animate" );
	
	level flag::set( "boats_departed" );
	
	//set off hunter that destroys tanker in front
	trigger::use( "trigger_hunter_attack" );
	
	self vehicle::get_on_and_go_path( self.nd_start );
}

function player_protection()
{
	level flag::wait_till( "boats_go" );
	
	foreach ( player in level.players )
	{
		player.overridePlayerDamage = &callback_player_damage_onboat;
	}
}

function callback_player_damage_onboat( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, iBoneIndex, vSurfaceNormal )
{
	iDamage = 1;
	
	return iDamage;
}

function airboat_jump_land() //self = boat
{
	a_t_start = GetEntArray( "trigger_ramp_start", "targetname" );
	a_t_takeoff = GetEntArray( "trigger_ramp_end", "targetname" );
	a_t_land = GetEntArray( "trigger_ramp_land", "targetname" );
	
	foreach( t_start in a_t_start )
	{
		t_start thread boat_ramp_start( level.vh_boat1 );
		t_start thread boat_ramp_start( level.vh_boat2 );
	}
	
	foreach( t_takeoff in a_t_takeoff )
	{
		t_takeoff thread boat_ramp_takeoff( level.vh_boat1 );
		t_takeoff thread boat_ramp_takeoff( level.vh_boat2 );
	}
	
	foreach( t_land in a_t_land )
	{
		t_land thread boat_ramp_land( level.vh_boat1 );
		t_land thread boat_ramp_land( level.vh_boat2 );
	}
}

function boat_ramp_start( vh_boat )  //self = trigger
{
	level endon( "ride_over" );
	
	while( 1 )
	{
		self waittill( "trigger", e_trigger );
		
		if ( e_trigger == vh_boat )
		{
			vh_boat playsound ("veh_airboat_ramp_hit");
			vh_boat playsound ("veh_airboat_jump");
			vh_boat notify( "remove_boat_trail" );
			
			break;
		}
	}
}

function boat_ramp_takeoff( vh_boat )  //self = trigger
{
	level endon( "ride_over" );
	
	while( 1 )
	{
		self waittill( "trigger", e_trigger );
		
		if ( !level flag::get( "wasps_upahead" ) )
		{
			level flag::set( "wasps_upahead" );
		}
			
		if ( e_trigger == vh_boat )
		{
			vh_boat playsound ( "veh_airboat_jump_air" );
			
			break;
		}
	}
}

function boat_ramp_land( vh_boat )  //self = trigger
{
	level endon( "ride_over" );
	
	while( 1 )
	{
		self waittill( "trigger", e_trigger );
			
		if ( e_trigger == vh_boat )
		{
			vh_boat playsound ( "veh_airboat_land" );
			
			vh_boat fx::play( "boat_land_splash", undefined, undefined, 4, true, "tag_origin_animate"  );
			vh_boat fx::play( "boat_trail", undefined, undefined, "remove_boat_trail", true, "tag_origin_animate" );
			
			break;
		}
	}
}

function airboat_jump_wasp()
{
	trigger::wait_till( "trigger_boatjump_wasp" );
	
	a_nd_starts = GetVehicleNodeArray( "wasp_jump_start", "targetname" );
	
	a_vh_wasps = [];
	
	for ( i = 0; i < a_nd_starts.size; i++ )
	{
		a_vh_wasps[i] = spawner::simple_spawn_single( "wasp_jump" );
		
		wait 0.05;
		
		a_vh_wasps[i] vehicle_ai::start_scripted();
		
		a_vh_wasps[i] thread wasp_jump_kill();
		
		a_vh_wasps[i] thread vehicle::get_on_and_go_path( a_nd_starts[i] );
	}
}

function airboat_kill_wasp()
{
	trigger::wait_till( "trigger_wasp_kill" );
	
	level flag::set( "kill_wasps" );
}

function wasp_jump_kill()  //self = WASP
{
	self endon( "death" );
	
	self waittill( "reached_end_node" );
	
	self vehicle_ai::stop_scripted( "combat" );
	
	level flag::wait_till( "kill_wasps" );
	
	wait RandomFloatRange( 1.5, 2.5 );  //don't want every wasp dieing at once
	
	self kill();
}

function dock_guard()
{
	level flag::wait_till( "all_players_spawned" );
	
	spawner::simple_spawn( "dock_guard", &dock_guard_logic );
	spawner::simple_spawn( "water_guard", &water_guard_logic );
}

function swamp_guard_1()
{
	trigger::wait_till( "trigger_swamp_1" );
	
	spawner::simple_spawn( "swamp_guard1", &cleanup_guard );
}

function outpost_tower_destroy()
{
	mdl_outpost1 = GetEnt( "clip_outpost1", "targetname" );
	t_outpost = GetEnt( "trigger_outpost_dmg", "targetname" );
	
	t_outpost waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon );
	
	level thread scene::play( "p7_fxanim_cp_biodomes_outpost_01_bundle" );
	
	ai_tower = GetEnt( "tower_guard", "script_noteworthy", true );
	
	if ( IsAlive( ai_tower ) )
	{
		ai_tower StartRagDoll();
		
		ai_tower LaunchRagDoll( ( 0, -80, 80 ) );
	}
	
	mdl_outpost1 Delete();
}

function swamp_guard_2()
{
	trigger::wait_till( "trigger_swamp_2" );
	
	level notify( "hunter2_fire" );
	level notify( "hunter_resume" );
	
	//spawner::simple_spawn( "swamp_guard2", &cleanup_guard );
}

function swamp_guard_3()
{
	trigger::wait_till( "trigger_swamp_3" );
	
	spawner::simple_spawn( "swamp_guard3", &cleanup_guard );
}

function dock_guard_logic()
{
	self endon( "death" );
	
	self.goalradius = 16;
	
	trigger::wait_till( "trigger_dock" );
	
	wait RandomFloatRange( 0.5, 1.5 );
	
	self.goalradius = 2048;
	
	if ( isdefined( self.script_noteworthy ) )
	{
		s_goal = struct::get( self.script_noteworthy, "targetname" );
	
		if ( isdefined( s_goal ) )
		{
			self SetGoal( s_goal.origin, false, 300 );
		}
	}
	
	level waittill( self.targetname );
	
	self kill();
}

function water_guard_logic()
{
	self endon( "death" );
	
	self.goalradius = 16;
	
	self ai::set_behavior_attribute( "cqb", true );
	
	trigger::wait_till( "trigger_dock_advance" );
	
	wait RandomFloatRange( 0.5, 1.5 );
	
	s_goal = struct::get( self.script_noteworthy );
	
	self SetGoal( s_goal.origin, true );
	
	trigger::wait_till( "trigger_hendricks_board" );
	
	self.goalradius = 2048;
	
	self ai::set_behavior_attribute( "cqb", false );
	
	level waittill( self.targetname );
	
	self kill();
}

function bridge_guard_1()
{
	trigger::wait_till( "trigger_bridge_1" );
	
	spawner::simple_spawn( "swamp_guard_bridge1", &cleanup_guard );	
}

function bridge_guard_2()
{
	trigger::wait_till( "trigger_bridge_2" );
	
	spawner::simple_spawn( "swamp_guard_bridge2", &cleanup_guard );	
}

function cleanup_guard()
{
	self endon( "death" );
	
	self.goalradius = 8;
	
	self.health = 1;
	
	if ( self.targetname == "swamp_guard_bridge1_ai" )
	{
		trigger::wait_till( "trigger_bridge1_guys" );
		
		nd_goal = GetNode( self.script_noteworthy, "targetname" );
		
		wait RandomFloatRange( 0.1, 0.4 );
		
		self SetGoal( nd_goal.origin, true );
	}
	
	if ( self.targetname == "swamp_guard_bridge2_ai" )
	{
		trigger::wait_till( "trigger_bridge2_guys" );
		
		nd_goal = GetNode( self.script_noteworthy, "targetname" );
				
		wait RandomFloatRange( 0.1, 0.4 );
		
		self SetGoal( nd_goal.origin, true );
	}
	
	level waittill( self.targetname );
	
	self kill();
}

function hunter_callback()
{
	self endon( "death" );
	
	Target_Set( self, ( 0, 0, 0 ) );

	self.health = self.healthdefault;

	self vehicle::friendly_fire_shield();

	self EnableAimAssist();
	self SetNearGoalNotifyDist( 50 );

	self SetHoverParams( 15, 100, 40 );
	self.flyheight = GetDvarFloat( "g_quadrotorFlyHeight" );
	
	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0.574;	//+/- 55 degrees = 110 fov

	self.vehAirCraftCollisionEnabled = true;

	self.original_vehicle_type = self.vehicletype;

	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );

	self.goalRadius = 300;
	self.goalHeight = 512;
	
	self hunter_initTagArrays();

	self.overrideVehicleDamage = &HunterCallback_VehicleDamage;

	self thread vehicle_ai::nudge_collision();

	self turret::_init_turret( 1 );
	self turret::_init_turret( 2 );

	self turret::set_burst_parameters( 1, 2, 1, 2, 1 );
	self turret::set_burst_parameters( 1, 2, 1, 2, 2 );

	self turret::set_target_flags( 1 | 2, 1 );
	self turret::set_target_flags( 1 | 2, 2 );

	//hunter::defaultRole();
}

function HunterCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	damageLevelChanged = vehicle::update_damage_fx_level( self.health, iDamage, self.healthdefault );
	return iDamage;
}

function hunter_initTagArrays()
{
	self.missileTags = [];
	
	if ( !isdefined( self.missileTags ) ) self.missileTags = []; else if ( !IsArray( self.missileTags ) ) self.missileTags = array( self.missileTags ); self.missileTags[self.missileTags.size]="tag_rocket1";;
	if ( !isdefined( self.missileTags ) ) self.missileTags = []; else if ( !IsArray( self.missileTags ) ) self.missileTags = array( self.missileTags ); self.missileTags[self.missileTags.size]="tag_rocket2";;
}

function hunter_fuel_truck()
{
	trigger::wait_till( "trigger_hunter_attack" );
	
	objectives::complete( "cp_level_biodomes_escape" );
	
	vh_hunter = spawner::simple_spawn_single( "hunter_swamp_1", &hunter1_spawn_func );
}

function hunter1_spawn_func()  //self = hunter
{
	self endon( "death" );
	
	self SetForceNoCull();
	
	nd_start = GetVehicleNode( self.target, "targetname" );
	
	self thread vehicle::get_on_and_go_path( nd_start );
	
	self thread missile_volley();
	
	e_target = GetEnt( "fuel_truck_missile", "targetname" );
	
	self SetTurretTargetEnt( e_target );
	
	self thread hunter_fire_missile( 0, e_target, undefined, false, 0.5 );
	e_missile = self thread hunter_fire_missile( 1, e_target, undefined, false, 0.5 );
	e_missile thread hunter_missile_explosion( e_target );
	
	self waittill( "hunter_stop" );
	
	self SetSpeedImmediate( 0 );
	
	level waittill( "hunter2_fire" );
	
	self thread hunter_divert_fire();
	
	trigger::wait_till( "trigger_hunter_corner" );
	
	self ResumeSpeed( 50 );
	
	self notify( "stop_fire" );
	
	level waittill( "hunter_start_fire" );
	
	self thread hunter_open_fire();
}

function hunter_divert_fire()  //self = hunter
{
	a_e_targets = [];
	
	for( i = 1; i < 4; i++ )
	{
		a_e_targets[i] = GetEnt( "divert_" + i, "targetname" );
		
		self thread hunter_fire_missile( 0, a_e_targets[i], undefined, false, 0.5 );
		self thread hunter_fire_missile( 1, a_e_targets[i], undefined, false, 0.5 );
		
		wait 0.5;
	}
}

function missile_volley()
{
	e_target1 = GetEnt( "intro_missile1", "targetname" );
	e_target1a = GetEnt( "intro_missile1a", "targetname" );
	e_target2 = GetEnt( "intro_missile2", "targetname" );
	e_target2a = GetEnt( "intro_missile2a", "targetname" );
	
	self thread hunter_fire_missile( 0, e_target1 );
	self thread hunter_fire_missile( 1, e_target1a );
	
	e_target1 Delete();
	e_target1a Delete();
		
	wait 0.5;
		
	self thread hunter_fire_missile( 0, e_target2 );
	self thread hunter_fire_missile( 1, e_target2a );
	
	e_target2 Delete();
	e_target2a Delete();
}

function hunter_stop_and_go()  //self = hunter
{
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "hunter_stop" );
		
		self SetSpeed( 0, 45, 25 );
		
		level waittill( "hunter_resume" );
		
		self ResumeSpeed( 50 );
	}
}

function hunter_open_fire()
{
	self endon( "death" );
	self endon( "stop_fire" );
	
	while( 1 )
	{
		e_boat = level.vh_boat1;
		
		v_angles = e_boat GetTagAngles( "tag_driver" );
		
		v_pos = e_boat GetTagOrigin( "tag_driver" ) + AnglesToForward( v_angles ) * 1500;
		
		e_target = Spawn( "script_model", v_pos );
					
		self thread hunter_fire_missile( 0, e_target );
		self thread hunter_fire_missile( 1, e_target );
		
		wait RandomFloatRange( 1.0, 2.0 );
		
		e_target delete();
	}
}

function hunter_fire_missile( launcher_index, target, offset, blinkLights, waittimeAfterBlinkLights )
{
	self endon( "death" );

	if ( ( isdefined( blinkLights ) && blinkLights ) )
	{
		self vehicle_ai::blink_lights_for_time( 1 );

		if ( isdefined( waittimeAfterBlinkLights ) && waittimeAfterBlinkLights > 0 )
		{
			wait waittimeAfterBlinkLights;
		}
	}

	if ( !isdefined( offset ) )
	{
		offset = ( 0, 0, 0 );
	}

	spawnTag = self.missileTags[ launcher_index ];
	origin = self GetTagOrigin( spawnTag );
	angles = self GetTagAngles( spawnTag );
	forward = AnglesToForward( angles );
	up = AnglesToUp( angles );

	if ( isdefined( spawnTag ) )
	{
		weapon = GetWeapon( "hunter_rocket_turret" );
		missile = MagicBullet( weapon, origin, target.origin, self, target, offset );
		
		return missile;
	}
}

function hunter_missile_explosion( e_target )  //self = hunter missile
{
	self waittill( "death" );
	
	fx::play( "explosion_lg", e_target.origin );
	
	mdl_truck_before = GetEnt( "fuel_truck_before", "targetname" );
	mdl_truck_after = GetEnt( "fuel_truck_after", "targetname" );
	
	mdl_truck_before delete();
	mdl_truck_after Show();
	
	wait 0.1;  //wait a bit for the explosion to reach players
	
	Earthquake( 0.8, 2.0, e_target.origin, 5000 );
	
	exploder::exploder( "Objective_swamps_tanker_impact_fire" );
	
	s_air = struct::get( "fuel_truck_air" );
	s_pos = struct::get( "fuel_truck_pos" );
	
	mdl_truck_after MoveTo( s_air.origin, 0.5 );
	mdl_truck_after RotateTo( s_air.angles, 0.5 );
	wait 0.45;
	mdl_truck_after MoveTo( s_pos.origin, 0.5 );
	mdl_truck_after RotateTo( s_pos.angles, 0.5 );
}

function hunter_turret_attack()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );
	
	while( 1 )
	{
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			if( DistanceSquared( self.enemy.origin, self.origin ) < ( (self.settings.engagementDist * 3) * (self.settings.engagementDist * 3) ) ) 
			{
				self SetTurretTargetEnt( self.enemy );
				self SetLookAtEnt( self.enemy );
				self vehicle_ai::fire_for_time( RandomFloatRange( 1, 2 ) );
			}
			
			if( isdefined( self.enemy ) && IsAI( self.enemy ) )
			{
				wait( RandomFloatRange( 1, 2 ) );
			}
			else
			{
				wait( RandomFloatRange( 0.8, 1.3 ) );
			}
		}
		else
		{
			self ClearTurretTarget();
			wait 0.4;
		}
	}
}

function hunter_rocket_attack()
{
	self endon( "death" );
	self endon( "change_state" );
	self endon( "end_attack_thread" );

	while( true )
	{
		if ( isdefined( self.enemy ) && self VehCanSee( self.enemy ) && vehicle_ai::IsCooldownReady( "rocket_launcher" ) )
		{
			target = self.enemy;
			self SetLookAtEnt( target );
			wait 0.5;

			randomRange = 20;
			offset = [];
			for ( i = 0; i < 2; i++ )
			{
				offset[i] = ( RandomFloatRange( -randomRange, randomRange ), RandomFloatRange( -randomRange, randomRange ), RandomFloatRange( -randomRange, randomRange ) );
			}

			self thread hunter_fire_missile( 0, target );
			wait 0.25;
			self thread hunter_fire_missile( 1, target );

			wait 1;
			vehicle_ai::Cooldown( "rocket_launcher", 3 );
			//self thread Movement_Thread_StayInDistance();
		}
		wait 0.5;
	}
}

function wasp_chaser_1()
{
	trigger::wait_till( "trigger_chaser_1" );
	
	nd_start = GetVehicleNode( "chaser1_start", "targetname" );
	
	a_vh_wasps = [];
	
	for ( i = 0; i < 12; i++ )
	{
		a_vh_wasps[i] = spawner::simple_spawn_single( "wasp_chaser1" );
		
		wait 0.05;
		
		a_vh_wasps[i] thread wasp_chaser_spawn_func( nd_start, level.vh_boat1 );
	}
}

function wasp_chaser_2()
{
	trigger::wait_till( "trigger_chaser_2" );
	
	nd_start = GetVehicleNode( "chaser2_start", "targetname" );
	
	a_vh_wasps = [];
	
	for ( i = 0; i < 12; i++ )
	{
		a_vh_wasps[i] = spawner::simple_spawn_single( "wasp_chaser2" );
		
		wait 0.05;
		
		a_vh_wasps[i] thread wasp_chaser_spawn_func( nd_start, level.vh_boat2 );
	}
}

function wasp_chaser_spawn_func( nd_start, vh_boat ) //self = wasp
{
	self endon( "death" );
	
	self vehicle_ai::start_scripted();
	
	self thread wasp_fire();
	self thread wasp_chaser_speed( vh_boat );
		
	v_offset = ( RandomIntRange( -200, 200 ), RandomIntRange( -200, 200 ), RandomIntRange( -100, 120 ) );
		
	self PathFixedOffset( v_offset );
		
	self thread vehicle::get_on_and_go_path( nd_start );
	
	trigger::wait_till( "trigger_outpost" );
		
	if ( self.targetname == "wasp_chaser1_ai" )
	{
		wait RandomFloatRange( 2.5, 2.8 );  //don't want every wasp dieing at once
	}
	else
	{
		wait RandomFloatRange( 0.5, 0.8 );  //don't want every wasp dieing at once
	}
	
	self kill();
}

function wasp_chaser_speed( vh_boat )  //self = wasp
{
	self endon( "death" );
	
	while( 1 )
	{
		n_speed = vh_boat GetSpeedMPH();
		
		self SetSpeed( n_speed );
		
		wait 0.1;
	}
}

function wasp_fire()
{
	self endon( "death" );
	
	while( 1 )
	{
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			if( DistanceSquared( self.enemy.origin, self.origin ) < ( (self.settings.engagementDist * 3) * (self.settings.engagementDist * 3) ) ) 
			{
				self SetTurretTargetEnt( self.enemy );
				self vehicle_ai::fire_for_time( RandomFloatRange( 0.3, 0.6 ) );
			}

			if( isdefined( self.enemy ) && IsAI( self.enemy ) )
			{
				wait( RandomFloatRange( 2, 2.5 ) );
			}
			else
			{
				wait( RandomFloatRange( 0.5, 1.5 ) );
			}
		}
		else
		{
			wait 0.4;
		}
	}
}

function wasp_swarm()
{
	trigger::wait_till( "trigger_wasp_swarm" );
	
	spawner::simple_spawn( "wasp_swarm_1", &cleanup_wasps, "kill_wasp_1" );
	
	trigger::wait_till( "trigger_wasp_mid" );
	
	level notify( "kill_wasp_1" );
	
	spawner::simple_spawn( "wasp_swarm_mid", &cleanup_wasps, "kill_wasp_mid" );
	
	trigger::wait_till( "trigger_wasp_swarm2" );
	
	level notify( "kill_wasp_mid" );
	
	spawner::simple_spawn( "wasp_swarm_2", &cleanup_wasps, "kill_wasp_2" );
	
	trigger::wait_till( "trigger_remove_wasp" );
	
	level notify( "kill_wasp_2" );
}

function wasp_plane()
{
	trigger::wait_till( "trigger_wasp_plane" );
	
	spawner::simple_spawn( "wasp_swarm_plane", &cleanup_wasps_plane, "kill_wasp_plane" );	
}

function cleanup_wasps( str_notify )  //self = wasp
{
	self endon( "death" );
	
	level waittill( str_notify );
	
	self Kill();
}

function cleanup_wasps_plane( str_notify )  //self = wasp
{
	self endon( "death" );
	
	self vehicle_ai::start_scripted();
	
	wait 0.5;  //keep wasps inside for a bit
	
	self vehicle_ai::stop_scripted( "combat" );
	
	level waittill( str_notify );
	
	self Kill();
}

function outpost_crash()
{
	trigger::wait_till( "trigger_outpost" );
	
	a_mdl_clips = GetEntArray( "outpost_clips", "script_noteworthy" );
	
	foreach( clip in a_mdl_clips )
	{
		clip delete();
	}
	
	mdl_outpost = GetEnt( "outpost_crash", "targetname" );
	
	if ( isdefined( mdl_outpost ) )
	{
		a_ai_guards = util::get_ai_array( "swamp_guard3_ai", "targetname" );
		
		foreach( ai_guard in a_ai_guards )
		{
			ai_guard StartRagdoll();
			ai_guard LaunchRagDoll( ( RandomIntRange( -100, 100 ), RandomIntRange( -100, 100 ), RandomIntRange( 80, 100 ) ) );
		}
		
		mdl_outpost delete();
	}
	
	level thread scene::play( "p7_fxanim_cp_biodomes_outpost_boat_crash_bundle" );
}

function jump_land_city( t_land )  //self = player
{
	t_land waittill( "trigger" );
		
	Earthquake( 1.0, 2.5, self.origin, 400 );
		
	self PlayRumbleOnEntity( "damage_heavy" );	
}

function igc_end()
{
	level.vh_boat1.animname = "boat1";
	level.vh_boat2.animname = "boat2";
	
	trigger::wait_till( "trigger_end_igc" );
	
	level scene::stop( "cin_bio_15_03_waterpark_vign_shoot_center" );
	util::wait_network_frame();
	
	level thread mission_over();
	
	level thread scene::play( "cin_bio_16_01_slide_1st_slammed" );
	
	level notify( "get_out" );
}


function mission_over()  //self = boat 1
{
	level waittill( "notetrack_fadeout" );  //fade out to hide player popping back to start of IGC location
	
	util::screen_fade_out( 1 );
	
	wait 0.5;
	
	skipto::objective_completed( "objective_swamps" );
}

function airboat_sounds()  //self = boat
{
	//TODO add some kind of sputtering sound for airboat getting revved up before the hunter kicking in fully
	
	self waittill( "boat_speed_up" ); //allow some time for boat to pick up speed, notify is set on spline node in radiant
	
	self playsound( "veh_airboat_start" );
	self.sndent = spawn( "script_origin", (self.origin) );
	self.sndent LinkTo( self );
	self.sndent playloopsound ( "veh_airboat_loop", 2 );
	
	level waittill( "get_out" );
	wait (2);
	self playsound ("veh_airboat_stop");
	self.sndent stoploopsound (.2);
}



//dev skiptos
//skips the swimming up to the boat and fighting enemies part
function dev_swamp_rail_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_swamps_init" );
	
	objectives::set( "cp_level_biodomes_escape", struct::get( "airboat_waypoint" ) );
	
	cp_mi_sing_biodomes_util::init_hendricks( str_objective );
	
	level flag::set( "hendricks_dive" );
	
	level thread airboat_spawn_dev(); //handles Hendricks boarding a bit different from the normal version
	level thread hunter_fuel_truck();
	
	level.vehicle_main_callback["hunter"] = &hunter_callback;

	level flag::set( "reached_dock" );
	level thread player_protection();
	level thread airboat_jump_wasp();
	level thread airboat_kill_wasp();
	level thread swamp_guard_1();
	level thread outpost_tower_destroy();
	level thread bridge_guard_1();
	level thread bridge_guard_2();
	level thread swamp_guard_2();
	level thread swamp_guard_3();
	level thread wasp_swarm();
	level thread wasp_plane();
	level thread outpost_crash();
	level thread destroy_ferriswheel();
			
	t_city_land = GetEnt( "trigger_store_crash", "targetname" );
	
	foreach( player in level.players )
	{
		player thread jump_land_city( t_city_land );
	}
}

function airboat_spawn_dev()
{
	level.n_boarded = 0;
	
	level.vh_boat1 = vehicle::simple_spawn_single( "airboat_1" );
	level.vh_boat2 = vehicle::simple_spawn_single( "airboat_2" );
	
	level.vh_boat1 SetCanDamage( false );
	level.vh_boat2 SetCanDamage( false );
	
	level thread check_player_boarding();
	
	boat_setup_seats();
	
	//put Hendricks directly in the boat at the beginning
	level.ai_hendricks notify( "stop_following" );
	
	s_board = struct::get( "hendricks_board" );
	
	level.ai_hendricks thread vo_swamp();
	
	//make sure Hendricks runs and fires on his way to the boat
	level.ai_hendricks.goalradius = 4;
	level.ai_hendricks ai::set_ignoreme( false );
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::disable_pain();
	
	level.ai_hendricks SetGoal( s_board.origin, true );
	level.ai_hendricks waittill( "goal" );
	
	level.ai_hendricks thread hendricks_geton_boat();
	
	level.vh_boat1 MakeVehicleUsable();
	level.vh_boat2 MakeVehicleUsable();

	level thread airboat_jump_land();
	level thread airboat_rumbler();
	level thread tall_grass();
	level thread igc_end();
		
	level.vh_boat1 thread airboat_depart();
	level.vh_boat2 thread airboat_depart();
	level.vh_boat2 thread boat_scrape();
	
	level thread airboat_icon();
	level thread exploder_triggers();
}

//lets user replay the final cutscene as much as needed
function dev_swamp_final_scene_init( str_objective, b_starting )
{	
	cp_mi_sing_biodomes_util::init_hendricks( str_objective );
		
	level flag::set( "hendricks_dive" );
	
	level.n_boarded = 0;
	
	level.vh_boat1 = vehicle::simple_spawn_single( "airboat_1" );
	level.vh_boat2 = vehicle::simple_spawn_single( "airboat_2" );
	
	level.vh_boat1 SetCanDamage( false );
	level.vh_boat2 SetCanDamage( false );
	
	level thread check_player_boarding();
	boat_setup_seats();
	
	//put Hendricks directly in the boat at the beginning	
	level.ai_hendricks thread hendricks_geton_boat();
	
	level.vh_boat1.animname = "boat1";
	level.vh_boat2.animname = "boat2";
	
	level flag::wait_till( "first_player_spawned" );

	level.players[0] thread force_player_onboard();
	
	level flag::wait_till( "hendricks_onboard" );
	
	while ( true )
	{		
		util::screen_fade_in( 2 );
		
		//so that scene doesn't immediately play after spawning from dev skipto
		level thread util::screen_message_create( "PRESS UP ON D-PAD TO PLAY FINAL SCENE", undefined, undefined, undefined, 10 );
		while ( true )
		{
			if ( level.players[0] ActionSlotOneButtonPressed() )
			{
				break;
			}
			
			wait 0.05;
		}
		util::screen_message_delete();
		
		if ( level scene::is_active( "cin_bio_15_03_waterpark_vign_shoot_center" ) )
		{
			level scene::stop( "cin_bio_15_03_waterpark_vign_shoot_center" );
			util::wait_network_frame();
		}
		
		level thread scene::play( "cin_bio_16_01_slide_1st_slammed" );
		
		level notify( "get_out" );
		
		level waittill( "notetrack_fadeout" );  //fade out to hide player popping back to start of IGC location
		
		util::screen_fade_out( 1 );
	}
}