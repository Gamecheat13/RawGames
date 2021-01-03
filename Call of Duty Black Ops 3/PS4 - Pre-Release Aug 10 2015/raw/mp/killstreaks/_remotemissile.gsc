#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

#using scripts\mp\_util;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\visionset_mgr_shared;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                             










	
//#precache( "material","tow_filter_overlay_no_signal");
#precache( "material", "hud_remote_missile_target" );
#precache( "string", "KILLSTREAK_EARNED_REMOTE_MISSILE" );
#precache( "string", "KILLSTREAK_REMOTE_MISSILE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_REMOTE_MISSILE_INBOUND" );
#precache( "string", "KILLSTREAK_REMOTE_MISSILE_HACKED" );
#precache( "eventstring", "mpl_killstreak_cruisemissile" );
#precache( "fx", "killstreaks/fx_predator_trigger" );

#namespace remotemissile;



function init()
{
	level.rockets = [];
	
	killstreaks::register( "remote_missile", "remote_missile", "killstreak_remote_missile", "remote_missle_used",&tryUsePredatorMissile, true );
	killstreaks::register_alt_weapon( "remote_missile", "remote_missile_missile" );
	killstreaks::register_alt_weapon( "remote_missile", "remote_missile_bomblet" );
	killstreaks::register_strings( "remote_missile", &"KILLSTREAK_EARNED_REMOTE_MISSILE", &"KILLSTREAK_REMOTE_MISSILE_NOT_AVAILABLE", &"KILLSTREAK_REMOTE_MISSILE_INBOUND", undefined, &"KILLSTREAK_REMOTE_MISSILE_HACKED" );
	killstreaks::register_dialog( "remote_missile", "mpl_killstreak_cruisemissile", "remoteMissileDialogBundle", undefined, "friendlyRemoteMissile", "enemyRemoteMissile", "enemyRemoteMissileMultiple", "friendlyRemoteMissileHacked", "enemyRemoteMissileHacked", "requestRemoteMissile" );
	killstreaks::set_team_kill_penalty_scale( "remote_missile", level.teamKillReducedPenalty );
	killstreaks::override_entity_camera_in_demo("remote_missile", true);

	clientfield::register( "missile", "remote_missile_bomblet_fired", 1, 1, "int" );
	clientfield::register( "missile", "remote_missile_fired", 1, 2, "int" );
	
	level.missilesForSightTraces = [];

	level.missileRemoteDeployFX = "killstreaks/fx_predator_trigger";
	level.missileRemoteLaunchVert = 18000;
	level.missileRemoteLaunchHorz = 7000;
	level.missileRemoteLaunchTargetDist = 1500;
	
	visionset_mgr::register_info( "visionset", "remote_missile_visionset", 1, 110, 16, true, &visionset_mgr::ramp_in_out_thread_per_player, false  );
}

function remote_missile_game_end_think( rocket, team, killstreak_id, snd_first, snd_third )
{
	self endon( "Remotemissle_killstreak_done" );
	
	level waittill( "game_ended" );
	
	snd_first = rocket.snd_first;
	snd_third = rocket.snd_third;
	
	self player_missile_end( rocket, true, true, team, killstreak_id, snd_first, snd_third );

	self notify( "Remotemissle_killstreak_done" );
}

function tryUsePredatorMissile( lifeId )
{
	waterDepth = self depthofplayerinwater();
	
	if( !self IsOnGround() || self util::isUsingRemote() || ( waterDepth > 2 ) )
	{
		self iPrintLnBold( &"KILLSTREAK_REMOTE_MISSILE_NOT_USABLE" );
		return false;
	}

	team = self.team;
	killstreak_id = self killstreakrules::killstreakStart( "remote_missile", team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}

	returnVar = _fire( lifeId, self, team, killstreak_id );
	
	return returnVar;
}


