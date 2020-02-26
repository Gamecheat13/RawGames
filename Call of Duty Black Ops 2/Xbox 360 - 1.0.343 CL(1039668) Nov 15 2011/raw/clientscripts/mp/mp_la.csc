// Test clientside script for mp_la

#include clientscripts\mp\_utility;

main()
{
	// team nationality
	clientscripts\mp\_teamset_seals::level_init();

	// _load!
	clientscripts\mp\_load::main();

	clientscripts\mp\mp_la_fx::main();

	//thread clientscripts\mp\_fx::fx_init(0);
	thread clientscripts\mp\_audio::audio_init(0);

	thread clientscripts\mp\mp_la_amb::main();

	// This needs to be called after all systems have been registered.
	waitforclient(0);

	println("*** Client : mp_la running...");
	level thread doFogFunc( 0 );	
}

doFogFunc( localClientNum )
{
	fog_start_ent = GetEntArray(localClientNum, "fog_clientscript_start", "targetname");
	fog_end_ent = GetEntArray(localClientNum, "fog_clientscript_end", "targetname");
	
	fogOriginStart = fog_start_ent[0].origin; // (200.0,-1000.0,-464.0); //
	fogOriginEnd = fog_end_ent[0].origin; // (-1050.0,720.0,-464.0); //
	Xlength = ( fogOriginStart[1] - fogOriginEnd[1] );
	YLength = ( fogOriginStart[0] - fogOriginEnd[0] );
	
	//debugstar(  fogOriginStart, 100000, (1,0,0) );
	//debugstar(  fogOriginEnd, 100000, (0,1,0) );
	
	wasEnabled = 0;
	serverFog = GetServerVolumetricFogDensity( localClientNum );
	previousFog = serverFog;
	
	// the ratios are different for X and Y as they are 2 different layouts of entrances
	dotAddition = GetDvarFloatDefault( "scr_fog_dot_add", 1.2 );
	dotDivision = GetDvarFloatDefault( "scr_fog_dot_div", 2 );
	fogInnerRatioX = GetDvarFloatDefault( "scr_fog_inner_ratio_x", 0.3 );
	fogViewRatioX = GetDvarFloatDefault( "scr_fog_view_ratio_x", 0.6 );
	fogInnerRatioY = GetDvarFloatDefault( "scr_fog_inner_ratio_y", 0.2 );
	fogViewRatioY = GetDvarFloatDefault( "scr_fog_view_ratio_y", 0.5 );
	showFogDebug = GetDvarIntDefault( "scr_fog_debug", 0 );
	shortWaitTime = GetDvarFloatDefault( "scr_fog_wait", 0.02 );
	extendedWaitTime = GetDvarFloatDefault( "scr_fog_extened_wait", 0.04 );
	
		
	while( true )
	{
		localplayers = level.localPlayers;
		currentWait = extendedWaitTime;
		for (localClientNum = 0; localClientNum < localplayers.size; localClientNum++)
		{
			currentFog = serverFog;
	
			localPlayer = localplayers[localClientNum];
		
			localClientOrigin = getlocalclientpos( localClientNum );
	
			distance = Distance( localClientOrigin, fogOriginStart );
			heightOffset =  ( localClientOrigin[2] - fogOriginStart[2] );
			
			if ( localClientOrigin[1] > fogOriginStart[1] && localClientOrigin[1] < fogOriginEnd[1] )
			{
				inXWise = true;
			}
			else 
			{
				inXWise = false;
			}
			
			if ( localClientOrigin[0] < fogOriginStart[0] && localClientOrigin[0] > fogOriginEnd[0] )
			{
				inYWise = true;
			}
			else
			{
				inYWise = false;
			}
			
	
			if ( inxwise && inywise )
			{	
				dot = 0;
				distXRatio = 0;
				distyRatio = 0;
						
				// X
				
				playerLength = ( fogOriginStart[1] - localClientOrigin[1] );
				distXRatio = ( playerLength / Xlength );
			
				// Y
				
				playerLength = ( fogOriginStart[0] - localClientOrigin[0] );
				distYRatio = ( playerLength / YLength );
	
							
				forward	= anglestoforward( localPlayer.angles );
				forward = VectorNormalize( forward );
	
				dirToEnemy = fogOriginStart - localClientOrigin;
				dirToEnemy = VectorNormalize( dirToEnemy );
	
				dot = vectordot( dirToEnemy, forward );
				dot += dotAddition;
				dot /= dotDivision;
				
				if ( distXRatio > distYRatio )
				{
					subVar = ( fogInnerRatioX + ( fogViewRatioX * dot ) );
					distRatio = distXRatio;
				}
				else 
				{
					subVar = ( fogInnerRatioY + ( fogViewRatioY * dot ) );
					distRatio = distYRatio;
				}
				
				if ( subVar > 1 )
					subVar = 1;
				
				multVar = 1 - subVar;
				multVar = 1 / multVar;
				
				distRatio -= subVar;
				distRatio *= multVar;
				
				if ( distRatio < 0 )
					distRatio = 0;

				currentFog *= distRatio;
				currentWait = shortWaitTime;				
/#
				if ( showFogDebug ) 
				{
					iprintlnbold( localClientNum + " dist: " + distRatio );
				}
#/
			}
			
			setservervolumetricfogdensity( localClientNum, currentFog, 0 );

		}

		wait(currentWait);
	}
}
	
