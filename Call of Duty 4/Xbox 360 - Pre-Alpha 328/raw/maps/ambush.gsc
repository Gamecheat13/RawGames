#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#include maps\_hud_util;

main()
{
	//	targetname / friendly_respawn_trigger
	//  target / auto__ == targetning a spawner
	//	replacement spawners with targetname / color_spawner

	add_start( "ambush", ::start_ambush );
	add_start( "village", ::start_village);
	add_start( "morpheus", ::start_morpheus);
	add_start( "apartment", ::start_apartment);

	default_start( ::start_default );

	createthreatbiasgroup( "player" );
	createthreatbiasgroup( "oblivious" );
	createthreatbiasgroup( "group1" );
	createthreatbiasgroup( "group2" );
	createthreatbiasgroup( "badguy" );

	maps\_bm21_troops::main( "vehicle_bm21_mobile_cover" );
	maps\_bmp::main( "vehicle_bmp_low" );
	maps\_blackhawk::main("vehicle_blackhawk_low");
	maps\_uaz::main( "vehicle_uaz_hardtop" );
	maps\_vehicle::build_aianims( ::uaz_anims, ::uaz_vehicle_anims );
	maps\_drone::init();

	precacheItem( "hunted_crash_missile" );

	precacheModel( "viewhands_op_force" );

	precacheTurret( "heli_minigun_noai" );

	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_m16_clip";
	level.weaponClipModels[1] = "weapon_mp5_clip";
	level.weaponClipModels[2] = "weapon_ak74u_clip";
	level.weaponClipModels[3] = "weapon_ak47_clip";
	level.weaponClipModels[4] = "weapon_dragunov_clip";
	level.weaponClipModels[5] = "weapon_g36_clip";
	level.weaponClipModels[6] = "weapon_saw_clip";
	level.weaponClipModels[7] = "weapon_g3_clip";

	// todo change to the sas version.
	maps\_load::set_player_viewhand_model( "viewhands_player_usmc" );

	setup_flags();

	maps\ambush_anim::main();
	maps\ambush_fx::main();
	maps\_load::main();
	level thread maps\ambush_amb::main();
	maps\_compass::setupMiniMap("compass_map_ambush");

	maps\createart\ambush_art::main();

	animscripts\dog_init::initDogAnimations();

	setignoremegroup( "badguy", "allies" );	// allies ignore badguy
	setignoremegroup( "badguy", "axis" );	// axis ignore badguy

	// make oblivious ingnored and ignore by everything.
	setignoremegroup( "allies", "oblivious" );	// oblivious ignore allies
	setignoremegroup( "axis", "oblivious" );	// oblivious ignore axis
	setignoremegroup( "player", "oblivious" );	// oblivious ignore player
	setignoremegroup( "oblivious", "allies" );	// allies ignore oblivious
	setignoremegroup( "oblivious", "axis" );	// axis ignore oblivious
	setignoremegroup( "oblivious", "oblivious" );	// oblivious ignore oblivious

	level.bmpCannonRange = 2048;
	level.bmpMGrange = 1200;
	level.bmpMGrangeSquared = level.bmpMGrange * level.bmpMGrange;
	level.cosine["180"] = cos(180);

	level thread fixednode_trigger_setup();
	level thread setup_player_action_notifies();
	level thread setup_vehicle_pause_node();
	level thread ambush_tower_fall();
	
	// add respawn guys to the squad
	array_thread( getentarray( "respawn_guy", "script_noteworthy" ), ::add_spawn_function, ::generic_allied );

	level.sm_sunsamplesizenear = GetDvarFloat( "sm_sunsamplesizenear" );
}

#using_animtree( "vehicles" );   
uaz_vehicle_anims( positions )
{
	positions = maps\_uaz::set_vehicle_anims( positions );

//	positions[ 0 ].vehicle_getoutanim = undefined;
	positions[ 0 ].vehicle_getoutanim = %ambush_VIP_escape_UAZ;
	positions[ 0 ].vehicle_getoutanim_clear = false;

	return positions;
}

#using_animtree( "generic_human" );   
uaz_anims()
{
	positions = maps\_uaz::setanims();

	positions[ 0 ].getout = %ambush_VIP_escape_son;

	return positions;

}

setup_flags()
{
	takeover_flags();
	ambush_flags();
	village_flags();
	morpheus_flags();
	apartment_flags();
}

takeover_flags()
{
	// takeover

	flag_trigger_init( "takeover_setup", getent( "takeover_setup", "targetname" ) );
	flag_init( "takeover_checkpoint_located" );
	flag_trigger_init( "takeover_inplace", getent( "takeover_inplace", "targetname" ) );
	flag_trigger_init( "takeover_force", getent( "takeover_boundary", "targetname" ) );
	flag_trigger_init( "takeover_advance", getent( "takeover_boundary", "targetname" ) );
	flag_init( "takeover_done" );
	flag_init( "takeover_fade" );
	flag_init( "takeover_fade_clear" );
	flag_init( "takeover_fade_done" );
}

ambush_flags()
{
	// ambush
	flag_init( "ambush_mission_fail" );
	flag_init( "ambush_early_start" );
	flag_init( "ambush_vehicles_inplace" );
	flag_init( "ambush_badguy_spotted" );
	flag_init( "ambush_rocket" );
	flag_init( "ambush_start" );
	flag_init( "ambush_rear_bmp_destroyed" );
	flag_init( "ambush_tower_fall" );
	flag_init( "ambush_switch_tower" );
	flag_init( "ambush_recovered" );
}

village_flags()
{
	flag_init( "village_helicopter_greeting" );

	flag_trigger_init( "junkyard_exit", getent( "junkyard_exit", "targetname" ) );
	flag_trigger_init( "village_road", getent( "village_road", "targetname" ) );

	flag_trigger_init( "village_approach", getent( "village_approach", "targetname" ) );
	flag_init( "village_defend" );
	flag_trigger_init( "village_retreat", getent( "village_retreat", "targetname" ) );
	flag_init( "village_badguy_escape" );
	flag_init( "village_alley" );
}

morpheus_flags()
{
	flag_trigger_init( "morpheus_quick_start",		getent( "morpheus_quick_start",		"targetname" ) );
	flag_trigger_init( "morpheus_dumpster",			getent( "morpheus_dumpster",		"targetname" ) );
	flag_trigger_init( "morpheus_green_car",		getent( "morpheus_green_car",		"targetname" ) );
	flag_trigger_init( "morpheus_iron_fence",		getent( "morpheus_iron_fence",		"targetname" ) );
	flag_init( "morpheus_iron_fence_fight" );
	flag_trigger_init( "morpheus_flanker",			getent( "morpheus_flanker",			"targetname" ) );
	flag_trigger_init( "morpheus_rpg",				getent( "morpheus_rpg",				"targetname" ) );
	flag_trigger_init( "morpheus_2nd_floor",		getent( "morpheus_2nd_floor",		"targetname" ) );
	flag_trigger_init( "morpheus_single",			getent( "morpheus_single",			"targetname" ) );
	flag_trigger_init( "morpheus_target",			getent( "morpheus_target",			"targetname" ) );
	flag_trigger_init( "morpheus_target_moving",	getent( "morpheus_target_moving",	"targetname" ) );
	flag_trigger_init( "morpheus_alley",			getent( "morpheus_alley",			"targetname" ) );
}

apartment_flags()
{
	flag_trigger_init( "apartment_start",			getent( "apartment_start",			"targetname" ) );
	flag_trigger_init( "apartment_badguy_run",		getent( "apartment_badguy_run",		"targetname" ) );
	flag_trigger_init( "apartment_fire",			getent( "apartment_fire",			"targetname" ) );
	flag_init( "apartment_heli_attack" );
	flag_init( "apartment_heli_firing" );
	flag_init( "apartment_mg_destroyed" );
	flag_trigger_init( "apartment_badguy_attack",	getent( "apartment_badguy_attack",	"targetname" ) );
	flag_trigger_init( "apartment_inside",			getent( "apartment_inside",			"targetname" ) );
	flag_trigger_init( "apartment_badguy_3rd_flr",	getent( "apartment_badguy_3rd_flr",	"targetname" ) );
	flag_trigger_init( "apartment_mg_4th_flr",		getent( "apartment_mg_4th_flr",		"targetname" ) );
	flag_init( "apartment_mg_destroyed_2" );
	flag_init( "apartment_clear" );
	flag_trigger_init( "apartment_roof",			getent( "apartment_roof",			"targetname" ) );
	flag_trigger_init( "apartment_stairs",			getent( "apartment_stairs",			"targetname" ) );
	flag_trigger_init( "apartment_suicide",			getent( "apartment_suicide",		"targetname" ) );
	flag_init( "mission_done" );
}

aarea_takeover_init()
{
	autosave_by_name( "takeover" );

	battlechatter_off( "allies" );

	setExpFog(600, 2500, .69, .72, .675, 0);
	VisionSetNaked( "ambush_rain", 0 );

	// turn village triggers off.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_off );

	setup_friendlies( 3 );
	level.player set_playerspeed( 130 );

	array_thread( level.squad, ::enable_cqbwalk );
	array_thread( get_generic_allies(), ::replace_on_death );

	level thread guardtower_dead_enemies();

	level thread takeover_player();
	level thread takeover_objective();
	level thread takeover_setup();
	level thread takeover_attack();
	level thread takeover_clear_roof();
	level thread takeover_fade();

	array_thread( getentarray( "checkpoint_guy", "targetname" ), ::add_spawn_function, ::checkpoint_guy );
	scripted_array_spawn( "checkpoint_guy", "targetname", true );
}

guardtower_dead_enemies()
{
	flag_wait( "takeover_fade_clear" );

	array = getentarray( "dead_enemies", "script_noteworthy" );

	drone = [];
	spawner = getentarray( "tower_drone", "targetname" );
	for( i = 0 ; i < spawner.size ; i ++ )
	{
		drone[i] = dronespawn( spawner[i] );
		drone[i].animname = "generic";
	}

	for( i = 0 ; i < drone.size ; i ++ )
	{
		array[i] anim_first_frame_solo( drone[i], "death_pose_" + i );
		drone[i] linkto( array[i] );
	}
}

takeover_objective()
{
	wait 1;
	checkpoint = getent( "obj_checkpoint", "targetname" );
	objective_add( 0, "active", &"AMBUSH_OBJ_CHECKPOINT", checkpoint.origin );
	objective_current( 0 );

	flag_wait( "takeover_checkpoint_located" );
	objective_state( 0, "done" );

	dumpster = getent( "obj_dumpster", "targetname" );
	objective_add( 1, "active", &"AMBUSH_OBJ_GET_IN_POSITION", dumpster.origin);
	objective_current( 1 );

	flag_wait( "takeover_force" );

	waittill_dead_or_dying( get_ai_group_ai( "tower_guy" ), undefined, 4 );

	objective_state( 1, "done" );

	objective_add( 2, "active", &"AMBUSH_OBJ_SECURE_CHECKPOINT", checkpoint.origin);
	objective_current( 2 );

	flag_wait( "takeover_done" );

	objective_state( 2, "done" );

}