function getBestSpawnPoint( remoteMissileSpawnPoints )
{
	validEnemies = [];

	foreach ( spawnPoint in remoteMissileSpawnPoints )
	{
		spawnPoint.validPlayers = [];
		spawnPoint.spawnScore = 0;
	}
	
	foreach ( player in level.players )
	{
		if ( !isAlive( player ) )
			continue;

		if ( player.team == self.team )
			continue;
		
		if ( player.team == "spectator" )
			continue;
		
		bestDistance = 999999999;
		bestSpawnPoint = undefined;
	
		foreach ( spawnPoint in remoteMissileSpawnPoints )
		{
			//could add a filtering component here but i dont know what it would be.
			spawnPoint.validPlayers[spawnPoint.validPlayers.size] = player;
		
			potentialBestDistance = Distance2DSquared( spawnPoint.targetent.origin, player.origin );
			
			if ( potentialBestDistance <= bestDistance )
			{
				bestDistance = potentialBestDistance;
				bestSpawnpoint = spawnPoint;	
			}	
		}

		bestSpawnPoint.spawnScore += 2;
	}

	bestSpawn = remoteMissileSpawnPoints[0];
	foreach ( spawnPoint in remoteMissileSpawnPoints )
	{
		foreach ( player in spawnPoint.validPlayers )
		{
			spawnPoint.spawnScore += 1;
			
			if ( bulletTracePassed( player.origin + (0,0,32), spawnPoint.origin, false, player ) )
				spawnPoint.spawnScore += 3;
		
			if ( spawnPoint.spawnScore > bestSpawn.spawnScore )
			{
				bestSpawn = spawnPoint;
			}
			else if ( spawnPoint.spawnScore == bestSpawn.spawnScore ) // equal spawn weights so we toss a coin.
			{			
				if ( math::cointoss() )
					bestSpawn = spawnPoint;	
			}
		}
	}
	
	return ( bestSpawn );
}

function drawLine( start, end, timeSlice, color )
{
	/#
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, color,false, 1 );
		{wait(.05);};
	}
	#/
}

