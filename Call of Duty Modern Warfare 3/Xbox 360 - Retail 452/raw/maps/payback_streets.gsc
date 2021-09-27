#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_sandstorm;
#include maps\payback_util;
#include maps\payback_sandstorm_code;
#include maps\payback_streets_const;
#include maps\payback_env_code;
#include maps\_audio;
	
init_flags_streets()
{
	flag_init( "ambush_start" );
	flag_init( "prespawn_ambush_guys" );
	flag_init( "streets_enemy_movement" );
	flag_init( "streets_skip_price_int" );
	flag_init( "streets_chopper_ambush" );
	flag_init( "streets_chopper_end" );
	flag_init( "streets_ambush_over" );
	flag_init( "start_streets_script" );
	flag_init( "streets_area1_preambush" );
	flag_init( "streets_area1_VO_000" );
	flag_init( "streets_area1_runners" );
	flag_init( "streets_area1_ambush" );
	flag_init( "streets_area1_wave2" );
	flag_init( "streets_area1_wave3" );
	flag_init( "streets_area1_cleanup" );
	flag_init( "streets_area1_end" );
	flag_init( "rollcar_stopped" );
	
	flag_init( "streets_ambush_started" );
	flag_init( "streets_tech_runaway" );
	flag_init( "streets_tech_runaway_move" );
	flag_init( "streets_tech_passedmid" );
	flag_init( "streets_tech_passedstand" );
	flag_init( "streets_area2_alley1" );
	flag_init( "streets_mid_over" );
	flag_init( "streets_area2_narrowstreet" ); 
	flag_init( "streets_area2_begin" );
	flag_init( "streets_area3_slopealley" );
	flag_init( "streets_area2_runners" );
	flag_init( "streets_area3_start_mainpath" );
	flag_init( "streets_area3_start_sidepath" );
	flag_init( "streets_area3_sidetoend" );
	flag_init( "streets_area3_end" );
	flag_init( "end_streets_combat" );
	flag_init( "streets_player_at_sec_LZ" );
	flag_init( "streets_ambush_setup" );
	flag_init( "streets_vo_030" );
	flag_init( "sjp_player_chose_way" );

	flag_init( "streets_start_umbrellas" );
	flag_init( "sjp_axis_all_dead" );
	
	init_flags_environmental();
	
	
	
	maps\payback_sandstorm::init_flags_sandstorm();
}

init_streets_assets()
{
	maps\payback_sandstorm::init_sandstorm_assets();
		
	precachestring( &"PAYBACK_SANDSTORM_ARRIVAL" );
	precacheModel( "com_plastic_bucket_empty" );
	precacheModel( "me_wood_cage_large" );
	precacheModel( "me_electricbox2_door_upper" );
	precacheModel( "com_barrel_green_dirt" );
	PreCacheModel( "vehicle_80s_hatch1_scriptable_destroyed" );
}

// only called on level starting point, not on full playthrough
start_s2_city()
{
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
	
	// AUDIO: jump/checkpoints
	aud_send_msg("s2_city");
	thread sandstorm_fx(4);
	texploder(2300);
	exploder(2000);
	exploder(2500);
	exploder(4000);
	battlechatter_off( "axis" ); // AUDIO: turn off battlechatter prior to ambush, restored in payback_streets::handler_streets_area1()
	battlechatter_off( "allies" );
	trigger_off( "streets_ambush_hurt" , "targetname" );
	
	level.start_point = "s2_city"; // for my test level
	
	//move player to streets start
	move_player_to_start();
	level.price = spawn_ally( "price" );
	level.soap = spawn_ally( "soap" );
	level.hannibal = spawn_ally("hannibal");	
	level.murdock = spawn_ally("murdock");
	level.barracus = spawn_ally("barracus");
	
	level.chopper_fog_brushes = GetEntArray( "chopper_fog_brush", "targetname" );
	
	foreach ( brush in level.chopper_fog_brushes )
	{
		brush Hide();
        brush NotSolid();
	}

	objective_state( obj( "obj_primary_lz" ) , "current" );
	
	init_sandstorm_env_effects("s2_city");
	
	// Show compound exit vista
	GetEnt("compoundexit_vista", "targetname") Show();
	
	streets();
}

start_s2_postambush()
{
	maps\_compass::setupMiniMap("compass_map_payback_port","port_minimap_corner");
	init_sandstorm_env_effects();
	
	// Show compound exit vista
	GetEnt("compoundexit_vista", "targetname") Show();	
	
	aud_send_msg("s2_postambush");
	thread sandstorm_fx(4);
	texploder(2300);
	exploder(2000);
	exploder(2500);
	exploder(4000);
	texploder(5300);
	exploder(5000);//const
	streets_save_triggers();
	trigger_off( "streets_ambush_hurt" , "targetname" );
	battlechatter_on( "axis" );
	battlechatter_on( "allies" );
	thread spawn_area1_vehicle2();
	thread handler_area1_to_guardhouse();
	
	level.start_point = "s2_postambush";
	move_player_to_start();
	level.price = spawn_ally( "price" );
	level.soap = spawn_ally( "soap" );
	level.murdock = spawn_ally("murdock");
	level.barracus = spawn_ally("barracus");
	thread sjp_setup();
	
	level.chopper_fog_brushes = GetEntArray( "chopper_fog_brush", "targetname" );
	foreach ( brush in level.chopper_fog_brushes )
	{
		brush Hide();
        brush NotSolid();
	}
	
	flag_set( "streets_area1_cleanup" );
	thread handler_streets_area1_cleanup();
	
	flag_wait("end_streets_combat");
	level notify( "notify_streets_complete" );
	aAI_streets = getaiarray ( "axis" );
	thread AI_delete_when_out_of_sight( aAI_streets, 800);
//Simon's main handler code
	streets_construction();
}
streets()
{	
//Any common code
	thread set_sandstorm_level( "light" );

//Dan's main handler code
	
	flag_wait("start_streets_script");
	// thread custom save triggers for timers

	streets_save_triggers();
	init_color_trigger_listeners( "streets_colors" );
	thread handler_streets1_prespawn();

	level.ambush_gun = getent( "streets_hannibal_weapon", "targetname" );
	level.ambush_gun Hide();	
	
	level.soap disable_cqbwalk();
	level.price disable_cqbwalk();
	level.hannibal disable_ai_color();

	maps\payback_1_script_d::chopper_main();
	chopper_streets_start = GetStruct( "chop_streets_start_struct", "targetname" );
	chopper_streets_path = GetStruct( "chop_streets_path_struct", "targetname" );
	level.chopper vehicle_teleport( chopper_streets_start.origin , chopper_streets_start.angles );
	level.chopper clearlookatent();
	level.chopper thread vehicle_paths( chopper_streets_path );
	thread start_umbrellas( "streets_start_umbrellas" );
	thread skip_price_interrogation_end();
	
	//Objective - change to chopper
	Objective_OnEntity( obj( "obj_primary_lz" ), level.chopper , (0,0,60) );
		
	trigger_activate_targetname_safe( "streets_right_bravopositions" );
	han_pos = getnode( "streets_init_hanposition", "targetname" );
	level.hannibal set_goal_node( han_pos );
		
	thread handler_streets_area1();
	
	flag_wait( "end_streets_combat" );
	level notify( "notify_streets_complete" );
	aAI_streets = getaiarray ( "axis" );
	thread AI_delete_when_out_of_sight( aAI_streets, 800);
	
//Simon's main handler code
	streets_construction();
}

