#using scripts\shared\clientfield_shared;
#using scripts\shared\ai\systems\gib;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                           	                                     	                	                       	            	                                                                                                                                                                                                                              
                                                                                                                                                                                                       	     	                                                                                   

#precache( "client_fx", "explosions/fx_ability_exp_ravage_core" );

function autoexec precache()
{
	level._effect[ "zombie_suicide" ] = "explosions/fx_ability_exp_ravage_core";
}

function autoexec main()
{
	clientfield::register(
		"actor",
		"zombie",
		1,
		1,
		"int",
		&ZombieClientUtils::zombieHandler,
		!true,
		!true);
	
	clientfield::register(
		"actor",
		"zombie_suicide",
		1,
		1,
		"int",
		&ZombieClientUtils::zombieSuicideHandler,
		!true,
		!true);
}

#namespace ZombieClientUtils;

function zombieHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	entity = self;
	
	if ( IsDefined( entity.archetype ) && entity.archetype != "zombie" )
	{
		return;
	}
	
	if ( !IsDefined( entity.initializedGibCallbacks ) || !entity.initializedGibCallbacks )
	{
		entity.initializedGibCallbacks = true;

		GibClientUtils::AddGibCallback( localClientNum, entity, 8, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 16, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 32, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 128, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 256, &_gibCallback );
	}
}

function private _gibCallback( localClientNum, entity, gibFlag )
{
	switch (gibFlag)
	{
	case 8:
		playsound(0, "zmb_zombie_head_gib", self.origin);
		break;
	case 16:
	case 32:
	case 128:
	case 256:
		playsound(0, "zmb_death_gibs", self.origin);
		break;
	}
}


function private zombieSuicideHandler( localClientNum, oldValue, newValue, bNewEnt, bInitialSnap, fieldName, wasDemoJump )
{
	if( newValue )
	{
		PlayFxOnTag(
				localClientNum,
				level._effect[ "zombie_suicide" ],
				self,
				"j_spineupper" );
	}
}