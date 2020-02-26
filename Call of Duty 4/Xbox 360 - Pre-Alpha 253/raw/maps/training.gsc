#include maps\_utility;
#include maps\_hud_util;
#include maps\_anim;

main()
{
	setExpFog(200, 2700, .65 , .5 , .33, 0);

	// add the starts before _load because _load handles starts now
	default_start( ::navigationTraining );
	add_start( "navigation", ::navigationTraining );
	add_start( "obstacle", ::obstacleTraining );
	add_start( "rifle", ::rifleTraining );
	add_start( "sidearm", ::sideArmTraining );
	add_start( "frag", ::fragTraining );
	add_start( "launcher", ::launcherTraining );
	add_start( "explosives", ::explosivesTraining );
	add_start( "battle", ::battleStart );
	

	maps\_load::main();
	maps\training_anim::main();
	level thread maps\training_amb::main();
	maps\_compass::setupMiniMap("compass_map_training");

	level.curObjective = 1;
	level.objectives = [];

	playerInit();
	buddiesInit();
	speakersInit();
	registerActions();
	thread playerShootTracker();
	
	precacheString( &"TRAINING_OBJ_GET_RIFLE_AMMO" );
	precacheString( &"TRAINING_OBJ_ENTER_STALL" );
	precacheString( &"TRAINING_HINT_SIDEARM" );
	precacheString( &"TRAINING_HINT_OBJECTIVE_MARKER" );
	precacheString( &"TRAINING_HINT_OBJECTIVE_REMINDER" );
	precacheString( &"TRAINING_HINT_OBJECTIVE_REMINDER2" );
	precacheString( &"TRAINING_HINT_LADDER" );
	precacheString( &"TRAINING_HINT_HOLDING_SPRINT" );

	getEnt( "explosives_pickup_trigger", "targetname" ) trigger_off();
	getEnt( "explosives_use_trigger", "targetname" ) trigger_off();
	
   	jumpTo( getDvar( "start" ) );
		

}

start()
{
}


playerInit()
{
	level.gunPrimary = "m4_grunt";
	level.gunSidearm = "beretta";

	level.player takeAllWeapons();
	level.player giveWeapon( level.gunPrimary );
	level.player giveWeapon( level.gunSidearm );
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("smoke_grenade_american");

	level.player SetWeaponAmmoStock( level.gunPrimary, 0 );
	level.player SetWeaponAmmoStock( level.gunSidearm, 0 );
	level.player SetWeaponAmmoClip( level.gunPrimary, 0 );
	level.player SetWeaponAmmoClip( level.gunSidearm, 0 );
	level.player SetWeaponAmmoStock( "fraggrenade", 0 );
	level.player SetWeaponAmmoClip( "fraggrenade", 0 );
	level.player SetWeaponAmmoStock( "smoke_grenade_american", 0 );
	level.player SetWeaponAmmoClip( "smoke_grenade_american", 0 );

	level.player switchToWeapon( level.gunPrimary );
}


buddiesInit()
{
	level.buddies = getEntArray( "buddy", "script_noteworthy" );
	level.buddiesByID = [];
	for ( index = 0; index < level.buddies.size; index++ )
	{
		level.buddies[index].buddyID = int( level.buddies[index].targetname[5] );
		level.buddiesByID[level.buddies[index].buddyID] = level.buddies[index];
	}
}


speakersInit()
{
	thread battlechatter_off();
	level.marine1 = getEnt( "marine1", "script_noteworthy" );
	assert( isDefined( level.marine1 ) );
	level.marine1.animname = "marine1";
	level.marine1.lastSpeakTime = 0;
	level.marine1.lastNagTime = 0;
	level.marine1.speaking = false;
	level.marine1 pushplayer( true );

	level.smith = getEnt( "smith", "script_noteworthy" );
	assert( isDefined( level.smith ) );
	level.smith.animname = "smith";
	level.smith.lastSpeakTime = 0;
	level.smith.lastNagTime = 0;
	level.smith.speaking = false;
	level.smith pushplayer( true );

	level.marine2 = getEnt( "marine2", "script_noteworthy" );
	assert( isDefined( level.marine2 ) );
	level.marine2.animname = "marine2";
	level.marine2.lastSpeakTime = 0;
	level.marine2.lastNagTime = 0;
	level.marine2.speaking = false;
	level.marine2 pushplayer( true );

	level.marine3 = getEnt( "marine3", "script_noteworthy" );
	assert( isDefined( level.marine3 ) );
	level.marine3.animname = "marine3";
	level.marine3.lastSpeakTime = 0;
	level.marine3.lastNagTime = 0;
	level.marine3.speaking = false;
	level.marine3 pushplayer( true );

	level.marine4 = getEnt( "marine4", "script_noteworthy" );
	assert( isDefined( level.marine4 ) );
	level.marine4.animname = "marine4";
	level.marine4.lastSpeakTime = 0;
	level.marine4.lastNagTime = 0;
	level.marine4.speaking = false;
	level.marine4 pushplayer( true );

	level.marine5 = getEnt( "marine5", "script_noteworthy" );
	assert( isDefined( level.marine5 ) );
	level.marine5.animname = "marine5";
	level.marine5.lastSpeakTime = 0;
	level.marine5.lastNagTime = 0;
	level.marine5.speaking = false;
	level.marine5 pushplayer( true );
}


jumpTo( jumpToArea )
{
	jumpToNodes = getEntArray( "jumpto_training_" + jumpToArea, "targetname" );
	if ( !jumpToNodes.size )
	{
		printLn( "Invalid jumpto: " + jumpToArea );
		return;
	}
	
	for ( index = 0; index < jumpToNodes.size; index++ )
	{
		node = jumpToNodes[index];

		if ( node.script_noteworthy == "player_pos" )
		{
			level.player setOrigin( node.origin );
			level.player setPlayerAngles( node.angles );
		}
		else if ( isSubStr( node.script_noteworthy, "buddy_pos" ) )
		{
			id = int( node.script_noteworthy[9] );
			
			level.buddiesByID[id] teleport( node.origin );
			level.buddiesByID[id] setGoalPos( node.origin );
		}
	}
}
//****************************************************************
//****************************************************************
//****************************************************************

navigationTraining()
{
	level notify ( "navigationTraining_start" );
	flag_trigger_init( "near_obstacle", getEnt( "obstacleTraining_near", "targetname" ), true );
	flag_trigger_init( "player_in_line", getEnt( "obstacleTraining_line", "targetname" ), true );
	flag_trigger_init( "player_entered_course", getEnt( "obstacleTraining_enter", "targetname" ) );
	registerObjective( "obj_regroup_with_squad", &"TRAINING_OBJ_REGROUP_WITH_SQUAD", getEnt( "obstacleTraining_near", "targetname" ) );
	thread navigationTraining_buddies();

	level.marine1 thread execDialog( "meetsquad" );
	
	wait 2;
	setObjectiveState( "obj_regroup_with_squad", "current" );
	
	thread navigationTraining_objectiveHint();
	
	flag_wait( "near_obstacle" );
	setObjectiveLocation( "obj_regroup_with_squad", getEnt( "obstacleTraining_objective", "targetname" )  );
	level.smith execDialog( "firstsquad" );

	flag_wait( "player_entered_course" );
	level.smith execDialog( "getinformation" );

	level.smith.lastNagTime = getTime();
	while ( !flag( "player_in_line" ) )
	{
		level.smith nagPlayer( "getinline", 10.0 );
		wait ( 0.05 );
	}

	setObjectiveState( "obj_regroup_with_squad", "done" );
	level notify ( "navigationTraining_end" );
	wait ( 0.5 );
	thread obstacleTraining();
}


navigationTraining_objectiveHint()
{
	level endon ( "mission failed" );
	level endon ( "navigationTraining_end" );

	wait ( 1.0 );
	actionBind = getActionBind( "objectives" );	
	keyHint( actionBind.hint, actionBind.key, 6.0);

	wait ( 1.0 );
	thread hint( &"TRAINING_HINT_OBJECTIVE_MARKER", 10.0 );

	level.marine1.lastNagTime = getTime();
	timePassed = 0;
	for ( ;; )
	{
		if( distance( level.player.origin, level.marine1.origin ) < 512 )
			level.marine1 nagPlayer( "squadwaiting", 15.0 );
		
		if ( !flag( "player_entered_course" ) && timePassed > 30.0 )
		{
			hint( &"TRAINING_HINT_OBJECTIVE_REMINDER", 6.0 );
			wait( 0.5 );
			thread hint( &"TRAINING_HINT_OBJECTIVE_REMINDER2", 10.0 );			
			timePassed = 0;
		}
		
		timePassed += 0.05;
		wait ( 0.05 );
	}
}


navigationTraining_buddies()
{
	for ( index = 0; index < level.buddies.size; index++ )
	{
		// waiting around, playing idles
	}
	
	flag_wait( "near_obstacle" );

	for ( index = 0; index < level.buddies.size; index++ )
	{
		buddy = level.buddies[index];
		buddy.goalradius = 32;
		buddy setGoalNode( getNode( "obstacle_lane_node" + buddy.buddyID, "targetname" ) );
	}
}


