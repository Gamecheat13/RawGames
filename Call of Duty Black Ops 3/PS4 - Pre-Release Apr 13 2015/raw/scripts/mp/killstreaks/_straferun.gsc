#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\gametypes\_battlechatter;


#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\_vehicle;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_dogs;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;



#precache( "string", "MP_EARNED_STRAFERUN" );
#precache( "string", "KILLSTREAK_STRAFERUN_NOT_AVAILABLE" );
#precache( "string", "MP_WAR_STRAFERUN_INBOUND" );
#precache( "string", "MP_WAR_STRAFERUN_INBOUND_NEAR_YOUR_POSITION" );
#precache( "eventstring", "mpl_killstreak_straferun" );
#precache( "fx", "killstreaks/fx_wh_contrail" );
#precache( "fx", "killstreaks/fx_wh_chaff_trail" );
#precache( "fx", "killstreaks/fx_vtol_exp" );
#precache( "fx", "killstreaks/fx_wh_chaff_trail" );

#namespace straferun;

function init()
{
	level.strafeRunNumRockets = 8;
	level.strafeRunRocketDelay = 0.35;
	level.strafeRunGunLookahead = 4000;
	level.strafeRunGunOffset = -800;
	level.strafeRunGunRadius = 500;
	level.strafeRunExitUnits = 20000;
	level.strafeRunMaxStrafes = 6;
	level.strafeRunFlareDelay = 2;
	level.strafeRunShellShockDuration = 2.5;
	level.strafeRunShellShockRadius = 512;
	level.strafeRunKillsBeforeExit = 10;
	level.strafeRunNumKillcams = 5;

	level.strafeRunModel = "veh_t6_air_a10f";
	level.strafeRunModelEnemy = "veh_t6_air_a10f_alt";
	level.strafeRunVehicle = "vehicle_straferun_mp";
	level.strafeRunGunWeapon = GetWeapon( "straferun_gun" );
	level.strafeRunGunSound = "wpn_a10_shot_loop_npc";
	level.strafeRunRocketWeapon = GetWeapon( "straferun_rockets" );
	level.strafeRunRocketTags = [];
	level.strafeRunRocketTags[0] = "tag_rocket_left";
	level.strafeRunRocketTags[1] = "tag_rocket_right";
	level.strafeRunContrailFX = "killstreaks/fx_wh_contrail";
	level.strafeRunChaffFX = "killstreaks/fx_wh_chaff_trail";
	level.strafeRunExplodeFX = "killstreaks/fx_vtol_exp";
	level.strafeRunExplodeSound = "evt_helicopter_midair_exp";
	level.strafeRunShellShock = "straferun";
	
	killstreaks::register( "straferun", "straferun", "killstreak_straferun", "straferun_used",&useKillstreakStrafeRun, true);
	killstreaks::register_strings( "straferun", &"MP_EARNED_STRAFERUN", &"KILLSTREAK_STRAFERUN_NOT_AVAILABLE", &"MP_WAR_STRAFERUN_INBOUND", &"MP_WAR_STRAFERUN_INBOUND_NEAR_YOUR_POSITION" );
	killstreaks::register_dialog( "straferun", "mpl_killstreak_straferun", "kls_straferun_used", "","kls_straferun_enemy", "", "kls_straferun_ready");
	killstreaks::register_tos_dvar( "scr_teamops" );
	killstreaks::register_alt_weapon( "straferun", level.strafeRunGunWeapon.name );
	killstreaks::register_alt_weapon( "straferun", level.strafeRunRocketWeapon.name );
	killstreaks::set_team_kill_penalty_scale( "straferun", 0.0 );

	// killcams are created on level start and live all game
	createKillcams( level.strafeRunNumKillcams, level.strafeRunNumRockets );
}

function PlayPilotDialog( dialog )
{

	soundAlias = level.teamPrefix[self.team] + self.pilotVoiceNumber + "_" + dialog;
	
	while( isdefined( self.owner ) && self.owner.pilotisSpeaking )
	{
		wait ( .2 );
	}
	
	if ( isdefined( self.owner ) )
	{
		self.owner playLocalSound(soundAlias);
		self.owner.pilotisSpeaking = true;
		self.owner thread battlechatter::wait_playback_time( soundAlias ); 
		self.owner util::waittill_any( soundAlias, "death", "disconnect" );
		if ( isdefined( self.owner ) )
		{
			self.owner.pilotisSpeaking = false;
		}
	}
	
	
}
	
