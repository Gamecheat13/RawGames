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

#using scripts\shared\ai\archetype_warlord_interface;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\_dialog;
#using scripts\cp\_load;
#using scripts\cp\_skipto;
#using scripts\cp\_spawn_manager;
#using scripts\cp\_squad_control;
#using scripts\cp\_util;
#using scripts\cp\_ammo_cache;
#using scripts\cp\_objectives;
#using scripts\cp\cybercom\_cybercom;

#using scripts\cp\cp_mi_sing_biodomes_fx;
#using scripts\cp\cp_mi_sing_biodomes_init_spawn;
#using scripts\cp\cp_mi_sing_biodomes_sound;
#using scripts\cp\cp_mi_sing_biodomes_markets;
#using scripts\cp\cp_mi_sing_biodomes_warehouse;
#using scripts\cp\cp_mi_sing_biodomes_cloudmountain;
#using scripts\cp\cp_mi_sing_biodomes_fighttothedome;
#using scripts\cp\cp_mi_sing_biodomes_util;

    	   	                                                                                                                                                                                                                                                                                                                                                                                                                                               
     
                                                                                                                                                     





#precache( "triggerstring", "CP_MI_SING_BIODOMES_AIRBOAT" );
#precache( "triggerstring", "CP_MI_SING_BIODOMES_AIRBOAT_EXIT" );

#precache( "string", "CP_MI_SING_BIODOMES_BULLET_HINT" );
#precache( "string", "CP_MI_SING_BIODOMES_PLAN_B" );
#precache( "string", "CP_MI_SING_BIODOMES_CAC_WAIT" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_INIT" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_GONE" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_DONE" );
#precache( "string", "CP_MI_SING_BIODOMES_INVALID_POS" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_REGEN" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT1_STATUS" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT2_STATUS" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT3_STATUS" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT4_STATUS" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT_STANDARD" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT_MOVE" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT_INTERACT" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT_ATTACK" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT1_DEAD" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT2_DEAD" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT3_DEAD" );
#precache( "string", "CP_MI_SING_BIODOMES_ROBOT4_DEAD" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_STATUS_LABEL" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_TARGET" );
#precache( "string", "CP_MI_SING_BIODOMES_SQUAD_MOVE" );

#precache( "fx", "impacts/fx_bul_flesh_body_fatal_exit" );
#precache( "fx", "blood/fx_blood_ai_head_explosion" );
#precache( "fx", "blood/fx_blood_impact_biodomes" );
#precache( "fx", "blood/fx_blood_unstab_biodomes" );
#precache( "fx", "blood/fx_blood_impact_slowmo_bullet_biodomes" );
#precache( "fx", "explosions/fx_exp_core_lg_bm" );
#precache( "fx", "explosions/fx_exp_dome_biodomes" );
#precache( "fx", "destruct/fx_dest_ceiling_collapse_biodomes" );
#precache( "fx", "weapon/fx_trail_bullet_biodomes" );
#precache( "fx", "weapon/fx_muz_flash_int" );
#precache( "fx", "impacts/fx_object_dirt_impact_md" );
#precache( "fx", "electric/fx_elec_sparks_boat_scrape_biodomes" );
#precache( "fx", "explosions/fx_exp_grenade_smoke" );
#precache( "fx", "explosions/fx_exp_underwater_depth_charge" );
#precache( "fx", "ui/fx_ui_flagbase_blue" );
#precache( "fx", "ui/fx_koth_marker_blue" );

#precache( "lui_menu", "CACWaitMenu" );
#precache( "lui_menu", "BulletTimeReticule" );
#precache( "lui_menu", "SquadStartMenu" );
#precache( "lui_menu", "SquadControlReticuleMenu" );
#precache( "lui_menu", "SquadMenu" );
#precache( "lui_menu", "SquadMenu_2" );
#precache( "lui_menu", "SquadGoneMenu" );
#precache( "lui_menu", "SquadInvalidPosMenu" );
#precache( "lui_menu", "SquadRegenMenu" );
#precache( "lui_menu_data", "squad_regen_text" );
#precache( "lui_menu_data", "squad_gone_text" );
#precache( "lui_menu_data", "squad_label_text" );
#precache( "lui_menu_data", "robot_one_text" );
#precache( "lui_menu_data", "robot_two_text" );
#precache( "lui_menu_data", "robot_three_text" );
#precache( "lui_menu_data", "robot_four_text" );
#precache( "lui_menu_data", "robot1_index" );
#precache( "lui_menu_data", "robot1_health" );
#precache( "lui_menu_data", "robot1_action" );
#precache( "lui_menu_data", "robot2_index" );
#precache( "lui_menu_data", "robot2_health" );
#precache( "lui_menu_data", "robot2_action" );
#precache( "lui_menu_data", "robot3_index" );
#precache( "lui_menu_data", "robot3_health" );
#precache( "lui_menu_data", "robot3_action" );
#precache( "lui_menu_data", "robot4_index" );
#precache( "lui_menu_data", "robot4_health" );
#precache( "lui_menu_data", "robot4_action" );
#precache( "string", "SquadStartFadeIn" );
#precache( "string", "RobotOneDead" );
#precache( "string", "RobotTwoDead" );
#precache( "string", "RobotThreeDead" );
#precache( "string", "RobotFourDead" );

#precache( "objective", "cp_level_biodomes_cloud_mountain" );
#precache( "objective", "cp_level_biodomes_cloud_mountain_waypoint" );
#precache( "objective", "cp_level_biodomes_servers" );
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
	
	cp_mi_sing_biodomes_fx::main();
	cp_mi_sing_biodomes_sound::main();
	cp_mi_sing_biodomes_markets::main();
	cp_mi_sing_biodomes_fighttothedome::main();

	setup_skiptos();
	
	callback::on_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	spawner::add_global_spawn_function( "axis", &on_actor_spawned );
	
	load::main();
	
	skipto::set_skip_safehouse();
	
	clientfield::set( "supertree_fall_init", 1 );
}

function precache()
{
	// DO ALL PRECACHING HERE
	level._effect[ "blood_headpop" ] = "blood/fx_blood_ai_head_explosion";
	level._effect[ "blood_bullettime" ] = "impacts/fx_bul_flesh_body_fatal_exit";
	level._effect[ "blood_stab" ] = "blood/fx_blood_impact_biodomes";
	level._effect[ "blood_unstab" ] = "blood/fx_blood_unstab_biodomes";
	level._effect[ "explosion_lg" ] = "explosions/fx_exp_core_lg_bm";
	level._effect[ "explosion_dome" ] = "explosions/fx_exp_dome_biodomes";
	level._effect[ "ceiling_collapse" ] = "destruct/fx_dest_ceiling_collapse_biodomes";
	level._effect[ "bullet_trail" ] = "weapon/fx_trail_bullet_biodomes";
	level._effect[ "muzzle_flash" ] = "weapon/fx_muz_flash_int";
	level._effect[ "dirt_impact" ] = "impacts/fx_object_dirt_impact_md";
	level._effect[ "boat_sparks" ] = "electric/fx_elec_sparks_boat_scrape_biodomes";
	level._effect[ "smoke_grenade" ] = "explosions/fx_exp_grenade_smoke";
	level._effect[ "depth_charge" ] = "explosions/fx_exp_underwater_depth_charge";
	level._effect[ "squad_waypoint_base" ] = "ui/fx_ui_flagbase_blue";
	level._effect[ "squad_waypoint_marker" ] = "ui/fx_koth_marker_blue";
}

function clientfields_init()
{
	clientfield::register( "toplayer", "player_bullet_camera", 1, 2, "int" );
	clientfield::register( "toplayer", "player_waterfall_pstfx", 1, 1, "int" );
	clientfield::register( "toplayer", "bullet_disconnect_pstfx", 1, 1, "int" );
	
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
	level flag::init( "hendricks_markets2_arch_throw" );
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
	level flag::init( "hendricks_reached_finaltree" );
	level flag::init( "player_reached_bottom_finaltree" );
	level flag::init( "start_hendricks_dive" );
	level flag::init( "player_reached_top_finaltree" );
}

