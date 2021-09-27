#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_specialops_code;
#include maps\_audio;
#include maps\_slowmo_breach;

CONST_ENEMY_ACCURACY = 1;  // 1.75 is punishing on veteran
CONST_TIME_REGULAR = 210;
CONST_TIME_HARDENED = 145;
CONST_TIME_VETERAN = 110;
CONST_LOST_SCORE_PER_DAMAGE = 100;

CONST_SCORE_PER_KILL = 25;
CONST_MAX_KILLS_SP_REGULAR = 26;
CONST_MAX_KILLS_SP_HARDENED = 31;
CONST_MAX_KILLS_SP_VETERAN = 36;
CONST_MAX_KILLS_COOP = 38;

CONST_SCORE_ACCURACY = 2000;
CONST_SCORE_DAMAGED = 3000;
CONST_SCORE_TIME = 5000;

main()
{
	fixSP();
	precacheEverything();
	setupDialogOverrides();

	maps\_load::main();
	
	maps\so_milehigh_hijack_slowmo_killswitch::init();
	
	level thread startAmbientVO();
	level thread cleanUpEnemiesOnFinalBreach();
	level thread disableGrenadesDuringBreach();
	
	if(noSlowMo())
	{
		spawners = GetEntArray("so_commander","script_noteworthy");
		foreach(spawner in spawners)
			spawner.count = 0;
	}

	setupDifficulty();	
	setupSP();
	setupEnemies();
	setupPlane();
	level thread setupStart();
	level thread setupPlayers();
	level thread setupObjectives();
	level thread setupChallenge();
	level thread spawnEnemies();
	level thread lowerPlaneRumble();
	level thread upperPlaneRumble();
	level thread setupDoors();
	level thread startDebate();
	level thread setupCounterBreach();
	level thread setupEndCleanup();
	
	/#
	level thread show_ai_health();
	#/
}

noSlowMo()
{
	return isDefined(level.no_slowmo) && level.no_slowmo;
}

/*************************************************************************************************
	precacheEverything
	self = level
**************************************************************************************************/
precacheEverything()
{
	flag_init( "lower_floor_first_terrorists" );
	flag_init( "so_upper_floor_last_chance" );
	flag_init( "so_conference_room_terrorists" );
	flag_init( "so_begin_debate_breach" );
	flag_init( "so_president_spawned" );
	flag_init( "so_president_captured" );
	flag_init( "so_conference_room_hall");
	
	PrecacheMinimapSentryCodeAssets();
	
	precacheVO();
	
	maps\createart\hijack_art::main();
	maps\hijack_fx::main();
	maps\hijack_aud::main();
	maps\hijack_anim::main();
	maps\hijack_precache::main();
	maps\so_milehigh_hijack_fx::main();
	setupAnims();
	
	maps\hijack::level_precache();
	maps\hijack::level_init_flags();
	maps\hijack::level_init_assets();
	
	maps\hijack_precache::main();
	maps\so_milehigh_hijack_precache::main();
}

/*************************************************************************************************
	precacheVO
	self = level
**************************************************************************************************/
precacheVO()
{
	level.scr_radio[ "so_milehigh_fail_cowards" ] 			= "so_milehigh_fail_cowards";		// Defeat.  I have no patience for cowards.
	level.scr_radio[ "so_milehigh_fail_no_defeat" ] 		= "so_milehigh_fail_no_defeat";		// Defeat is not an option.
	level.scr_radio[ "so_milehigh_fail_been_defeated" ] 	= "so_milehigh_fail_been_defeated";	// You have been defeated!
	level.scr_radio[ "so_milehigh_fail_next_fight" ] 		= "so_milehigh_fail_next_fight";	// We lost, next fight is ours.
	level.scr_radio[ "so_milehigh_fail_happen_again" ] 		= "so_milehigh_fail_happen_again";	// You were defeated.  Don't let this happen again.
	level.scr_radio[ "so_milehigh_fail_objective" ] 		= "so_milehigh_fail_objective";		// Objective lost!
	level.scr_radio[ "so_milehigh_win_served_well" ] 		= "so_milehigh_win_served_well";	// Good work.  You've served me well.
	level.scr_radio[ "so_milehigh_win_victory" ] 			= "so_milehigh_win_victory";		// Victory.
	level.scr_radio[ "so_milehigh_win_enemy_defeated" ] 	= "so_milehigh_win_enemy_defeated";	// Good work, the enemy is defeated.
	level.scr_radio[ "so_milehigh_win_well_done" ] 			= "so_milehigh_win_well_done";		// Well done.
	level.scr_radio[ "so_milehigh_win_victorious" ] 		= "so_milehigh_win_victorious";		// We are victorius.
	level.scr_radio[ "so_milehigh_win_victory_ours" ] 		= "so_milehigh_win_victory_ours";	// Victory is ours.
	level.scr_radio[ "so_milehigh_win_jerk" ] 				= "so_milehigh_win_jerk";			// You've served me well this far.  Don't give me a reason to doubt you.
	level.scr_radio[ "so_milehigh_time_hurry" ] 			= "so_milehigh_time_hurry";			// Time's almost up!
	level.scr_radio[ "so_milehigh_time_generic" ] 			= "so_milehigh_time_generic";		// Push forward!
	level.scr_radio[ "so_milehigh_start_capture" ] 			= "so_milehigh_start_capture";		// Capture the objective.
	level.scr_radio[ "so_milehigh_start_defeat" ] 			= "so_milehigh_start_defeat";		// I'm counting on you. Defeat them.
	level.scr_radio[ "so_milehigh_start_finish" ] 			= "so_milehigh_start_finish";		// It's all up to you.  Finish it.
}

/*************************************************************************************************
	setupDialogOverrides
	self = level
**************************************************************************************************/
setupDialogOverrides()
{
	level.so_dialog_func_override = [];
	level.so_dialog_func_override[ "ready_up" ]				= ::dialogReadyUp;
	level.so_dialog_func_override[ "success_best" ]			= ::dialogSuccess;
	level.so_dialog_func_override[ "success_generic" ]		= ::dialogSuccess;
	level.so_dialog_func_override[ "failed_generic" ]		= ::dialogFailedGeneric;
	level.so_dialog_func_override[ "failed_time" ]			= ::dialogFailedTime;
	level.so_dialog_func_override[ "failed_bleedout" ]		= ::dialogFailedGeneric;
	level.so_dialog_func_override[ "time_low_normal" ]		= ::dialogTimeLow;
	level.so_dialog_func_override[ "time_low_hurry" ]		= ::dialogTimeHurry;
	level.so_dialog_func_override[ "killing_civilians" ]	= ::dialogVoid;
	level.so_dialog_func_override[ "progress_goal_status" ]	= ::dialogVoid;
	level.so_dialog_func_override[ "time_status_late" ]		= ::dialogVoid;
	level.so_dialog_func_override[ "time_status_good" ]		= ::dialogVoid;
	level.so_dialog_func_override[ "progress" ]				= ::dialogVoid;
}

/*************************************************************************************************
	dialogVoid - dummy function so nothing happens on certain dialog overrides
	self = level
**************************************************************************************************/
dialogVoid(arg)
{
}

/*************************************************************************************************
	dialogReadyUp
	self = level
**************************************************************************************************/
dialogReadyUp()
{
	so_dialog_play( "so_milehigh_start_finish", 0, true );
}

/*************************************************************************************************
	dialogTimeLow
	self = level
**************************************************************************************************/
dialogTimeLow()
{
	so_dialog_play( "so_milehigh_time_generic" );
}

/*************************************************************************************************
	dialogTimeHurry
	self = level
**************************************************************************************************/
dialogTimeHurry()
{
	so_dialog_play( "so_milehigh_time_hurry" );
}

/*************************************************************************************************
	dialogFailedGeneric
	self = level
**************************************************************************************************/
dialogFailedGeneric()
{
	if ( IsDefined( level.so_milehigh_played_time_failed_dialog ) && level.so_milehigh_played_time_failed_dialog )
	{
		return;
	}
	
	if ( IsDefined( level.president_dead ) && level.president_dead )
	{
		so_dialog_play( "so_milehigh_fail_objective" );
		return;
	}
	
	random_dialog = RandomInt(4);
	switch ( random_dialog )
	{
		case 0:
			so_dialog_play( "so_milehigh_fail_no_defeat" );
			break;
		case 1:
			so_dialog_play( "so_milehigh_fail_been_defeated" );
			break;
		case 2:
			so_dialog_play( "so_milehigh_fail_next_fight" );
			break;
		case 3:
			so_dialog_play( "so_milehigh_fail_happen_again" );
			break;
	}
}

/*************************************************************************************************
	dialogFailedTime
	self = level
**************************************************************************************************/
dialogFailedTime()
{
	level.so_milehigh_played_time_failed_dialog = true;
	so_dialog_play( "so_milehigh_fail_cowards" );
}

/*************************************************************************************************
	dialogSuccess
	self = level
**************************************************************************************************/
dialogSuccess(do_sarcasm)
{
	if ( !isdefined( do_sarcasm ) )
	{
		do_sarcasm = false;
		if ( level.gameSkill >= 3 )
		{
			if ( has_been_played() )
				do_sarcasm = cointoss();
		}
	}
	
	if ( do_sarcasm )
		so_dialog_play( "so_milehigh_win_jerk", 0.5, true );
	else
	{
		random_dialog = RandomInt(6);
		switch ( random_dialog )
		{
			case 0:
				so_dialog_play( "so_milehigh_win_served_well", 0.5, true );
				break;
			case 1:
				so_dialog_play( "so_milehigh_win_victory", 0.5, true );
				break;
			case 2:
				so_dialog_play( "so_milehigh_win_enemy_defeated", 0.5, true );
				break;
			case 3:
				so_dialog_play( "so_milehigh_win_well_done", 0.5, true );
				break;
			case 4:
				so_dialog_play( "so_milehigh_win_victorious", 0.5, true );
				break;
			case 5:
				so_dialog_play( "so_milehigh_win_victory_ours", 0.5, true );
				break;
		}
	}
}