function useKillstreakStrafeRun( hardpointType )
{
	startNode = GetVehicleNode( "warthog_start", "targetname" );
	if ( !isdefined( startNode ) )
	{
/#		println( "ERROR: Strafe run vehicle spline not found!" );	#/
		return false;
	}
	
	killstreak_id = self killstreakrules::killstreakStart( "straferun", self.team, false, false );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	

	// Spawn and setup vehicle
	plane = SpawnVehicle( level.strafeRunVehicle, startNode.origin, (0,0,0), "straferun" );
	
	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
		plane.teamops = true;
	
	plane.attackers = [];
	plane.attackerData = [];
	plane.attackerDamage = [];
	plane.flareAttackerDamage = [];
	plane SetTeam( self.team );
	plane SetEnemyModel( level.strafeRunModelEnemy );
	plane.team = self.team;
	plane MakeVehicleUnusable();
	plane thread cleanupOnDeath( plane.team );
	plane.health = 999999;
	plane.maxhealth = 999999;
	plane clientfield::set( "enemyvehicle", 1 );
	
	plane SetOwner( self );
	plane.owner = self;
	
	
	plane.numStrafes = 0;
	plane.killstreak_id = killstreak_id;
	plane.numFlares = 2;
	plane.fx_flare = "killstreaks/fx_wh_chaff_trail";
	plane.soundMod = "straferun";	
	plane SetDrawInfrared( true );

	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
	{
		plane.straferunKills = 0;
		plane.strafeRunbda = 0;
	}
	else
	{
		self.straferunKills = 0;
		self.strafeRunbda = 0;
	}

	self.pilotisSpeaking = false;	
	plane.pilotVoiceNumber = self.bcVoiceNumber + 1;
	if 	(plane.pilotVoiceNumber > 3) 
	{
		plane.pilotVoiceNumber = 0;
	}
	self killstreaks::play_killstreak_start_dialog( "straferun", self.pers["team"] );
	self AddWeaponStat( GetWeapon( "straferun" ), "used", 1 );

	//play pilot dialog
	plane thread PilotDialogWait ("a10_used", 2.5);	

	// make targetable
	Target_Set( plane, (0,0,0) );
	Target_SetTurretAquire( plane, false );
	
	//plane thread playContrail();
	
	// Setup vehicle weapons
	//plane setVehWeapon( level.strafeRunGunWeapon );
	plane.gunSoundEntity = spawn( "script_model", plane GetTagOrigin( "tag_flash" ) );
	plane.gunSoundEntity LinkTo( plane, "tag_flash", (0,0,0), (0,0,0) );
	
	//plane.killCamEntities = level.strafeRunKillcams.strafes;
	
	plane resetKillcams();


	if( GetDvarInt( "teamOpsEnabled" ) == 0 )
		plane thread watchForOtherKillstreaks();

	plane thread watchForKills();
	plane thread watchdamage();
	plane thread doStrafeRuns();
	plane thread vehicle::follow_path( startNode );
	plane thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("death");	

	if( GetDvarInt( "teamOpsEnabled" ) == 0 )
		plane thread watchForOwnerExit( self );

	return true;
}

function playContrail()
{
	self endon( "death" );
	
	wait( 0.1 );
	PlayFXOnTag( level.strafeRunContrailFX, self, "tag_origin" );
	self playloopsound ("veh_a10_engine_loop", 1);
}

function cleanupOnDeath( team )
{	
	self waittill( "death" );
	
	killstreakrules::killstreakStop( "straferun", team, self.killstreak_id );
	
	if( isdefined( self.gunSoundEntity ) )
	{
		self.gunSoundEntity StopLoopSound();
		self.gunSoundEntity Delete();
		self.gunSoundEntity = undefined;
	}
}

function watchdamage()
{
	self endon( "death" );

	self.maxhealth = 999999;
	self.health = self.maxhealth;
	self.maxhealth = 1000;
	
	low_health = false;
	damage_taken = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );
		
		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;
		
/#
		self.damage_debug = ( damage + " (" + weapon.name + ")" );
#/
		
		if ( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
		{
			damage += 1000;
		}	
			
		self.attacker = attacker;

		damage_taken += damage;

			
		if ( damage_taken >= 1000 )
		{
			self thread explode();

			if( GetDvarInt( "teamOpsEnabled" ) == 0 )
			{			
				if ( self.owner util::IsEnemyPlayer( attacker ) )
				{
					attacker challenges::addFlySwatterStat( weapon, self );
				}
				else
				{
					//Destroyed Friendly Killstreak 
				}
			}

			return;
		}
	}
}