function level_init()
{
	level.mdl_warehouse_keyline = GetEnt( "warehouse_keyline", "targetname" );
	level.mdl_warehouse_keyline Hide();
	
	level.override_robot_damage = true;
	
	GetEnt( "back_door_look_trigger" , "script_noteworthy" ) TriggerEnable( false ); //this is re-enabled in the warehouse once the AI at the back door are spawned
	
	SetEnableNode( GetNode( "forklift_traverse_start" , "targetname" ) , false );
	SetEnableNode( GetNode( "forklift_traverse_end" , "targetname" ) , false );
	
	a_hide_ents = GetEntArray( "start_hidden" , "script_noteworthy" ); //using this tag to hide ents more easily
	foreach ( ent in a_hide_ents )
	{
		ent Hide();
	}
	
	a_destroyed_props = GetEntArray( "partyroom_destroyed" , "targetname" );
	foreach ( prop in a_destroyed_props )
	{
		prop Hide(); //hide all the destroyed state stuff in the party room until after IGC
	}
	
	a_trig_waterfalls = GetEntArray( "waterfall_triggers", "script_noteworthy" );
	array::thread_all( a_trig_waterfalls, &trig_waterfall_func );
	
	level thread add_open_door_action();
	level thread add_turret1_action();
	level thread add_turret2_action();
}

function level_setup()
{
	level thread cp_mi_sing_biodomes_util::group_triggers_enable( "igc_trigger_disable_group", false );
	level thread cp_mi_sing_biodomes_util::group_triggers_enable( "trigger_color_market", false );
	level thread cp_mi_sing_biodomes_util::group_triggers_enable( "hendricks_markets1_scene_triggers", false );
	
	level waittill( "player_regain_control" );
	
	level thread cp_mi_sing_biodomes_markets::spawn_markets1_enemies();

	level thread cp_mi_sing_biodomes_util::group_triggers_enable( "igc_trigger_disable_group", true );
	level thread cp_mi_sing_biodomes_util::group_triggers_enable( "trigger_color_market", true );
	level thread cp_mi_sing_biodomes_util::group_triggers_enable( "hendricks_markets1_scene_triggers", true );
		
	//will have looping intro animation at beginning of this area; play scene/trigger linked in radiant
	level thread scene::init( "cin_bio_03_01_market_vign_engage" );
}



function on_actor_spawned()  //self = ai
{
	self.b_keylined = false;
	self.b_targeted = false;
}


//============================================================

function on_player_connect()
{
	self.b_bled_out = false;
	
	self thread monitor_player_bleed_out();
	
	self flag::init( "player_bullet_over" );
}

function on_player_spawned()
{		
	if ( !GetDvarInt( "art_review", 0 ) )
	{
		if ( level.skipto_point == "objective_igc" || level.skipto_point == "dev_bullet_scene" )
		{			
			//if we've already started the bullet scene, go ahead and set it as true
			if ( level flag::get( "bullet_start" ) )
			{
				self flag::set( "player_bullet_over" );
			}
		}
		else if ( level.skipto_point == "objective_markets_start" || level.skipto_point == "objective_markets_rpg" || level.skipto_point == "objective_markets2_start" )
		{
			if ( !self.b_bled_out )
			{
				self init_squad_robots( level.skipto_point );
				
				//restart color triggers that robots use
				self thread squad_color_triggers();
				self thread squad_color_markets_start();
				self thread squad_color_markets_rpg();
				self thread squad_color_markets2();
			}
			
			self thread squad_hud();
		}
		else if ( level.skipto_point == "objective_warehouse" || level.skipto_point == "objective_cloudmountain" )
		{
			if ( !self.b_bled_out )
			{
				self init_squad_robots( level.skipto_point );
			}
			
			self thread squad_hud();
			
			level flag::set( "turret2_dead" );
		}
	}
}

function monitor_player_bleed_out()  //self = player
{
	self endon( "disconnect" );
	
	self waittill( "bled_out" );
	
	self.b_bled_out = true;
}

function init_squad_robots( str_objective, n_squad )  //self = player
{
	self.a_robots = [];

	//adjust health and squad size based on number of co-op players
	if ( !isdefined( n_squad ) )
	{
		switch( level.players.size )
		{
			case 1:
				n_robot_health_scalar = 4;
				n_squad = 4;
				break;
			case 2:
				n_robot_health_scalar = 3;
				n_squad = 3;
				break;
			case 3:
				n_robot_health_scalar = 3;
				n_squad = 2;
				break;
			case 4:
				n_robot_health_scalar = 3;
				n_squad = 2;
				break;
			default:
				n_robot_health_scalar = 1;
				n_squad = 4;
				break;
		}
	}
	else
	{
		n_robot_health_scalar = 4;
	}
	
	for ( i = 0; i < n_squad; i++ )
	{
		self.a_robots[i] = spawner::simple_spawn_single( "friendly_robot_control" );
		self.a_robots[i].health = self.a_robots[i].health * n_robot_health_scalar;
		self.a_robots[i].start_health = self.a_robots[i].health;
	}
	
	skipto::teleport_ai( str_objective, self.a_robots );
	
	self squad_control::init_squad_control();
}

//self is a trigger that acts as the waterfall volume
function trig_waterfall_func()
{
	self endon( "death" );
	
	while( true )
	{
		self trigger::wait_till();
		self.who thread play_waterfall( self );
	}
}

//self is a player
function play_waterfall( t_waterfall )
{
	self endon( "death" );
	
	//make sure same player doesn't keep activating the trigger
	t_waterfall SetInvisibleToPlayer( self );
	
	self clientfield::set_to_player( "player_waterfall_pstfx", true );
	
	while ( self IsTouching( t_waterfall ) )
	{
		n_delay = RandomFloatRange( 0, 1 );
		
		//wait a bit before checking to see if we've left the trigger
		wait n_delay;
	}
	
	//player has left trigger, let them be able to activate it again
	t_waterfall SetVisibleToPlayer( self );
	
	self clientfield::set_to_player( "player_waterfall_pstfx", false );
}

function opening_igc_fade()
{	
	util::screen_fade_out( 0 );
	
	level flag::wait_till( "partyroom_igc_started" );
	wait 0.5; //allow a bit of time for party room igc to kick in before the fade in starts
	
	util::screen_fade_in( 1 );
}

