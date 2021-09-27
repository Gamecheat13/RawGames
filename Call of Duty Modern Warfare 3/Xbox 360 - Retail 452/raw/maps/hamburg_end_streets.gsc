/*
//todo

add ambient stuff and swinging lights in the garage area.
large tree on fire as you come out of garage.
*/
#include maps\_utility;
#include animscripts\utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\hamburg_code;
#include maps\hamburg_end;
#include maps\_minigun;
#include maps\_audio;
#include animscripts\hummer_turret\common;

ALLYIN2AXIS_IN_PLAYER_OUT							=  10000;
ALLYOUT2AXIS_IN_PLAYER_OUT							= -5000;	
ALLYIN2AXIS_OUT_PLAYER_OUT							=  2500;
ALLYOUT2AXIS_OUT_PLAYER_OUT							=  5000;	

ALLYIN2AXIS_IN_PLAYER_IN							=  2500;
ALLYOUT2AXIS_IN_PLAYER_IN							=  200;	
ALLYIN2AXIS_OUT_PLAYER_IN							=  -5000;
ALLYOUT2AXIS_OUT_PLAYER_IN							=  15000;	

ALLY_MOVE_WAIT_TIME_FOR_RETREAT						= 4;

////////////////////////////////////////////////////////////////////////
/// Initialization
////////////////////////////////////////////////////////////////////////

streets_pre_load()
{
	flag_init( "end_spawn_btr" );
	flag_init( "end_spawn_ally_tank" );
	flag_init( "end_spawn_reinforce");
	flag_init( "street_enemybtrincoming" );
	flag_init( "streets_tankstop1_clear" );
	flag_init( "streets_tankstop2_clear" );
	flag_init( "street_spawn_tankstop1_int" );
	flag_init( "street_overrun_tankstop1" );
	flag_init( "street_to_corner_finished");
	flag_init( "streetfoot_finished");
	flag_init( "t1_pos1" );
	flag_init( "t1_pos2" );
	flag_init( "streets_player_inside" );
	flag_init( "blueend1_spawned" );
	flag_init( "blueend2_spawned" );
	flag_init( "greenend1_spawned" );
	flag_init( "greenend2_spawned" );
	flag_init( "streetsbtr_reached_end" );
	flag_init( "spawn_tankstop3_int" );
	flag_init( "streets_kick_off" );
	flag_init( "streets_hind_fire_osprey" );
	flag_init( "streets_javelin_osprey" );
	flag_init( "streets_spawn_f15" );
	flag_init( "streets_f15_fire_missile1" );
	flag_init( "streets_f15_fire_missile2" );
	flag_init( "streets_kicked_door" );
	flag_init( "streets_first_btr_down");
	flag_init( "streets_killshot_btr");
	flag_init( "sjp_tank_dialogue" );
	flag_init( "sjp_tank_dialogue2" );
	flag_init( "streets_javelins_down");
	flag_init( "streets_interiors_complete");
	flag_init( "streets_jav_at_apaches" );
	flag_init( "sjp_fire_allowed" );
	flag_init( "monitor_outside_for_saves" );
	flag_init( "disabled_saves_outside" );
	
	
	PreCacheItem( "cobra_Sidewinder" );
	PreCacheModel( "vehicle_f15_missile" );
	PreCacheItem( "f15_missile" );
	
	thread streets_post_load();
}

streets_post_load()
{	
	level waittill ( "load_finished" );
	clear_path_blockers();
}

setup_streetcorner()
{
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	level.streets_fire_full = true;
	setup_spawn_funcs();
	
	modify_street_paths( "tankstop1int_retreat_blocker" , 1 );
	
	modify_street_paths( "streets_ai_keep_sides" , 1 );
	
	
	startstruct = getstruct( "start_streetcorner", "targetname" );

	if(isdefined(startstruct))
	{
		level.player SetOrigin( startstruct.origin );
		level.player SetPlayerAngles( startstruct.angles);
	}
	spawn_allies(1, "hamburg_end_streetcorner" );
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	
	remove_global_spawn_function( "axis", ::disable_grenades );
	
	
	level.fast_destructible_explode = false;
	

	level.destructible_protection_func = undefined;

	thread handle_ally_threatbiasgroup();
	thread monitor_allies_javelin_area();
	set_no_explode_vehicles();
	thread f15_bomber();
	thread objective_streetsfollow_sandmansniper();
	clear_path_blockers();
	thread watch_inside_trigger();
	thread watch_outside_trigger();
	thread monitor_street_player(0);
	level.streets_player_outside = 0;
}



//begin_streets()
begin_streetcorner()
{
	
//	thread autosave_now(1);
	
	flag_wait( "streetfoot_finished");
	level notify( "streets_all_finished" );
	
}

			
setup_streets()
{
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	setup_spawn_funcs();
	startstruct = getstruct( "start_street", "targetname" );
	if(isdefined(startstruct))
	{
		level.player SetOrigin( startstruct.origin );
		level.player SetPlayerAngles( startstruct.angles);
	}
	
	spawn_allies(0);
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
	set_no_explode_vehicles();
	thread objective_streetsfollow_sandmansniper();
	
}
/*
axisdebug()
{
	level.db_axis = 0;
	level.db_axisin = 0;
	level.db_axisout = 0;
	while(1)
	{
		axis = GetAIArray( "axis" );
		undef = 0;
		inside = 0;
		outside = 0;
		
		foreach( enemy in axis )
		{
			if(! IsDefined( enemy.inside ) )
				undef++;
			else if(enemy.inside == 1)
				inside++;
			else
				outside++;
		}
		if(axis.size != level.db_axis || inside != level.db_axisin || outside != level.db_axisout )
		{
			level.db_axis = axis.size ;
			level.db_axisin = inside ;
			level.db_axisout = outside ;
			
			IPrintLn("T:"+axis.size+" I:"+inside+" O:"+outside);
		}
		wait 0.1;
	}
	
}

*/

//begin_streetcorner()
begin_streets()
{
	//tank_test();
	maps\_compass::setupMiniMap("compass_map_hamburg", "city_minimap_corner");
	thread autosave_now(1);
	thread watch_inside_trigger();
	thread watch_outside_trigger();
	level.streets_fire_full = false;
//	thread axisdebug();

	remove_global_spawn_function( "axis", ::disable_grenades );
	flag_set( "streets_kicked_door" );
	level.streets_player_outside = 1;
	
	level.fast_destructible_explode = false;
	level.streets_todelete = [];
	
	streets_hide_badplaces();
	level.custombadplacethread = ::hamburg_end_badplace;
	

	
	level.destructible_protection_func = undefined;
	thread handle_ally_threatbiasgroup();
	array_thread( getvehiclenodearray( "streets_plane_sound", "script_noteworthy" ), vehicle_scripts\_f15::plane_sound_node );
	thread tank_btr_interaction();
	//thread allied_jets_ambient();
	
	thread handle_combat_flow();
	thread monitor_tankstops();
	thread handle_tankstop2int_spawn();
	thread sjp_launch_javelins();
	thread handle_capitol_roof();
	thread ambient_javs();
	thread handle_enemy_tank_advance();
	level.streets_player_outside = 1;

	if(	hide_targetname( "tank_wall_broken" ,0 ) )
		hide_targetname( "hamburg_security_gate_crash", 0 );
	
	
	
	flag_wait( "street_to_corner_finished");
	


}

////////////////////////////////////////////////////////////////////////////////////////
// Utility code
clear_path_blockers()
{
	modify_street_paths( "tankstop1int_retreat_blocker" , 1 );
	modify_street_paths( "streets_ai_keep_sides" , 1 );
	modify_street_paths( "snipernest_retreat_blocker" , 1 );
	modify_street_paths( "sjp_jav_blocker" , 1 );
	
}
streets_hide_badplaces()
{
	places = GetEntArray( "tankstop_badplace", "script_noteworthy" );
	foreach( place in places )
	{
		place Hide();
		place NotSolid();
	}
}

//
// End utility code
//
////////////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////////////
//
// Redo here.

handle_combat_flow()
{
	level endon( "launch_jav_barrage" );
	
	flag_wait( "sjp_spawn_runner_vehicle" );
	
	dudes = array_spawn_targetname_allow_fail( "sjp_gaz_flee_foot" );
	array_thread( dudes, ::enable_sprint);
	array_thread( dudes, ::streets_ignore_enemies,8,0);
	wait 1;
	spawned = spawn_vehicle_from_targetname_and_drive( "sjp_gaz_flee");
	spawned setAcceleration(25);
	spawned Vehicle_SetSpeed( 30 );

	// initial population of streets as the player turns onto it from the ramp.
	flag_wait( "streets_kick_off" );
	javdudes = [];

	thread f15_bomber();
	
	thread handle_heli_intro();
	
    array_spawn_targetname_allow_fail_setthreat_insideaware( "street_first_defence" , "axis_outside" );
	patrollers = array_spawn_targetname_allow_fail_setthreat_insideaware( "street_first_patrol" , "axis_outside" );
	
	foreach(patroller in patrollers)
	{
		patroller thread streetpatrol();
	}
	
	SetThreatBias( "ally_outside", "axis_outside", 250);
	
	
	flag_wait( "end_spawn_reinforce" );
	array_spawn_targetname_allow_fail_setthreat_insideaware( "tankstop1_int_early" ,"axis_inside"  );
	
	thread watch_tankstop1_int();
	
	
	wait 1;

	// start of tankstop spawns- everything cascades through the various threads based upon the minor tx_posx flags and major tankstop complete flags.
	flag_wait( "t1_pos1" );
//	array_spawn_targetname_allow_fail_setthreat_insideaware( "streets_tankstop1int_spawn", "axis_outside");
	array_spawn_targetname_allow_fail_setthreat_insideaware( "tankstop2_int_early"  );
	thread autosave_now(1);
	
	flag_wait( "t1_pos2" );
	flag_set( "streets_tankstop1_clear" );
	flag_set( "street_overrun_tankstop1" );
	flag_set( "spawn_tankstop2_int" );
	wait 0.1;
	level notify( "tankstop2_started");
//	if(	level.streets_player_outside == 1 )
//		array_spawn_targetname_allow_fail_setthreat_insideaware( "streets_tankstop1int_busguys" ,"axis_outside" );

	flag_set( "et_2" );
	wait 0.2;
		
	
	//retreat everyone left.
	//retreat_tankstop_group( "tankstop1_retreat_to", "tankstop1" );
	//if the player is outside, move the inside guys outside to provide more defense- the end area can get pretty crowded anyhow.
	// Otherwise let the player deal with them.
	if(	level.streets_player_outside == 1 )
	{
		thread retreat_interior( true );
	}

	wait ALLY_MOVE_WAIT_TIME_FOR_RETREAT;
	thread autosave_now(1);
	
	thread watch_low_enemy_count();

	
}

