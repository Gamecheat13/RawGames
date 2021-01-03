#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;
#using scripts\mp\_util;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "eventstring", "mpl_killstreak_radar" );
#precache( "string", "KILLSTREAK_EARNED_RADAR" );
#precache( "string", "KILLSTREAK_RADAR_INBOUND" );
#precache( "string", "KILLSTREAK_RADAR_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_DESTROYED_UAV" );
#precache( "string", "KILLSTREAK_RADAR_HACKED" );

#precache( "fx", "killstreaks/fx_uav_damage_trail" );
#precache( "fx", "killstreaks/fx_uav_lights" ); 
#precache( "fx", "killstreaks/fx_uav_bunner" );


	
#namespace uav;
	
function init()
{	
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.activeUAVs[ team ] = 0;
		}
	}
	else
	{	
		level.activeUAVs = [];
	}
	
	level.activePlayerUAVs = [];
	level.spawnedUAVs = [];

	if ( tweakables::getTweakableValue( "killstreak", "allowradar" ) )
	{
		killstreaks::register( "uav", "uav", "killstreak_uav", "uav_used", &ActivateUAV );
		killstreaks::register_strings( "uav", &"KILLSTREAK_EARNED_RADAR", &"KILLSTREAK_RADAR_NOT_AVAILABLE", &"KILLSTREAK_RADAR_INBOUND", undefined, &"KILLSTREAK_RADAR_HACKED" );
		killstreaks::register_dialog( "uav", "mpl_killstreak_radar", "uavDialogBundle", "uavPilotDialogBundle", "friendlyUav", "enemyUav", "enemyUavMultiple", "friendlyUavHacked", "enemyUavHacked", "requestUav", "threatUav" );
	}
	
	level thread UAVTracker();
	
	callback::on_connect( &OnPlayerConnect );
	callback::on_spawned( &OnPlayerSpawned );
	callback::on_joined_team( &OnPlayerJoinedTeam );
	
	setMatchFlag( "radar_allies", 0 );
	setMatchFlag( "radar_axis", 0 );
}

function HackedPreFunction( hacker )
{
	uav = self;
	uav ResetActiveUAV();
}

function ConfigureTeamPost( owner, isHacked )
{
	uav = self;
	uav thread teams::WaitUntilTeamChangeSingleTon( owner, "UAV_watch_team_change", &OnTeamChange, owner.entNum, "delete", "death", "leaving" );
	if ( isHacked == false )
	{
		uav teams::HideToSameTeam();
	}
	else
	{
		uav SetVisibleToAll();
	}
	owner AddActiveUAV();
}

function ActivateUAV()
{
	assert( isdefined( level.players ) );
	
	if ( self killstreakrules::isKillstreakAllowed( "uav", self.team ) == false )
	{
		return false;
	}
	
	killstreak_id = self killstreakrules::killstreakStart( "uav", self.team );
	if (  killstreak_id == -1 )
	{
		return false;
	}
	
	rotator = level.airsupport_rotator;
	attach_angle = -90;
	
	uav = spawn( "script_model", rotator getTagOrigin( "tag_origin" ) );
	if ( !isdefined( level.spawnedUAVs ) ) level.spawnedUAVs = []; else if ( !IsArray( level.spawnedUAVs ) ) level.spawnedUAVs = array( level.spawnedUAVs ); level.spawnedUAVs[level.spawnedUAVs.size]=uav;;

	uav setModel( "veh_t7_drone_uav_enemy_vista" );
	
	uav.targetname = "uav";
	
	uav killstreaks::configure_team( "uav", killstreak_id, self, undefined, undefined, &ConfigureTeamPost );
	uav killstreak_hacking::enable_hacking( "uav", &HackedPreFunction, undefined );
	
	uav clientfield::set( "enemyvehicle", 1 );
	killstreak_detect::killstreakTargetSet( uav );
	
	uav SetDrawInfrared( true );
	
	uav.killstreak_id = killstreak_id;
	uav.leaving = false;
	uav.health = 99999;
	
	uav.maxhealth = ( 700 );
	uav.lowhealth = ( ( 700 ) * 0.4 );
	
	uav SetCanDamage( true );
	uav thread killstreaks::MonitorDamage( "uav", uav.maxhealth, &DestroyUAV, uav.lowhealth, &OnLowHealth, 0, undefined, true );

	uav thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );
	uav.rocketDamage = uav.maxhealth + 1;
	
	minFlyHeight = int( airsupport::getMinimumFlyHeight() );
	zOffset = minFlyHeight + ( 2500 );
	
	angle = randomInt( 360 );
	radiusOffset = ( 4000 ) + randomInt( ( 1000 ) );
	xOffset = cos( angle ) * radiusOffset;
	yOffset = sin( angle ) * radiusOffset;
	angleVector = vectorNormalize( ( xOffset, yOffset, zOffset ) );
	angleVector = angleVector * zOffset;
	uav linkTo( rotator, "tag_origin", angleVector, ( 0, angle + attach_angle, 0 ) );
	
	self AddWeaponStat( GetWeapon( "uav" ), "used", 1 );

	uav thread killstreaks::WaitForTimeout( "uav", ( 25000 ), &OnTimeout, "delete", "death", "crashing" );
	uav thread killstreaks::WaitForTimecheck( ( ( 25000 ) / 2 ), &OnTimecheck, "delete", "death", "crashing" );
	
	uav thread StartUAVFx();
	
	self killstreaks::play_killstreak_start_dialog( "uav", self.team, killstreak_id );
	
	uav killstreaks::play_pilot_dialog_on_owner( "arrive", "uav", killstreak_id );
	uav thread killstreaks::player_killstreak_threat_tracking( "uav" );
	
	return true;
}

