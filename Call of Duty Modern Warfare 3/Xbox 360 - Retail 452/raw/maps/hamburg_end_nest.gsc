#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_end;
#include animscripts\hummer_turret\common;
#include maps\hamburg_tank_ai;
#include maps\_audio;
#include maps\_hud_util;

ALLYIN2AXIS_IN_PLAYER_OUT							=  5000;
ALLYOUT2AXIS_IN_PLAYER_OUT							= -5000;	
ALLYIN2AXIS_OUT_PLAYER_OUT							=  2500;
ALLYOUT2AXIS_OUT_PLAYER_OUT							=  5000;	

ALLYIN2AXIS_IN_PLAYER_IN							=  2500;
ALLYOUT2AXIS_IN_PLAYER_IN							=  200;	
ALLYIN2AXIS_OUT_PLAYER_IN							=  -5000;
ALLYOUT2AXIS_OUT_PLAYER_IN							=  5000;

begin_ambush()
{
	
}

setup_ambush()
{
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	startstruct = getstruct( "start_ambush", "targetname" );

	if(isdefined(startstruct))
	{
		level.player SetOrigin( startstruct.origin );
		level.player SetPlayerAngles( startstruct.angles );
	}
	
	spawn_allies(1);
	//setup_spawn_funcs();

	battlechatter_on( "allies" );
    battlechatter_on( "axis" );
    
    setup_suv_scene_bodies();
    thread setup_hvt_vehicles();
    thread squad_goto_hvt_vehicles();
	
	thread setup_flickering_lights();
	thread handle_null_breach();
	thread squad_goto_hvt_vehicles_failsafe();
	
	set_no_explode_vehicles();
    
	wait 1;
	
	flag_set("flag_goto_hvt_vehicles");
	
}

setup_nest()
{
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	startstruct = getstruct( "start_crows_nest", "targetname" );

	if(isdefined(startstruct))
	{
		level.player SetOrigin( startstruct.origin );
		level.player SetPlayerAngles( startstruct.angles );
	}
	
	spawn_allies(1);
	//setup_spawn_funcs();
	//thread maps\hamburg_end_streets::rogers_open_door();
	
	
	//array_spawn_function_noteworthy( "enemy_javelin", ::AI_jav_sting_spot_think );
	//thread spawn_setup_javelin_rooftops();
	thread maps\hamburg_end_streets::f15_bomber();
	flag_set("rooftop_javs_dead");
	
	wait 1;
	
	battlechatter_on( "allies" );
    battlechatter_on( "axis" );
    
	set_no_explode_vehicles();
	
	thread maps\hamburg_code::cleanup_bridge_and_before_garage_area();
	//IPrintLnBold("deleted_first");
	wait 2;
	//IPrintLnBold("deleted 2");
	thread maps\hamburg_code::garage_cleanup_beach_area();
	//IPrintLnBold("deleted_3");
	thread axisdebug();

}

axisdebug()
{
   level.db_axis = 0;    
   while(1)
    {
        axis = GetAIArray( "axis" );
        if( axis.size != level.db_axis )
        {
            level.db_axis = axis.size ;            
            IPrintLn("T:"+axis.size );
        }
        wait 0.1;
    }
    
}


setup_end()
{
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	startstruct = getstruct( "start_end", "targetname" );

	if(isdefined(startstruct))
	{
		level.player SetOrigin( startstruct.origin );
		level.player SetPlayerAngles( startstruct.angles );
	}
	spawn_allies(1);
	//setup_spawn_funcs();

	battlechatter_off( "allies" );
    battlechatter_on( "axis" );
    
	//array_spawn_function_noteworthy( "enemy_javelin", ::AI_jav_sting_spot_think );
	//thread spawn_setup_javelin_rooftops();
    
	thread setup_flickering_lights();
	//thread setup_dead_hvts();
	thread handle_null_breach();
	setup_suv_scene_bodies();
    thread setup_hvt_vehicles();
    //setup allies to ignore enemies
    //setup_nest_allies();
	set_no_explode_vehicles();
    
}


nest_pre_load()
{
	thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance0_outside_battle2");
	thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance2_outside_battle2");
	thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance1_outside_battle2");
	thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance3_outside_battle2");
	thread maps\hamburg_end_nest::check_trigger_flagset("trig_advance4_outside_battle2");	
	
	//End Nest Section
	
	flag_init( "nest_go_wave1a" );
	flag_init( "approaching_null_breach" );
	flag_init( "finish_mission" );
	
	flag_init( "start_outside_battle2" );
	flag_init( "advance0_outside_battle2" );
	flag_init( "flag_nest_apache_killspot" );
	flag_init( "advance1_outside_battle2" );
	flag_init( "advance2_outside_battle2" );
	flag_init( "advance3_outside_battle2" );
	flag_init( "advance4_outside_battle2" );
	flag_init( "advance5_outside_battle2" );
	
	flag_init( "nest_advance_inside1" );
	flag_init( "follow_sandman_nest" );
	flag_init( "rooftop_javs_dead" );
	flag_init( "endstreet_helis");
	flag_init("go_rooftop_heli");
	flag_init("player_approaching_breach");
	
	flag_init( "flag_goto_hvt_vehicles" );
	flag_init( "allies_follow_sandman_to_breach" );
	flag_init( "squad_at_hvts" );
	flag_init( "flag_streets_apache_killspot" );
	flag_init("retreat_balconyguys");
	flag_init("stop_breach_chatter");
	flag_init("goalpost_dead");
	flag_init("close_breach_door");
	flag_init("sandman_at_breach");
	flag_init("flag_search_scene_failsafe");
	flag_init("search_scene_finished");
}


begin_nest()
{
	level.destructible_protection_func = undefined;

	//level.playervehicle = level.end_tank;
	
	//thread autosave_now(1);
	
	thread go_rooftop_heli();
	//thread setup_spawn_funcs();
	//thread handle_nest_ally_threatbiasgroup();

	/*
	array_spawn_function_noteworthy( "enemy_javelin", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_spotter_crouched", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_spotter", ::AI_jav_sting_spot_think );
	*/
	
	//thread objective_follow_rogers_nest();

	
	//Objectives
	
	
	//thread spawn_nest_drones1();
	
	/*
	thread spawn_nest_wave1();
	
	thread spawn_nest_wave1b();
	thread spawn_nest_wave1c();
	thread spawn_nest_wave1d();
	thread spawn_nest_wave1e();
	thread battle_ambience1();
	*/
	
	//thread setup_nest_enemies();
	//thread nest_approach_vo();
	flag_wait( "nestfoot_finished" );
	
}

breachroom_close_the_door()
{
	/*-----------------------
	BREACH SETUP
	-------------------------*/	
	icon_trigger = GetEnt( "trigger_breach_icon", "targetname" );
	icon_trigger trigger_off();
	
	usetrigger = getent("hamburg_trigger_use_breach","targetname");
	//usetrigger trigger_off();
	usetrigger disable_trigger_with_targetname("hamburg_trigger_use_breach");

	wait( 1 );
	//hide the breach door model for now
	breach_door = level.breach_doors[ 2 ];
	breach_door Hide();

	breach_path_clip = GetEnt( "breach_solid", "targetname" );
	breach_path_clip NotSolid();
	breach_path_clip ConnectPaths();

	old_door = GetEnt( "blast_door_slam", "targetname" );// this is the wood door
	old_door.origin = breach_door.origin;
	startAngles = old_door.angles;
	old_door.angles += ( 0, -74, 0 );

	/*-----------------------
	GUY CLOSES BREACH DOOR
	-------------------------*/	
	flag_wait( "close_breach_door" );
	thread nest_enemy_battlechatter();
	/*
	guy = spawn_targetname( "control_room_door_close_guy", true );
	guy set_ignoreme( true );
	guy set_ignoreall( true );
	guy thread magic_bullet_shield();

	node = GetNode( "sheppard_door_peek", "targetname" );

	node anim_generic_reach( guy, "alert2look_cornerR" );
	node anim_generic( guy, "alert2look_cornerR" );
	*/
	
	//flag_set( "breach_door_closed" );

	old_door RotateYaw( 74, .25 );

	old_door thread play_sound_in_space( "breach_door_slam", old_door.origin );

	breach_path_clip Solid();
	breach_path_clip DisconnectPaths();

	wait( .66 );
	old_door thread play_sound_in_space( "breach_headshot", old_door.origin );

	old_door Hide();
	old_door NotSolid();
	breach_door Show();
	wait 0.4;
	old_door thread play_sound_in_space( "breach_headshot", old_door.origin );
	wait .15;
	old_door thread play_sound_in_space( "breach_headshot", old_door.origin );

	
	wait 0.5;
	old_door thread play_sound_in_space( "breach_bodyfall", old_door.origin );

	flag_wait("sandman_at_breach");
	
	icon_trigger trigger_on();
	//usetrigger trigger_on();
	usetrigger enable_trigger_with_targetname("hamburg_trigger_use_breach");
	level waittill( "breaching" );

	icon_trigger trigger_off();

}

setup_battle2_to_hvts()
{
	//thread setup_spawn_funcs();
	thread setup_hvt_vehicles();
	thread objective_follow_sandman();
	//thread objective_hvt_breach();
	thread nest_javelin_apache();
	//thread endstreets_apache();
	thread setup_end_street_combat();
	thread maps\hamburg_end::allied_jets_ambient();
}

begin_end()
{
	level.destructible_protection_func = undefined;
	//level.targetsScriptedJavStinger = [];
	//level.playervehicle = level.end_tank;
	
	thread autosave_by_name( "begin_end" );
	//thread handle_null_breach();
	thread objective_follow_sandman();
	//thread objective_hvt_breach();
	
	
	/*
	array_spawn_function_noteworthy( "enemy_javelin", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_spotter_crouched", ::AI_jav_sting_spot_think );
	array_spawn_function_noteworthy( "enemy_spotter", ::AI_jav_sting_spot_think );
	*/
	
	//thread nest_approach_vo();
	
	
	flag_wait( "nestfoot_finished" );
	
}

ai_array_killcount_flag_set( enemies , killcount , flag , timeout )
{
	waittill_dead_or_dying( enemies , killcount , timeout );
	flag_set( flag );
}


