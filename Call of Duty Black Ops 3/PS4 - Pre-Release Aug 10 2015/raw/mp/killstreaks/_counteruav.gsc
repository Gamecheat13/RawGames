#using scripts\codescripts\struct;

#using scripts\mp\_util;
#using scripts\mp\gametypes\_battlechatter;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
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
#precache( "string", "KILLSTREAK_DESTROYED_COUNTERUAV" );
#precache( "string", "KILLSTREAK_COUNTERUAV_HACKED" );
#precache( "string", "mpl_killstreak_radar" );

	
function init()
{	
	level.activeCounterUAVs = [];
	level.counter_uav_positions = GenerateRandomPoints( ( 20 ) );
	level.counter_uav_position_index = [];
	level.counter_uav_offsets = BuildOffsetList( ( 0, 0, 0 ), ( 3 ), ( 450 ), ( 450 ) );
	
	if ( level.teamBased )
	{
		foreach( team in level.teams )
		{
			level.activeCounterUAVs[ team ] = 0;
			level.counter_uav_position_index[ team ] = 0;

			level thread MovementManagerThink( team );
		}
	}
	else
	{
		level.activeCounterUAVs = [];
	}
	
	level.activePlayerCounterUAVs = [];
	
	level.counter_uav_entities = [];
			
	if( tweakables::getTweakableValue( "killstreak", "allowcounteruav" ) )
	{
		killstreaks::register( "counteruav", "counteruav", "killstreak_counteruav", "counteruav_used", &ActivateCounterUAV );
		killstreaks::register_strings( "counteruav", &"KILLSTREAK_EARNED_COUNTERUAV", &"KILLSTREAK_COUNTERUAV_NOT_AVAILABLE", &"KILLSTREAK_COUNTERUAV_INBOUND", undefined, &"KILLSTREAK_COUNTERUAV_HACKED" );
		killstreaks::register_dialog( "counteruav", "mpl_killstreak_radar", "counterUavDialogBundle", "counterUavPilotDialogBundle", "friendlyCounterUav", "enemyCounterUav", "enemyCounterUavMultiple", "friendlyCounterUavHacked", "enemyCounterUavHacked", "requestCounterUav", "threatCounterUav" );
	}

	clientfield::register( "toplayer", "counteruav", 1, 1, "int" );
	level thread WatchCounterUAVs();
	
	callback::on_connect( &OnPlayerConnect );
	callback::on_spawned( &OnPlayerSpawned );
	callback::on_joined_team( &OnPlayerJoinedTeam );
	
/#
	if ( GetDvarInt( "scr_cuav_offset_debug" ) )
		level thread WaitAndDebugDrawOffsetList();
#/

}

