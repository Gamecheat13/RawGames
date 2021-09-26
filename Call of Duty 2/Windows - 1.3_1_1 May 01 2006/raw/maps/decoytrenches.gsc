/*
TODO:
 / add rest of emplacement objectives
 / tie rest of emppacement objectives in to removal of trench blocker
 / better cover/geometry outside of the exit from the trenches
 - better friendly chains outside of the exit from the trenches
 - delete one of the two roof guys at emplacement three
 - force remaining roof guy at emplacement three to fire mg42
 / add friendly assault visuals outside of playable area
 - more/better cover at ammo depot upon exiting 
*/

#include maps\_utility;
#include maps\_anim;

main()
{
	level thread maps\decoytrenches_amb::main();

	maps\_panzer2::main( "xmodel/vehicle_panzer_ii" );
	maps\_flak88::main( "xmodel/german_artillery_flak88" );
	maps\_truck::main( "xmodel/vehicle_opel_blitz_desert" );
	maps\_tankai::main();
	maps\_tankai_crusader::main("xmodel/vehicle_crusader2");
	maps\decoytrenches_fx::main();
	
	// hack
	spawners = getEntArray( "bunker two ai", "script_noteworthy" );
	for ( index = 0; index < spawners.size; index++ )
	{
		if ( !isDefined( spawners[index].script_aigroup ) )
			spawners[index].script_aigroup = "emplacement3";
	}
	// end hack
	
	maps\_load::main();
	maps\decoytrenches_anim::main();
//	setEnvironment( "cold" );
	
	precacheShader( "hudStopwatch" );
	precacheShader( "hudStopwatchNeedle" );
	precacheShader( "inventory_tnt_large" );
	precacheShader( "inventory_docs" );
	precacheModel( "xmodel/prop_door_metal_bunker_damaged" );
	precacheModel( "xmodel/military_tntbomb" );
	precacheModel( "xmodel/military_tntbomb_obj" );
	precacheString( &"DECOYTRENCHES_HINT_NONLINEAR1" );
	level.smoke_grenade_weapon = "smoke_grenade_american_night";

	level.timersused = 0;

	level.flag["combat start"] = false;
	level.flag["documents recovered"] = false;
	level.flag["emplacement 1 cleared"] = false;
	level.flag["emplacement 2 cleared"] = false;
	level.flag["emplacement 3 cleared"] = false;
	level.flag["emplacements cleared"] = false;
	level.flag["depot reached"] = false;
	level.flag["stockpiles destroyed"] = false;
	level.flag["bunker destroyed"] = false;
	level.flag["fuel caches destroyed"] = false;
	level.flag["objectives completed"] = false;
	level.flag["arrived at BCV"] = false;
	level.flag["bunker one passed"] = false;
	level.flag["price_arrival_music"] = false;

	level.inv_tnt = maps\_inventory::inventory_create( "inventory_tnt_large", true );

	level.player.ignoreme = true;
//	DialogTestThread();
	thread Setup_Soldiers();
	
	thread Trigger_CombatStart();
	thread Trigger_CombatStartDamage();
	thread Trigger_SmokeThrow();
	thread Trigger_BunkerAI();
	thread Trigger_ReinforcementArrival();
	thread Trigger_IgnoreMe();
	thread Trigger_DepotReached();
	thread Trigger_BunkerDoor();
	thread Trigger_EmplacementThree();
	thread Trigger_BunkerGrenades();
	thread Trigger_DepotApproach();
	thread Trigger_TrenchGrenades();
	thread Trigger_NoSightController();
	
	array_thread( getEntArray( "distraction", "script_noteworthy" ),  ::AI_NoCompass );
	array_thread( getEntArray( "runner", "script_noteworthy" ),  ::AI_RunnerSetup );
	array_thread( getEntArray( "intro soldier", "targetname" ), ::AI_IntroThink );
	array_thread( getEntArray( "intro runner", "targetname" ), ::AI_IntroRunnerThink );
//	array_thread( getEntArray( "emplacement two ai", "script_noteworthy" ), ::EmplacemtSpawner_Think );
//	array_thread( getEntArray( "bunker two spawner", "targetname" ), ::EmplacemtSpawner_Think );
	array_thread( getEntArray( "trigger_endchain", "targetname" ),  ::Trigger_EndChain );
	chain_off( "postemplacement_chain" );
	
	array_thread( getEntArray( "delete_by_spawnflags", "script_noteworthy" ),  ::DeleteBySpawnFlags );
	
	thread AI_NoCompass();
	thread OpelBlitz_Thread();
	thread EndTrench_Thread();
	thread Emplacement_Save();
	thread FuelCache_Save();
	thread Depot_Thread();
	thread maps\decoytrenches_obj::Objectives();

	thread Intro();
	thread Exit_Blocker();
	thread Trench_Blocker();
	thread Outro();
	
	thread music();	
}