/*
spawn_setup_javelin_rooftops()
{
	wait 1;
	roofspawners = getentarray( "rooftop_jav_barret", "targetname" );
	array_thread( roofspawners, ::add_spawn_function, ::roof_death_anims );
	level.rooftopEnemies = array_spawn( roofspawners, true );
	
	thread handle_rooftop_drones();
	
	foreach(jav in level.rooftopEnemies)
	{
		jav.damageIsFromPlayer = true; //make sure these guys can destroy vehicles
		
	}
	array_thread( level.rooftopEnemies, ::AI_blood_spatter_when_sniped );
	
	thread ai_array_killcount_flag_set(level.rooftopEnemies, level.rooftopEnemies.size, "rooftop_javs_dead");
}
*/
/*
roof_death_anims()
{
	self.animname = "generic";
	self.deathFunction = ::try_balcony_death;
}
*/
/*
try_balcony_death()
{	
	deathAnims = [];
	deathAnims[0] = getanim( "death_rooftop_A" );
	deathAnims[1] = getanim( "death_rooftop_B" );
	deathAnims[2] = getanim( "death_rooftop_D" );
	deathAnims[3] = getanim( "death_rooftop_E" );
	self.deathanim = deathAnims[ randomint( deathAnims.size ) ];
	return false;
}

AI_blood_spatter_when_sniped()
{
	while( isalive( self ) )
	{
		self waittill( "damage", amount, attacker, direction_vec, impact_org );

		if ( ( isdefined( attacker ) ) && ( isdefined( attacker.classname ) && ( attacker.classname == "misc_turret" ) ) )
		{
			if ( !isdefined( impact_org ) )
				break;
			if ( !isdefined( direction_vec ) )
				direction_vec = ( 0, 0, 1 );
			
			//playfx( getfx( "headshot" ), impact_org, direction_vec );
			playfx( getfx( "thermal_body_gib" ), impact_org );
			//playfx( getfx( "headshot3" ), impact_org );
			//playfx( getfx( "headshot4" ), impact_org );
			//PlayFX( <effect id >, <position of effect>, <forward vector>, <up vector> )
		}
	}
}

handle_rooftop_drones()
{
	level endon("rooftop_javs_dead");
	
	thread check_bomb();
		
	while(!flag("rooftop_javs_dead"))
	{

			randint = RandomIntRange(2, 7);
			level.ambient_rooftopdrones = array_spawn_targetname_with_delay("battle_ambience");
		
			foreach(guy in level.ambient_rooftopdrones)
			{
				guy thread remove_drone_on_path_end();
			}
		
			wait(randint);
	}
	
}

check_bomb()
{
	
	thread check_drones_delete();
	
	flag_wait("sjp_f15_firesidewinders_overhead");
	
	wait .25;
	
	checkvol = getEnt( "rooftop_volume" , "targetname" );
	
	helitroops = get_ai_group_ai("helinest_troops");
	drones = checkvol get_drones_touching_volume( "axis" );
	guys = checkvol get_ai_touching_volume("axis");
	
	arrcomb = array_combine(drones, guys);
	
	arrcomb2 = array_combine(arrcomb, helitroops);
	
	
	foreach(guy in arrcomb2)
	{
		if(IsDefined(guy) && IsAlive(guy))
		{
			//guy array_kill();
			guy thread delete_delay();
		}
	}
}

check_drones_delete()
{
	checkvol2 = getEnt( "rooftop_volume2" , "targetname" );
	checkvol3 = getEnt( "rooftop_volume3" , "targetname" );
	
	thread delete_drones( checkvol2 );
	thread delete_drones( checkvol3 );
}

delete_drones( trig )
{
	
	while(1)
	{
		wait 1;
		
		axis = trig get_drones_touching_volume( "axis" );
		
		foreach (dude in axis)
		{
			if(IsAlive(dude) && IsDefined(dude))
			{
				dude delete();
			}
		}
	}
		
}

delete_delay()
{
	//wait .05;
	self delete();
}
*/

check_trigger_flagset(targetname)
{
	trigger = getent(targetname,"targetname");
	
	trigger waittill( "trigger" );

	if ( IsDefined( trigger.script_flag_set ) )
	{
		flag_set( trigger.script_flag_set );
	}
}

/*
debugout()
{
	while(1)
	{
		t = GetEnt( "sjp_debug_trig", "targetname" );
		exists = IsDefined( t);
		f = flag( "flag_goto_hvt_vehicles");
		
		IPrintLn( " trig exists " + exists + "flag is" + f );
		wait 1;
	}
	
}
*/
setup_end_street_combat()
{
//	thread debugout();
	flag_wait("rooftop_javs_dead");
	
	thread autosave_by_name( "rooftop_javs_dead" );
	thread spawn_end_street_wave2();
	thread squad_goto_hvt_vehicles();
	
	//level.fixednodesaferadius_default = 64;
	//level.red1.fixednodesaferadius = 100;
	if(IsDefined(level.green1) && isalive(level.green1))
	{
		level.green1.fixednodesaferadius = 100;
	}
	
	if(IsDefined(level.green2) && isalive(level.green2))
	{
		level.green2.fixednodesaferadius = 100;
	}
		
	guys = array_spawn_targetname_allow_fail("end_streets_wave1");
		
//	level.sandman dialogue_queue( "tank_snd_goodwork" );
	
	music_play( "ham_end_see_ambush" );
	level.sandman dialogue_queue( "hamburg_snd_rooftopsclear" );
	
	level.sandman thread dialogue_queue( "hamburg_snd_convoyatend" );
	
	wait 1;
	
	endstreets_apache();
	
	thread ai_array_killcount_flag_set(guys, (guys.size - 2), "advance1_outside_battle2");
	
	//wait 4;
	
	//thread retreat_from_vol_to_vol("goal_streets_wave0","goal_Lstreets_wave1", 0.1,0.5);
}

spawn_end_street_wave2()
{
	flag_wait("advance1_outside_battle2");
	
	thread autosave_by_name( "advance1_outside_battle2" );
	thread spawn_end_street_wave3();
	//thread destroy_hvts_veh();
	
	thread retreat_from_vol_to_vol("goal_Lstreets_wave0","goal_Lstreets_wave1", .5, 1);
	SafeActivateTrigger("trig_advance1_outside_battle2");
	guys = array_spawn_targetname_allow_fail("end_streets_wave2"); 
	

	
	thread ai_array_killcount_flag_set(guys, (guys.size - 2), "advance2_outside_battle2");
}


spawn_end_street_wave3()
{
	flag_wait("advance2_outside_battle2");
	
	thread autosave_by_name( "advance2_outside_battle2" );
	thread spawn_end_street_wave4();
	
	thread retreat_from_vol_to_vol("goal_Lstreets_wave1","goal_Lstreets_wave3", 1, 2);
	thread retreat_from_vol_to_vol("goal_Rstreets_wave1","goal_Rstreets_wave3", 2, 5);
	

	SafeActivateTrigger("trig_advance2_outside_battle2");
	guys = array_spawn_targetname_allow_fail("end_streets_wave3");
	
	
	
	
	thread ai_array_killcount_flag_set(guys, (guys.size - 2), "advance3_outside_battle2");

	thread endstreethelis();
	
	/*
	level.endsuvs = GetEntArray("endsuvs","targetname");
	
	foreach(car in level.endsuvs)
	{
		car thread maps\hamburg_end::turn_on_headlights();
	
	}
	*/
	
}

spawn_end_street_wave4()
{
	flag_wait("advance3_outside_battle2");
	
	thread autosave_by_name( "advance3_outside_battle2" );
	thread spawn_end_street_wave5();
	
	wave4helis = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 800 );
	
	setup_suv_scene_bodies();
	

	
	SafeActivateTrigger("trig_advance3_outside_battle2");
	
	
	
	level.endstreetguys1 = array_spawn_targetname_allow_fail("end_streets_wave4");
	
	array_spawn_function_targetname("end_streets_nest", maps\hamburg_end::spawn_func_delete_at_path_end);
	end_street_nest = array_spawn_targetname_allow_fail("end_streets_nest");

	
	
	thread ai_array_killcount_flag_set(level.endstreetguys1, (level.endstreetguys1.size - 2), "advance4_outside_battle2");

	

}


spawn_end_street_wave5()
{
	flag_wait("advance4_outside_battle2");
	
	//pre setup breach event stuff
	thread setup_flickering_lights();
	thread handle_null_breach();
	thread squad_goto_hvt_vehicles_failsafe();
	
	thread autosave_by_name( "advance4_outside_battle2" );
	//thread squad_goto_hvt_vehicles();
	
	//retreat_from_vol_to_vol("goal_streets_wave4","goal_streets_wave5");
	thread retreat_from_vol_to_vol("goal_Lstreets_wave3","goal_streets_wave4", 2, 3);
	thread retreat_from_vol_to_vol("goal_Rstreets_wave3","goal_streets_wave4", 2, 5);
	
	SafeActivateTrigger("trig_advance4_outside_battle2");
	level.endstreetguys2 = array_spawn_targetname_allow_fail("end_streets_wave5");
    
	wait 0.05;
	
	radio_dialogue( "tank_hqr_reached" );
	
	//wait 2;
	
	level.sandman dialogue_queue("hamburg_snd_affirmitive");
	level.sandman thread dialogue_queue("hamburg_snd_watchleft");
	combarr = [];
	
	combarr = array_combine(level.endstreetguys1, level.endstreetguys2);
	thread ai_array_killcount_flag_set(combarr, combarr.size, "flag_goto_hvt_vehicles");
	thread ai_array_killcount_flag_set(combarr, int(combarr.size * 0.5), "advance5_outside_battle2");

	flag_wait("advance5_outside_battle2");
	
	//move allies up a bit at corner transition
	SafeActivateTrigger("trig_advance5_outside_battle2");
}

go_rooftop_heli()
{
	flag_wait("go_rooftop_heli");

	rooftopheli = spawn_vehicle_from_targetname_and_drive("endstreets_heli_rooftop");
	endstreets_apache();

}

endstreethelis()
{
	flag_wait("endstreet_helis");
	heliflyby = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 400 );
}


squad_goto_hvt_vehicles()
{   
	level endon("flag_search_scene_failsafe");
	
	aud_send_msg("play_car_horn");
	
	flag_wait("flag_goto_hvt_vehicles");


	
	
	flag_set("retreat_balconyguys");
	
	heliflyby = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 400 );
	
	
	thread setup_hvt_vehicles();
/* Testing the respawn code if anyone should die.
	wait 2;
	
	if( IsDefined( level.blue2.magic_bullet_shield ) )
		level.blue2 stop_magic_bullet_shield();
	if( IsDefined( level.blue1.magic_bullet_shield ) )
		level.blue1 stop_magic_bullet_shield();
	if( IsDefined( level.green1.magic_bullet_shield ) )
		level.green1 stop_magic_bullet_shield();
	wait 0.1;	
	
	level.blue2 Kill();
	level.blue1 Kill();
	level.green1 Kill();

	//wait 0.1;	
	*/
	thread handle_suv_search_anim_veh( level.red1, "sandman","suv1", "suv1b" , "hvt_search_scene_sand", level.suv1, level.suv1_bullets , level.suvbody1 );
	thread green1_handle_suv_search_anim_veh( level.green1, "rogers", "suv2","suv2b" , "hvt_search_scene_rogers", level.suv2, level.suv2_bullets , level.suvbody2 );
	
	thread blue2_handle_search_anim( level.blue2, "leftside", "hvt_search_scene_left" );
	//thread handle_search_anim( level.green2, "generic", "hvt_search_scene_g2", "hvt_search_scene_g2");
	thread blue1_handle_search_anim( level.blue1, "rightside", "hvt_search_scene_right" );
	
	SafeActivateTrigger("trig_post_convoy_colors");
	thread handle_convoy_vo();
	
	//disable_trigger_with_targetname("trig_search_scene_failsafe");
	/*
	level.green1 StopAnimScripted();
	level.green2 StopAnimScripted();
	level.blue1 StopAnimScripted();
	*/
	

}

green1_dialogue_queue( spawned_message, animname, vo_to_play )
{
	
	if( !IsDefined( level.green1) || !IsAlive( level.green1 ) )
	{
		level waittill( spawned_message );
		level.green1.animname = animname;
	
	}
	level.green1 dialogue_queue( vo_to_play );
}

handle_convoy_vo()
{
	level endon("flag_search_scene_failsafe");

	green1_dialogue_queue("greenend1_spawned", "rogers", "hamburg_rhg_wereclear" );
	level.sandman dialogue_queue( "hamburg_snd_checkvehicles" );
	
	flag_wait("squad_at_hvts");
	
	wait 2;
	music_stop( 20 );
	level.green1 dialogue_queue( "hamburg_rhg_nothinhere" );
	
	wait 1;
	
	level.sandman dialogue_queue( "hamburg_snd_nothere" );
	level.sandman dialogue_queue( "hamburg_snd_negativecargo" );
	level.player radio_dialogue( "tank_hqr_anysign" );
	
	
	level.sandman dialogue_queue( "hamburg_snd_copyyourlast" );
	green1_dialogue_queue("greenend1_spawned", "rogers", "hamburg_rhg_lotofblood" );
	green1_dialogue_queue("greenend1_spawned", "rogers", "hamburg_rhg_goinup" );
		
	level.sandman thread dialogue_queue( "hamburg_snd_easy" );
	
	flag_set("search_scene_finished");
	
	SafeActivateTrigger("trig_squad_follow_sandman");
	
	level.red1 enable_cqbwalk();
	level.blue1 enable_cqbwalk();
	level.blue2 enable_cqbwalk();
	level.green1 enable_cqbwalk();
	level.green2 enable_cqbwalk();
	
	
	flag_set("allies_follow_sandman_to_breach");
	
	flag_wait("approaching_null_breach");
	
	
	level.red1 disable_cqbwalk();
	level.blue1 disable_cqbwalk();
	level.blue2 disable_cqbwalk();
	level.green1 disable_cqbwalk();
	level.green2 disable_cqbwalk();
	
	delayThread( 0.5, ::music_play, "ham_end_gobreach");
	level.green1 dialogue_queue("hamburg_rhg_contact");	
	level.sandman dialogue_queue("hamburg_snd_movenow");
	
	flag_wait("sandman_at_breach");
	
	level.sandman thread breach_door_nag();	
}