play_tank_crew_vo( vo, timeout )
{
	if( !IsDefined( timeout ) )
	{
		timeout = 3;
	}
	
	endtime = GetTime() + timeout * 1000;
	speaker = undefined;
	while( 1 )
	{
		if ( IsDefined( level.green1 ) && IsAlive( level.green1 ) )
		{
			speaker = level.green1;
			break;
		}
		if( IsDefined( level.green2 ) && IsAlive( level.green2 ) )
		{
			speaker = level.green2;
			break;
		}
		
		wait 0.1;
		if( GetTime() > endtime )
		{
			return;
		}
	}
	if( !IsDefined( speaker.animname ) )
	{
		speaker.animname = "generic";
		
		
	}
	speaker dialogue_queue( vo );
}



incoming_tank_dialogue()
{
	flag_wait( "sjp_tank_dialogue" );
	
	
	if( flag( "end_spawn_ally_tank" ) )
	{
		return;
	}
	//TANK!			
	play_tank_crew_vo( "hamburg_rhg_tank" );
	
	if( flag( "end_spawn_ally_tank" ) )
	{
		return;
	}
	//Take cover!	
	level.sandman dialogue_queue( "hamburg_snd_takecover" );
	
	/*
	target_struct = getstruct( "tank_target_tree_fire", "targetname" );
	target = target_struct.origin;

	level.end_enemytank SetTurretTargetVec( target );
    level.end_enemytank waittill( "turret_on_target" );
	level.end_enemytank FireWeapon();
	
	wait 0.2;
	activate_exploder( "enemy_tank_tree_fire" );
	forw = AnglesToForward( target_struct.angles );
	up = AnglesToUp( target_struct.angles );
	PlayFX( level._effect[ "tank_blast_wood" ],target, forw ,up );
		
	earthquake( 0.8, 0.5, target-(0,0,150), 1500 );
	*/
	//flag_wait( "sjp_tank_dialogue2" );
	wait 8;
	if( flag( "end_spawn_ally_tank" ) )
	{
		return;
	}
	
	//IPrintLnBold( "RHINO ONE!  WHERE THE HELL ARE YOU?!	");
	play_tank_crew_vo( "hamburg_rhg_whereareyou" );
}

/*
tank_test()
{
	thread autosave_now(1);

	level.player teleport_player(getnode("player_tank_test", "targetname")); // (-6614,18143,-70 ),(0,0,0));
	
	wait 1;
	
	thread tank_btr_interaction();
	flag_set( "end_spawn_btr" );
	flag_set( "end_spawn_ally_tank" );
	
	wait 999;
}
*/


pokegunner()
{
	level.end_tank endon( "death" );
	while( 1 )
	{
		level.end_tank_gunner UseTurret( level.end_tank.mgturret[1] );
		wait 2;
	}
}

#using_animtree( "generic_human" );

tank_btr_interaction()
{
	
	flag_wait( "end_spawn_btr");
	thread street_tankout_failsafe();
	
	real_tank = spawn_vehicle_from_targetname( "end_ally_tank_incoming" );
	level.end_tank = real_tank;

	
	spawner= GetEnt( "end_enemytank_attack", "targetname" );
	//spawner remove_spawn_function( ::shoot_explode );
	//spawner remove_spawn_function( ::script_vehicle_t90_tank_woodlandthink );
	spawner remove_spawn_function( maps\hamburg_tank_ai::turret_attack_think_hamburg );
	wait 0.2;
	level.end_enemytank = spawn_vehicle_from_targetname_and_drive( "end_enemytank_attack" );
	level.end_enemytank godon();
	level.end_enemytank disable_turret_fire();
	level.end_enemytank mgoff();
	level.end_enemytank.mgturret[1] SetMode( "manual" );
	
	level.end_enemytank notify ( "stop_turret_attack_think_hamburg" );

	//level.end_enemytank.turret
	
	
	level.end_enemytank maps\hamburg_tank_ai::stop_turret_attack_think_hamburg();
	wait 0.3;
	level.end_enemytank.mgturret[1] SetMode( "manual" );
	level.end_enemytank.mgturret[1] ClearTargetEntity();
	
	//level.end_enemytank thread street_tank_support(1);
	//level.end_enemytank.turret
	
	thread incoming_tank_dialogue();

	flag_wait( "end_spawn_ally_tank" );
	thread autosave_now(0);
	
	
//	level.player_tank = real_tank;
	level.end_tank endon( "death" );
	
	
	level.playervehicle = real_tank;
	badbrush = GetEnt( "tankstop_badplace_anim", "targetname" );
	BadPlace_Brush( "tankstopanim",-1,badbrush, "axis", "allies" );
	level.end_tank thread tank_kill_touching();
	//IPrintLnBold("starting tank anim.");
	
	real_tank thread street_tank_anim( real_tank );
	thread handle_axis_tank_reaction();
	wait 0.1;
	level.end_enemytank mgon();
	level.end_enemytank.mgturret[1] SetMode( "sentry" );

//	real_tank disable_turret_fire();
	real_tank.damageIsFromPlayer = true;
	real_tank maps\hamburg_tank_ai::stop_turret_attack_think_hamburg();
	if(real_tank.mgturret.size == 2)
	{
//		real_tank mgoff();
		level.end_tank_minigun = real_tank.mgturret[1];
//		IPrintLnBold( " mode = " + level.end_tank_minigun `() );
		real_tank.mgturret[0] SetMode( "sentry_offline" );
//		real_tank.mgturret[1].idle_target_always = spawn_tag_origin();
		real_tank.mgturret[1] SetMode( "manual" );
//		real_tank.mgturret[1] set_manual_target( self.idle_target_always, 0 );
		
		
	}
	gunner = level.end_tank.riders[0];
	level.end_tank_gunner = gunner;
	
	/*
	gunner = spawn_targetname( "streets_tank_minigunner" );
	gunner UseTurret( level.end_tank.mgturret[1] );
//	gunner = level.end_tank.riders[0];
	level.end_tank_gunner = gunner;
	//thread pokegunner();
	wait 0.1;
	if( !IsDefined(level.end_tank_gunner.magic_bullet_shield ))
	{
		level.end_tank_gunner magic_bullet_shield( 1 );
	}
		level.end_tank_gunner disable_danger_react();
		level.end_tank_gunner disable_pain();
		level.end_tank_gunner disable_surprise();
		level.end_tank_gunner disable_bulletwhizbyreaction();
		level.end_tank_gunner set_ignoreSuppression( true );
		level.end_tank_gunner disable_pain();
//		IPrintLnBold( "MAKING GUNNER GOD ETC." );

*/		
	real_tank godon();
		

	checkvol= GetEnt( "sjp_tank_retreat_axis", "targetname");
//	enemies = checkvol get_ai_touching_volume(  "axis" );
//	if( enemies.size > 0 )
//		level.end_tank thread kill_array_dudes( enemies ) ;

	wait 4;
	
	
	target = level.end_enemytank GetCentroid();
    level.end_tank SetTurretTargetVec( target );
    level.end_tank waittill( "turret_on_target" );
	level.end_enemytank godon();
	//level.end_tank FireWeapon();


 	aimoffset = (0, 0,60);
	fire_btr = 0;
	target = level.end_enemytank GetCentroid();

	flag_wait( "streets_killshot_btr" );
	flag_wait( "sjp_fire_allowed" );
	BadPlace_Delete( "tankstopanim" );
	
	level.end_enemytank godoff();
	
	level.end_enemytank.health = 1;
	level.end_tank  maps\hamburg_tank_ai::stop_turret_attack_think_hamburg();
	
	
	//level.end_tank notify( "stop_persistent_turret_forward");
	target = level.end_enemytank GetCentroid();
    level.end_tank SetTurretTargetVec( target );
    level.end_tank waittill( "turret_on_target" );
	tankorigin = level.end_tank GetCentroid();
//	level.end_enemytank Kill();
	
	level.end_tank FireWeapon();
	wait 0.2;
	SafeActivateTrigger( "color_move_past_tank" );
	array_spawn_targetname_allow_fail_setthreat_insideaware( "street_post_tank_reinforce"  ,"axis_outside" );
	
	while(IsDefined(level.end_enemytank) && IsAlive( level.end_enemytank) )
	{
		wait 1;
		target = level.end_enemytank GetCentroid();
	    level.end_tank SetTurretTargetVec( target );
	    level.end_tank waittill( "turret_on_target" );
		tankorigin = level.end_tank GetCentroid();
	//	level.end_tank FireWeapon();
		level.end_enemytank Kill();
		wait 0.2;
	}
	level.end_tank thread persistent_turret_forward();

	flag_set( "streets_first_btr_down");
	
	wait 0.5;

	//Threat neutralized.  We're movin up.			
	level.player thread radio_dialogue( "tank_rh1_threatneutralized" );

}

handle_axis_tank_reaction()
{
	retreat_from_vol_to_vol( "tankstop_behindtank" , level.active_combat_vol );
	
	wait 0.6;
	// Kill anyone in the immediate vicinity.
	checkvol= GetEnt( "sjp_tank_kill_volume", "targetname" );
	enemies = checkvol get_ai_touching_volume(  "axis" );
	numenemies = enemies.size;
	foreach( enemy in enemies )
	{
		enemy Kill(level.end_tank.origin, level.end_tank, level.end_tank );
	}
	
}

watch_low_enemy_count()
{
	level endon( "launch_jav_barrage" );
	tankstop2 = false;
	wait 1;
	while(1)
	{
		axis = GetAIArray( "axis" );
		undef = 0;
		inside = 0;
		outside = 0;
		num_by_bus = 0;
		bus = GetEnt( "sjp_bus_vol", "script_noteworthy" );
		if( IsDefined(bus) )
		{
			in_bus = bus get_ai_touching_volume( "axis" );
			num_by_bus = in_bus.size;
		}
		
		foreach( enemy in axis )
		{
			if(! IsDefined( enemy.inside ) )
				undef++;
			else if(enemy.inside == 1)
				inside++;
			else
				outside++;
		}
		outside -= num_by_bus;
		check = 6;
		if( !tankstop2 )
			check = 7;
		if( outside <= check )//|| flag( "et_4" ) )
		{
//			IPrintLnBold( "streets_tankstop_overrun spawned");
			tospawn = "streets_tankstop_overrun";
			if( !tankstop2 )
			{
				tospawn = "tankstop2";
				tankstop2 = true;
			}
			spawned = array_spawn_targetname_allow_fail_setthreat_insideaware( tospawn, "axis_outside" );
			send_to_active_vol( spawned );
//			flag_set( "launch_jav_barrage");
			if(tospawn == "streets_tankstop_overrun" )
				break;
		}
		//IPrintLn("T:"+axis.size+" U:"+undef+" I:"+inside+" O:"+outside);
		wait 0.5;
	}
}

