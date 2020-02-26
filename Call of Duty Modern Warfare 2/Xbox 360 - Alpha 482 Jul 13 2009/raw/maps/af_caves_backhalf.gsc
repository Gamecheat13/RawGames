#include maps\_utility;
#include common_scripts\utility;
#include maps\_hud_util;
#include maps\_anim;
#include maps\_stealth_utility;
#include maps\_slowmo_breach;
#include maps\af_caves_code;
#include maps\_vehicle;
#include maps\_riotshield;
#using_animtree( "generic_human" );


main_af_caves_backhalf_preload()
{
	precacheModel( "weapon_rpd_MG_Setup" );
	precacheItem( "scar_h_digital_eotech" );
	
	level.priceLedgeHelpCooldown = 4; //seconds you have to wait since the last time Price killed an enemy to give him super accuracy
	level.riotShieldInstructed = false;
	level.aColornodeTriggersBackhalf = [];
	trigs = getentarray( "trigger_multiple", "classname" );
	foreach ( trigger in trigs )
	{
		if ( ( isdefined( trigger.script_noteworthy ) ) && ( getsubstr( trigger.script_noteworthy, 0, 19 ) == "colornodes_backhalf" ) )
			level.aColornodeTriggersBackhalf = array_add( level.aColornodeTriggersBackhalf, trigger );
	}
	
	flag_init( "can_talk" );
	flag_set( "can_talk" );
	flag_init( "obj_ledge_traverse_given" );
	flag_init( "obj_ledge_traverse_complete" );
	flag_init( "obj_overlook_to_skylight_given" );
	flag_init( "obj_overlook_to_skylight_complete" );
}

main_af_caves_backhalf_postload()
{
	//anims
	backhalf_anims();
	
	//vehicles
	aVehicleSpawners = maps\_vehicle::_getvehiclespawnerarray();
	array_thread( aVehicleSpawners, ::add_spawn_function, ::vehicle_think );
	array_thread( getvehiclenodearray( "plane_sound", "script_noteworthy" ), maps\_mig29::plane_sound_node );
	array_thread( getvehiclenodearray( "uav_sound", "script_noteworthy" ), maps\_ucav::plane_sound_node );
	array_thread( getvehiclenodearray( "fire_missile", "script_noteworthy" ), maps\_ucav::fire_missile_node );

	
	//Ledge	
	array_spawn_function_targetname( "hostiles_ledge_fight", ::AI_ledge_hostiles_think );
	
	//Overlook
	array_spawn_function_noteworthy( "overlook_heli_fastropers", ::AI_overlook_heli_fastropers_think );
	
	//Skylight
	array_spawn_function_noteworthy( "skylight_heli_fastropers", ::AI_skylight_heli_fastropers_think );

	
	
	//	Airstrip
	array_spawn_function_noteworthy( "airstrip_grp1", ::airstrip_fallback_guys );
	array_spawn_function_noteworthy( "grenade_tossers", ::airstrip_nade_tossers_think );
	array_spawn_function_noteworthy( "grenade_tossers", ::airstrip_nade_tossers_retreat );
	array_spawn_function_noteworthy( "airstrip_rpg_guys", ::rpg_guys );

//	Control Room		
	array_spawn_function_noteworthy( "breach_ar_guys", ::controlroom_guys_think );	
	array_spawn_function_noteworthy( "grenade_tossers", ::controlroom_guys_think );	
}

AA_backhalf_init()
{
	thread ledge_setup();
	thread cavern_setup();
	thread airstrip_setup();
}

/****************************************************************************
    LEDGE FIGHT
****************************************************************************/ 
ledge_setup()
{
	flag_wait( "steamroom_halfway_point" );
	thread AAA_sequence_ledge_to_cave();
	thread dialogue_ledge_to_cave();
	thread obj_ledge_traverse();
	
	flag_wait( "player_inside_overlook" );
	thread AA_overlook_init();
	
}


