#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\colors_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\trigger_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

#using scripts\cp\_ammo_cache;
#using scripts\cp\_load;
#using scripts\cp\_mobile_armory;
#using scripts\cp\_objectives; 
#using scripts\cp\_oed;
#using scripts\cp\_skipto;
#using scripts\cp\_util;

#using scripts\cp\cp_mi_sing_blackstation_qzone;
#using scripts\cp\cp_mi_sing_blackstation_comm_relay;
#using scripts\cp\cp_mi_sing_blackstation_cross_debris;
#using scripts\cp\cp_mi_sing_blackstation_fx;
#using scripts\cp\cp_mi_sing_blackstation_police_station;
#using scripts\cp\cp_mi_sing_blackstation_port;
#using scripts\cp\cp_mi_sing_blackstation_sound;
#using scripts\cp\cp_mi_sing_blackstation_station;
#using scripts\cp\cp_mi_sing_blackstation_subway;
#using scripts\cp\cp_mi_sing_blackstation_utility;

       
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "material", "generic_filter_raindrops" );
#precache( "material", "t7_hud_prompt_pickup_64" );

#precache( "objective", "cp_level_blackstation_qzone" );
#precache( "objective", "cp_level_blackstation_secure_cargo" );
#precache( "objective", "cp_level_blackstation_wheelhouse" );
#precache( "objective", "cp_level_blackstation_rendezvous" );
#precache( "objective", "cp_level_blackstation_comm_relay" );
#precache( "objective", "cp_level_blackstation_blackstation" );
#precache( "objective", "cp_level_blackstation_kill_target" );
#precache( "objective", "cp_standard_follow_breadcrumb" );
#precache( "objective", "cp_standard_breadcrumb" );

#precache( "triggerstring", "CP_MI_SING_BLACKSTATION_WARLORD_INTERACT" );

#precache( "string", "CP_MI_SING_BLACKSTATION_USE_ANCHOR" );
#precache( "string", "CP_MI_SING_BLACKSTATION_JUMP_SHIP" );
#precache( "string", "EXE_CHECKPOINT_REACHED" );

#precache( "lui_menu", "CACWaitMenu" );
#precache( "lui_menu", "MissileLauncherHint" );
#precache( "lui_menu", "MissileLauncherEquipHint" );

#precache( "fx", "blood/fx_blood_ai_head_explosion" );
#precache( "fx", "light/fx_light_emergency_flare_red" );
#precache( "fx", "light/fx_light_ray_work_light" );
#precache( "fx", "light/fx_spot_low_factory_zmb" );
#precache( "fx", "weather/fx_lightning_strike_bolt_single_blackstation" );
#precache( "fx", "destruct/fx_dest_robot_head_sparks" );
#precache( "fx", "water/fx_water_splash_boat_impact_bio" );
#precache( "fx", "water/fx_temp_water_tidal_wave_sgen" );
#precache( "fx", "weapon/fx_attchmnt_laser_3p" );

#precache( "model", "veh_t7_city_car_static_dead" );
#precache( "model", "veh_t6_v_van_whole" );
#precache( "model", "veh_t7_civ_gt_sedan_bluemetallic_dest" );
#precache( "model", "p7_water_container_plastic_large_distressed" );
#precache( "model", "p7_light_spotlight_generator_02" );
#precache( "model", "p7_foliage_treetrunk_fallen_01" );
#precache( "model", "veh_t7_civ_truck_med_cargo_54i_dead" );
#precache( "model", "p7_debris_junkyard_scrap_pile_01" );
#precache( "model", "p7_debris_junkyard_scrap_pile_02" );
#precache( "model", "p7_debris_junkyard_scrap_pile_03" );
#precache( "model", "p7_debris_concrete_rubble_lg_03" );
#precache( "model", "p7_debris_metal_scrap_01" );
#precache( "model", "p7_debris_ibeam_dmg" );
#precache( "model", "p7_sin_wall_metal_slats" );


function main()
{
	precache();
	register_clientfields();
	flag_init();
	level_init();
	weather_setup();
	
	cp_mi_sing_blackstation_fx::main();
	cp_mi_sing_blackstation_sound::main();
	cp_mi_sing_blackstation_qzone::main();
	cp_mi_sing_blackstation_port::main();
	
	setup_skiptos();
	billboard();
		
	//Level Vars
	//level.giveCustomLoadout = &giveCustomLoadout;  //TODO - remove when we decide on the anchor button
	level.b_enhanced_vision_enabled = true;	// Enables Enhanced Vision.  See _oed.gsc
		
	// Callbacks
	callback::on_spawned( &on_player_spawned );
	callback::on_loadout( &on_player_loadout );
	
	load::main();
	
	SetDvar( "ui_newHud", 1 );  // TEMP: enable comms UI visualization. Remove when this is set by default
}