sjp_launch_javelins()
{
	self notify( "stop_javelin_barrage" );
	self endon( "stop_javelin_barrage" );
	
	level.player endon( "death" );

	flag_wait("launch_jav_barrage");
	activate_trigger_with_targetname( "streets_mortar_inside_color" );
	
	
	retreaters = GetAIArray( "allies" );
	foreach( retreater in retreaters )
	{
		retreater thread streets_ignore_enemies(4,0);
	}
	vol = GetEnt( "sjp_outsiders_retreat", "targetname" );
	retreaters = vol get_ai_touching_volume( "axis" );
	goalvolume = getEnt( "sjp_outsiders_retreat_to" , "targetname" );
	Assert(IsDefined(goalvolume));
	goalvolumetarget = getNode( goalvolume.target , "targetname" );
	Assert(IsDefined(goalvolumetarget));
	foreach( retreater in retreaters )
	{
		
		retreater thread streets_ignore_enemies(-1,1);
		retreater.fixednode = 0;
		retreater SetGoalNode( goalvolumetarget );
		retreater SetGoalVolume( goalvolume );		
	}
	
	flag_set( "street_to_corner_finished" );
	// set the AI running inside- make them forget their enemies first. Blues should already be inside.
/*
	level.red1 thread streets_ignore_enemies();
	if(IsDefined(level.green1))
	   level.green1 thread streets_ignore_enemies();
	if(IsDefined(level.green2))
	   level.green2 thread streets_ignore_enemies();
*/

	SafeActivateTrigger( "streets_retreat_color" );
	//wait 0.75;
	
	
	i = 0;
	startpoint = (0,0,0);
	targetpoint = (0,0,0);
	raindeath = 1;
	thread rain_death();
	level.end_tank godoff();
	level.end_tank_gunner stop_magic_bullet_shield();
	level.end_tank_gunner.health = 1;
	
//	level.end_tank.health = 1;
	level.end_tank riders_godoff();
	
	
	level.end_tank.attachedpath = undefined;
	level.end_tank notify( "newpath" );

	level.end_tank Vehicle_SetSpeed(11,4,4);

	node = GetVehicleNode( "tank_speed_off", "targetname" );
	level.end_tank thread vehicle_paths( node );
	level.end_tank StartPath( node );
	
	level.end_tank thread tank_fire_roof();

	if( level.streets_player_outside )
	{
		wait 1.2;
	}
	thread handle_heli_jav();

	//INCOMING!!			
	play_tank_crew_vo( "hamburg_rhg_incoming" );

	delayThread( 2, ::music_stop, 3 );

	//Get inside!  Go!  Go!			
	level.sandman thread dialogue_queue( "hamburg_snd_getinside" );

	level.streets_reset_obj = false;
	if(level.streets_player_outside )
	{
		
		hvtsnipe = obj( "followtosnipe" );
		
		level.streets_reset_obj = true;
		insideobj = obj( "insideobj" );
		Objective_Position( insideobj, getstruct( "sjp_inside_objective", "targetname" ).origin );
		Objective_SetPointerTextOverride( insideobj, &"HAMBURG_INSIDE" );
		Objective_Add( insideobj, "current", &"HAMBURG_MOVE_INSIDE" );
		objective_clearAdditionalPositions(hvtsnipe);
		
		
		if(!IsDefined(level.retreat_interior ))
			retreat_interior( false );
	}

	
	secs = 2;
	while(level.streets_player_outside == 1 )
	{
		
		wait 1;
		secs++;
		if(secs % 9 == 0)
		{
			//Get inside!  Go!  Go!			
			level.sandman thread dialogue_queue( "hamburg_snd_getinside" );
		}
	}
	if( level.streets_reset_obj )
	{
		insideobj = obj( "insideobj" );
	
		Objective_Delete( insideobj );
		
		hvtsnipe = obj( "followtosnipe" );
		
		Objective_OnEntity( hvtsnipe, level.red1, (0, 0, 70) );
		
	}
	
	
	
	thread monitor_allies_javelin_area();
	
	flag_wait( "sjp_needsupport" );
}

tank_fire_roof()
{
	self endon( "death" );
	wait 2.5;
	so = GetEnt( "sjp_f15_firesidewinders_newt2", "targetname" );
	target = so.origin;
	self SetTurretTargetVec( target );
    self waittill( "turret_on_target" );
    self FireWeapon();

}


rain_death()
{
	level notify( "stop_rain_death");
	level endon( "stop_rain_death" );
	hit_tank = 0;
	fast_first_wave = true;
	wait_monitor = true;
	if(level.streets_player_outside == 0)
	{
		fast_first_wave = true;
		wait_monitor = false;
		
	}
		
	while(1)
	{
		for(i = 1;i<=5;i++)
		{
			startstr = "sjp_jav_cap_start" + i;
			endstr= "sjp_jav_cap_end" + i;
			
			if ( i == 2 || i ==4 )
				continue;
			
			targetpoint = getstruct( endstr, "targetname" ).origin;
			startpoint = getstruct( startstr, "targetname" ).origin;
			newmissile = MagicBullet( "javelin_cheap", startpoint, targetpoint );
			newmissile Missile_SetTargetPos( targetpoint );
			newmissile.dmg = 1;
			newmissile thread earthquake_on_explode( 0.6, 0.6, 2048 );
	//		if(fast_first_wave&& (i%2) == 1)
	//			newmissile Missile_SetFlightmodeDirect();
	//		else
				newmissile Missile_SetFlightmodeTop();
			if(fast_first_wave)
				wait RandomFloatRange(0.1,0.25);
			else if(!hit_tank)
				wait RandomFloatRange(1.0,2.0);
			else
				wait RandomFloatRange(1,2);
//				wait RandomFloatRange(4,10);
		}
		fast_first_wave = false;
		
		hit_tank++;
		if(hit_tank == 1)
		{
			targetpoint = level.end_tank.origin;
			startpoint = getstruct( "sjp_jav_cap_start1", "targetname" ).origin;
			newmissile = MagicBullet( "javelin", startpoint, targetpoint );
			newmissile Missile_SetTargetEnt( level.end_tank);
			newmissile Missile_SetFlightmodeTop();
			newmissile thread earthquake_on_explode( 0.4, 0.4, 2048 );
			thread monitor_street_player(wait_monitor);
			break;
		}
		if( hit_tank == 2)
			break;
		
	}
}

earthquake_on_explode( str, len, rad )
{
	self waittill( "explode" );
	if ( isdefined( self ) )
	{
		Earthquake( str, len, self.origin, rad );
		PlayRumbleOnPosition( "artillery_rumble", self.origin );
	}
}

block_ai_outside_paths()
{
	modify_street_paths( "tankstop1int_retreat_blocker" , 0 );
	modify_street_paths( "snipernest_retreat_blocker" , 0 );
	
	flag_wait( "rooftop_javs_dead" );
	
	modify_street_paths( "tankstop1int_retreat_blocker" , 1 );
	modify_street_paths( "snipernest_retreat_blocker" , 1 );
}
/*
monitor_windows_player()
{
	time_last_message = 0;
	ignore_next = level.streets_player_outside;
	while(1)
	{
	
		flag_wait( "player_near_windows" );
		if(flag( "rooftop_javs_dead") )
		{
			break;
		}

		if( GetTime() > time_last_message )
		{
			if( ignore_next )
			{
				time_last_message= GetTime() + 4000;
				ignore_next = 0;
			}
			else
			{
				time_last_message= GetTime() + 12000;
				
				switch(RandomIntRange(0,2))
				{
					case 0:
						//Frost - mget away from those windows.
						level.sandman dialogue_queue( "tank_snd_getawaywindows" );
							
					break;
					case 1:
						//"get out of the killzone.
						level.sandman dialogue_queue( "tank_snd_outofkillzone" );
						
					break;
				}
			}
		}
		wait 0.1;
		
	}
	
}
*/
monitor_street_player(wait_monitor)
{
	if( wait_monitor )
		wait 5;
	beeninside =0;
	tri = 0;
	
	thread mortar_mixin();
	outtime = 0;
	everspawned = 0;
	while( 1 )
	{
		if(flag( "rooftop_javs_dead") )
		{
			
			break;
		}
		
		while( level.streets_player_outside == 1 )
		{
			if(beeninside)
			{ 
				if( tri  == 0 )
				{
					outtime = GetTime();
					//Get inside!  Go!  Go!			
					level.sandman thread dialogue_queue( "hamburg_snd_getinside" );
					
				}
				tri++;
			}
			wait 0.2;
			
//			startstr = "sjp_jav_cap_start" + RandomIntRange(1,5);
//			
//			targetpoint = level.player.origin;
//			startpoint = getstruct( startstr, "targetname" ).origin;
//			newmissile = MagicBullet( "javelin", startpoint, targetpoint );
//			newmissile.dmg = 1;
//			
//			newmissile Missile_SetTargetPos( targetpoint );
//			if( tri % 6 >=2 )
//				newmissile Missile_SetTargetEnt( level.player );
//			
//			if(RandomIntRange(1,3) == 1)
//			{
//				newmissile Missile_SetFlightmodeTop();
//			}
//			else
//			{
//				newmissile Missile_SetFlightmodeDirect();
//			}
//			wait RandomFloatRange(2,4);
		}
		
		beeninside++;
		if(beeninside == 1)
		{
			flag_set( "monitor_outside_for_saves" );
//			thread monitor_windows_player();
			//thread block_ai_outside_paths();
		}
		tri = 0;
		wait 1;
	}
	//IPrintLnBold( "javelins down");
}
mortar_mixin()
{
//	if ( !( isdefined( level.mortar ) ) )
	level.mortar = 1;//loadfx( "explosions/artilleryExp_dirt_brown" );
	thread choose_mortar_location();
	wait 2;
	
	thread streets_trigger_targeted();
	flag_wait("rooftop_javs_dead");
	//kill off the mortars too.
}