AAA_sequence_ledge_to_cave()
{
	wait( 0.05 );
	level.price enable_ai_color();
	level.price cqb_walk( "off" );
	level.price.neverEnableCQB = true;
	level.price thread force_weapon_when_player_not_looking( "scar_h_digital_eotech" );
	
	
	
	triggersEnable( "colornodes_backhalf_ledge_start", "script_noteworthy", true );
	triggersEnable( "colornodes_backhalf_ledge", "script_noteworthy", true );
	activate_trigger_with_noteworthy( "colornodes_backhalf_ledge_start" );
	
	/*-----------------------
	CANYON VEHICLES
	-------------------------*/	
	flag_wait( "player_approaching_steamroom_exit" );
	air_convoy_ledge = spawn_vehicles_from_targetname_and_drive( "air_convoy_ledge" );

	//get overlook fastropers ready
	thread blackhawk_overlook_rappel_think();

	flag_wait( "player_clear_steamroom" );
	thread autosave_by_name( "ledge_start" );
	zodiacs_canyon_start = spawn_vehicles_from_targetname_and_drive( "zodiacs_canyon_start" );
	zodiacs_canyon = spawn_vehicles_from_targetname_and_drive( "zodiacs_canyon" );

	//jets_canyon_01
	flag_wait( "player_ledge_stairs_01" );
	level.price.sprint = true;
	thread price_has_awesome_accuracy_while_player_is_using_shield( "ledge_gunners_dead" );
	uav_bridge_01 = spawn_vehicle_from_targetname_and_drive( "uav_bridge_01" );
	uav_bridge_01 thread uav_bridge_01_think();
	
	flag_wait( "player_ledge_corner_01" );
	
	flag_wait( "player_crossed_bridge" );
	level.priceLedgeHelpCooldown = .1;		//let Price be accurate more ofthen now that we're closer
	
	flag_wait( "player_ledge_last_stairs" );
	level.price.ignoreme = false;
	
	flag_wait( "player_inside_overlook" );
	level.player notify ( "done_with_ledge_sequence" );

}

price_has_awesome_accuracy_while_player_is_using_shield( sFlagToEndOn )
{
	level.player endon( "death" );
	level.price endon( "death" );
	level.price.old_baseaccuracy = level.price.baseaccuracy;
	level.lasttimePriceKilledEnemy = getTime();
	wait( 0.05 );
	while( !flag( sFlagToEndOn ) )
	{
		if ( ( player_is_using_riot_shield() ) && ( price_hasnt_killed_a_fool_in_the_last_few_seconds( level.priceLedgeHelpCooldown ) ) )
		{
			level.price.baseaccuracy = 25;
		}
		else
		{
			level.price.baseaccuracy = level.price.old_baseaccuracy;
		}
		//level.player waittill_either_or_timeout( "weapon_change", "done_with_ledge_sequence" );
		wait( 2 );
	}

	level.price.baseaccuracy = level.price.old_baseaccuracy;

}

price_hasnt_killed_a_fool_in_the_last_few_seconds( iSeconds )
{
	//only give Price awesome accuracy if it's been at lease XX seconds since his last kill
	currentTime = getTime();
	timeElapsed = currentTime - level.lasttimePriceKilledEnemy;
	if ( currentTime == level.lasttimePriceKilledEnemy )
		return false;
	else if ( timeElapsed > ( iSeconds * 1000 ) )
		return true;
	else
		return false;
}

AI_ledge_hostiles_think()
{
	while( isdefined( self ) )
	{
		self waittill( "death", attacker );
		if ( ( isdefined( attacker ) ) && ( attacker == level.price ) )
		{
			//Good night
			//He's down
			//Got 'em
			//Got one.
			level.price dialogue_execute_temp( "Got 'em  " + randomintrange( 0, 4 ) );
			level.lasttimePriceKilledEnemy = getTime();
		}
	}
	
}

dialogue_ledge_to_cave()
{
	flag_wait( "player_approaching_steamroom_exit" );
	
	flag_set( "obj_ledge_traverse_given" );
	iPrintLnBold( "UAV dialogue" );
	
	flag_wait( "player_clear_steamroom" );
	
	flag_wait( "player_ledge_riotshields" );
	//They're sending in a UAV. Grab a riot shield, we're about to go loud.
	level.price dialogue_execute_temp( "PRICE: They're sending in a UAV. Grab a riot shield, we're about to go loud." );

	flag_wait( "player_ledge_stairs_01" );
	iPrintLnBold( "UAV going loud dialogue" );
	
	thread dialogue_nag_riotshield( "ledge_gunners_dead", "player_crossed_bridge" );
	
	/*-----------------------
	LEDGE GUNNERS DEAD
	-------------------------*/	
	flag_wait( "ledge_gunners_dead" );
	level.player notify ( "done_with_ledge_sequence" );
	level.price.sprint = false;
	
	if ( !flag( "player_inside_overlook" ) )
	{
		if ( flag( "can_talk" ) )
		{
			flag_clear( "can_talk" );
			//Price: We're clear. Move in.
			level.price dialogue_execute_temp( "PRICE: We're clear. Move in." );
			flag_set( "can_talk" );	
		}
	}
	
}