takeover_player()
{
	trigger = getent( "takeover_danger_trigger", "targetname" );
	trigger waittill( "trigger" );

	level thread set_flag_on_player_action( "takeover_force", true, true);

	flag_wait( "takeover_force" );

	level.player set_playerspeed( 190, 3 );
}

takeover_setup()
{
	thread add_dialogue_line( "Russian", level.scr_text[ "generic" ][ "best_way" ] );
	wait 3; 
	level.price queue_anim( "ambush_pri_notbad" );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "radio_jammers1" ] );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "radio_jammers2" ] );

	level endon( "takeover_force" );

	getent( "gate_open", "targetname" ) hide();
	getent( "rear_blocker_open", "targetname" ) hide();

	flag_wait( "takeover_setup" );

//	thread add_dialogue_line( "Price", level.scr_text[ "price" ][ "this_is_it1" ] );
//	thread add_dialogue_line( "Price", level.scr_text[ "price" ][ "this_is_it2" ] );
	level.price thread queue_anim( "ambush_pri_onmymark" );
	flag_set( "takeover_checkpoint_located" );
	activate_trigger_with_targetname( "takeover_setup_color_init" );

	flag_wait( "takeover_inplace" );
	wait 3;
	level.price thread queue_anim( "ambush_pri_takethemout" );

	wait 7;
	level.price thread queue_anim( "ambush_pri_cleartower" );

	wait 7;
	flag_set( "takeover_force" );
}

takeover_attack()
{
	flag_wait( "takeover_force" );

	blocker = getent( "takeout_path_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	activate_trigger_with_targetname( "takeover_attack_color_init" );

	level.price thread queue_anim( "ambush_pri_movemove" );

	battlechatter_on( "allies" );

	activate_trigger_with_targetname( "takeover_attack_color_init" );
	flag_wait_or_timeout( "takeover_advance", 10 );

	activate_trigger_with_targetname( "takeover_advance_color_init" );

	axis = getaiarray( "axis" );

	waittill_dead_or_dying( axis );

	array_thread( level.squad, ::disable_cqbwalk );

	activate_trigger_with_targetname( "takeover_hero_clear_color_init" );
	wait 2;
	thread add_dialogue_line( "Griggs", level.scr_text[ "mark" ][ "area_secure" ] );
//	level.mark thread queue_anim( "area_secure" );
	activate_trigger_with_targetname( "takeover_clear_color_init" );

	level.price thread takeover_price();

	wait 2;
	flag_set( "takeover_done" );
	level.price queue_anim( "ambush_pri_sortedout" );
	level.price queue_anim( "ambush_pri_keepbusy" );
	wait 0.5;
	level.price thread queue_anim( "ambush_pri_muchtime" );
	
	flag_set( "takeover_fade" );

	level thread aarea_ambush_init();
}

takeover_price()
{
	self disable_ai_color();
	anim_ent = getnode( "price_cleanup_node", "targetname" );
	anim_ent anim_reach_solo( self, "cleanup" );
	anim_ent thread anim_single_solo( self, "cleanup" );

	flag_wait( "takeover_fade_clear" );

	self stopanimscripted();
	self notify( "single anim", "end" );
	self set_force_color( "y" );
}

takeover_clear_roof()
{
	trigger = getent( "clear_roof", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "roof_guy" ), ::kill_ai, 0, 5 );
}

takeover_fade()
{
	flag_wait( "takeover_fade" );
	black = create_overlay_element( "black", 0 );
	black fadeovertime( 2 );
	black.alpha = 1;
	thread hud_hide();

	wait 2;
	level.player FreezeControls( true );

	flag_wait( "takeover_fade_clear" );

	hud_string();

	black fadeovertime( 4 );
	black.alpha = 0;
	level.player FreezeControls( false );
 	wait 2;
	thread hud_hide( false );
	wait 2;
	black destroy();
	flag_set( "takeover_fade_done" );
}

hud_string()
{
	hud_string = createFontString( "objective", 1.5 );
	hud_string.sort = 3;
	hud_string.glowColor = ( 0.7, 0.7, 0.3 );
	hud_string.glowAlpha = 1;
	hud_string SetPulseFX( 60, 3500, 700 );
	hud_string.foreground = true;

	hud_string setPoint( "BOTTOM", undefined, 0, -150 );

	hud_string setText( &"AMBUSH_TWO_HOURS_LATER" );

	wait 5;

	hud_string destroy();
}

checkpoint_guy()
{
	self endon( "death" );

	self setthreatbiasgroup( "oblivious" );

	flag_wait( "takeover_force" );

	wait randomfloatrange( 0.5, 3 );
	self setthreatbiasgroup( "axis" );
	self.fixednode = false;

}

aarea_ambush_init()
{
	ambush_setup();
	autosave_by_name( "ambush" );

	blocker = getent( "rear_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	getent( "rear_blocker_open", "targetname" ) show();

	getent( "badguy", "script_noteworthy" ) add_spawn_function( ::ambush_badguy_spawn_function );
	getent( "badguy_passanger", "script_noteworthy" ) add_spawn_function( ::ambush_badguy_passanger_spawn_function );

	activate_trigger_with_targetname( "ambush_enemy_color_init" );

	level thread ambush_player_interrupt();

	level thread ambush_helicopter();
	level thread ambush_objective();
	level thread ambush_mark();
	level thread ambush_price();
	level thread ambush_steve();
	level thread ambush_rockets();
	level thread ambush_caravan();

	flag_wait( "ambush_recovered" );
	level thread aarea_village_init();
}

ambush_player_interrupt()
{
	level endon( "ambush_rocket" );

	level thread ambush_mission_fail();

	vnode = getvehiclenode( "caravan_approach", "script_noteworthy" );
	vnode waittill( "trigger" );

	level thread set_flag_on_player_action( "ambush_mission_fail", false, true);

	flag_wait( "ambush_vehicles_inplace" );

	level thread set_flag_on_player_action( "ambush_early_start", false, true);

	flag_wait( "ambush_early_start" );

	flag_set( "ambush_start" );
	flag_set( "ambush_rocket" );
}

ambush_mission_fail()
{
	level endon( "ambush_vehicles_inplace" );

	flag_wait( "ambush_mission_fail" );

	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_STARTED_EARLY" );
	maps\_utility::missionFailedWrapper();
}

ambush_helicopter()
{
	flag_wait( "ambush_start" );

//	wait 3;

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( level.helicopter.target, "targetname" );
	level.helicopter thread heli_path_speed();
	level.helicopter sethoverparams( 150, 120, 60);

	struct = getstruct( "rocket_attack", "script_noteworthy" );
	struct waittill( "trigger" );

	level.helicopter setVehWeapon( "hunted_crash_missile" );
	level.helicopter setturrettargetent( level.rear_bmp );
	
	level.rear_bmp maps\_vehicle::godoff();

//	level.helicopter fireweapon( "tag_gun_r", level.rear_bmp, ( 0,0,0 ) );
	level.helicopter fireweapon( "tag_barrel", level.rear_bmp, ( 0,0,0 ) );
	wait 0.5;
	missile = level.helicopter fireweapon( "tag_barrel", level.rear_bmp, ( 0,0,0 ) );

	assert( isdefined( missile ) );

	missile waittill( "death" );

	if ( isalive( level.rear_bmp ) )
		level.rear_bmp notify( "death" );

	flag_set( "ambush_rear_bmp_destroyed" );

}

ambush_objective()
{
	flag_wait( "takeover_fade_done" );

	objective_add( 3, "active", &"AMBUSH_OBJ_AMBUSH_CONVOY", level.player.origin );
	objective_current( 3 );

	flag_wait( "ambush_start" );
	objective_state( 3, "done" );
}


ambush_badguy_spawn_function()
{
	self.name = "V. Zakhaev";

	self set_battlechatter( false );

	self setthreatbiasgroup( "oblivious" );
	self thread magic_bullet_shield();

	flag_wait( "ambush_start" );

	level.badguy_jeep waittill( "death" );
	self unlink();

	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self.grenadeawareness = 0;
	self setFlashbangImmunity( true );

	node = getnode( "ambush_badguy_path", "targetname" );
	self thread maps\_spawner::go_to_node( node );

	self waittill( "reached_path_end" );
	self stop_magic_bullet_shield();
	self delete();
}

ambush_badguy_passanger_spawn_function()
{
	self setthreatbiasgroup( "oblivious" );
	self waittill( "jumpedout" );
	self setthreatbiasgroup( "axis" );
}

ambush_caravan()
{
	level thread ambush_streetlight();

	wait 8;
	vehicles = maps\_vehicle::scripted_spawn( 0 );

	level.badguy_jeep = undefined;
	level.rear_truck = undefined;
	level.bm21 = undefined;
	level.middle_bm21 = undefined;
	level.bmp = undefined;
	level.rear_bmp = undefined;

	for( i = 0 ; i < vehicles.size ; i ++ )
	{
		thread maps\_vehicle::gopath( vehicles[i] );
		
		if ( !isdefined( vehicles[i].script_noteworthy ) )
			continue;
		else if ( vehicles[i].script_noteworthy == "ambush_jeep" )
			level.badguy_jeep = vehicles[i];
		else if ( vehicles[i].script_noteworthy == "rear_truck" )
			level.rear_truck = vehicles[i];
		if ( vehicles[i].script_noteworthy == "bm21" )
			level.bm21 = vehicles[i];
		if ( vehicles[i].script_noteworthy == "middle_bm21" )
			level.middle_bm21 = vehicles[i];
		if ( vehicles[i].script_noteworthy == "bmp" )
			level.bmp = vehicles[i];
		if ( vehicles[i].script_noteworthy == "rear_bmp" )
			level.rear_bmp = vehicles[i];
	}

	level.vehicle_ResumeSpeed = 20;

	vnode = getvehiclenode( "bm21_inplace", "script_noteworthy" );
	vnode waittill( "trigger" );

	flag_set( "ambush_vehicles_inplace" );

	flag_wait( "ambush_rocket" );
	flag_wait_or_timeout( "ambush_start", 1 );

	level.bm21 notify( "unload", "all" );
	level.middle_bm21 notify( "unload", "passengers" );

	level.rear_bmp thread ambush_bmp_attack();

	flag_wait( "ambush_rear_bmp_destroyed" );

	wait 1;

	activate_trigger_with_noteworthy( "ambush_extra_enemies" );

	wait 3;

	activate_trigger_with_targetname( "jeep_vehiclegate" );
}

ambush_streetlight()
{
	streetlight = getent( "streetlight", "targetname" );
	ents = getentarray( streetlight.target, "targetname" );
	if ( ents[0].classname == "script_model" )
	{
		end_angles = ents[0].angles;
		end_origin = ents[0].origin;
		ents[0] delete();
	 	ents[1] linkto( streetlight );
	}
	else
	{
		end_angles = ents[1].angles;
		end_origin = ents[1].origin;
		ents[1] delete();
	 	ents[0] linkto( streetlight );
	}

	vnode = getvehiclenode( "streetlight_hit", "script_noteworthy" );
	vnode waittill( "trigger" );

	streetlight rotateto( end_angles, 0.3, 0, 0.1 );
	streetlight moveto( end_origin, 0.3, 0, 0.1 );

	vnode = getvehiclenode( "truck_hit", "script_noteworthy" );
	vnode waittill( "trigger" );
	level.middle_bm21 JoltBody( ( level.middle_bm21.origin + (0,0,64) ), 2 );
}

ambush_bmp_attack()
{
	self endon( "death" );

	ent = getent( "bmp_target", "targetname" );
	level.rear_bmp thread bmp_pan_target( ent );

	level.rear_bmp waittill("turret_on_target");

	while ( true )
	{
		level.rear_bmp fireweapon();
		wait 0.1;
	}
}

bmp_pan_target( ent )
{
	self setturrettargetent( ent );
	self waittill("turret_on_target");

	while( isdefined( ent.target ) )
	{
		wait 0.5;
		ent = getent( ent.target, "targetname" );
		self setturrettargetent( ent );
		self waittill("turret_on_target");
	}
}

ambush_rockets()
{
	flag_wait( "ambush_rocket" );

	ai = get_ai_group_ai( "rocket_man" );
	ai = get_array_of_closest( level.rear_truck.origin , ai );

	target1 = getent( "rpg_target1", "targetname" );	//	BMP
	target2 = getent( "rpg_target2", "targetname" );	//	rear BM21

	ai[0] notify( "end_patrol" );
	ai[0] set_ignoreSuppression( true );
	ai[0] setgoalnode( getnode( "bmp_attack_node", "targetname" ) );
	ai[0] setstablemissile( true );
	ai[0].goalradius = 32;
	ai[0] setentitytarget( target1 );
	ai[0].a.rockets = 1;
	ai[0].maxSightDistSqrd = 8192*8192;
	
	level.bmp thread destroy_rocket_target( ai[0] );
	level.bmp maps\_vehicle::godoff();

	ai[1] notify( "end_patrol" );
	ai[1] set_ignoreSuppression( true );
	ai[1] setgoalnode( getnode( "rear_truck_attack_node", "targetname" ) );
	ai[1] setstablemissile( true );
	ai[1].goalradius = 32;
	ai[1] setentitytarget( target2 );
	ai[1].a.rockets = 1;
	ai[1].maxSightDistSqrd = 8192*8192;

	level.rear_truck thread destroy_rocket_target( ai[1] );
	level.rear_truck maps\_vehicle::godoff();	
}

destroy_rocket_target( ai )
{
	while ( true )
	{
		self waittill( "damage", damage, attacker );
		if ( attacker == ai )
		{
			flag_set( "ambush_start" );
			ai clearenemy();
			ai setthreatbiasgroup( "allies" );
			ai stop_magic_bullet_shield();

			if ( isalive( self ) )
				self notify( "death" );
			break;
		}
	}
}

ambush_price()
{
	wait 8;
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "caravan_inbound1" ] );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "caravan_inbound2" ] );
	wait 2;
	level.price queue_anim( "ambush_pri_copythat" );
	level.price thread queue_anim( "ambush_pri_youknow" );

	level thread ambush_price_leadup();

	flag_wait_either( "ambush_rocket", "ambush_early_start" );

	activate_trigger_with_targetname( "ambush_attack_color_init" );
	level.price thread queue_anim( "ambush_pri_go" );

	flag_wait_or_timeout( "ambush_start", 3 );
	level.price setthreatbiasgroup( "allies" );
	level.player setthreatbiasgroup( "player" );
}