breach_door_nag()
{
	level endon("breaching");

	while(1)
	{
		self dialogue_queue("hamburg_snd_getacharge");
		
		wait 3;
		
		self dialogue_queue("hamburg_snd_breachandclear");
		
		wait 3;
		
		self dialogue_queue("hamburg_snd_damndoor");
		
		wait 3;
	}
}

squad_goto_hvt_vehicles_failsafe()
{
	level endon("search_scene_finished");
	
	thread check_trigger_flagset("trig_search_scene_failsafe");
	
	flag_wait("flag_search_scene_failsafe");
	

	
	if(IsDefined(level.green1) && IsAlive(level.green1))
	{
		level.green1 anim_stopanimscripted();
	}
		
	if(IsDefined(level.green2) && IsAlive(level.green2))
	{
		level.green2 anim_stopanimscripted();
	}
	
	if(IsDefined(level.blue1) && IsAlive(level.blue1))
	{
		level.blue1 anim_stopanimscripted();
	}
	

	level.red1 anim_stopanimscripted();
	level.red1 enable_sprint();
	level.red1.movePlaybackRate = 1.2;
	
	if(IsDefined(level.green1) && IsAlive(level.green1))
	{
		level.green1 enable_sprint();
		level.green1.movePlaybackRate = 1.2;
	}
	
	if(IsDefined(level.green2) && IsAlive(level.green2))
	{
		level.green2 enable_sprint();
		level.green2.movePlaybackRate = 1.2;
	}
	
	if(IsDefined(level.blue1) && IsAlive(level.blue1))
	{
		level.blue1 enable_sprint();
		level.blue1.movePlaybackRate = 1.2;
	}
	
	if(IsDefined(level.blue2) && IsAlive(level.blue2))
	{
		level.blue2 enable_sprint();
		level.blue2.movePlaybackRate = 1.2;
	}
	
	
	music_play( "ham_end_gobreach");
	
	
	
	SafeActivateTrigger("trig_squad_follow_sandman");
	flag_set("allies_follow_sandman_to_breach");	
	
}


setup_hvt_vehicles()
{
	level.suv1 = GetEnt("endsuv1","targetname");
	level.suv2 = GetEnt("endsuv2","targetname");
	//level.suv3 = GetEnt("endsuv3","targetname");
	
	level.suv1_bullets = GetEnt("endsuv1_bullets","targetname");
	level.suv2_bullets = GetEnt("endsuv2_bullets","targetname");
	//level.suv3_bullets = GetEnt("endsuv3_bullets","targetname");
	
	level.gaz1 = GetEnt("gaz1","targetname");
	level.gaz2 = GetEnt("gaz2","targetname");
	level.gaz3 = GetEnt("gaz3","targetname");
	
	level.suv1.animname = "suv1";
	level.suv2.animname = "suv2";
	//level.suv3.animname = "suv3";
	
	level.suv1_bullets.animname = "suv1b";
	level.suv2_bullets.animname = "suv2b";
	//level.suv3_bullets.animname = "suv3b";
	
	level.gaz1.animname = "gaz1";
	level.gaz2.animname = "gaz2";
	level.gaz3.animname = "gaz3";
	
	level.suv1 SetAnimTree();
	level.suv2 SetAnimTree();
	//level.suv3 SetAnimTree();
	
	
	level.suv1_bullets SetAnimTree();
	level.suv2_bullets SetAnimTree();
	//level.suv3_bullets SetAnimTree();
	
	level.gaz1 SetAnimTree();
	level.gaz2 SetAnimTree();
	level.gaz3 SetAnimTree();
	
	thread hvt_vehicles_firstframe(level.suv1, level.suv2, level.gaz1, level.gaz2, level.gaz3, level.suv1_bullets, level.suv2_bullets, level.suv3_bullets );
}

hvt_vehicles_firstframe(suv1, suv2, gaz1, gaz2, gaz3, suv1b, suv2b, suv3b)
{
	vehs = [];
	vehs[0] = suv1;
	vehs[1] = suv2;
	//vehs[2] = suv3;
	vehs[3] = gaz1;
	vehs[4] = gaz2;
	vehs[5] = gaz3;
	vehs[6] = suv1b;
	vehs[7] = suv2b;
	vehs[8] = suv3b;
	
	scene = getstruct("node_hvt_search_sandman","targetname");
	
	scene anim_first_frame_solo(vehs[0], "hvt_search_scene_sand"  );
	scene anim_first_frame_solo(vehs[1], "hvt_search_scene_rogers"  );
	//scene anim_first_frame_solo(vehs[2], "hvt_search_scene_right"  );
	scene anim_first_frame_solo(vehs[3], "hvt_search_scene_gaz"  );
	scene anim_first_frame_solo(vehs[4], "hvt_search_scene_gaz"  );
	scene anim_first_frame_solo(vehs[5], "hvt_search_scene_gaz"  );
	scene anim_first_frame_solo(vehs[6], "hvt_search_scene_sand"  );
	scene anim_first_frame_solo(vehs[7], "hvt_search_scene_rogers"  );
	scene anim_first_frame_solo(vehs[8], "hvt_search_scene_right"  );
}

rogers_door_open_hvt()
{
	rogers = self;
	rogers PushPlayer( true );
	
	rogers.animname = "generic" ;
	
	goalnode = GetNode( "hvt_door_kick_start" , "targetname" );
	goalstruct = getstruct( "struct_hvt_door_kick_start" , "targetname" );
	
	goalnode anim_reach_and_approach_node_solo( rogers, "doorkick_2_stand");
	
	thread rogers_open_door();
	goalstruct anim_single_solo_run( rogers, "doorkick_2_stand" );
	rogers PushPlayer( false );
	
	
}
rogers_open_door()
{
	wait 0.4;
	
	doorr = GetEnt( "hvt_door_kick_door", "targetname" );
	doorr ConnectPaths();
	doorr RotateYaw( -120, 0.15 );	
	doorr thread play_sound_in_space( "wood_door_kick", doorr.origin );
	flag_clear( "streets_kicked_door" );
}

setup_suv_scene_bodies()
{
	level.hvt_search_sceneorg = getstruct("node_hvt_search_sandman","targetname");
	
	// spinny wheel on destroyed suv
	suv = GetEnt("end_suburban_destroyed","targetname");
	
	joint = spawn_anim_model("suv_spin_wheel_joint", suv.origin);
	joint linkto( suv, "tag_origin");
	
	wheel = spawn_anim_model( "suv_spin_wheel", suv.origin );
	wheel linkto( joint , "J_prop_1" );
	
	suv thread anim_loop_solo( joint, "hamburg_suburban_wheel", "stop_loop");
	
	suvbody1spawner = GetEnt("suvbody1","targetname");
	suvbody2spawner = GetEnt("suvbody2","targetname");
	suvbody3spawner = GetEnt("suvbody3","targetname");
	suvbody3bspawner = GetEnt("suvbody3b","targetname");
	
	suvbody4spawner = GetEnt("suvbody4","targetname");
	suvbody5spawner = GetEnt("suvbody5","targetname");
	suvbody6spawner = GetEnt("suvbody6","targetname");
	suvbody7spawner = GetEnt("suvbody7","targetname");
	

	//thread convoy_bodies();
	
	suvbody1spawner.script_looping = 0;
	suvbody2spawner.script_looping = 0;
	suvbody3spawner.script_looping = 0;
	suvbody3bspawner.script_looping = 0;
	suvbody4spawner.script_looping = 0;
	suvbody5spawner.script_looping = 0;
	suvbody6spawner.script_looping = 0;
	suvbody7spawner.script_looping = 0;
	
	level.suvbody1 = suvbody1spawner dronespawn();
	level.suvbody2 = suvbody2spawner dronespawn();
	level.suvbody3 = suvbody3spawner dronespawn();
	level.suvbody3b = suvbody3spawner dronespawn();
	
	level.suvbody4 = suvbody4spawner dronespawn();
	level.suvbody5 = suvbody5spawner dronespawn();
	level.suvbody6 = suvbody6spawner dronespawn();
	level.suvbody7 = suvbody7spawner dronespawn();
	
	bodies = [];
	bodies[0] = level.suvbody1;
	bodies[1] = level.suvbody2;
	bodies[2] = level.suvbody3;
	bodies[3] = level.suvbody3b;
	bodies[4] = level.suvbody4;
	bodies[5] = level.suvbody5;
	bodies[6] = level.suvbody6;
	bodies[7] = level.suvbody7;
	
	bodies[0].animname = "body1";
	bodies[1].animname = "body2";
	bodies[2].animname = "body3";
	bodies[3].animname = "generic";
	
	bodies[4].animname = "generic";
	bodies[5].animname = "generic";
	bodies[6].animname = "generic";
	bodies[7].animname = "generic";
	
	bodies[0] prep_bodies();
	bodies[1] prep_bodies();
	bodies[2] prep_bodies();
	bodies[3] prep_bodies();
	bodies[4] prep_bodies();
	bodies[5] prep_bodies();
	bodies[6] prep_bodies();
	bodies[7] prep_bodies();
	
	waitframe();
	
	briefcase = GetEnt("hamburg_briefcase","targetname");
	briefcase.animname = "hamburg_briefcase";
	briefcase SetAnimTree();
	level.hvt_search_sceneorg anim_first_frame_solo( briefcase, "scn_hamburg_briefcase" );
	
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[0], "hvt_search_scene_sand" );
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[1], "hvt_search_scene_rogers" );
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[2], "hvt_search_scene_right" );
	
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[3], "hamburg_convoy_search_briefcase_casualty" );
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[4], "hamburg_convoy_search_curb_casualty" );
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[5], "hamburg_convoy_search_front_gaz_russian_casualty" );
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[6], "hamburg_convoy_search_rear_gaz_russian_casualty" );
	level.hvt_search_sceneorg anim_first_frame_solo(bodies[7], "hamburg_convoy_search_suv1_casualty" );
	
}

convoy_bodies()
{
	spawners = getentarray( "convoy_bodies", "targetname" );
	convoy_bodies = [];

	foreach ( spawner in spawners )
	{
		guy = spawner dronespawn();
		guy setcontents( 0 );
		guy.animname = "generic";
		guy.noragdoll = true;
		guy.nocorpsedelete = true;
		guy.ignoreme = true;
		guy.reference = spawner;
		guy.dontDoNotetracks = true;	//allows using of ai _anim functons without getting errors
		guy.script_looping = 0;		//will force drone to scip default idle behavior
		guy gun_remove();
		
		convoy_bodies[ convoy_bodies.size ] = guy;
	
		guy.animation = spawner.animation;
		guy.reference anim_first_frame_solo( guy, guy.animation );
	}
		
}