dialogue_nag_riotshield( sFlagToEndOn1, sFlagToEndOn2 )
{

	while( true )
	{
		if ( ( flag( sFlagToEndOn1 ) ) || ( flag( sFlagToEndOn2 ) ) )
			return;
				
		//No riot shield, but near a pickup
		if ( ( !player_has_riot_shield() ) && ( player_is_near_a_riot_shield_pickup() ) )
		{
			if ( flag( "can_talk" ) )
			{
				flag_clear( "can_talk" );
				//Captain Price	11	4	Pick up one of those riot shields, Soap. We don't have much cover out here.
				//Captain Price	11	5	Soap, grab a riot shield. We'll need all the cover we can get.
				//Grab a riot shield. We're completely exposed out here.
				level.price dialogue_execute_temp( "Pick up one of those riot shields, Soap. We don't have much cover out here." );
				flag_set( "can_talk" );	
			}
		}
		
		//Player has the shield
		else if ( player_has_riot_shield() )
		{
			//Have we given the general instruction yet?
			if ( level.riotShieldInstructed == false )
			{
				
				if ( flag( "can_talk" ) )
				{
					flag_clear( "can_talk" );
					//Captain Price	11	3	Take point with the riot shield. I'll take care of any resistance.
					level.price dialogue_execute_temp( "Take point with the riot shield. I'll take care of any resistance." );
					level.riotShieldInstructed = true;
					flag_set( "can_talk" );	
				}
			}
			//Player has it, but is not using it
			else if ( !player_is_using_riot_shield() )
			{
				if ( flag( "can_talk" ) )
				{
					flag_clear( "can_talk" );
					//Switch to the shield, we're exposed out here!
					//Bring up the riot shield, Soap!
					//Give us some cover with that riot shield, Soap!
					level.price dialogue_execute_temp( "Switch to the shield, we're exposed out here!" );
					flag_set( "can_talk" );	
				}
			}
			//Player is using it, but not crouched
			else if ( !player_is_crouched() )
			{
				if ( flag( "can_talk" ) )
				{
					flag_clear( "can_talk" );
					//Captain Price	11	3	Stay low with that shield so I can get a clean shot
					//Captain Price	11	3	Keep low with that shield.
					//Crouch down with that shield, Soap! I'll take care of the shooters.
					level.price dialogue_execute_temp( "Stay low with that shield so I can get a clean shot" );
					flag_set( "can_talk" );	
				}
			}
				
		}
		
		level.player waittill_notify_or_timeout( "weapon_change", 10 );
		wait( 3 );

	}
}

uav_bridge_01_think()
{
	while( isdefined( self ) )
		wait( 2 );
	uav_bridge_02 = spawn_vehicle_from_targetname_and_drive( "uav_bridge_02" );
}

player_is_crouched()
{
	if ( level.player GetStance() == "crouch" )
		return true;
	else
		return false;
}

player_is_using_riot_shield()
{
	if ( !player_has_riot_shield() )
		return false;
	else
	{
		currentWeapon = level.player getCurrentWeapon();
		if ( currentWeapon == "riotshield" )
			return true;
		else
			return false;
	}
}

player_has_riot_shield()
{
	weapons = level.player GetWeaponsListAll();
	if ( !isdefined( weapons ) )
		return false;
	foreach ( weapon in weapons )
	{
		if ( IsSubStr( weapon, "riotshield" ) )
			return true;
	}
	return false;
}

player_is_near_a_riot_shield_pickup()
{
	riotShields = [];
	weapons = getWeaponArray();
	playerDistSquared = 600 * 600;
	foreach( weapon in weapons )
	{
		if ( IsSubStr( weapon.code_classname, "riotshield" ) )
		{
			if ( distanceSquared( weapon.origin, level.player.origin ) < playerDistSquared )
				return true;
		}

	}
	
	return false;
}

/****************************************************************************
    OVERLOOK FIGHT
****************************************************************************/ 

AA_overlook_init()
{
	thread AAA_sequence_overlook_to_breach();
	thread dialogue_overlook_to_breach();
	thread obj_overlook_to_skylight();	
}

AAA_sequence_overlook_to_breach()
{
	flag_wait( "player_inside_overlook" );
	triggersEnable( "colornodes_backhalf_overlook_to_breach", "script_noteworthy", true );
	
	level.price cqb_walk( "off" );
	level.price.neverEnableCQB = true;
	level.price.sprint = false;
	level.price.fixednodesaferadius = 1024;
	level.fixednodesaferadius_default = 1024;
	
	
	/*-----------------------
	OVERLOOK CAVE
	-------------------------*/	
	//get fastropers ready for skylight area
	skylight1_heli_unload = getstruct( "skylight1_heli_unload", "targetname" );
	blackhawk_skylight_01 = spawn_vehicle_from_targetname_and_drive( "blackhawk_skylight_01" );
	blackhawk_skylight_01 waittill( "reached_dynamic_path_end" );

	/*-----------------------
	SKYLIGHT AREA
	-------------------------*/	
	flag_wait( "player_enter_skylight" );
	//aFriendlies = blackhawk_skylight_01.riders; 
	blackhawk_skylight_01 vehicle_paths( skylight1_heli_unload );
	
	//blackhawk_fastropers script_noteworthy
}

