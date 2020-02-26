#include common_scripts\utility;
#include maps\mp\gametypes\_missions;

precache_gib_fx()
{
	level.lastGibTime 	= 0;
	level.gibDelay 		= 3 * 1000; // 3 seconds
	level.minGibs		= 2;
	level.maxGibs		= 4;
	level.totalGibs		= RandomIntRange( level.minGibs, level.maxGibs );
	level._effect["animscript_gib_fx"] 		 = LoadFx( "weapon/bullet/fx_flesh_gib_fatal_01_mp" ); 
	level._effect["animscript_gibtrail_fx"] 	 = LoadFx( "trail/fx_trail_blood_streak_mp" ); 
}

do_gib( iDamage, sMeansOfDeath, weapon )
{
	if ( do_explosive_gib( iDamage, sMeansOfDeath, weapon ) || do_bullet_gib( iDamage, sMeansOfDeath, weapon ))
		return true;
		
	return false;
}

do_explosive_gib( iDamage, sMeansOfDeath, weapon, sHitLoc, vAttackerOrigin )
{
	if ( weapon == "m8_white_smoke_mp" )
		return false;
		
	if ( weapon == "tabun_gas_mp" )
		return false;
		
	if ( weapon == "signal_flare_mp" )
		return false;
		
	if ( weapon == "molotov_mp" )
		return false;
		
	if ( sMeansOfDeath == "MOD_EXPLOSIVE" ||
	     sMeansOfDeath == "MOD_GRENADE" ||
	     sMeansOfDeath == "MOD_GRENADE_SPLASH" ||
	     sMeansOfDeath == "MOD_PROJECTILE" ||
	     sMeansOfDeath == "MOD_PROJECTILE_SPLASH" ||
	     sMeansOfDeath == "MOD_SUICIDE")
	{
		// do the gibs only if the damage was enough to kill the player in one hit
		// even if the were already damaged
		if ( iDamage >= self.maxhealth )
		{
			return true;
		}
	}
	
	return false;
}

is_weapon_shotgun( sWeapon )
{
	if (WeaponClass( sWeapon ) == "spread")
		return true;
		
	return false;
}

do_bullet_gib( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vAttackerOrigin )
{
	if ( !isdefined( vAttackerOrigin ) )
		return false;
		
	if( !isdefined( sHitLoc ) )
		return false; 

	if( sMeansOfDeath == "MOD_MELEE" )
		return false; 

	shotty_gib = is_weapon_shotgun( sWeapon );
	
	// shotgun damage is less than 50
	if( iDamage < 35 && !shotty_gib )
	{
		return false; 
	}

	distSquared = DistanceSquared( self.origin, vAttackerOrigin );
	maxDist = 300; 
	gib_chance = 50;

	if( shotty_gib ) // shotgun
	{
		if( distSquared < 110*110 )
		{
			gib_chance = 100;
		}
		else if( distSquared < 200*200 )
		{
			gib_chance = 75;
		}
		else if( distSquared < 270*270 )
		{
			gib_chance = 50;
		}
		else if( distSquared < 330*330 )
		{
			if( RandomInt( 100 ) < 50 )
			{
				gib_chance = 50;
			}
			else
			{
				return false;
			}
		}
		else
		{
			return false;
		}
	}
	else if( isSubStr( sWeapon, "gunner" ) )
	{
		maxDist = 3000; 
	}
	else if( issubstr(sWeapon,"mg42") || issubstr(sWeapon,"30cal") )  // heavy weapons
	{
		gib_chance = 30;
		maxDist = 2000; 
	}
	else if( issubstr( sWeapon, "ptrs41_" ) )
	{
		maxDist = 3500; 
	}
	else
	{
		return false; 
	}
	
	if( distSquared < maxDist*maxDist && RandomInt( 100 ) < gib_chance &&  GetTime() > level.lastGibTime + level.gibDelay )
	{
		return true;
	}
	
	return false;
}