DeleteBySpawnFlags()
{
	if ( !isDefined( self.spawnflags ) )
		return;
		
	if ( self.spawnflags & 256 && level.gameSkill == 0)
		self delete();
	else if ( self.spawnflags & 512 && level.gameSkill == 1)
		self delete();
	else if ( self.spawnflags & 1024 && level.gameSkill == 2)
		self delete();
	else if ( self.spawnflags & 2048 && level.gameSkill == 3)
		self delete();
}

DialogTestThread()
{
	level.maxfriendlies = 0;
	soldiers = getAIArray();
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] delete();
	
	priceSpawner = getEnt( "price", "targetname" );
	level.price = priceSpawner stalingradspawn();
	spawn_failed( level.price );
	assert( isDefined( level.price ) );
	level.price thread maps\_utility::magic_bullet_shield();
	level.price.animname = "price";
	
	macGregorSpawner = getEnt( "macgregor", "targetname" );
	level.macgregor = macGregorSpawner stalingradspawn();
	spawn_failed( level.macgregor );
	assert( isDefined( level.macgregor ) );
	level.macgregor thread maps\_utility::magic_bullet_shield();
	level.macgregor.animname = "macgregor";

	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( soldiers[index] == level.price || soldiers[index] == level.macgregor )
			continue;

		soldiers[index] delete();
	}
	
	level.price.goalradius = 32;
	level.price setGoalNode( getNode( "node_priceOutro", "targetname" ) );
	level.price.grenadeAwareness = 0;
	
	level.macgregor.goalradius = 32;
	level.macgregor setGoalNode( getNode( "node_macgregorOutro", "targetname" ) );
	level.macgregor.grenadeAwareness = 0;

	level.soldier1 = getEnt ( "soldier1", "targetname" ) stalingradspawn();
	spawn_failed( level.soldier1 );
	level.soldier1.animname = "soldier1";
	level.soldier1.goalradius = 32;
	level.soldier1 thread magic_bullet_shield();
	level.soldier1.grenadeAwareness = 0;
	
	level.price waittill( "goal" );
//	getEnt( "rally point radius", "targetname" ) waittill ( "trigger" );
	
	Dialog_Outro();
	level waittill ( "hell freezes over" );
}

Setup_Soldiers()
{
	level.maxfriendlies = 0;
	level.friendlywave_thread = ::Friendly_Chain;

	allies = getAIArray( "allies" );
	for ( index = 0; index < allies.size; index++ )
	{
		allies[index] allowedStances( "crouch" );
		allies[index].dontavoidplayer = true;
		allies[index].ignoreme = true;
		
		allies[index] setGoalPos( allies[index].origin );
		
		if ( isDefined( allies[index].script_noteworthy ) && allies[index].script_noteworthy == "distraction" )
			continue;
	}


	level.soldier4 = getEnt( "soldier4intro", "targetname" );
	level.soldier4.animname = "soldier4";

	axis = getAIArray( "axis" );
	for ( index = 0; index < axis.size; index++ )
	{
		axis[index].ignoreme = true;
	}
	
	flag_wait( "objectives completed" );
}


Friendly_Chain( soldier )
{
	soldier setGoalEntity( level.player );
	
	if ( isDefined( soldier.script_noteworthy ) && soldier.script_noteworthy == "soldier4" )
	{
		level.soldier4 = soldier;
		soldier.animname = "soldier4";
	}
}


AI_RunnerSetup()
{
	while ( true )
	{
		self waittill ( "spawned", soldier );
		
		if ( spawn_failed( soldier ) )
			continue;
			
		soldier thread AI_RunnerThink();
	}
}


AI_FlankerSetup( side )
{
	while ( true )
	{
		self waittill ( "spawned", soldier );
		
		if ( spawn_failed( soldier ) )
			continue;
			
		soldier thread AI_FlankerThink( side );
	}
}


AI_FlankerThink( side )
{
	self endon ( "death" );
	
	self.maxdist = 10;
	self.fightdist = 10;
	self set_forcegoal();
	self clearEnemyPassThrough();
	
	self waittill ( "goal" );
	level notify ( "flanker", side );
	self unset_forcegoal();
}


