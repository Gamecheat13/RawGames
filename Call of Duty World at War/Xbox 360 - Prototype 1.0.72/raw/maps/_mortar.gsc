#include maps\_utility; 
main()
{
}

// SCRIPTER_MOD
// MikeD( 3/16/200 ): TODO, This needs testing
hurtgen_style()
{
	// One mortar within x distance goes off every x seconds but not within x units of the player

	mortars = GetEntArray( "mortar", "targetname" ); 
	lastmortar = -1; 

	for( i = 0; i < mortars.size; i++ )
	{
		mortars[i] setup_mortar_terrain(); 
	}
	if( !( IsDefined( level.mortar ) ) )
	{
		error( "level.mortar not defined. define in level script" ); 
	}

	level waittill( "start_mortars" ); 

	while( 1 )
	{
		wait( 1 +( RandomFloat( 2 ) ) ); 
		
		r = RandomInt( mortars.size ); 
		//println( "mortar size: ", mortars.size ); 
		//println( "r: ", r ); 
		for( i = 0; i < mortars.size; i++ )
		{
			c = ( i + r ) % mortars.size; 
			//println( "current number: ", c ); 

// SCRIPTER_MOD
// MikeD( 3/16/200 ): No more level.player
//			d = Distance( level.player GetOrigin(), mortars[c].origin ); 
			players = get_players(); 

			do_mortar = false; 
			dist = undefined; 
			for( q = 0; q < players.size; q++ )
			{
				dist = DistanceSquared( players[q].origin, mortars[c].origin ); 
				if( dist < 1600 * 1600 && dist > 400 * 400 )
				{
					do_mortar = true; 
				}
				else
				{
					do_mortar = false; 
				}
			}

			if( !do_mortar )
			{
				continue; 
			}

			d2 = undefined; 

			if( IsDefined( level.foley ) )
			{
				d2 = Distancesquared( level.foley.origin, mortars[c].origin ); 
			}
			else
			{
				d2 = 360 * 360; 
			}

			if( ( d2 > 350 * 350 ) &&( c != lastmortar ) )
			{
				mortars[c] activate_mortar( 400, 300, 25, undefined, undefined, undefined, false ); 
				lastmortar = c; 

// SCRIPTER_MOD
// MikeD (3/22/2007): Not needed since activate_mortar already calls it.
//				if( dist < 500 * 500 )
//				{
//					maps\_shellshock::main( 4 ); 
//				}
				break; 
			}
		}
	}
}

