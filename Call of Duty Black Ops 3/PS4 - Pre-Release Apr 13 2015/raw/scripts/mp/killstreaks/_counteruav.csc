#using scripts\codescripts\struct;

#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_satellite;
#using scripts\mp\teams\_teams;

#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\damagefeedback_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\system_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;

                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       


#namespace counteruav;

#precache( "string", "KILLSTREAK_COUNTERUAV_INBOUND" );
#precache( "string", "KILLSTREAK_COUNTERUAV_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_EARNED_COUNTERUAV" );
#precache( "fx", "killstreaks/fx_cuav_jammer" );

	
function init()
{	
	level.activeCounterUAVs = [];
	level.counter_uav_positions = GenerateRandomPoints( ( 20 ) );
	level.counter_uav_position_index = [];
	level.counter_uav_offsets = BuildOffsetList( ( 0, 0, 0 ), ( 3 ), ( 450 ), ( 450 ) );
	level.counter_uav_offset_index = [];
	
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.activeCounterUAVs[ team ] = 0;
			level.counter_uav_position_index[ team ] = 0;
			level.counter_uav_offset_index[ team ] = 0;

			level thread MovementManagerThink( team );
		}
	}
	else
	{
		level.activeCounterUAVs = [];
	}
	
	level.activePlayerCounterUAVs = [];
			
	if( tweakables::getTweakableValue( "killstreak", "allowcounteruav" ) )
	{
		killstreaks::register( "counteruav", "counteruav", "killstreak_counteruav", "counteruav_used", &ActivateCounterUAV );
		killstreaks::register_strings( "counteruav", &"KILLSTREAK_EARNED_COUNTERUAV", &"KILLSTREAK_COUNTERUAV_NOT_AVAILABLE", &"KILLSTREAK_COUNTERUAV_INBOUND" );
		killstreaks::register_dialog( "counteruav", "mpl_killstreak_radar", 3, undefined, 94, 112, 94 );
	}
	
	clientfield::register( "toplayer", "counteruav", 1, 1, "int" );
	level thread WatchCounterUAVs();
	
	callback::on_connect( &OnPlayerConnect );
	callback::on_spawned( &OnPlayerSpawned );
}

function OnPlayerConnect()
{
	self.entNum = self getEntityNumber();
	
	if( !level.teamBased )
	{
		level.activeCounterUAVs[ self.entNum ] = 0;
		level.counter_uav_position_index[ self.entNum ] = 0;
		level.counter_uav_offset_index[ self.entNum ] = 0;
		self thread MovementManagerThink( self.entnum );
	}
	
	level.activePlayerCounterUAVs[ self.entNum ] = 0;
}

function OnPlayerSpawned()
{
	if( self EnemyCounterUAVActive() )
	{
		self clientfield::set_to_player( "counteruav", 1 );
	}
	else
	{
		self clientfield::set_to_player( "counteruav", 0 );
	}
}

function GenerateRandomPoints( count )
{
	points = [];
	
	for( i = 0; i < count; i++ )
	{
		point = airsupport::GetRandomMapPoint( ( 0.80 ) );
		minFlyHeight = airsupport::getMinimumFlyHeight();
		point = point + ( 0, 0, minFlyHeight + ( 1000 ) );
		points[ i ] = point;
	}
	
	return points;
}

function MovementManagerThink( teamOrEntNum )
{
	while( true )
	{
		level waittill( "counter_uav_updated" );
		
		activeCount = 0;
		
		while( level.activeCounterUAVs[ teamOrEntNum ] > 0 )
		{
			if( activeCount == 0 )
			{
				activeCount = level.activeCounterUAVs[ teamOrEntNum ];
			}
			
			if( activeCount != level.activeCounterUAVs[ teamOrEntNum ] )
			{
				level.counter_uav_offset_index[ teamOrEntNum ] = 0;
			}
			
			currentIndex = level.counter_uav_position_index[ teamOrEntNum ];
			newIndex = currentIndex;
			
			while( newIndex == currentIndex )
			{
				newIndex = RandomIntRange( 0, ( 20 ) );	
			}
			
			destination = level.counter_uav_positions[ newIndex ];
			level.counter_uav_position_index[ teamOrEntNum ] = newIndex;
			
			level notify( "counter_uav_move_" + teamOrEntNum );
			wait( ( 5 ) + RandomIntRange( ( 5 ), ( 10 ) ) );
		}
	}
}