AI_RunnerThink()
{
	self endon ( "death" );
	
	if ( !flag( "combat start" ) )
		self.ignoreme = true;
		
	self.goalradius = 32;
	self.health = 1;
	
	self set_forcegoal();
	self.maxSightDistSqrd = 0;
	self.fightdist = 0;
	self.maxdist = 0;
	self.interval = 0;
	self clearEnemyPassThrough();
	
	self waittill ( "goal" );
	self delete();
}


AI_IntroThink()
{
	level waittill ( "starting final intro screen fadeout" );
	
	self set_forcegoal();
	self clearEnemyPassThrough();
	self setGoalNode( getNode( self.target, "targetname" ) );
	
	self waittill ( "goal" );
	self unset_forcegoal();
}


AI_IntroRunnerThink()
{
	level waittill ( "starting final intro screen fadeout" );
	wait ( 2.0 );
	
	self setGoalNode( getNode( self.target, "targetname" ) );
	
	self thread AI_RunnerThink();
}

Intro()
{
//	level.player takeAllWeapons();
//	level.player giveWeapon( "binoculars" );
	getEnt( "intro clip", "targetname" ) delete();

	tanks = maps\_vehicle::scripted_spawn(0);
	
	battleChatterOff( "allies" );

	thread Intro_GermanChatter();

	for ( index = 1; index < 5; index++ )
	{
		getEnt( "tank" + index, "script_noteworthy" ) thread Tank_Thread();
		wait ( randomfloatrange( 0.25, 1.0 ) );
	}

	getEnt( "trigger_introSpawner", "script_noteworthy" ) notify ( "trigger" );
	
	level Dialog_Intro();
	
//	getEnt( "intro clip", "targetname" ) delete();
	
	allies = getAIArray( "allies" );
	for ( index = 0; index < allies.size; index++ )
	{
		if ( isDefined( allies[index].script_noteworthy ) && allies[index].script_noteworthy == "distraction" )
			continue;
		
		allies[index] allowedStances( "crouch", "stand", "prone" );
		allies[index].dontavoidplayer = false;
		
		goalNode = getNode( allies[index].target, "targetname" );
		allies[index] setGoalNode( goalNode );
		allies[index].goalradius = 64;
		allies[index].fightdist = 0;
		allies[index].maxdist = 0;
	}

	thread CombatStart();
}


Intro_GermanChatter()
{
	
	// (9801,-13054,-222)
	thread playSoundInSpace( "GE_1_threat_infantry_many", (6833,-12810,-285) );
	wait ( 2.0 );
	thread playSoundInSpace( "GE_0_threat_infantry_exposed", (7288,-12306,-112) );
	wait ( 3.5 );
	thread playSoundInSpace( "GE_0_threat_vehicle_brencarrier", (6833,-12810,-285) );
	wait ( 3.5 );
	thread playSoundInSpace( "GE_1_order_attack_infantry", (7288,-12306,-112) );
	wait ( 3.5 );
	thread playSoundInSpace( "GE_0_order_attack_infantry", (6833,-12810,-285) );
}


EmplacemtSpawner_Think()
{
	self endon ( "death" );
	while ( !flag( "bunker one passed" ) && self.count )
	{
		soldier = self doSpawn();
		
		if ( !spawn_failed ( soldier ) )
			soldier waittill ( "death" );
		
		wait ( randomFloatRange( 6.0, 10.0 ) );
	}
}


Exit_Blocker()
{
	blockers = getEntArray( "exit blocker", "targetname" );
	
	for ( index = 0; index < blockers.size; index++ )
		blockers[index] hide();
		
	level waittill ( "combat start" );
	
	for ( index = 0; index < blockers.size; index++ )
		blockers[index] show();
}

AI_NoCompass()
{
	while ( true )
	{
		self waittill ( "spawned", soldier );
		self.count++;
		
		soldier.drawoncompass = false;
		soldier thread magic_bullet_shield();
		
		soldier waittill( "goal" );
		soldier notify ( "stop magic bullet shield" );
	}
}


