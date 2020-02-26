#include common_scripts\utility;
#include animscripts\utility;
#include animscripts\anims;
#include maps\_utility; 

#insert raw\common_scripts\utility.gsh;

#using_animtree( "generic_human" );

//
//		 Damage Yaw
//
//           front
//        /----|----\
//       /    180    \
//      /\     |     /\
//     / -135  |  135  \
//     |     \ | /     |
// left|-90----+----90-|right
//     |     / | \     |
//     \  -45  |  45   /
//      \/     |     \/
//       \     0     / 
//        \----|----/
//           back

//--------------------------------------------------------------------------------
// precaching effects needed for death
//--------------------------------------------------------------------------------
precache_ai_death_fx()
{
	anim._effect["animscript_gib_fx"] 		 = LoadFx( "weapon/bullet/fx_flesh_gib_fatal_01" ); 
	anim._effect["animscript_gibtrail_fx"] 	 = LoadFx( "trail/fx_trail_blood_streak" ); 
	
	anim._effect["death_neckgrab_spurt"] = LoadFx( "impacts/fx_flesh_hit_neck_fatal" ); 
	
	// Weapon/level Specific effects
	if( IS_TRUE( level.supportsVomitingDeaths ) )
		anim._effect["tazer_knuckles_vomit"] = LoadFx( "weapon/taser/fx_taser_knuckles_vomit" ); 
}

//--------------------------------------------------------------------------------
// Main function
//--------------------------------------------------------------------------------
main()
{
	self trackScriptState( "Death Main", "code" ); 
	self endon( "killanimscript" ); 

	// stop all sounds
	self stopsounds(); 

	// stop the laser if its on
	self animscripts\shared::updateLaserStatus( false );
	
	// stop shooting flamethrower
	self flamethrower_stop_shoot(); 

	// clear look at entity
	self LookAtEntity();			

	// delete temp trigger
	if( IsDefined( self.coverLookAtTrigger ) )
	{
		/#
			if( GetDvarInt( "scr_coverLookAtDebug") == 1 )
				PrintLn( "Deleting coverLookAtTrigger for entity " + self GetEntityNumber() + " at time " + GetTime() );
		#/
		
		self.coverLookAtTrigger Delete();
	}
	
	if( IsDefined( level.missionCallbacks ) )
	{
		// removing coop challenges for now MGORDON
		//maps\_challenges_coop::doMissionCallback( "actorKilled", self ); 
	}
	
	// death function
	if( handleDeathFunction() )
		return;

	// don't abort at this point unless you're going to play another animation!
	// just playing ragdoll isn't sufficient because sometimes ragdoll fails, and then
	// you'll just have a corpse standing around in limbo.
	// need to wait a little bit, as soon as this script is done the actor becomes 
	// an actor_corpse and is available for deletion.  If it gets deleted too soon
	// before the actor gets to 'think' at least once then the game can crash.
	if( self.a.nodeath == true )
	{
		wait 0.1;
		return; 
	}
	
	// REACTION_AI_TODO - Commented this out for now. We will look into this system next game
	//addreactionevent ("death",1,self);

	// clear face anims
	clearFaceAnims();

	animscripts\utility::initialize( "death" ); 
	
	anim.painGlobals.numDeathsUntilCrawlingPain--; 
		
	// immidiate ragdoll death
	// DONT use forceragdollimmediate in levels as its being used by the traversal scripts. Use self.a.deathForceRagdoll instead.
	if ( IS_TRUE( self.forceragdollimmediate ) || IS_TRUE( self.a.deathForceRagdoll ) )
		self doImmediateRagdollDeath();

	// custom deathanim
	if( IsDefined( self.deathanim ) )
		return playCustomDeathAnim(); 
	
	// helmet pop
	deathHelmetPop();

	// death sounds
	playDeathSound();

	// clear root before playing any animations
	self ClearAnim( %root, 0.3 ); 
	
	// AI_TODO - Find a better way to implement level/weapon specific deaths
	// machete/similar melee weapon death
	if( play_machete_melee_gib_death_anim() )
		return;
	
	// AI_TODO - Find a better way to implement level/weapon specific deaths
	// special sword death
	if( play_sword_melee_gib_death_anim() )
		return;
	
	// AI_TODO - Find a better way to implement level/weapon specific deaths
	// taser knuckle deaths
	if( play_tazer_melee_death_anim() )
		return;

	// gas death
	if( play_gas_death_anim() )
		return; 
	
	// explosive death
	if( play_explosion_death() )
		return; 
	
	// special death
	if( special_death() )
		return; 
	
	// flame death
	if( play_flame_death_anim() )
		return; 
	
	// gib death
	if( play_bulletgibbed_death_anim() )
		return; 
	
	// vehicle death
	if( play_hit_by_vehicle_anim() )
		return;
		
	// generic death
	deathAnim = get_death_anim(); 

	/#
	if( GetDvarint( "scr_deathDebug" ) == 1 )
		println( "^2Playing death: ", deathAnim, " ; pose is ", self.a.pose ); 
	#/

	play_death_anim( deathAnim ); 
}
//--------------------------------------------------------------------------------
// death globals
//--------------------------------------------------------------------------------
DeathGlobalsInit()
{
	if( !IsDefined( anim.deathGlobals ) )
	{
		anim.deathGlobals = SpawnStruct();

		// explosion death
		anim.deathGlobals.EXPLOSION_DEATH_GIB_CHANCE	 = 50;
		anim.deathGlobals.EXPLOSION_DEATH_GIB_MIN_DAMAGE = 165; // minimum damage needed to gib with explosion death

		// extended deaths
		anim.deathGlobals.EXTENDED_DEATH_GIB_CHANCE		 = 50;

		// gib related variables
		anim.deathGlobals.GLOBAL_GIB_CHANCE	= 20;
		anim.deathGlobals.lastGibTime 		= 0;
		anim.deathGlobals.gibDelay 			= 3 * 1000; // 3 seconds
		anim.deathGlobals.minGibs			= 2;
		anim.deathGlobals.maxGibs			= 4;
		anim.deathGlobals.totalGibs			= RandomIntRange( anim.deathGlobals.minGibs, anim.deathGlobals.maxGibs );
	}
}

//--------------------------------------------------------------------------------
// death function
//--------------------------------------------------------------------------------
handleDeathFunction()
{
	// handle the deathfunction
	if( IsDefined( self.deathFunction ) )
	{
		successful_death = self[[self.deathFunction]](); 
		if( !IsDefined( successful_death ) || successful_death )
			return true; 
	}

	return false;
}

//--------------------------------------------------------------------------------
// utility for death
//--------------------------------------------------------------------------------
clearFaceAnims()
{
	// make sure the guy doesn't keep doing facial animation after death
	const changeTime = 0.3; 
	self ClearAnim( %scripted_look_straight, 		changeTime ); 
	self ClearAnim( %scripted_talking, 				changeTime ); 
}

//--------------------------------------------------------------------------------
// helmet pop
//--------------------------------------------------------------------------------
deathHelmetPop()
{
	if( self.damageLocation == "helmet" || self.damageLocation == "head" || IS_TRUE( self.a.popHeadIfNeeded ) )
	{
		self helmetPop(); 
	}
	else
	{
		explosiveDamage = self animscripts\pain::wasDamagedByExplosive();
		explosiveDamage = explosiveDamage && ( !IsDefined(self.noExplosiveDeathAnim) || !self.noExplosiveDeathAnim );

		if( explosiveDamage && RandomInt( 2 ) == 0 )
			self helmetPop();
	}
}

helmetPop()
{	
	if( !IsDefined( self.hatModel ) || !ModelHasPhysPreset( self.hatModel ) )
		return; 

	partName = GetPartName( self.hatModel, 0 ); 
	origin   = self GetTagOrigin( partName ); //self . origin +( 0, 0, 64 ); 
	angles	 = self GetTagAngles( partName ); //( -90, 0 + RandomInt( 90 ), 0 + RandomInt( 90 ) ); 

	helmetLaunch( self.hatModel, origin, angles, self.damageDir ); 

	hatModel = self.hatModel; 
	self.hatModel = undefined; 
	
	wait 0.05; 

	if( !IsDefined( self ) )
		return; 

	self detach( hatModel, "" ); 
}

helmetLaunch( model, origin, angles, damageDir )
{
	launchForce = damageDir; 
	launchForce = launchForce * RandomFloatRange( 1.1, 4.0 ); 

	forcex = launchForce[0]; 
	forcey = launchForce[1]; 
	forcez = RandomFloatRange( 0.8, 3.0 ); 

	contactPoint = self.origin +( RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ) ) * 5; 

	CreateDynEntAndLaunch( model, origin, angles, contactPoint, ( forcex, forcey, forcez ) ); 
}

//--------------------------------------------------------------------------------
// death head pop - AI_TODO - we should actually handle this with limb data eventually. Talk to character team.
//--------------------------------------------------------------------------------
headPop()
{
	if( !IS_TRUE( self.a.popHeadIfNeeded ) )
		return;
		
	if( !IsDefined( self.headModel ) )
		return; 
	
	self playsound( "chr_gib_decapitate" );
	
	self detach( self.headModel, "" ); 
	
	if( IsDefined( self.a.popHeadNotify ) )
		level notify( self.a.popHeadNotify );
}

headLaunch( model, origin, angles, damageDir )
{
	launchForce = damageDir; 
	launchForce = launchForce * RandomFloatRange( 0.5, 1.0 ); 

	forcex = launchForce[0]; 
	forcey = launchForce[1]; 
	forcez = RandomFloatRange( 0.3, 0.6 ); 

	contactPoint = self.origin +( RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ), RandomFloatRange( -1, 1 ) ) * 5; 
	
	self Detach( self.headModel );
	CreateDynEntAndLaunch( model, origin, angles, contactPoint, ( forcex, forcey, forcez ), anim._effect["animscript_gibtrail_fx"] );	
}

//--------------------------------------------------------------------------------
// death sounds
//--------------------------------------------------------------------------------
playDeathSound()
{
	if( !damageLocationIsAny( "head", "helmet" ) )
	{
		if( !shouldDieQuietly() )
		{
			self animscripts\face::SayGenericDialogue( "death" );
			
			if( IsDefined( self.team ) )
				self maps\_dds::dds_notify_mod( ( self.team != "allies" ) );
		}
	}
	else
	{
		if( self.damageLocation == "helmet" 	&& 
		    IsDefined( self.hatModel ) 			&&
			ModelHasPhysPreset( self.hatModel ) &&
			IsSubstr( self.hatmodel, "helm" ) 
		   )
		{
			self PlaySound( "prj_bullet_impact_headshot_helmet" ); 
		}
		else
		{
			self PlaySound( "prj_bullet_impact_headshot" ); 
		}

		if( IsDefined( self.team ) )
			self maps\_dds::dds_notify_mod( ( self.team != "allies" ), "headshot" );
	}
}