// SCRIPTER_MOD
// MikeD( 3/16/200 ): TODO, This needs testing
railyard_style( fRandomtime, iMaxRange, iMinRange, iBlastRadius, iDamageMax, iDamageMin, fQuakepower, iQuaketime, iQuakeradius, targetsUsed, seedtime )
{
	// One mortar within iMaxRange distance goes off every( random + random ) seconds but not within iMinRange units of the player
	// Terminate on demand by setting level.iStopBarrage != 0, operates indefinitely by default
	// Pass optional custom radius damage settings to activate_mortar()
	// Also pass optional custom earthquake settings to mortar_boom() via activate_mortar() if you want more shaking

	if( !IsDefined( fRandomtime ) )
	{
		fRandomtime = 7; 
	}

	if( !IsDefined( iMaxRange ) )
	{
		iMaxRange = 2200; 
	}

	if( !IsDefined( iMinRange ) )
	{
		iMinRange = 300; 
	}

	if( !IsDefined( level.iStopBarrage ) )
	{
		level.iStopBarrage = 0; 
	}

	if( !IsDefined( targetsUsed ) )	//this allows railyard_style to get called again and not setup any terrain related stuff
	{
		targetsUsed = 0; 
	}

	mortars = GetEntArray( "mortar", "targetname" ); 
	lastmortar = -1; 

	for( i = 0; i < mortars.size; i++ )
	{
		if( IsDefined( mortars[i].target ) &&( targetsUsed == 0 ) )	//no target necessary, mortar will just play effect and sound
		{
			mortars[i] setup_mortar_terrain(); 
		}
	}

	if( !IsDefined( level.mortar ) )
	{
		error( "level.mortar not defined. define in level script" ); 
	}

	if( IsDefined( level.mortar_notify ) )
	{
		level waittill( level.mortar_notify ); 
	}

// SCRIPTER_MOD
// MikeD( 3/16/200 ): Converted to uSing Distancesquared(), more optimized.
	iMaxRange = iMaxRange * iMaxRange; 
	iMinRange = iMinRange * iMinRange; 

	for( ;; )
	{
		if( level.iStopBarrage != 0 )
		{
			wait( 1 ); 
		}

		while( level.iStopBarrage == 0 )
		{
			if( IsDefined( seedtime ) )
			{
				wait( seedtime +( RandomFloat( fRandomtime ) + RandomFloat( fRandomtime ) ) ); 
			}
			else
			{
				wait( RandomFloat( fRandomtime ) + RandomFloat( fRandomtime ) ); 
			}
	
			r = RandomInt( mortars.size ); 
			//println( "mortar size: ", mortars.size ); 
			//println( "r: ", r ); 
			for( i = 0; i < mortars.size; i++ )
			{
				c = ( i + r ) % mortars.size; 

			if( c == lastmortar )
			{
					continue; 
			}

				//println( "current number: ", c ); 
// SCRIPTER_MOD
// MikeD( 3/16/200 ):  No more level.player
//				d = Distance( level.player GetOrigin(), mortars[c].origin ); 
				do_mortar = false; 

				players = get_players(); 
				for( q = 0; q < players.size; q++ )
				{
					dist = Distancesquared( players[q] GetOrigin(), mortars[c].origin ); 

					if( dist < iMaxRange && dist > iMinRange )
					{
						do_mortar = true; 
					}
					else
					{
						do_mortar = false; 
					}
				}

				if( do_mortar )
				{
					mortars[c] activate_mortar( iBlastRadius, iDamageMax, iDamageMin, fQuakepower, iQuaketime, iQuakeradius , false ); 
					lastmortar = c; 
					break; 
				}
			}
		}
	}
}

is_lastblast( mortar, lastblast )
{
	for( i = 0; i < lastblast.size; i++ )
	{
		if( mortar == lastblast[i] )
		{
			return true; 
		}
	}

	return false; 
}