get_explosion_gib_ref( direction )
{
/#
	// Dvars for testing bigs.
	if( GetDvarInt( "gib_delay" ) > 0 )
	{
		level.gibDelay = GetDvarInt( "gib_delay" ); 
	}

	if( GetDvar( "gib_test" ) != "" )
	{
		self.gib_ref = GetDvar( "gib_test" ); 
		return; 
	}
#/

	// If already set, then use it. Useful for canned gib deaths.
//	if( IsDefined( self.gib_ref ) )
//	{
//		return; 
//	}

	if( GetTime() > level.lastGibTime + level.gibDelay && level.totalGibs > 0 )
	{
		level.totalGibs--; 

		// MikeD( 5/5/2008 ): Allows multiple guys to GIB at once.
//		level.lastGibTime = GetTime(); 
		level thread set_last_gib_time(); 

		refs = []; 
		switch( direction )
		{
			case "left":
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "left_leg"; 

				gib_ref = get_random( refs ); 				
				break; 

			case "right":
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "right_leg"; 

				gib_ref = get_random( refs ); 				
				break; 

			case "forward":
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "right_leg"; 
				refs[refs.size] = "left_leg"; 
				refs[refs.size] = "guts"; 
				refs[refs.size] = "no_legs"; 

				gib_ref = get_random( refs ); 				
				break; 

			case "back":
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "right_leg"; 
				refs[refs.size] = "left_leg"; 
				refs[refs.size] = "no_legs"; 

				gib_ref = get_random( refs ); 				
				break; 

			default: // "up"
				refs[refs.size] = "right_arm"; 
				refs[refs.size] = "left_arm"; 
				refs[refs.size] = "right_leg"; 
				refs[refs.size] = "left_leg"; 
				refs[refs.size] = "no_legs"; 
				refs[refs.size] = "guts"; 

				gib_ref = get_random( refs ); 
				break; 
		}


		self.gib_ref = gib_ref; 
	}
	else
	{
		self.gib_ref = undefined; 
	}
}

get_gib_ref_by_direction( damageyaw )
{
	gib_debug_print( "gibs: damageyaw " + damageyaw );
	
	// one in five chance of doing the upwards gib
	if( randomint(5) == 0 || damageyaw == 0)
	{
		gib_debug_print("gibs: gib_ref UP" );
		get_explosion_gib_ref( "up" ); 
	}
	else
	if( ( damageyaw > 135 ) ||( damageyaw <= -135 ) )	// Front quadrant
	{
		gib_debug_print("gibs: gib_ref FORWARD" );
		get_explosion_gib_ref( "forward" ); 
	}
	else if( ( damageyaw > 45 ) &&( damageyaw <= 135 ) )		// Right quadrant
	{
		gib_debug_print("gibs: gib_ref RIGHT" );
		get_explosion_gib_ref( "right" ); 
	}
	else if( ( damageyaw > -45 ) &&( damageyaw <= 45 ) )		// Back quadrant
	{
		gib_debug_print("gibs: gib_ref BACK" );
		get_explosion_gib_ref( "back" ); 
	}
	else
	{															// Left quadrant
		gib_debug_print("gibs: gib_ref LEFT" );
		get_explosion_gib_ref( "left" ); 
	}
}

gib_debug_print( text )
{
/#
	if( GetDvarInt( "debug_gibs" ) > 0 )
	{
		println(text );
	}
#/
}