function _fire( lifeId, player, team, killstreak_id )
{
	remoteMissileSpawnArray = getEntArray( "remoteMissileSpawn" , "targetname" );
	
	foreach ( spawn in remoteMissileSpawnArray )
	{
		if ( isdefined( spawn.target ) )
			spawn.targetEnt = getEnt( spawn.target, "targetname" );	
	}
	
	if ( remoteMissileSpawnArray.size > 0 )
		remoteMissileSpawn = player getBestSpawnPoint( remoteMissileSpawnArray );
	else
		remoteMissileSpawn = undefined;

	if ( isdefined( remoteMissileSpawn ) )
	{	
		startPos = remoteMissileSpawn.origin;	
		targetPos = remoteMissileSpawn.targetEnt.origin;

		vector = vectorNormalize( startPos - targetPos );		
		startPos = ( vector * level.missileRemoteLaunchVert ) + targetPos;
	}
	else
	{
		upVector = (0, 0, level.missileRemoteLaunchVert );
		backDist = level.missileRemoteLaunchHorz;
		targetDist = level.missileRemoteLaunchTargetDist;
		
		forward = AnglesToForward( player.angles );
		startpos = player.origin + upVector + forward * backDist * -1;
		targetPos = player.origin + forward * targetDist;
	}
	
	self util::setUsingRemote( "remote_missile" );
	self util::freeze_player_controls( true );
	player DisableWeaponCycling();
	
	result = self killstreaks::init_ride_killstreak( "qrdrone" );		
	
	if ( result != "success" )
	{
		if ( result != "disconnect" )
		{
			player util::freeze_player_controls( false );
			player killstreaks::clear_using_remote();
			player EnableWeaponCycling();
			killstreakrules::killstreakStop( "remote_missile", team, killstreak_id );
		}

		return false;
	}	

	rocket = MagicBullet( GetWeapon( "remote_missile_missile" ), startpos, targetPos, player );
	
	forceAngleVector = vectorNormalize( targetPos - startPos );
	rocket.angles = VectorToAngles( forceAngleVector );
	rocket.targetname = "remote_missile";
	
	rocket killstreaks::configure_team( "remote_missile", killstreak_id, self, undefined, undefined, undefined );
	rocket killstreak_hacking::enable_hacking( "remote_missile", undefined, &HackedPostFunction );
	killstreak_detect::killstreakTargetSet( rocket );
	rocket.hackedHealthUpdateCallback = &hackedHealthUpdate;
	
	rocket thread handleDamage();
	
	player LinkToMissile( rocket, true, true );
	rocket.owner = player;
	//rocket.killcament = player;
	player thread cleanupWaiter( rocket, player.team, killstreak_id, rocket.snd_first, rocket.snd_third );
	
	visionset_mgr::activate( "visionset", "remote_missile_visionset", player, 0, 90000, 0 );	
	self clientfield::set_to_player( "fog_bank_2", 1 );
	self clientfield::set( "operating_predator", 1 );
	self killstreaks::play_killstreak_start_dialog( "remote_missile", self.pers["team"], killstreak_id );

	self AddWeaponStat( GetWeapon( "remote_missile" ), "used", 1 );

	rocket thread setup_rockect_map_icon();
	rocket missile_sound_play( player );
	rocket thread missile_brake_timeout_watch();
	rocket thread missile_timeout_watch();
	rocket thread missile_sound_impact( player, 3750 );
	player thread missile_sound_boost( rocket );
	player thread missile_deploy_watch( rocket );
	player thread watchOwnerTeamKillKicked( rocket );	
	player thread remote_missile_game_end_think( rocket, player.team, killstreak_id );
	player thread watch_missile_death( rocket, player.team, killstreak_id );
	player thread sndWatchExplo();

	rocket spawning::create_entity_enemy_influencer( "small_vehicle", rocket.team );

	player util::freeze_player_controls( false );

	player waittill( "Remotemissle_killstreak_done" );

	return true;
}

function hackedHealthUpdate( hacker )
{
	// no need for health update
}

function HackedPostFunction( hacker )	
{
	rocket = self;
	hacker missile_deploy( rocket, true );
}

function setup_rockect_map_icon()
{
	wait( 0.1 );
	self  clientfield::set( "remote_missile_fired", ( 1 ) );
}

function watchOwnerTeamKillKicked( rocket )
{
	rocket endon ( "death" );
	rocket endon ( "deleted" );

	self waittill( "teamKillKicked" );
	
	rocket spawning::remove_influencers();
	rocket Detonate();
}

function watch_missile_death( rocket, team, killstreak_id )
{
	self endon( "Remotemissle_killstreak_done" );
	
	snd_first = rocket.snd_first;
	snd_third = rocket.snd_third;

	rocket waittill( "death" );

	self player_missile_end( rocket, true, true, team, killstreak_id, snd_first, snd_third );

	self notify( "Remotemissle_killstreak_done" );
}

function player_missile_end( rocket, performPlayerKillstreakEnd, unlink, team, killstreak_id, snd_first, snd_third )
{
	if( isalive( rocket ) )
	{
		rocket clientfield::set( "remote_missile_fired", 0 );
		rocket Delete();
	}	
	
	self notify( "snd1stPersonExplo" );
	missile_end_sounds( rocket, snd_first, snd_third );	
	
	if( isdefined( self ) ) 
	{
		self thread destroy_missile_hud();
		
		//Only do this if the killstreak is ending normally
		if( ( isdefined( performPlayerKillstreakEnd ) && performPlayerKillstreakEnd ) )
		{
			self PlayRumbleOnEntity( "grenade_rumble" );
			
			if ( level.gameended == false ) 
			{
				self SendKillstreakDamageEvent( 600 );
			//	self thread hud::fade_to_black_for_x_sec( 0, 0.25, 0.1, 0.25 );
			//	wait( 0.25 );
			}

			if( isdefined ( rocket ) ) 
			{
				rocket hide();
			}
		}
	
		self clientfield::set( "operating_predator", 0 );
		self clientfield::set_to_player( "fog_bank_2", 0 );
		visionset_mgr::deactivate( "visionset", "remote_missile_visionset", self );
		
		if( unlink )
			self UnlinkFromMissile();

		self notify( "remotemissile_done" );
		self util::freeze_player_controls( false );
		self killstreaks::clear_using_remote();
		self EnableWeaponCycling();
		
		killstreakrules::killstreakStop( "remote_missile", team, killstreak_id );
	}
}