function igc_party( b_dev_skipto = false )
{
	level thread opening_igc_fade();
	
	level flag::wait_till( "all_players_spawned" );
	
	s_scene = struct::get( "tag_align_partyroom" );
	
	level thread play_stab_fx();
	
	level flag::set( "partyroom_igc_started" );
	
	//if loading from dev_bullet_scene skipto, skip the majority of the opening scene
	if ( !b_dev_skipto )
	{
		s_scene scene::play( "cin_bio_01_01_party_1st_drinks" );
	}
	else
	{
		level thread scene::play( "cin_bio_01_01_party_1st_drinks_waitloop" );
		util::wait_network_frame(); //keeps cybercom related SRE from happening in dev skipto
	}
	
	//cin_bio_01_01_party_1st_drinks_waitloop automatically set to play after initial scene in APE
	
	level thread initiate_plan_timer();
	
	foreach( player in level.players )
	{
		player thread initiate_plan();
		player thread cybercom::disableCybercom();
	}
	
	util::screen_message_create( &"CP_MI_SING_BIODOMES_PLAN_B", undefined, undefined, 150 );
	
	level flag::wait_till( "plan_b" );
	
	foreach( player in level.players )
	{
		player thread rumble_glass_break();
	}
	
	util::screen_message_delete();
	
	if ( level scene::is_active( "cin_bio_01_01_party_1st_drinks_waitloop" ) )
	{
		level scene::stop( "cin_bio_01_01_party_1st_drinks_waitloop" );
	}
	
	s_scene scene::play( "cin_bio_01_01_party_1st_drinks_trigger" );
	
	level thread shoot_igc_guards();
	level thread keyline_friendlies();
	
	SetSlowMotion( 1, 0.5, 4 );
	
	foreach( player in level.players )
	{
		//make sure the flag was set in case the spawn stuff didn't work
		if ( !player flag::exists( "player_bullet_over" ) )
		{
			player flag::init( "player_bullet_over" );
		}
		
		player thread bullet();
		player thread bullet_done();
		player thread bullet_end_trigger();
		player.ignoreme = true;
	}
	
	spawn_manager::enable( "sm_bullet_scene_robots" );
	
	s_scene thread scene::play( "cin_bio_01_01_party_1st_drinks_bullettime" );
	
	wait_for_all_bullets();
	
	level thread bullet_cleanup(); //cleans up unused bullet and gun barrel props
	
	a_destroyed_props = GetEntArray( "partyroom_destroyed" , "targetname" );
	foreach ( prop in a_destroyed_props )
	{
		prop Show();
	}
	
	a_mdl_windows = GetEntArray( "party_room_window", "targetname" );
	foreach( mdl_window in a_mdl_windows )
	{
		mdl_window Delete();
	}
	
	s_scene scene::stop( "cin_bio_01_01_party_1st_drinks_bullettime" );
	
	exploder::exploder( "objective_intro_bulletbarrage" );
	
	e_dannyli = GetEnt( "dannyli" , "targetname" , true );
	e_gohbro = GetEnt( "gohbrother" , "targetname" , true );
	
	SetSlowMotion( 0.5 , 1, 5 );
	
	array::run_all( spawn_manager::get_ai( "sm_bullet_scene_robots" ), &Delete );
	
	//play the right animation based on who died
	if ( !level flag::get( "dannyli_dead" ) && !level flag::get( "gohbro_dead" ) )
	{
		level thread scene::add_scene_func( "cin_bio_02_04_gunplay_vign_stab_both", &party_over, "done" );
		s_scene thread scene::play( "cin_bio_02_04_gunplay_vign_stab_both" );
	}
	else if ( !level flag::get( "dannyli_dead" ) )
	{
		level thread scene::add_scene_func( "cin_bio_02_04_gunplay_vign_stab_dannyli", &party_over, "done" );
		s_scene thread scene::play( "cin_bio_02_04_gunplay_vign_stab_dannyli" );
	}
	else if ( !level flag::get( "gohbro_dead" ) )
	{
		level thread scene::add_scene_func( "cin_bio_02_04_gunplay_vign_stab_gohbrother", &party_over, "done" );
		s_scene thread scene::play( "cin_bio_02_04_gunplay_vign_stab_gohbrother" );
	}
	else
	{
		level thread scene::add_scene_func( "cin_bio_02_04_gunplay_vign_stab_none", &party_over, "done" );
		s_scene thread scene::play( "cin_bio_02_04_gunplay_vign_stab_none" );
	}
	
	level thread squad_camo_intro_scene();
	
	//TODO add a notetrack for when the robots blast out the shutter. Wait for that note here, then delete.
	GetEnt( "party_room_shutter" , "targetname" ) Delete();
	
	//this enables all the triggers for markets spawning and scripts
	level notify( "player_regain_control" );
	
	foreach( player in level.players )
	{
		player AllowCrouch( true );
		player AllowProne( true );
	}
}

function wait_for_all_bullets()
{	
	level endon( "bullet_over" );
	
	//keep checking each player to see if they're all done with their bullet scenes
	while ( true )
	{
		b_bullets_finished = true;
		
		foreach( player in level.players )
		{
			if ( !player flag::get( "player_bullet_over" ) )
			{
				b_bullets_finished = false;
				break;
			}
		}
		
		if ( b_bullets_finished )
		{
			break;
		}
		
		wait 0.05;
	}
	
	level flag::set( "bullet_over" );
}

function keyline_friendlies()
{
	e_keyline_player = spawner::simple_spawn_single( "keyline_player" );
	e_hendricks = GetEnt( "hendricks", "animname", true );
	
	e_keyline_player thread keyline_bullet_time();
	e_hendricks thread keyline_bullet_time();
}

function keyline_bullet_time()  //self = friendly entity
{
	self.goalradius = 4;
	
	level flag::wait_till( "bullet_start" );
	
	self ai::gun_remove();
	self thread squad_control::enable_keyline( 3 );
	
	level flag::wait_till( "bullet_over" );
	
	self ai::gun_recall();
	self thread squad_control::disable_keyline();
	
	if ( self.targetname == "keyline_player_ai" )
	{
		self Delete();
	}
}

function bullet_cleanup()
{
	a_props = GetEntArray( "bullet_prop" , "script_noteworthy" );
	
	foreach ( ent in a_props )
	{
		ent Delete();
	}
}

function play_stab_fx()
{	
	level waittill( "stab_notetrack" ); //notetrack set in drinks_server animation
		
	ai_server = GetEnt( "server" , "animname" , true );
	
	ai_server fx::play( "blood_stab" , undefined, undefined, undefined, true, "J_SpineUpper", true );
	
	level waittill( "unstab_notetrack" ); //notetrack set in drinks_server animation
	
	ai_server fx::play( "blood_unstab" , undefined, undefined, undefined, true, "J_SpineUpper", true );
}

function party_over( scene )
{
	//get 4 unique start points for each player after opening scene is finished
	a_start_points = struct::get_array( "markets_player_start_locations", "targetname" );
	Assert( a_start_points.size >= level.players.size, "Add more script_structs named markets_player_start_locations to setup players after igc" );
	
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i].ignoreme = false;
		level.players[i] thread squad_color_triggers();
		level.players[i] thread squad_color_markets_start();
		level.players[i] thread squad_color_markets_rpg();
		level.players[i] thread squad_color_markets2();
	}
	
	//keeps players from bunching up after the scene is done
	level util::teleport_players_igc( "objective_markets_start" );

	init_squad( "objective_igc" );
	
	cp_mi_sing_biodomes_util::init_hendricks( "objective_igc" );
}

function initiate_plan()  //self = player
{
	level endon( "plan_b" );
	self endon( "disconnect" );
	
	while( 1 )
	{
		if ( self ActionSlotOneButtonPressed() ) //DPAD_UP
		{
			level flag::set( "plan_b" );
		}
		
		wait 0.05;
	}
}

function rumble_glass_break()  //self = player
{
	wait 1.5;  //TODO - add notetrack for glass break
	
	self PlayRumbleOnEntity( "damage_heavy" );
}

function initiate_plan_timer()
{
	level endon( "plan_b" );
	
	wait 6;
	
	level flag::set( "plan_b" );
}


function robot_set_name()  //self = player
{
	str_name = self.playername;
	
	for ( i = 0; i < self.a_robots.size; i++ )
	{
		self.a_robots[i].propername = str_name + "-" + i;
	}
}

function init_squad( str_objective )
{
	a_party_spots = struct::get_array( "struct_party_room" );
	a_robot_spots = struct::get_array( "markets_combat_robot_squad_spawn" );
	a_ai_party_robots = [];
	a_ai_robots = [];
	
	//adjust robot health and squad count depending on number of players
	switch( level.players.size )
	{
		case 1:
			n_robot_health_scalar = 4;
			n_squad = 4;
			break;
		case 2:
			n_robot_health_scalar = 3;
			n_squad = 6;
			break;
		case 3:
			n_robot_health_scalar = 3;
			n_squad = 6;
			break;
		case 4:
			n_robot_health_scalar = 3;
			n_squad = 8;
			break;
		default:
			n_robot_health_scalar = 1;
			n_squad = 4;
			break;
	}
	
	for ( i = 0; i < 4; i++ )
	{
		a_ai_party_robots[i] = GetEnt( "robot0" + (i+1), "animname" );
		a_ai_party_robots[i].health = a_ai_party_robots[i].health * n_robot_health_scalar;
		a_ai_party_robots[i].start_health = a_ai_party_robots[i].health;
		a_ai_party_robots[i] ForceTeleport( a_party_spots[i].origin, a_party_spots[i].angles );
	}
	
	if ( n_squad > 4 )
	{
		for ( i = 0; i < ( n_squad - a_party_spots.size ); i++ )  //minus initial party robots
		{
			a_ai_robots[i] = spawner::simple_spawn_single( "friendly_robot_control" );
			a_ai_robots[i] forceteleport( a_robot_spots[i].origin, a_robot_spots[i].angles );
			a_ai_robots[i].health = a_ai_robots[i].health * n_robot_health_scalar;
			a_ai_robots[i].start_health = a_ai_robots[i].health;
						
			wait 0.05;
		}
	}
	
	//skipto::teleport_ai( str_objective, a_ai_robots );
	
	wait 1;  //TODO - init robot squad control after opening IGC
	
	a_squad = ArrayCombine( a_ai_party_robots, a_ai_robots, false, true );
	
	n_squad_size = a_squad.size/level.players.size;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i].a_robots = [];
		
		for ( j = 0; j < n_squad_size; j++ )
		{
			array::add( level.players[i].a_robots, a_squad[0] );
			ArrayRemoveValue( a_squad, a_squad[0] );
		}
		
		level.players[i] squad_control::init_squad_control();
		level.players[i] thread squad_hud();
	}
}

