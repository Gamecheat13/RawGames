#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\zm\_zm_bgb;
#using scripts\zm\_zm_utility;

    

                                                                 
                                                                                                                               

#namespace zm_bgb_killing_time;


function autoexec __init__sytem__() {     system::register("zm_bgb_killing_time",&__init__,undefined,undefined);    }

function __init__()
{
	if ( !( isdefined( level.bgb_in_use ) && level.bgb_in_use ) )
	{
		return;
	}

	bgb::register( "zm_bgb_killing_time", "activated" );

	clientfield::register( "actor",		"zombie_instakill_fx",		1, 1, "int", &zombie_instakill_fx_cb,	!true, true);
	clientfield::register( "toplayer",	"instakill_upgraded_fx",	1, 1, "int", &instakill_upgraded_fx_cb,	!true, !true );
}

//--------------------------------------------------------------------------------------------------
//	INSTAKILL UPGRADED
//--------------------------------------------------------------------------------------------------
function instakill_upgraded_fx_cb( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if(newVal)
	{
		self thread instakill_upgraded_fx_sound( localClientNum );
	}
	else
	{
		self notify("stop_instakill_upgrade_fx");
		StopSound( self.instakill_soundId );
	}
}

function instakill_upgraded_fx_sound( localClientNum )
{
	self endon("death");
	self endon( "end_demo_jump_listener" );
	self endon("entityshutdown");
	
	self notify("stop_instakill_upgrade_fx");	
	self endon("stop_instakill_upgrade_fx");
	
	while(1)
	{
		self.instakill_soundId = self PlaySound( localClientNum, "zmb_music_box", self.origin );
		
		wait 4; // wait for slowed down sound
	}	
}

function zombie_instakill_fx_cb(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if(!IsDefined(newVal))
	{
		return;
	}
	
	if ( newVal )
	{
		fxObj = util::spawn_model(localClientNum, "tag_origin", self.origin, self.angles);
		
		fxObj thread PlayeSoundAndDelete( localClientNum, fxObj );		
	}
}

function private PlayeSoundAndDelete( localClientNum, fxObj )
{
	fxObj PlaySound( localClientNum, "evt_ai_explode" );		
	
	wait 1;
	
	fxObj Delete();
}
