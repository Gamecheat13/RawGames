#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;

init()
{
	level.tabunInitialGasShockDuration  = weapons_get_dvar_int( "scr_tabunInitialGasShockDuration", "7");
	level.tabunWalkInGasShockDuration  = weapons_get_dvar_int( "scr_tabunWalkInGasShockDuration", "4");
	level.tabunGasShockRadius = weapons_get_dvar_int( "scr_tabun_shock_radius", "185" );
	level.tabunGasShockHeight = weapons_get_dvar_int( "scr_tabun_shock_height", "20" );
	level.tabunGasPoisonRadius = weapons_get_dvar_int( "scr_tabun_effect_radius", "185" );	
	level.tabunGasPoisonHeight = weapons_get_dvar_int( "scr_tabun_shock_height", "20" );	
	level.tabunGasDuration = weapons_get_dvar_int( "scr_tabunGasDuration", "8" ); // in seconds, after initial shock if you enter, you will get cough, blurred vision if you stay in this length
	level.poisonDuration = weapons_get_dvar_int( "scr_poisonDuration", "8" ); // in seconds you will get poison full screen effect for
	level.poisonDamage = weapons_get_dvar_int( "scr_poisonDamage", "13" ); // how much damage will the poison do each tick
	level.poisonDamageHardcore = weapons_get_dvar_int( "scr_poisonDamageHardcore", "5" ); // how much damage will the poison do each tick
 
	
	level.fx_tabun_0 = "tabun_tiny_mp";
	level.fx_tabun_1 = "tabun_small_mp";
	level.fx_tabun_2 = "tabun_medium_mp";
	level.fx_tabun_3 = "tabun_large_mp";
	level.fx_tabun_single = "tabun_center_mp";

	PreCacheItem( level.fx_tabun_0 );
	PreCacheItem( level.fx_tabun_1 );
	PreCacheItem( level.fx_tabun_2 );
	PreCacheItem( level.fx_tabun_3 );
	PreCacheItem( level.fx_tabun_single );
	
	level.fx_tabun_radius0 = weapons_get_dvar_int( "scr_fx_tabun_radius0", 55 );
	level.fx_tabun_radius1 = weapons_get_dvar_int( "scr_fx_tabun_radius1", 55 );
	level.fx_tabun_radius2 = weapons_get_dvar_int( "scr_fx_tabun_radius2", 50 );
	level.fx_tabun_radius3 = weapons_get_dvar_int( "scr_fx_tabun_radius3", 25 );
	
	level.sound_tabun_start = "wpn_gas_hiss_start";
	level.sound_tabun_loop = "wpn_gas_hiss_lp";
	level.sound_tabun_stop = "wpn_gas_hiss_end";
	
	level.sound_shock_tabun_start = "";
	level.sound_shock_tabun_loop = "";
	level.sound_shock_tabun_stop = "";
	
	
	/#
	level thread checkDvarUpdates();
	#/
}


checkDvarUpdates()
{
	while(true)
	{
		level.tabunGasPoisonRadius = weapons_get_dvar_int( "scr_tabun_effect_radius", level.tabunGasPoisonRadius );
		level.tabunGasPoisonHeight = weapons_get_dvar_int( "scr_tabun_shock_height", level.tabunGasPoisonHeight );	
		level.tabunGasShockRadius  = weapons_get_dvar_int( "scr_tabun_shock_radius", level.tabunGasShockRadius );
		level.tabunGasShockHeight = weapons_get_dvar_int( "scr_tabun_shock_height", level.tabunGasShockHeight );
		level.tabunInitialGasShockDuration  = weapons_get_dvar_int( "scr_tabunInitialGasShockDuration", level.tabunInitialGasShockDuration);
		level.tabunWalkInGasShockDuration  = weapons_get_dvar_int( "scr_tabunWalkInGasShockDuration", level.tabunWalkInGasShockDuration);
		level.tabunGasDuration  = weapons_get_dvar_int( "scr_tabunGasDuration", level.tabunGasDuration);
		level.poisonDuration = weapons_get_dvar_int( "scr_poisonDuration", level.poisonDuration );
		level.poisonDamage = weapons_get_dvar_int( "scr_poisonDamage", level.poisonDamage );
		level.poisonDamageHardcore = weapons_get_dvar_int( "scr_poisonDamageHardcore", level.poisonDamageHardcore );

		level.fx_tabun_radius0 = weapons_get_dvar_int( "scr_fx_tabun_radius0", level.fx_tabun_radius0 );
		level.fx_tabun_radius1 = weapons_get_dvar_int( "scr_fx_tabun_radius1", level.fx_tabun_radius1 );
		level.fx_tabun_radius2 = weapons_get_dvar_int( "scr_fx_tabun_radius2", level.fx_tabun_radius2 );
		level.fx_tabun_radius3 = weapons_get_dvar_int( "scr_fx_tabun_radius3", level.fx_tabun_radius3 );
		wait(1.0);
	}
}

