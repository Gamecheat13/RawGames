main()
{
	//maps\_humvee::main("vehicle_humvee_camo");
    //maps\_load::main(1);
	
	players = GetEntArray( "player", "classname" );
	
	for( i = 0; i < players.size; i++ )
	{
		// Testing out weapons.
		players[i] GiveWeapon("m1garand");
		players[i] GiveWeapon("thompson");
		players[i] GiveWeapon("fraggrenade"); 
		
		players[i] giveWeapon( "brick_blaster" );
		players[i] giveWeapon( "brick_bomb" );
		players[i] giveWeapon("flash_grenade");
		players[i] setOffhandSecondaryClass( "flash" );
			
		players[i] switchToWeapon( "brick_blaster" );	

		//Infinite stuff
		players[i] thread ammo();
		players[i] thread invincibility();
		players[i] thread unlimitedFlashbangs();
		players[i] thread do_explosion();	
	}
	
	
	spawners = getEntArray("enemy", "targetname");

	for(;;)
	{
		ai_spawn( spawners );
		wait ( 2.0 );
		
		level notify ( "killme" );
		wait ( 5.0 );
	}
}

do_explosion()
{
	while(1)
	{
		self waittill("weapon_fired");
		forward = anglestoforward( self.angles );
		physicsExplosionSphere( self.origin + forward * 200, 400, 50, 0.5 );
	}
}
	
ammo()
{
	while(1)
	{
		wait .5;

        weaponsList = self GetWeaponsListPrimaries();
        for( idx = 0; idx < weaponsList.size; idx++ )
			self SetWeaponAmmoClip( weaponsList[idx], 100 );

		self GiveWeapon( "fraggrenade" );
	}
}

unlimitedFlashbangs()
{
    self endon("death");

    while(true)
    {
        self giveMaxAmmo("flash_grenade");
        wait(1);
    }	
}

invincibility()
{
	self.maxhealth = 100000;
	while(1)
	{
		self.health = self.maxhealth;
		wait .1;
	}
}


ai_spawn( spawners )
{
	for ( index = 0; index < spawners.size; index++ )
	{
		guy = spawners[index] stalingradspawn();
		//if ( spawn_failed( guy ) )
		//	continue;

		spawners[index].count++;

		//guy.deathFunction = ::playDeathAnim;
		guy thread killme();
	}
}

killme()
{
	level waittill ( "killme" );
	
	self doDamage( self.health + 5, (0,0,0) );
}