//if player is a sprinter skips Price walkout animation at end of interrogation
skip_price_interrogation_end()
{
	flag_wait( "streets_skip_price_int" );
	
	level.price anim_stopanimscripted();
	if( (IsDefined( level.swap_model ) ) && level.swap_model == false )
		{
			maps\payback_1_script_e::swap_model();
		}	
	if( (IsDefined( level.hide_mask_1 ) ) && level.hide_mask_1 == false )
		{
			maps\payback_1_script_e::hide_mask_1();
		}		
	if( (IsDefined( level.price_unholster_mg ) ) && level.price_unholster_mg == false )
		{
			maps\payback_1_script_e::price_unholster_mg();
		}	
	level.price enable_ai_color();
	
}

handler_streets1_prespawn()
{
	flag_wait("streets_ambush_setup");
	array_spawn_targetname( "streets_area1_prespawn" );
	
	flag_wait("ambush_start");
	
	group = get_ai_group_ai("streets_area1_ignoreall");
	
	foreach(dude in group)
	{
		dude set_ignoreall(false);
		dude set_ignoreme(false);
	}
	
}

handler_streets_area1()
{
	//iprintln("handler area1 called");
	
	flag_wait("streets_area1_runners");
	thread handler_streets_vo_000();
	thread streets_move_bravo();
		
	flag_wait("streets_area1_ambush");
	thread start_umbrellas_idle();
	//thread streets_vo_010();
	endpoint = getStruct( "streets_ambush_sniper1_target", "targetname" );
	level.friendly_endpoint = endpoint.origin;
	thread make_hannibal_mortal();
	//thread streets_moderate_ai_moveplaybackrate();
	//IPrintLn( "ambush starting" );
	//will delete artificial test delay
	delayThread(5.5, ::autosave_now_silent);
	aud_send_msg("city_pre_ambush");
	wait 6.5;
	thread handler_streets_area1_end();
	thread handler_ambush_sequence();
	battlechatter_on( "axis" ); // AUDIO: restore battlechatter (disabled in payback_1_script_e::setup_breach)
	battlechatter_on( "allies" ); // AUDIO: restore battlechatter (disabled in payback_1_script_e::setup_breach)
	
	flag_wait("streets_area1_wave2");
	thread spawn_area1_vehicle2();	
	thread spawn_area1_wave2();
	array_spawn_targetname( "streets_area1_runners2" );
	thread handler_area1_to_guardhouse();
	thread handler_streets_area1_cleanup();
		
	flag_wait("streets_area1_wave3");
	array_spawn_targetname( "streets_area1_lastwave" );
		
	//trying to sprint through will remove death shield faster
	level.player EnableDeathShield( false );
}

streets_move_bravo() 
{
	thread streets_move_soap();
	thread streets_move_price();
	thread streets_move_barracus();
	thread streets_move_murdock();
	node = getnode( "han_chopper_pickup", "targetname" );
	level.hannibal.goalradius = node.radius;
	//level.hannibal enable_cqbwalk();
	level.hannibal thread streets_remove_traits();
	flag_wait( "streets_area1_ambush" );
	//switches hannibals weapon to m4
	//level.hannibal forceUseWeapon( "m4m203_acog", "primary" );
	//level.hannibal.sidearm = "none";
	//level.hannibal.secondaryweapon = "none";
	//level.hannibal.lastweapon = "none";
	
	
	level.hannibal set_goal_node( node );
	level.hannibal.animname = "generic";
	level.hannibal waittill( "goal" );
	//level.hannibal anim_loop_solo ( level.hannibal, "payback_bravo_chopper_wave" );

}

streets_remove_traits()
{
	self.grenadeawareness = 0;
	self.ignoreexplosionevents = true;
	self.ignorerandombulletdamage = true;
	self.disableBulletWhizbyReaction = true;
	self thread disable_pain();
	self thread disable_surprise();
}

streets_add_traits()
{
	self.grenadeawareness = 1;
	self.ignoreexplosionevents = false;
	self.ignorerandombulletdamage = false;
	self.disableBulletWhizbyReaction = false;
	self thread enable_pain();
	self thread disable_surprise();
}

streets_move_soap()
{
	//wait 2.0;
	level.soap disable_ai_color();
	node_s = getnode( "streets_soap_start", "targetname" );
	level.soap.goalradius = node_s.radius;
	level.soap set_goal_node( node_s );
	//wait 2;
	//level.soap.sprint = true;
	
	level.soap waittill( "goal" );
	flag_wait( "streets_area1_ambush" );
	wait 1;
	//level.soap.sprint = false;
	level.soap thread streets_remove_traits();
	//level.soap enable_cqbwalk();
	node_s = getnode( "streets_soap_end", "targetname" );
	level.soap.goalradius = node_s.radius;
	level.soap set_goal_node( node_s );
	
	flag_wait( "streets_ambush_started" );
	//level.soap disable_sprint();
	level.soap disable_cqbwalk();
	level.soap enable_ai_color();
	level.soap thread streets_add_traits();
}

streets_move_price()
{
	level.price disable_ai_color();
	node_p = getnode( "streets_price_start", "targetname" );
	//level.price.sprint = true;
	level.price.goalradius = node_p.radius;
	level.price set_goal_node( node_p );
	
	level.price waittill( "goal" );
	flag_wait( "streets_area1_ambush" );
	wait .6;
	//level.price.sprint = false;
	level.price thread streets_remove_traits();
	//level.price enable_cqbwalk();
	node_p = getnode( "streets_price_end", "targetname" );
	level.price.goalradius = node_p.radius;
	level.price set_goal_node( node_p );
	
	flag_wait( "streets_ambush_started" );
	//level.price disable_sprint();
	level.price disable_cqbwalk();
	level.price enable_ai_color();
	level.price streets_add_traits();
}

streets_move_barracus()
{
	
	level.Barracus disable_ai_color();
	node_b = getnode( "streets_bar_start", "targetname" );
	//level.barracus.sprint = true;
	level.barracus.goalradius = node_b.radius;
	wait .5;
	level.barracus set_goal_node( node_b );
	
	flag_wait( "streets_area1_ambush" );
	wait 1;
	level.barracus thread streets_remove_traits();
	//level.barracus enable_cqbwalk();
	level.barracus.animname = "generic";
	level.barracus.deathanim = getanim_generic( "death_explosion_right13");
	
	node_b = getnode( "streets_bar_end", "targetname" );
	level.barracus.goalradius = node_b.radius;
	level.barracus set_goal_node( node_b );
	
	flag_wait( "streets_ambush_started" );
	level.barracus thread streets_add_traits();
	level.barracus enable_ai_color_dontmove();
	//wait 3;
	level.barracus disable_cqbwalk();
	node_b = getnode( "streets_bar_duck", "targetname" );		
	level.barracus set_goal_node( node_b );
	//level.barracus disable_sprint();
//	level.barracus enable_ai_colordontmove();
	trigger_activate_targetname_safe ( "streets_ambush_bravo_pos" );
}