gib_player( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDamageDir, vAttackerOrigin )
{
//	if( !is_mature() )
//	{
//		return; 
//	}

	if ( do_explosive_gib( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vAttackerOrigin ) )
	{
		if (isdefined(vDamageDir))
		{
			gib_debug_print( "gibs: angles " + self.angles[1] );
			gib_debug_print( "gibs: vDamageDir " + vectortoangles(vDamageDir)[1] );
			damageyaw = AngleClamp180( vectortoangles(vDamageDir)[1] - self.angles[1] );
		}
		else
		{
			damageyaw = 0;
		}
		get_gib_ref_by_direction(damageyaw);
	}
	else if ( do_bullet_gib( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vAttackerOrigin ) )
	{
			get_bullet_gib_ref( iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDamageDir);
	}
	else
	{
		return false;
	}
	
	if( !IsDefined( self.gib_ref ) )
	{
		return false; 
	}

	self maps\mp\gametypes\_weapons::detach_all_weapons();
	flamethrowerTank = self maps\mp\gametypes\_teams::detachFlamethrowerTank();
	
	maps\mp\gametypes\_missions::doMissionCallback( "playerGib", self ); 

	gib_ref = self.gib_ref; 

	limb_data = get_limb_data( gib_ref ); 

	if( !IsDefined( limb_data ) )
	{
/#
		println( "^3do_gib: - limb_data is not setup for gib_ref on model: " + self.model + " and gib_ref of: " + self.gib_ref ); 
#/

		return false; 
	}

	forward = undefined; 
	velocity = undefined; 

	pos1 = []; 
	pos2 = []; 
	velocities = []; 

//	level thread draw_line( self GetTagOrigin( limb_data["spawn_tags"] ), self GetTagOrigin( limb_data["spawn_tags"] ) + velocity ); 

	if ( flamethrowerTank )
	{
		self maps\mp\gametypes\_teams::attachFlamethrowerTank();
	}
	
	if( limb_data["spawn_tags"][0] != "" )
	{
		if( isdefined(self.gib_vel) )
		{
			for( i = 0; i < limb_data["spawn_tags"].size; i++ )
			{
				velocities[i] = self.gib_vel;
			}
		}
		else
		{
			for( i = 0; i < limb_data["spawn_tags"].size; i++ )
			{
				pos1[pos1.size] = self GetTagOrigin( limb_data["spawn_tags"][i] );
			}

			wait( 0.05 );

			for( i = 0; i < limb_data["spawn_tags"].size; i++ )
			{
				pos2[pos2.size] = self GetTagOrigin( limb_data["spawn_tags"][i] );
			}

			for( i = 0; i < pos1.size; i++ )
			{
				forward = VectorNormalize( pos2[i] - pos1[i] );
				velocities[i] = forward * RandomIntRange( 600, 1000 );
				velocities[i] = velocities[i] + ( 0, 0, RandomIntRange( 400, 700 ) );
			}
		}
	}

	if( IsDefined( limb_data["fx"] ) )
	{
		for( i = 0; i < limb_data["spawn_tags"].size; i++ )
		{
			if( limb_data["spawn_tags"][i] == "" )
			{
				continue; 
			}

			PlayFxOnTag( level._effect[limb_data["fx"]], self, limb_data["spawn_tags"][i] ); 
		}
	}

	self PlaySound( "death_gibs" );
	self thread throw_gib( limb_data["spawn_models"], limb_data["spawn_tags"], velocities ); 
	
	// Set the upperbody model
	self SetModel( limb_data["body_model"] ); 

	// Attach the legs
	self Attach( limb_data["legs_model"] ); 

	if ( gib_ref == "no_legs" )
		return true;
		
	return false;
}