prep_bodies()
{
	self kill();
	self setcontents( 0 );
	self.noragdoll = true;
	self.nocorpsedelete = true;
	self.ignoreme = true;
	self.dontDoNotetracks = true;	
	//self.drone_override= true;
	self.script_looping = 0;
	self stopanimscripted();
	self.allowdeath = false;
    self.health = 1;
    self.no_pain_sound = true;
    self.diequietly = true;
    //self.a.nodeath = true;
    self.delete_on_death = false;
    //self.NoFriendlyfire = true;
    self.ignoreme = true;
    self.ignoreall = true;
    self.dontEverShoot = true;
    self gun_remove();
    //self InvisibleNotSolid();
}
green1_handle_suv_search_anim_veh( ai, animname,vehanimname,vehbanimname, scene, veh, vehbullets, body ) //flagwaitalive
{
	if( !IsDefined( ai ) || !IsAlive( ai ) )
		{
		level waittill( "greenend1_spawned");
		ai = level.green1;
	}
	// They are alive now- don't let a stray grenade or something kill them off.
	if( !IsDefined( ai.magic_bullet_shield  ) )
	{
		ai thread magic_bullet_shield();
	}
	handle_suv_search_anim_veh( ai, animname,vehanimname,vehbanimname, scene, veh, vehbullets, body ) ;
	

}
handle_suv_search_anim_veh( ai, animname,vehanimname,vehbanimname, scene, veh, vehbullets, body ) //flagwaitalive
{
	
	veh.animname = vehanimname;
	vehbullets.animname = vehbanimname;
	//veh maps\hamburg_end_anim::setup_suv();
	
	guys = [];
	guys[0] = ai;
	guys[1] = body;
	guys[2] = veh;
	guys[3] = vehbullets;
	
	ai disable_ai_color();
    ai set_ignoreall( false );
    ai set_fixednode_false();
    ai set_ignoresuppression( true );
    ai.disablebulletwhizbyreaction = true;
	ai.animname = animname;

	if( ai == level.red1 )
	{
		level.red1.goalradius = 32;
		//Ghetto, sorry.
		level.red1 SetGoalPos( ( -300, 18219, -80 ) );
		level.red1 waittill( "goal" );
	}
	
	level.hvt_search_sceneorg anim_reach_solo( ai, scene );
	aud_send_msg("convoy_victim_1st_car");
	level.hvt_search_sceneorg anim_single( guys ,scene );
	
	//guys[1] kill();
	
	if (scene == "hvt_search_scene_rogers")
	{
		aud_send_msg("stop_car_horn");
	}
	
	//flag_wait("allies_follow_sandman_to_breach");
	ai enable_ai_color();
}

blue1_handle_search_anim( ai , animname, scene ) //flagwaitalive
{
	if( !IsDefined( ai ) || !IsAlive( ai ) )
	{
		level waittill( "blueend1_spawned");
		ai = level.blue1;
		
	}
	// They are alive now- don't let a stray grenade or something kill them off.
	if( !IsDefined( ai.magic_bullet_shield  ) )
	{
		ai thread magic_bullet_shield();
	}
	handle_search_anim( ai , animname, scene );
 
}
blue2_handle_search_anim( ai , animname, scene ) //flagwaitalive
{
	if( !IsDefined( ai ) || !IsAlive( ai ) )
	{
		level waittill( "blueend2_spawned");
		ai = level.blue2;
		
	}
	// They are alive now- don't let a stray grenade or something kill them off.
	if( !IsDefined( ai.magic_bullet_shield  ) )
	{
		ai thread magic_bullet_shield();
	}
	handle_search_anim( ai , animname, scene );
 
}

handle_search_anim( ai , animname, scene ) //flagwaitalive
{
	
	
	ai disable_ai_color();
	ai enable_cqbwalk();
    ai set_ignoreall( false );
    ai set_fixednode_false();
    ai set_ignoresuppression( true );
    ai.disablebulletwhizbyreaction = true;

	ai.animname = animname;
	
	level.hvt_search_sceneorg anim_reach_solo( ai, scene );
	aud_send_msg("convoy_victim_2nd_car");
	level.hvt_search_sceneorg anim_single_solo( ai ,scene );
	
	//flag_wait("allies_follow_sandman_to_breach");
	ai disable_cqbwalk();
	ai enable_ai_color();
}

/*
waittill_alive_and_spawned( flagtowait , ai)
{
	if(!IsDefined(ai) || IsAlive(ai) == false )
    {
        flag_wait(flagtowait);
        return;
    }

}
*/

setup_flickering_lights()
{
	flares = getentarray( "flickerlight1", "targetname" );
	foreach( flare in flares )
		flare thread flareFlicker();

	flares2 = getentarray( "flickerlight1a", "targetname" );
	foreach( flare in flares2 )
		flare thread flareFlicker();
	
	fluorescents = getentarray( "fluorescentFlicker", "targetname" );
	foreach( fluorescent in fluorescents )
		fluorescent thread fluorescentFlicker();

}


fluorescentFlicker()
{
	for ( ;; )
	{
		wait( randomfloatrange( .05, .1 ) );
		
		self setLightIntensity( randomfloatrange( 0.2, 2.5 ) );
	}
}

flareFlicker()
{
	while( isdefined( self ) )
	{
		wait( randomfloatrange( .05, .1 ) );
		self setLightIntensity( randomfloatrange( 0.6, 1.8 ) );
	}
}

retreat_from_vol_to_vol( from_vol, retreat_vol, delay_min, delay_max)
{
	AssertEx (  ((IsDefined(retreat_vol)  && IsDefined( from_vol ) ) ), "Need the two info volume names ." );

	checkvol = getEnt( from_vol , "targetname" );
	retreaters = checkvol get_ai_touching_volume(  "axis" );
	goalvolume = getEnt( retreat_vol , "targetname" );
	goalvolumetarget = getNode( goalvolume.target , "targetname" );
	foreach( retreater in retreaters )
	{
		if(IsDefined(retreater) && IsAlive(retreater))
		{
			//retreater thread maps\hamburg_end_streets::streets_ignore_enemies();
			retreater.fixednode = 0;
			//retreater.sprint = true;
			retreater.pathRandomPercent = randomintrange( 75, 100 );
			retreater SetGoalNode( goalvolumetarget );
			retreater SetGoalVolume( goalvolume );		
			//wait(RandomFloatRange(delay_min,delay_max)); // Only want to wait if we actually processed someone.
			
		}
	}
	
}

handle_null_breach()
{
	flag_wait("approaching_null_breach");
	
	// I just don't want breach setting timescale soundchannels all over. - Nate.
	maps\_slowmo_breach::slomo_sound_scale_setup();
	
	thread maps\_autosave::_autosave_game_now_nochecks();
	
	thread breachroom_close_the_door();
	thread rogers_into_breach_room();
	thread sandman_into_breach_room();
	SetDvar("hostage_missionfail","1");
	
	array_spawn_function_targetname("nestshadowguys", maps\hamburg_end::spawn_func_delete_at_path_end);
	shadowguys = array_spawn_targetname_allow_fail("nestshadowguys");

	foreach(guy in shadowguys)
	{
		guy.moveplaybackrate = 1.3;
		guy.forcegoal = true;
		guy.goalradius = 20;
		guy.ignoreall = true;
		guy.ignoreme = true;
		guy.sprint = true;
		guy.grenadeawareness = 0;
		guy.ignoreexplosionevents = true;
		guy.ignorerandombulletdamage = true;
		guy.ignoresuppression = true;
		guy.fixednode = false;
		guy.disableBulletWhizbyReaction = true;
		guy disable_pain();
		guy magic_bullet_shield(true);
		
		guy.og_newEnemyReactionDistSq = guy.newEnemyReactionDistSq;
		guy.newEnemyReactionDistSq = 0;

	}	
	thread setup_dead_hvts();
	thread swinging_lamp_thread();

	maps\_slowmo_breach::add_slowmo_breach_custom_function( "melee_B_attack", ::_slomo_breach_charger );

	level waittill( "breaching" );
	fade = 2;
	thread music_stop( fade );
	delayThread( fade, ::music_play, "ham_end_activatebreach" );
	battlechatter_off("allies");
	battlechatter_off("axis");
	                 
	breach_enemies = [];
	
	breach_enemies get_ai_group_ai("breach_enemies");
	
	foreach(guy in breach_enemies)
	{
		guy disable_long_death();
	}
	
	goalpost = GetEntArray("scrgoalpost","script_noteworthy");
	
	foreach(thing in goalpost)
	{
		if( !IsSpawner(thing))
		{
			level.realG = thing;
			break;
		}
	}

	flag_wait( "breaching_on" );
	flag_set("stop_breach_chatter");
	
	level.red1 disable_sprint();
	
	if(IsDefined(level.green1) && IsAlive(level.green1))
	{
		level.green1 disable_sprint();
	}
	
	if(IsDefined(level.green2) && IsAlive(level.green2))
	{
		level.green2 disable_sprint();
	}
	
	if(IsDefined(level.blue1) && IsAlive(level.blue1))
	{
		level.blue1 disable_sprint();
	}
	
	if(IsDefined(level.blue2) && IsAlive(level.blue2))
	{
		level.blue2 disable_sprint();
	}
	
	//level.slomobreachduration = 1.75;
	level waittill("slowmo_breach_ending");
	//waittill_aigroupcleared("breach_enemies");
	//waittill_aigroupcount("breach_enemies",4 );
	
	if(IsAlive(level.realG))
	{
	
		music_play( "ham_end_resuced");
		
		battlechatter_on("allies");
		
		thread handle_blue1_breach_anim();
		thread handle_red1_breach_anim();
		thread rescue_hvt_dialogue();
		
		wait 4;
		
		badguys = GetAIArray("axis");
		foreach(ai in badguys)
		{
			if(IsDefined(ai) && IsAlive(ai))
			{
				ai Delete();
			}
		}
		
		SafeActivateTrigger("trig_allies_into_breachroom");
		
		wait 2;
		
		spawn_vehicle_from_targetname_and_drive("nest_osprey_kill");
		level.endvehiclearr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 350 );
		
		aud_send_msg("end_osprey");
		
		wait 4;
		
		thread maps\hamburg_end_streets::handle_f15_rumble();
		endvehiclearr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 351 );
			
		wait 8;
		
		//endvehicleapache = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 352 );
		
		wait 6;
		
		fade_out_time = 3;
		black_overlay = create_client_overlay( "black", 0, level.player );
		black_overlay.sort = -1;
		black_overlay.foreground = false;
		black_overlay FadeOverTime( fade_out_time );
		black_overlay.alpha = 1;
		
		wait( fade_out_time );
		
		nextmission();
 	}
	
}

_slomo_breach_charger()
{
	self endon( "death" );
	self maps\_slowmo_breach::breach_enemy_cancel_ragdoll();
	//self set_generic_deathanim( self.animation + "_death" );
	self waittillmatch( "single anim", "start_ragdoll" );
	wait( .1 );
	self thread knife_guy_stabs_player();
	//self waittill( "finished_breach_start_anim" );
	//self gun_recall();
}

knife_guy_stabs_player()
{
	player = get_closest_player( self.origin );
	dist = Distance( player.origin, self.origin );
	if ( dist <= 75 )
	{
		player PlayRumbleOnEntity( "grenade_rumble" );
		player thread play_sound_on_entity( "melee_knife_hit_body" );
		player EnableHealthShield( false );
		player EnableDeathShield( false );
		waittillframeend;
		player DoDamage( player.health + 50000, self GetTagOrigin( "tag_weapon_right" ), self );
		player.breach_missionfailed = true;// tells slowmo to stop
	}
}


sandman_into_breach_room()
{
	level waittill( "sp_slowmo_breachanim_done" );
	
	level.red1 anim_stopanimscripted();
	
	level.red1 ally_breach_prep();
	
	level.red1_pre_breach_accuracy = level.red1.baseaccuracy;
	level.red1.baseaccuracy = level.red1.baseaccuracy / 4;
	
	level.red1.ignoreme = true;
	
	level.red1 teleport_ai( GetNode( "breach_room_sandman_spot" , "targetname" ) );
	level.red1 SetGoalNode(GetNode( "breach_room_sandman_spot" , "targetname" ) );
	level waittill( "slomo_breach_over" );
	level.red1 set_force_color("r");
}

