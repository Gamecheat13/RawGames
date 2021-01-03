#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "client_fx", "light/fx_light_red_spike_charge_os" );

#namespace spike_charge_siegebot;

function autoexec __init__sytem__() {     system::register("spike_charge_siegebot",&__init__,undefined,undefined);    }

function __init__()
{
	level._effect["spike_charge_siegebot_light"] = "light/fx_light_red_spike_charge_os";
	
	callback::add_weapon_type( "spike_charge_siegebot", &spawned );
	callback::add_weapon_type( "spike_charge_siegebot_theia", &spawned );
	callback::add_weapon_type( "siegebot_launcher_turret", &spawned );
	callback::add_weapon_type( "siegebot_launcher_turret_theia", &spawned );
	callback::add_weapon_type( "siegebot_javelin_turret", &spawned );
}

function spawned( localClientNum )
{
	self thread fx_think( localClientNum );
}

function fx_think( localClientNum )
{
	self notify( "light_disable" );

	self endon( "entityshutdown" );
	self endon( "light_disable" );

	self util::waittill_dobj( localClientNum );
	
//	self PlaySound( localClientNum, "wpn_semtex_countdown" );

	interval = 0.3;

	for( ;; )
	{
		self stop_light_fx( localClientNum );
		self start_light_fx( localClientNum );
		//self fullscreen_fx( localClientNum );
		self PlaySound( localClientNum, "wpn_semtex_alert" );

		util::server_wait( localClientNum, interval, 0.01, "player_switch" );

		self util::waittill_dobj( localClientNum );

		interval = math::clamp( ( interval / 1.2 ), 0.08, 0.3 );
	}
}

function start_light_fx( localClientNum )
{
	player = GetLocalPlayer( localClientNum );

	self.fx = PlayFxOnTag( localClientNum, level._effect["spike_charge_siegebot_light"], self, "tag_fx" );
}

function stop_light_fx( localClientNum )
{
	if ( isdefined( self.fx ) && self.fx != 0 )
	{
		StopFx( localClientNum, self.fx );
		self.fx = undefined;
	}
}
/*
function sticky_indicator( player, localClientNum )
{
	controllerModel = GetUIModelForController( localClientNum );
	stickyImageModel = CreateUIModel( controllerModel, "hudItems.stickyImage" );

	SetUIModelValue( stickyImageModel, "hud_icon_stuck_semtex" );

	// this is probably good enough, but the while loop is safer
	// self util::waittill_any( "death", "detonated" );
	
	while( IsDefined(self ) )
	{
		WAIT_CLIENT_FRAME;
	}

	SetUIModelValue( stickyImageModel, "blacktransparent" );
}
*/
/*
function fullscreen_fx( localClientNum )
{
	player = GetLocalPlayer( localClientNum );

	if ( isdefined( player ) )
	{
		if ( player GetInKillcam( localClientNum ) )
		{
			return;
		}
		else if ( player util::is_player_view_linked_to_entity( localClientNum ) )
		{
			return;
		}
	}

	if ( self util::friend_not_foe( localClientNum ) )
	{
		return;
	}

	parent = self GetParentEntity();

	if ( isdefined( parent ) && parent == player )
	{
		parent PlayRumbleOnEntity( localClientNum, "buzz_high" );

		if ( GetDvarint( "ui_hud_hardcore" ) == 0 )
		{
			self thread sticky_indicator( player, localClientNum );
		}
	}
}
*/