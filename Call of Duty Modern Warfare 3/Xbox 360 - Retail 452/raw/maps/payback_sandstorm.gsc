#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\payback_util;
#include maps\payback_sandstorm_code;
#include maps\payback_env_code;
#include maps\payback_streets_const;
#include maps\_audio;

init_flags_sandstorm()
{
	//flag_init("sandstorm_sandbag_event_end");
	flag_init("start_blackout");
	flag_init("stop_blackout");
	flag_init("ai_heat_is_on");
	flag_init("ai_heat_is_off");
	flag_init("sandstorm_uaz1_vo_ready");
	flag_init("sandstorm_dead_ahead");
	flag_init("spawn_uaz1");
	flag_init("uaz_guys_dead");
	flag_init("blackout_flare_on");
	flag_init("contact_echo");
	flag_init("runners_shot");
	flag_init("sandstorm_runner_see_you");
	flag_init("sandstorm_in_alley");
	flag_init("enemies_right");
	flag_init("lookers_dead");
	flag_init("echo_vo");
	flag_init("sandstorm_end_runners2");
	flag_init("price_at_end_runners");
	flag_init("end_runners_fight");
	flag_init("end_runners_dead");
	flag_init("lighten_sandstorm");
}


lighten_sandstorm()
{
	level endon("death");
	level endon("end_sandstorm");
	
	trigs = GetEntArray("sandstorm_lightener", "script_noteworthy");
	
	while(true)
	{
		flag_wait("lighten_sandstorm");
		//IPrintLnBold( "lighten sandstorm" );

		
		lighten_to = 0.75; // 75% of max particles 
		
		foreach (trig in trigs)
		{
			if (all_players_istouching(trig))
			{
				if (IsDefined(trig.script_parameter))
				{
					lighten_to = trig.script_parameter;
				}
				break;
			}
		}
		
		new_rate = level.sandstormSpawnrate / lighten_to;
		set_sandstorm_spawnrate(new_rate);	

		flag_waitopen("lighten_sandstorm");
		//IPrintLnBold( "un-lighten sandstorm" );
		set_sandstorm_spawnrate();  // reset to appropriate value
	}
}
	
try_activate(trigger)
{
	if (IsDefined(trigger) && !IsDefined(trigger.trigger_off))
	{
		trigger activate_trigger();
	}
}
activate_one_trigger(trigger_name)
// for when there's more than one trigger with the same name
{
	ents = GetEntArray(trigger_name, "targetname");
	try_activate(ents[0]);
}

init_sandstorm_assets()
{
	setup_vehicle_light_types();
//	PreCacheModel( "com_blackhawk_spotlight_on_mg_setup" );
	//PreCacheModel( "mil_sandbag_desert_single_flat" );
	PreCacheTurret( "heli_spotlight" );
	PreCacheItem( "rpg_straight" );
}

setup_vehicle_light_types()
{
	//kill_lights(lightmodel);
	// Car 1
	lightmodel = get_light_model( "vehicle_uaz_fabric" , "script_vehicle_uaz_fabric" );
	build_light( lightmodel , "headlight_right", "TAG_LIGHT_RIGHT_FRONT", "maps/payback/payback_headlights_l", 	"headlights" , 0.2 );
	build_light( lightmodel , "headlight_left", "TAG_LIGHT_LEFT_FRONT", "maps/payback/payback_headlights_l", 	"headlights" , 0.2 );
	build_light( lightmodel , "taillight_right", "TAG_LIGHT_RIGHT_TAIL", "misc/car_taillight_uaz_pb", 	"headlights" , 0.2 );
	build_light( lightmodel , "taillight_left", "TAG_LIGHT_LEFT_TAIL", "misc/car_taillight_uaz_pb", 	"headlights" , 0.2 );

	// car behind gate

	technical_lightmodels = [];
	technical_lightmodels[0] = get_light_model( "vehicle_vehicle_pickup_technical_pb_rusted" , "script_vehicle_pickup_technical_payback" );
	technical_lightmodels[1] = get_light_model( "vehicle_vehicle_pickup_technical_pb_rusted" , "script_vehicle_pickup_technical_payback_physics" );
	technical_lightmodels[2] = get_light_model( "vehicle_vehicle_pickup_technical_pb_rusted" , "script_vehicle_pickup_technical_payback_instant_death" );

	foreach( lightmodel in technical_lightmodels )
	{
		//get_light_model(vehicle_vehicle_pickup_technical_pb_rusted)
		build_light( lightmodel, "headlight_truck_left", "tag_headlight_left",	"maps/payback/payback_headlights_l_sq", "headlights" );
		build_light( lightmodel, "headlight_truck_right", "tag_headlight_right", "maps/payback/payback_headlights_r_sq", "headlights" );
		build_light( lightmodel, "parkinglight_truck_left_f", 	"tag_parkinglight_left_f", 	"misc/blank", 	"headlights" );
		build_light( lightmodel, "parkinglight_truck_right_f", 	"tag_parkinglight_right_f", "misc/blank", 	"headlights" );
		build_light( lightmodel, "taillight_truck_right", 	 	"tag_taillight_right", 		"misc/car_taillight_truck_R_pb", 		"headlights" );
		build_light( lightmodel, "taillight_truck_left", 		 "tag_taillight_left", 	"misc/car_taillight_truck_L_pb", 		"headlights" );
		build_light( lightmodel, "brakelight_truck_right", 		"tag_taillight_right", 		"misc/car_brakelight_truck_R_pb", 		"brakelights" );
		build_light( lightmodel, "brakelight_truck_left", 		"tag_taillight_left", 		"misc/car_brakelight_truck_L_pb", 		"brakelights" );
	}
}

setup_vehicle_inview_lights()
{
	wait(.2);
	// replace light models for inview (Transition in the effect)
	lightmodel = get_light_model( "vehicle_jeep_rubicon" , "script_vehicle_jeep_rubicon_payback" );
	level.rescue_jeep_a thread lights_off_internal();
	level.rescue_jeep_b lights_off_internal();

	build_light( lightmodel , "headlight_truck_right", "tag_headlight_right", "maps/payback/payback_headlights_view", 	"headlights" );
	build_light( lightmodel , "headlight_truck_left", "tag_headlight_left", "maps/payback/payback_headlights_view", 	"headlights" );

	level.rescue_jeep_a lights_on_internal();
	level.rescue_jeep_b lights_on_internal();
	//build_light( lightmodel , "taillight_truck_right", "tag_brakelight_right", "misc/car_taillight_uaz_pb", 	"headlights" );
	//build_light( lightmodel , "taillight_truck_left", "tag_brakelight_left", "misc/car_taillight_uaz_pb", 	"headlights" );

}