rogers_into_breach_room()
{
	level waittill( "sp_slowmo_breachanim_done" );
	
	level.blue1 anim_stopanimscripted();
	level.blue1 ally_breach_prep();
	
	level.blue1_pre_breach_accuracy = level.blue1.baseaccuracy;
	level.blue1.baseaccuracy = level.blue1.baseaccuracy / 4;
	level.blue1.ignoreme = true;

	level.blue1 teleport_ai( GetNode( "breach_room_rogers_spot" , "targetname" ) );
	level.blue1 SetGoalNode(GetNode( "breach_room_rogers_spot" , "targetname" ) );
	level waittill( "slomo_breach_over" );
	level.blue1 set_force_color("b");
}

ally_breach_prep()
{
	self.ignoreexplosionevents = true;
	self.ignoresuppression = true;
	self.disableBulletWhizbyReaction = true;
	self.ignorerandombulletdamage = true;
	self thread disable_pain();
	self thread disable_surprise();
	self AllowedStances( "stand" );
}



nest_enemy_battlechatter()
{
	level.player endon( "death" );
	soundorg = getent("breach_chatter_org","targetname");
	
	while ( !flag( "stop_breach_chatter" ))
	{
		//enemy custom_battlechatter( "order_move_combat" );
		soundorg PlaySound("RU_1_order_move_combat");
		wait( RandomFloatRange( 3.0 , 5.5 ));
	}
	
}	

/*
swinging_light_timeout()
{
	wait 4;
	level notify("end_lamp_swing");
}
*/

rescue_hvt_dialogue()
{
	wait 2; 
	
	level.sandman thread dialogue_queue( "hamburg_snd_lookatme" );
	
	wait 1;
	
	level.sandman dialogue_queue( "hamburg_snd_itshim" );
	
	wait 2;
	
	level.sandman dialogue_queue("hamburg_snd_vicepres");
	
	wait 1;
	
	level.player radio_dialogue( "tank_hqr_onscene" );
	
	wait 1;
	
	level.sandman dialogue_queue("hamburg_snd_lzneptune");
	
	wait 1.5;
	
	level.player radio_dialogue("hamburg_rno_firstround");
	
}

handle_blue1_breach_anim()
{
	//blue1AnimNode = getnode("node_end_guy1","targetname");
	level.blue1 rogers_door_open_hvt();
	level.blue1 disable_ai_color();
	//blue1AnimNode anim_reach_and_approach_node_solo( level.blue1, "ending"  );
	//blue1AnimNode anim_single_solo(level.blue1,"ending");
	//level.blue1 waittillmatch("single anim","end");
	level.blue1 set_force_color( "b" );
	level.blue1 enable_ai_color();
}

handle_red1_breach_anim()
{
	
	AnimNode = getstruct("nodehvt5","targetname");
	

	guys = [];
	
	guys[0] = level.realG;
	guys[1] = level.red1;
	
	
	
	guys[0].animname = "generic";
	guys[1].animname = "sandman";
	
	AnimNode anim_reach_and_approach_solo( level.red1, "secure_hvi"  );
	aud_send_msg("breach_free_hostage");
	AnimNode anim_single( guys ,"secure_hvi");

}

setup_dead_hvts()
{
	hvt5 = spawn_targetname("hvt5");
	hvt5.animname = "generic";
	
	hvt5 setcontents( 0 );
	hvt5.noragdoll = true;
	hvt5.nocorpsedelete = true;
	hvt5.ignoreme = true;
	hvt5.dontDoNotetracks = true;	
	//self.drone_override= true;
	hvt5.script_looping = 0;
	hvt5 stopanimscripted();
	hvt5.allowdeath = false;
    hvt5.health = 1;
    hvt5.no_pain_sound = true;
    hvt5.diequietly = true;
    //self.a.nodeath = true;
    hvt5.delete_on_death = false;
    //self.NoFriendlyfire = true;
    hvt5.ignoreme = true;
    hvt5.ignoreall = true;
    hvt5.dontEverShoot = true;
    hvt5 gun_remove();
    //self InvisibleNotSolid();

	hvtanimnode5 = getstruct("nodehvt5","targetname");
	hvtanimnode5 thread anim_first_frame_solo(hvt5,"dead_hvt5");
}


endstreets_apache()
{
	streets_apache = spawn_vehicle_from_targetname_and_drive("endstreets_apache");
	streets_apache.allowedToFire = false;
	streets_apache.damageIsFromPlayer = true;
	
	wait .5;
	
	foreach(mg in streets_apache.mgturret)
	{
		mg SetMode( "sentry_offline" );
		mg ClearTargetEntity();
		mg StopFiring();
	}
	
	streets_apache thread apache_fire_missile_handler("endstreet_apache_killspot", 3, "flag_streets_apache_killspot", 0);
}

nest_javelin_apache()
{
	flag_wait("advance1_outside_battle2");
	level.nest_mi17_destroy = spawn_vehicle_from_targetname_and_drive("endstreets_heli_dropoff");
	level.nest_mi17_destroy.enableRocketDeath = true;
	
	wait 8;
	
	nest_apache_destroy = spawn_vehicle_from_targetname_and_drive("nest_apache_kill");
	rpgspots = getstructarray("end_apache_rpgs","targetname");
	//repulsor = Missile_CreateRepulsorEnt(nest_apache_destroy, 10000, 6000 );
	
	wait .5;
	
	foreach(mg in nest_apache_destroy.mgturret)
	{
		mg SetMode( "sentry_offline" );
		mg ClearTargetEntity();
		mg StopFiring();
	}
	
	//Have heli destroy vehicles
	nest_apache_destroy.damageIsFromPlayer = true;
	
	flag_wait("flag_nest_apache_killspot");
	
	for( i = 0; i < 7; i++ )
	{
		offset_salvo = 0.15;
		nest_apache_destroy thread maps\_helicopter_globals::fire_missile( "apache_zippy", 1, level.nest_mi17_destroy);
		wait ( offset_salvo );
	}
	
	nest_apache_destroy thread apache_fire_missile_handler("nest_apache_killspot", 3, "flag_nest_apache_killspot", 0);
	
	thread shoot_rpgs_at_heli(nest_apache_destroy, rpgspots);
	
	//failsafe for destroying heli outright in rare chance apache missiles miss.
	if(IsDefined(level.nest_mi17_destroy) && IsAlive(level.nest_mi17_destroy))
	{
		level.nest_mi17_destroy Kill();
	}

}

apache_fire_missile_handler( shoot_at_struct, targetcount, flag_to_wait, delay )
{
	flag_wait(flag_to_wait);
	zippycount = 4;
	
	
	nestzippy = [];
	
	if(IsDefined(delay))
	{
		wait(delay);
	}
	
	//Get all of the script structs to fire at
	for(i = 0; i < targetcount; i++)
	{
		nestzippy[i] = getEnt( shoot_at_struct + i, "targetname");
	}
	
	//loop through every struct
	for( i = 0; i < nestzippy.size; i++ )
	{	
				
		for( j = 0; j < zippycount; j++ )
		{
			offset_salvo = 0.2; // RandomFloatRange ( 0.1, 0.25 );
			self thread maps\_helicopter_globals::fire_missile( "apache_zippy", 1, nestzippy[i]);
			wait ( offset_salvo );
		}
		wait .75;
	}
}

shoot_rpgs_at_heli( target, spots )
{
	//loop through every struct
	for( i = 0; i < spots.size; i++ )
	{	

		ambush_rpg = magicBullet( "rpg", spots[i].origin, target.origin, level.player );
		
		wait 2;
	}
}
/*
destroy_hvts_veh()
{
	//rpg shot	
	rpg_start = getstruct( "hvt_ambush_rpg", "targetname" );
	rpg_target = getstruct( "hvt_ambush_rpg_target", "targetname" );
	
	target_ent = Spawn( "script_origin", rpg_target.origin );
	level.missileAttractor = Missile_CreateAttractorEnt( target_ent, 4000, 9000 );
	ambush_rpg = magicBullet( "rpg", rpg_start.origin, rpg_target.origin, level.player );
    
	//make sure the rpg destroys the suv
	ambush_rpg.damageIsFromPlayer = true;
	//rpg!
	Missile_DeleteAttractor( level.missileAttractor );
}
*/