/*************************************************************************************************
	fixSP
	self = level
**************************************************************************************************/
fixSP()
{
	// hack for audio triggers so they won't SRE (just delete them i guess)
	entities = GetEntArray();
	foreach ( entity in entities )
	{
		if ( !( IsSubStr( entity.classname, "trigger" ) ) )
		{
			continue;
		}
		
		if ( 	!IsDefined( entity.script_audio_zones ) && !IsDefined( entity.audio_zones ) && !IsDefined( entity.ambient ) &&
		    ( IsDefined( entity.script_audio_enter_msg )
			|| IsDefined( entity.script_audio_exit_msg )
			|| IsDefined( entity.script_audio_progress_msg )
			|| IsDefined( entity.script_audio_enter_func )
			|| IsDefined( entity.script_audio_exit_func )
			|| IsDefined( entity.script_audio_progress_func )
			|| IsDefined( entity.script_audio_point_func ) ) )
		{
			entity Delete();
		}
	}
	
//	foodcart = GetEnt( "foodcart", "targetname" );
//	foodcart Delete();
	
	plane_extra_wings_and_exterior = GetEnt( "hijack_crash_model_exterior", "script_noteworthy" );
	plane_extra_wings_and_exterior Delete();
	
	plane_tail_extra_pieces = GetEntArray( "hijack_crash_plane_model", "targetname" );
	foreach( piece in plane_tail_extra_pieces )
	{
		if ( piece.model == "hijack_plane_crash_exterior_rear_shell" )
		{
			piece Delete();
			break;
		}
	}
	
	//hack to remove overlapping vision set triggers that are spamming the set vision command
	//there is only one vision trigger with the vision set of "hijack_cargo", "hijack_conference", and "hijack_airplane_combat"
	vision_triggers = GetEntArray("trigger_multiple_visionset","classname");
	foreach(trigger in vision_triggers)
	{
		if(IsDefined(trigger.script_visionset))	   
		{
			if(trigger.script_visionset == "hijack_cargo")
			{
				trigger Delete();
			}
			else if( trigger.script_visionset == "hijack_conference")
			{
				trigger Delete();
			}
			else if ( trigger.script_visionset == "hijack_airplane_combat" )
			{
				trigger Delete();
			}
		}
	}
	
	//so_delete_all_triggers();
	//so_delete_all_spawners();
	//so_delete_all_by_type( ::type_goalvolume, ::type_infovolume );
}


/*************************************************************************************************
	setupSP
	self = level
**************************************************************************************************/
setupSP()
{
	// copied from hijack::setup(); - needed to turn off some of it
	PreCacheShellShock( "hijack_airplane" );
	PreCacheShellShock( "hijack_minor" );
	PreCacheShellShock( "hijack_slowview" );
	PreCacheShellShock( "default" );
	PreCacheShellShock( "dcburning" );
	PreCacheShellShock( "hijack_door_explosion" );
	PreCacheShellShock( "hijack_engine_explosion" );
	PreCacheShellShock( "hijack_tail_explosion" );
	PreCacheShellShock( "hijack_end_scene" );
	precacherumble( "hijack_plane_low");
	precacherumble( "hijack_plane_medium");
	precacherumble( "hijack_plane_large");
			
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );
	
	thread set_vision_set( "hijack_airplane", 1 );
	
	level.debate_trigger = getEnt( "player_debate_trigger", "script_noteworthy" );
	level.debate_trigger trigger_off();
		
	if ( getdvar( "airmasks" ) == "" )
	setdvar( "airmasks", "1" );
			
//	maps\_drone_ai::init();
	
	level.player SetWeaponAmmoStock( "fnfiveseven", 60 );
	
	level.orig_phys_gravity = GetDvar( "phys_gravity" );
	level.orig_ragdoll_gravity = GetDvar( "phys_gravity_ragdoll" );
	level.orig_WakeupRadius = GetDvar( "phys_gravityChangeWakeupRadius" );
	level.orig_ragdoll_life = GetDvar( "ragdoll_max_life" );
	level.orig_sundirection = (-14, 114, 0); //GetMapSunAngles(); this won't work since this area of plane is in a "stage" volume.
	
	level.org_view_roll = getent( "org_view_roll", "targetname" );
	assert( isdefined( level.org_view_roll ) );
	level.player playerSetGroundReferenceEnt( level.org_view_roll );
	level.aRollers = [];
	level.aRollers = array_add( level.aRollers, level.org_view_roll );

	level.conf_lights_off = GetEntArray( "conf_light_off", "targetname" );
	array_call(level.conf_lights_off, ::hide);
	
	airmasks = getentarray( "airmask", "targetname" );
	array_thread( airmasks, maps\hijack_code::airmask_setup );
	
	level.seatbeltsigns = getentarray( "seatbelt_signs", "targetname" );
	array_call(level.seatbeltsigns, ::hide);
	
	level.crash_models = GetEntArray("hijack_crash_plane_model", "targetname");	

//	thread manage_tail_models();
	thread maps\hijack::setup_volumetric_lights();
	thread maps\hijack::setup_object_mass();
	thread maps\hijack::no_grenade_death_hack();
	thread maps\hijack::setup_tarmac_triggers();
	thread maps\hijack::setup_hijack_specific_lights();
	
	thread maps\hijack::pause_inflight_fx();
	thread maps\hijack::pause_tarmac_fx();
	thread maps\hijack::pause_fuselage_fire_fx();
	thread maps\hijack::pause_wreckage_interior_fx();
}

/*************************************************************************************************
	setupPlane
	self = level
**************************************************************************************************/
setupPlane()
{
	maps\_slowmo_breach::slowmo_breach_init();
	maps\_slowmo_breach::add_breach_func( ::breachStart );
	maps\_anim::addNotetrack_customFunction( "active_breacher_rig", "slowmo", ::postSlowmoBegins );
	
	level thread maps\hijack::show_tail_models();
	level thread maps\hijack_crash_fx::pre_sled_light();
	level thread maps\hijack::setup_cloud_tunnel();
	level thread maps\hijack::setup_turbines();
	//level thread maps\hijack_crash_fx::handle_crash_lights();
	
	maps\_compass::setupMiniMap("compass_map_hijack_airplane", "airplane_upper_minimap_corner");
	setsaveddvar( "compassmaxrange", 1500 ); //default is 3500
	
	level thread setupGlass();
}

/*************************************************************************************************
	setupGlass
	self = level
**************************************************************************************************/
setupGlass()
{
	level endon( "special_op_terminated" );
	
	// delete the clip on the tactical room glass after slowmo so they player has a chance of seeing it break
	clip = GetEnt("glass_blocking_clip","targetname");
	level waittill( "slowmo_breach_ending" );
	wait 2;
	clip Delete();
}

/*************************************************************************************************
	setupStart
	self = level
**************************************************************************************************/
setupStart()
{
	level endon( "special_op_terminated" );
	
	breach_trigger = GetEnt( "so_first_breach_trigger", "targetname" );
	breach_trigger SetHintString( "" );
		
	waittillBothPlayersWeaponsAreReady();
	breach_trigger notify( "trigger", level.players[0] );
	level notify( "so_players_ready" );
	
	foreach ( player in level.players )
	{
		player FreezeControls( false );
	}
}

/*************************************************************************************************
	setupPlayers
	self = level
**************************************************************************************************/
setupPlayers()
{
	foreach ( player in level.players )
	{
		// make it so both players get their view tilted
		player playerSetGroundReferenceEnt( level.org_view_roll );
		
		// can't have the players doing something before the initial breach starts
		player FreezeControls( true );
		
		// keep track of the damage each player receives
		player thread playerDetectDamage();
		
		// show num times damaged on the HUD
		player thread playerShowDamagedHUD();
		
		// show accuracy on the HUD
		player thread playerShowAccuracyHUD();
	}
}

/*************************************************************************************************
	playerDetectDamage
	self = player
**************************************************************************************************/
playerDetectDamage()
{
	level endon( "special_op_terminated" );
	
	self.num_times_damaged = 0;
	
	while ( true )
	{
		self waittill("damage", damage, attacker, direction, point, type );
		self.num_times_damaged++;	
		self notify( "milehigh_damage" );
	}
}

/*************************************************************************************************
	playerShowAccuracyHUD
	self = player
**************************************************************************************************/
playerShowAccuracyHUD()
{
	level endon( "special_op_terminated" );
	
	ypos = maps\_specialops::so_hud_ypos();
	self.hud_so_accuracy_msg = maps\_specialops::so_create_hud_item( 4, ypos, &"SO_MILEHIGH_HIJACK_ACCURACY_HUD", self );
	self.hud_so_accuracy_count = maps\_specialops::so_create_hud_item( 4, ypos, &"SO_MILEHIGH_HIJACK_ACCURACY_HUD_PERCENT", self );
	self.hud_so_accuracy_count.alignX = "left";
	
	self thread maps\_specialops::info_hud_handle_fade( self.hud_so_accuracy_msg );
	self thread maps\_specialops::info_hud_handle_fade( self.hud_so_accuracy_count );
	
	accuracy = 100;
	
	while ( 1 )
	{
		shots_fired = max( 1, float( self.stats[ "shots_fired" ] ) );
		shots_hit = max( 1, float( self.stats[ "shots_hit" ] ) );
		
		accuracy = shots_hit / shots_fired;
		accuracy = int(accuracy * 100);	
		
		self.hud_so_accuracy_count SetValue(accuracy);
		wait 0.1;
	}
}