start_sandstorm()
{

	// AUDIO: jump/checkpoints
	aud_send_msg("s2_sandstorm");
	exploder(6000);
	thread post_rappel_light();
	chopper_init_fog_brushes();
	
	sslight_01 = GetEnt( "sslight_01" , "targetname" );
	sslight_01 SetLightIntensity( 7 );
		
	street_light_gate = GetEnt( "street_light_gate" , "targetname" );
	street_light_gate SetLightIntensity( 3 );

	level.start_point = "s2_sandstorm"; // for my test level
	
	kill_triggers = getEntArray( "strconst_fallkill" , "targetname" );
	array_thread( kill_triggers , ::trigger_off );
	
	//level.debug_no_sandstorm = true;
	//level.debug_no_heroes = true;
			
	//move player to sandstorm start
	move_player_to_start();
	if ( !debug_no_heroes() )
	{
		level.price = spawn_ally( "price" );
		level.soap = spawn_ally( "soap" );
	}
	
	init_sandstorm_env_effects("s2_sandstorm");
	
	thread set_sandstorm_level( "extreme" , 0.051 ); // .05 is smallest allowed
	
	level.chopper_fog_brushes = GetEntArray( "chopper_fog_brush", "targetname" );
	foreach ( brush in level.chopper_fog_brushes )
	{
		brush Hide();
        brush NotSolid();
	}

	objective_state( obj( "obj_kruger" ) , "done" );
	objective_state( obj( "obj_secondary_lz" ), "done");
	objective_state( obj( "obj_find_chopper" ), "current");

//	delayThread(1, maps\payback_streets_const::post_rappel_gate_open);
	
	thread sandstorm();
	
	wait 1;
	
	// mock up of end of rappel scene for jumpto:
	maps\payback_streets_const::post_rappel_gate_open();
	// get allies going
	activate_one_trigger("allies_into_sandstorm");
	level.price thread dialogue_queue("payback_pri_cmonlads");  
	wait 2;
	activate_one_trigger("soap_into_sandstorm");
}
/*
// should be called after sandstorm, if line patrol is removed
post_sandstorm_cleanup()
{
	if ( !debug_no_heroes() )
	{
		level.soap restore_original_sight_values();
		level.price restore_original_sight_values();
		level.soap disable_cqbwalk();
		level.price disable_cqbwalk();
	}
//	sandstorm_stealth_off();
	battlechatter_on( "allies" );
}
*/	
sandstorm()
{
	// Delete the compound exit vista
	GetEnt("compoundexit_vista", "targetname") Delete();
	
	thread lighten_sandstorm();
	thread sandstorm_contact_echo_vo();
	level.shot_uaz1 = false;
	// AUDIO: natural progression
	aud_send_msg("s2_sandstorm");
	aud_send_msg("sandstorm_start");
	
	sandstorm_skybox_show();
	
	maps\_compass::setupMiniMap("compass_map_payback_sandstorm","sandstorm_minimap_corner");
	
	//thread sandstorm_initial_dialog();
	//thread pole_thread();
	//thread sandstorm_chase_guys();
	//thread sandstorm_vo();
	if (!is_specialop())
	{
		maps\payback_fx_sp::setup_sandstorm_replacement_fx();
	}
	flag_wait( "sandstorm_script_trigger" );
	autosave_by_name( "save_sandstorm" );
	/#
	if ( !debug_no_heroes() )
	{
		//thread price_distance_monitor();
	}
	#/
	
	SetSunFlarePosition(( -29, 313.993, 0 ));
	
	battlechatter_off( "allies" );
	
	thread uaz1_handler();
	
	/*
	for ( i = 1 ; i <= 3 ; i++ )
	{
		thread sandstorm_tinroof_listener( i );
	}
	*/
	thread ambient_pickups();
	thread sandstorm_blackout();
	thread watertower_thread( "sandstorm_water_tower" , "sandstorm_watertower_event" );
	thread marketstall_thread( "sandstorm_market_stall" );
	thread scaffold_thread();
//	thread wallfall_thread();
	thread moroccan_lamp_thread_2();	
	
//	thread price_sandstorm_enemy_alert_vo( "ai_heat_is_off" );
	
	SetSavedDvar( "objectiveFadeTooFar", 5 ); // keep it on until really close for sandstorm
	if ( !debug_no_heroes() )
	{
		Objective_OnEntity( obj( "obj_find_chopper" ), level.price , (0,0,50) );
		Objective_SetPointerTextOverride( obj( "obj_find_chopper" ) , "" );
		level.price enable_pain();
		level.price.ignoreall = false;
		level.soap.ignoreall = false;
		level.price.baseAccuracy = 2.0;
		level.soap.baseAccuracy = 2.0;
	}

	thread sandstorm_price_leading_tracker();
	flag_wait( "sandstorm_intro_disable_color_end_triggers" );
/*
	sandstorm_technical = spawn_vehicle_from_targetname_and_drive( "sandstorm_patrol_technical" );
	sandstorm_technical thread handle_vehicle_lights();
	sandstorm_technical thread setup_spotlight( sandstorm_technical , "tag_50cal" , "sandstorm_spotlight_target" );
	sandstorm_technical thread sandstorm_patrol_technical_lights_off_handler();
*/	
//	thread radio_dialogue( "payback_pri_wevelostem_r" );
	
//	thread sandstorm_ally_passive_active_handler();
	thread sandstorm_enemy_battlechatter();
	thread sandstorm_runners_thread();
		
	level thread sandstorm_next_section_wait();
	
	flag_wait( "heat_is_off" );
	if ( !debug_no_heroes() )
	{
		level.soap disable_cqbwalk();
		level.price disable_cqbwalk();
		level.price.moveplaybackrate = 1.0;
		level.soap.moveplaybackrate = 1.0;
		objective_state( obj ( "follow" ) , "invisible" );
	}		
}

sandstorm_blackout()
{
	flag_wait("start_blackout");

	thread radio_dialogue( "payback_mct_cantsee_r" );
	
	thread set_sandstorm_level( "blackout" , 5 );
	
	delayThread(30, ::flag_set, "stop_blackout");  // blackout should only last so long
	
	//spawn flare guys
	guys = array_spawn_targetname_allow_fail("flare_guy");

	allguys = array_combine(level.uaz_riders, guys);
	thread 	sandstorm_move_to_alley(allguys);

	thread uaz_guys_on(guys);
	array_thread(guys, ::setup_sandstorm_guy);
	array_thread(guys, ::wait_till_shot);
	flare_guy = guys[0];
	foreach (guy in guys)
	{
		guy.ignoreall = true;
		guy disable_ai_color();
		guy.pathrandompercent = 0;
		guy.moveplaybackrate = 1;
		guy.goalradius = 8;
		guy.walkdist = 0;
		guy.disablearrivals = true;

		if (IsDefined(guy.script_noteworthy) && guy.script_noteworthy == "the_flare_guy")
		{
			flare_guy = guy;
			// make him stay in the fight zone from the start
			fight_zone = GetEnt("uaz_fight_volume", "targetname");
			struct = GetStruct("sstorm_flare_anim", "targetname");
			guy setGoalPos(struct.origin);
			guy setgoalvolume(fight_zone);
		}
		else
		{
			level.not_flare_guy = guy;
		}
	}
	thread flare_notify(flare_guy);
	flag_wait("stop_blackout");
	wait 1.5;
	//thread set_sandstorm_level( "extreme" , 10 ); 
}