streets_move_murdock()
{
	wait 1.0;
	level.murdock disable_ai_color();
	//level.murdock enable_cqbwalk();
	node_m = getnode( "streets_mur_start", "targetname" );
	level.murdock.sprint = true;
	level.murdock.goalradius = node_m.radius;
	level.murdock set_goal_node( node_m );

	flag_wait( "streets_area1_ambush" );
	level.murdock thread streets_remove_traits();
	wait 2;
	
	level.murdock enable_cqbwalk();
	node_m = getnode( "streets_mur_end", "targetname" );
	//level.murdock.sprint = true;
	level.murdock.goalradius = node_m.radius;
	level.murdock.animname = "generic";
	//level.murdock.deathanim = getanim_generic( "death_explosion_stand_B_v1");
	level.murdock set_goal_node( node_m );

	flag_wait( "streets_ambush_started" );	
	level.murdock thread streets_add_traits();
	level.murdock enable_ai_color_dontmove();
	wait 1.3;
	//level.murdock disable_sprint();
	level.murdock disable_cqbwalk();
	
	
	trigger_activate_targetname_safe ( "streets_ambush_bravo_pos" );

//	node_m = getnode( "streets_mur_duck", "targetname" );
//	level.murdock set_goal_node( node_m );
	
}

streets_ambush_player()
{
	level.player EnableDeathShield( true );
	wait 5.0;
	level.player EnableDeathShield( false );
	level.streets_fakefire = false;
	player_speed_percent( 100, 1 );
}


handler_ambush_sequence()
{
	thread array_spawn_targetname("streets_area1_initial_amb");
	
	// *crack*
	sniper_ambush1 = getStruct( "streets_ambush_sniper1", "targetname" );
	sniper_target1 = getStruct( "streets_ambush_sniper1_target", "targetname" );
	aud_send_msg("city_ambush_01_sniper", sniper_ambush1.origin);

	flag_set("ambush_start");
	
	// *splat*
	BulletTracer ( sniper_ambush1.origin, sniper_target1.origin, true );
	level notify( "streets_ambush_presnipe" );
	
	wait 0.1; // AUDIO: about three frames
	thread streets_speed_reset();
	PlayFx( getfx( "flesh_hit_body_fatal_exit" ), level.hannibal GetTagOrigin( "j_head" ) );
	aud_send_msg("city_ambush_02_bullet", level.hannibal);
	thread handler_ambush_pricestopvo();
	level.hannibal thread streets_kill_hannibal();
	
	//level.hannibal thread gun_remove();
	//hurt trigger if the player runs past the sniper shot point
	thread handler_streets_ambush_hurt();
	flag_set( "streets_ambush_started" );
	wait .2;
	thread streets_vo_ambush();
	wait 0.3; // AUDIO: added wait
	thread handler_chopper_exit();

	thread streets_ambush_player();
	aud_send_msg("city_ambush_03_chopper");
	wait 0.1;
	//thread array_spawn_noteworthy("streets_area1_initial_amb");	//delayThread( 0.3, ::array_spawn_noteworthy, "streets_area1_initial_amb"  );
	rpg_start2 = getStruct( "streets_ambush_rpg2", "targetname" );
	rpg_target2 = getStruct( "streets_ambush_rpg2_target", "targetname" );
	target_ent2 = Spawn( "script_origin", rpg_target2.origin );
	missileAttractor2 = Missile_CreateAttractorEnt( target_ent2, 200000, 2000 );
	rpg = magicBullet( "rpg_straight", rpg_start2.origin, rpg_target2.origin );
	aud_send_msg("play_rpg_explode", rpg);
	aud_send_msg("city_ambush_04_mayhem"); // AUDIO:
	
	wait 0.5;
	Missile_DeleteAttractor( missileAttractor2 );
	rpg_start = getStruct( "streets_ambush_rpg1", "targetname" );
	rpg_target = getStruct( "streets_ambush_rpg1_target", "targetname" );
	target_ent = Spawn( "script_origin", rpg_target.origin );
	missileAttractor = Missile_CreateAttractorEnt( target_ent, 200000, 2000 );
	rpg = magicBullet( "rpg_straight", rpg_start.origin, rpg_target.origin );
	aud_send_msg("play_rpg_explode", rpg);
	
	mgspot = getStruct( "streets_mag_gre_org", "targetname" );
	MagicGrenadeManual ( "fraggrenade", mgspot.origin, ( 0, 0, 0 ), 0 );
	
	
	trigger_on( "ambush_npc_triggers", "script_noteworthy" );	
	wait 0.2;
	
	Missile_DeleteAttractor( missileAttractor );
	

	
//	thread magic_grenades();
	thread array_spawn_targetname("streets_area1_runners1"); //delayThread( 0.3, ::array_spawn_targetname, "streets_area1_runners1"  );
	
	wait 2;
	thread streets_fakefire_smallarms();
	thread array_spawn_noteworthy("streets_area1_initial_amb");	
	

	wait 1;
//	thread streets_ambush_fightthenrun();
	thread sjp_setup();
	aud_send_msg("start_rpg_listener");

//	rpg_start3 = getStruct( "streets_ambush_rpg3", "targetname" );
//	rpg_target3 = getStruct( "streets_ambush_rpg3_target", "targetname" );
//	target_ent3 = Spawn( "script_origin", rpg_target3.origin );
//	missileAttractor3 = Missile_CreateAttractorEnt( target_ent3, 2000, 2000 );
//	magicBullet( "rpg", rpg_start3.origin, rpg_target3.origin );
	
//	wait 1.0;
	//Missile_DeleteAttractor( missileAttractor3 );
	
	//delayThread (1, ::streets_fakeRPG ); 
}

handler_ambush_pricestopvo()
{
	level.price stopsounds();
}

handler_streets_ambush_hurt()
{
	trigger_on( "streets_ambush_hurt" , "targetname" );
	wait 1.0;
	trigger_off( "streets_ambush_hurt" , "targetname" );
}

handler_streets_area1_end()
{
	flag_wait( "streets_area1_end" );
}

streets_fakeRPG( index )// not used just yet... will replace ugly script aboverpg_start, rpgtarget, missile)
{
	rpg_start = getStruct( "streets_ambush_rpg" + index , "targetname" );
	rpg_target = getStruct( "streets_ambush_rpg" + index + "_target", "targetname" );
	target_ent = Spawn( "script_origin", rpg_target.origin );
	missileAttractor = Missile_CreateAttractorEnt( target_ent, 2000, 2000 );
	magicBullet( "rpg", rpg_start.origin, rpg_target.origin );
	wait 3;
	Missile_DeleteAttractor ( missileAttractor );
}