dialogue_overlook_to_breach()
{
	
}

AI_overlook_heli_fastropers_think()
{
	//called from spawn func
	self endon( "death" );
	self.ignoreme = true;
	self waittill( "jumpedout" );
	self.ignoreme = false;
}

AI_skylight_heli_fastropers_think()
{
	//called from spawn func
	self endon( "death" );
	self.ignoreme = true;
	self waittill( "jumpedout" );
	self.ignoreme = false;
}

blackhawk_overlook_rappel_think()
{
	blackhawk_overlook_rappel = spawn_vehicle_from_targetname_and_drive( "blackhawk_overlook_rappel" );
	
	blackhawk_overlook_rappel endon( "death" );
	blackhawk_overlook_rappel waittill( "reached_dynamic_path_end" );

	flag_wait( "player_inside_overlook" );
	//aFriendlies = blackhawk_skylight_01.riders; 
	overlook_heli_unload = getstruct( "overlook_heli_unload", "targetname" );
	blackhawk_overlook_rappel vehicle_paths( overlook_heli_unload );
	
	//spawn other blackhawk
	blackhawk_overlook_01 = spawn_vehicle_from_targetname_and_drive( "blackhawk_overlook_01" );
	
	blackhawk_overlook_rappel waittill( "unloaded" );
	wait( 5 );

}


//ledge_price_movement()
//{
//	add_wait( ::flag_wait, "get_out" );
//	add_wait( ::flag_wait, "location_change_ledge" );
//	do_wait_any();	
//	
//	level.price thread friendly_adjust_movement_speed();
//	level.price pushplayer( true );
//	level.price cqb_walk( "off" );
//	level.price.neverEnableCQB = true;
//
//	level.price set_ignoreall( true );
//   	level.price.dontshootwhilemoving = true;
//
//	level.price disable_ai_color();
//	level.price disable_pain();
//  	level.price.IgnoreRandomBulletDamage = true;
//	level.price disable_surprise();
//
//	setsaveddvar( "ai_friendlysuppression", 0 );
//    setsaveddvar( "ai_friendlyfireblockduration", 100 );
//
//	node = getnode( "price_moveup1", "targetname" );
//	level.price.goalradius = 64;
//	level.price setGoalNode( node );
//	
//	flag_wait( "player_ledge_moveup2" );
//	level.price notify( "stop_adjust_movement_speed" );
//	
//	thread ledge_price_dive();
//	thread ledge_price_dive_dialogue();
//	
//	flag_wait( "price_dived" );
//	
//	level.price.sprint = true; //Run Forest Run!
//	level.price.moveplaybackrate = .9;
//
//	node = getnode( "price_post_bridge_node", "targetname" );
//	level.price.goalradius = 64;
//	level.price setGoalNode( node );
//	
//	flag_wait( "price_crossed_bridge" );
//	
//	level.price set_ignoreall( false );
//   	level.price.dontshootwhilemoving = undefined;
//   	
//   	setsaveddvar( "ai_friendlysuppression", 1 );
//    setsaveddvar( "ai_friendlyfireblockduration", 2000 );
//}


//  ACT 7, SCENE 1
cavern_setup()
{
	flag_wait( "player_crossed_bridge" );
	thread cavern_shepherd_dialogue();
	thread cavern_breach_savegame();
	thread cavern_breach_that_door();
	
	thread controlroom_sheppard_close_the_door();
	thread controlroom_breach_destruction();
	
	battlechatter_on( "allies" );
	
//	sentrys	= getentarray( "sentry", "script_noteworthy" );
//	level.sentrys_alive = sentrys.size;
//	array_thread( sentrys, ::cavern_senrty_guns );
//	array_thread( sentrys, ::cavern_senrty_guns_death );
}

cavern_senrty_guns()
{
	self waittill( "shooting" );
	flag_set( "sentry_fired" );
}

cavern_senrty_guns_death()
{
	self waittill( "death" );
	level.sentrys_alive--;
}

cavern_price_see_shepherd()
{
	flag_wait( "visual_on_shepherd" );	
	
	wait 1.5;
	//Price: "I got a visual on Shepherd! He's getting away! Head for that door to the northwest! Go! Go!"
	radio_dialogue( "pri_gettingaway" );
	
/*
	flag_wait( "sentry_fired" );
	
	wait( randomintrange( 2, 4 ) );
	
	if ( level.sentrys_alive > 0 )
	{
		//Price: "We gotta take out those sentry guns!"
		radio_dialogue( "pri_takeoutsentry" );
	}
*/
}

