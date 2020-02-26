#include maps\_utility;
#include maps\_anim;

main()
{
	setExpFog( 0, 13900, 0.5, 0.5, 0.5, 0 );
	//Load Level FX
	maps\interior_concept_fx::main();

	maps\_load::main();
	playerInit();
	thread postFX_toggle();
	
}

playerInit()
{
	//Player setup
	level.player takeAllWeapons();
	level.player giveWeapon("m16_grenadier");
	level.player giveWeapon("mp5");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player setOffhandSecondaryClass( "flash" );

	//Infinite stuff
	level.player thread ammo();
	level.player thread invincibility();
	level.player thread unlimitedFlashbangs();
	
}
	
ammo()
{
	while(1)
	{
		wait .5;

        weaponsList = level.player GetWeaponsListPrimaries();
        for( idx = 0; idx < weaponsList.size; idx++ )
			level.player SetWeaponAmmoClip( weaponsList[idx], 100 );

		level.player GiveWeapon( "fraggrenade" );
	}
}

unlimitedFlashbangs()
{
    self endon("death");

    while(true)
    {
        level.player giveMaxAmmo("flash_grenade");
        wait(1);
    }	
}

invincibility()
{
	level.player.maxhealth = 100000;
	while(1)
	{
		level.player.health = level.player.maxhealth;
		wait .1;
	}
}

postFX_toggle()
{
	level.player endon ( "death" );
	
	for (;;)
	{
		while ( !level.player buttonPressed( "DPAD_LEFT" ) )
			wait 0.05;
		
		if ( isdefined( level.player.postFX_ON ) )
			postFX_Off();
		else
			postFX_ON();
		
		while ( level.player buttonPressed( "DPAD_LEFT" ) )
			wait 0.05;
	}
}

postFX_ON()
{
	level.player.postFX_ON = true;
	VisionSetNaked( "interior_concept" );
}

postFX_Off()
{
	// set dvars back to original values
	VisionSetNaked( "default" );
	level.player.postFX_ON = undefined;
}