streets_ambush_fightthenrun()
{
	wait 3;
	enemies = get_ai_group_ai( "streets_area1_fightretreat" );
	retreat_pos = GetNode( "streets_ambush_runners", "targetname" );
	level.streets_retreat_delay = 0;
	
	for( i = 0; i < enemies.size; i++ )
		{
			if( IsAlive( enemies[i] ))
		   	{
		   		level.streets_retreat_delay = level.streets_retreat_delay + 2.5;
		   		enemies[i] thread streets_flee( retreat_pos );
		   	}
		}
}
	
streets_flee(node)
{
	self endon( "death" );
		
	self enable_sprint();
	self ignore_everything();
	wait level.streets_retreat_delay;
	self SetGoalNode( node );
	self waittill( "goal" );
	self Delete();
}

streets_kill_hannibal()
{
	if ( IsDefined( level.hannibal ) && IsDefined( self.magic_bullet_shield ) && self.magic_bullet_shield )
		{
 			level.hannibal stop_magic_bullet_shield();
		}
	level.hannibal anim_single_solo( level.hannibal, "death_run_forward_crumple" );
	level.hannibal.allowDeath = true;
	level.hannibal.a.nodeath = true;
	level.hannibal Kill();
	
	if( IsDefined( level.ambush_gun ) )
	   {
	   		level.ambush_gun Show();
	   }
	
}
	
magic_grenades()
{
	wait 4.5;
	gren = Getstruct ("streets_magicgren_org", "targetname" );
 //	MagicGrenadeManual( "fraggrenade", gren.origin, ( 0, 500, 500 ), randomfloatrange( 2, 3 ) );
   	MagicGrenade( "fraggrenade", gren.origin, level.player.origin , 2 );
}

handler_chopper_exit()
{
	wait .2;
	chopper_streets_exit = GetStruct( "chop_streets_exit_struct", "targetname" );
	//level.chopper thread maps\payback_1_script_d::Chopper_Fly_Path( chopper_streets_exit ); 
	level.chopper thread vehicle_paths( chopper_streets_exit );
	
	wait 2.3;
//	rpg = spawn_vehicle_from_targetname_and_drive( "streets_chopper_rpg_flared" );
	
	wait .5;
	//streets_flares_fire_burst( level.chopper,  7, 1, 5.0 );
	stop_umbrellas();
	
	flag_wait ( "streets_chopper_end" );
	level.chopper Delete();
	level.chopper = undefined;
	thread maps\payback_aud::delete_chopper_audio(); // AUDIO: fade out and delete chopper audio (ONLY AFTER level.chopper HAS BEEN NUKED!)
}

start_umbrellas_idle()
{
	level.umbrella_one = getEnt( "streets_chopper_umbrella_1" , "targetname" );
	level.umbrella_one.animname = "umbrella";
	level.umbrella_one setanimtree();
	level.umbrella_one thread anim_loop_solo( level.umbrella_one , "wind_idle_1" );
	
	level.umbrella_two = getEnt( "streets_chopper_umbrella_2" , "targetname" );
	level.umbrella_two.animname = "umbrella";
	level.umbrella_two setanimtree();
	level.umbrella_two thread anim_loop_solo( level.umbrella_two , "wind_idle_2"  );
}

start_umbrellas( wait_flag )
{
	if ( IsDefined( wait_flag ))
	{
		flag_wait( wait_flag );
	}
	//level.umbrella_one = getEnt( "streets_chopper_umbrella_1" , "targetname" );
	//level.umbrella_one.animname = "umbrella";
	//level.umbrella_one setanimtree();
	level.umbrella_one notify( "stop_loop" );
	wait(0.20);
	level.umbrella_one thread anim_loop_solo( level.umbrella_one , "heli_wind_near" , "end_heli_wind" );
	
	//level.umbrella_two = getEnt( "streets_chopper_umbrella_2" , "targetname" );
	//level.umbrella_two.animname = "umbrella";
	//level.umbrella_two setanimtree();
	level.umbrella_two notify( "stop_loop" );
	wait(0.20);
	level.umbrella_two thread anim_loop_solo( level.umbrella_two , "heli_wind_far" , "end_heli_wind" );
}

stop_umbrellas()
{
	if ( IsDefined( level.umbrella_one ))
	{
		level.umbrella_one notify( "end_heli_wind" );
		wait(0.05);
		level.umbrella_one thread anim_loop_solo( level.umbrella_one , "wind_idle_1" );
	}

	if ( IsDefined( level.umbrella_two ))
	{
		level.umbrella_two notify( "end_heli_wind" );
		wait(0.05);
		level.umbrella_two thread anim_loop_solo( level.umbrella_two , "wind_idle_2"  );
	}	
}

postspawn_rpg_vehicle() //grabbed this from london to see the vehicle rocket
{
	self SetModel( "projectile_rpg7" );
	fx = getfx( "smoke_geotrail_rpg" );
	PlayFXOnTag( fx, self, "tag_origin" );

	fx = getfx( "at4_flash" );
	PlayFXOnTag( fx, self, "tag_origin" );

	self PlaySound( "weap_rpg_fire_npc" );
	self PlayLoopSound( "weap_rpg_loop" );

	self waittill( "reached_end_node" );
	rpg_spot = getent( "streets_flare_rpg", "targetname" );
//	PlayFx( getfx( "rpg_explode" ), rpg_spot.origin ); //have an explosion but player can't see
	self Delete();
}

streets_fakefire_smallarms()
{
	spots = GetStructArray( "streets_ambush_firespot", "targetname" );
	array_thread( spots, ::streets_fakefire_smallarms_spot );
}

streets_fakefire_smallarms_spot()
{
	level endon( "death" );
	level.streets_fakefire = true;
	
	spot = self;
	weapons = level.scriptedweapons;
	
	burstShotsMin = 5;
	burstShotsMax = 12;
	
	shotWaitMin = 0.1;
	shotWaitMax = 0.15;
	burstWaitMin = 0.5;
	burstWaitMax = 1;
	
	start = spot.origin;
	
	while( level.streets_fakefire )
	{
		
		//weapon = get_random( weapons );
		burstShots = RandomIntRange( burstShotsMin, burstShotsMax );
		
		for( i = 0; i < burstShots; i++ )
		{
			
			x = level.player.origin[ 0 ] + RandomIntRange( -32, 64 );
			y = level.player.origin[ 1 ] + RandomIntRange( -32, 64 );
			z = level.player.origin[ 2 ] + RandomIntRange( -32, 0 );
			targetOrigin = ( x, y, z );
			
			angles = VectorToAngles( targetOrigin - start );
			forward = AnglesToForward( angles );
			vec = ( forward* 12 );
			end = start + vec;
						
			MagicBullet( "ak47", spot.origin, end );
			
			wait( RandomFloatRange( shotWaitMin, shotWaitMax ) );
		}
		
		wait( RandomFloatRange( burstWaitMin, burstWaitMax ) );
	}
}

streets_flares_fire_burst( vehicle, fxCount, flareCount, flareTime )
{
	
	assert( isdefined( level.flare_fx[ vehicle.vehicletype ] ) );

	assert( fxCount >= flareCount );

	for ( i = 0 ; i < fxCount ; i++ )
	{
		playfx( level.flare_fx[ vehicle.vehicletype ], vehicle getTagOrigin( "tag_light_belly" ) );

		if ( vehicle == level.playervehicle )
		{
			level.stats[ "flares_used" ]++ ;
			level.player playLocalSound( "weap_flares_fire" );
		}
		wait 0.25;
	}
}

