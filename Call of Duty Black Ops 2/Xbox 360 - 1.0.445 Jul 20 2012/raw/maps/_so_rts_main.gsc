#include common_scripts\utility;
#include maps\_utility;
#include maps\_scene;
#include maps\_music;
#include maps\_vehicle;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_so_rts.gsh;
#insert raw\maps\_scene.gsh;

	
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
preload()
{
	maps\sp_killstreaks\_killstreaks::preload();
	globals_init();
	maps\_so_rts_precache::main();

	maps\_so_rts_rules::preload();
	maps\_so_rts_ai::AI_preload();
	maps\_so_rts_catalog::preload();
	maps\_so_rts_poi::preload();
	maps\_so_rts_tutorial::preload();
    
    anim_init();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
postload()
{
	maps\_so_rts_support::MP_ents_cleanup();

	// intercept player death
	level.prevent_player_damage = maps\_so_rts_main::Callback_PreventPlayerDamage;
	level.overridePlayerDamage  = maps\_so_rts_main::Callback_PlayerDamage;
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
globals_init()
{
	if(!isDefined(level.rts))
	{
		level.rts = SpawnStruct();
	}
	flag_init( "start_rts" );
	flag_init( "start_rts_enemy");
	flag_init( "rts_game_over" );
	flag_init( "rts_start_clock" );
	flag_init( "fps_mode_only");
	flag_init( "fps_mode");
	flag_init( "rts_mode");
	flag_init( "block_input");
	SetDvar("ui_specops","1");
	SetSavedDvar( "compass", "1" );
	SetDvar( "old_compass", "1" );
	SetDvar("ui_hideminimap","0");
	SetDvar("lui_enabled","1");
	
	level.rts.objectiveNum					= 10;
	level.rts.ally_cam_active 				= false;
	
	level.rts.networkIntruders				= [];
	
 	game["entity_headicon_allies"]			= "hud_specops_ui_deltasupport";
	game["entity_headicon_axis"]			= "hudicon_spetsnaz_ctf_flag_carry";

	level.teamBased 						= false;
	
	level.rts.fov							= DEFAULT_FOV;
	
	level.rts.static_trans_time				= TOTAL_STATIC_TRANSITION_TIME * 1000;
	level.rts.static_trans_time_half		= level.rts.static_trans_time * 0.5;
	level.rts.static_trans_time_nearhalf	= level.rts.static_trans_time_half * 0.7;
	level.rts.lastFPSpoint 					= level.rts.player_startpos;
	
	Rpc("clientscripts/_so_rts","initTransitionTime", TOTAL_STATIC_TRANSITION_TIME );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
anim_init()
{
	add_scene( "plant_network_intruder", "player_tag_origin" );
	add_player_anim( "player_body", %player::int_motion_sensor_pullout, SCENE_DELETE, PLAYER_1 );
	
	precache_assets();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
checkpoint_save_restored()
{
	level thread maps\_so_rts_poi::checkpoint_save_restored();
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
main()
{
	OnSaveRestored_Callback( ::checkpoint_save_restored );
	wait_for_first_player();
	maps\_so_rts_support::setupMapBoundary();

	level thread maps\sp_killstreaks\_killstreaks::init();
	level.killstreakscountsdisabled	= true;
	level.rts.player = GetPlayers()[0];
	level.rts.player.force_minigame = true;
	level.rts.lastFPSpoint = level.rts.player.origin;
	level.rts.player thread player_deathShieldWatch();
	
	maps\_so_rts_rules::init();
	maps\_so_rts_event::init();
	maps\_so_rts_ai::AI_init();
	maps\_so_rts_catalog::init();
	maps\_so_rts_poi::init();
	maps\_so_rts_squad::init();
	maps\_so_rts_tutorial::init();
	
	level thread maps\_so_rts_enemy::enemy_player();
	level thread maps\_so_rts_player::friendly_player();

	infantry 	= maps\_so_rts_squad::getSquadsByType( "infantry", level.rts.player.team ).size;
	mechanized 	= maps\_so_rts_squad::getSquadsByType( "mechanized", level.rts.player.team ).size;
	level thread maps\_so_rts_rules::rules_SetGameTimer();

	
	/#
	maps\_so_rts_support::setup_devgui();
	#/
	
	if ( isDefined(level.rts.allied_base) && isDefined(level.rts.allied_base.entity) )
	{
		level.rts.player_startpos = level.rts.allied_base.entity.origin;
	}
	else
	{
		level.rts.player_startpos = GetPlayers()[0].origin;
	}


	maps\_dds::dds_disable( "allies" );
	maps\_dds::dds_disable( "axis" );


	wait 1;
	flag_set( "start_rts" );
	wait 0.05;
	maps\_so_rts_support::toggle_damage_indicators(true);
	
	level thread main_think();
//	level.friendlyFireDisabled = 1;
	DisableGrenadeSuicide();
	level.rts.ground = undefined;
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
player_eyeInTheSky(fastLink)
{
	if ( flag("fps_mode_only") )
		return;
	if ( flag("rts_mode") )
		return;

	level notify("eye_in_the_sky");
	flag_clear("fps_mode");
	flag_set("block_input");
	level.rts.player.ignoreme 	= true;
	level.rts.player EnableInvulnerability();
	level.rts.player.takedamage = false;
	
	level.rts.targetTeamMate = undefined;
	level.rts.targetTeamEnemy= undefined;
	level.rts.minPlayerZ	 = level.rts.player.origin[2] + level.rts.game_rules.minPlayerZ;
	level.rts.maxPlayerZ	 = level.rts.minPlayerZ + level.rts.game_rules.maxPlayerZ;
	level.rts.minViewAngle	 = MIN_VIEW_ANGLE;
	level.rts.maxViewAngle	 = MAX_VIEW_ANGLE;

	if(!isDefined(level.rts.playerLinkObj))
	{
		level.rts.playerLinkObj	= Spawn( "script_model", level.rts.player.origin);
		level.rts.playerLinkObj	SetModel( "tag_origin" );
		if (IS_TRUE(fastLink))
		{
			level.rts.playerLinkObj.angles = (290,290,0);
			level.rts.player PlayerLinkTo( level.rts.playerLinkObj, undefined, 1, 0, 0, 0, 0 );
		}
	}

	level.rts.player DisableWeapons();
	level.rts.player DisableOffhandWeapons();
	level.rts.player EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	level.rts.player HideViewModel();			
	level.rts.player AllowStand( true );
	level.rts.player SetStance("stand");
	level.rts.player AllowCrouch( false );
	level.rts.player AllowProne( false );

	
	level.rts.player thread maps\_so_rts_support::do_switch_transition();
	level waittill("switch_fullstatic");
	level notify("rts_ON");
	level clientnotify( "rts_ON" );
	maps\_so_rts_support::toggle_damage_indicators(false);
	
	level thread rts_menu();
	level.rts.playerLinkObj_moveIncForward = undefined;
	level.rts.ground = undefined;
	maps\_so_rts_support::playerLinkObj_defaultPos();
	level.rts.player SetClientFlag( FLAG_CLIENT_FLAG_RETICLE );
	//level.rts.player SetClientFlag( level.CLIENT_FLAG_REMOTE_MISSILE );
	
	// link player
	level.rts.player unlink();
	level.rts.player PlayerLinkTo( level.rts.playerLinkObj, undefined, 1, 0, 0, 0, 0 );//needed
	
	wait .4;
	flag_set("rts_mode");
	flag_clear("block_input");
	level thread maps\_so_rts_support::unitReticleTracker();
	level thread eyeInTheSky_controls();
	LUINotifyEvent( &"rts_hud_visibility", 1, 1 );
	level.rts.player.ignoreme 	= true;
	level.rts.player EnableInvulnerability();
	level.rts.player.takedamage = true;
	
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
eyeInTheSky_controls()
{
	level endon( "rts_terminated" );
	

	while(flag("rts_mode"))
	{
		if(flag("block_input"))
		{
			wait 0.05;
			continue;
		}
		
		dirty 	 = false;
		onlyZ	 = undefined;
		movement = level.rts.player GetNormalizedMovement();	
		zoom	 = level.rts.player GetNormalizedCameraMovement();
		
		if ( level.rts.game_rules.camera_mode == CAMERA_MODE_ORBIT )
		{
			if ( zoom[0] > DEFAULT_DEADZONE || zoom[0]<-DEFAULT_DEADZONE)
			{
				level.rts.playerLinkObj.origin -= (0,0,PLAYER_Z_HEIGHT_INC*zoom[0]);
				level.rts.ground = undefined;
				dirty = true;
			}
			if ( zoom[1] > DEFAULT_DEADZONE || zoom[1]<-DEFAULT_DEADZONE)
			{
				maps\_so_rts_support::playerLinkObj_rotate(PLAYER_ROTATION_INC*(-zoom[1]));
				level.rts.playerLinkObj_moveIncForward = undefined;
				dirty = true;
			}
		}
		else
		if ( level.rts.game_rules.camera_mode == CAMERA_MODE_LOOK )
		{
			playerLinkObj_orient(-zoom[0]*PLAYER_ROTATION_INC,-zoom[1]*PLAYER_ROTATION_INC);
			level.rts.ground = undefined;
			dirty = true;
			level.rts.playerLinkObj_moveIncForward = undefined;
		}
		
		
		if ( movement[0] > DEFAULT_DEADZONE || movement[0]<-DEFAULT_DEADZONE || movement[1] > DEFAULT_DEADZONE || movement[1]<-DEFAULT_DEADZONE )
		{
			maps\_so_rts_support::playerLinkObj_moveObj(movement[0],movement[1]);
			level.rts.ground = undefined;
			dirty = true;
		}


		buttonPressed = maps\_so_rts_support::getButtonPress();
		switch(buttonPressed)
		{
			case "NO_INPUT":
			break;
			case "BUTTON_BACK":
				maps\_so_rts_event::trigger_event("switch_character");
				thread player_in_control();
			break;
			case "BUTTON_LTRIG":
				if ( level.rts.game_rules.zoom_avail)
				{
					maps\_so_rts_support::playerLinkObj_zoom(-1,0.3);
					level.rts.playerLinkObj_moveIncForward = undefined;
					onlyZ = true;
					dirty = true;
				}
			break;
			case "BUTTON_RTRIG":
				if ( level.rts.game_rules.zoom_avail)
				{
					maps\_so_rts_support::playerLinkObj_zoom(1,0.3);
					level.rts.playerLinkObj_moveIncForward = undefined;
					onlyZ = true;
					dirty = true;
				}
			break;
			case "BUTTON_RSTICK":
				maps\_so_rts_event::trigger_event("reset_view");
				screen_fade_out(0.5);
				level.rts.lastFPSpoint = undefined;
				maps\_so_rts_support::playerLinkObj_defaultPos();
				level.rts.lastFPSpoint = level.rts.player.origin;
				screen_fade_in(0.5);
			break;
		}
		
		if ( dirty )
		{
			maps\_so_rts_support::playerLinkObj_viewClamp(onlyZ);
		}
		wait 0.05;
	}
}
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
player_in_control()
{
	if ( flag("fps_mode") )
		return;

	targetEnt = level.rts.targetTeamMate;
	level.rts.targetTeamMate = undefined;
	
	if ( !isDefined(targetEnt) || !IS_TRUE(targetEnt.rts_unloaded) || IS_TRUE(targetEnt.no_takeover) )
		return;
	
	level notify("player_in_control");
	if (IS_VEHICLE(targetEnt) )
	{
		targetEnt veh_magic_bullet_shield(true);
	}
	else
	{
		targetEnt.takedamage = false;
	}
	targetEnt.selectable = false;
	level.rts.targetTeamEnemy= undefined;
	
	
	flag_clear("rts_mode");
	flag_set("block_input");

	
	level.rts.player EnableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	level.rts.player thread maps\_so_rts_support::do_switch_transition(targetEnt);
	targetEnt notify("taken_control_over");
	level waittill("switch_fullstatic");
	level notify( "rts_OFF" );
	level clientnotify( "rts_OFF" );
	maps\_so_rts_support::toggle_damage_indicators(true);
	maps\_so_rts_support::playerLinkObj_zoom(0,0);
	level.rts.player ClearClientFlag( FLAG_CLIENT_FLAG_RETICLE );
	level thread fps_menu();
	
	level.rts.player  EnableWeapons();
	level.rts.player  EnableOffhandWeapons();
	level.rts.player Unlink();
	
	if (isDefined(level.rts.playerLinkObj) )
	{
		level.rts.playerLinkObj delete();
		level.rts.playerLinkObj = undefined;
	}

	/////////////
	//take over target.....
	targetEnt = level.rts.player maps\_so_rts_ai::takeOverSelected(targetEnt);
	/////////////
	level.rts.player ShowViewModel();			
	level.rts.player AllowStand( true );
	level.rts.player SetStance("stand");
	level.rts.player AllowCrouch( true );
	level.rts.player AllowProne( true );
	level waittill("switch_complete");
	if (!IS_VEHICLE(targetEnt))
	{
		level.rts.player.ignoreme 	= false;
		level.rts.player DisableInvulnerability(); // so the player doesn't get killed by the hurt trigger in mp maps
	}

	flag_set("fps_mode");
	flag_clear("block_input");
	level.rts.lastSquadSelected = level.rts.player.ally.squadID;
	level thread player_in_control_controls();
	LUINotifyEvent( &"rts_hud_visibility", 1, 0 );
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////	
player_in_control_controls()
{
	level endon( "rts_terminated" );
	
	while(flag("fps_mode"))
	{
		if(flag("block_input"))
		{
			wait 0.05;
			continue;
		}

		buttonPressed = maps\_so_rts_support::getButtonPress();
		switch(buttonPressed)
		{
			case "NO_INPUT":
			break;
			case "BUTTON_BACK":
				maps\_so_rts_event::trigger_event("switch_command");
				rts_go_rts();
			break;
			case "BUTTON_LSHLDR":
				thread maps\_so_rts_squad::squadFollowPlayer(false);
			break;
			case "BUTTON_LSHLDR_LONG":
				thread maps\_so_rts_squad::squadFollowPlayer(true);
			break;
		}
		wait 0.05;
	}
}

rts_go_rts()
{
	if ( flag("fps_mode_only"))
		return;
	if (isDefined(level.rts.player.attacked_by_dog) )
		return;
	if ( GetDvarInt( "scr_rts_no_rts" ) == 1 )
		return;
		
	level.rts.lastFPSpoint = level.rts.player.origin;
	level thread player_eyeInTheSky();
	level waittill("switch_fullstatic");
	level.rts.player thread maps\_so_rts_ai::restoreReplacement(); //self is player
}


create_player_corpse(spawner,origin,angles)
{
	self notify("create_player_corpse");
	self endon("create_player_corpse");

	if ( !isDefined(angles) )
		angles = level.rts.player.angles;
	if ( !isDefined(origin) )
	{	//using trace; death animation sometimes putting player origin through the floor.  Believe this is the case with the dog attack animation. trace should at least get me the right loc
		trace 			= BulletTrace( level.rts.player.origin + (0,0,-72), level.rts.player.origin + (0,0,72), true, level.rts.player );
		origin	 		= trace["position"]+(0,0,6);
	}

	level waittill("switch_fullstatic");
	
	ai 		  = simple_spawn_single( spawner, undefined, undefined, undefined, undefined, undefined, undefined, true);
	if (isDefined(ai))
	{
		ai forceteleport(origin,angles);
		ai kill();
		/#
		println("creating corpse at:"+origin+" with angles:"+angles);
		#/
	}
}


Callback_PlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	self endon( "disconnect" );

	if ( sMeansOfDeath == "MOD_TRIGGER_HURT" )
		return 0;


	if (IS_TRUE(self.blockAllDamage))
	{
		iDamage = 0;
	}
	if ( flag("fps_mode"))
	{
		iDamage = int(iDamage*level.rts.game_rules.player_dmg_reducerFPS);
	}
	
	
	if ( isDefined(self.armor)  && self.armor > 0 )
	{
		self.armor -= iDamage;
		if ( self.armor > 0 )
			iDamage = 0;
		else
		{
			iDamage = -self.armor;
			self.armor = undefined;
		}
	}
	
	if ( iDamage > 0 )
	{
		level notify("rts_player_damaged");
	}
	
	return iDamage;
}


player_deathShieldWatch()
{
	level endon( "rts_terminated" );
	self EnableDeathShield( true );
	
	while(1)
	{
		self waittill( "deathshield");
		if(isDefined(self.ally) )
		{
			if (isDefined(self.ally.ai_ref) && self.ally.ai_ref.species == "human" )
			{
				level thread create_player_corpse(self.ally.ai_ref.ref,self.origin,self.angles );
			}

			maps\_so_rts_squad::removeDeadFromSquad(self.ally.squadID);
			if (level.rts.squads[self.ally.squadID].members.size == 0 )
			{
				level.rts.squads[self.ally.squadID].destroyed = 1;
				nextSquad = maps\_so_rts_squad::getNextValidSquad(self.ally.squadID);
			}
			else
			{
				nextSquad = self.ally.squadID;
			}
			
			maps\_so_rts_event::trigger_event( "player_died");
	
			if (nextSquad == -1  )
			{
				maps\_so_rts_event::trigger_event("died_all_pkgs");
				level.rts.lastFPSpoint = level.rts.player.origin;
				level thread player_eyeInTheSky();
			}
			else
			{
				maps\_so_rts_event::trigger_event("forceswitch_"+level.rts.squads[nextSquad].pkg_ref.ref);
				maps\_so_rts_main::player_nextAvailUnit(nextSquad,true);
			}
		
			LUINotifyEvent( &"rts_remove_ai", 1, self GetEntityNumber() );
			if ( IsDefined( self.viewlockedentity ) )
			{
				self.viewlockedentity kill();
			}
		}
	}
}


///////////////////////////////////////
// check if the damage is enough to kill us and switch into an ally if one's available
Callback_PreventPlayerDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, sWeapon, vPoint, vDir, sHitLoc, modelIndex, psOffsetTime )
{
	self endon( "disconnect" );
	
	if ( sMeansOfDeath == "MOD_TRIGGER_HURT" )//MP maps have hurt triggers.  In the Tactical View, the player is high up and possibly inside one of these trigger types.
		return true;

	return false;
}

player_nextAvailUnit(nextSquad,playerdied)
{
	if(!isDefined(nextSquad))
	{
		nextSquad = maps\_so_rts_squad::getNextValidSquad();
	}
	else
	{
		maps\_so_rts_squad::removeDeadFromSquad(nextSquad);
		if( !IS_TRUE(level.rts.squads[nextSquad].selectable))
		{
			nextSquad = maps\_so_rts_squad::getNextValidSquad();
		}
	}
	
	if ( nextSquad != -1 )
	{
		level thread squadSelectNextAIandTakeOver(nextSquad,playerdied);
	}
	else
	{
		maps\_so_rts_event::trigger_event("died_all_pkgs");
		level.rts.lastFPSpoint = level.rts.player.origin;
		level thread player_eyeInTheSky();
		self.ally = undefined;
	}
}

fps_OnlyMode(ignoreExclusion)
{
//	SetDvar("ui_hideminimap","1");
	flag_set ("fps_mode_only");
	
	if(flag("rts_mode"))
	{
		allies = GetAIArray("allies");
		alive  = [];
		for(i=0;i<allies.size;i++)
		{
			if (!IS_TRUE(level.rts.squads[allies[i].squadID].selectable) || !IS_TRUE(allies[i].rts_unloaded) )
			{
				continue;
			}
			alive[alive.size] = allies[i];
		}
		allies = alive;
		
		if (allies.size == 0 )
		{
			level thread maps\_so_rts_rules::mission_complete(false);
			return;
		}
	}

	if(isarray(ignoreExclusion) )
	{
		foreach(item in ignoreExclusion)
		{
			for(i=0;i<level.rts.packages.size;i++)
			{
				if ( level.rts.packages[i].ref == item  )
				{
					continue;
				}
//				level.rts.packages[i].qty["allies"] = 0;
			}
		}
	}
	else
	{
		for(i=0;i<level.rts.packages.size;i++)
		{
			if ( level.rts.packages[i].ref == ignoreExclusion  )
			{
				continue;
			}
//			level.rts.packages[i].qty["allies"] = 0;
		}
	}

}

rts_menu()
{
	maps\_so_rts_support::hide_player_hud();
}
fps_menu()
{
	maps\_so_rts_support::show_player_hud();
}



main_think()
{
	flag_wait("start_rts");
	
	while(!flag("rts_game_over"))
	{
		if ( package_GetNumTeamResources("allies") == 0 )//we ran out of resources
		{
			level thread maps\_so_rts_rules::mission_complete(false);
		}
			
		wait 0.25;
	}
	
	if(!flag("rts_mode") )
	{
		flag_clear("fps_mode_only");
		level.rts.lastFPSpoint = level.rts.player.origin;
	}
	level notify("rts_terminated");
	
	
	maps\_so_rts_support::time_countdown_delete();
	SetDvar("ui_specops","0");
	SetDvar("ui_hideminimap","1");

	SetSavedDvar( "compass", "0" );
	SetDvar( "old_compass", "0" );
	maps\_so_rts_support::toggle_damage_indicators(false);
	
	Rpc("clientscripts/_so_rts","toggle_satellite_RemoteMissile",0,0 );
	if ( IS_FALSE(level.rts.game_success) )//recenter over player's destroyed base.
	{
		wait 2;
		level.rts.lastFPSpoint = undefined;
		screen_fade_out(0.5);
		player_eyeInTheSky();
		maps\_so_rts_support::playerLinkObj_defaultPos();
		level.rts.lastFPSpoint = level.rts.player.origin;
		screen_fade_in(0.5);
	}
}