// SCRIPTER_MOD
// MikeD( 3/16/200 ): Removed Since it's only for BOG. However, I want to keep it here as it has a couple good examples.
// We should remove later.
//bog_style_mortar()
//{
//	//	script_structs are placed in the level and grouped with script_mortargroup with targetname "mortar"
//	//	mortar group is turned on/off in script
//	//	mortar locations will start going off randomly and wont go off within x units of the player
//	//	each mortar location has script_fxid so it can play a set fx( this allows having mortars on land and water in the same group )
//	//	mortars will go forever until that group of mortars is notified to stop
//	//	each mortar has a cooldown time of x seconds before it can be used again
//	
//	groups = []; 
//	groupNum = []; 
//	structs = getstructarray( "mortar", "targetname" ); 
//	assert( IsDefined( structs ) ); 
//	assert( structs.size > 0 ); 
//	for( i = 0 ; i < structs.size ; i++ )
//	{
//		if( !IsDefined( structs[i].script_mortargroup ) )
//			continue; 
//		
//		index = -1; 
//		groupNumber = Int( structs[i].script_mortargroup ); 
//		for( p = 0 ; p < groups.size ; p++ )
//		{
//			if( groupNumber != groupNum[p] )
//				continue; 
//			
//			index = p; 
//			break; 
//		}
//		
//		if( index == -1 )
//		{
//			// new group
//			groups[groups.size] = []; 
//			groupNum[groupNum.size] = groupNumber; 
//			index = groups.size - 1; 
//		}
//		
//		groups[index][groups[index].size] = structs[i]; 
//	}
//	
//	for( i = 0 ; i < groups.size ; i++ )
//		thread bog_style_mortar_think( groups[i] ); 
//	
//	wait( 0.05 ); 
//	
//	array_thread( GetEntArray( "mortar_on", "targetname" ), ::bog_style_mortar_trigger, "on" ); 
//	array_thread( GetEntArray( "mortar_off", "targetname" ), ::bog_style_mortar_trigger, "off" ); 
//}
//
//bog_style_mortar_think( mortars, groupNum )
//{
//	min = 0.5; 
//	max = 3; 
//	groupNum = Int( mortars[0].script_mortargroup ); 
//	for( ;; )
//	{
//		level waittill( "start_mortars " + groupNum ); 
//		level thread bog_style_mortar_activate( mortars, groupNum, min, max ); 
//	}
//}
//
//bog_style_mortar_activate( mortars, groupNum, min, max )
//{
//	level endon( "start_mortars " + groupNum ); 
//	level endon( "stop_mortars " + groupNum ); 
//	
//	for( ;; )
//	{
//		for( ;; )
//		{
//			wait( 0.05 ); 
//			rand = RandomInt( mortars.size ); 
//			if( IsDefined( mortars[rand].cooldown ) )
//				continue; 
//			d = Distance( level.player.origin, mortars[rand].origin ); 
//			if( d < 300 )
//				continue; 
//			if( d > 1000 )
//				continue; 
//			break; 
//		}
//		if( ( IsDefined( level.noMortars ) ) &&( level.noMortars == true ) )
//			return; 
//		mortars[rand] thread bog_style_mortar_explode(); 
//		
//		wait( min + RandomFloat( max - min ) ); 
//	}
//}
//
//bog_style_mortar_checkPlayerFOV()
//{
//	forwardvec = AnglesToForward( level.player.angles ); 
//	normalvec = VectorNormalize( self.origin -( level.player GetOrigin() ) ); 
//	vecdot = VectorDot( forwardvec, normalvec ); 
//	if( !IsDefined( level.Cos80 ) )
//		level.Cos80 = Cos( 80 ); 
//	if( vecdot > level.Cos80 )
//		return true; 
//	return false; 
//}
//
//bog_style_mortar_explode( insTant, customExploSound )
//{
//	if( !IsDefined( insTant ) )
//		insTant = false; 
//	
//	self thread bog_style_mortar_cooldown(); 
//	if( !insTant )
//		self play_sound_in_space( level.scr_sound["mortar"]["incomming"] ); 
//	if( IsDefined( customExploSound ) )
//		self thread play_sound_in_space( customExploSound ); 
//	else
//		self thread play_sound_in_space( level.scr_sound["mortar"][self.script_fxid] ); 
//	
//	//dont play an effect if it's behind the player - trying to save on particle effects
//	RadiusDamage( self.origin, 150, 50, 50 ); 
//	if( self bog_style_mortar_checkPlayerFOV() )
//		PlayFx( level._effect["mortar"][self.script_fxid], self.origin ); 
//	
//	if( GetDvarInt( "bog_camerashake" ) > 0 )
//	{
//		//if player is trying to snipe dont do view shake
//		if( ( level.player GetCurrentWeapon() == "dragunov" ) &&( level.player PlayerAds() > 0.8 ) )
//			return; 
//		Earthquake( 0.25, 2, self.origin, 1250 ); 
//	}
//}
//
//bog_style_mortar_cooldown()
//{
//	self.cooldown = true; 
//	wait( 3 + RandomFloat( 2 ) ); 
//	self.cooldown = undefined; 
//}
//
//bog_style_mortar_trigger( value )
//{
//	assert( IsDefined( self.script_mortargroup ) ); 
//	
//	self waittill( "trigger" ); 
//	
//	if( value == "on" )
//		bog_style_mortar_on( self.script_mortargroup ); 
//	else if( value == "off" )
//		bog_style_mortar_off( self.script_mortargroup ); 
//}
//
//bog_style_mortar_on( groupNum )
//{
//	level notify( "start_mortars " + groupNum ); 
//}
//
//bog_style_mortar_off( groupNum )
//{
//	level notify( "stop_mortars " + groupNum ); 
//}