handler_streets_area1_cleanup()
{
	flag_wait( "streets_area1_cleanup" );

	wait 1;
	thread streets_vo_020();
	autosave_by_name( "s2_city" );
	wait 3;

	thread sandstorm_timer();
	objective_state( obj( "obj_secondary_lz" ), "current");
 	Objective_OnEntity( obj( "obj_secondary_lz" ), level.price , (0,0,50) );
		
}

cargo_room_prop(joint, prop_anim, prop_anim_loop, anim_ref)
{
	rig = spawn_anim_model("cargo");
	waittillframeend;
	
	anim_ref anim_first_frame_solo( rig, prop_anim );
	self linkto( rig , joint );
	
	anim_ref anim_single_solo( rig, prop_anim );
	if ( IsDefined( prop_anim_loop ))
	{
		anim_ref anim_loop_solo( rig, prop_anim_loop );
	}
	flag_wait_or_timeout( "kill_cargo", 300 );
	
	self unlink();
	rig Delete();
	self Delete();
}

handler_rollcar_sequence()
{
	flag_wait( "streets_area3_start_mainpath" );
	ref = getStruct( "city_rollcar_ref_push" , "targetname" );
	rig = spawn_anim_model("car_barrels");
	waittillframeend;
	ref anim_first_frame_solo( rig, "payback_city_truck_push_barrels" );
	barrel_1 = getent( "rc_barrel_1", "targetname" );
	barrel_2 = getent( "rc_barrel_2", "targetname" );
	barrel_1 linkto( rig, "J_prop_1", (0,0,0), (0,0,0) );
	barrel_2 linkto( rig, "J_prop_2", (0,0,0), (0,0,0) );
	clip_b1 = getent( "rc_clip_b1", "targetname" );
	clip_b2 = getent( "rc_clip_b2", "targetname" );
	
	clip_b1 LinkTo( barrel_1 );
	clip_b2 LinkTo( barrel_2 );
	//rig attach("com_barrel_green_dirt","J_prop_1", 0);
	//rig attach("com_barrel_green_dirt","J_prop_2", 0);
		
	flag_wait( "city_rollcar_start" );
	trigger_off( "streets_after_carboom", "script_noteworthy" );
	car = GetEnt( "city_rollcar" , "targetname" );
	car_clip = GetEnt( "streets_car_clip", "targetname" );
	car_clip LinkTo( car );
	
	car.animname = "city_rollcar";
	car SetAnimTree();
	//car solid();
		
	left_pusher = spawn_targetname( "city_rollcar_push_left" );
	left_pusher.animname = "generic";
	right_pusher = spawn_targetname( "city_rollcar_push_right" );
	right_pusher.animname = "generic";

	ref thread anim_single_solo( left_pusher , "payback_city_pushcar_left" );
	ref thread anim_single_solo( right_pusher , "payback_city_pushcar_right" );
	left_pusher.allowdeath = true;
	right_pusher.allowdeath = true;
	
	//thread gopath( pickup );
	//ref thread anim_single_solo( car , "payback_city_rollcar" );
	thread rollcar_anim ( ref, car );
	car anim_self_set_time( "payback_city_rollcar" , 0.33 );
	
	thread rollcar_hits_player( car_clip );
	wait(0.05);
	left_pusher setanimtime(left_pusher getanim_generic( "payback_city_pushcar_left" ), 0.45 );
	right_pusher setanimtime(right_pusher getanim_generic( "payback_city_pushcar_right" ), 0.45 );
		
	ref thread anim_single_solo( rig, "payback_city_truck_push_barrels" );
	wait(0.05);
	rig setanimtime(rig getanim( "payback_city_truck_push_barrels" ), 0.30 );
	// anim for barrels payback_city_truck_push_barrels
	
	node_left = getnode( "streets_nodeleft", "targetname" );
	node_right = getnode( "streets_noderight", "targetname" );
	left_pusher.goalradius = node_left.radius;
	right_pusher.goalradius = node_right.radius;
	left_pusher set_goal_node( node_left );
	right_pusher set_goal_node( node_right );
	//left_pusher thread pusher_delete();
	//right_pusher thread pusher_delete();
	wait .5;
	thread badplace1_rollcar();
	aud_send_msg("city_car_roll", car);
	thread rollcar_dialog();
		
	fx_tag_origin = spawn_tag_origin();
	fx_tag_origin LinkTo(car, "tag_hood", (0,0,0),(-90,0,0));
	
	PlayFXOnTag( level._effect["rollcar_fire_hood"] , fx_tag_origin , "tag_origin" );
	wait 1.0;
	PlayFXOnTag( level._effect["rollcar_fire_body"] , car , "tag_death_fx" );
	texploder(5300);
	exploder(5000);
	
	bad_spot = getStruct( "city_rollcar_badspot" , "targetname" );
	BadPlace_Cylinder( "vehicle_kill_badplace", 7 , bad_spot.origin , bad_spot.radius , bad_spot.height , "axis" , "allies" );
	
	flag_wait("city_rollcar_switchmodel");
	car SetModel( "vehicle_80s_hatch1_scriptable_destroyed" );
	aud_send_msg("city_car_explosion", car);
	PlayFXOnTag( level._effect["rollcar_death"] , car , "tag_death_fx" );
	car RadiusDamage( car.origin , 300 , 175 , 20 , car );
	//rig delete();
	flag_set( "streets_area3_end" );
	trigger_on( "streets_after_carboom", "script_noteworthy" );
	
}

rollcar_anim( ref, car )
{
	ref anim_single_solo( car , "payback_city_rollcar" );
	level notify( "rollcar_stop" );
}

rollcar_hits_player( car_clip )
{
	level endon( "rollcar_stop" );
		
	while ( 1 )
	{
		b_touched_player = car_clip IsTouching( level.player );
		if ( b_touched_player )
		{
			level.player DoDamage(1000, car_clip.origin, car_clip );
			level notify( "rollcar_stop" );
		}
	wait .05;
	}
}

badplace1_rollcar()
{
	wait .3;
	bad_spot1 = getStruct( "city_rollcar_badspot1" , "targetname" );
	BadPlace_Cylinder ( "vehicle_kill_badplace1", 3 , bad_spot1.origin , bad_spot1.radius , bad_spot1.height , "axis" , "allies" );
}

pusher_delete()
{
	self endon("death");
	self waittill( "reached_path_end" );
	if( IsDefined( self ) )
	{
		self Delete();
	}
}

rollcar_dialog()
{
	level.soap dialogue_queue( "payback_mct_contactfront" );
}
// TIMER FUNCTIONS
// AUTOSAVE FOR TIMER

streets_save_triggers()
{
	trigger_array = getentarray( "sandstorm_save", "targetname" );
	for ( i = 0; i < trigger_array.size; i++ )
	{
		trigger_array[ i ] thread my_autosave();
	}	
}
	
