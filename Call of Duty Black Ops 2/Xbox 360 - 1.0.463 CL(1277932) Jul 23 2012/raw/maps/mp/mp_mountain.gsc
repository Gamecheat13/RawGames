#include maps\mp\_utility;
#include common_scripts\utility;

main()
{
	/#
		level thread devgui_mountain();
		execdevgui( "devgui_mp_mountain" );
	#/
	
	//needs to be first for create fx
	maps\mp\mp_mountain_fx::main();

	maps\mp\_load::main();

	maps\mp\mp_mountain_amb::main();

	if ( GameModeIsMode( level.GAMEMODE_WAGER_MATCH ) )
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_mountain_wager");
	}
	else
	{
		maps\mp\_compass::setupMiniMap("compass_map_mp_mountain");
	}
	
	//setExpFog(2048, 6000, 1, 0.5, 0.5, 0);


	// Set up the default range of the compass
	//SetDvar("compassmaxrange","2100");

	// Set up some generic War Flag Names.
	// Example from COD5: CALLSIGN_SEELOW_A is the name of the 1st flag in Selow whose string is "Cottage" 
	// The string must have MPUI_CALLSIGN_ and _A. Replace Mapname with the name of your map/bsp and in the 
	// actual string enter a keyword that names the location (Roundhouse, Missle Silo, Launchpad, Guard Tower, etc)

	game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_MAPNAME_A";
	game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_MAPNAME_B";
	game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_MAPNAME_C";
	game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_MAPNAME_D";
	game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_MAPNAME_E";

	game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_MAPNAME_A";
	game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_MAPNAME_B";
	game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_MAPNAME_C";
	game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_MAPNAME_D";
	game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_MAPNAME_E";

	// enable new spawning system
	maps\mp\gametypes\_spawning::level_use_unified_spawning(true);
	
	SetDvar( "scr_spawn_enemy_influencer_radius", 1620 );

	level thread gondola_sway();
	level thread glass_exploder_init();

	glasses = GetStructArray( "glass_shatter_on_spawn", "targetname" );

	for ( i = 0; i < glasses.size; i++ )
	{
		RadiusDamage( glasses[i].origin, 64, 101, 100 ); 
	}
}

devgui_mountain( cmd )
{
	for ( ;; )
	{
		wait( 0.5 );

		devgui_string = GetDvar( "devgui_notify" );

		switch( devgui_string )
		{
			case "":
			break;

			default:
				level notify( devgui_string );
			break;
		}

		SetDvar( "devgui_notify", "" );
	}
}

//Picks randomly from 2 sway strengths
gondola_sway()
{
	level endon ("gondola_triggered");
		
	gondola_cab = GetEnt( "gondola_cab", "targetname" );  
		
	while( 1 )
	{
		randomSwingAngle = RandomFloatRange( 2, 5 );
		randomSwingTime = RandomFloatRange( 2, 3 );
		
		gondola_cab RotateTo( (randomSwingAngle*0.5,(randomSwingAngle*0.6)+90,randomSwingAngle*.8), randomSwingTime, randomSwingTime*0.3, randomSwingTime*0.3 );
		gondola_cab playsound ("amb_gondola_swing");
		wait( randomSwingTime );
		gondola_cab RotateTo( ((randomSwingAngle*0.5)*-1,(randomSwingAngle*-1*0.6)+90,randomSwingAngle*.8*-1), randomSwingTime, randomSwingTime*0.3, randomSwingTime*0.3 );
		gondola_cab playsound ("amb_gondola_swing_back");
		wait( randomSwingTime );
	}
}
		
glass_exploder_init()
{
	single_exploders = [];
	
	for ( i = 0; i < level.createFXent.size; i++ )
	{
		ent = level.createFXent[ i ];

		if ( !IsDefined( ent ) )
			continue;
	
		if ( ent.v[ "type" ] != "exploder" )
			continue;	

		if ( ent.v[ "exploder" ] == 201 || ent.v[ "exploder" ] == 202 )
		{
			ent thread glass_group_exploder_think();
		}
		else if ( ent.v[ "exploder" ] >= 101 && ent.v[ "exploder" ] <= 106 )
		{
			single_exploders[ single_exploders.size ] = ent;
		}
		else if ( ent.v[ "exploder" ] == 301 || ent.v[ "exploder" ] == 302 )
		{
			single_exploders[ single_exploders.size ] = ent;
		}
	}

	level thread glass_exploder_think( single_exploders );
}

glass_group_exploder_think()
{
	thresholdSq = 160 * 160;
	count = 0;
	
	for ( ;; )
	{
		level waittill( "glass_smash", origin );

		if ( DistanceSquared( self.v[ "origin" ], origin ) < thresholdSq )
		{
			count++;
		}

		if ( count >= 3 )
		{
			exploder( self.v[ "exploder" ] );
			return;
		}
	}
}

glass_exploder_think( exploders )
{
	thresholdSq = 160 * 160;

	if ( exploders.size <= 0 )
	{
		return;
	}
	
	for ( ;; )
	{
		closest = 999 * 999;
		closest_exploder = undefined;
		
		level waittill( "glass_smash", origin );

		for ( i = 0; i < exploders.size; i++ )
		{
			if ( !IsDefined( exploders[i] ) )
			{
				continue;
			}

			if ( IsDefined( exploders[i].glass_broken ) )
			{
				continue;
			}

			distSq = DistanceSquared( exploders[i].v[ "origin" ], origin );

			if ( distSq > thresholdSq )
			{
				continue;
			}

			if ( distSq < closest )
			{
				closest_exploder = exploders[i];
				closest = distSq;
			}
		}

		if ( IsDefined( closest_exploder ) )
		{
			closest_exploder.glass_broken = true;
			exploder( closest_exploder.v[ "exploder" ] );
		}
	}
}