flare_notify(flare_guy)
{
	flare_guy endon("death");
	flare_guy set_run_anim("payback_pmc_sandstorm_stumble_2");
//	flare_struct = GetStruct("sstorm_flare_anim", "targetname");
//	flare_struct anim_generic_reach(flare_guy, "deploy_flare");
//	flare_struct thread anim_generic(flare_guy, "deploy_flare");

	flare_guy thread anim_generic(flare_guy, "deploy_flare");

	flare_light = GetEnt("sand_flare_01", "targetname");
	waitframe();
   	level.blackout_flare = Spawn( "script_model", flare_guy.origin );
    level.blackout_flare.owner = flare_guy;
    level.blackout_flare SetModel( "mil_emergency_flare" );
    level.blackout_flare LinkTo( flare_guy, "TAG_INHAND", (0,0,0), (0,0,0) );
	playfxontag( getfx( "flare_ambient" ), level.blackout_flare, "TAG_ORIGIN" );
	flare_light thread manual_linkto( level.blackout_flare );
	flare_guy thread detach_flare_on_death();
	aud_send_msg("flare_audio_start", flare_guy.origin);
		
	flare_guy waittillmatch("single anim", "end" );
	
	flag_set("blackout_flare_on");
		
	level.blackout_flare Unlink();
}

detach_flare_on_death()
{
    self addAIEventListener( "death" );
    self addAIEventListener( "projectile_impact" );
    self waittill( "ai_event", eventtype );
    
    flare_drop_pos = groundpos(level.blackout_flare.origin);
	level.blackout_flare Unlink();
	level.blackout_flare moveto(flare_drop_pos, 0.5, 0.05, 0);
	
}


setup_sandstorm_guy()
{
	self.ignoreall = true;			
	self.baseaccuracy = 0.25;
	
	self.animname = "generic";
	switch(RandomInt(3))
	{
		case 0: self set_run_anim( "payback_pmc_sandstorm_stumble_1" ); break;
		case 1: self set_run_anim( "payback_pmc_sandstorm_stumble_2" ); break;
		case 2: self set_run_anim( "payback_pmc_sandstorm_stumble_3" ); break;
	}
}

//sandstorm_initial_dialog()
//{
//	radio_dialogue( "payback_eol_foundnikolai" ); // Captain Price, we’ve found Nikolai - sending his location to you now.
//	radio_dialogue( "payback_eol_newexfil" ); // We'll have transport ready at the new exfil point.	
//}

ambient_pickups()
{
	pickups = getEntArray( "sandstorm_amb_pickup" , "targetname" );
	array_thread( pickups , ::vehicle_lights_on );
}
/*
sandstorm_chase_guys()
{
	phantom_fire_source = getstructarray( "sandstorm_phantom_pressure_fire" , "targetname" );
	thread phantom_pressure( level.player, "ak47", phantom_fire_source, 0.01, 0.05, 3000, 5000, 0.9 );
	
	thread radio_dialogue( "payback_mct_gogogo2_r" );
	
	if ( !debug_no_heroes() )
	{
		level.price thread sandstorm_hero_retreat();
		level.soap thread sandstorm_hero_retreat();
	}
	
	wait 5;
	if ( !debug_no_heroes() )
	{
		level.price thread sandstorm_hero_end_retreat();
		level.soap thread sandstorm_hero_end_retreat();
	}
	sandstorm_allies_sprint();
	flag_wait( "sandstorm_intro_stop_pressure" );

	level notify( "phantom_pressure" );
	
	sandstorm_stealth_on();
	exploder( "sandstorm_blown_debris_1" );
}

sandstorm_hero_retreat()
{
	wait .25;
	aimpoint = getStruct( "sandstorm_retreat_shootatpos" , "targetname" );
	self disable_pain();
	self OrientMode( "face point" , aimpoint.origin );
	//self.moveLoopOverrideFunc = ::sandstorm_run_backwards;
	//self.shootPosOverride = aimpoint.origin;
	self.alertLevelInt = 2;
}

sandstorm_hero_end_retreat()
{
	self.shootPosOverride = undefined;
	self.ignoreall = true;
	self OrientMode( "face default" );
	self.ignoreall = false;
	self.moveLoopOverrideFunc = undefined;
	self clear_run_anim();
	self.alertLevelInt = 1;
}

sandstorm_run_backwards()
{
	self animscripts\run::runShootWhileMovingThreads();
	self animscripts\run::RunNGun_Backward();
}
*/

sandstorm_allies_sprint()
{
	if ( !debug_no_heroes() )
	{
		level.price disable_cqbwalk();
		level.soap disable_cqbwalk();
		//level.price enable_sprint();
		//level.soap enable_sprint();
		level.price.moveplaybackrate = 1.0;
		level.soap.moveplaybackrate = 1.0;
	}
}

sandstorm_allies_cqb()
{
	if ( !debug_no_heroes() )
	{
//		level.price disable_sprint();
//		level.soap disable_sprint();
		level.price enable_cqbwalk();
		level.soap enable_cqbwalk();
		level.price.moveplaybackrate = 1.1;
		level.soap.moveplaybackrate = 1.1;
	}
}

sandstorm_ally_needs_to_catch_up()
{
	to_player = ( level.player.origin - self.origin );
	to_player_dist = Length( to_player );
	// reasonably close to player
	if ( to_player_dist < 600 )
	{
		return false;		
	}
	to_player = VectorNormalize( to_player );
	to_goal = VectorNormalize( self.goalpos - self.origin );
	// we goal is on opposite side of player, assume we are leading the player
	dot = VectorDot( to_goal , to_player );
	if ( dot < -0.5 )
	{
		return false;	
	}
	return true;
}

sandstorm_price_leading_tracker()
{
	level.player endon( "death" );
	price_is_sprinting = false;
	
	if ( debug_no_heroes() )
	{
		return; 
	}
	
	while ( 1 )
	{
		if ( price_is_sprinting )
		{
			if ( !(level.price sandstorm_ally_needs_to_catch_up() ))
		    {
				sandstorm_allies_cqb();
				price_is_sprinting = false;
		    }
		}
		else 
		{
			if ( level.price sandstorm_ally_needs_to_catch_up() )
			{
				sandstorm_allies_sprint();
				price_is_sprinting = true;
			}
		}
		wait 1;	
	}
}

sandstorm_runners_thread()
{
	level endon( "sandstorm_section_end" );
	
	flag_wait( "sandstorm_runners" );
	thread sandstorm_window_lookers();
	thread sandstorm_end_runners2();
	thread vo_echo_team_reports_in();
	
	clear_vol = getEnt( "sandstorm_runners_clear_volume" , "targetname" );
	
	level.sandstorm_runners_in_volume = array_spawn_targetname( "sandstorm_runner" );
	thread sandstorm_runner_guys_handler(level.sandstorm_runners_in_volume);
	
	thread sandstorm_runner_vo();
	
	thread sandstorm_runner_clear_watch( clear_vol );
	thread sandstorm_runner_see_you();
	
	wait 2;
	while ( level.sandstorm_runners_in_volume.size > 0 )
	{
		index = RandomIntRange( 0 , level.sandstorm_runners_in_volume.size );
		enemy = level.sandstorm_runners_in_volume[index];
		if (IsDefined(enemy) && IsAlive(enemy))
		{
			enemy custom_battlechatter( "order_move_combat" );
			wait( RandomFloatRange( 0.1 , 0.3 ));
		}
		else
		{
			level.sandstorm_runners_in_volume = array_removeDead( level.sandstorm_runners_in_volume );
			wait 0.05;	
		}
	}
	
	autosave_by_name("runners_past");
	sandstorm_allies_cqb();
	activate_trigger("sandstorm_post_runsquad", "targetname");
	thread radio_dialogue( "payback_pri_moveout_r" );
}

