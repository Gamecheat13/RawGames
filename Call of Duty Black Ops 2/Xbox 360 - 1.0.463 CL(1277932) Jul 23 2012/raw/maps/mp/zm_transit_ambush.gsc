#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility;

#include maps\mp\zm_transit_utility;

main()
{
	level.numRoundsSinceLastAmbushRound		= 0;
	level.numBusStopsSinceLastAmbushRound	= 0;
	level.numAmbushRounds 					= 0;
	level.ambushPercentagePerStop			= 10;
	level.ambushPercentagePerRound			= 25;

	flag_init( "ambush_round", 0 );
	flag_init( "ambush_safe_area_active", 0 );
	initAmbushEffects();

	thread ambushRoundKeeper();

	/#
	AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Ambush Round:6/Always:1\" \"zombie_devgui ambush_round always\"\n" );
	AddDebugCommand( "devgui_cmd \"Zombies:1/Bus:14/Ambush Round:6/Never:2\" \"zombie_devgui ambush_round never\"\n" );
	#/
}

initAmbushEffects()
{
	level._effect[ "ambush_bus_fire" ] = LoadFX( "env/fire/fx_fire_md" );
}

shouldStartAmbushRound()
{
	/#

	// dev gui option to always force an ambush round
	if ( level.ambushPercentagePerStop == 100 )
	{
		return true;
	}

	if ( GetDvarInt( "zombie_cheat" ) == 2 )
	{
		return false;
	}

	#/

	// can not recive two ambush rounds in a row
	if ( level.numBusStopsSinceLastAmbushRound < 2 )
	{
		//* return false;
	}

	// every bus stop adds 10 percent chance fire an ambush round
	randInt = RandomIntRange(0, 100);
	percentChance = level.numBusStopsSinceLastAmbushRound * level.ambushPercentagePerStop;

	if ( randInt < percentChance )
	{
		//* return true;
	}

	// every round adds 25 percent chance fire an ambush round
	percentChance = level.numRoundsSinceLastAmbushRound * level.ambushPercentagePerRound;

	if ( randInt < percentChance )
	{
		//* return true;
	}

	if ( maps\mp\zm_transit_bus::busGasEmpty() )
	{
		return true;
	}

	return false;
}

isAmbushRoundActive()
{
	return flag_exists( "ambush_round" ) && flag( "ambush_round" );
}

is_ambush_round_spawning_active()
{
	return flag_exists( "ambush_safe_area_active" ) && flag( "ambush_safe_area_active" );
}

ambushStartRound()
{
	flag_set( "ambush_round" );

	//* level thread ambushPointFailSafe();

	ambushRoundThink();
}

ambushEndRound()
{
	//* ambushRoundAftermath();

	level.the_bus.IsSafe = true;

	maps\mp\zm_transit_bus::busGasAdd( 60 );

	level.numBusStopsSinceLastAmbushRound = 0;
	level.numRoundsSinceLastAmbushRound = 0;

	flag_clear( "ambush_round" );
}

cancelAmbushRound()
{
	// reset ambush round flags
	flag_clear( "ambush_round" );
	flag_clear( "ambush_safe_area_active" );
	maps\mp\zm_transit_utility::try_resume_zombie_spawning();

	bbprint( "zombie_events", "category %s type %s round %d", "DOG", "stop", level.round_number );

	// end ambush threads
	level.the_bus notify ( "ambush_round_fail_safe" );
}

ambushRoundSpawning()
{
	level.numAmbushRounds++;
	//* level thread ambushRoundEffects();

	// it is still safe on the bus for a limited time
	wait( 6 );
	level.the_bus.IsSafe = false;

	//* level.dog_targets = GET_PLAYERS();

	//* for( i = 0 ; i < level.dog_targets.size; i++ )
	//* {
	//* 	level.dog_targets[i].hunted_by = 0;
	//* }

	//* ambushDogHealthIncrease();
	//* limitedAmbushSpawn();
}

limitedAmbushSpawn()
{
	// the number of dogs spawned is based on the number of ambush rounds already recived
	if ( level.numAmbushRounds < 3 )
	{
		dogCount = level.dog_targets.size * 6;
	}
	else
	{
		dogCount = level.dog_targets.size * 8;
	}

	setupDogSpawnLocs();

	level thread ambushRoundSpawnFailSafe( 20 );

	while ( get_enemy_count() > 0 )
	{
		wait(1.0);
	}

	level notify( "end_ambushWaitFunction" );
}

ambushRoundThink()
{
	module = maps\mp\zombies\_zm_game_module::get_game_module( level.GAME_MODULE_NML_INDEX );

	if ( IsDefined( module.hub_start_func ) )
	{
		level thread[[ module.hub_start_func ]]( "nml" );
		level notify( "game_mode_started" );
	}

	//* flag_clear( "end_nml" );

	level thread ambushRoundSpawning();
	ambushWaitFunction();
	ambushEndRound();
}

