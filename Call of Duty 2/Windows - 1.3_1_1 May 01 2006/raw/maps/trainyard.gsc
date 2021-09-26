#include maps\_utility;
#include maps\_anim;
#include maps\_hardpoint;

/* TODO
	- end window trigger when obj C is complete (trigger_windowspawner)
	- add crouch hint
	- activity at obj points (mg42 thingy?)
	
*/

main()
{	
	setCullFog(0, 3000, .562, .57, .59, 0);

	precacheModel("xmodel/vehicle_condor");
	precacheModel("xmodel/prop_mortar_ammunition");
	precacheModel("xmodel/weapon_stickybomb");
	precacheModel("xmodel/weapon_stickybomb_obj");
	precacheShader("hudStopwatch");
	precacheShader("hudStopwatchNeedle");
	precacheShader("inventory_stickybomb");
	precacheString(&"SCRIPT_EXPLOSIVESPLANTED");
	precacheString(&"TRAINYARD_HINT_NONLINEAR1");	
	
	level._effect["mortar launch"] = loadfx ("fx/muzzleflashes/cruisader_flash.efx");

	if (getcvar ("start") == "")
		setcvar ("start", "start");

	//*** Campaign
	level.campaign = "russian";	
	maps\trainyard_anim::main();

	maps\_panzer2::main("xmodel/vehicle_panzer_ii_winter");
	maps\_halftrack::main("xmodel/vehicle_halftrack_mg_snow");
	maps\_truck::main("xmodel/vehicle_opel_blitz_snow");
	maps\trainyard_fx::main();
	
	maps\_load::main();
	maps\_mortarteam::main();
	
	level.inv_sticky = maps\_inventory::inventory_create( "inventory_stickybomb", true );
	level.assaultingPlayer = 0;
	level.mortarSoldiers = [];
	
	precacheString(&"MOSCOW_PLATFORM_UNBOUND");
	
	level.crouchHint = createHint();
	if ( level.xenon )
	{
		level.crouchHint addHintString( &"MOSCOW_PLATFORM_PUSH_TO_CROUCH_SINGLE", "+stance" );
		level.crouchHint addHintString( &"MOSCOW_PLATFORM_PUSH_TO_CROUCH", "lowerstance" );
	}
	else
	{
		level.crouchHint addHintString( &"MOSCOW_PLATFORM_GO_CROUCH", "gocrouch" );
		level.crouchHint addHintString( &"MOSCOW_PLATFORM_TOGGLE_CROUCH", "togglecrouch" );
		level.crouchHint addHintString( &"MOSCOW_PLATFORM_HOLD_CROUCH", "+movedown" );
	}

	set_ambient("inside");
	level.flag["reached warehouse"] = false;
	level.flag["entered trench"] = false;
	level.flag["started charge"] = false;
	level.flag["entered station"] = false;
	level.flag["entered lower tower"] = false;
	level.flag["entered upper tower"] = false;
	level.flag["captured stationhouse"] = false;
	level.flag["defended stationhouse"] = false;
	level.flag["destroyed tank"] = false;
	level.flag["cleared supply depot"] = false;
	level.flag["hardpoint 1 cleared"] = false;
	level.flag["hardpoint 2 cleared"] = false;
	level.flag["hardpoint 3 cleared"] = false;
	level.flag["hardpoint1 dialog finished"] = false;
	level.flag["hardpoint2 dialog finished"] = false;
	level.flag["hardpoint3 dialog finished"] = false;
	level.flag["absolute victory"] = false;
	level.flag["pipekill start"] = false;
	level.flag["rendezvous"] = false;
	level thread maps\trainyard_amb::main();

	thread maps\_utility::set_ambient("inside");

	level.player.ignoreme = true;
	level.player.stickybomb = 0;

	level.timersused = 0;

	level.player takeWeapon( "RGD-33russianfrag" );
	level.player takeWeapon( "Stielhandgranate" );
	level.player takeWeapon( "smoke_grenade_american" );
	
	thread Setup_Soldiers();
	thread Scene_HalfTrack();
	thread CounterAttack();
	thread maps\trainyard_obj::Objectives();

	thread Trigger_InPipe();
	thread Trigger_BomberWave();
	thread Trigger_RunBy();
	thread Trigger_BarrelSoldiers();
	thread Trigger_StationBattle();
	thread Trigger_StationRunners();
	thread Trigger_MortarCrews();
	thread Trigger_Warehouse();
	thread Trigger_WarehousePlatform();
	thread Trigger_Trench();
	thread Trigger_StationAssault();
	thread Trigger_Charge();
	thread Trigger_PipeKill();
	thread Trigger_Hardpoints();
	thread Trigger_PipeOpening();
	thread Trigger_PipeGrenades();
	thread Trigger_SupplyDepot();
	thread Trigger_WindowSpawner();
	thread Trigger_PipeHint();
		
	array_thread( getEntArray( "trigger_bulletChain", "targetname" ), ::Trigger_BulletChain );
	thread Propaganda();
	thread FinalAssault();
	thread WindowSpawners();
	thread victory();	
	thread music();
	thread music_stoptension();
	thread music_victory();

	getEnt( "trigger_factoryspawner", "script_noteworthy" ) triggerOff();
	getEnt( "auto_mg42", "script_noteworthy" ) thread AutoMG42_Think();

	if (getcvar ("start") == "assault")
	{
		pipeSoldiers[0] = getEnt( "pipe_russian_front", "targetname" );
		pipeSoldiers[1] = getEnt( "pipe_russian_rear", "targetname" );

		for ( index = 0; index < pipeSoldiers.size; index++ )
			pipeSoldiers[index] delete();


		getEnt( "pipe_closing_russian", "targetname" ) delete();

		getEnt( "trigger_warehouse", "targetname" ) notify ( "trigger" );
		array_thread( getEntArray( "stationdefend_soldier", "targetname" ), ::StationDefend_Think );

		level.player setOrigin( (2664,-976,256) );
		level.player setPlayerAngles( (0,90,0) );
		
		return;		
	}

	thread dialog_intro();

	thread maps\_vehicle::scripted_spawn(0);
	
	tanks = maps\_vehicle::scripted_spawn(1);
	level.tank = tanks[0];	
	
	level.tank.script_turretmg = false;
	level.tank.script_turret = false;
	level.tank stopEngineSound();
}


#using_animtree ("generic_human");
Setup_Soldiers()
{
	level.maxfriendlies = 6;
	level.friendlywave_thread = ::FriendlyWave_StationAssaultThink;

	level.pipeSoldiers[0] = getEnt( "pipe_russian_front", "targetname" );
	level.pipeSoldiers[1] = getEnt( "pipe_russian_rear", "targetname" );
	
	level.pipeSoldiers[0].deathanim = %crouch_death_fetal;
	level.pipeSoldiers[0] thread PipeSoldier_Think();
	level.pipeSoldiers[0].animname = "soldier4";
	level.pipeSoldiers[0] thread FriendlyFire_DamageCheck();
	
	level.pipeSoldiers[1].deathanim = %crouch_death_falltohands;
	level.pipeSoldiers[1] thread PipeSoldier_Think();
	level.pipeSoldiers[1].animname = "soldier3";
	level.pipeSoldiers[1] thread FriendlyFire_DamageCheck();

	level.soldier1 = getEnt( "pipe_closing_russian", "targetname" );
	level.soldier1 thread magic_bullet_shield();
	level.soldier1.animname = "soldier1";
	level.soldier1 thread FriendlyFire_DamageCheck();
	level.soldier1 animscripts\shared::PutGunInHand( "none" );
}


FriendlyFire_DamageCheck()
{
	while( true )
	{
		self waittill ( "damage", damage, attacker, direction, point, method );
		
		if (attacker != level.player)
			continue;
		
		if ( (isdefined(method)) && (method == "MOD_GRENADE_SPLASH") )
			continue;
			
		break;
	}

	setCvar("ui_deadquote", "@SCRIPT_MISSIONFAIL_KILLTEAM_RUSSIAN");
	maps\_utility::missionFailedWrapper();
}


Trigger_BomberWave()
{
	getEnt( "trigger_bomberwave", "targetname" ) waittill ( "trigger" );
	
	level notify ( "bomber wave" );

	Bomber_Wave();	
	Bomber_Wave();	
}


