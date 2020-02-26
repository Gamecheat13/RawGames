#include common_scripts\utility;
#include maps\_utility;

/*
 _____ _____  _____ _   _   ___  ______ _____ _____  	 _____ _   _  _____ 
/  ___/  __ \|  ___| \ | | / _ \ | ___ \_   _|  _  | 	|  _  | \ | ||  ___|
\ `--.| /  \/| |__ |  \| |/ /_\ \| |_/ / | | | | | | 	| | | |  \| || |__  
 `--. \ |    |  __|| . ` ||  _  ||    /  | | | | | | 	| | | | . ` ||  __| 
/\__/ / \__/\| |___| |\  || | | || |\ \ _| |_\ \_/ / 	\ \_/ / |\  || |___ 
\____/ \____/\____/\_| \_/\_| |_/\_| \_|\___/ \___/  	 \___/\_| \_/\____/ 
*/


#define MAX_TURRET_ENGAGE_DIST_SQ (8192*8192)

//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_scenario_one_intro()
{
	level thread maps\_so_war_support::war_zodiac_player_insert();
	level waittill("zodiac_player_insert_done");
	
	flag_set("intro_complete");
}

//////////////////////////////////////////////////////////////////////////////////////////////////
dockside_scenario_one_end(success)
{
	if (success )
	{
		flag_set("outro_event");
		flag_wait("war_mission_completed");
	}

	while(1)
	{
		maps\_so_war_support::missionCompleteMsg(success);
		wait 4;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////
main()
{
	wait 0.05;
	
	flag_init("populate_map");
	flag_init("sniper_training");
	flag_init("heavy_training");
	flag_init("assault_training");
	flag_init("sam_event");
	flag_init("download_event");
	flag_init("escape_event");
	flag_init("outro_event");
	
	
	//intialize whatever
	//:
	//:
	level.scr_anim["war_ai"]["war_capture_CAP1"] 			= %generic_human::ai_hack_stand;			//CAP1 is scenario ID.. i.e. level.currentGameSeg.segID
	level.scr_anim["war_player"]["war_capture_CAP1"] 		= %generic_human::int_war_mode_hack;


	flag_wait("intro_complete");
	
	level thread populate_map();
	level thread sniper_Training();
	level thread heavy_Training();
	level thread assault_Training();
	level thread sam_event("CAP1");			// CAP1 is defined in war_gamedefs;  
	level thread download_event("PRO1");
	level thread escape_event("ESC1");
	level thread outro_event();
	
	flag_set("populate_map");
	
	//:
	//:
	flag_wait("war_mission_completed");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
populate_map()
{
	level endon("special_op_terminated");
	flag_wait("populate_map");
	
	maps\_stealth_logic::stealth_init();
	maps\_stealth_behavior::main();
	
	// stealth for the player
	level.player maps\_stealth_logic::stealth_ai_logic();
	
	// start stealth thread on the allies
	flag_wait( "allies_spawned" );	
	array_thread( GetAIArray( "allies" ), ::start_allies_in_stealth );
	
	// spawn patrollers and snipers and run stealth on them
	spawn_regular_patrollers();
	spawn_armored_patrollers();
	
	// alert all bad guys if anyone is spotted
	level thread alert_all_on_stealth_break();

	flag_set("sniper_training");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
start_allies_in_stealth()
{
	self.pacifist = true;
	self maps\_stealth_logic::stealth_ai_logic();
}
//////////////////////////////////////////////////////////////////////////////////////////////////
alert_all_on_stealth_break()
{
	level endon("special_op_terminated");
	flag_wait( "_stealth_spotted" );
	level notify( "_stealth_stop_stealth_logic" );
	
	// send all AI after the player
	array_func( GetAiArray("axis"), maps\_so_war_ai::attack_player, level.player );
	
	// restore visible dist on the allies
	array_func( GetAiArray("allies"), maps\_utility::set_maxvisibledist, 8192 );
	array_func( GetAiArray("allies"), maps\_utility::set_pacifist, false );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
spawn_regular_patrollers()
{
	waveNum 	= maps\_so_war_ai::get_wavenum_by_userdefined( "STH_1" );
	ai_count 	= maps\_so_war_ai::get_ai_count( "regular", waveNum );
	
	// find all the patrol point starts
	patrolStarts = GetEntArray( "stealth_patrol_start", "script_noteworthy" );
	patrolStarts = array_randomize( patrolStarts );
	patrolStartIndex = 0;
	
	assert( patrolStarts.size >= ai_count, "You must have enough stealth patrol points to support " + ai_count + " ai. You only have " + patrolStarts.size + "." );
		
	squad_type 	= maps\_so_war_ai::get_squad_type( waveNum );
	classname 	= maps\_so_war_ai::get_ai_classname( squad_type );

	ai_spawner 	= maps\_so_code::get_spawners_by_classname( classname )[ 0 ];
	assert( isdefined( ai_spawner ), "No ai spawner with classname: " + classname );
	
	// spawn regular patrollers
	for( ; patrolStartIndex < ai_count && patrolStartIndex < patrolStarts.size; patrolStartIndex++ )
	{
		start = patrolStarts[ patrolStartIndex ];
		
		new_guy = spawn_single_patroller( ai_spawner, start, squad_type );
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
spawn_armored_patrollers()
{
	waveNum 	= maps\_so_war_ai::get_wavenum_by_userdefined( "STH_1" );
	ai_count 	= maps\_so_war_ai::get_ai_count( "boss", waveNum );
	
	if( ai_count <= 0 )
		return;
	
	// find all the patrol point starts
	patrolStarts = GetEntArray( "armored_patrol_start", "script_noteworthy" );
	
	if( patrolStarts.size <= 0 )
		return;
	
	patrolStarts = array_randomize( patrolStarts );
		
	squad_type 	= maps\_so_war_ai::get_bosses_ai( waveNum )[0];
	classname 	= maps\_so_war_ai::get_ai_classname( squad_type );

	ai_spawner 	= maps\_so_code::get_spawners_by_classname( classname )[ 0 ];
	assert( isdefined( ai_spawner ), "No ai spawner with classname: " + classname );
	
	// spawn regular patrollers
	for( patrolStartIndex = 0; patrolStartIndex < patrolStarts.size; patrolStartIndex++ )
	{
		start = patrolStarts[ patrolStartIndex ];
		
		new_guy = spawn_single_patroller( ai_spawner, start, squad_type );
		
		new_guy maps\_juggernaut::make_juggernaut( false );
		new_guy maps\_so_war_ai::global_jug_behavior();
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
spawn_single_patroller( ai_spawner, startNode, squad_type )
{
	ai_spawner.count = 1; // make sure count > 0
	
	// set up the patrol
	ai_spawner.script_patroller = 1;
	ai_spawner.target = startNode.targetname;
	
	new_guy = simple_spawn_single( ai_spawner );
	
	new_guy.ai_type = get_ai_struct( squad_type );
	new_guy [[ level.attributes_func ]]();

	new_guy ForceTeleport( startNode.origin, startNode.angles );
	new_guy thread maps\_stealth_logic::stealth_ai_logic();
	
	// disable patroller not to break future waves
	ai_spawner.script_patroller = 0;
	
	return new_guy;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
sniper_Training()
{
	level endon("special_op_terminated");
	level endon( "_stealth_stop_stealth_logic" );

	flag_wait("sniper_training");
	
	level thread sniper_Training_abort_on_stealth_break();
	
	sniper = GetEnt( "friendly_sniper_ai", "targetname" );
	
	if( IsDefined( sniper ) )
	{
		while( 1 )
		{
			sniper waittill( "goal" );
			
			if( IsDefined( sniper.special_node_type ) && IsDefined(sniper.node) && IsDefined(sniper.node.targetname) && sniper.node.targetname == sniper.special_node_type )
				break;
		}
		flag_set("war_switch_avail");
		
		iprintlnbold( "SNIPER VO: Sniper is in position. Heavily armored units spotted." );
		iprintlnbold( "SNIPER VO: This 50 cal should make short work of them." );
		wait( 1 );
		if (maps\_so_war_classes::get_cur_player_class()!="friendly_sniper")
		{
			level thread maps\_so_War_support::show_hint("SO_WAR_TRAINING_SNIPER_DPAD","player_switch_friendly_sniper");
		}
		level waittill( "_stealth_stop_stealth_logic" );
	}

	flag_set("war_switch_avail");
	flag_set("heavy_training");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
sniper_Training_abort_on_stealth_break()
{
	level endon("special_op_terminated");
	
	level waittill( "_stealth_stop_stealth_logic" );
	
	flag_set("heavy_training");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
heavy_Training()
{
	level endon("special_op_terminated");
	flag_wait("heavy_training");
	
	// wait a little while to give the reinforcements some time to arrive
	wait 7;
	
	// bring in the choppers
	flag_init( "heavy_training_squads" );
	
	iprintlnbold( "HEAVY VO: Enemy choppers incoming. Get some cover." );
	iprintlnbold( "HEAVY VO: The stinger can take them out before they have a chance to land." );
	wait 7;
	level thread heavy_training_chopper_squads();
	if (maps\_so_war_classes::get_cur_player_class()!="friendly_heavy")
	{
		level thread maps\_so_War_support::show_hint("SO_WAR_TRAINING_HEAVY_DPAD","player_switch_friendly_heavy");
	}
	
	// wait for the chopper squads to be destroyed
	flag_wait( "heavy_training_squads" );
	
	flag_set("assault_training");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
heavy_training_chopper_squads()
{
	// set the wave (TODO: add a separate one for this event, perhaps)
	level.current_wave = maps\_so_war_ai::get_wavenum_by_userdefined( "STH_1" );
	
	// send 2 choppers
	level.heavy_training_choppers = 2;
	level.heavy_training_ai = 0;
	
	for( i=0; i < level.heavy_training_choppers; i++ )
	{
		level thread maps\_so_war_ai::spawn_enemy_squad_by_chopper( 4, ::heavy_training_chopper_status, "inner_dropoff" );
		wait( RandomFloatRange( 2, 5 ) );
	}
	
	// wait until all the squads are dead
	while( level.heavy_training_choppers > 0 || level.heavy_training_ai > 0 )
		wait( 0.2 );
	
	// next stage
	flag_set( "heavy_training_squads" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////
heavy_training_chopper_status( status, param )
{
	if( status == "chopper_death" )
	{
		level.heavy_training_choppers--;
		
		// total hack to remove destroyed choppers
		// TODO: set up crash paths for heli at some point so they don't fall out of the world or setup roadblocks within the level.
		wait( 3 );
		if( IsDefined(param) )
			param notify( "crash_move_done" );
		wait( 1 );
		if( IsDefined(param) )
			param Delete();
	}
	else if( status == "new_guy" )
	{
		self thread heavy_training_monitor_ai_death();
		level.heavy_training_ai++;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
heavy_training_monitor_ai_death()
{
	level endon("special_op_terminated");
	
	self waittill( "death" );
	
	level.heavy_training_ai--;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
assault_Training()
{
	level endon("special_op_terminated");
	flag_wait("assault_training");
	
	// wait a little for a pacing break
	wait 1;
	
	iprintlnbold( "ASSAULT VO: Alright, let's get those gates open." );
	wait( 1 );
	if (maps\_so_war_classes::get_cur_player_class()!="friendly_assault")
	{
		level thread maps\_so_War_support::show_hint("SO_WAR_TRAINING_ASSAULT_DPAD","player_switch_friendly_assault");
	}
	
	flag_set("start_war"); //go time
	flag_set("sam_event");
}
//////////////////////////////////////////////////////////////////////////////////////////////////
sam_event(segment)
{
	level endon("special_op_terminated");
	//initialize SAM sites
	maps\_so_war_gametypes::war_InitGameItemsFor("CAP1");
	level.WAR_sam_sites = [];
	sams = getEntArray("sam_site","targetname");
	foreach (turret in sams)
	{
		level.WAR_sam_sites[level.WAR_sam_sites.size] = createSAMTurret(turret);
	}
	maps\_so_war_gametypes::war_hide_game_items();
	
	flag_wait("sam_event");//go time
	wait 0.05;
	assert( level.currentGameSeg.segID == segment,"Active segment was expected to be something else");
	
	
	level thread samTurret_disable_watcher();
	level waittill("sam_sites_destroyed");
	flag_set("download_event");
}
//////////////////////////////////////////////////////////////////////////////////////////////////


download_event(segment)
{
	level endon("special_op_terminated");
	dsm_obj 	= GetEnt("def1_dsm","targetname");
	dsm_trig 	= maps\_so_war_support::war_create_trigger_use(dsm_obj.origin,48,"SO_WAR_PRO1_TRIGGER_HINT",undefined,"use_activated",level);
	assert(isDefined(dsm_trig));

	dsm_obj  Hide();
	dsm_trig trigger_off();
	
	flag_wait("download_event");//go time
	
	dsm_obj Show();
	objectiveNum = level.objectiveNum;
	Objective_Add( objectiveNum, "current", &"SO_WAR_LOCATE_DEVICE");
	level.objectiveNum++;
	trigger = spawn("trigger_radius", dsm_obj.origin ,0, 512, 64);
	trigger waittill("trigger");
	trigger delete();
	Objective_State( objectiveNum, "done" );
	
	objectiveNum = level.objectiveNum;
	Objective_Add( objectiveNum, "current", &"SO_WAR_SECURE_MICRO_OBJ",dsm_obj.origin);
	objective_set3d( objectiveNum, true, "default",  &"SO_WAR_SECURE_MICRO_OBJ_3D" );
	level.objectiveNum++;
	dsm_trig trigger_on();
	level waittill("use_activated");
	
	dsm_obj Hide();
	dsm_trig Delete();
	Objective_State( objectiveNum, "done" );
	flag_set("pro1_flag_go");  //protect game segment is waiting on this (defined in gamedefs)
	wait 2;

	war_spawn_helicopter("axis",dsm_obj.origin,125);
	assert( level.currentGameSeg.segID == segment,"Active segment was expected to be something else");
	level waittill(level.currentGameSeg.notifyFinish );	
	dsm_obj Show();

	objectiveNum = level.objectiveNum;
	Objective_Add( objectiveNum, "current", &"SO_WAR_RETRIEVE_DRM",dsm_obj.origin);
	objective_set3d( objectiveNum, true, "default",  &"SO_WAR_RETRIEVE_DRM_3D" );
	level.objectiveNum++;
	dsm_trig 	= maps\_so_war_support::war_create_trigger_use(dsm_obj.origin,48,"SO_WAR_PRO1_TRIGGER_HINT2",undefined,"use_activated_retrieve",level);
	flag_set("escape_event");
	level waittill("use_activated_retrieve");
	Objective_State( objectiveNum, "done" );
	dsm_trig Delete();
	dsm_obj Delete();
	
}
//////////////////////////////////////////////////////////////////////////////////////////////////
escape_event(segment)
{
	flag_wait("escape_event");//go time
	wait 0.5;
	assert( level.currentGameSeg.segID == segment,"Active segment was expected to be something else");

	//: stuff

	level waittill(level.currentGameSeg.notifyFinish );	
}
//////////////////////////////////////////////////////////////////////////////////////////////////
outro_event()
{
	flag_wait("outro_event");//go time
	maps\_so_war_support::hide_player_hud();
	
	player = GetPlayers()[0];
	player takeallweapons();
	
	iprintlnbold( "ANIM: Player is picked up by osprey" );
	wait(5);
	iprintlnbold( "VO: <COMMAND> Weapons hot, on target 20 seconds." );
	wait( 5 );
	iprintlnbold( "VO: <COMMAND> Bring in home..." );
	
	outro_remotemissile();

	flag_set("war_mission_completed");
}

outro_remotemissile()
{
	maps\_so_war_support::hide_player_hud();
	
	player = GetPlayers()[0];
	player takeallweapons();
	
	level.remotemissile_override_origin = (-8612,-12421,18017);
	level.remotemissile_override_angles = (50.8,53.3,0);
	level.remotemissile_override_target = (-968, -2400, 867);
	player maps\sp_killstreaks\_killstreaks::useKillstreak( "remote_missile_sp");
	wait .5;
	player SetClientFlag( level.CLIENT_FLAG_REMOTE_MISSILE );
	
	level.remotemissile_override_origin = undefined;
	level.remotemissile_override_angles = undefined;
	level.remotemissile_override_target = undefined;	
	player waittill( "remotemissile_done" );
	player ClearClientFlag( level.CLIENT_FLAG_REMOTE_MISSILE );
}

//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////
createSAMTurret(location)
{
	//Spawn a turret at this location 
	turret = spawnTurret( "auto_turret", location.origin, "tow_turret_sp" );
	turret.turretType = "tow";
	turret SetTurretType(turret.turretType );
	
	turret SetModel( level.auto_turret_settings[turret.turretType].modelBase );
	turret SetForceNoCull();
	turret PlaySound ("mpl_turret_startup");
	turret maketurretunusable();
	turret SetMode( "manual", "scan" );
	
	turret.hasBeenPlanted = true;
	turret.waitForTargetToBeginLifespan = false;
	turret.stunnedByTacticalGrenade = false;
	turret.stunTime = 0.0;
	turret.curr_time = 0;
	turret.fireTime = level.auto_turret_settings[turret.turretType].turretFireDelay;
	turret.angles = location.angles;
	turret.turret_active = true;
	turret.takedamage = true;
	turret.stunDuration = 60.0;
	turret.carried = 0;
	turret.team = "axis";
	turret.health = 2000;
	turret.bulletDamageReduction = 0.3;

	turret setturretteam( turret.team);
	turret SetDefaultDropPitch(45.0);
	turret SetScanningPitch(-35.0);
	turret SetLeftArc( 25 );
	turret SetRightArc( 25 );

	location.script_ent = turret;

	wait 1;
	turret_set_difficulty( turret, "fu" );


	offset = level.turrets_headicon_offset[ turret.turretType ];
	turret maps\sp_killstreaks\_entityheadicons::setEntityHeadIcon( turret.team, GetPlayers()[0], offset ); //passing in player, player is used to create the client hud elm
	
	turret thread maps\sp_killstreaks\_turret_killstreak::turret_tow_think();
	turret thread maps\sp_killstreaks\_turret_killstreak::watchDamage();
	turret thread samTurret_destroyTurret();
	turret thread samTurret_targetingSystem();
	
	return turret;
}
//////////////////////////////////////////////////////////////////////////////////////////////////
samTurret_targetingSystem()
{
	level endon("special_op_terminated");
	self endon("destroy_turret");
	while(1)
	{
		//check team always, could be hacked?
		myTeam = self.team;
		if(!isDefined(myTeam))
		{
			myTeam = "axis";
		}
	
		curEnemy = self getTargetEntity();
		
		if (isDefined(curEnemy) )
		{
			if(isDefined(curEnemy.vteam) )
				team = curEnemy.vteam;
			else
				team = curEnemy.team;
		
			if ( team == myTeam )
			{
				self ClearTargetEntity();
				curEnemy = undefined;
			}
		}
		
		
		if ( isDefined(curEnemy) )
		{
			distSQ = distancesquared(self.origin,curEnemy.origin);
			if (distSQ >= MAX_TURRET_ENGAGE_DIST_SQ)
			{
				self ClearTargetEntity(); 
				curEnemy = undefined;
			}
		}
		
		if ( !isDefined(curEnemy) )
		{
			self StopFiring(); 
			if ( myTeam == "axis" )
			{
				enemies = GetVehicleArray("allies");
			}
			else
			{
				enemies = GetVehicleArray("axis");
			}
			if (isDefined(enemies) )
			{
				foreach(enemy in enemies)
				{
					distSQ = distancesquared(self.origin,enemy.origin);
					if (distSQ < MAX_TURRET_ENGAGE_DIST_SQ)
					{
						self StartFiring(); 
						self setTargetEntity(enemy);
						self notify("turretstatechange");
						break;
					}
				}
			}
		}
	
		wait 1;
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
samTurret_disable_watcher()
{
	level endon("special_op_terminated");
	level endon("sam_sites_destroyed");

	while(1)
	{
		self waittill(level.currentGameSeg.notifyProgress,turret,hacked);
		if (!hacked)
		{
			turret notify("destroy_turret",true);
		}
		else
		{
			turret.team = "allies";
			turret setturretteam( turret.team );
			offset = level.turrets_headicon_offset[ turret.turretType ];
			turret maps\sp_killstreaks\_entityheadicons::setEntityHeadIcon( turret.team, GetPlayers()[0], offset ); //passing in player, player is used to create the client hud elm
			turret playsound ("dst_equipment_destroy");
			turret maps\sp_killstreaks\_turret_killstreak::stunTurret( 5 );
			turret PlaySound ("mpl_turret_startup");
			turret maketurretunusable();
			turret SetMode( "manual", "scan" );
			level.WAR_sam_sites = array_remove(level.WAR_sam_sites,turret);
			if ( level.WAR_sam_sites.size == 0 )
			{
				level notify("sam_sites_destroyed");
			}
		}
	}
}
//////////////////////////////////////////////////////////////////////////////////////////////////
samTurret_destroyTurret(playDeathAnim)
{
	level endon("special_op_terminated");
	self waittill( "destroy_turret", playDeathAnim );

	level notify("war_destroyed",self);
	level.WAR_sam_sites = array_remove(level.WAR_sam_sites,self);
	if ( level.WAR_sam_sites.size == 0 )
	{
		level notify("sam_sites_destroyed");
	}

	self.turret_active = false;
	self.curr_time = -1;
	self SetMode( "auto_ai" );
	self notify( "stop_burst_fire_unmanned" );
	self notify( "turret_deactivated" );
	if( isDefined( playDeathAnim ) && playDeathAnim && !self.carried )
	{
		// show like it's stunned before we blow it up & play some sound
		self playsound ("dst_equipment_destroy");
		self maps\sp_killstreaks\_turret_killstreak::stunTurret( self.stunDuration );
	}
	
	wait( 0.1 );

	if( isdefined( self ) ) 
	{
		if( self.hasBeenPlanted )
		{
			PlayFX( level._turret_explode_fx, self.origin + (0, 0, 20) );
			self playsound ("mpl_turret_exp");
		}
		self Delete();
	}
}




