#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\jake_tools;
#using_animtree( "generic_human" );

main()
{
	setsaveddvar( "sm_sunSampleSizeNear", 2 );
	setsaveddvar( "r_specularcolorscale", "1.5" );
	if ( getdvar( "ragdoll_deaths" ) == "" )
		setdvar( "ragdoll_deaths", "1" );
	if ( getdvar( "debug_airlift" ) == "" )
		setdvar( "debug_airlift", "0" );
	
	initPrecache();
	/*-----------------------
	LEVEL VARIABLES
	-------------------------*/	
	level.zpuBlastRadius = 384;
	level.section = undefined;
	level.onMark19 = false;
	level.physicsSphereRadius = 300;
	level.physicsSphereForce = 1.5;
	level.cobraHealth = [];
	level.cobraHealth["easy"] = 9000;
	level.cobraHealth["medium"] = 6000;
	level.cobraHealth["hard"] = 3000;
	level.cobraHealth["insane"] = 1500;
	
	level.CannonRange = 5000;
	level.CannonRangeSquared = level.CannonRange * level.CannonRange;
	level.AIdeleteDistance = 1024;
	level.hitsToDestroyT72 = 4;
	level.hitsToDestroyBMP = 2;
	level.cobraTargetExcluders = [];
	level.cosine = [];
	level.cosine[ "15" ] = cos( 15 );
	level.cosine[ "20" ] = cos( 20 );
	level.cosine[ "25" ] = cos( 25 );
	level.cosine[ "35" ] = cos( 35 );
	level.cosine[ "40" ] = cos( 40 );
	level.cosine[ "55" ] = cos( 55 );
	level.vehicles_axis = [];
	level.vehicles_allies = [];
	level.AIdeleteDistance = 512;
	level.spawnerCallbackThread = ::AI_think;
	level.droneCallbackThread = ::AI_drone_think;
	level.aColornodeTriggers = [];
	trigs = getentarray( "trigger_multiple", "classname" );
	for ( i = 0;i < trigs.size;i ++ )
	{
		if ( ( isdefined( trigs[ i ].script_noteworthy ) ) && ( getsubstr( trigs[ i ].script_noteworthy, 0, 10 ) == "colornodes" ) )
			level.aColornodeTriggers = array_add( level.aColornodeTriggers, trigs[ i ] );
	}
	/*-----------------------
	STARTS
	-------------------------*/
	add_start( "debug", ::start_debug );	
	//add_start( "plazafly", ::start_plazafly );
	//add_start( "plaza", ::start_plaza );
	add_start( "smoketown", ::start_smoketown );
	add_start( "cobrastreets", ::start_cobrastreets );
	//add_start( "nuke", ::start_nuke );
	
	default_start( ::start_default );
	
	/*-----------------------
	GLOBAL SCRIPTS
	-------------------------*/
	initDifficulty();
	level.mortar_min_dist = 5000;
	level.noMaxMortarDist = true;
	maps\createart\airlift_art::main();
	level thread maps\airlift_fx::main();
	maps\_drone::init(); 
	maps\_zpu_antiair::main( "vehicle_zpu4" );
	maps\_seaknight::main( "vehicle_ch46e" );
	maps\_seaknight_airlift::main( "vehicle_ch46e_opened_door" );
	maps\_m1a1::main( "vehicle_m1a1_abrams" );
	maps\_mig29::main( "vehicle_mig29_desert" );
	maps\_bmp::main( "vehicle_bmp" );
	maps\_t72::main( "vehicle_t72_tank" );
	maps\_cobra::main( "vehicle_cobra_helicopter_low" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed" );
	maps\airlift_anim::main();
	maps\_load::main();
	//maps\_compass::setupMiniMap( "compass_map_airlift" );
	level thread maps\airlift_amb::main();	
	thread maps\_mortar::bog_style_mortar();

	/*-----------------------
	FLAGS
	-------------------------*/	
	//intro ride
	flag_init( "seaknight_set_up" );
	flag_init( "cobra_shoots_at_bridge" );
	
	//plaza
	flag_init( "plaza_deploy" );
	flag_init( "start_tank_crush" );
	flag_init( "car_getting_crushed" );
	
	//smoketown
	flag_init( "delete_orange_smoke" );
	
	//cobrastreets
	flag_init( "pilot_taken_from_cockpit" );
	flag_init( "player_putting_down_pilot" );
	flag_init( "pilot_put_down_in_seaknight" );
	
	//objectives
	flag_init( "obj_plaza_clear_given" );
	flag_init( "obj_plaza_clear_complete" );
	flag_init( "obj_plaza_building_given" );
	flag_init( "obj_plaza_building_complete" );
	flag_init( "obj_extract_team_given" );
	flag_init( "obj_extract_team_complete" );
	flag_init( "obj_safe_distance_given" );
	flag_init( "obj_safe_distance_complete" );
	flag_init( "obj_rescue_pilot_given" );
	flag_init( "obj_rescue_pilot_complete" );

	/*-----------------------
	SPAWNER THREADS
	-------------------------*/	
	array_thread( getentarray( "hostiles_bmp_bridge", "script_noteworthy" ), ::add_spawn_function, ::AI_hostiles_bmp_bridge );
	
	/*-----------------------
	GLOBAL THREADS
	-------------------------*/	
	//only use a small fx for T72 since it will be covered by giant rocket explosion :)
	maps\_vehicle::build_deathfx_override( "t72", ( "explosions/grenade_flash" ), "tag_origin", "exp_armor_vehicle" );

	disable_color_trigs();
	hideAll();
	thread exploder_statue();
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	array_thread( getvehiclenodearray( "plane_bomb", "script_noteworthy" ), maps\_mig29::plane_bomb_node );
	aFlight_flag_origins = getentarray( "flightFlag", "script_noteworthy" );
	array_thread( aFlight_flag_origins,::flight_flags_think );
	aExploder_trigs_mark19 = getentarray( "exploder_trigs_mark19", "targetname" );
	array_thread( aExploder_trigs_mark19,::exploder_trigs_mark19_think );
	array_thread( level.vehicle_spawners,::vehicle_think );

	/*-----------------------
	DEBUG
	-------------------------*/	
	flag_wait( "player_exit_seaknight_smoketown" );
	iprintlnbold( "end of current level progress" );
}

/****************************************************************************
    START FUNCTIONS
****************************************************************************/ 
start_default()
{
	AA_intro_init();
	//start_plazafly();
	//start_plaza();
	//start_smoketown();
	//start_cobrastreets();
	//start_nuke();
}

start_debug()
{
	AA_intro_init();
}

start_plazafly()
{
	thread seaknight_player_think( "plazafly" );
	thread AA_plaza_init();
}

start_plaza()
{
	thread seaknight_player_think( "plaza" );
	flag_set( "seaknightInPlazaFly" );
	thread AA_plaza_init();
}


start_cobrastreets()
{
	thread seaknight_player_think( "cobrastreets" );
	thread AA_cobrastreets_init();
}

start_smoketown()
{
	thread seaknight_player_think( "smoketown" );
	thread AA_smoketown_init();
}


/****************************************************************************
    FLIGHT INTO CITY
****************************************************************************/ 

AA_intro_init()
{
	level.section = "intro_to_plaza";
	thread music();
	thread seaknight_player_think( "default" );
	flag_wait( "seaknight_set_up" );
	thread cobra_wingman_think();
	thread intro_flyover();
	
	flag_wait( "seaknightInPlazaFly" );
	thread AA_plaza_init();
}



music()
{
	musicPlay( "airlift_start_music" );
	flag_wait( "plaza_deploy" );
	musicStop(1);
	musicPlay( "airlift_deploy_music" );

}


intro_flyover()
{

	/*-----------------------
	ABRAMS GO INTO DISTANCE
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 1 );

	/*-----------------------
	COBRA WINGMAN
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 4 );	

	/*-----------------------
	COBRA WINGMEN
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 7 );	
	
	/*-----------------------
	MORTARS ON
	-------------------------*/	
	delaythread (3, maps\_mortar::bog_style_mortar_on, 0 );	

	/*-----------------------
	SEAKNIGHT WINGMAN
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 3 );	
	
	/*-----------------------
	ENEMY TANKS ON BRIDGE
	-------------------------*/	
	delaythread (3, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 5 );	

	/*-----------------------
	BMPS APPROACHING BRIDGE
	-------------------------*/	
	delaythread (15, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 6 );	
	
	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	delaythread (18, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 2 );	
	delaythread (10, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 10 );	
	delaythread (5, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 19 );	
	delaythread (5.5, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 20 );	
	delaythread (5.3, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 21 );	
	delaythread (6, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 22 );	
	delaythread (6.2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 23 );


	wait(6);

	/*-----------------------
	DRONES NEAR BRIDGE SIDE
	-------------------------*/	
	triggerActivate( "trig_spawn_drones_bridge_side" );
	wait(10);

	/*-----------------------
	PALM GROVE COBRAS
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 16 );

	/*-----------------------
	FIRST ZPU
	-------------------------*/		
	triggerActivate( "trig_spawn_zpu_start" );
	
	wait(3);
	/*-----------------------
	COBRA SHOOTS AT BRIDGE
	-------------------------*/	
	flag_set( "cobra_shoots_at_bridge" );

	/*-----------------------
	MORTARS OFF
	-------------------------*/		
	thread maps\_mortar::bog_style_mortar_off( 0 );

	
	/*-----------------------
	BRIDGE DRONES
	-------------------------*/		
	flag_wait( "seaknightBridgeEnd" );	
	triggerActivate( "trig_spawn_drones_bridge" );
	
	/*-----------------------
	DELETE BRIDGE AI WHEN OUT OF SIGHT
	-------------------------*/		
	flag_wait( "seaknightInPlazaFly" );		
	aAI_to_delete = getentarray( "hostiles_bmp_bridge", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );
}



AI_hostiles_bmp_bridge()
{
	self endon( "death" );
	self set_goalvolume( "volume_bridge_01" );
	flag_wait( "seaknightInPlazaFly" );
	self set_goalvolume( "volume_retreat_bridge" );
	flag_wait( "seaknightInPlaza" );
	self delete();

}
seaknight_wingman_think()
{
	level.ch46Wingman = maps\_vehicle::waittill_vehiclespawn( "seaknight_wingman" );

}

cobra_wingman_think()
{
	level.cobraWingman = maps\_vehicle::waittill_vehiclespawn( "wingman" );
	
	wait(2);
	level.cobraWingman notify( "stop_default_behavior" );
	flag_wait( "cobra_shoots_at_bridge" );
	
	/*-----------------------
	COBRA FIRES AT BRIDGE ARMOR
	-------------------------*/		

	wait (1);
	eTarget = getent( "cobra_bridge_tank1", "targetname" );
	assert(isdefined(eTarget));
	level.cobraWingman maps\_helicopter_globals::fire_missile( "ffar_airlift", 2, eTarget);
	wait(1.5);

	eTarget = getent( "cobra_bridge_tank2", "targetname" );
	assert(isdefined(eTarget));
	level.cobraWingman maps\_helicopter_globals::fire_missile( "ffar_airlift", 2, eTarget);
	wait ( 2 );
	level.cobraWingman thread vehicle_cobra_default_weapons_think();

}

cobra_wingman2_think()
{
	level.cobraWingman2 = maps\_vehicle::waittill_vehiclespawn( "wingman2" );
	
	flag_wait( "cobra_shoots_at_bridge" );
	/*-----------------------
	COBRA FIRES AT BRIDGE ARMOR
	-------------------------*/		
	//level.cobraWingman2 thread maps\_vehicle::mgon();


}



/****************************************************************************
    PLAZA SECTION
****************************************************************************/ 
AA_plaza_init()
{
	flag_wait( "seaknight_set_up" );
	thread plaza_flyover();
	thread cobra_plaza_chase();
	thread tank_crush_plaza();

}

plaza_flyover()
{
	flag_wait( "seaknightInPlazaFly" );
	/*-----------------------
	ROOFTOP DUDES
	-------------------------*/	
	wait(1);
	triggerActivate( "trig_spawn_plaza_roof_01" );

	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	delaythread (.6, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 25 );	
	delaythread (.2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 26 );	
	delaythread (.6, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 27 );	
	delaythread (1, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 28 );	
	delaythread (1.2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 29 );	
		
	
	/*-----------------------
	STREET ARMOR AND ZPU IN PLAZA
	-------------------------*/	
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 14 );
	triggerActivate( "trig_spawn_zpu_plaza" );
	if ( getdvar( "debug_airlift" ) == "1" )
		iprintlnbold( "plaza armor" );	
	wait(2);
	/*-----------------------
	PALACE DUDES
	-------------------------*/	
	triggerActivate( "trig_spawn_plaza_main" );
	triggerActivate( "trig_spawn_drones_palace_01" );
	
	if ( getdvar( "debug_airlift" ) == "1" )
		iprintlnbold( "palace dudes" );			
	/*-----------------------
	STREET ARMOR IN STREET
	-------------------------*/	
	delaythread (2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 15 );	
	if ( getdvar( "debug_airlift" ) == "1" )
		iprintlnbold( "street armor" );	
	/*-----------------------
	ENEMY TRUCK GUYS
	-------------------------*/	
	flag_wait( "seaknightInPlazaConstruction" );
	delaythread (2, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 17 );	
	if ( getdvar( "debug_airlift" ) == "1" )
		iprintlnbold( "truck dudes" );	
	/*-----------------------
	DELETE ALL REMAINING ROOF 01 DUDES
	-------------------------*/
	aAI_to_delete = getentarray( "hostiles_roof_fodder", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );
	
	
	
	/*-----------------------
	STREET DUDES AND OTHER BMPS NEAR GAS
	-------------------------*/	
	flag_wait( "seaknightInPlazaStreetEnd" );
	
	//delete remaining AI near statue
	aAI_to_delete = getentarray( "hostiles_plaza_fodder_palace", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 512 );
	
	delaythread (2.5, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 18 );	
	wait(4);
	triggerActivate( "trig_spawn_plaza_alley_01" );
	if ( getdvar( "debug_airlift" ) == "1" )
		iprintlnbold( "alley dudes" );		
	
	wait(11);
	/*-----------------------
	CONSTRUCTION SITE
	-------------------------*/
	triggerActivate( "trig_spawn_drones_plaza_street_retreat" );
	
	/*-----------------------
	PLAYER SEAKNIGHT LANDS IN PLAZA
	-------------------------*/
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_plaza", "script_noteworthy" ) );

	/*-----------------------
	DELETE ALL REMAINING ENEMIES
	-------------------------*/
	flag_wait( "seaknightInPlaza" );
	aAI_to_delete = getentarray( "hostiles_plaza_fodder", "script_noteworthy" );
	thread AI_delete_when_out_of_sight( aAI_to_delete, 1024 );


	/*-----------------------
	COBRA KILLS ANY REMAINING VISIBLE TARGETS
	-------------------------*/	
	aRemainingTargets = getentarray( "targets_plaza_end", "script_noteworthy" );
	if ( aRemainingTargets.size > 0 )
		delaythread (12, ::vehicle_cobra_spawn_and_kill, "cobra_plaza_end", aRemainingTargets, 1 );	

	/*-----------------------
	WINGMAN SEAKNIGHT LANDS IN PLAZA
	-------------------------*/	
	eNode = getent( "seaknight_plaza_alt_landing", "targetname" );
	assert( isdefined( eNode ) );
	aFriendliesSeaknightWingman = spawnGroup( getentarray( "allies_seaknight_wingman", "targetname" ), true );
	array_thread( aFriendliesSeaknightWingman, ::friendlies_plaza_seaknights );
	delaythread (0, ::vehicle_animated_seaknight_land, eNode, undefined, aFriendliesSeaknightWingman );	
	
	/*-----------------------
	OTHER SEAKNIGHT LANDS IN PLAZA
	-------------------------*/	
	eNode = getent( "seaknight_plaza_alt_landing2", "targetname" );
	assert( isdefined( eNode ) );
	aFriendliesSeaknightOther = spawnGroup( getentarray( "allies_seaknight_plaza_ch46_2", "targetname" ), true );
	array_thread( aFriendliesSeaknightOther, ::friendlies_plaza_seaknights );
	delaythread (1, ::vehicle_animated_seaknight_land, eNode, undefined, aFriendliesSeaknightOther );	
	
	level.seaknight waittill( "landed" );
	flag_set( "plaza_deploy" );
	thread seaknight_door_open_sound();
	flag_set( "start_tank_crush" );
	/*-----------------------
	MARINES TAKE UP POSITIONS 
	-------------------------*/
	wait(10);
	triggersEnable("colornodes_plaza", "script_noteworthy", true);
	trig_colornode = getent( "colornodes_plaza", "script_noteworthy" );
	trig_colornode notify( "trigger", level.player );
	
	triggerActivate( "trig_spawn_hostiles_palace_assault" );
	/*-----------------------
	SEAKNIGHT LIFTOFF
	-------------------------*/	
	wait(2);
	level.seaknight cleargoalyaw();
	level.seaknight vehicle_liftoff();
	level.seaknight vehicle_resumepath();
	
	thread AA_smoketown_init();
	
	
}