obstacleTraining()
{
	level notify ( "obstalceTraining_start" );

	flag_trigger_init( "melee_entered", getEnt( "obstacleTraining_melee", "targetname" ) );
	flag_trigger_init( "crouch_entered", getEnt( "obstacleTraining_crouch", "targetname" ) );
	flag_trigger_init( "prone_entered", getEnt( "obstacleTraining_prone", "targetname" ) );
	flag_trigger_init( "open_fire", getEnt( "obstacleTraining_mgs", "targetname" ) );

	flag_init( "course_started" );

	registerObjective( "obj_bash_dummy", &"TRAINING_OBJ_BASH_DUMMY", getEnt( "obj_bash_dummy", "targetname" ) );
	thread obstacleTraining_buddies();

	//wait ( 2.0 );
	flag_set( "course_started" );
	setObjectiveState( "obj_bash_dummy", "current" );
	thread obstacleTraining_dialog();

	flag_wait( "crouch_entered" );
	actionBind = getActionBind( "crouch" );	
	thread keyHint( actionBind.hint, actionBind.key );

	flag_wait( "prone_entered" );
	actionBind = getActionBind( "prone" );	
	thread keyHint( actionBind.hint, actionBind.key );

	flag_wait( "open_fire" );

	getEnt( "obstacleTraining_Standup", "targetname" ) waittill ( "trigger" );
	actionBind = getActionBind( "stand" );
	thread keyHint( actionBind.hint, actionBind.key, 5.0 );
	
	getEnt( "obstacleTraining_mantle", "targetname" ) waittill ( "trigger" );
	actionBind = getActionBind( "mantle" );
	thread keyHint( actionBind.hint, actionBind.key, 5.0 );

	getEnt( "obstacleTraining_ladder", "targetname" ) waittill ( "trigger" );
	thread hint( &"TRAINING_HINT_LADDER" );
	while ( level.player isTouching( getEnt( "obstacleTraining_ladder", "targetname" ) ) )
		wait ( 0.05 );

	level.hintElem destroyElem();		

	getEnt( "obstacleTraining_sprint", "targetname" ) waittill ( "trigger" );
	level.smith thread execDialog( "sprint" );
	actionBind = getActionBind( "sprint" );
	keyHint( actionBind.hint, actionBind.key ); // make this not disappear
	
	actionBind = getActionBind( "sprint2" );
	hint( actionBind.hint );

	while( !flag( "melee_entered" ) )
		wait ( 0.05 );

	actionBind = getActionBind( "melee" );
	thread keyHint( actionBind.hint, actionBind.key );

	flag_triggers_init( "dummy_melee", getEntArray( "melee_damage_trigger", "targetname" ) );
	
	level.smith execDialog( "melee" );
	level.smith.lastNagTime = getTime();
	while ( !flag( "dummy_melee" ) )
	{
		level.smith nagPlayer( "carvermelee", 6.0 );
		wait ( 0.05 );
	}

	setObjectiveState( "obj_bash_dummy", "done" );
	while (level.smith.speaking)
		wait .05;
	level.smith thread execDialog( "gotorange" );

	level notify ( "obstacleTraining_end" );
	wait ( 0.5 );
	thread rifleTraining();
}



obstacleTraining_dialog()
{
	level endon( "obstacleTraining_end" );

	level.smith execDialog( "gogogo" );
	wait .5;

	flag_wait( "crouch_entered" );
	level.smith execDialog( "crouch" );
	wait .5;

	flag_wait( "prone_entered" );
	level.smith execDialog( "prone" );
	
	flag_wait( "open_fire" );
	level.smith execDialog( "openfire" );
}


obstacleTraining_buddies()
{
	for ( index = 0; index < level.buddies.size; index++ )
	{
		buddy = level.buddies[index];
		startNode = getNode( "obstacle_lane_node" + buddy.buddyID, "targetname" );
		
		level.buddies[index] thread obstacleTrainingCourseThink( startNode );
	}
	
	level thread buddyMovementScaler();
}


obstacleTrainingCourseThink( goalNode )
{
	level endon( "obstacleTraining_end" );
	
	self.goalradius = 32;
	self setGoalNode( goalNode );
	self waittill ( "goal" );
	
	flag_wait( "course_started" );
	while ( isDefined( goalNode.target ) )
	{
		goalNode = getNode( goalNode.target, "targetname" );

		self setGoalNode( goalNode );
		self waittill ( "goal" );

		if ( isDefined( goalNode.script_noteworthy ) && goalNode.script_noteworthy == "prone" )
			self allowedStances( "prone" );
		else if ( isDefined( goalNode.script_noteworthy ) && goalNode.script_noteworthy == "stand" )
			self allowedStances( "prone", "stand", "crouch" );		
	}
}

buddyMovementScaler()
{
	level endon( "obstacleTraining_end" );
	for ( ;; )
	{
		maxYPos = level.buddies[0].origin[1];
		minYPos = level.buddies[0].origin[1];
		avgYPos = 0;

		for ( index = 0; index < level.buddies.size; index++ )
		{
			buddy = level.buddies[index];

			if ( buddy.origin[1] < minYPos )
				minYPos = buddy.origin[1];
				
			if ( buddy.origin[1] > maxYPos )
				maxYPos = buddy.origin[1];
				
			avgYPos += buddy.origin[1];
		}
		avgYPos /= level.buddies.size;
		
		for ( index = 0; index < level.buddies.size; index++ )
		{
			buddy = level.buddies[index];

			if ( buddy.origin[1] > avgYPos )
			{
				frac = (buddy.origin[1] - avgYPos) / (maxYPos - avgYPos);
				buddy.animplaybackrate = 1 - frac * 0.2;
//				buddy thread printAboveHead (buddy.animplaybackrate, 1, undefined, (0,1,0) );
			}
			else if ( buddy.origin[1] < avgYPos )
			{
				frac = (avgYPos - buddy.origin[1]) / (avgYPos - minYPos);
				buddy.animplaybackrate = 1 + frac * 0.2;
//				buddy thread printAboveHead (buddy.animplaybackrate, 1, undefined, (1,0,0) );
			}
		}
		wait ( 1.0 );
	}
//	oldAnimPlaybackRate = self.animplaybackrate;
}


