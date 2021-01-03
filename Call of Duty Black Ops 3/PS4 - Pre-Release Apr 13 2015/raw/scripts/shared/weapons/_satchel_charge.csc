#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "client_fx", "weapon/fx_c4_light_orng" );
#precache( "client_fx", "weapon/fx_c4_light_blue" );

#namespace satchel_charge;

function init_shared( localClientNum )
{
	level._effect["satchel_charge_enemy_light"] = "weapon/fx_c4_light_orng";
	level._effect["satchel_charge_friendly_light"] = "weapon/fx_c4_light_blue";
	
	callback::add_weapon_type( "satchel_charge", &satchel_spawned );
}

function satchel_spawned( localClientNum ) // self == the grenade
{
	self endon( "entityshutdown" );
	
	if ( self isGrenadeDud() ) 
		return;
	
	self.equipmentFriendFX = level._effect["satchel_charge_friendly_light"];
	self.equipmentEnemyFX = level._effect["satchel_charge_enemy_light"];
	self.equipmentTagFX = "tag_origin";
	
	self thread weaponobjects::equipmentTeamObject( localClientNum );
}
