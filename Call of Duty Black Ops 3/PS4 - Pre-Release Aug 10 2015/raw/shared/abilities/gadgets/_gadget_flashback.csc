#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\duplicaterender_mgr;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                                                                                                     	   	                                                                      	  	  	


function autoexec __init__sytem__() {     system::register("gadget_flashback",&__init__,undefined,undefined);    }




#precache( "client_fx", "player/fx_plyr_flashback_trail" );
	
function __init__()
{
	clientfield::register( "scriptmover", "flashback_trail_fx", 1, 1, "int", &set_flashback_trail_fx, !true, !true );
	clientfield::register( "playercorpse", "flashback_clone", 1, 1, "int", &clone_flashback_changed, !true, true );
	visionset_mgr::register_overlay_info_style_postfx_bundle( "flashback_warp", 1, 7, "pstfx_flashback_warp", 0.8 );
}

function set_flashback_trail_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if( newVal )
	{
		player = GetLocalPlayer( localclientnum );
		if( isDefined( self.owner ) && isDefined( player ) && ( self.owner == player ) )
		{
			if( IsThirdPerson( localclientnum ) )
			{
				fx = PlayFxOnTag( localclientnum, "player/fx_plyr_flashback_trail", self, "tag_origin" );
			}
		}
		else
		{
			fx = PlayFxOnTag( localclientnum, "player/fx_plyr_flashback_trail", self, "tag_origin" );
		}
	}
}

function clone_flashback_changed( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{		
	if ( oldVal != newVal )
	{
		self clone_flashback_changed_event( localClientNum, newVal);
	}
}

function clone_fade( localClientNum )
{
	self endon ( "entityshutdown" );
	
	startTime = GetServerTime( localClientnum );
	while( true )
	{
		currentTime = GetServerTime( localClientnum );
		elapsedTime = currentTime - startTime;
		elapsedtime = float( elapsedtime / 1000 );
		if( elapsedTime < 1.0  )
		{
			amount = 1.0 - elapsedTime / 1.0;
			self MapShaderConstant( localClientNum, 0, "scriptVector1", amount );
		}
		else
		{
			self MapShaderConstant( localClientNum, 0, "scriptVector1", 0 );
		}
		
		{wait(.016);};
	}
}

function clone_flashback_changed_event( localClientNum, armorStatusNew )
{
	if ( armorStatusNew )
	{
		self duplicate_render::update_dr_flag( "armor_on", true );
		
		shieldExpansionNcolor = "scriptVector0";
		shieldExpansionValueX = 0;

		colorTintValueY = 1.0;
		colorTintValueZ = 1.0;
		colorTintValueW = 1.0;
		
		damageStateValue = 1.0;
		
		self MapShaderConstant( localClientNum, 0, shieldExpansionNcolor, shieldExpansionValueX, colorTintValueY, colorTintValueZ, colorTintValueW );
		self MapShaderConstant( localClientNum, 0, "scriptVector1", damageStateValue );
		
		self thread clone_fade( localClientNum );
	}
	else
	{
		self duplicate_render::update_dr_flag( "armor_on", false );
	}
}