/*************************************************************************************************
	playerShowDamagedHUD
	self = player
**************************************************************************************************/
playerShowDamagedHUD()
{
	level endon( "special_op_terminated" );
	
	ypos = maps\_specialops::so_hud_ypos();
	self.hud_so_damaged_msg = maps\_specialops::so_create_hud_item( 3, ypos, &"SO_MILEHIGH_HIJACK_DAMAGED_HUD", self );
	self.hud_so_damaged_count = maps\_specialops::so_create_hud_item( 3, ypos, undefined, self );
	self.hud_so_damaged_count SetText( 0 );
	self.hud_so_damaged_count.alignX = "left";
	
	self thread maps\_specialops::info_hud_handle_fade( self.hud_so_damaged_msg );
	self thread maps\_specialops::info_hud_handle_fade( self.hud_so_damaged_count );
	
	self thread playerDamagedHUDSetColor();
	
	while( true )
	{
		self waittill( "milehigh_damage" );
		self.hud_so_damaged_count SetText( self.num_times_damaged );
	}
}

/*************************************************************************************************
	playerDamagedHUDSetColor
	self = player
**************************************************************************************************/
playerDamagedHUDSetColor()
{
	level endon( "special_op_terminated" );
	
	num_damage_to_yellow = int( ( CONST_SCORE_DAMAGED / CONST_LOST_SCORE_PER_DAMAGE ) / 2 );
	num_damage_to_red = int( CONST_SCORE_DAMAGED / CONST_LOST_SCORE_PER_DAMAGE );

	self.hud_so_damaged_count set_hud_green();
	self.hud_so_damaged_msg set_hud_green();
	current = "green";
	
	while ( true )
	{
		if ( self.num_times_damaged >= num_damage_to_red )
		{
			self.hud_so_damaged_count set_hud_red();
			self.hud_so_damaged_msg set_hud_red();
			break;
		}
		else if ( current != "yellow" && self.num_times_damaged >= num_damage_to_yellow )
		{
			self.hud_so_damaged_count set_hud_yellow();
			self.hud_so_damaged_msg set_hud_yellow();
			current = "yellow";
		}
		wait 0.1;
	}
}

/*************************************************************************************************
	waittillBothPlayersWeaponsAreReady
	self = level
**************************************************************************************************/
waittillBothPlayersWeaponsAreReady()
{
	level endon( "special_op_terminated" );
	
	wait_for_beginning_weapon_switch = true;
	while ( wait_for_beginning_weapon_switch )
	{
		if ( level.players[0] IsSwitchingWeapon() || level.players[0] using_illegal_breach_weapon() )
		{
			waitframe();
			continue;
		}
		
		if ( level.players.size == 2 && ( level.players[1] IsSwitchingWeapon() || level.players[0] using_illegal_breach_weapon() ) )
		{
			waitframe();
			continue;
		}
		
		wait_for_beginning_weapon_switch = false;
	}
}

/*************************************************************************************************
	postSlowmoBegins
	self = level
**************************************************************************************************/
postSlowmoBegins(rig)
{
	// turn off bullet_penetration_damage, it is enabled by default in case hostages are in the room so that
	// bullet penetrations does not go past the first AI you hit, but it causes strangeness where the death anim/ragdoll
	// is not visually where the bullet trace thinks it is, thus it feels like you have a clean shot but you don't
	SetSavedDvar( "bullet_penetration_damage", 1 );
}

/*************************************************************************************************
	breachStart
	self = level
**************************************************************************************************/
breachStart(rig)
{
	level endon( "special_op_terminated" );
	
	if ( !flag( "so_player_upstairs" ) )
	{
		// first breach downstairs - cargo room
		flag_set( "lower_floor_first_terrorists" );
		flag_set( "so_milehigh_hijack_start" );
		aud_send_msg("start_lower_level_combat");
		
		// open the cargo door
		level thread openCargoDoor();
		
		level waittill( "slowmo_breach_ending", slomoLerpTime_out );
		// change slowmo time for the second breach
		level.slomobreachduration = 2.5;
	}
	else
	{
		// second breach upstairs - debate room
		flag_set( "so_begin_debate_breach" );
		flag_set("door_breach");
		
		// get rid of the bsp script brushmodel door
		level.door4 delete();
		
		level waittill( "slowmo_breach_ending", slomoLerpTime_out );

		// start the counter breach if the player does not move forward
		flag_set( "so_counter_breach" );
	}
	
	// this will happen after the slowmo ends:
	// it is possible to end a slowmo early in the second breach and still have guys, reset their health
	breach_ai = GetAIArray();
	foreach ( guy in breach_ai )
	{
		if ( IsDefined( guy.script_noteworthy ) && guy.script_noteworthy == "so_president" )
		{
			// don't need to change his stats
			continue;
		}
		
		if ( guy.baseaccuracy != 5000 )
		{
			// not involved in the breach
			continue;
		}
		
		guy.health = 150;
		guy.baseaccuracy = level.new_enemy_accuracy;
	}
}