function missile_end_sounds( rocket, snd_first, snd_third )
{
	if( isdefined( rocket ) )
	{
		rocket spawning::remove_influencers();
		rocket missile_sound_stop();
	}
	else
	{
		if( isdefined( snd_first ) )
			snd_first delete();
		if( isdefined( snd_third ) )
			snd_third delete();	
	}
}

function missile_timeout_watch()
{
	self endon( "death" );
	
	wait ( 15 - 0.05 );
	if ( isdefined( self ) )
	{
		self spawning::remove_influencers();
		self missile_sound_stop();
	}
}

function missile_brake_timeout_watch()
{
	rocket = self;
	player = rocket.owner;
	
	self endon( "death" );

	self waittill( "missile_brake" );
	
	rocket PlaySound( "wpn_remote_missile_brake_npc" );
	player playlocalsound( "wpn_remote_missile_brake_plr" );
		
	wait( 1.5 );
	
	if( isdefined( self ) )
	{
		self SetMissileBrake( false );
	}
}

function stopOndeath( snd )
{
	self waittill( "death" );
	if( isdefined( snd ) ) 
		snd delete();
}

function cleanupWaiter( rocket, team, killstreak_id, snd_first, snd_third )
{
	self endon( "Remotemissle_killstreak_done" );
	
	snd_first = rocket.snd_first;
	snd_third = rocket.snd_third;

	self util::waittill_any( "joined_team", "joined_spectators", "disconnect" );
	
	self player_missile_end( rocket, false, false, team, killstreak_id, snd_first, snd_third );

	self notify( "Remotemissle_killstreak_done" );
}

/#
function _fire_noplayer( lifeId, player )
{
	upVector = (0, 0, level.missileRemoteLaunchVert );
	backDist = level.missileRemoteLaunchHorz;
	targetDist = level.missileRemoteLaunchTargetDist;

	forward = AnglesToForward( player.angles );
	startpos = player.origin + upVector + forward * backDist * -1;
	targetPos = player.origin + forward * targetDist;
	
	rocket = MagicBullet( GetWeapon( "remotemissile_projectile" ), startpos, targetPos, player );

	if ( !isdefined( rocket ) )
		return;

	rocket thread handleDamage();
	
	rocket.lifeId = lifeId;
	rocket.type = "remote";
	
	rocket thread Rocket_CleanupOnDeath();

	wait ( 2.0 );
}
#/

function handleDamage()
{
	self endon ( "death" );
	self endon ( "deleted" );

	self setCanDamage( true );
	self.health = 99999;
	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, tagName, modelName, partName, weapon );
		
		if ( isdefined ( attacker ) && isdefined( self.owner ) ) 
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) )
			{
				scoreevents::processScoreEvent( "destroyed_remote_missile", attacker, self.owner, weapon );
				attacker AddWeaponStat( weapon, "destroyed_controlled_killstreak", 1 );
			}
			else
			{
				//Destroyed Friendly Killstreak 
			}
			self.owner SendKillstreakDamageEvent( int(damage) );
		}
		self spawning::remove_influencers();
		self Detonate();
	}
}	