function GetCurrentPosition( teamOrEntNum )
{
	basePosition = level.counter_uav_positions[ level.counter_uav_position_index[ teamOrEntNum ] ];
	offset = level.counter_uav_offsets[ level.counter_uav_offset_index[ teamOrEntNum ] ];
	
	level.counter_uav_offset_index[ teamOrEntNum ]++;
	if( level.counter_uav_offset_index[ teamOrEntNum ] >= level.counter_uav_offsets.size )
	{
		level.counter_uav_offset_index[ teamOrEntNum ] = 0;
	}
	
	return basePosition + offset;
}

function BuildOffsetList( startOffset, depth, offset_x, offset_y )
{
	offsets = [];
	for( col = 0; col < depth; col++ )
	{
		itemCount = math::pow( 2, col );
		startingIndex = ( math::pow( 2, col ) - 1 );
		
		for( i = 0; i < itemCount; i++ )
		{
			x = offset_x * col;

			y = 0;
			if( itemCount > 1 )
			{
				y = ( i * offset_y );
				total_y = offset_y * ( itemCount - 1 );
				y -= ( total_y  / 2 );
			}
			
			offsets[ startingIndex + i ] = startOffset + ( x, y, 0 );
		}
	}
	
	return offsets;
}

function ActivateCounterUAV()
{
	if( self killstreakrules::isKillstreakAllowed( "counteruav", self.team ) == false )
	{
		return false;
	}

	killstreak_id = self killstreakrules::killstreakStart( "counteruav", self.team );
	if(  killstreak_id == -1 )
	{
		return false;
	}

	counterUav = SpawnCounterUAV( self );
	if( !isdefined( counterUav ) )
	{
		return false;
	}
	
	self killstreaks::play_killstreak_start_dialog( "counteruav", self.team );
	
	counterUAV SetScale( ( 1 ) );
	
	counterUav clientfield::set( "enemyvehicle", 1 );
	counterUav.killstreak_id = killstreak_id;
	
	counterUav AddActiveCounterUAV();
	
	counterUav teams::HideToSameTeam();
	counterUav thread killstreaks::WaitTillEMP( &DestroyCounterUav );
	counterUav thread teams::WaitUntilTeamChange( self, &OnTeamChange, self.entNum, "death", "leaving", "crashing" );
	counterUav thread killstreaks::WaitForTimeout( "counteruav", ( 30000 ), &OnTimeout, "delete", "death", "crashing" );
	counterUav thread util::WaitTillEndOnThreaded( "death", &DestroyCounterUav, "delete", "leaving" );
	
	counterUav SetCanDamage( true );
	counterUav thread killstreaks::MonitorDamage( "counteruav", ( 700 ), &DestroyCounterUAV, ( 700 ), &OnLowHealth, 0, undefined, true );
	
	counterUav PlayLoopSound( "veh_uav_engine_loop", 1 );
	PlayFXOnTag ( "killstreaks/fx_cuav_jammer", counterUav, "tag_origin" );
	
	counterUav thread ListenForMove();
	
	return true;
}

function SpawnCounterUAV( owner )
{
	minFlyHeight = airsupport::getMinimumFlyHeight();
	cuav = spawn( "script_model", airsupport::GetMapCenter() + ( 0, 0, ( minFlyHeight + ( 1000 ) ) ) );
	
	cuav setModel( "veh_t7_drone_cuav" );
	cuav.targetname = "counteruav";

	cuav SetTeam( owner.team );
	cuav SetOwner( owner );
	
	Target_Set( cuav );

	cuav.owner = owner;
	cuav.ownerEntNum = owner.entNum;
	cuav.team = owner.team;
	
	cuav thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );
	
	cuav.maxhealth = ( 700 );
	cuav.health = 99999;
	cuav.rocketDamage = ( 700 ) + 1;
	
	cuav SetDrawInfrared( true );
		
	return cuav;
}

function ListenForMove()
{
	self endon( "death" );
	self endon( "leaving" );
	
	while( true )
	{
		self thread CounterUAVMove();
		level util::waittill_any( "counter_uav_move_" + self.team, "counter_uav_move_" + self.ownerEntNum );
	}
}

function CounterUAVMove()
{
	self endon( "death" );
	self endon( "leaving" );
	level endon( "counter_uav_move_" + self.team );
	
	destination = ( 0, 0, 0 );
	
	if( level.teamBased )
	{
		destination = GetCurrentPosition( self.team );
	}
	else
	{
		destination = GetCurrentPosition( self.ownerEntNum );
	}
	
	lookAngles = VectorToAngles( destination - self.origin );
	rotationAccelerationDuration = ( 0.5 ) * ( 0.2 );
	rotationDecelerationDuration = ( 0.5 ) *( 0.2 );
	self RotateTo( lookAngles, ( 0.5 ), rotationAccelerationDuration, rotationDecelerationDuration );
	self waittill( "rotatedone" );
	
	travelAccelerationDuration = ( 5 ) * ( 0.2 );
	travelDecelerationDuration = ( 5 ) * ( 0.2 );
	self MoveTo( destination, ( 5 ), travelAccelerationDuration, travelDecelerationDuration );
}