function precache()
{
	level._effect[ "blood_headpop" ] = "blood/fx_blood_ai_head_explosion";
	level._effect[ "red_flare" ] = "light/fx_light_emergency_flare_red";
	level._effect[ "lightning_strike" ] = "weather/fx_lightning_strike_bolt_single_blackstation";
	level._effect[ "disabled_robot" ] = "destruct/fx_dest_robot_head_sparks";
	level._effect[ "worklight" ] = "light/fx_spot_low_factory_zmb";
	level._effect[ "worklight_rays" ] = "light/fx_light_ray_work_light";
	level._effect[ "wave_pier" ] = "water/fx_temp_water_tidal_wave_sgen";
	level._effect[ "kane_laser" ] = "weapon/fx_attchmnt_laser_3p";
}

function flag_init()
{
	level flag::init( "kill_weather" );
	level flag::init( "kill_surge" );
	level flag::init( "end_surge" );
	level flag::init( "kill_wave" );
	level flag::init( "surging_inward" );
	level flag::init( "move_debris" );	
	level flag::init( "vtol_spawned" );
	level flag::init( "vtol_jump" );
	level flag::init( "on_ground" );
	level flag::init( "debris_interact" );
	level flag::init( "debris_clear" );
	level flag::init( "warlord_intro_prep" );
	level flag::init( "warlord_intro_done" );
	level flag::init( "warlord_fight" );
	level flag::init( "warlord_backup" );
	level flag::init( "warlord_reinforce" );
	level flag::init( "warlord_retreat" );
	level flag::init( "warlord_fight_done" );
	level flag::init( "qzone_done" );
	level flag::init( "warning_vo_played" );
	level flag::init( "wind_gust" );
	level flag::init( "drone_strike" );
	level flag::init( "surge_active" );
	level flag::init( "end_surge_start" );
	level flag::init( "end_surge_rest" );
	level flag::init( "wind_done" );
	level flag::init( "surge_done" );
	level flag::init( "wave_done" );
	level flag::init( "cover_switch" );
	level flag::init( "enter_port" );
	level flag::init( "tanker_smash" );
	level flag::init( "tanker_go" );
	level flag::init( "roof_fly" );
	level flag::init( "tanker_face" );
	level flag::init( "tanker_hit" );
	level flag::init( "tanker_ride" );
	level flag::init( "tanker_ride_done" );
	level flag::init( "subway_engaged" );
	level flag::init( "table_flip" );
	level flag::init( "walkway_collapse" );
	level flag::init( "building_teeter" );
	level flag::init( "building_collapse" );
	level flag::init( "end_frogger" );
	level flag::init( "kill_patroller" );
	level flag::init( "police_station_engaged" );
	level flag::init( "comm_relay_engaged" );
	level flag::init( "comm_relay_hacked" );
	level flag::init( "igc_robot_down" );
	level flag::init( "blackstation_exterior_engaged" );
	level flag::init( "exterior_ready_weapons" );
	level flag::init( "ziplines_ready" );
	level flag::init( "kane_landed" );
	level flag::init( "zipline_player_landed" );
	level flag::init( "lightning_strike" );
	level flag::init( "lightning_strike_done" );
	level flag::init( "breach_active" );
	level flag::init( "hendricks_at_window" );
	level flag::init( "player_in_house" );
	level flag::init( "bridge_start_blocked" );
	level flag::init( "bridge_collapsed" );
	level flag::init( "cancel_slow_mo" );
	level flag::init( "atrium_rubble_dropped" );
	level flag::init( "midway_impact" );
	level flag::init( "path_is_open" );
	level flag::init( "awakening_begun" );
	level flag::init( "no_awakened_robots" );
	level flag::init( "truck_in_position" );
	level flag::init( "give_dni_weapon" );
}

function level_init()
{
	SetDvar( "player_swimTime", 5000 );
}

function on_player_spawned()  //self = player
{
	self thread player_rain_fx();
		
	self thread blackstation_utility::player_anchor();
	
	self.b_launcher_hint = false;
	self.b_safezone = false;
	self.is_surged = false;
	self.is_wet = false;
		
	//TODO - temp until IGC is added
	if ( !GetDvarInt( "art_review", 0 ) )
	{
		if ( level.skipto_point == "objective_igc" )
		{
			self thread cp_mi_sing_blackstation_qzone::vtol_board();
			
			if ( level.players.size > 1 )
			{
				wait 0.5;  //need to wait a bit after player has spawned before opening menu, don't know why, this is temp anyway
				
				self.wait_menu = self OpenLUIMenu( "CACWaitMenu" );  //TODO - temp until we have real CAC functionality for campaign
			}
			else
			{
				util::screen_fade_out( 0 );
				
				wait 0.5;
				
				util::screen_fade_in( 1 );
			}
		}
	}
}

