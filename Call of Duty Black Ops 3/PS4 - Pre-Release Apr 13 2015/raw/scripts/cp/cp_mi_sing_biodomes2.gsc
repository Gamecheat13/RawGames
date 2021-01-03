#using scripts\codescripts\struct;

#using scripts\cp\gametypes\_save;

#using scripts\shared\ai_shared;
#using scripts\shared\animation_shared;
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
#using scripts\shared\lui_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scene_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\teamgather_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_util;
#using scripts\cp\_ammo_cache;
#using scripts\cp\_objectives;

#using scripts\cp\cp_mi_sing_biodomes2_fx;
#using scripts\cp\cp_mi_sing_biodomes2_sound;

#using scripts\cp\cp_mi_sing_biodomes_util;
#using scripts\cp\cp_mi_sing_biodomes_swamp;
#using scripts\cp\cp_mi_sing_biodomes_supertrees;




#precache( "triggerstring", "CP_MI_SING_BIODOMES_AIRBOAT" );
#precache( "triggerstring", "CP_MI_SING_BIODOMES_AIRBOAT_EXIT" );

#precache( "fx", "blood/fx_blood_ai_head_explosion" );
#precache( "fx", "blood/fx_blood_impact_biodomes" );
#precache( "fx", "blood/fx_blood_unstab_biodomes" );
#precache( "fx", "blood/fx_blood_impact_slowmo_bullet_biodomes" );
#precache( "fx", "explosions/fx_exp_core_lg_bm" );
#precache( "fx", "explosions/fx_exp_dome_biodomes" );
#precache( "fx", "explosions/fx_exp_elvsft_biodome" );
#precache( "fx", "destruct/fx_dest_ceiling_collapse_biodomes" );
#precache( "fx", "weapon/fx_trail_bullet_biodomes" );
#precache( "fx", "weapon/fx_muz_flash_int" );
#precache( "fx", "impacts/fx_object_dirt_impact_md" );
#precache( "fx", "electric/fx_elec_sparks_boat_scrape_biodomes" );
#precache( "fx", "explosions/fx_exp_grenade_smoke" );
#precache( "fx", "explosions/fx_exp_underwater_depth_charge" );
#precache( "fx", "ui/fx_ui_flagbase_blue" );
#precache( "fx", "ui/fx_koth_marker_blue" );
#precache( "fx", "vehicle/fx_spray_fan_boat" );
#precache( "fx", "vehicle/fx_splash_front_fan_boat" );

#precache( "lui_menu", "CACWaitMenu" );

#precache( "objective", "cp_level_biodomes_repel" );
#precache( "objective", "cp_level_biodomes_exfil" );
#precache( "objective", "cp_level_biodomes_escape" );
#precache( "objective", "cp_level_biodomes_supertrees_waypoint" );
#precache( "objective", "cp_level_biodomes_extract" );
#precache( "objective", "cp_level_biodomes_jump_from_supertree" );

#precache( "material", "t7_hud_prompt_hack_64" );
#precache( "material", "t7_hud_prompt_push_64" );
#precache( "material", "t7_hud_prompt_resource_64" );
#precache( "material", "t7_hud_prompt_pickup_64" );

function main()
{
	savegame::set_mission_name( "biodomes" );
	
	precache();
	clientfields_init();
	flag_init();
	level_init();
	
	cp_mi_sing_biodomes2_fx::main();
	cp_mi_sing_biodomes2_sound::main();
	cp_mi_sing_biodomes_supertrees::main();
	cp_mi_sing_biodomes_swamp::main();

	setup_skiptos();
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	spawner::add_global_spawn_function( "axis", &on_actor_spawned );
	
	load::main();
	
	clientfield::set( "supertree_fall_init", 1 );
}