ambush_price_leadup()
{
	level endon( "ambush_early_start" );

	flag_wait( "ambush_badguy_spotted" );

	level.price queue_anim( "ambush_pri_thirdfront" );
	level.price queue_anim( "ambush_pri_takealive" );
	level.price queue_anim( "ambush_pri_standby" );
	flag_set( "ambush_rocket" );
}

ambush_mark()
{
	wait 1;
	level.mark pushplayer( true );
	thread add_dialogue_line( "Griggs", level.scr_text[ "mark" ][ "outfit1" ] );
	thread add_dialogue_line( "Griggs", level.scr_text[ "mark" ][ "outfit2" ] );
//	level.mark thread queue_anim( "black_russian" );
	
	flag_wait( "ambush_rocket" );

	ent = getent( "ambush_mark_target", "targetname" );
	level.mark setentitytarget( ent );

	flag_wait_or_timeout( "ambush_start", 6 );

	level.mark clearenemy();

	// make group1 hate group2 
	setthreatbias( "group2", "group1", 100000 );

	level.mark setthreatbiasgroup( "group1" );

	ai = get_ai_group_ai( "mark_targets" );
	for( i = 0 ; i < ai.size ; i ++ )
	{
		ai[i] setthreatbiasgroup( "group2" );
	}

	flag_wait( "ambush_tower_fall" );
	level.mark setthreatbiasgroup( "oblivious" );

	level.mark set_run_anim( "sprint" );

	flag_wait( "ambush_recovered" );
	level.mark setthreatbiasgroup( "allies" );
}

ambush_setup()
{
	wait 3;
	level notify( "putout_fires" );
	thread maps\_utility::set_ambient("exterior_norain");

	ent = getent( "player_outofsight", "targetname" );
	level.player setorigin ( ent.origin );
	level.player setplayerangles ( ent.angles );
	wait 1;

	node = getnode( "startnodeprice_ambush", "targetname" );
	level.price teleport ( node.origin, node.angles );
	level.price setthreatbiasgroup( "oblivious" );

	node = getnode( "startnodemark_ambush", "targetname" );
	level.mark teleport ( node.origin, node.angles );
	level.mark setthreatbiasgroup( "oblivious" );

	node = getnode( "startnodesteve_ambush", "targetname" );
	level.steve teleport ( node.origin, node.angles );
	level.steve setthreatbiasgroup( "oblivious" );

	node = getnode( "startnodeplayer_ambush", "targetname" );
	level.player setorigin ( node.origin );
	level.player setplayerangles ( node.angles + (13,0,0) );
	level.player setthreatbiasgroup( "oblivious" );

	ambush_setup_enemy_allies();

	activate_trigger_with_targetname( "ambush_setup_color_init" );

	if ( level.player HasWeapon( "remington700" ) )
	{
		level.player takeweapon( "remington700" );
		level.player giveweapon( "rpd" );
		level.player switchToWeapon( "rpd" );
	}

	level.player setViewmodel( "viewhands_op_force" );
	level.player disableweapons();

	delete_dropped_weapons();
	clearallcorpses();

	getent( "gate_open", "targetname" ) show();
	getent( "gate_closed", "targetname" ) hide();

	thread maps\_weather::rainNone( 0 );
	setExpFog(2000, 5500, .462618, .478346, .455313, 0);
	VisionSetNaked( "ambush", 0 );

	wait 3;

	flag_set( "takeover_fade_clear" );
	setsaveddvar( "sm_sunsamplesizenear", 0.6 );

	flag_wait( "takeover_fade_done" );

	level.player enableweapons();
}

ambush_setup_enemy_allies()
{
	level.names_copies = [];

	// delete generic allies
	generic = get_generic_allies(); 
	for ( i=0; i < generic.size; i++ )
	{
		level.names_copies[ level.names_copies.size ] = generic[i].name;
		generic[i] notify( "disable_reinforcement" );
		generic[i] delete();
	}

	waittillframeend;

	array_thread( getentarray( "ambush_allied_axis", "targetname" ), ::add_spawn_function, ::ambush_allied_axis_spawnfunc );
	scripted_array_spawn( "ambush_allied_axis", "targetname", true );

	array_thread( getentarray( "ambush_allied", "targetname" ), ::add_spawn_function, ::ambush_allied_spawnfunc );
	scripted_array_spawn( "ambush_allied", "targetname", true );

}

ambush_allied_axis_spawnfunc()
{
	self setthreatbiasgroup( "oblivious" );
	self.pacifist = true;
	self.a.lastshoottime = gettime();
	self.team = "allies";
	self.voice = "russian";
	self set_battlechatter( false );
	self.ignoreme = true;
	self.maxSightDistSqrd = 4;
	self.no_ir_beacon = true;
	self thread magic_bullet_shield();

	if ( isdefined( self.script_noteworthy ) && self.script_noteworthy == "delay_guy" )
		self thread ambush_delay();

	if ( level.names_copies.size > 0 )
	{
		self.name = level.names_copies[ level.names_copies.size - 1 ];
		level.names_copies = array_remove( level.names_copies, self.name );
	}
	else
		self maps\_names::get_name();

	self thread generic_allied();

	flag_wait( "ambush_rocket" );
	flag_wait_or_timeout( "ambush_start", 6 );

	if ( !isdefined( self.script_aigroup ) || self.script_aigroup != "rocket_man" )
		self stop_magic_bullet_shield();

	self.pacifist = false;
	self.ignoreme = false;
	self.maxSightDistSqrd = 8192*8192;

	if ( self.script_aigroup == "ground_man_upper" )
	{
		self setthreatbiasgroup( "allies" );
		self set_force_color( "r" );
	}
	if ( self.script_aigroup == "ground_man_lower" )
	{
		self setthreatbiasgroup( "allies" );
		self set_force_color( "c" );
	}
}

ambush_steve()
{
	level endon( "ambush_early_start" );
	level thread ambush_steve_fight();

	level.steve set_goalnode( getnode( "steve_ambush_node", "targetname" ) );

	flag_wait( "ambush_vehicles_inplace" );
	level.steve thread maps\_patrol::patrol( "caravan_walkby" );

	ent = getent( "badguy_spotted", "script_noteworthy" );
	ent waittill( "trigger" );

	level.steve queue_anim( "ambush_gaz_visualtarget" );
	flag_set( "ambush_badguy_spotted" );
}

ambush_steve_fight()
{
	flag_wait( "ambush_rocket" );
	level.steve notify( "end_patrol" );
	level.steve set_force_color( "c" );
	wait 4;
	level.steve setthreatbiasgroup( "allies" );

	flag_wait( "ambush_rear_bmp_destroyed" );
	wait 3;
	level.steve queue_anim( "ambush_gaz_gotcompany" );
}

ambush_delay()
{
	self endon( "death" );

	vnode = getvehiclenode( "delay_node", "script_noteworthy" );
	vnode waittill( "trigger" );

	wait 1.5;

	self maps\_patrol::patrol( "delay_path" );

	flag_wait( "ambush_vehicles_inplace" );
	level thread ambush_delay_dialogue();

	flag_wait( "ambush_rocket" );
//	flag_wait_or_timeout( "ambush_start", 2 );
	wait .5;

	ent = getent( "delay_fire_target", "targetname" );
	self setentitytarget( ent );
	self.maxSightDistSqrd = 8192*8192;

	wait 1;

	self clearenemy();
	self set_force_color( "c" );

	wait 5;
	self setthreatbiasgroup( "allies" );

}