function squad_camo_intro_scene()
{
	wait 0.5; //allow some time for scene to kick in before continuing
	
	a_ai_party_robots = [];
	
	for ( i = 0; i < 4; i++ )
	{
		a_ai_party_robots[i] = GetEnt( "robot0" + (i+1), "animname" );
		
		if ( isdefined( a_ai_party_robots[i]) )
		{
			a_ai_party_robots[i] clientfield::set( "robot_camo_shader", 2 );
			a_ai_party_robots[i] clientfield::set( "robot_camo_shader", 1 );
			a_ai_party_robots[i] PlaySound( "gdt_camo_suit_on" );
		}
	}
	
	level util::waittill_notify_or_timeout( "intro_robot_camo_off", 10 ); //notetrack is in all the ch_bio_02_04_gunplay_vign_stab* animations for robot01
	
	foreach( robot in a_ai_party_robots )
	{
		robot clientfield::set( "robot_camo_shader", 0 );
		robot PlaySound( "gdt_camo_suit_off" );
		wait 0.25; //stagger the robot camo deactivation
	}
}

function squad_hud()  //self = player
{
	self endon( "disconnect" );
	
	//don't do any of the HUD stuff if the squad is not player controlled, but setup health though
	if ( !level.b_squad_player_controlled )
	{
		for ( i = 0; i < self.a_robots.size; i++ )
		{
			self.a_robots[i].n_start_health = self.a_robots[i].health;
			self thread squad_regen_health( self.a_robots[i] );
		}
		
		return;
	}
	
	if ( !self.a_robots.size )
	{
		return;	
	}
	
	if ( !isdefined( self GetLUIMenu( "SquadStartMenu" ) ) )
	{
		self.squad_start_menu = self OpenLUIMenu( "SquadStartMenu" );
	
		wait 3;
	}
	
	if ( isdefined( self GetLUIMenu( "SquadStartMenu" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "SquadStartMenu" ) );
	}
	
	if ( !isdefined( self GetLUIMenu( "SquadControlReticuleMenu" ) ) )
	{
		self.reticule_menu = self OpenLUIMenu( "SquadControlReticuleMenu" );
		self playlocalsound( "evt_squad_activate" );
	
		self lui::play_animation( self.reticule_menu, "SquadStartFadeIn" );
		
		self SetLUIMenuData( self.reticule_menu, "squad_label_text", &"CP_MI_SING_BIODOMES_SQUAD_STATUS_LABEL" );
	}
	
	if ( !isdefined( self GetLUIMenu( "SquadMenu" ) ) )
	{
		self.squad_menu = self OpenLUIMenu( "SquadMenu" );
		
		if ( self.a_robots.size > 2 )
		{
			if ( !isdefined( self GetLUIMenu( "SquadMenu_2" ) ) )
			{
				self.squad_menu_2 = self OpenLUIMenu( "SquadMenu_2" );
			}
		}
		
		a_str_menu = array( "robot_one_text", "robot_two_text", "robot_three_text", "robot_four_text" );
		a_str_index = array( "robot1_index", "robot2_index", "robot3_index", "robot4_index" );
		a_str_health = array( "robot1_health", "robot2_health", "robot3_health", "robot4_health" );
		a_str_action = array( "robot1_action", "robot2_action", "robot3_action", "robot4_action" );
	
		//self SetLUIMenuData( self.squad_menu, "squad_label_text", &"CP_MI_SING_BIODOMES_SQUAD_STATUS_LABEL" );
	
		for ( i = 0; i < self.a_robots.size; i++ )
		{
			self.a_robots[i].n_start_health = self.a_robots[i].health;
		
			self thread squad_regen_health( self.a_robots[i], a_str_menu[i], a_str_index[i], a_str_health[i], a_str_action[i], i );
			self thread squad_action_display( self.a_robots[i], a_str_menu[i], a_str_index[i], a_str_health[i], a_str_action[i], i );
			self thread squad_damage_display( self.a_robots[i], a_str_menu[i], a_str_index[i], a_str_health[i], a_str_action[i], i );
			self thread squad_death_display( self.a_robots[i], a_str_menu[i], a_str_index[i], i );
		}
		
		self thread squad_control::update_camo_energy_HUD( 100 );
		
		level thread squad_control_hint();
	}
	
	self waittill( "end_squad_control" );
	
	if ( !isdefined( self GetLUIMenu( "SquadGoneMenu" ) ) )
	{
		self.squad_gone_menu = self OpenLUIMenu( "SquadGoneMenu" );
		
		if ( self.a_squad.size )
		{
			self SetLUIMenuData( self.squad_gone_menu, "squad_gone_text", &"CP_MI_SING_BIODOMES_SQUAD_DONE" );
		}
		else
		{
			self SetLUIMenuData( self.squad_gone_menu, "squad_gone_text", &"CP_MI_SING_BIODOMES_SQUAD_GONE" );
		}
	}
	
	wait 5;  //give time to read message before closing it
	
	if ( isdefined( self GetLUIMenu( "SquadGoneMenu" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "SquadGoneMenu" ) );
	}
	
	if ( isdefined( self GetLUIMenu( "SquadControlReticuleMenu" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "SquadControlReticuleMenu" ) );
	}
	
	if ( isdefined( self GetLUIMenu( "SquadMenu" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "SquadMenu" ) );
		self playlocalsound( "evt_squad_deactivate" );
	}
	
	if ( isdefined( self GetLUIMenu( "SquadMenu_2" ) ) )
	{
		self CloseLUIMenu( self GetLUIMenu( "SquadMenu_2" ) );
	}
}

function squad_regen_health( ai_robot, str_menu_data, str_index_data, str_health_data, str_action_data, n_index = 0 )  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	ai_robot endon( "death" );
		
	n_threshold = 10;
	
	ai_robot.n_health = Int( ( ai_robot.health/ai_robot.n_start_health ) * 100 );
	
	while( 1 )
	{
		if ( level.skipto_point == "objective_cloudmountain" && level.b_squad_player_controlled )
		{
			break;
		}
		
		if ( ai_robot.health < ai_robot.start_health )
		{
			ai_robot.health += n_threshold;
				
			ai_robot.n_health = Int( ( ai_robot.health/ai_robot.n_start_health ) * 100 );
			
			if ( ai_robot.n_health > 100 )
			{
				ai_robot.n_health = 100;
			}
			
			if ( ai_robot.n_health <= 100 )
			{
				if( level.b_squad_player_controlled )
				{
					squad_menu = self.squad_menu;
					
					if ( n_index > 1 )
					{
						squad_menu = self.squad_menu_2;
					}
					self SetLUIMenuData( squad_menu, str_index_data, n_index+1 );
					self SetLUIMenuData( squad_menu, str_health_data, ai_robot.n_health );
					self SetLUIMenuData( squad_menu, str_action_data, get_robot_action( ai_robot ) );
					self SetLUIMenuData( squad_menu, str_menu_data, get_robot_status_string( n_index ) );
					//self SetLUIMenuData( squad_menu, str_menu_data, (n_index+1) + " - STATUS: " + ai_robot.n_health + " PCT"   + " (" + ai_robot.str_action + ")" );
				}
				
				ai_robot.n_old_health = ai_robot.n_health;
			}
		}
		
		for ( i = 0; i < self.a_robots.size; i++ )  //regen faster if no enemies are around
		{
			if ( isdefined( self.a_robots[i].enemy ) )
			{
				n_wait = 5;
			}
			else
			{
				n_wait = 0.1;	
			}
		}
		
		wait n_wait;  //regen time
	}
	
	if ( level.b_squad_player_controlled )
	{
		if ( !isdefined( self GetLUIMenu( "SquadRegenMenu" ) ) )
		{
			self.squad_regen_menu = self OpenLUIMenu( "SquadRegenMenu" );
			
			self SetLUIMenuData( self.squad_regen_menu, "squad_regen_text", &"CP_MI_SING_BIODOMES_SQUAD_REGEN" );
		}
		
		wait 4;
		
		if ( isdefined( self GetLUIMenu( "SquadRegenMenu" ) ) )
		{
			self CloseLUIMenu( self GetLUIMenu( "SquadRegenMenu" ) );
		}
	}
}

