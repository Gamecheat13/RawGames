#include maps\_utility;
#include maps\firingrange_share;
#include common_scripts\utility;

main()
{
	maps\_load::main();

	PrecacheItem( "facemask" );

	level.weaponslotsthread = ::weaponslots;

	level.player giveWeapon("saw");
	level.player giveWeapon("beretta");
	level.player giveWeapon("fraggrenade");
	level.player giveWeapon("flash_grenade");
	level.player switchtoWeapon("beretta");
	level.player setOffhandSecondaryClass( "flash" );
	level.player giveWeapon("claymore");
	level.player SetActionSlot( 3, "weapon" , "claymore" );
	level.player setViewmodel( "viewmodel_base_viewhands" );
		
				
	setExpFog(800, 6000, .5, .55 , .6, 0);
	VisionSetNaked( "village_defend" );
	
	init();
	
    thread blartest();
}

weaponslots()
{
	weaponslots = [];
	weaponslots = weaponadd("saw",weaponslots);
	weaponslots = weaponadd("rpd",weaponslots);
	weaponslots = weaponadd("at4",weaponslots);
	weaponslots = weaponadd("winchester1200",weaponslots);
	weaponslots = weaponadd("rpg",weaponslots);
	weaponslots = weaponadd("mp5",weaponslots);
	weaponslots = weaponadd("beretta",weaponslots);
	weaponslots = weaponadd("dragunov",weaponslots);
	weaponslots = weaponadd("m14_scoped",weaponslots);
	weaponslots = weaponadd("m40a3",weaponslots);
	weaponslots = weaponadd("usp",weaponslots);
	weaponslots = weaponadd("deserteagle",weaponslots);
	weaponslots = weaponadd("uzi",weaponslots);
	weaponslots = weaponadd("skorpion",weaponslots);
	weaponslots = weaponadd("m60e4",weaponslots);
	weaponslots = weaponadd("c4",weaponslots);
	weaponslots = weaponadd("claymore",weaponslots);
	weaponslots = weaponadd("claymore2",weaponslots);
	weaponslots = weaponadd("mp5_silencer",weaponslots);
	weaponslots = weaponadd("colt45",weaponslots);
	weaponslots = weaponadd("m1014",weaponslots);
	

	return weaponslots;
}

blartest()
{
    while( 1 )
    {
        blar = getdvar( "blar" );
        
        if ( blar == "" )
        {
        }
        else if ( blar == "disable" )
        {
        	level.player DisableWeapons();
        }
        else if ( blar == "enable" )
        {
        	level.player EnableWeapons();
        }
        else if ( blar == "facemask" )
        {
        	level.player DisableWeapons();
        	wait( 1.0 );
        	SetSavedDvar( "nightVisionDisableEffects", 1 );
        	level.player ForceViewmodelAnimation( "facemask", "nvg_down" );
        	wait( 4.5 );
        	SetSavedDvar( "nightVisionDisableEffects", 0 );
        	level.player EnableWeapons();
        }
        else
        {
        	level.player ForceViewmodelAnimation( "facemask", blar );
        }

        setdvar( "blar", "" );
        wait( 0.1 );
    }
}