Bomber_Wave()
{
	bomberPaths = getVehicleNodeArray( "bomber_path", "targetname" );
	bomberPaths = array_randomize( bomberPaths );
	
	for ( index = 0; index < bomberPaths.size; index++ )
	{
		bomber = spawnVehicle( "xmodel/vehicle_condor", "plane", "Condor", bomberPaths[index].origin, (0,0,0) );
		bomber thread Bomber_TrackPath();
		bomber thread Bomber_PlayFlyBy();
		bomber attachPath( bomberPaths[index] );
		bomber startPath();
		duration = randomFloatRange( 0.5, 1.5 );
		wait ( duration );
	}
	wait ( 4.0 );
}


Bomber_TrackPath()
{
	self waittill ( "reached_end_node" );
	
	self delete();
}


Bomber_PlayFlyBy()
{
	self endon ( "death" );
	
	while ( 1 )
	{
		if ( self.origin[0] < (level.player.origin[0] + 10000) )
		{
			self playSound( "bomber_fly_by" );
			while ( 1 )
			{
				if ( self.origin[0] < level.player.origin[0] + 512 )
				{
					earthquake( 0.1, 0.7, level.player.origin, 1000 );
					level.player playRumble( "damage_heavy" );
					return;
				}
				wait ( 0.25 );
			}
		}
		
		wait ( 0.25 );
	}
}


Scene_HalfTrack()
{
	array_thread( getEntArray( "halftrack_soldier", "script_noteworthy" ), ::HalfTrackSoldier_Think );
	array_thread( getEntArray( "halftrack_officer", "script_noteworthy" ), ::HalfTrackOfficer_Think );

	getVehicleNode( "node_halftrack", "script_noteworthy") waittill ( "trigger", halftrack );

	halftrack thread Trigger_HalfTrackShoot();
	
	halftrack waittill ( "unload" );
	
	level notify ( "run to goal", true );
		
	wait ( 3.0 );
	level thread German_Taunting();

	wait ( 5.0 );	
	level notify ( "halftrack scene finished" );
	
}


German_Taunting()
{
	level endon ( "pipekill start" );
	
	tauntAliases = [];
	tauntAliases[tauntAliases.size] = "GE_0_taunt";
	tauntAliases[tauntAliases.size] = "GE_1_taunt";
	tauntAliases[tauntAliases.size] = "GE_2_taunt";
	tauntAliases[tauntAliases.size] = "GE_3_taunt";
	
	level playSoundInSpace( "GE_0_threat_infantry_generic", (-312,-2788,72) );

	while ( true )
	{
		wait ( randomFloatRange(1.0, 3.0 ) );
		level playSoundInSpace( tauntAliases[randomInt( tauntAliases.size )], (-312,-2788,72) );
		fxOrigins = getEntArray( "fx_randomPipeHole", "targetname" );
		FX_DoRandomPipeHole( fxOrigins );
	}
}


HalfTrackSoldier_Think()
{
	self waittill ( "spawned", soldier );

	if ( spawn_failed( soldier ) )
		return;

	soldier endon ( "death" );
	
	soldier.ignoreme = true;
	soldier.interval = 0;
	
	level waittill ( "run to goal" );
	
	soldier.ignoreme = false;
		
	goalNode = getNode( soldier.target, "targetname" );
	soldier setGoalNode( goalNode );
	
	soldier waittill ( "goal" );
	soldier delete();
}


HalfTrackOfficer_Think()
{
	self endon ( "death" );

	self waittill ( "spawned", officer );

	if ( spawn_failed( officer ) )
		return;
	
	officer.ignoreme = true;

	level waittill ( "run to goal" );
	
	officer.ignoreme = false;

	goalNode = getNode( officer.target, "targetname" );
	officer setGoalNode( goalNode );
	
	officer waittill ( "goal" );
	officer delete();
}


Trigger_HalfTrackShoot()
{
	self endon ( "unload" );
	
	getEnt( "trigger_halftrackshoot", "targetname" ) waittill ( "trigger" );
	
	self notify ( "unload", true );	

	wait ( 1.0 );
	level playSoundInSpace( "GE_0_reaction_surprise_ambush", (-312,-2788,72) );
}

PipeSoldier_Think()
{
	self allowedStances( "crouch" );
	self.ignoreme = true;
	self.goalradius = 32;
	self.dontavoidplayer = true;
	self.atGoal = false;
	self thread magic_bullet_shield();

	level waittill ( "pipe closed" );

	if ( self.targetname == "pipe_soldier_back" )
		wait ( 0.25 );

	goalNode = getNode( self.target, "targetname" );	
	self setGoalNode( goalNode );
	
	level waittill ( "bomber wave" );
	wait ( 5.0 );
	
	goalNode = getNode( goalNode.target, "targetname" );
	self setGoalNode( goalNode );

	level waittill ( "halftrack scene finished" );

	self.goalradius = 16;

	goalNode = getNode( goalNode.target, "targetname" );
	self setGoalNode( goalNode );

//	self waittill ( "goal" );
//	self.atGoal = true;

	flag_wait ( "pipekill start" );

	if ( self.targetname == "pipe_soldier_back" )
		wait ( 0.5 );

	self notify ( "stop magic bullet shield" );
//	goalNode = getNode( "node_pipekill", "targetname" );
	goalNode = getNode( goalNode.target, "targetname" );
	self setGoalNode( goalNode );

	self waittill ( "goal" );
	self.atGoal = true;
	
	goalNode = getNode( "node_pipekill", "targetname" );
	self setGoalNode( goalNode );
}


Trigger_PipeKill()
{
	getEnt( "trigger_pipeHurt", "targetname" ) triggerOff();
	getEnt( "trigger_pipekill", "targetname" ) waittill ( "trigger" );

	flag_set ( "pipekill start" );

	thread playSoundInSpace( "pipe_stress", level.player.origin, true );
	thread playSoundInSpace( "GE_0_threat_infantry_generic", (-312,-2788,72) );

	while ( !level.pipeSoldiers[0].atGoal || !level.pipeSoldiers[1].atGoal )
		wait ( 0.05 );

	level.pipeSoldiers[0] thread PipeSoldier_Kill( 0.65, "weapon_RGD-33russianfrag" );
	level.pipeSoldiers[1] thread PipeSoldier_Kill( 1.0, "weapon_smoke_grenade_american" );

	wait ( 0.25 );

	fxOrigins = getEntArray( "fx_scriptedPipeHole", "targetname" );
	fxOrigins = array_randomize( fxOrigins );
	
	waitTime = 0.1 * (fxOrigins.size / 4);
	thread Trigger_PipeHurt( waitTime );

	for ( index = 0; index < int(fxOrigins.size / 2); index++ )
	{
		playFx( level._effect["pipe_hit"], fxOrigins[index].origin, anglestoforward(fxOrigins[index].angles));
		magicBullet( "mp40", fxOrigins[index].origin, vectorScale( anglesToForward( fxOrigins[index].angles), 1 ) );
		fxOrigins[index] playSound( "pipe_bullet_penetrate" );
		
		wait ( 0.1 );
	}

	getEnt( "trigger_pipeHurt", "targetname" ) delete();
	
	wait ( 1.0 );
	level playSoundInSpace( "GE_0_inform_killconfirm_infantry", (-312,-2788,72) );

	level thread FX_RandomPipeHole();
	level.player.ignoreme = false;
}

Trigger_PipeHurt( waitTime )
{
	wait ( waitTime );
	
	getEnt( "trigger_pipeHurt", "targetname" ) triggerOn();	
}

PipeSoldier_Kill( deathTime, weapon )
{
	self endon ( "death" );
/*
	if ( self.targetname == "pipe_russian_front" )
		trigger = getEnt( "trigger_aiFront", "targetname" );
	else	
		trigger = getEnt( "trigger_aiRear", "targetname" );

	while ( !self isTouching( trigger ) )
		wait ( 0.05 );
*/
	wait ( deathtime );

	weapon = spawn( weapon, self getTagOrigin( "tag_weapon_right" ) );
	weapon.angles = self getTagAngles( "tag_weapon_right" ); 

	self animscripts\death::PlayDeathSound();
	if ( isDefined(self.groundType) )
		self playSound ("bodyfall_" + self.groundType + "_large");
	else
		self playSound ("bodyfall_dirt_large");
		
	self doDamage( self.health + 1000, self.origin );
}