get_limb_data( gib_ref )
{
	temp_array = []; 

	// Slightly faster, store the isdefined stuff before checking, which will be less code-calls.
	torsoDmg1_defined 	 = IsDefined( self.torsoDmg1 ); 
	torsoDmg2_defined 	 = IsDefined( self.torsoDmg2 ); 
	torsoDmg3_defined 	 = IsDefined( self.torsoDmg3 ); 
	torsoDmg4_defined 	 = IsDefined( self.torsoDmg4 ); 
	torsoDmg5_defined 	 = IsDefined( self.torsoDmg5 ); 
	legDmg1_defined 	 = IsDefined( self.legDmg1 ); 
	legDmg2_defined 	 = IsDefined( self.legDmg2 ); 
	legDmg3_defined 	 = IsDefined( self.legDmg3 ); 
	legDmg4_defined 	 = IsDefined( self.legDmg4 ); 

	gibSpawn1_defined 	 = IsDefined( self.gibSpawn1 ); 
	gibSpawn2_defined 	 = IsDefined( self.gibSpawn2 ); 
	gibSpawn3_defined 	 = IsDefined( self.gibSpawn3 ); 
	gibSpawn4_defined 	 = IsDefined( self.gibSpawn4 ); 
	gibSpawn5_defined 	 = IsDefined( self.gibSpawn5 ); 

	gibSpawnTag1_defined 	 = IsDefined( self.gibSpawnTag1 ); 
	gibSpawnTag2_defined 	 = IsDefined( self.gibSpawnTag2 ); 
	gibSpawnTag3_defined 	 = IsDefined( self.gibSpawnTag3 ); 
	gibSpawnTag4_defined 	 = IsDefined( self.gibSpawnTag4 ); 
	gibSpawnTag5_defined 	 = IsDefined( self.gibSpawnTag5 ); 

// Right arm is getting blown off! /////////////////////////////////////////////////////	
	if( torsoDmg2_defined && legDmg1_defined && gibSpawn1_defined && gibSpawnTag1_defined )
	{
		temp_array["right_arm"]["body_model"] 		 = self.torsoDmg2; 
		temp_array["right_arm"]["legs_model"] 		 = self.legDmg1; 
		temp_array["right_arm"]["spawn_models"][0] 	 = self.gibSpawn1; 

		temp_array["right_arm"]["spawn_tags"][0]	 = self.gibSpawnTag1; 
		temp_array["right_arm"]["fx"]				 = "animscript_gib_fx"; 
	}

// Left arm is getting blown off! //////////////////////////////////////////////////////	
	if( torsoDmg3_defined && legDmg1_defined && gibSpawn2_defined && gibSpawnTag2_defined )
	{
		temp_array["left_arm"]["body_model"] 		 = self.torsoDmg3; 
		temp_array["left_arm"]["legs_model"] 		 = self.legDmg1; 
		temp_array["left_arm"]["spawn_models"][0] 	 = self.gibSpawn2; 

		temp_array["left_arm"]["spawn_tags"][0]		 = self.gibSpawnTag2; 
		temp_array["left_arm"]["fx"]				 = "animscript_gib_fx"; 
	}

// Right leg is getting blown off! ////////////////////////////////////////////////////
	if( torsoDmg1_defined && legDmg2_defined && gibSpawn3_defined && gibSpawnTag3_defined )
	{
		temp_array["right_leg"]["body_model"] 		 = self.torsoDmg1; 
		temp_array["right_leg"]["legs_model"] 		 = self.legDmg2; 
		temp_array["right_leg"]["spawn_models"][0] 	 = self.gibSpawn3; 

		temp_array["right_leg"]["spawn_tags"][0]	 = self.gibSpawnTag3; 
		temp_array["right_leg"]["fx"]				 = "animscript_gib_fx"; 
	}


// Left leg is getting blown off! /////////////////////////////////////////////////////
	if( torsoDmg1_defined && legDmg3_defined && gibSpawn4_defined && gibSpawnTag4_defined )
	{
		temp_array["left_leg"]["body_model"] 		 = self.torsoDmg1; 
		temp_array["left_leg"]["legs_model"] 		 = self.legDmg3; 
		temp_array["left_leg"]["spawn_models"][0] 	 = self.gibSpawn4; 

		temp_array["left_leg"]["spawn_tags"][0]		 = self.gibSpawnTag4; 
		temp_array["left_leg"]["fx"]				 = "animscript_gib_fx"; 
	}

// No legs! ///////////////////////////////////////////////////////////////////////////
	if( torsoDmg1_defined && legDmg4_defined && gibSpawn4_defined && gibSpawn3_defined && gibSpawnTag3_defined && gibSpawnTag4_defined )
	{
		temp_array["no_legs"]["body_model"] 		 = self.torsoDmg1; 
		temp_array["no_legs"]["legs_model"] 		 = self.legDmg4; 
		temp_array["no_legs"]["spawn_models"][0] 	 = self.gibSpawn4; 
		temp_array["no_legs"]["spawn_models"][1] 	 = self.gibSpawn3; 

		temp_array["no_legs"]["spawn_tags"][0]		 = self.gibSpawnTag4; 
		temp_array["no_legs"]["spawn_tags"][1]		 = self.gibSpawnTag3; 
		temp_array["no_legs"]["fx"]					 = "animscript_gib_fx"; 
	}

// Guts! //////////////////////////////////////////////////////////////////////////////
	if( torsoDmg4_defined && legDmg1_defined )
	{
		temp_array["guts"]["body_model"] 			 = self.torsoDmg4; 
		temp_array["guts"]["legs_model"] 			 = self.legDmg1; 

		temp_array["guts"]["spawn_models"][0] 		 = ""; 
	//	temp_array["guts"]["spawn_tags"][0]			 = "J_SpineLower"; 
		temp_array["guts"]["spawn_tags"][0]			 = ""; 
		temp_array["guts"]["fx"]					 = "animscript_gib_fx"; 
	}

// Head! //////////////////////////////////////////////////////////////////////////////
	if( torsoDmg5_defined && legDmg1_defined )
	{
		temp_array["head"]["body_model"] 			 = self.torsoDmg5; 
		temp_array["head"]["legs_model"] 			 = self.legDmg1; 

		if( gibSpawn5_defined && gibSpawnTag5_defined )
		{
			temp_array["head"]["spawn_models"][0] 		 = self.gibSpawn5; 
			temp_array["head"]["spawn_tags"][0]			 = self.gibSpawnTag5;
		}
		else
		{
			temp_array["head"]["spawn_models"][0] 		 = ""; 
			temp_array["head"]["spawn_tags"][0]			 = "";
		}
		temp_array["head"]["fx"]					 = "animscript_gib_fx"; 
	}
	if( IsDefined( temp_array[gib_ref] ) )
	{
		return temp_array[gib_ref]; 
	}
	else
	{
		return undefined; 
	}
}