Trench_Blocker()
{
	closedBlockers = getEntArray( "trench blocker", "targetname" );
	openBlockers = getEntArray( "trench blocker open", "targetname" );
	closedCollision = getEntArray( "trench blocker coll", "targetname" );
	openCollision = getEntArray( "trench blocker open coll", "targetname" );
	
	for ( index = 0; index < openBlockers.size; index++ )
	{
		openBlockers[index] hide();
	}
	
	for ( index = 0; index < closedBlockers.size; index++ )
	{
		closedBlockers[index] show();
	}
	
	for ( index = 0; index < openCollision.size; index++ )
		openCollision[index] notsolid();

	for ( index = 0; index < closedCollision.size; index++ )
		closedCollision[index] solid();
		
	flag_wait( "emplacements cleared" );

	playSoundInSpace( "GE_0_taunt", (7861,-13212,-195) );
	thread playSoundInSpace( "explo_metal_rand", (7740,-13150,-232) );	
	radiusDamage( (7736,-13107,-235), 128, 100, 25 ); 
	earthquake( 0.25, 3, (7740,-13150,-232), 1050 );
	exploder( 5 );
	wait ( 0.25 );

	//(7740 -13152 -232) // explosion
	chain_off( "emplacement chain" );
	chain_on( "postemplacement_chain" );
	
	level.player setFriendlyChain( getNode( "friendly chain trench two", "targetname" ) );

	entities = getEntArray( "distraction", "script_noteworthy" );
	for ( index = 0; index < entities.size; index++ )
	{
		if ( !isAlive( entities[index] ) )
			continue; 
		entities[index] setGoalPos( (4928,-9728,23) );
		entities[index].goalradius = 256;
		
	}

	thread Dialog_LinkUp();
		
	for ( index = 0; index < closedBlockers.size; index++ )
	{
		closedBlockers[index] hide();
	}

	for ( index = 0; index < openBlockers.size; index++ )
	{
		openBlockers[index] show();
	}

	for ( index = 0; index < openCollision.size; index++ )
	{
		openCollision[index] solid();
		openCollision[index] disconnectpaths();
	}

	for ( index = 0; index < closedCollision.size; index++ )
	{
		closedCollision[index] notsolid();
		closedCollision[index] connectpaths();
	}
}


CombatStart()
{
	flag_wait( "combat start" );
	level.player setFriendlyChain( getNode( "friendly chain start", "targetname" ) );
	level.maxfriendlies = 2;

//	autoSaveByName( "combat start" );

	allies = getAIArray( "allies" );
	for ( index = 0; index < allies.size; index++ )
	{
		if ( isDefined( allies[index].script_noteworthy ) && allies[index].script_noteworthy == "distraction" )
			continue;
			
		allies[index].ignoreme = false;
		allies[index].goalradius = 64;
		allies[index].fightdist = 0;
		allies[index].maxdist = 0;
		allies[index] setGoalEntity( level.player );
	}

	axis = getAIArray( "axis" );
	for ( index = 0; index < axis.size; index++ )
	{
		axis[index].ignoreme = false;
	}
		
	level.player.ignoreme = false;

	battleChatterOn( "allies" );
}


EndTrench_Thread()
{
	flag_wait( "objectives completed" );
	
	level.player setFriendlyChain( getNode( "end trench chain", "script_noteworthy" ) );	
}


Trigger_CombatStart()
{
	level endon ( "combat start" );
	
	getEnt( "trigger_combatstart", "script_noteworthy" ) waittill ( "trigger" );
	flag_set( "combat start" );
}


Trigger_CombatStartDamage()
{
	level endon ( "combat start" );

	getEnt( "trigger_combatstartdamage", "targetname" ) waittill ( "trigger", shooter );
	flag_set( "combat start" );
}


Trigger_TrenchGrenades()
{
	getEnt( "trigger_trenchGrenades", "script_noteworthy" ) waittill ( "trigger" );

	soldier = getClosest( (8653,-12681,-156), getaiarray() );
	
	thread playSoundInSpace( "GE_0_order_action_grenade", (8628,-12704,-160) );

	grenadeSrc = getEnt( "trenchGrenadeOrigin", "targetname" );
	
	grenadeTargets = getEntArray( grenadeSrc.target, "targetname" );
	for ( index = 0; index < grenadeTargets.size; index++ )
	{
		if ( !isAlive( soldier ) )
			continue;
			
		soldier magicGrenade( grenadeSrc.origin, grenadeTargets[index].origin );
		
		wait ( randomFloatRange( 0.5, 2.0 ) );
	}
}


Trigger_NoSightController()
{
	damageTrigger = getEnt( "trigger_noSightController", "targetname" );
	noSightBrushes = getEnt( damageTrigger.target, "targetname" );

	while ( !flag( "bunker one passed" ) )
	{
		damageTrigger waittill ( "trigger", shooter );
		
		if ( shooter != level.player )
			continue; 
			
		noSightBrushes triggerOff();
		wait ( 6.0 );
		noSightBrushes triggerOn();
	}
	
	noSightBrushes delete();
	damageTrigger delete();
}


Trigger_DepotApproach()
{
	getEnt( "trigger_depotapproach", "targetname" ) waittill ( "trigger" );
	
	thread Dialog_Greeting();
}


