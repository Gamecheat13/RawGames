#using scripts\codescripts\struct;

#using scripts\shared\exploder_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\sound_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\zm\_util;

/*
	****************************************************************************************************************
	GunFireLoopfx: Simulates bursts of fire.
	fx::gunfireloopfx(fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)

	Example:
	fx::gunfireloopfx (level.medFire,			// Medium fire effect
							(-701, -18361, 148),	// Origin
							10, 15,					// 10 to 15 shots
							0.1, 0.3,				// 0.1 to 0.3 seconds between shots
							2.5, 9);				// 2.5 to 9 seconds between sets of shots.
	****************************************************************************************************************

	****************************************************************************************************************
	GrenadeExplosionfx: Creates a grenade explosion with view jitter.
	fx::GrenadeExplosionfx((x y z));

	Example:
	fx::GrenadeExplosionfx( (-701, -18361, 148) ); // origin
	****************************************************************************************************************
*/

#namespace fx;

function print_org (fxcommand, fxId, fxPos, waittime)
{
	/#
	if (GetDvarString( "debug") == "1")
	{
		println ("{");
		println ("\"origin\" \"" + fxPos[0] + " " + fxPos[1] + " " + fxPos[2] + "\"");
		println ("\"classname\" \"script_model\"");
		println ("\"model\" \"fx\"");
		println ("\"script_fxcommand\" \"" + fxcommand + "\"");
		println ("\"script_fxid\" \"" + fxId + "\"");
		println ("\"script_delay\" \"" + waittime + "\"");
		println ("}");
	}
	#/
}

function gunfireloopfx(fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
    thread gunfireloopfxthread (fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax);
}

function gunfireloopfxthread (fxId, fxPos, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	level endon ("stop all gunfireloopfx");
	wait .05; // waitframe

	if (betweenSetsMax < betweenSetsMin)
	{
		temp = betweenSetsMax;
		betweenSetsMax = betweenSetsMin;
		betweenSetsMin = temp;
	}

	betweenSetsBase = betweenSetsMin;
	betweenSetsRange = betweenSetsMax - betweenSetsMin;

	if (shotdelayMax < shotdelayMin)
	{
		temp = shotdelayMax;
		shotdelayMax = shotdelayMin;
		shotdelayMin = temp;
	}

	shotdelayBase = shotdelayMin;
	shotdelayRange = shotdelayMax - shotdelayMin;

	if (shotsMax < shotsMin)
	{
		temp = shotsMax;
		shotsMax = shotsMin;
		shotsMin = temp;
	}

	shotsBase = shotsMin;
	shotsRange = shotsMax - shotsMin;

	fxEnt = spawnFx( level._effect[fxId], fxPos );
    for (;;)
    {
		shotnum = shotsBase + randomint (shotsRange);
		for (i=0;i<shotnum;i++)
		{
			triggerFx( fxEnt );

			wait (shotdelayBase + randomfloat (shotdelayRange));
		}
        wait (betweenSetsBase + randomfloat(betweenSetsRange));
    }
}

function gunfireloopfxVec(fxId, fxPos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
    thread gunfireloopfxVecthread (fxId, fxPos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax);
}

function gunfireloopfxVecthread (fxId, fxPos, fxPos2, shotsMin, shotsMax, shotdelayMin, shotdelayMax, betweenSetsMin, betweenSetsMax)
{
	level endon ("stop all gunfireloopfx");
	wait .05; // waitframe

	if (betweenSetsMax < betweenSetsMin)
	{
		temp = betweenSetsMax;
		betweenSetsMax = betweenSetsMin;
		betweenSetsMin = temp;
	}

	betweenSetsBase = betweenSetsMin;
	betweenSetsRange = betweenSetsMax - betweenSetsMin;

	if (shotdelayMax < shotdelayMin)
	{
		temp = shotdelayMax;
		shotdelayMax = shotdelayMin;
		shotdelayMin = temp;
	}

	shotdelayBase = shotdelayMin;
	shotdelayRange = shotdelayMax - shotdelayMin;

	if (shotsMax < shotsMin)
	{
		temp = shotsMax;
		shotsMax = shotsMin;
		shotsMin = temp;
	}

	shotsBase = shotsMin;
	shotsRange = shotsMax - shotsMin;

	fxPos2 = vectornormalize (fxPos2 - fxPos);

	fxEnt = spawnFx ( level._effect[fxId], fxPos, fxPos2 );

	for (;;)
	{
		shotnum = shotsBase + randomint (shotsRange);
		for (i=0;i<int(shotnum/level.fxfireloopmod);i++)
		{
			triggerFx( fxEnt );
			delay =((shotdelayBase + randomfloat (shotdelayRange))*level.fxfireloopmod);
			if(delay < .05)
				delay = .05;
			wait delay;
		}
		wait (shotdelayBase + randomfloat (shotdelayRange));
		wait (betweenSetsBase + randomfloat(betweenSetsRange));
	}
}

function GrenadeExplosionfx(pos)
{
	playfx (level._effect["mechanical explosion"], pos);
	earthquake(0.15, 0.5, pos, 250);
	// TODO: Add explosion effect and view jitter
//	println("The script command grenadeExplosionEffect has been removed. fx::GrenadeExplosionfx must be set up to make an effect and jitter the view.");
}
