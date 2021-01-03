#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\hud_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\_spawning;

#using scripts\mp\_util;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;

                                            
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           








	
//#precache( "material","tow_filter_overlay_no_signal");
#precache( "material","mp_hud_cluster_status");
#precache( "material","mp_hud_armed");
#precache( "material","mp_hud_deployed");
#precache( "material", "reticle_side_round_big_top" );
#precache( "material", "reticle_side_round_big_right" );
#precache( "material", "reticle_side_round_big_left" );
#precache( "material", "reticle_side_round_big_bottom" );
#precache( "material", "hud_remote_missile_target" );
#precache( "string", "KILLSTREAK_EARNED_REMOTE_MISSILE" );
#precache( "string", "KILLSTREAK_REMOTE_MISSILE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_REMOTE_MISSILE_INBOUND" );
#precache( "eventstring", "mpl_killstreak_cruisemissile" );
#precache( "fx", "killstreaks/fx_predator_trigger" );

#namespace remotemissile;

function init()
{
	level.rockets = [];
	
	killstreaks::register( "remote_missile", "remote_missile", "killstreak_remote_missile", "remote_missle_used",&tryUsePredatorMissile, true );
	killstreaks::register_alt_weapon( "remote_missile", "remote_missile_missile" );
	killstreaks::register_alt_weapon( "remote_missile", "remote_missile_bomblet" );
	killstreaks::register_strings( "remote_missile", &"KILLSTREAK_EARNED_REMOTE_MISSILE", &"KILLSTREAK_REMOTE_MISSILE_NOT_AVAILABLE", &"KILLSTREAK_REMOTE_MISSILE_INBOUND" );
	killstreaks::register_dialog( "remote_missile", "mpl_killstreak_cruisemissile", 7, undefined, 99, 117, 99 );
	killstreaks::set_team_kill_penalty_scale( "remote_missile", level.teamKillReducedPenalty );
	killstreaks::override_entity_camera_in_demo("remote_missile", true);

	clientfield::register( "missile", "remote_missile_bomblet_fired", 1, 1, "int" );
	clientfield::register( "missile", "remote_missile_fired", 1, 2, "int" );
	
	level.missilesForSightTraces = [];

	level.missileRemoteDeployFX = "killstreaks/fx_predator_trigger";
	level.missileRemoteLaunchVert = 18000;
	level.missileRemoteLaunchHorz = 7000;
	level.missileRemoteLaunchTargetDist = 1500;
}


function remote_missile_game_end_think(missile, team, killstreak_id, snd_first, snd_third )
{
	missile endon("deleted");
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "disconnect" );
	self endon( "Remotemissle_killstreak_done" );
	
	level waittill("game_ended");

	missile_end_sounds( missile, snd_first, snd_third );
	
	self player_missile_end( missile, true, true );
	
	killstreakrules::killstreakStop( "remote_missile", team, killstreak_id );
	
	if (isdefined(missile))
		missile Delete();

	self notify( "Remotemissle_killstreak_done" );
}

