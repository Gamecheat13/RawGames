#include maps\_utility; 
#include common_scripts\utility; 

main()
{
	maps\_80s_sedan1::main( "vehicle_80s_sedan1_red_destructible" );
	maps\_80s_hatch1::main( "vehicle_80s_hatch1_green_destructible" );
	maps\_bus::main( "vehicle_bus_destructable" );
	maps\_bm21_troops::main( "vehicle_bm21_mobile_bed_destructible" );
	maps\_uaz::main( "vehicle_uaz_fabric_destructible" );
	maps\_uaz::main( "vehicle_uaz_open_destructible" );
	maps\_uaz::main( "vehicle_uaz_hardtop_destructible" );
	maps\_uaz::main( "vehicle_uaz_light_destructible" );
	speedbumps_setup();
	maps\_load::main();
	playerInit();
	maps\_vehicle::create_vehicle_from_spawngroup_and_gopath( 0 );
	wait .1;
	ai = getaiarray("allies")[0];

	ai thread magic_bullet_shield();	
	
//	array_thread(getentarray("script_vehicle","classname"),maps\_vehicle::godon);
	while(1)
	{
		while(!level.player usebuttonpressed())
			wait .05;
		ai = getaiarray("allies")[0];
		
//		array_thread(getentarray("script_vehicle","classname"),::dropragdolloncarsinview, ai);
		thread dropragdollatpoint( ai );
		wait .1;
	}
	
	/*
	while( !level.player useButtonPressed() )
		wait 0.05;
	array_thread( getentarray( "destructible", "targetname" ), ::destructible_disable_explosion );
	
	while( level.player useButtonPressed() )
		wait 0.05;
	
	while( !level.player useButtonPressed() )
		wait 0.05;
	
	array_thread( getentarray( "destructible", "targetname" ), ::destructible_force_explosion );
	*/
}

dropragdollatpoint( ai )
{
	trace = player_view_trace();
	position = trace["position"];
	ragdoll = maps\_vehicle_aianim::convert_guy_to_drone ( ai, true );
	
	offsetorigin = position+ (0,0,256);
	
	dropspeedbump( offsetorigin );
	ragdoll.origin = offsetorigin;
	ragdoll.angles = (randomfloat(340),randomfloat(340),randomfloat(340));
	wait .05;
	ragdoll thread startragdoll_loc();
}

startragdoll_loc()
{
	self startragdoll();
	wait 2;
	self delete();
}

player_view_trace()
{
	maxdist = 1000;
	traceorg = level.player geteye();
	return bullettrace( traceorg, traceorg + vector_multiply( anglestoforward( level.player getplayerangles() ), maxdist ), 0, self );
}


dropragdolloncarsinview( ai )
{
	if(! within_fov( level.player.origin, level.player.angles, self.origin, cos(30) ) )
		return;
	ragdoll = maps\_vehicle_aianim::convert_guy_to_drone ( ai, true );
	ragdoll.origin = self.origin+(0,0,196);
	wait .05;
	ragdoll startragdoll_loc();
	
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
	//level.player thread invincibility();
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

invincibility()
{
	level.player.maxhealth = 100000;
	while(1)
	{
		level.player.health = level.player.maxhealth;
		wait .1;
	}
}

speedbumps_setup()
{
	level.speedbumpcurrent = 0;
	level.speedbumps = getentarray("speedbump","targetname");
}

dropspeedbump( origin )
{
	level.speedbumpcurrent++;
	if(level.speedbumpcurrent >= level.speedbumps.size)
		level.speedbumpcurrent = 0;
	groundpos = bullettrace( origin, ( origin + ( 0, 0, -100000 ) ), 0, undefined )[ "position" ];
	level.speedbumps[ level.speedbumpcurrent ].origin = groundpos;
}