function on_player_loadout()
{
	w_dni_shotgun = GetWeapon( "micromissile_launcher" );
	
	self GiveWeapon( w_dni_shotgun );
	
	level flag::set( "give_dni_weapon" );
}

function close_cacwaitmenu()  //self = player
{
	wait 1;  //wait until IGC has started playing before closing menu
	
	if ( isdefined( self.wait_menu ) )
	{
		self CloseLUIMenu( self.wait_menu );
	}	
}

function register_clientfields()
{
	clientfield::register( "toplayer", "fullscreen_rain_fx", 1, 1, "int" );
	clientfield::register( "toplayer", "sndWindSystem", 1, 2, "int" );
	clientfield::register( "world", "water_level", 1, 3, "int" );
	clientfield::register( "actor", "kill_target_keyline", 1, 4, "int" );
	clientfield::register( "world", "pier_wave_init", 1, 1, "int" );
	clientfield::register( "world", "pier_wave_play", 1, 1, "int" );
	clientfield::register( "toplayer", "player_rain", 1, 2, "int" );
}


// SKIPTO'S
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
function setup_skiptos()
{
	skipto::add( "objective_igc",	&cp_mi_sing_blackstation_qzone::objective_igc_init, undefined, &cp_mi_sing_blackstation_qzone::objective_igc_done );
	skipto::add( "objective_qzone", &cp_mi_sing_blackstation_qzone::objective_qzone_init, undefined, &cp_mi_sing_blackstation_qzone::objective_qzone_done );
	skipto::add( "objective_warlord_igc", &cp_mi_sing_blackstation_qzone::objective_warlord_igc_init, undefined, &cp_mi_sing_blackstation_qzone::objective_warlord_igc_done );
	skipto::add( "objective_warlord", &cp_mi_sing_blackstation_qzone::objective_warlord_init, undefined, &cp_mi_sing_blackstation_qzone::objective_warlord_done );
	skipto::add( "objective_anchor_intro", &cp_mi_sing_blackstation_port::anchor_intro, undefined, &cp_mi_sing_blackstation_port::anchor_intro_done );
	skipto::add( "objective_port_assault", &cp_mi_sing_blackstation_port::port_assault,	undefined, &cp_mi_sing_blackstation_port::port_assault_done );
	skipto::add( "objective_barge_assault", &cp_mi_sing_blackstation_port::barge_assault, undefined, &cp_mi_sing_blackstation_port::barge_assault_done );	
	skipto::add( "objective_storm_surge", &cp_mi_sing_blackstation_port::storm_surge, undefined, &cp_mi_sing_blackstation_port::storm_surge_done );
	skipto::add( "objective_subway", &objective_subway_init, undefined, &objective_subway_done );
	skipto::add( "objective_police_station", &objective_police_station_init, undefined, &objective_police_station_done );
	skipto::add( "objective_kane_intro", &cp_mi_sing_blackstation_police_station::objective_kane_intro_init, undefined, &cp_mi_sing_blackstation_police_station::objective_kane_intro_done );
	skipto::add( "objective_comm_relay_traverse", &cp_mi_sing_blackstation_comm_relay::objective_comm_relay_traverse_init, undefined, &cp_mi_sing_blackstation_comm_relay::objective_comm_relay_traverse_done );
	skipto::add( "objective_comm_relay", &cp_mi_sing_blackstation_comm_relay::objective_comm_relay_init, undefined, &cp_mi_sing_blackstation_comm_relay::objective_comm_relay_done );
	skipto::add( "objective_cross_debris", &cp_mi_sing_blackstation_cross_debris::objective_cross_debris_init, undefined, &cp_mi_sing_blackstation_cross_debris::objective_cross_debris_done );
	skipto::add( "objective_blackstation_exterior", &cp_mi_sing_blackstation_station::objective_blackstation_exterior_init, undefined, &cp_mi_sing_blackstation_station::objective_blackstation_exterior_done );
	skipto::add( "objective_blackstation_interior", &cp_mi_sing_blackstation_station::objective_blackstation_interior_init, undefined, &cp_mi_sing_blackstation_station::objective_blackstation_interior_done );
	skipto::add( "objective_end_igc", &cp_mi_sing_blackstation_station::objective_end_igc_init, undefined, &cp_mi_sing_blackstation_station::objective_end_igc_done );
}

