#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\math_shared;
#using scripts\shared\killstreaks_shared;

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\teams\_teams;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace satellite;



	
#precache( "string", "mpl_killstreak_satellite" );
#precache( "string", "KILLSTREAK_EARNED_SATELLITE" );
#precache( "string", "KILLSTREAK_SATELLITE_INBOUND" );
#precache( "string", "KILLSTREAK_DESTROYED_SATELLITE" );
#precache( "string", "KILLSTREAK_SATELLITE_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_SATELLITE_HACKED" );

function init()
{	
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.activeSatellites[ team ] = 0;
		}
	}
	else
	{	
		level.activeSatellites = [];
	}
	
	level.activePlayerSatellites = [];
	
	if ( tweakables::getTweakableValue( "killstreak", "allowradardirection" ) )
	{
		killstreaks::register( "satellite", "satellite", "killstreak_satellite", "uav_used", &ActivateSatellite );
		killstreaks::register_strings( "satellite", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND", undefined, &"KILLSTREAK_SATELLITE_HACKED" );
		killstreaks::register_dialog( "satellite", "mpl_killstreak_satellite", "satelliteDialogBundle", undefined, "friendlySatellite", "enemySatellite", "enemySatelliteMultiple", "friendlySatelliteHacked", "enemySatelliteHacked", "requestSatellite", "threatSatellite" );
	}
	
	callback::on_connect( &OnPlayerConnect );
	
	level thread SatelliteTracker();
}

function OnPlayerConnect()
{
	self.entnum = self getEntityNumber();
	
	if ( !level.teamBased )
	{
		level.activeSatellites[ self.entnum ] = 0;
	}
	
	level.activePlayerSatellites[ self.entnum ] = 0;  // needed for satellite-related kill scores
}

function ActivateSatellite()
{
	if( self killstreakrules::isKillstreakAllowed( "satellite", self.team ) == false )
	{
		return false;
	}

	killstreak_id = self killstreakrules::killstreakStart( "satellite", self.team );
	if(  killstreak_id == -1 )
	{
		return false;
	}
	
	minFlyHeight = int( airsupport::getMinimumFlyHeight() );
	zOffset = minFlyHeight + ( 6000 );
	
	// pick a random start point from map center
	travelAngle = RandomFloatRange( ( 90.0 ), ( 180.0 ) );
	travelRadius = airsupport::GetMaxMapWidth() * ( 2.5 );
	xOffset = sin( travelAngle ) * travelRadius;
	yOffset = cos( travelAngle ) * travelRadius;
	
	satellite = spawn( "script_model", airsupport::GetMapCenter() + ( xOffset, yOffset, zOffset ));
	satellite setModel( "veh_t7_drone_srv_blimp" );
	satellite SetScale( ( 1 ) );
	
	satellite.killstreak_id = killstreak_id;
	satellite.owner = self;
	satellite.ownerEntNum = self GetEntityNumber();
	satellite.team = self.team;
	satellite setTeam( self.team );
	satellite setOwner( self );
	satellite killstreaks::configure_team( "satellite", killstreak_id, self, undefined, undefined, &ConfigureTeamPost );
	satellite killstreak_hacking::enable_hacking( "satellite", &HackedPreFunction, undefined );
	satellite.targetname = "satellite";
	satellite.maxhealth = ( 700 );
	satellite.lowhealth = ( ( 700 ) * 0.4 );	
	satellite.health = 99999;

	satellite SetCanDamage( true );
	satellite thread killstreaks::MonitorDamage( "satellite", satellite.maxhealth, &DestroySatellite, satellite.lowhealth, &OnLowHealth, 0, undefined, false );

	satellite.rocketDamage = ( satellite.maxhealth / ( 3 ) ) + 1;
	
	/#
	//Box( airsupport::GetMapCenter() + ( xOffset, yOffset, zOffset ), (-4, -4, 0 ), ( 4, 4, 5000 ), 0, ( 1, 0, 0 ), 0.6, false, 2000 );	
	//Box( airsupport::GetMapCenter() + ( -xOffset, -yoffset, zOffset ), (-4, -4, 0 ), ( 4, 4, 5000 ), 0, ( 0, 1, 0 ), 0.6, false, 2000 );	
	#/
	
	satellite MoveTo( airsupport::GetMapCenter() + ( -xOffset, -yoffset, zOffset ), ( 40000 ) * 0.001 );

	Target_Set( satellite );

	satellite clientfield::set( "enemyvehicle", 1 );
	
	satellite thread killstreaks::WaitTillEMP( &OnEMP );
	satellite thread killstreaks::WaitForTimeout( "satellite", ( 40000 ), &DestroySatellite, "death" );
	
	satellite thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "death" );
	
	satellite thread Rotate( ( 10 ) );
	
	self killstreaks::play_killstreak_start_dialog( "satellite", self.team, killstreak_id );
	satellite thread killstreaks::player_killstreak_threat_tracking( "satellite" );
	return true;
}

