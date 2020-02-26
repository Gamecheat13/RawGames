#include maps\_utility;


main()
{
	precacheVehicles();

	maps\_load::main();
	maps\_javelin::init();

	thread LoadOut();

	setExpFog(250, 6000, .5, .5, .52, 0);
	VisionSetNaked( "ambush" );

	level.player SetActionSlot( 3, "weapon", "C4" );	//DPAD_LEFT switches to C4
	level.player SetActionSlot( 4, "" );

	thread mytargettest();
	thread dropJavelin();
    thread blartest();
    //thread looptest();
}


LoadOut()
{
	PreCacheItem( "javelin" );
	PreCacheItem( "m4_grenadier" );
	PreCacheItem( "g36c" );
	PreCacheItem( "deserteagle" );
	PreCacheItem( "usp" );
	PreCacheItem( "c4" );

	//wait ( 1.0 );

	level.player TakeAllWeapons();

	//level.player GiveWeapon( "m4_grenadier" );
	level.player GiveWeapon( "javelin" );
	//level.player GiveWeapon( "colt45" );
	level.player GiveWeapon( "g36c" );
	//level.player GiveWeapon( "deserteagle" );
	//level.player GiveWeapon( "usp" );
	level.player GiveWeapon( "c4" );

	level.player switchToWeapon( "javelin" );
}


blartest()
{

    while( 1 )
    {
        blar = getdvar( "blar" );
        
        if ( blar == "test" )
        {
        	weapons = level.player GetWeaponsListPrimaries();
        	for( idx = 0; idx < weapons.size; idx++ )
        	{
	        	fraction = level.player GetFractionMaxAmmo( weapons[idx] );
        		println( "weapon ", idx, ":   ", fraction, " - ", weapons[idx] );
        	}

			result = maps\_autosave::autoSaveAmmoCheck();
			if ( result )
				println( "Autosave okay!" );
			else
				println( "Autosave denied." );
		}
		else if ( blar == "weaplock" )
		{
			level.player DisableWeapons();
		}
		else if ( blar == "weapunlock" )
		{
			level.player EnableWeapons();
		}
		else if ( blar == "ammo" )
		{
			weaponsList = level.player GetWeaponsList();
			for( idx = 0; idx < weaponsList.size; idx++ )
			{
				weapon = weaponsList[idx];

				level.player giveMaxAmmo( weapon );
				level.player SetWeaponAmmoClip( weapon, 9999 );
			}
		}
		else if ( blar == "m4" )
		{
			level.player SetWeaponAmmoStock( "m4_grenadier", 4 );
		}
		else if ( blar == "lock" )
		{
			//origin = Spawn( "script_origin", level.player.origin );
			origin = Spawn( "script_origin", level.player getorigin() );
			origin.angles = level.player GetPlayerAngles();
			
			println( "Player origin: ", level.player getorigin() );
			println( "LockEnt origin: ", origin getorigin() );
			
			level.player PlayerLinkToDelta( origin );
			level.player SetPlayerAngles( origin.angles );
			
			wait ( 2.0 );
			level.player UnLink();
		}

        setdvar( "blar", "" );
        wait( 0.1 );
	}
}


LoopTest()
{
	while(1)
	{
		wait 0.1;
		println( "Weapon: ", (level.player GetCurrentWeapon()) );
	}
}


dropJavelin()
{
	while(1)
	{
		wait 2.0;

		javelin = getent( "weapon_javelin", "classname" );
		if ( isDefined( javelin ) )
			continue;

		target = getent( "spawn_javelin", "targetname" );
		origin = target getOrigin();
		newJavelin = spawn( "weapon_javelin", origin );
	}
}


precacheVehicles()
{
	maps\_t72::main("vehicle_t72_tank");
}


TargetDeathWait( ent )
{
	ent waittill ( "death" );
	target_remove( ent );
}


SetTestTankTarget( name, attackmode )
{
	OFFSET = ( 0, 0, 20 );
	targ = getent( name, "targetname" );
	target_set( targ, OFFSET );
	target_setAttackMode( targ, attackmode );
	target_setJavelinOnly( targ, true );
	thread TargetDeathWait( targ );
}


SetTestPointTarget( name, attackmode )
{
	targ = getent( name, "targetname" );
	target_set( targ );
	target_setAttackMode( targ, attackmode );
	target_setJavelinOnly( targ, true );
}


mytargettest()
{
	wait( 0.5 );
	
	SetTestTankTarget( "tank1", "top" );
	SetTestTankTarget( "tank2", "top" );
	SetTestTankTarget( "tank3", "direct" );
	
	SetTestPointTarget( "building1", "direct" );
	SetTestPointTarget( "building2", "direct" );
}