function precache()
{
	// DO ALL PRECACHING HERE
	level._effect[ "blood_headpop" ] = "blood/fx_blood_ai_head_explosion";
	level._effect[ "blood_bullettime" ] = "blood/fx_blood_impact_slowmo_bullet_biodomes";
	level._effect[ "blood_stab" ] = "blood/fx_blood_impact_biodomes";
	level._effect[ "blood_unstab" ] = "blood/fx_blood_unstab_biodomes";
	level._effect[ "explosion_lg" ] = "explosions/fx_exp_core_lg_bm";
	level._effect[ "explosion_dome" ] = "explosions/fx_exp_dome_biodomes";
	level._effect[ "explosion_zipline_up" ] = "explosions/fx_exp_elvsft_biodome";
	level._effect[ "ceiling_collapse" ] = "destruct/fx_dest_ceiling_collapse_biodomes";
	level._effect[ "bullet_trail" ] = "weapon/fx_trail_bullet_biodomes";
	level._effect[ "muzzle_flash" ] = "weapon/fx_muz_flash_int";
	level._effect[ "dirt_impact" ] = "impacts/fx_object_dirt_impact_md";
	level._effect[ "boat_sparks" ] = "electric/fx_elec_sparks_boat_scrape_biodomes";
	level._effect[ "smoke_grenade" ] = "explosions/fx_exp_grenade_smoke";
	level._effect[ "depth_charge" ] = "explosions/fx_exp_underwater_depth_charge";
	level._effect[ "squad_waypoint_base" ] = "ui/fx_ui_flagbase_blue";
	level._effect[ "squad_waypoint_marker" ] = "ui/fx_koth_marker_blue";
	level._effect[ "boat_trail" ] = "vehicle/fx_spray_fan_boat";
	level._effect[ "boat_land_splash" ] = "vehicle/fx_splash_front_fan_boat";
}

function clientfields_init()
{
	// FX Anim bits
	clientfield::register( "world", "warehouse_window_break", 1, 1, "int" );
	clientfield::register( "world", "server_room_window_break", 1, 1, "int" );
	clientfield::register( "world", "control_room_window_break", 1, 1, "int" );
	clientfield::register( "world", "tall_grass_init", 1, 1, "int" );
	clientfield::register( "world", "tall_grass_play", 1, 1, "int" );
	clientfield::register( "toplayer", "server_extra_cam", 1, 5, "int" );
	clientfield::register( "toplayer", "server_interact_cam", 1, 3, "int" );
	clientfield::register( "world", "supertree_fall_init", 1, 1, "int" );
	clientfield::register( "world", "supertree_fall_play", 1, 1, "int" );
	clientfield::register( "world", "ferriswheel_fall_play", 1, 1, "int" );
}

function flag_init()
{
	level flag::init( "partyroom_igc_started" );
	level flag::init( "plan_b" );
	level flag::init( "dannyli_dead" );
	level flag::init( "gohbro_dead" );
	level flag::init( "bullet_start" );
	level flag::init( "bullet_over" );
	level flag::init( "markets1_enemies_alert" );
	level flag::init( "hendricks_markets2_wallrun" );
	level flag::init( "turret1" );
	level flag::init( "turret2" );
	level flag::init( "turret1_dead" );
	level flag::init( "turret2_dead" );
	level flag::init( "container_done" );
	level flag::init( "back_door_closed" );
	level flag::init( "warehouse_warlord" );
	level flag::init( "warehouse_warlord_dead" );
	level flag::init( "phalanx" );
	level flag::init( "back_door_opened" );
	level flag::init( "warehouse_done" );
	level flag::init( "warehouse_wasps" );
	level flag::init( "turret_hall_clear" );
	level flag::init( "hand_cut" );
	level flag::init( "elevator_light_on_server_room" );
	level flag::init( "elevator_light_on_cloudmountain" );
	level flag::init( "cloudmountain_left_cleared" );
	level flag::init( "cloudmountain_right_cleared" );
	level flag::init( "window_broken" );
	level flag::init( "window_hooks" );
	level flag::init( "window_gone" );
	level flag::init( "server_room_failing" );
	level flag::init( "top_floor_breached" );
	level flag::init( "hendricks_on_dome" );
	level flag::init( "hunter_missiles_go" );
	level flag::init( "hendricks_dive" );
	level flag::init( "reached_dock" );
	level flag::init( "hendricks_onboard" );
	level flag::init( "fuel_truck" );
	level flag::init( "boats_go" );
	level flag::init( "boats_departed" );
	level flag::init( "wasps_upahead" );
	level flag::init( "kill_wasps" );
	
	//supertrees flags
	level flag::init( "hendricks_played_supertree_takedown" );
	level flag::init( "hendricks_reached_finaltree" );
	level flag::init( "any_player_reached_bottom_finaltree" );
	level flag::init( "player_reached_bottom_finaltree" );
	level flag::init( "start_hendricks_dive" );
	level flag::init( "player_reached_top_finaltree" );
}

