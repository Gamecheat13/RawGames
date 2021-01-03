#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\cp\_dialog;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;

#using scripts\cp\_debug;

#using scripts\shared\spawner_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\scene_shared;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_util;
#using scripts\cp\_objectives;
#using scripts\cp\_skipto;
#using scripts\shared\animation_shared;

#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\vehicle_ai_shared;

#using scripts\cp\cp_mi_sing_vengeance_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\_util;

#namespace vengeance_intro;

function skipto_intro_init( str_objective, b_starting )
{	
	vengeance_util::skipto_baseline( str_objective, b_starting );
	
	vengeance_util::init_hero( "hendricks", str_objective );
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	level.ai_hendricks.goalradius = 32;
	
	callback::on_spawned( &vengeance_intro::on_player_spawned );

	level util::screen_fade_out( 0 );
	
	level flag::wait_till( "all_players_spawned" );
	wait( 0.25 );
	
	level util::screen_fade_out( 0 );
	
	foreach( e_player in level.players )
	{
		e_player Freezecontrols( true );
		e_player setClientUIVisibilityFlag( "hud_visible", 0 );
	}	

	intro_main();
}

function on_player_spawned() // self = player
{
	self endon( "death" );
	
	self allowsprint( false );
	self allowjump( false );	
	self SetLowReady( true );
}

function intro_main()
{
	level thread intro_street_vignette_setup();
	
	intro_screen();

	level flag::set( "intro_wall_done" );

//	level thread intro_street_ambient_vehicles();
	
	level thread intro_hendricks();

	trig = getent( "obj_intro_complete", "targetname" );
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;
	
	trigger::wait_till( "obj_intro_complete", "targetname" );
	
	foreach( e_player in level.players )
	{
		e_player SetLowReady( false );
	}
	
	skipto::objective_completed( "intro" );
}

function intro_street_vignette_setup()
{
	intro_street_vign = struct::get_array( "intro_street_vign", "targetname" );

	intro_street_spawner_array = [];
	
	foreach( vign in intro_street_vign )
	{
		intro_street_vign_spawner = spawner::simple_spawn_single( "intro_street_vign_spawner" );
		intro_street_vign_spawner.team = "allies";
		array::add( intro_street_spawner_array, intro_street_vign_spawner );
		//level thread street_vignette_play( vign, intro_street_vign_spawner );
		if( vign.script_noteworthy == "cin_bio_04_01_market2_vign_bound_civ01" || vign.script_noteworthy == "cin_bio_04_01_market2_vign_bound_civ02" )
		{
			intro_street_vign_spawner thread vign_bound_civ( vign );
		}
		else
		{
			intro_street_vign_spawner.allowdeath = false;
			level thread street_vignette_play( vign, intro_street_vign_spawner );
		}
	}
	
	level flag::wait_till( "civilian_rescue_complete" );
	wait( 1 );
	
	foreach( spawner in intro_street_spawner_array )
	{
		if( IsDefined( spawner ) )
		{
			spawner stopanimscripted();
			spawner Delete();
		}
	}
}

function street_vignette_play( vign, intro_street_vign_spawner )
{
	level endon( "civilian_rescue_complete" );
	intro_street_vign_spawner endon( "death" );
	
	intro_street_vign_spawner thread animation::play( vign.script_parameters, vign.origin, vign.angles );
		
	if ( IsAnimLooping( vign.script_parameters ) )
		return;

	wait GetAnimLength( vign.script_parameters );
	
	while( 1 )
	{
		intro_street_vign_spawner animation::play( vign.script_parameters, vign.origin, vign.angles );
		wait( 0.05 );
	}
/*	
	while( 1 )
	{
		vign scene::play( vign.script_noteworthy, intro_street_vign_spawner );	
		wait(0.05);
	}
*/
}

function vign_bound_civ( vign )
{
	vign thread scene::play( vign.script_noteworthy, self );
	wait( 0.5 );
	self kill();	
}

function intro_screen()
{
	level util::screen_fade_out( 0 );
	
	intro_anim_struct = struct::get( "intro_hendricks", "targetname" );
	
	intro_anim_struct scene::init( "cin_ven_01_10_introwall_3rd" );
	
	wait( 1 );
	
	//Hendricks: Kane, what is your situtation?
	level dialog::remote( "hend_kane_we_re_ascendin_0" );

	wait(0.5);
	
	level thread util::screen_fade_in( 1 );
	
	intro_anim_struct thread scene::play( "cin_ven_01_10_introwall_3rd" );
	
	level thread intro_screen_vo();
	
	//wait(17);
	level.ai_hendricks waittill( "intro_igc_fade_to_black" );
	
	level util::screen_fade_out( 1 );
	
//	intro_anim_struct waittill( "scene_done" );
	
	wait( 1 );
	
	skipto::teleport( "intro_teleport", undefined, undefined );
	
	wait( 0.5 );
	
	level util::screen_fade_in( 1 );
	
	foreach( e_player in level.players )
	{
		e_player Freezecontrols( false );
		e_player setClientUIVisibilityFlag( "hud_visible", 1 );
	}
}

