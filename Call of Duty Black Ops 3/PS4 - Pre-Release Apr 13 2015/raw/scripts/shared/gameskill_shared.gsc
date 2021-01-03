#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\flag_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace hackable;

function autoexec __init__sytem__() {     system::register("hackable",&init,undefined,undefined);    }


	
function init()
{
	callback::on_localclient_connect( &on_player_connect );
	
}

function on_player_connect( localClientNum )
{
	duplicate_render::set_dr_filter_offscreen( "hacking", 75, 
	                                "being_hacked",                        undefined,                    
	                                2, "mc/hud_keyline_orange"  );
}



// called on a player to show what's being hacked

function set_hacked_ent( ent )
{
	if ( !( ent === self.hacked_ent ) )
	{
		if ( IsDefined(self.hacked_ent) )
		{
		   	self.hacked_ent duplicate_render::change_dr_flags( undefined, "being_hacked" );
		}
		self.hacked_ent=ent;
		if ( IsDefined(self.hacked_ent) )
		{
		   	self.hacked_ent duplicate_render::change_dr_flags( "being_hacked", undefined );
		}
	}
}



