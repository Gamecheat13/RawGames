#include maps\mp\_utility;
#include common_scripts\utility;


/*
///ScriptDocBegin
Name: boost_jump_wrapper()
Summary: Controls player boost.
Module: MP
CallOn: a player
MandatoryArg: N/A
Example: level.player thread boost_jump_wrapper();
SPMP: MP
///ScriptDocEnd
*/
boost_jump_wrapper()
{
	self endon( "death" );
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	
	//variables//
	self.boost_fuel = 100;
	self.vert_vel = 0;
	self.thruster_force = (0,0,0);
	self.boost_stalled = false;
	////////////////
	
//	self thread handleJetpackFuelMeter();
	
	gameFlagWait("prematch_done");
	
	setdvar("boostjump_enable", "1");
	
//	self DisableOffhandWeapons();
	
	self thread play_boost_sound();
	
/*
	while (1)
	{
		if (self SecondaryOffhandButtonPressed())
		{
			//If the player is not standing, make them stand.
			if (self GetStance() != "stand")
			{
				self SetStance("stand");
			}
			else if (self.boost_fuel > 0 && self.boost_stalled == false)
			{
				if (self.vert_vel < 50)
				{
					self.vert_vel += 10;
				}
				self.thruster_force = (0, 0, self.vert_vel);
				self thread jetpack_fly(self.thruster_force);
				self.boost_fuel -= 3;
			}
			//If the player is holding down the boost button with no fuel, they are stalled (their booster doesn't fire, but the booster starts recharging).
			else if (self.boost_fuel <= 0 || self.boost_stalled == true)
			{
				//Recharge fuel when the player has used up their fuel and is holding down the boost button.
				self.boost_stalled = true;
				if (self.boost_fuel < 100)
				{
					self.boost_fuel += 3;
					if (self.boost_fuel > 100)
					{
						self.boost_fuel = 100;
					}
				}
			}
		}
		else
		{
			self.boost_stalled = false;
			
			self.vert_vel = 0;
			self.thruster_force = (0,0,0);
			if (self.boost_fuel < 100)
			{
				self.boost_fuel += 3;
				if (self.boost_fuel > 100)
				{
					self.boost_fuel = 100;
				}
			}
		}
		wait(0.05);
	}
	*/
}


/*
///ScriptDocBegin
Name: boost_jump(<thruster_force>)
Summary: boosts the player.
Module: MP
CallOn: a player
MandatoryArg: <thruster_force> the vector you want to add to the player's velocity.
Example: level.player thread boost_jump();
SPMP: MP
///ScriptDocEnd
*/
jetpack_fly( thruster_force )
{
	self endon( "death" );
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	
	self.boost["inboost"] = true;
	self PlayRumbleOnEntity( "damage_heavy" );
	
	current_velocity = self GetVelocity();
	//current_position = self.origin;
	
	movement = current_velocity + thruster_force;
	//new_position = current_position + thruster_force;
	
	self SetVelocity( movement );
	//self MoveTo(new_position, 0.05, 0.05, 0.05);
}


/*
///ScriptDocBegin
Name: play_boost_sound()
Summary: plays the boost jump sound in a waited loop.
Module: MP
CallOn: a player
MandatoryArg: N/A
Example: level.player thread play_boost_sound();
SPMP: MP
///ScriptDocEnd
*/
play_boost_sound()
{
	self endon("death");
	self endon("disconnect");
	self endon("joined_team");
	self endon("joined_spectators");
	
	while (1)
	{
		if (self SecondaryOffhandButtonPressed() && self GetBoostJumpStalled() == false)
		{
			self PlayRumbleOnEntity( "damage_heavy" );
			playSoundinSpace("boost_jump_plr_mp", self.origin);
			if (self GetBoostJumpFuel() > 10)
			{
				wait(0.05);
			}
			else
			{
				wait(1);
			}
		}
		wait(0.05);
	}
}


/*
///ScriptDocBegin
Name: handleJetpackFuelMeter()
Summary: creates and animates a player's jetpack's fuel meter.
Module: MP
CallOn: a player
MandatoryArg: N/A
Example: level.player thread handleJetpackFuelMeter();
SPMP: MP
///ScriptDocEnd
*/
handleJetpackFuelMeter()
{
	self endon("game_ended");
	self endon("disconnect");
	
	if (!IsDefined(self.hud_fuel_meter))
	{
		self.hud_fuel_meter = NewClientHudElem(self);
		self.hud_fuel_meter.x = 30;
		self.hud_fuel_meter.y = 200;
		self.hud_fuel_meter.sort = 6;
		self.hud_fuel_meter.horzalign = "left";
		self.hud_fuel_meter.vertalign = "top";
		self.hud_fuel_meter SetShader( "hudcolorbar", 20, 100 );
	}
	if (!IsDefined(self.hud_fuel_arrow))
	{
		self.hud_fuel_arrow = NewClientHudElem(self);
		self.hud_fuel_arrow.sort = 6;
		self.hud_fuel_arrow.x = 10;
		self.hud_fuel_arrow.horzalign = "left";
		self.hud_fuel_arrow.vertalign = "top";
		self.hud_fuel_arrow SetShader( "hud_killstreak_dpad_arrow_right", 20, 20 );
	}
	
	while (1)
	{
		self.hud_fuel_arrow.y = 290 - self GetBoostJumpFuel();
		wait(0.05);
	}
	
	self waittill("death");
	return;
}


playerBoostJumpPrecaching()
{
	PreCacheShader("hudcolorbar");
	PreCacheShader("hud_killstreak_dpad_arrow_right");
}