sandstorm_runner_vo()
{
//	thread sandstorm_runner_runner_vo();
	vo_origin = GetStruct("sandstorm_runner_vo_spot", "targetname");
	play_sound_in_space("payback_mrc1_foundchopper", vo_origin.origin);
//	wait 1;
	radio_dialogue( "payback_pri_getdown_r" );
//	wait 0.5;
//	radio_dialogue( "payback_mct_cantbegood_r" );
//	wait 0.2;
	wait 1;
	radio_dialogue( "payback_pri_foundnikolai_r" );
//	wait 1;
	if (!flag("runners_shot"))
	{
		play_sound_in_space("payback_afm_keepsearching", vo_origin.origin);
	}
}

sandstorm_runner_runner_vo()
{
	vo_origin = GetStruct("sandstorm_runner_vo_spot", "targetname");
	
	play_sound_in_space("payback_mrc1_foundchopper", vo_origin.origin);

	wait 0.5;
	if (!flag("runners_shot"))
	{
		play_sound_in_space("payback_afm_keepsearching", vo_origin.origin);
	}
}


		
sandstorm_runner_see_you()
{
	flag_wait("sandstorm_runner_see_you");
	sandstorm_allies_cqb();
	
	foreach (guy in level.sandstorm_runners_in_volume)
	{
		if (IsDefined(guy) && IsAlive(guy))
		{
			level notify("runners_shot");

			guy.ignoreall = false;
			guy.ignoreme = false;
		}
	}
}

sandstorm_runner_guys_handler(guys)
{
	foreach (guy in guys)
	{
		if (IsDefined(guy.script_noteworthy))
		{
			goalnode = GetNode(guy.script_noteworthy, "targetname");
			if (IsDefined(goalnode))
			{
				guy.default_radius = guy.goalradius;
				guy set_goal_radius( goalnode.radius );
				guy SetGoalNode(goalnode);
			}
		}
		guy.ignoreall = true;
		guy.ignoreme = true;
		guy.baseaccuracy = 0.25;
		guy thread awake_on_shot();
		guy enable_sprint();
		if (RandomFloat(10) > 5)
		{
			guy maps\payback_sandstorm_code::flashlight_on_guy();			
		}
		guy thread remove_at_end(350);

	}
	
	level waittill("runners_shot");
	
	foreach(guy in guys)
	{
		if  (IsDefined(guy) && IsAlive(guy) 
		     && (DistanceSquared(guy.origin, level.player.origin) < 360000) || (RandomFloat(10) > 5 ) )
		{
			guy sandstorm_runners_fight();
		}
	}	

	// remove the blocker volume
//	block_vol = getEnt( "sandstorm_runner_blockpath" , "targetname" );
//	block_vol DisconnectPaths();
//	block_vol ConnectPaths();
//	block_vol delete();
}
	
sandstorm_runners_fight(who)
{
	self endon("death");
	
	self notify("fighting_time");
	wait 0.2;

	if (IsDefined(self) && IsAlive(self) )
	{
		if (!IsDefined(who))
		{
			wait RandomFloatRange(0.25, 1.0);
		}
		self.ignoreall = false;
		self.ignoreme = false;
		self set_goal_radius(self.default_radius);
		self disable_sprint();
		self.alertlevel = "combat";
	
		if (IsDefined(who))
		{
			self GetEnemyInfo(who);
		}
	
		self.baseaccuracy = 0.15;
	
		if (IsDefined(self) && IsAlive(self) )
		{
			self setgoalpos( self.origin );
		}
	
		
		fight_zone = GetEnt("fight_zone", "targetname");
		goalVolumeTarget = getNode( fight_zone.target , "targetname" );
	
		if ( IsDefined(self) && IsAlive(self) && self IsTouching(fight_zone) )
		{
			self SetGoalNode(goalVolumeTarget);
			self SetGoalVolume(fight_zone);
		}
	}
}

remove_at_end(safe_distance)
{
	self endon("death");
	self endon("fighting_time");

	wait 0.5;

	self waittill("goal");
	dist = DistanceSquared(self.origin, level.player.origin);
	
	if (dist > (safe_distance*safe_distance) && !raven_player_can_see_ai(self))
	{
		self Delete();
	}
	else
	{
		self notify("got_to_end");
		self.ignoreall = false;
		self.ignoreme = false;
		self GetEnemyInfo(level.player);
		self.alertlevel = "combat";
	}
}

awake_on_shot()
{
	self endon("death");
	self endon("got_to_end");

	self addAIEventListener( "grenade danger" );
    self addAIEventListener( "gunshot" );
    self addAIEventListener( "silenced_shot" );
    self addAIEventListener( "bulletwhizby" );
    self addAIEventListener( "projectile_impact" );

    self waittill( "ai_event", eventtype );

    self sandstorm_runners_fight(level.player);

	level notify("runners_shot");
	flag_set("runners_shot");
}