/*************************************************************************************************
	openCargoDoor
	self = level
**************************************************************************************************/
#using_animtree( "animated_props" );
openCargoDoor()
{
	level endon( "special_op_terminated" );
	
	foreach(model in level.crash_models)
	{
		model.animname = "generic";
		model UseAnimTree(#animtree);	
	}
	
//	props = getent("hijack_crash_model_props", "script_noteworthy");
//	props thread anim_loop_solo(props, "hijack_pre_plane_crash_compartments", "stop loop");
	
	doorprop = getent("hijack_crash_model_front_interior", "script_noteworthy");
	aud_send_msg("pre_crash_door");
	doorprop thread anim_single_solo(doorprop, "hijack_pre_plane_crash_door");
	
	
	crash_door_blocker = getent("crash_door_blocker", "targetname");
	crash_door_blocker delete();
	
	waitframe();
	doorprop thread anim_self_set_time( "hijack_pre_plane_crash_door", 0.99 );
}

/*************************************************************************************************
	setupAnims
	self = level
**************************************************************************************************/
setupAnims()
{
	setupEnemyAnims();
	setupPlayerAnims();
}

/*************************************************************************************************
	setupEnemyAnims
	self = level
**************************************************************************************************/
#using_animtree( "generic_human" );
setupEnemyAnims()
{
	level.scr_anim[ "generic" ][ "payback_breach_react_soldier_4" ] 				= %payback_breach_react_soldier_4;
	level.scr_anim[ "generic" ][ "payback_breach_crateguy" ] 						= %payback_breach_crateguy;
	level.scr_anim[ "generic" ][ "payback_breach_doorguy" ] 						= %payback_breach_doorguy;
	level.scr_anim[ "generic" ][ "ny_harbor_bulkhead_door_breach_stunned_guy1" ] 	= %ny_harbor_bulkhead_door_breach_stunned_guy1;
	level.scr_anim[ "generic" ][ "ny_harbor_bulkhead_door_breach_stunned_guy2" ] 	= %ny_harbor_bulkhead_door_breach_stunned_guy2;
	
	// custom animations for the debate breach since it ends differently in the spec ops version as opposed to the SP version
	level.scr_anim[ "so_advisor" ][ "debate" ]				 						= %so_milehigh_breach_reaction_advisor_start;
	level.scr_anim[ "so_advisor" ][ "debate_cine_advisor_end_loop" ][0]				= %so_milehigh_breach_reaction_advisor_loop;
	level.scr_anim[ "so_agent2" ][ "debate" ]										= %so_milehigh_breach_reaction_agent2;
	level.scr_anim[ "so_commander" ][ "debate" ]				 					= %so_milehigh_breach_reaction_commander;
	level.scr_anim[ "so_hero_agent" ][ "debate" ]									= %so_milehigh_breach_reaction_hero_agent;
	level.scr_anim[ "so_flashbang_enemy" ][ "so_milehigh_breach_flashbang_toss" ]	= %so_milehigh_breach_flashbang_toss;
	level.scr_anim[ "so_advisor" ][ "couch_death" ]										= %so_milehigh_breach_advisor_death;
}

/*************************************************************************************************
	setupPlayerAnims
	self = level
**************************************************************************************************/
#using_animtree( "multiplayer" );
setupPlayerAnims()
{	
	level.scr_animtree[ "player_slide_stumble" ] 						= #animtree;
	level.scr_model[ "player_slide_stumble" ] 							= "viewmodel_base_viewhands";
	level.scr_anim[ "player_slide_stumble" ][ "pb_stumble_forward" ] 	= %pb_stumble_forward;
	level.scr_anim[ "player_slide_stumble" ][ "pb_stumble_back" ] 		= %pb_stumble_back;
	level.scr_anim[ "player_slide_stumble" ][ "pb_stumble_left" ] 		= %pb_stumble_left;
	level.scr_anim[ "player_slide_stumble" ][ "pb_stumble_right" ] 		= %pb_stumble_right;
	level.scr_anim[ "player_slide_stumble" ][ "root" ]					= %code;
}

/*************************************************************************************************
	playerPlayCoopSlideAnim
	self = player
**************************************************************************************************/
playerPlayCoopSlideAnim(slide_direction_vector)
{
	level endon( "special_op_terminated" );
	
	// no need to do this when not in coop
	if ( !is_coop() )
	{
		return;
	}
	
	// otherwise disable ability to change stance since will be in the middle of an animation
	else if ( self GetStance() == "stand" )
	{
		self AllowCrouch( false );
		self AllowProne( false );
	}
	else
	{
		self AllowStand( false );
		self AllowProne( false );
	}
	self AllowJump( false );
	
	// calculate which direction we are in reference to the slide
	normal_slide_dir = VectorNormalize( slide_direction_vector );
	normal_player_dir = VectorNormalize( AnglesToForward( self.angles ) );
	dot_product = VectorDot( normal_slide_dir, normal_player_dir );
	angle_between = ACos( dot_product );
	
	animation = undefined; 
	
	if ( angle_between < 45 ) // 0 - 45 degrees is forward
	{
		animation = "pb_stumble_forward";
	}
	else if ( angle_between > 135 ) // 135 - 180 is backward
	{
		animation = "pb_stumble_back";
	}
	else  // 45 - 135 is left or right
	{
		is_left = isLeft(normal_player_dir, normal_slide_dir);
		if ( is_left )
		{
			animation = "pb_stumble_left";
		}
		else
		{
			animation = "pb_stumble_right";
		}
	}

	//IPrintLnBold( animation );
	
	// play the correct anim depending on which direction we are facing
	self.animname = "player_slide_stumble";
	self thread anim_single_solo( self, animation );
	
	waitframe();
	
	// allow stances now that the anim is done
	self AllowCrouch( true );
	self AllowStand( true );
	self AllowProne( true );
	self AllowJump( true );
}

/*************************************************************************************************
	isLeft
	self = level
**************************************************************************************************/
isLeft( vec1, vec2 )
{
	return( vec1[ 0 ] * vec2[ 1 ] - vec1[ 1 ] * vec2[ 0 ] > 0 );
}

/*************************************************************************************************
	setupDifficulty
	self = level
**************************************************************************************************/
setupDifficulty()
{
	maps\hijack_code::so_remove_entities_by_script_difficulty();
	
	assert( isdefined( level.gameskill ) );
	
	switch( level.gameSkill )
	{
		case 0:									// Easy
		case 1:	soMilehighRegular();	break;	// Regular
		case 2:	soMilehighHardened();	break;	// Hardened
		case 3:	soMilehighVeteran();	break;	// Veteran
	}
	
	if( is_coop() )
	{
		level.max_kills = CONST_MAX_KILLS_COOP;
	}
	
}

/*************************************************************************************************
	soMilehighRegular
	self = level
**************************************************************************************************/
soMilehighRegular()
{
	level.challenge_time_limit 	= CONST_TIME_REGULAR;
	level.new_enemy_accuracy	= CONST_ENEMY_ACCURACY;
	level.max_kills 			= CONST_MAX_KILLS_SP_REGULAR;
}

/*************************************************************************************************
	soMilehighHardened
	self = level
**************************************************************************************************/
soMilehighHardened()
{
	level.challenge_time_limit 	= CONST_TIME_HARDENED;
	level.new_enemy_accuracy	= CONST_ENEMY_ACCURACY;
	level.max_kills 			= CONST_MAX_KILLS_SP_HARDENED;
}

/*************************************************************************************************
	soMilehighVeteran
	self = level
**************************************************************************************************/
soMilehighVeteran()
{
	level.challenge_time_limit 	= CONST_TIME_VETERAN;
	level.new_enemy_accuracy	= CONST_ENEMY_ACCURACY;
	level.max_kills 			= CONST_MAX_KILLS_SP_VETERAN;	
}

/*************************************************************************************************
	setupObjectives
	self = level
**************************************************************************************************/
setupObjectives()
{
	level endon( "special_op_terminated" );
	
	obj_pos_1 = getstruct( "so_upstairs", "targetname" );
	obj_pos_2 = getstruct( "so_obj_find_president", "targetname" );
	Objective_Add( 1, "current", &"SO_MILEHIGH_HIJACK_OBJECTIVE_FIND" );
	Objective_SetPointerTextOverride( 1, "" );
	Objective_Position( 1, obj_pos_1.origin );
	flag_wait( "so_player_upstairs" );
	Objective_Position( 1, obj_pos_2.origin );
	flag_wait( "so_obj_find_president" );
	objective_complete( 1 );
	Objective_Add( 2, "current", &"SO_MILEHIGH_HIJACK_OBJECTIVE_CAPTURE" );
	objective_breach( 2, 2);
	flag_wait( "so_president_spawned" );
	level.so_president waittill( "so_debate_anim_started" );
	waitframe();
	setsaveddvar( "objectiveHide", false );
	Objective_SetPointerTextOverride( 2, &"SO_MILEHIGH_HIJACK_CAPTURE" );
	//Objective_OnEntity( 2, level.so_president );
	level.so_president thread presidentUpdateCaptureObjective();
	flag_wait( "so_president_captured" );
	level.so_president.so_no_mission_over_delete = true;
	level.so_president SetHintString( "" );
	flag_set( "so_milehigh_hijack_complete" );
	objective_complete( 2 );
}

/*************************************************************************************************
	presidentUpdateCaptureObjective
	self = president
**************************************************************************************************/
presidentUpdateCaptureObjective()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	while ( !flag( "so_president_captured" ) )
	{
		origin = self.origin + ( 0, 0, 32 );
		Objective_Position( 2, origin );
		waitframe();
	}
}

/*************************************************************************************************
	setupChallenge
	self = level
**************************************************************************************************/
setupChallenge()
{
	level thread enable_challenge_timer( "so_milehigh_hijack_start", "so_milehigh_hijack_complete" );
	level thread fade_challenge_in(1.5, 1);
	level thread fade_challenge_out( "so_milehigh_hijack_complete", 0 );
	
	level.milehigh_num_enemies = 0;
	
	level.custom_eog_no_defaults = 1;
	level.eog_summary_callback = ::customEOGSummary;
	
	// turn on the timer and keep it on
	level waittill( "so_players_ready" );
	waitframe();
	foreach ( player in level.players )
	{
		player notify( "force_challenge_timer" );
	}
}