//--------------------------------------------------------------------------------
// Immediate Ragdoll death
//--------------------------------------------------------------------------------
doImmediateRagdollDeath()
{
	self animscripts\shared::DropAllAIWeapons();
	self.skipDeathAnim = true;  // this helps playDeathAnim() do failsafes for ragdoll failures later

	initialImpulse = 10;

	damageType = maps\_destructible::getDamageType( self.damageMod );
	if( IsDefined( self.attacker ) && self.attacker == level.player && damageType == "melee" )
	{
		initialImpulse = 5;
	}

	damageTaken = self.damagetaken;
	if ( damageType == "bullet" )
		damageTaken = max( damageTaken, 300 );

	directionScale = initialImpulse * damageTaken;
	directionUp = max( 0.3, self.damagedir[ 2 ] );
	direction = ( self.damagedir[ 0 ], self.damagedir[ 1 ], directionUp );

	if ( IsDefined( self.ragdoll_directionScale ) )
	{
		direction *= self.ragdoll_directionScale;
	}
	else
	{
		direction *= directionScale;
	}

	if ( self.forceragdollimmediate )
		direction += self.prevAnimDelta * 20 * 10;	// 20 frames/sec

	if (isdefined(self.ragdoll_start_vel))
		direction += self.ragdoll_start_vel * 10;

	self LaunchRagdoll( direction, self.damagelocation );

	// wait a bit so that the ragdoll can start before the death script tries to play a regular
	//  death animation as a failsafe - if ragdolling, the regular death anim won't do anything when called
	wait( 0.05 );
}


//--------------------------------------------------------------------------------
// Custom Death Anim
//--------------------------------------------------------------------------------
playCustomDeathAnim()
{
	if( !animHasNoteTrack( self.deathanim, "dropgun" ) && !animHasNoteTrack( self.deathanim, "fire_spray" ) ) // && !animHasNotetrack( deathAnim, "gun keep" )
	{
		self animscripts\shared::DropAllAIWeapons(); 
	}

	self thread do_gib(); 

	//thread[[anim.println]]( "Playing special death as set by self.deathanim" ); #/
	self SetFlaggedAnimKnobAll( "deathanim", self.deathanim, %root, 1, .05, 1 ); 

	if( !animHasNotetrack( self.deathanim, "start_ragdoll" ) )
	{
		self thread waitForRagdoll( getanimlength( self.deathanim ) * 0.9 ); 
	}

	self animscripts\shared::DoNoteTracks( "deathanim" ); 
	if( IsDefined( self.deathanimloop ) )
	{
		self SetFlaggedAnimKnobAll( "deathanim", self.deathanimloop, %root, 1, .05, 1 ); 

		for( ;; )
		{
			self animscripts\shared::DoNoteTracks( "deathanim" ); 
		}
	}

	return;
}
//--------------------------------------------------------------------------------
// explosive death
//--------------------------------------------------------------------------------
play_explosion_death()
{
	/#
	if( debug_explosion_death_gib() ) 
		return true;
	#/
	
	explosiveDamage = self animscripts\pain::wasDamagedByExplosive();
	explosiveDamage = explosiveDamage && ( !IsDefined(self.noExplosiveDeathAnim) || !self.noExplosiveDeathAnim );

	if( !explosiveDamage )
		return false;

	if( self.damageLocation != "none" )
		return false; 
	
	if( self.a.pose == "prone" )
		return false;
	
	wantUpwardsDeath = false;
	deathArray		 = []; 
	
	if( self.a.movement != "run" ) // non-running explosion deaths
	{	
		// upward death was for zombietron
		if( self.mayDoUpwardsDeath && GetTime() > anim.lastUpwardsDeathTime + 6000 )
		{
			deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_up_1") ); 
			deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_up_2") ); 
			wantUpwardsDeath = true;
			getExplosionGibRef( "up" ); 
		}
		else
		{
			if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) )	 // Front quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_front_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_front_2") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_front_3") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_front_4") ); 
				getExplosionGibRef( "back" ); 
			}
			else if( ( self.damageyaw > 45 ) &&( self.damageyaw <= 135 ) ) // Right quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_right_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_right_2") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_right_3") ); 
				getExplosionGibRef( "left" ); 
			}
			else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_back_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_back_2") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_back_3") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_back_4") ); 
				getExplosionGibRef( "forward" ); 
			}
			else
			{															  // Left quadrant
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_left_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_left_2") ); 
				getExplosionGibRef( "right" ); 
			}
		}
	}
	else // running explosion deaths
	{
		// upward death was for zombietron
		if( self.mayDoUpwardsDeath && GetTime() > anim.lastUpwardsDeathTime + 2000 )
		{
			deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_up_1") ); 
			deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_up_2") ); 
			wantUpwardsDeath = true;
			getExplosionGibRef( "up" ); 
		}
		else
		{
			if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) )	    // Front quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_front_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_front_2") ); 
				getExplosionGibRef( "back" ); 
			}
			else if( ( self.damageyaw > 45 ) &&( self.damageyaw <= 135 ) )	// Right quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_right_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_right_2") ); 
				getExplosionGibRef( "left" ); 
			}
			else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) )	// Back quadrant
			{
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_back_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_back_2") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_back_3") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_back_4") ); 
				getExplosionGibRef( "forward" ); 
			}
			else
			{															   // Left quadrant
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_left_1") ); 
				deathArray[deathArray.size] = tryAddDeathAnim( animArray("explode_run_left_2") ); 
				getExplosionGibRef( "right" ); 
			}
		}
	}

	deathAnim = deathArray[RandomInt( deathArray.size )]; 

	if( GetDvar( "scr_expDeathMayMoveCheck" ) == "on" )
	{
		localDeltaVector = getMoveDelta( deathAnim, 0, 1 ); 
		endPoint		 = self localToWorldCoords( localDeltaVector ); 

		if( !self mayMoveToPoint( endPoint, false ) )
		{
			if( try_gib_extended_death( anim.deathGlobals.EXPLOSION_DEATH_GIB_CHANCE ) )
				return true; 
			
			return false; 
		}
	}

	// this should really be in the notetracks
	self AnimMode( "nogravity" ); 

	if( try_gib_extended_death( anim.deathGlobals.EXPLOSION_DEATH_GIB_CHANCE ) )
		return true; 
	
	// zombietron upwards death
	if( wantUpwardsDeath )
		anim.lastUpwardsDeathTime = GetTime();
	
	play_death_anim( deathAnim ); 

	return true; 
}

getExplosionGibRef( direction )
{
	/# 
	// Gib debug
	if( GetDvarint( "gib_delay" ) > 0 )
		anim.deathGlobals.gibDelay = GetDvarint( "gib_delay" ); 

	if( GetDvar( "gib_test" ) != "" )
	{
		self.a.gib_ref = GetDvar( "gib_test" ); 
		return; 
	}
	#/

	// If already set, then use it. Useful for canned gib deaths.
	if( IsDefined( self.a.gib_ref ) )
		return; 

	// Don't gib if we haven't taken enough damage by the explosive
	// grenade damage usually range from 160 - 250, so we go above the minimum
	// so if the splash damage is near it's lowest, don't gib.
	if( self.damageTaken < anim.deathGlobals.EXPLOSION_DEATH_GIB_MIN_DAMAGE )
		return; 

	if( GetTime() > anim.deathGlobals.lastGibTime + anim.deathGlobals.gibDelay && anim.deathGlobals.totalGibs > 0 )
	{
		anim.deathGlobals.totalGibs--; 
		anim thread setLastGibTime(); 

		refs = []; 
		switch( direction )
		{
		case "right":
			refs[refs.size] = "left_arm"; 
			refs[refs.size] = "left_leg"; 

			gib_ref = get_random( refs ); 				
			break; 

		case "left":
			refs[refs.size] = "right_arm"; 
			refs[refs.size] = "right_leg"; 

			gib_ref = get_random( refs ); 				
			break; 

		case "forward":
			refs[refs.size] = "right_arm"; 
			refs[refs.size] = "left_arm"; 
			refs[refs.size] = "right_leg"; 
			refs[refs.size] = "left_leg"; 
			//refs[refs.size] = "guts"; 
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
			//refs[refs.size] = "guts"; 

			gib_ref = get_random( refs ); 
			break; 
		}

		self.a.gib_ref = gib_ref; 
	}
	else
	{
		self.a.gib_ref = undefined; 
	}
}

setLastGibTime()
{
	anim notify( "stop_last_gib_time" ); 
	anim endon( "stop_last_gib_time" ); 

	wait( 0.05 ); 
	anim.deathGlobals.lastGibTime 	 = GetTime(); 
	anim.deathGlobals.totalGibs		 = RandomIntRange( anim.deathGlobals.minGibs, anim.deathGlobals.maxGibs ); 
}

//--------------------------------------------------------------------------------
// Special deaths
//--------------------------------------------------------------------------------
// Special death is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the death for the special animation state, or false if it wants the regular 
// death function to handle it.
special_death()
{
	/#
	if( GetDvar( "scr_forceSpecialDeath" ) != "" )
	{
		self.a.special = GetDvar( "scr_forceSpecialDeath" );

		Assert(	   self.a.special == "cover_right" || self.a.special == "cover_left"
				|| self.a.special == "cover_stand" || self.a.special == "saw"
				|| self.a.special == "dying_crawl" || self.a.special == "cover_crouch" 
			   );
	}	
	#/	

	if( !shouldHandleSpecialPain() )
		return false;	
	
	switch( self.a.special )
	{
		case "cover_right":
			if( self.a.pose == "stand" || self.a.pose == "crouch" )
			{
				deathArray = animArray("cover_right_front");
				DoDeathFromArray( deathArray ); 
			}
			return true; 

		case "cover_left":
			if( self.a.pose == "stand" || self.a.pose == "crouch" )
			{
				deathArray = animArray("cover_left_front");
				DoDeathFromArray( deathArray ); 
			}
			return true; 

		case "cover_stand":
			if( self.a.pose == "stand" )
			{
				deathArray = animArray("cover_stand_front");
			}
			else
			{
				assert( self.a.pose == "crouch" ); 
				deathArray = array( animArray("cover_crouch_front_1"), animArray("cover_crouch_front_2") );
			}

			DoDeathFromArray( deathArray ); 
			return true; 

		case "cover_crouch":
			deathArray = []; 
			if( damageLocationIsAny( "head", "neck" ) &&( self.damageyaw > 135 || self.damageyaw <= -45 ) )	// Front/Left quadrant
			{
				deathArray[deathArray.size] = animArray("cover_crouch_front_1");
			}

			if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) )	// Back quadrant
			{
				deathArray[deathArray.size] = animArray("cover_crouch_back");
			}

			deathArray[deathArray.size] = animArray("cover_crouch_front_2");

			DoDeathFromArray( deathArray ); 
			return true; 

		case "cover_pillar_lean":
			deathArray = [];

			if( self.cornerDirection == "left" )
				deathArray[deathArray.size] = animArrayPickRandom("cover_pillar_left");
			else if ( self.cornerDirection == "right" )
				deathArray[deathArray.size] = animArrayPickRandom("cover_pillar_right");
			
			DoDeathFromArray( deathArray ); 
			return true; 

		case "cover_pillar":
			 deathArray = [];
			 
			 deathArray[deathArray.size] = animArrayPickRandom("cover_pillar_front");
						
			 DoDeathFromArray( deathArray ); 
			 return true; 

		case "saw":
			DoDeathFromArray( array( animArray("front") ) ); 
			return true; 

		case "dying_crawl":
			assert( self.a.pose == "prone" || self.a.pose == "back", self.a.pose );
			deathArray = animArray("crawl");
			DoDeathFromArray( deathArray ); 
			return true;
	}

	return false; 
}