cobra_plaza_chase()
{
	/*-----------------------
	COBRA CHASES DOWN ALLEY
	-------------------------*/		
	flag_wait( "seaknightInPlaza" );
	delaythread (0, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 30 );	

	/*-----------------------
	DELETE REMAINING ENEMY AI
	-------------------------*/			
	flag_wait( "seaknightPlazaLanding" );
	aAI_to_delete = getaiarray("axis");
	thread AI_delete_when_out_of_sight( aAI_to_delete, 256 );
	
}



vehicle_cobra_spawn_and_kill( sCobraTargetname, aTargets, fKillDelay )
{
	eCobra = spawn_vehicle_from_targetname( sCobraTargetname );
	thread maps\_vehicle::gopath( eCobra );
	assert( isdefined( eCobra ) );
	
	if ( isdefined( fKillDelay ) )
		wait( fKillDelay );
	
	if ( aTargets.size > 0 )
	{
		eCobra notify( "stop_default_behavior" );
		eCobra thread vehicle_mg_on();
		
		if ( aTargets.size > 1 )
			aTargets = get_array_of_closest( eCobra.origin , aTargets , undefined , aTargets.size );
		for(i=0;i<aTargets.size;i++)
		{
			if ( ( !isdefined( aTargets[i] ) ) || ( !isalive( aTargets[i] ) ) )
				continue;
			
			eCobra maps\_helicopter_globals::fire_missile( "ffar_airlift", 2, aTargets[i]);
			wait(.3);
		}
	}
	else
		iprintln( sCobraTargetname + " doesn't have any targets to shoot." );
}





