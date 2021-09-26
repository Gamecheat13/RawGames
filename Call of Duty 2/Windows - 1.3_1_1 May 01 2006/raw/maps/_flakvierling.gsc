/////////////////////////////////////////////////////////////////////////////
// Flak Vierling
/////////////////////////////////////////////////////////////////////////////
#using_animtree( "artillery_flakvierling" );

main()
{
	precachemodel("xmodel/artillery_flakvierling_d");
}


init()
{
	self UseAnimTree( #animtree );

	self.health = 1000;

	thread kill();
	thread shoot();
}

kill()
{
	self.deathmodel = "xmodel/artillery_flakvierling_d";
	self.deathfx    = loadfx( "fx/explosions/explosion1.efx" );
	self.deathsound = "explo_metal_rand";

	maps\_utility::precache( self.deathmodel );

	self waittill( "death", attacker );

	self setmodel( self.deathmodel );
	self playsound( self.deathsound );
	self clearTurretTarget();

	playfx( self.deathfx, self.origin );
	earthquake( 0.25, 3, self.origin, 1050 );

	self freeVehicle();
}

shoot()
{
	barrel = 1;
	setcvar("shaky",.2);
	while( self.health > 0 )
	{
		self waittill( "turret_fire" );
		self FireTurret();
		earthquake(getcvarfloat("shaky"), .1, self.origin, 2250);

		if( barrel == 1 )
		{
			self setAnimKnobRestart( %artillery_flakvierling_fire1 );
			barrel = 2;
		}
		else
		{
			self setAnimKnobRestart( %artillery_flakvierling_fire2 );
			barrel = 1;
		}
	}
}


