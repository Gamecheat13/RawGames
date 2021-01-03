#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "client_fx", "weapon/fx_equip_light_os" );

#namespace sticky_grenade;

function autoexec __init__sytem__() {     system::register("sticky_grenade",&__init__,undefined,undefined);    }

function __init__()
{
	level._effect["grenade_light"] = "weapon/fx_equip_light_os";
	
	callback::add_weapon_type( "sticky_grenade", &spawned );
}

function spawned( localClientNum )
{
	if ( self isGrenadeDud() ) 
		return; 

	self thread fx_think( localClientNum );
}

function stop_sound_on_ent_shutdown( handle )
{
	self waittill( "entityshutdown" );
	
	StopSound(handle);
}

function fx_think( localClientNum )
{
	self notify( "light_disable" );
	self endon( "light_disable" );
	
	self endon( "entityshutdown" );
	
	self util::waittill_dobj( localClientNum );
	
	handle = self PlaySound( localClientNum, "wpn_semtex_countdown" );
	self thread stop_sound_on_ent_shutdown( handle );
	

	interval = 0.3;

	for( ;; )
	{
		self stop_light_fx( localClientNum );
		localPlayer = GetLocalPlayer( localClientNum );
		
		if (  !( localPlayer isEntityLinkedToTag( self, "j_head" ) ) 
		    && !( localPlayer isEntityLinkedToTag( self, "j_elbow_le" ) ) 
		    && !( localPlayer isEntityLinkedToTag( self, "j_spineupper" ) ) )
	    {
			self start_light_fx( localClientNum );
		}

		self fullscreen_fx( localClientNum );

		util::server_wait( localClientNum, interval, 0.01, "player_switch" );

		self util::waittill_dobj( localClientNum );

		interval = math::clamp( ( interval / 1.2 ), 0.08, 0.3 );
	}
}

function start_light_fx( localClientNum )
{
	player = GetLocalPlayer( localClientNum );

	self.fx = PlayFxOnTag( localClientNum, level._effect["grenade_light"], self, "tag_fx" );
}

function stop_light_fx( localClientNum )
{
	if ( isdefined( self.fx ) && self.fx != 0 )
	{
		StopFx( localClientNum, self.fx );
		self.fx = undefined;
	}
}

function sticky_indicator( player, localClientNum )
{
	controllerModel = GetUIModelForController( localClientNum );
	stickyImageModel = CreateUIModel( controllerModel, "hudItems.stickyImage" );

	SetUIModelValue( stickyImageModel, "hud_icon_stuck_semtex" );

	// this is probably good enough, but the while loop is safer
	// self util::waittill_any( "death", "detonated" );
	
	while( IsDefined(self ) )
	{
		{wait(.016);};
	}

	SetUIModelValue( stickyImageModel, "blacktransparent" );
}

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

	if ( self isfriendly( localClientNum ) )
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
