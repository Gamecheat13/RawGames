#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



#precache( "client_fx", "_t6/weapon/harpy_swarm/fx_hrpy_swrm_exhaust_trail_close" );

#using_animtree( "mp_missile_drone" );

#namespace missile_swarm;

function autoexec __init__sytem__() {     system::register("missile_swarm",&__init__,undefined,undefined);    }
	
function __init__()
{
	level._effect["swarm_tail"] = "_t6/weapon/harpy_swarm/fx_hrpy_swrm_exhaust_trail_close";

	clientfield::register( "world", "missile_swarm", 1, 2, "int",&swarm_start, !true, !true );
}

function swarm_start( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player = GetLocalPlayer( localClientNum );

	if ( !isdefined( player ) )
	{
		return;
	}

	if ( player GetInKillcam( localClientNum ) )
	{
		return;
	}

	if ( IsDemoPlaying() )
	{
		return;
	}
		
	if ( newVal && newVal != oldVal && newval != 2 )
	{
		player thread swarm_think( localClientNum, self.origin );
	}
	else if ( !newVal )
	{
		level notify( "missile_swarm_stop" );
	}
	else if ( newVal == 2 )
	{
		level notify( "missile_emp_death" );
		level notify( "missile_swarm_stop" );
	}
}

function swarm_think( localClientNum, sound_origin )
{
	level endon( "missile_swarm_stop" );
	self endon( "entityshutdown" );

	self.missile_swarm_count = 0;
	self.missile_swarm_max	= 12;

	level thread swarm_sound( localClientNum, sound_origin );

	for ( ;; )
	{
		assert( self.missile_swarm_count >= 0 );

		if ( self.missile_swarm_count > self.missile_swarm_max )
		{
			wait( 0.5 );
			continue;
		}

		count = RandomIntRange( 1, 3 );
		self.missile_swarm_count += count;

		for ( i = 0; i < count; i++ )
		{
			self projectile_spawn( localClientNum );
		}
		
		wait( ( self.missile_swarm_count / self.missile_swarm_max ) );
	}
}

function projectile_spawn( localClientNum )
{
	dist = 10000;
	upVector = ( 0, 0, RandomIntRange( 1000, 1300 ) );

	yaw		= RandomIntRange( 0, 360 );
	angles	= ( 0, yaw, 0 );
	forward = AnglesToForward( angles );

	origin = self.origin + upVector + forward * dist * -1;
	end = self.origin + upVector + forward * dist;

	rocket = spawn( localClientNum, origin, "script_model" );
	rocket SetModel( "veh_t6_drone_hunterkiller_viewmodel" );
	
	rocket UseAnimTree( #animtree );
	rocket SetAnim( %o_drone_hunter_launch, 1.0, 0.0, 1.0 );

	rocket thread projectile_move_think( localClientNum, self, origin, end );
	rocket thread projectile_delete_think( localClientNum );
}

function projectile_move_think( localClientNum, player, start, end )
{
	level endon( "missile_emp_death" );
	
	wait( RandomFloatRange( 0.5, 1 ) );

	PlayFxOnTag( localClientNum, level._effect["swarm_tail"], self, "tag_origin" );

	direction = end - self.origin;
	self RotateTo( vectortoangles( direction ), 0.05 );
	self waittill( "rotatedone" );

	self MoveTo( end, RandomFloatRange( 12, 18 ) );
	self waittill( "movedone" );

	if ( isdefined( player ) )
	{
		player.missile_swarm_count--;
	}
	
	self delete();
}

function swarm_sound( localClientNum, origin )
{
	level endon( "missile_swarm_stop" );
	entity = spawn( localClientNum, origin, "script_model" );
	entity thread deleteOnMissileSwarmStop();
	
	wait( 2 );
	
	entity PlayLoopSound( "veh_harpy_drone_swarm_close__lp", 1 );
}

function deleteOnMissileSwarmStop()
{
	level waittill( "missile_swarm_stop" );
	self StopLoopSound( 1 );

	wait( 1 );
	self delete();
}

function projectile_delete_think( localClientNum )
{
	self endon( "death" );
	
	level waittill( "missile_emp_death" );
		
	if( isdefined( self ) )
	{
		self delete();
	}
}