setup_mortar_terrain()
{
	self.has_terrain = false; 
	if( IsDefined( self.target ) )
	{
		self.terrain = GetEntArray( self.target, "targetname" ); 
		self.has_terrain = true; 
	}
	else
	{
		println( "z:          mortar entity has no target: ", self.origin ); 
	}

	if( !IsDefined( self.terrain ) )
	{
		println( "z:          mortar entity has target, but target doesnt exist: ", self.origin ); 
	}

	if( IsDefined( self.script_hidden ) )
	{
		if( IsDefined( self.script_hidden ) )
		{
			self.hidden_terrain = GetEnt( self.script_hidden, "targetname" ); 
		}
		else if( ( IsDefined( self.terrain ) ) &&( IsDefined( self.terrain[0].target ) ) )
		{
			self.hidden_terrain = GetEnt( self.terrain[0].target, "targetname" ); 
		}
		
		if( IsDefined( self.hidden_terrain ) )
		{
			self.hidden_terrain Hide(); 
		}
	}
	else if( IsDefined( self.has_terrain ) )
	{
		if( IsDefined( self.terrain ) && IsDefined( self.terrain[0].target ) )
		{
			self.hidden_terrain = GetEnt( self.terrain[0].target, "targetname" ); 
		}
		
		if( IsDefined( self.hidden_terrain ) )
		{
			self.hidden_terrain Hide(); 
		}
	}		

}

activate_mortar( range, max_damage, min_damage, fQuakepower, iQuaketime, iQuakeradius , bIsstruct )
{
//	if( bIsstruct )
//	{
//		if( Distance( self.origin, level.player.origin ) < 1000 )
//			incoming_sound( undefined, bIsstruct ); 
//	}
//	else
	incoming_sound( undefined, bIsstruct ); 

	level notify( "mortar" ); 
	self notify( "mortar" ); 
	

	if( !IsDefined( range ) )
	{
		range = 256; 
	}

	if( !IsDefined( max_damage ) )
	{
		max_damage = 400; 
	}

	if( !IsDefined( min_damage ) )
	{
		min_damage = 25; 
	}

	RadiusDamage( self.origin, range, max_damage, min_damage ); 

	if( ( IsDefined( self.has_terrain ) && self.has_terrain == true ) &&( IsDefined( self.terrain ) ) )
	{
		for( i = 0; i < self.terrain.size; i++ )
		{
			if( IsDefined( self.terrain[i] ) )
			{
				self.terrain[i] Delete(); 
			}
		}
	}
	
	if( IsDefined( self.hidden_terrain ) )
	{
		self.hidden_terrain Show(); 
	}
	self.has_terrain = false; 
	
	mortar_boom( self.origin, fQuakepower, iQuaketime, iQuakeradius , undefined, bIsstruct ); 
}

mortar_boom( origin, fPower, iTime, iRadius, effect, bIsstruct )
{
	if( !IsDefined( fPower ) )
	{
		fPower = 0.15; 
	}
	
	if( !IsDefined( iTime ) )
	{
		iTime = 2; 
	}

	if( !IsDefined( iRadius ) )
	{
		iRadius = 850; 
	}

	thread mortar_sound( bIsstruct ); 

	if( IsDefined( effect ) )
	{
		PlayFx( effect, origin ); 
	}
	else
	{
		PlayFx( level.mortar, origin ); 
	}
		
	Earthquake( fPower, iTime, origin, iRadius ); 
	
	if( IsDefined( level.playerMortar ) )
	{
		return; 
	}

	players = get_players(); 

// SCRIPTER_MOD
// MikeD( 3/16/200 ): No more level.player
	players = get_players();
	player_count = 0;
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, origin ) > 300 * 300 )
	{
			player_count++;
		}
	}

	if( player_count == players.size )
	{
		return; 
	}

// MikeD( 3/16/200 ): Note, these are for rails...
	if( level.script == "carchase" || level.script == "breakout" )
	{
		return; 
	}

	level.playerMortar = true; 		
	level notify( "shell shock player", 	iTime*4 ); 
	maps\_shellshock::main( origin, iTime * 4 ); 
}

mortar_sound( bIsstruct )
{
	if( !IsDefined( level.mortar_last_sound ) )
	{
		level.mortar_last_sound = -1; 
	}

	soundnum = RandomInt( 3 ) + 1; 
	while( soundnum == level.mortar_last_sound )
	{
		soundnum = RandomInt( 3 ) + 1; 
	}

	level.mortar_last_sound	 = soundnum; 
	
	if( !bIsstruct )
	{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//		self PlaySound( "mortar_explosion"+soundnum ); 
	}
	else
	{
		play_sound_in_space( "mortar_explosion"+soundnum, self.origin ); 
	}
}