/*************************************************************************************************
	customEOGSummary
	self = level
**************************************************************************************************/
customEOGSummary()
{
	// 10000 score breakdown:
	// no damage taken = 3000
	// accuracy = 2000
	// within time = 5000
	
	session_time = int( min( ( level.challenge_end_time - level.challenge_start_time ), 86400000 ) );
	total_accuracy = 0;
	total_damage_taken = 0;

	// grab initial stats
	//-------------------
	foreach ( player in level.players )
	{
		player.so_eog_summary_data[ "damaged" ]			= player.num_times_damaged;

		shots_fired = max( 1, float( player.stats[ "shots_fired" ] ) );
		shots_hit = max( 1, float( player.stats[ "shots_hit" ] ) );
		
		accuracy_float = shots_hit / shots_fired;
		accuracy_display = int( accuracy_float * 100 );
		
		player.so_eog_summary_data[ "accuracy" ]		= accuracy_display;
		
		total_accuracy += accuracy_float;
		total_damage_taken += player.so_eog_summary_data[ "damaged" ];
	}
	
	// determine score
	// ---------------
	
	// base score 10000 per difficulty
	difficulty_points = int( level.specops_reward_gameskill * 10000 );
	level.session_score = difficulty_points;
	
	// calculate time score
	// give up to 5000 points for completing the mission in the time frame (not possible to get all of the points)
	lowest_possible_time = 20000; // not possible to beat legitimately under this time
	worst_time = level.challenge_time_limit * 1000;
	modified_time = max( 0, (session_time - lowest_possible_time) );
	session_time_score = 0;
	if ( session_time < worst_time )
		session_time_score = int ( ( ( worst_time - modified_time ) / worst_time ) * CONST_SCORE_TIME );
	level.session_score += session_time_score;
	
	// calculate kill score
	// kills are worth 25 points each.  in most SpecOps maps, this maximizes at 100 kills for 2500 points.
	// however, we don't have 100 guys.  So, we award 25 points per kill, and the remainder of the 2500 goes toward bonus
	// regular SP - 26 kills + president		650 possible points for kills, 
	// hardened SP - 31 kills + president		775 possible points for kills,
	// veteran SP - 36 kills + president		900 possible points for kills,
	// regular co-op - 38 kills + president		950 possible points for kills,
	// hardened co-op - 38 kills + president	950 possible points for kills,
	// veteran co-op - 38 kills + president		950 possible points for kills,
	
	kill_score = CONST_SCORE_PER_KILL * level.players[0].so_eog_summary_data[ "kills" ];
	if( is_coop() )
	{
		kill_score += CONST_SCORE_PER_KILL * get_other_player( level.players[0] ).so_eog_summary_data[ "kills" ];
	}
	level.session_score += kill_score;
	
	// calculate accuracy score
	// give up to (2000 - maximum kill points) for perfect accuracy
	accuracy_avg = total_accuracy / level.players.size;
	skill_based_accuracy_max = CONST_SCORE_ACCURACY - ( level.max_kills * CONST_SCORE_PER_KILL );
	accuracy_points = int( skill_based_accuracy_max * accuracy_avg );
	level.session_score += accuracy_points;
	
	// calculate damage taken score
	// give up to 3000 points for not taking any damage
	damage_taken_avg = total_damage_taken / level.players.size;
	lost_score_via_damage_taken = min( (CONST_LOST_SCORE_PER_DAMAGE * damage_taken_avg), CONST_SCORE_DAMAGED );
	damage_taken_points = int(CONST_SCORE_DAMAGED - lost_score_via_damage_taken);
	level.session_score += damage_taken_points;

	foreach ( player in level.players )
		player override_summary_score( level.session_score );
	
//	challenge_time_string = convert_to_time_string( level.challenge_time_limit, true );
	
	diffString[ 0 ] = "@MENU_RECRUIT";
	diffString[ 1 ] = "@MENU_REGULAR";
	diffString[ 2 ] = "@MENU_HARDENED";
	diffString[ 3 ] = "@MENU_VETERAN";
	
	score_label = undefined;
	col1_lable = undefined;
	col2_lable = undefined;
	col3_lable = undefined;
	
	if ( is_coop() )
	{
		score_label = "@SPECIAL_OPS_UI_TEAM_SCORE";
		col1_lable = "@SPECIAL_OPS_PERFORMANCE_YOU";
		col2_lable = "@SPECIAL_OPS_PERFORMANCE_PARTNER";
		col3_lable = "@SPECIAL_OPS_POINTS";
	}
	else
	{
		score_label = "@SPECIAL_OPS_UI_SCORE";
		col1_lable = "";//"@SPECIAL_OPS_COUNT";
		col2_lable = "@SPECIAL_OPS_POINTS";
	}
	
	clear_custom_eog_summary();
	
	foreach ( player in level.players )
	{
		accuracy		= player.so_eog_summary_data[ "accuracy" ];
		damage			= player.so_eog_summary_data[ "damaged" ];
		seconds 		= player.so_eog_summary_data[ "time" ] * 0.001;
		time_string 	= convert_to_time_string( seconds, true );
		diff 			= diffString[ player.so_eog_summary_data[ "difficulty" ] ];
		final_score 	= player.so_eog_summary_data[ "score" ];
		kills 			= player.so_eog_summary_data[ "kills" ];

		if ( is_coop() )
		{
			p2_accuracy 	= get_other_player( player ).so_eog_summary_data[ "accuracy" ];
			p2_damage 		= get_other_player( player ).so_eog_summary_data[ "damaged" ];
			p2_diff 		= diffString[ get_other_player( player ).so_eog_summary_data[ "difficulty" ] ];
			p2_kills 		= get_other_player( player ).so_eog_summary_data[ "kills" ];

			if ( !level.missionfailed )
			{
				player add_custom_eog_summary_line( "",										col1_lable,		col2_lable, 	col3_lable,				1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 			p2_diff, 		difficulty_points,		2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 	time_string,	session_time_score,		3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 			p2_kills, 		kill_score,				4 );
				player add_custom_eog_summary_line( "@SO_MILEHIGH_HIJACK_ACCURACY", 		accuracy+"%", 	p2_accuracy+"%", accuracy_points,		5 );
				player add_custom_eog_summary_line( "@SO_MILEHIGH_HIJACK_DAMAGED", 			damage, 		p2_damage, 		damage_taken_points,	6 );

				if( !issplitscreen() )
					player add_custom_eog_summary_line_blank();
					
				player add_custom_eog_summary_line( score_label, 							final_score, 	undefined, 		undefined);
			}
			else
			{
				player add_custom_eog_summary_line( "",										col1_lable,			col2_lable, 		undefined,			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				p2_diff, 			undefined,			2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		time_string,		undefined,			3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				p2_kills, 			undefined,			4 );
			}
		}
		else
		{
			if ( !level.missionfailed )
			{
				player add_custom_eog_summary_line( "",										col1_lable,		col2_lable, 			col3_lable,	1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 			difficulty_points, 		undefined,	2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 	session_time_score,		undefined,	3 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 			kill_score, 			undefined,	4 );
				player add_custom_eog_summary_line( "@SO_MILEHIGH_HIJACK_ACCURACY", 		accuracy+"%", 	accuracy_points, 		undefined,	5 );
				player add_custom_eog_summary_line( "@SO_MILEHIGH_HIJACK_DAMAGED", 			damage, 		damage_taken_points, 	undefined,	6 );
				
				if( !issplitscreen() )
					player add_custom_eog_summary_line_blank();
				
				player add_custom_eog_summary_line( score_label, 							final_score, 	undefined, 				undefined);
			}
			else
			{
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_DIFFICULTY", 			diff, 				undefined, 			undefined,			1 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_TIME", 				time_string, 		undefined,			undefined,			2 );
				player add_custom_eog_summary_line( "@SPECIAL_OPS_UI_KILLS", 				kills, 				undefined, 			undefined,			3 );
			}
		}
	}
	
	if ( !level.missionfailed )
	{
		setdvar( "ui_hide_hint", 1 );
	}
	else
	{
		setdvar( "ui_hide_hint", 0 );
	}
}

/*************************************************************************************************
	setupEnemies
	self = level
**************************************************************************************************/
setupEnemies()
{
	// setup counter breach enemies
	addSpawnFunctionByName( "so_conference_room_hall", ::enemyCounterBreach );
	addSpawnFunctionByName( "so_conference_room_hall", ::enemyMustKillToCapture );
	addSpawnFunctionByName( "so_conference_room_hall_flash_bang", ::enemyMustKillToCapture );
	
	// setup enemy counting
	addSpawnFunctionByName( "lower_floor_first_terrorists", ::enemyBasicSetup );
	addSpawnFunctionByName( "lower_floor_second_terrorists", ::enemyBasicSetup );
	addSpawnFunctionByName( "lower_floor_terrorists", ::enemyBasicSetup );
	addSpawnFunctionByName( "so_upper_floor_stairs", ::enemyBasicSetup );
	addSpawnFunctionByName( "so_last_hallway_rush", ::enemyBasicSetup );
	addSpawnFunctionByName( "so_upper_floor_hall", ::enemyBasicSetup );
	addSpawnFunctionByName( "so_conference_room_hall", ::enemyBasicSetup );
	addSpawnFunctionByName( "breach_enemy_spawner", ::enemyBasicSetup );
	
	level thread disableRandomGrenadeDeath();
}

/*************************************************************************************************
	disableRandomGrenadeDeath
	self = level
**************************************************************************************************/
disableRandomGrenadeDeath()
{
	while ( !IsDefined( anim.numDeathsUntilCornerGrenadeDeath ) )
	{
		wait 1;
		continue;
	}
	
	anim.numDeathsUntilCornerGrenadeDeath = 999999;
}

/*************************************************************************************************
	spawnEnemies
	self = level
**************************************************************************************************/
spawnEnemies()
{
	level endon( "special_op_terminated" );
	
	// spawn first enemies
	flag_wait( "lower_floor_first_terrorists" );
	if(noSlowMo())
		wait 1; //Give extra time if there isn't any slow mo
	spawnEnemiesByName( "lower_floor_first_terrorists" );
	
	// spawn tactical room 2nd
	flag_wait( "lower_floor_second_terrorists" );
	spawnEnemiesByName( "lower_floor_second_terrorists" );
	
	// spawn tactical room guy to melee
	flag_wait( "lower_floor_third_terrorists" );
	spawnEnemiesByName( "lower_floor_third_terrorists" );
	
	// spawn most of the lower floor enemies
	flag_wait( "lower_floor_terrorists" );
	spawnEnemiesByName( "lower_floor_terrorists" );
		
	// upper floor enemies
	flag_wait("so_upper_floor_stairs");
	spawnEnemiesByName( "so_upper_floor_stairs" );
	
	flag_wait("so_last_hallway_rush");
	spawnEnemiesByName( "so_last_hallway_rush" );
	
	flag_wait("so_upper_floor_rumble");
	spawnEnemiesByName( "so_upper_floor_hall" );
	
	// counter breach enemies
	flag_wait("so_conference_room_hall");
	if(noSlowMo())
		wait 4; //Give extra time if there isn't any slow mo
	spawnEnemiesByName( "so_conference_room_hall" );
}

/*************************************************************************************************
	spawnEnemiesByName
	self = level
**************************************************************************************************/
spawnEnemiesByName(targetname)
{
	spawners = GetEntArray( targetname, "targetname" );
	if ( spawners.size == 0 )
	{
		return;
	}
	return array_spawn( spawners, 1, 0 );
}

/*************************************************************************************************
	addSpawnFunctionByName
	self = level
**************************************************************************************************/
addSpawnFunctionByName(targetname, function)
{
	spawners = GetEntArray( targetname, "targetname" );
	if ( spawners.size == 0 )
	{
		return;
	}
	array_spawn_function( spawners, function );
}

/*************************************************************************************************
	enemyBasicSetup
	self = enemy
**************************************************************************************************/
enemyBasicSetup()
{
	// if this is the president, don't worry about him
	if ( IsDefined( self.script_noteworthy ) && self.script_noteworthy == "so_president" )
	{
		return;
	}
	
	// give them accuracy based on difficulty
	self.baseaccuracy = level.new_enemy_accuracy;
	
	// no grenades please
	self.grenadeammo = 0;
	
	// disable surprise reaction anims
	self.disableReactionAnims = true;
	
	// count them as a spawned enemy
	level.milehigh_num_enemies++;
}

