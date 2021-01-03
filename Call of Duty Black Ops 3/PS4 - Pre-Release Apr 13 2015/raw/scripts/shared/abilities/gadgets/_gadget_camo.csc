#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                           
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                    	   	  	

#using scripts\shared\system_shared;



	








function autoexec __init__sytem__() {     system::register("gadget_camo",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_localclient_connect( &on_player_connect );
	callback::on_spawned( &on_player_spawned );
	
	clientfield::register( "allplayers", "camo_shader", 1, 3, "int", &ent_camo_material_callback, !true, true );
	
	duplicate_render::set_dr_filter_framebuffer( "camo_rev", 90, 
	                                "gadget_camo_reveal",                        				"gadget_camo_flicker,gadget_camo_break",                    
	                                0, "mc/hud_outline_predator"    );
	duplicate_render::set_dr_filter_framebuffer( "camo_fr", 90, 
	                                "gadget_camo_on,gadget_camo_friend",                        "gadget_camo_flicker,gadget_camo_break",                    
	                                0, "mc/hud_outline_predator_camo_active_ally"    );
	duplicate_render::set_dr_filter_framebuffer( "camo_en", 90, 
	                                "gadget_camo_on",                                           "gadget_camo_flicker,gadget_camo_break,gadget_camo_friend", 
	                                0, "mc/hud_outline_predator_camo_active_enemy"   );
	duplicate_render::set_dr_filter_framebuffer( "camo_fr_fl", 80, 
	                                "gadget_camo_on,gadget_camo_flicker,gadget_camo_friend",    "gadget_camo_break",                                        
	                                0, "mc/hud_outline_predator_camo_disruption_ally"   );
	duplicate_render::set_dr_filter_framebuffer( "camo_en_fl", 80, 
	                                "gadget_camo_on,gadget_camo_flicker",                       "gadget_camo_break,gadget_camo_friend",                     
	                                0, "mc/hud_outline_predator_camo_disruption_enemy"  );
	duplicate_render::set_dr_filter_framebuffer( "camo_brk", 70, 
	                                "gadget_camo_on,gadget_camo_break",                         undefined,                                                  
	                                0, "mc/hud_outline_predator_break" );
	
}

function on_player_spawned( local_client_num )
{
	player_view = getlocalplayer( local_client_num );
	
	if ( player_view GetEntityNumber() != self GetEntityNumber() )
	{
		return;
	}
	
	self thread watch_killcam_reapply_dr( local_client_num );
}

function watch_killcam_reapply_dr( local_client_num )
{
	self endon( "entityshutdown" );
	
	self notify("camo_killcam_reapply_dr");
	self endon("camo_killcam_reapply_dr");
	while(1)
	{
		level util::waittill_any( "demo_jump", "player_switch", "killcam_begin", "killcam_end" );
		{wait(.016);};
		player_view = getlocalplayer( local_client_num );
		if ( isdefined(player_view) )
		{
			//assert( player_view isplayer(), "GetLocalPlayer("+local_client_num+") returned something other than a player" );
			
			if ( player_view isplayer() )
			{
				val = player_view clientfield::get( "camo_shader" );
				player_view ent_camo_material_callback( local_client_num, 0, val, true, false, "camo_shader", true );
			}
		}

	}
}


function on_player_connect( local_client_num )
{
}

function ent_camo_material_callback( local_client_num, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	player_view = getlocalplayer( local_client_num );
	player_client = getnonpredictedlocalplayer( local_client_num ); 
	killcam = ( !( player_view === player_client ) );
	if ( killcam )
	{
		/*
		/#
			n1 = ( IsDefined(player_client) ? player_client.name : "<undefined>" );
			n2 = ( IsDefined(player_view) ? player_view.name : "<undefined>" );
			ns = ( IsDefined(self.name) ? self.name : "<undefined>" );
			println("CAMO: Self "+ns+" Player "+n1+" seeing player "+n2+" in camo state "+newVal+"\n" );
		#/
		*/
	}
	
	friend = util::friend_not_foe( local_client_num, true ); 
	self duplicate_render::set_dr_flag( "gadget_camo_friend", friend );
	self duplicate_render::set_dr_flag( "gadget_camo_flicker", newVal == 2 );
	self duplicate_render::set_dr_flag( "gadget_camo_break", newVal == 3 );
	self duplicate_render::set_dr_flag( "gadget_camo_reveal", newVal != oldVal );
	self duplicate_render::set_dr_flag( "gadget_camo_on", false );
	self duplicate_render::change_dr_flags();
	
	self notify( "endtest" );
	
	self thread doReveal( local_client_num, newVal != 0 );
	
	if ( newVal && !oldVal )
	{
		self GadgetPulseResetReveal();
	}
}

function doReveal( local_client_num, direction )
{
	self notify( "endtest" );
	self endon( "endtest" );
	
	self endon( "entityshutdown" );
	
	if( direction )
	{
		startVal = 1;
	}
	else
	{
		startVal = 0;
	}
	
	while( ( startVal >= 0 ) && ( startVal <= 1 ) )
	{
		self MapShaderConstant( local_client_num, 0, "scriptVector0", startVal, 0, 0, 0 );
		if( direction )
		{
			startVal -= .016 / 0.35;
		}
		else
		{
			startVal += .016 / 0.35;
		}
		wait( .016 );
	}
	
	self duplicate_render::set_dr_flag( "gadget_camo_reveal", false );
	self duplicate_render::set_dr_flag( "gadget_camo_on", direction );
	self duplicate_render::change_dr_flags();
}

