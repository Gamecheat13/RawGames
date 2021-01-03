#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\util_shared;
#using scripts\cp\_vehicle;



// _qrdrone.csc
// Sets up clientside behavior for the qrdrone




	
#precache( "client_fx", "_t6/weapon/qr_drone/fx_qr_light_red_3p" );
#precache( "client_fx", "_t6/weapon/qr_drone/fx_qr_light_green_3p" );
#precache( "client_fx", "_t6/weapon/qr_drone/fx_qr_light_green_1p" );

#namespace qrdrone;

function autoexec __init__sytem__() {     system::register("qrdrone",&__init__,undefined,undefined);    }
	
function __init__()
{
	type = "qrdrone_mp";
	
	clientfield::register( "helicopter", "qrdrone_state", 1, 3, "int",&stateChange, !true, !true );

	level._effect["qrdrone_enemy_light"] = "_t6/weapon/qr_drone/fx_qr_light_red_3p";
	level._effect["qrdrone_friendly_light"] = "_t6/weapon/qr_drone/fx_qr_light_green_3p";
	level._effect["qrdrone_viewmodel_light"] = "_t6/weapon/qr_drone/fx_qr_light_green_1p";

	// vehicle flags	
	clientfield::register( "helicopter", "qrdrone_countdown", 1, 1, "int", &start_blink, !true, !true );
	clientfield::register( "helicopter", "qrdrone_timeout", 1, 1, "int", &final_blink, !true, !true );
	
	vehicle::add_vehicletype_callback( "qrdrone_mp",&spawned );
}