ambush_delay_dialogue()
{
	level endon( "ambush_start" );

	iprintln( level.scr_text[ "generic" ][ "delaying1" ] );
	wait 2;
	iprintln( level.scr_text[ "enemy" ][ "background1" ] );
	wait 4;
	iprintln( level.scr_text[ "enemy" ][ "background2" ]);
	wait 4;
	iprintln( level.scr_text[ "enemy" ][ "background3" ]);
	wait 5;
	iprintln( level.scr_text[ "generic" ][ "delaying2" ] );
}

ambush_allied_spawnfunc()
{
	self endon( "death" );

	self setthreatbiasgroup( "oblivious" );

	flag_wait( "ambush_rocket" );

	self setthreatbiasgroup( "allies" );
}

ambush_tower_fall()
{
	guard_tower = getent( "guard_tower", "targetname" );
	parts = getentarray( "guard_tower_part", "targetname" );
	for( i = 0 ; i < parts.size ; i ++ )
	{
		parts[i] linkto( guard_tower );
	}

	guard_tower_d = getentarray( "guard_tower_d", "targetname" );

	array_thread( guard_tower_d, ::ambush_tower_swap );

	vnode = getvehiclenode( "tower_collision", "script_noteworthy" );
	vnode waittill( "trigger" );

	level.mark linkto( guard_tower );
	guard_tower playsound( "ambush_car_crash" );

	flag_set( "ambush_tower_fall" );

	guard_tower rotateto( ( 0,20,90 ), 1.7, 1.7, 0 );
	wait 1.65;

	level.player playsound( "ambush_tower_crash" );

	level.mark unlink();

	level thread ambush_tower_blackout();

	wait 1;

	for( i = 0 ; i < parts.size ; i ++ )
	{
		parts[i] unlink();
		parts[i] delete();
	}
	guard_tower delete();

	sandbags = getentarray( "guard_tower_sandbags", "targetname" );
	for( i = 0 ; i < sandbags.size ; i ++ )
		sandbags[i] delete();

	flag_set( "ambush_switch_tower" );
}

ambush_tower_swap()
{
	self hide();

	if ( self.classname == "script_brushmodel" )
	{
		self connectpaths();
		self notsolid();
	}

	flag_wait( "ambush_switch_tower" );

	if ( self.classname == "script_brushmodel" )
	{
		self solid();
		self disconnectpaths();
	}
	self show();

}

ambush_tower_blackout()
{
	level.player setthreatbiasgroup( "oblivious" );

	black = create_overlay_element( "black", 1 );

	level.player shellshock( "default", 20 );

	ent = getent( "player_outofsight", "targetname" );
	level.player setorigin ( ent.origin );
	level.player setplayerangles ( ent.angles );

	wait 1;

	node = getnode( "startnodemark_village", "targetname" );
	level.mark teleport( node.origin, node.angles );

	player_origin = ( -534, -311, 5 );
	player_angles = ( -15, 40, 0 );

	level.player setorigin( player_origin );
	level.player setplayerangles( player_angles );

	// teleport player and lock him to a view. Same as in aftermath. Even do the view movement.
	level.player setstance( "prone" );

	level.player disableweapons();
	level.player allowstand( false );
	level.player allowcrouch( false );
	level.player freezeControls( true );

	wait 1;

	setsaveddvar( "sm_sunsamplesizenear", level.sm_sunsamplesizenear );

	black fadeovertime( 3 );
	black.alpha = 0;

	thread ambush_recover();
	wait 2;
	level.badguy_jeep notify( "unload", "all" );
	wait 7;

	level.badguy_jeep notify( "death" );
	wait 10;

	black destroy();

	level.player freezeControls( false );
	level.player allowstand( true );
	level.player allowcrouch( true  );

	flag_set( "ambush_recovered" );

	wait 2;
	level.player enableweapons();

	level.player setthreatbiasgroup( "player" );

}

ambush_recover()
{
	ground_ref_ent = spawn( "script_model", (0,0,0) );
	level.player playerSetGroundReferenceEnt( ground_ref_ent );

	// all motion a total of 18.65 seconds
	motion = [];
	motion[0]["angles"] = (7, -50, -10);
	motion[0]["time"] = ( 0, 0, 0);

	motion[1]["angles"] = (-5, 20, 0);
	motion[1]["time"] = ( 3.3, 3.3, 0);

	motion[2]["angles"] = (0, 25, 3);
	motion[2]["time"] = ( 1, 0, 1);

	motion[3]["angles"] = (4, 25, -3);
	motion[3]["time"] = ( 3, 3, 0);

	motion[4]["angles"] = (5, 25, -4);
	motion[4]["time"] = ( 1, 0, 1);

	motion[5]["angles"] = (2, 23, -2);
	motion[5]["time"] = ( 0.65, 0.65, 0);

	// explosion
	motion[6]["angles"] = (20, -20, 15);
	motion[6]["time"] = ( 0.7, 0, .4);

	motion[7]["angles"] = (0, -16, 0);
	motion[7]["time"] = ( 4, 2, 2);

	// running
	motion[8]["angles"] = (10, -60, 0);
	motion[8]["time"] = ( 5, 2, 1);

	for( i = 0 ; i < motion.size ; i ++ )
	{
		angles = adjust_angles_to_player( motion[i]["angles"] );
		time = motion[i]["time"][0];
		acc = motion[i]["time"][1];
		dec = motion[i]["time"][2];

		if ( time == 0)
			ground_ref_ent.angles = angles;
		else
		{
			ground_ref_ent rotateto( angles, time, acc, dec );
			// wait time - (dec/2);
			ground_ref_ent waittill( "rotatedone" );
		}
	}

	ground_ref_ent rotateto( (0,0,0), 1, 0.5, 0.5 );
	ground_ref_ent waittill( "rotatedone" );

	level.player playerSetGroundReferenceEnt( undefined );
}

Main_objective()
{
	objective_trigger = getent( "main_objective", "targetname" );
	objective_add( 4, "active", &"AMBUSH_OBJ_CAPTURE_TARGET", objective_trigger.origin);
	objective_current( 4 );

	while ( isdefined( objective_trigger.target) )
	{
		objective_trigger waittill( "trigger" );

		if ( isdefined( objective_trigger.script_flag_wait ) )
			flag_wait( objective_trigger.script_flag_wait );

		objective_trigger = getent( objective_trigger.target, "targetname" );
		objective_position( 4, objective_trigger.origin);
		objective_Ring( 4 );

		level notify( "main_objective_updated" );
	}
}

aarea_village_init()
{
	// turn village triggers on.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_on );

	getent( "badguy_village", "script_noteworthy" ) add_spawn_function( ::badguy_spawn_function );
	getent( "badguy_village", "script_noteworthy" ) add_spawn_function( ::village_badguy );

	autosave_by_name( "village" );

	level thread village_friendlies();
	level thread village_enemies();
	level thread main_objective();
	level thread village_helicopter();
	level thread village_price();
	level thread village_mark();

	level thread failed_to_pursue();
	
	level thread village_cleanup();

	flag_wait_either( "village_alley", "morpheus_quick_start" );

	level thread aarea_morpheus_init();
}

village_friendlies()
{
	flag_wait( "junkyard_exit" );

	maps\_spawner::kill_spawnerNum( 1 );
	array_delete( getaiarray( "axis" ) );

	generic = get_generic_allies(); 
	for( i = 0 ; i < generic.size ; i ++ )
	{
		generic[i] delete();
	}

	waittillframeend;

	ai = scripted_array_spawn( "village_friendlies", "targetname" );
	array_thread( ai, ::generic_allied );

	level.price teleport( getnode( "village_price_teleport", "targetname").origin );
	level.price set_force_color( "r" );
	level.steve teleport( getnode( "village_steve_teleport", "targetname").origin );
	level.steve set_force_color( "r" );

	array_thread( get_generic_allies(), ::replace_on_death );

	array_thread( level.squad, ::enable_careful );

	trigger = getent( "friendlies_arriving", "targetname" );
	while ( true )
	{
		trigger waittill( "trigger", ent );
		if ( ent != level.mark )
			break;
	}	

	autosave_by_name( "village_attack" );

	add_dialogue_line( "Griggs", level.scr_text[ "mark" ][ "friendlies_six" ] );
//	add_dialogue_line( "Price", level.scr_text[ "price" ][ "sorry_wait" ] );

	flag_wait( "village_retreat" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "keep_alive" ] );

	flag_wait( "village_badguy_escape" );
	add_dialogue_line( "Price", level.scr_text[ "radio" ][ "heli_alley" ] );
	level.price queue_anim( "ambush_pri_goafterhim" );

	flag_set( "village_alley" );
}

village_enemies()
{
	array_thread( getentarray( "village_force", "script_noteworthy" ), ::add_spawn_function, ::village_enemies_spawn_function );

	level thread village_bmp();

	flag_wait( "village_defend" );
	activate_trigger_with_targetname( "village_defend_color_init" );

	ai = get_ai_group_ai( "village_force" );

	flag_wait( "village_retreat" );
	wait 3;
	activate_trigger_with_targetname( "village_retreat_1_color_init" );

	waittill_aigroupcount( "village_force", 4 );

	flag_set( "village_badguy_escape" );

	activate_trigger_with_targetname( "village_retreat_2_color_init" );

	triggers = getentarray( "village_second_force", "script_noteworthy" );
	array_thread( triggers, ::activate_trigger );
}

village_bmp()
{
	bmp = maps\_vehicle::waittill_vehiclespawn( "village_bmp" );
	bmp waittill( "reached_end_node" );
	bmp thread vehicle_turret_think();
}

village_enemies_spawn_function()
{
	self endon( "death" );

	self setthreatbiasgroup( "oblivious" );

	flag_wait( "village_defend" );

	self setthreatbiasgroup( "axis" );
}

village_badguy()
{
	self set_generic_run_anim( "sprint" );
	self.moveplaybackrate = 1.2;

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	flag_wait( "village_approach" );

	level thread set_flag_on_player_action( "village_defend", false, false );

//	thread add_dialogue_line( "badguy", level.scr_text[ "badguy" ][ "my_turf" ] );
//	wait 3;
	flag_set( "village_defend" );
//	thread add_dialogue_line( "badguy", level.scr_text[ "badguy" ][ "enemies_to_kill" ] );
	wait 3;

	setthreatbias( "player", "badguy", 0 );	// badguy nolonger ignore player;
	setthreatbias( "allies", "badguy", 0 );	// badguy nolonger ignore allies;

	node = getnode( "badguy_village_retreat_node", "targetname" );
	self set_goalnode( node );

	waittill_aigroupcount( "village_force", 4 );

	flag_wait( "village_retreat" );

	node = getnode( "badguy_village_delete_node", "targetname" );
	self set_goalnode( node );

	self waittill( "goal" );

	self notify( "stop_death_fail" );
	self delete();
}