function squad_action_display( ai_robot, str_menu_data, str_index_data, str_health_data, str_action_data, n_index )  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	ai_robot endon( "death" );
	
	ai_robot.n_health = Int( ( ai_robot.health/ai_robot.n_start_health ) * 100 );
	
	while( 1 )
	{
		ai_robot waittill( "action" );
		
		if ( ai_robot.n_health )
		{
			n_health = ai_robot.n_health;	
		}
		else
		{
			n_health = ai_robot.n_old_health;
		}
		
		//self thread print_robot_action( ai_robot );
		
		squad_menu = self.squad_menu;
				
		if ( n_index > 1 )
		{
			squad_menu = self.squad_menu_2;
		}
		
		//self SetLUIMenuData( squad_menu, str_menu_data, (n_index+1) + " - STATUS: " + n_health + " PCT"   + " (" + ai_robot.str_action + ")" );
		self SetLUIMenuData( squad_menu, str_index_data, n_index+1 );
		self SetLUIMenuData( squad_menu, str_health_data, ai_robot.n_health );
		self SetLUIMenuData( squad_menu, str_action_data, get_robot_action( ai_robot ) );
		self SetLUIMenuData( squad_menu, str_menu_data, get_robot_status_string( n_index ) );
	}
}

function get_robot_action( ai_robot )
{
	switch ( ai_robot.str_action )
	{
		case "Standard":
			str_action = &"CP_MI_SING_BIODOMES_ROBOT_STANDARD";
			break;
		case "Moving":
			str_action = &"CP_MI_SING_BIODOMES_ROBOT_MOVE";
			break;
		case "Interacting":
			str_action = &"CP_MI_SING_BIODOMES_ROBOT_INTERACT";
			break;
		case "Attacking":
			str_action = &"CP_MI_SING_BIODOMES_ROBOT_ATTACK";
			break;
	}
	
	return str_action;
}

function get_robot_status_string( n_index )
{
	switch ( n_index )
	{
		case 0:
			str_status = &"CP_MI_SING_BIODOMES_ROBOT1_STATUS";
			break;
		case 1:
			str_status = &"CP_MI_SING_BIODOMES_ROBOT2_STATUS";
			break;
		case 2:
			str_status = &"CP_MI_SING_BIODOMES_ROBOT3_STATUS";
			break;
		case 3:
			str_status = &"CP_MI_SING_BIODOMES_ROBOT4_STATUS";
			break;
	}
	
	return str_status;
}

function print_robot_action( ai_robot )  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	ai_robot endon( "action" );
	ai_robot endon( "death" );
	level endon( "turret_hall_clear" );
	
	while( 1 )
	{
		if ( ai_robot.str_action != "Standard" )
		{
			if ( ai_robot.str_action == "Moving" )
			{
				str_color = ( 1, 1, 1 );
			}
			else if ( ai_robot.str_action == "Interacting" )
			{
				str_color = ( 1, 1, 0 );
			}
			else if ( ai_robot.str_action == "Attacking" )
			{
				str_color = ( 1, 0, 0 );
			}
			
			v_pos = ai_robot.origin + ( 0, 0, 84 );
			
			/#Print3D( v_pos, ai_robot.str_action, str_color, 1, 0.25 );#/  //TODO - temp
		}
		
		wait 0.05;
	}
}

function squad_damage_display( ai_robot, str_menu_data, str_index_data, str_health_data, str_action_data, n_index )  //self = player
{
	self endon( "disconnect" );
	self endon( "end_squad_control" );
	ai_robot endon( "death" );
	
	ai_robot.n_old_health = Int( ( ai_robot.health/ai_robot.n_start_health ) * 100 );
	
	if ( n_index < 2 )
	{
		squad_menu = self.squad_menu;	
	}
	else
	{
		squad_menu = self.squad_menu_2;
	}
				
	//self SetLUIMenuData( squad_menu, str_menu_data, (n_index+1) + " - STATUS: " + ai_robot.n_old_health + " PCT"   + " (" + ai_robot.str_action + ")" );
	self SetLUIMenuData( squad_menu, str_index_data, n_index+1 );
	self SetLUIMenuData( squad_menu, str_health_data, ai_robot.n_health );
	self SetLUIMenuData( squad_menu, str_action_data, get_robot_action( ai_robot ) );
	self SetLUIMenuData( squad_menu, str_menu_data, get_robot_status_string( n_index ) );
	
	while( 1 )
	{
		ai_robot waittill( "damage" );
		
		if ( ai_robot.health )
		{
			ai_robot.n_health = Int( ( ai_robot.health/ai_robot.n_start_health ) * 100 );
			
			if ( ai_robot.n_health > 4 && ai_robot.n_old_health > ai_robot.n_health + 5 )  //no need to display percentages below 5
			{
				squad_menu = self.squad_menu;
				
				if ( n_index > 1 )
				{
					squad_menu = self.squad_menu_2;
				}
				
				//self SetLUIMenuData( squad_menu, str_menu_data, (n_index+1) + " - STATUS: " + ai_robot.n_health + " PCT"   + " (" + ai_robot.str_action + ")" );
				self SetLUIMenuData( squad_menu, str_index_data, n_index+1 );
				self SetLUIMenuData( squad_menu, str_health_data, ai_robot.n_health );
				self SetLUIMenuData( squad_menu, str_action_data, get_robot_action( ai_robot ) );
				self SetLUIMenuData( squad_menu, str_menu_data, get_robot_status_string( n_index ) );
				
				ai_robot.n_old_health = ai_robot.n_health;
			}
		}
		
		wait 3;  //no need to constantly update
	}
}

function squad_death_display( ai_robot, str_menu_data, str_index_data, n_index )  //self = player
{
	self endon( "disconnect" );
	
	ai_robot waittill( "death" );
	
	wait 0.1;  //give a little time for squad control to process
	
	squad_menu = self.squad_menu;
				
	if ( n_index > 1 )
	{
		squad_menu = self.squad_menu_2;
	}
				
	//self SetLUIMenuData( squad_menu, str_menu_data, (n_index+1) + " - STATUS: DESTROYED"  );
	self SetLUIMenuData( squad_menu, str_index_data, n_index+1 );
	
	switch( n_index )
	{
		case 0:
			self SetLUIMenuData( squad_menu, str_menu_data, &"CP_MI_SING_BIODOMES_ROBOT1_DEAD" );
			self lui::play_animation( squad_menu, "RobotOneDead" );
			break;
		case 1:
			self SetLUIMenuData( squad_menu, str_menu_data, &"CP_MI_SING_BIODOMES_ROBOT2_DEAD" );
			self lui::play_animation( squad_menu, "RobotTwoDead" );
			break;
		case 2:
			self SetLUIMenuData( squad_menu, str_menu_data, &"CP_MI_SING_BIODOMES_ROBOT3_DEAD" );
			self lui::play_animation( squad_menu, "RobotThreeDead" );
			break;
		case 3:
			self SetLUIMenuData( squad_menu, str_menu_data, &"CP_MI_SING_BIODOMES_ROBOT4_DEAD" );
			self lui::play_animation( squad_menu, "RobotFourDead" );
			break;
	}
}

