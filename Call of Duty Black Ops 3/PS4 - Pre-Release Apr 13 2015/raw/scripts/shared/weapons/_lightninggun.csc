#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\visionset_mgr_shared;

#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

       

#precache( "client_fx", "weapon/fx_lightninggun_impact_player_spwner" );

#namespace lightninggun;

function init_shared()
{	
	level.weaponLightningGun = GetWeapon( "hero_lightninggun" );

	level._effect["lightninggun_player_shock"] = "weapon/fx_lightninggun_impact_player_spwner";

	visionset_mgr::register_overlay_info_style_electrified( "lightninggun_electrified", 1, 7, 1.25 );

	clientfield::register( "allplayers", "damaged_by_lightninggun", 1, 1, "int", &lightninggun_damage_fx, !true, !true );
}

function lightninggun_damage_fx( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( IsDefined( self.lightninggun_damage_fx_handle ) )
	{
		StopFX( localClientNum, self.lightninggun_damage_fx_handle );
	}

	if ( newVal )
	{
		self.lightninggun_damage_fx_handle = PlayFXOnTag( localClientNum, level._effect["lightninggun_player_shock"], self, "j_spineupper" );
		
		if( self islocalplayer() )
		{
			self playsound( 0, "wpn_lightning_gun_electrocuted_plr" );
		}
		else
		{
			self playsound( 0, "wpn_lightning_gun_electrocuted_npc" );
		}
	}
}
