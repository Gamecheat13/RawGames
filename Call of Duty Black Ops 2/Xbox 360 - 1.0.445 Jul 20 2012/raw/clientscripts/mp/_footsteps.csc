init()
{
	
	surfaceArray = getSurfaceStrings();
//	footstepArray = getFootstepStrings();
	
	movementArray = [];
/*	for ( footStepIndex = 0; footStepIndex < footstepArray.size; footStepIndex++ )
	{
		movementArray[footStepIndex] = "step_" + footstepArray[footStepIndex];
	}*/
	
	// for playerJump() sound
	movementArray[movementArray.size] = "step_run";
	// for playerLand() sound
	movementArray[movementArray.size] = "land";
	
	// building array of all sounds
	level.playerFootSounds = [];
	for ( movementArrayIndex = 0; movementArrayIndex < movementArray.size; movementArrayIndex++ )
	{
		movementType = movementArray[movementArrayIndex];
		for ( surfaceArrayIndex = 0; surfaceArrayIndex < surfaceArray.size; surfaceArrayIndex++ )
		{
			surfaceType = surfaceArray[surfaceArrayIndex];
			for ( index = 0; index < 4; index++ )
			{
				if ( index < 2 ) 
				{
					firstPerson = false;
				}
				else
				{
					firstPerson = true;
				}
				
				if ( ( index % 2 ) == 0 )
				{
					isLouder = false;
				}
				else
				{
					isLouder = true;
				}
				
				createSoundAliasSlot( movementType, surfaceType, firstperson, isLouder );
				snd = buildAndCacheSoundAlias( movementtype, surfaceType, firstperson, isLouder );
				
				//PrintLn(movementType + " " + surfaceType + " : " + snd);
			}
		}
	}
	
}

/#
checkSurfaceTypeIsCorrect( moveType, surfaceType )
{
		if ( !isdefined( level.playerFootSounds[moveType][surfaceType] ) )
		{
			println( "_footsteps.csc:" + surfaceType + " is an incorrect material override. " );
			println( "Correct surface types: " );
			println( "***Begin" );
			arrayKeys = getarraykeys( level.playerFootSounds[moveType] );
			for ( i = 0; i < arrayKeys.size; i++ )
			{
				println( arrayKeys[i] );
			}
			println( "***End" );
		}	
}
#/

playerJump(client_num, player, surfaceType, firstperson, quiet, isLouder)
{
	if ( isdefined( player.audioMaterialOverride ) )
	{
		surfaceType = player.audioMaterialOverride;
/#
		checkSurfaceTypeIsCorrect( "step_run", surfaceType );
#/
	}
	
	sound_alias = level.playerFootSounds["step_run"][surfaceType][firstperson][isLouder];
	
	player playsound( client_num, sound_alias );
}

playerLand(client_num, player, surfaceType, firstperson, quiet, damagePlayer, isLouder)
{	
	if ( isdefined( player.audioMaterialOverride ) )
	{
		surfaceType = player.audioMaterialOverride;
/#
		checkSurfaceTypeIsCorrect( "land", surfaceType );	
#/
	}
	
	sound_alias = level.playerFootSounds["land"][surfaceType][firstperson][isLouder];

	player playsound( client_num, sound_alias );
	// play step sound for landings if one exists
	if ( IsDefined( player.step_sound ) && (!quiet) && (player.step_sound) != "none" )
	{
		volume = clientscripts\mp\_audio::get_vol_from_speed (player);

 		player playsound (client_num, player.step_sound, player.origin, volume);				
	}
	if ( damagePlayer )
	{
		sound_alias = "fly_land_damage_npc";
		if ( firstperson )
		{
			sound_alias = "fly_land_damage_plr";
			player playsound( client_num, sound_alias );
		}
	}
}

playerFoliage(client_num, player, firstperson, quiet)
{
	sound_alias = "fly_movement_foliage_npc";
	if ( firstperson )
	{
		sound_alias = "fly_movement_foliage_plr";
	}

	volume = clientscripts\mp\_audio::get_vol_from_speed (player);		
	player playsound( client_num, sound_alias, player.origin, volume );
}


createSoundAliasSlot( movementType, surfaceType, firstperson, isLouder )
{
	isPrecached = false;
	if ( !isdefined( level.playerFootSounds[movementtype] ) )
	{
		level.playerFootSounds[movementtype] = [];
	}
	if ( !isdefined( level.playerFootSounds[movementtype][surfaceType] ) )
	{
		level.playerFootSounds[movementtype][surfaceType] = [];
	}
	if ( !isdefined( level.playerFootSounds[movementtype][surfaceType][firstperson] ) )
	{
		level.playerFootSounds[movementtype][surfaceType][firstperson] = [];
	}
}



buildAndCacheSoundAlias( movementtype, surfaceType, firstperson, isLouder )
{
	sound_alias = "fly_" + movementtype;

	if ( firstperson )
	{
		sound_alias = sound_alias + "_plr_";
	}
	else
	{
		sound_alias = sound_alias + "_npc_";
	}
	
	sound_alias = sound_alias + surfaceType; 
	
	level.playerFootSounds[movementtype][surfaceType][firstperson][isLouder] = sound_alias;
	
	return sound_alias;
}

do_foot_effect(client_num, ground_type, foot_pos, on_fire)
{

	if(!isdefined(level._optionalStepEffects))
		return;

	if( on_fire )
	{
		ground_type = "fire";
	} 
	
/#
	if(GetDvarInt("debug_surface_type"))
	{
		print3d(foot_pos, ground_type, (0.5, 0.5, 0.8), 1, 3, 30);
	}
#/

	for(i = 0; i < level._optionalStepEffects.size; i ++)
	{
		if(level._optionalStepEffects[i] == ground_type)
		{
			effect = "fly_step_" + ground_type;
			
			if(isdefined(level._effect[effect]))
			{
				playfx(client_num, level._effect[effect], foot_pos, foot_pos + (0,0,100));
				return;				
			}
		}
	}
	
}

missing_ai_footstep_callback()
{
	/#
	type = self._aitype;
	
	if(!IsDefined(type))
	{
		type = "unknown";
	}
	
	PrintLn("*** Ai type : " + type + " has a client-script footstep script callback specified, but has no callback specified.  Call _footsteps::RegisterAITypeFootstepCB(\""+self._aitype+"\", ::yourcbfunc); in your level main .csc file.");		
	#/
}

playAIFootstep(client_num, pos, surface, notetrack, bone)
{	
	if(!IsDefined(self._aitype))
	{
	/#	PrintLn("*** Client script footstep callback on an entity that doesn't have an _aitype defined.  Ignoring.");	#/
		FootstepDoEverything();		
		return;
	}
	
	if(!IsDefined(level._footstepCBFuncs) || !IsDefined(level._footstepCBFuncs[self._aitype]))
	{
		self missing_ai_footstep_callback();
		FootstepDoEverything();
		return;
	}
	
	[[level._footstepCBFuncs[self._aitype]]](client_num, pos, surface, notetrack, bone);

}