village_mark()
{
	//todo: tweak to match dialogue
	activate_trigger_with_targetname( "village_color_init" );

	waittill_aigroupcleared( "junkyard_dog" );
	activate_trigger_with_targetname( "dog_dead_color_init" );

	flag_wait( "village_defend" );
	level.mark clear_run_anim();
}

village_helicopter()
{
	flag_wait( "village_helicopter_greeting" );

	wait 2;

	// 	radio_dialogue( "greetings" );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_greetings1" ] );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_greetings2" ] );
//	iprintlnbold( level.scr_text[ "radio" ][ "heli_greetings" ] );
	wait 6;
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_target_junkyard" ] );
//	iprintlnbold( level.scr_text[ "radio" ][ "heli_target_junkyard" ] );

	flag_wait( "junkyard_exit" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_outskirts" ] );
	flag_wait( "village_road" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_sympatisers" ] );

	
}

village_price()
{
	level endon( "morpheus_quick_start" );

	level.price queue_anim( "ambush_pri_runforit" );
	level.price queue_anim( "ambush_pri_chasehim" );

	flag_set( "village_helicopter_greeting" );
}

village_cleanup()
{
	flag_wait( "morpheus_rpg" );

	level.price stop_magic_bullet_shield();
	level.price notify( "disable_reinforcement" );

	allies = getaiarray( "allies" );
	for( i = 0 ; i < allies.size ; i ++ )
	{
		if ( allies[i] == level.mark || allies[i] == level.steve )
			continue;

		allies[i] notify( "disable_reinforcement" );
		allies[i] delete();
	}

	axis = get_ai_group_ai( "village_force" );
	axis = array_merge( axis, get_ai_group_ai( "village_enemy" ) );
	axis = array_merge( axis, get_ai_group_ai( "village_dog" ) );

	array_delete( axis );
}

aarea_morpheus_init()
{
	autosave_by_name( "morpheus" );

	flag_set( "village_alley" );

	generic = get_generic_allies(); 
	for ( i=0; i < generic.size; i++ )
	{
		generic[i] notify( "disable_reinforcement" );
	}

	level.steve set_force_color( "g" );
	activate_trigger_with_targetname( "morpheus_color_init" );

	morpheus_sets();

	flag_wait( "apartment_start" );
	
	level thread aarea_apartment_init();
}

morpheus_sets()
{
	array_thread( getentarray( "iron_fence_guy", "script_noteworthy" ), ::add_spawn_function, ::morpheus_iron_fence_spawn_function );

	level thread morpheus_dumpster();
	level thread morpheus_iron_fence();
	level thread morpheus_flanker();
	level thread morpheus_rpg();
	level thread morpheus_2nd_floor();
	level thread morpheus_single();
	level thread morpheus_target();
	level thread morpheus_alley();
}

morpheus_completion( completion_notify, dialogue )
{
	level endon( "new_morpheus_set" );

	level waittill( completion_notify );

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ dialogue ] );
}

morpheus_dumpster()
{
	flag_wait( "morpheus_dumpster" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_dumpster_complete", "heli_you_got_them" );

	waittill_aigroupcleared( "dumpster_front_guy" );
	if ( flag( "morpheus_green_car" ) )
		return;

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_dumpster" ] );

	ai = get_ai_group_ai( "dumpster_guy" );
	for( i = 0 ; i < ai.size ; i ++ )
	{
		ai[i] setthreatbiasgroup( "axis" );
	}

	level thread morpheus_dumpster_clear( "morpheus_dumpster_complete" );
	level endon( "morpheus_dumpster_clear" );

	waittill_aigroupcleared( "dumpster_guy" );

	level notify( "morpheus_dumpster_complete" );
}

morpheus_dumpster_clear( completion_notify )
{
	level endon( completion_notify );

	flag_wait( "morpheus_iron_fence" );

	array_thread( get_ai_group_ai( "dumpster_guy" ), ::self_delete );
	level notify( "morpheus_dumpster_clear" );
}

/*
morpheus_green_car()
{
	flag_wait( "morpheus_green_car" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_green_car_complete", "heli_nice_work" );

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_green_car" ] );

	level thread morpheus_green_car_clear( "morpheus_green_car_complete" );
	level endon( "morpheus_green_car_clear" );

	waittill_aigroupcleared( "green_car" );
	level notify( "morpheus_green_car_complete" );
}

morpheus_green_car_clear( completion_notify )
{
	level endon( completion_notify );
	wait 10;
	level notify( "morpheus_green_car_clear" );
}
*/

morpheus_iron_fence()
{
	flag_wait( "morpheus_iron_fence" );
	level notify( "new_morpheus_set" );

//	autosave_by_name( "iron_fence" );

	level thread morpheus_completion( "morpheus_iron_fence_complete", "heli_nicely_done" );

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_yard" ] );

	level thread morpheus_iron_fence_fight();

	flag_wait( "morpheus_iron_fence_fight" );

	activate_trigger_with_targetname( "iron_fence_color_init" );
}

morpheus_iron_fence_fight()
{
	level endon( "morpheus_iron_fence_fight" );

	level thread set_flag_on_player_action( "morpheus_iron_fence_fight", true, true);

	trigger = getent( "fight_timeout_trigger", "targetname" );
	trigger waittill( "trigger" );

	trigger = getent( "fight_trigger", "targetname" );
	trigger wait_for_trigger_or_timeout( 2.5 );

	flag_set( "morpheus_iron_fence_fight" );
}

morpheus_iron_fence_spawn_function()
{
	if ( flag( "morpheus_iron_fence_fight" ) )
		return;

	self setthreatbiasgroup( "oblivious" );
	self.fixednode = true;

	flag_wait( "morpheus_iron_fence_fight" );

	randomfloatrange( 0.5, 1.5 );

	self setthreatbiasgroup( "axis" );
	self.fixednode = false;
}

morpheus_flanker()
{
	flag_wait( "morpheus_flanker" );
	level notify( "new_morpheus_set" );

	if ( !get_ai_group_count( "flanker" ) )
		return;

	flag_wait( "morpheus_iron_fence_fight" );

	level thread morpheus_completion( "morpheus_flanker_complete", "heli_you_got_them" );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_flank_right" ] );

	level thread morpheus_flanker_clear( "morpheus_flanker_complete" );
	level endon( "morpheus_flanker_clear" );

	wait 1;
	activate_trigger_with_targetname( "morpheus_flanker_color_init" );

	waittill_aigroupcleared( "flanker" );
	level notify( "morpheus_flanker_complete" );
}

morpheus_flanker_clear( completion_notify )
{
	level endon( completion_notify );
	wait 10;
	level notify( "morpheus_flanker_clear" );
}

morpheus_rpg()
{
	flag_wait( "morpheus_rpg" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_rpg_complete", "heli_nice_work" );

	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_roof" ] );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_rpg_roof" ] );

	level thread morpheus_rpg_clear( "morpheus_rpg_complete" );
	level endon( "morpheus_rpg_clear" );

	waittill_aigroupcleared( "roof_guy" );
	level notify( "morpheus_rpg_complete" );
}

morpheus_rpg_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_rpg_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "roof_guy" ), ::self_delete );
	level notify( "morpheus_rpg_clear" );
}

morpheus_2nd_floor()
{
	flag_wait( "morpheus_2nd_floor" );

	level notify( "new_morpheus_set" );

	activate_trigger_with_targetname( "roof_guy_spawn_trigger" );

	level thread morpheus_completion( "morpheus_2nd_floor_complete", "heli_you_got_them" );

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_second_floor" ] );

	level thread morpheus_2nd_floor_clear( "morpheus_2nd_floor_complete" );
	level endon( "morpheus_2nd_floor_clear" );

	waittill_aigroupcleared( "roof_guy" );
	level notify( "morpheus_2nd_floor_complete" );
}

morpheus_2nd_floor_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_rpg_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "floor_guy" ), ::self_delete );
	level notify( "morpheus_2nd_floor_clear" );
}

morpheus_single()
{
	flag_wait( "morpheus_single" );

//	autosave_by_name( "morpheus_single" );

	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_single_complete", "heli_all_clear" );

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_overturned" ] );

	level thread morpheus_single_clear( "morpheus_single_complete" );
	level endon( "morpheus_single_clear" );

	waittill_aigroupcleared( "single_guy" );
	level notify( "morpheus_single_complete" );
}

morpheus_single_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_single_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "single_guy" ), ::self_delete );
	level notify( "morpheus_single_clear" );
}

morpheus_target()
{
	flag_wait( "morpheus_target" );
	level notify( "new_morpheus_set" );

	waittill_aigroupcleared( "single_guy" );
	flag_wait( "morpheus_target_moving" );
	
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_target" ] );

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	badguy = scripted_spawn( "badguy_runby", "targetname" );
	badguy badguy_spawn_function();

	badguy.moveplaybackrate = 0.64;
	
	badguy waittill( "goal" );

	badguy notify( "stop_death_fail" );
	badguy delete();
}

morpheus_alley()
{
	flag_wait( "morpheus_alley" );
	level notify( "new_morpheus_set" );

	level thread morpheus_completion( "morpheus_alley_complete", "heli_all_clear" );

	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_alley_left" ] );

	level thread morpheus_alley_clear( "morpheus_alley_complete" );
	level endon( "morpheus_alley_clear" );

	flag_wait( "morpheus_green_car" );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_green_car" ] );

	waittill_aigroupcleared( "alley_guy" );
	level notify( "morpheus_alley_complete" );
}

morpheus_alley_clear( completion_notify )
{
	level endon( completion_notify );

	trigger = getent( "morpheus_alley_clear", "targetname" );
	trigger waittill( "trigger" );

	array_thread( get_ai_group_ai( "alley_guy" ), ::self_delete );
	level notify( "morpheus_alley_clear" );
}

aarea_apartment_init()
{
//	autosave_by_name( "apartment" );

	// no axis left alive.
	axis = getaiarray( "axis" );
	array_delete( axis );

	level thread apartment_dialogue();
	level thread apartment_badguy();
	level thread apartment_friendlies();

	level thread apartment_mg_nest();

	level thread apartment_helicopter();

	level thread apartment_mg_nest_2();

	level thread apartment_suicide();

	flag_wait( "apartment_inside" );
	autosave_by_name( "inside" );

	flag_wait( "apartment_mg_4th_flr" );
	autosave_by_name( "4th_floor" );

	flag_wait( "apartment_roof" );
	autosave_by_name( "roof" );

	flag_wait( "mission_done" );
	missionsuccess( "icbm", false );

}