watchTabunGrenadeDetonation( owner )
{	
	self waittill( "explode", position, surface );
	
	// AE 10-27-09: if it's in water then no need to continue
	if( !IsDefined(level.water_duds) || level.water_duds == true)
	{
		if( IsDefined(surface) && surface == "water" )
		{
			return;
		}
	}

	//level thread play_sound_in_space( "wpn_tabun_explode", position );

	if ( weapons_get_dvar_int ( "scr_enable_new_tabun", 1 ) )
		generateLocations( position, owner );
	else
		singleLocation( position, owner );
}	


damageEffectArea ( owner, position, radius, height, killCamEnt )
{
	// AE 10-27-09: rewritting this so it makes more sense and is more effecient
	//	this fixed a bug where if you stood on the tabun it would kill you instantly

	// spawn trigger radius for the effect areas
	shockEffectArea = spawn( "trigger_radius", position, 0, radius, height );
	gasEffectArea = spawn( "trigger_radius", position, 0, radius, height );

	/#
	if( GetDvarint( "scr_draw_triggers" ) )
		level thread drawcylinder( position, radius, height, undefined, "tabun_draw_cylinder_stop" );
	#/
	
	// dog stuff
	owner thread maps\mp\killstreaks\_dogs::flash_dogs( shockEffectArea );
	owner thread maps\mp\killstreaks\_dogs::flash_dogs( gasEffectArea );

	// loop variables
	loopWaitTime = 0.5;
	durationOfTabun = level.tabunGasDuration;

	// loop for the duration of the effect
	while (durationOfTabun > 0)
	{
		players = GET_PLAYERS();
		for (i = 0; i < players.size; i++)
		{
			// if this is not hardcore then don't affect teammates
			if ( level.friendlyfire == 0 )
			{
				if ( players[i] != owner )				
				{
					if (!isdefined (owner) || !isdefined(owner.team) )
						continue;
					if( level.teambased && players[i].team == owner.team )
						continue;
				}
			}

			// see if we're not in the poison area
			if ((!isDefined (players[i].inPoisonArea)) || (players[i].inPoisonArea == false) )
			{
				// since we're not in the pioson area, now see if we're in the poison area
				if (players[i] istouching(gasEffectArea) && players[i].sessionstate == "playing")
				{
					// check for the gas mask perk
					if ( ! ( players[i] hasPerk ("specialty_proximityprotection") ) )
					{
						trace = bullettrace( position, players[i].origin + (0,0,12), false, players[i] );

						if ( trace["fraction"] == 1 )
						{
							players[i].lastPoisonedBy = owner;
							players[i] thread damageInPoisonArea( shockEffectArea, killcament, trace, position  );
						}
					}
					// battle chatter for gas
					players[i]  thread maps\mp\gametypes\_battlechatter_mp::incomingSpecialGrenadeTracking( "gas" );
				}	
			}
		}

		wait (loopWaitTime);
		durationOfTabun -= loopWaitTime;
	}

	// if the durations are different, wait for the difference
	if ( level.tabunGasDuration < level.poisonDuration )
		wait ( level.poisonDuration - level.tabunGasDuration );

	// clean up
	shockEffectArea delete();
	gasEffectArea delete();	

	/#
	if( GetDvarint( "scr_draw_triggers" ) )
		level notify( "tabun_draw_cylinder_stop" );
	#/
}	
	
