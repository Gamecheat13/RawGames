
main()
{
	maps\mp\mp_radar_precache::main();
	maps\createart\mp_radar_art::main();
	maps\mp\mp_radar_fx::main();
	maps\mp\_explosive_barrels::main();
	
	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_radar" );
	
    maps\mp\_compass::setupMiniMap( "compass_map_mp_radar" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
	
	//	start launching migs
	//level thread migLauncher();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "mountains", 0.2, 0.9, 2 );
}

migLauncher()
{
	//	stop when the match ends
	level endon ( "game_ended" );
	
	//	get the nodes
	startNode = common_scripts\utility::getStruct( "mig_start", "targetname" );
	launchNode = common_scripts\utility::getStruct( "mig_launch", "targetname" );
	air1Node = common_scripts\utility::getStruct( "mig_air1", "targetname" );
	endNode = common_scripts\utility::getStruct( "mig_end", "targetname" );
	
	//	 get the distances (used for speed: distance/time)
	startToLaunchDist = distance( startNode.origin, launchNode.origin );
	launchToAir1Dist = distance( launchNode.origin, air1Node.origin );
	air1ToEndDist = distance( air1Node.origin, endNode.origin );
	
	//	get the orientations
	startToLaunchAng = vectorToAngles( vectorNormalize( launchNode.origin - startNode.origin ) );
	launchToAir1Ang = vectorToAngles( vectorNormalize( air1Node.origin - launchNode.origin ) );
	air1ToEndAng = vectorToAngles( vectorNormalize( endNode.origin - air1Node.origin ) );		
		
	//	make the mig
	mig = spawn( "script_model", startNode.origin );
	mig setModel( "vehicle_mig29_low_mp" );	
		
	//	loop and launch periodically
	while ( true )
	{
		//	wait a random time
		wait( randomIntRange( 10, 25 ) );		
		
		//	go directly to start position, show
		mig.origin = startNode.origin;
		mig.angles = startToLaunchAng;
		mig show();
		
		//	start engine fx, start taxi sound, move to launch position
		playFxOnTag( level.fx_airstrike_afterburner, mig, "tag_origin" );
		mig playloopsound( "veh_mig29_dist_loop" );
		mig moveTo( launchNode.origin, startToLaunchDist/3000, 1, 0 );
		wait( startToLaunchDist/3000 );
		
		//	start contrail fx, orient, move to air1 position		
		playFxOnTag( level.fx_airstrike_contrail, mig, "tag_origin" );		
		mig rotateTo( launchToAir1Ang, 0.5 );
		mig moveTo( air1Node.origin, launchToAir1Dist/6000, 0, 0 );
		wait( launchToAir1Dist/6000 );	
		
		//	start boom sound, orient, move to end position
		mig rotateTo( air1ToEndAng, 0.5 );
		mig moveTo( endNode.origin, air1ToEndDist/9000, 0, 0 );
		wait( air1ToEndDist/9000 );	
		
		//	stop fx, hide
		stopFxOnTag( level.fx_airstrike_afterburner, mig, "tag_origin" );
		stopFxOnTag( level.fx_airstrike_contrail, mig, "tag_origin" );
		mig hide();
		
		//	let the sound trail for a bit, then stop sound
		wait( 2 );
		mig stopSounds();		
	}
}