incoming_sound( soundnum , bIsstruct )
{
	currenttime = GetTime(); 
	if( !IsDefined( level.lastmortarincomingtime ) )
	{
		level.lastmortarincomingtime = currenttime; 
	}
	else if( ( currenttime-level.lastmortarincomingtime ) < 1000 )
	{
		wait( 1 ); 
		return; 
	}
	else
	{
		level.lastmortarincomingtime = currenttime; 
	}	

	if( !IsDefined( soundnum ) )
	{
		soundnum = RandomInt( 3 ) + 1; 
	}

	if( soundnum == 1 )
	{
		if( bIsstruct )
		{
			thread play_sound_in_space( "mortar_incoming1", self.origin ); 
		}
		else
		{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//			self PlaySound( "mortar_incoming1" ); 
		}
		wait( 1.07 - 0.25 ); 
	}
	else if( soundnum == 2 )
	{
		if( bIsstruct )
		{
			thread play_sound_in_space( "mortar_incoming2", self.origin ); 
		}
		else
		{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//			self PlaySound( "mortar_incoming2" ); 
		}
		wait( 0.67 - 0.25 ); 
	}
	else
	{
		if( bIsstruct )
		{
			thread play_sound_in_space( "mortar_incoming3", self.origin ); 
		}
		else
		{
// SCRIPTER_MOD
// MikeD( 3/16/200 ): These sounds do not exist
//			self PlaySound( "mortar_incoming3" ); 
		}
		wait( 1.55 - 0.25 ); 
	}
}

// SCRIPTER_MOD
// MikeD (3/22/2007): I think we will want to write our own mortar loop. I am not sure why generic_style is
// not similar to the other mortar loops.
// TODO: NEEDS TESTING!
generic_style_init()
{
	level._explosion_iMaxRange = []; 
	level._explosion_iMinRange = []; 
	level._explosion_iBlastRadius = []; 
	level._explosion_iDamageMax = []; 
	level._explosion_iDamageMin = []; 
	level._explosion_fQuakePower = []; 
	level._explosion_iQuakeTime = []; 
	level._explosion_iQuakeRadius = []; 
}

generic_style_setradius( strExplosion, iMinRange, iMaxRange )
{
	level._explosion_iMinRange[strExplosion] = iMinRange; 
	level._explosion_iMaxRange[strExplosion] = iMaxRange; 	
}

generic_style_setdamage( strExplosion, iBlastRadius, iDamageMin, iDamageMax )
{
	level._explosion_iBlastRadius[strExplosion] = iBlastRadius; 
	level._explosion_iDamageMin[strExplosion] = iDamageMin; 
	level._explosion_iDamageMax[strExplosion] = iDamageMax; 
}

generic_style_setquake( strExplosion, fQuakePower, iQuakeTime, iQuakeRadius )
{
	level._explosion_fQuakePower[strExplosion] = fQuakePower; 
	level._explosion_iQuakeTime[strExplosion] = iQuakeTime; 
	level._explosion_iQuakeRadius[strExplosion] = iQuakeRadius; 
}

// REQUIRED: level._effect[strExplosion] 		 = LoadFx( ... ); 
// REQUIRED: level._effectType[strExplosion]	 = strType( "mortar", "bomb" or "artillery" )