shouldHandleSpecialPain()
{
	if( self.a.special == "none" )
		return false; 

	if( IS_TRUE( self.forceragdollimmediate	) )
		return false;
	
	if( wasDamagedByChargedSniperShot() )
		return false;
	
	return true;
}


//--------------------------------------------------------------------------------
// Flame deaths
//--------------------------------------------------------------------------------
play_flame_death_anim() 
{
	if(self.damagemod =="MOD_MELEE" )
		return false;
	
	if ( !is_mature() )
		return false;

	if( is_gib_restricted_build() )
		return false;

	if( !IsDefined( self.a.forceflamedeath ) || !self.a.forceflamedeath )
	{
		if( self.damagemod != "MOD_BURNED" )
			return false;
	}

	deathArray = []; 

	if( weaponIsGasWeapon( self.weapon ) )
	{
		if( self.a.pose == "crouch" )
		{
			deathArray[0] = animArray("flame_front_1");
			deathArray[1] = animArray("flame_front_2");
			deathArray[2] = animArray("flame_front_3");
			deathArray[3] = animArray("flame_front_4");
			deathArray[4] = animArray("flame_front_5");
			deathArray[5] = animArray("flame_front_6");
			deathArray[6] = animArray("flame_front_7");
			deathArray[7] = animArray("flame_front_8");
		}
		else
		{
			deathArray[0] = animArray("flame_front_2");
		}
	}
	else
	{
		if( self.a.pose == "prone" )
		{
			deathArray[0] = get_death_anim(); 
		}
		else if( self.a.pose == "back" )
		{
			deathArray[0] = get_death_anim(); 
		}
		else if( self.a.pose == "crouch" )
		{
			deathArray[0] = animArray("flame_front_1");
			deathArray[1] = animArray("flame_front_2");
			deathArray[2] = animArray("flame_front_3");
			deathArray[3] = animArray("flame_front_4");
			deathArray[4] = animArray("flame_front_5");
			deathArray[5] = animArray("flame_front_6");
			deathArray[6] = animArray("flame_front_7");
			deathArray[7] = animArray("flame_front_8");
		}
		else
		{
			deathArray[0] = animArray("flame_front_1");
			deathArray[1] = animArray("flame_front_2");
			deathArray[2] = animArray("flame_front_3");
			deathArray[3] = animArray("flame_front_4");
			deathArray[4] = animArray("flame_front_5");
			deathArray[5] = animArray("flame_front_6");
			deathArray[6] = animArray("flame_front_7");
			deathArray[7] = animArray("flame_front_8");
			deathArray[8] = animArray("flameA_start");
			deathArray[9] = animArray("flameB_start");
		}
	}

	if( deathArray.size == 0 )
	{
		/#
			println( "^3ANIMSCRIPT WARNING: None of the Flame-Deaths exist!!" );
		#/

		return false; 
	}

	deathArray = animscripts\pain::removeBlockedAnims( deathArray ); 

	if( deathArray.size == 0 )
	{
		/#
			println( "^3ANIMSCRIPT WARNING: All of the Flame-Death Animations are blocked by geometry, cannot use any!!" ); 
		#/

		return false; 
	}
			
	randomChoice = RandomInt( deathArray.size );
	self thread flame_death_fx();

	play_death_anim( deathArray[randomChoice] ); 
	return true; 
}

flame_death_fx()
{
	self endon( "death" );

	if ( IS_TRUE(self.is_on_fire) )
		return;

	self.is_on_fire = true;

	self thread on_fire_timeout();

	// flamethrower AI charring
	if(IsDefined(level.ACTOR_CHARRING_CLIENT_FLAG))
		self SetClientFlag(level.ACTOR_CHARRING_CLIENT_FLAG);

	self StartTanning();

	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_torso"] ) )
	{
		PlayFxOnTag( level._effect["character_fire_death_torso"], self, "J_SpineLower" ); 
	}
	else
	{
		/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_torso\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_torso\"" ); 
		#/
	}

	if( IsDefined( level._effect ) && IsDefined( level._effect["character_fire_death_sm"] ) )
	{
		wait 1;

		tagArray = []; 
		tagArray[0] = "J_Elbow_LE"; 
		tagArray[1] = "J_Elbow_RI"; 
		tagArray[2] = "J_Knee_RI"; 
		tagArray[3] = "J_Knee_LE"; 
		tagArray = randomize_array( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 

		wait 1;

		tagArray[0] = "J_Wrist_RI"; 
		tagArray[1] = "J_Wrist_LE"; 
		if( !IsDefined( self.a.gib_ref ) || self.a.gib_ref != "no_legs" )
		{
			tagArray[2] = "J_Ankle_RI"; 
			tagArray[3] = "J_Ankle_LE"; 
		}

		tagArray = randomize_array( tagArray ); 

		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[0] ); 
		PlayFxOnTag( level._effect["character_fire_death_sm"], self, tagArray[1] ); 
	}
	else
	{
		/#
		println( "^3ANIMSCRIPT WARNING: You are missing level._effect[\"character_fire_death_sm\"], please set it in your levelname_fx.gsc. Use \"env/fire/fx_fire_player_sm\"" ); 
		#/
	}	
}

on_fire_timeout()
{
	self endon ("death");

	// about the length of the flame fx
	wait 12;

	if (IsDefined(self) && IsAlive(self))
	{
		self.is_on_fire = false;
		self notify ("stop_flame_damage");
	}

}

//--------------------------------------------------------------------------------
// Gas deaths
//--------------------------------------------------------------------------------
play_gas_death_anim() 
{
	if( !IsDefined( self.a.forcegasdeath ) || !self.a.forcegasdeath )
	{
		if( self.damagemod != "MOD_GAS" )
				return false;
	}

	deathArray = []; 
	if( self.a.pose == "stand" || self.a.pose == "crouch" )
	{
		deathArray[0] = animArray("gas_front_1");
		deathArray[1] = animArray("gas_front_2");
		deathArray[2] = animArray("gas_front_3");
		deathArray[3] = animArray("gas_front_4");
		deathArray[4] = animArray("gas_front_5");
		deathArray[5] = animArray("gas_front_6");
		deathArray[6] = animArray("gas_front_7");
		deathArray[7] = animArray("gas_front_8");
		deathArray[8] = animArray("gasA_start");
		deathArray[9] = animArray("gasB_start");
	}
	else
	{
		deathArray[0] = get_death_anim(); 
	}
	
	if( deathArray.size == 0 )
	{
		/#
		println( "^3ANIMSCRIPT WARNING: None of the Gas-Deaths exist!!" ); 
		#/
		return false; 
	}

	deathArray = animscripts\pain::removeBlockedAnims( deathArray ); 

	if( deathArray.size == 0 )
	{
		/#
		println( "^3ANIMSCRIPT WARNING: All of the Gas-Death Animations are blocked by geometry, cannot use any!!" ); 
		#/
		return false; 
	}

	// make these anims interruptable
	self.a.allowDeathShortCircuit = true;	
	
	randomChoice = RandomInt( deathArray.size );

	deathAnim = deathArray[randomChoice];
	play_death_anim( deathAnim ); 

	return true; 
}

//--------------------------------------------------------------------------------
// Bullet gib deaths
//--------------------------------------------------------------------------------
play_bulletgibbed_death_anim()
{
	const MIN_DAMAGE_FOR_GIBBING	= 50;  // minimum damage required for gibbing, unless hit by shotgun or force_gib is true
	const SNIPER_GIB_CHANCE			= 70; // sniper has 30% chance within maxGibDist from GDT
	const SPECIAL_GIB_WEAPON_CHANCE	= 100; // special gib weapon has 100% chance within maxGibDist from GDT
	const FORCE_GIB_CHANCE			= 100; // force gib has 100% chance, distance does not matter
		
	const SHOTGUN_SMALL_RANGE_DISTSQ	    = 110 * 110;
	const SHOTGUN_MED_RANGE_DISTSQ		    = 200 * 200;
	const SHOTGUN_LONG_RANGE_DISTSQ			= 270 * 270;
	const SHOTGUN_EXTRA_LONG_RANGE_DISTSQ 	= 330 * 300;
	const SHOTGUN_EXTRA_LONG_RANGE_DIST		= 330; // used as maxGibDist
	
	if( !shouldPlayBulletGibbedDeath() )
		return false;

	force_gib		      = IsDefined( self.force_gib ) && self.force_gib;
	self.a.gib_ref	      = undefined;
	enough_damage_for_gib = self.damagetaken >= MIN_DAMAGE_FOR_GIBBING;
	distSquared			  = DistanceSquared( self.origin, self.attacker.origin ); 
	gib_chance			  = FORCE_GIB_CHANCE; // start with 100% and take it from there

	if( force_gib )											// force gib
	{
		// no need to do anything
	}
	else if( WeaponClass( self.damageWeapon ) == "spread" ) // shotgun
	{
		maxDist = SHOTGUN_EXTRA_LONG_RANGE_DIST;

		if( distSquared < SHOTGUN_SMALL_RANGE_DISTSQ )
			gib_chance = 100;
		else if( distSquared < SHOTGUN_MED_RANGE_DISTSQ )
			gib_chance = 75;
		else if( distSquared < SHOTGUN_LONG_RANGE_DISTSQ )
			gib_chance = 50;
		else if( distSquared < SHOTGUN_EXTRA_LONG_RANGE_DISTSQ )
			gib_chance = 25;
		else
			return false;	// too far for a shotgun to gib
	}
	else if( isSniperRifle( self.damageWeapon ) && enough_damage_for_gib )	// draganov or any other sniper
	{
		maxDist	   = WeaponMaxGibDistance( self.damageWeapon );
		gib_chance = SNIPER_GIB_CHANCE;
	}
	else if( WeaponDoGibbing( self.damageWeapon ) && enough_damage_for_gib ) // generic gib weapon such as MG's, set from GDT
	{
		maxDist	   = WeaponMaxGibDistance( self.damageWeapon );
		gib_chance = SPECIAL_GIB_WEAPON_CHANCE;
	}
	else
	{
		// gib not supported for the damage weapon
		return false;
	}
			
	// can gib if either force_gib is set or the conditions are met
	canGib = force_gib || ( !force_gib && RandomInt( 100 ) <= gib_chance && distSquared < maxDist * maxDist && ( GetTime() > anim.deathGlobals.lastGibTime + anim.deathGlobals.gibDelay ) );
	
	if( canGib )
	{
		 getBulletGibRef();
		 anim.deathGlobals.lastGibTime = GetTime(); 
	}
		
	const range		  = 0.6; 
	const nrange	  = -0.6; 
	self.gib_vel  = self.damagedir * RandomFloatRange( 0.5, 0.9 ); 
	self.gib_vel += ( RandomFloatRange( nrange, range ), RandomFloatRange( nrange, range ), RandomFloatRange( 0.4, 1.0 ) ); 

	// extended gib death
	
	if( try_gib_extended_death( anim.deathGlobals.EXTENDED_DEATH_GIB_CHANCE ) )
		return true; 

	// regular death with gib
	deathAnim = get_death_anim(); 
	play_death_anim( deathAnim ); 

	return true; 
}

