#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\exploder_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

                                                        

#namespace zm_trap_electric;

function autoexec __init__sytem__() {     system::register("zm_trap_electric",&__init__,undefined,undefined);    }
	
function __init__()
{	
	visionset_mgr::register_overlay_info_style_electrified( "zm_trap_electric", 1, 15, 1.25 );
	
	a_traps = struct::get_array( "trap_electric", "targetname" );
	foreach( trap in a_traps )
	{
		clientfield::register( "world", trap.script_noteworthy, 1, 1, "int", &trap_fx_monitor, !true, !true );			
	}
}

function trap_fx_monitor( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	exploder_name = "trap_electric_" + fieldName;
	if ( newVal )
	{
		exploder::exploder( exploder_name );
	}
	else
	{
		exploder::stop_exploder( exploder_name );
	}

	fire_points = struct::get_array( fieldName,"targetname" );
		
	foreach( point in fire_points )
	{
		if( !isdefined( point.script_noteworthy ) )
		{
			if( newVal )
			{
				point thread electric_trap_fx();
			}
			else
			{
				point thread stop_trap_fx();
			}
		}
	}
}

function electric_trap_fx()
{	
	ang = self.angles;
	forward = AnglesToForward(ang);
	up = AnglesToUp(ang);
	
	if ( isdefined( self.loopFX ) )
	{
		for(i = 0; i < self.loopFX.size; i ++)
		{
			self.loopFX[i] delete();
		}
		
		self.loopFX = [];
	}

	if(!isdefined(self.loopFX))
	{
		self.loopFX = [];
	}	
	
	players = getlocalplayers();
	
	for(i = 0; i < players.size; i++)
	{
		self.loopFX[i] = PlayFx( i, level._effect["zapper"], self.origin, forward, up, 0);
	}
}

function stop_trap_fx()
{
	players = getlocalplayers();
	
	for(i = 0; i < players.size; i++)
	{
		for(j = 0; j < self.loopFX.size; j ++)
		{
			StopFx( i, self.loopFX[j] );
		}		
	}
	
	self.loopFX = [];	
}