my_autosave()
{
    self waittill( "trigger" );
	assertex( isdefined( self.script_savetrigger_timer ), "savetrigger needs script_timer value" );
    autosave_by_name_wraper( "s2_city", self.script_savetrigger_timer );
}

autosave_by_name_wraper( save_name, required_time )
{
	assertex( isdefined( required_time ), "required_time is needed to save" );

	if ( isdefined( level.start_time ) )
	{
		current_time = gettime();
		elapsed_time = ( current_time - level.start_time ) / 1000 / 60;

		remaining_time = level.stopwatch - elapsed_time;
		required_time = required_time * level.required_time_scale;

		if ( remaining_time < required_time )
			return;
	}
    //autosave_by_name ( save_name );
    autosave_or_timeout( save_name, 12 );
}

sandstorm_timer_cleanup()
{
	flag_wait( "streets_player_at_sec_LZ" );
	sandstorm_killTimer();
}

sandstorm_killTimer()
{
	level notify( "sandstorm_kill_timer" );
	if ( isdefined( level.timer ) )
		level.timer destroy();
}

sandstorm_timer()
{
	if ( level.start_point == "s2_construction" )
	{
		level.stopwatch = 1; // 3 is the standard time
		level.required_time_scale = 1;
	}
	else
	{
		switch( level.gameSkill )
		{
		case 1: //medium
			level.stopwatch = 3.0;
			level.required_time_scale = 1;
			
			break;
		case 2: //hard
			level.stopwatch = 3.0;
			level.required_time_scale = 1;
			
			break;
		case 3: //FU difficulty
			level.stopwatch = 2.75;
			level.required_time_scale = 1;
						
			break;
		default: // Easy
			level.stopwatch = 3.5;           
			level.required_time_scale = 1.36;
			
			break;
		}
	}

	level endon( "sandstorm_kill_timer" );
	level.hudTimerIndex = 20;
	level.timer = maps\_hud_util::get_countdown_hud( -250, 100 );
	level.timer SetPulseFX( 30, 900000, 700 );// something, decay start, decay duration
	level.timer.label = &"PAYBACK_SANDSTORM_ARRIVAL";
	level.timer settenthstimer( level.stopwatch * 60 );
	level.start_time = gettime();

	thread sandstorm_timer_cleanup();
	thread sandstorm_timer_tick();
	wait ( level.stopwatch * 60 );
	//player is a loser!
	//if needed a flag_set (flag to notify other threads or states)
	level.timer destroy();
	level thread mission_failed( &"PAYBACK_FAIL_SECONDLZ" );
}

mission_failed( deadquote )
{
	level.player endon( "death" );
	level endon( "kill_timer" );
	level notify( "mission failed" );
	
	level.player freezeControls( true );
	level.player thread player_sandstorm_death_effect();
	//level.player thread play_sound_on_entity( "airplane_final_explosion" );
	musicstop( 1 );
	setDvar( "ui_deadquote", deadquote );
	maps\_utility::missionFailedWrapper();
	level notify( "sandstorm_kill_timer" );
	level.streets_timer = false;
}


sandstorm_timer_tick()
{
	level endon( "stop_timer_tick" );
	level endon( "sandstorm_kill_timer" );
	wait ((level.stopwatch * 60) - 60);
	
	while ( true )
	{
		wait( 1 );
		level.player thread play_sound_on_entity( "countdown_beep" ); 
		level notify( "timer_tick" );
	}
}


player_sandstorm_death_effect()
{
	player = level.player;
//	playfx( level._effect[ "player_death_explosion" ], player.origin );

	earthquake( 1, 1, level.player.origin, 100 );
}

//POST_AMBUSH

handler_area1_to_guardhouse()
{
	flag_wait("streets_tech_runaway");
 	thread runners_area2_narrowstreet();
	thread spawn_area2_narrowstreet();
	thread handler_streets_area2();
	thread make_murdock_mortal();
	thread streets_area2_runners();
	thread streets_area2_runners_cleanup();
	thread handler_player_moves_side();
}

sjp_setup()
{
	sjp_watchvolume_empty();
	level.soap disable_sprint();
	level.price disable_sprint();

	// disables all NPC move triggers in area before moveup is called
	flag_set( "streets_ambush_over" );
	activate_trigger_with_targetname_check_active( "sjp_ambush_over" );
	wait 1.5;
	trigger_activate_targetname_safe( "streets_area1_cleanup" );
	// as the player clears out the area where the technical was, move the allies into the open space.
	flag_wait("streets_tech_runaway_move" );
	wait 7;

	wait_until_enemies_in_volume( "sjp_narrowstreet_int_colormoveup_vol" , 1 );
	flag_set( "streets_mid_over" );
	activate_trigger_with_targetname_check_active( "sjp_narrowstreet_int_colormoveup" );
	
	wait_until_enemies_in_volume( "sjp_narrowstreet_colormoveup_vol" , 0 );
	activate_trigger_with_targetname_check_active( "narrowstreet_colormoveup" );
	

	thread handle_rolling_truck_corner();
	//thread handle_thin_streets();
}

streets_area2_runners()
{
	level endon( "notify_streets_area2_playermidpush" );
	flag_wait( "streets_area2_runners" );
	thread handler_ambush_cleanup();
	
	flag_wait( "streets_tech_passedmid" );	
	level.group2 = array_spawn_targetname( "streets_area2_runners2" );
	foreach(man in level.group2)
	{
		if (IsAlive(man))
		{	
			man thread runners_flee();
		}
	}

	wait .1;
	
	level.group3 = array_spawn_targetname( "streets_area2_runners3" );
	foreach(man in level.group3)
	{
		if (IsAlive(man))
		{	
			man thread runners_flee();
		}
	}

}

runners_flee()
{
	self waittill( "goal" );
	self Delete();
}

streets_area2_runners_cleanup()
{
	flag_wait( "streets_area3_start_mainpath" );
	thread AI_delete_when_out_of_sight( level.group2, 256);
	thread AI_delete_when_out_of_sight( level.group3, 256);

}

sjp_watchvolume_empty()
{
	wait_until_enemies_in_volume( "sjp_ambush_area" , 4 );
	trigger_activate_targetname_safe( "streets_area1_wave3_trig" );
	
	wait_until_enemies_in_volume( "sjp_ambush_area" , 0 );
}

handle_rolling_truck_corner()
{
	flag_wait( "sjp_truck_corner" );
	thread sjp_watch_axis_alldead();
	// wait for a while until the enemies all get into place, then start monitoring for moving up.
	wait 8;
	wait_until_enemies_in_volume( "sjp_truckcorner_init", 1 );
	
	if(player_in_vol( "sjp_truckcorner_init" ) )
	{
		trigger_activate_targetname_safe( "sjp_truckcorner_color" );
	}
	
	wait_until_enemies_in_volume( "sjp_truckcorner_top", 2 );
	trigger_activate_targetname_safe( "sjp_truckcorner_top_color" );
}