// Allows for multiple sets of explosions in a single level
// One explosion within iMaxRange distance goes off every( random + random ) seconds but not within iMinRange units of the player
// Starts on notify specified by level.explosion_start[strExplosion]
// Terminates on notify specified by level.explosion_stop[strExplosion]
// Terminate on demand by setting level.bStopBarrage[strExplosion] == true, operates indefinitely by default
generic_style( strExplosion, fDelay, iBarrageSize, fBarrageDelay, iMinRange, iMaxRange, bTargetsUsed )
{
	//// Safety checks
	assertex( ( IsDefined( strExplosion ) &&( strExplosion != "" ) ), "strExplosion not passed. pass in level script" ); 
	assertex( ( IsDefined( level._effect ) && IsDefined( level._effect[strExplosion] ) ), "level._effect[strMortars] not defined. define in level script" ); 

	//// Initialize Defaults
	iLastExplosion = -1; 
	iMaxRangeLocal = iMaxRange; 
	iMinRangeLocal = iMinRange; 

	generic_style_setradius( strExplosion, 300, 2200 ); 
	
	if( !IsDefined( fDelay ) )
	{
		fDelay = 7; 
	}
		
	if( !IsDefined( iBarrageSize ) )
	{
		iBarrageSize = 1; 
	}
		
	if( !IsDefined( fBarrageDelay ) )
	{
		fBarrageDelay = 0; 
	}

	if( !IsDefined( bTargetsUsed ) )	//this allows generic_style to get called again and not setup any terrain related stuff
	{
		bTargetsUsed = false; 
	}

	if( IsDefined( level.explosion_stopNotify ) && IsDefined( level.explosion_stopNotify[strExplosion] ) )
	{
		level endon( level.explosion_stopNotify[strExplosion] ); 
	}

	// for backwards compatibility
	if( !IsDefined( level.bStopBarrage ) || !IsDefined( level.bStopBarrage[strExplosion] ) )
	{
		level.bStopBarrage[strExplosion] = false; 
	}

	//// Explosion Points
	aeExplosions = GetEntArray( strExplosion, "targetname" ); 

	//// Terrain Setup
	for( i = 0; i < aeExplosions.size; i++ )
	{
		if( IsDefined( aeExplosions[i].target ) &&( !bTargetsUsed ) )	//no target necessary, mortar will just play effect and sound
		{
			aeExplosions[i] setup_mortar_terrain(); 
		}
	}

	//// Start Wait
	if( IsDefined( level.explosion_startNotify ) && IsDefined( level.explosion_startNotify[strExplosion] ) )
	{
		level waittill( level.explosion_startNotify[strExplosion] ); 
	}

	//// Main Loop
	while( true )
	{
		while( !level.bStopBarrage[strExplosion] )
		{
			for( j = 0; j < iBarrageSize; j++ )
			{
				// putting this here allows for updates during barrage
				if( !IsDefined( iMaxRange ) )
				{
					iMaxRangeLocal = level._explosion_iMaxRange[strExplosion]; 		
				}
				if( !IsDefined( iMinRange ) )
				{
					iMinRangeLocal = level._explosion_iMinRange[strExplosion]; 
				}
			
				iRand = RandomInt( aeExplosions.size ); 
// SCRIPTER_MOD
// MikeD (3/22/2007): No more level.player
//				for( i = 0; i < aeExplosions.size; i++ )
//				{
//					iCur = ( i + iRand ) % aeExplosions.size; 
//					fDist = Distance( level.player GetOrigin(), aeExplosions[iCur].origin ); 
//					if( ( fDist < iMaxRangeLocal ) &&( fDist > iMinRangeLocal ) &&( iCur != iLastExplosion ) )
//					{
//						aeExplosions[iCur].iMinRange = iMinRangeLocal; 
//						aeExplosions[iCur] explosion_activate( strExplosion ); 
//						iLastExplosion = iCur; 
//						break; 
//					}
//				}

				for( i = 0; i < aeExplosions.size; i++ )
				{
					iCur = ( i + iRand ) % aeExplosions.size; 

					do_mortar = false;
					players = get_players();
					for( q = 0; q < players.size; q++ )
					{
						fDist = Distancesquared( players[i] GetOrigin(), aeExplosions[iCur].origin );

						if( iCur != iLastExplosion && fDist < iMaxRangeLocal * iMaxRangeLocal && fDist > iMinRangeLocal * iMinRangeLocal )
						{
							do_mortar = true;
						}
						else
						{
							do_mortar = false;
							break;
						}
					}

					if( do_mortar )	
					{
						aeExplosions[iCur].iMinRange = iMinRangeLocal; 
						aeExplosions[iCur] explosion_activate( strExplosion ); 
						iLastExplosion = iCur; 
						break; 
					}
				}

				iLastExplosion = -1; 
				if( IsDefined( level.explosion_delay ) && IsDefined( level.explosion_delay[strExplosion] ) )
				{
					wait( level.explosion_delay[strExplosion] ); 
				}
				else
				{
					wait( RandomFloat( fDelay ) + RandomFloat( fDelay ) ); 
				}
			}
			if( IsDefined( level.explosion_barrage_delay ) && IsDefined( level.explosion_barrage_delay[strExplosion] ) )
			{
				wait( level.explosion_barrage_delay[strExplosion] ); 
			}
			else
			{
				wait( RandomFloat( fBarrageDelay ) + RandomFloat( fBarrageDelay ) ); 
			}
		}
		wait( 0.05 ); 
	}
}