function spawned( localClientNum ) // self == qrdrone
{
	self util::waittill_dobj( localClientNum );

	self thread restartFX( localClientNum, 0 );

	self thread collisionHandler(localClientNum);
	self thread engineStutterHandler(localClientNum);
	self thread QRDrone_watch_distance();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function stateChange( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");
	self util::waittill_dobj( localClientNum );

	self restartFX( localClientNum, newVal );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function restartFX( localClientNum, blinkStage ) // self == qrdrone
{
	self notify( "restart_fx" );

	/#println( "Restart QRDrone FX: stage " + blinkStage );#/

	switch( blinkStage )
	{
		case 0:
		{
			self spawn_solid_fx( localClientNum );
			break;
		}
		case 1:
		{
			self.fx_interval = 1.0;
			self spawn_blinking_fx( localClientNum );
			break;
		}
		case 2:
		{
			self.fx_interval = .133;
			self spawn_blinking_fx( localClientNum );
			break;
		}
		case 3:
		{
			self notify( "stopfx" );
			self notify( "fx_death" );
			return;
		}
	}

	self thread watchRestartFX( localClientNum );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchRestartFX( localClientNum )
{
	self endon("entityshutdown");

	level util::waittill_any( "demo_jump", "player_switch", "killcam_begin", "killcam_end" );

	self restartFX( localClientNum, clientfield::get( "qrdrone_state" ));
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function spawn_solid_fx( localClientNum ) // self == qrdrone
{
	if ( self IsLocalClientDriver( localClientNum ) )
	{
		fx_handle = playfxontag( localClientNum, level._effect["qrdrone_viewmodel_light"], self, "tag_body" );		
	}
	else if ( self util::friend_not_foe( localClientNum ) )
	{
		fx_handle = playfxontag( localClientNum, level._effect["qrdrone_friendly_light"], self, "tag_body" );
	}
	else
	{
		fx_handle = playfxontag( localClientNum, level._effect["qrdrone_enemy_light"], self, "tag_body" );
	}

	self thread cleanupFX( localClientNum, fx_handle );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function spawn_blinking_fx( localClientNum )
{
	self thread blink_fx_and_sound( localClientNum, "wpn_crossbow_alert" );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function blink_fx_and_sound( localClientNum, soundAlias )
{
	self endon( "entityshutdown" );
	self endon( "restart_fx" );
	self endon( "fx_death" );

	if ( !isdefined( self.interval ) )
	{
		self.interval = 1.0;
	}
	
	while(1)
	{
		self PlaySound( localClientNum, soundAlias );
		
		self spawn_solid_fx( localClientNum );
		util::server_wait( localClientNum, self.interval / 2);

		self notify( "stopfx" );
		
		util::server_wait( localClientNum, self.interval / 2);
		self.interval = (self.interval / 1.17);

		if (self.interval < .1)
		{
			self.interval = .1;
		}	
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function cleanupFX( localClientNum, handle )
{
	self util::waittill_any( "entityshutdown", "blink", "stopfx", "restart_fx" );
	stopfx( localClientNum, handle );
}

function start_blink( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if (!newVal)
		return;
		
	self notify("blink");
}

// this second state is necessary so killcams show the appropriate "fast blink" state
function final_blink( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if (!newVal)
		return;
	
	self.interval = .133;
}

function loop_local_sound( localClientNum, alias, interval, fx )
{
	self endon( "entityshutdown" );
	self endon( "stopfx" );

	level endon( "demo_jump" );
	level endon( "player_switch" );

	// also playing the blinking light fx with the sound

	if ( !isdefined( self.interval ) )
	{
		self.interval = interval;
	}
	
	while(1)
	{
		self PlaySound( localClientNum, alias );
		
		self spawn_solid_fx( localClientNum );
		util::server_wait( localClientNum, self.interval / 2);

		self notify( "stopfx" );
		
		util::server_wait( localClientNum, self.interval / 2);
		self.interval = (self.interval / 1.17);

		if (self.interval < .1)
		{
			self.interval = .1;
		}	
	}
}

function check_for_player_switch_or_time_jump( localClientNum )
{
	self endon("entityshutdown");

	level util::waittill_any( "demo_jump", "player_switch", "killcam_begin" );
	self notify( "stopfx" );

	waittillframeend;

	self thread blink_light( localClientNum );
	
	if ( isdefined( self.blinkStartTime ) && self.blinkStartTime <= level.serverTime )
	{
		self.interval = 1;
		self thread start_blink( localClientNum, true );
	}
	else
	{
		self spawn_solid_fx( localClientNum );
	}
	
	self thread check_for_player_switch_or_time_jump( localClientNum );
}

function blink_light( localClientNum )
{
	self endon("entityshutdown");
	level endon( "demo_jump" );
	level endon( "player_switch" );
	level endon( "killcam_begin" );	

	self waittill("blink");
	
	if ( !isdefined( self.blinkStartTime ) )
	{
		self.blinkStartTime = level.serverTime;
	}	

	if ( self IsLocalClientDriver( localClientNum ) )
	{
		self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["qrdrone_viewmodel_light"] );
	}
	else if ( self util::friend_not_foe( localClientNum ) )
	{
		self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["qrdrone_friendly_light"] );
	}
	else
	{
		self thread loop_local_sound( localClientNum, "wpn_crossbow_alert", 1, level._effect["qrdrone_enemy_light"] );
	}
}


function collisionHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_collision", hip, hitn, hit_intensity );

		driver_local_client = self GetLocalClientDriver();
		
		if( isdefined( driver_local_client ) )
		{
			//println( "veh_collision " + hit_intensity );
			player = getlocalplayer( driver_local_client );

			if( isdefined( player ) )
			{
				// todo - play sound here also
				if( hit_intensity > 15 )
				{
					player PlayRumbleOnEntity( driver_local_client, "damage_heavy" );
				}
				else
				{
					player PlayRumbleOnEntity( driver_local_client, "damage_light" );
				}
			}
		}
	}
}

function engineStutterHandler( localClientNum )
{
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		self waittill( "veh_engine_stutter" );
		if ( self IsLocalClientDriver( localClientNum ) )
		{
			player = getlocalplayer( localClientNum );
			
			if( isdefined( player ) )
			{
				player PlayRumbleOnEntity( localClientNum, "rcbomb_engine_stutter" );
			}
		}
	}
}

function getMinimumFlyHeight()
{	
	if ( !isdefined( level.airsupportHeightScale ) ) 
		level.airsupportHeightScale = 1;

	airsupport_height = struct::get( "air_support_height", "targetname");
	if ( isdefined(airsupport_height) )
	{
		planeFlyHeight = airsupport_height.origin[2];
	}
	else
	{
/#
		PrintLn("WARNING:  Missing air_support_height entity in the map.  Using default height.");
#/
		// original system
		planeFlyHeight = 850;
	
		if ( isdefined( level.airsupportHeightScale ) )
		{
			level.airsupportHeightScale = GetDvarInt( "scr_airsupportHeightScale", level.airsupportHeightScale );	
			planeFlyHeight *= GetDvarInt( "scr_airsupportHeightScale", level.airsupportHeightScale );	
		}
		
		if ( isdefined( level.forceAirsupportMapHeight ) )
		{
			planeFlyHeight += level.forceAirsupportMapHeight;
		}	
	}
	
	return planeFlyHeight;
}

function QRDrone_watch_distance()
{
	self endon ("entityshutdown" );
	
	qrdrone_height = struct::get( "qrdrone_height", "targetname");
	if ( isdefined(qrdrone_height) )
	{
		self.maxHeight = qrdrone_height.origin[2];
	}
	else
	{
		self.maxHeight = int(getMinimumFlyHeight());
	}
	
	self.maxDistance = 12800;		
	
	level.mapCenter = GetMapCenter();
	
	self.minHeight = level.mapCenter[2] - 800;		

	//	shouldn't be possible to start out of range, but just in case
	inRangePos = self.origin;	

	soundent = spawn (0, self.origin, "script_origin" );
	soundent linkto(self);
	
	// end static on vehicle death
	self thread QRDrone_staticStopOnDeath( soundent );
	
	//	loop
	while ( true )
	{
		if ( !self QRDrone_in_range() )
		{
			//	increase static with distance from exit point or distance to heli in proximity
			staticAlpha = 0;		
			while ( !self QRDrone_in_range() )
			{	                        
				if ( isdefined( self.heliInProximity ) )
				{
					dist = distance( self.origin, self.heliInProximity.origin );
					staticAlpha = 1 - ( (dist-150) / (300-150) );
				}
				else
				{
					dist = distance( self.origin, inRangePos );
					staticAlpha = min( 1, dist/200 );	
				}

				
				// SOUND: put sound code here to change the volume of the static while the player is 
				// in static.  staticAlpha will be 0 - 1. 0 being no static, 1 being full static.

				
				sid = soundent playloopsound ( "veh_qrdrone_static_lp", .2 );
				self vehicle::set_static_amount( staticAlpha * 2 );

				wait ( 0.05 );
			}
			
			
			//	fade out static
			self thread QRDrone_staticFade( staticAlpha, soundent, sid );
	
		}		
		inRangePos = self.origin;
		wait ( 0.05 );
	}
}


function QRDrone_in_range()
{
	if ( self.origin[2] < self.maxHeight && self.origin[2] > self.minHeight )
	{
		if ( self isInsideHeightLock() )
		{
				return true;
		}
	}
	return false;
}


function QRDrone_staticFade( staticAlpha, sndent, sid )
{
	self endon ( "entityshutdown" );
	while( self QRDrone_in_range() )
	{
		staticAlpha -= 0.05;
		if ( staticAlpha <= 0 )
		{
			// SOUND: Put call here to completely turn static sound off
			sndent StopAllLoopSounds (.5);
			//delete sid;
			self vehicle::set_static_amount( 0 );
			break;
		}
		
		// SOUND:  Put call here to change volume of static based on staticAlpha
		setsoundvolumerate( sid, .6 );
		setsoundvolume( sid, staticAlpha );
		
		self vehicle::set_static_amount( staticAlpha * 2 );
	
			
		wait( 0.05 );
	}
}

function QRDrone_staticStopOnDeath( sndent )
{
	self waittill ( "entityshutdown" );
	sndent StopAllLoopSounds (.1);
	sndent delete();
}