vehicle_intro_to_plaza_think()
{
	flag_wait( "seaknightInPlaza" );
}



friendlies_plaza_seaknights()
{
	self endon( "death" );
	self waittill ( "unloaded" );
	wait ( randomfloatrange( 2, 3) );
	self notify( "stop_ch46_idle" );
}

tank_crush_plaza()
{
	flag_wait( "start_tank_crush" );
	/*-----------------------
	SPAWN TANK CRUSHER
	-------------------------*/	
	level.tankCrusher = spawn_vehicle_from_targetname( "tank_crusher" );
	thread maps\_vehicle::gopath( level.tankCrusher );
	level.tankCrusher thread maps\_vehicle::mgon();
	/*-----------------------
	COLUMN OF ABRAMS GO PAST
	-------------------------*/	
	delaythread (3, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 11 );
	delaythread (5.1, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 12 );
	delaythread (6.9, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 13 );

	/*-----------------------
	ALLIES ASSAULT MAIN BUILDING
	-------------------------*/		
	delaythread (0, ::plaza_building_assault );


	/*-----------------------
	TANK CRUSHES CAR
	-------------------------*/		
	node = getVehicleNode( "sedan_crush_node", "script_noteworthy" );
	assert( isdefined( node ) );
	node waittill( "trigger" );
	flag_set( "car_getting_crushed" );
	level.tankCrusher thread maps\_vehicle::mgoff();
	level.tankCrusher setSpeed( 0, 999999999, 999999999 );
	eSedan = getent( "crunch_sedan", "targetname" );
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	
	level.tankCrusher maps\_vehicle::tank_crush( eSedan,
											tank_path_2,
											level.scr_anim[ "tank" ][ "tank_crush" ],
											level.scr_anim[ "sedan" ][ "tank_crush" ],
											level.scr_animtree[ "tank_crush" ],
											level.scr_sound[ "tank_crush" ] );
	level.tankCrusher resumeSpeed( 999999999 );
}

plaza_building_assault()
{
	/*-----------------------
	YOUR CHALK DISEMBARKS AND TAKES UP POSITIONS
	-------------------------*/
	triggerActivate( "trig_spawn_allies_plaza_chalk" );
	thread plaza_AT4_sequence();
	
	/*-----------------------
	ALLIED DRONES FOLLOW TANK COLUMN
	-------------------------*/
	triggerActivate( "trig_spawn_drones_plaza_allies" );
	
}

plaza_AT4_sequence()
{
	eTarget = getent( "org_rpg_plaza_01", "targetname" );
	eAt4_dude = spawnDude( getent( "plaza_at4_dude", "script_noteworthy" ), true );
	node = getnode( "node_at4_guy", "targetname" );
	assert( isdefined( node ));
	createthreatbiasgroup( "ignored" );
	eAt4_dude set_threatbiasgroup( "ignored" );
	eAt4_dude.ignoreme = true;
	setignoremegroup( "ignored", "axis" );
	setignoremegroup( "axis", "ignored" );
	
	node anim_reach_solo (eAt4_dude, "AT4_fire_start");
	eAt4_dude attach("weapon_AT4", "TAG_INHAND");
	node thread anim_single_solo( eAt4_dude, "AT4_fire" );
	eAt4_dude waittillmatch ( "single anim", "fire" );
	org = eAt4_dude gettagorigin( "TAG_INHAND" );
	magicbullet( "rpg_player", org, eTarget.origin );	
	thread plaza_at4_impact();
	eAt4_dude waittillmatch ( "single anim", "end" );
	org_hand = eAt4_dude gettagorigin("TAG_INHAND");
	angles_hand = eAt4_dude gettagangles("TAG_INHAND");
	eAt4_dude detach("weapon_AT4", "TAG_INHAND");
	model_at4 = spawn("script_model", org_hand);
	model_at4 setmodel( "weapon_at4" );
	model_at4.angles = angles_hand;		
	node thread anim_loop_solo ( eAt4_dude, "AT4_idle", undefined, "stop_idle" );
	
	wait (1);
	node notify ( "stop_idle" );
	eNode = getnode( "node_at4_guy_next", "targetname" );
	assert( isdefined( eNode ) );
	eAt4_dude setgoalnode( eNode );
	eAt4_dude notify( "stop magic bullet shield" );
	
	flag_wait( "seaknightLeavePlaza" );
	
	if ( isdefined( eAt4_dude ) )
	{
		eAt4_dude delete();
		model_at4 delete();
	}
}

plaza_at4_impact()
{
	wait(2);
	org_rpg_plaza_01 = getent( "org_rpg_plaza_01", "targetname" );
	thread play_sound_in_space( "building_explosion3", org_rpg_plaza_01.origin );
	playfx( getfx( "palace_at4" ), org_rpg_plaza_01.origin );
	
}

/****************************************************************************
    SMOKETOWN
****************************************************************************/ 
AA_smoketown_init()
{
	flag_wait( "seaknight_set_up" );
	thread smoketown_flyover();
	thread smoketown_land();
	thread orange_smoke();
}

orange_smoke()
{
	org_orange_smoke = getent( "org_orange_smoke", "targetname" );
	playfx( getfx( "smoke_blue_signal" ), org_orange_smoke.origin );
	flag_wait( "delete_orange_smoke" );
	org_orange_smoke delete();
}


smoketown_flyover()
{
	flag_wait( "seaknightLeavePlaza" );
	
	/*-----------------------
	PLANES FLY IN DISTANCE
	-------------------------*/	
	delaythread (10, maps\_vehicle::create_vehicle_from_spawngroup_and_gopath, 24 );	
	wait(5);
	/*-----------------------
	DELETE ALL AI LEFT BEHIND
	-------------------------*/
	aAI_to_delete = getaiarray();
	thread AI_delete_when_out_of_sight( aAI_to_delete, level.AIdeleteDistance );
}

smoketown_land()
{

	
	flag_wait( "seaknightLandingInSmoketown" );
	/*-----------------------
	SEAKNIGHT LANDS IN SMOKETOWN
	-------------------------*/
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_smoketown", "script_noteworthy" ) );
	
	/*-----------------------
	FRIENDLIES SPAWNED TO UNLOAD
	-------------------------*/
	aFriendliesSeaknight = spawnGroup( getentarray( "seaknight_unloaders_smoketown", "targetname" ), true );
	level.crewchief = spawnDude( getent( "seaknight_crewchief_smoketown", "targetname" ), true );
	level.seaknight thread vehicle_seaknight_unload( aFriendliesSeaknight, level.crewchief );
	level.seaknight waittill( "landed" );


		
	/*-----------------------
	UNLINK PLAYER AND UNLOAD HIDDEN AI
	-------------------------*/	
	wait( 1 );
	level.seaknight notify ( "unload_ai" );
	thread seaknight_player_dismount_gun();
	
	level.seaknight waittill ( "all_ai_unloaded" );
	flag_wait( "player_exit_seaknight_smoketown" );
	wait( 2 );
	

	
	//trig_colornode = getent( "colornodes_smoketown_start", "targetname" );
	//trig_colornode notify( "trigger", level.player );
	//for(i=0;i<aFriendliesSeaknight.size;i++)
		//aFriendliesSeaknight[i] notify( "stop_ch46_idle" );
}


/****************************************************************************
    COBRA STREETS
****************************************************************************/ 
AA_cobrastreets_init()
{
	flag_wait( "seaknight_set_up" );
	thread obj_rescue_pilot();
	thread cobra_streetfight();
}