function staticEffect( duration )
{
	self endon ( "disconnect" );
	
	staticBG = newClientHudElem( self );
	staticBG.horzAlign = "fullscreen";
	staticBG.vertAlign = "fullscreen";
	staticBG setShader( "white", 640, 480 );
	staticBG.archive = true;
	staticBG.sort = 10;
	staticBG.immunetodemogamehudsettings = true;

	static = newClientHudElem( self );
	static.horzAlign = "fullscreen";
	static.vertAlign = "fullscreen";
	//static setShader( "tow_filter_overlay_no_signal", 640, 480 );
	static.archive = true;
	static.sort = 20;
	static.immunetodemogamehudsettings = true;

	self clientfield::set( "remote_killstreak_static", 1 );

	wait ( duration );

	self clientfield::set( "remote_killstreak_static", 0 );
	static destroy();
	staticBG destroy();
}

function Rocket_CleanupOnDeath()
{
	entityNumber = self getEntityNumber();
	level.rockets[ entityNumber ] = self;
	self waittill( "death" );	
	
	level.rockets[ entityNumber ] = undefined;
}

function missile_sound_play( player )
{
	snd_first_person = spawn( "script_model", self.origin );
	snd_first_person SetModel( "tag_origin" );
	snd_first_person LinkTo( self );

	snd_first_person SetInvisibleToAll();
	snd_first_person SetVisibleToPlayer( player );
	snd_first_person PlayLoopSound( "wpn_remote_missile_loop_plr", .5 );

	self.snd_first = snd_first_person;

	snd_third_person = spawn( "script_model", self.origin );
	snd_third_person SetModel( "tag_origin" );
	snd_third_person LinkTo( self );

	snd_third_person SetVisibleToAll();
	snd_third_person SetInvisibleToPlayer( player );
	snd_third_person PlayLoopSound( "wpn_remote_missile_loop_npc", .2 );

	self.snd_third = snd_third_person;
}

function missile_sound_boost( rocket )
{
	self endon( "remotemissile_done" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "disconnect" );

	self waittill( "missile_boost" );
	rocket PlaySound( "wpn_remote_missile_fire_boost_npc" );
	rocket.snd_third PlayLoopSound( "wpn_remote_missile_boost_npc" );
	self playlocalsound( "wpn_remote_missile_fire_boost_plr" );
	rocket.snd_first PlayLoopSound( "wpn_remote_missile_boost_plr" );
	self PlayRumbleOnEntity( "sniper_fire" );
	
	if ( rocket.origin[2] - self.origin[2] > 4000 )
	{
		rocket notify( "stop_impact_sound" );
		rocket thread missile_sound_impact( self, 6250 );
	}
}

function missile_sound_impact( player, distance )
{
	self endon( "death" );
	self endon( "stop_impact_sound" );
	player endon( "disconnect" );
	player endon( "remotemissile_done" );
	player endon( "joined_team" );
	player endon( "joined_spectators" );
	
	for ( ;; )
	{
		if ( self.origin[2] - player.origin[2] < distance )
		{
			self PlaySound( "wpn_remote_missile_inc" );
			return;
		}
		{wait(.05);};
	}
}

function sndWatchExplo()
{
	self endon( "Remotemissle_killstreak_done" );
	self endon( "remotemissile_done" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "disconnect" );
	self endon( "bomblets_deployed" );
	
	self waittill( "snd1stPersonExplo" );
	self playlocalsound( "wpn_remote_missile_explode_plr" );
}

function missile_sound_deploy_bomblets()
{
	self.snd_first PlayLoopSound( "wpn_remote_missile_loop_plr", .5 );
}

function missile_sound_stop()
{
	self.snd_first delete();
	self.snd_third delete();

	if( isdefined( self.snd_brake_first ) ) self.snd_brake_first delete();
	if( isdefined( self.snd_brake_third ) ) self.snd_brake_third delete();
}