rifleTraining()
{
	level notify ( "rifleTraining_start" );
	
	autosave_by_name( "rifle_training" );

	flag_trigger_init( "player_entered_rifle", getEnt( "rifleTraining_enter", "targetname" ) );
	flag_trigger_init( "player_at_rifle_stall", getEnt( "rifleTraining_stall", "targetname" ), true );
	
	registerObjective( "obj_get_rifle_ammo", &"TRAINING_OBJ_GOTO_RIFLE", getEnt( "obj_rifle_ammo", "targetname" ) );
	registerObjective( "obj_hit_rifle_targets", &"TRAINING_OBJ_HIT_RIFLE_TARGETS", getEnt( "obj_rifle_stall", "targetname" ) );
	registerObjective( "obj_hit_rifle_targets_timed", &"TRAINING_OBJ_HIT_RIFLE_TARGETS_TIMED", getEnt( "obj_rifle_stall", "targetname" ) );

	thread training_targetDummies( "rifle" );

	thread rifleTraining_buddies();
	array_thread( getEntArray( "rifle_ammoitem", "targetname" ), ::ammoRespawnThink );

	gate = getEnt( "gate_rifle", "targetname" );
	gate moveX( 192, 3, 1, 1 );

	setObjectiveState( "obj_get_rifle_ammo", "current" );

	flag_wait( "player_entered_rifle" );
	setObjectiveString( "obj_get_rifle_ammo", &"TRAINING_OBJ_GET_RIFLE_AMMO" );

	level.marine2 execDialog( "getammo" );
	level.marine2 thread execDialog( "assignments" );

	while ( !(level.player GetWeaponAmmoStock( level.gunPrimary )) && !(level.player GetWeaponAmmoClip( level.gunPrimary )) )
	{
		if ( level.marine2 nagPlayer( "loadweapon", 8.0 ) )
		{
			if ( (level.player GetWeaponAmmoStock( level.gunPrimary )) && !(level.player GetWeaponAmmoClip( level.gunPrimary )) )
			{
				actionBind = getActionBind( "reload" );
				thread keyHint( actionBind.hint, actionBind.key );
			}
		}
		wait ( 0.05 );
	}

	setObjectiveString( "obj_get_rifle_ammo", &"TRAINING_OBJ_ENTER_STALL" );
	setObjectiveLocation( "obj_get_rifle_ammo", getEnt( "obj_rifle_stall", "targetname" )  );

	level.marine2.lastNagTime = getTime();
	while( !flag( "player_at_rifle_stall" ) )
	{
		level.marine2 illegalFireCheck( "carverceasefire" );
		level.marine2 nagPlayer( "gotofour", 8.0 );
		wait ( 0.05 );
	}

	while( level.marine2.speaking )
		wait ( 0.05 );

	level.marine2 execDialog( "aimdownrange" );

	while( !flag( "player_at_rifle_stall" ) || !isADS() )
	{
		level.marine2 illegalFireCheck( "carverceasefire" );
		if ( !flag( "player_at_rifle_stall" ) )
		{
			level.marine2 nagPlayer( "gotofour", 6.0 );
		}
		else if ( !isADS() )
		{
			if ( level.marine2 nagPlayer( "aimyourweapon", 6.0 ) )
			{
				actionBind = getActionBind( "ads" );
				thread keyHint( actionBind.hint, actionBind.key );
			}
		}
		wait ( 0.05 );		
	}

	setObjectiveState( "obj_get_rifle_ammo", "done" );
	array_thread( level.buddies, ::rifleTrainingShootThink );
	level.marine2 execDialog( "dontfire" );

	wait ( 1.0 );

	while( level.marine2 illegalFireCheck( "carverceasefire" ) )
		wait ( 1.5 );

	level.marine2 execDialog( "weaponsfree" );

	wait ( 0.1 );
	raiseTargetDummies( "rifle", undefined, 0 );
	raiseTargetDummies( "rifle", undefined, 1 );
	raiseTargetDummies( "rifle", undefined, 2 );
	raiseTargetDummies( "rifle", undefined, 3 );	
	raiseTargetDummies( "rifle", undefined, 4 );	
	raiseTargetDummies( "rifle", undefined, 5 );	
	setObjectiveState( "obj_hit_rifle_targets", "current" );
	
	actionBind = getActionBind( "attack" );
	thread keyHint( actionBind.hint, actionBind.key );

	flag_set( "can_fire_rifle" );

	wait ( 1.0 );
	targetDummies = getTargetDummies( "rifle", 4 );
	numRaised = targetDummies.size;
	while ( numRaised )
	{
		numRaised = 0;
		for ( index = 0; index < targetDummies.size; index++ )
		{
			if ( targetDummies[index].raised )
				numRaised++;
		} 
		
		if ( !(level.player GetWeaponAmmoStock( level.gunPrimary )) )
		{
			level.marine2 nagPlayer( "getammo", 8.0 ); // should tell carver to get more ammo
			println ("z:             wtf2");
		}
		else if ( !(level.player GetWeaponAmmoClip( level.gunPrimary )) )
		{
			wait ( 2.0 );
			if ( !(level.player GetWeaponAmmoClip( level.gunPrimary )) )
			{
				actionBind = getActionBind( "reload" );
				thread keyHint( actionBind.hint, actionBind.key );
				
				level.marine2 nagPlayer( "loadweapon", 8.0 );
				println ("z:             wtf");			
			}
		}
		else if ( !flag( "player_at_rifle_stall" ) )
		{
			level.marine2 nagPlayer( "backtostation", 8.0 );
		}
		
		wait ( 0.05 );
	}

	setObjectiveState( "obj_hit_rifle_targets", "done" );
	level.marine2 execDialog( "ceasefire" );
	flag_clear( "can_fire_rifle" );

	wait ( 3.0 );
	level.marine2 illegalFireCheck( "isaidcease" );

	if ( level.player GetWeaponAmmoClip( level.gunPrimary ) == 30 )
		level.player SetWeaponAmmoClip( level.gunPrimary, 29 );
	
	level.marine2 execDialog( "changemags" );
	
	if ( level.player GetWeaponAmmoClip( level.gunPrimary ) != 30 )
	{
		actionBind = getActionBind( "reload" );
		thread keyHint( actionBind.hint, actionBind.key );				
	}

	level.marine2.lastNagTime = getTime();
	while( level.player GetWeaponAmmoClip( level.gunPrimary ) != 30 )
	{
		level.marine2 nagPlayer( "loadweapon", 6.0 );
		wait ( 0.05 );
	}

	lowerTargetDummies( "rifle", undefined, 0 );
	lowerTargetDummies( "rifle", undefined, 1 );
	lowerTargetDummies( "rifle", undefined, 2 );
	lowerTargetDummies( "rifle", undefined, 5 );

	while( level.marine2 illegalFireCheck( "carverceasefire" ) )
		wait ( 1.5 );

	level.marine2 execDialog( "timedtargets" );
	wait ( 0.1 );
	level.player playSound( "training_wal_goodtogo" );
	wait ( 1.0 );

	while( level.marine2 illegalFireCheck( "carverceasefire" ) )
		wait ( 1.5 );

	if ( level.xenon )
	{
		actionBind = getActionBind( "ads_switch" );
		thread hint( actionBind.hint, 5.0 );
	}

	wait ( 1.0 );

	setObjectiveState( "obj_hit_rifle_targets_timed", "current" );
	
	numHit = 0;
	numRepeats = 0;
	while ( numHit < 4 )
	{
		level.marine2 execDialog( "fire" );				
		flag_set( "can_fire_rifle" );
		thread rifleTraining_timedTargets( 1, 4, 10.0 );
		thread rifleTraining_timedTargets( 2, 4, 10.0 );
		thread rifleTraining_timedTargets( 3, 4, 10.0 );
		thread rifleTraining_timedTargets( 5, 4, 10.0 );
		thread rifleTraining_timedTargets( 6, 4, 10.0 );
		thread rifleTraining_timedTargets( 7, 4, 10.0 );
		thread rifleTraining_timedTargets( 8, 4, 10.0 );
		numHit = rifleTraining_timedTargets( 4, 4, 10.0 );	
		flag_clear( "can_fire_rifle" );

		if ( numHit < 4 )
		{
			wait ( 1.0 );

			numRepeats++;
			if ( numRepeats > 1 )
				level.marine2 execDialog( "stilltooslow" );
			else
				level.marine2 execDialog( "tooslow" );

			if ( level.xenon )
			{
				actionBind = getActionBind( "ads_switch" );
				thread hint( actionBind.hint);
			}
	
			wait ( 2.0 );
		}
	}

	while( level.marine2 illegalFireCheck( "carverceasefire" ) )
		wait ( 1.5 );

	wait ( 1.0 );
	
	setObjectiveState( "obj_hit_rifle_targets_timed", "done" );

	level.marine2 execDialog( "gotorange" );	

	level notify ( "rifleTraining_end" );
	wait ( 0.5 );
	thread sidearmTraining();
}


illegalFireCheck( scoldAnim )
{
	if ( !level.player.illegalFire )
		return false;
		
	while ( !self scoldPlayer( scoldAnim ) )
		wait ( 0.05 );
	level.player.illegalFire = false;
	
	return true;
}


nagPlayer( nagAnim, minNagTime )
{
	if ( self.speaking )
		return false;
		
	time = getTime();
	if ( time - self.lastSpeakTime < 1.0 )
		return false;
		
	if ( time - self.lastNagTime < (minNagTime * 1000) )
		return false;
		
	self execDialog( nagAnim );
	self.lastNagTime = self.lastSpeakTime;
	return true;
}


scoldPlayer( scoldAnim )
{
	if ( self.speaking )
		return false;

	self execDialog( scoldAnim );
	return true;
}


execDialog( dialogAnim )
{
	assert( !self.speaking );
	self.speaking = true;
	self anim_single_solo( self, dialogAnim );
	self.speaking = false;
	self.lastSpeakTime = getTime();
}
/*
rifleTraining_timedTargets( laneID, numTargets, timeLimit )
{
	assert( numTargets * 0.25 < timeLimit );

	targetOrder = [];
	targetOrder[targetOrder.size] = randomInt( 4 );
	while ( targetOrder.size < numTargets )
	{
		targetID = randomInt( 4 );
		while ( targetID == targetOrder[targetOrder.size - 1] )
			targetID = randomInt( 4 );

		targetOrder[targetOrder.size] = targetID;
	}

	numHit = 0;
	timePerTarget = (timeLimit - (numTargets * 0.5)) / numTargets;

	for ( index = 0; index < numTargets; index++ )
	{
		raiseTargetDummies( "rifle", laneID, targetOrder[index] );
		wait ( 0.25 );
		wait ( timePerTarget );

		targetDummies = getTargetDummies( "rifle", laneID, targetOrder[index] );
		if ( !targetDummies[0].raised || targetDummies[0].moving )
			numHit++;
		
		lowerTargetDummies( "rifle", laneID, targetOrder[index] );
	}
	
	return numHit;
}
*/

rifleTraining_timedTargets( laneID, numTargets, timeLimit )
{
	
	assert( numTargets * 0.25 < timeLimit );

	targetOrder = [];
	targetOrder[targetOrder.size] = randomInt( 4 );
	while ( targetOrder.size < numTargets )
	{
		targetID = randomInt( 4 );
		while ( targetID == targetOrder[targetOrder.size - 1] )
			targetID = randomInt( 4 );

		targetOrder[targetOrder.size] = targetID;
	}

	numHit = 0;
	timePerTarget = (timeLimit - (numTargets * 0.5)) / numTargets;

	for ( index = 0; index < numTargets; index++ )
	{
		raiseTargetDummies( "rifle", laneID, targetOrder[index] );
		wait ( 0.25 );
		wait ( timePerTarget );

		targetDummies = getTargetDummies( "rifle", laneID, targetOrder[index] );
		if ( !targetDummies[0].raised || targetDummies[0].moving )
			numHit++;
		
		lowerTargetDummies( "rifle", laneID, targetOrder[index] );
	}
	
	return numHit;
}


isADS()
{
	return ( level.player playerADS() > 0.5 );
}


rifleTraining_buddies()
{
	startNode = getNode( "action_chain1", "targetname" );
	startNode2 = getNode( "action_chain2", "targetname" );

	//initActionChain( startNode );
	//initActionChain( startNode2 );

	for ( index = 0; index < level.buddies.size; index++ )
	{
		if ( level.buddies[index].buddyID <= 4 )
			level.buddies[index] thread rifleTrainingIntroThink( startNode );
		else
			level.buddies[index] thread rifleTrainingIntroThink( startNode2 );
	}
}