damageInPoisonArea( gasEffectArea, killcament, trace, position ) // self == player in poison area
{
	self endon( "disconnect" );
	self endon( "death" );

	self thread watch_death();
	self.inPoisonArea = true;

	self startPoisoning();

	tabunShockSound = spawn ("script_origin",(0,0,1));
	tabunShockSound thread deleteEntOnOwnerDeath( self );
	tabunShockSound.origin = position;
	tabunShockSound playsound( level.sound_shock_tabun_start );
	
	tabunShockSound playLoopSound ( level.sound_shock_tabun_loop );
	
	timer = 0;
	while ( (trace["fraction"] == 1 ) && (isdefined (gasEffectArea) ) &&	self istouching(gasEffectArea) && self.sessionstate == "playing"&& isdefined (self.lastPoisonedBy) )
	{
		// NOTE: DoDamage( <health>, <source position>, <attacker>, <inflictor>, <hitloc>, <mod>, <dflags>, <weapon> )
		damage = level.poisonDamage;
		if( level.hardcoreMode )
		{
			damage = level.poisonDamageHardcore;
		}
		self DoDamage( damage, gasEffectArea.origin, self.lastPoisonedBy, killCamEnt, "none", "MOD_GAS", 0, "tabun_gas_mp" );

		if ( self mayApplyScreenEffect() )
		{
			// try to do a stumble effect by having one shellshock slow and the other speed up slightly
			switch( timer )
			{
			case 0:
				self ShellShock( "tabun_gas_mp", 1.0 );
				break;
			case 1:
				self ShellShock( "tabun_gas_nokick_mp", 1.0 );
				break;
			default:
				break;
			}
			timer++;
			if( timer >= 2 )
			{
				timer = 0;
			}

			self hide_hud();
		}
		wait(1.0);
		trace = bullettrace( position, self.origin + (0,0,12), false, self );
	}
	tabunShockSound StopLoopSound( 0.5 );
    wait( 0.5 );
    thread playSoundinSpace( level.sound_shock_tabun_stop, position );	
	// have a little delay before we give back
	wait( 0.5 );
	tabunShockSound notify( "delete" );
	tabunShockSound delete();
	self show_hud();
	self stopPoisoning();
	
	self.inPoisonArea = false;
}

deleteEntOnOwnerDeath( owner )
{
	self endon( "delete" );
	owner waittill( "death" );
	self delete();	
}

watch_death() // self == player
{	
	// fail safe stuff for if the player dies
	self waittill("death");
	self show_hud();
}

hide_hud() // self == player
{
   self setClientUIVisibilityFlag( "hud_visible", 0 );
}
show_hud() // self == player
{
	self setClientUIVisibilityFlag( "hud_visible", 1 );
}

// returns dvar value in int
weapons_get_dvar_int( dvar, def )
{
	return int( weapons_get_dvar( dvar, def ) );
}

// dvar set/fetch/check
weapons_get_dvar( dvar, def )
{
	if ( getdvar( dvar ) != "" )
	{
		return getdvarfloat( dvar );
	}
	else
	{
		setdvar( dvar, def );
		return def;
	}
}

generateLocations( position, owner )
{
	oneFoot = ( 0, 0, 12 );
	startPos = position + oneFoot;

	
	/#
	level.tabun_debug = GetDvarIntDefault( "scr_tabun_debug", 0 );
	if ( level.tabun_debug )
	{
		black = ( 0.2, 0.2, 0.2 );	
		debugstar(startPos, 2 * 1000, black);
	}
	#/
	
	spawnAllLocs( owner, startPos );
}

singleLocation( position, owner )
{
	SpawnTimedFX( level.fx_tabun_single, position );
	killCamEnt = spawn( "script_model", position + (0,0,60) );
	killCamEnt deleteAfterTime( 15.0 );
	killCamEnt.startTime = gettime();
	
	damageEffectArea ( owner, position, level.tabunGasPoisonRadius, level.tabunGasPoisonHeight, killcament );
}



hitPos( start, end, color )
{
	trace = bullettrace( start, end, false, undefined );
	
	/#
	level.tabun_debug = GetDvarIntDefault( "scr_tabun_debug", 0 );
	if ( level.tabun_debug )
	{
		debugstar(trace["position"], 2 * 1000, color);
	}

	thread debug_line( start, trace["position"], color, 80 );
	#/
	
	return trace["position"];
}