Trigger_DepotReached()
{
	getEnt( "trigger_depotreached", "targetname" ) waittill ( "trigger" );

//	thread Dialog_FuelDump();

	flag_set( "depot reached" );
		
	wait ( 15.0 );
	
	iPrintLnBold( &"DECOYTRENCHES_HINT_NONLINEAR1" );

	wait ( 45.0 );
	
	while ( !flag( "stockpiles destroyed" ) )
	{
		thread Dialog_AmmoHint();
		wait ( 60.0 );
	}

	while ( !flag( "fuel caches destroyed" ) )
	{
		thread Dialog_FuelHint();
		wait ( 20.0 );
	}
}


Trigger_AmmoBunkerEntrance()
{
	self waittill ( "trigger" );
	
	spawners = getEntArray( self.target, "targetname" );
	
	for ( index = 0; index < spawners.size; index++ )
	{
		soldier = spawners[index] doSpawn();
		spawn_failed( soldier );
	}
}


Trigger_EmplacementThree()
{
	trigger = getEnt( "emplacement three", "targetname" );
	trigger waittill ( "trigger" );

/*	
	entities = getEntArray( "bunker two ai", "script_noteworthy" );
	
	for ( index = 0; index < entities.size; index++ )
	{
		if ( !isAlive( entities[index] ) )
			continue;
			
		entities[index].goalradius = 100;
		entities[index] setGoalPos( (8843,-12488,-75) );
	}	
*/

	soldiers = getEntArray( "trench fodder", "script_noteworthy" );
	
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] delete();
}



Trigger_BunkerGrenades()
{
	level endon ( "emplacement 3 cleared" );
	getEnt( "trigger_emplacementRoof", "targetname" ) endon ( "trigger" );
	
	getEnt( "trigger_bunkerGrenades", "targetname" ) waittill ( "trigger" );
	
	soldier = getClosest( (8653,-12681,-156), getaiarray() );
	
	thread playSoundInSpace( "GE_0_order_action_grenade", (8628,-12704,-160) );

	for ( index = 0; index < 3; index++ )
	{
		if ( !isAlive( soldier ) )
			continue;
			
		grenadeSrc = (8628,-12704,-160);
		grenadeDest = grenadeSrc + ( randomIntRange( -20, 20 ), randomIntRange( -20, 20 ), -20 );
		soldier magicGrenade( grenadeSrc, grenadeDest );
		
		wait ( randomFloatRange( 0.5, 1.0 ) );
	}
}


Trigger_SmokeThrow()
{
	getEnt( "trigger_smokethrow", "script_noteworthy" ) waittill ( "trigger" );

	smokeOrigin = getEnt( "smokeOrigin", "targetname" );
	magicSmoke( smokeOrigin.origin );
}


Trigger_BunkerAI()
{
	getEnt( "bunker one enter", "script_noteworthy" ) waittill ( "trigger" );

	thread Dialog_Bunkers();
	
//	smokeOrigin = getEnt( "trenchSmokeOrigin", "targetname" );
	
//	magicSmoke( smokeOrigin.origin );
	
	getEnt( "bunker one exit", "script_noteworthy" ) waittill ( "trigger" );
	
	flag_set( "bunker one passed" );
	
	soldiers = getEntArray( "bunker one ai", "script_noteworthy" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( isSentient( soldiers[index] ) )
			soldiers[index] setGoalEntity( level.player );
	}
}


Trigger_ReinforcementArrival()
{
	getEnt( "trigger reinforcement arrival", "script_noteworthy" ) waittill ( "trigger" );

	level.player setFriendlyChain ( getNode( "depot chain", "script_noteworthy" ) );	
	level.maxfriendlies = 4;

	priceSpawner = getEnt( "price", "targetname" );
	level.price = priceSpawner dospawn();
	spawn_failed( level.price );
	assert( isDefined( level.price ) );
	level.price thread maps\_utility::magic_bullet_shield();
	level.price setGoalEntity( level.player );
	level.price.animname = "price";
	
	macGregorSpawner = getEnt( "macgregor", "targetname" );
	level.macgregor = macGregorSpawner dospawn();
	spawn_failed( level.macgregor );
	assert( isDefined( level.macgregor ) );
	level.macgregor thread maps\_utility::magic_bullet_shield();
	level.macgregor setGoalEntity( level.player );
	level.macgregor.animname = "macgregor";

	thread Dialog_Cover();

	flag_wait( "objectives completed" );
	/*
	level.soldier1 = level.macgregor; // temp
	*/
}


