#include maps\_utility;

// Weapon configuration for anim scripts.
// Supplies information for all AI weapons.
#using_animtree ("generic_human");

usingAutomaticWeapon()
{
	if( self.weapon == "none" || !self animscripts\utility::holdingWeapon() )
		return false;
	
	if ( weaponIsSemiAuto( self.weapon ) )
		return false;
			
	if ( weaponIsBoltAction( self.weapon ) )
		return false;
			
	class = self.weaponclass;

	if ( class == "rifle" || class == "mg" || class == "smg" )
		return true;
	
	return false;
}

usingSemiAutoWeapon()
{
	return ( weaponIsSemiAuto( self.weapon ) );
}

autoShootAnimRate()
{
	if ( usingAutomaticWeapon() )
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
		// return weaponFireTime( self.weapon ) * 10;
		return 0.1 / weaponFireTime( self.weapon ) * GetDvarfloat( "scr_ai_auto_fire_rate");
	}
	else
	{
		//println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
		return 0.2;	// Equates to 2 shots a second, decent for a non-auto weapon.
	}
}

burstShootAnimRate()
{
	if (usingAutomaticWeapon())
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
		return 0.16 / weaponFireTime( self.weapon );
	}
	else
	{
		//println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
		return 0.2;	// Equates to 2 shots a second, decent for a non-auto weapon.
	}
}

waitAfterShot()
{
	return 0.25;
}

shootAnimTime(semiAutoFire)
{
	if( !usingAutomaticWeapon() || (IsDefined(semiAutofire) && (semiAutofire == true)))
	{
		// We randomize the result a little from the real time, just to make things more 
		// interesting.  In reality, the 20Hz server is going to make this much less variable.
		rand = 0.5 + RandomFloat(1); // 0.8 + 0.4
		return weaponFireTime( self.weapon ) * rand;
	}
	else
	{
		return weaponFireTime( self.weapon );
	}

}

RefillClip()
{
	assert( IsDefined( self.weapon ), "self.weapon is not defined for " + self.model );

	if ( self.weapon == "none" )
	{
		self.bulletsInClip = 0;
		return false;
	}
	
	// AI_TODO - Proper ammo tracking for rocketlauncher AI's
	if ( self.weaponclass == "rocketlauncher" )
	{
		if ( !self.a.rocketVisible )
			self thread animscripts\combat_utility::showRocketWhenReloadIsDone();
			
		if( self.a.rockets <= 0 )
			self.a.rockets = weaponClipSize( self.weapon );
	}

	self.bulletsInClip = weaponClipSize( self.weapon );
	assert(IsDefined(self.bulletsInClip), "RefillClip failed");
	
	if ( self.bulletsInClip <= 0 )
		return false;
	else
		return true;
}

precacheWeaponSwitchFx()
{
	
	// AI_TODO : This is currently being worked on and not finished yet.
	// Add weapon specific effects one we come up with design
	
	//weaponSwitchEffects = [];
		
	//weaponSwitchEffects["dragunov_switch"]	= "misc/fx_weapon_switch_glare";
	//anim._effect[ "dragunov_switch" ] = loadfx( weaponSwitchEffects["dragunov_switch"] );

}