function level_init()
{
	mdl_truck_after = GetEnt( "fuel_truck_after", "targetname" );
	mdl_truck_after Hide();
	
	level.override_robot_damage = true;
	
	mdl_outpost1 = GetEnt( "clip_outpost1", "targetname" );
	mdl_outpost1 SetMovingPlatformEnabled( true );
	
	a_hide_ents = GetEntArray( "start_hidden" , "script_noteworthy" ); //using this tag to hide ents more easily
	foreach ( ent in a_hide_ents )
	{
		ent Hide();
	}
}

function level_setup()
{

}

function on_actor_spawned()  //self = ai
{
	self.b_keylined = false;
	self.b_targeted = false;
}


//============================================================

function on_player_connect()
{
	self flag::init( "player_on_boat" );
	self.b_bled_out = false;
	self thread monitor_player_bleed_out();
}

function on_player_spawned()
{	
	//at start of level, freeze player controls immediately to keep player from jumping around when sliding
	//gets reset after landing in supertrees player_slide_finished() thread
	if ( level.skipto_point === "objective_descend" )
	{
		self player_spawn_descend();
	}
	
	//make sure player is considered on tree1 at the beginning of the level
	if( level.skipto_point === "objective_descend" || level.skipto_point === "objective_supertrees" )
	{
		self.str_current_tree = "tree1";
	}
	
	self thread cp_mi_sing_biodomes_swamp::player_onto_boat_tracking();
	
	if ( level flag::get( "boats_departed" ) )
	{
		self thread cp_mi_sing_biodomes_swamp::force_player_onboard();
	}
}

//self is player
//HACK until there's a better animated version of the slide
function player_spawn_descend()
{
	self endon ( "death" );
	
	//get first struct associated with player
	s_start = struct::get( "descend_player"+self GetEntityNumber(), "targetname" );
	
	//bail out and use regular player movement to fall down the dome if start point doesn't exist
	if ( !isdefined( s_start ) )
	{
		return;
	}
	
	e_playermover = util::spawn_model( "tag_origin", s_start.origin, s_start.angles );
	self PlayerLinkToDelta( e_playermover, "tag_origin", 1, 45, 45, 45, 45 );
	
	//continue on "spline" while there's a valid target to move to
	while ( isdefined( s_start.target ) )
	{
		s_end = struct::get( s_start.target, "targetname" );

		//find out how fast to move
		n_dist = Distance( s_start.origin, s_end.origin );
		n_time = n_dist / 600;
		
		e_playermover MoveTo( s_end.origin, n_time );
		e_playermover waittill( "movedone" );
		
		s_start = s_end;
	}
	
	e_playermover Delete();
}

function monitor_player_bleed_out()  //self = player
{
	self endon( "disconnect" );
	
	self waittill( "bled_out" );
	
	self.b_bled_out = true;
}


//============================================================
// SKIP TO'S

function setup_skiptos()
{
	skipto::add( "objective_descend", &cp_mi_sing_biodomes_supertrees::objective_descend_init, undefined, &cp_mi_sing_biodomes_supertrees::objective_descend_done );
	skipto::add( "objective_supertrees", &cp_mi_sing_biodomes_supertrees::objective_supertrees_init, undefined, &cp_mi_sing_biodomes_supertrees::objective_supertrees_done );
	skipto::add_dev( "dev_supertrees_fire", &cp_mi_sing_biodomes_supertrees::dev_supertrees_fire_init );
	skipto::add( "objective_dive", &cp_mi_sing_biodomes_supertrees::objective_dive_init, undefined, &cp_mi_sing_biodomes_supertrees::objective_dive_done );
	skipto::add( "objective_swamps", &cp_mi_sing_biodomes_swamp::objective_swamps_init, undefined, &cp_mi_sing_biodomes_swamp::objective_swamps_done );
	skipto::add_dev( "dev_swamp_rail", &cp_mi_sing_biodomes_swamp::dev_swamp_rail_init );
	skipto::add_dev( "dev_swamp_rail_final_scene", &cp_mi_sing_biodomes_swamp::dev_swamp_final_scene_init );
}