function intro_screen_vo()
{
	//Kane: The safehouse is under coordinated attack by the 54i. We’re dug in but it’s not good. Need you back here, now!
	level dialog::remote( "kane_code_black_the_safe_0" );                 
	wait(0.15);
	//Hendricks: Copy that. We’re on the wall south of the safehouse, hold tight.
	level dialog::remote( "hend_kane_we_can_see_the_0" );
	wait(0.25);
	//Player: The city’s crawling with 54i… we can’t get bogged down in a firefight.
	//level.players[0] dialog::say( "plyr_the_city_s_crawling_0" );
	//level.players[0] dialog::player_say( "plyr_the_city_s_crawling_0" );
	level dialog::player_say( "plyr_the_city_s_crawling_0" );
	//intro_player_vo	= GetEnt( "intro_player_vo", "targetname" );
	//intro_player_vo dialog::say( "plyr_the_city_s_crawling_0" );
	wait(0.15);
	//Hendricks: Agreed, equip suppressors.
	level.ai_hendricks dialog::say( "hend_this_place_is_crawli_0" );
	wait(1);
	//Hendricks: Keep it quiet and keep moving. Let's go.
	level.ai_hendricks thread dialog::say( "hend_keep_it_quiet_and_ke_0" );
}

function intro_street_ambient_vehicles()
{
	level endon( "clotheslines_begin" );
	
	count = 0;
	
	while( count <= 75 )
	{
		vehicle::add_spawn_function( "intro_street_technical", &give_riders );     
	
		intro_street_technical = vehicle::simple_spawn_single_and_drive( "intro_street_technical" );
		
//		intro_street_technical = vehicle::simple_spawn_single( "intro_street_technical" );	
//		truck_start = GetVehicleNode( intro_street_technical.target, "targetname" );
//		intro_street_technical thread vehicle::get_on_and_go_path( truck_start );
		
		count ++;
		
		wait( RandomFloatRange( 15, 20 ) );
	}
}

function give_riders()
{
	a_ai_riders = [];
	a_str_rider_positions = Array( "driver", "passenger1", "gunner1" );
	a_str_rider_spawners = Array( "intro_street_technical_enemy1", "intro_street_technical_enemy2", "intro_street_technical_enemy3" );
	a_str_rider_spawners = array::randomize( a_str_rider_spawners );
	
	for( i = 0; i < a_str_rider_positions.size; i++ )
	{
		a_ai_riders[i] = spawner::simple_spawn_single( a_str_rider_spawners[i] );
		
		a_ai_riders[i] ai::set_ignoreall( true );
		
		a_ai_riders[i] vehicle::get_in( self, a_str_rider_positions[i], true );
	}
}

function intro_hendricks()
{
	level.ai_hendricks ai::set_behavior_attribute( "cqb", true );
	trigger::use( "intro_wall_hendricks_movement_trigger", "targetname", level.ai_hendricks );
	
	level flag::wait_till( "hendricks_comments_on_massacre" );
	
	//"Hendricks: This was a massacre... they didn’t leave anyone alive."
	level.ai_hendricks dialog::say( "hend_this_was_a_massacre_0" );
}

function skipto_intro_done( str_objective, b_starting, b_direct, player )
{
}

/*****************************************
 * -- Civilian Rescue --
 * ***************************************/

function skipto_civilian_rescue_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		vengeance_util::skipto_baseline( str_objective, b_starting );
	
		vengeance_util::init_hero( "hendricks", str_objective );
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		level.ai_hendricks.goalradius = 32;
		
		objectives::set( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
		//objectives::set( "obj_follow" , level.ai_hendricks );
		
		level flag::wait_till( "all_players_spawned" );
		wait( 0.25 );
	}	
	
	level flag::set( "civilian_rescue_begin" );
	
	civilian_rescue_main();
}

function civilian_rescue_main()
{
	level thread civilian_rescue_hendricks();
	
	level thread civilian_rescue_scene_setup();
	
	level thread civilian_rescue_scene();
	
	level flag::wait_till( "hendricks_enters_apartment_building1_bedroom" );
	foreach( e_player in level.players )
	{
		e_player allowsprint( true );
		e_player allowjump( true );	
	}
	
	level flag::wait_till( "civilian_rescue_complete" );

	skipto::objective_completed( "civilian_rescue" );
}