function add_turret1_action()
{
	level flag::wait_till( "turret1" );
	
	if ( IsAlive( level.turret_markets1 ) )
	{
		for( i = 0; i < level.players.size; i++ )
		{
			level.players[i] thread squad_control::squad_control_task( level.turret_markets1 );
		}
		
		level.turret_markets1 thread remove_turret_task_ondeath();
	}
}

function add_turret2_action()
{
	level flag::wait_till( "turret2" );
	
	if ( IsAlive( level.turret_markets2 ) )
	{
		for( i = 0; i < level.players.size; i++ )
		{
			level.players[i] thread squad_control::squad_control_task( level.turret_markets2 );
		}
		
		level.turret_markets2 thread remove_turret_task_ondeath();
	}
}

function add_turret_hallway_action()
{
	e_turret = GetEnt( "turret_hall", "script_noteworthy" );
		
	if ( isdefined( e_turret ) )
	{
		for( i = 0; i < level.players.size; i++ )
		{
			level.players[i] thread squad_control::squad_control_task( e_turret );
		}
	}
}

function add_open_door_action()
{
	level flag::wait_till( "warehouse_warlord" );
	
	ai_warlord = GetEnt( "warehouse_enemy_warlord_ai", "targetname" );
	
	if ( IsAlive( ai_warlord ) )
	{
		//make sure warlord can catch the preferred nodes
		ai_warlord.goalheight = 320;
		
		level scene::play( "cin_bio_05_02_warehouse_aie_jump", ai_warlord );
		
		//give the warlord some elevated spots to go to
		a_warlord_nodes = GetNodeArray( "node_warlord_warehouse_preferred", "targetname" );
		
		foreach ( node in a_warlord_nodes )
		{
			ai_warlord WarlordInterface::AddPreferedPoint( node.origin, 5000, 10000 );
		}
		
		ai_warlord waittill( "death" );
		
		ai_warlord WarlordInterface::ClearAllPreferedPoints();
	}
	
	level flag::set( "warehouse_warlord_dead" );
	
	//for special "tasks", i.e. scripted moments	
	e_robot_task = GetEnt( "pry_door", "script_noteworthy" );
	
	for( i = 0; i < level.players.size; i++ )
	{
		level.players[i] thread squad_control::squad_control_task( e_robot_task );
	}
}

function remove_turret_task_ondeath()  //self = squad interact-able turret
{
	self waittill( "death" );
	
	if ( isdefined( self ) )
	{
		foreach( player in level.players )
		{
			if ( IsInArray( player.a_robot_tasks, self ) )
			{
				ArrayRemoveValue( player.a_robot_tasks, self );
			}
		}
	}
}

//TODO temp
function hendricks_follow_player()
{
	level.ai_hendricks endon( "stop_following" ); //notify  for Hendricks to stop following, used in cloud mountain
	
	level flag::wait_till( "all_players_spawned" );
	
	level.ai_hendricks colors::disable();
	
	while( 1 )
	{
		if ( Distance2DSquared( level.ai_hendricks.origin, level.players[0].origin ) > ( 600 * 600 ) )
		{
			level.ai_hendricks SetGoal( level.players[0].origin, true );
		
			level.ai_hendricks util::waittill_any_timeout( 5, "goal" );
		}
		
		wait 0.1;
	}
}


//============================================================
// SKIP TO'S

function setup_skiptos()
{
	skipto::add( "objective_igc",	&objective_igc_init, undefined, &objective_igc_done );
	skipto::add_dev( "dev_bullet_scene", &dev_bullet_scene_init );
	skipto::add( "objective_markets_start", &cp_mi_sing_biodomes_markets::objective_markets_start_init,	undefined, &cp_mi_sing_biodomes_markets::objective_markets_start_done );
	skipto::add( "objective_markets_rpg", &cp_mi_sing_biodomes_markets::objective_markets_rpg_init,	undefined, &cp_mi_sing_biodomes_markets::objective_markets_rpg_done );
	skipto::add( "objective_markets2_start",	&cp_mi_sing_biodomes_markets::objective_markets2_start_init, undefined, 	&cp_mi_sing_biodomes_markets::objective_markets2_start_done);
	skipto::add( "objective_warehouse", &cp_mi_sing_biodomes_warehouse::objective_warehouse_init, undefined, &cp_mi_sing_biodomes_warehouse::objective_warehouse_done );
	skipto::add_dev( "dev_warehouse_door", &cp_mi_sing_biodomes_warehouse::dev_warehouse_door_init );
	skipto::add_dev( "dev_warehouse_door_without_robots", &cp_mi_sing_biodomes_warehouse::dev_warehouse_door_without_robots_init );
	skipto::add( "objective_cloudmountain", &cp_mi_sing_biodomes_cloudmountain::objective_cloudmountain_init, undefined, 	&cp_mi_sing_biodomes_cloudmountain::objective_cloudmountain_done );
	skipto::add( "objective_turret_hallway", &cp_mi_sing_biodomes_cloudmountain::objective_turret_hallway_init, undefined, &cp_mi_sing_biodomes_cloudmountain::objective_turret_hallway_done );
	skipto::add( "objective_xiulan_vignette",	&cp_mi_sing_biodomes_cloudmountain::objective_xiulan_vignette_init, undefined, &cp_mi_sing_biodomes_cloudmountain::objective_xiulan_vignette_done );
	skipto::add( "objective_server_room_defend", &cp_mi_sing_biodomes_cloudmountain::objective_server_room_defend_init, undefined, &cp_mi_sing_biodomes_cloudmountain::objective_server_room_defend_done );
	skipto::add( "objective_fighttothedome", &cp_mi_sing_biodomes_fighttothedome::objective_fighttothedome_init,	undefined, &cp_mi_sing_biodomes_fighttothedome::objective_fighttothedome_done );
}


function objective_igc_init( str_objective, b_starting )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_igc_init" );
	
	init_party();
	level thread igc_party();
	level thread level_setup();
	
	level waittill( "end_igc" ); //notetrack set in hendricks stab animations
	
	wait 1; //give player a moment after exiting IGC before advancing
	
	//get Hendricks into position
	trigger::use( "trig_hendricks_color_marketst1" );
	
	level skipto::objective_completed( "objective_igc" );
}

function objective_igc_done( str_objective, b_starting, b_direct, player )
{
	cp_mi_sing_biodomes_util::objective_message( "objective_igc_done" );
	
	if ( b_starting )
	{
		level thread bullet_cleanup();
	}
}



//============================================================
// Markets Area logic

function squad_control_hint()
{
	//TODO - move to after opening IGC when implemented
	wait 1;
	
	util::screen_message_create( &"CP_MI_SING_BIODOMES_SQUAD_TARGET", undefined, undefined, 0, 4 );
	util::screen_message_create( &"CP_MI_SING_BIODOMES_SQUAD_MOVE", undefined, undefined, 0, 4 );
}

//taken from _cybercom_gadget_security_breach.gsc, fade when going into the bullet scene
function bullet_transition_visionset( player, setname, delay, direction, duration )
{
	wait delay;
	
	if ( direction > 0 )
	{
		visionset_mgr::activate( "visionset", setname, player, duration, 0.0, 0.0 );
		visionset_mgr::deactivate( "visionset", setname, player );
	}
	else
	{
		visionset_mgr::activate( "visionset", setname, player, 0.0, 0.0, duration );
		visionset_mgr::deactivate( "visionset", setname, player );
	}
}

