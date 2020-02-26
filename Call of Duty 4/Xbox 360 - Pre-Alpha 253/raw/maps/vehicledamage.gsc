main()
{
	maps\_80s_sedan1::main( "vehicle_80s_sedan1_red_destructible" );
	maps\_80s_hatch1::main( "vehicle_80s_hatch1_green_destructible" );
	maps\_load::main();
	playerInit();
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
}

playerInit()
{
	//Player setup
	level.player takeAllWeapons();
	level.player giveWeapon("m16_grenadier");
	level.player giveWeapon("usp");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player setOffhandSecondaryClass( "flash" );
	level.player switchToWeapon( "usp" );	

	//Infinite stuff
	level.player thread ammo();
	level.player thread invincibility();
	
}
	
ammo()
{
	while(1)
	{
		wait .5;

        //weaponsList = level.player GetWeaponsListPrimaries();
        //for( idx = 0; idx < weaponsList.size; idx++ )
		//	level.player SetWeaponAmmoClip( weaponsList[idx], 100 );

		level.player GiveWeapon( "fraggrenade" );
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