FX_RandomPipeHole()
{
	self endon ( "reached warehouse" );

	fxOrigins = getEntArray( "fx_randomPipeHole", "targetname" );

	while ( true )
	{
		FX_DoRandomPipeHole( fxOrigins );
		wait ( randomFloatRange( 2.0, 6.0 ) );
	}
}

FX_DoRandomPipeHole( fxOrigins )
{
	fxOrigins = array_randomize( fxOrigins );
		
	for ( index = 0; index < fxOrigins.size; index++ )
	{
		if ( distance( level.player.origin, fxOrigins[index].origin ) < 500 )
		{
			playFx( level._effect["pipe_hit"], fxOrigins[index].origin, anglestoforward(fxOrigins[index].angles));
			if ( randomFloat( 1.0 ) > 0.5 )
				magicBullet( "mp40", fxOrigins[index].origin, vectorScale( anglesToForward( fxOrigins[index].angles), 1 ) );
			else
				magicBullet( "kar98k", fxOrigins[index].origin, vectorScale( anglesToForward( fxOrigins[index].angles), 1 ) );
				
			fxOrigins[index] playSound( "pipe_bullet_penetrate" );
			break;
		}
		wait ( 0.05 );
	}
}

AutoMG42_Think()
{
	while ( true )
	{
		owner = self getTurretOwner();
		
		if ( !isDefined( owner ) )
		{
			wait ( 0.5 );
			continue;
		}

		owner waittill ( "death" );
		badplace_cylinder("automg42", 6.0, self.origin, 128, 128, owner.team );		
		wait ( 6.0 );
	}	
}


Trigger_BulletChain()
{
	self waittill ( "trigger" );
	
	level thread playSoundInSpace( "GE_" + randomInt( 4 ) + "_taunt", level.player.origin - (0,0,256) );

	chain = getEnt( self.target, "targetname" );
	
	while ( isDefined( chain ) )
	{
		playFx( level._effect["pipe_hit"], chain.origin, anglestoforward(chain.angles));
		level thread playSoundInSpace( "weap_mp40_fire", level.player.origin - (0,0,256) );
		chain playSound( "pipe_bullet_penetrate" );
		radiusDamage( chain.origin, 32, level.player.maxhealth / 4, level.player.maxhealth / 4 );
		wait ( 0.1 );
		
		if ( isDefined( chain.target ) )
			chain = getEnt( chain.target, "targetname" );
		else
			chain = undefined;
	}
}


Trigger_InPipe()
{
	soldier = getEnt( "pipe_closing_russian", "targetname" );
	getEnt( "trigger_inpipe", "targetname" ) waittill ( "trigger" );
	level notify ( "end_pipe_hint" );

	level.player allowLeanLeft(false);
	level.player allowLeanRight(false);

	getNode( soldier.target, "targetname" ) thread anim_single_solo( soldier, "goodluck" );

	pipeHatchModel = getEnt( "pipehatch_model", "script_noteworthy" );
	pipeHatch =  getEnt( pipeHatchModel.target, "targetname" );

	pipeOrigin = spawn( "script_origin", pipeHatch.origin );
	pipeHatchModel linkTo ( pipeOrigin );

	pipeHatch playSoundAsMaster ("pipe_hatch_close");
	pipeOrigin rotateYaw( 45, 1.5, 0.05, 0.05 );
	pipeHatch rotateYaw( 45, 0.05, 0.0, 0.0 );
	
	wait ( 1.5 );
	earthquake( 0.1, 0.2, level.player.origin, 1000 );
	level notify ( "pipe closed" );
	soldier delete();
}


Trigger_PipeOpening()
{
	level endon ( "reached warehouse" );

	pipeOpenings = getEntArray( "trigger_pipeOpening", "targetname" );
	
	array_thread( pipeOpenings, ::Trigger_pipeOpeningDamage );
	while ( true )
	{
		exposed = false;
		
		for ( index = 0; index < pipeOpenings.size; index++ )
		{
			if ( !pipeOpenings[index].damaged )
				continue;
				
			if ( level.player isTouching( pipeOpenings[index] ) )
				exposed = true;
		}
		
		if ( exposed )
			level.player.ignoreme = false;
		else
			level.player.ignoreme = true;
		
		wait ( 0.1 );	
	}
}


Trigger_PipeOpeningDamage()
{
	level endon ( "reached warehouse" );

	self.damaged = false;
	while ( true )
	{
		self waittill ( "trigger", attacker );

		if ( attacker != level.player )
			continue;
			
		if ( !attacker isTouching( self ) )
			continue;
			
		self.damaged = true;
		return;
	}
}


Trigger_PipeHint()
{
	level endon ( "end_pipe_hint" );

	getEnt( "trigger_pipehint", "targetname" ) waittill ( "trigger" );
	
	wait ( 5.0 );
	thread displayHintElem( level.crouchHint, "end_pipe_hint", 5.0 );	
}


Trigger_RunBy()
{
	getEnt( "trigger_runby", "targetname" ) waittill ( "trigger" );
	
	spawners = getEntArray( "runby_soldier", "targetname" );
	
	for ( index = 0; index < spawners.size; index++ )
	{
		soldier = spawners[index] doSpawn();
		if ( spawn_failed( soldier ) )
			continue;
		
		soldier RunBySoldier_Think();
		wait ( randomFloatRange( 0.5, 2.0 ) );
	}
}


RunBySoldier_Think()
{
	self endon( "death" );
	
	if ( self.team != "allies" )
		return;
		
	flag_wait( "reached warehouse" );
	
	self delete();
}


DeleteOnPathEnd_SpawnerThink()
{
	while ( true )
	{
		self waittill ( "spawned", soldier );
		
		if ( spawn_failed( soldier ) )
			continue;

		soldier thread DeleteOnPathEnd_Think();
	}
}


DeleteOnPathEnd_Think()
{
	self endon ( "death" );

	self.goalradius = 64;
	self waittill ( "reached_path_end" );
			
	self delete();
}


Trigger_BarrelSoldiers()
{
	getEnt( "trigger_barrelsoldiers", "targetname" ) waittill ( "trigger" );

	array_thread( getEntArray( "barrel_soldier", "targetname" ), ::BarrelSoldier_Think );
	array_thread( getEntArray( "barrel_officer", "targetname" ), ::BarrelOfficer_Think );
	
	setEnvironment( "cold" );
	Spawn_Soldiers( getEntArray( "barrel_soldier", "targetname" ) );
	Spawn_Soldiers( getEntArray( "barrel_officer", "targetname" ) );
	setEnvironment( "normal" );
	
	level waittill ( "barrel soldier died" );
	level notify ( "barrel speech interrupted" );
}


Spawn_Soldiers( spawners, delay )
{
	if ( !isdefined( delay ) )
		delay = 0;
		
	soldiers = [];
	for ( index = 0; index < spawners.size; index++ )
	{
		soldier = spawners[index] doSpawn();
		
		if ( spawn_failed( soldier ) )
			continue;
			
		soldier.targetname = spawners[index].targetname;		
		soldiers[soldiers.size] = soldier;
		wait ( delay );
	}
	
	return ( soldiers );
}


BarrelSoldier_FleeThink()
{
	self endon ( "death" );
	
	level waittill ( "barrel speech interrupted" );
	
	goalNode = getNode( self.target, "targetname" );
	self setGoalNode( goalNode );
	
	self waittill ( "goal" );
	self delete();
}


BarrelOfficer_FleeThink( goalPos )
{
	self endon ( "death" );

	goalPos = self.origin;
	
	level waittill ( "barrel speech interrupted" );
	
	self setGoalPos( goalPos );
	
	self waittill ( "goal" );
	self delete();
}