shouldPlayBulletGibbedDeath()
{
	if ( IS_TRUE( self.no_gib ) )
		return false;
		
	if( self.damagemod == "MOD_MELEE" )
		return false; 
	
	if( !IsDefined( self.attacker ) || !IsDefined( self.damageLocation ) )
		return false; 

	// if no damageweapon is defined and also not setup for force_gib then don't gib
	force_gib  = IsDefined( self.force_gib ) && self.force_gib;
	if( !IsDefined(self.damageWeapon) || ( IsDefined(self.damageWeapon) && self.damageWeapon == "none" ) )
	{
		if( !force_gib )
			return false;
	}

	return true;
}

getBulletGibRef()
{
	refs = []; 
	switch( self.damageLocation )
	{
	case "torso_upper":
	case "torso_lower":
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

	if( IsDefined( self.custom_gib_refs ) )
		refs = self.custom_gib_refs;

	if( refs.size )
		self.a.gib_ref = get_random( refs ); 

	return self.a.gib_ref; // in case need to store somewhere else
}

//--------------------------------------------------------------------------------
// Machete/similar weapon deaths
//--------------------------------------------------------------------------------
play_machete_melee_gib_death_anim()
{
	if( !shouldPlayMacheteGibbedDeath() )
		return false;
	
	// force head gib when player is charging with machete, as level wants
	const FORCE_CHARGED_HEAD_GIB_CHANCE = 100;
	shouldForceHeadGib = self.attacker isMeleeCharged() && ( self.attacker GetStance() == "stand" );
	shouldForceHeadGib = shouldForceHeadGib && ( RandomInt( 100 ) <= FORCE_CHARGED_HEAD_GIB_CHANCE );
	
	getMacheteGibRef( shouldForceHeadGib );
	anim.deathGlobals.lastGibTime = GetTime(); 
	
	self.a.popHeadIfNeeded = true;
		
	if( IsDefined( self.a.gib_ref ) )
	{
	  if( self.a.gib_ref == "head" )
	   	self.a.popHeadNotify = "machete_gib_head";
	
	  level notify( "machete_gib_" + self.a.gib_ref );
	}
	
	const range		  = 0.6; 
	const nrange	  = -0.6; 
	self.gib_vel  = self.damagedir * RandomFloatRange( 0.5, 0.9 ); 
	self.gib_vel += ( RandomFloatRange( nrange, range ), RandomFloatRange( nrange, range ), RandomFloatRange( 0.4, 1.0 ) ); 
	
	// extended gib death
	if( self.a.gib_ref != "head" )
	{
	   if( try_gib_extended_death( anim.deathGlobals.EXTENDED_DEATH_GIB_CHANCE ) )
		return true; 
	}

	// regular death with gib
	deathAnim = get_death_anim(); 
	play_death_anim( deathAnim ); 

	return true; 
}

shouldPlayMacheteGibbedDeath()
{
	if( self.damagemod != "MOD_MELEE" )
		return false; 

	if( IS_TRUE( self.no_gib ) )
		return false;

	if( !IsDefined( self.attacker ) || !IsDefined( self.damageLocation ) )
		return false; 

	if( !IsPlayer(self.attacker) )
		return false; 

	// We assume that player can only have one melee weapon at a time and machete like weapon is setup as a melee weapon
	// otherwise we have to change this script to check for damageweapon instead.
	if( !self.attacker hasMacheteLikeWeapon() )
		return false;
	
	// if no damageweapon is defined and also not setup for force_gib then don't gib
	if( !IsDefined(self.damageWeapon) || ( IsDefined(self.damageWeapon) && self.damageWeapon == "none" ) )
	{
		if( IS_FALSE( self.force_gib ) )
			return false;
	}

	return true;		
}

hasMacheteLikeWeapon()
{
	if( self HasWeapon("riotshield_sp") )
		return false;
	
	// add more machete like melee weapons in here if needed
	if( self HasWeapon( "machete_sp" ) && WeaponDoGibbing( "machete_sp" ) )
		return true;
	
	return false;
}

getMacheteGibRef( shouldForceHeadGib )
{
	refs = []; 
	
	const UNFORCED_MACHETE_HEAD_GIB_CHANCE = 50;
	
	if( IS_TRUE( shouldForceHeadGib ) )
	{
		refs[refs.size] = "head"; 
	}
	else
	{
		switch( self.damageLocation )
		{
			case "helmet":
			case "head":
			case "neck":
			case "torso_upper":
				if( RandomInt(100) < UNFORCED_MACHETE_HEAD_GIB_CHANCE )
				{
					refs[refs.size] = "head"; 
				}
				else
				{
					refs[refs.size] = "right_arm"; 
					refs[refs.size] = "left_arm"; 
				}
				break; 
			case "torso_lower":
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
		}
	}

	if( IsDefined( self.custom_gib_refs ) )
		refs = self.custom_gib_refs;

	if( refs.size )
		self.a.gib_ref = get_random( refs ); 

	return self.a.gib_ref; // in case need to store somewhere else
}


//--------------------------------------------------------------------------------
// Sword gib deaths - Ideally, this can be combined with machete but as there are 
// some specific requests for afghanistan, currently kept seperate.
//--------------------------------------------------------------------------------
play_sword_melee_gib_death_anim()
{
	if( !shouldPlaySwordGibbedDeath() )
		return false;

	self.a.gib_ref	      = undefined;
			
	getSwordGibRef();
	anim.deathGlobals.lastGibTime = GetTime(); 
	
	if( IS_TRUE( self.attacker.is_on_horse ) )
	{
		self.a.popHeadIfNeeded = true;
		self.a.popHeadNotify = "sword_head_gib";
	}
	
	const range		  = 0.6; 
	const nrange	  = -0.6; 
	self.gib_vel  = self.damagedir * RandomFloatRange( 0.5, 0.9 ); 
	self.gib_vel += ( RandomFloatRange( nrange, range ), RandomFloatRange( nrange, range ), RandomFloatRange( 0.4, 1.0 ) ); 
	
	// extended gib death
	if( try_gib_extended_death( anim.deathGlobals.EXTENDED_DEATH_GIB_CHANCE ) )
		return true; 
	
	// regular death with gib
	deathAnim = get_death_anim(); 
	play_death_anim( deathAnim ); 

	return true; 
}

shouldPlaySwordGibbedDeath()
{	
	if( self.damagemod != "MOD_MELEE" )
		return false; 

	if( IS_TRUE( self.no_gib ) )
		return false;
	
	if( !IsDefined( self.attacker ) || !IsDefined( self.damageLocation ) )
		return false; 
	
	if( !IsPlayer(self.attacker) )
		return false; 
	
	if( self.attacker HasWeapon("riotshield_sp") )
		return false;

	if( !self.attacker HasWeapon( "pulwar_sword_sp" ) || !WeaponDoGibbing( "pulwar_sword_sp" ) )
		return false;
	
	// if no damageweapon is defined and also not setup for force_gib then don't gib
	if( !IsDefined(self.damageWeapon) || ( IsDefined(self.damageWeapon) && self.damageWeapon == "none" ) )
	{
		if( IS_FALSE( self.force_gib ) )
			return false;
	}
	
		
	return true;
}

getSwordGibRef()
{		
	const CHANCE_FOR_ARM_GIB = 50;
	
	a_refs = []; 	   
	switch( self.damagelocation )
	{
		case "right_arm_upper":
		case "right_arm_lower":
		case "right_hand":
			self.torsoDmg5 = self.torsoDmg1;	// BJoyal remove this once we have proper torsos for head removal. CP (12/8/11) - need this also for horseback override
			a_refs[a_refs.size] = "right_arm"; 
			break; 
		case "left_arm_upper":
		case "left_arm_lower":
		case "left_hand":
			self.torsoDmg5 = self.torsoDmg1;	// BJoyal remove this once we have proper torsos for head removal. CP (12/8/11) need this also for horseback override
			a_refs[a_refs.size] = "left_arm"; 
			break; 
		case "torso_upper":
		case "helmet":
		case "head":
		case "neck":
			self.torsoDmg5 = self.torsoDmg1;	// BJoyal (10/13/11) remove this once we have proper torsos for head removal
			a_refs[a_refs.size] = "head"; 
			break; 
			
		default:
			self.torsoDmg5 = self.torsoDmg1;	// BJoyal remove this once we have proper torsos for head removal. CP (12/8/11) need this also for horseback override
			break;
	}
	
	//Force a gib when player is on horseback
	if( isdefined( self.attacker.is_on_horse ) )//assumes Player is the attacker since getSwordGibRef checks
	{
		if( self.attacker.is_on_horse )
		{
			if(!isdefined(self.custom_gib_refs) )
			{
				self.custom_gib_refs = [];
			}
			self.custom_gib_refs[self.custom_gib_refs.size] = "head";//Piggyback on script_forcegib to force desired gib	
			if( randomint( 100 ) < CHANCE_FOR_ARM_GIB )//Sometimes add the possibility of an arm gib instead
			{
				self.custom_gib_refs[self.custom_gib_refs.size] = "right_arm";
			}
			if( randomint( 100 ) < CHANCE_FOR_ARM_GIB )//Sometimes add the possibility of an arm gib instead
			{
				self.custom_gib_refs[self.custom_gib_refs.size] = "left_arm";
			}			
		}
	}	
	
	if( IsDefined( self.custom_gib_refs ) )
		a_refs = self.custom_gib_refs;
	
	if( a_refs.size )
		self.a.gib_ref = get_random( a_refs ); 
		
	return self.a.gib_ref; // in case need to store somewhere else
}


//--------------------------------------------------------------------------------
// Taser Knuckle melee deaths
//--------------------------------------------------------------------------------
play_tazer_melee_death_anim()
{
	if( !shouldPlayTazerDeath() )
		return false;

	deathArray = []; 

	if( shouldDoRunningForwardDeath() )	
		deathArray = animArray( "tazer_running" );
	else if( self.a.pose == "stand" || self.a.pose == "crouch" )
		deathArray = animArray( "tazer" );
	
	if( deathArray.size == 0 )
	{
		/#println( "^3ANIMSCRIPT WARNING: None of the tazer-deaths exist!!" );#/
		return false; 
	}

	deathArray = animscripts\pain::removeBlockedAnims( deathArray ); 

	if( deathArray.size == 0 )
		return false; 
	
	randomChoice = RandomInt( deathArray.size );

	deathAnim = deathArray[randomChoice];
	play_death_anim( deathAnim ); 

	return true; 
}

shouldPlayTazerDeath()
{	
	if( self.damagemod != "MOD_MELEE" )
		return false; 
	
	if( !IsDefined( self.attacker ) || !IsDefined( self.damageLocation ) )
		return false; 
	
	if( !IsPlayer(self.attacker) )
		return false; 
	
	if( self.attacker HasWeapon( "riotshield_sp" ) )
	   return false;

	if( !self.attacker HasWeapon( "tazer_knuckles_sp" ) )
		return false;
		
	return true;
}

//--------------------------------------------------------------------------------
// vehicle hit death
//--------------------------------------------------------------------------------
play_hit_by_vehicle_anim()
{
	if( self.damagemod == "MOD_CRUSH" )
	{
		// play an anim just in case ragdoll fails
		deathAnim = get_death_anim(); 
		self thread play_death_anim( deathAnim ); 

		self thread do_gib(); 
		self launch_ragdoll_based_on_damage_type();
		wait 0.5;

		return true; 
	}

	return false;
}

//--------------------------------------------------------------------------------
// Generic deaths
//--------------------------------------------------------------------------------
// SUMEET_TODO - port over getStrongBulletDamageDeathAnim once the animations from MW3 are ported over and
// make sure to compare MW3 strong bullet animations with getStandPowerDeathAnimArray() animations that we have created
get_death_anim()
{
	if( self.a.pose == "stand" )
	{
		if( shouldDoRunningForwardDeath() )
		{
			return getRunningForwardDeathAnim(); 
		}

		return getStandDeathAnim(); 
	}
	else if( self.a.pose == "crouch" )
	{
		return getCrouchDeathAnim(); 
	}
	else if( self.a.pose == "prone" )
	{
		return getProneDeathAnim(); 
	}
	else
	{
		assert( self.a.pose == "back" ); 
		return getBackDeathAnim(); 
	}
}


//--------------------------------------------------------------------------------
// Running forward deaths
//--------------------------------------------------------------------------------
getRunningForwardDeathAnim()
{
	deathArray = []; 

	if( WeaponClass( self.damageWeapon ) == "spread" )
	{
		deathArray = getStandSpreadDeathAnimArray();
	}
	else if( animscripts\combat_utility::isSniperRifle(self.damageWeapon) )
	{
		deathArray = getStandSniperDeathAnimArray();
	}
	else if( animscripts\combat_utility::isCrossbow(self.damageWeapon) )
	{
		deathArray = getRunCrossbowDeathAnimArray();
	}
	else
	{
		deathArray[deathArray.size] = animArray("run_back_1", "death");
		deathArray[deathArray.size] = animArray("run_back_2", "death");

		if( ( self.damageyaw >= 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
		{
			deathArray[deathArray.size] = animArray("run_front_1", "death");
			deathArray[deathArray.size] = animArray("run_front_2", "death");
		}
		else if( ( self.damageyaw >= -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
		{
			deathArray[deathArray.size] = animArray("run_back_1", "death");
			deathArray[deathArray.size] = animArray("run_back_2", "death");
		}
	}

	ArrayRemoveValue( deathArray, undefined ); 
	deathArray = animscripts\pain::removeBlockedAnims( deathArray );

	if( !deathArray.size )
		return getStandDeathAnim(); 
	
	return deathArray[RandomInt( deathArray.size )]; 
}

//--------------------------------------------------------------------------------
// Stand deaths
//--------------------------------------------------------------------------------
getStandDeathAnim()
{
	deathArray = []; 

	if( weaponAnims() == "pistol" )
	{
		deathArray = getStandPistolDeathAnimArray();
	}
	else if( weaponIsGasWeapon( self.weapon ) )
	{
		deathArray[deathArray.size] = animArray("front", "death"); 
	}
	else if( self usingRocketLauncher() && IS_TRUE( self.dofiringdeath ) ) 
	{
		// for indoor AI's we dont want firing RPG deaths that can cause un-intended slpash damage
		deathArray = getStandRPGDeathAnimArray();
	}
	else if( WeaponClass( self.damageWeapon ) == "spread" )
	{
		deathArray = getStandSpreadDeathAnimArray();
	}
	else if( animscripts\combat_utility::isSniperRifle(self.damageWeapon) )
	{
		deathArray = getStandSniperDeathAnimArray();
	}
	else if( animscripts\combat_utility::isCrossbow(self.damageWeapon) )
	{
		deathArray = getStandCrossbowDeathAnimArray();
	}
	else
	{
		// torso or legs
		if( damageLocationIsAny( "torso_lower", "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArray("groin", "death");
			deathArray[deathArray.size] = animArray("gutshot", "death");
			deathArray[deathArray.size] = animArray("crotch", "death");
			deathArray[deathArray.size] = animArray("guts", "death");
			deathArray[deathArray.size] = animArray("leg", "death");
		}
		// torso only
		else if( damageLocationIsAny( "torso_upper", "torso_lower" ) )
		{
			deathArray[deathArray.size] = animArray("torso_start", "death");
			deathArray[deathArray.size] = animArray("deadfallknee", "death");
			deathArray[deathArray.size] = animArray("forwardtoface", "death");

			if( damageLocationIsAny( "torso_upper" ) )
			{
				deathArray[deathArray.size] = animArray("nerve", "death");
				deathArray[deathArray.size] = animArray("tumbleforward", "death");
				deathArray[deathArray.size] = animArray("fallside", "death");
			}
		}
		// headshots
		else if( damageLocationIsAny( "head", "helmet" ) )
		{
			deathArray[deathArray.size] = animArray("head_1", "death");
			deathArray[deathArray.size] = animArray("head_2", "death");
			deathArray[deathArray.size] = animArray("collapse", "death");
		}
		// neck
		else if( damageLocationIsAny( "neck" ) )
		{
			deathArray[deathArray.size] = animArray("neckgrab", "death");
			deathArray[deathArray.size] = animArray("neckgrab2", "death");
		}

		// extended deaths
		if( longDeathAllowed() )
		{
			if( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "left_foot" ) )
			{
				deathArray[deathArray.size] = animArray("left_leg_start", "death");
			}
			else if( damageLocationIsAny( "right_leg_upper", "right_leg_lower", "right_foot" ) )
			{
				deathArray[deathArray.size] =  animArray("right_leg_start", "death");
			}
		}

		// directional deaths
		if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
		{
			// firing deaths
			if( damageLocationIsAny( "torso_upper", "left_arm_upper", "right_arm_upper" ) )	
			{	
				if( firingDeathAllowed() && RandomInt(100) < 35 )
				{
					deathArray[deathArray.size] = animArray("firing_1", "death");
					deathArray[deathArray.size] = animArray("firing_2", "death");
				}
			}

			if ( damageLocationIsAny( "neck", "head", "helmet" ) )
			{
				deathArray[ deathArray.size ] = animArray("face", "death");
				deathArray[ deathArray.size ] = animArray("headshot_slowfall", "death");
				deathArray[ deathArray.size ] = animArray("head_straight_back", "death");
			}
			else if ( damageLocationIsAny( "torso_upper" ) )
			{
				deathArray[ deathArray.size ] = animArray("tumbleback", "death");
				deathArray[ deathArray.size ] = animArray("chest_stunned", "death");
				deathArray[ deathArray.size ] = animArray("fall_to_knees_2", "death");
			}
			else if ( damageLocationIsAny( "left_arm_upper" ) )
			{
				deathArray[deathArray.size] = animArray("shoulder_stumble", "death");
				deathArray[deathArray.size] = animArray("shoulder_spin", "death");
				deathArray[deathArray.size] = animArray("shoulderback", "death");
			}
		}
		else if( ( self.damageyaw > 45 ) &&( self.damageyaw <= 135 ) ) // Right quadrant
		{
			if( damageLocationIsAny( "torso_upper", "right_arm_upper", "head" ) )	
			{
				deathArray[deathArray.size] = animArray("fallforward", "death");
			}

			deathArray[deathArray.size] = animArray("fall_to_knees_2", "death");
		}
		else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
		{
			if( weaponIsGasWeapon( self.weapon ) )
			{
				deathArray = []; 
				deathArray[0] = animArray("back", "death");
			}
			else
			{
				deathArray[deathArray.size] = animArray("fall_to_knees_1", "death");
				deathArray[deathArray.size] = animArray("fall_to_knees_2", "death");
				deathArray[deathArray.size] = animArray("stumblefall", "death");
			}
		}
		else // Left quadrant
		{
			if( damageLocationIsAny( "torso_upper", "left_arm_upper", "head" ) )	
			{
				deathArray[deathArray.size] = animArray("twist", "death");
				deathArray[deathArray.size] = animArray("fallforward_b", "death");
			}

			deathArray[deathArray.size] = animArray("fall_to_knees_2", "death");
		}

		if( deathArray.size < 2 || RandomInt( 100 ) < 15 )
		{
			deathArray[deathArray.size] = animArray("front", "death");
			deathArray[deathArray.size] = animArray("groin", "death");
			deathArray[deathArray.size] = animArray("fall_to_knees_1", "death");
		}

		assert( deathArray.size > 0, deathArray.size ); 
	}

	ArrayRemoveValue( deathArray, undefined ); 


	if( deathArray.size == 0 )
		deathArray[deathArray.size] = animArray("front", "death");

	return deathArray[RandomInt( deathArray.size )]; 
}

//--------------------------------------------------------------------------------
// RPG stand deaths
//--------------------------------------------------------------------------------
getStandRPGDeathAnimArray()
{
	deathArray = []; 

	deathArray[deathArray.size] = animArray("front", "death");
	deathArray[deathArray.size] = animArray("stagger", "death");

	return deathArray;
}

//--------------------------------------------------------------------------------
// Pistol deaths
//--------------------------------------------------------------------------------
getStandPistolDeathAnimArray()
{
	deathArray = []; 

	if( abs( self.damageYaw ) < 50 )
	{
		deathArray[deathArray.size] = animArray("back", "death"); // falls forwards
	}
	else
	{
		if( abs( self.damageYaw ) < 110 )
		{
			deathArray[deathArray.size] = animArray("back", "death"); // falls forwards
		}

		if( damageLocationIsAny( "torso_lower", "torso_upper", "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower" ) )
		{
			deathArray[deathArray.size] = animArray("groin", "death"); // hit in groin from front
			if( !damageLocationIsAny( "torso_upper" ) )
			{
				deathArray[deathArray.size] = animArray("groin", "death"); //( twice as likely )
			}
		}

		if( !damageLocationIsAny( "head", "neck", "helmet", "left_foot", "right_foot", "left_hand", "right_hand", "gun" ) && RandomInt( 2 ) == 0 )
		{
			deathArray[deathArray.size] = animArray("head", "death"); // hit at top and falls backwards, but more dragged out
		}

		if( deathArray.size == 0 || damageLocationIsAny( "torso_lower", "torso_upper", "neck", "head", "helmet", "right_arm_upper", "left_arm_upper" ) )
		{
			deathArray[deathArray.size] = animArray("front", "death"); // falls backwards
		}
	}

	return deathArray;
}

//--------------------------------------------------------------------------------
// Power/Shotgun/Spread Stand deaths
//--------------------------------------------------------------------------------
getStandSpreadDeathAnimArray()
{
	deathArray = [];

	if( damageLocationIsAny( "neck" ) )
	{
		deathArray[deathArray.size] = animArray("neckgrab", "death");
		deathArray[deathArray.size] = animArray("neckgrab2", "death");
	}

	if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArray("faceplant", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArray("armslegsforward", "death");
			deathArray[deathArray.size] = animArrayPickRandom("flyback", "death");
			deathArray[deathArray.size] = animArrayPickRandom("flyback_far", "death");
			deathArray[deathArray.size] = animArray("jackiespin_inplace", "death");
			deathArray[deathArray.size] = animArrayPickRandom("heavy_flyback", "death");
			deathArray[deathArray.size] = animArray("chest_blowback", "death");
			deathArray[deathArray.size] = animArray("chest_spin", "death");
		}
	}
	else if( ( self.damageyaw > 45 ) &&( self.damageyaw <= 135 ) ) // Right quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArrayPickRandom("legsout_right", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArrayPickRandom("jackiespin_left", "death");
			deathArray[deathArray.size] = animArray("chest_spin", "death");
		}
	}
	else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArray("gib_no_legs_start", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArrayPickRandom("jackiespin_vertical", "death");
			deathArray[deathArray.size] = animArray("faceplant", "death");
		}
	}
	else // Left quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArrayPickRandom("legsout_left", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArrayPickRandom("jackiespin_right", "death");
		}
	}

	assert( deathArray.size > 0, deathArray.size ); 

	return deathArray;
}