function PlayFx( name )
{
	self endon( "death" );
	wait ( 0.1 );
	
	if ( isdefined( self ) )
	{
		PlayFXOnTag( name, self, "tag_origin" );
	}
}

function OnLowHealth()
{
}

function OnTeamChange( entNum, event )
{
	DestroyCounterUAV( undefined, undefined );
}

function OnTimeout()
{
	self airsupport::Leave( ( 5 ) );
	wait( ( 5 ) );
	self RemoveActiveCounterUAV();
	Target_Remove( self );
	self delete();
}

function DestroyCounterUAV( attacker, weapon )
{
	if( isdefined( attacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_counter_uav", attacker, self, weapon );
	}
	
	self PlaySound( "evt_helicopter_midair_exp" );
	self RemoveActiveCounterUAV();
	Target_Remove( self );
	self thread DeleteCounterUAV();
}

function DeleteCounterUAV()
{
	self notify( "crashing" );
	
	self thread PlayFx( "killstreaks/fx_uav_exp" );
	wait( 0.1 );
	
	self setModel( "tag_origin" );
	wait( 0.2 );
	
	self notify( "delete" );
	self delete();
}

function EnemyCounterUAVActive()
{
	if( level.teamBased )
	{
		foreach( team in level.teams )
		{
			if( team == self.team )
			{
				continue;
			}
			
			if( TeamHasActiveCounterUAV( team ) )
			{
				return true;
			}
		}
	}
	else
	{
		enemies = self teams::GetEnemyPlayers();
		foreach( player in enemies )
		{
			if( player HasActiveCounterUAV() )
			{
				return true;
			}
		}
	}
	
	return false;
}

function HasActiveCounterUAV()
{
	return ( level.activeCounterUAVs[ self.entNum ] > 0 );
}

function TeamHasActiveCounterUAV( team )
{
	return ( level.activeCounterUAVs[ team ] > 0 );
}

function AddActiveCounterUAV()
{
	if ( level.teamBased )
	{
		level.activeCounterUAVs[ self.team ]++;	
		
		foreach( team in level.teams )
		{
			if ( team == self.team )
			{
				continue;
			}
			
			if( satellite::HasSatellite( team ) )
			{
				self.owner challenges::blockedSatellite();
			}
		}
	}
	else 
	{
		level.activeCounterUAVs[ self.ownerEntnum ]++;
		
		keys = getarraykeys( level.activeCounterUAVs );
		for ( i = 0; i < keys.size; i++ )
		{
			if( keys[i] == self.ownerEntNum )
			{
				continue;
			}

			if( satellite::HasSatellite( keys[i] ) )
			{
				self.owner challenges::blockedSatellite();
				break;
			}
		}
	}
	
	level.activePlayerCounterUAVs[ self.ownerEntNum ]++;

	level notify( "counter_uav_updated" );
}

function RemoveActiveCounterUAV()
{
	if ( level.teamBased )
	{
		level.activeCounterUAVs[ self.team ]--;
		assert( level.activeCounterUAVs[ self.team ] >= 0 );
		if ( level.activeCounterUAVs[ self.team ] < 0 ) 
		{
			level.activeCounterUAVs[ self.team ] = 0;
		}
	}
	else if ( isdefined( self.owner ) )
	{
		assert( isdefined( self.ownerEntNum ) );
		if ( !isdefined( self.ownerEntNum ) )
		{
			self.ownerEntNum = self.owner getEntityNumber();
		}
		
		level.activeCounterUAVs[self.ownerEntNum ]--;
		
		assert( level.activeCounterUAVs[ self.ownerEntNum ] >= 0 );
		if ( level.activeCounterUAVs[ self.ownerEntNum ] < 0 ) 
		{
			level.activeCounterUAVs[ self.ownerEntNum ] = 0;
		}
	}

	level.activePlayerCounterUAVs[ self.ownerEntNum ]--;

	killstreakrules::killstreakStop( "counteruav", self.team, self.killstreak_id );
	level notify ( "counter_uav_updated" );
}

function WatchCounterUAVs()
{
	while( true )
	{
		level waittill( "counter_uav_updated" );
		
		foreach( player in level.players )
		{
			if( player EnemyCounterUAVActive() )
			{
				player clientfield::set_to_player( "counteruav", 1 );
			}
			else
			{
				player clientfield::set_to_player( "counteruav", 0 );
			}
		}
	}
}