BarrelSoldier_Think()
{
	self waittill ( "spawned", soldier );

	if ( spawn_failed( soldier ) )
		return;

	soldier endon ( "death" );
	level endon ( "barrel speech interrupted" );

	soldier thread deathWaiter( "barrel soldier died" );
	soldier thread BarrelSoldier_FleeThink();
	
	level waittill_any ( "barrel speech done" );
		
	soldier.goalradius = 64;

	wait ( randomFloatRange( 0.1, 0.25 ) );
	
	goalNode = getNode( soldier.target, "targetname" );
	soldier setGoalNode( goalNode );
	
	soldier waittill ( "goal" );
	soldier delete();
}


BarrelOfficer_Think()
{
	self.script_bcdialog = false;
	self waittill ( "spawned", soldier );

	if ( spawn_failed( soldier ) )
		return;

	soldier endon ( "death" );
	level endon ( "barrel speech interrupted" );

	soldier thread deathWaiter( "barrel soldier died" );
	soldier thread BarrelOfficer_FleeThink();
	soldier thread BarrelOfficer_SpeechThink();

	goalPos = soldier.origin;	
	soldier.goalradius = 32;
	soldier waittill ( "goal" );

	level waittill ( "barrel speech done" );

	soldier setGoalPos( goalPos );

	soldier waittill ( "goal" );
	soldier delete();
}

BarrelOfficer_SpeechThink()
{
	self endon ( "death" );
	level endon ( "barrel speech interrupted" );
	
	self playSound( "GE_3_threat_infantry_many", "done", true );
	self waittill ( "done" );
	self playSound( "GE_3_order_move_follow", "done", true );
	self waittill ( "done" );
	self playSound( "GE_1_response_acknowledge_follow", "done", true );
	level notify ( "barrel speech done" );
}


Trigger_StationBattle()
{
	level endon ( "reached warehouse" );
	
	getEnt( "trigger_stationbattle", "targetname" ) waittill ( "trigger" );
	array_thread( getEntArray( "stationdefend_soldier", "targetname" ), ::StationDefend_Think );
	array_thread( getEntArray( "stationattack_soldier", "targetname" ), ::StationAssault_SpawnerThink );
	
//	generic_style (strExplosion, fDelay, iBarrageSize, fBarrageDelay, iMinRange, iMaxRange, bTargetsUsed)
	/*
	level.explosion_stopNotify["german1_mortar"] = "stop german1 mortars";
	thread maps\_mortar::generic_style( "german1_mortar", 4, 4, 1, 1, 10000 );

	level.explosion_stopNotify["german2_mortar"] = "stop german2 mortars";
	thread maps\_mortar::generic_style( "german2_mortar", 4, 4, 1, 1, 10000 );
	*/
	level.explosion_stopNotify["russian_mortar"] = "stop russian mortars";
	thread maps\_mortar::generic_style( "russian_mortar", 4, 4, 1, 1, 10000 );
}


Trigger_StationRunners()
{
	getEnt( "trigger_stationrunners", "targetname" ) waittill ( "trigger" );

	array_thread( getEntArray( "stationrunner2_soldier", "targetname" ),  ::DeleteOnPathEnd_SpawnerThink );
	array_thread( getEntArray( "stationrunner3_soldier", "targetname" ),  ::DeleteOnPathEnd_SpawnerThink );

	Spawn_Soldiers( getEntArray( "stationrunner1_soldier", "targetname" ) );
	Spawn_Soldiers( getEntArray( "stationrunner3_soldier", "targetname" ) );
	wait ( 10.0 );
	Spawn_Soldiers( getEntArray( "stationrunner2_soldier", "targetname" ) );
}


StationAssault_SpawnerThink()
{
	self endon ( "death" );
	level endon ( "reached warehouse" );
	
	while ( true )
	{
		soldier = self doSpawn();
	
		if ( spawn_failed( soldier ) )
		{
			wait ( 1.0 );
			continue;
		}
		
		soldier.targetname = "stationattack_soldier";
		soldier.dropWeapon = false;
		soldier waittill ( "death" );
	}
}


StationDefend_Think()
{
	self endon ( "death" );
	while ( true )
	{
		soldier = self doSpawn();
	
		if ( spawn_failed( soldier ) )
		{
			wait ( 1.0 );
			continue;
		}
		
		soldier.targetname = self.targetname;
		soldier waittill ( "death" );
		
		wait ( randomFloatRange( 3.0, 6.0 ) );
	}
}


Trigger_MortarCrews()
{
	getEnt( "trigger_mortarcrews", "targetname" ) waittill ( "trigger" );

	spawners = getEntArray( "mortarcrew1_soldier", "targetname" );
	level thread MortarCrew_Spawn( spawners, 1, "german1_mortar" );

	spawners = getEntArray( "mortarcrew2_soldier", "targetname" );
	level thread MortarCrew_Spawn( spawners, 1, "german1_mortar" );

	spawners = getEntArray( "mortarcrew3_soldier", "targetname" );
	level thread MortarCrew_Spawn( spawners, 2, "german2_mortar" );

	spawners = getEntArray( "mortarcrew4_soldier", "targetname" );
	level thread MortarCrew_Spawn( spawners, 2, "german2_mortar" );	
}


Trigger_Warehouse()
{
	array_thread( getEntArray( "charge_soldier", "script_noteworthy" ), ::ChargeSpawner_Think );
	array_thread( getEntArray( "trench_soldier", "script_noteworthy" ), ::TrenchSpawner_Think );

	getEnt( "trigger_warehouse", "targetname" ) waittill ( "trigger" );
	
	flag_set ( "reached warehouse" );

	level notify ( "stop russian mortars" );
	
	soldiers = getAIArray( "axis" );
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] delete();
	
	soldiers = getEntArray( "stationattack_soldier", "targetname" );
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] delete();

	level.followers = 0;
}


Trigger_WarehousePlatform()
{
	getEnt( "trigger_warehouseplatform", "targetname" ) waittill ( "trigger" );
	
	level.player allowLeanLeft( true );
	level.player allowLeanRight( true );
}


TrenchSpawner_Think()
{
	self endon ( "death" );
	
	self waittill ( "spawned", soldier );
	
	if ( spawn_failed( soldier ) )
		return;
	
	soldier endon( "death" );
	soldier.ignoreme = true;
	flag_wait ( "started charge" );
	soldier.ignoreme = false;

	self thread FriendlyWave_StationAssaultThink( soldier );
}


Trigger_Trench()
{
	getEnt( "trigger_trench", "targetname" ) waittill ( "trigger" );
	
	flag_set( "entered trench" );

	getEnt( "trigger_charge", "script_noteworthy" ) notify ( "trigger" );
	getEnt( "trench_friendlywave", "script_noteworthy" ) notify ( "trigger" );
	
	wait ( 15.0 );
	
	chainTriggers = getEntArray( "assault_chain", "targetname" );
	
	closestTrigger = chainTriggers[0];
	for ( index = 0; index < chainTriggers.size; index++ )
	{
		origin = chainTriggers[index] getOrigin();
		if ( distance( level.player.origin, origin ) < distance( level.player.origin, closestTrigger getOrigin() ) )
			closestTrigger = chainTriggers[index];
	}
	
	closestTrigger notify ( "trigger" );
	level.player setFriendlyChain( getNode( closestTrigger.target, "targetname" ) );
}


Trigger_Charge()
{
	getEnt( "trigger_charge", "script_noteworthy" ) waittill ( "trigger" );
	
	thread dialog_charge();
	
	killTriggers = getEntArray( "trigger_playerkill", "targetname" );
	for ( index = 0; index < killTriggers.size; index++ )
		killTriggers[index] delete();

	flag_set( "started charge" );
	level.player.ignoreme = false;
}


Trigger_StationAssault()
{
	getEnt( "trigger_enterstation", "targetname" ) waittill ( "trigger" );	
	flag_set( "entered station" );

	getEnt( "trigger_enterlowertower", "targetname" ) waittill ( "trigger" );
	flag_set( "entered lower tower" );

	getEnt( "trigger_enteruppertower", "targetname" ) waittill ( "trigger" );
	flag_set( "entered upper tower" );
	
	waittill_aigroupcleared( "station" );

	flag_set( "captured stationhouse" );	
	thread autoSaveByName( "capturedstation" );
}


Trigger_WindowSpawner()
{
	/*
	trigger = getEnt( "trigger_windowspawner", "script_noteworthy" );
	trigger endon ( "trigger" );

	waittill_aigroupcleared( "hardpoint ?" );
	
	trigger delete();
	*/
}


