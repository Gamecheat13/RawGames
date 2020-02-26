/****************************************************************************
Level: 		Zipline
Campaign: 	SAS
****************************************************************************/

#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\jake_tools;
#using_animtree("generic_human");

main()
{

	maps\createart\zipline_art::main();
	level thread maps\zipline_fx::main();

	maps\_bm21::main("vehicle_bm21_mobile");
	maps\_truck::main("vehicle_pickup_4door");
	maps\_bmp::main("vehicle_bmp");
	
	maps\zipline_anim::main();
	maps\_load::main();
	level thread maps\zipline_amb::main();	

	battlechatter_off( "allies" );
	
	AA_town_init();
	
	thread descriptions();
}

descriptions()
{
	descriptions = getentarray("description", "targetname");
	for(i=0;i<descriptions.size;i++)
		descriptions[i] thread print3DthreadZip(descriptions[i].script_noteworthy);
}


/****************************************************************************
    MAIN TOWN START
****************************************************************************/
AA_town_init()
{
	thread bm21_spawn_and_think();
}


bm21_spawn_and_think()
{
	aBM21targetnames = [];
	aBM21targetnames[0] = "bm21_01";
	aBM21targetnames[1] = "bm21_02";
	aBM21targetnames[2] = "bm21_03";
	aBM21targetnames[3] = "bm21_04";
	
	for(i=0;i<aBM21targetnames.size;i++)
		thread bm21_think(aBM21targetnames[i]);
}


bm21_think(sTargetname)
{
	eVehile = spawn_vehicle_from_targetname(sTargetname);
	eVehile thread bm21_artillery_think();

}

bm21_artillery_think()
{
	self endon ("death");

	aTargets = [];
	tokens = strtok( self.script_linkto, " " );
	for ( i=0; i < tokens.size; i++ )
		aTargets[aTargets.size] = getent( tokens[ i ], "script_linkname" );
		
	assertEx(aTargets.size > 1, "Vehicle at position " + self.origin + " needs to scriptLinkTo more than 1 script_origin artillery targets");
	aTargets = array_randomize(aTargets);
	while (true)
	{
		wait (randomfloatrange(4, 10));
		for(i=0;i<aTargets.size;i++)
		{
			iTimesToFire = 5 + randomint(6);
			for(i2=0;i2<iTimesToFire;i2++)
			{
				if (i2 == 0)
				{
					self setturrettargetent (aTargets[i]);
					self waittill ("turret_rotate_stopped");	
					wait(1);	
				}

				self notify ( "shoot_target", aTargets[i]);
				wait (.25);
			}
		}
	}
}

print3DthreadZip(sMessage)
{
	self notify ("stop_3dprint");
	self endon ("stop_3dprint");
	self endon ("death");

	for (;;)
	{
		if (isdefined(self))
			print3d (self.origin + (0,0,0), sMessage, (1,1,1), 1, 0.5);
		wait (0.05);
	}
}