choose_mortar_location()
{
	active_zone = "mortar_area_1";
	flag_set( active_zone );
	z1 = [];
	z2 = [];
	mortar_to_use = [];
	level.streets_mortars = [];
	level.streets_mortar_index = [];
	level.streets_mortar_index[0]="mortar_area_1";
	level.streets_mortar_index[1]="mortar_area_2";
	level.streets_mortar_index[2]="mortar_area_3";
	
	z1["mortar_area_1"] = "mortar_area_2";
	z2["mortar_area_1"] = "mortar_area_3";
	mortar_to_use["mortar_area_1"] = "streets_mortar_1";
	level.streets_mortars["mortar_area_1"] = GetEnt( "streets_mortar_1", "script_noteworthy" );
	
	z1["mortar_area_2"] = "mortar_area_1";
	z2["mortar_area_2"] = "mortar_area_3";
	mortar_to_use["mortar_area_2"] = "streets_mortar_2";
	level.streets_mortars["mortar_area_2"] = GetEnt( "streets_mortar_2", "script_noteworthy" );
	
	z1["mortar_area_3"] = "mortar_area_1";
	z2["mortar_area_3"] = "mortar_area_2";
	mortar_to_use["mortar_area_3"] = "streets_mortar_3";
	level.streets_mortars["mortar_area_3"] = GetEnt( "streets_mortar_3", "script_noteworthy" );

	level.active_mortar = active_zone;
	
	
	while(1)
	{
		flag_wait_either( z1[active_zone],z2[active_zone] );
		flag_clear( active_zone );
		if( flag(z1[active_zone]) )
		{
			active_zone = z1[active_zone];
		}
		else if( flag(z2[active_zone]) )
		{
			active_zone = z2[active_zone];
		}
		else
		{
			IPrintLnBold( "GOT INCORRECT Mortar Zone:ac =  " + active_zone );
		}
		level.active_mortar = active_zone;
	}

		
	
	
}

spawn_room_dregs()
{
	flag_wait( "spawn_init_dregs" );
	spawned = array_spawn_targetname_allow_fail_setthreat_insideaware( "sniperoom_initspawn" ,"axis_inside" );
	
	flag_wait( "spawn_dregs" );
	spawned = array_spawn_targetname_allow_fail_setthreat_insideaware( "sniperoom_spawn" ,"axis_inside" );
}

monitor_allies_javelin_area()
{
	thread spawn_room_dregs();
//	check_vol_activate_target( "sjp_corner_moveup1" );
	level notify( "sjp_stop_runners");

//	wait 4;
//	check_vol_activate_target( "sjp_corner_moveup2" );
//	
//	
//
//	check_vol_activate_target( "sjp_corner_moveup3" );
//
//	check_vol_activate_target( "sjp_corner_moveup4" );
	flag_wait( "spawn_dregs" );
	wait 1;
	wait_until_enemies_in_volume( "sjp_corner_moveup5", 2);
	//make the last two guys ignore suppression so that they come out to die.
	checkvol= GetEnt( "sjp_corner_moveup5", "targetname" );
	enemies = checkvol get_ai_touching_volume(  "axis" );
	array_thread( enemies, ::set_ignoreSuppression, true );

	level.player thread radio_dialogue( "tank_f16_engagingtargets" );
	retreat_from_vol_to_vol( "sjp_corner_moveup5", "sjp_corner_moveup5_retreat_to" );
	wait_until_enemies_in_volume( "sjp_corner_moveup5",0 );
	SafeActivateTrigger( "sjp_start_sniper_color" );
	
	// Disable any remaining interior triggers so Sandman etc. doesn't get triggered to a different node.
	flag_set( "streets_interiors_complete" );

	if( IsDefined( level.balcony_dudes ))
	{
		for( i = 0;i < level.balcony_dudes.size; i++ ) 
		{
			if( IsDefined (level.balcony_dudes[i] ) )
			{
				level.balcony_dudes[i] Kill();
			}
		}
	}
	flag_wait_or_timeout( "vaguely_looking_right_direction", 6 );
	flag_set( "rooftop_javs_dead" );
	level notify( "stop_rain_death");
}
	

f15_bomber()
{
	flag_wait( "rooftop_javs_dead" );
	f152 = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 534 );
	f15_overhead = f152[0];

	f15_overhead thread f15_overhead_handler();

	
	wait 1; // give the player some time to watch it before kicking everything off
	thread maps\hamburg_end_nest::setup_battle2_to_hvts();
	
//	battlechatter_on("allies");
	
	//setup threads for last battle.
	flag_set( "streets_javelins_down");
	
	
	wait 1;
	
	flag_set("start_outside_battle2");
}

f15_overhead_handler()
{
//	wait 0.2;
	thread handle_f15_rumble();
	r_offset_m = ( 76,-74, -105 );
	l_offset_m = ( 76, 74, -135 );
	fx = getfx( "f15_missile_trail" );
	//fx = getfx( "rpg_trail" );
	
	flags = [];
	flags[flags.size] = "sjp_f15_firesidewinders_far";
	flags[flags.size] = "sjp_f15_firesidewinders_overhead";
	target1 = GetEnt( "streets_mortar_1", "script_noteworthy" );
	target2 = GetEnt( "sjp_f15_firesidewinders_newt2", "targetname" );
	

	left_start = (0,0,0);
	right_start = (0,0,0);
	left_end = (0,0,0);
	right_end = (0,0,0);
	found_heli = false;

	for( i =0; i <2; i++ )
	{
		flag_wait( flags[i] );
		
	//	self thread maps\_helicopter_globals::fire_missile( "f15_missile", 2, target, 0.1, 99);
		if( i == 0)
		{
			heli = get_vehicle( "endstreets_heli_rooftop", "targetname" );

			left_start = getstruct( "sjp_fire_far_r", "targetname").origin;
			left_end = getstruct( "sjp_fire_far_rt", "targetname").origin;
			
			if(!IsDefined(heli) )
			{
				right_end = getstruct( "sjp_fire_far_lt", "targetname").origin;
				//IPrintLnBold(" NO HELI!");
			}
			else 
			{
				//IPrintLnBold(" FOUND HELI!");
				right_end = heli.origin-(0,0,72);
				found_heli = true;
				
			}
			right_start = getstruct( "sjp_fire_far_l", "targetname").origin;
			
		}
		else
		{
			left_start = get_world_relative_offset(self.origin, self.angles, l_offset_m);
			left_end = target1.origin;
			right_end =  target2.origin;
	
		}
			
		missile1 = MagicBullet( "f15_missile", left_start, left_end);
		PlayFXOnTag( fx, missile1, "tag_origin" );
		wait 0.2;
		if( i == 1)
		{
			right_start = get_world_relative_offset(self.origin, self.angles, r_offset_m);
		}

		missile2 = MagicBullet( "f15_missile", right_start, right_end);
		aud_send_msg("f15_missile", missile2);
		PlayFXOnTag( fx, missile2, "tag_origin" );
		if(i == 0)
		{
			if( !found_heli )
				missile2 thread handle_roof_hit( "f15_near_r" );
				
//			heli = get_vehicle( "endstreets_heli_rooftop", "targetname" );
//			missile2 Missile_SetTargetEnt(heli, (0,0,-72) );
//			missile2 Missile_SetFlightmodeTop();
			
			missile1 thread destroy_tower_piece();
		}
		else
		{
			missile1 thread handle_roof_hit( "f15_near_l" );
//			missile2 thread handle_roof_hit( "f15_near_r" );
			missile2 thread destroy_roof_piece( "f15_near_r" );
		}

	}
}
handle_f15_rumble()
{
	wait 1.0;
	level.player thread play_sound_in_space( "veh_f15_sonic_boom" );
	wait 0.5;
	Earthquake(0.5,1,level.player.origin,500);
	
}

handle_roof_hit( expl_name )
{
	self waittill( "death" );
	exploder( expl_name );
	

}

destroy_tower_piece()
{
	self waittill( "death" );
	exploder( "f15_far_r");
	
	ents = GetEntArray( "tower_chunk_parts", "script_noteworthy" );
	wait 0.2;
	foreach(ent in ents)
	{
		ent Hide();
	}
}
destroy_roof_piece( expl_name )
{
	self waittill( "death");
	exploder( expl_name );
	
	ents = GetEntArray( "f15_missile_roof_destroy", "targetname" );
	foreach(ent in ents)
	{
		ent Hide();
	}
	
	
}


f15_watch( target )
{
	target endon( "death" );
	
	flag_wait( "streets_spawn_f15" );
	wait 2;
	f15s = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 333 );
	target.enableRocketDeath = true;
	
	flag_wait( "streets_f15_fire_missile1" );
	
	r_offset_m = ( 76,-124, -105 );
	l_offset_m = ( 76, 124, -135 );
	fx = getfx( "f15_missile_trail" );
	attackfrom = 1;
	flag_set( "end_spawn_reinforce" );
	
	while(IsDefined(target) )
	{
		
		left_start = get_world_relative_offset(f15s[attackfrom].origin, f15s[attackfrom].angles, l_offset_m);
		left_end = target.origin;
		missile1 = MagicBullet( "f15_missile", left_start, left_end);
		missile1 Missile_SetTargetEnt( target );
		missile1 Missile_SetFlightmodeDirect();
		PlayFXOnTag( fx, missile1, "tag_origin" );
		wait 0.2;
	
		right_start = get_world_relative_offset(f15s[attackfrom].origin, f15s[attackfrom].angles, r_offset_m);
		right_end = target.origin;
		missile2 = MagicBullet( "f15_missile", right_start, right_end);
		PlayFXOnTag( fx, missile2, "tag_origin" );
		missile2 Missile_SetTargetEnt( target );
		missile1 Missile_SetFlightmodeDirect();
		
		if(attackfrom == 1)
			attackfrom = 0;
		else
			attackfrom = 1;
		wait 0.5;
	}
	
	

}


