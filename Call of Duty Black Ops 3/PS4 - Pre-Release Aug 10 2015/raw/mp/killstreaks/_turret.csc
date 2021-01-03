#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     

#using_animtree( "mp_microwaveturret" );

#namespace turret;

function autoexec __init__sytem__() {     system::register("killstreak_turret",&__init__,undefined,undefined);    }

function __init__()
{
	clientfield::register( "vehicle", "turret_microwave_open", 1, 1, "int", &microwave_open_anim, !true, !true );
	clientfield::register( "scriptmover", "turret_microwave_init", 1, 1, "int", &microwave_init_anim, !true, !true );
	clientfield::register( "scriptmover", "turret_microwave_close", 1, 1, "int", &microwave_close_anim, !true, !true );
	clientfield::register( "vehicle", "turret_microwave_sounds", 1, 1, "int", &turret_microwave_sounds, !true, !true );
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
	
	self playsound ( 0, "wpn_micro_turret_start");

	wait 0.7; // wait until deploy animation is finished
	
	origin = self GetTagOrigin( "tag_flash" );
	angles = self GetTagAngles( "tag_flash" );

	forward = AnglesToForward( angles );
	forward = VectorScale( forward, 750 );

	trace = BulletTrace( origin, origin + forward, false, self );

	start = origin;
	end = trace[ "position" ];
		
	self.microwave_audio_start = start;
	self.microwave_audio_end = end;
	self thread turret_microwave_sound_updater();
	
	soundLineEmitter( "wpn_micro_turret_loop", self.microwave_audio_start, self.microwave_audio_end );
	self thread turret_microwave_sound_off_waiter( localClientNum );
}

function turret_microwave_sound_off_waiter( localClientNum )
{
	self util::waittill_any( "sound_stop", "entityshutdown" );
	playsound (0, "wpn_micro_turret_stop", self.microwave_audio_start);
	soundStopLineEmitter ( "wpn_micro_turret_loop", self.microwave_audio_start, self.microwave_audio_end );
}

function turret_microwave_sound_updater()
{
	self endon( "sound_stop" );
	self endon( "entityshutdown" );
	
	while( 1 )
	{
		origin = self GetTagOrigin( "tag_flash" );

		if ( origin[0] != self.microwave_audio_start[0] || origin[1] != self.microwave_audio_start[1] || origin[2] != self.microwave_audio_start[2] )
		{
			previousStart = self.microwave_audio_start;
			previousEnd = self.microwave_audio_end;

			angles = self GetTagAngles( "tag_flash" );
		
			forward = AnglesToForward( angles );
			forward = VectorScale( forward, 750 );
		
			trace = BulletTrace( origin, origin + forward, false, self );
	
			self.microwave_audio_start = origin;
			self.microwave_audio_end = trace[ "position" ];

			soundUpdateLineEmitter( "wpn_micro_turret_loop", previousStart, previousEnd, self.microwave_audio_start, self.microwave_audio_end );
		}
		
		wait 0.1;
	}
}

function microwave_init_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	if ( !newVal )
		return;
	
	self UseAnimTree( #animtree );
	self SetAnimRestart( %o_turret_guardian_close, 1.0, 0.0, 1.0 );
	self SetAnimTime( %o_turret_guardian_close, 1.0 );
}

function microwave_open_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	if ( !newVal )
		return;

	self UseAnimTree( #animtree );
	self SetAnimRestart( %o_turret_guardian_open, 1.0, 0.0, 1.0 );
}

function microwave_close_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");
	
	if ( !newVal )
		return;

	self UseAnimTree( #animtree );
	self SetAnimRestart( %o_turret_guardian_close, 1.0, 0.0, 1.0 );
}