function getValidTargets( rocket, trace )
{
	pixbeginevent("remotemissile_getVTs_header");

	targets = [];

	forward = AnglesToForward ( rocket.angles );

	rocketZ = rocket.origin[2];
	mapCenterZ = level.mapCenter[2];
	diff = mapCenterZ - rocketZ;

	ratio = diff / forward[2];

	aimTarget = rocket.origin + forward * ratio;
	rocket.aimTarget = aimTarget;
	
//	/#
//	circle( rocket.aimTarget, REMOTE_MISSILE_TARGETING_RADIUS, (0,1,0), true, true, 2000 );
//	#/
	
	pixendevent();

	pixbeginevent("remotemissile_getVTs_enemies");

	enemies = self GetEnemies();
	
	foreach( player in enemies )
	{
		if( !IsPlayer( player ) )
		{
			continue;
		}
		
		if ( Distance2DSquared( player.origin, aimTarget) < 1400 * 1400 && !player HasPerk( "specialty_nokillstreakreticle" ) )
		{
			if ( trace )
			{
				if ( BulletTracePassed( player.origin + (0,0,60), player.origin + (0,0,180), false, player) )
				{
					targets[targets.size] = player;					
				}
			}
			else
			{
				targets[targets.size] = player;
			}
		}
	}

	dogs = GetEntArray( "attack_dog", "targetname" );
		
	foreach( dog in dogs )
	{
		if ( dog.team != self.team && Distance2DSquared( dog.origin, aimTarget) < 1400 * 1400 )
		{
			if ( trace )
			{
				if ( BulletTracePassed( dog.origin + (0,0,60), dog.origin + (0,0,180), false, dog) )
				{
					targets[targets.size] = dog;					
				}
			}
			else
			{
				targets[targets.size] = dog;
			}
		}
	}
	
	tanks = GetEntArray( "talon", "targetname" );

	foreach( tank in tanks )
	{
		if ( tank.team != self.team && Distance2DSquared( tank.origin, aimTarget) < 1400 * 1400 )
		{
			if ( trace )
			{
				if ( BulletTracePassed( tank.origin + (0,0,60), tank.origin + (0,0,180), false, tank) )
				{
					targets[targets.size] = tank;					
				}
			}
			else
			{
				targets[targets.size] = tank;
			}
		}
	}
	
	turrets = GetEntArray( "auto_turret", "classname" );
	foreach( turret in turrets )
	{
		if ( turret.team != self.team && Distance2DSquared( turret.origin, aimTarget) < 1400 * 1400 )
		{
			if ( trace )
			{
				if ( BulletTracePassed( turret.origin + (0,0,60), turret.origin + (0,0,180), false, turret) )
				{
					targets[targets.size] = turret;					
				}
			}
			else
			{
				targets[targets.size] = turret;
			}
		}
	}	
	
	pixendevent();

	return targets;
}

function create_missile_hud( rocket )
{	
	self.missile_target_icons = [];
	
	foreach (player	in level.players)
	{
		if( player == self )
			 continue;
		
		if (level.teamBased && player.team == self.team)
			continue;
		
		index = player.clientId;
		self.missile_target_icons[index] = newClientHudElem( self );
		self.missile_target_icons[index].x = 0;
		self.missile_target_icons[index].y = 0;
		self.missile_target_icons[index].z = 0;
		self.missile_target_icons[index].alpha = 0;
		self.missile_target_icons[index].archived = true;
		self.missile_target_icons[index] setShader( "hud_remote_missile_target", 175, 175 );
		self.missile_target_icons[index] setWaypoint( false );
		self.missile_target_icons[index].hidewheninmenu = true;
		self.missile_target_icons[index].immunetodemogamehudsettings = true;
	}	
	
	for(i=0; i<3; i++ )
	{
		self.missile_target_other[i] = newClientHudElem( self );
		self.missile_target_other[i].x = 0;
		self.missile_target_other[i].y = 0;
		self.missile_target_other[i].z = 0;
		self.missile_target_other[i].alpha = 0;
		self.missile_target_other[i].archived = true;
		self.missile_target_other[i] setShader( "hud_remote_missile_target", 175, 175 );
		self.missile_target_other[i] setWaypoint( false );
		self.missile_target_other[i].hidewheninmenu = true;
		self.missile_target_other[i].immunetodemogamehudsettings = true;
	}
	rocket.iconIndexOther = 0;
	
	self thread targeting_hud_think( rocket );
}