function watchForOtherKillstreaks()
{
	self endon( "death" );

	for ( ;; )
	{
		level waittill( "killstreak_started", hardpointType, teamName, attacker );
		if ( !isdefined ( self.owner ) ) 
		{
			self thread explode();
			return;
		}

		if ( hardpointType == "emp" )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) ) 
			{
				self thread explode();
				attacker challenges::addFlySwatterStat( hardpointType, self );
				return;
			}
		}
		else if ( hardpointType == "missile_swarm" )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) ) 
			{
				self.leaveNextTime = true;
			}
		}
	}
}

function watchForKills()
{
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "killed", player );
		if ( IsPlayer( player ) )
		{
			//IPrintLnBold( "STRAFE RUN KILLED PLAYER\n" );
			
		}
		else
		{
			//IPrintLnBold( "STRAFE RUN KILLED SOMETHING ELSE\n" );
			//self.bda = self.bda + 1;
		}
	}
}

function watchForOwnerExit( owner )
{
	self endon( "death" );
	
	owner util::waittill_any( "disconnect", "joined_team", "joined_spectator");
	self.leaveNextTime = true;
}

function addStraferunKill()
{
	if ( !isdefined( self.straferunKills ) )
	{
		self.straferunKills = 0;
	}
	self.straferunKills++;	
}