//--------------------------------------------------------------------------------
// Sniper/Charged Sniper deaths
//--------------------------------------------------------------------------------
getStandSniperDeathAnimArray()
{
	deathArray = [];
	
	if( wasDamagedByChargedSniperShot() )
	{
		deathArray = getStandChargedSniperDeathAnimArray();
			
		if( deathArray.size > 0 )
			return deathArray;
	}
		
	if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArray("faceplant", "death");
		}
		else if( damageLocationIsAny( "torso_upper", "neck", "head", "helmet" ) )
		{
			deathArray[deathArray.size] = animArrayPickRandom("upontoback", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArrayPickRandom("flatonback", "death");
		}
	}
	else if( ( self.damageyaw > 45 ) &&( self.damageyaw <= 135 ) ) // Right quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArrayPickRandom("legsout_right", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArrayPickRandom("legsout_left", "death");
		}
	}
	else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArray("gib_no_legs_start", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArray("faceplant", "death");
		}
	}
	else // Left quadrant
	{
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower",  "right_leg_upper", "right_leg_lower" )	 )
		{
			deathArray[deathArray.size] = animArrayPickRandom("legsout_left", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArrayPickRandom("legsout_right", "death");
		}
	}

	assert( deathArray.size > 0, deathArray.size ); 

	return deathArray;
}