function civilian_rescue_hendricks()
{
	level flag::wait_till( "hendricks_comments_on_noises" );
	
	//"Hendricks: Hear that?  Contact ahead, take it slow."
	level.ai_hendricks thread dialog::say( "hend_hear_that_contact_0" );
	
	level flag::wait_till( "hendricks_heading_to_apartment_building1_bedroom_door" );
	level.ai_hendricks waittill( "goal" );
	
	level flag::wait_till( "player_ready_to_enter_apartment_building1_bedroom" );

	bedroom_door = GetEnt( "apartment_building1_bedroom_door", "targetname" );
	bedroom_door_struct = struct::get( "apartment_building1_bedroom_door_struct", "targetname" );
	bedroom_door_origin = util::spawn_model( "tag_origin", bedroom_door_struct.origin, bedroom_door_struct.angles );
	bedroom_door LinkTo( bedroom_door_origin, "tag_origin" );
	bedroom_door_clip = GetEnt( "apartment_building1_bedroom_door_left_clip", "targetname" );
	bedroom_door_clip LinkTo( bedroom_door_origin, "tag_origin" );
			
	bedroom_door_origin rotateyaw( 95, 1 );
	bedroom_door_origin connectpaths();
	wait( 1 );
	bedroom_door_origin Delete();

	trigger::use( "hendricks_enters_apartment_building1_bedroom_trigger", "targetname", level.ai_hendricks );
	
	wait( 1 );
	
	objectives::complete( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
	
	wait( 3 );
	
	//objectives::set( "obj_civilian_rescue" );
	objectives::set( "cp_level_vengeance_civilian_rescue" );
	
	level flag::wait_till_any( array( "civilian_rescue_enemies_alerted", "civilian_rescue_on_three" ) );
	level.ai_hendricks setgoalpos( level.ai_hendricks.origin );
	
	civilian_rescue_clip = GetEnt( "civilian_rescue_clip", "targetname" );
	civilian_rescue_clip NotSolid();
	civilian_rescue_clip connectpaths();
	civilian_rescue_clip Delete();
	
	if( IsDefined( level.civilian_rescue_badguy3 ) && IsAlive( level.civilian_rescue_badguy3 ) )
	{
		hendricks_target = level.civilian_rescue_badguy3;
	}
	else if( IsDefined( level.civilian_rescue_badguy1 ) && IsAlive( level.civilian_rescue_badguy1 ) )
	{
		hendricks_target = level.civilian_rescue_badguy1;
	}
	
	//hendricks_target = array::get_closest( level.ai_hendricks.origin, level.civilian_rescue_enemies );
	MagicBullet( level.ai_hendricks.weapon , level.ai_hendricks GetTagOrigin( "tag_flash" ) , hendricks_target GetTagOrigin( "j_head" ) , level.ai_hendricks , hendricks_target );
	MagicBullet( level.ai_hendricks.weapon , level.ai_hendricks GetTagOrigin( "tag_flash" ) , hendricks_target GetTagOrigin( "j_head" ) , level.ai_hendricks , hendricks_target );
	level.ai_hendricks ai::set_ignoreall( false );
	level.ai_hendricks ai::set_ignoreme( false );
	if( IsDefined( hendricks_target) && isAlive( hendricks_target ) )
	{
		level.ai_hendricks thread ai::shoot_at_target( "kill_within_time" , hendricks_target , "j_head" , 0.1 ); //make hendricks shoot each ai until they're all dead
		
		wait( 3 );
	}

	foreach ( enemy in level.civilian_rescue_enemies )
	{
		if ( isAlive( enemy ) )
		{
			MagicBullet( level.ai_hendricks.weapon , level.ai_hendricks GetTagOrigin( "tag_flash" ) , enemy GetTagOrigin( "j_head" ) , level.ai_hendricks , enemy );
			
			level.ai_hendricks thread ai::shoot_at_target( "kill_within_time" , enemy , "j_head" , 0.1 ); //make hendricks shoot each ai until they're all dead
		
			enemy waittill( "death" );
		}
	}
	
	level flag::wait_till( "civilian_rescue_enemies_dead" );
	level.ai_hendricks ai::set_ignoreall( true );
	level.ai_hendricks ai::set_ignoreme( true );
	//objectives::complete( "obj_civilian_rescue" );
	objectives::complete( "cp_level_vengeance_civilian_rescue" );
}


function civilian_rescue_scene_setup()
{
	level.civilian_rescue_enemies = [];
	civilian_rescue_ai_spawners = getentarray( "civilian_rescue_ai", "script_noteworthy" );
    foreach ( spawner in civilian_rescue_ai_spawners )
    {
		spawner spawner::add_spawn_function( &civilian_rescue_ai_setup );
		
		if( spawner.targetname != "civilian_rescue_civilian" )
		{
			spawner spawner::add_spawn_function( &civilian_rescue_enemies_watch_for_death );
    		spawner spawner::add_spawn_function( &civilian_rescue_enemies_watch_for_alert );
    		spawner spawner::add_spawn_function( &civilian_rescue_enemies_alerted );
		}
		else
		{
			spawner spawner::add_spawn_function( &setup_civilian_rescue_civilian );
		}
		spawner spawner::spawn();
    }
}

function civilian_rescue_ai_setup()
{
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self.allowdeath = true;
	
	if( IsDefined( self.targetname ) )
	{
		if( self.targetname == "civilian_rescue_civilian_ai" )
	   {
	   		level.civilian_rescue_civilian = self;
	   }
	   if ( self.targetname == "badguy1_ai" )
	   {
			level.civilian_rescue_badguy1 = self;
			array::add( level.civilian_rescue_enemies, self );
	   }   
	   if ( self.targetname == "badguy2_ai" )
	   {
			level.civilian_rescue_badguy2 = self;
			array::add( level.civilian_rescue_enemies, self );
	   }
	   if ( self.targetname == "badguy3_ai" )
	   {
			level.civilian_rescue_badguy3 = self;
			array::add( level.civilian_rescue_enemies, self );
	   }
	   if ( self.targetname == "badguy4_ai" )
	   {
			level.civilian_rescue_badguy4 = self;
			array::add( level.civilian_rescue_enemies, self );
	   }
	   if ( self.targetname == "badguy5_ai" )
	   {
			level.civilian_rescue_badguy5 = self;
			array::add( level.civilian_rescue_enemies, self );
	   }
	}
}

function civilian_rescue_enemies_watch_for_death()
{
	self waittill( "death" );
	
	level.civilian_rescue_enemies = array::remove_dead( level.civilian_rescue_enemies );
	if( level.civilian_rescue_enemies.size == 0 )
	{
		level flag::set( "civilian_rescue_enemies_dead" );
	}
}

function civilian_rescue_enemies_watch_for_alert()
{
	self endon( "death" );
	level endon( "civilian_rescue_on_three" );
	
	str_notify = self util::waittill_any_return( "bulletwhizby" , "damage" , "under_attack" , "death" );
	
	if( !level flag::get( "civilian_rescue_enemies_alerted" ) )
	{
		level flag::set( "civilian_rescue_enemies_alerted" );
	}
}

function civilian_rescue_enemies_alerted()
{
	self endon( "death" );
	
	level flag::wait_till_any( array( "civilian_rescue_enemies_alerted", "civilian_rescue_on_three" ) );

	self ai::set_ignoreall( false );
	self ai::set_ignoreme( false );
}

function setup_civilian_rescue_civilian()
{
	self endon( "death" );
	
	self.team = "allies";
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	self.goalradius = 32;

	self thread civilian_rescue_civilian_watcher();
	
	self waittill( "rescued" );
	self stopanimscripted();
	
	node = GetNode( "civilian_rescue_civilian_door_node", "targetname" );
	self setgoalnode( node );
	self waittill( "goal" );
	
	//level thread door_open( undefined, undefined, "apartment_building2_courtyard_doors" );
	//wait( .5 );
	
	node = GetNode( "civilian_rescue_civilian_delete_node", "targetname" );
	self setgoalnode( node );
	self waittill( "goal" );
	self Delete();
}

function civilian_rescue_civilian_watcher()
{
	self endon( "death" );
	
	level flag::wait_till( "civilian_rescue_enemies_dead" );
	
	self notify( "rescued" );
}

function civilian_rescue_scene()
{
	level flag::wait_till( "hendricks_enters_apartment_building1_bedroom" );
	wait( 0.25 );
	anim_struct = struct::get( "civilian_rescue_anim_struct", "targetname" );

	level thread civilian_rescue_scene_play( anim_struct );
	
	level flag::wait_till_any( array( "civilian_rescue_enemies_alerted", "civilian_rescue_on_three" ) );
	
	if( level flag::get( "civilian_rescue_enemies_alerted" ) )
	{
		level.ai_hendricks stopanimscripted();
	}

	level flag::wait_till( "civilian_rescue_enemies_dead" );
	
	wait( 1 );

	level flag::set( "hendricks_civilian_rescue_scene_complete" );
	
	trig = getent( "clothesline_gather_trigger", "targetname" );
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;
	//gather_struct = GetEnt( "clothesline_gather_struct", "targetname" );
	objectives::set( "cp_level_vengeance_gather_clothesline", trig.objective_target );
	
	trigger::use( "start_clotheslines_hendricks_movement_trigger", "targetname", level.ai_hendricks );
	level.ai_hendricks waittill( "goal" );
	
	if( !level flag::get( "player_ready_for_apartment_building2_exit" ) )
		level flag::wait_till( "player_ready_for_apartment_building2_exit" );
	
	objectives::complete( "cp_level_vengeance_gather_clothesline", trig.objective_target );
	
	level flag::set( "civilian_rescue_complete" );
}

function civilian_rescue_scene_play( anim_struct, anim_array )
{
	level endon( "civilian_rescue_enemies_alerted" );
	
	anim_struct thread scene::init( "cin_ven_civtorture_enter_vign" );
	
	wait( 1 );
	
	//"Hendricks: Hold your fire, get in position and let’s take them out together."
	level.ai_hendricks dialog::say( "hend_hold_your_fire_get_0" );
	
	wait( 1 );

	if( IsDefined( level.players ) && level.players.size > 1 )
	{
		level.ai_hendricks dialog::say( "I've got the one on the far left.", 0 );
	}
	else
	{
		level.ai_hendricks dialog::say( "I've got the one on the left.", 0 );
	}
	
//	wait( 1 );
	
	//"Hendricks: Sync your shot on three…  1, 2, 3."
	level.ai_hendricks dialog::say( "hend_sync_your_shot_on_th_0" );
	level flag::set( "civilian_rescue_on_three" );
	
	anim_struct waittill( "scene_done" );
}

function skipto_civilian_rescue_done( str_objective, b_starting, b_direct, player )
{
}

/*****************************************
 * -- Clotheslines --
 * ***************************************/

function skipto_clotheslines_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		vengeance_util::skipto_baseline( str_objective, b_starting );
	
		vengeance_util::init_hero( "hendricks", str_objective );
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		level.ai_hendricks.goalradius = 32;
		
		level scene::init( "cin_ven_02_40_clotheslinehorror_3rd_main" );
		
		level flag::wait_till( "all_players_spawned" );
		wait( 0.25 );
		
		trigger::use( "start_clotheslines_hendricks_movement_trigger", "targetname", level.ai_hendricks );
		level.ai_hendricks waittill( "goal" );
	}
	
		//objectives::set( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
		//objectives::show_for_target( "obj_follow" , level.ai_hendricks );
	
	level flag::set( "clotheslines_begin" );
	
	clotheslines_main();
}