handle_capitol_roof()
{

	flag_wait( "sjp_runners_on_roof" );
	thread handle_roof_runners();
	
//	IPrintLnBold( "spawning extra");
	axis = GetAICount( "axis" );
	if( axis < 18 )
	{
		spawned = array_spawn_targetname_allow_fail_setthreat_insideaware( "street_extra_on_runners" ,"axis_outside" );
		send_to_active_vol( spawned );
	}
/*
	wait 2;	
	axis = GetAICount( "axis" );
	if( axis < 18 )
	{
		spawned = array_spawn_targetname_allow_fail_setthreat_insideaware( "street_extra_on_runners2" ,"axis_outside" );
		send_to_active_vol( spawned );
	}
*/	
	
//	wait 3; // let the pump start pumping.
	//temp_dialogue( "Sandman","We've got runners on the Capitol building! " );
//	level.sandman  dialogue_queue( "tank_snd_runnersoncapital" );
	
	

}
//drones
handle_roof_runners()
{
	level notify( "sjp_stop_runners");
	level endon("sjp_stop_runners");
	
	while(1)
	{
		randint = RandomIntRange(15, 20);
		ambient = array_spawn_targetname_with_delay("sjp_roof_runners");
		
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



handle_heli_intro()
{
	// osprey / heli interactoins.
	introfly = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 331 );
	
	// other vehicles in the background
	ambientfly = maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 334 );
	
	hind = introfly[0];
	osprey = introfly[1];
	osprey.enableRocketDeath = true;
	osprey godon();
	
	aud_send_msg("street_chopper_fly_by", [hind, osprey]);
		
	hind Vehicle_SetSpeedImmediate(120, 35, 17.5);
	hind endon( "death" );

	// f15 that comes in and finishes off hind
	thread f15_watch(hind);
	
	streetszippy = [];
	for(i = 0; i <8; i++)
	{
		streetszippy[i] = getent( "streets_zippy" + (i + 1), "targetname");
	}
	
	flag_wait( "streets_hind_fire_osprey" );

	for( j = 0; j< 4; j++)
	{
//		if( j == 2 )
//		{
//			osprey godoff();
//			osprey.health = 1;
//		}
	
		if(j <= 1)
		{
			for( i = 0; i < 4; i++ )
			{
				offset_salvo = 0.15;
				hind thread maps\_helicopter_globals::fire_missile( "mi28_zippy", 1, streetszippy[(j * 4) + i]);
				wait ( offset_salvo );
			}
			wait 1;
		}
		else
		{
			for( i = 0; i < 6; i++ )
			{
				if( !IsDefined( hind ) || !IsAlive( hind ) )
				{
					return;
				}
				offset_salvo = 0.15; // RandomFloatRange ( 0.1, 0.25 );
				hind thread maps\_helicopter_globals::fire_missile( "mi28_zippy", 1, osprey);
				wait ( offset_salvo );
			}
			wait 1;
		}
	}
}
get_world_relative_offset( origin, angles, offset )
{
	cos_yaw = cos( angles[ 1 ] );
	sin_yaw = sin( angles[ 1 ] );

	// Rotate offset by yaw
	x = ( offset[ 0 ] * cos_yaw ) - ( offset[ 1 ] * sin_yaw );
	y = ( offset[ 0 ] * sin_yaw ) + ( offset[ 1 ] * cos_yaw );

	// Translate to world position
	x += origin[ 0 ];
	y += origin[ 1 ];
	return ( x, y, origin[ 2 ] + offset[ 2 ] );
}



// this throws up a path blocker along the windows of the first interior area so the 
// enemy won't come out level with the player and take them from behind / by surprise.
retreat_interior( block_windows )
{
	level.retreat_interior = 1;
	delay = 3;
	if( block_windows )
		modify_street_paths( "tankstop1int_retreat_blocker" , 0 );
	else
	{
		delay = 8;
	}
	retreat_tankstop_group( "tankstop1int_retreat_outside", "tankstop1_int", undefined, 0, delay );
	
	wait 1.5;					 
	if( block_windows )
		modify_street_paths( "tankstop1int_retreat_blocker" , 1 );
}
		







monitor_tankstops()
{
	
	flag_wait( "streets_killshot_btr" );
	wait 3;
	
	wait_until_enemies_in_volume( "moveup_tankstop1_pos1",4 );
	flag_set( "t1_pos1");
	wait 1;	         
	
	wait_until_enemies_in_volume( "moveup_tankstop1_pos2",2 );
	flag_set( "t1_pos2");	
	wait 12;	         
}



retreat_tankstop_group( retreat_vol, group1, group2, delete_on_retreat, delay)
{
	AssertEx (  ((IsDefined(retreat_vol)  && IsDefined( group1 ) ) ), "Need at least the info volume name and one ai group." );
	if( !IsDefined( delay ) )
	   delay = 3;
	deleteme = 0;
	if( IsDefined( delete_on_retreat ) && delete_on_retreat )
	{
		delay = -1;
		deleteme = 1;		
	}
	
	retreaters = get_ai_group_ai(group1);
	if( IsDefined( group2 ) )
	{
		retreat2 = get_ai_group_ai( group2);
		retreaters = array_combine( retreaters, retreat2 );
	}
	
	goalvolume = getEnt( retreat_vol , "targetname" );
	Assert(IsDefined(goalvolume));
	goalvolumetarget = getNode( goalvolume.target , "targetname" );
	Assert(IsDefined(goalvolumetarget));
	foreach( retreater in retreaters )
	{
		
		retreater thread streets_ignore_enemies(delay,deleteme);
		retreater.fixednode = 0;
		retreater SetGoalNode( goalvolumetarget );
		retreater SetGoalVolume( goalvolume );		
	}
	
}




street_tankout_failsafe()
{
	flag_wait_either( "street_tankout_failsafe" , "sjp_looking_tank_spot" );
	flag_set( "end_spawn_ally_tank" );
	
	//speed us up!
	if(  ( !flag( "sjp_fire_allowed" ) ) && IsDefined( level.end_enemytank ) && IsAlive( level.end_enemytank) )
	{
		level.end_enemytank thread watch_player_runon();
		level.end_enemytank Vehicle_SetSpeed( 10, 10, 10 );
		flag_wait( "sjp_fire_allowed" );
		level.end_enemytank Vehicle_SetSpeed( 4, 10, 20 );
		
	}
	
	
}
watch_player_runon()
{
	self endon( "death" );
	firsttime = 1;
	vol = GetEnt( "sjp_outsiders_retreat", "targetname" );
	while(1)
	{
		if( any_players_istouching( vol ) )
		{
			if(firsttime)
			{
				firsttime = 0;
				self thread handle_enemy_mg();
			}
			self SetTurretTargetVec( level.player.origin + (0,0,40) );
	    	self waittill( "turret_on_target" );
	    	self FireWeapon();
	    	wait 1;
		}
		wait 0.1;
	}
}

handle_enemy_mg()
{
	mgs = [];
	foreach( mg in self.mgturret )
		mgs[mgs.size] = mg;
	
	self handle_enemy_mg_blocking();
	foreach (mg in mgs)
	{
		mg notify( "turret_cleanup" );
	}
}

handle_enemy_mg_blocking()
{
	self endon( "death" );
	self mgon();
			
	foreach( mg in self.mgturret )
		mg SetMode( "manual" );

	while( 1 )
	{
		foreach( mg in self.mgturret )
		{
			mg thread set_manual_target( level.player , 3 );
		}
		wait 3;
	}
}
show_targetname( name )
{
	ent = GetEnt( name, "targetname" );
	if( IsDefined( ent ) )
	{
	   	ent Show();
	   	return true;
	}
	return false;
}
hide_targetname( name , make_not_solid )
{
	ent = GetEnt( name, "targetname" );
	if( IsDefined( ent ) )
	{
		ent Hide();
		if( make_not_solid )
		{
			ent NotSolid();
			ent ConnectPaths();
		}
	   	return true;
	}
	return false;
}

#using_animtree( "vehicles" );
street_tank_anim(realtank)
{
	self.animname = "generic" ;
	self useAnimTree( level.scr_animtree[ self.animname ] );
	self setanimtree(); 
	animateto = getstruct( "animate_koolaid_tank", "targetname" );
	gate = getent(  "hamburg_security_gate_crash", "targetname" );
	if(hide_targetname( "tank_wall_whole" ,1 ) )
	{
		gate Show();
		show_targetname( "tank_wall_broken" );
	}
	gate.animname = "streets_entrance" ;
	exploder( "garage_explode");
	exploder( "tank_breach_after_sparks" );
	exploder( "tank_breach_after_dust" );
	exploder( "tank_breach_after_fire1" );

	gate useAnimTree( level.scr_animtree[ gate.animname ] );
	
	actors = [];
	actors[actors.size] = self;
	actors[actors.size] = gate;
	
	earthquake( 0.5, 2, gate.origin, 2000 );
	thread spawn_blue_allies( "hamburg_end_street" );
	thread setgroup_maybedead( "blueend1_spawned", level.blue1,"ally_outside");
	thread setgroup_maybedead( "blueend2_spawned", level.blue2,"ally_outside");
//	SetBiasPlayerOutside();
	//self thread persistent_turret_forward();

	PlayFXOnTag( getfx( "tank_breach_brick_trail" ), gate, "J_Stone_5" );
	PlayFXOnTag( getfx( "tank_breach_brick_trail" ), gate, "J_Stone_7" );
	PlayFXOnTag( getfx( "tank_breach_brick_trail" ), gate, "J_Stone_8" );
	PlayFXOnTag( getfx( "tank_breach_brick_trail" ), gate, "J_Stone_2" );
	
	gate thread do_fx_on_brick( "J_Stone_5", 3 );
	gate thread do_fx_on_brick( "J_Stone_7", 4 );
	gate thread do_fx_on_brick( "J_Stone_8", 3.2 );
	gate thread do_fx_on_brick( "J_Stone_2", 2 );
	
	animateto thread anim_single(actors, "streets_bust_out_garage" );
	
	aud_send_msg("tank_smash_through_wall");
		
	wait 0.8;
	level.end_tank.mgturret[0] notify( "stop_burst_fire_unmanned" );
	level.end_tank.mgturret[0] notify( "turretstatechange" );
	
	wait 3.2;

	self stopanimscripted();
	//IPrintLnBold("anim finishing up now.");
	//wait 1;
	
	//IPrintLnBold("setting low speed");
	
	level.end_tank setAcceleration(5);
	level.end_tank Vehicle_SetSpeed( 6 );
	//wait 1;
	
	//IPrintLnBold("starting movement");

	node = GetVehicleNode( "streets_tank_cont", "targetname" );
	level.end_tank thread vehicle_paths( node );
	level.end_tank StartPath( node );
	wait 3;
	target = level.end_tank GetCentroid();
    level.end_enemytank SetTurretTargetVec( target );
 
	//wait 2;	
	
//	level.end_tank thread manage_minigun();
	level.end_tank waittill ( "reached_end_node" );
	level.end_tank notify( "kill_touching" );
	
	level.end_tank.script_attackai = 0;
	level.end_tank.script_turret = 0;
//	level.end_tank  streets_start_turret( 0 );
	thread handle_tank_down_street();
	level.end_tank thread start_tank_smart_targets();
	
	
	self.disconnect_paths = 1;
	self DisconnectPaths();
	
	flag_wait( "streets_first_btr_down");
	
	wait 1;

	
	//level.end_tank thread street_tank_support(0);
}

