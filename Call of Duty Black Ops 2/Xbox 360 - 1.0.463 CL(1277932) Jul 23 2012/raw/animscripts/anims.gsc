#include animscripts\utility;
#include common_scripts\Utility;

#using_animtree ("generic_human");

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// BEGIN PUBLIC FUCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

animArray( animname, scriptOverride, errorIfMissing )
{
	return animArrayGeneric( animname, scriptOverride, errorIfMissing, self.anim_array, anim.anim_array, true );
}

angleDeltaArray( animname, scriptOverride, errorIfMissing )
{
	return animArrayGeneric( animname, scriptOverride, errorIfMissing, self.angle_delta_array, anim.angle_delta_array, false );
}

moveDeltaArray( animname, scriptOverride, errorIfMissing )
{
	return animArrayGeneric( animname, scriptOverride, errorIfMissing, self.move_delta_array, anim.move_delta_array, false );
}

preMoveDeltaArray( animname, scriptOverride, errorIfMissing )
{
	return animArrayGeneric( animname, scriptOverride, errorIfMissing, self.pre_move_delta_array, anim.pre_move_delta_array, false );
}

postMoveDeltaArray( animname, scriptOverride, errorIfMissing )
{
	return animArrayGeneric( animname, scriptOverride, errorIfMissing, self.post_move_delta_array, anim.post_move_delta_array, false );
}

longestExposedApproachDist()
{	
	if( IsDefined(self.longestExposedApproachDist) )
	{
		assert( IsDefined( self.longestExposedApproachDist[self.animType] ) );

		return self.longestExposedApproachDist[self.animType];
	}

	assert( IsDefined(anim.longestExposedApproachDist) );

	if( self.subclass != "regular" && IsDefined(anim.longestExposedApproachDist[self.subclass]) )
	{
		return anim.longestExposedApproachDist[self.subclass];
	}
	
	if( IsDefined(anim.longestExposedApproachDist[self.animType]) )
	{
		return anim.longestExposedApproachDist[self.animType];
	}
	
	return anim.longestExposedApproachDist["default"];
}

longestApproachDist( animname )
{	
	if( IsDefined(self.longestApproachDist) )
	{
		if( IsDefined( self.longestApproachDist[self.animType][animname] ) )
			return self.longestApproachDist[self.animType][animname];
	}

	assert( IsDefined(anim.longestApproachDist) );
	
	if( self.subclass != "regular" && IsDefined( anim.longestApproachDist[self.subclass] ) && IsDefined( anim.longestApproachDist[self.subclass][animname] ) )
	{
		return anim.longestApproachDist[self.subclass][animname];
	}
	
	if( IsDefined( anim.longestApproachDist[self.animType] ) && IsDefined( anim.longestApproachDist[self.animType][animname] ) )
	{
		return anim.longestApproachDist[self.animType][animname];
	}
		
	return anim.longestApproachDist["default"][animname];
}