cavern_breach_savegame()
{
	flag_wait( "go_breach_door" );	
	thread autosave_by_name( "breach" );
}

cavern_breach_that_door()
{
	level endon( "breach_activated" );	
	
	guys = get_living_ai_array( "last_cavern_guys", "script_noteworthy" );
	waittill_dead_or_dying( guys );
	
	flag_wait( "go_breach_door" );
	
	level.price.fixednodesaferadius = 192;
	level.fixednodesaferadius_default = 192;
	
	//Price: "Soap, get in position to breach!"
	radio_dialogue( "pri_positiontobreach" );
	
	flag_wait( "breach_door" );
	
	//Price: "Do it."
	radio_dialogue( "pri_doit" );
}

cavern_shepherd_dialogue()
{
	flag_wait( "controlroom_door_close_spawner" );
	
	//Shepherd: "Lieutenant, have your men rendezvous with me at the airstrip."
	radio_dialogue( "shp_rendevous" );
	
	//Lieutenant: "Yes sir."
	radio_dialogue( "lnt_yessir2" );
}

//  ACT 8, SCENE 1
controlroom_sheppard_close_the_door()
{
	icon_trigger = getent( "trigger_breach_icon", "targetname" );
	icon_trigger trigger_off();

	wait( 2 );
	//hide the breach door model for now
	breach_door = level.breach_doors[ 2 ];
	breach_door hide();
	
	breach_path_clip = getent( "breach_solid", "targetname" );
	breach_path_clip notsolid();
	breach_path_clip connectpaths();
				
	old_door = getent( "blast_door_slam", "targetname" );// this is the wood door
	old_door.origin = breach_door.origin;
	startAngles = old_door.angles;
	old_door.angles += ( 0, -74, 0 );

	flag_wait( "controlroom_door_close_spawner" );

	guy = spawn_targetname( "control_room_door_close_guy", true );
	guy set_ignoreme( true );
	guy set_ignoreall( true );
	guy thread magic_bullet_shield();
	
	node = getnode( "sheppard_door_peek", "targetname" );
	
	node anim_generic_reach( guy, "alert2look_cornerR" );
	node anim_generic( guy, "alert2look_cornerR" );
	
	old_door rotateyaw( 74, .50 );
	
	old_door thread play_sound_in_space( "scn_afcaves_doorslam_brace", old_door.origin );

	breach_path_clip solid();
	breach_path_clip disconnectpaths();
	
	wait( .66 );

	old_door hide();
	old_door notsolid();
	breach_door show();
	
	wait .5;
	icon_trigger trigger_on();
	
	wait 9;
	guy set_ignoreme( false );
	guy set_ignoreall( false );
	guy stop_magic_bullet_shield();
}
		
controlroom_breach_destruction()
{
	level waittill( "A door in breach group 1 has been activated." );
	
	level notify( "breach_activated" );
	
//  Lamp that is hanging over the big table have it swinging caused by the breach explosion. 
//	swing_light_org = getstruct( "swing_light_org", "targetname" );
//	run_thread_on_targetname( "swing_light_org", ::swing_light_org_think );	
//	run_thread_on_noteworthy( "hunted_hanging_light", ::hunted_hanging_light );

	wait 3;
	exploder( "control_room_breach" ); 

	wait 5;
		if ( cointoss() )
			earthquake( 0.2, .75, level.player.origin, 350 );
		else
			earthquake( 0.3, 1.75, level.player.origin, 400 );
	exploder( "control_room_breach" ); 
	exploder( "controlroom_aftershock" );

	wait 6;
	earthquake( .2, 1.75, level.player.origin, 350 );
	exploder( "control_room_breach" );
}

controlroom_guys_think()// making the guys in the rear wait till the slowmo has ended before they shoot.
{
	self endon( "death" );
	self.dontEverShoot = true;
	
	level waittill( "A door in breach group 1 has been activated." );
	wait 12;
	
	self.dontEverShoot = undefined;		
}

//  ACT 9, SCENE 1
airstrip_setup()
{
	flag_wait( "location_change_control_room" );

	thread airstrip_nade_tossers();
	thread airstrip_nade_tossers_dialogue();
	thread airstrip_cave_destruction();
	thread airstrip_price_dialogue();
	thread airstrip_shepherd_dialogue();
	thread airstrip_price_flanking_lf_warning();
	thread airstrip_price_flanking_rt_warning();
	thread airstrip_tower_destruction();
	thread airstrip_kill_bird_dialogue();
	thread airstrip_player_clip();
	thread airstrip_heli_crash_destruction();
	thread airstrip_heli_crash_victims();
	thread airstrip_surving_enemy();
	thread airstrip_level_end_dialogue();
	thread airstrip_end_of_level();
	
	level.price.baseAccuracy = 15;
	battlechatter_on( "allies" );
}