cobra_streetfight()
{
	flag_set( "obj_rescue_pilot_given" );

	/*-----------------------
	SEAKNIGHT LANDS IN SMOKETOWN
	-------------------------*/
	level.seaknight thread vehicle_heli_land( getent( "seaknight_land_cobrastreets", "script_noteworthy" ) );

	/*-----------------------
	SPAWN PILOT, DEAD PILOT
	-------------------------*/	
	level.crashnode = getent( "node_pilot_crash", "targetname" );
	assert(isdefined(level.crashnode));
	spawner = getent( "friendly_cobrapilot", "script_noteworthy" );
	level.cobrapilot = spawnDude( spawner, "stalingrad" );
	level.cobrapilot thread cobrapilot_think();
	
	spawner = getent( "friendly_deadpilot", "script_noteworthy" );
	level.deadpilot = spawnDude( spawner, "stalingrad" );
	level.deadpilot gun_remove();
	level.crashnode thread anim_loop_solo( level.deadpilot, "deadpilot_idle", undefined, "stop_idle_deadpilot" );

	/*-----------------------
	SPAWN ENEMIES
	-------------------------*/		
	
	
	/*-----------------------
	FRIENDLIES SPAWNED TO UNLOAD
	-------------------------*/
	level.aFriendliesSeaknight = spawnGroup( getentarray( "seaknight_unloaders_cobrastreets", "targetname" ), true );
	level.crewchief = spawnDude( getent( "seaknight_crewchief_cobrastreets", "targetname" ), true );
	level.seaknight thread vehicle_seaknight_unload( level.aFriendliesSeaknight, level.crewchief );
	level.seaknight waittill( "landed" );

	/*-----------------------
	LZ FRIENDLIES WHO PROTECT YOUR ADVANCE
	-------------------------*/
	level.aFriendliesLZ = spawnGroup( getentarray( "friendlies_cobrastreets_lz", "targetname" ), true );
	
	/*-----------------------
	UNLINK PLAYER AND UNLOAD HIDDEN AI
	-------------------------*/	
	wait(2);
	level.seaknight notify ( "unload_ai" );
	thread seaknight_player_dismount_gun();
	
	level.seaknight waittill ( "all_ai_unloaded" );
	

	/*-----------------------
	COLORNODES FOR COBRA APPROACH
	-------------------------*/		
	triggersEnable("colornodes_cobrastreets_start", "script_noteworthy", true);

	flag_wait( "player_exit_seaknight_cobrastreets" );
	array_thread( level.aFriendliesSeaknight, ::ai_notify, "stop_ch46_idle", 5);
	

	
	flag_wait( "pilot_taken_from_cockpit" );
	
	/*-----------------------
	COLORNODES FOR COBRA RETREAT
	-------------------------*/		
	triggersEnable("colornodes_cobrastreets_start", "script_noteworthy", false);
	triggersEnable("colornodes_cobrastreets_end", "script_noteworthy", true);


	/*-----------------------
	SETUP DUMMIES FOR SEAKNIGHT EXIT
	-------------------------*/			
	//4 dudes slam to idle positions outside seaknight and are hidden
	level.aFriendliesLZdummies = spawnGroup( getentarray( "friendlies_cobrastreets_lz_dummies", "targetname" ), true );
	vehicle_seaknight_idle_and_load( level.aFriendliesLZdummies );	
	

	/*-----------------------
	DELETE ALL FRIENDLIES AND SHOW DUMMIES INSTEAD
	-------------------------*/		
	flag_wait( "player_putting_down_pilot" );
	flag_set ( "obj_rescue_pilot_complete" );
	
	//show dudes outside and delete others
	level.seaknight notify ( "show_loaders" );
	
	for(i=0;i<level.aFriendliesLZ.size;i++)
	{
		level.aFriendliesLZ[i] notify( "stop magic bullet shield" );
		level.aFriendliesLZ[i] delete();
	}

	for(i=0;i<level.aFriendliesSeaknight.size;i++)
	{
		level.aFriendliesSeaknight[i] notify( "stop magic bullet shield" );
		level.aFriendliesSeaknight[i] delete();
	}	
	
	//Regular dudes run up ramp and delete themselves
	//eDeleteNode = getnode( "seaknight_ai_delete_cobrastreets", "targetname" );
	//assert(isdefined(eDeleteNode));
	//vehicle_seaknight_fake_load( level.aFriendliesLZ, eDeleteNode );
	
	wait(1);
	level.seaknight notify ( "load" );

	/*-----------------------
	SEAKNIGHT LIFTOFF
	-------------------------*/	
	wait(10);
	level.seaknight cleargoalyaw();
	level.seaknight vehicle_liftoff();
	level.seaknight vehicle_resumepath();
	
	thread AA_nuke_init();
}

vehicle_seaknight_fake_load( aFriendlies, eDeleteNode )
{
	array_thread( aFriendlies, ::vehicle_seaknight_fake_load_think, eDeleteNode );	
	while ( aFriendlies.size > 0 )
	{
		wait(.05);
		aFriendlies = array_removeDead( aFriendlies );
	}
}

vehicle_seaknight_fake_load_think( eDeleteNode )
{
	self disable_ai_color();
	self pushplayer( true );
	self setgoalnode( eDeleteNode );
	self setGoalRadius( eDeleteNode.radius );	
	self waittill ("goal");
	self notify( "stop magic bullet shield" );
	self delete();	
}

cobrapilot_think()
{
	self endon ( "death" );
	self.useable = true;
	//self thread cobrapilot_shoots_enemies();
	
	
	//anim_loop_solo( guy, anime, tag, ender, entity )
	level.crashnode thread anim_loop_solo( self, "wounded_cockpit_shoot", undefined, "stop_idle_pilot" );

	/*-----------------------
	PILOT STOPS SHOOTING AND WAVES AS PLAYER APPROACHES
	-------------------------*/
	flag_wait( "player_near_crash_site" );
	level.crashnode notify ( "stop_idle_pilot" );
	level.crashnode thread anim_loop_solo( self, "wounded_cockpit_wave_over", undefined, "stop_idle_pilot" );

	/*-----------------------
	PLAYER ACTIVATES COCKPIT
	-------------------------*/	
	self sethintstring( &"SCRIPT_PLATFORM_HINT_PILOT_PICKUP" );
	
	self waittill ( "trigger" );
	level.player allowprone( false );
   	level.player allowcrouch( false );
	
	level.cobrapilot.useable = false;
	//flag_wait( "player_activates_cockpit" );

	/*-----------------------
	PLAYER PLAYS PULLOUT ANIM WITH PILOT
	-------------------------*/	
	level.player disableweapons();
	// this is the model the player will attach to for the pullout sequence
	ePlayerview = spawn_anim_model( "player_carry" );
	ePlayerview hide();
	
	// put the ePlayerview in the first frame so the tags are in the right place
	level.crashnode anim_first_frame_solo( ePlayerview, "wounded_pullout" );

	// this smoothly hooks the player up to the animating tag
	ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	level.crashnode thread anim_single_solo( ePlayerview, "wounded_pullout" );
	level.crashnode anim_single_solo( self, "wounded_pullout" );
	
	flag_set( "pilot_taken_from_cockpit" );
	level.player unlink();
	level.cobrapilot hide();
	
	
	/*-----------------------
	WAIT FOR PLAYER TO RE-ENTER SEAKNIGHT
	-------------------------*/	
	trig_pilot_putdown = getent( "trig_pilot_putdown", "targetname" );
	trig_pilot_putdown waittill ( "trigger" );
	
	/*-----------------------
	PLACE PILOT AND PLAYER
	-------------------------*/	
	flag_set( "player_putting_down_pilot" );

	// put the ePlayerview in the first frame so the tags are in the right place
	level.seaknight anim_first_frame_solo( ePlayerview, "wounded_putdown", "tag_detach" );

	// this smoothly hooks the player up to the animating tag
	ePlayerview lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	level.cobrapilot show();
	level.seaknight thread anim_single_solo( ePlayerview, "wounded_putdown", "tag_detach", level.seaknight );
	level.seaknight anim_single_solo( self, "wounded_putdown", "tag_detach", level.seaknight );

	/*-----------------------
	LINK PLAYER TO CURRENT POS TO SEE NUKE
	-------------------------*/		
	level.player enableweapons();
										//<viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	ePlayerview linkto( level.seaknight );
	level.player playerlinktodelta( ePlayerview, "tag_player", 1, 20, 45, 5, 25 );
	level.cobrapilot notify( "stop magic bullet shield" );
	level.cobrapilot delete();	
	
	flag_set( "pilot_put_down_in_seaknight" );
	
}

//cobrapilot_shoots_enemies()
//{
//	self endon( "death" );
//	level endon ( "player_near_crash_site" );
//	eKillVolume = getent( "volume_cobrapilot_killzone", "targetname" );
//	while ( true )
//	{
//		self waittillmatch ( "single anim", "fire" );
//		aEnemies = getAIarrayTouchingVolume( "axis", undefined, eKillVolume );
//		if ( !isdefined( aEnemies )
//			continue;
//		if ( isdefined( aEnemies[0] ) && ( isalive( aEnemies[0] ) )
//			aEnemies[0] thread death_by_velinda();
//		}
//	}
//}
//
//death_by_velinda()
//{
//	self endon( "death" );
//	playfxontag( getfx( "headshot" ), self, "tag_eye");	
//	magicbullet( level.cobrapilot.weapon, level.cobrapilot gettagorigin( "tag_flash" ), self gettagorigin ( "TAG_EYE" ) );	
//	
//}

/****************************************************************************
    COBRA STREETS
****************************************************************************/ 

AA_nuke_init()
{
	
}