Trigger_IgnoreMe()
{
	trigger = getEnt( "ignoremetrigger", "targetname" );
	
	trigger waittill ( "trigger" );
	
	level.player.ignoreme = true;
	while ( level.player isTouching( trigger ) )
	{
		wait ( 1.0 );
	}
	
	level.player.ignoreme = false;	
}


Trigger_BunkerDoor()
{
	trigger = getEnt( "trigger_bunkerdoor", "targetname" );

	flag_wait( "objectives completed" );
	
	soldier3Spawners = getEntArray( "soldier3", "targetname" );
	level.soldier3 = undefined;
	soldier4Spawners = getEntArray( "soldier4", "targetname" );
	level.soldier4 = undefined;
	
	for ( index = 0; index < soldier3Spawners.size; index++ )
	{
		if ( isDefined( level.soldier3 ) )
			continue;
			
		soldier = soldier3Spawners[index] doSpawn();

		if ( spawn_failed( soldier ) )
			continue;
		
		soldier.animname = "soldier3";
		level.soldier3 = soldier;
		level.soldier3 thread Soldier_Think();
	}
	
	for ( index = 0; index < soldier4Spawners.size; index++ )
	{
		if ( isDefined( level.soldier4 ) )
			continue;
			
		soldier = soldier4Spawners[index] doSpawn();

		if ( spawn_failed( soldier ) )
			continue;
		
		soldier.animname = "soldier4";
		level.soldier4 = soldier;
		level.soldier4 thread Soldier_Think();
	}
	
	while ( !level.soldier3.atGoal || !level.soldier4.atGoal )
		wait ( 0.05 );
	
	trigger waittill ( "trigger" );	
	Dialog_OpenBunker();

	level.soldier3 BunkerDoor_Thread();
	level.soldier3.goalradius = 128;
}


Soldier_Think()
{
	self.atGoal = false;
	self.goalradius = 64;
	self.pathEnemyFightDist = 64;
	self.pathEnemyLookAhead = 64;
	self.ignoreme = true;
	self thread magic_bullet_shield();
	self setGoalNode( getNode( self.target, "targetname" ) );
	
	self waittill ( "goal" );
	self.atGoal = true;
}


Depot_Thread()
{
	flag_wait( "objectives completed" );
	
	trigger = getEnt( "trigger_depotradius", "targetname" );
	goalNode = getNode( "node_retreat", "targetname" );
	soldiers = getAIArray( "axis" );
	
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( !soldiers[index] isTouching( trigger ) )
			continue;
			
		soldiers[index].goalradius = goalNode.radius;
		soldiers[index] setGoalNode( goalNode );
		soldiers[index].health = 1;
	}
	
}


OpelBlitz_Thread()
{
	level waittill ( "new vehicle spawnedopel blitz", vehicle );

	vehicle waittill ( "reached_end_node" );
	
	wait ( 5.0 );
	getEnt( "trigger reinforcement arrival", "script_noteworthy" ) notify ( "trigger" );
}


Tank_Thread()
{
	level waittill ( "starting final intro screen fadeout" );
	thread maps\_vehicle::gopath( self );
	self startEngineSound();
	
	self waittill ( "reached_end_node" );
	self delete();
}


Emplacement_Save()
{
	saveCount = 0;
	while ( true )
	{
		level waittill ( "emplacement cleared" );
		autoSaveByName( "emplacement " + saveCount );
		saveCount++;
	}
}


FuelCache_Save()
{
	level waittill ( "fuel caches destroyed" );	
	thread autoSaveByName( "fuel cache" );
}


Trigger_EndChain()
{
	self waittill ( "trigger" );
	
	level.soldier3 setGoalNode( getNode( self.target, "targetname" ) );
}


BunkerDoor_Thread()
{
	bunkerDoorModel = getEnt( "ugbunkerdoor1", "script_noteworthy" );
	bunkerDoor =  getEnt( bunkerDoorModel.target, "targetname" );
	bunkerDoor disconnectPaths();
	goalNode = getNode( "ugbunkerdoornode", "targetname" );
	
	self.goalradius = 4;
	self setGoalNode( goalNode );
	self waittill ( "goal" );

	self thread BunkerDoor_NoteTracks();	
	self animScripted( "plantexplosives", goalNode.origin, (goalNode.angles), level.scr_anim["soldier3"]["plantbomb"] );
	self waittillmatch ( "plantexplosives", "end" );
	self setGoalNode( getNode( self.target, "targetname" ) );
	wait ( 5.0 );
	
	self.goalradius = 128;
	
	if ( isDefined( level.doorBomb ) )
		level.doorBomb delete();

	earthquake( 0.25, 3, bunkerDoor.origin, 1050 );
	bunkerDoor playSound ("explo_plant_rand");
	radiusDamage( (9650,-13738,-239), 128, 200, 100 ); 

	bunkerDoorModel linkTo ( bunkerDoor );
	bunkerDoorModel setModel( "xmodel/prop_door_metal_bunker_damaged" );
	bunkerDoorModel playSound( "explo_metal_rand" );
	exploder( 4 );	
	bunkerDoor rotateYaw( 89, 0.1, 0.05, 0.05 );
	wait ( 2.0 );
	bunkerDoor connectPaths();
	
	Dialog_CheckBunker();
	thread autoSaveByName( "bunker door" );	
}