function destroy_missile_hud()
{
	if (isdefined( self.missile_target_icons) )
	{
		foreach (player	in level.players)
		{
			if( player == self )
			{
				continue;
			}

			index = player.clientId;
			if (isdefined(self.missile_target_icons[index]))
			{
				self.missile_target_icons[index] Destroy();
			}
		}
	}
	if (isdefined( self.missile_target_other) )
	{
		for( i=0; i<3; i++)
		{
			if( isdefined( self.missile_target_other[i] ) )
				self.missile_target_other[i] Destroy();
		}
	}
}

function targeting_hud_think( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );
	
	targets = self getValidTargets( rocket, true );
	framesSinceTargetScan = 0;

	while( true )
	{
		foreach (icon in self.missile_target_icons)
		{
			icon.alpha = 0;
		}
		
		framesSinceTargetScan++;

		if ( framesSinceTargetScan > 5 )
		{
			targets = self getValidTargets( rocket, true );
			framesSinceTargetScan = 0;
		}

		if (targets.size > 0)
		{
			foreach (target in targets)
			{
				if ( isdefined( target ) == false ) 
					continue;
						
				if ( IsPlayer( target ) )
				{
					if ( isalive( target ) )
					{
						index = target.clientId;
						assert( isdefined( index ) );
						
						self.missile_target_icons[index].x = target.origin[0];
						self.missile_target_icons[index].y = target.origin[1];
						self.missile_target_icons[index].z = target.origin[2] + 47;
						self.missile_target_icons[index].alpha = 1;
					}
				}
				else
				{
					if( !isdefined(target.missileIconIndex))
					{
						target.missileIconIndex = rocket.iconIndexOther;
						rocket.iconIndexOther = (rocket.iconIndexOther + 1) % 3;
					}
					index = target.missileIconIndex;			
					self.missile_target_other[index].x = target.origin[0];
					self.missile_target_other[index].y = target.origin[1];
					self.missile_target_other[index].z = target.origin[2];
					self.missile_target_other[index].alpha = 1;
				}
			}
		}			
		
		wait (0.1);
	}
}

function missile_deploy_watch( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("remotemissile_bomblets_launched"); 
	rocket endon("death");
	level endon ( "game_ended" );	
	
	wait ( 0.25 );
	
	self thread create_missile_hud( rocket );
	
	while( true )
	{
		if ( self attackbuttonpressed() )
		{
			self thread missile_deploy( rocket, false );
		}
		else
		{
			{wait(.05);}; 				
		} 
	}
}

