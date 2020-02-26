// Weapon configuration for anim scripts.
// Supplies information for all AI weapons.
#using_animtree ("generic_human");


usingAutomaticWeapon()
{
	if ( weaponIsSemiAuto( self.weapon ) )
		return false;
		
	if ( weaponIsBoltAction( self.weapon ) )
		return false;
		
	class = weaponClass( self.weapon );
	if ( class == "rifle" || class == "mg" || class == "smg" )
		return true;

	return false;
}

usingSemiAutoWeapon()
{
	return ( weaponIsSemiAuto( self.weapon ) );
}

usingShotgunWeapon()
{
	return ( weaponClass( self.weapon ) == "spread" );
}

autoShootAnimRate()
{
	if ( usingAutomaticWeapon() )
	{
		// The auto fire animation fires 10 shots a second, so we divide the weapon's fire rate by 
		// 10 to get the correct anim playback rate.
//		return weaponFireTime( self.weapon ) * 10;
		return 0.1 / weaponFireTime( self.weapon ) * getdvarfloat("scr_ai_auto_fire_rate");
	}
	else
	{
//		println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
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
//		println ("weaponList::standAimShootAnims: No auto fire rate for "+self.weapon);
		return 0.2;	// Equates to 2 shots a second, decent for a non-auto weapon.
	}
}

waitAfterShot()
{
	return 0.25;
}

shootAnimTime(semiAutoFire)
{
	if( !usingAutomaticWeapon() || (isdefined(semiAutofire) && (semiAutofire == true)))
	{
		// We randomize the result a little from the real time, just to make things more 
		// interesting.  In reality, the 20Hz server is going to make this much less variable.
		rand = 0.5 + randomfloat(1); // 0.8 + 0.4
		return weaponFireTime( self.weapon ) * rand;
	}
	else
	{
		return weaponFireTime( self.weapon );
	}

}


RefillClip()
{
	assertEX( isDefined( self.weapon ), "self.weapon is not defined for " + self.model );

	/*
	// TODO: proper rocket ammo tracking
	if ( weaponClass( self.weapon ) == "rocketlauncher" && self.a.rockets < 1 )
		self animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
	*/

	if ( !isDefined( self.bulletsInClip ) )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
	}
	/*
	else if ( isDefined( self.ammoCounts[self.weapon] ) )
	{
		self.ammoCounts[self.weapon] -= weaponClipSize( self.weapon );
		if ( self.ammoCounts[self.weapon] > 0 )
			self.bulletsInClip = weaponClipSize( self.weapon ) + self.ammoCounts[self.weapon];
	}
	*/
	else
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
	}

	assertEX(isDefined(self.bulletsInClip), "RefillClip failed");
	
	if ( self.bulletsInClip <= 0 )
		return false;
	else
		return true;
}

precacheglobalfx()
{
	anim._effect["weapon_m16_clip"] = loadfx( "shellejects/clip_m16" );
	anim._effect["weapon_ak47_clip"] = loadfx( "shellejects/clip_ak47" );
	anim._effect["weapon_saw_clip"] = loadfx( "shellejects/clip_saw" );
	anim._effect["weapon_mp5_clip"] = loadfx( "shellejects/clip_mp5" );
	anim._effect["weapon_dragunov_clip"] = loadfx( "shellejects/clip_dragunov" );
	anim._effect["weapon_g3_clip"] = loadfx( "shellejects/clip_g3" );
	anim._effect["weapon_g36_clip"] = loadfx( "shellejects/clip_g36" );
	anim._effect["weapon_m14_clip"] = loadfx( "shellejects/clip_m14" );
	anim._effect["weapon_ak74u_clip"] = loadfx( "shellejects/clip_ak74u" );
}

precacheglobalmodels()
{
	// this should be automated...
	precacheModel( "weapon_m16_clip" );
	precacheModel( "weapon_ak47_clip" );
	precacheModel( "weapon_saw_clip" );
	precacheModel( "weapon_mp5_clip" );
	precacheModel( "weapon_dragunov_clip" );
	precacheModel( "weapon_g3_clip" );
	precacheModel( "weapon_g36_clip" );
	precacheModel( "weapon_m14_clip" );
	precacheModel( "weapon_ak74u_clip" );
	//precacheModel( "weapon_rpd_clip" ); // need the effect too (above)
}

add_weapon(name, type, time, clipsize, anims)
{
	assert (isdefined(name));
	assert (isdefined(type));
	if (!isdefined(time))
		time = 3.0;
	if (!isdefined(clipsize))
		time = 1;
	if (!isdefined(anims))
		anims = "rifle";

	name = tolower(name);
	anim.AIWeapon[name]["type"] =	type;
	anim.AIWeapon[name]["time"] 	=	time;
	anim.AIWeapon[name]["clipsize"] =	clipsize;
	anim.AIWeapon[name]["anims"] 	=	anims;
}

addTurret(turret)
{
	anim.AIWeapon[tolower(turret)]["type"] = "turret";
}
