#include maps\_utility; 
#include common_scripts\utility; 
#include animscripts\combat_utility; 
#include animscripts\utility; 
#include animscripts\ai_subclass\anims_table_militia; 

#insert raw\common_scripts\utility.gsh;
#insert raw\animscripts\utility.gsh;

subclass_militia()
{
	if ( self.type != "human" )
		return;
	
	if( !isSniper() &&  !usingShotgun() )
	{
		self.rambochance = 1.0;
		self.a.favor_blindfire = true;
		
		if( !IsDefined( self.a.doExposedBlindFire ) )
			self.a.doExposedBlindFire = true;
		
		self.a.favor_suppressedBehavior = true;
	}
	
	self.a.neverLean = true;
	self disable_react();
	self.noHeatAnims = true;
	self.a.disableReacquire = true;
	self.a.disableWoundedSet = true;
	self.grenadeawareness     = 0;
	self.a.allow_sideArm = false; // dont switch to sidearm
	self.a.noSMGPistolWeaponAnims = true;
	self.aggressiveMode = true;
	self.canFlank = true;

	if( IS_TRUE( level.randomizeMilitiaArray ) )
	{
		if( RandomInt(100) > 50 )
			setup_militia_anim_array();
	}
	else
	{
		setup_militia_anim_array();
	}
}
