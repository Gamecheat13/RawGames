#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

                                                                           
                                          	  	                                                                                  	        
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



	
function autoexec __init__()
{
	level thread player_init();
	
	duplicate_render::set_dr_filter_offscreen( "ap", 75, 
	                                "dead_locked",                        undefined,                    
	                                2, "mc/hud_outline_model_red"  );
	
}

function player_init()
{
	util::waitforclient( 0 );

	players = getlocalplayers();
	
	foreach( player in players )
	{
		player thread watch_lockon(0);
	}
}

function watch_lockon( localClientNum )
{
	
	while(1)
	{
		self waittill("lockon_changed",state,target);
		if (IsDefined(self.replay_lock) && ( !IsDefined(target) || self.replay_lock!= target ) )
		{
		   	self.ap_lock duplicate_render::change_dr_flags( undefined, "dead_locked" );
		   	self.ap_lock = undefined;
		}
		switch(state)
		{
			case 0:
			case 1:
			case 3:
			   	target duplicate_render::change_dr_flags( undefined, "dead_locked" );
				break;
				
			case 2:
			case 4:
			   	target duplicate_render::change_dr_flags( "dead_locked", undefined );
			   	self.ap_lock = target;
				break;
		}
	}
}