rifleTrainingIntroThink( startNode )
{
	level endon( "rifleTraining_end" );

	self.goalRadius = 16;
	self.interval = 0;
	self.atRifleStall = false;

//	self actionChainThink( startNode );

	self setGoalNode( getNode( "rifle_stall_node" + (self.buddyID), "targetname" ) );	
	self waittill ( "goal" );
	
	self.atRifleStall = true;
}


rifleTrainingShootThink()
{
	level endon( "rifleTraining_end" );

	while ( !self.atRifleStall )
		wait ( 0.05 );

	self.goalradius = 64;
	
	targetDummies = getTargetDummies( "rifle", self.buddyID );
	targetDummy = targetDummies[randomInt( targetDummies.size )];
	for ( ;; )
	{
		flag_wait( "can_fire_rifle" );
		while( flag( "can_fire_rifle" ) )
		{
			while ( !targetDummy.raised )
			{
				targetDummy = targetDummies[randomInt( targetDummies.size )];
				wait ( 0.05 );
			}
				
			self setEntityTarget( targetDummy );
			
			while ( targetDummy.raised && flag( "can_fire_rifle" ) )
				wait ( 0.05 );

			if ( !flag( "can_fire_rifle" ) )
				wait ( randomFloat( 1.5 ) );
				
			self clearEnemy();
		}	
		self clearEnemy();
	}
}


playerShootTracker()
{
	flag_init( "can_fire_rifle" );
	flag_init( "can_fire_sidearm" );
	
	level.player.illegalFire = false;
	for( ;; )
	{
		while( !level.player isFiring() )
			wait ( 0.05 );
		
		if ( level.player getCurrentWeapon() == level.gunPrimary )
		{
			if ( !flag( "can_fire_rifle" ) && ((level.player GetWeaponAmmoStock( level.gunPrimary )) || (level.player GetWeaponAmmoClip( level.gunPrimary ))) )
				level.player.illegalFire = true;
		}
		else if ( level.player getCurrentWeapon() == level.gunSidearm )
		{
			if ( !flag( "can_fire_sidearm" ) && ((level.player GetWeaponAmmoStock( level.gunSidearm )) || (level.player GetWeaponAmmoClip( level.gunSidearm ))) )
				level.player.illegalFire = true;
		}
		
		wait ( 0.05 );
	}
}



sideArmTraining()
{
	level notify ( "sideArmTraining_begin" );
	autosave_by_name( "sidearm_training" );

	flag_trigger_init( "player_entered_sidearm", getEnt( "sideArmTraining_enter", "targetname" ) );
	flag_trigger_init( "player_at_sidearm_stall", getEnt( "sideArmTraining_stall", "targetname" ), true );

	registerObjective( "obj_get_sidearm_ammo", &"TRAINING_OBJ_GOTO_SIDEARM", getEnt( "obj_sidearm_ammo", "targetname" ) );
	registerObjective( "obj_hit_sidearm_targets", &"TRAINING_OBJ_HIT_SIDEARM_TARGETS", getEnt( "obj_sidearm_stall", "targetname" ) );

	thread training_targetDummies( "sidearm" );

	lowerPlywoodWalls();

	thread sideArmTraining_buddies();
	array_thread( getEntArray( "sidearm_ammoitem", "targetname" ), ::ammoRespawnThink );

	setObjectiveState( "obj_get_sidearm_ammo", "current" );
	flag_wait( "player_entered_sidearm" );
	setObjectiveString( "obj_get_sidearm_ammo", &"TRAINING_OBJ_GET_SIDEARM_AMMO" );
	level.marine3 execDialog( "getammo" );

	while ( !(level.player GetWeaponAmmoStock( level.gunSidearm )) && !(level.player GetWeaponAmmoClip( level.gunSidearm )) )
	{
		if ( level.marine2 nagPlayer( "loadweapon", 8.0 ) )
		{
			if ( (level.player GetWeaponAmmoStock( level.gunSidearm )) && !(level.player GetWeaponAmmoClip( level.gunSidearm )) )
			{
				actionBind = getActionBind( "reload" );
				thread keyHint( actionBind.hint, actionBind.key );
			}
		}
		wait ( 0.05 );
	}

	setObjectiveLocation( "obj_get_sidearm_ammo", getEnt( "obj_sidearm_stall", "targetname" )  );

	while ( level.player getCurrentWeapon() != level.gunSidearm )
	{
		actionBind = getActionBind( "sidearm" );
		thread keyHint( actionBind.hint, actionBind.key );
		wait ( 0.05 );
	}

	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();

	setObjectiveString( "obj_get_sidearm_ammo", &"TRAINING_OBJ_ENTER_STALL" );

	level.marine2.lastNagTime = getTime();
	level.marine3.lastNagTime = getTime();
	while( !flag( "player_at_sidearm_stall" ) || !isADS() )
	{
		level.marine2 illegalFireCheck( "carverceasefire" );
		if ( !flag( "player_at_sidearm_stall" ) )
		{
			level.marine2 nagPlayer( "gotofour", 6.0 );
		}
		else if ( !isADS() )
		{
			actionBind = getActionBind( "ads" );
			thread keyHint( actionBind.hint, actionBind.key );
			level.marine2 nagPlayer( "aimyourweapon", 6.0 );
		}
		wait ( 0.05 );		
	}

	setObjectiveState( "obj_get_sidearm_ammo", "done" );
	wait 0.1;

	wait ( 1.5 );
	array_thread( level.buddies, ::sideArmTrainingShootThink );
	flag_set( "can_fire_sidearm" );

	setObjectiveState( "obj_hit_sidearm_targets", "current" );

	level.marine3 execDialog( "weaponsfree" );

	actionBind = getActionBind( "attack" );
	thread keyHint( actionBind.hint, actionBind.key );

	raiseTargetDummies( "sidearm" );
	wait ( 1.0 );

	targetDummies = getTargetDummies( "sidearm", 4, 0 );

	numhits = 0;
	while ( numhits < 5 )
	{
		while ( targetDummies[0].raised )
			wait ( 0.05 );

		if ( targetDummies[0].cause == "MOD_PISTOL_BULLET" )
		{
			numhits++;
			if ( numHits == 5 )
				continue;
		}
		else
		{
			level.marine3 scoldPlayer( "usesidearm" );
			wait ( 3.0 );
		}

		raiseTargetDummies( "sidearm" );
		wait ( 0.5 );
	}

	setObjectiveState( "obj_hit_sidearm_targets", "done" );
	flag_clear( "can_fire_sidearm" );

	lowerTargetDummies( "sidearm" );

	wait ( 1.0 );
	
	level.marine3 execDialog( "penetratesome" ); // bullet pen desc
	level.marine3 execDialog( "stowsidearm" ); // bullet pen desc

	level.marine2.lastNagTime = getTime();
	level.marine3.lastNagTime = getTime();
	while( !flag( "player_at_sidearm_stall" ) || !isADS() || level.player getCurrentWeapon() != level.gunPrimary )
	{
		level.marine2 illegalFireCheck( "carverceasefire" );
		if ( !flag( "player_at_sidearm_stall" ) )
		{
			level.marine2 nagPlayer( "gotofour", 10.0 );
		}
		else if ( level.player getCurrentWeapon() != level.gunPrimary )
		{
			level.marine3 nagPlayer( "stowsidearm", 10.0 ); // switch weapon nag
			actionBind = getActionBind( "primary" );
			thread keyHint( actionBind.hint, actionBind.key );
		}
		else if ( !isADS() )
		{
			if ( level.marine2 nagPlayer( "aimyourweapon", 6.0 ) ) // ADS nag
			{
				actionBind = getActionBind( "ads" );
				thread keyHint( actionBind.hint, actionBind.key );
			}
		}

		wait ( 0.05 );		
	}
	
	// raise plywood
	raisePlywoodWalls();

	level.marine3 execDialog( "hittarget" ); // when I say
	
	wait ( 2.0 );
	
	level.marine3 execDialog( "alrightweaponsfree" ); // weapons free
	
	raiseTargetDummies( "sidearm" );

	targetDummies = getTargetDummies( "sidearm", 4, 0 );

	numhits = 0;
	while ( numhits < 4 )
	{
		while ( targetDummies[0].raised )
			wait ( 0.05 );

		if ( targetDummies[0].cause == "MOD_RIFLE_BULLET" )
		{
			numhits++;
			if ( numHits == 4 )
				continue;
		}

		raiseTargetDummies( "sidearm" );
		wait ( 0.5 );
	}

	lowerTargetDummies( "sidearm" );
	
	lowerPlywoodWalls();

	level.marine3 thread execDialog( "gotomout" );

	level notify ( "sideArmTraining_end" );
	wait ( 0.5 );
	thread fragTraining();
}


sideArmTraining_buddies()
{
	startNode = getNode( "action_chain1", "targetname" );
	startNode2 = getNode( "action_chain2", "targetname" );

//	initActionChain( startNode );
//	initActionChain( startNode2 );

	for ( index = 0; index < level.buddies.size; index++ )
	{
		if ( level.buddies[index].buddyID <= 4 )
			level.buddies[index] thread sideArmTrainingIntroThink( startNode );
		else
			level.buddies[index] thread sideArmTrainingIntroThink( startNode2 );
	}
}


sideArmTrainingIntroThink( startNode )
{
	level endon( "sideArmTraining_end" );

	self.goalRadius = 16;
	self.interval = 0;
	self.atSideArmStall = false;

//	self actionChainThink( startNode );

	self setGoalNode( getNode( "sidearm_stall_node" + (self.buddyID), "targetname" ) );	
	self waittill ( "goal" );
	
	self.atSideArmStall = true;
}


