

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
		
		

		return 0.1 / weaponFireTime( self.weapon ) * getdvarfloat("scr_ai_auto_fire_rate");
	}
	else
	{

		return 0.2;	
	}
}

burstShootAnimRate()
{
	if (usingAutomaticWeapon())
	{
		
		
		return 0.16 / weaponFireTime( self.weapon );
	}
	else
	{

		return 0.2;	
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
		
		
		rand = 0.5 + randomfloat(1); 
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

	

	if ( !isDefined( self.bulletsInClip ) )
	{
		self.bulletsInClip = weaponClipSize( self.weapon );
	}
	
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
	
	
	
	
	
	
	
	
	
}

precacheglobalmodels()
{
	
	
	
	
	
	
	
	
	
	
	
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