function tryUsePredatorMissile( lifeId )
{
	if (!self IsOnGround() || self util::isUsingRemote() )
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

	player.killstreak_waitamount = 10;
		
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
			player.killstreak_waitamount = undefined;
			killstreakrules::killstreakStop( "remote_missile", team, killstreak_id );
		}

		return false;
	}	

	rocket = MagicBullet( GetWeapon( "remote_missile_missile" ), startpos, targetPos, player );
	forceAngleVector = vectorNormalize( targetPos - startPos );
	rocket.angles = VectorToAngles( forceAngleVector );
	rocket.targetname = "remote_missile";
	rocket.team = team;
	rocket setTeam( team );
	rocket clientfield::set( "enemyvehicle", 1 );
	
	rocket thread handleDamage();
	
	player LinkToMissile( rocket, true, true );
	rocket.owner = player;
	rocket.killcament = player;
	player thread cleanupWaiter( rocket, player.team, killstreak_id, rocket.snd_first, rocket.snd_third );
		
	if ( isdefined( level.remote_missile_vision ) )
	{
		self UseServerVisionset( true );
		self SetVisionSetForPlayer( level.remote_missile_vision, 1 );
	}
	self clientfield::set( "operating_predator", 1 );
	self killstreaks::play_killstreak_start_dialog( "remote_missile", self.pers["team"] );

	self AddWeaponStat( GetWeapon( "remote_missile" ), "used", 1 );

	rocket thread setup_rockect_map_icon();
	rocket missile_sound_play( player );
	rocket thread missile_brake_timeout_watch();
	rocket thread missile_timeout_watch();
	rocket thread missile_sound_impact( player, 4000 );
	player thread missile_sound_boost( rocket );
	player thread missile_deploy_watch( rocket );
	player thread watchOwnerTeamKillKicked( rocket );	
	player thread remote_missile_game_end_think( rocket, player.team, killstreak_id, rocket.snd_first, rocket.snd_third );
	player thread watch_missile_death( rocket, player.team, killstreak_id, rocket.snd_first, rocket.snd_third );

	rocket spawning::create_entity_enemy_influencer( "small_vehicle", rocket.team );

	player util::freeze_player_controls( false );
	player killstreaks::clear_using_remote();
	player EnableWeaponCycling();

	player waittill( "Remotemissle_killstreak_done" );

	return true;
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

function watch_missile_death( rocket, team, killstreak_id, snd_first, snd_third )
{
	level endon( "game_ended" );
	rocket endon( "deleted" );
	self endon( "joined_team" );
	self endon( "joined_spectators" );
	self endon( "disconnect" );

	rocket waittill( "death" );

	missile_end_sounds( rocket, snd_first, snd_third );
	
	self player_missile_end( rocket, true, true );

	killstreakrules::killstreakStop( "remote_missile", team, killstreak_id );

	self notify( "Remotemissle_killstreak_done" );
}

function player_missile_end( rocket, performPlayerKillstreakEnd, unlink )
{
	if ( isdefined( self ) ) 
	{
		self thread destroy_missile_hud();
		
		//Only do this if the killstreak is ending normally
		if( isdefined( performPlayerKillstreakEnd ) && performPlayerKillstreakEnd )
		{
			self PlayRumbleOnEntity( "grenade_rumble" );
			
			if ( level.gameended == false ) 
			{
				self SendKillstreakDamageEvent( 600 );
				self thread hud::fade_to_black_for_x_sec( 0, 0.25, 0.1, 0.25 );
				wait( 0.25 );
			}

			if ( isdefined ( rocket ) ) 
			{
				rocket hide();
			}
		}
	
		self clientfield::set( "operating_predator", 0 );
		self UseServerVisionset( false );

		if( unlink )
			self UnlinkFromMissile();

		self notify( "remotemissile_done" );
		self util::freeze_player_controls( false );
		self killstreaks::clear_using_remote();
		self EnableWeaponCycling();

		if ( isdefined( self ) )
		{
			self.killstreak_waitamount = undefined;	
		}
	}
}