function bullet()  //self = player
{
	self endon( "death" );
	
	mdl_bullet = GetEnt( "bullet_" + self GetEntityNumber(), "targetname" );
	mdl_bullet.barrel = GetEnt( "barrel_bullet_" + self GetEntityNumber(), "targetname" );
	e_linkto = GetEnt( "bullet_tag_" + self GetEntityNumber(), "targetname" );
	
	//sound - turning off walla
	level util::clientnotify ("no_party");
		
	v_curr_pos = mdl_bullet.origin;
	
	// set angles to zero to better determine the offset for player linking
	mdl_bullet.angles = ( 0, 0, 0 );
	e_linkto.angles = ( 0, 0, 0 );
		
	mdl_bullet endon( "death" );
	
	mdl_bullet SetPlayerCollision( false );
		
	// offset puts player view right behind the bullet
	e_linkto LinkTo( mdl_bullet, "tag_origin", ( -10, 0, -60 ) );
	
	self disableweapons();
	self Hide();
	self NotSolid();
	self HideViewModel();
	self SetClientUIVisibilityFlag( "hud_visible", 0 );
	self PlayerLinkToDelta( e_linkto, "tag_origin", 0, 0, 0, 0, 0 );
	self FreezeControls( true );
	
	self thread bullet_transition_visionset( self, "hijack_vehicle", 0.1, 1, 3 );
	visionset_mgr::activate( "visionset", "hijack_vehicle_blur", self );
	self clientfield::set_to_player( "player_bullet_camera", 2 );
	
	mdl_bullet.angles = mdl_bullet.barrel.angles;
	e_linkto.angles = mdl_bullet.angles;
		
	wait 0.05;
	
	level thread util::screen_message_create( &"CP_MI_SING_BIODOMES_BULLET_HINT", undefined, undefined, 0, 3 );
	
	wait 2; //allow some time for transition to take place before firing bullet
	
	self thread bullet_ride_sound();
	
	mdl_bullet.yaw_offset = 0;
	mdl_bullet.pitch_offset = 0;
	
	mdl_bullet thread bullet_check_collision( self );
	
	weapon = GetWeapon( "robot_gun" );
	
	MagicBullet( weapon, mdl_bullet.origin + (0,0,100), mdl_bullet.origin + (0,0,200) );
	
	self PlayRumbleOnEntity( "sniper_fire" );
	
	v_forward = v_curr_pos + AnglesToForward( mdl_bullet.angles ) * 15;
	mdl_bullet MoveTo( v_forward, 1 );
	
	wait 0.9;
	
	e_linkto LinkTo( mdl_bullet, "tag_origin", ( -10, 0, -56 ) );
	
	self FreezeControls( false );
	self AllowCrouch( false );
	self AllowProne( false );
	
	mdl_bullet fx::play( "bullet_trail", mdl_bullet.origin, mdl_bullet.angles, undefined, true, "tag_origin", true );
	
	level flag::set( "bullet_start" );
	
	self.bullet_fui = self OpenLUIMenu( "BulletTimeReticule" );
	
	//HACK something is resetting the HUD, make invisible again
	self SetClientUIVisibilityFlag( "hud_visible", 0 );
	
	while( !self flag::get( "player_bullet_over" ) )
	{		
		mdl_bullet.angles = mdl_bullet.angles + ( mdl_bullet.pitch_offset, mdl_bullet.yaw_offset, 0 );
			
		v_forward = v_curr_pos + AnglesToForward( mdl_bullet.angles ) * 30;
		
		mdl_bullet MoveTo( v_forward, 0.1 );
		
		wait 0.05;
	
		v_curr_pos = mdl_bullet.origin;
		
		norm_move = self GetNormalizedMovement();
		
		//TODO add "bullet fin" movement animations to bullet when player steers it
		//pitch up
		if ( norm_move[0] > 0.2 && norm_move[0] < 0.5 )  //pitch up
		{
			if ( mdl_bullet.pitch_offset > -10 )
			{
				mdl_bullet.pitch_offset-= 0.01 * 6;
			}
		}
		if ( norm_move[0] >= 0.5 && norm_move[0] < 0.8 )  //pitch up
		{
			if ( mdl_bullet.pitch_offset > -10 )
			{
				mdl_bullet.pitch_offset-= 0.03 * 6;
			}
		}
		if ( norm_move[0] >= 0.8 )  //pitch up
		{
			if ( mdl_bullet.pitch_offset > -10 )
			{
				mdl_bullet.pitch_offset-= 0.05 * 6;
			}
		}
		
		//pitch down
		if ( norm_move[0] < -0.2 && norm_move[0] > -0.5 )
		{
			if ( mdl_bullet.pitch_offset < 10 )
			{
				mdl_bullet.pitch_offset+= 0.01 * 6;
			}
		}
		if ( norm_move[0] <= -0.5 && norm_move[0] > -0.8 )
		{
			if ( mdl_bullet.pitch_offset < 10 )
			{
				mdl_bullet.pitch_offset+= 0.03 * 6;
			}
		}
		if ( norm_move[0] <= -0.8 )
		{
			if ( mdl_bullet.pitch_offset < 10 )
			{
				mdl_bullet.pitch_offset+= 0.05 * 6;
			}
		}
		
		//yaw right
		if ( norm_move[1] > 0.2 && norm_move[1] < 0.5 )
		{
			if ( mdl_bullet.yaw_offset > -10 )
			{
				mdl_bullet.yaw_offset-= 0.01 * 6;
			}
		}
		if ( norm_move[1] >= 0.5 && norm_move[1] < 0.8 )
		{
			if ( mdl_bullet.yaw_offset > -10 )
			{
				mdl_bullet.yaw_offset-= 0.03 * 6;
			}
		}
		if ( norm_move[1] >= 0.8 )
		{
			if ( mdl_bullet.yaw_offset > -10 )
			{
				mdl_bullet.yaw_offset-= 0.05 * 6;
			}
		}
		
		//yaw left
		if ( norm_move[1] < -0.2 && norm_move[1] > -0.5 )
		{
			if ( mdl_bullet.yaw_offset < 10 )
			{
				mdl_bullet.yaw_offset+= 0.01 * 6;
			}
		}
		if ( norm_move[1] <= -0.5 && norm_move[1] > -0.8 )
		{
			if ( mdl_bullet.yaw_offset < 10 )
			{
				mdl_bullet.yaw_offset+= 0.03 * 6;
			}
		}
		if ( norm_move[1] <= -0.8 )
		{
			if ( mdl_bullet.yaw_offset < 10 )
			{
				mdl_bullet.yaw_offset+= 0.05 * 6;
			}
		}
	}
}

//self is a player
function bullet_ride_sound()
{
	self endon( "death" );
	
	snd_ent = spawn( "script_origin", (0,0,0 ));
	snd_ent playloopsound ("evt_bullet_ride");
	self flag::wait_till( "player_bullet_over" );
	//level waitill ("bllt_snd_off");
	snd_ent stoploopsound (.3);
}
	
//self is a player
function bullet_end_trigger()
{
	level endon( "bullet_over" );
	self endon( "death" );

	t_bullet_impact = GetEnt( "trigger_bullet_impact", "targetname" );
	
	while ( true )
	{
		t_bullet_impact trigger::wait_till();
		
		//set my flag if I was the one who hit this trigger
		if ( t_bullet_impact.who === self )
		{	
			self flag::set( "player_bullet_over" );
			break;
		}
	}
}

function bullet_check_collision( player )  //self = bullet
{
	self endon( "death" );
	level endon( "bullet_over" );
	
	while( self IsTouching( GetEnt( "trig_bullet_space" , "targetname" ) ) )
	{
		v_forward = self.origin + AnglesToForward( self.angles ) * 1000;
			
		v_trace = BulletTrace( self.origin, v_forward, true, player );
		
		e_hit = v_trace["entity"];
			
		if ( isdefined( e_hit ) && IsAi( e_hit ) )
		{
			if ( Distance2DSquared( self.origin, e_hit.origin ) < 30 * 30 )
			{
				self bullet_check_hit( player );
			}
		}
		
		wait 0.05;
	}
	
	player flag::set( "player_bullet_over" );
}