apartment_helicopter()
{
	flag_wait( "apartment_heli_attack" );

	maps\_spawner::kill_spawnerNum( 6 );

	aim_path_start = getent( "heli_mg_nest_aim_point", "targetname" );
	level.helicopter thread apartment_helicopter_turret( aim_path_start, undefined, 300 );

	struct = getstruct( "helicopter_fire", "script_noteworthy" );
	struct waittill( "trigger" );
	flag_set( "apartment_heli_firing" );

	ent = getent( "mg_destroyed", "script_noteworthy" );
	ent waittill( "trigger" );
	wait 1;
	flag_set( "apartment_mg_destroyed" );

	flag_clear( "apartment_heli_firing" );
	flag_wait( "apartment_mg_4th_flr" );

	aim_path_start = getent( "heli_mg_nest_aim_point_2", "targetname" );
	level.helicopter thread apartment_helicopter_turret( aim_path_start, true, 100 );

	wait 4;
	flag_set( "apartment_heli_firing" );

	maps\_spawner::kill_spawnerNum( 7 );

	ent = getent( "mg_destroyed_2", "script_noteworthy" );
	ent waittill( "trigger" );
	wait 1;

	flag_set( "apartment_mg_destroyed_2" );

	waittill_aigroupcleared( "fourthfloor_guy" );
	flag_set( "apartment_clear" );

	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_threat" ] );
}

apartment_helicopter_turret( aim_path_start, otherside, ups )
{
	// todo: spawn in a guy to man the mg.

    turret = spawnturret( "misc_turret", (0,0,0), "heli_minigun_noai" );
    turret setmodel( "cod3mg42" );
	turret.team = "allies";

	if ( isdefined( otherside ) )
	    turret linkto( level.helicopter, "tag_detach", ( 0, 120, 0 ), ( 0, 0, 0 ) );
	else
	    turret linkto( level.helicopter, "tag_detach", ( 0, 12, 0 ), ( 0, 0, 0 ) );


    turret maketurretunusable();
    turret setmode( "manual" ); //"auto_ai", "manual", "manual_ai" and "auto_nonai"
    turret setturretteam( "allies" );

	// make it aim ahead of time at the first target.

	aim_point = aim_path_start;
	aim_ent = spawn( "script_origin", aim_point.origin );
	turret settargetentity( aim_ent );
	turret.target_ent = aim_ent;

	flag_wait( "apartment_heli_firing" );

	turret thread manual_mg_fire( 6, 0.5, 3 );
	turret startfiring();

	turret apartment_helicopter_turret_mg_nest( aim_point, aim_ent, ups );

	turret notify( "stop_firing" );
	turret stopfiring();

	turret delete();
}

apartment_helicopter_turret_mg_nest( aim_point, aim_ent, ups )
{
	while ( isdefined( aim_point.target) )
	{
		aim_point = getent( aim_point.target, "targetname" );
		dist = distance( aim_point.origin, aim_ent.origin );
		move_time = dist/ups;
		aim_ent moveto( aim_point.origin, move_time );
		aim_ent waittill( "movedone" );
		aim_point notify( "trigger" );
		aim_point script_delay();
	}

	if ( !flag( "apartment_inside" ) )
		aigroup = "fifthfloor_guy";
	else
		aigroup = "fourthfloor_guy";

	axis = get_ai_group_ai( aigroup );

	while ( isdefined( axis ) && axis.size )
	{
		self settargetentity( axis[0] );
		axis[0] waittill( "death" );
		axis = get_ai_group_ai( aigroup );
	}
}

apartment_friendlies()
{
	flag_wait( "apartment_mg_destroyed" );

	activate_trigger_with_targetname( "apartment_entry_color_init" );
}

apartment_badguy()
{
	flag_wait( "apartment_badguy_run" );

	badguy = scripted_spawn( "badguy_apartment", "targetname" );
	level.badguy = badguy;
	badguy badguy_spawn_function();

	badguy notify( "stop_proximity_kill" );

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	flag_wait( "apartment_mg_destroyed" );
	badguy set_goalnode( getnode( "badguy_attack_node", "targetname" ) );

	flag_wait( "apartment_badguy_attack" );

	setthreatbias( "player", "badguy", 0 );	// badguy nolonger ignore player;
	setthreatbias( "allies", "badguy", 0 );	// badguy nolonger ignore allies;
	wait 1;

	setignoremegroup( "allies", "badguy" );	// badguy ignore allies;
	setignoremegroup( "player", "badguy" );	// badguy ignore player;

	badguy set_goalnode( getnode( "badguy_third_floor_node", "targetname" ) );

	flag_wait( "apartment_badguy_3rd_flr" );

	badguy set_goalnode( getnode( "badguy_4th_floor_node", "targetname" ) );

	flag_wait( "apartment_roof" );
	badguy set_goalnode( getnode( "badguy_roof_node", "targetname" ) );

}