/*************************************************************************************************
	enemyCounterBreach
	self = enemy
**************************************************************************************************/
enemyCounterBreach()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	// don't allow guys to flashbang themselves
	self setFlashbangImmunity( true );
	
	level waittill_either( "so_counter_breach_flash_activated", "flashbang_guy_killed" );
	wait 1;
	
	self setFlashbangImmunity( false );
}

/*************************************************************************************************
	lowerPlaneRumble
	self = level
**************************************************************************************************/
lowerPlaneRumble()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "so_lower_floor_rumble" );
	wait 2;

	// earthquake and sounds
	flag_set( "stop_rocking" );
	flag_set( "stop_constant_shake" );
	aud_send_msg("jet_roll_v01");
	aud_send_msg("turbine_wind_a");
	earthquake( .30, 5.5, level.player.origin, 80000 );
	
	// slide the players (not threaded so player animations can start)
	angles = ( 7, 90, 0 );
	slidePlayers(angles);
	
	// animate the plane tilt
	thread animatePlaneTiltView();
	
	// make enemies stumble
	thread maps\hijack_airplane::enemies_stumble();
	
	// throw items in the dining room
	wait(0.2);
	thread throwDiningRoomItems();
	
	wait(1);
	stopSlidingPlayers();
	wait(1);
//	wait(3.75);
	thread putRollersBackToZero();
	
	wait(1);
	flag_clear("stop_constant_shake");
	thread maps\hijack_airplane::constant_rumble();
}

/*************************************************************************************************
	slidePlayers
	self = level
**************************************************************************************************/
slidePlayers(angles)
{
	level.custom_linkto_slide = true;
	forward = AnglesToForward( angles );
	foreach ( player in level.players )
	{
		player PlayRumbleOnEntity( "hijack_plane_large" );
		player ViewKick(127, player.origin + (0,0,-220));
		player SetVelocity( forward * 110 );
		player playerPlayCoopSlideAnim(forward);
		player maps\hijack_code::hjk_BeginSliding();
	}
}

/*************************************************************************************************
	stopSlidingPlayers
	self = level
**************************************************************************************************/
stopSlidingPlayers()
{
	foreach ( player in level.players )
	{
		player maps\hijack_code::hjk_EndSliding();
	}
}

/*************************************************************************************************
	animatePlaneTiltView
	self = level
**************************************************************************************************/
animatePlaneTiltView()
{
	level endon( "special_op_terminated" );
	
	flag_set("stop_rocking");
	aud_send_msg("hallway_lurch", false);
	
	view_roller = spawn_anim_model( "upperhall_roller", level.player.origin);
	view_roller.angles = (0, 0, 0);
	view_roller anim_first_frame_solo( view_roller, "hallway_lurchcam" );
	
	player_ref = [];
	index = 0;
	foreach ( player in level.players )
	{
		player_ref[index] = spawn( "script_origin", player.origin );
		player_ref[index].angles = (0, 0, 0);
		player playerSetGroundReferenceEnt( player_ref[index] );
		
		player_ref[index] linkto( view_roller , "J_prop_1" );
		index++;
	}
		
	view_roller thread anim_single_solo( view_roller, "hallway_lurchcam" );
	
	view_roller waittillmatch( "single anim", "corpse_slump");
	thread maps\hijack_airplane::hallway_sun();
	array_thread( level.aRollers, maps\hijack_airplane::hallway_view_roll_obj );
	
	view_roller waittillmatch( "single anim", "end");
	
	foreach ( player in level.players )
	{
		player playerSetGroundReferenceEnt( level.org_view_roll );
	}
	
	array_delete(player_ref);
	view_roller delete();
}

/*************************************************************************************************
	throwDiningRoomItems
	self = level
**************************************************************************************************/
throwDiningRoomItems()
{
	objects_1 = GetEntArray("lower_level_room_1_objects","targetname");
	foreach (object in objects_1)
	{
		object thread maps\hijack_code::launch_object( RandomIntRange(200,240),( 0 , 1 , 0 ));
	}

	phys_explosion_origins = GetEntArray( "bar_room_physics", "targetname" );
	foreach (object in phys_explosion_origins)
	{
		object thread maps\hijack_code::start_phys_explosion_on_delay(64,64,0.65);
	}
}

/*************************************************************************************************
	putRollersBackToZero
	self = level
**************************************************************************************************/
putRollersBackToZero()
{
	array_thread( level.aRollers, maps\hijack_code::rotate_rollers_to, (0, 0, 0), 1, 0, 0 );
}

/*************************************************************************************************
	upperPlaneRumble
	self = level
**************************************************************************************************/
upperPlaneRumble()
{
	level endon( "special_op_terminated" );
	
	flag_wait( "so_upper_floor_rumble" );
	wait 0.7;
	
	// earthquake and sounds
	flag_set( "stop_rocking" );
	flag_set( "stop_constant_shake" );
	earthquake( .30, 5.5, level.player.origin, 80000 );
	
	// slide the players (not threaded so player animations can start)
	angles = ( 0, 90, 0 );
	slidePlayers(angles);
	
	// animate the plane tilt
	thread animatePlaneTiltView();
	
	// toss the cabinet's content
	thread maps\hijack_airplane::hallway_props();
	
	// sound it out
	aud_send_msg("hallway_lurch", false);

	// make enemies stumble
	thread maps\hijack_airplane::enemies_stumble();
		
	wait 1.2;
	stopSlidingPlayers();
	wait 1;
	thread putRollersBackToZero();
	
	wait(1);
	flag_clear("stop_constant_shake");
	thread maps\hijack_airplane::constant_rumble();
}

/*************************************************************************************************
	setupDoors
	self = level
**************************************************************************************************/
setupDoors()
{
	level endon( "special_op_terminated" );
	
	level.intro_origin = getstruct("pres_room_struct" , "targetname");
	level thread maps\hijack_airplane::intro_doors();
	intro_door0 = getEnt( "intro_door0", "targetname" );
	intro_door0 MoveY( -51, .05 );
	
	storage_door = GetEnt( "storage_door1", "targetname" );
	storage_door MoveY( 49, 1, 0, .25 );
	
	//level.door3 unlink();
	//level.door3 MoveY( 50, 1, 0, .25 );
	
	level.door2 unlink();
	level.door2 MoveY( 50, 1, 0, .25 );
	
	// door to conference room
	//level.door4 unlink();
	//level.door4 MoveY( 50, 1, 0, .25 );
	
	//level.door1 unlink();
	//level.door1 MoveY( 50, 1, 0, .25 );
	
	tactical_doors = GetEntArray( "so_tactical_door", "targetname" );
	
	foreach ( door in tactical_doors )
	{
		door Hide();
		door NotSolid();
		door ConnectPaths();
	}
}