handle_thin_streets()
{
	flag_wait( "sjp_street_way" );
	
	// Give the player a few seconds to make a choice (once the enemy are dead), and then move everyone on.
	sjp_wait_player_decide( 5, "sjp_player_chose_way_streets1", "sjp_color_way_streets1" );
	
	
	flag_wait( "sjp_start_watching_end" );
	wait 7;
	thread sjp_watch_axis_alldead();
	wait_until_enemies_in_volume( "sjp_truckcorner_top", 3 );
	
	activate_trigger_with_targetname_check_active( "sjp_streets_top_color" );
	//IPrintLnBold( "Activating top color from thin street" );
	
}

sjp_watch_axis_alldead()
{
	level notify( "sjp_alldead" ); 
	level endon( "sjp_alldead" );
	
	while(1)
	{
		axis = GetAIArray( "axis" );
		if(axis.size == 0 )
		{
			activate_trigger_with_targetname_check_active( "sjp_allies_to_end" );
			flag_set( "sjp_axis_all_dead" );
			
			//Do this last as it will terminate the function.
			level notify( "sjp_alldead" ); 
		}
		
		wait 1;
	}
}

//as the player is following price, he may decide NOT to make forward progress- if so, we do it for them.
sjp_wait_player_decide(waittime, waitflag, setflag)
{
	wait waittime;
	if( !flag( waitflag ) )
	{
		activate_trigger_with_targetname_check_active( setflag );
	}
	
}

player_in_vol( vol)
{
	checkvol= GetEnt( vol ,"targetname");
	AssertEx( IsDefined(checkvol), "volume undefined " + vol );
	if( level.player IsTouching( checkvol ) )
	{
		return true;
	}
	return false;	
}

activate_trigger_with_targetname_check_active( triggername )
{
	trigger = GetEnt( triggername, "targetname" );
	if( IsDefined( trigger ) )
	{
		if( !IsDefined( trigger.trigger_off	) || trigger.trigger_off == false )
		{
			trigger activate_trigger();
			trigger trigger_off();
			return;
		}
	}                          
	//IPrintLnBold( "failed to activate trigger " + triggername );
	
}

colorbarracus( color )
{
	if( !isdefined( level.barracus ) )
	{
		level waittill( "barracus_spawned" );
	}
	level.barracus set_force_color( color );

}
colormurdock( color )
{
	if( !isdefined( level.murdock ) )
	{
		level waittill( "murdock_spawned" );
	}
	level.murdock set_force_color( color );
}
handler_streets_area2()
{
	flag_wait( "streets_area2_begin" );
	level notify( "notify_streets_area2_playermidpush" );
	thread handler_spawn_area3_end();
	thread handler_rollcar_sequence();
	
	wait 1;
	level.scr_radio radio_dialogue( "payback_nik_winds" );
	
	wait 1;
	level.price dialogue_queue( "payback_pri_ontheway" );			
	
//vo
//	level.price dialogue_queue( "payback_pri_crossstreets" );
//	wait 2;
//	level.price dialogue_queue( "payback_pri_beforethestorm" );
}

handler_ambush_cleanup()
{
	ambushvol = getEnt( "sjp_ambush_area", "targetname" );
	aAxis = ambushvol get_ai_touching_volume( "axis" );
	thread AI_delete_when_out_of_sight( aAxis, 768 );
	
	goalVolume = getEnt( "streets_ambush_clear" , "targetname" );
    goalVolumeTarget = getNode( goalVolume.target , "targetname" );
	foreach( enemy in aAxis )
	{
		if ( IsAlive( enemy ))
		{
			enemy.sprint = true;
			enemy SetGoalNode( goalVolumeTarget );
			enemy SetGoalVolume( goalVolume );
		}
	}	
}

spawn_area1_vehicle2() 
{
	//level.vehicle_drivein = spawn_vehicle_from_targetname_and_drive( "sub_pmc_enemies_1001" );
	array_spawn_targetname( "sub_pmc_enemies_2" );
	
	tech = spawn_vehicle_from_targetname_and_drive( "streets_tech_1" ); //this also spawns tech waiting in area 2
	tech godon();
	streets_tech_driver = getentarray( "streets_tech_driver", "script_noteworthy" );
	foreach(man in streets_tech_driver)
	{
		if (IsAlive(man))
		{	
			man deletable_magic_bullet_shield();
		}
	}
		
}

spawn_area1_wave2()
{
	array_spawn_noteworthy( "streets_area1_wave2" );
	wait 3;

}

spawn_area1_wave3()
{
	//enemies = get_ai_group_ai ( "streets_area1_topfloor" );
	//enemies = getaiarray ( "axis" ); dano note this worked
	//goalVolume = getEnt( "streets_area1_end" , "targetname" );
    //goalVolumeTarget = getNode( goalVolume.target , "targetname" );
	//foreach( enemy in enemies )
	//{
	//	if ( IsAlive( enemy ))
	//	{
	//		enemy.sprint = true;
	//		enemy SetGoalNode( goalVolumeTarget );
	//		enemy SetGoalVolume( goalVolume );
	//	}
	//}
}

runners_area2_narrowstreet()
{
	flag_wait( "streets_tech_runaway" );
	
	streets_tech_gunner = getentarray( "streets_tech_gunner", "script_noteworthy" );

	foreach(dude in streets_tech_gunner)
	{
		if ( IsAlive( dude ))
		{
			dude set_ignoreall(false);
			dude set_ignoreme(false);
		}
	}
	
	array_spawn_targetname( "streets_area2_ns_runners" );
	wait 4;
	array_spawn_targetname( "streets_area2_ns_runners1" );
	
	flag_wait("streets_area2_begin");

}

spawn_area2_narrowstreet()
{
	spawned1 = array_spawn_noteworthy( "streets_area2_narrowstreet" );
	wait 4;

	flag_set("streets_tech_runaway_move" );
	spawned2 = array_spawn_noteworthy( "streets_area2_narrowstreet2" );
		
}

handler_player_moves_side()
{
	//flanking path at last battle
	flag_wait( "streets_area3_start_sidepath" );
	array_spawn_targetname( "area3_sidestreet_runners" );
		
}

handler_spawn_area3_slopealley()
{
	level endon ( "notify_streets_area3_end" );
	flag_wait("streets_area3_slopealley");
	level notify ( "notify_streets_area3_slopealley");
//	array_spawn_noteworthy( "streets_area3_slopealley");
}


handler_spawn_area3_end()
{
	level endon ( "notify_streets_complete" );
	
	flag_wait ( "streets_area3_end" );
	wait .5;
//	autosave_by_name( "s2_city" );
//	trigger_off( "streets_end_no_backspawn", "script_noteworthy" );
	array_spawn_noteworthy( "streets_area3_end" );

	trigger_off( "streets_area3_allydisable_top", "script_noteworthy" );
	trigger_off( "streets_colors", "script_noteworthy" );
	thread vo_streets_end();
	
	//endbattle_ai = get_ai_group_ai( "streets_endbattle" );
	//waittill_dead_or_dying( endbattle_ai, 9 );
	wait_until_enemies_in_volume( "streets_finalbattle", 2 );
	trigger_off( "streets_area3_start_sidepath_trig", "targetname" );
	goalVolume = getEnt( "streets_area3_leftovers" , "targetname" );
    goalVolumeTarget = getNode( goalVolume.target , "targetname" );
	endbattle_ai = getaiarray( "axis" );
    foreach( enemy in endbattle_ai )
	{
		if ( IsAlive( enemy ))
		{
			enemy SetGoalNode( goalVolumeTarget );
			enemy SetGoalVolume( goalVolume );
			
		}
	}
	
	wait_until_enemies_in_volume( "streets_finalbattle", 0 );
	trigger_activate_targetname_safe( "streets_lastallymove" );
		
	level notify ( "notify_streets_finished");
	flag_set ( "streets_area3_start_mainpath" ); //this kills all of back triggers that might be on/off
	wait 2;
	level.price dialogue_queue( "payback_pri_lzisclose" );
}

