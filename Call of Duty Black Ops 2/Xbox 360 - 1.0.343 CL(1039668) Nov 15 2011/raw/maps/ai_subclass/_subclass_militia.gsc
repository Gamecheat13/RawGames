#include maps\_utility; 
#include common_scripts\utility; 
#include animscripts\combat_utility; 
#include animscripts\utility; 
#include animscripts\ai_subclass\anims_table_militia; 

subclass_militia()
{
	if ( self.type != "human" )
		return;
	
	if( !isSniper() &&  !usingShotgun() )
	{
		self.rambochance = 1.0;
		self.a.favor_blindfire = true;
		self.a.doExposedBlindFire = true;
		self.a.favor_suppressedBehavior = true;
	}
	
	self.a.neverLean = true;
	self disable_tactical_walk();
	self disable_react();
	self.noHeatAnims = true;
	self.a.disableReacquire = true;
	self.a.disableWoundedSet = true;
	self.grenadeawareness     = 0;
	self.pathEnemyFightDist = 64; // stop at melee dist almost, anim.meleeGlobals.MELEE_RANGE	
	self.a.allow_sideArm = false; // dont switch to sidearm
	self.a.noSMGPistolWeaponAnims = true;

	setup_militia_anim_array();
}