function missile_deploy( rocket, hacked )
{
	rocket notify ("remotemissile_bomblets_launched"); 
	waitFrames = 2;
	explosionRadius = 0;
	targets = self getValidTargets( rocket, false );
	if( targets.size > 0 )
	{
		foreach( target in targets )
		{
			self thread fire_bomblet( rocket, explosionRadius, target, waitFrames );
			waitFrames++;
		}
	}
	
	bomblet = MagicBullet( GetWeapon( "remote_missile_bomblet" ), rocket.origin, rocket.origin + AnglesToForward ( rocket.angles ) * 1000, self);

	setup_bomblet( bomblet );
	
	if( rocket.origin[2] - self.origin[2] > 4000 )
	{
		//bomblet thread missile_sound_impact( self, 8000 );
		rocket notify( "stop_impact_sound" );
	}
	if( hacked == true )
	{
		rocket.originalOwner thread hud::fade_to_black_for_x_sec( 0, 0.15, 0, 0, "white" );
		self notify("remotemissile_done");
	}

	rocket clientfield::set( "remote_missile_fired", ( 2 ) );
	bomblet.killcamEnt = self;
	for( i = targets.size; i <= 8; i++ )
	{
		self thread fire_random_bomblet( rocket, explosionRadius, i % 6, waitFrames );
		waitFrames++;
	}
	
	playfx( level.missileRemoteDeployFX, rocket.origin, anglestoForward( rocket.angles ) );
	self playLocalSound("mpl_rc_exp");
	self PlayRumbleOnEntity( "sniper_fire" );			
	Earthquake( 0.2, 0.2, rocket.origin, 200 );
				
	//still rocket for viewing the bomblets
	rocket Hide();
	rocket setMissileCoasting( true );
	if ( hacked == false )
	{
		self thread hud::fade_to_black_for_x_sec( 0, 0.15, 0, 0, "white" );
	}

	rocket missile_sound_deploy_bomblets();
	self thread bomblet_camera_waiter( rocket );
	self notify( "bomblets_deployed" );

	if ( hacked == true )
	{
		rocket notify( "death" );
	}
	
	return;
}
			
function bomblet_camera_waiter( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );

	delay = GetDvarFloat( "scr_rmbomblet_camera_delaytime", 1.0 );

	self waittill( "bomblet_exploded" );

	wait( delay );

	rocket notify( "death" );
	self notify("remotemissile_done");
}

function setup_bomblet_map_icon()
{
	wait( 0.1 );
	self clientfield::set( "remote_missile_bomblet_fired", ( 1 ) );
}

function setup_bomblet( bomb )
{
	bomb.team = self.team;

	bomb setTeam( self.team );

	//Send over for the compass icon
	bomb thread setup_bomblet_map_icon();

	bomb.killcamEnt = self;

	bomb thread bomblet_explostion_waiter( self );	
}

function fire_bomblet( rocket, explosionRadius, target, waitFrames )
{
	origin = rocket.origin; 

	targetOrigin = target.origin + (0,0,50);
	
	wait( waitFrames * 0.05 );
	
	if( isdefined( rocket ) )
		origin = rocket.origin;

	bomb = MagicBullet( GetWeapon( "remote_missile_bomblet" ), origin, targetOrigin, self, target, (0,0,30) );

	setup_bomblet( bomb );
}

function fire_random_bomblet( rocket, explosionRadius, quadrant, waitFrames )
{
	origin = rocket.origin;
	angles = rocket.angles;
	owner = rocket.owner;
	aimTarget = rocket.aimtarget;
	
	wait ( waitFrames * 0.05 );
	
	angle = randomIntRange( 10 + ( 60 * quadrant), 50 + ( 60 * quadrant ) );
	radius = randomIntRange( 200, 1400 + 100 );
	x =	min( radius, 1400 - 50 ) * Cos( angle );
	y = min( radius, 1400 - 50 ) * Sin( angle );
	
	bomb = MagicBullet( GetWeapon( "remote_missile_bomblet" ), origin, aimtarget + ( x, y, 0 ), self);
	
	setup_bomblet( bomb );
}

function cleanup_bombs( bomb )
{
	player = self;
	bomb endon( "death" ); 
	
	player util::waittill_any( "joined_team", "joined_spectators", "disconnect" );
	
	if( isdefined( bomb ) )
	{
		bomb clientfield::set( "remote_missile_bomblet_fired", 0 );
		bomb delete();
	}
}

function bomblet_explostion_waiter( player )
{
	player thread cleanup_bombs( self );
	
	player endon( "disconnect" );
	player endon( "remotemissile_done" ); 
	player endon( "death" );
	level endon ( "game_ended" );

	self waittill( "death" );

	player notify( "bomblet_exploded" );
}
