#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#precache( "client_fx", "weapon/fx_hero_pineapple_trail_orng" );
#precache( "client_fx", "weapon/fx_hero_pineapple_trail_blue" );

#namespace sticky_grenade;

function autoexec __init__sytem__() {     system::register("pineapple_gun",&__init__,undefined,undefined);    }

function __init__()
{
	level._effect["pineapple_enemy_light"] = "weapon/fx_hero_pineapple_trail_orng";
	level._effect["pineapple_friendly_light"] = "weapon/fx_hero_pineapple_trail_blue";
	
	callback::add_weapon_type( "hero_pineapplegun", &spawned );
}

function spawned( localClientNum )
{
	if ( self isGrenadeDud() ) 
		return; 

	self thread fx_think( localClientNum );
}

function fx_think( localClientNum )
{
	self notify( "light_disable" );

	self endon( "entityshutdown" );
	self endon( "light_disable" );

	self util::waittill_dobj( localClientNum );
	
	interval = 0.3;

	for( ;; )
	{
		self stop_light_fx( localClientNum );
		self start_light_fx( localClientNum );
		//self PlaySound( localClientNum, "wpn_semtex_alert" );

		util::server_wait( localClientNum, interval, 0.01, "player_switch" );

		self util::waittill_dobj( localClientNum );

		interval = math::clamp( ( interval / 1.2 ), 0.08, 0.3 );
	}
}

function start_light_fx( localClientNum )
{
	friend = self util::friend_not_foe( localClientNum );

	player = GetLocalPlayer( localClientNum );

	if ( friend )
	{
		self.fx = PlayFxOnTag( localClientNum, level._effect["pineapple_friendly_light"], self, "tag_fx" );
	}
	else
	{
		self.fx = PlayFxOnTag( localClientNum, level._effect["pineapple_enemy_light"], self, "tag_fx" );
	}
}

function stop_light_fx( localClientNum )
{
	if ( isdefined( self.fx ) && self.fx != 0 )
	{
		StopFx( localClientNum, self.fx );
		self.fx = undefined;
	}
}