airstrip_nade_tossers()// Two enemies toss grenades and then retreat back to the airstrip.
{
	flag_wait( "magic_grenades" );
	
	nade_guys = getentarray( "grenade_toss_guys", "targetname" );
	array_thread( nade_guys, ::spawn_ai );

	nade_support_dude = getent( "nade_support_dude", "targetname" );
	nade_support_dude spawn_ai();
}

airstrip_nade_tossers_think()
{	
	flag_wait( "magic_grenades" );
		
	level endon( "player_near_tossers" );
	self endon( "death" );
	self disable_long_death();
	
	self.allowdeath = true;
	self.animname = "nade_tosser";
  	self set_ignoreme( true );
  	self.dontshootwhilemoving = true;
	
	vec = anglestoforward(self.angles);
	vec = vector_multiply( vec, 1400 );

	goal = getnode( self.target, "targetname" );
	goal anim_reach_solo( self, "cqb_nade_throw" );
	goal thread anim_single_solo( self, "cqb_nade_throw" );
	
	flag_wait( "nade_tossed" );
	
	self magicgrenademanual( self gettagorigin( "TAG_INHAND" ), vec, 2.5 );
	
	flag_set( "nade_tossers_retreat" );		
}

airstrip_nade_tossers_retreat()
{
	self endon( "death" );
	
	add_wait( ::flag_wait, "nade_tossers_retreat" );
	add_wait( ::flag_wait, "player_near_tossers" );
	do_wait_any();
	
	wait .5;
	self.dontshootwhilemoving = undefined;
  	self set_ignoreme( false );
	
	node = getnode( "nade_retreat", "targetname" );
	self.goalradius = 128;
	self setGoalNode( node );
	
	self waittill ( "goal" );
	self.goalradius = 1024;
}

airstrip_nade_tossers_dialogue()
{
	flag_wait( "magic_grenades" );
	
	wait 1.5;
	
	//Shadow Company 3: "You guys just don't know when to quit do ya!"
	org = getent( "grenade_speaker", "targetname" );
	org play_sound_in_space( "afcaves_sc3_whentoquit", org.origin );
}

airstrip_cave_destruction()
{
	level endon( "rpg_fired" );
	
	flag_wait( "rpg_hit" );
	exploder( "rpg_damage" );
	
	earthquake( 0.3, 2.75, level.player.origin, 1024 );
		
	level notify( "rpg_fired" );
}

airstrip_shepherd_dialogue()
{
	flag_wait( "leave_two_squads" );	
	
	//Shepherd: "Have your men stay with me."
	radio_dialogue( "shp_menstaywithme" );
	
	//Shepherd: "Leave two squads to cover the entrance."
	radio_dialogue( "shp_twosquads" );
	
	//Lieutenant: "Yes sir!."
	radio_dialogue( "lnt_yessir3" );
	
	flag_wait( "heli_inbound" );
	
	//Shepherd: "Call in some air support!"
	radio_dialogue( "shp_airsupport" );
	
	//Lieutenant: "Little Bird inbound now."
	radio_dialogue( "lnt_littlebirdinbound" );
	
	//Price: "Heads up Soap! Helicopter coming in fast from the west!"
	radio_dialogue( "pri_gonnagetaway" );
}

airstrip_fallback_guys()
{
	self endon( "death" );
	
	flag_wait( "grp1_noshoot" );
	self.dontEverShoot = true;
	
	flag_wait( "grp1_openfire" );
	self.dontEverShoot = undefined;	
}

airstrip_price_dialogue()
{
	flag_wait( "sheppard_southwest" );	
	
	//Price: "There he is! He's gone into the tunnel to the southwest!"
	radio_dialogue( "pri_intothetunnel" );
	
	//Price: "Keep moving!"
	radio_dialogue( "pri_keepmoving" );
}

airstrip_price_flanking_lf_warning()
{
	flag_wait( "watch_lt_flank" );
	
	flag_wait( "our_lt_flank" );
	//Price: "Watch our flanks."
	radio_dialogue( "pri_watchourflanks" );
}

airstrip_price_flanking_rt_warning()
{
	flag_wait( "watch_rt_flank" );
	
	flag_wait( "our_rt_flank" );
	//Price: "Watch our flanks."
	radio_dialogue( "pri_watchourflanks" );
}