swinging_lamp_thread()
{
	//level endon( "const_rappel_player_finished" );
	
	level.swinging_lamps = GetEntArray( "hvt_swinging_lamps" , "targetname" );
	foreach ( lamp in level.swinging_lamps )
	{
		if (IsDefined(lamp.target))
		{
			
			lamp.animname = "construction_lamp";
			lamp SetAnimTree();
			lamp thread anim_loop_solo( lamp , "wind_medium" , "end_lamp_swing" );
			
			light = getEnt( lamp.target , "targetname" );
			//light setLightIntensity( .1 );
		
			linkent = spawn_tag_origin();
			linkent LinkTo( lamp, "J_Hanging_Light_03", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			light thread manual_linkto( linkent );
			//PlayFXOnTag( getfx( "lights_point_white_payback" ), linkent, "tag_origin" );
			//PlayFXOnTag( level._effect[ "lights_point_white_payback" ] , lamp, "J_Hanging_Light_03" );
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





/* OLD! 



	
	//rpg shot	
	rpg_start = getstruct( "hvt_ambush_rpg", "targetname" );
	rpg_target = getstruct( "hvt_ambush_rpg_target", "targetname" );
	
	target_ent = Spawn( "script_origin", rpg_target.origin );
	level.missileAttractor = Missile_CreateAttractorEnt( target_ent, 4000, 9000 );
	ambush_rpg = magicBullet( "rpg", rpg_start.origin, rpg_target.origin, level.player );
    
	//make sure the rpg destroys the suv
	ambush_rpg.damageIsFromPlayer = true;
	//rpg!
	


AI_crowsnest_player_too_close()
{
	self endon( "death" );
	self endon( "alerted" );
	flag_wait_any( "in_nest", "player_shot_at_crowsnest_guys" );
	flag_set( "player_shot_at_crowsnest_guys" );
	nest_allies_react_enemies();
	self thread AI_become_alerted();
}

//We want to force all allies to use a different color for this section. so when they are killed, they dont respawn to nest, but respawn to lower area instead.
change_ally_colors( color )
{
	flag_wait("upper_nest_clear");
	
	//thread autosave_now_silent();
	
	allAllies  = GetAIArray("allies");
	
	foreach (ally in allAllies)
	{
		ally set_force_color( color );
	}
	
    SafeActivateTrigger("trig_ally_go_nest");
    
    //When cyan guy dies, set him to blue.
	thread think_respawn_allies();
}

think_respawn_allies()
{
	for(;;)
	{
		level waittill( "reinforcement_spawned", ally );
		ally set_force_color("green");
	}	
}

handle_nest_hero_tank()
{
	flag_wait( "upper_nest_clear" );
	
	wait 1;
	
	//thread autosave_now(1);
	
	//allies will now respawn as thier original colors. when they die, will spawn on the lower area.
	//trig_cyan_respawn = getent("trig_ally_uppernest_respawn","targetname");
	//trig_cyan_respawn trigger_off();
	
    SafeActivateTrigger("trig_ally_uppernest_respawn_lower");
	
	thread temp_dialogue("Squad","Badger1 nest is neutralized, proceed to waypoint", 4);
	
	wait 2;
	
	thread temp_dialogue("Badger1","Roger that, enroute, watch our back!", 2);
	
	level.end_tank Delete();
	level.end_tank2 = spawn_vehicle_from_targetname_and_drive("nest_tank");
	
	//add threats to tank.
	level.end_tank2 thread hero_tank_threat();
	level.end_tank2 godon();
	level.end_tank2 setAcceleration(15);
 
	level.end_tank2 thread do_path_section_and_finish( "tank_track_to_nest" );
	
	
	//end_tank thread maps\hamburg_tank_ai::turret_attack_think_hamburg();
		
	
	thread handle_tower_rpgs();

	flag_wait("nest_tank_end_path");
	
	init_s300();
	
	level.end_tank2.damageIsFromPlayer = true;
	
	level.end_tank2 thread maps\hamburg_tank_ai::stop_turret_attack_think_hamburg();
	
	s300vtarget1 = getstruct ( "s300vtarget1","targetname" );
    level.end_tank2 SetTurretTargetVec(  s300vtarget1.origin );
	
	thread temp_dialogue("Badger1","We have visual on target 1, aquiring vector...", 4);
	
	thread building_exploder();
	
    level.end_tank2 waittill( "turret_on_target" );               
    
    wait 2;
    
	thread temp_dialogue("Badger1","Firing!", 4);
	
    level.end_tank2 FireWeapon();
	
    wait 0.5;
	
	flag_set ("s300v1_destroyed");
	
	//exploder( 2000 );
    
	wait 1;
    
 	//s300v 1 destoryed, VO, fx, etc
	thread temp_dialogue("Badger1","Target is down, aquiring target 2, upward vector zero-2-niner!",4);
    
    s300vtarget2 = getstruct ( "s300vtarget2","targetname" );
    level.end_tank2 SetTurretTargetVec(  s300vtarget2.origin );
    level.end_tank2 waittill( "turret_on_target" );    
	
	thread temp_dialogue("Badger1","Good effect, Firing!", 2 );
	
	
    wait 1;
    
    level.end_tank2 FireWeapon();
	
	wait 0.5;
	
	//exploder( 2002 );
    
    level.end_tank2 thread maps\hamburg_tank_ai::turret_attack_think_hamburg();
	
    flag_set("s300_obj_complete");
    
   
    
}

init_s300()
{
	// s300v_a
	destructables = [];
    destructibles = GetEntArray( "nest_s300v_a", "targetname" );
    
    foreach ( destructible in destructibles )
    {
        destructible thread destructible_s300v_a_on_damage();  
    }
}

hero_tank_threat()
{
	flag_wait("spawn_tank_threat");
	//thread tank_threat_vo();
	
	
	//self thread tank_destroyed_mission_fail();
	
	threats = array_spawn_targetname_allow_fail("tank_threat");
	
	foreach(threat in threats)
	{
		threat thread think_tank_threat(level.end_tank2);	
	}
	
	thread ai_array_killcount_flag_set(threats, threats.size, "tank_threat_gone");
	
	thread temp_dialogue("Badger1","Bravo-Six this is Badger-1, meeting resistance – can you help clear the way over");
	wait 3;                    
	thread temp_dialogue("Rogers","Solid Copy Badger-1, we’re on it");
	thread temp_dialogue("Rogers","Squad get some fire on the streets below!");
	
	SafeActivateTrigger("trig_ally_nest_tank_support");
	nest_allies_disable_cqb();
	
	flag_wait("tank_threat_gone");
	thread temp_dialogue("Badger1","Were oscar mike to the waypoint... standby");
	
	wait 1;
	
	thread start_defend();

}

battle_ambience1()
{
	flag_wait("nest_battle_ambience");
		
	thread handle_end_battle_ambience();
	
	wait 2;
	
	arr2 = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 202 );

}


//drones
handle_end_battle_ambience()
{
	level endon("end_defend");
	
	while(1)
	{
		randint = RandomIntRange(15, 20);
		ambient = array_spawn_targetname_with_delay("battle_ambience");
		
		foreach(guy in ambient)
		{
			guy thread remove_drone_on_path_end();
		}
	
		wait(randint);
	}
	
}

remove_drone_on_path_end()
{
	self waittill("goal");
    		
   	if ( IsAlive(self) )
    {
   		self Delete();
    }
}
tank_destroyed_mission_fail()
{
	while(1)
	{
		wait .5;
		//self = end tank	
		if(self.health <= 0)
		{
			wait 1;
			
			level notify( "mission failed" );
		
			setdvar( "ui_deadquote", "Tank was destroyed! Mission Failed." );
		
			maps\_utility::missionFailedWrapper();
		}
	}
}

think_tank_threat(target)
{
	self endon("death");
	//self.ignoreme = true;
	self waittill("reached_path_end");
	wait 1;
	if(IsAlive(self))
	{
		self SetEntityTarget(target);
		//wait 2;
		//self Shoot();
		//wait 1;
		//self.ignoreme = false;
	}
	
}

tank_threat_vo()
{
	level endon("tank_threat_vo_done");
	while(1)
	{
		wait .5;
		
		while(!flag("tank_threat_balcony_vo"))
		{
			wait .25;
			if(flag("tank_threat_balcony_vo"))
			{
				thread temp_dialogue("Badger1","Contact, SECOND FLOOR BALCONY!", 2);
				break;
			}
		}
		
		while(!flag("tank_threat_rear_vo"))
		{
			wait .25;
			if(flag("tank_threat_rear_vo"))
			{
				thread temp_dialogue("Badger1"," Enemy at our rear!", 2);
				break;
			}
		}
		
		while(!flag("tank_threat_front_vo"))
		{
			wait .25;
			if(flag("tank_threat_front_vo"))
			{
				thread temp_dialogue("Badger1"," Enemy on street in front of us!", 2);
				level notify("tank_threat_vo_done");
				break;
			}
		}
	}
}

handle_nest_vehicle_vo()
{
	level endon("ac130_green_light");
	while(1)
	{
		wait .5;
			
		while(!flag("vehicle_vo_truck1"))
		{
			wait .5;
			if(flag("vehicle_vo_truck1"))
			{
				thread temp_dialogue("Squad","Troop transport to the northwest!");
				break;
			}
		}
		
		while(!flag("vehicle_vo_truck2"))
		{
			wait .5;
			if(flag("vehicle_vo_truck2"))
			{
				thread temp_dialogue("Squad","Troop transport to the south!");
				break;
			}
		}
		
		while(!flag("vehicle_vo_tank1"))
		{
			wait .5;
			if(flag("vehicle_vo_tank1"))
			{
				thread temp_dialogue("Squad","Tank to the north!");
				break;
			}
		}
			
		while(!flag("vehicle_vo_tank2"))
		{
			wait .5;
			if(flag("vehicle_vo_tank2"))
			{
				thread temp_dialogue("Squad","Tank coming in from the west!");
				break;
			}
		}
		
		while(!flag("vehicle_vo_tank3"))
		{
			wait .5;
			if(flag("vehicle_vo_tank3"))
			{
				thread temp_dialogue("Squad","Another Tank coming in from the north!");
				break;
			}
		}
				
	}
}
	

building_exploder()
{
	level endon ("ac130_green_light");
	flag_wait("missile_on_building");
	exploder(2001);
	
	missile_exp_loc = getStruct("missile_exp_loc","targetname");
	
	earthquake( 0.5, 2, missile_exp_loc.origin, 5000 );
	
}

start_defend()
{
	thread autosave_now(1);
	thread apache_strafe();
	
	
	threats2 = array_spawn_targetname_allow_fail("tank_threats2");
	
	flag_wait("s300v1_destroyed");
	
	level.endnesttanks = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 204 );
	
	flag_wait("s300_obj_complete");
	
	thread temp_dialogue("Squad1","Command, sierra-300-victors have neutralized, greenlight spectre 1, repeat greenlight spectre1!", 3 );
	
	thread temp_dialogue("Overlord","Squad ac130's are approaching, hold your position!", 3);
	
	thread handle_nest_vehicle_vo();
	
	SafeActivateTrigger("trig_red_defend1");	
	SafeActivateTrigger("trig_nest_defend_wave1");	

	wait 10;
	level.endnesthelis1 = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 203 );
	
	//level.endnesthelisend = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 235 );
	
	wait (7.5);
	
	flag_set("ac130_green_light");
	
	thread retreat_enemies();
}

set_veh_javelin_target()
{
	OFFSET = ( 0, 0, -32 );
	target_set( self, OFFSET );
	target_setAttackMode( self, "top" );
	Target_SetJavelinOnly( self, true );
}


tower_destroy_anim()
{
	flag_wait("tower_105_damage");
	
	wait 3;
	
	animateto = getstruct( "tower_collapse_node", "targetname" );
	
	tower = getent(  "tower_collapse_model", "targetname" );
	tower.animname = "tower_collapse" ;
	
	awning = getent("awning_collapse_model","targetname");
	awning.animname = "awning_collapse";
	
	//exploder
	
	tower useAnimTree( level.scr_animtree[ tower.animname ] );
	awning useAnimTree( level.scr_animtree[awning.animname ] );
	
	actors = [];
	actors[0] = tower;
	actors[1] = awning;

	animateto thread anim_single(actors, "nest_tower_collapse" );
	
	wait 5;
	
	glasspaines = [];
	glasspaines = GetEntArray("awningglass","targetname");

	foreach(thing in glasspaines)
	{
	
		thing DoDamage(200,(0, 0, 0));
	}
	
}

setup_tower_destroy()
{
	triggers = GetEntArray( "trig_tower_105_damage", "targetname" );
	foreach ( trig in triggers )
	{
		trig thread handle_tower_explosion( "tower_chunk", trig.script_index, "explosion_type_5", "thick_building_fire" );
	}
}

handle_tower_explosion( tower_name, part_radius, fx_name1, fx_name2 )
{
	attacker = undefined;
	while ( 1 )
	{
		self waittill( "damage", damage, attacker );
		if ( damage == 1000 )
		{
			break;
		}
	}
	
	fx_origin = GetEnt( tower_name + "_fx", "targetname" );
	
	
	if ( IsDefined( fx_name1 ) )
	{
		playfx( getfx( fx_name1 ), fx_origin.origin );
	}
	
	if ( IsDefined( fx_name2 ) )
	{
		playfx( getfx( fx_name2 ), fx_origin.origin );
	}
	
	chunk = GetEnt( tower_name + "_parts", "script_noteworthy" );

	chunk delete();
		
	
	self delete();
}



apache_strafe()
{

	flag_wait("ac130_green_light");
	
	wait 3;
	
	end_apache1 = spawn_vehicle_from_targetname_and_drive("end_apache1");
	wait 1;
	end_apache2 = spawn_vehicle_from_targetname_and_drive("end_apache2");
	
	//end_apache1 thread apache_fire_missile_handler( "nest_zippy", 4, "nest_apache1_zippy",2 );
	//end_apache2 thread apache_fire_missile_handler( "nest2_zippy", 1, "nest_apache2_zippy",2 );
	
}
apache_fire_missile_handler( shoot_at_struct, targetcount, flag_to_wait, delay )
{
	flag_wait(flag_to_wait);
	zippycount = 5;
	
	
	nestzippy = [];
	
	if(IsDefined(delay))
	{
		wait(delay);
	}
	
	//Get all of the script structs to fire at
	for(i = 0; i < targetcount; i++)
	{
		nestzippy[i] = getent( shoot_at_struct + i, "targetname");
	}
	
	//loop through every struct
	for( i = 0; i < nestzippy.size; i++ )
	{	
				
	
		for( j = 0; j < zippycount; j++ )
		{
			offset_salvo = 0.2; // RandomFloatRange ( 0.1, 0.25 );
			self thread maps\_helicopter_globals::fire_missile( "mi28_zippy", 1, nestzippy[i]);
			wait ( offset_salvo );
		}
		wait .75;
	}
}

s3002_missiles()
{
	level endon( "s300v2_destroyed" );
	
	flag_wait ( "start_s3002_missiles" );
	
	//set objective follow marker on rogers (hamburg_end/objective_follow_rogers_nest())
	flag_set("follow_rogers_nest");
	
	wait 10;

	s3001_missile1 = spawn_vehicle_from_targetname_and_drive( "s3002_missile1" );
	wait 2;
	
	thread temp_dialogue("Squad","We have a visual on Gargoyle missiles over");
	
	

	
	
	wait 20;
	
	s3001_missile3 = spawn_vehicle_from_targetname_and_drive( "s3002_missile2" );
	thread temp_dialogue("Squad","We've got to get those missiles offline! Keep pushing up!");
	
	wait 25;
	s3001_missile3 = spawn_vehicle_from_targetname_and_drive( "s3002_missile3" );
	
	wait 25;
	s3001_missile3 = spawn_vehicle_from_targetname_and_drive( "s3002_missile4" );
		
		
}

s3001_destroyed()
{
	flag_wait ("s300v1_destroyed");
	s3001_missile4 = spawn_vehicle_from_targetname_and_drive( "s3001_missile4" );
	wait 3;
	thread temp_dialogue("Squad","Did you see that!? Great shot Badger1");
}


s3001_missiles()
{
	flag_wait( "flag_s3001_missiles");
	
	handle_s3001_missile( 0, 0 );
	
	wait 1;
	
	for( i = 1; i < 3 ; i++ )
	{
		rand =  RandomIntRange(20, 30);
		handle_s3001_missile( i, rand );
	}
}

handle_s3001_missile( missile_number, interval )
{
	switch( missile_number )
	{
	
		case 0:
		wait interval;
		s3002_missile1 = spawn_vehicle_from_targetname_and_drive( "s3001_missile1" );
		break;
	
		case 1:
		wait interval;
		s3002_missile2 = spawn_vehicle_from_targetname_and_drive( "s3001_missile2" );
		break;
		
		case 2:
		wait interval;
		s3002_missile3 = spawn_vehicle_from_targetname_and_drive( "s3001_missile3" );
		break;
		
	}
}

//This handles the entire end event
handle_ac130()
{
	flag_wait( "ac130_green_light" );
	
	setup_tower_destroy();
	
	level.spectre1 = spawn_vehicle_from_targetname_and_drive( "spectre1" );
	spectre2 = spawn_vehicle_from_targetname_and_drive( "spectre2" );
	

	thread temp_dialogue("Spectre1","The calvary has arrived gentleman. Thanks for the assist, Spectre out...");
	//iprintlnbold("Spectre Gunship: The calvary has arrived gentleman. Thanks for the assist, Spectre out...");

	Missile_DeleteAttractor( level.missileAttractor );
	
	//iprintlnbold("ac130: Spectre 1 has targets, 40's are a go");
	
	fake_target1 = getstructarray( "ending_ac130_targets1", "targetname" );
	
	level.spectre1 ac130_destroy_veh( level.endnesthelis1, level.air_support_weapon4);

	level.spectre1 ac130_destroy_veh( level.endnesttanks, level.air_support_weapon4);
	
	level.spectre1 thread ac130_destroy_tower(level.air_support_weapon5); //level.air_support_weapon4);
	
	thread maps\hamburg_end_nest::ending_ac130_targets( fake_target1, 1, level.spectre1, level.air_support_weapon4 );
	
	wait 7;
	
	level notify( "end_defend" );
	
	thread temp_dialogue("Squad","Objective complete, enough excitement for one day... overlord, requesting evac, over");
		
	wait 3;
	
	thread temp_dialogue("Overlord","Roger that");
	
	level.endvehiclearr = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 350 );	
	
	flag_wait("finish_mission");
	
	wait 5;
	
	nextmission();
}

//get all enemies, and location specific enemies and retreat them to goal volumes
retreat_enemies()
{
	leftbaddies = [];
	leftbaddies = get_ai_group_ai("group_end_left_wave");
	
	frontbaddies = [];
	frontbaddies = get_ai_group_ai("group_end_front_wave");
	
	leftdeletetrig = getent("left_enemies_retreat","targetname");
	rightdeletetrig = getent("right_enemies_retreat","targetname");
	
	thread retreat_delete(leftdeletetrig);
	thread retreat_delete(rightdeletetrig);
	
	flag_set("stop_end_wave1");
	flag_set("stop_end_wave2");
	flag_set("stop_end_wave3");
	
	allaxis = GetAIarray("axis");
	
	foreach (guy in allaxis)
	{
		guy.ignoreall = true;
		guy.sprint = true;
	}
	
	leftcolor = "yellow";
	rightcolor = "red";
	
	foreach (guy in leftbaddies)
	{
		guy set_force_color( leftcolor );
	}
	
   
	foreach (guy in frontbaddies)
	{
		guy set_force_color( rightcolor );
	}
	

	
	 SafeActivateTrigger("trig_enemy_retreat_nest");
}
	
retreat_delete( trig )
{
	
	while(1)
	{
		wait 1;
		
		axis = trig get_ai_touching_volume( "axis" );
		
		foreach (dude in axis)
		{
			if(IsAlive(dude) && IsDefined(dude))
			{
				dude delete();
			}
		}
	}
		
}

nest_javelin_osprey()
{
	flag_wait("nest_javelin_osprey_go");

	nest_osprey_destroy = spawn_vehicle_from_targetname_and_drive("nest_osprey_kill");
	
	flag_wait("fire_at_nest_osprey");
	
	magicbullet_destroy_veh( "javelin","nest_jav", nest_osprey_destroy );
}

nest_javelin_apache()
{
	flag_wait("nest_javelin_apache_go");
	
	nest_apache_destroy = spawn_vehicle_from_targetname_and_drive("nest_apache_kill");
	
	//Have heli destroy vehicles
	nest_apache_destroy.damageIsFromPlayer = true;
	
	nest_apache_destroy thread apache_fire_missile_handler("nest_apache_killspot", 2, "flag_nest_apache_killspot", 0);
	
	wait 4;
	
	magicbullet_destroy_veh( "javelin","nest_jav", nest_apache_destroy );
}

//
handle_spawn_upper_nest()
{
	flag_wait( "spawn_upper_nest" );
	flag_set ( "start_s300_missiles" );
	
	SafeActivateTrigger("trig_upper_nest_spawns");
	
	thread handle_nest_javelin_fire();
	
    flag_wait( "stop_nest_wave");
    
    //setup allies to ignore enemies
    setup_nest_allies();
    
    //remove all non javelin/nest enemies
    ai_nest = [];
    ai_nest = get_ai_group_ai ("ai_nest");
    
    foreach(dude in ai_nest)
    {
    	dude Delete();
    }

    //failsafe, just incase the player is awesome and sprints up to nest and kills everyone before missiles are done.
    level.s300v_firing = false;
}

handle_nest_javelin_fire()
{
	level endon("stop_nest_wave");
	jav_org = getstruct( "nest_jav", "targetname" ).origin;
	
	targetarr = [];
	targetarr = GetEntArray("javelin_targets_crowsnest","targetname");
	
	while(1)
	{
		index = RandomIntRange(0, int(targetarr.size) );
		newMissile = MagicBullet( "javelin", jav_org, targetarr[index].origin );
		newMissile Missile_SetTargetEnt( targetarr[index] );
		newMissile Missile_SetFlightmodeTop();
		wait(RandomFloatRange(5.0, 7.5));
	}
}

setup_nest_enemies()
{

	flag_wait("setup_nest_enemies");
    
	//spawn more guys to add to nest
	hostiles_crowsnest = array_spawn( getentarray( "hostiles_crowsnest", "targetname" ), true );
	
	thread nest_enemy_battlechatter( hostiles_crowsnest );
	
	wait 1;
	
	array_thread( hostiles_crowsnest, ::AI_sneak_monitor, "player_shot_at_crowsnest_guys" );
	array_thread( hostiles_crowsnest, ::AI_crowsnest_player_too_close );
	
	
	
	waittill_dead_or_dying( hostiles_crowsnest );
    
  	flag_set( "upper_nest_clear" );
   	flag_set( "nest_battle_ambience" );   
}

	
nest_enemy_battlechatter(enemies)
{
	level.player endon( "death" );
	soundorg = getent("nest_chatter_org","targetname");
	
	while ( !flag( "upper_nest_clear" ))
	{
		//enemy custom_battlechatter( "order_move_combat" );
		soundorg PlaySound("RU_1_order_move_combat");
		wait( RandomFloatRange( 3.0 , 5.5 ));
	}
	
}	
setup_nest_allies()
{
	allAllies  = GetAIArray("allies");
	
	
	battlechatter_on("axis");

	
	foreach (ally in allAllies)
	{
		ally set_ignoreall(1);
		ally enable_cqbwalk();
	}
	
	//nest_approach_vo();
	
}


nest_approach_vo()
{
	level endon("end_nest_approach_vo");
	
	flag_wait("nest_advance_inside6");
	battlechatter_off("allies");
	
	
	if(!flag("player_shot_at_crowsnest_guys") || flag("almost_to_crowsnest"))
	{
		temp_dialogue("Rogers","Overlord, we are in position, approaching the enemy javelin nest");
	}
	
	if(!flag("player_shot_at_crowsnest_guys") || flag("almost_to_crowsnest"))
	{			
		temp_dialogue("Overlord","Solid Copy Bravo-Six", 3);
	}

	if(!flag("player_shot_at_crowsnest_guys") || flag("almost_to_crowsnest") )
	{		
		temp_dialogue("Rogers","Lets move, eyes peeled, stay icy", 3);   
	}
	
	flag_wait("almost_to_crowsnest");
	
	if(!flag("player_shot_at_crowsnest_guys"))
	{
		thread temp_dialogue("Rogers","Jackson let’s do it");
	}
	
	flag_wait("player_shot_at_crowsnest_guys");
	
	thread temp_dialogue("Rogers","Weapons free!");

	level notify("end_nest_approach_vo");
}


nest_allies_react_enemies()
{
	allAllies  = GetAIArray("allies");
	
	battlechatter_on("allies");
	
	foreach (ally in allAllies)
	{
		ally set_ignoreall(0);
		//ally disable_cqbwalk();
	}
}

nest_allies_disable_cqb()
{
	allAllies = GetAIArray("allies");
	
	foreach(ally in allAllies)
	{
		ally disable_cqbwalk();
	}
}


magicbullet_destroy_veh( weapon, struct_name, veh_to_destroy )
{
	startpoint = getstruct( struct_name, "targetname" ).origin;
	
	veh_to_destroy.health = 2;
	veh_to_destroy godoff();
	veh_to_destroy.enableRocketDeath = true;
	newMissile = MagicBullet( weapon, startpoint, veh_to_destroy GetCentroid() );
	newMissile Missile_SetTargetEnt( veh_to_destroy );
	//newMissile Missile_SetFlightmodeTop();
}

handle_tower_rpgs()
{
	level endon("end_defend");
	
	//rpg shot	
	rpg_start = getstructarray( "clocktower_rpgs", "targetname" );
	rpg_target = getstructarray( "clocktower_rpgs_target", "targetname" );
	attractor_ent = getstruct("clock_rpgs_attractor","targetname");
	target_ent = Spawn( "script_origin", attractor_ent.origin );
	level.missileAttractor = Missile_CreateAttractorEnt( target_ent, 4000, 9000 );
	
	//do this until the ac130s destroy the tower
	while(1)
	{
		foreach (rpg in rpg_start)
		{
			wait (RandomIntRange(5, 9));
			
			arr_target = randomintrange(0, rpg_target.size);
			
			level.clock_rpg = magicBullet( "rpg", rpg.origin, rpg_target[arr_target].origin );

			
		}
	}
}

handle_enemy_teleport()
{
	level endon("end_defend");
    
	//axis = get_ai_group_ai("group_end_wave1");
	trig = GetEnt("teleport_axis_defend", "targetname");
	
	while(1)
	{
		wait 1;
		axis = trig get_ai_touching_volume( "axis" );
		//goalvolume = getent("axis_defend_teleport_volume","targetname");
		//goalvolumetarget = getNode( goalvolume.target , "targetname" );
		
		foreach(dude in axis)
		{
			if(IsAlive(dude))
			{
				dude Delete();
				//dude teleport_ai(GetNode("axis_defend_teleport_node","targetname"));
				
				//thread temp_dialogue("Squad","Enemies breaking through rear! Watch your back");
				
				
				if(IsAlive(dude))
				{
					dude SetGoalNode( goalvolumetarget );
	        		dude SetGoalVolume( goalvolume );  
	        		//dude.script_goalvolume = 520;
				}
				
			}
		}
	}
	
}
		
spawn_nest_drones1()
{
	flag_wait("go_nest_drones1");
	
	guys = array_spawn_targetname_allow_fail("nest_wave_drones1");
	
	foreach (guy in guys)
	{
		guy thread do_sprint();
	}
	
}

spawn_nest_wave1()
{
	flag_wait("spawn_upper_nest");
	wave1 = array_spawn_targetname_allow_fail_setthreat("nest_wave1","axis_outside");
}




//A few enemies that spawn in the first building.
spawn_nest_wave1b()
{
	flag_wait("nest_advance_inside1");
	
	thread autosave_now(1);
	
	SafeActivateTrigger("trig_nest_advance_inside1");
   
	guys_out = array_spawn_targetname_allow_fail_setthreat("nest_wave1b_outside","axis_outside");
	guys_in = array_spawn_targetname_allow_fail_setthreat("nest_wave1b_inside","axis_inside");
	
	
	
	foreach (guy in guys_out)
	{
		guy thread do_sprint();
	}	
	
	foreach (guy in guys_in)
	{
		guy thread do_sprint();
	}	
	
	
	arrComb = array_combine( guys_out, guys_in );
	thread ai_array_killcount_flag_set(arrComb, int(arrComb.size - 2), "nest_advance_inside2");

}


spawn_nest_wave1c()
{
	flag_wait("nest_advance_inside2");
	
	thread autosave_now(1);
	
	//send allies forward, into the left building
	SafeActivateTrigger("trig_nest_advance_inside2");
    
    //guys_out = array_spawn_targetname_allow_fail_setthreat("nest_wave1c_outside","axis_outside");
	guys_in = array_spawn_targetname_allow_fail_setthreat("nest_wave1c_inside","axis_inside");
	guys_out = array_spawn_targetname_allow_fail_setthreat("nest_wave1c_outside","axis_inside");
	
	combguys = array_combine( guys_in, guys_out );
	thread ai_array_killcount_flag_set(combguys, int(combguys.size - 1), "nest_advance_inside3");
}


spawn_nest_wave1d()
{
	flag_wait("nest_advance_inside3");
	
	thread autosave_now(1);
	
	//send allies forward 
    //SafeActivateTrigger("trig_nest_advance_inside3");
    
    level.guys_out1_d = array_spawn_targetname_allow_fail_setthreat("nest_wave1d_out1","axis_outside");
    level.guys_out2_d = array_spawn_targetname_allow_fail_setthreat("nest_wave1d_out2","axis_outside");
	level.guys_in_d = array_spawn_targetname_allow_fail_setthreat("nest_wave1d_in","axis_inside");
	
	foreach (guy in level.guys_out1_d)
	{
		guy thread do_sprint();
	}	
	
	foreach (guy in level.guys_out2_d)
	{
		guy thread do_sprint();
	}	
	
	thread wave1d_out_retreat();
	
	wait 1;
	
	thread temp_dialogue("Rogers","MG Nest at the end of the street!");
	
	thread check_wave1d_out();
	thread check_wave1d_in();

	flag_wait_all( "nest_advance_inside5a", "nest_advance_inside5b");
	thread spawn_nest_wave1e();
	flag_set("spawn_last_nest_wave");

}

check_wave1d_out()
{
	
	arrcombine = array_combine(level.guys_out1_d, level.guys_out2_d);
	
	thread ai_array_killcount_flag_set(arrcombine, arrcombine.size - 1, "nest_advance_inside5a");
	flag_wait("nest_advance_inside5a");
	
    SafeActivateTrigger( "trig_nest_advance_inside5a" );
}


check_wave1d_in()
{
	thread ai_array_killcount_flag_set(level.guys_in_d, int(level.guys_in_d.size - 1) , "nest_advance_inside5b");
    flag_wait("nest_advance_inside5b");
	
  	SafeActivateTrigger( "trig_nest_advance_inside5b" );

}	
wave1d_out_retreat()
{
	flag_wait("wave1d_out_retreat");

	axis_d_out_1 = level.guys_out1_d;
	axis_d_out_2 = level.guys_out2_d;
	axis_d_in = level.guys_in_d;
	
	wait 2;
	
	goalvolume1 = getent("wave1d_retreat_volume1","targetname");
	goalvolumetarget1 = getNode( goalvolume1.target , "targetname" );
	
	foreach(dude in axis_d_out_1)
	{			
		if(IsAlive(dude))
		{
			dude thread nest_ignore_enemies();
			dude.fixednode = 0;
			dude SetGoalNode( goalvolumetarget1 );
	    	dude SetGoalVolume( goalvolume1 );  
		}
	}
	
	wait 5;
	
	goalvolume2 = getent("wave1d_retreat_volume2","targetname");
	goalvolumetarget2 = getNode( goalvolume2.target , "targetname" );
	
	foreach(dude in axis_d_out_2)
	{			
		if(IsAlive(dude))
		{
			dude thread nest_ignore_enemies();
			dude.fixednode = 0;
			dude SetGoalNode( goalvolumetarget2 );
	    	dude SetGoalVolume( goalvolume2 );  
		}
	}
	
	wait 1;
	
	SafeActivateTrigger("trig_nest_advance_inside5a");
}

nest_ignore_enemies( delay )
{
	if( !IsDefined(delay))
		delay = 3;
	self.ignoreall = true;
	self ClearEnemy();
	wait delay;
	if(IsDefined(self) && IsAlive(self) )
	self.ignoreall = false;
}

spawn_nest_wave1e()
{
	flag_wait( "spawn_last_nest_wave" );	
	
    //guys_in = array_spawn_targetname_allow_fail("nest_wave1e");
    
    
    //Make blue guys biased toward inside enemies now.
    thread setgroup_maybedead( "blueend1_spawned", level.blue1,"ally_inside");
	thread setgroup_maybedead( "blueend2_spawned", level.blue2,"ally_inside");
   
	//get remaining enemies in array and check when they are cleared.
	//waveD and E are both in aigroup last_lower_wave
	last_lower_wave = [];
    last_lower_wave = get_ai_group_ai ("last_lower_wave");
    
    waittill_dead_or_dying(last_lower_wave);
    
	wait 1;
    
	
	
    SafeActivateTrigger( "trig_nest_advance_inside6" );

}


handle_nest_ally_threatbiasgroup()
{
	// initial groups
	createthreatbiasgroup("ally_outside");
	createthreatbiasgroup("ally_inside");
	createthreatbiasgroup("axis_inside");
	createthreatbiasgroup("axis_outside");
	
	level.player SetThreatBiasGroup( "ally_outside" );
	level.red1   SetThreatBiasGroup( "ally_outside" );
	
	thread setgroup_maybedead( "greenend1_spawned", level.green1,"ally_inside");
	thread setgroup_maybedead( "greenend2_spawned", level.green2,"ally_inside");
	
	thread setgroup_maybedead( "blueend1_spawned", level.blue1,"ally_outside");
	thread setgroup_maybedead( "blueend2_spawned", level.blue2,"ally_outside");

	while(1)
	{
		flag_wait(   "nest_player_inside" );
		level.player SetThreatBiasGroup( "ally_inside" );
		SetBiasPlayerInside();
		
		flag_waitopen( "nest_player_inside" );
		level.player SetThreatBiasGroup( "ally_outside" );	
		SetBiasPlayerOutside();
	}
	
}
setgroup_maybedead( flagtowait, who, groupto)
{
	if(!IsDefined(who) || IsAlive(who) == false )
	{
		flag_wait(flagtowait);
	}
	who SetThreatBiasGroup(groupto);
}
SetBiasPlayerInside()
{
	
	SetThreatBias( "ally_inside", 	"axis_inside", 		ALLYIN2AXIS_IN_PLAYER_IN );
	SetThreatBias( "ally_outside",	"axis_inside", 		ALLYIN2AXIS_IN_PLAYER_IN );
	SetThreatBias( "ally_inside",	"axis_outside", 	ALLYIN2AXIS_OUT_PLAYER_IN );
	SetThreatBias( "ally_outside",	"axis_outside", 	ALLYOUT2AXIS_OUT_PLAYER_IN );
}
SetBiasPlayerOutside()
{
	SetThreatBias( "ally_inside", 	"axis_inside", 		ALLYIN2AXIS_IN_PLAYER_OUT );
	SetThreatBias( "ally_outside",	"axis_inside", 		ALLYIN2AXIS_IN_PLAYER_OUT );
	SetThreatBias( "ally_inside",	"axis_outside", 	ALLYIN2AXIS_OUT_PLAYER_OUT );
	SetThreatBias( "ally_outside",	"axis_outside", 	ALLYOUT2AXIS_OUT_PLAYER_OUT );
}












ending_ac130_targets( fake_target, rounds, gunship, weapon )
{
	num = 0;
	level.ac130_shooting = true;	
	for ( i = 0; i < rounds; i++ )
	{
		rounds++;
		for ( i = 0; i < fake_target.size; i++ )
		{
			fake_target[ i ] maps\hamburg_end_nest::ending_ac130_fire( gunship, weapon );
		}
	}
	level.ac130_shooting = false;
}

ending_ac130_fire( gunship, weapon )
{	
	self endon( "death" );	
	num_shots = 2;
	rounds_per_min = 80; // 120 is accurate for bofers 40mm l/70, 200 is accurate for the planned upgrade 30mm mk44 bushmaster ii
	fire_delay = 60 / rounds_per_min;
	for ( i = 0; i < num_shots; i++ )
	{	
		gun_pos = gunship.origin;
		target_pos = self.origin + randomvector( 100 );
		MagicBullet( weapon, gun_pos, target_pos );	
		wait fire_delay;		
	}	
}

ac130_destroy_tower( weapon )
{
	//105mm shot	
	gun_pos = self.origin;
	big_target = [];	

	big_target[0] = getstruct("105mm_target1","targetname");
	big_target[1] = getstruct("105mm_target2","targetname");
	big_target[2] = getstruct("105mm_target3","targetname");
	
	magicBullet( weapon, gun_pos, big_target[0].origin );
	
	wait 2;
	
	magicBullet( weapon, gun_pos, big_target[1].origin );
	
	wait 2;
	
	magicBullet( weapon, gun_pos, big_target[2].origin );
	
	
	
}
ac130_destroy_veh( vehicles, weapon )
{

	for(i = 0; i < vehicles.size; i++)
	{
		
		if(IsAlive(vehicles[i]) && IsDefined(vehicles[i]))
		{
			//105mm shot	
			gun_pos = self.origin;
			magicBullet( weapon, gun_pos, vehicles[i].origin );
			wait 1;
		
		}
	}
	

}

give_player_claymores( count )
{
	level.player GiveWeapon("claymore");
	level.player SetActionSlot(4, "weapon", "claymore");
	level.player SetWeaponAmmoStock("claymore", count);
	level.player thread display_hint_timeout( "claymore_hint", 3 );
}

destructible_s300v_a_on_damage()
{      
    //self endon( "death" );
    self.health = 100000;
    self SetCanDamage( true );
    
    //self waittill( "damage", damage, attacker)
    while(1)
    {
    	self waittill("damage", amount, attacker);
		if(attacker == level.end_tank)
		{
			break;
		}
    }
 
	fx = getfx( "FX_s300v_a" );
    pos = ( self.origin[ 0 ], self.origin[ 1 ], self.origin[ 2 ] );
    angles = ( self.angles[ 0 ] - 90, self.angles[ 1 ] - 270, self.angles[ 2 ] );
    forward = VectorNormalize( AnglesToForward( angles ) );
    PlayFX( fx, pos, forward );
    
    // swap

    damaged_model = Spawn( "script_model", self.origin );
    damaged_model SetModel( "ac_prs_enm_s300v_dam" );
    if ( IsDefined( self.angles ) )
        damaged_model.angles = self.angles;
    self Delete();
}

*/