function OnPlayerConnect()
{
	self.entNum = self getEntityNumber();
	
	if( !level.teamBased )
	{
		level.activeCounterUAVs[ self.entNum ] = 0;
		level.counter_uav_position_index[ self.entNum ] = 0;
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
		point = airsupport::GetRandomMapPoint( ( 0.50 ) );
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
	offset = level.counter_uav_offsets[ self.cuav_offset_index ];
	
	return basePosition + offset;
}

function AssignFirstAvailableOffsetIndex()
{
	self.cuav_offset_index = GetFirstAvailableOffsetIndex();
	
	MaintainCouterUavEntities();
}

function GetFirstAvailableOffsetIndex()
{
	// init available offset array
	available_offsets = [];
	for( i = 0; i < level.counter_uav_offsets.size; i++ )
		available_offsets[ i ] = true;
	
	// update available offsets array
	foreach( cuav in level.counter_uav_entities )
	{
		if ( isdefined( cuav ) )
		{
			available_offsets[ cuav.cuav_offset_index ] = false;
		}
	}
	
	// return first available
	for( i = 0; i < available_offsets.size; i++ )
	{
		if ( available_offsets[ i ] )
			return i;
	}
	
	/#util::warning("Max counter-uav available offset slots reached. Using slot 0 for now.");#/
	
	return 0;
}

function MaintainCouterUavEntities()
{
	for( i = level.counter_uav_entities.size; i >= 0; i-- )
	{
		if ( !isdefined( level.counter_uav_entities[ i ] ) )
	    {
			ArrayRemoveIndex( level.counter_uav_entities, i );
	    }
	}
}


/#
function WaitAndDebugDrawOffsetList()
{
	level endon( "game_ended" );

	wait 10;
	DebugDrawOffsetList();
}

function DebugDrawOffsetList()
{
	basePosition = level.counter_uav_positions[ 0 ];

	foreach ( offset in level.counter_uav_offsets )
	{
		 util::debug_sphere( basePosition + offset, 24, ( 0.95, 0.05, 0.05 ), 0.75, 9999999 ); 
	}
}
#/

function BuildOffsetList( startOffset, depth, offset_x, offset_y )
{
	offsets = [];
	for( col = 0; col < depth; col++ )
	{
		itemCount = math::pow( 2, col );
		startingIndex = ( itemCount - 1 );
		
		for( i = 0; i < itemCount; i++ )
		{
			x = offset_x * col;

			y = 0;
			if( itemCount > 1 )
			{
				y = ( i * offset_y );
				total_y = offset_y * startingIndex;
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

	counterUav = SpawnCounterUAV( self, killstreak_id );
	if( !isdefined( counterUav ) )
	{
		return false;
	}
	
	counterUAV SetScale( ( 1 ) );
	
	counterUav clientfield::set( "enemyvehicle", 1 );
	counterUav.killstreak_id = killstreak_id;
	
	counterUav thread killstreaks::WaitTillEMP( &DestroyCounterUav );
	counterUav thread killstreaks::WaitForTimeout( "counteruav", ( 30000 ), &OnTimeout, "delete", "death", "crashing" );
	counterUav thread killstreaks::WaitForTimecheck( ( ( 30000 ) / 2 ), &OnTimecheck, "delete", "death", "crashing" );
	counterUav thread util::WaitTillEndOnThreaded( "death", &DestroyCounterUav, "delete", "leaving" );
	
	counterUav SetCanDamage( true );
	counterUav thread killstreaks::MonitorDamage( "counteruav", ( 700 ), &DestroyCounterUAV, ( ( 700 ) * 0.4 ), &OnLowHealth, 0, undefined, true );
	
	counterUav PlayLoopSound( "veh_uav_engine_loop", 1 );
	
	counterUav thread ListenForMove();
	
	self killstreaks::play_killstreak_start_dialog( "counteruav", self.team, killstreak_id );
	counterUav killstreaks::play_pilot_dialog_on_owner( "arrive", "counteruav", killstreak_id );
	counterUav thread killstreaks::player_killstreak_threat_tracking( "counteruav" );
	
	return true;
}

function HackedPreFunction( hacker )
{
	cuav = self;
	cuav ResetActiveCounterUAV();
}

function SpawnCounterUAV( owner, killstreak_id )
{
	minFlyHeight = airsupport::getMinimumFlyHeight();
	//cuav = spawn( "script_model", airsupport::GetMapCenter() + ( 0, 0, ( minFlyHeight + COUNTER_UAV_POSITION_Z_OFFSET ) ) );
	
	cuav = SpawnVehicle( "veh_counteruav_mp", airsupport::GetMapCenter() + ( 0, 0, ( minFlyHeight + ( 1000 ) ) ), ( 0, 0, 0 ), "counteruav" );
	cuav AssignFirstAvailableOffsetIndex();
	
	cuav killstreaks::configure_team( "counteruav", killstreak_id, owner, undefined, undefined, &ConfigureTeamPost );
	cuav killstreak_hacking::enable_hacking( "counteruav", &HackedPreFunction, undefined );
		
	cuav.targetname = "counteruav";
	
	killstreak_detect::killstreakTargetSet( cuav );
	
	cuav thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "crashing" );
	
	cuav.maxhealth = ( 700 );
	cuav.health = 99999;
	cuav.rocketDamage = ( 700 ) + 1;
	
	cuav SetDrawInfrared( true );
	
	if ( !isdefined( level.counter_uav_entities ) ) level.counter_uav_entities = []; else if ( !IsArray( level.counter_uav_entities ) ) level.counter_uav_entities = array( level.counter_uav_entities ); level.counter_uav_entities[level.counter_uav_entities.size]=cuav;;
		
	return cuav;
}


function ConfigureTeamPost( owner, isHacked )
{
	cuav = self;

	if ( isHacked == false )
	{
		cuav teams::HideToSameTeam();
	}
	else
	{
		cuav SetVisibleToAll();
	}
	cuav thread teams::WaitUntilTeamChangeSingleton( owner, "CUAV_watch_team_change", &OnTeamChange, self.entNum, "death", "leaving", "crashing" );
	cuav AddActiveCounterUAV();
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
		destination = self GetCurrentPosition( self.team );
	}
	else
	{
		destination = self GetCurrentPosition( self.ownerEntNum );
	}
	
	lookAngles = VectorToAngles( destination - self.origin );
	rotationAccelerationDuration = ( 0.5 ) * ( 0.2 );
	rotationDecelerationDuration = ( 0.5 ) *( 0.2 );
	
	// as a vehicle, we cannot use RotateTo anymore; we'll figure this out soon
	// self RotateTo( lookAngles, COUNTER_UAV_ROTATION_DURATION, rotationAccelerationDuration, rotationDecelerationDuration );
	// self waittill( "rotatedone" );
	
	travelAccelerationDuration = ( 5 ) * ( 0.2 );
	travelDecelerationDuration = ( 5 ) * ( 0.2 );
	//self MoveTo( destination, COUNTER_UAV_SPEED, travelAccelerationDuration, travelDecelerationDuration );
	self SetVehGoalPos( destination, true, false );
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

function OnLowHealth( attacker, weapon )
{
	self.is_damaged = true;
}

function OnTeamChange( entNum, event )
{
	DestroyCounterUAV( undefined, undefined );
}

function OnPlayerJoinedTeam()
{
	HideAllCounterUAVsToSameTeam();
}

function OnTimeout()
{
	self.leaving = true;
	
	self killstreaks::play_pilot_dialog_on_owner( "timeout", "counteruav" );
	
	self airsupport::Leave( ( 5 ) );
	wait( ( 5 ) );
	self RemoveActiveCounterUAV();
	Target_Remove( self );
	self delete();
}

function OnTimecheck()
{
	self killstreaks::play_pilot_dialog_on_owner( "timecheck", "counteruav", self.killstreak_id );
}

function DestroyCounterUAV( attacker, weapon )
{
	if ( self.leaving !== true )
	{
		self killstreaks::play_destroyed_dialog_on_owner( "counteruav", self.killstreak_id );
	}
	
	if( isdefined( attacker ) && ( !isdefined( self.owner ) ||  self.owner util::IsEnemyPlayer( attacker ) ) )
	{
		scoreevents::processScoreEvent( "destroyed_counter_uav", attacker, self.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_COUNTERUAV", attacker.entnum );
	}

	self PlaySound( "evt_helicopter_midair_exp" );
	self RemoveActiveCounterUAV();
	Target_Remove( self );
	self thread DeleteCounterUAV();
}

function DeleteCounterUAV()
{
	self notify( "crashing" );
	
	params = level.killstreakBundle["counteruav"];
	if( isdefined( params.ksExplosionFX ) )	
		self thread PlayFx( params.ksExplosionFX );
	
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
	cuav = self;
	cuav ResetActiveCounterUAV();
	cuav killstreakrules::killstreakStop( "counteruav", self.originalteam, self.killstreak_id );
}

function ResetActiveCounterUAV()
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

function HideAllCounterUAVsToSameTeam()
{
	foreach( counteruav in level.counter_uav_entities )
	{
		if ( isdefined( counteruav ) )
		{
			counteruav teams::HideToSameTeam();
			
		}
	}
}