spawnAllLocs( owner, startPos )
{
	defaultDistance = weapons_get_dvar_int( "scr_defaultDistanceTabun", 220 );
	cos45 = .707;
	negCos45 = -.707;
	
	red   = ( 0.9, 0.2, 0.2 );
	blue = ( 0.2, 0.2, 0.9 );
	green  = ( 0.2, 0.9, 0.2 );
	white = ( 0.9, 0.9, 0.9 );	
		
	north  	= startPos + ( defaultDistance, 0, 0 );
	south 	= startPos - ( defaultDistance, 0, 0 );
	east 	= startPos + ( 0, defaultDistance, 0 );
	west 	= startPos - ( 0, defaultDistance, 0 );
	nw 		= startPos + ( cos45 * defaultDistance, 	negCos45 * defaultDistance, 0 ); 
	ne 		= startPos + ( cos45 * defaultDistance, 	cos45 * defaultDistance, 0 ); 
	sw		= startPos + ( negCos45 * defaultDistance, 	negCos45 * defaultDistance, 0 ); 
	se		= startPos + ( negCos45 * defaultDistance, 	cos45 * defaultDistance, 0 ); 

	locations = [];
	locations["color"] = [];
	locations["loc"] = [];
	locations["tracePos"] = [];
	locations["distSqrd"] = [];
	locations["fxtoplay"] = [];
	locations["radius"] = [];
	
	
	locations["color"][0] = red;
	locations["color"][1] = red;
	locations["color"][2] = blue;
	locations["color"][3] = blue;
	locations["color"][4] = green;
	locations["color"][5] = green;
	locations["color"][6] = white;
	locations["color"][7] = white;
	
	locations["point"][0] = north;
	locations["point"][1] = ne;
	locations["point"][2] = east;
	locations["point"][3] = se;
	locations["point"][4] = south;
	locations["point"][5] = sw;
	locations["point"][6] = west;
	locations["point"][7] = nw;
		
	for ( count = 0; count < 8; count++ )
	{
		trace = hitPos( startPos, locations["point"][count], locations["color"][count] );
		locations["tracePos"][count] = trace;
		locations["loc"][count] = startPos/2 + trace/2;
		locations["loc"][count] = locations["loc"][count] - ( 0, 0, 12 );
		locations["distSqrd"][count] = distancesquared( startPos, trace );
	}	

	centroid = getCentroid( locations );
	killCamEnt = spawn( "script_model", centroid + (0,0,60) );
	killCamEnt deleteAfterTime( 15.0 );
	killCamEnt.startTime = gettime();
	
	center = getcenter( locations );
			
	for ( i = 0; i < 8; i++ )
	{
		fxToPlay = setUpTabunFx( owner, locations, i);	
		switch ( fxToPlay )
		{
			case 0:
			{
				locations["fxtoplay"][i] = level.fx_tabun_0;
				locations["radius"][i] =  level.fx_tabun_radius0;
			}
			break;
			case 1:
			{
				locations["fxtoplay"][i] = level.fx_tabun_1;
				locations["radius"][i] = level.fx_tabun_radius1;
			}
			break;
			case 2:
			{
				locations["fxtoplay"][i] = level.fx_tabun_2;
				locations["radius"][i] = level.fx_tabun_radius2;
			}
			break;
			case 3:
			{
				locations["fxtoplay"][i] = level.fx_tabun_3;
				locations["radius"][i] = level.fx_tabun_radius3;
			}
			break;
			default:
			{
				locations["fxtoplay"][i] = undefined;
				locations["radius"][i] = 0;
			}
		}
	}

	singleEffect = true;
	freepassUsed = false;
	// check can we just play one large effect
	for ( i = 0; i < 8; i++ )
	{
		if ( locations["radius"][i] != level.fx_tabun_radius0 )
		{
			if (freePassUsed == false && locations["radius"][i] == level.fx_tabun_radius1 )
			{
				freePassUsed = true;
			}
			else
			{
				singleEffect = false;
			}
		}
	}
	oneFoot = ( 0, 0, 12 );
	startPos = startPos - oneFoot;
	
	thread playTabunSound( startPos );
	if ( singleEffect == true ) 
	{
		singleLocation( startPos, owner );
	}
	else
	{			
		SpawnTimedFX( level.fx_tabun_3, startPos );
		for ( count = 0; count < 8; count++ )
		{
			if ( isdefined ( locations["fxtoplay"][count] ) )
			{
				SpawnTimedFX( locations["fxtoplay"][count], locations["loc"][count] );
				thread damageEffectArea ( owner, locations["loc"][count], locations["radius"][count], locations["radius"][count], killCamEnt );
			}
		}
	}
}