Trigger_SupplyDepot()
{
	getEnt( "trigger_supplydepot", "script_noteworthy" ) waittill ( "trigger" );
	
	// hardpoint 1 dialog
	thread hardpointRushPlayer( "hardpoint1" );
	wait ( 3.0 );
	dialog_hardpoint1();
	flag_set( "hardpoint1 dialog finished" );
}


hardpointRushPlayer( aigroup )
{
	while ( getAIGroupCount( aigroup ) > 2 )
		wait ( 1.0 );
		
	soldiers = getAIGroupAI( aigroup );
	for ( index = 0; index < soldiers.size; index++ )
	{
		soldiers[index].goalradius = 256;
		soldiers[index] setGoalEntity( level.player );
	}
}


Trigger_Hardpoints()
{
	getEnt( "trigger_hardpoints", "script_noteworthy" ) waittill ( "trigger" );
	thread autoSaveByName( "hardpoints" );
	
	dialog_hardpoint2();
	thread hardpointRushPlayer( "hardpoint2" );
	flag_set( "hardpoint2 dialog finished" );
	iPrintLnBold( &"TRAINYARD_HINT_NONLINEAR1" );
	wait ( 7.0 );
	dialog_hardpoint3();
	thread hardpointRushPlayer( "hardpoint3" );
	flag_set( "hardpoint3 dialog finished" );
	
}


FriendlyWave_FollowerThink()
{
	level.followers++;
	
	self waittill ( "death" );
	level endon ( "defended stationhouse" );
	
	level.followers--;
}

FriendlyWave_TankAssaultThink( soldier )
{
	level endon ( "destroyed tank" );
	soldier endon ( "death" );
	
	goalNode = getNode( "node_tankassault", "script_noteworthy" );
	
	soldier.goalradius = goalNode.radius;
	soldier setGoalNode( goalNode );

	wait ( 20.0 );
	soldier.goalradius = goalNode.radius / 2;
}

FriendlyWave_FriendlyVolumeThink( soldier )
{
	soldier endon ( "death" );
	level endon ( "absolute victory" );
	
	while ( !flag( "absolute victory" ) )
	{		
		soldier thread Soldier_FriendlyVolumeThink();

		level waittill ( "new friendly volume" );
	}
}

Soldier_FriendlyVolumeThink()
{
	self endon ( "death" );
	self notify ( "Soldier_FriendlyVolumeThink" );
	self endon ( "Soldier_FriendlyVolumeThink" );
	level endon ( "absolute victory" );
	
	wait ( randomFloatRange( 0.5, 3.0 ) );

	self setGoalNode( level.goalNode );
	self setGoalVolume( level.goalVolume );
	self.goalradius = level.goalNode.radius;
}

ChargeSpawner_Think()
{
	self endon ( "death" );
	self waittill ( "spawned", soldier );
	
	if ( spawn_failed( soldier ) )
		return;
		
	soldier endon ( "death" );
	soldier.ignoreme = true;

	getEnt( "trigger_whchain", "targetname" ) waittill ( "trigger" );
	
	soldier thread FriendlyWave_StationAssaultThink( soldier );
}

FriendlyWave_StationAssaultThink( soldier )
{
	level endon ( "defended stationhouse" );
	soldier endon ( "death" );

	wait ( 0.5 );

	soldier setGoalEntity( level.player );

	soldier.ignoreme = true;
	flag_wait( "started charge" );
	soldier.ignoreme = false;

	flag_wait( "entered station" );
	friendlyVolume = getEnt( "volume_stationlower", "targetname" );
	friendlyNode = getNode( friendlyVolume.target, "targetname" );
	soldier setGoalNode( friendlyNode );
	soldier setGoalVolume( friendlyVolume );
	soldier.goalradius = friendlyNode.radius;

	flag_wait( "entered lower tower" );
	
	if ( level.gameSkill > 1 )
		maxFollowers = 1;
	else
		maxFollowers = 2;
	
	if ( level.followers < maxFollowers && !flag( "cleared supply depot" ) )
	{
		soldier thread FriendlyWave_FollowerThink();
	
		friendlyVolume = getEnt( "volume_towerlower", "targetname" );
		friendlyNode = getNode( friendlyVolume.target, "targetname" );
		soldier setGoalNode( friendlyNode );
		soldier setGoalVolume( friendlyVolume );
		soldier.goalradius = friendlyNode.radius;
	
		flag_wait( "entered upper tower" );
		friendlyVolume = getEnt( "volume_towerupper", "targetname" );
		friendlyNode = getNode( friendlyVolume.target, "targetname" );
		soldier setGoalNode( friendlyNode );
		soldier setGoalVolume( friendlyVolume );
		soldier.goalradius = friendlyNode.radius;
	}
}

// need crewid
MortarCrew_Spawn( spawners, crewID, targetTargetName )
{
	crewStruct = spawnStruct();
	
	mortarCrew = [];
	mortarName = undefined;

	mortarTargets = getEntArray( targetTargetName, "targetname" );

	for ( index = 0; index < spawners.size; index++ )
	{
		soldier = spawners[index] doSpawn();
		if ( spawn_failed( soldier ) )
			continue;
			
		if ( !isDefined( spawners[index].script_noteworthy ) )
			continue;
			
		mortarCrew[mortarCrew.size] = soldier;
		mortarName = spawners[index].script_noteworthy;
	}
	
	if ( mortarCrew.size < 2 )
		return;


	for ( index = 0; index < mortarCrew.size; index++ )
	{
		mortarCrew[index] thread MortarSoldier_Think( mortarCrew, crewID );
		if ( !isDefined(level.mortarSoldiers[crewID] ) )
			level.mortarSoldiers[crewID] = [];
		level.mortarSoldiers[crewID][level.mortarSoldiers[crewID].size] = mortarCrew[index];
	}

	mortar = getEnt( mortarName, "targetname" );
	mortar thread Mortar_LoadAndFire( mortarCrew, mortarTargets );
	
	level waittill ( "mortar crew interrupted " + crewID );
	mortar notify ( "stop" );
}


MortarSoldier_Think( crewStruct, crewID )
{
	self.ignoreme = true;

	self waittill_any ( "death", "pain", "damage", "grenade danger" );

	for ( index = 0; index < level.mortarSoldiers[crewID].size; index++ )
	{
		if ( !isAlive( level.mortarSoldiers[crewID][index] ) )
			continue;
			
		level.mortarSoldiers[crewID][index] animscripts\shared::putGunInHand( "right" );
		level.mortarSoldiers[crewID][index] stopAnimScripted();
		level.mortarSoldiers[crewID][index] notify ( "stopIdle" );

		if ( isdefined (level.mortarSoldiers[crewID][index].mortarAmmo) && level.mortarSoldiers[crewID][index].mortarAmmo )
		{
			level.mortarSoldiers[crewID][index] detach("xmodel/prop_mortar_ammunition", "TAG_WEAPON_RIGHT");
			level.mortarSoldiers[crewID][index].mortarAmmo = false;
		}
	}
	level notify ( "mortar crew interrupted " + crewID );
}


Mortar_LoadAndFire( mortarCrew, mortarTargets )
{
	self endon ( "stop" );
	mortarCrew[0] endon ( "death" );
	mortarCrew[1] endon ( "death" );
	
	mortarCrew[0].animname = "loadguy";
	mortarCrew[1].animname = "aimguy";
	loadGuy = mortarCrew[0];
	aimGuy = mortarCrew[1];

	loadGuy animscripts\shared::putGunInHand("none");
	aimGuy animscripts\shared::putGunInHand("none");
	
	aimGuy.deathanim = %crouch_death_clutchchest;
	
	self anim_single_solo (aimGuy, "fire");
	self.mortarEnt = self;
	self.mortar = self;
	self.mortar_targets = mortarTargets;

	while ( true )
	{
		self thread anim_loop( mortarCrew, "wait_idle", undefined, "stopIdle" );
		wait ( randomFloatRange(4.0, 6.0) );
		self notify ( "stopIdle" );
		self anim_single( mortarCrew, "pickup" );
		self anim_single( mortarCrew, "fire" );
	}
}