/*************************************************************************************************
	startDebate
	self = level
	
	Get the conference room setup to it's pre-breach state
**************************************************************************************************/
startDebate()
{
//	level.org_vba_base = getdvar( "bg_viewBobAmplitudeBase" );
//	level.org_vba_standing = getdvar( "bg_viewBobAmplitudeStanding" );
//	
//	SetSavedDvar( "bg_viewBobAmplitudeBase", "0.5");
//	SetSavedDvar( "bg_viewBobAmplitudeStanding", "0.01 0.01");
	
	// record animation info for future reference:
	// name			totalF	startF	endF
	// ---------------------------------
	// president	1609	1231	none
	// commander	1442	1231	1316
	// advisor		1634	1231	none
	// hero_agent	1609	1231	1400
	// secretary	1560	913		981
	// polit1		1531	1231	none
	// polit2		1531	1231	none
	// agent2		1609	1231	1348
	
	// calculate normalized start times
	start_frame_b = 		1231.0;		// start of breach
	//start_frame_s = 		913.0;		// start of plane shake
	
	startNT_president = 	start_frame_b / 1609;
	//startNT_commander = 	start_frame_b / 1442;
	//startNT_advisor = 		start_frame_b / 1634;
	//startNT_hero1 = 		start_frame_b / 1609;
	startNT_secretary = 	start_frame_b / 1560;
	startNT_polit1 = 		start_frame_b / 1531;
	startNT_polit2 = 		startNT_polit1;
	//startNT_agent2 = 		start_frame_b / 1609;
	
	// calculate number of unused seconds in the animation - used for determining when to end it early (weird)
	//FPS = 30.02;
	// name				totalF	   endF		startF
	//end_commander = 	( 1442 - ( 1316 - 	start_frame_b ) ) / FPS;
	//end_hero =			( 1609 - ( 1400 - 	start_frame_b ) ) / FPS;
	//end_secretary = 	( 1560 - ( 981 - 	start_frame_s ) ) / FPS;
	//end_agent2 = 		( 1609 - ( 1348 - 	start_frame_b ) ) / FPS;
	
	//Keep a list of enemies that must be killed before the president can be captured
	array_spawn_function_noteworthy( "so_commander", ::enemyMustKillToCapture );
	array_spawn_function_noteworthy( "so_hero_agent_01", ::enemyMustKillToCapture );
	array_spawn_function_noteworthy( "so_intro_agent2", ::enemyMustKillToCapture );
	array_spawn_function_noteworthy( "so_intro_agent1", ::enemyMustKillToCapture );
	
	// play the long debate anims at spawn for each person and end some of them early
	array_spawn_function_noteworthy( "so_president", ::enemyPostSpawnDebate, 		"president", "debate", 		startNT_president, 	undefined );
	array_spawn_function_noteworthy( "so_commander", ::enemyPostSpawnDebate, 		"so_commander", "debate", 	0, 					undefined );
	array_spawn_function_noteworthy( "so_advisor", 	::enemyPostSpawnDebate, 		"so_advisor", "debate", 	0, 					undefined );
	array_spawn_function_noteworthy( "so_hero_agent_01", ::enemyPostSpawnDebate, 	"so_hero_agent", "debate", 	0, 					undefined );  
	array_spawn_function_noteworthy( "so_secretary", ::enemyPostSpawnDebate, 		"secretary", "debate", 		startNT_secretary, 	undefined );
	array_spawn_function_noteworthy( "so_polit_1", ::enemyPostSpawnDebate, 			"polit_1", "debate", 		startNT_polit1, 	undefined );
	array_spawn_function_noteworthy( "so_polit_2", ::enemyPostSpawnDebate, 			"polit_2", "debate", 		startNT_polit2, 	undefined );
	array_spawn_function_noteworthy( "so_intro_agent2", ::enemyPostSpawnDebate, 	"so_agent2", "debate", 		0, 					undefined );
	array_spawn_function_noteworthy( "so_intro_agent1", ::enemyPostSpawnDebate );
	
	// setup the president for an objective marker and mission failed
	array_spawn_function_noteworthy( "so_president", ::presidentObjective );
	array_spawn_function_noteworthy( "so_president", ::presidentDeath );
	
	// setup guns for the men firing after the breach finishes
//	array_spawn_function_noteworthy( "so_commander", ::enemyPrepGun );
//	array_spawn_function_noteworthy( "so_intro_agent2", ::enemyPrepGun );
//	array_spawn_function_noteworthy( "so_intro_agent1", ::enemyPrepGun );
//	array_spawn_function_noteworthy( "so_hero_agent_01", ::enemyPrepGun );
	array_spawn_function_noteworthy( "so_polit_1", ::enemyRemoveGun );
	array_spawn_function_noteworthy( "so_polit_2", ::enemyRemoveGun );
	array_spawn_function_noteworthy( "so_secretary", ::enemyRemoveGun );
	array_spawn_function_noteworthy( "so_advisor", ::enemyRemoveGun );
	
	array_spawn_function_noteworthy( "so_commander", ::enemyCounterBreach );
	array_spawn_function_noteworthy( "so_intro_agent2", ::enemyCounterBreach );
	array_spawn_function_noteworthy( "so_intro_agent1", ::enemyCounterBreach );
	array_spawn_function_noteworthy( "so_hero_agent_01", ::enemyCounterBreach );
	
	// setup looping animations for those that live but don't have guns
	array_spawn_function_noteworthy( "so_president", ::enemyPlayEndLoopingAnimation, "debate_cine_president_end_loop", "stop_pres_debate_loop" );
	array_spawn_function_noteworthy( "so_advisor", ::enemyPlayEndLoopingAnimation, "debate_cine_advisor_end_loop", "stop_debate_advisor_loop" );
	
	// kill those that die in the blast (if not shot before)
	array_spawn_function_noteworthy( "so_secretary", ::enemyDieNoRagdoll, "start_ragdoll" );
	array_spawn_function_noteworthy( "so_polit_1", ::enemyDieNoRagdoll, "start_ragdoll" );//, "debate_cine_politician1_death_loop" );
	array_spawn_function_noteworthy( "so_polit_2", ::enemyDieNoRagdoll, "start_ragdoll" );//, "debate_cine_politician2_death_loop" );
	
	array_spawn_function_noteworthy( "so_advisor", ::advisorSetup );
	array_spawn_function_noteworthy( "so_commander", ::commanderSetup );
	
	array_spawn_function_targetname( "breach_enemy_spawner", ::tagDoNotCleanUp );
	
	level.intro_origin = getstruct("pres_room_struct" , "targetname");
	
	chairSetup( "chair1", "debate_chair1" );
	chairSetup( "chair2", "debate_chair2" );
	chairSetup( "chair3", "debate_chair3" );
	chairSetup( "chair4", "debate_chair4" );
	chairSetup( "chair5", "debate_chair5" );
	chairSetup( "chair6", "debate_chair6" );
	chairSetup( "chair8", "debate_chair8" );
	chairDestroy();
	debateRoomItemsDuringBreach();
}

/*************************************************************************************************
	debateRoomItemsDuringBreach
	self = level
**************************************************************************************************/
debateRoomItemsDuringBreach()
{
	level endon( "special_op_terminated" );
	
	physicspush = GetEntArray( "conf_room_physics", "targetname" );
	foreach (object in physicspush)
	{
		PhysicsExplosionSphere( object.origin, 64, 32, .6);
	}
	objects = GetEntArray("conf_room_junk","targetname");
	foreach (object in objects)
	{
		object thread maps\hijack_code::launch_object( RandomIntRange(120,170),( 0 , -1 , .05 ));
	}
	
	thread maps\hijack_airplane::debate_paper_chaos();
	thread maps\hijack_airplane::debate_picture();
	
	flag_wait( "door_breach" );
	kill_tv = GetEnt( "tv_destructor", "targetname" );
	kill_tv2 = GetEnt( "tv_destructor2", "targetname" );
	MagicBullet( "ak74u", kill_tv.origin, kill_tv2.origin);
}

/*************************************************************************************************
	chairSetup
	self = level
**************************************************************************************************/
chairSetup(chairname, chairanim)
{
	chair = GetEnt( chairname, "targetname" );
	chair.animname = "conf_chair";
	chair setanimtree();
	level.intro_origin anim_first_frame_solo( chair, chairanim );
	waitframe();
	level.intro_origin thread anim_single_solo( chair, chairanim );
	waitframe();
	chair thread anim_self_set_time( chairanim, 1 );
}

/*************************************************************************************************
	chairDestroy
	self = level
**************************************************************************************************/
chairDestroy()
{
	chair_top = getEnt( "chair_destroy_top", "targetname" );
	chair_bottom = getEnt( "chair_destroy_base", "targetname" );
	
	rig = spawn_anim_model("destroy_chair");
	waittillframeend;
	
	level.intro_origin anim_first_frame_solo( rig, "debate_cine_end_chair" );
	chair_top linkto( rig , "J_prop_1" );
	chair_bottom linkto( rig , "J_prop_2" );
	
	//flag_wait( "debate_starting" );
	
	level.intro_origin thread anim_single_solo( rig, "debate_cine_end_chair" );
	
	waitframe();
	
	rig anim_self_set_time( "debate_cine_end_chair", 1 );
	
	waitframe();
	
	chair_top unlink();
	chair_bottom unlink();
	rig Delete();
}

/*************************************************************************************************
	enemyDieNoRagdoll
	self = enemy
**************************************************************************************************/
enemyDieNoRagdoll(wait_notetrack_string)
{
	self endon("death");
	
	self.noragdoll = 1;
	self.a.nodeath = true;
	self.ignoreme = true;
	self.ignoreall = true;
	self.diequietly = true;
	
	self.no_ai = true;
	self.combatmode = "no_cover";
	self.deathanim = undefined;
	
	self waittillmatch( "single anim", wait_notetrack_string );
	
	self InvisibleNotSolid();

	self notify( "stop_loop" );// default ender.
	self notify( "single anim", "end" );
	self notify( "looping anim", "end" );
	
	self Kill();
}

/*************************************************************************************************
	advisorSetup
	self = enemy
**************************************************************************************************/
advisorSetup()
{
	level endon( "special_op_terminated" );
		
	self waittillmatch( "single anim", "end" );
	
	self.noragdoll = 1;
	self.a.nodeath = true;
	self.allowdeath = false;
	self.ignoreme = true;
	self.ignoreall = true;
	self.diequietly = true;
	self.health = 10000;
	
	self.no_ai = true;
	self.combatmode = "no_cover";
	self.deathanim = undefined;
	
	self waittill("damage", damage, attacker, direction, point, type );
	
	self InvisibleNotSolid();
	
	level.intro_origin notify( "stop_debate_advisor_loop" );
	level.intro_origin anim_single_solo( self, "couch_death" );
	
	self.allowdeath = true;
	
	self Kill( self.origin, attacker );
}

/*************************************************************************************************
	commanderSetup
	self = enemy
**************************************************************************************************/
commanderSetup()
{
	level endon( "special_op_terminated" );
	self endon( "death" );

	// this is a HACK to not actually drop his gun like his animation says to
	weapon = self.weapon;
	self waittillmatch( "single anim", "dropgun" );
	waitframe();
	animscripts\shared::placeWeaponOn( weapon, "right", 1 );
}

/*************************************************************************************************
	enemyRemoveGun
	self = enemy
**************************************************************************************************/
enemyRemoveGun()
{
	self gun_remove();
}

/*************************************************************************************************
	enemyPlayEndLoopingAnimation
	self = enemy
**************************************************************************************************/
enemyPlayEndLoopingAnimation( animation, end_notify )
{
	self waittillmatch( "single anim", "end" );
	level.intro_origin thread anim_loop_solo( self, animation, end_notify );
}

/*************************************************************************************************
	enemyMustKillToCapture
	self = enemy
**************************************************************************************************/
enemyMustKillToCapture()
{
	//Must kill guys should not take cover. If they choose to take cover they could run out
	//of the final room and the player will not understand why they cannot capture the president
	self.combatmode = "no_cover";
	
	if(!IsDefined(level.mustKillToCapture))
	{
		level.mustKillToCapture = [];
	}
	
	level.mustKillToCapture[level.mustKillToCapture.size] = self;
	
//	self endon("death");
//	while(1)
//	{
//		print3d( self.origin+(0,0,72), "Kill",(1,0,0), 1, 1 );	// origin, text, RGB, alpha, scale
//		wait( 0.05 );
//	}
}