apartment_dialogue()
{
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_building" ] );
	wait 3;
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_targer_visual" ] );
	wait 2;

	flag_wait_or_timeout( "apartment_badguy_run", 5 );
	activate_trigger_with_noteworthy( "spawn_mg_nest_ai" );
	flag_set( "apartment_fire");

//	thread add_dialogue_line( "Steve", level.scr_text[ "steve" ][ "target_visual" ] );
	level.steve queue_anim( "ambush_gaz_fivestory" );
//	thread add_dialogue_line( "Steve", level.scr_text[ "steve" ][ "heavy_fire" ] );
	level.steve queue_anim( "ambush_gaz_heavyfire" );

	flag_set( "apartment_heli_attack" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_heavy_fire" ] );

	flag_wait( "apartment_mg_destroyed" );
	wait 2;
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_threat" ] );

	flag_wait( "apartment_badguy_attack" );
	wait 6;
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_target_second_floor" ] );

	flag_wait( "apartment_badguy_attack" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_staircase" ] );

	flag_wait( "apartment_mg_4th_flr" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_deeper" ] );

	flag_wait( "apartment_mg_destroyed_2" );
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_threat" ] );

	flag_wait( "apartment_roof" );
	thread add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_movement_roof" ] );
	wait 3;
	add_dialogue_line( "Heli", level.scr_text[ "radio" ][ "heli_confirmed_roof" ] );
}

apartment_mg_nest()
{
	mg = getent( "apartment_manual_mg", "targetname" );
	mg.team = "axis";

	kill_trigger = getent( "mg_player_kill", "targetname" );
	zone_trigger = getent( "mg_player_target", "targetname" );
	mg thread apartment_mg_killzone( kill_trigger, zone_trigger, "apartment_mg_destroyed" );

	damage_trigger = getent( "mg_nest_damage_trigger", "targetname" );
	level thread apartment_mg_nest_player_damage( "apartment_mg_destroyed", damage_trigger, 600 );

	sandbags = getentarray( "sandbag", "targetname" );
	array_thread( sandbags, ::apartment_mg_nest_sandbag );

	flag_wait( "apartment_fire");

	mg thread manual_mg_fire( 3, 1 );
	mg thread apartment_mg_nest_heli();

	flag_wait( "apartment_mg_destroyed" );

	mg notify( "stop_targeting" );
	mg notify( "stop_firing" );

	fake_mg = spawn( "script_model", mg.origin );
	fake_mg.angles = mg.angles;
	fake_mg setmodel( mg.model );

	mg hide();

	wait 0.9;
	fake_mg physicslaunch( fake_mg.origin + ( 0,-50,0 ), (0,600,0) );
}

apartment_mg_nest_heli()
{
	level endon( "apartment_mg_destroyed" );
	flag_wait( "apartment_heli_firing" );

	wait 2;

	self notify( "stop_targeting" );
	self settargetentity( level.helicopter );
}

apartment_mg_nest_player_damage( flag_to_set, trigger, health )
{
	while( true )
	{
		trigger waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName );
		if ( attacker != level.player )
			continue;

		if ( damage < 100 )
			damage -= 50;
		else
			damage -= 10;
		health -= damage;

		if ( health < 0 )
			break;
	}

	flag_set( flag_to_set );
}

apartment_mg_nest_sandbag()
{
	flag_wait( "apartment_mg_destroyed" );

	self script_delay();
	self physicslaunch( self.origin + ( 0,-10,0 ), (0,1500,200) );
}

apartment_mg_nest_2()
{
	mg = getent( "apartment_manual_mg_2", "targetname" );
	mg.team = "axis";

	kill_trigger = getent( "mg_player_kill_2", "targetname" );
	zone_trigger = getent( "mg_player_target_2", "targetname" );
	mg thread apartment_mg_killzone( kill_trigger, zone_trigger, "apartment_mg_destroyed_2" );

	damage_trigger = getent( "mg_nest_damage_trigger_2", "targetname" );
	level thread apartment_mg_nest_player_damage( "apartment_mg_destroyed_2", damage_trigger, 450 );

	getent( "nest_2_clip", "targetname" ) delete();

	ent = getent( "mg_nest_2_explosion", "targetname" );
	nest_2 = getentarray( "nest_2", "targetname" );
	array_thread( nest_2, ::apartment_mg_nest_2_explosion, ent.origin );

	flag_wait( "apartment_mg_4th_flr");

	mg thread manual_mg_fire( 4, 0.8 );

	flag_wait( "apartment_mg_destroyed_2" );

	mg notify( "stop_targeting" );
	mg notify( "stop_firing" );

	wait 0.5;
	mg delete();
	
}

apartment_mg_nest_2_explosion( explosion_origin )
{
	flag_wait( "apartment_mg_destroyed_2" );

	playfx( level._effect["mg_nest_expl"], explosion_origin );

	vector = self.origin - explosion_origin;
	force = vector * 800;

	if ( IsSubStr( self.model, "metal" ) )
		force = force/10;

	self physicslaunch( explosion_origin, force );
}

apartment_mg_killzone( kill_trigger, zone_trigger, ender )
{
	level endon( ender );
	level endon( "mg_player_kill" );

	kill_trigger thread apartment_mg_kill( self, ender );

	while ( true )
	{
		self shoot_mg_targets();
		zone_trigger waittill( "trigger" );

		self notify( "stop_targeting" );
		self settargetentity( level.player );
		while ( level.player istouching( zone_trigger ) ) 
			wait 0.5;
	}
}

apartment_mg_kill( mg, ender )
{
	level endon( ender );

	level.player endon( "death" );
	self waittill( "trigger" );

	level notify( "mg_player_kill" );

	level.player EnableHealthShield( false );
	while ( true )
	{
		level.player dodamage( level.player.health * 2.5 , mg.origin );
		wait 0.05;
	}
}

apartment_suicide()
{
	flag_wait( "apartment_roof" );
	scripted_array_spawn( "roof_runners", "targetname", true );

	flag_wait( "apartment_stairs" );

	level.badguy animscripts\shared::placeWeaponOn( level.badguy.secondaryweapon, "right" );

	level.price = scripted_spawn( "roof_price", "targetname", true );
	level.price thread magic_bullet_shield();
	level.price.animname = "price";
	level.price thread squad_init();
	level.price.name = "Cpt. Price";

	actors = [];
	actors[0] = level.price;
	actors[1] = level.badguy;

	anim_ent = getent( "roof_anim_ent", "targetname" );

	anim_ent anim_first_frame( actors, "jump" );

	flag_wait( "apartment_suicide" );
	anim_ent anim_single( actors, "jump" );

	level.price queue_anim( "ambush_pri_2isdead" );
	level.steve queue_anim( "ambush_gaz_onlylead" );
	level.price queue_anim( "ambush_pri_knowtheman" );

	flag_set( "mission_done" );
}

/**********/

failed_to_pursue()
{
	array_thread( getentarray( "failed_to_pursue", "targetname" ), ::failed_to_pursue_trigger );

	level thread failed_to_pursue_timer( 120 ); // 60
	flag_wait( "junkyard_exit" );
	level notify( "made the time" );

	autosave_by_name( "junkyard_exit" );

	level thread failed_to_pursue_timer( 30 ); // 15
	flag_wait( "village_road" );
	level notify( "made the time" );

	autosave_by_name( "village_road" );

	flag_wait( "village_alley" );

	level thread failed_to_pursue_timer( 120 ); // 60
	flag_wait( "morpheus_iron_fence" );
	level notify( "made the time" );

	autosave_by_name( "morpheus_iron_fence" );

	level thread failed_to_pursue_timer( 360 ); // 180
	flag_wait( "morpheus_single" );
	level notify( "made the time" );

	autosave_by_name( "morpheus_single" );

	level thread failed_to_pursue_timer( 120 ); // 60
	flag_wait( "apartment_start" );
	level notify( "made the time" );

	autosave_by_name( "apartment_start" );

}

failed_to_pursue_timer( failtime )
{
	level endon( "made the time" );

	failtime = gettime() + ( failtime * 1000 );

	while( failtime > gettime() )
		wait 1;

	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_ESCAPED" );
	maps\_utility::missionFailedWrapper();
}

failed_to_pursue_trigger()
{
	self waittill( "trigger" );

	level notify( "made the time" );

	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_ESCAPED" );
	maps\_utility::missionFailedWrapper();
}

/**** badguy generic functions ****/

badguy_spawn_function()
{
	self.name = "V. Zakhaev";
	self.animname = "badguy";

	self set_battlechatter( false );

	self setthreatbiasgroup( "badguy" );
	self.fixednode = true;

	self thread badguy_died();
	self thread badguy_proximity_kill();

	self set_ignoreSuppression( true );
	self.a.disablePain = true;
	self.grenadeawareness = 1;
	self setFlashbangImmunity( true );
}

badguy_died()
{
	self endon( "stop_death_fail" );

	self.health = self.health * 3;

	self waittill( "death" );
	setdvar( "ui_deadquote", "@AMBUSH_MISSIONFAIL_KILLED_TARGET" );
	maps\_utility::missionFailedWrapper();
}

badguy_proximity_kill()
{
	// will try to kill the player if he gets to close.

	self  endon( "stop_proximity_kill" );
	level.player endon( "death" );
	self endon( "death" );

	old_accuracy = self.baseAccuracy;

	while( true )
	{
			while( distance2d( level.player.origin, self.origin ) > 350 )
				wait 0.1;

			self.baseAccuracy = self.baseAccuracy * 10;

			// make badguy hate player
			setthreatbias( "player", "badguy", 100000 );

			while( distance2d( level.player.origin, self.origin ) < 400 )
				wait 0.1;

			self.baseAccuracy = old_accuracy;
			// make group1 hate group2 
			setthreatbias( "player", "badguy", 0 );
	}
}

/******* start points *******/ 

start_default()
{
	aarea_takeover_init();
}

start_ambush()
{
	// turn old triggers off.
	array_thread( getentarray( "takeover_trigger", "script_noteworthy" ) , ::trigger_off );

	// turn village triggers off.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_off );

	setup_friendlies( 3 );
	start_teleport_squad( "ambush" );

	blocker = getent( "takeout_path_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	getent( "gate_open", "targetname" ) hide();
	getent( "rear_blocker_open", "targetname" ) hide();

	level thread guardtower_dead_enemies();
	flag_set( "takeover_fade_clear" );
	flag_set( "takeover_fade_done" );

	aarea_ambush_init();
}

start_village()
{
	setup_friendlies( 3 );
	start_teleport_squad( "village" );

	thread maps\_weather::rainNone( 0 );

	level.player setthreatbiasgroup( "player" );

	activate_trigger_with_targetname( "ambush_attack_color_init" );

	// turn old triggers off.
	array_thread( getentarray( "takeover_trigger", "script_noteworthy" ) , ::trigger_off );

	// turn village triggers off.
	array_thread( getentarray( "village_trigger", "script_noteworthy" ) , ::trigger_off );

	blocker = getent( "takeout_path_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	blocker = getent( "rear_blocker", "targetname" );
	blocker connectpaths();
	blocker delete();

	guard_tower = getent( "guard_tower", "targetname" );
	parts = getentarray( "guard_tower_part", "targetname" );
	for( i = 0 ; i < parts.size ; i ++ )
		parts[i] delete();
	guard_tower delete();
	sandbags = getentarray( "guard_tower_sandbags", "targetname" );
	for( i = 0 ; i < sandbags.size ; i ++ )
		sandbags[i] delete();

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( "village_heli_start", "targetname" );
	level.helicopter thread heli_path_speed( struct );

	aarea_village_init();
}

start_morpheus()
{
	setup_friendlies( 0 );
	start_teleport_squad( "morpheus" );

	thread maps\_weather::rainNone( 0 );

	level.player setthreatbiasgroup( "player" );

	activate_trigger_with_targetname( "village_retreat_2_color_init" );

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( "apartment_heli_start", "targetname" );
	level.helicopter thread heli_path_speed( struct );

	aarea_morpheus_init();
}

start_apartment()
{
	setup_friendlies( 0 );
	start_teleport_squad( "apartment" );

	thread maps\_weather::rainNone( 0 );

	level.player setthreatbiasgroup( "player" );

	level.steve set_force_color( "g" );

	activate_trigger_with_targetname( "apartment_color_init" );

	level.helicopter = maps\_vehicle::spawn_vehicle_from_targetname( "blackhawk" );
	struct = getstruct( "apartment_heli_start", "targetname" );
	level.helicopter thread heli_path_speed( struct );

	flag_wait( "apartment_start" );

	aarea_apartment_init();
}

/********* setup and utilities *********/

setup_friendlies( extras )
{
	if ( !isdefined( extras ) )
		extras = 0;

	level.squad = [];

	level.price = scripted_spawn( "price", "targetname", true );
	level.price thread magic_bullet_shield();
	level.price.animname = "price";
	level.price thread squad_init();
	level.price.name = "Cpt. Price";

	level.mark = scripted_spawn( "mark", "targetname", true );
	level.mark.script_bcdialog = false;
	level.mark thread magic_bullet_shield();
	level.mark.animname = "mark";
	level.mark thread squad_init();
	level.mark.battlechatter = false;
	level.mark.name = "Sgt. Griggs";

	level.steve = scripted_spawn( "steve", "targetname", true );
	level.steve thread magic_bullet_shield();
	level.steve.animname = "steve";
	level.steve.name = "Gaz";
	level.steve thread squad_init();

	getent( "kamarov", "script_noteworthy" ) add_spawn_function( ::kamarov );

	allied_spawner = getentarray( "allies", "targetname" );

	for ( i=0; i<extras; i++ )
	{
		ai = scripted_spawn( undefined, undefined, true, allied_spawner[i] );
		ai generic_allied();
	}

	// add spaw function to replacement guy spawners
	array_thread( getentarray( "color_spawner", "targetname" ), ::add_spawn_function, ::generic_allied );
}

kamarov()
{
	self.name = "Sgt. Kamarov";
	self.health = 10000;
}

squad_init()
{
	level.squad[ level.squad.size ] = self;
	self waittill( "death" );
	level.squad = array_remove( level.squad, self );
}

generic_allied()
{
	self.animname = "generic";
	self thread squad_init();
}

get_generic_allies()
{
	ai = [];
	for( i = 0 ; i < level.squad.size ; i ++ )
	{
		if ( level.squad[i].animname == "generic" )
			ai[ ai.size ] = level.squad[i];
	}
	return ai;
}

scripted_spawn( value, key, stalingrad, spawner )
{
	if ( !isdefined( spawner ) )
		spawner = getent( value, key );

//	assertEx( isdefined( spawner ), "Spawner with " + key + " / " + value + " does not exist." );
	
	if ( isdefined( stalingrad ) )
		ai = spawner stalingradSpawn();
	else
		ai = spawner dospawn();
	spawn_failed( ai );
	assert( isDefined( ai ) );
	return ai;
}

scripted_array_spawn( value, key, stalingrad )
{
	spawner = getentarray( value, key );
	ai = [];

	for ( i=0; i<spawner.size; i++ )
		ai[i] = scripted_spawn( value, key, stalingrad, spawner[i] );
	return ai;
}

start_teleport_squad( startname )
{
	node = getnode( "startnodeplayer_"+ startname, "targetname" );
	level.player setorigin ( node.origin );
	level.player setplayerangles ( node.angles );

	for ( i=0; i<level.squad.size; i++ )
	{
		level.squad[i] notify( "stop_going_to_node" );
		nodename = "startnode" + level.squad[i].animname + "_" + startname;
		node = getnodearray( nodename, "targetname" );
		level.squad[i] start_teleport( node );
	}
}

start_teleport( node )
{
	if ( node.size > 1 )
	{
		for ( i=0; i<node.size; i++ )
		{
			if ( isdefined( node[i].teleport_used ) )
				continue;
			node = node[i];
			break;
		}
	}
	else
		node = node[0];

	node.teleport_used = true;

	self teleport ( node.origin, node.angles );
	self setgoalpos ( self.origin );
	self.goalradius = node.radius;
	self setgoalnode ( node );
}

delete_dropped_weapons()
{
	wc = [];
	wc = array_add( wc, "weapon_ak47" );
	wc = array_add( wc, "weapon_beretta" );
	wc = array_add( wc, "weapon_g36c" );
	wc = array_add( wc, "weapon_m14" );
	wc = array_add( wc, "weapon_m16" );
	wc = array_add( wc, "weapon_m203" );
	wc = array_add( wc, "weapon_rpg" );
	wc = array_add( wc, "weapon_saw" );
	wc = array_add( wc, "weapon_m4" );
	wc = array_add( wc, "weapon_m40a3" );
	wc = array_add( wc, "weapon_mp5" );
	wc = array_add( wc, "weapon_mp5sd" );
	wc = array_add( wc, "weapon_usp" );
	wc = array_add( wc, "weapon_at4" );
	wc = array_add( wc, "weapon_dragunov" );
	wc = array_add( wc, "weapon_g3" );
	wc = array_add( wc, "weapon_uzi" );

	for( i = 0 ; i < wc.size ; i ++ )
	{
		weapons = getentarray( wc[i], "classname" );
		for( n = 0 ; n < weapons.size ; n ++ )
		{
			weapons[n] delete();
		}
	}
}

shoot_mg_targets()
{
	self endon( "stop_targeting" );

	self setmode( "manual" );
	self setbottomarc( 60 );
	self setleftarc( 60 );
	self setrightarc( 60 );

	all_targets = getentarray( self.target, "targetname" );
	all_targets = array_add( all_targets, level.player );

	target = undefined;

	while ( true )
	{
		if ( isdefined( target ) )
			excl[0] = target;
		else
			excl = undefined;
	
		// get_array_of_closest( org, array, excluders, max, maxdist )
		targets = get_array_of_closest( level.player.origin, all_targets, excl, 3);
		target = random( targets );
		self settargetentity( target );
		wait( randomfloatrange( 1, 3 ) );
	}
}

manual_mg_fire( burst, cooldown, extra_bullets )
{
	self endon( "stop_firing" );
	self.turret_fires = true;

	if ( !isdefined( extra_bullets ) )
		extra_bullets = 0;
	
	for ( ;; )
	{
		timer = randomfloatrange( 0.8, 1.5 ) * burst * 20;
		if ( self.turret_fires )
		{
			for ( i = 0; i < timer; i++ )
			{
				self shootturret();
				wait( 0.05 );
			}
		}

		if ( self.team != "allies" && randomint(2) )
		{
			while ( !BulletTracePassed( self gettagorigin( "tag_flash" ), level.player geteye(), false, self ) )
				wait 0.05;
		}

		wait randomfloatrange( 0.6, 1.2 ) * cooldown;
	}
}

random_offest( offset )
{
	return( offset - randomfloat( offset*2 ), offset - randomfloat( offset*2 ), offset - randomfloat( offset*2 ) );
}

set_playerspeed( player_speed, transition_time )
{
	base_speed = 190;

	if ( !isdefined( level.player.MoveSpeedScale ) )
		level.player.MoveSpeedScale = 1;

	if ( !isdefined(transition_time) )
		transition_time = 0;

	steps = abs( int( transition_time*4 ) );

	targetMoveSpeedScale = player_speed / base_speed;
	difference = level.player.MoveSpeedScale - targetMoveSpeedScale;

	for( i=0; i<steps; i++ )
	{	
		level.player.MoveSpeedScale -= difference/steps;
		level.player setMoveSpeedScale( level.player.MoveSpeedScale );
		wait 0.5;
	}

	level.player.MoveSpeedScale = targetMoveSpeedScale;
	level.player setMoveSpeedScale( level.player.MoveSpeedScale );
}

setup_player_action_notifies()
{
	wait 1;
	level.player notifyOnCommand( "player_gun", "+attack" );
	level.player notifyOnCommand( "player_frag", "+frag" );
	level.player notifyOnCommand( "player_flash", "-smoke" );
}

set_flag_on_player_action( flag_str, flash, grenade )
{
	// todo: change to use -> notifyOnCommand(<notify>, <command>).
	
	level notify( "kill_action_flag" );
	level endon( "kill_action_flag" );
	level endon( flag_str );

	if ( flag( flag_str ) )
		return;

	while ( true )
	{
		msg = level.player waittill_any_return( "player_gun", "player_flash", "player_frag" );
		if ( msg == "player_gun" )
			break;
		if ( msg == "player_frag" && isdefined( grenade ) )
		{
			wait 5;
			break;
		}
		if ( msg == "player_flash" && isdefined( flash ) )
		{
			wait 2;
			break;
		}
	}

	flag_set( flag_str );
}

kill_ai( mindelay, maxdelay )
{
	self endon( "death" );

	randomfloat( mindelay, maxdelay );
	self dodamage( self.health * 1.5, level.player.origin );
}

create_overlay_element( shader_name, start_alpha )
{
	overlay = newHudElem();
	overlay.x = 0;
	overlay.y = 0;
	overlay setshader ( shader_name, 640, 480);
	overlay.alignX = "left";
	overlay.alignY = "top";
	overlay.horzAlign = "fullscreen";
	overlay.vertAlign = "fullscreen";
	overlay.alpha = start_alpha;
	overlay.foreground = true;
	overlay.sort = 2;
	return overlay;
}

hud_hide( state )
{
	wait 0.05;

	if ( isdefined( state ) && !state )
	{
		setdvar( "ui_hud_showstanceicon", "1" );
		SetSavedDvar( "compass", "1" );
		SetSavedDvar( "ammoCounterHide", "0" );
		SetSavedDvar( "hud_showTextNoAmmo", "1" ); 
	}
	else
	{
		setdvar( "ui_hud_showstanceicon", "0" );
		SetSavedDvar( "compass", "0" );
		SetSavedDvar( "ammoCounterHide", "1" );
		SetSavedDvar( "hud_showTextNoAmmo", "0" ); 
	}
}

setup_vehicle_pause_node()
{
	array_thread( getvehiclenodearray( "pause_node", "script_noteworthy" ), ::vehicle_pause_node );
}

vehicle_pause_node()
{
	self waittill( "trigger", vehicle );	
	vehicle setspeed( 0, 60 );
	wait self.script_delay;
	vehicle resumespeed( 20 );
}

adjust_angles_to_player( stumble_angles )
{
		pa = stumble_angles[0];
		ra = stumble_angles[2];

		rv = anglestoright( level.player.angles );
		fv = anglestoforward( level.player.angles );

		rva = ( rv[0], 0, rv[1]*-1 );
		fva = ( fv[0], 0, fv[1]*-1 );
		angles = vector_multiply( rva, pa );
		angles = angles + vector_multiply( fva, ra );
		return angles + ( 0, stumble_angles[1], 0 );
}

set_goalnode( node )
{
	self setgoalnode( node );
	if ( isdefined( node.radius ) )
		self.goalradius = node.radius;
}

delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	while ( self cansee( level.player ) )
		wait 1;
	self delete();
}

kill_guy( origin )
{
	if ( isalive( self ) )
		self dodamage( self.health * 2, origin );
}

heli_path_speed( struct )
{
	if( isdefined( struct ) && isdefined( struct.speed ) )
	{
		accel = 25; 
		decel = undefined;
		if( isdefined( struct.script_decel ) )
		{
			decel = struct.script_decel;
		}
		speed = struct.speed;

		if( isdefined( struct.script_accel ) )
		{
			accel = struct.script_accel;
		}
		else
		{
			max_accel = speed / 4;
			if( accel > max_accel )
			{
				accel = max_accel;
			}
		}
		if ( isdefined( decel ) )
		{
			self setSpeed( speed, accel, decel );
		}
		else
		{
			self setSpeed( speed, accel );
		}
	}

	maps\_vehicle::vehicle_paths( struct );
}

fixednode_trigger_setup()
{
	array_thread( getentarray( "fixednode_set", "targetname" ), ::fixednode_set );
	array_thread( getentarray( "fixednode_unset", "targetname" ), ::fixednode_unset );
}

fixednode_set()
{
	while( true )
	{
		self waittill( "trigger", ai );
		if ( !ai.fixednode )
			ai.fixednode = true;
	}
}

fixednode_unset()
{
	while( true )
	{
		self waittill( "trigger", ai );
		if ( ai.fixednode )
			ai.fixednode = false;
	}
}


// from launchfacility_a
vehicle_turret_think()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	self thread maps\_vehicle::mgoff();
	self.turretFiring = false;
	eTarget = undefined;

	currentTargetLoc = undefined;

	if (getdvar("debug_bmp") == "1")
		self thread vehicle_debug();

	while (true)
	{
		wait (0.05);
		/*-----------------------
		TRY TO GET THE PLAYER AS A TARGET FIRST
		-------------------------*/		
		if ( !isdefined(eTarget) )
			eTarget = self vehicle_get_target_player_only();
		else if ( ( isdefined(eTarget) ) && ( eTarget != level.player ) )
			eTarget = self vehicle_get_target_player_only();
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
				//self clearTurretTarget();
				eTarget = self vehicle_get_target(level.bmpExcluders);
			}
				
		}
		/*-----------------------
		IF PLAYER ISN'T CURRENT TARGET, GET ANOTHER
		-------------------------*/	
		else
			eTarget = self vehicle_get_target(level.bmpExcluders);

		/*-----------------------
		ROTATE TURRET TO CURRENT TARGET
		-------------------------*/		
		if ( (isdefined(eTarget)) && (isalive(eTarget)) )
		{
			targetLoc = eTarget.origin + (0, 0, 32);
			self setTurretTargetVec(targetLoc);
			
			
			if (getdvar("debug_bmp") == "1")
				thread draw_line_until_notify(self.origin + (0, 0, 32), targetLoc, 1, 0, 0, self, "stop_drawing_line");
			
			fRand = ( randomfloatrange(2, 3));
			self waittill_notify_or_timeout( "turret_rotate_stopped", fRand );

			/*-----------------------
			FIRE MAIN CANNON OR MG
			-------------------------*/
			if ( (isdefined(eTarget)) && (isalive(eTarget)) )
			{
				if ( distancesquared(eTarget.origin,self.origin) <= level.bmpMGrangeSquared)
				{
					if (!self.mgturret[0] isfiringturret())
						self thread maps\_vehicle::mgon();
					
					wait(.5);
					if (!self.mgturret[0] isfiringturret())
					{
						self thread maps\_vehicle::mgoff();
						if (!self.turretFiring)
							self thread vehicle_fire_main_cannon();			
					}
	
				}
				else
				{
					self thread maps\_vehicle::mgoff();
					if (!self.turretFiring)
						self thread vehicle_fire_main_cannon();	
				}				
			}

		}
		
		//wait( randomfloatrange(2, 5));
	
		if (getdvar( "debug_bmp") == "1")
			self notify( "stop_drawing_line" );
	}
}

