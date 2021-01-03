#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\filter_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\system_shared;






	// Units per network frame.  0 < speed <= 1.0




	
function autoexec __init__sytem__() {     system::register("gadget_clone",&__init__,undefined,undefined);    }
	
function __init__()
{
	callback::on_spawned( &on_player_spawned );
	
	clientfield::register( "actor", "clone_activated", 1, 1, "int", &clone_activated, !true, true );
	clientfield::register( "actor", "clone_damaged", 1, 1, "int", &clone_damaged, !true, !true );
	
	duplicate_render::set_dr_filter_framebuffer( "clone_ally", 90, 
	                                "clone_ally_on", "clone_damage",                    
	                                0, "mc/ability_clone_ally", 0    );
	duplicate_render::set_dr_filter_framebuffer( "clone_enemy", 90, 
	                                "clone_enemy_on", "clone_damage",                    
	                                0, "mc/ability_clone_enemy", 0    );
	duplicate_render::set_dr_filter_framebuffer( "clone_damage_ally", 90, 
	                                "clone_ally_on,clone_damage", undefined,                    
	                                0, "mc/ability_clone_ally_damage", 0    );
	duplicate_render::set_dr_filter_framebuffer( "clone_damage_enemy", 90, 
	                                "clone_enemy_on,clone_damage", undefined,                    
	                                0, "mc/ability_clone_enemy_damage", 0    );
	
	clientfield::register( "allplayers", "clone_activated", 1, 1, "int", &player_clone_activated, !true, true );
}

function on_player_spawned( localClientNum )
{

}

function transition_shader( localClientNum )
{
	self endon ( "entityshutdown" );
	self endon ( "clone_shader_off" );
	
	rampInShader = 0.0;
	while( rampInShader < 1.0 )
	{
		if( isDefined( self ) )
		{
			self MapShaderConstant( localClientNum, 0, "scriptVector3", 1, rampInShader, 0, 0.04 ); 
		}
		rampInShader += .04;
		{wait(.016);};
	}
}

function set_shader( localClientNum, enabled, entity )
{
	if( entity isfriendly( localclientnum ) )
	{
		self duplicate_render::update_dr_flag( "clone_ally_on", enabled );
	}
	else
	{
		self duplicate_render::update_dr_flag( "clone_enemy_on", enabled );
	}
}

function clone_activated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal )
	{
		self._isClone = true;
		self set_shader( localClientNum, true, self getowner( localClientNum ) );
		if( isDefined( level._monitor_tracker ) )
		{
			self thread [[level._monitor_tracker]]( localClientNum );
		}
		self thread transition_shader( localClientNum );
	}
}

function player_clone_activated( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !isdefined( self ) )
		return;
	
	if( newVal )
	{
		self set_shader( localclientnum, true, self );
		self thread transition_shader( localClientNum );
	}
	else
	{
		self set_shader( localclientnum, false, self );
		self notify ( "clone_shader_off" );
		self MapShaderConstant( localClientNum, 0, "scriptVector3", 1, 0, 0, 1 ); 
	}
}

function clone_damage_flicker( localClientNum )
{
	self endon( "entityshutdown" );
	self notify( "start_flicker" );
	self endon( "start_flicker" );
	
	self duplicate_render::update_dr_flag( "clone_damage", true );
	self waittill( "stop_flicker" );
	self duplicate_render::update_dr_flag( "clone_damage", false );
}

function clone_damage_finish()
{
	self endon( "entityshutdown" );
	self endon( "start_flicker" );
	self endon( "stop_flicker" );
	
	wait( .2 );
	self notify( "stop_flicker" );
}

function clone_damaged( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal )
	{
		self thread clone_damage_flicker( localClientNum );
	}
	else
	{
		self thread clone_damage_finish();
	}
}