sandstorm_runner_clear_watch( volume )
{
	while ( level.sandstorm_runners_in_volume.size > 0 )
	{
		foreach( runner in level.sandstorm_runners_in_volume )
		{
			if ( !IsAlive( runner ) || !(runner IsTouching( volume )))
			{
				level.sandstorm_runners_in_volume = array_remove( level.sandstorm_runners_in_volume , runner );
			}
		}	
		wait 0.1;
	}
}
/*
sandstorm_patrol_technical_lights_off_handler()
{
	self endon( "death" );
	self waittill( "reached_end_node" );
	wait 2;
	self vehicle_lights_off( "all" );
	self notify( "stop_spotlight" );
}
*/
sandstorm_next_section_wait()
{
	flag_wait( "sandstorm_section_end" );	
	level notify( "sandstorm_section_end" );
	maps\payback_rescue::rescue_thread();
}
/*	
sandstorm_ally_passive_active_handler()
{
	level.sandstorm_allies_active = true;
	sandstorm_make_allies_passive();
	level.sandstorm_automatic_ally_passive_active = true;
	level.sandstorm_last_player_fire_time = 0;
	//level.sandtorm_ally_has_enemy = false;
	level thread player_firing_timer();
	//level thread ally_enemy_checker();
	while ( !flag( "sandstorm_section_end" ))
	{
		if ( level.sandstorm_automatic_ally_passive_active )
		{
			time_since_fire = GetTime() - level.sandstorm_last_player_fire_time;
			if ( time_since_fire < 1000 ) //|| level.sandtorm_ally_has_enemy )
			{
				sandstorm_make_allies_active();
			}
			else
			{
				sandstorm_make_allies_passive();
			}
		}
		wait .2;
	}
}
	
player_firing_timer()
{
	while ( !flag( "sandstorm_section_end" ))
	{
		level.player waittill( "begin_firing" );
		level.sandstorm_last_player_fire_time = GetTime();
		while ( level.player IsFiring() )
		{
			level.sandstorm_last_player_fire_time = GetTime();
			wait .1;
		}
	}
}
	
ally_enemy_checker()
{
	allies = GetAIArray( "allies" );
	while ( !flag( "sandstorm_section_end" ))
	{
		level.sandstorm_ally_has_enemy = false;
		foreach( ally in allies )
		{
			if ( IsDefined( ally.enemy ))
			{
				level.sandtorm_ally_has_enemy = true;
				break;				
			}
		}
		wait .05;
	}
}

sandstorm_tinroof_listener( num )
{
	level endon( "sandstorm_section_end" );
	// only play once, so end thread once somebody plays it
	level endon( "tinroof_ripped_off_played" );
	
	roof_flag = "payback_sstorm_tinroof" + num;
	flag_wait( roof_flag );
	roof_ents = getEntArray( roof_flag , "targetname" );
	for ( i = 0 ; i < roof_ents.size ; i++ )
	{
		if ( roof_ents[i].classname == "script_model" )
		{
			roof = roof_ents[i];
			roof thread tear_off_roof();
			level notify( "tinroof_ripped_off_played" );
		}
	}
}

tear_off_roof()
{
	aud_send_msg( "roof_tear" , self.origin );
	self.animname = "tinroof";
	self setanimtree();
	self anim_single_solo( self , "payback_sstorm_tinroof_enter_idle" );
	self anim_single_solo( self , "payback_sstorm_tinroof_tear" );
	self anim_single_solo( self , "payback_sstorm_tinroof_exit_idle" );
}
*/
sandstorm_enemy_battlechatter()
{
	level endon( "sandstorm_section_end" );
	level.player endon( "death" );
	
	while ( !flag( "sandstorm_section_end" ))
	{
		enemies = GetAIArray( "axis" );
		enemies = array_removeDead( enemies );
		if ( enemies.size > 0 )
		{
			index = RandomIntRange( 0 , enemies.size );
			enemy = enemies[index];
			enemy custom_battlechatter( "order_move_combat" );
		}
		wait( RandomFloatRange( 1.5 , 5.0 ));
	}
}

marketstall_thread( targetname )
{
	level endon( "sandstorm_section_end" );
	
	marketstall = getEnt( targetname , "targetname" );
	marketstall.animname = "marketstall";
	marketstall setanimtree();
	marketstall thread anim_loop_solo( marketstall , "payback_sstorm_market_stall_loop" , "end_market_stall_loop" );
	flag_wait( targetname + "_tear" );
	marketstall notify( "end_market_stall_loop" );
	aud_send_msg("sandstorm_market_tear", marketstall); // AUDIO
	thread market_explosion();
	marketstall anim_single_solo( marketstall , "payback_sstorm_market_stall_tear" );
	marketstall anim_single_solo( marketstall , "payback_sstorm_market_stall_exit" );
}

market_explosion()
{
	wait 1;
	physics_locs = getstructarray("wind_physics", "targetname");
	force = 0.25;
	foreach (loc in physics_locs)
	{
		PhysicsExplosionSphere(loc.origin, 50, 40, force);
		wait randomfloatrange(0.15, 0.35);
		force = force + 0.5;
		
	}
}

watertower_thread( modelname , locname )
{
	level endon( "sandstorm_section_end" );
	
	animloc = getStruct( locname , "targetname" );
	tower = getEnt( modelname , "targetname" );
	tower.animname = "watertower";
	tower setanimtree();
	animloc thread anim_loop_solo( tower , "payback_sstorm_water_tower_idle" , "end_water_tower" );
	flag_wait( locname + "_fall" );
	animloc notify( "end_water_tower" );
	aud_send_msg("sandstorm_watertower_fall", tower); // AUDIO
	animloc anim_single_solo( tower , "payback_sstorm_water_tower_fall" );
}

scaffold_thread()
{
	level endon( "sandstorm_section_end" );
	
	flag_wait( "sandstorm_scaffold_fall" );
	anim_start = GetStruct("sandstorm_construction_anim_origin","targetname");
	scaffold = GetEnt("sandstorm_scaffolding_collapse","targetname");
	scaffold.animname = "payback_scaffolding_collapse";
	scaffold useAnimTree( level.scr_animtree[ scaffold.animname ] );
	aud_send_msg("payback_scaffolding_collapse", scaffold);
	anim_start thread anim_single_solo(scaffold, "payback_scaffolding_collapse");
	
}

/*
wallfall_thread()
{
	level endon( "sandstorm_section_end" );
	
	wall_rig = GetEnt( "sandstorm_wallfall_rig" , "targetname" );
	wall_rig.animname = "payback_sstorm_wall";
	wall_rig useAnimTree( level.scr_animtree[ wall_rig.animname ] );
	wall_rig attach( "payback_sstorm_wall_fall" , "J_prop_1" );
	
	flag_wait( "sandstorm_wallfall" );
	
	thread radio_dialogue( "payback_mct_aboveus_r" );
	wall_rig thread anim_single_solo(wall_rig, "payback_sstorm_wall_fall");
	aud_send_msg("wall_collapse", wall_rig.origin);
	wall_wait_time = 1.0;
	wait wall_wait_time;
	Earthquake( 0.7, 1.0, wall_rig.origin, 2000 );
}

pole_thread()
{
	level endon( "sandstorm_section_end" );
	
	wait 2;
	pole_objects = GetEntArray( "sandstorm_fall_pole" , "targetname" );
	pole_pivot = GetEnt( "sandstorm_fall_pole_pivot" , "targetname" );
	foreach ( pole_obj in pole_objects )
	{
		pole_obj LinkTo( pole_pivot , "J_prop_1" );
	}
	pole_pivot RotateRoll( 90 , 1.5 );
	wait 1.5;
	exploder( "sandstorm_polefall" );
}
*/
moroccan_lamp_thread()
{
	level endon( "sandstorm_section_end" );
	
	level.sandstorm_swinging_lamps = GetEntArray( "sandstorm_swinging_lamps" , "targetname" );
	foreach ( lamp in level.sandstorm_swinging_lamps )
	{
		lamp.animname = "moroccan_lamp";
		lamp SetAnimTree();
		lamp thread anim_loop_solo( lamp , "wind_heavy" , "end_lamp_swing" );
		PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp , "tag_light" );
		wait RandomFloatRange( 0.1 , 0.25 );
	}
	/*
 	flag_wait( "rescue_nikolai_disable_weapons" ); // TODO: sooner based on when it is supposed to be
	foreach( lamp in level.sandstorm_swinging_lamps )
	{
		lamp notify( "end_lamp_swing" );
		StopFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp , "tag_light" );
	}
	*/
}