function doStrafeRuns()
{
	self endon( "death" );
	
	//self thread fireFlares();
	
	for ( ;; )
	{
		self waittill( "noteworthy", noteworthy, noteworthyNode );
		if ( noteworthy == "strafe_start" )
		{
			self.strafeRunGunLookahead = level.strafeRunGunLookahead;
			self.strafeRunGunRadius = level.strafeRunGunRadius;
			self.strafeRunGunOffset = level.strafeRunGunOffset;
			
/#
			self.strafeRunGunLookahead = GetDvarInt( #"scr_straferunlookahead", level.strafeRunGunLookahead ); 
			self.strafeRunGunRadius = GetDvarInt( #"scr_straferunradius", level.strafeRunGunRadius ); ;
			self.strafeRunGunOffset = GetDvarInt( #"scr_straferunoffset", level.strafeRunGunOffset ); ;
#/
			
			if ( isdefined( noteworthyNode ) )
			{
				if ( isdefined( noteworthyNode.script_parameters ) )
				{
					self.strafeRunGunLookahead = float( noteworthyNode.script_parameters );
				}
				
				if ( isdefined( noteworthyNode.script_radius ) )
				{
					self.strafeRunGunRadius = float( noteworthyNode.script_radius );
				}
					
				if ( isdefined( noteworthyNode.script_float ) )
				{
					self.strafeRunGunOffset = float( noteworthyNode.script_float );
				}
			}
			if( isdefined( self.owner ) )
			{
				self thread startStrafe( );
			}
		}
		else if ( noteworthy == "strafe_stop" )
		{
			self stopStrafe();
		
		}
		else if ( noteworthy == "strafe_leave" )
		{
	
			if ( self shouldLeaveMap() )
			{
				self thread leaveMap();
				//play pilot dialog
				self thread PilotDialogWait( "a10_leave", 5 );					
			}
			else
			{
				//play pilot dialog
				self thread PilotDialogWait( "a10_strafe", 3 );	
			}
		}
	}
}

function fireFlares()
{
	self endon( "death" );
	self endon( "strafe_start" );
	
	wait( 0.1 );
	
	for ( ;; )
	{
		chaff_fx = spawn( "script_model", self.origin );
		chaff_fx.angles = (0,180,0);
		chaff_fx SetModel( "tag_origin" );
		chaff_fx LinkTo( self , "tag_origin", (0,0,0), (0,0,0) );
		
		wait( 0.1 );
		
		PlayFXOnTag( level.strafeRunChaffFX, chaff_fx, "tag_origin" );
		chaff_fx playsound ("wpn_a10_drop_chaff");
		
		chaff_fx thread util::deleteAfterTimeThread( level.strafeRunFlareDelay );
		
		wait( level.strafeRunFlareDelay );
	}
}

function startStrafe(  )
{
	self endon( "death" );
	self endon( "strafe_stop" );
	
	if ( isdefined( self.strafing ) )
	{
		IPrintLnBold( "TRYING TO STRAFE WHEN ALREADY STRAFING!\n" );
		return;
	}
	self.strafing = true;

	//PlayPilotDialog("kls_hit");	
	self thread PilotDialogWait ("kls_hit", 3.5);
	
	// First strafe
	if ( self.numStrafes == 0 )
	{
		self firstStrafe();
	}
	
	self thread fireRockets();
	
	self thread startStrafeKillcams();

//	self planeSounds( undefined, "evt_flyby_apex_2362", "evt_flyby_wash_2362", 2362 ); 

	count = 0;
	weaponShootTime = level.strafeRunGunWeapon.fireTime;
	for ( ;; )
	{
		gunOrigin = self GetTagOrigin( "tag_flash" );
		gunOrigin += ( 0, 0, self.strafeRunGunOffset );
		forward = AnglesToForward( self.angles );
		forwardNoZ = VectorNormalize( (forward[0],forward[1],0) );
		right = weaponobjects::vectorcross( forwardNoZ, (0,0,1) );
		perfectAttackStartVector = gunOrigin + VectorScale( forwardNoZ, self.strafeRunGunLookahead );
		attackStartVector = perfectAttackStartVector + VectorScale( right, RandomFloatRange( 0-self.strafeRunGunRadius, self.strafeRunGunRadius ) );

		trace = BulletTrace( attackStartVector, (attackStartVector[0],attackStartVector[1],-500), false, self, false, true );
		self SetTurretTargetVec( trace["position"] );
		self FireWeapon();
		//self.gunSoundEntity PlayLoopSound( level.strafeRunGunSound );
		self shellShockPlayers( trace["position"] );
		
/#
		if (  GetDvarInt( #"scr_devStrafeRunBulletsDebugDraw", 0 ) )
		{
			time = 300;
			airsupport::debug_line( attackStartVector, trace["position"] - ( 0,0,20 ), (1,0,0), time, false );
			if( count % 30 == 0 )
			{
				trace = BulletTrace( perfectAttackStartVector, (perfectAttackStartVector[0],perfectAttackStartVector[1],-100000), false, self, false, true );
				airsupport::debug_line( trace["position"] + ( 0,0,20 ), trace["position"] - ( 0,0,20 ), (0,0,1), time, false );
			}
		}
#/
		count++;
		wait weaponShootTime;
	}
	
}

function firstStrafe()
{
	/*Target_Set( self );
	Target_SetTurretAquire( self, true );*/
}

function fireRockets()
{
	self notify( "firing_rockets" );
	
	self endon( "death" );
	self endon( "strafe_stop" );
	self endon( "firing_rockets" );

	if( GetDvarInt( "teamOpsEnabled" ) == 0 )
		self.owner endon( "disconnect" );
	
	forward = anglesToForward( self.angles );
	
	self.firedRocketTargets = [];
	
	for ( rocketIndex = 0 ; rocketIndex < level.strafeRunNumRockets ; rocketIndex++ )
	{
		rocketTag = level.strafeRunRocketTags[rocketIndex%level.strafeRunRocketTags.size];
		
		// If possible, choose the highest priority target we haven't already fired a rocket at, otherwise just choose the highest priority target
		targets = getValidTargets();
		rocketOrigin = self GetTagOrigin( rocketTag );
		targetOrigin = rocketOrigin + forward * 10000;
		if ( targets.size > 0 )
		{
			selectedTarget = undefined;
			foreach( target in targets )
			{
				alreadyAttacked = false;
				foreach( oldTarget in self.firedRocketTargets )
				{
					if ( oldTarget == target )
					{
						alreadyAttacked = true;
						break;
					}
				}
				if ( !alreadyAttacked )
				{
					selectedTarget = target;
					break;
				}
			}
			
			if ( isdefined( selectedTarget ) )
			{
				self.firedRocketTargets[self.firedRocketTargets.size] = selectedTarget;
	
				// do dead reconing on the target
				targetOrigin = deadReconTargetOrigin( rocketOrigin, selectedTarget );
			}
		}
		
		rocketOrigin = self GetTagOrigin( rocketTag );
		
		rocket = MagicBullet( level.strafeRunRocketWeapon, rocketOrigin, rocketOrigin + forward, self.owner );
		if( GetDvarInt( "teamOpsEnabled" ) == 1 )
			rocket.teamops = true;

		if ( isdefined( selectedTarget ) )
		{
			rocket missile_settarget( selectedTarget, (0,0,0) );
		}
		rocket.soundMod = "straferun";
	
		rocket attachKillcamToRocket( level.strafeRunKillcams.rockets[rocketIndex], selectedTarget, targetOrigin );
		
/#
		if ( GetDvarInt( #"scr_devStrafeRunKillcamsDebugDraw", 0 ) )
			rocket thread airsupport::debug_draw_bomb_path( undefined, (0,0.5,0), 400 );
#/

		wait level.strafeRunRocketDelay;
	}
}

function stopStrafe()
{
	self notify( "strafe_stop" );
	
	self.strafing = undefined;
	
	// after the strafe run is done reset the killcams for the next strafe
	self thread resetKillcams( 3 );

	self ClearTurretTarget();

	if( GetDvarInt( "teamOpsEnabled" ) == 1 )
		owner = self;
	else 
		owner = self.owner;
	
	if( !isdefined( owner ) )
		return;

	//self thread fireFlares();

	//TODO Add the negative BDA lines after they are recorded.
	if( GetDvarInt( "teamOpsEnabled" ) == 0 )
	{
		if (owner.strafeRunbda == 0)
		{
			bdaDialog = "kls_killn";
		}
		if (owner.strafeRunbda == 1)
		{
			bdaDialog = "kls_kill1";
		}
		if (owner.strafeRunbda == 2)
		{
			bdaDialog = "kls_kill2";
		}
		if (owner.strafeRunbda == 3)
		{
			bdaDialog = "kls_kill3";
		}
		if (owner.strafeRunbda > 3)
		{
			bdaDialog = "kls_killm";
		}	
	
		if (isdefined(bdaDialog))
		{
			//play pilot dialog
			self thread PilotDialogWait( bdaDialog, 3.5 );	
		}
	}
	
	owner.strafeRunbda = 0;	
	
	self.gunSoundEntity StopLoopSound();
	self.gunSoundEntity playsound ("wpn_a10_shot_decay_npc");
	self.numStrafes++;
}

function PilotDialogWait( Dialog, time )
{
	self endon( "death" );
	if (isdefined(time))
	{
		wait time;
	}

	if( GetDvarInt( "teamOpsEnabled" ) == 0 )
		PlayPilotDialog( Dialog );
}

function shouldLeaveMap()
{
	if ( isdefined( self.leaveNextTime ) && self.leaveNextTime )
	{
		return true;
		
		//PlayPilotDialog("a10_used");		
	
	}
	
	if ( self.numStrafes >= level.strafeRunMaxStrafes )
	{
		return true;
	}
	
	if( GetDvarInt( "teamOpsEnabled" ) == 1)
	{
		if( self.straferunKills >= level.strafeRunKillsBeforeExit )
		{
			return true;	
		}
	}
	else
	{
		if( self.owner.straferunKills >= level.strafeRunKillsBeforeExit )
		{
			return true;	
		}
	}
	
	return false;
}

function leaveMap()
{
	self unlinkKillcams();
	
	exitOrigin = self.origin + VectorScale( AnglesToForward( self.angles ), level.strafeRunExitUnits );
	
	/*self ClearTargetYaw();
	self ClearGoalYaw();*/
	self SetYawSpeed( 5, 999, 999 );
	self SetVehGoalPos( exitOrigin, 1 );
	
	wait 5;
	if ( isdefined ( self ) )
	{
		self Delete();
	}
}

function explode()
{
	self endon( "delete" );

	forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
	PlayFX( level.strafeRunExplodeFX, self.origin, forward );
	
	// play heli explosion sound
	self PlaySound( level.strafeRunExplodeSound );
	
	wait( 0.1 );
	
	if ( IsDefined( self ) )
	{
		self Delete();
	}
}

function canTargetEntity( entity )
{
	/*if ( distance( entity.origin, self.origin ) > level.heli_visual_range )
	{
		return false;
	}*/
	
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	visible_amount = entity sightConeTrace( heli_turret_point, self );
	
	if ( visible_amount < level.heli_target_recognition )
	{
		return false;
	}
	
	return true;
}

function canTargetPlayer( player )
{
	if ( !IsAlive( player ) || player.sessionstate != "playing" )
	{
		return false;
	}
	
	if ( player == self.owner )
	{
		return false;
	}

	if ( player airsupport::canTargetPlayerWithSpecialty() == false ) 
	{
		return false;
	}
	
	if ( !isdefined( player.team ) )
	{
		return false;
	}
	
	if ( level.teamBased && player.team == self.team )
	{
		return false;
	}
	
	if ( player.team == "spectator" )
	{
		return false;
	}
	
	if ( isdefined( player.spawntime ) && ( GetTime() - player.spawntime )/1000 <= level.heli_target_spawnprotection )
	{
		return false;
	}
		
	if ( !targetInFrontOfPlane( player ) )
	{
		return false;	
	}
	
	if ( player IsInMoveMode( "noclip" ))
	{
		return false;	
	}
	
	return canTargetEntity( player );
}

function canTargetActor( actor )
{
	if ( !isdefined( actor ) )
	{
		return false;
	}
	
	if ( level.teamBased && ( actor.team == self.team ) )
	{
		return false;
	}
	
	if ( isdefined( actor.script_owner ) && self.owner == actor.script_owner )
	{
		return false;
	}
	
	if ( !targetInFrontOfPlane( actor ) )
	{
		return false;	
	}
	
	return canTargetEntity( actor );
}

function targetInFrontOfPlane( target )
{
	forward_dir = AnglesToForward(self.angles);
	target_delta = VectorNormalize( target.origin - self.origin );
	dot = VectorDot( forward_dir, target_delta );
	
	// 60 degrees
	if ( dot < 0.5 )
		return true;
		
	return true;
}

function getValidTargets()
{
	targets = [];
	foreach( player in level.players )
	{
		if ( self canTargetPlayer( player ) )
		{
			if( isdefined( player ) )
				targets[targets.size] = player;
		}
		
	}
	
	dogs = dogs::dog_manager_get_dogs();
	
	foreach( dog in dogs )
	{
		if ( self canTargetActor( dog ) )
		{
			targets[targets.size] = dog;
		}
	}
	
	tanks = GetEntArray( "talon", "targetname" );
	
	foreach( tank in tanks )
	{
		if ( self canTargetActor( tank ) )
		{
			targets[targets.size] = tank;
		}
	}
	
	return targets;
}

function deadReconTargetOrigin( rocket_start, target )
{
	target_velocity = target GetVelocity();
	
	// would be nice to get this from the gdt.
	missile_speed = 7000;
	
	target_delta = target.origin - rocket_start;
	
	target_dist = Length( target_delta );
	
	time_to_target = target_dist / missile_speed;
	
	return target.origin + target_velocity * time_to_target;
}

function shellShockPlayers( origin )
{
	foreach( player in level.players )
	{
		if ( !IsAlive( player ) )
		{
			continue;
		}
		
		if ( player == self.owner )
		{
			continue;
		}
		
		if ( !isdefined( player.team ) )
		{
			continue;
		}
		
		if ( level.teamBased && player.team == self.team )
		{
			continue;
		}
		
		if ( DistanceSquared( player.origin, origin ) <= level.strafeRunShellShockRadius * level.strafeRunShellShockRadius )
		{
			player thread strafeRunShellShock();
		}
	}
}

function strafeRunShellShock()
{
	self endon( "disconnect" );
	
	if ( isdefined( self.beingStrafeRunShellShocked ) && self.beingStrafeRunShellShocked )
	{
		return;
	}
	
	self.beingStrafeRunShellShocked = true;
	
	self ShellShock( level.strafeRunShellShock, level.strafeRunShellShockDuration );
	wait( level.strafeRunShellShockDuration + 1 );
	
	self.beingStrafeRunShellShocked = false;
}

function createKillcams( numKillcams, numRockets )
{
	// killcams are only created once per level
	if ( !isdefined(level.strafeRunKillcams) )
	{
		level.strafeRunKillcams = SpawnStruct();
		
		level.strafeRunKillcams.rockets = [];
		for ( i = 0; i < numRockets; i++ )
		{
			level.strafeRunKillcams.rockets[level.strafeRunKillcams.rockets.size] = createKillcamEnt( );
		}
		
		level.strafeRunKillcams.strafes = [];
		for ( i = 0; i < numKillcams; i++ )
		{
			level.strafeRunKillcams.strafes[level.strafeRunKillcams.strafes.size] = createKillcamEnt( );
/#
		if ( GetDvarInt( #"scr_devStrafeRunKillcamsDebugDraw", 0 ) )
			level.strafeRunKillcams.strafes[i] thread airsupport::debug_draw_bomb_path( undefined, (0,0,0.5), 200 );
#/	
		}
	}
	
}

function resetKillcams( time )
{
	self endon( "death" );
	
	if ( isdefined( time ) )
		wait( time );
		
	for ( i = 0; i < level.strafeRunKillcams.rockets.size; i++ )
	{
		level.strafeRunKillcams.rockets[i] resetRocketKillcamEnt( self, i );
	}
	
	for ( i = 0; i < level.strafeRunKillcams.strafes.size; i++ )
	{
		level.strafeRunKillcams.strafes[i] resetKillcamEnt( self );
	}
}

function unlinkKillcams()
{
	for ( i = 0; i < level.strafeRunKillcams.rockets.size; i++ )
	{
		level.strafeRunKillcams.rockets[i] unlink();
	}
	
	for ( i = 0; i < level.strafeRunKillcams.strafes.size; i++ )
	{
		level.strafeRunKillcams.strafes[i] unlink();
	}
}

function createKillcamEnt()
{
	killCamEnt = spawn( "script_model", (0,0,0)  );
	//killCamEnt thread deleteWhenParentDies( self );
	
	killCamEnt SetFOVForKillcam( 25 );
	
	return killCamEnt;
}

function resetKillcamEnt( parent )
{
	self notify( "reset" );
	parent endon( "death" );
	
	offset_x = GetDvarInt( #"scr_killcamplaneoffsetx", -3000 );
	offset_y = GetDvarInt( #"scr_killcamplaneoffsety", 0 );
	offset_z = GetDvarInt( #"scr_killcamplaneoffsetz", 740 );
	
	self linkto( parent, "tag_origin", (offset_x, offset_y, offset_z), (10,0,0) );
	self thread unlinkWhenParentDies( parent );
}

function resetRocketKillcamEnt( parent, rocketIndex )
{
	self notify( "reset" );
	parent endon( "death" );
	
	offset_x = GetDvarInt( #"scr_killcamplaneoffsetx", -3000 );
	offset_y = GetDvarInt( #"scr_killcamplaneoffsety", 0 );
	offset_z = GetDvarInt( #"scr_killcamplaneoffsetz", 740 );

	rocketTag = level.strafeRunRocketTags[rocketIndex%level.strafeRunRocketTags.size];
	
	self linkto( parent, rocketTag, (offset_x, offset_y, offset_z), (10,0,0) );
	self thread unlinkWhenParentDies( parent );
}

function deleteWhenParentDies( parent )
{
	parent waittill("death");
	
	self delete();
}

function unlinkWhenParentDies( parent )
{
	self endon("reset");
	self endon("unlink");
	
	parent waittill("death");
	
	self unlink();
}

function attachKillcamToRocket( killCamEnt, selectedTarget, targetOrigin )
{
	offset_x = GetDvarInt( #"scr_killcamrocketoffsetx", -400 );
	offset_y = GetDvarInt( #"scr_killcamrocketoffsety", 0 );
	offset_z = GetDvarInt( #"scr_killcamrocketoffsetz", 110 );

	self.killCamEnt = killCamEnt;

	forward = VectorScale( AnglesToForward( self.angles ), offset_x );
	right = VectorScale( AnglesToRight( self.angles ), offset_y );
	up = VectorScale( AnglesToUp( self.angles ), offset_z );
	
	killCamEnt unlink();
	killCamEnt.angles = (0,0,0);
	killCamEnt.origin = self.origin;
	
	killCamEnt linkto( self, "", (offset_x,offset_y,offset_z), (9, 0, 0) );
	
	killCamEnt thread unlinkWhenClose( selectedTarget, targetOrigin, self ); 
}

function unlinkWhenClose( selectedTarget, targetOrigin, plane )
{
	plane endon( "death" );
	self notify( "unlink_when_close" );
	self endon( "unlink_when_close" );
	
	distSqr = 1000 * 1000;
	
	while ( 1 )
	{
		if ( isdefined( selectedTarget ) )
		{
			if ( DistanceSquared( self.origin, selectedTarget.origin ) < distSqr )
			{
				self unlink();
				self.angles = (0,0,0);		
				return;	
			}
		}
		else
		{
			if ( DistanceSquared( self.origin, targetOrigin ) < distSqr )
			{
				self unlink();
				self.angles = (0,0,0);		
				return;	
			}
		}
		wait( 0.1 );
	}
}

function getLookaheadOrigin( previous_origin, next_origin, lookAhead )
{
	delta = next_origin - previous_origin;
	forwardNoZ = VectorNormalize( (delta[0],delta[1],0) );
	origin = next_origin + VectorScale( forwardNoZ, lookAhead );
	return origin;
}

function strafeKillcam( parent, node, distance )
{
	parent endon("death");
	self endon( "reset" ); 
	
	// let the plane start firing
	{wait(.05);};
	
	self notify( "unlink" );
	self Unlink();
	self.angles = (0,0,0);
	
	accel_time = 0.2;
	speed = 20000;
	
	start_height_offset = -800;
	stop_height = level.mapCenter[2] - 500;

	start_origin_struct = getOriginAlongStrafePath( node, self.origin, distance );
	start_origin = start_origin_struct.origin;
	node = start_origin_struct.node;
	
	previous_origin = self.origin;
	
	start_origin = getLookaheadOrigin( previous_origin, start_origin, parent.strafeRunGunLookahead + 1000);
	
	trace = BulletTrace( (start_origin[0], start_origin[1], start_origin[2] + start_height_offset), (start_origin[0], start_origin[1], stop_height), false, parent, false, true );
	
	pathHeight = trace["position"][2];
	
	self killcamMoveto( trace["position"], speed, accel_time, pathHeight );
	
	speed = 500;

	while( isdefined(node) )
	{
		previous_origin = node.origin;
		node = GetVehicleNode( node.target, "targetname" );
	
		start_origin = getLookaheadOrigin( previous_origin, node.origin, parent.strafeRunGunLookahead + 1000 );
	
		trace = BulletTrace( (start_origin[0], start_origin[1], start_origin[2] + start_height_offset), (start_origin[0], start_origin[1], stop_height), false, parent, false, true );
		self killcamMoveto( trace["position"], speed, 0, pathHeight );
	}
}

function killcamMoveto( goal, speed, accel, pathHeight )
{
	self endon( "reset" ); 
	
	height_offset = RandomIntRange(350,450);
	origin = (goal[0], goal[1], goal[2] + height_offset );
	dist = Distance( origin, self.origin );
	time = dist / speed ;
	
	if ( accel > time )
		accel = time;
	
	self MoveTo( origin, time, accel, 0 );
	self waittill( "movedone" );	
}

function startStrafeKillcams()
{
	node = GetVehicleNode( self.currentNode.target, "targetname" );
	strafe_dist = getStrafeDistance(node);
	
	strafe_increment = strafe_dist / (level.strafeRunKillcams.strafes.size + 1); 
	current_dist = 10; // so we dont get a zero length delta on first point
	
	for ( i = 0; i < level.strafeRunKillcams.strafes.size; i++ )
	{
		level.strafeRunKillcams.strafes[i] thread strafeKillcam( self, node, current_dist );
		current_dist += strafe_increment;
		//wait( 0.5 );
	}
}

function getStrafeDistance(node)
{
	previous_node = node;
	next_node = GetVehicleNode( previous_node.target, "targetname" );

	dist = 0;
	
	//dist = Distance( ( self.origin[0], self.origin[1], 0 ), ( node.origin[0], node.origin[1], 0 ) );
	
	while ( (!isdefined(previous_node.script_noteworthy) || previous_node.script_noteworthy != "strafe_stop") && next_node != node )
	{
		dist += Distance( (previous_node.origin[0], previous_node.origin[1], 0) , ( next_node.origin[0], next_node.origin[1], 0 ) );

		previous_node = next_node;
		next_node = GetVehicleNode( previous_node.target, "targetname" );
	}
	
	return dist;
}

function getOriginAlongStrafePath(node, start_origin, distance_along)
{
	origin_node = SpawnStruct();
	
//	previous_node = node;
//	next_node = GetVehicleNode( previous_node.target, "targetname" );

//	seg_dist = Distance( (previous_node.origin[0], previous_node.origin[1], 0) , ( next_node.origin[0], next_node.origin[1], 0 ) );

	seg_dist = Distance( (start_origin[0], start_origin[1], 0) , ( node.origin[0], node.origin[1], 0 ) );
	
	dist = 0;
	
	if ( (dist + seg_dist) > distance_along )
	{
		forwardVec = VectorNormalize(  ( node.origin[0], node.origin[1], 0 ) - (start_origin[0], start_origin[1], 0) );
		origin_node.origin = start_origin + forwardVec * ( distance_along - dist );
		origin_node.node = node;
		return origin_node;
	}
	
	dist = seg_dist;
	
	previous_node = node;
	next_node = GetVehicleNode( previous_node.target, "targetname" );

	while ( (!isdefined(previous_node.script_noteworthy) || previous_node.script_noteworthy != "strafe_stop") && next_node != node )
	{
		seg_dist = Distance( (previous_node.origin[0], previous_node.origin[1], 0) , ( next_node.origin[0], next_node.origin[1], 0 ) );
	
		if ( (dist + seg_dist) > distance_along )
		{
			forwardVec = VectorNormalize( next_node.origin - previous_node.origin );
			origin_node.origin = previous_node.origin + forwardVec * ( distance_along - dist );
			origin_node.node = previous_node;
			return origin_node;
		}
		
		dist += seg_dist;
		previous_node = next_node;
		next_node = GetVehicleNode( previous_node.target, "targetname" );
	}
}