Propaganda()
{
	getEnt( "propaganda1", "targetname" ) waittill ( "trigger" );
	thread playSoundInSpace( "downtownsniper_gplv_propaganda1", (-1032,3438,64) );

	getEnt( "propaganda2", "targetname" ) waittill ( "trigger" );
	thread playSoundInSpace( "downtownsniper_gplv_propaganda2", (-1032,3438,64) );
}


CounterAttack()
{
	level thread assaultGroupCallout();

	flag_wait( "captured stationhouse" );
	
	thread autoSaveByName( "defendingstation1" );

	thread dialog_counterattack();

	level thread assaultGroup( "ge_assault1" );
	level thread assaultGroup( "ge_assault5" );
	wait ( 7.5 );

	level thread assaultGroup( "ge_assault2" );
	level thread assaultGroup( "ge_assault3" );
	wait ( 7.5 );

	level thread assaultGroup( "ge_assault4" );
	
	wait ( 15.0 );

	thread autoSaveByName( "defendingstation2" );

	mg42spawners = getEntArray( "soldier_mg42portable", "targetname" );
	soldier = mg42spawners[0] dospawn();
	spawn_failed( soldier );
	
	level.maxfriendlies = 4;

	level thread MagicGrenades();
	
	wait ( 30.0 );
	thread autoSaveByName( "defendingstation3" );

	wait ( 30.0 );
	thread autoSaveByName( "defendingstation4" );

	soldier = mg42spawners[1] dospawn();
	spawn_failed( soldier );

	level.maxfriendlies = 2;
	
	wait ( 30.0 );
	thread autoSaveByName( "defendingstation5" );

	level.maxfriendlies = 1; // set to 1... 0 causes an issue in _spawner
	soldier = mg42spawners[2] dospawn();
	spawn_failed( soldier );
	
	wait ( 30.0 );
	thread autoSaveByName( "defendedstation" );

	level.maxfriendlies = 3;

	flag_set( "defended stationhouse" );

	level notify ( "assault retreat ge_assault1" );
	wait ( 1.0 );
	level notify ( "assault retreat ge_assault2" );
	wait ( 1.0 );
	level notify ( "assault retreat ge_assault3" );	
	wait ( 1.0 );
	level notify ( "assault retreat ge_assault4" );
	wait ( 1.0 );
	level notify ( "assault retreat ge_assault5" );
	wait ( 1.0 );
	
	getEnt( "trigger_factoryspawner", "script_noteworthy" ) triggerOn();
	Setup_Tank();
	
	thread dialogue_tankobj();
	
	sandbagOrigin = getEnt( "sandbags_origin", "targetname" );
	sandbagOrigin playsound( "rocket_explode_sand" );
	radiusDamage ((-677,-176,58), 128, 100, 50);
	playFx( level._effect["sandbags"], sandbagOrigin.origin, anglesToForward( sandbagOrigin.angles ) );
	
	sandbags = getEntArray( "sandbags", "targetname" );	
	for ( index = 0; index < sandbags.size; index++ )
		sandbags[index] delete();

	sandbags_coll = getEntArray( "sandbags_coll", "targetname" );
	for ( index = 0; index < sandbags_coll.size; index++ )
	{
		sandbags_coll[index] notsolid();
		sandbags_coll[index] connectpaths();
	}
		
	wait ( 6.0 );
	
	thread Spawn_Soldiers( getEntArray( "depotdefend_soldier", "targetname" ) );

	soldiers = getAIArray( "allies" );
	goalNode = getNode( "node_tankassault", "script_noteworthy" );
	for ( index = 0; index < soldiers.size; index++ )
	{
		soldiers[index].goalradius = goalNode.radius;
		soldiers[index] setGoalNode( goalNode );
		soldiers[index] thread FriendlyWave_TankAssaultThink( soldiers[index] );
	}
	level.maxfriendlies = 4;
	level.friendlywave_thread = ::FriendlyWave_TankAssaultThink;

	flag_wait ( "destroyed tank" );
	thread autoSaveByName( "destroyedtank" );

	level thread UpdateGoalTrigger();

	soldiers = getAIArray( "allies" );
	for ( index = 0; index < soldiers.size; index++ )
		soldiers[index] thread FriendlyWave_FriendlyVolumeThink( soldiers[index] );

	level.friendlywave_thread = ::FriendlyWave_FriendlyVolumeThink;
}

Trigger_PipeGrenades()
{
	getEnt( "trigger_pipeGrenades", "targetname" ) waittill ( "trigger" );
	
	soldier = getClosest( (8653,-12681,-156), getaiarray( "axis" ) );
	
	thread playSoundInSpace( "GE_2_inform_attacking_grenade", level.player.origin + (0,0,-300) );

	grenadeSrc = (1636,-992,300);
	grenadeDest = (1586,-980,383);

	velocity = vectorNormalize( grenadeDest - grenadeSrc );
	velocity = vectorScale( velocity, distance( grenadeSrc, grenadeDest )*4);
	soldier MagicGrenadeManual( grenadeSrc, velocity, 4.0 );
}


MagicGrenades()
{
	if ( level.gameSkill == 0 )
		minFuse = 7.0;
	else if ( level.gameSkill == 1 )
		minFuse = 5.5;
	else
		minFuse = 4.0;
		
	grenadeOrigins = getEntArray( "magic grenade", "targetname" );
	while ( !flag( "defended stationhouse" ) )
	{
		if ( randomFloat( 1.0 ) > 0.33 )
		{
			wait ( 5.0 );
			grenadeSrc = getClosest( level.player.origin, grenadeOrigins);
		}
		else
		{
			grenadeSrc = grenadeOrigins[randomInt( grenadeOrigins.size )];
		}
			
		grenadeDest = getEnt( grenadeSrc.target, "targetname" );

		soldiers = getAIArray( "axis" );
		
		if ( isDefined( soldiers[0] ) )
			soldiers[0] magicGrenade( grenadeSrc.origin, grenadeDest.origin, randomFloatRange( minFuse, minFuse + 3.0 ) );
			
		wait ( randomFloatRange( 5.0, 15.0 ) );
	}
}


UpdateGoalTrigger()
{
	level.goalTriggers = getEntArray( "trigger_friendlyvolume", "targetname" );
	level.goalTrigger = getEnt( "trigger_friendlyvolume_start", "script_noteworthy" );
	level.goalVolume = getEnt( level.goalTrigger.target, "targetname" );
	level.goalNode = getNode( level.goalVolume.target, "targetname" );
	
	level.goalVolume = getEnt( "volume_depot", "targetname" );
	level.goalNode = getNode( level.goalVolume.target, "targetname" );

	flag_wait( "hardpoint2 dialog finished" );

	while ( true )
	{
		if ( !level.player isTouching( level.goalTrigger ) )
		{
			newGoalTrigger = undefined;

			for ( index = 0; index < level.goalTriggers.size; index++ )
			{
				if ( level.player isTouching( level.goalTriggers[index] ) )
					newGoalTrigger = level.goalTriggers[index];
			}
			
			if ( isDefined( newGoalTrigger) )
			{
				level.goalTrigger = newGoalTrigger;
				level.goalVolume = getEnt( level.goalTrigger.target, "targetname" );
				level.goalNode = getNode( level.goalVolume.target, "targetname" );
				level notify ( "new friendly volume" );
			}	
		}
		
		if ( level.doFinalAssault )
		{
			level.goalVolume = getEnt( "volume_commandpost", "targetname" );
			level.goalNode = getNode( level.goalVolume.target, "targetname" );
			level notify ( "new friendly volume" );
			return;
		}
		
		wait ( 0.5 );
	}
}


assaultGroupCallout()
{
	while ( true )
	{
		level waittill ( "assaultGroup warning", origin );
		
		soldier = getClosest( level.player.origin, getAIArray( "allies" ) );
		
		if ( !isDefined( soldier ) )
			continue;
			
		direction = animscripts\battleChatter::getDirectionCompass( level.player.origin, origin );
		
		switch( direction )
		{
			case "northwest":
			case "southwest":
			case "northeast":
			case "southeast":
				soldier customBattleChatter( "infantry_generic_" + direction );
				break;
			default:
				soldier customBattleChatter( "infantry_generic_inbound_" + direction );
				break;
		}
	}
}