airstrip_tower_destruction()
{
	trig = getent( "tower_trigger", "targetname" );
	trig waittill( "trigger" );
	
	radiusdamage ( trig.origin, 256, 1000, 900 );
	earthquake ( 0.4, 1, trig.origin, 2500 );

	trig thread play_sound_in_space( "explo_wood_tower", trig.origin );
//	exploder( "tower" );
			
	volume = getent( "tower_victims", "targetname" );

	mg = getent( "tower_mg", "script_noteworthy" );
	owner = mg getturretowner();
	if ( isalive( owner ) )
		owner notify( "stop_using_built_in_burst_fire" );

	mg hide();
	
	volume = getent( "tower_victims", "targetname" );
	array_thread( getcorpsearray(), ::delete_corpse_in_volume, volume );
}

airstrip_kill_bird_dialogue()
{
	level endon( "littlebird_crashed" );
	
	flag_wait ( "price_kill_littlebird" );
	
	level notify( "littlebird_shows_up" );
	
	//Price: "Take out that helicopter!!"
	radio_dialogue( "pri_takeoutheli" );
	
	while ( !flag( "littlebird_crashed" ) )
	{
		wait( randomintrange( 30, 40 ) );
		if ( flag( "littlebird_crashed" ) )
			break;
		//Price: "Take out that helicopter!!"
		radio_dialogue( "pri_takeoutheli" );
	}	
}

airstrip_surving_enemy()
{
	flag_wait( "littlebird_crashed" );
		
	surving_enemy = get_living_ai_array( "airstrip_guys", "script_noteworthy");
	foreach ( baddie in surving_enemy )
	if( isalive( baddie ) )
	{
	baddie.health = 1;
	}	
}

airstrip_heli_crash_victims()
{
	flag_wait( "littlebird_crashed" );
	
	battlechatter_off( "axis" );
	
	volume = getent( "heli_crash_victims", "targetname" );

	enemies = getaiarray( "axis" );
	foreach ( guy in enemies ) 
	{
		if ( guy istouching( volume ) )
			guy kill();
	}
}

airstrip_player_clip()
{
	flag_wait( "exit_player_clip" );
	
	exit_clip = getent( "exit_player_clip", "targetname" );
	exit_clip solid();
	
	flag_wait( "littlebird_crashed" );

	exit_clip = getent( "exit_player_clip", "targetname" );
	exit_clip notsolid();
}

airstrip_heli_crash_destruction()
{
	flag_set( "littlebird_crashed" );
	netting_destroyed = getentarray( "netting_destroyed", "targetname" );
	foreach ( destroyed_piece in netting_destroyed )
	destroyed_piece hide();
	
	flag_wait( "littlebird_crashed" );
	
	exploder( "helicrash_01" ); 
	earthquake( 0.6, 1, level.player.origin, 1024 );
	
	pristine_netting = getentarray( "netting_pristine", "targetname" );
	foreach ( nondestroyed_piece in pristine_netting )
	nondestroyed_piece hide();
	
	netting_destroyed = getentarray( "netting_destroyed", "targetname" );
	foreach ( destroyed_piece in netting_destroyed )
	destroyed_piece show();
	
	level notify( "littlebird_crashed" );
}

airstrip_level_end_dialogue()
{
	flag_wait( "littlebird_crashed" );
	
	wait 2;
	
	//Price: "Soap, regroup on me! He went through this tunnel, let's go!"
	//radio_dialogue( "pri_regrouponme" );	
}

airstrip_end_of_level()
{
	flag_wait( "littlebird_crashed" );
	
	level.price cqb_walk( "off" );
	level.price.neverEnableCQB = true;

  	level.price disable_ai_color();
  	level.price.IgnoreRandomBulletDamage = true;
	level.price disable_pain();

  	level.price set_ignoreme( true );
  	level.price set_ignoreall( false );
	
	node = getnode( "regroup_node", "targetname" );
	level.price setGoalNode( node );
	level.price.goalradius = 32;
  	
 	flag_wait( "player_regrouped" );
 	
	node = getnode( "price_level_end_node", "targetname" );
    level.price setGoalNode( node );
  	level.price.goalradius = 24;
  	level.price set_ignoreall( true );
  	
	add_wait( ::flag_wait, "level_exit" );
	add_wait( ::flag_wait, "player_in_exit" );
	do_wait_any();
	
	end_of_level();
}


riot_shield_guy()
{
	self endon( "death" );
	self riotshield_sprint_on();
	wait( randomfloatrange( 1.8, 2.2 ) );
//	self waittill( "goal" );
	self riotshield_sprint_off();
}

#using_animtree( "generic_human" );
backhalf_anims()
{

}


vehicle_think()
{
	switch( self.vehicletype )
    {
		case "zodiac":
   			self thread vehicle_zodiac_think();
    		break;
    	case "littlebird":
    		self thread vehicle_littlebird_think();
    		break;
    }
}