do_fx_on_brick( tag, time )
{
	effect_id = getfx( "tank_breach_brick_trail" );
	PlayFXOnTag( effect_id, self, tag );
	wait time;
	StopFXOnTag( effect_id, self, tag );
}


streetpatrol()
{
	self disable_surprise();
	self thread path_ignore_til_pathend();
	self waittill( "enemy" );
	self enable_sprint();
}
watch_tankstop1_int()
{
	flag_wait( "street_spawn_tankstop1_int" );	
	spawned = array_spawn_targetname_allow_fail_setthreat_insideaware( "tankstop1_int" ,"axis_inside" );
	level.balcony_dudes = [];
	level.balcony_dudes = array_spawn_targetname_allow_fail( "street_balcony" );
	
	//if there is anyone left in the ramp area, delete them now.
	rampai = get_ai_group_ai( "streets_ramp" );
	if( rampai.size > 0 )
	{
		foreach( guy in rampai )
			guy Delete();
	}
	
}

handle_tankstop2int_spawn()
{
	flag_wait( "spawn_tankstop2_int" );
	array_spawn_targetname_allow_fail_setthreat_insideaware( "tankstop2_int"  ,"axis_inside" );
	
}

retreat_from_vol_to_vol( from_vol, retreat_vol, ignore_enemies)
{
	if(   !(IsDefined(retreat_vol)  || !IsDefined( from_vol )  ) )
		return;
	
	if( !IsDefined( ignore_enemies ) )
		ignore_enemies = true;

	checkvol = getEnt( from_vol , "targetname" );
	retreaters = checkvol get_ai_touching_volume(  "axis" );
	goalvolume = getEnt( retreat_vol , "targetname" );
	goalvolumetarget = getNode( goalvolume.target , "targetname" );
	foreach( retreater in retreaters )
	{
		retreater disable_ai_color();
		if( ignore_enemies )
			retreater thread streets_ignore_enemies();
		retreater.fixednode = 0;
		//retreater.sprint = true;
		retreater SetGoalNode( goalvolumetarget );
		retreater SetGoalVolume( goalvolume );		
	}
	
}








persistent_turret_forward()
{
	self notify( "stop_persistent_turret_forward");
	self endon( "stop_persistent_turret_forward");
	self endon( "death" );
	while(1)
	{
		self streets_turret_forward();
		wait 0.2;
	}
}

streets_turret_forward()
{
	self ClearTurretTarget();
	
	vect = ( 0, 0, 32 ) + self.origin + ( AnglesToForward( self.angles ) * 3000 );
	
	if ( IsDefined( self.default_target_vec ) )
		self SetTurretTargetVec( self.default_target_vec );
	else
		self SetTurretTargetVec( vect );
	return vect;
}

streets_ignore_enemies( delay , mark_for_delete )
{
	if( !IsDefined(delay))
		delay = 3;
	if( !IsDefined(mark_for_delete))
		mark_for_delete = false;
	
	self.ignoreall = true;
	self ClearEnemy();
	if( delay == -1 )
	{
		self waittill( "goal" );
	}
	else
	{
		wait delay;
	}
	if(IsDefined(self) && IsAlive(self) )
	{
		if( mark_for_delete )
		{
			self Delete();
			return;
		}
		self.ignoreall = false;
		self disable_sprint();
		
	}
	
}
/*
handle_threatbiasgroup_outside()
{
	while( 1 )
	{
		flag_waitopen( "streets_player_inside" );
		{
			IPrintLnBold( " player inside" );
		}
	}
}
*/
array_spawn_targetname_allow_fail_setthreat_insideaware( tospawn , threatgroup )
{
	//Debug code to help get a handle on where too many guys spawn at once.
	/*
	axis = GetAIArray( "axis" );
	start_axis = axis.size;
	spawners = GetEntArray( tospawn, "targetname" );
	spawned = array_spawn_targetname_allow_fail( tospawn);
	IPrintLnBold( "Spawning: " + tospawn+". "+spawned.size+" of "+spawners.size );
	axis = GetAIArray( "axis" );
	end_axis = axis.size;
	
	lost = start_axis + spawners.size- end_axis;
	if(lost > 0)
	{
		if( !IsDefined(level.ttllost ) )
		{
			level.ttllost = 0;
		}
		level.ttllost += lost;
		IPrintLnBold( "LOST:" + lost +" TTL:"+ level.ttllost);
	}
	*/
	spawned = array_spawn_targetname_allow_fail( tospawn);
	
	foreach(spawn in spawned)
	{
		if(IsDefined( spawn ) )
		{
			if( IsDefined( spawn.script_parameters ) && spawn.script_parameters == "streets_ai_starting_inside" )
			{
				spawn SetThreatBiasGroup( "axis_inside" );
				spawn.inside = 1;
			}
			else
			{
				spawn SetThreatBiasGroup( "axis_outside" );
				spawn.inside = 0;
				
			}
		}
		
	}
	return spawned;
}
	


watch_inside_trigger()
{
	trigger = GetEnt( "streets_inside_border", "targetname" );
	while(1)
	{
		trigger waittill( "trigger", ent );
		if( IsDefined( ent) )
		{
			//IPrintLnBold( "inside trig by " + ent.classname );
			if(ent.team == "axis" )
			{
				if( ent GetThreatBiasGroup() != "axis_inside" )
				{
					ent SetThreatBiasGroup( "axis_inside" );
					ent.inside = 1;
					
					PokeBiasGroups();
				}
				
			}
			else
			{
				//IPrintLnBold( "inside trig by " + ent.classname );
				if( ent == level.player)
				{
					if( level.streets_player_outside == 1 )
						setplayerinside();
				}
				else
				{
					if( ent GetThreatBiasGroup() != "ally_inside" )
					{
						ent SetThreatBiasGroup( "ally_inside" );
						PokeBiasGroups();
					}
				}
			}
		}
	}
}

watch_outside_trigger()
{
	trigger = GetEnt( "streets_outside_border", "targetname" );
	while(1)
	{
		trigger waittill( "trigger", ent );
		//IPrintLnBold( "outside trig by " + ent.classname );
		if( IsDefined( ent ) )
		{
			if(ent.team == "axis" )
			{
				if( ent GetThreatBiasGroup() != "axis_outside" )
				{
					ent SetThreatBiasGroup( "axis_outside" );
					ent.inside = 0;
					
					PokeBiasGroups();
				}
			}
			else
			{
				//IPrintLnBold( "outside trig by " + ent.classname );
				if( ent == level.player )
				{
					if( level.streets_player_outside == 0)
						setplayeroutside();
				}
				else
				{
					if( ent GetThreatBiasGroup() != "ally_outside" )
					{
						ent SetThreatBiasGroup( "ally_outside" );
						PokeBiasGroups();
					}
				}
			}
		}

	}
}


handle_ally_threatbiasgroup()
{
	// initial groups
	createthreatbiasgroup( "ally_outside");
	createthreatbiasgroup( "ally_inside");
	createthreatbiasgroup( "axis_inside");
	createthreatbiasgroup( "axis_outside");
	
	level.player SetThreatBiasGroup( "ally_outside" );
	level.streets_player_outside = 1;
	level.red1   SetThreatBiasGroup( "ally_outside" );
	thread setgroup_maybedead( "greenend1_spawned", level.green1,"ally_outside");
	thread setgroup_maybedead( "greenend2_spawned", level.green2,"ally_outside");

	PokeBiasGroups();
}
PokeBiasGroups()
{
	SetIgnoreMeGroup("ally_inside","axis_outside");
	SetIgnoreMeGroup("axis_outside","ally_inside");
	SetIgnoreMeGroup( "ally_outside",	"axis_inside");
	SetIgnoreMeGroup( "axis_inside",	"ally_outside");
}
setplayerinside()
{
	level.player SetThreatBiasGroup( "ally_inside" );
//	level.red1   SetThreatBiasGroup( "ally_inside" );
//	thread setgroup_maybedead( "blueend1_spawned", level.blue1,"ally_outside");
//	thread setgroup_maybedead( "blueend2_spawned", level.blue2,"ally_outside");
	level.streets_player_outside = 0;
	if( flag( "disabled_saves_outside" ) )
	{
		flag_set( "can_save" );
		//IPrintLnBold("SAVES ALLOWED");
		
		flag_clear( "disabled_saves_outside" );
	}
	
	PokeBiasGroups();

}

setplayeroutside()
{
		
	level.player SetThreatBiasGroup( "ally_outside" );
//	level.red1   SetThreatBiasGroup( "ally_outside" );
//	thread setgroup_maybedead( "blueend1_spawned", level.blue1,"ally_inside");
//	thread setgroup_maybedead( "blueend2_spawned", level.blue2,"ally_inside");
	level.streets_player_outside = 1;
	PokeBiasGroups();
	
	//fix for odd bug where you can get a save when you are outside- stop it saving if player goes outside whilst the mortars are active.
	if( flag( "monitor_outside_for_saves" ) && !flag( "rooftop_javs_dead" ) )
	{
		flag_set( "disabled_saves_outside" );
		flag_clear( "can_save" );
		//IPrintLnBold("SAVES NOT HAPPENING");
		
		thread wait_enable_save();
	}

}

wait_enable_save()
{
	flag_wait_either( "can_save", "rooftop_javs_dead" );

	//IPrintLnBold("SAVES ALLOWED");
	
	flag_set( "can_save" );
	flag_clear( "disabled_saves_outside" );
}


setgroup_maybedead( flagtowait, who, groupto)
{
	if(!IsDefined(who) || IsAlive(who) == false )
	{
		flag_wait(flagtowait);
		who SetThreatBiasGroup(groupto);
		PokeBiasGroups();//only poke the groups if we had to wait, otherwise it is done real soon.
		return;
	}
	who SetThreatBiasGroup(groupto);
}
/*
SetBiasPlayerInside()
{
	level.streets_player_outside = 0;
	SetThreatBiasAgainstAll( "ally_inside",1 );
	SetThreatBiasAgainstAll( "axis_outside",1 );
	SetThreatBiasAgainstAll( "ally_outside",1 );
	SetThreatBiasAgainstAll( "axis_inside",1 );
}
*/

modify_street_paths( brushnames , enablepath )
{
	brushes = getentarray( brushnames , "targetname" );
	foreach( brush in brushes)
	{
		brush Solid();
		brush Show();
		if(enablepath)
		{
			brush ConnectPaths();
		}
		else
		{
			brush DisconnectPaths();
		}
		brush Hide();
		brush NotSolid();
	}
}