throw_gib( spawn_models, spawn_tags, velocities )
{
	if( velocities.size < 1 ) // For guts
	{
		return; 
	}

	for( i = 0; i < spawn_models.size; i++ )
	{
		origin = self GetTagOrigin( spawn_tags[i] ); 
		angles = self GetTagAngles( spawn_tags[i] ); 
		CreateDynEntAndLaunch( spawn_models[i], origin, angles, origin, velocities[i], level._effect["animscript_gibtrail_fx"] ); 
//		gib = Spawn( "script_model", self GetTagOrigin( spawn_tags[i] ) ); 
//		gib.angles = self GetTagAngles( spawn_tags[i] ); 
//		gib SetModel( spawn_models[i] ); 
//
//		// Play trail fX
//		PlayFxOnTag( level._effect["animscript_gibtrail_fx"], gib, "tag_fx" ); 
//
//		gib PhysicsLaunch( self.origin, velocities[i] ); 
//	
//		gib thread gib_delete(); 
	}
}

gib_delete()
{
	wait( 10 + RandomFloat( 5 ) ); 
	self Delete(); 
}

get_random( array )
{
	return array[RandomInt( array.size )]; 
}

set_last_gib_time()
{
	level notify( "stop_last_gib_time" ); 
	level endon( "stop_last_gib_time" ); 

	wait( 0.05 ); 
	level.lastGibTime 	 = GetTime(); 
	level.totalGibs		 = RandomIntRange( level.minGibs, level.maxGibs ); 
}

get_bullet_gib_ref(iDamage, sMeansOfDeath, sWeapon, sHitLoc, vDir)
{
	self.gib_ref = undefined; 
	
	level.lastGibTime = GetTime(); 

	refs = []; 
	switch( sHitLoc )
	{
		case "torso_upper":
		case "torso_lower":
			refs[refs.size] = "guts"; 
			refs[refs.size] = "right_arm"; 
			refs[refs.size] = "left_arm"; 
			break; 
		case "right_arm_upper":
		case "right_arm_lower":
		case "right_hand":
			refs[refs.size] = "right_arm"; 
			break; 
		case "left_arm_upper":
		case "left_arm_lower":
		case "left_hand":
			refs[refs.size] = "left_arm"; 
			break; 
		case "right_leg_upper":
		case "right_leg_lower":
		case "right_foot":
			refs[refs.size] = "right_leg"; 
			refs[refs.size] = "no_legs"; 
			break; 
		case "left_leg_upper":
		case "left_leg_lower":
		case "left_foot":
			refs[refs.size] = "left_leg"; 
			refs[refs.size] = "no_legs"; 
			break; 
		case "helmet":
		case "head":
			refs[refs.size] = "head"; 
			break; 
	}

	if( refs.size )
	{
		self.gib_ref = get_random( refs ); 
		/#
		println("GIBS:  " + sHitLoc + " " + self.gib_ref );
		#/
	}

	range = 600; 
	nrange = -600; 
	self.gib_vel = vDir * RandomIntRange( 500, 900 ); 
	self.gib_vel += ( RandomIntRange( nrange, range ), RandomIntRange( nrange, range ), RandomIntRange( 400, 1000 ) ); 
}