playTabunSound( position )
{	
	tabunSound = spawn ("script_origin",(0,0,1));
	tabunSound.origin = position;
	
	tabunSound playsound( level.sound_tabun_start );
	tabunSound playLoopSound ( level.sound_tabun_loop );
	wait( level.tabunGasDuration );
    thread playSoundinSpace( level.sound_tabun_stop, position );	
	tabunSound StopLoopSound( .5);
    wait(.5);
	tabunSound delete();
}

setUpTabunFx( owner, locations, count )
{
	fxToPlay = undefined;
	
	previous = count - 1;
	if ( previous < 0 )
		previous = previous + locations["loc"].size;
	next = count + 1;
	if ( next >= locations["loc"].size )
		next = next - locations["loc"].size;
	

	effect0Dist = level.fx_tabun_radius0 * level.fx_tabun_radius0;
	effect1Dist = level.fx_tabun_radius1 * level.fx_tabun_radius1;
	effect2Dist = level.fx_tabun_radius2 * level.fx_tabun_radius2;
	effect3Dist = level.fx_tabun_radius3 * level.fx_tabun_radius3;
	effect4Dist = level.fx_tabun_radius3;

	fxToPlay = -1;
	if ( locations["distSqrd"][count] > effect0Dist && locations["distSqrd"][previous] > effect1Dist && locations["distSqrd"][next] > effect1Dist ) 
	{
		fxToPlay = 0;
	}
	else if ( locations["distSqrd"][count] > effect1Dist && locations["distSqrd"][previous] > effect2Dist && locations["distSqrd"][next] > effect2Dist ) 
	{
		fxToPlay = 1;
	}
	else if ( locations["distSqrd"][count] > effect2Dist && locations["distSqrd"][previous] > effect3Dist && locations["distSqrd"][next] > effect3Dist ) 
	{
		fxToPlay = 2;
	}
	else if ( locations["distSqrd"][count] > effect3Dist && locations["distSqrd"][previous] > effect4Dist && locations["distSqrd"][next] > effect4Dist ) 
	{
		fxToPlay = 3;
	}
	
	return fxToPlay;
}
	
getCentroid( locations )
{
	centroid = ( 0, 0, 0 );

	for ( i = 0; i < locations["loc"].size; i++ ) 
	{
		centroid = centroid + ( locations["loc"][i] / locations["loc"].size );
	}
	
		
	/#
	level.tabun_debug = GetDvarIntDefault( "scr_tabun_debug", 0 );
	if ( level.tabun_debug )
	{
		purple = ( 0.9, 0.2, 0.9 );
		debugstar(centroid, 2 * 1000, purple);
	}
	#/

	return centroid;
}

getcenter( locations )
{
	center = ( 0, 0, 0 );
	curX = locations["tracePos"][0][0];
	curY = locations["tracePos"][0][1];
	minX = curX;
	maxX = curX;
	minY = curY;
	maxY = curY;
	for ( i = 1; i < locations["tracePos"].size; i++ ) 
	{
		curX = locations["tracePos"][i][0];
		curY = locations["tracePos"][i][1];
		
		if ( curX > maxX ) 
			maxX = curX;
		else if ( curX < minX )
			minX = curX;
			
		if ( curY > maxY ) 
			maxY = curY;
		else if ( curY < minY )
			minY = curY;
	}
	
	avgX = ( maxX + minX ) / 2;
	avgY = ( maxY + minY ) / 2;

	
	center = ( avgX, avgY, locations["tracePos"][0][2] );
	
	/#
	level.tabun_debug = GetDvarIntDefault( "scr_tabun_debug", 0 );
	if ( level.tabun_debug )
	{
		cyan = ( 0.2, 0.9, 0.9 );
		debugstar(center, 2 * 1000, cyan);
	}
	#/
		
	//fxToPlay = level.fx_tabun_1;
	//SpawnTimedFX( fxToPlay, center );
	
	return center;	
}
	