BunkerDoor_NoteTracks()
{
	while ( true )
	{
		self waittill ( "plantexplosives", noteTrack );
		switch ( noteTrack )
		{
			case "pickup tnt":
				self attach( "xmodel/military_tntbomb", "tag_weapon_left" );
				break;
			case "give tnt":
				self detach( "xmodel/military_tntbomb", "tag_weapon_left" );
				origin = self getTagOrigin( "tag_weapon_left" );
				angles = self getTagAngles( "tag_weapon_left" );
				level.doorBomb = spawn( "script_model", origin );
				level.doorBomb.angles = angles;
				level.doorBomb setModel( "xmodel/military_tntbomb" );
				level thread playSoundinSpace( "detpack_plant", level.doorBomb.origin );
				break;
			case "end":
				return;
		}
	}	
}

BunkerDoor_NoteTracksOld()
{
	self attach( "xmodel/military_tntbomb", "tag_weapon_right" );
	while ( true )
	{
		self waittill ( "plantexplosives", noteTrack );
		switch ( noteTrack )
		{
			case "end":
			case "release bomb from hands":
				doNoteTracks = false;
				self detach( "xmodel/military_tntbomb", "tag_weapon_right" );
				origin = self getTagOrigin( "tag_weapon_right" );
				level.doorBomb = spawn( "script_model", origin );
				level.doorBomb setModel( "xmodel/military_tntbomb" );
				break;
		}
	}	
}

Outro()
{
	flag_wait ( "documents recovered" );

	thread autoSaveByName( "documents" );
	
	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( soldiers[index] == level.price || soldiers[index] == level.macgregor )
			continue;

		soldiers[index] delete();
	}

	getEnt( "trigger_trenchExit", "targetname" ) waittill ( "trigger" );
/*	
	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		if ( soldiers[index] == level.price || soldiers[index] == level.macgregor )
			continue;

		soldiers[index] delete();
	}
*/
	
	level.price.goalradius = 32;
	level.price setGoalNode( getNode( "node_priceOutro", "targetname" ) );
	level.price.grenadeAwareness = 0;
	
	level.macgregor.goalradius = 32;
	level.macgregor setGoalNode( getNode( "node_macgregorOutro", "targetname" ) );
	level.macgregor.grenadeAwareness = 0;

	level.soldier1 = getEnt ( "soldier1", "targetname" ) doSpawn();
	spawn_failed( level.soldier1 );
	level.soldier1.animname = "soldier1";
	level.soldier1.goalradius = 32;
	level.soldier1 thread magic_bullet_shield();
	level.soldier1.grenadeAwareness = 0;
	
	flag_wait ( "arrived at BCV" );
	
	Dialog_Outro();
	
	maps\_endmission::nextmission();
}



Dialog_Intro()
{
	level.soldier4 anim_single_solo( level.soldier4, "depot" );
	wait ( 1.0 );

	level.soldier4 allowedStances( "crouch", "stand", "prone" );
	level.soldier4.dontavoidplayer = false;
	
	goalNode = getNode( level.soldier4.target, "targetname" );
	level.soldier4 setGoalNode( goalNode );
	level.soldier4.goalradius = 64;
	level.soldier4.fightdist = 0;
	level.soldier4.maxdist = 0;

	level.soldier4.allowdeath = 1;
	level.soldier4 anim_single_solo( level.soldier4, "wipeout" );
	wait ( 1.0 );
}


Dialog_Bunkers()
{
	battleChatterOff( "allies" );
	while ( !isAlive( level.soldier4 ) )
		wait ( 0.05 );

	level.soldier4 anim_single_solo( level.soldier4, "clearthosebunkers" );
	battleChatterOn( "allies" );
}


