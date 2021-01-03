#using scripts\codescripts\struct;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\shared\callbacks_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\damagefeedback_shared;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\shared\scoreevents_shared;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\shared\math_shared;
#using scripts\mp\teams\_teams;
#using scripts\shared\killstreaks_shared;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#namespace satellite;


	
#precache( "eventstring", "mpl_killstreak_satellite" );
#precache( "string", "KILLSTREAK_EARNED_SATELLITE" );
#precache( "string", "KILLSTREAK_SATELLITE_INBOUND" );
#precache( "string", "KILLSTREAK_SATELLITE_NOT_AVAILABLE" );
	
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
		killstreaks::register( "satellite", "satellite", "killstreak_spyplane_direction", "uav_used", &ActivateSatellite );
		killstreaks::register_strings( "satellite", &"KILLSTREAK_EARNED_SATELLITE", &"KILLSTREAK_SATELLITE_NOT_AVAILABLE", &"KILLSTREAK_SATELLITE_INBOUND" );
		killstreaks::register_dialog( "satellite", "mpl_killstreak_satellite", 30, undefined, 108, 126, 108 );
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
	zOffset = minFlyHeight + ( 7000 );
	
	// pick a random start point from map center
	travelAngle = RandomFloatRange( ( 90.0 ), ( 180.0 ) );
	travelRadius = airsupport::GetMaxMapWidth() * ( 1.0 );
	xOffset = sin( travelAngle ) * travelRadius;
	yOffset = cos( travelAngle ) * travelRadius;

	satellite = spawn( "script_model", airsupport::GetMapCenter() + ( xOffset, yOffset, zOffset ));
	satellite setModel( "veh_t7_mil_orbital_vsat" );
	satellite SetScale( ( .3 ) );
	
	satellite.killstreak_id = killstreak_id;
	satellite.owner = self;
	satellite.ownerEntNum = self GetEntityNumber();
	satellite.team = self.team;
	satellite setTeam( self.team );
	satellite setOwner( self );
	satellite.targetname = "satellite";
	satellite.maxhealth = ( 700 );
	satellite.lowhealth = ( ( 700 ) * 0.4 );	
	satellite.health = 99999;

	satellite SetCanDamage( true );
	satellite thread killstreaks::MonitorDamage( "satellite", satellite.maxhealth, &DestroySatellite, satellite.lowhealth, &OnLowHealth, 0, undefined, false );

	satellite.rocketDamage = ( satellite.maxhealth / ( 3 ) ) + 1;
	
	satellite MoveTo( airsupport::GetMapCenter() + ( -xOffset, -yoffset, zOffset ), ( 40000 ) * 0.001 );

	Target_Set( satellite );

	satellite clientfield::set( "enemyvehicle", 1 );
	satellite teams::HideToSameTeam();
	
	satellite thread killstreaks::WaitTillEMP( &OnEMP );
	satellite thread teams::WaitUntilTeamChange( self, &OnTeamChange, self.entNum, "death", "entityshutdown", "timed_out" );
	satellite thread killstreaks::WaitForTimeout( "satellite", ( 40000 ), &DestroySatellite, "death" );
	
	satellite thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "death" );
	
	satellite AddActiveSatellite();
	satellite thread Rotate( ( 10 ) );
	
	self killstreaks::play_killstreak_start_dialog( "satellite", self.team );
	
	return true;
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

function OnLowHealth()
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
		//scoreevents::processScoreEvent( "destroyed_satellite", attacker, self, weapon );
	}
	
	self RemoveActiveSatellite();
	Target_Remove( self );
	self delete();
}

function OnEmp( attacker )
{
	weapon = GetWeapon( "emp" );
	
	challenges::destroyedAircraft( attacker, weapon );
	//thread scoreevents::processScoreEvent( "destroyed_satellite", attacker, self.owner, weapon );
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
	killstreakrules::killstreakStop( "satellite", self.team, self.killstreak_id );
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