handler_streets_vo_000()
{
	flag_wait( "streets_area1_ambush" );
	// "We'll be there in 20 seconds."
	//level.price dialogue_queue( "payback_pri_20seconds" );

	// "That storm is massive."
	//level.soap dialogue_queue( "payback_mct_massive" );
	// "We do not want to get caught in that nightmare. Let’s move."
	//level.price dialogue_queue( "payback_pri_nightmare" );
	
	// "You think Kruger was telling the truth about Volk?"
	level.soap dialogue_queue( "payback_mct_tellingtruth" );
	// "Oh, yeah, he was telling the truth - I d bet Makarov s life on it."
	level.price dialogue_queue( "payback_pri_tellingtruth" );
	// "We'll start making plans for Paris as soon as we get back, then we can talk to ..."
	level.price dialogue_queue( "payback_pri_makingplans" );

	
}

streets_vo_010()
{
	wait .5;
	// NEW: "Check left."
	level.price dialogue_queue( "payback_pri_checkleft" );
	wait 1;
	// NEW: "Clear."
	level.soap dialogue_queue( "payback_mct_clear2" );
	wait .5;
	// "Watch those rooftops"
	level.price dialogue_queue( "payback_pri_watchrooftops" );
}

streets_vo_ambush()
{
	//SNIPER!!!

	level.soap thread dialogue_queue( "payback_mct_sniper" );

	wait .4;
	//AMBUSH!!!
	level.soap dialogue_queue( "payback_mct_ambush" );
	wait .5;
		//NIK, OUT OF HERE!
	level.price dialogue_queue( "payback_pri_outofhere" );
	wait .5;
		//remove chopper distance marker
	Objective_complete( obj("obj_primary_lz") );
	 	
	
	//TAKE COVER!!!
	level.price dialogue_queue( "payback_pri_takecover" );
	wait 1;
		
	
	// "Contact right! Contact right!"
	level.price dialogue_queue( "payback_pri_contactright" );
	
	wait .5;
	// NEW: "Spread Out"	
 	level.soap dialogue_queue( "payback_mct_spreadout" ); 	
 	
 	wait 1;
 	// "Get outta the open!"	
 	level.price dialogue_queue( "payback_pri_outtatheopen" );
 	
 	wait 3;
 	
 	level.soap dialogue_queue( "payback_mct_rooftops" );
 	
 	wait 1;
  	
 	level.price dialogue_queue( "payback_pri_nikolaisecondary" );
 	
 	wait .5;
 	
 	level.scr_radio radio_dialogue( "payback_nik_sandstormcoming" );
 	
 	wait .25;	
	level.price dialogue_queue( "payback_pri_justbethere" );
 	
 	 	
}

streets_vo_020()
{
	level.price dialogue_queue( "payback_pri_beforethestorm" );
	
}
/*
 	level.soap dialogue_queue( "" );
 	level.price dialogue_queue( "" );
 	
 	level.scr_radio radio_dialogue( "" );
*/

vo_streets_030()
{
	flag_wait("streets_vo_030");
	//level.player radio_dialogue( "payback_nik_krugersestate_r" ); 	// "Captain Price, Kruger's heading for his estate.  I've got to leave - this sand storm is playing hell with my engines."  
	//level.price dialogue_queue( "payback_pri_rogerstayclose_r" );  // "Roger that. But stay close, we'll need you for exfil.  All teams, we're heading to Kruger estate. Let's go!" 	
}
	
/*
	// "Almost there - the LZ looks clear but I’ve got movement in the distance."
	level.scr_radio[ "payback_nik_lzlooksclear" ] = "payback_nik_lzlooksclear";
	
	// "We’ll be there in 20 seconds."
	level.scr_sound[ "price" ][ "payback_pri_20seconds" ] = "payback_pri_20seconds";

	
*/

vo_streets_end()
{
	if( isdefined( level.east_entry ) == false )
	{
		level.scr_radio radio_dialogue( "payback_nik_enemiesclosing" );
	}
	
	wait 1;
 	level.price dialogue_queue( "payback_pri_moreonroof" );
 	
 	wait 2;
 	level.price dialogue_queue( "payback_pri_keeppushing" );
 	
 	aud_send_msg("start_rpg_listener");
}

make_murdock_mortal()
{
	if( isdefined( level.murdock ) == false )
	{
		level waittill( "murdock_spawned" );
		
	}
	level.murdock notify( "_disable_reinforcement" );

}

make_hannibal_mortal()
{
	if( isdefined( level.hannibal ) == false )
	{
		level waittill( "hannibal_spawned" );
		
	}
	level.hannibal notify( "_disable_reinforcement" );
}

streets_moderate_ai_moveplaybackrate()
{
	min_playback = 1.00;
	min_dist = 50;
	max_playback = 1.50;
	max_dist = 200;

	// how much can the player sprint?	
	min_sprint = .8;
	max_sprint = 1.4;
	min_sprint_dist = 100;
	max_sprint_dist = 200;
	
	max_speed_dif = 0.45; // the maximum difference in speed adjustment between the lead and last ai
	max_dist_dif = 200; // the distance at which to differ by max speed dif
	
	// the distance mods make the AI get a speed boost/slowdown to get them to the right place
	distance_mods = [];
	distance_mods[ "soap" ] = -10;
	distance_mods[ "price" ] = 20;
	//distance_mods[ "hannibal" ] = 0;
	distance_mods[ "murdock" ] = 20;
	distance_mods[ "barracus" ] = 20;
	
	ai = [];
	ai[ "soap" ] = level.soap;
	ai[ "price" ] = level.price;
	//ai[ "hannibal" ] = level.hannibal;
	ai[ "murdock" ] = level.murdock;
	ai[ "barracus" ] = level.barracus;
		
	moderate_ai_moveplaybackrate( "streets_ambush_presnipe" , min_playback , max_playback , min_dist , max_dist ,
	                              min_sprint , max_sprint , min_sprint_dist , max_sprint_dist ,
	                              max_speed_dif , max_dist_dif , distance_mods , ai  );
}

streets_speed_reset()
{
	ai =[];
	ai[ "soap" ] = level.soap;
	ai[ "price" ] = level.price;
	ai[ "murdock" ] = level.murdock;
	ai[ "barracus" ] = level.barracus;
	
	moderate_reset( ai );
}