wait_until_enemies_in_volume( vol, num_in )
{
	checkvol= GetEnt( vol ,"targetname");
	AssertEx( IsDefined(checkvol), "volume undefined " + vol );
	enemies = checkvol get_ai_touching_volume(  "axis" );
	numenemies = enemies.size;
	
//	IPrintLn( "ttl:" + GetAICount()  +  " vol " + vol + " contains:" + numenemies );//commentsjp

	while( numenemies > num_in)
	{
		wait 1;
		enemies = checkvol get_ai_touching_volume(  "axis" );
		numenemies = enemies.size;
		if( numenemies - num_in < 3 )
		{
			foreach( enemy in enemies )
			{
				if( enemy doingLongDeath() || enemy.delayedDeath )
				{
					//IPrintLnBold( "found a bleeder" );
					numenemies --;
				}
			}
		}

/*
		IPrintLn( "ttl:" + GetAICount()  +  " vol " + vol + " contains:" +numenemies );//commentsjp
		if(level.player FragButtonPressed())
		{
			axis = GetAIArray( "axis" );
			foreach( enemy in axis)
			{
				start = enemy GetCentroid();
				end = start + (0,0,500);
				thread draw_line_for_time(start,end,1,0,0,8);
			}
			axis = GetAIArray( "allies" );
			foreach( enemy in axis)
			{
				start = enemy GetCentroid();
				end = start + (0,0,500);
				thread draw_line_for_time(start,end,0,0,1,8);
				
			}
			
		}
*/
	}

}


streets_trigger_targeted()
{

	for ( i = 0;i < level.streets_mortars.size;i++ )
	{
		level.streets_mortars[ level.streets_mortar_index[i] ] streets_setup_mortar_terrain();
	//	IPrintLnBold("setup mortar: "+level.streets_mortar_index[i] + " with targets:" + level.streets_mortars[ level.streets_mortar_index[i] ].terrain.size);
	}

	mortar = level.streets_mortars[level.active_mortar];
	last_mortar =  mortar.terrain[0];
	
	level.outside_count = 0;
	while ( 1 )
	{
		if(flag( "rooftop_javs_dead" ))
		{
			break;
		}
		mortar = level.streets_mortars[level.active_mortar];
		m_array = mortar.terrain;
		m_array = array_remove(m_array,last_mortar);
		if( level.streets_player_outside && level.outside_count <4 )
		{
			m_array = get_outside_range(level.player.origin, m_array, 156);
		}
		choice = get_closest_to_player_view( m_array, level.player, true, 0.5 );
			
		if( !IsDefined( choice ) || choice == last_mortar )
		{
			choice = last_mortar; // could be undefined.
			while(choice == last_mortar && m_array.size > 1)
				choice =  m_array[RandomIntRange(0, m_array.size)];
			
		}
		last_mortar = choice;
		choice thread streets_activate_mortar( undefined, undefined, undefined, undefined, undefined, undefined, false );
		if( level.streets_player_outside == 0 )
		{
			wait(  RandomFloatRange(2,3.5));
			level.outside_count = 0;
		}
		else
		{
			level.outside_count++;
			wait(  RandomFloatRange(1,3));
			
		}
	}
}

streets_activate_mortar( range, max_damage, min_damage, fQuakepower, iQuaketime, iQuakeradius, bIsstruct )
{
//	if(bIsstruct)
//	{
//		if(distance(self.origin,level.player.origin) < 1000)
//			incoming_sound( undefined, bIsstruct );
//	}
//	else
	BadPlace_Cylinder("",2.5,self.origin,90,128, "axis");
	self streets_incoming_sound( undefined, true );

	level notify( "mortar" );
	self notify( "mortar" );


	if ( !isdefined( range ) )
		range = 200;
	if ( !isdefined( max_damage ) )
		max_damage = 400;
	if ( !isdefined( min_damage ) )
		min_damage = 25;

	origin = self.origin;
	if( level.outside_count >=4 && level.streets_player_outside )
	{
		origin = level.player.origin;
	}
	radiusDamage( origin, range, max_damage, min_damage );

	if ( ( isdefined( self.has_terrain ) && self.has_terrain == true ) && ( isdefined( self.terrain ) ) )
	{
		for ( i = 0;i < self.terrain.size;i++ )
		{
			if ( isdefined( self.terrain[ i ] ) )
				self.terrain[ i ] delete();
		}
	}

	if ( isdefined( self.hidden_terrain ) )
		self.hidden_terrain show();
	self.has_terrain = false;

	self streets_mortar_boom( origin, fQuakepower, iQuaketime, iQuakeradius, undefined, true );
}

streets_mortar_boom( origin, fPower, iTime, iRadius, effect, bIsstruct )
{
	if ( !isdefined( fPower ) )
		fPower = 0.15;
	if ( !isdefined( iTime ) )
		iTime = 2;
	if ( !isdefined( iRadius ) )
		iRadius = 850;


	self thread streets_mortar_sound( bIsstruct );

	if ( isdefined( effect ) )
		playfx( effect, origin );
	else
	{
		forw = AnglesToForward( self.angles );
		up = AnglesToUp( self.angles );
		PlayFX( level._effect[ "tank_blast_decal_asphalt"] , origin, forw ,up );
		PlayFX( level._effect[ "tank_blast_concrete" ],origin, forw ,up );
		
	}
	//IPrintLnBold("mortar sphere incoming.");
	earthquake( fPower, iTime, origin, iRadius );

}

streets_mortar_sound( bIsstruct )
{
	if ( !bIsstruct )
		self PlaySound( level.scr_sound[ "mortar" ][ "concrete" ] );
	else
		self thread play_sound_in_space( level.scr_sound[ "mortar" ][ "concrete" ] );
}

streets_incoming_sound( soundnum, bIsstruct )
{
	currenttime = gettime();
	if ( !isdefined( level.lastmortarincomingtime ) )
	{
		level.lastmortarincomingtime = currenttime;
	}
	else if ( ( currenttime - level.lastmortarincomingtime ) < 1000 )
	{
		wait 1;
		return;
	}
	else
	{
		level.lastmortarincomingtime = currenttime;
	}

	
	if ( bIsstruct )
		play_sound_in_space( "mortar_incoming", self.origin );
	else
	{
		self PlaySound("mortar_incoming","incoming_finished" );
		self waittill("incoming_finished");
		
	}
}
streets_setup_mortar_terrain()
{
	self.has_terrain = false;
	if ( isdefined( self.target ) )
	{
		self.terrain = getstructarray( self.target, "targetname" );
		self.has_terrain = true;
	}
	else
	{
		println( "z:          mortar entity has no target: ", self.origin );
	}

	if ( !isdefined( self.terrain ) )
		println( "z:          mortar entity has target, but target doesnt exist: ", self.origin );

	if ( isdefined( self.script_hidden ) )
	{
		if ( isdefined( self.script_hidden ) )
			self.hidden_terrain = getent( self.script_hidden, "targetname" );
		else if ( ( isdefined( self.terrain ) ) && ( isdefined( self.terrain[ 0 ].target ) ) )
			self.hidden_terrain = getent( self.terrain[ 0 ].target, "targetname" );

		if ( isdefined( self.hidden_terrain ) )
			self.hidden_terrain hide();
	}

	else if ( isdefined( self.has_terrain ) )
	{
		if ( ( isdefined( self.terrain ) ) && ( isdefined( self.terrain[ 0 ].target ) ) )
			self.hidden_terrain = getent( self.terrain[ 0 ].target, "targetname" );

		if ( isdefined( self.hidden_terrain ) )
			self.hidden_terrain hide();
	}

}

ambient_javs()
{
	level endon( "launch_jav_barrage" );
	
	end_jav = getstructarray( "jav_ambient_end_point", "targetname" );
	start_jav = getstructarray( "jav_ambient_launch_point", "targetname" );
	
	while(1)
	{
		end   = end_jav[RandomIntRange(0, end_jav.size)].origin;
		start = start_jav[RandomIntRange(0, start_jav.size)].origin;

		newmissile = MagicBullet( "javelin_cheap", start, end );
		newmissile Missile_SetTargetPos( end );
		newmissile Missile_SetFlightmodeTop();
		delaythread( 12, ::delete_if_defined, newmissile );
		wait RandomFloatRange(3,12);
	}
	
}

delete_if_defined( thing )
{
	if ( isdefined( thing ) )
		thing delete();
}

kill_array_dudes( clump )
{
	self endon( "death" );
	level endon( "launch_jav_barrage" );
	
//	self ClearTargetEntity();
//	self set_manual_target( self.idle_target_always, 0 );
	
	self SetMode( "sentry" );
	
	shot = false;
	// check can see them.
	height_add = (0,0,32);
	end_time = GetTime() + 6000;
	num = 0;
	foreach( guy in clump)
	{
		if( GetTime() > end_time )
			break;
		if( !IsDefined( guy ) || !IsAlive(guy) )
		{
			continue;
		}
		origin = guy GetCentroid();
		
	
		if ( SightTracePassed( level.end_tank_gunner GetEye(), origin , false, self,level.end_tank_gunner ) )
		{
			num++;
			shot = true;
//			IPrintLnBold( "trace passed for a clump dude- Firing?" );
			curr_time = GetTime();
			thisguy_maxtime = curr_time + 1500;
			thisguy_mintime = curr_time +500;
			
			
		//	self thread draw_line_from_ent_to_ent_until_notify( self, guy, 1, 1, 1, self, "hehaw" );
			self thread animscripts\hummer_turret\common::set_manual_target(guy,3,5);//,"streets_stop_fire");

			
			
			while( curr_time < thisguy_mintime || ( IsDefined(guy) && IsAlive(guy) &&  curr_time < end_time && curr_time < thisguy_maxtime) )
    		{
    			wait 0.05;
				curr_time = GetTime();
    		}
//			self ClearTargetEntity();
    		
			//level.end_tank_minigun notify( "streets_stop_fire" );
		//	self notify( "hehaw" );
			
		}
		else
		{
			wait 0.05; // at least wait for next tick before tracing again.
			/*
			IPrintLnBold( "trace FAILEDfor a clump dude!" );
			/#
			thread draw_debug_sphere( guy , guy.origin,128, (1,0,0) );
//			#/
		*/
		}
	}
//	IPrintLnBold( "turret off: shot:" + num );
	self SetMode( "manual" );

	return shot;	
	
}