sideArmTrainingShootThink()
{
	level endon( "sideArmTraining_end" );

	targetDummies = getTargetDummies( "sidearm", self.buddyID );
	targetDummy = targetDummies[0];

	for( ;; )
	{
		if ( !targetDummy.raised || !self.atSideArmStall || !flag( "can_fire_sidearm" ) )
		{
			self clearEnemy();
		}
		else
		{
			self.goalradius = 64;
			self setEntityTarget( targetDummy );
		}
			
		wait ( 0.05 );
	}
}


fragTraining()
{
	level notify ( "fragTraining_begin" );
	autosave_by_name( "frag_training" );

	flag_trigger_init( "player_at_frag_stall", getEnt( "fragTraining_stall", "targetname" ), true );
	flag_trigger_init( "player_entered_frag", getEnt( "fragTraining_enter", "targetname" ) );

	flag_trigger_init( "frag_target_1", getEnt( "grenade_damage_trigger1", "targetname" ) );
	flag_trigger_init( "frag_target_2", getEnt( "grenade_damage_trigger2", "targetname" ) );
	flag_trigger_init( "frag_target_3", getEnt( "grenade_damage_trigger3", "targetname" ) );

	registerObjective( "obj_get_frag_ammo", &"TRAINING_OBJ_GOTO_FRAG", getEnt( "obj_frag_ammo", "targetname" ) );
	registerObjective( "obj_throw_frags", &"TRAINING_OBJ_THROW_FRAGS_DONE", getEnt( "obj_frag_stall", "targetname" ) );

	array_thread( getEntArray( "frag_ammoitem", "targetname" ), ::ammoRespawnThink );

	setObjectiveState( "obj_get_frag_ammo", "current" );
	flag_wait( "player_entered_frag" );
	setObjectiveString( "obj_get_frag_ammo", &"TRAINING_OBJ_GET_FRAG_AMMO" );
	
	level.marine4 execDialog( "getammo" );
	
	while ( !level.player hasWeapon( "fraggrenade" ) )
		wait ( 0.05 );

	setObjectiveState( "obj_get_frag_ammo", "done" );
	wait ( 0.1 );
	
	numRemaining = 0;
	for ( index = 1; index < 4; index++ )
	{
		if ( flag( "frag_target_" + index ) )
			continue;
			
		numRemaining++;
	}

	setObjectiveState( "obj_throw_frags", "current" );
	setObjectiveRemaining( "obj_throw_frags", &"TRAINING_OBJ_THROW_FRAGS", numRemaining );

	actionBind = getActionBind( "frag" );	
	thread keyHint( actionBind.hint, actionBind.key );
	
	level.marine4 execDialog( "firstwindow" );

	level.marine4.lastNagTime = getTime();
	while( numRemaining )
	{
		curRemaining = 0;

		nextTarget = "";
		if ( !flag( "frag_target_1" ) )
		{
			curRemaining++;
			nextTarget = "firstwindow";
		}
		if ( !flag( "frag_target_2" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "secondwindow";
		}
		if ( !flag( "frag_target_3" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "dumpster";
		}
		
		if ( !curRemaining )
			break;

		if ( curRemaining != numRemaining )
		{
			setObjectiveRemaining( "obj_throw_frags", &"TRAINING_OBJ_THROW_FRAGS", curRemaining );
			level.marine4 execDialog( nextTarget );
			level.marine4.lastNagTime = getTime();
		}
		else
		{
			level.marine4 nagPlayer( nextTarget + "again", 10.0 );			
		}
			
		numRemaining = curRemaining;
		
		wait ( 0.05 );
	}
	
	setObjectiveRemaining( "obj_throw_frags", &"TRAINING_OBJ_THROW_FRAGS_DONE", 0 );
	setObjectiveState( "obj_throw_frags", "done" );

	wait ( 1.0 );
	level.marine4 thread execDialog( "gotorange" );

	level notify ( "fragTraining_end" );
	thread launcherTraining();
}


launcherTraining()
{
	level notify ( "launcherTraining_begin" );
	autosave_by_name( "launcher_training" );

	flag_trigger_init( "player_at_launcher_stall", getEnt( "launcherTraining_stall", "targetname" ), true );
	flag_trigger_init( "player_entered_launcher", getEnt( "launcherTraining_enter", "targetname" ) );

	flag_trigger_init( "launcher_wall_target", getEnt( "launcher_wall_trigger", "script_noteworthy" ) );

	registerObjective( "obj_get_launcher_ammo", &"TRAINING_OBJ_GOTO_LAUNCHER", getEnt( "obj_launcher_ammo", "targetname" ) );
	registerObjective( "obj_hit_wall", &"TRAINING_OBJ_HIT_WALL", getEnt( "obj_launcher_stall", "targetname" ) );
	registerObjective( "obj_hit_launcher_targets", &"TRAINING_OBJ_HIT_LAUNCHER_TARGETS_DONE", getEnt( "obj_launcher_stall", "targetname" ) );

	array_thread( getEntArray( "launcher_ammoitem", "targetname" ), ::ammoRespawnThink );
	//array_thread( getEntArray( "m203_ammoitem", "targetname" ), ::ammoRespawnThink );

	setObjectiveState( "obj_get_launcher_ammo", "current" );
	flag_wait( "player_entered_launcher" );
	setObjectiveString( "obj_get_launcher_ammo", &"TRAINING_OBJ_GET_LAUNCHER_AMMO" );

	level.marine5 execDialog( "getammo" );
	
	actionBind = getActionBind( "swap_launcher" );	
	thread keyHint( actionBind.hint, actionBind.key );

	while ( !level.player hasWeapon( "m203" ) )
		wait ( 0.05 );

	level.player giveMaxAmmo( "m203" );
	actionBind = getActionBind( "firemode" );	
	thread keyHint( actionBind.hint, actionBind.key );
	
	while ( !(level.player getCurrentWeapon() == "m203") )
	{
		thread keyHint( actionBind.hint, actionBind.key );
		wait ( 1.0 );
	}

	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
	
	setObjectiveState( "obj_get_launcher_ammo", "done" );
	wait ( 0.1 );
	
	level.marine5 execDialog( "useonwall" );
	setObjectiveState( "obj_hit_wall", "current" );

	while ( !flag( "launcher_wall_target" ) )
	{
		level.player giveMaxAmmo( "m203" );
		wait ( 0.05 );
	}
	
	setObjectiveState( "obj_hit_wall", "done" );
	wait ( 0.1 );
	
	level.marine5 execDialog( "didntexplode" );
	flag_trigger_init( "launcher_target_1", getEnt( "launcher_damage_trigger1", "targetname" ) );
	flag_trigger_init( "launcher_target_2", getEnt( "launcher_damage_trigger2", "targetname" ) );
	flag_trigger_init( "launcher_target_3", getEnt( "launcher_damage_trigger3", "targetname" ) );

	level.marine5 execDialog( "othertargets" );

	setObjectiveState( "obj_hit_launcher_targets", "current" );
	
	numRemaining = 0;
	for ( index = 1; index < 4; index++ )
	{
		if ( flag( "launcher_target_" + index ) )
			continue;
			
		numRemaining++;
	}

	setObjectiveState( "obj_hit_launcher_targets", "current" );
	setObjectiveRemaining( "obj_hit_launcher_targets", &"TRAINING_OBJ_HIT_LAUNCHER_TARGETS", numRemaining );

	level.marine5.lastNagTime = getTime();
	while( numRemaining )
	{
		curRemaining = 0;

		nextTarget = "";
		if ( !flag( "launcher_target_1" ) )
		{
			curRemaining++;
			nextTarget = "hittwo";
		}
		if ( !flag( "launcher_target_2" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "hitthree";
		}
		if ( !flag( "launcher_target_3" ) )
		{
			curRemaining++;
			if ( nextTarget == "" )
				nextTarget = "hitfour";
		}
		
		if ( !curRemaining )
			break;

		level.player giveMaxAmmo( "m203" );

		if ( curRemaining != numRemaining )
		{
			setObjectiveRemaining( "obj_hit_launcher_targets", &"TRAINING_OBJ_HIT_LAUNCHER_TARGETS", curRemaining );
			level.marine5.lastNagTime = getTime();
		}
		else
		{
			level.marine5 nagPlayer( nextTarget, 8.0 );			
		}
			
		numRemaining = curRemaining;
		
		wait ( 0.05 );
	}
	
	setObjectiveRemaining( "obj_hit_launcher_targets", &"TRAINING_OBJ_HIT_LAUNCHER_TARGETS_DONE", 0 );
	setObjectiveState( "obj_hit_launcher_targets", "done" );

	wait ( 1.0 );
	level.marine5 execDialog( "oorah" );
	wait ( 1.0 );

	level notify ( "launcherTraining_end" );
//	thread explosivesTraining();
	thread endOfLevel();
}


endOfLevel()
{
	wait ( 3.0 );
	iPrintLnBold( "End of currently scripted level." );
	wait ( 3.0 );
	missionsuccess( "bog_a", false );
}


explosivesTraining()
{
	level notify ( "explosivesTraining_begin" );

	pickupTrigger = flag_trigger_init( "explosives_pickup", getEnt( "explosives_pickup_trigger", "targetname" ) );
	useTrigger = flag_trigger_init( "explosives_use", getEnt( "explosives_use_trigger", "targetname" ) );
	pickupTrigger trigger_on();

	registerObjective( "obj_get_explosives", &"TRAINING_OBJ_GET_EXPLOSIVES_AMMO", getEnt( "obj_explosives_ammo", "targetname" ) );
	registerObjective( "obj_destroy_vehicle", &"TRAINING_OBJ_DESTROY_VEHICLE", getEnt( "obj_explosives_plant", "targetname" ) );
	
	setObjectiveState( "obj_get_explosives", "current" );
	level.marine5 execDialog( "getdetpack" );

	actionBind = getActionBind( "swap_explosives" );	
	thread keyHint( actionBind.hint, actionBind.key );
	
	getEnt( useTrigger.target, "targetname" ) hide();
	level.marine5.lastNameTime = getTime();
	while ( !flag( "explosives_pickup" ) )
	{
		level.marine5 nagPlayer( "carvergetdetpack", 8.0 );
		wait ( 0.05 );
	}
	getEnt( pickupTrigger.target, "targetname" ) hide();
	pickupTrigger trigger_off();

	setObjectiveState( "obj_get_explosives", "done" );
	wait ( 1.0 );
	setObjectiveState( "obj_destroy_vehicle", "current" );

	getEnt( useTrigger.target, "targetname" ) show();
	useTrigger trigger_on();
	while ( !flag( "explosives_use" ) )
	{
		actionBind = getActionBind( "plant_explosives" );	
		thread keyHint( actionBind.hint, actionBind.key );
		wait ( 1.0 );
	}

	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();

	getEnt( useTrigger.target, "targetname" ) setModel( "mil_tntbomb_mp" );
	useTrigger trigger_off();

	//...
	setObjectiveState( "obj_destroy_vehicle", "done" );

	level notify ( "explosivesTraining_end" );
	thread battleStart();
}


battleStart()
{
	level notify ( "battleStart_begin" );
	
	
	
	level notify ( "battleStart_end" );
}








actionNodeThink( actionNode )
{
	assert( isDefined( actionNode.script_noteworthy ) );
	
	switch( actionNode.script_noteworthy )
	{
		case "ammo_node":
			wait ( 2.0 );
			println( self.buddyID + " leaving" );
		break;
	}
}


getFreeActionNode( curNode )
{
	actionNode = undefined;
	while ( isDefined( curNode.target ) )
	{
		nextNode = getNode( curNode.target, "targetname" );
		
		if ( isDefined( nextNode.script_noteworthy ) )
		{
			if ( nextNode.inUse )
			{
				if ( !isDefined( actionNode ) )
					return curNode;
				else
					return actionNode;
			}
				
			actionNode = nextNode;
		}
		
		curNode = nextNode;		
	}
	return actionNode;
}


initActionChain( actionNode )
{
	while ( isDefined( actionNode.target ) )
	{
		actionNode.inUse = false;
		actionNode = getNode( actionNode.target, "targetname" );
	}
}


actionChainThink( startNode )
{
	self setGoalNode( startNode );
	self waittill( "goal" );
	curNode = startNode;
	actionNode = undefined;

	while ( !isDefined( actionNode ) )
	{
		actionNode = getFreeActionNode( curNode );
		wait ( 0.05 );
	}

	while ( isDefined( actionNode ) )
	{
		actionNode.inUse = true;
		while ( curNode != actionNode )
		{
			curNode = getNode( curNode.target, "targetname" );
			self setGoalNode( curNode );
			self waittill ( "goal" );
		}
		
		self actionNodeThink( actionNode );
		
		while ( isDefined( actionNode ) && curNode == actionNode )
		{
			actionNode = getFreeActionNode( curNode );
			wait ( randomFloatRange( 0.1, 0.5 ) );
		}	
		curNode.inUse = false;
	}
	
	while( isDefined( curNode.target ) )
	{
		curNode = getNode( curNode.target, "targetname" );
		self setGoalNode( curNode );
		self waittill ( "goal" );
	}
}


raisePlywoodWalls()
{
	plywoodWalls = getEntArray( "sidearm_plywood", "script_noteworthy" );
	
	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( 90, 0.25, 0.1, 0.1 );
	}
}


lowerPlywoodWalls()
{
	plywoodWalls = getEntArray( "sidearm_plywood", "script_noteworthy" );
	
	for ( index = 0; index < plywoodWalls.size; index++ )
	{
		plywoodWalls[index] rotateRoll( -90, 0.25, 0.1, 0.1 );
	}
}


raiseTargetDummies( group, laneID, dummyID )
{
	targetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );
		
	for ( index = 0; index < targetDummies.size; index++ )
	{
		targetDummy = targetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		if ( targetDummy.raised )
			continue;
			
		targetDummies[index] thread moveTargetDummy( "raise" );
	}
}

moveTargetDummy( command )
{
	self.modelEnt setCanDamage( false );
		
	while ( self.moving )
		wait ( 0.05 );

	switch( command )
	{
	case "raise":
		if ( !self.raised )
		{
			speed = 0.25;
			self rotatePitch( 90, speed, 0.1, 0.1 );
			wait ( 0.25 );
			self.raised = true;
			
			if ( self.laneID == 4 )
				self enableAimAssist();

			self.modelEnt setCanDamage( true );
		}
		break;
	
	case "lower":
		if ( self.raised )
		{
			speed = 0.75;
			self rotatePitch( -90, speed, 0.25, 0.25 );
			wait ( 0.75 );
			self.raised = false;
			self.cause = "lower";

			if ( self.laneID == 4 )
				self disableAimAssist();

		}
		break;
	}
}

lowerTargetDummies( group, laneID, dummyID )
{
	targetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );
		
	for ( index = 0; index < targetDummies.size; index++ )
	{
		targetDummy = targetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;

		if ( !targetDummy.raised )
			continue;
			
		targetDummies[index] thread moveTargetDummy( "lower" );
	}
}