// TO USE THIS CODE: replace all script_model's with targetname sandstorm_swinging_lamps with prefab:
// prefabs/payback/misc/moroccan_lamp_primary_light_style.map
// also change level._effect[ "lights_point_white_payback" ] to loadfx("misc/light_glow_white_payback" );
moroccan_lamp_thread_2()
{
	level endon( "sandstorm_section_end" );
	
	level.sandstorm_swinging_lamps = GetEntArray( "sandstorm_swinging_lamps" , "targetname" );
	foreach ( lamp in level.sandstorm_swinging_lamps )
	{
		if (IsDefined(lamp.target))
		{
			lamp.animname = "moroccan_lamp";
			lamp SetAnimTree();
			lamp thread anim_loop_solo( lamp , "wind_heavy" , "end_lamp_swing" );
			
			light = getEnt( lamp.target , "targetname" );
			linkent = spawn_tag_origin();
			linkent LinkTo( lamp, "tag_light", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			light thread manual_linkto( linkent );
			//PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , linkent, "tag_origin" );
			PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp, "tag_light" );
			wait RandomFloatRange( 0.1 , 0.25 );
		}
	}
	/*
 	flag_wait( "rescue_nikolai_disable_weapons" ); // TODO: sooner based on when it is supposed to be
	foreach( lamp in level.sandstorm_swinging_lamps )
	{
		lamp notify( "end_lamp_swing" );
		StopFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp , "tag_light" );
	}
	*/
}

//sandstorm_vo()
//{
//	if ( !debug_no_heroes() )
//	{
//		block_vol = getEnt( "sstorm_entrance_gate" , "targetname" );
//		block_vol Solid();
//
//		// "Nikolai - do you copy?!!?  NIKOLAI?!!"
//		level.price dialogue_queue( "payback_pri_nikolaicopy" );
//	
//		wait 0.25;
//		
//		// "Baseplate, Nikolai’s bird is down in the city."
//		radio_dialogue( "payback_pri_downincity" );
//	
//		wait 0.25;
//		
//		// "Solid copy. We’ve lost him. Do you have a visual of the crash site?"
//		radio_dialogue( "payback_eol_visualoncrash" );
//	
//		wait 0.25;
//		
//		// "Negative. The sandstorm is on top of us."
//		radio_dialogue( "payback_pri_negativesandstorm" );
//		
//		wait 0.5;
//		block_vol ConnectPaths();
//		block_vol delete();
//		activate_one_trigger("allies_into_sandstorm");
//		
//		// "We need to get to the crash site and find Nikolai."
//		level.price dialogue_queue( "payback_pri_gettocrashsite" );
//		/*
//		wait 0.5;
//		
//		// "North of our location!  Move quick - he'll have the whole army moving down on top of him."
//		level.price dialogue_queue( "payback_pri_wholearmy" );
//	
//		wait 0.5;
//		
//		// "Roger that."
//		radio_dialogue( "payback_eol_rogerthat" );
//	
//		wait 1;
//		
//		// "Let's go.  We'll have to reach Nikolai before Kruger's men do."
//		level.price dialogue_queue( "payback_pri_reachnikolai" );
//	
//		wait 0.5;
//		
//		// "They won't see us coming in this storm."
//		level.soap dialogue_queue( "payback_mct_wontseeus" );
//	
//		wait 0.5;
//		
//		// "That's what I'm counting on."
//		level.price dialogue_queue( "payback_pri_countingon" );
//		*/
//		flag_wait( "start_blackout" );
//		wait 2;
//		radio_dialogue( "payback_mct_cantsee_r" );
////		radio_dialogue("payback_pri_slowsteady_r");
//		//flag_wait( "sandstorm_technical_advance" );
//		//thread radio_dialogue( "payback_pri_yourlocation_r" );
/*		
		flag_wait( "sandstorm_vo_nikolai_awake" );
		thread radio_dialogue( "payback_pri_yourlocation_r" );
		wait 1;
		thread radio_dialogue( "payback_nik_keyradio_r" );
		wait 1.5;
		thread radio_dialogue( "payback_pri_keyingmic_r" );
	
		flag_wait( "sandstorm_vo_nikolai_trouble" );
		thread radio_dialogue( "payback_eol_deploying_r" );

 */
//	}
//}

/*
 *  TODO: Use these lines
	north_lines[0] = "payback_pri_cantsee_r";
	north_lines[1] = "payback_pri_visibilityzero_r";
	north_lines[2] = "payback_mct_blindouthere_r";
	north_lines[3] = "payback_mct_gotnothing_r";
	north_lines[4] = "payback_pri_headnorth_r";
*/


uaz1_handler( evt_info , trigger )
{
	level endon( "sandstorm_section_end" );
	flag_wait("spawn_uaz1");
	
	uaz = spawn_vehicle_from_targetname_and_drive( "uaz1" );
	uaz thread handle_vehicle_lights();
	uaz thread uaz1_vo_handler();

	level.blackout_shots_fired = false;
	
	uaz thread init_uaz_riders();
	
//	uaz thread uaz1_unload_guys();
	uaz waittill( "damage" , amount , who );
	level.shot_uaz1 = true;
	
	if ( who == level.player )
	{
		uaz Vehicle_SetSpeed( 0, 35 );
		uaz_ai = uaz vehicle_unload();
		foreach( ai in uaz_ai )
		{
			ai.ignoreme = false;
			ai.ignoreall = false;			
			ai GetEnemyInfo(who);
			ai.baseaccuracy = 0.25;
		}
	}
}

init_uaz_riders()
{
	wait 0.25;
	level.uaz_riders = self.riders;
	
	foreach (guy in level.uaz_riders)
	{
		if (IsDefined(guy) && IsAlive(guy))
		{
			guy.ignoreall = true;
			guy disable_ai_color();
			guy.pathrandompercent = 0;
			guy.moveplaybackrate = 1;
			guy.goalradius = 8;
			guy.walkdist = 0;
			guy.disablearrivals = true;
		
			guy.animname = "generic";
			switch(RandomInt(3))
			{
				case 0: guy set_run_anim( "payback_pmc_sandstorm_stumble_1" ); break;
				case 1: guy set_run_anim( "payback_pmc_sandstorm_stumble_2" ); break;
				case 2: guy set_run_anim( "payback_pmc_sandstorm_stumble_3" ); break;
			}
			
			guy thread sandstorm_uaz_unload();
			guy thread wait_till_shot();
		}
	}
		
	self waittill( "reached_end_node" );
	
	thread uaz_guys_on(level.uaz_riders);
	
}
/*
uaz1_unload_guys()
{	
	wait 0.3;
	level.uaz_riders = self.riders;
	foreach (guy in level.uaz_riders)
	{
		if (IsDefined(guy) && IsAlive(guy))
		{
			guy.animname = "generic";
			switch(RandomInt(3))
			{
				case 0: guy set_run_anim( "payback_pmc_sandstorm_stumble_1" ); break;
				case 1: guy set_run_anim( "payback_pmc_sandstorm_stumble_2" ); break;
				case 2: guy set_run_anim( "payback_pmc_sandstorm_stumble_3" ); break;
			}
			guy thread sandstorm_uaz_unload();
		}
	}
		
	self waittill( "reached_end_node" );
	
	thread uaz_guys_on(level.uaz_riders);
}
*/
sandstorm_uaz_unload()
{
	self endon("death");
	// when the uaz reaches the end of the path
	node = GetNode(self.script_noteworthy, "targetname");
	
	self waittill("jumpedout");

	if (level.shot_uaz1)
	{
		// always put flashlights on guys when the player shoots the jeep
		self.ignoreall = false;
		
		self maps\payback_sandstorm_code::flashlight_on_guy();	
	}
	else
	{
		// make guys walk to front of car if uaz went all the way
		self.goalradius = 8;
		self SetGoalNode(node);
//		self.movespeedscale = 0.25;
		
		self waittill("goal");
		
		if (IsAlive(self) && !level.blackout_shots_fired)
		{
			self anim_generic(self, self.animation);
		}
	}

}