show_streets_target()
{
	self endon ( "death" );
	while( true )
	{
		target = self GetTurretTarget( false );
			

		if ( IsDefined( target ) )
		{
			if( IsAI( target ) )
				Line( self.origin , target.origin, (0,1,0) );
			else
				Line( self.origin , target.origin, (1,1,1) );
		}
		wait 0.05;
	}
}


check_shell( shell_vols, clump ) 
{
	self endon( "death" );
	level endon( "launch_jav_barrage" );
	
	check_far = get_outside_range( self.origin, clump, 512 );
	player_far = [];
	if( check_far.size > 0 )
		player_far = get_outside_range(level.player.origin, check_far, 256);
	
	if( player_far.size > 0 )
	{
		foreach( vol in shell_vols )
		{
			if( player_far[0] IsTouching( vol ) )
			{
				target = vol GetCentroid();
				
				// make sure the player and tank are far enough away from the center of this volume too.
				if( LengthSquared( level.player.origin - target ) > 65536 && LengthSquared( self.origin - target ) > 262144 )
				{
					
				    self SetTurretTargetVec( target );
	    			self waittill( "turret_on_target" );
	    			self delayCall( 1, ::FireWeapon );
	    			self delayThread( 2, ::streets_turret_forward );
					return true;
				}
			}
		}
	}
	return false;
}

start_tank_smart_targets()
{
	self tank_smart_targets();
	//the hummer turret code has a wait in set manual target, and you can get an SRE if it gets destroyed whilst waiting.
	if( IsDefined( level.end_tank_minigun ) && IsAlive( level.end_tank_minigun ) )
		level.end_tank_minigun notify( "turret_cleanup" );
		
}

tank_smart_targets()
{
	self endon( "death" );
	level endon( "launch_jav_barrage" );

//	level.end_tank_minigun thread show_streets_target();
	self.script_turret = 1;
	self  notify( "stop_persistent_turret_forward");
		
	shell_vols = GetEntArray( "sjp_axis_turret_target", "targetname" );
	last_shell = 0;
	last_mini = 0;
	
	if( shell_vols.size == 0 )
	{
		last_shell = GetTime() + 999999;
	}
	
	while(1)
	{
		if( level.player isADS() || level.streets_player_outside == 0 )
		{
			axis = GetAIArray( "axis" );
			target = [];
			if(	level.streets_player_outside )
				target = get_closest_to_player_view( axis, level.player, true, 0.94 );
			else
			{
//				level.end_tank_minigun SetMode( "sentry" );
				wait 2;
//				level.end_tank_minigun SetMode( "sentry_offline" );
			}
			if( IsDefined( target ) && target.size > 0 )
			{
				time = GetTime();

				//See if there is a clump of dudes around here.
				clump = get_within_range( target.origin, axis, 150 );
				
				if( time > last_shell && shell_vols.size >0 )
				{
					if( self check_shell( shell_vols,clump ) )
						last_shell = time + 8000;
					else
					{
						last_shell = time + 500;
						
					}
				}
				
				if( clump.size >=2 )
				{
					if( time > last_mini )
					{
						//Worthwhile trying to nail them- no threading.
						if( level.end_tank_minigun kill_array_dudes( clump ) )
						{
							 last_mini = GetTime() + 1000;
							
						}
					}
				}
			}
			wait 0.1;
		}
		wait 0.1;
		
	}
	
//	while(1)
//	{
//		vehicles = GetEntArray( "destructible_vehicle", "targetname" );
//		base_vehicles = get_within_range(level.player.origin, vehicles, 3500);
//		ok_targs = get_outside_range(level.player.origin, base_vehicles, 500);
//			
//		targ_index = get_closest_index_to_player_view(ok_targs);
//		if(IsDefined (targ_index) )
//		{
//			
//			targ = ok_targs[targ_index];
//			target = targ GetCentroid();
//		    level.end_tank SetTurretTargetVec( target );
//    		level.end_tank waittill( "turret_on_target" );
//			level.end_tank FireWeapon();
//			wait 5;
//		}
//		
//
//		
//		wait 1;
//	}
	
}

handle_heli_jav()
{
	//wait 1;
	
	// osprey / heli interactoins.
	heli = spawn_vehicle_from_targetname_and_drive( "end_streets_jav_heli" );
	heli godon();
	fire = getstruct( "fire_zippy_node", "script_noteworthy" );
	
	fire waittill( "trigger" );
	for( i = 0; i < 4; i++ )
	{
		offset_salvo = 0.15;
		heli thread maps\_helicopter_globals::fire_missile( "mi28_zippy", 1, level.end_tank);
		wait ( offset_salvo );
	}
}
send_to_active_vol( spawned )
{
	goalvolume = getEnt( level.active_combat_vol , "targetname" );
	goalvolumetarget = getNode( goalvolume.target , "targetname" );
	foreach( guy in spawned )
	{
		if( IsDefined( guy ) && IsAlive( guy ))
		{
			guy SetGoalNode( goalvolumetarget );
			guy SetGoalVolume( goalvolume );		
		}
	}
}

handle_enemy_tank_advance()
{
	level endon( "launch_jav_barrage" );
	wait_num = 1;
	
	base_flag = "et_";
	base_vol = "fight_et_";
	level.active_combat_vol = base_vol + wait_num;
	curr_flag_wait = base_flag + wait_num;
	
	while( 1 )
	{
		flag_wait( curr_flag_wait );
		wait_num++;
		old_vol = level.active_combat_vol;
		level.active_combat_vol = base_vol + wait_num ;
//		IPrintLnBold( "Active Vol:"+ level.active_combat_vol );

		// SJP commmented out whilst trying a purely tank based retreat.
		//	retreat_from_vol_to_vol( old_vol, level.active_combat_vol, false );

		if( wait_num >= 4 )
			break;

		
		curr_flag_wait = base_flag + wait_num;
		
	}
//	IPrintLnBold( "QUIT FUNC: Vol:"+ level.active_combat_vol );
	
}
handle_tank_down_street()
{
	//Handle moving from the animation end point to Tankstop 2
	enemy_check_time = 0;
	level endon( "launch_jav_barrage" );
	level.end_tank endon( "death" );
	retreat_test_vol = GetEnt( "retreat_test_tank", "targetname" );
	
	level.end_tank Vehicle_SetSpeed( 5,15,15 );
	
	wait 1.5; // give anybody in front of the tank a second or two to hustle before it mows them down.

	node = GetVehicleNode( "street_tank_follow_player", "targetname" );
	
	level.end_tank StartPath( node );
	level.end_tank thread vehicle_paths( node );
	level.end_tank Vehicle_SetSpeed( 0,15,15 );
	
	
	startp = (-6400, 18272, -96);//getstruct( "street_startp", "targetname" ).origin;
	endp = (-4416, 20256, -96);//getstruct( "street_endp", "targetname" ).origin;
	tank_moving = false;
	while(1)
	{
		//tank pos.
		totank = PointOnSegmentNearestToPoint(startp,endp, level.end_tank.origin);

		
		toplayer = PointOnSegmentNearestToPoint(startp,endp, level.player.origin);
		
		diff = toplayer - totank;
		len = Length( diff );
//		
//		IPrintLn(len + " v:" + diff);
		p_ahead = true;
		if(diff[0] < 0 )
			p_ahead = false;
		if( tank_moving )
		{
			if(!p_ahead )
			{
				level.end_tank Vehicle_SetSpeed( 0,15,15 );
				tank_moving = false;
			}
			else
			{
				speed = len / 20;
				speed = clamp(speed,1,5);
				level.end_tank Vehicle_SetSpeed( speed );
				
			}
		}
		else
		{
			if( p_ahead && len > 100)
			{
				level.end_tank Vehicle_SetSpeed( 5,15,15 );
				tank_moving = true;
			}
		
			wait 0.25;
		}
		// See if enemies should be retreating out of range of the tank.
		if( GetTime() > enemy_check_time )
		{
			enemy_check_time =  GetTime() + 0.5;
			axis = retreat_test_vol get_ai_touching_volume(  "axis" );
			retreat_to_vol = GetEnt( level.active_combat_vol, "targetname" );
			retreat_to_node = getNode( retreat_to_vol.target , "targetname" );
			
			foreach( guy in axis )
			{
				curr_vol = guy GetGoalVolume();
				if( !IsDefined(curr_vol) || curr_vol != retreat_to_vol )
				{
					toguy = PointOnSegmentNearestToPoint(startp,endp, guy.origin);
					diff = toguy - totank;
					len2 = LengthSquared( diff );
					if(diff[0] < 0 || len2 < 65536 )
					{
						guy disable_ai_color();
						guy.fixednode = 0;
						
						guy SetGoalNode( retreat_to_node );
						guy SetGoalVolume( retreat_to_vol );
						//IPrintLnBold( "retreating guy");
						//thread draw_debug_line(guy.origin,guy.origin+ (0,0,128), 3);
					}
				}
			}
		}
		wait 0.1;
	}
}		

hamburg_end_badplace()
{
	if ( !IsDefined( self.script_badplace ) )
		return;
	self endon( "kill_badplace_forever" );
	if ( !self Vehicle_IsPhysVeh() )
		self endon( "death" );
	self endon( "delete" );
	for ( ;; )
	{
		if ( !IsDefined( self ) )
			return;
		if ( !IsDefined( self.script_badplace ) || !self.script_badplace )
		{
// 			BadPlace_Delete( "tankbadplace" );
			while ( IsDefined( self ) && ( !IsDefined( self.script_badplace ) || !self.script_badplace ) )
				wait 0.5;
			if ( !IsDefined( self ) )
				return;
		}
		speed = self Vehicle_GetSpeed();
		if ( speed <= 0 )
		{
			wait 0.2;
			continue;
		}

 		org = -85;
 		toadd = 170;
 		loop = 3;
 		radius = 110;
 		duration = 0.25;
 		height = 300;
 		for(i = 0;i< loop;i++ )
 		{
			cylinder_org = tag_project( "tag_origin", org);
			// have to use unique names for each bad place. if not they will be shared for all vehicles and thats not good. - R
			BadPlace_Cylinder( self.unique_id + "cyl", duration, cylinder_org, radius, height, "axis", "allies" );
			org += toadd;
 		}

		wait duration + 0.05;
	}
}

tank_kill_touching()
{
	self notify( "kill_touching" );
	self endon( "kill_touching" );
	self endon( "death" );
	while(1)
	{
		axis = GetAIArray( "axis" );
		check_near = get_within_range( self.origin, axis, 190 );
		foreach( guy in check_near )
		{
			if( self IsTouching( guy ) )
			{
				guy Kill( guy.origin,self);
			}
		}
		wait 0.05;
	}
}