function clotheslines_main()
{
	level thread clotheslines_hendricks();

	level flag::wait_till( "hendricks_at_clotheslines_moment" );

	skipto::objective_completed( "clotheslines" );	
}

function clotheslines_hendricks()
{
	anim_struct = struct::get( "clotheslines_anim_struct", "targetname" );
	anim_struct thread scene::play( "cin_ven_02_40_clotheslinehorror_3rd_main" );
	
	wait( 2 );
	
//	level thread door_open( undefined, "apartment_building2_exit_doors_open", "apartment_building2_exit_doors" );
	
	wait( 20 );
	
	//"Hendricks: My god... help me get them down."
	level.ai_hendricks dialog::say( "hend_my_god_help_me_get_0" );
	
	foreach( e_player in level.players )
	{
		e_player SetLowReady( true );
	}
	
	anim_struct waittill( "scene_done" );
	
	level.ai_hendricks setgoalpos( level.ai_hendricks.origin, true);
	
	level flag::set( "hendricks_at_clotheslines_moment" );
}

function skipto_clotheslines_done( str_objective, b_starting, b_direct, player )
{
}

/*****************************************
 * -- Takedown --
 * ***************************************/

function skipto_takedown_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		vengeance_util::skipto_baseline( str_objective, b_starting );
	
		vengeance_util::init_hero( "hendricks", str_objective );
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		level.ai_hendricks.goalradius = 32;
		
		//objectives::set( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
		//objectives::set( "obj_follow" , level.ai_hendricks );
		
		level flag::wait_till( "all_players_spawned" );
		wait( 0.25 );
		
		foreach( e_player in level.players )
		{
			e_player SetLowReady( true );
		}
	}

	level flag::set( "takedown_begin" );
	
	takedown_main();	
}