getStandChargedSniperDeathAnimArray()
{
	Assert( IsChargedShotSniperRifle( self.damageWeapon ) );
	
	const EXPLOSIVE_CHARGE_SHOT_LEVEL_LOW  = 2;
	const EXPLOSIVE_CHARGE_SHOT_LEVEL_HIGH = 3;
	const EXPLOSIVE_CHARGE_SHOT_LEVEL_FULL = 5;
	
	weaponCharged 	   = IsDefined( self.attacker.chargeShotLevel ) && self.attacker.chargeShotLevel >= EXPLOSIVE_CHARGE_SHOT_LEVEL_LOW;
	weaponFullyCharged = weaponCharged && self.attacker.chargeShotLevel >= EXPLOSIVE_CHARGE_SHOT_LEVEL_FULL;
	
	if( weaponFullyCharged )
		self.a.tryHeadShotSlowMo = true;
	
	// its usually in notetracks but still in case if its not there.
	self AnimMode( "nogravity" ); 	
	
	deathArray = [];
	
	if( !weaponCharged )
	{
		deathArray[deathArray.size] = animArrayPickRandom("sniper_uncharged", "death");
	}
	else
	{
		if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) 	// Front quadrant
		{
			if( self.attacker.chargeShotLevel >= EXPLOSIVE_CHARGE_SHOT_LEVEL_HIGH || IS_TRUE(self.forceChargedSniperDeath) )
				deathArray[deathArray.size] = animArrayPickRandom("charged_front_high", "death");	
			else
				deathArray[deathArray.size] = animArrayPickRandom("charged_front_low", "death");	
		}
		else if( ( self.damageyaw > 45 ) &&( self.damageyaw <= 135 ) ) // Right quadrant
		{
			deathArray[deathArray.size] = animArrayPickRandom("charged_right", "death");
		}
		else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
		{
			deathArray[deathArray.size] = animArrayPickRandom("charged_back", "death");
		}
		else 														   // Left quadrant
		{
			deathArray[deathArray.size] = animArrayPickRandom("charged_left", "death");
		}
	}
	
	assert( deathArray.size > 0, deathArray.size ); 
		
	deathArray = animscripts\pain::removeBlockedAnims( deathArray );

	return deathArray;
}

