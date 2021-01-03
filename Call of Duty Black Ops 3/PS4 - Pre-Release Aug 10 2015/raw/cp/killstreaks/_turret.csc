#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                                       

#using_animtree ( "mp_microwaveturret" );

function init()
{
	//clientfield::register( "turret", "turret_microwave_open", VERSION_SHIP, 1, "int", &microwave_open_anim, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "turret", "turret_microwave_close", VERSION_SHIP, 1, "int", &microwave_close_anim, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "turret", "turret_microwave_destroy", VERSION_SHIP, 1, "int", &microwave_destroy_anim, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
	//clientfield::register( "turret", "turret_microwave_sounds", VERSION_SHIP, 1, "int",&turret_microwave_sounds, !CF_HOST_ONLY, !CF_CALLBACK_ZERO_ON_NEW_ENT );
}

function turret_microwave_sounds( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{

	if( newVal == 1 )
	{
		self thread turret_microwave_sound_start( localClientNum );
	}
	else if( newVal == 0 )
	{
		self notify( "sound_stop" );
	}
}

function turret_microwave_sound_start( localClientNum )
{
	self endon( "entityshutdown" );
	self endon( "sound_stop" );

	//println( "+++ starting microwave line emitter" );

	origin = self GetTagOrigin( "tag_flash" );
	angles = self GetTagAngles( "tag_flash" );

	forward = AnglesToForward( angles );
	forward = VectorScale( forward, 750 );

	trace = BulletTrace( origin, origin + forward, false, self );

	start = origin;
	end = trace[ "position" ];
	
	self thread turret_microwave_sound_off_waiter( localClientNum, start, end );

	//Line( start, end, (1,0,0), 1, false, 10000 );

	self playsound ( 0, "wpn_micro_turret_start");
	soundLineEmitter( "wpn_micro_turret_loop", start, end );
	//iprintlnbold ("micro_on");
}


function turret_microwave_sound_off_waiter( localClientNum, start, end )
{

	self util::waittill_any( "sound_stop", "entityshutdown" );
	playsound (0, "wpn_micro_turret_stop", start);
	soundStopLineEmitter ( "wpn_micro_turret_loop", start, end );
	//iprintlnbold ("micro_off");

}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function microwave_open_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	self endon("entityshutdown");

	if ( !newVal )
		return;
	
	self UseAnimTree( #animtree );
	// self SetAnim( %o_hpm_open, 1.0, 0.0, 1.0 );

}
//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function microwave_close_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{	
	if ( !newVal )
		return;
	
	self UseAnimTree( #animtree );
	// self SetAnim( %o_hpm_close, 1.0, 0.0, 1.0 );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function microwave_destroy_anim( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{

	self UseAnimTree( #animtree );
	// self SetAnim( %o_hpm_destroyed, 1.0, 0.0, 1.0 );
}