function takedown_main()
{	
	level thread takedown_use_triggers_setup();
	level thread takedown_scene();
	
	level flag::wait_till( "takedown_complete" );
	
	takedown_rooftop_clip = GetEnt( "takedown_rooftop_clip", "targetname" );
	takedown_rooftop_clip connectpaths();
	wait( 0.1 );
	takedown_rooftop_clip Delete();
	
/*
	trig = getent( "obj_takedown_complete", "targetname" );
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;

	//TEMP
	objectives::set( "cp_standard_breadcrumb", trig.objective_target );
	
	trigger::wait_till( "obj_takedown_complete", "targetname" );
	
	//TEMP
	if ( isdefined( trig ) )
	{
		objectives::complete( "cp_standard_breadcrumb", trig.objective_target );
	}
*/
	skipto::objective_completed( "takedown" );
	//objectives::complete( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
}

function hendricks_takedown_vo()
{
	wait( 4 );
	//"Hendricks: Over here!  54i. We’re stopping these bastards, spread out."
	level.ai_hendricks dialog::say( "hend_over_here_54i_we_0" );	
	
	wait( 2 );
	//"Hendricks: Get in position, quick."	
	level.ai_hendricks dialog::say( "hend_get_in_position_qui_0" );
}

function takedown_scene()
{
	takedown_scene_setup();
	
	thread hendricks_takedown_vo();
	
	level scene::play( "cin_ven_03_10_takedown_intro_1st" );
	
	level flag::set( "takedown_moment_get_in_place" );
	//objectives::complete( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
	//objectives::set( "obj_takedown" );
	objectives::set( "cp_level_vengeance_takedown" );
	
	level thread scene::play( "cin_ven_03_10_takedown_loop_1st" );
	level thread scene::play( "cin_ven_03_10_takedown_hookup_hdrix_1st" );
/*	
	//"Hendricks: Over here!  54i. We’re stopping these bastards, spread out."
	level.ai_hendricks dialog::say( "hend_over_here_54i_we_0" );	
	
	//"Hendricks: Get in position, quick."	
	level.ai_hendricks dialog::say( "hend_get_in_position_qui_0" );
	
	level flag::set( "takedown_moment_get_in_place" );
	objectives::complete( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
	objectives::set( "obj_takedown" );
*/
	level flag::wait_till( "all_players_ready_for_takedown" );
	//objectives::complete( "obj_takedown" );
	objectives::complete( "cp_level_vengeance_takedown" );
	level scene::stop( "cin_ven_03_10_takedown_loop_1st" );
	level thread scene::play( "cin_ven_03_10_takedown_npc_1st" );
	
	foreach ( enemy in level.takedown_enemies )
	{
		if ( isAlive( enemy ) )
			enemy setgoalpos( enemy.origin, true);
	}
	
	level.ai_hendricks waittill( "start_slowmo" );
	SetSlowMotion( 1.0, 0.3, 0.3 );
	level.ai_hendricks waittill( "stop_slowmo" );
	
	if( level.players.size == 1 )
	{
		if( IsDefined( level.takedown_rbot2 ) && IsAlive( level.takedown_rbot2 ) )
		{
			MagicBullet( level.ai_hendricks.weapon , level.ai_hendricks GetTagOrigin( "tag_flash" ) , level.takedown_rbot2 GetTagOrigin( "j_head" ) , level.ai_hendricks , level.takedown_rbot2 );	
			if( IsAlive( level.takedown_rbot2 ) )
				level.takedown_rbot2 kill();
		}
	}
	
	
	SetSlowMotion( 0.3, 1.0 );
	
	level.ai_hendricks setgoalpos( level.ai_hendricks.origin, true );
	
	foreach ( enemy in level.takedown_enemies )
	{
		if ( isAlive( enemy ) )
		{
			enemy setgoalpos( enemy.origin, true);
			enemy ai::set_ignoreall( false );
			enemy ai::set_ignoreme( false );
		}
	}
	
	wait( 1 );
	
	level.takedown_enemies = array::remove_dead( level.takedown_enemies );
	if( level.takedown_enemies.size > 0 )
	{		
		foreach ( enemy in level.takedown_enemies )
		{
			if ( isAlive( enemy ) )
			{
				MagicBullet( level.ai_hendricks.weapon , level.ai_hendricks GetTagOrigin( "tag_flash" ) , enemy GetTagOrigin( "j_head" ) , level.ai_hendricks , enemy );
				
				level.ai_hendricks thread ai::shoot_at_target( "kill_within_time" , enemy , "j_head" , 0.1 ); //make hendricks shoot each ai until they're all dead
			
				enemy waittill( "death" );
			}
		}
	}
	
	//level.ai_hendricks setgoalpos( level.ai_hendricks.origin, true );
	trigger::use( "hide_tutorial_gate_hendricks_movement_trigger", "targetname", level.ai_hendricks );
//	self waittill( "goal" );
	
	wait( 1 );

	level flag::set( "takedown_complete" );	
}