/*************************************************************************************************
	startDebate
	self = enemy
**************************************************************************************************/
enemyPostSpawnDebate( animname, anime, start_time_normalized, unused_seconds_for_end )
{
	level endon( "special_op_terminated" );
	
	// change the team so i do not need to make new gdt entries
	self.team = "axis";
	
	// disable surprise reaction anims
	self.disableReactionAnims = true;
	
	// use default animation set on spawner
	if ( !IsDefined( animname ) )
	{
		return;
	}
	
	// setup to play the conference animation
	self.animname = animname;
	
	// override the breach anims after they start to play
	level waittill( "breach_enemy_anims" );
	waitframe();
	
	level.intro_origin thread anim_play_at_time( self, anime, start_time_normalized, unused_seconds_for_end );
	
	self notify( "so_debate_anim_started" );
}

/*************************************************************************************************
	anim_play_at_time
	self = scene entity
**************************************************************************************************/
anim_play_at_time( guy, anime, start_time_normalized, unused_seconds_for_end )
{
	self thread anim_single_solo( guy, anime, undefined, unused_seconds_for_end );
	waitframe();
	guy thread anim_self_set_time( anime, start_time_normalized );
}

/*************************************************************************************************
	presidentObjective
	self = president enemy
**************************************************************************************************/
presidentObjective()
{
	level endon( "special_op_terminated" );
	
	level.so_president = self;
	flag_set( "so_president_spawned" );
	
	while(!canCapturePresident())
	{
		wait .1;
	}
	
	self SetCursorHint( "HINT_NOICON" );
	self SetHintString( &"SO_MILEHIGH_HIJACK_USE_PRESIDENT" );
	self MakeUsable();
	
	self waittill( "trigger" );
	flag_set( "so_president_captured" );
}

/*************************************************************************************************
	canCapturePresident
	self = level
**************************************************************************************************/
canCapturePresident()
{
	if( IsDefined( level.mustKillToCapture ) )
	{
		near_president_vol = getEnt("near_president_vol", "targetname");
		foreach( ai in level.mustKillToCapture )
		{
			// if the ai is alive and not on the floor dying it is ok to capture the president
			if( IsAlive(ai) && !(ai doingLongDeath()) && ai IsTouching(near_president_vol) )
			{
				return false;
			}
		}
	}
	return true;
}

/*************************************************************************************************
	presidentDeath
	self = president enemy
**************************************************************************************************/
presidentDeath()
{
	level endon( "special_op_terminated" );
		
	self waittill( "death" );
	
	level.challenge_end_time = gettime();
	level.president_dead = true;
	maps\_specialops::so_force_deadquote( "@SO_MILEHIGH_HIJACK_PRESIDENT_KILLED" );
	maps\_utility::missionFailedWrapper();
}

/*************************************************************************************************
	setupCounterBreach
	self = level
**************************************************************************************************/
setupCounterBreach()
{
	level endon( "special_op_terminated" );
	level endon( "flashbang_guy_killed" );
	
	flash_grenade_start = getstruct( "so_flash_grenade_start", "targetname" );
	flash_grenade_end = getstruct( "so_flash_grenade_end", "targetname" );
	
	flag_wait( "so_counter_breach" );
	level thread spawnFlashbangEnemy();
	flag_set( "so_conference_room_hall" );
	level.door3 unlink();
	level.door3 MoveY( -50, 0.5, 0, .1 );
	wait 0.4;
	grenade = MagicGrenade( "flash_grenade", flash_grenade_start.origin, flash_grenade_end.origin, 1 );
	level notify( "flashbang_out" );

	while ( IsDefined( grenade ) )
	{
		waitframe();
	}
	
	level notify( "so_counter_breach_flash_activated" );	
}

/*************************************************************************************************
	spawnFlashbangEnemy
	self = level
**************************************************************************************************/
spawnFlashbangEnemy()
{
	level endon( "flashbang_out" );
	
	spawner = GetEnt( "so_conference_room_hall_flash_bang", "targetname" );
	guy = spawner spawn_ai( 1, 0 );
	guy.animname = "so_flashbang_enemy";
	level.intro_origin anim_single_solo( guy, "so_milehigh_breach_flashbang_toss" );
//	guy stop_magic_bullet_shield();
	goal = getstruct( "so_flashbang_guy_goal", "targetname" );
	guy SetGoalPos( goal.origin );
	
	guy waittill( "death" );
	level notify( "flashbang_guy_killed" );
}

/*************************************************************************************************
	setupEndCleanup
	self = level
**************************************************************************************************/
setupEndCleanup()
{
	level waittill( "special_op_terminated" );
	
	flag_set( "stop_constant_shake" );
}

/*************************************************************************************************
	startAmbientVO
	self = level
**************************************************************************************************/
startAmbientVO()
{
	level endon( "special_op_terminated" );
	
	level thread playLinesBehindConferenceDoor();
	
	speaker = GetEnt( "so_ambient_vo_hijackers_speaker", "targetname" );
	flag_wait ( "so_ambient_vo_hijackers" );
	speaker PlaySound( "hijack_fso3_hijackerstaking" );
}

/*************************************************************************************************
	playLinesBehindConferenceDoor
	self = level
**************************************************************************************************/
playLinesBehindConferenceDoor()
{
	level endon( "special_op_terminated" );
	
	behind_door = GetEnt( "so_lines_behind_door", "targetname" );
//	breach_trigger = GetEnt( "so_conference_breach_trigger", "targetname" );
	
//	breach_trigger waittill( "trigger" );
	level waittill( "breaching_number_2" );
	behind_door PlaySound( "hijack_cmd_everyonedown", "conference_line_complete" );
	behind_door waittill( "conference_line_complete" );

	behind_door PlaySound( "hijack_cmd_allteams", "conference_line_complete" );
	flag_wait( "so_begin_debate_breach" );
	wait 1;
	behind_door StopSounds();
	waitframe();
	behind_door Delete();
}

tagDoNotCleanUp()
{
	self.doNotCleanUp = true;
}

cleanUpEnemiesOnFinalBreach()
{
	level endon( "special_op_terminated" );
	
	level waittill( "breaching_number_2" );
	
	wait .3;	//Both players should be looking at the door now
	
	ai_array = GetAIArray( "axis" );
	foreach(ai in ai_array)
	{
		if(!IsDefined(ai.doNotCleanUp) || !ai.doNotCleanUp)
			ai Delete();
	}
	
}

disableGrenadesDuringBreach()
{
	level endon( "special_op_terminated" );
	
	level.slowmo_breach_disable_stancemod = true;
	
	while(1)
	{
		level waittill( "breaching" );
		
		foreach(player in level.players)
		{
			player EnableInvulnerability();
			player DisableWeaponSwitch();
			player DisableOffhandWeapons();
			player AllowCrouch( false );
			player AllowProne( false );
			player AllowSprint( false );
			player AllowJump( false );
		}
		
		level waittill( "sp_slowmo_breachanim_done" );
		
		foreach(player in level.players)
		{
			player DisableInvulnerability();
			player EnableWeaponSwitch();
			player AllowCrouch( true );
			player AllowProne( true );
			player AllowSprint( true );
			player AllowJump( true );
		}
		
		flag_waitopen("breaching_on");
		
		foreach(player in level.players)
		{
			player EnableOffhandWeapons();
		}
	}
}

////////////
//Debug Code
////////////
/#
show_ai_health()
{
	while(1)
	{
		dvar_value = getDebugDvarInt( "show_ai_health" );
		if(dvar_value == 0)
		{
			level notify("stop_ai_show_health");
			wait .25;
			continue;
		}
		
		player = level.players[0];
		ai_array = GetAIArray( "axis" );

		for(i=0;i<ai_array.size;i++)
		{
			ai = ai_array[i];
			
			ai thread ai_record_damage_history();
			
			text = "" + ai.health + "/" + ai.maxhealth;
			
			right = anglestoright(player.angles);
			right = -1 * right * ((text.size / 2) * 8); //Roughly center text
			up = (0,0,70);
			
			color = (0,1,0); //Green
			historySize = ai.damageHistory.size;
			if(historySize>0 && ai.damageHistory[historySize-1].time+1000>GetTime())
			{
				color = (1,0,0); //red
			}

			print3d( ai.origin+right+up, text, color, 1, .75 );
			
			//Print damage history
			k=0;
			for(j=ai.damageHistory.size-1; j>=0 && k<dvar_value-1; j--)
			{
				up = up + (0,0,-10);
				print3d( ai.origin+right+up, ai.damageHistory[j].text, color, 1, .75 );
				k++;
			}
		
			
		}
		wait( 0.05 );
	}
}

ai_record_damage_history()
{
	level endon("stop_ai_show_health");
	self endon("death");
	
	if(IsDefined(self.record_damage_time_active) && self.record_damage_time_active)
	{
		return;
	}
	
	self.damageHistory = [];
	self.record_damage_time_active = true;
	while(1)
	{
		self waittill("damage", damage, attacker, direction, point, type );
		
		s 			= spawnStruct();
		s.time 		= GetTime();
		s.damage 	= damage;
		s.attacker	= attacker;
		s.type		= type;
		if(IsDefined(self.damageLocation))
		{
			s.loc		= self.damageLocation;
			s.text		= "-" + damage + " " + self.damageLocation + " " + type;
		}
		s.text		= "-" + damage + " " + type;
		
		self.damageHistory[self.damageHistory.size] = s;
	}
}
#/