assaultGroupRetreat(groupName)
{
	level endon ("assault stop " + groupName);

	while (1)
	{
		level waittill ("assault retreat " + groupName);
		level.assaultGroupRetreat[groupName] = true;
	}
}

assaultGroupAttack(groupName)
{
	level endon ("assault stop " + groupName);

	while (1)
	{
		level waittill ("assault attack " + groupName);
		level.assaultGroupRetreat[groupName] = false;
	}
}

assaultGroup(groupName)
{
	level endon ("assault stop " + groupName);
	
	spawners = getentarray(groupName, "targetname");

	level.assaultGroupRetreat[groupName] = false;
	level thread assaultGroupRetreat(groupName);
	level thread assaultGroupAttack(groupName);
	
	while (1)
	{
		if (level.assaultGroupRetreat[groupName])
			level waittill ("assault attack " + groupName);

		soldiers = [];
		for (i = 0; i < spawners.size; i++)
		{
			soldier = spawners[i] dospawn();
			if (spawn_failed(soldier))
				continue;
			spawners[i].count++;
			soldier.targetname = ("_" + groupName);
			soldier.assaultNode = getnode (spawners[i].target, "targetname");
			soldier.goalradius = 32;
			soldier.interval = 0;
			soldier.anim_disableLongDeath = true;
			soldiers[soldiers.size] = soldier;
		}

		goalNode = undefined;

		if (soldiers.size)
			level notify ( "assaultGroup warning", soldiers[0].origin );

		while (soldiers.size > 0)
		{
			if (level.assaultGroupRetreat[groupName])
			{
				goalNode = getNode( "node_retreat", "script_noteworthy" );
				
				for (i = 0; i < soldiers.size; i++)
				{
					soldiers[i].goalradius = goalNode.radius;
					soldiers[i] setGoalNode( goalNode );
				}
				
				level notify ( "assault stop " + groupName );
				return;
			}

			assaultToGoal(soldiers, goalNode, groupName);
			waittillframeend;
			soldiers = assaultGetSoldiers(groupName);
		}
		
		wait ( randomFloatRange( 5.0, 10.0 ) );
	}
}

assaultGetSoldiers(groupName)
{
	liveSoldiers = [];
	soldiers = getentarray("_" + groupName, "targetname");
	for (i = 0; i < soldiers.size; i++)
	{
		if (!isalive(soldiers[i]))
			continue;
			
		liveSoldiers[liveSoldiers.size] = soldiers[i];
	}
	return liveSoldiers;
}

assaultToGoal(soldiers, goalNode, groupName)
{
	level endon ("assault stop " + groupName);
	level endon ("assault retreat " + groupName);

	trackerEnt = spawnStruct();
	trackerEnt.notAtGoal = 0;

	for (i = 0; i < soldiers.size; i++)
	{
		// used only when retreating
		if (isdefined (goalNode))
		{
			soldiers[i] setgoalnode(goalNode);
			continue;
		}
		
		if (isdefined (soldiers[i].assaultNode))
		{
			trackerEnt.notAtGoal++;
			soldiers[i] thread assaultThink( groupName, trackerEnt );
			soldiers[i] thread assaultThinkDeathWaiter( groupName, trackerEnt );
		}
		else
		{
			trackerEnt.notAtGoal++;
			soldiers[i] thread addToAssaultQueue();
			soldiers[i] thread assaultThinkDeathWaiter( groupName, trackerEnt );
		}
	}

	while ( trackerEnt.notAtGoal )
	{
		trackerEnt waittill ("goalordeath");
	}

	wait ( randomFloatRange( 3.0, 6.0 ) );
}

assaultThink(groupName, trackerEnt)
{
	level endon ("assault stop " + groupName);
	level endon ("assault retreat " + groupName);
	
	self endon ( "death" );
	
	wait randomfloatrange (0, 0.6);
	while ( true )
	{
		self setGoalNode( self.assaultNode );	
		self waittill ( "goal" );

		if ( !isDefined( self.assaultNode.target ) )
		{
			self.assaultNode = undefined;
			self notify ( "reached stop node" );
			trackerEnt.notAtGoal--;
			trackerEnt notify ("goalordeath", groupName);
			return;
		}
		
		if ( isDefined( self.assaultNode.script_noteworthy ) && self.assaultNode.script_noteworthy == "assaultcover" )
		{
			self.assaultNode = getNode( self.assaultNode.target, "targetname" );
			self notify ( "reached stop node" );
			trackerEnt.notAtGoal--;
			trackerEnt notify ("goalordeath", groupName);
			return;
		}
		
		self.assaultNode = getNode( self.assaultNode.target, "targetname" );
	}
}

assaultThinkDeathWaiter(groupName, trackerEnt)
{
	self endon ("reached stop node");
	level endon ("assault stop " + groupName);
	level endon ("assault retreat " + groupName);
	
	self waittill ( "death" );
	trackerEnt.notAtGoal--;
	trackerEnt notify ("goalordeath");
}


addToAssaultQueue()
{
	self endon ( "death" );
	self endon ( "defended stationhouse" );

	if ( level.gameSkill < 1 )		
		assaultCount = 1;
	else if ( level.gameSkill > 2 )
		assaultCount = 4;
	else
		assaultCount = 3;
	
	while ( true )
	{
		if ( level.assaultingPlayer < assaultCount )
		{
			self.goalradius = 512;
			self setGoalEntity ( level.player );
			self thread assaultQueueDeathWaiter();
			return;
		}
		
		goalVolume = getEnt( "volume_stationlower", "targetname" );
		goalNode = getNode( goalVolume.target, "targetname" );
		self setGoalNode( goalNode );
		self setGoalVolume( goalVolume );
		self.goalradius = goalNode.radius;

		wait ( 1.0 );
	}
}


assaultQueueDeathWaiter()
{
	level.assaultingPlayer++;
	self waittill ( "death" );
	level.assaultingPlayer--;
}


Setup_Tank()
{
	level.tank.script_turretmg = true;
	level.tank startEngineSound();

	level.tank thread Tank_TargetPicker();
	level.tank thread Tank_DeathWaiter();
	level.tank thread Tank_SetupStickBombs();
	thread maps\_vehicle::gopath(level.tank);
}


Tank_DeathWaiter()
{
	self waittill ("death");
	
	flag_set("destroyed tank");
	getEnt( "trigger_supplydepot", "script_noteworthy" ) notify ( "trigger" );
}


Tank_TargetPicker()
{
	self endon ( "death" );
	self endon ( "explosives planted" );

	self.script_turret = false;
	playerHid = false;
	while ( true )
	{
		tankTarget = getClosestAI( self.origin, "allies" );

		if ( ( distance( self.origin, level.player.origin ) < 600 && !playerHid ) || !isDefined( tankTarget ))
			tankTarget = level.player;

		self setTurretTargetEnt ( tankTarget, (0,0,64) );
		targetNotify = self waittill_any( "turret_on_target", "turret_on_vistarget" );

		if ( tankTarget == level.player && targetNotify == "turret_on_target" )
			playerHid = true;
		else
			playerHid = false;

		if( isAlive( tankTarget ) )
		{
			wait ( randomFloatRange( 1.0, 2.0 ) );
			self fireTurreT();
			wait ( randomFloatRange( 3.0, 6.0 ) );
		}
	}
}