training_targetDummies( group )
{
	targetDummies = getTargetDummies( group );
	for ( index = 0; index < targetDummies.size; index++ )
		targetDummies[index] thread targetDummyThink();
}


targetDummyThink()
{
	orgEnt = getEnt( self.target, "targetname" );
	if ( !isDefined( orgEnt ) )
		return;
			
	self.origin = orgEnt.origin;
	self.angles = orgEnt.angles;

	self.modelEnt = orgEnt;
	self.modelEnt linkTo( self );
	self.modelEnt.health = 1000;
	
	self.dummyID = int( self.script_label );
	self.laneID = int( self.targetname[4] );
	
	self rotatePitch( -90, 0.25 );
	self.raised = false;
	self.moving = false;
	self.cause = "";
	self hide();
	
	for( ;; )
	{
		self.modelEnt waittill ( "damage", amount, attacker, direction_vec, point, cause );
		self.modelEnt.health = 1000;

		if ( self.laneID == 4 )
		{
			if ( cause == "MOD_PISTOL_BULLET" )
				level.player playSound( "bullet_small_metal" );
			else
				level.player playSound( "bullet_large_metal" );
		}

		self.moving = true;
		self.cause = cause;
		self disableAimAssist();
		self.modelEnt setCanDamage( false );
		self rotatePitch( -90, 0.25 );
		wait ( 0.25 );
		self.raised = false;
		self.moving = false;
	}
}

getTargetDummies( group, laneID, dummyID )
{
	groupTargetDummies = getEntArray( group + "_target_dummy", "script_noteworthy" );
	
	targetDummies = [];
	for ( index = 0; index < groupTargetDummies.size; index++ )
	{
		targetDummy = groupTargetDummies[index];
		if ( isDefined( dummyID ) && targetDummy.dummyID != dummyID )
			continue;

		if ( isDefined( laneID ) && targetDummy.laneID != laneID )
			continue;
		
		targetDummies[targetDummies.size] = targetDummy;
	}
	
	if ( isDefined( laneID ) && isDefined( dummyID ) )
	{
		assert( targetDummies.size == 1 );
	}
	return targetDummies;
}


ammoRespawnThink( ammoItem )
{
	ammoItem = self;
	ammoItem hide();
	ammoItemClass = ammoItem.classname;
	ammoItemOrigin = ammoItem.origin;

	if ( isDefined( ammoItem.target ) )
		ammoItemModels = getEntArray( ammoItem.target, "targetname" );
	else
		ammoItemModels = [];
	
	for ( ;; )
	{
		while( isDefined( ammoItem ) )
			wait ( 0.05 );
			
		for ( index = 0; index < ammoItemModels.size; index++ )
			ammoItemModels[index] hide();

		while( !isDefined( ammoItem ) )
		{
			wait ( 1.0 );

			if ( distance( level.player.origin, ammoItemOrigin ) < 256 )
				continue;

			if ( level.player pointInFov( ammoItemOrigin ) )
				continue;
				
			ammoItem = spawn( ammoItemClass, ammoItemOrigin );
			ammoItem hide();
	
			for ( index = 0; index < ammoItemModels.size; index++ )
				ammoItemModels[index] show();
		}
	}
}


pointInFov( origin )
{
    forward = anglesToForward( self.angles );
    return ( vectorDot( forward, origin - self.origin ) > 0.766 ); // 80 fov	
}