function HackedPreFunction( hacker )
{
	satellite = self;
	satellite ResetActiveSatellite();
}

function ConfigureTeamPost( owner, isHacked )
{
	satellite = self;
	
	satellite thread teams::WaitUntilTeamChangeSingleTon( owner, "Satellite_watch_team_change", &OnTeamChange, self.entNum, "delete", "death", "leaving" );
	if ( isHacked == false )
	{
		satellite teams::HideToSameTeam();
	}
	else
	{
		satellite SetVisibleToAll();
	}
	satellite AddActiveSatellite();
}

function Rotate( duration )
{
	self endon( "death" );
	
	while( true )
	{
		self rotateyaw( -360, duration );
		wait( duration );
	}
}

function OnLowHealth( attacker, weapon )
{
}

function OnTeamChange( entNum, event )
{
	DestroySatellite( undefined, undefined );
}

function DestroySatellite( attacker = undefined, weapon = undefined )
{
	if( isdefined( attacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_satellite", attacker, self.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_SATELLITE", attacker.entnum );
		self killstreaks::play_destroyed_dialog_on_owner( "satellite", self.killstreak_id );
	}
	
	params = level.killstreakBundle["satellite"];
	if( isdefined( params.ksExplosionFX ) )	
		PlayFXOnTag( params.ksExplosionFX, self, "tag_origin" );
	
	self setModel( "tag_origin" );
	Target_Remove( self );
	
	wait( 0.5 );
	
	self RemoveActiveSatellite();
	self delete();
}

function OnEmp( attacker )
{
	weapon = GetWeapon( "emp" );
	
	challenges::destroyedAircraft( attacker, weapon );
	attacker challenges::addFlySwatterStat( weapon, self );

	DestroySatellite( attacker, weapon );
}

function HasSatellite( team_or_entnum )
{
	return level.activeSatellites[ team_or_entnum ] > 0;
}

function AddActiveSatellite()
{
	if ( level.teamBased )
	{
		level.activeSatellites[ self.team ]++;	
	}
	else
	{		
		level.activeSatellites[ self.ownerEntNum ]++;
	}
	
	level.activePlayerSatellites[ self.ownerEntNum ]++;

	level notify( "satellite_update" );
}

function RemoveActiveSatellite()
{
	self ResetActiveSatellite();

	killstreakrules::killstreakStop( "satellite", self.originalteam, self.killstreak_id );
}

function ResetActiveSatellite()
{
	if( level.teamBased )
	{
		level.activeSatellites[ self.team ]--;
		
		assert( level.activeSatellites[ self.team ] >= 0 );
		if( level.activeSatellites[ self.team ] < 0 )
		{
			level.activeSatellites[ self.team ] = 0;
		}
	}
	else if ( isdefined( self.ownerEntNum ) )
	{		
		level.activeSatellites[ self.ownerEntNum ]--;
		
		assert( level.activeSatellites[ self.ownerEntNum ] >= 0 );
		if( level.activeSatellites[ self.ownerEntNum ] < 0 )
		{
			level.activeSatellites[ self.ownerEntNum ] = 0;
		}
	}

	assert( isdefined( self.ownerEntNum ) );
	level.activePlayerSatellites[ self.ownerEntNum ]--;
	assert( level.activePlayerSatellites[ self.ownerEntNum ] >= 0 );

	level notify( "satellite_update" );
}

function SatelliteTracker()
{
	level endon ( "game_ended" );
	
	while( true )
	{
		level waittill ( "satellite_update" );
		
		if( level.teamBased )
		{
			foreach( team in level.teams )
			{
				activeSatellites = level.activeSatellites[ team ];
						
				if( !activeSatellites )
				{
					SetSatellite( team, 0 );
					continue;
				}
				
				SetSatellite( team, 1 );	
			}
		}
		else
		{
			for( i = 0; i < level.players.size; i++ )
			{
				player = level.players[ i ];
				
				assert( isdefined( player.entnum ) );
				if( !isdefined( player.entnum ) )
				{
					player.entnum = player getEntityNumber();
				}
				
				activeSatellites = level.activeSatellites[ player.entnum ];
				if( activeSatellites == 0 )
				{
					player SetClientUIVisibilityFlag( "radar_client", 0 );
					player.hasSatellite = false;
					continue;
				}
																
				player setClientUIVisibilityFlag( "radar_client", 1 );
				player.hasSatellite = true;
			}
		}
	}
}

function SetSatellite( team, value )
{
	SetTeamSatellite( team, value );

	if( team == "allies" )
	{
		SetMatchFlag( "radar_allies", value );
	}
	else if ( team == "axis" ) 
	{
		SetMatchFlag( "radar_axis", value );
	}
}