function OnLowHealth( attacker, weapon )
{
	self.is_damaged = true;
}

function OnTeamChange( entNum, event )
{
	DestroyUAV( undefined, undefined );
}

function DestroyUAV( attacker, weapon )
{	
	if( isdefined( attacker ) && ( !isdefined( self.owner ) ||  self.owner util::IsEnemyPlayer( attacker ) ) )
	{
		scoreevents::processScoreEvent( "destroyed_uav", attacker, self.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_UAV", attacker.entnum );
		attacker challenges::addFlySwatterStat( weapon, self );
	}
	
	if( !self.leaving )
	{
		self RemoveActiveUAV();
		
		self killstreaks::play_destroyed_dialog_on_owner( "uav", self.killstreak_id );
	}
	
	self notify( "crashing" );
	
	self playsound ( "evt_helicopter_midair_exp" );
	
	params = level.killstreakBundle["uav"];
	if( isdefined( params.ksExplosionFX ) )
		PlayFXOnTag( params.ksExplosionFX, self, "tag_origin" );
	
	self StopLoopSound();
	self setModel( "tag_origin" );
	Target_Remove( self );
	self unlink();

	wait( 0.5 );
	
	ArrayRemoveValue( level.spawnedUAVs, self );
	self notify( "delete" );
	self delete();
}

function OnPlayerConnect()
{
	self.entNum = self getEntityNumber();
	
	if ( !level.teambased )
	{
		level.activeUAVs[ self.entNum ] = 0;
	}
	
	level.activePlayerUAVs[ self.entNum ] = 0; // needed for UAV-related kill scores
}

function OnPlayerSpawned()
{
	self endon( "disconnect" );
	if( level.teambased == false || level.multiteam == true )
	{	
		level notify( "uav_update" );
	}
}

function OnPlayerJoinedTeam()
{
	HideAllUAVsToSameTeam();
}

function OnTimeout()
{
	PlayAfterburnerFx();
	
	if( ( isdefined( self.is_damaged ) && self.is_damaged ) )
	{
		PlayFxOnTag( "killstreaks/fx_uav_damage_trail", self, "tag_body" );
	}

	self killstreaks::play_pilot_dialog_on_owner( "timeout", "uav" );
	
	self.leaving = true;
	self RemoveActiveUAV();	
	
	airsupport::Leave( ( 10 ) );
	wait( ( 10 ) );
	
	Target_Remove( self );
	ArrayRemoveValue( level.spawnedUAVs, self );
	self delete();
}

function OnTimecheck()
{
	self killstreaks::play_pilot_dialog_on_owner( "timecheck", "uav", self.killstreak_id );
}

function StartUAVFx()
{
	self endon( "death" );
	wait ( 0.1 );
	
	if( isdefined( self ) )
	{
		PlayFXOnTag( "killstreaks/fx_uav_lights", self, "tag_origin" );	
		PlayFXOnTag( "killstreaks/fx_uav_bunner", self, "tag_origin" );		
		self PlayLoopSound ("veh_uav_engine_loop", 1);		
	}
}

function PlayAfterburnerFx()
{
	self endon( "death" );
	wait ( 0.1 );
	
	if( isdefined( self ) )
	{
		PlayFXOnTag( "killstreaks/fx_uav_bunner", self, "tag_origin" );		
		self StopLoopSound();
		team = util::getOtherTeam( self.team );
		self playsoundtoteam ( "veh_kls_uav_afterburner" , team );
	}
}

function HasUAV( team_or_entnum )
{
	return level.activeUAVs[ team_or_entnum ] > 0;
}

function AddActiveUAV()
{
	if ( level.teamBased )
	{
		assert( isdefined( self.team ) );
		level.activeUAVs[self.team]++;	
	}
	else
	{
		assert( isdefined( self.entNum ) );
		if ( !isdefined( self.entNum ) )
		{
			self.entNum = self GetEntityNumber();
		}
		
		level.activeUAVs[ self.entNum ]++;
	}

	level.activePlayerUAVs[ self.entNum ]++;

	level notify ( "uav_update" );
}

function RemoveActiveUAV()
{
	uav = self;
	uav ResetActiveUAV();
	uav killstreakrules::killstreakStop( "uav", self.originalteam, self.killstreak_id );	
}

function ResetActiveUAV()
{
	if ( level.teamBased )
	{
		level.activeUAVs[self.team]--;
		assert( level.activeUAVs[self.team] >= 0 );
		
		if( level.activeUAVs[self.team] < 0 )
		{
			level.activeUAVs[self.team] = 0;
		}
	}
	else if( isdefined( self.owner ) )
	{
		assert( isdefined( self.owner.entNum ) );
		if( !isdefined( self.owner.entNum ) )
		{
			self.owner.entNum = self.owner getEntityNumber();
		}
		
		level.activeUAVs[self.owner.entNum]--;
		
		assert( level.activeUAVs[self.owner.entNum] >= 0 );
		if( level.activeUAVs[self.owner.entNum] < 0 )
		{
			level.activeUAVs[self.owner.entNum] = 0;
		}
	}
	
	if ( isdefined( self.owner ) )
	{		
		level.activePlayerUAVs[self.owner.entNum]--;
		assert( level.activePlayerUAVs[self.owner.entNum] >= 0 );
	}
	level notify ( "uav_update" );
}

function SetTeamUAV( team, value )
{
	SetTeamSpyplane( team, value );

	if( team == "allies" )
	{
		SetMatchFlag( "radar_allies", value );
	}
	else if ( team == "axis" ) 
	{
		SetMatchFlag( "radar_axis", value );
	}
}

function UAVTracker()
{
	level endon ( "game_ended" );
	
	while( true )
	{
		level waittill ( "uav_update" );
		
		if( level.teamBased )
		{
			foreach( team in level.teams )
			{
				activeUAVs = level.activeUAVs[ team ];
						
				if( !activeUAVs )
				{
					SetTeamUAV( team, 0 );
					continue;
				}
				
				uavSpeed = 1;
				if( activeUAVs > 1 )
				{
					uavSpeed = 2;
				}
			
				SetTeamUAV( team, uavSpeed );	
			}
		}
		else
		{
			for( i = 0; i < level.players.size; i++ )
			{
				player = level.players[ i ];
				
				assert( isdefined( player.entNum ) );
				if( !isdefined( player.entNum ) )
				{
					player.entNum = player getEntityNumber();
				}
				
				activeUAVs = level.activeUAVs[ player.entNum ];
				if( ( activeUAVs == 0 ) )
				{
					player SetClientUIVisibilityFlag( "radar_client", 0 );
					player.hasSpyplane = false;
					continue;
				}
				
				if ( activeUAVs > 1 )
				{
					uavSpeed = 2;
				}
				else
				{
					uavSpeed = 1;
				}
								
				player setClientUIVisibilityFlag( "radar_client", 1 );
				player.hasSpyplane = uavSpeed;
			}
		}
	}
}

function HideAllUAVsToSameTeam()
{
	foreach( uav in level.spawnedUAVs )
	{
		if ( isdefined( uav ) )
		{
			
			uav teams::HideToSameTeam();
		}
	}
}