explosion_activate( strExplosion, iBlastRadius, iDamageMin, iDamageMax, fQuakePower, iQuakeTime, iQuakeRadius )
{
	//// Initialize Defaults
	generic_style_setdamage( strExplosion, 256, 25, 400 ); 
	generic_style_setquake( strExplosion, 0.15, 2, 850 ); 
	
	if( !IsDefined( iBlastRadius ) )
	{
		iBlastRadius = level._explosion_iBlastRadius[strExplosion]; 
	}
	if( !IsDefined( iDamageMin ) )
	{
		iDamageMin = level._explosion_iDamageMin[strExplosion]; 
	}
	if( !IsDefined( iDamageMax ) )
	{
		iDamageMax = level._explosion_iDamageMax[strExplosion]; 
	}

	if( !IsDefined( fQuakePower ) )
	{
		fQuakePower = level._explosion_fQuakePower[strExplosion]; 
	}
	if( !IsDefined( iQuakeTime ) )
	{
		iQuakeTime = level._explosion_iQuakeTime[strExplosion]; 
	}
	if( !IsDefined( iQuakeRadius ) )
	{
		iQuakeRadius = level._explosion_iQuakeRadius[strExplosion]; 
	}

	//// Incoming Sound
	explosion_incoming( strExplosion ); 

	level notify( "explosion", strExplosion ); 

	bDoDamage = true; 
	fPreDist = undefined; 
	eLocation = self; 

// SCRIPTER_MOD
// MikeD (3/22/2007): No more level.player
//	if( IsDefined( self.iMinRange ) && Distance( level.player.origin, self.origin ) < self.iMinRange )
//	{
//		// get closest location outside iMinRange
//		aeExplosions = GetEntArray( strExplosion, "targetname" ); 
//		for( iCur = 0; iCur < aeExplosions.size; iCur++ )
//		{
//			fDist = Distance( level.player GetOrigin(), aeExplosions[iCur].origin ); 
//			if( fDist > self.iMinRange )
//			{
//				if( !IsDefined( fPreDist ) || fDist < fPreDist )
//				{
//					fPreDist = fDist; 
//					eLocation = aeExplosions[iCur]; 
//				}
//			}
//		}
//		if( !IsDefined( fPreDist ) )
//		{
//			bDoDamage = false; 
//		}
//	}
	
	// SCRIPTER_MOD
	// JesseS (3/27/07): No more level.player	
	players = get_players();
	for( q = 0; q < players.size; q++ )
	{
		if( IsDefined( self.iMinRange ) && Distancesquared( players[q].origin, self.origin ) < self.iMinRange * self.iMinRange )
	{
		// get closest location outside iMinRange
		aeExplosions = GetEntArray( strExplosion, "targetname" ); 
			break_now = false;
		for( iCur = 0; iCur < aeExplosions.size; iCur++ )
		{
				fDist = Distance( players[q] GetOrigin(), aeExplosions[iCur].origin ); 
			if( fDist > self.iMinRange )
			{
				if( !IsDefined( fPreDist ) || fDist < fPreDist )
				{
					fPreDist = fDist; 
					eLocation = aeExplosions[iCur]; 
						break_now = true;
						break;
				}
			}
		}

		if( !IsDefined( fPreDist ) )
		{
			bDoDamage = false; 
		}

			if( break_now )
			{
				break;
			}
		}
	}

	if( bDoDamage )
	{
		RadiusDamage( eLocation.origin, iBlastRadius, iDamageMax, iDamageMin ); 
	}

	//// Process Terrain
	if( ( IsDefined( eLocation.has_terrain ) && eLocation.has_terrain == true ) &&( IsDefined( eLocation.terrain ) ) )
	{
		for( i = 0; i < eLocation.terrain.size; i++ )
		{
			if( IsDefined( eLocation.terrain[i] ) )
			{
				eLocation.terrain[i] Delete(); 
			}
		}
	}
	
	if( IsDefined( eLocation.hidden_terrain ) )
	{
		eLocation.hidden_terrain Show(); 
	}
	eLocation.has_terrain = false; 
	
	//// Explosion Effects
	eLocation explosion_boom( strExplosion, fQuakePower, iQuakeTime, iQuakeRadius ); 
}