vehicle_zodiac_think()
{
	playfxontag( getfx( "zodiac_wake_geotrail_oilrig" ), self, "tag_origin" );
}

vehicle_littlebird_think()
{
	self endon( "death" );
	if ( self.classname == "script_vehicle_littlebird_armed" )
	{
		self thread maps\_attack_heli::heli_default_missiles_on();
		waittillframeend;
		foreach ( turret in self.mgturret )
		{
			turret SetMode( "manual" );
			turret StopFiring();
		}
	}
}

triggersEnable( triggerName, noteworthyOrTargetname, bool )
{
	assertEX( isdefined( bool ), "Must specify true/false parameter for triggersEnable() function" );
	aTriggers = getentarray( triggername, noteworthyOrTargetname );
	assertEx( isDefined( aTriggers ), triggerName + " does not exist" );
	if ( bool == true )
		array_thread( aTriggers, ::trigger_on );
	else
		array_thread( aTriggers, ::trigger_off );
}


dialogue_execute( sLineToExecute )
{
	self endon( "death" );
	self dialogue_queue( sLineToExecute );

}

dialogue_execute_temp( sLineToExecute )
{
	hint_temp( sLineToExecute, 3 );

}
hint_temp( string, timeOut )
{
	hintfade = 0.5;

	level endon( "clearing_hints" );

	if ( isDefined( level.tempHint ) )
		level.tempHint destroyElem();

	level.tempHint = createFontString( "default", 1.5 );
	level.tempHint setPoint( "BOTTOM", undefined, 0, -60 );
	level.tempHint.color = ( 1, 1, 1 );
	level.tempHint setText( string );
	level.tempHint.alpha = 0;
	level.tempHint fadeOverTime( 0.5 );
	level.tempHint.alpha = 1;
	level.tempHint.sort = 1;
	wait( 0.5 );
	level.tempHint endon( "death" );

	if ( isDefined( timeOut ) )
		wait( timeOut );
	else
		return;

	level.tempHint fadeOverTime( hintfade );
	level.tempHint.alpha = 0;
	wait( hintfade );

	level.tempHint destroyElem();
}


force_weapon_when_player_not_looking( weaponName )
{
	self endon( "death" );
	while ( within_fov( level.player.origin, level.player getplayerangles(), level.price.origin, level.cosine[ "45" ] ) )
	{
		wait 1;
	}
	self forceUseWeapon( weaponName, "primary" );
}

obj_ledge_traverse()
{
	flag_wait( "obj_ledge_traverse_given" );
	objective_number = 6;
	
	objective_add( objective_number, "active", &"AF_CAVES_OBJ_LEDGE_TRAVERSE" );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, ( 0, 0, 70 ) );
	//Objective_SetPointerTextOverride( objective_number, &"OILRIG_OBJ_SOAP" );
	
	flag_wait( "player_ledge_stairs_01" );

	objective_position( objective_number, ( 0, 0, 0 ) );
	
	obj_position = getent( "obj_ledge_gunners", "targetname" );
	objective_position( objective_number, obj_position.origin );
	//Objective_SetPointerTextOverride( objective_number );
	
	flag_wait( "player_ledge_end" );
	
	objective_position( objective_number, ( 0, 0, 0 ) );
	Objective_OnEntity( objective_number, level.price, ( 0, 0, 70 ) );
	
	objective_state( objective_number, "done" );
	
	flag_set( "obj_ledge_traverse_complete" );
}

obj_overlook_to_skylight()
{
	flag_wait( "obj_overlook_to_skylight_given" );
	objective_number = 6;
	
	objective_add( objective_number, "active", &"AF_CAVES_LOCATE_SHEPHERD" );
	objective_current( objective_number );
	Objective_OnEntity( objective_number, level.price, ( 0, 0, 70 ) );
	//Objective_SetPointerTextOverride( objective_number, &"OILRIG_OBJ_SOAP" );
	
}


//REFERENCE           OBJ_LEDGE_TRAVERSE
//LANG_ENGLISH        "Traverse the rock bridge"
//
//REFERENCE           OBJ_BREACH
//LANG_ENGLISH        "Breach the Control Room"
//
//REFERENCE           OBJ_DOOR_CONTROLS
//LANG_ENGLISH        "Override the door controls"
//
//REFERENCE           OBJ_ESCAPE
//LANG_ENGLISH        "Escape from the cave"
//
//REFERENCE           OBJ_HUMMER
//LANG_ENGLISH        "Mount the Humvee turret"
//
//REFERENCE           OBJ_HUMMER
//LANG_ENGLISH        "Eliminate all enemy resistance"