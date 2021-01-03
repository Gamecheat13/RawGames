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
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#precache( "eventstring", "mpl_killstreak_radar" );
#precache( "string", "KILLSTREAK_EARNED_RADAR" );
#precache( "string", "KILLSTREAK_RADAR_INBOUND" );
#precache( "string", "KILLSTREAK_RADAR_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_DESTROYED_UAV" );

#precache( "fx", "killstreaks/fx_uav_exp" );
#precache( "fx", "killstreaks/fx_uav_damage_trail" );
#precache( "fx", "killstreaks/fx_uav_afterbunner" );	
#precache( "fx", "killstreaks/fx_uav_bunner" );
#precache( "fx", "killstreaks/fx_uav_lights" ); 


#namespace uav;
	
function init()
{	
	level.uavTimers = [];
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.activeUAVs[ team ] = 0;
			level.uavTimers[team] = 0;
		}
	}
	else
	{	
		level.activeUAVs = [];
	}
	
	if ( tweakables::getTweakableValue( "killstreak", "allowradar" ) )
	{
		killstreaks::register( "uav", "uav", "killstreak_uav", "uav_used", &ActivateUAV );
		killstreaks::register_strings( "uav", &"KILLSTREAK_EARNED_RADAR", &"KILLSTREAK_RADAR_NOT_AVAILABLE", &"KILLSTREAK_RADAR_INBOUND" );
		killstreaks::register_dialog( "uav", "mpl_killstreak_radar", 29, 43, 107, 125, 107 );

	}
	
	level thread UAVTracker();
	
	callback::on_connect( &OnPlayerConnect );
	callback::on_spawned( &OnPlayerSpawned );
	
	setMatchFlag( "radar_allies", 0 );
	setMatchFlag( "radar_axis", 0 );
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
	self killstreaks::play_killstreak_start_dialog( "uav", self.team );

	self killstreaks::pick_pilot( "uav", 2 );
	self killstreaks::play_pilot_dialog( "uav", 0, true );
	
	rotator = level.airsupport_rotator;
	attach_angle = -90;
	
	uav = spawn( "script_model", rotator getTagOrigin( "tag_origin" ) );
	uav setModel( "veh_t7_drone_uav" );
	uav.targetname = "uav";
	uav SetTeam( self.team );
	uav SetOwner( self );
	Target_Set( uav );
	
	uav SetDrawInfrared( true );
	
	uav.owner = self;
	uav.team = self.team;
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
	uav clientfield::set( "enemyvehicle", 1 );

	uav teams::HideToSameTeam();
	uav thread teams::WaitUntilTeamChange( self, &OnTeamChange, self.entNum, "delete", "death", "leaving" );
	uav thread killstreaks::WaitForTimeout( "uav", ( 25000 ), &OnTimeout, "delete", "death", "crashing" );
	uav thread killstreaks::WaitForTimecheck( ( ( 25000 ) / 2 ), &OnTimecheck, "delete", "death", "crashing" );
	uav thread util::WaitTillEndOnThreaded( "death", &DestroyUAV, "delete", "leaving" );
	
	uav thread StartUAVFx();
	self AddActiveUAV();
	
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
	if( isdefined( self.owner) )
	{
		self.owner killstreaks::play_pilot_dialog( "uav", 2 );
	}
	
	if( isdefined( attacker ) && ( !isdefined( self.owner ) ||  self.owner util::IsEnemyPlayer( attacker ) ) )
	{
		thread scoreevents::processScoreEvent( "destroyed_uav", attacker, self.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_UAV", attacker.entnum );
		attacker challenges::addFlySwatterStat( weapon, self );
	}
	
	if( !self.leaving )
	{
		self RemoveActiveUAV();
	}
	
	self notify( "crashing" );
	
	self playsound ( "evt_helicopter_midair_exp" );
	PlayFXOnTag( "killstreaks/fx_uav_exp", self, "tag_origin" );
	self StopLoopSound();
	
	self setModel( "tag_origin" );
	Target_Remove( self );
	self unlink();
	
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

function OnTimeout()
{
	PlayAfterburnerFx();
	
	if( ( isdefined( self.is_damaged ) && self.is_damaged ) )
	{
		PlayFxOnTag( "killstreaks/fx_uav_damage_trail", self, "tag_body" );
	}

	if( isdefined( self.owner) )
	{
		self.owner killstreaks::play_pilot_dialog( "uav", 5 );
	}
	
	self.leaving = true;
	self RemoveActiveUAV();	
	
	airsupport::Leave( ( 10 ) );
	wait( ( 10 ) );
	
	Target_Remove( self );
	self delete();
}

function OnTimecheck()
{
	if( isdefined( self.owner) )
	{
		self.owner killstreaks::play_pilot_dialog( "uav", 4 );
	}
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
		self playsound("veh_kls_uav_afterburner");
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
	
	killstreakrules::killstreakStop( "uav", self.team, self.killstreak_id );
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