explosion_boom( strExplosion, fPower, iTime, iRadius )
{
	if( !IsDefined( fPower ) )
	{
		fPower = 0.15; 
	}
	if( !IsDefined( iTime ) )
	{
		iTime = 2; 
	}
	if( !IsDefined( iRadius ) )
	{
		iRadius = 850; 
	}

	explosion_sound( strExplosion ); 

	explosion_origin = self.origin; 

	PlayFx( level._effect[strExplosion], explosion_origin ); 
	Earthquake( fPower, iTime, explosion_origin, iRadius ); 
	
// SCRIPTER_MOD
// MikeD (3/22/2007): No more level.player
//	if( Distance( level.player.origin, explosion_origin ) > 300 )

	players = get_players();
	player_count = 0;
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, explosion_origin ) > 300 * 300 )
		{
			player_count++;
		}
	}

	if( player_count == players.size )
	{
		return; 
	}

	if( level.script == "carchase" || level.script == "breakout" )
	{
		return; 
	}

	level.playerMortar = true; 		
	level notify( "shell shock player", 	iTime * 4 ); 
	maps\_shellshock::main( explosion_origin, iTime * 4 ); 
}

explosion_sound( strExplosion )
{
	if( !IsDefined( level._explosion_last_sound ) )
	{
		level._explosion_last_sound = 0; 
	}

	soundnum = RandomInt( 3 ) + 1; 
	while( soundnum == level._explosion_last_sound )
	{
		soundnum = RandomInt( 3 ) + 1; 
	}

	level._explosion_last_sound = soundnum; 

	if( level._effectType[strExplosion] == "mortar" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_explosion1" ); 
			break; 
		case 2:
			self PlaySound( "mortar_explosion2" ); 
			break; 
		case 3:
			self PlaySound( "mortar_explosion3" ); 
			break; 
		}
	}
	else if( level._effectType[strExplosion] == "artillery" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_explosion4" ); 
			break; 
		case 2:
			self PlaySound( "mortar_explosion5" ); 
			break; 
		case 3:
			self PlaySound( "mortar_explosion1" ); 
			break; 
		}
	}
	else if( level._effectType[strExplosion] == "bomb" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_explosion1" ); 
			break; 
		case 2:
			self PlaySound( "mortar_explosion4" ); 
			break; 
		case 3:
			self PlaySound( "mortar_explosion5" ); 
			break; 
		}
	}
}

explosion_incoming( strExplosion, soundnum )
{
	if( !IsDefined( level._explosion_last_incoming ) )
	{
		level._explosion_last_incoming = -1; 
	}

	soundnum = RandomInt( 4 ) + 1; 
	while( soundnum == level._explosion_last_incoming )
	{
		soundnum = RandomInt( 4 ) + 1; 
	}

	level._explosion_last_incoming	 = soundnum; 

	if( level._effectType[strExplosion] == "mortar" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_incoming1" ); 
			wait( 1.07 - 0.25 ); 
			break; 
		case 2:
			self PlaySound( "mortar_incoming2" ); 
			wait( 0.67 - 0.25 ); 
			break; 
		case 3:
			self PlaySound( "mortar_incoming3" ); 
			wait( 1.55 - 0.25 ); 
			break; 
		default:
			wait( 1.75 ); 
			break; 
		}
	}
	else if( level._effectType[strExplosion] == "artillery" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_incoming4" ); 
			wait( 1.07 - 0.25 ); 
			break; 
		case 2:
			self PlaySound( "mortar_incoming4_new" ); 
			wait( 0.67 - 0.25 ); 
			break; 
		case 3:
			self PlaySound( "mortar_incoming1_new" ); 
			wait( 1.55 - 0.25 ); 
			break; 
		default:
			wait( 1.75 ); 
			break; 
		}
	}
	else if( level._effectType[strExplosion] == "bomb" )
	{
		switch( soundnum )
		{
		case 1:
			self PlaySound( "mortar_incoming2_new" ); 
			wait( 1.75 ); 
			break; 
		case 2:
			self PlaySound( "mortar_incoming3_new" ); 
			wait( 1.75 ); 
			break; 
		case 3:
			self PlaySound( "mortar_incoming4_new" ); 
			wait( 1.75 ); 
			break; 
		default:
			wait( 1.75 ); 
			break; 
		}
	}
}
