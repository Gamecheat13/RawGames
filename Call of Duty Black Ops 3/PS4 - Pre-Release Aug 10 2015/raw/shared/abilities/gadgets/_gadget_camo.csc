#using scripts\codescripts\struct;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;
#using scripts\shared\abilities\gadgets\_gadget_camo_render;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	

#using scripts\shared\system_shared;

function autoexec __init__sytem__() {     system::register("gadget_camo",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &on_player_spawned );
	
	clientfield::register( "allplayers", "camo_shader", 1, 3, "int", &ent_camo_material_callback, !true, true );
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
	flags_changed = self duplicate_render::set_dr_flag( "gadget_camo_friend", friend );
	flags_changed |= self duplicate_render::set_dr_flag( "gadget_camo_flicker", newVal == 2 );
	flags_changed |= self duplicate_render::set_dr_flag( "gadget_camo_break", newVal == 3 );
	flags_changed |= self duplicate_render::set_dr_flag( "gadget_camo_reveal", newVal != oldVal );
	flags_changed |= self duplicate_render::set_dr_flag( "gadget_camo_on", false );
	if ( flags_changed )
	{
		self duplicate_render::update_dr_filters();
	}
	
	self notify( "endtest" );
	
	self thread gadget_camo_render::doReveal( local_client_num, newVal != 0 );
	
	if ( newVal && !oldVal )
	{
		self GadgetPulseResetReveal();
	}
}
