#using scripts\codescripts\struct;
#using scripts\shared\duplicaterender_mgr;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\system_shared;



	









function autoexec __init__sytem__() {     system::register("gadget_camo_render",&__init__,undefined,undefined);    }

function __init__()
{
	duplicate_render::set_dr_filter_framebuffer_duplicate( "camo_rev_dr", 90, 
	                                "gadget_camo_reveal,",                        				"gadget_camo_flicker,gadget_camo_break,hide_model",                    
	                                1, "mc/hud_outline_predator", 0    );
	duplicate_render::set_dr_filter_framebuffer( "camo_rev", 90, 
	                                "gadget_camo_reveal,hide_model",                        	"gadget_camo_flicker,gadget_camo_break",                    
	                                0, "mc/hud_outline_predator", 0    );
	duplicate_render::set_dr_filter_framebuffer( "camo_fr", 90, 
	                                "gadget_camo_on,gadget_camo_friend",                        "gadget_camo_flicker,gadget_camo_break",                    
	                                0, "mc/hud_outline_predator_camo_active_ally", 0    );
	duplicate_render::set_dr_filter_framebuffer( "camo_en", 90, 
	                                "gadget_camo_on",                                           "gadget_camo_flicker,gadget_camo_break,gadget_camo_friend", 
	                                0, "mc/hud_outline_predator_camo_active_enemy", 0   );
	duplicate_render::set_dr_filter_framebuffer( "camo_fr_fl", 80, 
	                                "gadget_camo_on,gadget_camo_flicker,gadget_camo_friend",    "gadget_camo_break",                                        
	                                0, "mc/hud_outline_predator_camo_disruption_ally", 0   );
	duplicate_render::set_dr_filter_framebuffer( "camo_en_fl", 80, 
	                                "gadget_camo_on,gadget_camo_flicker",                       "gadget_camo_break,gadget_camo_friend",                     
	                                0, "mc/hud_outline_predator_camo_disruption_enemy", 0  );
	duplicate_render::set_dr_filter_framebuffer( "camo_brk", 70, 
	                                "gadget_camo_on,gadget_camo_break",                         undefined,                                                  
	                                0, "mc/hud_outline_predator_break", 0 );
}

#namespace gadget_camo_render;

function doReveal( local_client_num, direction )
{
	self notify( "endtest" );
	self endon( "endtest" );
	
	self endon( "entityshutdown" );
	
	if ( !isdefined( self ) )
		return;
			
	if( direction )
	{
		self duplicate_render::update_dr_flag( "hide_model", false );
		startVal = 0;
		endVal = 1;
	}
	else
	{
		self duplicate_render::update_dr_flag( "hide_model", true );
		startVal = 1;
		endVal = 0;
	}
	
	priorValue = startVal;
	while( ( startVal >= 0 ) && ( startVal <= 1 ) )
	{
		self MapShaderConstant( local_client_num, 0, "scriptVector0", startVal, 0, 0, 0 );
		if( direction )
		{
			startVal += .016 / 0.35;
			if( ( priorValue < .5 ) && ( startVal >= .5 ) )
			{
				self duplicate_render::update_dr_flag( "hide_model", true );
			}
		}
		else
		{
			startVal -= .016 / 0.35;
			if( ( priorValue > .5 ) && ( startVal <= .5 ) )
			{
				self duplicate_render::update_dr_flag( "hide_model", false );
			}
		}
		priorValue = startVal;
		wait( .016 );
	}
	self MapShaderConstant( local_client_num, 0, "scriptVector0", endVal, 0, 0, 0 );
	
	flags_changed = self duplicate_render::set_dr_flag( "gadget_camo_reveal", false );
	flags_changed = flags_changed && self duplicate_render::set_dr_flag( "gadget_camo_on", direction );
	
	if (flags_changed)
	{
		self duplicate_render::update_dr_filters();
	}
}