function bullet_check_hit( player )  //self = bullet
{
	v_forward = self.origin + AnglesToForward( self.angles ) * 1000;
			
	v_trace = BulletTrace( self.origin, v_forward, true, player );
		
	e_hit = v_trace["entity"];
	v_pos = v_trace["position"];
	v_angles = v_trace["normal"];
			
	if ( isdefined( e_hit ) && ( e_hit.targetname !== "hendricks" ) && ( e_hit.targetname !== "keyline_player_ai" ) )
	{
		if ( IsAi( e_hit ) && Distance2DSquared( self.origin, e_hit.origin ) < 15 * 15 )
		{
			if ( e_hit == GetEnt( "dannyli" , "animname" , true ) )
			{
			    level flag::set( "dannyli_dead" );
			}
			else if ( e_hit == GetEnt( "gohbrother" , "animname" , true ) )
			{
			    level flag::set( "gohbro_dead" );
			}
			
			///# Iprintlnbold( "HIT " + e_hit.targetname ); #/

			e_hit fx::play( "blood_bullettime", v_pos , v_angles, undefined , undefined , true );
			
			///# Iprintlnbold( "KILLING " + e_hit.targetname ); #/
			
			e_hit kill();
			
			player flag::set( "player_bullet_over" );
		}
	}
}

function set_death_anim() //self = ai hit with bullet
{
	switch ( self.targetname )
	{
		case "guard01":
			self animation::set_death_anim( "ch_bio_01_01_party_1st_drinks_guard01_hitreact" );
			break;
		case "guard02":
			self animation::set_death_anim( "ch_bio_01_01_party_1st_drinks_guard02_hitreact" );
			break;
		case "guard03":
			self animation::set_death_anim( "ch_bio_01_01_party_1st_drinks_guard03_hitreact" );
			break;
		case "gohbrother":
			self animation::set_death_anim( "ch_bio_01_01_party_1st_drinks_gohbrother_hitreact" );
			break;
		case "dannyli":
			self animation::set_death_anim( "ch_bio_01_01_party_1st_drinks_dannyli_hitreact" );
			break;
		default :
			break;
	}
}

function shoot_igc_guards() //kills any guards the player didn't already hit
{
	flag::wait_till( "bullet_over");
	
	a_source_spots = struct::get_array( "igc_extra_bullets" );
	
	for ( i = 1; i <= 3; i++ )
	{
		e_guard = GetEnt( "guard0" + i , "animname" , true );
		
		if ( isdefined( e_guard ) && isAlive( e_guard ) )
		{
			v_source = array::random( a_source_spots ).origin;
			
			level thread kill_igc_guards( e_guard , v_source );
		}
	}
}

function kill_igc_guards( e_guard , v_source)
{
	wait RandomFloatRange( 0.5 , 1 ); //wait to let victims of slomo bullets die first
	
	//weapon = GetWeapon( "sniper_powerbolt" );
	
	//e_bullet = MagicBullet( weapon, v_source , e_guard.origin + (0,0,44) , undefined, e_guard ); //TODO make it so these bullets can only kill the intended target, ignore everyone else
		
	e_guard Kill( v_source );
}

function bullet_done()  //self = player
{
	self endon( "disconnect" );
	
	self flag::wait_till( "player_bullet_over" );
	
	//TODO fade the player's screen until all the bullets are finished in co-op
	if ( level.players.size > 1 )
	{
		self util::screen_message_create_client( "Waiting for other players" );
		self clientfield::set_to_player( "bullet_disconnect_pstfx", true );
	}
	
	level flag::wait_till( "bullet_over" );
	
	self util::screen_message_delete_client();
	self clientfield::set_to_player( "bullet_disconnect_pstfx", false );
	
	self clientfield::set_to_player( "player_bullet_camera", 1 );
		
	self Unlink();
	self Show();
	self Solid();
	self ShowViewModel();
	self setClientUIVisibilityFlag( "hud_visible", 1 );
	self enableweapons();
	self thread cybercom::enableCybercom();
	
	self CloseLUIMenu( self.bullet_fui );
	
	self thread bullet_transition_visionset( self, "hijack_vehicle", 0, -1, 3 );
	visionset_mgr::deactivate( "visionset", "hijack_vehicle_blur", self );
	self clientfield::set( "camo_shader", 1 );

	wait 1; //wait a bit to reveal the player (technically just their arm in this scene)
	
	self clientfield::set( "camo_shader", 0 );
	self PlaySound( "gdt_camo_suit_off");
}

function init_party()
{
	spawner::add_spawn_function_group( "party_guys", "script_noteworthy", &party_spawn_func );
}
	
function party_spawn_func()
{
	self endon( "death" );
	
	self thread set_death_anim();
	
	self ai::set_ignoreall( true );
	self ai::set_ignoreme( true );
	
	level flag::wait_till( "bullet_start" );
	
	self thread squad_control::enable_keyline( 2 );
	
	level flag::wait_till( "bullet_over" );
	
	self thread squad_control::disable_keyline();
	
	level waittill( "end_igc" );
	
	self Delete();
}

function squad_color_triggers()  //self = player, need to check whose robots to send to color nodes
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_start", "targetname", self );
	
	trigger::use( "t_color_start" + self GetEntityNumber() );
}

function squad_color_markets_start()  //self = player
{
	self endon( "disconnect" );
	
	self thread color_triggers_market_right_start();
	self thread color_triggers_market_right_mid();
	self thread color_triggers_market_right_end();
	self thread color_triggers_market_left_start();
	self thread color_triggers_market_left_mid();
	self thread color_triggers_market_left_end();
}

function squad_color_markets_rpg()  //self = player
{
	self endon( "disconnect" );
	
	self thread color_triggers_market_turret();
	
	trigger::wait_till( "t_zoo_start", "targetname", self );
	trigger::use( "t_color_zoo_start" + self GetEntityNumber() );
}

function squad_color_markets2()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_zoo_tunnel", "targetname", self );
	trigger::use( "t_color_zoo_tunnel" + self GetEntityNumber() );
	
	trigger::wait_till( "t_zoo_cages", "targetname", self );
	trigger::use( "t_color_zoo_cages" + self GetEntityNumber() );
	
	trigger::wait_till( "t_zoo_ramp", "targetname", self );
	trigger::use( "t_color_zoo_ramp" + self GetEntityNumber() );
	
	trigger::wait_till( "t_zoo_bridge", "targetname", self );
	trigger::use( "t_color_zoo_bridge" + self GetEntityNumber() );
	
	trigger::wait_till( "t_zoo_end", "targetname", self );
	trigger::use( "t_color_zoo_end" + self GetEntityNumber() );
}

function color_triggers_market_right_start()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_right_start", "targetname", self );
	trigger::use( "t_color_right_start" + self GetEntityNumber() );
}

function color_triggers_market_right_mid()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_right_mid", "targetname", self );
	trigger::use( "t_color_right_mid" + self GetEntityNumber() );
}

function color_triggers_market_right_end()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_right_end", "targetname", self );
	trigger::use( "t_color_right_end" + self GetEntityNumber() );
}

function color_triggers_market_left_start()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_left_start", "targetname", self );
	trigger::use( "t_color_left_start" + self GetEntityNumber() );
}

function color_triggers_market_left_mid()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_left_mid", "targetname", self );
	trigger::use( "t_color_left_mid" + self GetEntityNumber() );
}

function color_triggers_market_left_end()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_left_end", "targetname", self );
	trigger::use( "t_color_left_end" + self GetEntityNumber() );
}

function color_triggers_market_turret()  //self = player
{
	self endon( "disconnect" );
	
	trigger::wait_till( "t_pre_turret1", "targetname", self );
	trigger::use( "t_color_pre_turret1" + self GetEntityNumber() );
	
	level flag::wait_till( "turret1_dead" );
	
	trigger::use( "t_color_post_turret1" + self GetEntityNumber() );
}


//dev skipto, this will skip to the start of the bullet scene, using the same gameplay function for the opening igc
function dev_bullet_scene_init( str_objective, b_starting )
{
	init_party();
	level thread igc_party( true );
	level thread level_setup();
}
