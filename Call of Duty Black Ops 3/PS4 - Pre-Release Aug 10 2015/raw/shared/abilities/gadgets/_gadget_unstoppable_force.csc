#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\filter_shared;
#using scripts\shared\util_shared;

#using scripts\shared\abilities\_ability_player;
#using scripts\shared\abilities\_ability_power;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\shared\lui_shared;

#using scripts\shared\system_shared;











	


	
#precache( "client_fx", "player/fx_plyr_ability_screen_blur_overdrive" );

function autoexec __init__sytem__() {     system::register("gadget_unstoppable_force",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &on_player_spawned );
	
	clientfield::register( "toplayer", "unstoppableforce_state", 1, 1, "int", &player_unstoppableforce_handler, !true, true);
}

function on_player_spawned( local_client_num )
{

}


function player_unstoppableforce_handler(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{
	if ( !self IsLocalPlayer() || IsSpectating( localClientNum, false ) || ( (isdefined(level.localPlayers[localClientNum])) && (self GetEntityNumber() != level.localPlayers[localClientNum] GetEntityNumber())) )
	{
		return;
	}
	
	if(newVal)
	{
		EnableSpeedBlur( localClientNum, GetDvarFloat( "scr_unstoppableforce_amount", 0.15 ), GetDvarFloat( "scr_unstoppableforce_inner_radius", 0.6 ), GetDvarFloat( "scr_unstoppableforce_outer_radius", 1 ), GetDvarInt( "scr_unstoppableforce_velShouldScale", 1 ),GetDvarInt( "scr_unstoppableforce_velScale", 220 ));
		self thread activation_flash(localClientNum);
		self boost_fx_on_velocity(localClientNum);
	}
	else
	{
		self stop_boost_camera_fx(localClientNum);
	   	DisableSpeedBlur( localClientNum );
	   	
	   	// Notify child threads to end.
	   	self notify( "end_unstoppableforce_boost_fx");
	}
}


// Flashes the screen white on activation.
function activation_flash(localClientNum)
{
	wait GetDvarFloat( "scr_unstoppableforce_activation_delay", 0.6 );

	lui::screen_fade( GetDvarFloat("scr_unstoppableforce_flash_fade_in_time", 0.075), GetDvarFloat("scr_unstoppableforce_flash_alpha", 0.6), 0, "white" );
	wait GetDvarFloat("scr_unstoppableforce_flash_fade_in_time", 0.075);
	lui::screen_fade( GetDvarFloat("scr_unstoppableforce_flash_fade_out_time", 0.9), 0, GetDvarFloat("scr_unstoppableforce_flash_alpha", 0.6), "white" );
}

// Turn on the "hyperdrive" boost effects on camera
function enable_boost_camera_fx(localClientNum)
{
	self.firstperson_fx = PlayFXOnCamera( localClientNum, "player/fx_plyr_ability_screen_blur_overdrive", (0,0,0), (1,0,0), (0,0,1) );
}

// Turn off the "hyperdrive" boost effects on camera
function stop_boost_camera_fx(localClientNum)
{
	if (isdefined(self.firstperson_fx))
	{
		StopFX(localClientNum, self.firstperson_fx);
		self.firstperson_fx = undefined;
	}
}

// Stop FX when we die or hit a cybercom turnoff event.
function boost_fx_interrupt_handler(localClientNum)
{
	self endon("end_unstoppableforce_boost_fx");
	
	self util::waittill_any("disable_cybercom", "death");
	stop_boost_camera_fx( localClientNum );
	
	self notify( "end_unstoppableforce_boost_fx");
}

// Turn on boost FX (hyperdrive!) when we're moving forward fast enough.
// This effectively translates to sprinting forward with its current tuning.
function boost_fx_on_velocity(localClientNum)	//self == player
{
	self endon("disable_cybercom");
	self endon("death");
	self endon("end_unstoppableforce_boost_fx");
	self endon("disconnect");
	
	//Keep track of when we might need to turn force off the boost FX
	self thread boost_fx_interrupt_handler(localclientnum);
	
	while (isDefined(self))
	{
		// Get forward direction and speed information.
		v_player_velocity = self GetVelocity();
		v_player_forward = Anglestoforward(self.angles);
		n_dot = VectorDot(VectorNormalize(v_player_velocity), v_player_forward);
		n_speed = Length(v_player_velocity);
	
		// If we're moving forward fast enough:
		if (n_speed >= GetDvarInt( "scr_unstoppableforce_boost_speed_tol", 320 ) && n_dot > 0.8)
		{
			if (!isdefined(self.firstperson_fx))
			{
				self enable_boost_camera_fx(localClientNum);
			}
		}
		else
		{
			if (isdefined(self.firstperson_fx))
			{
				self stop_boost_camera_fx(localClientNum);
			}
		}
		{wait(.016);};
	}
}