function billboard()
{
	skipto::add_billboard( "objective_igc", "INTRO IGC", "IGC 1st Shared", "Small", "BLOCKOUT" );
	skipto::add_billboard( "objective_qzone", "Q-ZONE", "Pacing", "Small", "BLOCKOUT" );
	skipto::add_billboard( "objective_warlord_igc", "WARLORD INTRO", "IGC 3rd", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_warlord", "WARLORD FIGHT", "Combat", "Small", "BLOCKOUT" );
	skipto::add_billboard( "objective_anchor_intro", "DEBRIS TRAVERSAL", "Pacing", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_port_assault", "PORT ASSAULT", "Combat", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_barge_assault", "BARGE ASSAULT", "Combat", "Small", "BLOCKOUT" );	
	skipto::add_billboard( "objective_storm_surge", "STORM SURGE", "Combat", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_subway", "SUBWAY", "Pacing", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_police_station", "POLICE STATION", "Combat", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_kane_intro", "KANE INTRO", "IGC 3rd", "Small", "BLOCKOUT" );
	skipto::add_billboard( "objective_comm_relay_traverse", "COMM RELAY TRAVERSE", "Pacing", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_comm_relay", "COMM RELAY", "Combat", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_cross_debris", "CROSS DEBRIS", "Pacing", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_blackstation_exterior", "BLACK STATION LOOTING", "Medium", "Small", "BLOCKOUT" );
	skipto::add_billboard( "objective_blackstation_interior", "BLACK STATION", "Combat", "Medium", "BLOCKOUT" );
	skipto::add_billboard( "objective_end_igc", "END IGC", "IGC 3rd", "Medium", "BLOCKOUT" );
}

function objective_subway_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_subway" );
	}
	
	level thread blackstation_utility::player_rain_intensity( "none" );
			
	cp_mi_sing_blackstation_subway::subway_main();
}

function objective_subway_done( str_objective, b_starting, b_direct, player )
{
	
}

function objective_police_station_init( str_objective, b_starting )
{
	if ( b_starting )
	{
		blackstation_utility::init_hendricks( "objective_police_station" );
	}
	
	level thread blackstation_utility::player_rain_intensity( "med" );
	
	cp_mi_sing_blackstation_police_station::police_station_main();
}

function objective_police_station_done( str_objective, b_starting, b_direct, player )
{
	
}


// END SKIPTO'S
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

function giveCustomLoadout( takeAllWeapons, alreadySpawned )
{
	//HACK - Anchor mechanic uses the same button as is used for secondary grenades.
	//For now, we are taking away secondary grenades so there are no issues
	self TakeWeapon( self.grenadetypesecondary );
}

function player_rain_fx()  //self = player
{
	self endon( "death" );
	
	switch( level.skipto_point )
	{
		case "objective_subway":
		case "objective_blackstation_interior":
		case "objective_end_igc":
			self thread blackstation_utility::player_rain_intensity( "none" );
			break;
			
		case "objective_igc":
		case "objective_qzone":
		case "objective_warlord_igc":
		case "objective_warlord":
			self thread blackstation_utility::player_rain_intensity( "light" );
			break;
			
		case "objective_anchor_intro":
		case "objective_port_assault":
		case "objective_police_station":
		case "objective_kane_intro":
		case "objective_comm_relay_traverse":
		case "objective_comm_relay":
		case "objective_blackstation_exterior":
			self thread blackstation_utility::player_rain_intensity( "med" );
			break;
			
		case "objective_barge_assault":
		case "objective_storm_surge":
		case "objective_cross_debris":
			self thread blackstation_utility::player_rain_intensity( "heavy" );
			break;
	}
}

function weather_setup()
{
	//run through all of the doorway triggers 
	a_trig_rain_outdoor = GetEntArray( "trig_rain_indoor", "targetname" );
	foreach( e_trig in a_trig_rain_outdoor )
	{
		e_trig thread monitor_outdoor_rain_doorways();
	}
}


//	Turn off rain indoors
function monitor_outdoor_rain_doorways()
{
	while ( 1 )
	{
		self waittill( "trigger", e_player );
		
		if ( ( isdefined( e_player.b_rain_on ) && e_player.b_rain_on ) )
		{
			e_player thread pause_rain_overlay( self );
		}
	}
}

function pause_rain_overlay( e_trig )
{
	self endon( "disconnect" );
	
	self.b_rain_on = false;
	self clientfield::set_to_player( "fullscreen_rain_fx", 0 );	

	util::wait_till_not_touching( e_trig, self );
	
	self.b_rain_on = true;
	self clientfield::set_to_player( "fullscreen_rain_fx", 1 );	
}