Tank_SetupStickBombs()
{
	self endon ( "death" );

	self.bombTriggers = [];
	self.bombs = [];

	tags = [];
	tags[0] = "tag_engine_left";
	tags[1] = "tag_left_wheel_07";
	tags[2] = "tag_right_wheel_07";
	location_angles = [];
	location_angles[0] = (90,0,0);
	location_angles[1] = (0,0,0);
	location_angles[2] = (180,0,0);

	for ( index = 0; index < tags.size; index++ )
	{
		bomb = spawn( "script_model", self getTagOrigin( tags[index] ) );
		bomb setModel( "xmodel/weapon_stickybomb_obj" );
		bomb.angles = location_angles[index];
		bomb linkTo( self, tags[index] );

		bomb.trigger = undefined;

		triggers = getEntArray( "sticky_trigger", "targetname" );
		for ( triggerId = 0; triggerId < triggers.size; triggerId++ )
		{
			if ( !isDefined( triggers[triggerId].inuse ) )
			{
				bomb.trigger = triggers[triggerId];
				break;
			}
		}

		assert( isDefined( bomb.trigger ) );
		bomb.trigger.inuse = true;

		bomb.trigger.oldorigin = bomb.trigger.origin;
		bomb.trigger.origin = bomb.origin;
		if ( !isDefined( bomb.trigger.linktoenable ) )
			bomb.trigger enableLinkTo();

		bomb.trigger.linktoenable = true;
		bomb.trigger linkTo( bomb );

		self.bombs[index] = bomb;
		self thread Tank_StickyBombWait( bomb.trigger, index );
	}

	self waittill ( "explosives planted", bombID );

	iprintlnbold (&"SCRIPT_EXPLOSIVESPLANTED");

	level.inv_sticky maps\_inventory::inventory_destroy();
	bomb = self.bombs[bombID];

	level thread remove_stickys( self.bombs, bombID );

	bomb setModel( "xmodel/weapon_stickybomb" );
	bomb playSound( "explo_plant_rand" );
	bomb playLoopSound( "bomb_tick" );

	self stopwatch( bomb );

	bomb playsound( "explo_mine" );
	radiusDamage (bomb.origin, 128, 100, 50);

	playFx( level._effect["tankbomb"], bomb.origin, anglesToForward( bomb.angles ) );
	wait ( 0.5 );
	self notify ("death", level.player);
	
	bomb delete();
}


Tank_StickyBombWait( trigger, id )
{
	self endon ( "death");
	self endon ( "explosives planted" );
	
	trigger setHintString( &"SCRIPT_PLATFORM_HINTSTR_PLANTEXPLOSIVES" );
	
	trigger waittill ("trigger");

	level notify ( "explosives planted" );
	self notify ( "explosives planted", id );
	return;
}

remove_stickys( bombs, id )
{
	if ( !isDefined( id ) )
		id = 1000; // a value that will never match
		
	for ( index = 0; index < bombs.size; index++ )
	{
		if ( !isDefined( bombs[index] ) )
			continue;
			
		bombs[index].trigger unLink();
		bombs[index].trigger.inuse = undefined;
		bombs[index].trigger.origin =  bombs[index].trigger.oldorigin;

		if (index != id)
			bombs[index] delete();
	}
}


stopWatch( bomb )
{
	if (isdefined (self.bombstopwatch))
		self.bombstopwatch destroy();
	self.bombstopwatch = maps\_utility::getstopwatch(60);
	level.timersused++;
	wait level.explosiveplanttime;
	bomb stoploopsound ("bomb_tick");
	level.timersused--;
	if (level.timersused < 1)
	{
		if (isdefined (self.bombstopwatch))
			self.bombstopwatch destroy();
	}
}


WindowSpawners()
{
	flag_wait( "hardpoint 3 cleared" );
	
	trigger = getEnt( "trigger_windowspawners", "script_noteworthy" );
	if ( isDefined( trigger ) )
		trigger delete();
}


FinalAssault()
{
	level endon( "hardpoint 2 cleared" );
	
	level.doFinalAssault = false;
	flag_wait( "hardpoint 1 cleared" );
	flag_wait( "hardpoint 3 cleared" );
	
	wait ( 120.0 );
	
	level.doFinalAssault = true;
}


getSoldier( animname )
{
	while ( true )
	{
		soldier = undefined;
		exclude = [];
		soldiers = getAIArray( "allies" );
		
		for ( index = 0; index < soldiers.size; index++ )
		{
			soldier = getClosestExclude( level.player.origin, soldiers, exclude );

			if ( !isDefined( soldier ) )
				continue;
				
			if ( isDefined( soldier.animname ) && soldier.animname != animname )
			{
				exclude[exclude.size] = soldier;
				soldier = undefined;
			}
		}
		
		if ( isDefined( soldier ) )
		{
			soldier.animname = animname;
			return ( soldier );
		}

		wait ( 0.25 );
	}
}

dialog_charge()
{
	soldier = getSoldier( "soldier4" );
	
	soldier thread magic_bullet_shield();
	soldier anim_single_solo( soldier, "stationhouse" );
	soldier anim_single_solo( soldier, "letsgocomrades" );
	soldier notify ( "stop magic bullet shield" );
}

dialog_hardpoint1()
{
	soldier = getSoldier( "soldier4" );
	
	soldier thread magic_bullet_shield();
	soldier anim_single_solo( soldier, "supplyobjective" );
	soldier notify ( "stop magic bullet shield" );
}

dialog_hardpoint2()
{
	soldier = getSoldier( "soldier4" );
	
	soldier thread magic_bullet_shield();
	soldier anim_single_solo( soldier, "hardpointobjective" );
	soldier notify ( "stop magic bullet shield" );
}

dialog_hardpoint3()
{
	soldier = getSoldier( "soldier3" );
	
	soldier thread magic_bullet_shield();
	soldier anim_single_solo( soldier, "mgobjective" );
	soldier notify ( "stop magic bullet shield" );
}

dialog_victory()
{
	soldier = getSoldier( "soldier3" );
	
	soldier thread magic_bullet_shield();
	soldier animscripts\shared::SetInCombat();
	wait ( 1.0 );
	soldier anim_single_solo( soldier, "backtostation" );
	soldier notify ( "stop magic bullet shield" );
}

dialog_intro()
{
	soldier = getEnt( "pipe_closing_russian", "targetname" );
	soldier thread maps\_anim::anim_loop_solo ( soldier, "idle", undefined, "stopidle" );

	level waittill ( "starting final intro screen fadeout" );
	
	soldier notify ( "stopidle" );
	soldier anim_single_solo( soldier , "okcomrade" );
	soldier thread maps\_anim::anim_loop_solo ( soldier, "idle", undefined, "stopidle" );
}

dialog_counterattack()
{
	soldier = getSoldier( "soldier4" );
	
	soldier thread magic_bullet_shield();
	soldier anim_single_solo( soldier, "atallcosts" );
	soldier notify ( "stop magic bullet shield" );
}

dialogue_tankobj()
{
	soldier = getSoldier( "soldier4" );
	
	soldier thread magic_bullet_shield();
	soldier anim_single_solo( soldier, "panzerse" );
	wait ( 4.0 );
	soldier anim_single_solo( soldier, "stickybombs" );
	wait ( 8.0 );
	soldier anim_single_solo( soldier, "tanktose" );
	soldier notify ( "stop magic bullet shield" );
}

music()
{
	//soviet_tension_light
	
	level endon ("nearing the battle");
	level waittill ( "pipe closed" );
	
	while(1)
	{
		musicplay("soviet_tension_light01");
		wait 163;
	}
}

music_stoptension()
{
	musicStopTrig = getent("stoptensionmusic", "targetname");
	musicStopTrig waittill ("trigger");
	
	level notify ("nearing the battle");
	musicstop(24);
}

music_victory()
{	
	level waittill ("absolute victory");
	
	musicplay("soviet_victory_light01");
	
	cjPoints = getEntArray( "cj_origin", "targetname" );
	
	cjPoint = getClosest( level.player.origin, cjPoints );
	cjNodes = getNodeArray( cjPoint.target, "targetname" );
	
	allies = getAIArray( "allies" );
	for ( index = 0; index < allies.size; index++ )
	{
		allies[index].goalradius = 32;
		allies[index] setGoalNode( cjNodes[index] );
	}
	
	while ( distance( level.player.origin, cjPoint.origin ) > 384 )
		wait ( 0.1 );
	
	flag_set( "rendezvous" );
	
	dialog_victory();
	
	maps\_endmission::nextmission();
}

victory()
{
	flag_wait( "destroyed tank" );
	flag_wait( "hardpoint 1 cleared" );
	flag_wait( "hardpoint 2 cleared" );
	flag_wait( "hardpoint 3 cleared" );	
	
	//Kill any remaining enemy troops in the area
	aAxis = getaiarray("axis");
	for(i=0; i<aAxis.size; i++)
		aAxis[i] doDamage (aAxis[i].health + 10050, aAxis[i].origin);
	
	flag_set( "absolute victory" );
}