/@
"Name: setIdleAnimOverride( overrideAnim )"
"Module: Utility"
"Summary: Overrides the default idle anim set for an AI"
"MandatoryArg: overrideAnim: can be a single anim or an array. Set to undefined to remove override"
"Example: guy setIdleAnimOverride( %idleAnim );"
"SPMP: singleplayer"
@/
setIdleAnimOverride( overrideAnim )
{
	if( !IsDefined(self.anim_array) )
	{
		self.anim_array = [];
	}

	if( !IsDefined(overrideAnim) ) // clear
	{
		self.anim_array[self.animType]["stop"]["stand"]["none"]["idle"] = undefined;
		self.anim_array[self.animType]["stop"]["stand"][self WeaponAnims()]["idle"] = undefined;
	}
	else if( IsArray(overrideAnim) )
	{
		self.anim_array[self.animType]["stop"]["stand"]["none"]["idle"] = array( overrideAnim );
		self.anim_array[self.animType]["stop"]["stand"][self WeaponAnims()]["idle"] = array( overrideAnim );
	}
	else
	{
		self.anim_array[self.animType]["stop"]["stand"]["none"]["idle"] = array( array(overrideAnim) );
		self.anim_array[self.animType]["stop"]["stand"][self WeaponAnims()]["idle"] = array( array(overrideAnim) );
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// END PUBLIC FUCTIONS
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

animArrayGeneric( animname, scriptOverride, errorIfMissing, my_anim_array, global_anim_array, useCache )
{
	// clear cache on pose change
	if( self.a.pose != self.a.prevPose )
	{
		clearAnimCache();
		self.a.prevPose = self.a.pose;
	}

	// check the cache first
	if( useCache )
	{
		cacheEntry = self.anim_array_cache[animname];
		if( IsDefined(cacheEntry) )
		{
			return cacheEntry;
		}
	}

	theAnim = %void;

	animType		= self.animType;
	animScript		= self.a.script;
	animPose		= self.a.pose;
	animWeaponAnims = self WeaponAnims();

	if( IsAi(self) && !self holdingWeapon() )
	{
		animWeaponAnims = "none";
	}

	errorIfMissingOverride = errorIfMissing;

	// check the override
	if( IsDefined( scriptOverride ) )
	{
		animScript = scriptOverride;
	}
	else if( IsDefined( self.a.script_suffix ) )
	{
		animScript += self.a.script_suffix;
	}

	// check the self array to see if we have overrides
	if( IsDefined( my_anim_array ) )
	{
		theAnim = self animArrayInternal( my_anim_array, animType, animScript, animPose, animWeaponAnims, animName, false, false );
	}

	assert( IsDefined( global_anim_array ) );

	// error out unless it's a special animType
	if( !IsDefined(errorIfMissing) )
	{
		if( animType != "default" || self.subclass != "regular" )
		{
			errorIfMissing			= true;
			errorIfMissingOverride	= false;
		}
		else
		{
			errorIfMissing			= true;
			errorIfMissingOverride	= true;
		}
	}

	// check the global array if the self array didn't have the anim
	if( IsDefined(global_anim_array) && (!IsDefined( theAnim ) || (!IsArray(theAnim) && theAnim == %void)) )
	{
		// check if the subclass has this animation before looking into the default array
		if( self.subclass != "regular" )
		{
			theAnim = self animArrayInternal( global_anim_array, self.subclass, animScript, animPose, animWeaponAnims, animName, errorIfMissingOverride, true );
		}
		
		if( !IsDefined( theAnim ) || (!IsArray(theAnim) && theAnim == %void) )
		{
			theAnim = self animArrayInternal( global_anim_array, animType, animScript, animPose, animWeaponAnims, animName, errorIfMissingOverride, true );
		}

		// if no anim was found, fall back on default array		
		if( animType != "default" && (!IsDefined( theAnim ) || (!IsArray(theAnim) && theAnim == %void)) )
		{
			theAnim = self animArrayInternal( global_anim_array, "default", animScript, animPose, animWeaponAnims, animName, errorIfMissing, true );
		}
	}

	if( useCache && IsDefined(theAnim) )
	{
		self.anim_array_cache[animname] = theAnim;
	}

	return theAnim;
}

animArrayExist( animname, scriptOverride )
{
	theAnim = animArray( animname, scriptOverride, false );

	if( !IsDefined(theAnim) || theAnim == %void )
	{
		return false;
	}

	return true;
}

animArrayAnyExist( animname, scriptOverride )
{
	animArray = animArray( animname, scriptOverride, false );

	if( !IsDefined(animArray) || (!IsArray(animArray) && animArray == %void) )
	{
		return false;
	}
	else if( !IsArray(animArray) )
	{
		return true;
	}
	
	return animArray.size > 0;
}

animArrayPickRandom( animname, scriptOverride, oncePerCache )
{
	animArray = animArray( animname, scriptOverride );

	// return the single anim or the chicken dance
	if( !IsArray(animArray) )
	{
		return animArray;
	}

	assert( animArray.size > 0 );
	
	if ( animArray.size > 1 )
	{
		index = RandomInt( animArray.size );
	}
	else
	{
		index = 0;
	}

	// randomize only once per animscript (cache gets reset on animscript change)
	if( IsDefined(oncePerCache) )
	{
		self.anim_array_cache[animname] = animArray[index];
	}

	return animArray[index];
}

animArrayInternal( anim_array, animType, animScript, animPose, animWeaponAnims, animName, errorIfMissing, globalArrayLookup )
{
	animType_array = anim_array[ animType ];

	// error out and return the chicken dance  
	if( !IsDefined( animType_array ) )
	{
		/#
		if( errorIfMissing )
		{
			//dumpAnimArray();
			errorMsg = "Missing anim: " + animType + "/" + animScript + "/" + animPose + "/" + animWeaponAnims + "/" + animName + ". AnimType \'" + animType + "\' not part of anim array. ";
			assert( IsDefined( animType_array ), errorMsg );
		}
		#/

	  return %void;
	}

	script_array = animType_array[ animScript ];

	// error out and return the chicken dance  
	if( !IsDefined( script_array ) )
	{
		// is in cover script, try exposed
		if( IsDefined(self.coverNode) && animScript != "combat" && animscripts\shared::isExposed() )
		{
			return animArrayInternal( anim_array, animType, "combat", animPose, animWeaponAnims, animName, errorIfMissing, globalArrayLookup );
		}

		/#
		if( errorIfMissing )
		{
			//dumpAnimArray();
			errorMsg = "Missing anim: " + animType + "/" + animScript + "/" + animPose + "/" + animWeaponAnims + "/" + animName + ". Script \'" + animScript + "\' not part of anim array. ";
			assert( IsDefined( script_array ), errorMsg );
		}
		#/

	  return %void;
	}

	pose_array = script_array[ animPose ];

	// error out and return the chicken dance  
	if( !IsDefined( pose_array ) )
	{
		/#
		if( errorIfMissing )
		{
			//dumpAnimArray();
			errorMsg = "Missing anim: " + animType + "/" + animScript + "/" + animPose + "/" + animWeaponAnims + "/" + animName + ". Pose \'" + animPose + "\' not part of anim array. ";
			assert( IsDefined( pose_array ), errorMsg );
		}
		#/

	  return %void;
	}

	weapon_array = pose_array[ animWeaponAnims ];

	// error out and return the chicken dance  
	if( !IsDefined( weapon_array ) )
	{
		// use rifle anims by default. The anim array check is so that this is done only for the default set.
		if( animWeaponAnims != "rifle" && globalArrayLookup )
		{
			return animArrayInternal( anim_array, animType, animScript, animPose, "rifle", animName, errorIfMissing, globalArrayLookup );
		}

		if( errorIfMissing )
		{
			/#
			//dumpAnimArray();
			errorMsg = "Missing anim: " + animType + "/" + animScript + "/" + animPose + "/" + animWeaponAnims + "/" + animName + ". WeaponType \'" + animWeaponAnims + "\' not part of anim array. ";
			assertMsg( errorMsg );
			#/
		}
		
		return %void;
	}

	theAnim = weapon_array[ animName ];

	// error out and return the chicken dance  
	if( !IsDefined( theAnim ) )
	{
		// SUMEET_TODO - The rifle animWeaponAnims check is out of order. We should be checking if AI is using combat animations at cover first 
		// Holding this off for Green Light to not cause global issues.
		
		// use rifle anims by default
		if( animWeaponAnims != "rifle" )
		{
			theAnim = animArrayInternal( anim_array, animType, animScript, animPose, "rifle", animName, errorIfMissing, globalArrayLookup );
		}
		else if( IsDefined(self.coverNode) && animScript != "combat" && globalArrayLookup ) // is in cover script, try exposed
		{
			theAnim = animArrayInternal( anim_array, animType, "combat", animPose, animWeaponAnims, animName, errorIfMissing, globalArrayLookup );
		}
		
		if( (!IsDefined(theAnim) || (!IsArray(theAnim) && theAnim == %void)) && errorIfMissing )
		{
			/#
			//dumpAnimArray();
			errorMsg = "Missing anim: " + animType + "/" + animScript + "/" + animPose + "/" + animWeaponAnims + "/" + animName + ". Anim \'" + animName + "\' not part of anim array. Cur: " + self.a.script + "Prev: " + self.a.prevScript;
			assert( IsDefined(theAnim) && theAnim != %void, errorMsg );
			#/
		}
	}

	return theAnim;
}

/#
dumpAnimArray()
{
	println("self.a.array:");
	keys = getArrayKeys( self.a.array );

	for ( i=0; i < keys.size; i++ )
	{
		if ( isarray( self.a.array[ keys[i] ] ) )
		{
			println( " array[ \"" + keys[i] + "\" ] = {array of size " + self.a.array[ keys[i] ].size + "}" );
		}
		else
		{
			println( " array[ \"" + keys[i] + "\" ] = ", self.a.array[ keys[i] ] );
		}
	}
}
#/

clearAnimCache()
{
	self.anim_array_cache = [];
}