registerObjective( objName, objText, objEntity )
{
	flag_init( objName );
	objID = level.objectives.size;

	newObjective = spawnStruct();
	newObjective.name = objName;
	newObjective.id = objID;
	newObjective.state = "invisible";
	newObjective.text = objText;
	newObjective.entity = objEntity;
	newObjective.added = false;

	level.objectives[objName] = newObjective;	
	
	return newObjective;
}


setObjectiveState( objName, objState )
{
	assert( isDefined( level.objectives[objName] ) );
	
	objective = level.objectives[objName];
	objective.state = objState;
	
	if ( !objective.added )
	{
		objective_add( objective.id, objective.state, objective.text, objective.entity.origin );
		objective.added = true;
	}
	else
	{
		objective_state( objective.id, objective.State );
	}	

	if ( objective.state == "done" )
		flag_set( objName );
}


setObjectiveString( objName, objString )
{
	objective = level.objectives[objName];
	objective.text = objString;
	
	objective_string( objective.id, objString );
}

setObjectiveLocation( objName, objLoc )
{
	objective = level.objectives[objName];
	objective.loc = objLoc;
	
	objective_position( objective.id, objective.loc.origin );
}

setObjectiveRemaining( objName, objString, objRemaining )
{
	assert( isDefined( level.objectives[objName] ) );
	
	objective = level.objectives[objName];
	
	if ( !objRemaining )
		objective_string( objective.id, objString );
	else
		objective_string( objective.id, objString, objRemaining );
}


printAboveHead (string, duration, offset, color)
{
	self endon ("death");
	
	if (!isdefined (offset))
		offset = (0, 0, 0);
	if (!isdefined (color))
		color = (1,0,0);
		
	for(i = 0; i < (duration * 20); i++)
	{
		if (!isalive (self))
			return;
			
		aboveHead = self getshootatpos() + (0,0,10) + offset;
		print3d (aboveHead, string, color, 1, 0.5);	// origin, text, RGB, alpha, scale
		wait (0.05);
	}	
}


registerActions()
{
	level.actionBinds = [];
	registerActionBinding( "objectives",		"toggle cl_paused",		&"TRAINING_HINT_CHECK_OBJECTIVES_PAUSED" );
	registerActionBinding( "objectives",		"+scores",				&"TRAINING_HINT_CHECK_OBJECTIVES_SCORES" );

	registerActionBinding( "attack", 			"+attack",				&"TRAINING_HINT_ATTACK" );

	registerActionBinding( "ads",				"+speed",				&"TRAINING_HINT_ADS" );
	registerActionBinding( "ads",				"toggleads",			&"TRAINING_HINT_ADS_TOGGLE" );
	registerActionBinding( "ads_switch",		"+speed",				&"TRAINING_HINT_ADS_SWITCH" );

	registerActionBinding( "breath",			"+melee_breath",		&"TRAINING_HINT_BREATH_MELEE" );
	registerActionBinding( "breath",			"+breath_sprint",		&"TRAINING_HINT_BREATH_SPRINT" );
	registerActionBinding( "breath",			"+holdbreath",			&"TRAINING_HINT_BREATH" );

	registerActionBinding( "melee",				"+melee_breath",		&"TRAINING_HINT_MELEE_BREATH" );
	registerActionBinding( "melee",				"+melee",				&"TRAINING_HINT_MELEE" );

	registerActionBinding( "prone",				"+stance",				&"TRAINING_HINT_PRONE_STANCE" );
	registerActionBinding( "prone",				"goprone",				&"TRAINING_HINT_PRONE" );
	registerActionBinding( "prone",				"toggleprone",			&"TRAINING_HINT_PRONE_TOGGLE" );
	registerActionBinding( "prone",				"+prone",				&"TRAINING_HINT_PRONE_HOLD" );
	registerActionBinding( "prone",				"lowerstance",			&"TRAINING_HINT_PRONE_DOUBLE" );
//	registerActionBinding( "prone",				"+movedown",			&"" );

	registerActionBinding( "crouch",			"+stance",				&"TRAINING_HINT_CROUCH_STANCE" );
	registerActionBinding( "crouch",			"gocrouch",				&"TRAINING_HINT_CROUCH" );
	registerActionBinding( "crouch",			"togglecrouch",			&"TRAINING_HINT_CROUCH_TOGGLE" );
//	registerActionBinding( "crouch",			"lowerstance",			&"TRAINING_HINT_CROUCH_DOU" );
//	registerActionBinding( "crouch",			"+movedown",			&"TRAINING_HINT_CROUCH" );

	registerActionBinding( "stand",				"+gostand",				&"TRAINING_HINT_STAND" );
	registerActionBinding( "stand",				"+stance",				&"TRAINING_HINT_STAND_STANCE" );

	registerActionBinding( "jump",				"+gostand",				&"TRAINING_HINT_JUMP_STAND" );
	registerActionBinding( "jump",				"+moveup",				&"TRAINING_HINT_JUMP" );

	registerActionBinding( "sprint",			"+breath_sprint",		&"TRAINING_HINT_SPRINT_BREATH" );
	registerActionBinding( "sprint",			"+sprint",				&"TRAINING_HINT_SPRINT" );

	registerActionBinding( "sprint2",			"+breath_sprint",		&"TRAINING_HINT_HOLDING_SPRINT_BREATH" );
	registerActionBinding( "sprint2",			"+sprint",				&"TRAINING_HINT_HOLDING_SPRINT" );

	registerActionBinding( "reload",			"+usereload",			&"TRAINING_HINT_RELOAD_USE" );
	registerActionBinding( "reload",			"+reload",				&"TRAINING_HINT_RELOAD" );
	
	registerActionBinding( "mantle",			"+gostand",				&"TRAINING_HINT_MANTLE" );

	registerActionBinding( "sidearm",			"weapnext",				&"TRAINING_HINT_SIDEARM_SWAP" );
	registerActionBinding( "sidearm",			"weaponslot primaryb",	&"TRAINING_HINT_SIDEARM" );

	registerActionBinding( "primary",			"weapnext",				&"TRAINING_HINT_PRIMARY_SWAP" );

	registerActionBinding( "frag",				"+frag",				&"TRAINING_HINT_FRAG" );

	registerActionBinding( "swap_launcher",		"+activate",			&"TRAINING_HINT_SWAP" );
	registerActionBinding( "swap_launcher",		"+usereload",			&"TRAINING_HINT_SWAP_RELOAD" );

	registerActionBinding( "firemode",			"weapnext",				&"TRAINING_HINT_FIREMODE" );

	registerActionBinding( "attack_launcher", 	"+attack",				&"TRAINING_HINT_LAUNCHER_ATTACK" );

	registerActionBinding( "swap_explosives",	"+activate",			&"TRAINING_HINT_EXPLOSIVES" );
	registerActionBinding( "swap_explosives",	"+usereload",			&"TRAINING_HINT_EXPLOSIVES_RELOAD" );

	registerActionBinding( "plant_explosives",	"+activate",			&"TRAINING_HINT_EXPLOSIVES_PLANT" );
	registerActionBinding( "plant_explosives",	"+usereload",			&"TRAINING_HINT_EXPLOSIVES_PLANT_RELOAD" );
	
	initKeys();
	updateKeysForBindings();
}


registerActionBinding( action, binding, hint )
{
	if ( !isDefined( level.actionBinds[action] ) )
		level.actionBinds[action] = [];

	actionBind = spawnStruct();
	actionBind.binding = binding;
	actionBind.hint = hint;

	actionBind.keyText = undefined;
	actionBind.hintText = undefined;
	
	precacheString( hint );

	level.actionBinds[action][level.actionBinds[action].size] = actionBind;
}


getActionBind( action )
{
	for ( index = 0; index < level.actionBinds[action].size; index++ )
	{
		actionBind = level.actionBinds[action][index];
		
		binding = getKeyBinding( actionBind.binding );
		if ( !binding["count"] )
			continue;
		
		return level.actionBinds[action][index];
	}
	
	return undefined;
}


updateKeysForBindings()
{
	if ( level.xenon )
	{
		setKeyForBinding( getCommandFromKey( "BUTTON_START" ), "BUTTON_START" );
		setKeyForBinding( getCommandFromKey( "BUTTON_A" ), "BUTTON_A" );
		setKeyForBinding( getCommandFromKey( "BUTTON_B" ), "BUTTON_B" );
		setKeyForBinding( getCommandFromKey( "BUTTON_X" ), "BUTTON_X" );
		setKeyForBinding( getCommandFromKey( "BUTTON_Y" ), "BUTTON_Y" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSTICK" ), "BUTTON_LSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSTICK" ), "BUTTON_RSTICK" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LSHLDR" ), "BUTTON_LSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RSHLDR" ), "BUTTON_RSHLDR" );
		setKeyForBinding( getCommandFromKey( "BUTTON_LTRIG" ), "BUTTON_LTRIG" );
		setKeyForBinding( getCommandFromKey( "BUTTON_RTRIG" ), "BUTTON_RTRIG" );
	}
	else
	{
		//level.kbKeys = "1234567890-=QWERTYUIOP[]ASDFGHJKL;'ZXCVBNM,./";
		//level.specialKeys = [];
		
		for ( index = 0; index < level.kbKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.kbKeys[index] ), level.kbKeys[index] );
		}

		for ( index = 0; index < level.specialKeys.size; index++ )
		{
			setKeyForBinding( getCommandFromKey( level.specialKeys[index] ), level.specialKeys[index] );
		}
		
	}
}