Dialog_LinkUp()
{
	battleChatterOff( "allies" );
	while ( !isAlive( level.soldier4 ) )
		wait ( 0.05 );

	level.soldier4 anim_single_solo( level.soldier4, "linkup" );
	battleChatterOn( "allies" );
}


Dialog_Cover()
{
	battleChatterOff( "allies" );
	level.price anim_single_solo( level.price, "givedaviscover" );
	battleChatterOn( "allies" );
	
	flag_set("price_arrival_music");
}


Dialog_Greeting()
{
	flag_wait("price_arrival_music");

	level.price anim_single_solo( level.price, "goodtosee" );

	wait ( 8.0 );

	battleChatterOff( "allies" );
	level.price anim_single_solo( level.price, "ammodump" );
	level.macgregor anim_single_solo( level.macgregor, "ammodump" );
	battleChatterOn( "allies" );
}

/*
Dialog_FuelDump()
{
	level.price anim_single_solo( level.price, "ammodump" );
	level.macgregor anim_single_solo( level.macgregor, "ammodump" );
	battleChatterOn( "allies" );
}
*/

Dialog_FuelHint()
{
	level.price setBattleChatter( false );
	level.price anim_single_solo( level.price, "shootfuel" );
	level.price setBattleChatter( true );
}


Dialog_AmmoHint()
{
	level.price setBattleChatter( false );
	level.price anim_single_solo( level.price, "bunkers" );
	level.price setBattleChatter( true );
}


Dialog_Rally()
{
	level.price setBattleChatter( false );
	level.price anim_single_solo( level.price, "gotorally" );
	level.price setBattleChatter( true );
}


Dialog_OpenBunker()
{
	battleChatterOff( "allies" );
	level.soldier3 thread animscripts\shared::SetInCombat();
	level.soldier4 thread animscripts\shared::SetInCombat();
	level.soldier4 anim_single_solo( level.soldier4, "getbunkeropen" );
	level.soldier3 anim_single_solo( level.soldier3, "getbunkeropen" );
}


Dialog_CheckBunker()
{
	level.price thread animscripts\shared::SetInCombat();
	level.macgregor thread animscripts\shared::SetInCombat();

	level.price anim_single_solo( level.price, "checkbunker" );
	level.macgregor anim_single_solo( level.macgregor, "stupidmaps" );
	level.price anim_single_solo( level.price, "shutitmac" );
	level.macgregor anim_single_solo( level.macgregor, "but" );
	level.price anim_single_solo( level.price, "keepmouthshut" );
	battleChatterOn( "allies" );
}


Dialog_Outro()
{
	battleChatterOff( "allies" );
	priceGoal = getNode( "node_priceOutro", "targetname" );

	priceGoal thread anim_loop_solo( level.price, "idle", undefined, "stopidle" );
	level.soldier1 anim_single_solo( level.soldier1, "needintown" );
	priceGoal notify ( "stopidle" );
	priceGoal anim_reach_solo( level.price, "bloodyhardfight", undefined, priceGoal );
	level.price anim_single_solo( level.price, "bloodyhardfight" );
	priceGoal thread anim_loop_solo( level.price, "idle", undefined, "stopidle" );
	level.soldier1 anim_single_solo( level.soldier1, "yessir" );
	priceGoal notify ( "stopidle" );
	priceGoal anim_reach_solo( level.price, "getinbrencarrier", undefined, priceGoal );
	level.price anim_single_solo( level.price, "getinbrencarrier" );
}


magicSmoke( smokeOrigin )
{
	soldier = getClosest( smokeOrigin, getaiarray() );

	oldGrenadeWeapon = soldier.grenadeWeapon;
		
	soldier.grenadeWeapon = "smoke_grenade_american_night";
	soldier.grenadeAmmo++;
	
	soldier magicGrenade( smokeOrigin + (0,0,50), smokeOrigin );
	soldier.grenadeWeapon = oldGrenadeWeapon;
}

music()
{
	musicplay("british_decoytrenches_intro");
	
	flag_wait("price_arrival_music");
	
	//thread music_loop("british_decoytrenches_supplydump");
	
	musicplay("british_decoytrenches_supplydump");
	
	flag_wait("stockpiles destroyed");
	flag_wait("fuel caches destroyed");
	flag_wait( "documents recovered" );
	
	//level notify("stopmusicloop");
	
	musicstop(10);
	
	flag_wait ("arrived at BCV");
	
	musicplay("british_decoytrenches_outro");
}
/*
music_loop(musicAlias)
{
	level endon ("stopmusicloop");
	
	while(1)
	{
		musicplay(musicAlias);
		wait 98;
	}
}
*/