function takedown_scene_setup()
{
	takedown_truck_54i = GetEnt( "truck_54i", "script_noteworthy" );
	takedown_truck_54i.animname = "truck_54i";
	takedown_truck_54i thread takedown_cleanup();
	
	takedown_siegebot = GetEnt( "takedown_siegebot", "script_noteworthy" );
	takedown_siegebot.animname = "takedown_siegebot";
	takedown_siegebot thread takedown_cleanup();
	
	level.takedown_enemies = [];
	takedown_ai_spawners = getentarray( "takedown_ai", "script_noteworthy" );
    foreach ( spawner in takedown_ai_spawners )
    {
		spawner spawner::add_spawn_function( &takedown_ai_setup );
		spawner spawner::spawn();
    }
}

function takedown_ai_setup()
{
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	if( IsDefined( self.targetname ) )
	{
	   if ( self.targetname == "takedown_enemy1_ai" )
	   {
			level.takedown_enemy1 = self;
			array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy2_ai" )
	   {
			level.takedown_enemy2 = self;
			array::add( level.takedown_enemies, self );
			
//			en2_machete = util::spawn_model( "p7_54i_gear_knife" );
//			en2_machete.animname = "en2_machete";
//			level scene::init( "cin_ven_03_10_takedown_intro_1st", en2_machete );
//			en2_machete thread takedown_cleanup();
	   }
	   if ( self.targetname == "takedown_enemy3_ai" )
	   {
			level.takedown_enemy3 = self;
			array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy4_ai" )
	   {
			level.takedown_enemy4 = self;
			array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy5_ai" )
	   {
			level.takedown_enemy5 = self;
			array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy6_ai" )
	   {
			level.takedown_enemy6 = self;
			array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy7_ai" )
	   {
			level.takedown_enemy7 = self;
			array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy8_ai" )
	   {
	   		level.takedown_enemy8 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy9_ai" )
	   {
	   		level.takedown_enemy9 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy10_ai" )
	   {
	   		level.takedown_enemy10 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy11_ai" )
	   {
	   		level.takedown_enemy11 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy12_ai" )
	   {
	   		level.takedown_enemy12 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_enemy13_ai" )
	   {
	   		level.takedown_enemy13 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_rbot1_ai" )
	   {
	   		level.takedown_rbot1 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	   if ( self.targetname == "takedown_rbot2_ai" )
	   {
	   		level.takedown_rbot2 = self;
	   		array::add( level.takedown_enemies, self );
	   }
	}	
}

function takedown_use_triggers_setup()
{
	level flag::wait_till( "takedown_moment_get_in_place" );
	level.takedown_player_counter = 0;
	level.one_player_has_hooked_up = undefined;
	level.takedown_use_triggers = GetEntArray( "takedown_use_trigger", "targetname" );
	array::thread_all( level.takedown_use_triggers, &activate_multiple_player_waypoints, "cp_standard_breadcrumb" );
	array::thread_all( level.takedown_use_triggers, &takedown_use_trigger_wait );
	level thread takedown_hookup_timer();
}

function takedown_use_trigger_wait()
{
	self endon( "death" );

	self SetHintString( &"CP_MI_SING_VENGEANCE_TAKEDOWN_OBJ_TRIGGER" );
	target = struct::get( self.target, "targetname" );
	player_link_spot = util::spawn_model( "tag_origin", target.origin, target.angles );
	
	self trigger::wait_till();
	
	self.who.used_takedown_trigger = true;
	self.takedown_trigger_used = true;
	
	if( !IsDefined( level.one_player_has_hooked_up ) )
		level.one_player_has_hooked_up = true;
	
	self MakeUnusable();
	
	if( IsDefined( self.objective_target ) )
	{
		objectives::complete( "cp_standard_breadcrumb", self.objective_target );  
	}

	if( IsDefined( self.script_parameters ) )
	{
 		if( self.script_parameters == "1" )
		{
 			hookup_scene = "cin_ven_03_10_takedown_hookup_player1_1st";
 			hookup_loop_scene = "cin_ven_03_10_takedown_hookup_loop_player1_1st";
			takedown_scene = "cin_ven_03_10_takedown_player1_1st";
		}
		else if ( self.script_parameters == "2" )
		{
			hookup_scene = "cin_ven_03_10_takedown_hookup_player2_1st";
			hookup_loop_scene = "cin_ven_03_10_takedown_hookup_loop_player2_1st";
			takedown_scene = "cin_ven_03_10_takedown_player2_1st";
		}
		else if( self.script_parameters == "3" )
		{
			hookup_scene = "cin_ven_03_10_takedown_hookup_player3_1st";
			hookup_loop_scene = "cin_ven_03_10_takedown_hookup_loop_player3_1st";
			takedown_scene = "cin_ven_03_10_takedown_player3_1st";
		}
		else if( self.script_parameters == "4" )
		{
			hookup_scene = "cin_ven_03_10_takedown_hookup_player4_1st";
			hookup_loop_scene = "cin_ven_03_10_takedown_hookup_loop_player4_1st";
			takedown_scene = "cin_ven_03_10_takedown_player4_1st";
		}
	}
 
	if( IsDefined( hookup_scene ) )
	{
		level scene::play( hookup_scene, self.who );
	}

	if( IsDefined( level.takedown_player_counter ) )
	{
	   	level.takedown_player_counter ++;
	   	
	   	if( level.takedown_player_counter >= level.players.size )
	   	{
	   		level flag::set( "all_players_ready_for_takedown" );
	   	}
	}	
		
	if( !level flag::get( "all_players_ready_for_takedown" ) )
	{
		if( IsDefined( hookup_loop_scene ) )
		{
			level thread scene::play( hookup_loop_scene, self.who );
		}

		level flag::wait_till( "all_players_ready_for_takedown" );
	}

	foreach( e_player in level.players )
	{
		e_player SetLowReady( false );
	}
	
	if( IsDefined( hookup_loop_scene ) )
	{
		if( ( level scene::is_playing( hookup_loop_scene ) ) )
			level scene::stop( hookup_loop_scene );
	}
	
	if( IsDefined( takedown_scene ) )
	{
		level scene::play( takedown_scene, self.who );
	}	
}

function takedown_hookup_timer()
{
	level endon( "all_players_ready_for_takedown" );
	
	while( !IsDefined( level.one_player_has_hooked_up ) )
	{
		wait( 0.05 );
	}
	
	wait( 15 );
	
	players_not_hookedup = [];
	foreach( e_player in level.players )
	{
		if( !IsDefined( e_player.used_takedown_trigger ) )
		{
			array::add( players_not_hookedup, e_player );
		}
	}
	
	triggers_not_used = [];
	foreach( trigger in level.takedown_use_triggers )
	{
		if( !IsDefined( trigger.takedown_trigger_used ) )
		{
			if( trigger.script_parameters == "1" )
			{
				array::add( triggers_not_used, trigger );
			}
			if( level.players.size >= 2 && trigger.script_parameters == "2" )
			{		
				array::add( triggers_not_used, trigger );
			}
			if( level.players.size >= 3 && trigger.script_parameters == "3" )
			{		
				array::add( triggers_not_used, trigger );
			}
			if( level.players.size >= 4 && trigger.script_parameters == "4" )
			{		
				array::add( triggers_not_used, trigger );
			}
		}
	}
	
	for( i = 0; i < players_not_hookedup.size; i++ )
	{
		triggers_not_used[i] notify( "trigger", players_not_hookedup[i] );
	}	
}

function takedown_cleanup()
{
	level flag::wait_till( "start_dogleg_1_intro" );

	wait( 1 );
	
	if( IsDefined ( self ) )
		self Delete();	
}

function skipto_takedown_done( str_objective, b_starting, b_direct, player )
{
}

/*****************************************
 * -- Functions used in multiple checkpoints --
 * ***************************************/

function door_open( wait_flag, set_flag, door_array_targetname  )
{
	if( IsDefined( wait_flag ) )
	{
		level flag::wait_till( wait_flag );
		level.ai_hendricks waittill( "goal" );
	}
	
	door_array = GetEntArray( door_array_targetname, "targetname" );

	foreach( door in door_array )
	{
		if( IsDefined(door.script_noteworthy) && door.script_noteworthy == "left" )
		{
			clip = GetEnt( door_array_targetname + "_left_clip", "targetname" );
			if( IsDefined( clip ) )
			{
				clip Linkto( door, "tag_origin" );
			}
			
			door rotateyaw( 90, 1 );
			door connectpaths();
				
		}
		else if( IsDefined (door.script_noteworthy ) && door.script_noteworthy == "right" )
		{
			clip = GetEnt( door_array_targetname + "_right_clip", "targetname" );
			if( IsDefined( clip ) )
			{
				clip Linkto( door, "tag_origin" );
			}
			
			door rotateyaw( -90, 1 );
			door connectpaths();
		}
	}
	
	wait( 1 );
	if( IsDefined( set_flag ) )
		level flag::set( set_flag );	
}

function activate_multiple_player_waypoints( objective_id )//self is trigger
{
	if( IsDefined( self.script_parameters ) )
	{
		self MakeUnusable();
		
		if( self.script_parameters == "1" )
		{
			self thread activate_multiple_player_waypoints_internal( objective_id );
		}
		if( level.players.size >= 2 && self.script_parameters == "2" )
		{		
			self thread activate_multiple_player_waypoints_internal( objective_id );
		}
		if( level.players.size >= 3 && self.script_parameters == "3" )
		{		
			self thread activate_multiple_player_waypoints_internal( objective_id );
		}
		if( level.players.size >= 4 && self.script_parameters == "4" )
		{		
			self thread activate_multiple_player_waypoints_internal( objective_id );
		}
	}
}

function activate_multiple_player_waypoints_internal( objective_id )//self is trigger
{
	self.objective_target = SpawnStruct();
	self.objective_target.origin = self.origin;
	objectives::set( objective_id, self.objective_target );
	
	self MakeUsable();
}

/*****************************************
 * -- Streets --
 * ***************************************/
/*
function skipto_streets_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		vengeance_util::skipto_baseline( str_objective, b_starting );
	
		vengeance_util::init_hero( "hendricks", str_objective );
		level.ai_hendricks ai::set_ignoreall( true );
		level.ai_hendricks ai::set_ignoreme( true );
		
//		objectives::set( "cp_standard_follow_breadcrumb" , level.ai_hendricks );
	}
	
	level flag::set( "streets_begin" );
	
	trig = getent( "obj_streets_complete", "targetname" );
	trig.objective_target = SpawnStruct();
	trig.objective_target.origin = trig.origin;
	
	//TEMP
	objectives::set( "cp_standard_breadcrumb", trig.objective_target );
	
	trigger::wait_till( "obj_streets_complete", "targetname" );
	
	//TEMP
	if ( isdefined( trig ) )
	{
		objectives::complete( "cp_standard_breadcrumb", trig.objective_target );
	}
	
	skipto::objective_completed( "streets" );
	skipto::teleport( "temple", undefined, undefined );
}
*/
/*
function skipto_streets_done( str_objective, b_starting, b_direct, player )
{	
//	trig = level.skipto_triggers[ str_objective ];
//	if ( isdefined( trig ) )
//	{
/		objectives::complete( "cp_level_vengeance_temp", trig.objective_target );
//		skipto::teleport( "temple", undefined, undefined );
//	}
}
*/
function skipto_intro_arena_init( str_objective, b_starting )
{	
	vengeance_util::skipto_baseline( str_objective, b_starting );

	if ( b_starting )
	{
		intro_arena_main();
	}		
}

function skipto_intro_arena_done( str_objective, b_starting, b_direct, player )
{
	//s_obj = struct::Get( "bldg_objective", "targetname" );
	//objectives::complete( "cp_jzuk_temp", s_obj );
}

function intro_arena_main()
{
	//setup patrollers
    intro_arena_spawners = getentarray( "intro_arena_spawners", "targetname" );
    foreach ( spawner in intro_arena_spawners )
    {
    	spawner spawner::add_spawn_function( &vengeance_util::setup_patroller );
    }
    
    level.intro_arena_spawners = spawner::simple_spawn( "intro_arena_spawners" );
	
	level thread vengeance_util::spawn_police( "intro_arena_police_spawner" );
}