obj_plaza_clear()
{
	flag_wait("obj_plaza_clear_given");
	objective_number = 4;
	
	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_PLAZA_CLEAR", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_plaza_clear_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_plaza_building()
{
	flag_wait("obj_plaza_building_given");
	objective_number = 4;
	
	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_PLAZA_BUILDING", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_plaza_building_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_extract_team()
{
	flag_wait("obj_extract_team_given");
	objective_number = 4;
	
	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_EXTRACT_TEAM", obj_position.origin );
	objective_current ( objective_number );
	
	flag_wait ( "obj_extract_team_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_rescue_pilot()
{
	flag_wait("obj_rescue_pilot_given");
	objective_number = 4;

	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	obj_rescue_pilot_putdown = getent( "obj_rescue_pilot_putdown", "targetname" );
	
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_RESCUE_PILOT", obj_position.origin );
	objective_current ( objective_number );

	flag_wait( "pilot_taken_from_cockpit" );
	
	objective_position( objective_number, obj_rescue_pilot_putdown.origin );
	
	flag_wait ( "obj_rescue_pilot_complete" );
	
	objective_state ( objective_number, "done" );	
}

obj_safe_distance()
{
	flag_wait("obj_safe_distance_given");
	objective_number = 4;
	
	obj_position = getent ( "obj_rescue_pilot", "targetname" );
	objective_add( objective_number, "active", &"AIRLIFT_OBJ_SAFE_DISTANCE", obj_position.origin );
	objective_current ( objective_number );

	flag_wait ( "obj_safe_distance_complete" );
	
	objective_state ( objective_number, "done" );	
}


/****************************************************************************
    VEHICLE FUNCTIONS
****************************************************************************/ 
AA_vehicles()
{
	
}


vehicle_delete_thread()
{
	//wait until a certain flag is set, then destroy this vehicle
	self endon( "death" );
	if ( ( isdefined( self.script_noteworthy ) ) && ( getsubstr( self.script_noteworthy, 0, 10 ) == "deleteFlag" ) )
	{
		sFlag = getsubstr( self.script_noteworthy, 11 );
		flag_wait( sFlag );
		
		while ( true )
		{
			wait (0.05);
			playerEye = level.player getEye();
			bInFOV = within_fov( playerEye, level.player getPlayerAngles(), self.origin, level.cosine[ "25" ]);
			if ( !bInFOV )
			{
				self notify ( "death" );	
				break;
			}
			else
				wait ( randomfloatrange(1, 2.2) );
		}
	}
}

vehicle_think()
{
	eVehicle = maps\_vehicle::waittill_vehiclespawn_spawner_id( self.spawner_id );
	if ( ( isdefined( self.script_parameters ) ) && ( self.script_parameters == "playerTarget" ) )
		level.cobraTargetExcluders[ level.cobraTargetExcluders.size ] = eVehicle;
	
	/*-----------------------
	VARIABLE SETUP
	-------------------------*/	
	assertex( isdefined( self.script_team ), "Need to define a script_team for vehicle at " + self.origin);
	if ( self.script_team == "axis" )
		level.vehicles_axis = array_add( level.vehicles_axis, self );
	else if ( self.script_team == "allies" )
		level.vehicles_allies = array_add( level.vehicles_allies, self );
	else
		assertmsg( "vehicle at " + self.origin + " has script_team defined, but it is neither axis or allies ( " + self.script_team + " ? )" );
		
	assertex( isdefined( eVehicle.vehicletype ), "No vehicletype defined for vehicle at " + eVehicle.origin );

	/*-----------------------
	RUN VEHICLE SPECIFIC THREADS
	-------------------------*/	
	//self thread vehicle_damage_think();
	self thread vehicle_death_think();
	self thread vehicle_delete_thread();

	/*-----------------------
	RUN SECTION-SPECIFIC THREADS FOR THIS VEHICLE
	-------------------------*/	
//	if ( !isdefined( level.section ) )
//		return;
//	
//	switch ( level.section )
//	{
//		case "intro_to_plaza":
//			self thread vehicle_intro_to_plaza_think();
//
//	}
//		
	switch ( eVehicle.vehicletype )
    {
    	case "zpu_antiair":
    		eVehicle thread vehicle_zpu_think();
    	case "m1a1":
    		eVehicle thread vehicle_m1a1_think();
    		break;
    	case "bmp":
    		eVehicle thread vehicle_bmp_think();
    		break;
    	case "t72":
    		eVehicle thread vehicle_t72_think();
    		break;
    	case "cobra":
    		eVehicle thread vehicle_cobra_think();
    		break;
     	case "mig29":
    		break; 
     	case "seaknight_airlift":
    		break; 
    }


}

vehicle_death_think()
{
	self waittill( "death" );
	earthquake( 0.5, 2, self.origin, 8000);
}

vehicle_zpu_think()
{
	self endon( "death" );
	assertex( isdefined( self.script_linkTo ), "ZPU needs to script_linkTo at least one script_origin for a default target" );
	self.defaultTargets = getentarray( self.script_linkTo, "script_linkname"  );
	assertex( self.defaultTargets.size > 0, "You need to have this ZPU target at least one script_origin to use as a default target. Origin: " + self.origin );
	self thread vehicle_turret_think();
	self thread vehicle_zpu_death();
}

vehicle_zpu_death()
{
	self waittill ( "damage", damage, attacker, direction_vec, point, type );
	iprintln( "zpu damaged" );
}

vehicle_heli_land( eNode )
{
	self endon( "death" );
	eNode waittill( "trigger", vehicle );
	self notify( "landing" );
	self vehicle_detachfrompath();
	self setgoalyaw( eNode.angles[ 1 ] );
	vehicle_land();
	self notify( "landed" );
}

vehicle_cobra_think()
{
	self endon( "death" );
	self thread vehicle_cobra_default_weapons_think();

	/*-----------------------
	REACHES NEXT-TO-LAST AND LAST NODE IN CHAIN
	-------------------------*/	
	eEndNode = self get_last_ent_in_chain( "ent" );
	bReachedNextToLastNode = false;
	bReachedLastNode = false;

	/*-----------------------
	CONTINUALLY CHECK NODES AND UPDATE COBRA INFO
	-------------------------*/	
	while ( isdefined( eEndNode ) )
	{
		
		self waittill_any( "near_goal", "goal" );
		self.preferredTarget = undefined;
		eNextNode = undefined;

		/*-----------------------
		SEE IF THERE IS A NEXT NODE IN CHAIN
		-------------------------*/				
		if ( ( isdefined( self.currentnode ) ) && ( isdefined( self.currentnode.target ) )  )		
			eNextNode = getent( self.currentnode.target, "targetname" );
		
		/*-----------------------
		CHECK IF NEXT NODE HAS ANY PREFERRED TARGETS
		-------------------------*/		
		if ( ( isdefined( eNextNode ) ) && ( isdefined( eNextNode.script_linkTo ) ) )
			self.preferredTarget = getent( eNextNode.script_linkTo, "script_linkname" );
			
		/*-----------------------
		COBRA NOTIFY WHEN AT NEXT TO LAST NODE IN CHAIN
		-------------------------*/			
		if ( ( bReachedNextToLastNode == false ) && ( isdefined( eNextNode ) ) )
		{
			if ( eNextNode == eEndNode )
			{
				self notify( "near_default_path_end" );
				bReachedNextToLastNode = true;			
			}
		}
		/*-----------------------
		COBRA NOTIFY WHEN AT LAST NODE IN CHAIN
		-------------------------*/		
		if ( ( bReachedNextToLastNode == true ) && ( isdefined( self.currentnode ) ) && ( self.currentnode == eEndNode ) )
		{
			self notify( "reached_default_path_end" );
			bReachedLastNode = true;
		}
		/*-----------------------
		RESTART CHECKING AFTER SWITCHES TO ANOTHER PATH
		-------------------------*/				
		if ( ( bReachedLastNode == true ) && ( bReachedNextToLastNode == true ) )
		{
			bReachedNextToLastNode = false;
			bReachedLastNode = false;
			self waittill( "start_dynamicpath" );
			eEndNode = self get_last_ent_in_chain( "ent" );
		}
			
	}

}

vehicle_cobra_default_weapons_think()
{
	self endon( "death" );
	self endon( "stop_default_behavior" );
	self thread vehicle_mg_on();
	while ( true )
	{
		wait( 0.05 );	

		/*-----------------------
		FIRE MISSILES AT PREFERRED TARGETS FIRST
		-------------------------*/		
		if ( isdefined( self.preferredTarget ) )
			eTarget = self.preferredTarget;

		/*-----------------------
		OTHERWISE FIND A GOOD VEHICLE TARGET
		-------------------------*/			
		//getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
		else
			eTarget = maps\_helicopter_globals::getEnemyTarget( 3000, level.cosine[ "20" ], false, true, true, true, level.cobraTargetExcluders );
		
		if ( ( isdefined( eTarget ) ) && ( isdefined( eTarget.classname ) ) )
		{
			switch ( eTarget.classname )
			{
				case "script_origin":	//a preferred target that the next node in cobra's path is script_linkTo'ed
					
					// check if the cobra is within fov
					iFOVcos = level.cosine[ "15" ];
					forwardvec = anglestoforward( self.angles );
					normalvec = vectorNormalize( eTarget.origin - ( self.origin ) );
					vecdot = vectordot( forwardvec, normalvec );
					if ( vecdot <= iFOVcos )
						break;
					else
					{
						iShots = 1;
						self maps\_helicopter_globals::fire_missile( "ffar_airlift", iShots, eTarget );
						wait randomfloatrange( 2, 4.0 );	
						
//						
//						//if random target, make sure player can see it
//						playerEye = level.player getEye();
//						
//						// check if the cobra or target is within fov
//						bInFOV = within_fov( playerEye, level.player getPlayerAngles(), self.origin, level.cosine[ "40" ]);
//						if ( !bInFOV )
//							bInFOV = within_fov( playerEye, level.player getPlayerAngles(), eTarget.origin, level.cosine[ "40" ]);
//						
//						// FIRE if either is within FOV
//						if ( bInFOV )
//						{
//							iShots = 1;
//							self maps\_helicopter_globals::fire_missile( "ffar_airlift", iShots, eTarget );
//							wait randomfloatrange( 2, 4.0 );						
//						}

					}
					break;
				case "script_vehicle":	
					iShots = randomintrange( 1, 3 );
					self maps\_helicopter_globals::fire_missile( "ffar_airlift", iShots, eTarget );
					wait randomfloatrange( 1, 4.0 );
					break;
			}
		}
	}	
}

vehicle_m1a1_think()
{

}

vehicle_bmp_think()
{
	self endon( "death" );
	self thread vehicle_turret_think();
}

vehicle_mg_off()
{
	if ( isdefined( self.mgturret ) )
		self thread maps\_vehicle::mgoff();
}

vehicle_mg_on()
{
	if ( isdefined( self.mgturret ) )
		self thread maps\_vehicle::mgon();
}

vehicle_turret_think()
{
	self endon ("death");
	self vehicle_mg_off();
	self.turretFiring = false;
	eTarget = undefined;
	while ( true )
	{
		wait (0.05);
		/*-----------------------
		DISTANCE CHECK TO PLAYER
		-------------------------*/	
		if ( distancesquared( level.player.origin, level.player.origin ) > level.CannonRangeSquared )
			eTarget = undefined;
		else
			eTarget = level.player;

		/*-----------------------
		ONLY TARGET THE PLAYER IF WITHIN **PLAYER** FOV (NO CHEAP SHOTS)
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			playerEye = level.player getEye();
			bInFOV = within_fov( playerEye, level.player getPlayerAngles(), self.origin, level.cosine[ "25" ]);
			if ( !bInFOV )
			{
				//lose player as target for now
				if ( ( isdefined( eTarget ) ) && ( eTarget == level.player ) )
					eTarget = undefined;
				continue;			
			}
		}

		/*-----------------------
		IF CURRENT IS PLAYER, DO SIGHT TRACE
		-------------------------*/		
		if ( (isdefined(eTarget)) && (eTarget == level.player) )
		{
			sightTracePassed = false;
			sightTracePassed = sighttracepassed( self.origin, level.player.origin + ( 0, 0, 150 ), false, self );
			/*-----------------------
			IF CURRENT IS PLAYER BUT CAN'T SEE HIM, GET ANOTHER TARGET
			-------------------------*/		
			if ( !sightTracePassed )
			{
				eTarget = undefined;
			}
		}

		/*-----------------------
		IF PLAYER ISN'T CURRENT TARGET, GET ANOTHER
		-------------------------*/	
		if ( !isdefined( eTarget ) )
			eTarget = self vehicle_get_target();


		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( ( isdefined( eTarget ) ) && ( isalive( eTarget ) ) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec( targetLoc );
			fRand = ( randomfloatrange( 2, 3 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON
			-------------------------*/
			if (!self.turretFiring)
				self thread vehicle_fire_main_cannon();	
		}
	}
}

vehicle_get_target()
{
	eTarget = undefined;
	switch ( self.vehicletype )
	{
		case "zpu_antiair":
			self.defaultTargets = array_randomize( self.defaultTargets );
			eTarget = self.defaultTargets[0];
			break;
		case "bmp":
												//  getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
			eTarget = maps\_helicopter_globals::getEnemyTarget( level.CannonRange, level.cosine[ "180" ], true, true, false, true );
			break;
	}
	if ( isdefined( eTarget ) )
		return eTarget;
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	iFireTime = undefined;
	iBurstNumber = undefined;
			
	switch ( self.vehicletype )
	{
		case "zpu_antiair":
			iFireTime = weaponfiretime("bmp_turret");
			iBurstNumber = randomintrange(8, 15);
			break;
		case "bmp":
			iFireTime = weaponfiretime("bmp_turret");
			iBurstNumber = randomintrange(3, 8);
			break;
		default:
			assertmsg( "need to define a case statement for " + self.vehicletype );
	}

	assert( isdefined( iFireTime ) );
	self.turretFiring = true;
	i = 0;
	while (i < iBurstNumber)
	{
		i++;
		wait(iFireTime);
		self fireWeapon();
	}
	self.turretFiring = false;
}

vehicle_t72_think()
{

	
}

vehicle_damage_think()
{
	iPlayerProjectileHits = 0;
	while ( ( isalive( self ) ) && ( isdefined( self ) ) )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		wait ( 0.05 );
		damageType = vehicle_get_damage_type_and_attacker( type, damage, attacker, self.vehicletype );
		
		//player_missile
		//cobra_missile
		
		switch ( self.vehicletype )
	    {
	    	case "bmp":
	    		if ( damageType == "cobra_missile" )
	    			break;
	    		else if ( damageType == "player_missile" )
	    		{
	    			iPlayerProjectileHits++;
	    			if ( iPlayerProjectileHits == level.hitsToDestroyBMP )
	    				break;
	    		}
	    	case "t72":
	    		if ( damageType == "cobra_missile" )
	    			break;
	    		else if ( damageType == "player_missile" )
	    		{
	    			iPlayerProjectileHits++;
	    			if ( iPlayerProjectileHits == level.hitsToDestroyT72 )
	    				break;
	    		}
	    }
	    
	    self thread vehicle_death();
	}
	
}

vehicle_death()
{
	self notify ( "death" );
}


vehicle_get_damage_type_and_attacker( type, damage, attacker, vehicletypeAttacked )
{
	if ( !isdefined( type ) )
		return "unknown";
	if ( !isdefined( attacker ) )
		return "unknown";	
	
	sAttacker = undefined;
	sDamage = undefined;

	/*-----------------------
	IS THE ATTACKER PLAYER OR A VEHICLE?
	-------------------------*/		
	if ( attacker == level.player )
		sAttacker = "player";
	else if ( ( isdefined ( attacker.classname ) ) && ( attacker.classname == "script_vehicle" ) )
	{
		switch ( attacker.vehicletype )
		{
			case "cobra":
				sAttacker = "cobra";
		}
	}
	/*-----------------------
	FIND OUT WHAT WEAPON USED
	-------------------------*/	
	type = tolower( type );
	switch( type )
	{
		case "mod_projectile":
		case "mod_projectile_splash":
			sDamage = "missile";
			break;
		case "mod_grenade":
		case "mod_grenade_splash":
			sDamage = "grenade";
			break;
		default:
			sDamage = undefined;
			break;
	}	

	/*-----------------------
	RETURN CONCATENATED STRING OF ATTACKER AND DAMAGE
	-------------------------*/		
	return sAttacker + "_" + sDamage;
	
}

vehicle_cobra_attack_pattern_think( sStartNode )
{
	self endon( "death" );
	self notify( "starting_new_attack_pattern" );
	self endon( "starting_new_attack_pattern" );
	eStartNode = getent( sStartNode, "script_noteworthy" );
	assertex( isdefined( eStartNode ), "No start node with the script_noteworthy " + sStartNode +  " exists" );
	
	/*-----------------------
	SWITCH TO OTHER PATH
	-------------------------*/		
	self vehicle_detachfrompath(); 
	self thread vehicle_dynamicpath( eStartNode, false );
	eStartNode waittill( "trigger", vehicle );
	
	if ( getdvar( "debug_airlift" ) == "1" )
		iprintlnbold( "cobra arrived at start point" );
		

}

vehicle_animated_seaknight_land( eNode, sFlagDepart, aFriendlies )
{
	eSeaknight = spawn( "script_model", eNode.origin );
	eSeaknight setmodel( "vehicle_ch46e" );
	eSeaknight.animname = "seaknight";
	eSeaknight assign_animtree();
	
	if ( isdefined( aFriendlies ) )
		eSeaknight thread vehicle_seaknight_unload( aFriendlies );
	
	eOrgFx = spawn( "script_origin", eNode.origin );
	eSeaknight delaythread ( 19, ::vehicle_canned_seaknight_fx, eOrgFx );
	eNode anim_single_solo( eSeaknight, "landing" );
	eNode thread anim_loop_solo( eSeaknight, "idle", undefined, "stop_idle" );	
	eSeaknight notify ( "unload_ai" );
	eSeaknight waittill( "all_ai_unloaded" );
	
	if ( isdefined( sFlagDepart ) )
		flag_wait( sFlagDepart );
		
	wait(1);
	eNode notify( "stop_idle" );
	eNode thread anim_single_solo( eSeaknight, "take_off" );
	wait(1.5);
	eSeaknight notify( "taking_off" );
	eOrgFx delete();
	eSeaknight waittillmatch( "single anim", "end" );
	eSeaknight delete();

}

vehicle_seaknight_idle_and_load( aFriendlies )
{
	assertex( aFriendlies.size == 4, "Need to pass exactly 4 friendlies to this function. You passed " + aFriendlies.size );
	iLoadNumber = 0;
	for(i=0;i<aFriendlies.size;i++)
	{
		iLoadNumber++;
		aFriendlies[i] thread vehicle_seaknight_idle_and_load_think( iLoadNumber );
	}
}

vehicle_seaknight_idle_and_load_think( iAnimNumber )
{
	self endon( "death" );
	sAnimUnload = "ch46_unload_" + iAnimNumber;
	sAnimLoad = "ch46_load_" + iAnimNumber;

	/*-----------------------
	HIDE WHILE DOING UNLOAD
	-------------------------*/		
	self hide();
	level.seaknight anim_generic( self, sAnimUnload, "tag_detach" );
	
	/*-----------------------
	IDLE IN POSITION OUTSIDE SEAKNIGHT
	-------------------------*/		
	level.seaknight waittill ( "show_loaders" );
	self show();
	self thread anim_generic_loop( self, "ch46_unload_idle", undefined, "stop_ch46_idle" );

	/*-----------------------
	LOAD INTO SEAKNIGHT AND DELETE
	-------------------------*/	
	level.seaknight waittill ( "load" );
		
	self notify ( "stop_ch46_idle" );
	level.seaknight anim_generic( self, sAnimLoad, "tag_detach" );
	
	self notify( "stop magic bullet shield" );
	self delete();		
}

vehicle_seaknight_unload( aFriendlies, eCrewchief )
{
	//self ==> the seaknight vehicle
	self endon( "death" );
	assertex( aFriendlies.size == 4, "Need 4 AI for seaknight unload, you passed " + aFriendlies.size );
	iAnimNumber = 1;
	for(i=0;i<aFriendlies.size;i++)
	{
		sAnim = "ch46_unload_" + iAnimNumber;
		iAnimNumber++;
		aFriendlies[i] thread vehicle_seaknight_unload_ai_think( sAnim, self );
	}
	if ( isdefined( eCrewchief ) )
	{
			//anim_loop_solo( guy, anime_idle, tag, ender, entity );
		eCrewchief gun_remove();
		eCrewchief linkto( level.seaknight );
		self thread anim_loop_solo( eCrewchief, "crewchief_idle", "tag_detach", "stop_idle_crewchief", self );
	}
	
	/*-----------------------
	CHECK TO SEE WHEN ALL AI UNLOADED
	-------------------------*/		
	aUnloadedAI = aFriendlies;
	while( aUnloadedAI.size > 0 )
	{
		wait( 0.05 );
		for(i=0;i<aUnloadedAI.size;i++)
		{
			if ( isdefined( aUnloadedAI[i].unloaded ) )
			{
				aUnloadedAI[i].unloaded = undefined;
				aUnloadedAI = array_remove( aUnloadedAI, aUnloadedAI[i] );
			}
		}
	} 
	self notify( "all_ai_unloaded" );
	iprintln( "all ai unloaded" );
}

vehicle_seaknight_unload_ai_think( sAnim, eSeaknight )
{
	self endon( "death" );
	self allowedstances("crouch");
	self linkto( eSeaknight, "tag_detach");
	self hide();
	eSeaknight waittill ( "unload_ai" );
	self unlink();
	self show();
	eSeaknight anim_generic( self, sAnim, "tag_detach" );
	self setgoalpos( self.origin );
	//self thread anim_generic_loop( self, "ch46_unload_idle", undefined, "stop_ch46_idle" );
	self notify ( "unloaded" );
	self.unloaded = true;
	self waittill( "stop_ch46_idle" );
	self allowedstances("crouch", "stand", "prone" );
	
	
}



vehicle_canned_seaknight_fx( eOrgFx )
{
	self endon( "death" );
	self endon( "taking_off" );
	
	while ( isdefined( eOrgFx ) )
	{
		playfx ( getfx( "heli_dust_default" ), eOrgFx.origin );	
		wait( 0.1 );
	}
}

/****************************************************************************
    UTILITIES / HOUSEKEEPING
****************************************************************************/ 
AA_Utility()
{
	
}

initDifficulty()
{
	/*-----------------------
	SETUP VARIABLES
	-------------------------*/		
	skill = getdifficulty();
	level.skill = undefined;
	switch( skill )
	{
		case "gimp":
		case "easy":
			level.skill = "easy";
			break;
		case "medium":
			level.skill = "medium";
			break;
		case "hard":
		case "difficult":
			level.skill = "hard";
			break;
		case "fu":
			level.skill = "veteran";
			break;
	}

	/*-----------------------
	SEAKNIGHT HEALTH VARIABLES
	-------------------------*/		
	level.seaknightHealth = [];
	level.seaknightHealth["easy"] = 9000;
	level.seaknightHealth["medium"] = 6000;
	level.seaknightHealth["hard"] = 3000;
	level.seaknightHealth["veteran"] = 1500;
	

}

deleteWeapons()
{
	if (isdefined(self))
		self delete();
}

AI_player_seek()
{
	self endon ("death");
	newGoalRadius = distance( self.origin, level.player.origin );
	for(;;)
	{
		wait 2;
		self.goalradius = newGoalRadius;
			
		self setgoalentity ( level.player );
		newGoalRadius -= 175;
		if ( newGoalRadius < 512 )
		{
			newGoalRadius = 512;
			return;
		}
	}
}


getDamageType( type )
{
	//returns a simple damage type: melee, bullet, splash, or unknown
	if ( !isdefined( type ) )
		return "unknown";
	
	type = tolower( type );
	switch( type )
	{
		case "mod_explosive":
		case "mod_explosive_splash":
			return "c4";
		case "mod_projectile":
		case "mod_projectile_splash":
			return "rocket";
		case "mod_grenade":
		case "mod_grenade_splash":
			return "grenade";
		case "unknown":
			return "unknown";
		default:
			return "unknown";
	}
}

initPrecache()
{
	precacheItem( "cobra_FFAR_airlift" );
	precacheItem( "mark19_temp" );
	precacheItem( "rpg_player" );
	
	precacheModel( "weapon_AT4" );
	precacheModel( "viewhands_player_marines" );
	
	precacheModel( "weapon_saw_MG_Setup" );
	precacheModel( "weapon_rpd_MG_Setup" );
	
	precachestring( &"AIRLIFT_OBJ_PLAZA_CLEAR" );
	precachestring( &"AIRLIFT_OBJ_PLAZA_BUILDING" );
	precachestring( &"AIRLIFT_OBJ_EXTRACT_TEAM" );
	precachestring( &"AIRLIFT_OBJ_RESCUE_PILOT" );
	precachestring( &"AIRLIFT_OBJ_SAFE_DISTANCE" );
	
	precachestring( &"AIRLIFT_DEBUG_LEVEL_END" );
	
	precachestring( &"SCRIPT_PLATFORM_HINT_PILOT_PICKUP" );
	precachestring( &"SCRIPT_PLATFORM_HINT_PILOT_PUTDOWN" );
	precachestring( &"SCRIPT_PLATFORM_HINT_PILOT_PUTDOWN_CHOPPER" );
	

}

seaknight_player_think( sStartPoint )
{
	eStartPath = undefined;
	switch( sStartPoint )
	{
		case "default":
			break;
		case "plazafly":
			eStartPath = getent( "flightPathstart_plazafly", "targetname" );
			break;
		case "plaza":
			eStartPath = getent( "flightPathstart_plaza", "targetname" );
			break;
		case "smoketown":
			eStartPath = getent( "flightPathstart_smoketown", "targetname" );
			break;
		case "cobrastreets":
			eStartPath = getent( "flightPathstart_cobrastreets", "targetname" );
			break;
		case "nuke":
			break;	
	}
	
	if ( sStartPoint != "default" )
	{
		eSeaknightSpawner = getvehiclespawner( "seaknightPlayer" );
		eSeaknightSpawner.origin = eStartPath.origin;
		eSeaknightSpawner.angles = eStartPath.angles;
	}
	
	level.seaknight = spawn_vehicle_from_targetname( "seaknightPlayer" );
	thread maps\_vehicle::gopath( level.seaknight );
	level.seaknight seaknight_turret_think();
	if ( sStartPoint != "default" )
	{
		level.seaknight vehicle_detachfrompath(); 
		level.seaknight thread vehicle_dynamicpath( eStartPath, false ); 	
	}

	/*-----------------------
	SEAKNIGHT SETUP
	-------------------------*/	
	level.seaknight setmaxpitchroll( 5, 10 );
	level.seaknight sethoverparams( 32, 10, 3 );
	//level.seaknight.health = level.seaknightHealth[ level.skill ];
	
	flag_set( "seaknight_set_up" );

	/*-----------------------
	SEAKNIGHT DEATH
	-------------------------*/	
	level.seaknight waittill( "death" );
	
	level.seaknight thread play_loop_sound_on_entity(level.scr_sound["heli_alarm_loop"]);
	level.seaknight waittill( "crash_done" );
	
	level.player DisableInvulnerability();
	level.player dodamage( level.player.health + 1000, level.player.origin );
	
	level.eHindIntro notify ( "stop sound" + level.scr_sound["heli_alarm_loop"] );
}

exploder_trigs_mark19_think()
{
	self endon ( "exploder_detonated" );
	iExploderNum = self.script_noteworthy;
	assertex( isdefined( self.script_noteworthy, "exploder_trigs_mark19 at position " + self.origin + " needs a script_noteworthy with the number of the exploder to trigger" ) );
	assertex( isdefined( level.scr_sound[ "exploder" ][ iExploderNum ], "Need to define a sound for this exploder number: " + iExploderNum ) );
	while ( true )
	{
		self waittill ( "damage", amount, attacker, direction_vec, point, type );	
		if ( attacker != level.player )
			continue;
		if ( !isdefined( type ) )
			continue;
		
		exploder( iExploderNum );
		thread play_sound_in_space( level.scr_sound[ "exploder" ][ iExploderNum ], self.origin );
		level notify( "exploder_" + iExploderNum + "_detonated" );
		self notify( "exploder_detonated" );
	}
}

exploder_statue()
{
	statue = getent( "statue", "targetname" );
	statue_fallen = getent( "statue_fallen", "targetname" );
	org_fall = statue_fallen.origin;
	ang_fall = statue_fallen.angles;
	statue_fall_fx = getent( "statue_fall_fx", "targetname" );
	statue_fallen delete();
	
	level waittill( "exploder_100_detonated" );
	playfx ( getfx("statue_smoke"), statue.origin);
	thread play_sound_in_space( level.scr_sound[ "statue_fall" ], org_fall );
	
	fRotateTime = 2;
	fMoveTime = 2;
	
	statue moveto( org_fall, fMoveTime, fMoveTime );
	statue rotateto( ang_fall, fRotateTime, fRotateTime );
	
	wait( fMoveTime );
	thread play_sound_in_space( level.scr_sound[ "statue_impact" ], org_fall );
}

seaknight_turret_test()
{
	while( !isdefined( level.cobraWingman ) )
		wait (0.05);
	
	eTarget = level.cobraWingman;
	
	iFireTime = weaponfiretime("seaknight_mark19");
	while ( true )
	{
		targetLoc = eTarget.origin;
		self setTurretTargetVec(targetLoc);
		fRand = ( randomfloatrange(2, 3));
		self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );
		self fireWeapon();
		wait( 2 );
	}


}

seaknight_turret_think2()
{

	
	// self == > the player seaknight
	//self clearTurretTarget();
	//level.player setplayerangles( self.angles );
	//self makevehicleusable();
	//self useby ( level.player );
	//level.player DisableTurretDismount();

}


seaknight_turret_think()
{
	// self == > the player seaknight
	
	/*-----------------------
	SETUP TURRET
	-------------------------*/	
	sTag = "tag_player";	
	orgOffset = ( 15, 0, -10 );
	angOffset = ( 0, 0, 0 );
	level.TempTurretOrg = spawn( "script_origin", ( 0, 0, 0 ) );
	level.TempTurretOrg.angles = self.angles;
	level.TempTurretOrg linkto( self, sTag, orgOffset, angOffset );
	
	seaknight_player_mount_gun();
}

seaknight_player_mount_gun()
{
	/*-----------------------
	HACKED UNTIL CH46 TURRET RIGGED
	-------------------------*/		
	level.onMark19 = true;
	thread hud_hide( true );
	thread playerWeaponTempRemove();
	level.player giveWeapon( "mark19_temp" );
	level.player switchToWeapon( "mark19_temp" );
	level.player EnableInvulnerability();
				//playerlinktodelta( <linkto entity>, 	<tag>, 		<viewpercentag fraction>, <right arc>, <left arc>, <top arc>, <bottom arc> )
	level.player playerlinktodelta( level.TempTurretOrg, undefined, 1, 50, 50, 30, 45 );
	tagAngles = level.seaknight gettagangles( "tag_player" );
	level.player setplayerangles(tagAngles + ( 0, 0, 0) );
   	level.player allowprone( false );
   	level.player allowcrouch( false );
    thread turret_ammo_think();
    thread shotFired();
}

seaknight_player_mount_gun2()
{
	//level.player playerSetGroundReferenceEnt( level.seaknight );
	//thread hud_hide( true );
	level.seaknight useby ( level.player );
	level.seaknight thread seaknight_fire_turret();
}

seaknight_fire_turret()
{
	iFireTime = weaponfiretime( "seaknight_mark19" );
	while ( true )
	{
		self waittill( "turret_fire" );
		self fireWeapon();
		wait( iFireTime );
	}
}


shotFired()
{
	for (;;)
	{
		level.player waittill( "projectile_impact", weaponName, position, radius );
		if ( getdvar( "ragdoll_deaths" ) == "1" )
			thread shotFiredPhysicsSphere( position );
		wait 0.05;
	}
}

shotFiredPhysicsSphere( center )
{
	wait 0.1;
	physicsExplosionSphere( center, level.physicsSphereRadius, level.physicsSphereRadius / 2, level.physicsSphereForce );
}

seaknight_player_dismount_gun()
{
	/*-----------------------
	HACKED UNTIL CH46 TURRET RIGGED
	-------------------------*/
	
	level.onMark19 = false;
	thread seaknight_door_open_sound();
	VisionSetNaked( "airlift_streets", 3 );
	thread hud_hide( false );
	level notify( "player_off_turret" );
	level.player takeWeapon( "mark19_temp" );
	level.seaknight lerp_player_view_to_tag( "tag_turret_exit", 1, 0.9, 25, 25, 45, 0 );
    level.player unlink();
	level.player notify ( "restore_player_weapons" );
	//level.player DisableInvulnerability();
   	level.player allowprone( true );
   	level.player allowcrouch( true );

}

seaknight_door_open_sound()
{
	level.seaknight playsound (level.scr_sound["seaknightdoor_open_start"], "sounddone");
	wait(.3);
	level.seaknight thread play_loop_sound_on_entity (level.scr_sound["seaknightdoor_open_loop"]);
	wait(2);
	level.seaknight notify ( "stop sound" + level.scr_sound["seaknightdoor_open_loop"]);
	level.seaknight playsound (level.scr_sound["seaknightdoor_open_end"]);
}

playerWeaponTempRemove()
{
	// HACKED until I get the CH46 rigged with an actual turret
	playerWeapons = level.player GetWeaponsList();
	playerPrimaryWeapons = level.player GetWeaponsListPrimaries();
	
	if ( playerWeapons.size > 0 )
	{
		for(i=0;i<playerWeapons.size;i++)
			level.player takeWeapon(playerWeapons[i]);		
	}
	
	level.player waittill ("restore_player_weapons");
	
	if ( playerWeapons.size > 0 )
	{
		for(i=0;i<playerWeapons.size;i++)
			level.player giveWeapon(playerWeapons[i]);				
	}
	
	if ( isdefined( playerPrimaryWeapons[0] ) )
		level.player switchToWeapon( playerPrimaryWeapons[0] );

}

hud_hide( state )
{
	wait 0.05;
	if ( state )
	{
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "hud_showTextNoAmmo", "0" ); 
	}
	else
	{
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
		SetSavedDvar( "hud_showTextNoAmmo", "1" ); 
	}
}

turret_ammo_think()
{
	level endon( "player_off_turret" );
    while ( true )
    {
    	wait( 1 );
    	level.player givemaxammo( "mark19_temp" );
    }
	
}

disable_color_trigs()
{
	array_thread( level.aColornodeTriggers, ::trigger_off );
}

flight_flags_think()
{
	//self ==> the script_origin with the flag
	assertEx( isdefined( self.script_parameters ), "Flight flags need to have the <vehicleTargetname_FlagName> set in a script_parameters key: ent at location: " + self.origin );
	assertEx( issubstr( self.script_parameters, "_" ), "Flight flags need to have a '_' seperating the vehicle targetname from the flag string. ent at location: " + self.origin );
	aStrings = strtok( self.script_parameters, "_" );
	assertEx( aStrings.size == 2, "Flight flags need to have a SINGLE '_' seperating the vehicle targetname from the flag string. ent at location: " + self.origin );
	vehicleTargetname = aStrings[ 0 ];
	sFlag = aStrings[ 1 ];
	
	flag_init( sFlag );
	level endon ( sFlag );

	/*-----------------------
	SET FLAG ONLY WHEN SPECIFIC VEHICLE HITS ORIGIN
	-------------------------*/		
	while ( true )
	{
		self waittill( "trigger", other );
		if ( other.targetname == vehicleTargetname )
		{
			if ( getdvar( "debug_airlift" ) == "1" )
				self thread print3Dthread( sFlag, undefined, 5 );
			flag_set( sFlag );
		}
	}
}

AI_think(guy)
{
	/*-----------------------
	RUN ON EVERY DUDE THAT SPAWNS
	-------------------------*/		
	if (guy.team == "axis")
		guy thread AI_axis_think();
	
	if (guy.team == "allies")
		guy thread AI_allies_think();

}

AI_allies_think()
{
	self.animname = "frnd";
	self thread magic_bullet_shield();
	self.a.disablePain = true;
}

AI_axis_think()
{
	self.animname = "hostile";
	self thread AI_ragdoll();
}

AI_ragdoll()
{
	self waittill( "death", attacker, cause );
	
	if ( ( isdefined ( attacker ) ) && ( attacker == level.player) && ( level.onMark19 == true ) )
		self.skipDeathAnim = true;
}

AI_drone_think()
{
	self endon( "death" );
	self thread AI_ragdoll();
	self endon ( "stop_default_drone_behavior" );
	self waittill( "goal" );
	self delete();
}