vehicle_fire_main_cannon()
{
	self endon ("death");
	self endon ( "c4_detonation" );
	//self notify ("firing_cannon");
	//self endon ("firing_cannon");
	
	iFireTime = weaponfiretime("bmp_turret");
	assert(isdefined(iFireTime));
	
	iBurstNumber = randomintrange(3, 8);
	
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

vehicle_get_target(aExcluders)
{
									//  getEnemyTarget( fRadius, iFOVcos, getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], true, true, false, true, aExcluders);
	return eTarget;
}

vehicle_get_target_player_only()
{
	aExcluders = level.squad;
									//  getEnemyTarget( fRadius, 			iFOVcos, 				getAITargets, doSightTrace, getVehicleTargets, randomizeTargetArray, aExcluders )
	eTarget = maps\_helicopter_globals::getEnemyTarget( level.bmpCannonRange, level.cosine[ "180" ], false, true, false, false, aExcluders);
	return eTarget;
}

vehicle_debug()
{
/*
	self endon ("death");
	while (true)
	{
		wait(.5);
		thread debug_circle( self.origin, level.bmpMGrange, 0.5, level.color[ "red" ], undefined, true);
		thread debug_circle( self.origin, level.bmpCannonRange, 0.5, level.color[ "blue" ], undefined, true);
	}
*/
}