ambushWaitFunction()
{
	//* flag_wait( "end_nml" );
}

ambushPointFailSafe()
{
	level.the_bus endon( "ambush_point" );
	level.the_bus waittill( "reached_stop_point" );

	cancelAmbushRound();
}

ambushRoundSpawnFailSafe( timer )
{
	ambushRoundTimeLimit = timer;
	currentAmbushTime = 0;

	while ( currentAmbushTime < ambushRoundTimeLimit )
	{
		if ( !flag( "ambush_round" ) )
		{
			return;
		}

		wait( 1.0 );
		currentAmbushTime++;
	}

	level notify( "end_ambushWaitFunction" );

	wait(5);

	// kill any lost dogs
	//------------------------------------
	dogs = GetAISpeciesArray( "all", "zombie_dog" );

	for( i = 0; i < dogs.size; i++)
	{
		// already going to die
		if ( IsDefined(dogs[i].marked_for_death) && dogs[i].marked_for_death )
		{
			continue;
		}

		if ( is_magic_bullet_shield_enabled( dogs[i] ) )
		{
			continue;
		}

		dogs[i] dodamage( dogs[i].health + 666, dogs[i].origin );
	}
}

ambushDogHealthIncrease()
{
	switch( level.numAmbushRounds )
	{
		case 1:
		{
			level.dog_health = 400;
		} break;
		case 2:
		{
			level.dog_health = 900;
		} break;
		case 3:
		{
			level.dog_health = 1300;
		} break;
		case 4:
		{
			level.dog_health = 1600;
		} break;
		default:
		{
			level.dog_health = 1600;
		} break;
	}
}

ambushRoundAftermath()
{
	power_up_origin = level.the_bus GetTagOrigin( "tag_body" );

	// spawn max ammo at the center of the bus
	if ( IsDefined( power_up_origin ) )
	{
		level thread maps\mp\zombies\_zm_powerups::specific_powerup_drop( "full_ammo", power_up_origin );
	}
}

ambushRoundEffects()
{
	wait(2);

	// stager the lighting effects
	level thread ambushLightningEffect( "tag_body" );
	wait(0.5);
	level thread ambushLightningEffect( "tag_wheel_back_left" );
	wait(0.5);
	level thread ambushLightningEffect( "tag_wheel_back_right" );
	wait(0.5);
	level thread ambushLightningEffect( "tag_wheel_front_left" );
	wait(0.5);
	level thread ambushLightningEffect( "tag_wheel_front_right" );
	wait(1.5);

	// bus fire effects
	fxEnt0 = SpawnAndLinkFXToTag( level._effect[ "ambush_bus_fire" ], level.the_bus, "tag_body" );
	fxEnt1 = SpawnAndLinkFXToTag( level._effect[ "ambush_bus_fire" ], level.the_bus, "tag_wheel_back_left" );
	fxEnt2 = SpawnAndLinkFXToTag( level._effect[ "ambush_bus_fire" ], level.the_bus, "tag_wheel_back_right" );
	fxEnt3 = SpawnAndLinkFXToTag( level._effect[ "ambush_bus_fire" ], level.the_bus, "tag_wheel_front_left" );
	fxEnt4 = SpawnAndLinkFXToTag( level._effect[ "ambush_bus_fire" ], level.the_bus, "tag_wheel_front_right" );

	level waittill( "end_ambushWaitFunction" );

	fxEnt0 delete();
	fxEnt1 delete();
	fxEnt2 delete();
	fxEnt3 delete();
	fxEnt4 delete();
}

ambushLightningEffect( tag )
{
	fxEntLighting = SpawnAndLinkFXToTag( level._effect[ "lightning_dog_spawn" ], level.the_bus, tag );
	//playsoundatposition( "zmb_hellhound_prespawn", fxEntLighting.origin );

	wait(5);

	//playsoundatposition( "zmb_hellhound_bolt", fxEntLighting.origin );
	fxEntLighting delete();

}

setupDogSpawnLocs()
{
	level.enemy_dog_locations = [];

	currentZone = undefined;

	// figure out what ambush_zone the bus is in
	ambush_zones = GetEntArray( "ambush_volume", "script_noteworthy" );
	for ( i = 0; i < ambush_zones.size; i++ )
	{
		touching = false;
		for ( b = 0; b < level.the_bus.bounds_origins.size && !touching; b++ )
		{
			bounds = level.the_bus.bounds_origins[b];
			touching = bounds IsTouching(ambush_zones[i]);
		}

		if ( touching )
		{
			currentZone = ambush_zones[i];
			break;
		}
	}

	Assert(IsDefined(currentZone), "Bus needs to be in an ambush zone for an ambush round: " + level.the_bus.origin);
	level.enemy_dog_locations = GetStructArray(currentZone.target, "targetname" );
}

ambushRoundKeeper()
{
	while ( true )
	{
		level waittill( "between_round_over" );

		level.numRoundsSinceLastAmbushRound++;
	}
}