//--------------------------------------------------------------------------------
// Crossbow deaths
//--------------------------------------------------------------------------------
getStandCrossbowDeathAnimArray()
{
	deathArray = [];

	if( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "left_foot" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_l_leg", "death");
		deathArray[deathArray.size] = animArray("left_leg_start", "death");
	}
	else if( damageLocationIsAny( "right_leg_upper", "right_leg_lower", "right_foot" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_r_leg", "death");
		deathArray[deathArray.size] = animArray("right_leg_start", "death");
	}
	else if( damageLocationIsAny( "left_arm_upper", "left_arm_lower", "left_hand" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_l_arm", "death");
	}
	else if( damageLocationIsAny( "right_arm_upper", "right_arm_lower", "right_arm" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_r_arm", "death");
	}
	else if( damageLocationIsAny( "neck" ) )
	{
		deathArray[deathArray.size] = animArray("neckgrab", "death");
		deathArray[deathArray.size] = animArray("neckgrab2", "death");
	}
	else if( damageLocationIsAny( "head", "helmet" ) )
	{
		deathArray[deathArray.size] = animArray("head_1", "death");
		deathArray[deathArray.size] = animArray("head_2", "death");
		deathArray[deathArray.size] = animArray("collapse", "death");
	}
	else if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
	{
		deathArray[deathArray.size] = animArray("crossbow_front", "death");
		deathArray[deathArray.size] = animArray("front", "death");
		deathArray[deathArray.size] = animArray("front_2", "death");
	}
	else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
	{
		deathArray[deathArray.size] = animArray("crossbow_back", "death");
		deathArray[deathArray.size] = animArray("fall_to_knees_1", "death");
		deathArray[deathArray.size] = animArray("fall_to_knees_2", "death");
		deathArray[deathArray.size] = animArray("stumblefall", "death");
	}
	else
	{
		deathArray[deathArray.size] = animArray("front", "death");
		deathArray[deathArray.size] = animArray("front_2", "death");
	}

	assert( deathArray.size > 0, deathArray.size ); 

	return deathArray;
}

getRunCrossbowDeathAnimArray()
{
	deathArray = [];

	if( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "left_foot" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_run_l_leg", "death");
	}
	else if( damageLocationIsAny( "right_leg_upper", "right_leg_lower", "right_foot" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_run_r_leg", "death");
	}
	else if( damageLocationIsAny( "left_arm_upper", "left_arm_lower", "left_hand" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_run_l_arm", "death");
	}
	else if( damageLocationIsAny( "right_arm_upper", "right_arm_lower", "right_arm" )	 )
	{
		deathArray[deathArray.size] = animArray("crossbow_run_r_arm", "death");
	}
	else if( ( self.damageyaw > -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
	{
		deathArray[deathArray.size] = animArray("crossbow_run_back", "death");
	}
	else if( ( self.damageyaw > 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
	{
		if( damageLocationIsAny( "head", "helmet", "neck" ) )
		{
			deathArray[deathArray.size] = animArray("run_front_2", "death");
			deathArray[deathArray.size] = animArray("run_front_3", "death");
		}
		else
		{
			deathArray[deathArray.size] = animArray("crossbow_run_front", "death");
		}
	}
	else // gotta play something
	{
		deathArray[deathArray.size] = animArray("crossbow_run_front", "death");
	}

	ArrayRemoveValue( deathArray, undefined ); 
	deathArray = animscripts\pain::removeBlockedAnims( deathArray );

	if( !deathArray.size )
		deathArray[deathArray.size] = getStandDeathAnim(); 
	
	return deathArray;
}

//--------------------------------------------------------------------------------
// Crouch deaths
//--------------------------------------------------------------------------------
getCrouchDeathAnim()
{
	deathArray = []; 

	if( isSniperRifle(self.damageWeapon) )
	{
		deathArray = getCrouchSniperDeathAnimArray();
	}
	else if( weaponIsGasWeapon( self.weapon ) )
	{
		deathArray[deathArray.size] = animArray("front", "death"); 
	}
	else
	{
		if( damageLocationIsAny( "head", "neck" ) )	// Front/Left quadrant
		{
			deathArray[deathArray.size] = animArray("front", "death"); 
		}

		if( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
		{
			deathArray[deathArray.size] = animArray("front_3", "death");
		}

		if( deathArray.size < 2 )
		{
			deathArray[deathArray.size] = animArray("front_2", "death"); 
		}

		if( deathArray.size < 2 )
		{
			deathArray[deathArray.size] = animArray("front_3", "death"); 
		}
	}

	ArrayRemoveValue( deathArray, undefined ); 
	assert( deathArray.size > 0, deathArray.size ); 
	return deathArray[RandomInt( deathArray.size )]; 
}

//--------------------------------------------------------------------------------
// Prone deaths
//--------------------------------------------------------------------------------

getCrouchSniperDeathAnimArray()
{
	deathArray = [];

	// AI_TODO - hacking it right now to use stand deaths. We need sniper deaths for crouch
	self.a.pose = "stand";
	
	return getStandSniperDeathAnimArray();
}

//--------------------------------------------------------------------------------
// Prone deaths
//--------------------------------------------------------------------------------
getProneDeathAnim()
{
	return animArray("front", "death"); 
}

//--------------------------------------------------------------------------------
// Back deaths
//--------------------------------------------------------------------------------
getBackDeathAnim()
{
	return animArrayPickRandom("front", "death");
}

//--------------------------------------------------------------------------------
// Generic extended deaths
// Usually they are 3 step start/loop/end animations. These functions can be called from any 
// death handler function with the input as a start animation and internally it will find the sequence
//--------------------------------------------------------------------------------
get_extended_death_seq( deathAnim )
{
	/#
	// Tool for forcing extended death anims for testing.	
	// For testing 	scr_forceExtendedDeath can be set to either 1 or the index name of available deaths
	// for example to test right leg extended death, set it to right_leg_start
	value = GetDvar( "scr_forceExtendedDeath" );
	
	if( value != "" )
		deathAnim = force_extended_death_anim( value );
	#/

	deathSeq = [];
	
	if( animArrayExist("flameA_start") && deathAnim == animArray("flameA_start") )
	{
		deathSeq[0] = animArray("flameA_start"); 
		deathSeq[1] = animArray("flameA_loop"); 
		deathSeq[2] = animArray("flameA_end"); 
	}
	else if( animArrayExist("flameB_start") && deathAnim == animArray("flameB_start") )
	{
		deathSeq[0] = animArray("flameB_start"); 
		deathSeq[1] = animArray("flameB_loop"); 
		deathSeq[2] = animArray("flameB_end"); 
	}
	else if( animArrayExist("gasA_start") && deathAnim == animArray("gasA_start") )
	{
		deathSeq[0] = animArray("gasA_start"); 
		deathSeq[1] = animArray("gasA_loop"); 
		deathSeq[2] = animArray("gasA_end"); 
	}
	else if( animArrayExist("gasB_start") && deathAnim == animArray("gasB_start") )
	{
		deathSeq[0] = animArray("gasB_start"); 
		deathSeq[1] = animArray("gasB_loop"); 
		deathSeq[2] = animArray("gasB_end"); 
	}
	else if( animArrayExist("left_leg_start") && deathAnim == animArray("left_leg_start") )
	{
		deathSeq[0] = animArray("left_leg_start");
		deathSeq[1] = animArray("left_leg_loop");
		deathSeq[2] = animArray("left_leg_end");
	}
	else if( animArrayExist("right_leg_start") && deathAnim == animArray("right_leg_start") )
	{
		deathSeq[0] = animArray("right_leg_start");
		deathSeq[1] = animArray("right_leg_loop");
		deathSeq[2] = animArray("right_leg_end");
	}
	else if( animArrayExist("torso_start") && deathAnim == animArray("torso_start") )
	{
		deathSeq[0] = animArray("torso_start");
		deathSeq[1] = animArray("torso_loop");
		deathSeq[2] = animArray("torso_end");
	}

	if( deathSeq.size == 3 )
		return deathSeq;

	return undefined;
}

//--------------------------------------------------------------------------------
// Gib extended deaths
//--------------------------------------------------------------------------------
try_gib_extended_death( chance )
{
	if( RandomInt( 100 ) >= chance )
		return false; 

	if( self.a.pose == "prone" || self.a.pose == "back" )
		return false;

	if( IS_TRUE(self.noGibDeathAnim) )
		return false;

	if( wasDamagedByChargedSniperShot() )
		return false;
	
	if( !shouldDieQuietly() && self.type == "human" )
		self thread animscripts\face::SaySpecificDialogue( undefined, "chr_spl_generic_gib_" + self.voice, 1.6 );

	
	deathseq = get_gib_extended_death_anims(); 

	if( deathSeq.size == 3 )
	{
		do_extended_death( deathSeq ); 
		return true; 
	}

	return false; 
}

get_gib_extended_death_anims()
{
	hitfrom = undefined; 

	if( ( self.damageyaw > 90 ) ||( self.damageyaw <= -90 ) )
		hitfrom = "front"; 
	else
		hitfrom = "back"; 

	gib_ref = self.a.gib_ref; 

	deathSeq = []; 
	if( IsDefined( hitfrom ) && IsDefined( gib_ref ) && gib_ref != "head" )
	{
		const hitIndex	= 0; 
		const loopIndex	= 1; 
		const dieIndex	= 2;

		if( gib_ref == "guts" || gib_ref == "no_legs" ) // don't have directional anims
			hitfrom = "";
		else
			hitfrom = "_" + hitfrom;

		deathSeq[hitIndex]  = animArray("gib_" + gib_ref + hitfrom + "_start"); 
		deathSeq[loopIndex] = animArray("gib_" + gib_ref + hitfrom + "_loop");
		deathSeq[dieIndex]  = animArray("gib_" + gib_ref + hitfrom + "_end");
	}

	return deathSeq; 
}

//--------------------------------------------------------------------------------
// Extended death support functions
//--------------------------------------------------------------------------------
do_extended_death( deathSeq )
{
	self animscripts\shared::DropAllAIWeapons(); 

	self thread do_gib(); 

	/#
	if( GetDvar( "scr_forceExtendedDeath" ) != "" )
		Record3DText( "AI is going to ragdoll", self.origin + ( 0, 0, 70 ), ( 1, 1, 1 ), "Animscript" );
	#/

	// don't collide with player during long death
	self SetPlayerCollision(false);

	self thread death_anim_short_circuit();
	self setFlaggedAnimKnobAllRestart( "deathhitanim", deathSeq[0], %body, 1, .1 ); 
	self animscripts\shared::DoNoteTracks( "deathhitanim" ); 
	self notify( "stop_death_anim_short_circuit" );

	/#
	if( GetDvar( "scr_forceExtendedDeath" ) != "" )
		Record3DText( "AI is going to play actual death", self.origin + ( 0, 0, 70 ), ( 1, 1, 1 ), "Animscript" );
	#/

	self thread end_extended_death( deathSeq ); 

	numDeathLoops = RandomInt( 2 ) + 1; 
	self thread extended_death_loop( deathSeq, numDeathLoops ); 

	// We must wait for the sequence to end, or else self will get removed before we're done.
	self waittill( "extended_death_ended" ); 
}

end_extended_death( deathSeq )
{
	assert( IsDefined( deathSeq[2] ) ); 

	// Normally, the final death anim runs at the end of the loop, but the loop can be intterupted by shooting.
	// Code sends a special notify "damage_afterdeath" if the AI is shot while in extended death
	self waittill_any( "damage_afterdeath", "ending_extended_death" ); 


	self setFlaggedAnimKnobAllRestart( "deathdieanim", deathSeq[2], %body, 1, .1 ); 
	self animscripts\shared::DoNoteTracks( "deathdieanim" ); 

	// All done with extended death sequence.
	self notify( "extended_death_ended" ); 
}

extended_death_loop( deathSeq, numLoops )
{
	// If someone shoots or damages self in any way, play final death immediately.
	self endon( "damage" ); 

	assert( IsDefined( deathSeq[1] ) ); 	

	animLength = GetAnimLength( deathSeq[1] ); 
	for( i = 0; i < numLoops; i++ )
	{
		self setFlaggedAnimKnobAllRestart( "deathloopanim", deathSeq[1], %body, 1, .1 ); 
		self animscripts\shared::DoNoteTracks( "deathloopanim" ); 
	}

	// If the loop hasn't already been cut short by the actor taking further damage, 
	// go into the final death anim.	
	self notify( "ending_extended_death" ); 
}

death_anim_short_circuit( delay )
{
	self endon( "stop_death_anim_short_circuit" );

	if(IsDefined(delay))
		wait delay;
	else
		wait 0.3; 

	totalDamageTaken = 0; 
	while( 1 )
	{
		self waittill( "damage_afterdeath", damagetaken, attacker, dir, point, mod ); 
		
		if( IsDefined( self.damageMod ) && self.damageMod != "MOD_BURNED" )
		{
			totalDamageTaken += self.damageTaken; 
			if( totalDamageTaken > 100 )
			{
				self launch_ragdoll_based_on_damage_type(); 
				break; 
			}
		}
	}
}

//--------------------------------------------------------------------------------
// Death anim playback
//--------------------------------------------------------------------------------
play_death_anim( deathAnim )
{
	if( IS_TRUE( self.a.tryHeadShotSlowMo ) )
		self thread headShotSlowMo();
			
	deathSeq = get_extended_death_seq( deathAnim );
	if( IsDefined( deathSeq ) )
	{
		do_extended_death( deathSeq );
		self maps\_dds::dds_notify_casualty();
		return;
	}

	// AI_TODO - we should remove this at it causes AI to go into ragdoll pretty quick.
	// currently its just turned off.
	//self thread death_anim_short_circuit();

	if( !animHasNoteTrack( deathAnim, "dropgun" ) && !animHasNoteTrack( deathAnim, "fire_spray" ) ) // && !animHasNotetrack( deathAnim, "gun keep" )
		self animscripts\shared::DropAllAIWeapons(); 
	
	self thread play_death_anim_fx( deathAnim );
	
	if( IS_TRUE(self.skipDeathAnim) )
	{
		self thread do_gib(); 
		self launch_ragdoll_based_on_damage_type();
		wait 0.5;

		return; 
	}
	else
	{
		if( IS_TRUE( self.a.allowDeathShortCircuit ) )
		{
			// don't collide with player during long death
			self SetPlayerCollision(false);
			self thread death_anim_short_circuit();
		}
		else
		{
			// in this case wait for few frames to let animation play and then track additional damage for ragdoll.
			// this will make the deaths more responsive.
			self thread death_anim_short_circuit(0.3);
		}
		
		self setFlaggedAnimKnobAllRestart( "deathanim", deathAnim, %body, 1, .1 );
	}

	self thread do_gib(); 

	if( !animHasNotetrack( deathanim, "start_ragdoll" ) )
		self thread waitForRagdoll( getanimlength( deathanim ) * 0.9 ); 
	
	// do we really need this anymore?
	/#
		if( GetDvar( "debug_deathBodyFallNotetrack" ) == "on" )
		{
			if( animhasnotetrack( deathAnim, "bodyfall large" ) )
				return; 

			if( animhasnotetrack( deathAnim, "bodyfall small" ) )
				return; 

			println( "Death animation ", deathAnim, " does not have a bodyfall notetrack" ); 
			iprintlnbold( "Death animation needs fixing( check console and report bug in the animation to Boon )" ); 
		}
	#/

	self animscripts\shared::DoNoteTracks( "deathanim" ); 
	self animscripts\shared::DropAllAIWeapons();
	
	self notify( "stop_death_anim_short_circuit" );

	self maps\_dds::dds_notify_casualty();
}

play_death_anim_fx( deathAnim )
{		
	if( animHasNoteTrack( deathAnim, "death_neckgrab_spurt" ) && is_mature() )
		PlayFXOnTag( anim._effect["death_neckgrab_spurt"], self, "j_neck" ); 
	
	// if getting melee'ed by taser knuckles then we should play vomit fx
	// AI_TODO - weapon specific effects like these should move out and handled through GDT and also up the function hierarchy
	
	if( !IsDefined( self.attacker ) || !IsDefined( self.damageMod ) )
		return false; 

	if( !IsPlayer( self.attacker ) )
		return false; 

	const MELEE_VOMIT_FX_CHANCE = 33;
	forcedGasDeath = IS_TRUE( self.a.forcegasdeath );
	if( forcedGasDeath || self.damageMod == "MOD_MELEE" && RandomInt(100) <  MELEE_VOMIT_FX_CHANCE && self.attacker HasWeapon( "tazer_knuckles_sp" ) )
	{
		wait( RandomFloatRange(0.2, 1.0) );
		
		if( IsDefined(self) )
			PlayFXOnTag( anim._effect["tazer_knuckles_vomit"], self, "j_neck" );		
	}
}

//--------------------------------------------------------------------------------
// Gib Utility
//--------------------------------------------------------------------------------
do_gib()
{
	if( !IsDefined( self.a.gib_ref ) )
		return; 
	
	if( !is_mature() )
		return; 
	
	if( is_gib_restricted_build() )
		return; 
	
	//reduce chance of a gib to 20%
	if( RandomFloat(100) > anim.deathGlobals.GLOBAL_GIB_CHANCE )
		return ;
		
	if ( IsDefined(self.damageWeapon) )
	{
		if (isSubStr( self.damageWeapon, "flame" ) || isSubStr( self.damageWeapon, "molotov" ) || isSubStr( self.damageWeapon, "napalmblob" ) )
			return;
	}	
		
	// removing coop challenges for now MGORDON
	//maps\_challenges_coop::doMissionCallback( "playerGib", self ); 

	gib_ref = self.a.gib_ref; 
	
	// handle healmet and head pop. Currently, head pop is not setup in limb data
	if( gib_ref == "head" )
	{
		self helmetPop();
		// death head pop - AI_TODO - we should actually handle this with limb data eventually. Talk to character team.
		self headPop();
	}
	
	limb_data = get_limb_data( gib_ref ); 

	if( !IsDefined( limb_data ) )
	{
		/#
		println( "^3animscripts\death.gsc - limb_data is not setup for gib_ref on model: " + self.model + " and gib_ref of: " + self.a.gib_ref ); 
		#/
		return; 
	}

	forward = undefined; 

	pos1 = []; 
	pos2 = []; 
	velocities = []; 

	if( limb_data["spawn_tags"][0] != "" )
	{
		if( IsDefined( self.gib_vel ) )
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
				velocities[i] = forward * RandomFloatRange( 0.6, 1.0 ); 
				velocities[i] = velocities[i] +( 0, 0, RandomFloatRange( 0.4, 0.7 ) ); 
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

			PlayFxOnTag( anim._effect[limb_data["fx"]], self, limb_data["spawn_tags"][i] ); 
		}
	}

	PlaySoundAtPosition( "chr_death_gibs", self.origin );
	self thread maps\_dds::dds_notify( "gib", ( self.team != "allies" ) );
	self thread throw_gib( limb_data["spawn_models"], limb_data["spawn_tags"], velocities ); 

	// Set the upperbody model
	self SetModel( limb_data["body_model"] ); 

	// Attach the legs
	self Attach( limb_data["legs_model"] ); 
}

get_limb_data( gib_ref )
{
	temp_array = []; 

	// Slightly faster, store the IsDefined stuff before checking, which will be less code-calls.
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
		CreateDynEntAndLaunch( spawn_models[i], origin, angles, origin, velocities[i], anim._effect["animscript_gibtrail_fx"], 1 ); 
	}
}

//--------------------------------------------------------------------------------
// Utility
//--------------------------------------------------------------------------------
headShotSlowMo()
{
	const HEADSHOT_SLOWMO_DELAY 			 = 0.2;
	const HEADSHOT_SLOWMO_TIMESCALE 		 = 0.2;
	const HEADSHOT_SLOWMO_TIMESCALE_INTERVAL = 0.2;
	
	if( self.team == self.attacker.team )
		return;

	if( GetPlayers().size > 1 )
		return;

	if( !IsPlayer(self.attacker) )
		return;

	if( !damageLocationIsAny( "head", "helmet", "neck" ) )
		return;
	
	if( GetTimeScale() != 1 )
		return;
	
	wait(HEADSHOT_SLOWMO_DELAY);
	
	SetTimeScale(HEADSHOT_SLOWMO_TIMESCALE);
	
	wait(HEADSHOT_SLOWMO_TIMESCALE_INTERVAL);
	
	SetTimeScale(1);
}

waitForRagdoll( time )
{
	wait( time ); 

	do_ragdoll = true; 
	if( IS_TRUE(self.nodeathragdoll) )
		do_ragdoll = false; 

	if( IsDefined( self ) && do_ragdoll )
	{
		/#recordEntText( "death ragdoll", self, (0,1,0), "Animation" );#/
		self StartRagDoll(); 
	}

	if( IsDefined( self ) )
		self animscripts\shared::DropAllAIWeapons(); 
}	

DoDeathFromArray( deathArray )
{
	deathAnim = deathArray[RandomInt( deathArray.size )]; 	
	play_death_anim( deathAnim ); 
}

shouldDoRunningForwardDeath()
{
	if( self.a.movement != "run" )
		return false;

	if( self getMotionAngle() > 60 || self getMotionAngle() < -60 )
		return false; 

	if( ( self.damageyaw >= 135 ) ||( self.damageyaw <= -135 ) ) // Front quadrant
		return true; 

	if( ( self.damageyaw >= -45 ) &&( self.damageyaw <= 45 ) ) // Back quadrant
		return true; 

	return false; 
}

tryAddDeathAnim( animName )
{
	assert( !animHasNoteTrack( animName, "fire" ) && !animHasNoteTrack( animName, "fire_spray" ) );
	return animName;
}


firingDeathAllowed()
{
	if ( !IsDefined( self.weapon ) || !self animscripts\weaponList::usingAutomaticWeapon() )
		return false;

	if ( self.a.weaponPos[ "right" ] == "none" )
		return false;

	if( shouldDieQuietly() )
		return false;

	if( IS_FALSE( self.dofiringdeath ) )
		return false;

	return true;
}

longDeathAllowed()
{
	if ( IS_TRUE(level.disableLongDeaths) )
		return false;

	if ( IS_TRUE(self.a.disableLongDeath) )
		return false;
	
	if( IS_TRUE( self.a.nodeath ) )
		return false;
	
	if( IS_TRUE( self.forceragdollimmediate	) )
		return false;
	
	if( IsDefined( self.overrideActorDamage ) )
		return false;
	
	if( IS_TRUE( self.magic_bullet_shield ) )
		return false;

	return true;
}

shouldDieQuietly()
{
	return IS_TRUE( self.dieQuietly );
}

isValidGibRef( gib_ref )
{	
	// SUMEET_TODO - make this list global list so that it can be updated/edited easily
	refs = []; 

	refs[refs.size] = "right_arm"; 
	refs[refs.size] = "left_arm"; 
	refs[refs.size] = "right_leg"; 
	refs[refs.size] = "left_leg"; 
	refs[refs.size] = "no_legs"; 
	refs[refs.size] = "head"; 

	if( IsInArray( refs, gib_ref ) )
		return true;

	return false;
}

get_random( array )
{
	return array[RandomInt( array.size )]; 
}

randomize_array( array )
{
	for( i = 0; i < array.size; i++ )
	{
		j = RandomInt( array.size ); 
		temp = array[i]; 
		array[i] = array[j]; 
		array[j] = temp; 
	}
	return array; 
}

launch_ragdoll_based_on_damage_type( bullet_scale )
{
	if( self animscripts\pain::wasDamagedByExplosive() )
	{
		force = 1.6; 
	}
	else if( WeaponClass( self.damageWeapon ) == "spread" )		// shotgun
	{
		distSquared = DistanceSquared( self.origin, self.attacker.origin ); 
		const maxDistSquared = 300*300;
		if( distSquared > maxDistSquared )
		{
			distSquared = maxDistSquared;
		}
		force = .3; 
		force += .7 *( 1.0 - ( distSquared /( maxDistSquared ) ) ); 
	}
	else  // everything else
	{
		if( self.damagetaken < 75 )
		{
			force = .35;
		}
		else
		{
			force = .45; 
		}
		if( IsDefined( bullet_scale ) )
		{
			force *= bullet_scale;
		}
	}

	initial_force = self.damagedir + ( 0, 0, 0.2 ); 
	initial_force *= 60 * force; 

	if( damageLocationIsAny( "head", "helmet", "neck" ) )
	{
		initial_force *= 0.5;
	}

	/# recordEntText( "death launch ragdoll", self, (0,1,0), "Animation" ); #/

	self startragdoll( self.damagemod == "MOD_CRUSH" ); 
	self launchragdoll( initial_force, self.damageLocation ); 	
}


//--------------------------------------------------------------------------------
// Death debug
//--------------------------------------------------------------------------------
/#
force_extended_death_anim( value )
{
	deathAnim = undefined;

	// populate the list of possible death animations
	anims = [];

	if( animArrayExist("flameA_start") )
		anims[anims.size] = animArray("flameA_start");

	if( animArrayExist("flameB_start") )
		anims[anims.size] = animArray("flameB_start");

	if( animArrayExist("gasA_start") )
		anims[anims.size] = animArray("gasA_start");

	if( animArrayExist("gasB_start") )
		anims[anims.size] = animArray("gasB_start");

	if( animArrayExist("left_leg_start") )
		anims[anims.size] = animArray("left_leg_start");

	if( animArrayExist("right_leg_start") )
		anims[anims.size] = animArray("right_leg_start");

	if( animArrayExist("torso_start") )
		anims[anims.size] = animArray("torso_start");

	assert( anims.size > 0, "There is no extended death animations present for " + self.a.pose );

	// if its set to 1 then pick up a random extended death
	if( value == "on" )
	{
		random_anim = anims[RandomIntRange( 0, anims.size )];
	}
	else
	{
		assert(    value == "flameA_start"   || value == "flameB_start"
				|| value == "gasA_start"     || value == "gasB_start"
				|| value == "left_leg_start" || value == "right_leg_start" 
				|| value == "torso_start", "Set the dvar either ON or available extended deaths, look at get_extended_death_seq function in death.gsc" );

		random_anim = animArray(value);

		assert( IsDefined( random_anim ), "The animation for " + self.a.pose + " " + value + "does not exist."  );
	}

	deathAnim = random_anim;		

	return deathAnim;
}

debug_explosion_death_gib()
{
	if( GetDvar( "gib_test" ) != "" )
	{
		deathAnim = %death_explosion_up10; 
		getExplosionGibRef( "right" ); 

		localDeltaVector = getMoveDelta( deathAnim, 0, 1 ); 
		endPoint = self localToWorldCoords( localDeltaVector ); 

		if( !self mayMoveToPoint( endPoint ) )
			return false; 

		// this should really be in the notetracks
		self AnimMode( "nogravity" ); 

		play_death_anim( deathAnim ); 
		return true; 
	}

	return false;
}

#/

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}