function missile_end_sounds( rocket, snd_first, snd_third )
{
	if( isdefined(rocket) )
	{
		rocket spawning::remove_influencers();
	
		rocket missile_sound_stop();
	}
	else
	{
		if ( isdefined( snd_first ) )
		{
			snd_first delete();
		}
		if ( isdefined( snd_third ) )
		{
			snd_third delete();	
		}
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
	self endon( "death" );
	
	self waittill( "missile_brake" );
	wait( 1.5 );
	
	if( isdefined( self ) )
	{
		self SetMissileBrake( false );
	}
}

function cleanupWaiter( rocket, team, killstreak_id, snd_first, snd_third )
{
	rocket endon("death");
	rocket endon("deleted");
	
	self util::waittill_any( "joined_team", "joined_spectators", "disconnect" );

	missile_end_sounds( rocket, snd_first, snd_third );
	
	self player_missile_end( rocket, false, false );

	killstreakrules::killstreakStop( "remote_missile", team, killstreak_id );
	
	if (isdefined(rocket))
		rocket Delete();

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
	rocket.snd_first PlayLoopSound( "wpn_remote_missile_boost_plr" );
	rocket.snd_first PlaySound( "wpn_remote_missile_fire_boost" );
	self PlayRumbleOnEntity( "sniper_fire" );
	
	if ( rocket.origin[2] - self.origin[2] > 4000 )
	{
		rocket notify( "stop_impact_sound" );
		rocket thread missile_sound_impact( self, 6000 );
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

function missile_sound_deploy_bomblets()
{

	self.snd_first PlayLoopSound( "wpn_remote_missile_loop_plr", .5 );

}

function missile_sound_stop()
{
	self.snd_first delete();
	self.snd_third delete();
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

	enemies = self GetEnemies( true );
	
	foreach( player in enemies )
	{
		if( !IsPlayer( player ) )
		{
			continue;
		}
		
		if ( Distance2DSquared( player.origin, aimTarget) < 600 * 600 && !player HasPerk( "specialty_nokillstreakreticle" ) )
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
		if ( dog.team != self.team && Distance2DSquared( dog.origin, aimTarget) < 600 * 600 )
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
		if ( tank.team != self.team && Distance2DSquared( tank.origin, aimTarget) < 600 * 600 )
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
		if ( turret.team != self.team && Distance2DSquared( turret.origin, aimTarget) < 600 * 600 )
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
	
	self.deploy_hud_armed = newclienthudelem( self );
	self.deploy_hud_armed.alignX = "center";
	self.deploy_hud_armed.alignY = "middle";
	self.deploy_hud_armed.horzAlign = "user_center";
	self.deploy_hud_armed.vertAlign = "user_center";
	self.deploy_hud_armed SetShader("mp_hud_armed", 110, 55);
	self.deploy_hud_armed.hidewheninmenu = true;
	self.deploy_hud_armed.immunetodemogamehudsettings = true;
	self.deploy_hud_armed.x = -25;
	self.deploy_hud_armed.y = 161;
	
	self.deploy_hud_deployed = newclienthudelem( self );
	self.deploy_hud_deployed.alignX = "center";
	self.deploy_hud_deployed.alignY = "middle";
	self.deploy_hud_deployed.horzAlign = "user_center";
	self.deploy_hud_deployed.vertAlign = "user_center";
	self.deploy_hud_deployed SetShader("mp_hud_deployed", 110, 55);
	self.deploy_hud_deployed.hidewheninmenu = true;
	self.deploy_hud_deployed.immunetodemogamehudsettings = true;
	self.deploy_hud_deployed.alpha = 0.35;
	self.deploy_hud_deployed.x = 25;
	self.deploy_hud_deployed.y = 161;	

	self.missile_reticle_top = newclienthudelem( self );
	self.missile_reticle_top.alignX = "center";
	self.missile_reticle_top.alignY = "middle";
	self.missile_reticle_top.horzAlign = "user_center";
	self.missile_reticle_top.vertAlign = "user_center";
	self.missile_reticle_top.font = "small";
	self.missile_reticle_top SetShader("reticle_side_round_big_top", 140, 64);
	self.missile_reticle_top.hidewheninmenu = false;
	self.missile_reticle_top.immunetodemogamehudsettings = true;
	self.missile_reticle_top.x = 0;
	self.missile_reticle_top.y = 0;
	
	self.missile_reticle_bottom = newclienthudelem( self );
	self.missile_reticle_bottom.alignX = "center";
	self.missile_reticle_bottom.alignY = "middle";
	self.missile_reticle_bottom.horzAlign = "user_center";
	self.missile_reticle_bottom.vertAlign = "user_center";
	self.missile_reticle_bottom.font = "small";
	self.missile_reticle_bottom SetShader("reticle_side_round_big_bottom", 140, 64);
	self.missile_reticle_bottom.hidewheninmenu = false;
	self.missile_reticle_bottom.immunetodemogamehudsettings = true;
	self.missile_reticle_bottom.x = 0;
	self.missile_reticle_bottom.y = 0;
	
	self.missile_reticle_right = newclienthudelem( self );
	self.missile_reticle_right.alignX = "center";
	self.missile_reticle_right.alignY = "middle";
	self.missile_reticle_right.horzAlign = "user_center";
	self.missile_reticle_right.vertAlign = "user_center";
	self.missile_reticle_right.font = "small";
	self.missile_reticle_right SetShader("reticle_side_round_big_right", 64, 140);
	self.missile_reticle_right.hidewheninmenu = false;
	self.missile_reticle_right.immunetodemogamehudsettings = true;
	self.missile_reticle_right.x = 0;
	self.missile_reticle_right.y = 0;
	
	self.missile_reticle_left = newclienthudelem( self );
	self.missile_reticle_left.alignX = "center";
	self.missile_reticle_left.alignY = "middle";
	self.missile_reticle_left.horzAlign = "user_center";
	self.missile_reticle_left.vertAlign = "user_center";
	self.missile_reticle_left.font = "small";
	self.missile_reticle_left SetShader("reticle_side_round_big_left", 64, 140);
	self.missile_reticle_left.hidewheninmenu = false;
	self.missile_reticle_left.immunetodemogamehudsettings = true;
	self.missile_reticle_left.x = 0;
	self.missile_reticle_left.y = 0;	
	
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
		self.missile_target_icons[index] setShader( "hud_remote_missile_target", 450, 450 );
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
		self.missile_target_other[i] setShader( "hud_remote_missile_target", 450, 450 );
		self.missile_target_other[i] setWaypoint( false );
		self.missile_target_other[i].hidewheninmenu = true;
		self.missile_target_other[i].immunetodemogamehudsettings = true;
	}
	rocket.iconIndexOther = 0;
	
	self thread targeting_hud_think( rocket );
	self thread reticle_hud_think( rocket );
	self thread flash_cluster_armed( rocket );
}

function destroy_missile_hud()
{
	
	if (isdefined(self.deploy_hud_armed))
	{
		self.deploy_hud_armed destroy();
	}
	if (isdefined(self.deploy_hud_deployed))
	{
		self.deploy_hud_deployed destroy();
	}
	if (isdefined(self.missile_reticle))
	{
		self.missile_reticle destroy();
	}
	if (isdefined(self.missile_reticle_top))
	{
		self.missile_reticle_top destroy();
	}
	if (isdefined(self.missile_reticle_bottom))
	{
		self.missile_reticle_bottom destroy();
	}
	if (isdefined(self.missile_reticle_right))
	{
		self.missile_reticle_right destroy();
	}
	if (isdefined(self.missile_reticle_left))
	{
		self.missile_reticle_left destroy();
	}
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

function flash_cluster_armed( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	level endon ( "game_ended" );
	rocket endon( "death" );
	self endon ( "bomblets_deployed" );
	
	for ( ;; )
	{
		self.deploy_hud_armed.alpha = 1;
		wait ( .35 );
		self.deploy_hud_armed.alpha = 0;
		wait ( .15 );
	}
}

function flash_cluster_deployed( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	level endon ( "game_ended" );
	rocket endon( "death" );

	self.deploy_hud_armed.alpha = 0.35;
	
	for ( ;; )
	{
		self.deploy_hud_deployed.alpha = 1;
		wait ( .35 );
		self.deploy_hud_deployed.alpha = 0;
		wait ( .15 );
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
		
function reticle_hud_think( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );
	
	first = true;
	while( true )
	{	
		//1000 is max that will fit the screen		
		//real FOV is 15 so we should be dividing by 7.5 if we switch to the camera eye location
		reticleSize = int( min( max( 0, 1000 * atan( 600 / max( 0.1, (rocket.origin[2] - self.origin[2]))) / 9 ), 1500));

		if ( !first )
		{
			self.missile_reticle_top MoveOverTime( 0.1 );
			self.missile_reticle_bottom MoveOverTime( 0.1 );
			self.missile_reticle_right MoveOverTime( 0.1 );
			self.missile_reticle_left MoveOverTime( 0.1 );
		}
		else
		{
			first = false;
		}
		
		self.missile_reticle_top.y = -reticleSize/2.4;
		self.missile_reticle_bottom.y = reticleSize/2.4;
		self.missile_reticle_right.x = reticleSize/2.4;
		self.missile_reticle_left.x = -reticleSize/2.4;
		wait (0.1);
	}
}

function missile_deploy_watch( rocket )
{
	self endon( "disconnect" );
	self endon("remotemissile_done"); 
	rocket endon("death");
	level endon ( "game_ended" );	
	
	wait ( 0.25 );
	
	self thread create_missile_hud( rocket );
	waitFrames = 2;
	explosionRadius = 0;
	
	while( true )
	{
		if ( self attackbuttonpressed() )
		{
			targets = self getValidTargets( rocket, false );
			if (targets.size > 0)
			{
				foreach (target in targets)
				{
					self thread fire_bomblet( rocket, explosionRadius, target, waitFrames );
					waitFrames++;
				}
			}
			
			bomblet = MagicBullet( GetWeapon( "remote_missile_bomblet" ), rocket.origin, rocket.origin + AnglesToForward ( rocket.angles ) * 1000, self);
			bomblet.team = self.team;
			bomblet setTeam( self.team );
			if ( rocket.origin[2] - self.origin[2] > 4000 )
			{
				bomblet thread missile_sound_impact( self, 8000 );
				rocket notify( "stop_impact_sound" );
			}

			//Send over for the compass icon
			bomblet thread setup_bomblet_map_icon();
			rocket  clientfield::set( "remote_missile_fired", ( 2 ) );
			bomblet.killcamEnt = self;
			for (i=targets.size; i<=8; i++)
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
			self thread hud::fade_to_black_for_x_sec( 0, 0.15, 0, 0, "white" );
			rocket missile_sound_deploy_bomblets();
			self thread bomblet_camera_waiter( rocket );
			self thread flash_cluster_deployed( rocket );
			self notify( "bomblets_deployed" );
			
			return;
		}
		else
		{
			{wait(.05);}; 				
		} 
	}
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

	rocket notify("death");
	self notify("remotemissile_done");

}

function fire_bomblet( rocket, explosionRadius, target, waitFrames )
{
	origin = rocket.origin; 

	targetOrigin = target.origin + (0,0,50);
	wait( waitFrames * 0.05 );
	if ( isdefined( rocket ) )
	{
		origin = rocket.origin;
	}

	bomblet = MagicBullet( GetWeapon( "remote_missile_bomblet" ), origin, targetOrigin, self, target, (0,0,30) );
	bomblet.team = self.team;
	bomblet setTeam( self.team );

	//Send over for the compass icon
	bomblet.killcamEnt = self;
	bomblet thread setup_bomblet_map_icon();

	bomblet thread bomblet_explostion_waiter( self );
}

function setup_bomblet_map_icon()
{
	wait( 0.1 );
	self clientfield::set( "remote_missile_bomblet_fired", ( 1 ) );
}



function fire_random_bomblet( rocket, explosionRadius, quadrant, waitFrames )
{
	origin = rocket.origin;
	angles = rocket.angles;
	owner = rocket.owner;
	aimTarget = rocket.aimtarget;
	
	wait ( waitFrames * 0.05 );
	
	angle = randomIntRange( 10 + ( 60 * quadrant), 50 + ( 60 * quadrant ) );
	radius = randomIntRange( 200, 600 + 100 );
	x =	min( radius, 600 - 50 ) * Cos( angle );
	y = min( radius, 600 - 50 ) * Sin( angle );
	
	bomblet = MagicBullet( GetWeapon( "remote_missile_bomblet" ), origin, aimtarget + ( x, y, 0 ), self);
	bomblet.team = self.team;
	bomblet setTeam( self.team );

	//Send over for the compass icon
	bomblet thread setup_bomblet_map_icon();
	bomblet.killcamEnt = self;

	bomblet thread bomblet_explostion_waiter( self );
}



function bomblet_explostion_waiter( player )
{
	player endon( "disconnect" );
	player endon( "remotemissile_done" ); 
	player endon( "death" );
	level endon ( "game_ended" );

	self waittill( "death" );

	player notify( "bomblet_exploded" );
}
