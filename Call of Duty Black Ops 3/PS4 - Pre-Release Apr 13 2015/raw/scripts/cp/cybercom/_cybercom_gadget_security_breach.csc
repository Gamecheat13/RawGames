    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                      	                       	     	                                                                     
     

#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\util_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\postfx_shared;
#using scripts\shared\visionset_mgr_shared;

#namespace cybercom_security_breach;




function init()
{
	init_clientfields();
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	level.vehicle_transition_on	= [];
}

function init_clientfields()
{
	// clientfield setup
	clientfield::register( "toplayer", "hijack_vehicle_transition", 1, 2, "int", &player_vehicleTransition, !true, !true );
	clientfield::register( "toplayer", "hijack_static_effect", 1, 7, "float", &player_static_cb, !true, !true );
	clientfield::register( "toplayer", "sndInDrivableVehicle", 1, 1, "int", &sndInDrivableVehicle, !true, !true );

	clientfield::register( "vehicle", "vehicle_hijacked", 1, 1, "int", &player_hijacked_this_vehicle, !true, !true );
	clientfield::register( "toplayer", "hijack_spectate", 1, 1, "int", &player_spectate_cb, !true, !true );

	clientfield::register( "toplayer", "hijack_static_ramp_up", 1, 1, "int", &player_static_rampup_cb, !true, !true );
	
	visionset_mgr::register_visionset_info( "hijack_vehicle",		1, 7, undefined,	"vehicle_transition" );
	visionset_mgr::register_visionset_info( "hijack_vehicle_blur",	1, 7, undefined, "vehicle_hijack_blur" );
}

//---------------------------------------------------------
function on_player_connect(localClientNum)
{	
	filter::init_filter_vehicle_hijack_oor( self );
}
function on_player_spawned(localClientNum)
{	
	//Setting this context ahead of time
	setsoundcontext( "drivableveh", "3rdperson" );

}

function spectate(localClientNum,delta_time)
{
	player = getLocalPlayer(localClientNum);
	if(isDefined(player.vehicle_camera_pos))
		player CameraSetPosition( player.vehicle_camera_pos );

	ang = player getcamangles();
	if(isDefined(player.vehicle_camera_ang))
		ang = player.vehicle_camera_ang;
	
	ang = (ang[0],ang[1],0);
	player CameraSetLookat( ang );
}

function player_static_rampup_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal )
	{
		startStatic = (isDefined(self.last_hijack_oor_value)?self.last_hijack_oor_value:0);
		if ( !( isdefined( self.vehicle_hijack_filter_on ) && self.vehicle_hijack_filter_on ) )
		{
			filter::enable_filter_vehicle_hijack_oor( self, 0);
			self.vehicle_hijack_filter_on = true;
		}
		timeStart = GetTime();
		timeEnd = timeStart + 3*1000;
		timeCur = timeStart;
		playsound( localClientNum, "gdt_securitybreach_static_oneshot", (0,0,0) );
		while(timeCur< timeEnd)
		{
			timeCur = GetTime();
			curStatic = math::linear_map(timeCur, timeStart, timeEnd, startStatic, 1);
			filter::set_filter_vehicle_hijack_oor_amount( self, 0, curStatic );			
			wait 0.01;
		}
	}
	else
	{
		filter::disable_filter_vehicle_hijack_oor( self, 0);
		self.vehicle_hijack_filter_on = undefined;
	}
}

function player_spectate_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	self notify("player_spectate");
	if(newVal )
	{
		self CameraSetUpdateCallback( &spectate );
	}
	else
	{
		self CameraSetUpdateCallback();
		self.vehicle_camera_pos = undefined;
		self.vehicle_camera_ang = undefined;
	}
}

function player_update_angles(vehicle)
{
	self endon ("player_spectate");
	self endon("disconnect");
	self endon("spawn");
	self endon("entityshutdown");
	vehicle endon("entityshutdown");

	while(isAlive(vehicle))
	{
		self.vehicle_camera_pos = self getcampos();
		self.vehicle_camera_ang = self getcamangles();
		wait 0.01;
	}
}

function player_hijacked_this_vehicle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{//self = vehicle
	if ( self IsLocalClientDriver( localClientNum ) )
	{
		player = getLocalPlayer(localClientNum);
		player thread player_update_angles(self);
	}
}

function player_static_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(newVal != 0 )
	{
		self.last_hijack_oor_value = newVal;
		if ( !( isdefined( self.vehicle_hijack_filter_on ) && self.vehicle_hijack_filter_on ) )
		{
			filter::enable_filter_vehicle_hijack_oor( self, 0);
			self.vehicle_hijack_filter_on = true;
		}
		filter::set_filter_vehicle_hijack_oor_amount( self, 0, newVal );
	}

	if(( isdefined( self.vehicle_hijack_filter_on ) && self.vehicle_hijack_filter_on ) && newVal == 0 )
	{
		filter::disable_filter_vehicle_hijack_oor( self, 0 );
		self.vehicle_hijack_filter_on = undefined;
	}

//	self Randomfade( newVal );
	self thread static_sound(newVal);
}

function static_sound(val)
{
	
	if (!isdefined (level.static_soundent))
	{
		level.static_soundent = spawn(0, self.origin, "script_origin");
		level.static_soundent linkto (self);
	}

	
	if (val == 0)
	{
		level.static_soundent delete();
		level.static_soundent = undefined;
	}
	else
	{
		sid = level.static_soundent playloopsound ( "gdt_securitybreach_static_interference", 1 );
		setsoundvolume( sid, val );
		setsoundvolumerate( sid, 1 );
	}
}

function sndInDrivableVehicle(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if( newVal == 1 )
	{
		setsoundcontext( "drivableveh", "1stperson" );
		
		if (!isdefined (level.plr_dist_soundent)) //spawn ent playing silent wav to activate dist based duck
		{
			level.plr_dist_soundent = spawn (0, self.origin, "script_origin");
			level.plr_dist_soundent linkto (self);
			level.plr_dist_soundent playloopsound ("gdt_securitybreach_silence");
		}
		
	}
	else
	{
		setsoundcontext( "drivableveh", "3rdperson" );
		level.plr_dist_soundent delete();
		level.plr_dist_soundent = undefined;
	}
}

function player_vehicleTransition( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	switch(newVal)
	{
		case 2:
			self thread postfx::PlayPostfxBundle( "pstfx_vehicle_takeover_fade_in" );
			playsound( 0, "gdt_securitybreach_transition_in", (0,0,0) );
		break;		
		case 3:
			self thread postfx::PlayPostfxBundle( "pstfx_vehicle_takeover_fade_out" );
			playsound( 0, "gdt_securitybreach_transition_out", (0,0,0) );
		break;		
		case 1:
			self thread postfx::StopPostfxBundle();
		break;		
		case 4:
			self thread postfx::PlayPostfxBundle( "pstfx_vehicle_takeover_white" );
		break;		
	}
}