getActionForBinding( binding )
{
	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;
				
			return arrayKeys[index];
		}
	}
}

setKeyForBinding( binding, key )
{
	if ( binding == "" )
		return;
		
	arrayKeys = getArrayKeys( level.actionBinds );
	for ( index = 0; index < arrayKeys.size; index++ )
	{
		bindArray = level.actionBinds[arrayKeys[index]];
		for ( bindIndex = 0; bindIndex < bindArray.size; bindIndex++ )
		{
			if ( bindArray[bindIndex].binding != binding )
				continue;
				
			bindArray[bindIndex].key = key;
		}
	}
}


hint( text, timeOut )
{
	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
		
	level.hintElem = createFontString( "default", 2.0 );
	level.hintElem setPoint( "TOP", undefined, 0, 30 );

	level.hintElem setText( text );	
	level.hintElem endon ( "death" );

	if ( isDefined( timeOut ) )
		wait ( timeOut );
	else
		return;

	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;
	wait ( 0.5 );

	level.hintElem destroyElem();
}


keyHint( text, key, timeOut )
{
	assert( isDefined( key ) );

	if ( isDefined( level.hintElem ) )
		level.hintElem destroyElem();
		
	level.hintElem = createFontString( "default", 2.0 );
	level.hintElem setPoint( "TOP", undefined, 0, 30 );

	level.hintElem setText( text );	
	level.hintElem endon ( "death" );

	if ( isDefined( timeOut ) )
	{
		level.player thread waitForButtonOrTimeout( "got_button_" + key, key, timeOut );
		level.player waittill( "got_button_" + key );
	}
	else
	{
		level.player waittillmatch("pressed_button", key);
	}
	
	level.hintElem fadeOverTime( 0.5 );
	level.hintElem.alpha = 0;

	wait ( 0.5 );

	level.hintElem destroyElem();
}

waitForButtonOrTimeout( finishedNotify, key, timeOut )
{
	self thread notifyOnTimeout( finishedNotify, timeOut );
	self endon( finishedNotify );
	self waittillmatch( "pressed_button", key );
	self notify( finishedNotify );
}
notifyOnTimeout( finishedNotify, timeOut )
{
	self endon( finishedNotify );
	wait timeOut;
	self notify( finishedNotify );
}


training_stallTriggers( group, endonString )
{
	stallTriggers = getEntArray( group + "_stall_trigger", "script_noteworthy" );
	
	for ( index = 0; index < stallTriggers.size; index++ )
		stallTriggers[index] thread stallTriggerThink( group );

	thread wrongStallNag( endonString );
}


wrongStallNag( endonString )
{
	level endon ( endonString );
	for( ;; )
	{
		level waittill ( "player_wrong_stall", stallString );
		
		level.marine2 anim_single_solo( level.marine2, "gotofour" );

		wait ( 10.0 );
	}
}


stallTriggerThink( group )
{
	for ( ;; )
	{
		self waittill ( "trigger", entity );
		
		if ( entity != level.player )
			continue;
		
		if ( self.targetname != "stall4" )
			level notify ( "player_wrong_stall", self.targetname );
		else
			flag_set( group + "_player_at_stall" );
	}
}

initKeys()
{
	level.kbKeys = "1234567890-=qwertyuiop[]asdfghjkl;'zxcvbnm,./";
	
	level.specialKeys = [];
	
	level.specialKeys[level.specialKeys.size] = "TAB";
	level.specialKeys[level.specialKeys.size] = "ENTER";
	level.specialKeys[level.specialKeys.size] = "ESCAPE";
	level.specialKeys[level.specialKeys.size] = "SPACE";
	level.specialKeys[level.specialKeys.size] = "BACKSPACE";
	level.specialKeys[level.specialKeys.size] = "UPARROW";
	level.specialKeys[level.specialKeys.size] = "DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "ALT";
	level.specialKeys[level.specialKeys.size] = "CTRL";
	level.specialKeys[level.specialKeys.size] = "SHIFT";
	level.specialKeys[level.specialKeys.size] = "CAPSLOCK";
	level.specialKeys[level.specialKeys.size] = "F1";
	level.specialKeys[level.specialKeys.size] = "F2";
	level.specialKeys[level.specialKeys.size] = "F3";
	level.specialKeys[level.specialKeys.size] = "F4";
	level.specialKeys[level.specialKeys.size] = "F5";
	level.specialKeys[level.specialKeys.size] = "F6";
	level.specialKeys[level.specialKeys.size] = "F7";
	level.specialKeys[level.specialKeys.size] = "F8";
	level.specialKeys[level.specialKeys.size] = "F9";
	level.specialKeys[level.specialKeys.size] = "F10";
	level.specialKeys[level.specialKeys.size] = "F11";
	level.specialKeys[level.specialKeys.size] = "F12";
	level.specialKeys[level.specialKeys.size] = "INS";
	level.specialKeys[level.specialKeys.size] = "DEL";
	level.specialKeys[level.specialKeys.size] = "PGDN";
	level.specialKeys[level.specialKeys.size] = "PGUP";
	level.specialKeys[level.specialKeys.size] = "HOME";
	level.specialKeys[level.specialKeys.size] = "END";
	level.specialKeys[level.specialKeys.size] = "MOUSE1";
	level.specialKeys[level.specialKeys.size] = "MOUSE2";
	level.specialKeys[level.specialKeys.size] = "MOUSE3";
	level.specialKeys[level.specialKeys.size] = "MOUSE4";
	level.specialKeys[level.specialKeys.size] = "MOUSE5";
	level.specialKeys[level.specialKeys.size] = "MWHEELUP";
	level.specialKeys[level.specialKeys.size] = "MWHEELDOWN";
	level.specialKeys[level.specialKeys.size] = "AUX1";
	level.specialKeys[level.specialKeys.size] = "AUX2";
	level.specialKeys[level.specialKeys.size] = "AUX3";
	level.specialKeys[level.specialKeys.size] = "AUX4";
	level.specialKeys[level.specialKeys.size] = "AUX5";
	level.specialKeys[level.specialKeys.size] = "AUX6";
	level.specialKeys[level.specialKeys.size] = "AUX7";
	level.specialKeys[level.specialKeys.size] = "AUX8";
	level.specialKeys[level.specialKeys.size] = "AUX9";
	level.specialKeys[level.specialKeys.size] = "AUX10";
	level.specialKeys[level.specialKeys.size] = "AUX11";
	level.specialKeys[level.specialKeys.size] = "AUX12";
	level.specialKeys[level.specialKeys.size] = "AUX13";
	level.specialKeys[level.specialKeys.size] = "AUX14";
	level.specialKeys[level.specialKeys.size] = "AUX15";
	level.specialKeys[level.specialKeys.size] = "AUX16";
	level.specialKeys[level.specialKeys.size] = "KP_HOME";
	level.specialKeys[level.specialKeys.size] = "KP_UPARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGUP";
	level.specialKeys[level.specialKeys.size] = "KP_LEFTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_5";
	level.specialKeys[level.specialKeys.size] = "KP_RIGHTARROW";
	level.specialKeys[level.specialKeys.size] = "KP_END";
	level.specialKeys[level.specialKeys.size] = "KP_DOWNARROW";
	level.specialKeys[level.specialKeys.size] = "KP_PGDN";
	level.specialKeys[level.specialKeys.size] = "KP_ENTER";
	level.specialKeys[level.specialKeys.size] = "KP_INS";
	level.specialKeys[level.specialKeys.size] = "KP_DEL";
	level.specialKeys[level.specialKeys.size] = "KP_SLASH";
	level.specialKeys[level.specialKeys.size] = "KP_MINUS";
	level.specialKeys[level.specialKeys.size] = "KP_PLUS";
	level.specialKeys[level.specialKeys.size] = "KP_NUMLOCK";
	level.specialKeys[level.specialKeys.size] = "KP_STAR";
	level.specialKeys[level.specialKeys.size] = "KP_EQUALS";
	level.specialKeys[level.specialKeys.size] = "PAUSE";
	level.specialKeys[level.specialKeys.size] = "SEMICOLON";
	level.specialKeys[level.specialKeys.size] = "COMMAND";
	level.specialKeys[level.specialKeys.size] = "181";
	level.specialKeys[level.specialKeys.size] = "191";
	level.specialKeys[level.specialKeys.size] = "223";
	level.specialKeys[level.specialKeys.size] = "224";
	level.specialKeys[level.specialKeys.size] = "225";
	level.specialKeys[level.specialKeys.size] = "228";
	level.specialKeys[level.specialKeys.size] = "229";
	level.specialKeys[level.specialKeys.size] = "230";
	level.specialKeys[level.specialKeys.size] = "231";
	level.specialKeys[level.specialKeys.size] = "232";
	level.specialKeys[level.specialKeys.size] = "233";
	level.specialKeys[level.specialKeys.size] = "236";
	level.specialKeys[level.specialKeys.size] = "241";
	level.specialKeys[level.specialKeys.size] = "242";
	level.specialKeys[level.specialKeys.size] = "243";
	level.specialKeys[level.specialKeys.size] = "246";
	level.specialKeys[level.specialKeys.size] = "248";
	level.specialKeys[level.specialKeys.size] = "249";
	level.specialKeys[level.specialKeys.size] = "250";
	level.specialKeys[level.specialKeys.size] = "252";
}