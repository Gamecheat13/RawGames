#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    

#using_animtree ( "mp_microwaveturret" );

#namespace turret;

function autoexec __init__sytem__() {     system::register("killstreak_turret",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "scriptmover", "turret_microwave_open", 1, 1, "int", &microwave_open_anim, !true, !true );
	clientfield::register( "scriptmover", "turret_microwave_close", 1, 1, "int", &microwave_close_anim, !true, !true );
	clientfield::register( "scriptmover", "turret_microwave_destroy", 1, 1, "int", &microwave_destroy_anim, !true, !true );
	clientfield::register( "scriptmover", "turret_microwave_sounds", 1, 1, "int", &turret_microwave_sounds, !true, !true );
}

function turret_microwave_sounds( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{

	if( newVal == ( 1 ) )
	{
		self thread turret_microwave_sound_start( localClientNum );
	}
	else if( newVal == ( 0 ) )
	{
		self notify( "sound_stop" );
	}
}

function turret_microwave_sound_start( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "sound_stop" );

	origin = self GetTagOrigin( "tag_flash" );
	angles = self GetTagAngles( "tag_flash" );

	forward = AnglesToForward( angles );
	forward = VectorScale( forward, 750 );

	trace = BulletTrace( origin, origin + forward, false, self );

	start = origin;
	end = trace[ "position" ];
	
	self thread turret_microwave_sound_off_waiter( localClientNum, start, end );
	self playsound ( 0, "wpn_micro_turret_start");
	soundLineEmitter( "wpn_micro_turret_loop", start, end );
}

function turret_microwave_sound_off_waiter( localClientNum, start, end )
{
	self util::waittill_any( "sound_stop", "entityshutdown" );
	playsound (0, "wpn_micro_turret_stop", start);
	soundStopLineEmitter ( "wpn_micro_turret_loop", start, end );
}

function microwave_open_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	if ( !newVal )
		return;
	
	self UseAnimTree( #animtree );
	self SetAnim( %o_hpm_open, 1.0, 0.0, 1.0 );
}

function microwave_close_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	if ( !newVal )
		return;
	
	self UseAnimTree( #animtree );
	self SetAnim( %o_hpm_close, 1.0, 0.0, 1.0 );
}

function microwave_destroy_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self UseAnimTree( #animtree );
	self SetAnim( %o_hpm_destroyed, 1.0, 0.0, 1.0 );
}
