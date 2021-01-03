#using scripts\shared\clientfield_shared;
#using scripts\shared\ai\systems\gib;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
                                                                                                           	                                                                                                                                                                                                                   
                                                                                                                                                                                                                                                                                                                                                                   

function autoexec precache()
{
}

function autoexec main()
{
	clientfield::register(
		"actor",
		"skeleton",
		1,
		1,
		"int",
		&ZombieClientUtils::zombieHandler,
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

		GibClientUtils::AddGibCallback( localClientNum, entity, 4, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 8, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 16, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 64, &_gibCallback );
		GibClientUtils::AddGibCallback( localClientNum, entity, 128, &_gibCallback );
	}
}

function private _gibCallback( localClientNum, entity, gibFlag )
{
	switch (gibFlag)
	{
	case 4:
		playsound(0, "zmb_zombie_head_gib", self.origin);
		break;
	case 8:
	case 16:
	case 64:
	case 128:
		playsound(0, "zmb_death_gibs", self.origin);
		break;
	}
}