wait_till_shot()
{
	level endon("uaz1_guys_fighting");
	
	self addAIEventListener( "grenade danger" );
    self addAIEventListener( "gunshot" );
    self addAIEventListener( "silenced_shot" );
    self addAIEventListener( "bulletwhizby" );
    self addAIEventListener( "projectile_impact" );

    self waittill( "ai_event", eventtype );
	
	level.blackout_shots_fired = true;
	self StopAnimScripted();
	self clear_run_anim();
	self SetGoalPos(self.origin);
	self.ignoreall = false;
	self.ignoreme = false;
	self.baseaccuracy = 0.25;
	wait 0.1;
	fight_zone = GetEnt("uaz_fight_volume", "targetname");
	struct = GetStruct("sstorm_flare_anim", "targetname");
	self setGoalPos(struct.origin);
	self setgoalvolume(fight_zone);
	level notify("uaz1_guys_fighting");
}

uaz_guys_on(guys)
{
	level waittill("uaz1_guys_fighting");
	
	foreach (guy in guys)
	{
		if (IsDefined(guy) && IsAlive(guy))
		{
			guy stopanimscripted();
			guy OrientMode("face default");
			guy enable_ai_color();
			guy.ignoreall = false;
			self.goalradius = 200;
			guy.baseaccuracy = 0.15;
			guy.alertlevel = "combat";
		}
	}
}
	

sandstorm_move_to_alley(guys)
{
	// move allies up after combat
	
	if (guys.size > 0)
	{
		thread ai_array_killcount_flag_set(guys, guys.size, "uaz_guys_dead");
		flag_wait("uaz_guys_dead");
	}
	else
	{
		flag_set("uaz_guys_dead");
	}
	
	// allies move up
	activate_one_trigger("sandstorm_move_to_alley");

	// also make blackout end after combat is over
	wait 2;
	flag_set("stop_blackout");
}


uaz1_vo_handler()
{
	flag_wait( "sandstorm_uaz1_vo_ready" );
	autosave_by_name_silent("see_jeep");
	sandstorm_allies_cqb();
	trig = GetEnt("sandstorm_intro_after_vehicle", "targetname");
	
/*	
	if (!IsDefined(trig.activated_color_trigger))
	{
		trig.activated_color_trigger = false;
	}
	
	if (trig.activated_color_trigger == false)
	{
		level.price thread anim_generic( level.price, "signal_stop_cqb" );
	}
*/
	thread radio_dialogue( "payback_pri_vehiclecoming_r" );
	
//	while( (level.price getanimtime( getgenericanim( "signal_stop_cqb" ) ) < 0.5) && (!IsDefined(trig.activated_color_trigger) || trig.activated_color_trigger == false) )
//		wait( 0.05 );
	
//	level.price StopAnimScripted();
	
	// automatically proceed
	try_activate(trig);
	//trig activate_trigger();
//	thread sandstorm_melee_event();
	thread blackout_vo();
}

blackout_takedown_vo()
{
	flag_wait("blackout_flare_on");
	level.price dialogue_queue("payback_pri_takeemout");
	wait 0.5;
	blackout_soap_price_fight();
}

blackout_soap_price_fight()
{
	level.soap.baseaccuracy = 10;
	level.price.baseaccuracy = 10;
	
	// TODO FIXME: temp cheap way to mock this up. eventually only get the 2 possible groups alive
	allguys = getaiarray("axis");
	foreach (guy in allguys)
	{
		guy.ignoreme = false;
	}
	
	if (IsDefined(allguys[0]) && IsAlive(allguys[0]))
    {
		level.soap GetEnemyInfo(allguys[0]);
		level.price GetEnemyInfo(allguys[0]);
	}
}

blackout_vo()
{
	flag_wait("sandstorm_dead_ahead");
	
	sa = level.soap.baseaccuracy;
	pa = level.price.baseaccuracy;

	radio_dialogue("payback_mct_deadahead_r");

	level.price.animname = "price";

	if (level.blackout_shots_fired == false)
	{
//		level.price dialogue_queue("payback_pri_holdup");
		thread blackout_takedown_vo();
	}
	else
	{
		level.price dialogue_queue("payback_pri_takeemout");
		blackout_soap_price_fight();
	}

	flag_wait("uaz_guys_dead");
	level.soap.baseaccuracy = sa;
	level.price.baseaccuracy = pa;
	autosave_by_name("blackout_done");
	
	sandstorm_allies_sprint();
	radio_dialogue("payback_mct_wereclear_r");
	// TODO FIXME: TEMP VO used here
	level.price dialogue_queue("payback_pri_gottamove");
	wait 0.5;
	flag_set("contact_echo");
	
}

sandstorm_contact_echo_vo()
{
	// hopefully this fits in somewhere  

	flag_wait("contact_echo");

	//leaving out most pauses between lines to keep it quick as possible - where we're playing it leaves not much time to play
	level.price dialogue_queue("payback_pri_echoteam2");
	wait 0.25;
	radio_dialogue("payback_eol_locatedchopper");
//	level.price dialogue_queue("payback_pri_meetatcrash");
//	radio_dialogue("payback_eol_rogerthat2");
}

sandstorm_window_lookers()
{
	flag_wait("sandstorm_runner_see_you");  // temporary flag for mock up
	thread callout_lookers();
	thread lookers_autosave();
	
	spawner = GetEnt("ss_window_guy_c", "targetname");
	middle_guy = spawner spawn_ai(true);
	middle_guy thread maps\payback_sandstorm_code::flashlight_on_guy();
	middle_guy.animname = "generic";
	middle_guy set_run_anim( "payback_pmc_sandstorm_stumble_3" );
	middle_node = GetNode("ss_middle_search_node", "targetname");

	spawner = GetEnt("ss_window_guy_l", "targetname");
	left_guy = spawner spawn_ai(true);	
	left_guy thread maps\payback_sandstorm_code::attachFlashlight("alley_fight");
	left_origin = GetEnt("ss_left_search_guy", "targetname");
	
	spawner = GetEnt("ss_window_guy_r", "targetname");
	right_guy = spawner spawn_ai(true);	
	right_guy thread maps\payback_sandstorm_code::attachFlashlight("alley_fight");
	right_origin = GetEnt("ss_right_search_guy", "targetname");
	
	alley_guys = [middle_guy, left_guy, right_guy];
/*
	alley_guys = [];
	array_add(alley_guys, middle_guy);
	array_add(alley_guys, left_guy);
	array_add(alley_guys, right_guy);
*/
	thread handle_unawares(alley_guys, "alley_fight");
	
	middle_guy setGoalNode(middle_node);
	thread left_looker(left_guy);
	right_looker(right_guy);
	
	thread ai_array_killcount_flag_set(alley_guys, alley_guys.size, "lookers_dead"); 
	
	// see player if he's in the volume
	if (flag("sandstorm_in_alley"))
	{
		if (!flag("alley_fight") && !flag("lookers_dead"))
		{
			radio_dialogue("payback_mct_theyknow_r");
			flag_set("alley_fight");
		}
	}
	else
	{
		level notify("lookers_deleted");
		foreach (guy in alley_guys)
		{
			if (IsDefined(guy) && IsAlive(guy))
			{
				guy delete();
			}
		}
	}
}

lookers_autosave()
{
	level endon("lookers_deleted");
	
	flag_wait("alley_fight");
	flag_wait("lookers_dead");
	autosave_by_name_silent("window_lookers");
}
	
callout_lookers()
{
	level endon("death");
	level endon("lookers_deleted");
	
	flag_wait("enemies_right");
	
	if (!flag("alley_fight"))
	{
		//radio_dialogue("payback_pri_enemyright_r");
		flag_wait("lookers_dead");
		radio_dialogue("payback_mct_thatwaseasy_r");
	}
}

left_looker(left_guy)
{
	left_guy endon("death");
	left_guy anim_generic(left_guy, "active_patrolwalk_pause");
	left_guy anim_generic(left_guy, "active_patrolwalk_turn_180");
}

right_looker(right_guy)
{
	right_guy endon ("death");
	right_guy anim_generic(right_guy, "active_patrolwalk_v5");
	right_guy anim_generic(right_guy, "active_patrolwalk_v5");
	right_guy anim_generic(right_guy, "active_patrolwalk_turn_180");
}

vo_echo_team_reports_in()
{
	flag_wait("echo_vo");
	
	radio_dialogue("payback_tm2_reachednikolai");
	wait 0.5;
	level.price dialogue_queue("payback_pri_hangon");
}

sandstorm_end_runners2()
{
	flag_wait("sandstorm_end_runners2");
	thread blizzard_level_transition_extreme2(5);
	badguys = array_spawn_targetname_allow_fail("sandstorm_end_runners2");
	wavers = array_spawn_targetname_allow_fail("sandstorm_end_wavers2");
	
	allbadguys = array_combine(badguys, wavers);
	thread handle_unawares(allbadguys, "end_runners_fight");
	
	default_endgoal_node = GetNode("sandstorm_end_runners2_node", "targetname");
	
	array_thread(badguys, ::do_end_runners, default_endgoal_node);
	array_thread(wavers, ::do_end_wavers, default_endgoal_node);

	extras = array_spawn_targetname_allow_fail("sandstorm_end_runners3");
	array_thread(extras, ::do_end_runners, default_endgoal_node);
	
	thread ai_array_killcount_flag_set(allbadguys, allbadguys.size, "end_runners_dead");
	thread boost_sstorm_allies_combat_accuracy("end_runners_fight", "end_runners_dead");
	
	waver_vo_spot = GetStruct("sandstorm_waver_vo_spot", "targetname");
	thread play_sound_in_space("payback_afm_hurry",waver_vo_spot.origin);
	wait 1.5;
	level.price dialogue_queue("payback_mct_headingfornik" );
		
	if (!flag("end_runners_fight"))
	{
		level.price dialogue_queue( "payback_pri_dropem" );
		wait 1;
		flag_set("end_runners_fight");
	}
	
	// post fight
	flag_wait("end_runners_dead");
	autosave_by_name("end_runners_dead");
	sandstorm_allies_sprint();
	trigger_off("ss_allies_wavers1", "targetname");
	activate_one_trigger("ss_allies_wavers2");
	radio_dialogue("payback_mct_wereclear_r");
}

boost_sstorm_allies_combat_accuracy(start_flag, stop_flag)
{
	soap_acc = level.soap.baseaccuracy;
	price_acc = level.price.baseaccuracy;
	
	flag_wait(start_flag);
	
	level.soap.baseaccuracy = 1000;
	level.price.baseaccuracy = 1000;
	
	flag_wait(stop_flag);
	
	level.soap.baseaccuracy = soap_acc;
	level.price.baseaccuracy = price_acc;
}

do_end_runners(final_node)
{
	if (randomfloat(100) < 75)
	{
		self maps\payback_sandstorm_code::flashlight_on_guy();	
	}
	self set_goal_radius(10);
	self SetGoalPos(self.origin);
	// give wavers a chance to animate before going;
	wait 2;
	
	if (IsDefined(self) && IsAlive(self))
	{
		self run_and_delete(final_node, "end_runners_fight");
	}
}

do_end_wavers(final_node)
{
	self endon("death");
	self endon("end_runners_fight");
	
	wave_struct = GetStruct(self.script_noteworthy, "targetname");
//	wave_struct anim_generic_reach(self, self.animation);
	wave_struct anim_generic_teleport(self, self.animation);
	wave_struct anim_generic(self, self.animation);
	
	self run_and_delete(final_node, "end_runners_fight");
}

run_and_delete(final_node, endon_notify)
{
	self endon("death");


	if ( IsDefined(endon_notify) &&
	    (!IsDefined(self.script_noteworthy) || 
	     (IsDefined(self.script_noteworthy) && self.script_noteworthy != "no_intterupt")) )
	{
		level endon(endon_notify);
	}
	
	self set_goal_radius(100);
	self SetGoalNode(final_node);
	wait 1;
	self waittill("goal");
	wait 0.2;

	if ( raven_player_can_see_ai(self) )
	{
		// player managed to see them get to the end of the path.  start a fight.
		self.ignoreall = false;
		self.ignoreme = false;
		wait 1;
		self GetEnemyInfo(level.player);
	}
	else
	{
		self Delete();
	}
}

// ============================================================================================================
// ====================================== "unaware guys system" functions =====================================
// ============================================================================================================



handle_unawares(guys, notify_name)
{
	level endon("death");
	self endon("deleted");

	
	foreach (guy in guys)
	{
		guy thread handle_unaware_shot(notify_name);
	}
	
	level waittill(notify_name);
	
	array_thread(guys, ::unawares_attack);
}
	
handle_unaware_shot(notify_name)
{
	self endon("death");
	self endon("deleted");

	level endon(notify_name);

	self addAIEventListener( "grenade danger" );
    self addAIEventListener( "gunshot" );
    self addAIEventListener( "silenced_shot" );
    self addAIEventListener( "bulletwhizby" );
    self addAIEventListener( "projectile_impact" );

    self waittill( "ai_event", eventtype );
	
	self unawares_attack(level.player);
	level notify(notify_name);
	flag_set(notify_name);
}

unawares_attack(target)
{
	self endon("death");
	self endon("deleted");
	
	if (!IsDefined(target))
	{
		// guys who weren't directly affected will wait a random amount of time to react so they don't always react
		wait RandomFloatRange(0.5, 2.0);
	}
	
	if (IsDefined(self) && IsAlive(self))
	{
		self.ignoreme = false;
		self.ignoreall = false;
		self.baseaccuracy = 0.2;
		self stopanimscripted();
		self SetGoalPos(self.origin);
		
		if (IsDefined(target))
		{
			self GetEnemyInfo(target);
		}
		else
		{
			self GetEnemyInfo(level.player);
		}
	}
}