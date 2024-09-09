#include common_scripts\utility;
#include animscripts\utility;
#include animscripts\combat_utility;
#include maps\_utility;

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

init_animset_death()
{
	initAnimSet = [];
	
	initAnimSet["directed_energy_stand_front_head"] = [ %stand_death_head_front_a_dea ];
	initAnimSet["directed_energy_stand_front_legs"] = [ %stand_death_legs_front_a_dea ];
	initAnimSet["directed_energy_stand_front_default"] = [ %stand_death_torso_front_a_dea ];
	initAnimSet["directed_energy_stand_back_default"] = [ %stand_death_torso_back_a_dea ];
	
	initAnimSet["strong_legs"] = [ %death_shotgun_legs, %death_stand_sniper_leg ];
	initAnimSet["strong_torso_lower"] = [ %death_shotgun_legs, %death_stand_sniper_leg, %death_shotgun_back_v1, %exposed_death_blowback, %death_stand_sniper_chest1, %death_stand_sniper_chest2, %death_stand_sniper_spin1 ];
	initAnimSet["strong_default"] = [ %death_shotgun_legs, %death_stand_sniper_leg, %death_shotgun_back_v1, %exposed_death_blowback, %death_stand_sniper_chest1, %death_stand_sniper_chest2, %death_stand_sniper_spin1 ];

	initAnimSet["strong_right"] = [ %death_shotgun_spinL, %death_stand_sniper_spin1, %death_stand_sniper_chest1, %death_stand_sniper_chest2 ];
	initAnimSet["strong_left"] = [ %death_shotgun_spinR, %death_stand_sniper_spin2, %death_stand_sniper_chest1, %death_stand_sniper_chest2 ];

	initAnimSet["running_forward"] = [ %run_death_facedown, %run_death_roll, %run_death_fallonback, %run_death_flop ];
	
	initAnimSet["stand_pistol_forward"] = [ %pistol_death_2 ];  // 100 degree front arc
	initAnimSet["stand_pistol_front"] = [ %pistol_death_2 ]; // 220 degree front arc
	initAnimSet["stand_pistol_groin"] = [ %pistol_death_3, %pistol_death_3 ]; // Twice as likely
	initAnimSet["stand_pistol_torso_upper"] = [ %pistol_death_3 ];
	initAnimSet["stand_pistol_upper_body"] = [ %pistol_death_4 ];
	initAnimSet["stand_pistol_default"] = [ %pistol_death_1 ];

	initAnimSet["stand_pistol_torso_upper"] = [ %pistol_death_3, %pistol_death_1 ]; // 220 degree front arc
	initAnimSet["stand_pistol_lower_body"] = [ %pistol_death_2 ]; // 220 degree front arc

	initAnimSet["cover_right_stand"] = [ %corner_standr_deathA, %corner_standr_deathB ];
	initAnimSet["cover_right_crouch_head"] = [ %CornerCrR_alert_death_slideout ];
	initAnimSet["cover_right_crouch_default"] = [ %CornerCrR_alert_death_slideout, %CornerCrR_alert_death_back ];

	initAnimSet["cover_left_stand"] = [ %corner_standl_deathA, %corner_standl_deathB ];
	initAnimSet["cover_left_crouch"] = [ %CornerCrL_death_side, %CornerCrL_death_back ];

	initAnimSet["cover_stand"] = [ %coverstand_death_left, %coverstand_death_right ];

	initAnimSet["cover_crouch_head"] = %covercrouch_death_1;
	initAnimSet["cover_crouch_back"] = %covercrouch_death_3;
	initAnimSet["cover_crouch_default"] = %covercrouch_death_2;

	initAnimSet["saw_stand"] = [ %saw_gunner_death ];
	initAnimSet["saw_crouch"] = [ %saw_gunner_lowwall_death ];
	initAnimSet["saw_prone"] = [ %saw_gunner_prone_death ];

	initAnimSet["dying_crawl_crouch"] = [ %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 ];
	initAnimSet["dying_crawl_prone"] = [ %dying_crawl_death_v1, %dying_crawl_death_v2 ];

	initAnimSet["stand_lower_body"] = [ %exposed_death_groin, %stand_death_leg ];
	initAnimSet["stand_lower_body_extended"] = [ %stand_death_crotch, %stand_death_guts ];
	initAnimSet["stand_head"] = [ %exposed_death_headshot, %exposed_death_flop ];
	initAnimSet["stand_neck"] = [ %exposed_death_neckgrab ];
	initAnimSet["stand_left_shoulder"] = [ %exposed_death_twist, %stand_death_shoulder_spin, %stand_death_shoulderback ];
	initAnimSet["stand_torso_upper"] = [ %stand_death_tumbleforward, %stand_death_stumbleforward ];
	initAnimSet["stand_torso_upper_extended"] = [ %stand_death_fallside ];

	initAnimSet["stand_front_head"] = [ %stand_death_face, %stand_death_headshot_slowfall ];
	initAnimSet["stand_front_head_extended"] = [ %stand_death_head_straight_back ];
	initAnimSet["stand_front_torso"] = [ %stand_death_tumbleback ];
	initAnimSet["stand_front_torso_extended"] = [ %stand_death_chest_stunned ];

	initAnimSet["stand_back"] = [ %exposed_death_falltoknees, %exposed_death_falltoknees_02 ];
	
	initAnimSet["stand_default"] = [ %exposed_death_02, %exposed_death_nerve ];
	initAnimSet["stand_default_firing"] = [ %exposed_death_firing_02, %exposed_death_firing ];
	initAnimSet["stand_backup_default"] = %exposed_death;


	initAnimSet["crouch_head"] = [ %exposed_crouch_death_fetal ];
	initAnimSet["crouch_torso"] = [ %exposed_crouch_death_flip ];
	initAnimSet["crouch_default1"] = [ %exposed_crouch_death_twist ];
	initAnimSet["crouch_default2"] = [ %exposed_crouch_death_flip ];

	anim.archetypes[ "soldier" ]["death"] = initAnimSet;

}

main()
{
	self endon( "killanimscript" );

	// make sure the guy doesn't talk after death
	self stopsounds();
	changeTime = 0.3;
	self clearanim( %scripted_talking, 				changeTime );
	
	// don't abort at this point unless you're going to play another animation!
	// just playing ragdoll isn't sufficient because sometimes ragdoll fails, and then
	// you'll just have a corpse standing around in limbo.

/*
=============
///ScriptFieldDocBegin
"Name: .nodeath"
"Summary: .a.nodeath -> set to true to disable death anims"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/
	
	if ( self.a.nodeath == true )
		return;

	if ( isdefined( self.deathFunction ) )
	{
		result = self [[ self.deathFunction ]]();
		if ( !isdefined( result ) )
			result = true;
		if ( result )
			return;
	}

	animscripts\utility::initialize( "death" );

	// should move this to squad manager somewhere...
	removeSelfFrom_SquadLastSeenEnemyPos( self.origin );

	anim.numDeathsUntilCrawlingPain -- ;
	anim.numDeathsUntilCornerGrenadeDeath -- ;

	if ( isDefined( self.ragdoll_immediate ) || self.forceRagdollImmediate )
	{
		self doImmediateRagdollDeath();
		// ragdoll can fail so don't assume that we can quit the function
	}
/*
=============
///ScriptFieldDocBegin
"Name: .deathanim"
"Summary: deathanim"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	

	if ( isDefined( self.deathanim ) )
	{
		playDeathAnim( self.deathAnim );

		// Added so that I can do special stuff in Level scripts on an ai
		if ( isdefined( self.deathanimscript ) )
			self [[ self.deathanimscript ]]();
		return;
	}

	explosiveDamage = self animscripts\pain::wasDamagedByExplosive();

	if ( self.damageLocation == "helmet" || self.damageLocation == "head" )
		self helmetPop();
	else if ( explosiveDamage && randomint( 3 ) == 0 )
		self helmetPop();

	self clearanim( %root, 0.3 );

	if ( !damageLocationIsAny( "head", "helmet" ) )
	{
/*
=============
///ScriptFieldDocBegin
"Name: .diequietly"
"Summary: AI dies quietly when this is set, no shooting deaths eiter"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	
		if ( self.dieQuietly )
		{
			// replace with actual die quietly gurglesque sound
//			if ( randomint(3) < 2 )
//				self animscripts\face::SayGenericDialogue("pain");
		}
		else
		{
			PlayDeathSound();
		}
	}

	if ( explosiveDamage && playExplodeDeathAnim() )
		return;
		
	// different from deathFunction above, doesn't skip explosion deaths, immediate ragdoll, sounds, etc
	if ( isdefined( self.specialDeathFunc ) )
	{
		if ( [[ self.specialDeathFunc ]]() )
			return;
	}

	// TODO: replace these with the above specialDeathFunc
	if ( specialDeath() )
		return;

	deathAnim = getDeathAnim();

	 /#
	if ( getdvarint( "scr_paindebug" ) == 1 )
		println( "^2Playing pain: ", deathAnim, " ; pose is ", self.a.pose );
	#/

	playDeathAnim( deathAnim );
}

doImmediateRagdollDeath()
{
	self animscripts\shared::DropAllAIWeapons();
	self.skipDeathAnim = true;  // this helps playDeathAnim() do failsafes for ragdoll failures later
	
	initialImpulse = 10;
	
	damageType = common_scripts\_destructible::getDamageType( self.damageMod );
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
	
	if ( self.forceRagdollImmediate )
		direction += self.prevAnimDelta * 20 * 10;	// 20 frames/sec
		
	if (isdefined(self.ragdoll_start_vel))
		direction += self.ragdoll_start_vel * 10;
	
	self startragdollfromimpact( self.damagelocation, direction );
	
	// wait a bit so that the ragdoll can start before the death script tries to play a regular
	//  death animation as a failsafe - if ragdolling, the regular death anim won't do anything when called
	wait( 0.05 );
}

playDeathAnim( deathAnim )
{
	if ( !animHasNoteTrack( deathAnim, "dropgun" ) && !animHasNoteTrack( deathAnim, "fire_spray" ) )// && !animHasNotetrack( deathAnim, "gun keep" )
		self animscripts\shared::DropAllAIWeapons();

	//if ( isdefined( self.faceDamageDir ) )
	//	self orientmode( "face angle", self.damageYaw );

	self setFlaggedAnimKnobAllRestart( "deathanim", deathAnim, %body, 1, .1 );


/*
=============
///ScriptFieldDocBegin
"Name: .skipDeathAnim"
"Summary: Makes an AI skip their death anim and still do ragdoll"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	

	if ( IsDefined( self.skipDeathAnim ) )
	{
		ASSERTEX( self.skipDeathAnim, "self.skipDeathAnim must be either true or undefined." );
		
/*
=============
///ScriptFieldDocBegin
"Name: .noragdoll"
"Summary: .noragdoll -> set to true to disable ragdoll"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/		
		if( !isdefined( self.noragdoll ) )
				self startRagDoll();
		
		wait( 0.05 );
		// failsafe in case ragdoll fails: he'll still be playing a deathanim,
		//  but at least he'll fall to the ground
		self AnimMode( "gravity" );
	}
	else if ( IsDefined( self.ragdolltime ) )
	{
		self thread waitForRagdoll( self.ragdolltime );
	}
	else if ( !animHasNotetrack( deathanim, "start_ragdoll" ) )
	{
		self thread waitForRagdoll( getanimlength( deathanim ) * 0.35 );
	}

	// do we really need this anymore?
	 /#
	if ( getdebugdvar( "debug_grenadehand" ) == "on" )
	{
		if ( animhasnotetrack( deathAnim, "bodyfall large" ) )
			return;
		if ( animhasnotetrack( deathAnim, "bodyfall small" ) )
			return;

		println( "Death animation ", deathAnim, " does not have a bodyfall notetrack" );
		iprintlnbold( "Death animation needs fixing (check console and report bug in the animation to Boon)" );
	}
	#/
	
	// SRS 11/20/08: blood pools don't always line up with ragdoll corpses, so skip them if
	//  we did ragdoll without a death anim (which usually sends the body farther away from the death spot)
	if ( !IsDefined( self.skipDeathAnim ) )
	{
		self thread playDeathFX();
	}
	
	self animscripts\shared::DoNoteTracks( "deathanim" );
	self animscripts\shared::DropAllAIWeapons();
}

waitForRagdoll( time )
{
	wait( time );
	if ( isdefined( self ) )
		self animscripts\shared::DropAllAIWeapons();
	if ( isdefined( self ) && !isdefined( self.noragdoll ) )
		self startragdoll();
}

playDeathFX()
{
	self endon( "killanimscript" );
	//iprintlnbold("bleed'n");

	if ( self.stairsState != "none" )
		return;

	wait 2;
	
	play_blood_pool();
}

play_blood_pool( note, flagName )
{
	if ( !isdefined( self ) )
		return;
/*
=============
///ScriptFieldDocBegin
"Name: .skipBloodPool"
"Summary: Set to true for no blood pool."
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	
	if ( isdefined( self.skipBloodPool ) )
	{
		assertex( self.skipBloodPool, "Setting must be either true or undefined" );
		return;
	}
	
	tagPos = self gettagorigin( "j_SpineUpper" );	// rough tag to play fx on
	tagAngles = self gettagangles( "j_SpineUpper" );
	forward = anglestoforward( tagAngles );
	up = anglestoup( tagAngles );
	right = anglestoright( tagAngles );

	tagPos = tagPos + ( forward * -8.5 ) + ( up * 5 ) + ( right * 0 );

	trace = bulletTrace( tagPos + ( 0, 0, 30 ), tagPos - ( 0, 0, 100 ), false, undefined );
	
	if ( trace[ "normal" ][2] > 0.9 )
		playfx( level._effect[ "deathfx_bloodpool_generic" ], tagPos );
}


// TODO: replace these with specialDeathFunc
// Special death is for corners, rambo behavior, mg42's, anything out of the ordinary stand, crouch and prone.  
// It returns true if it handles the death for the special animation state, or false if it wants the regular 
// death function to handle it.
specialDeath()
{
	if ( self.a.special == "none" )
		return false;

	switch( self.a.special )
	{
	case "cover_right":
		if ( self.a.pose == "stand" )
		{
			deathArray = self lookupAnim( "death", "cover_right_stand" );
			DoDeathFromArray( deathArray );
		}
		else
		{
			deathArray = [];

			if ( damageLocationIsAny( "head", "neck" ) )
			{
				deathArray = self lookupAnim( "death", "cover_right_crouch_head" );
			}
			else
			{
				deathArray = self lookupAnim( "death", "cover_right_crouch_default" );
			}
			DoDeathFromArray( deathArray );
		}
		return true;

	case "cover_left":
		if ( self.a.pose == "stand" )
		{
			deathArray = self lookupAnim( "death", "cover_left_stand" );
			DoDeathFromArray( deathArray );
		}
		else
		{
			deathArray = self lookupAnim( "death", "cover_left_crouch" );
			DoDeathFromArray( deathArray );
		}
		return true;

	case "cover_stand":
		deathArray = self lookupAnim( "death", "cover_stand" );
		DoDeathFromArray( deathArray );
		return true;

	case "cover_crouch":
		deathArray = [];
		if ( damageLocationIsAny( "head", "neck" ) && ( self.damageyaw > 135 || self.damageyaw <= -45 ) )	// Front / Left quadrant
			deathArray[ deathArray.size ] = self lookupAnim( "death", "cover_crouch_head" );

		if ( ( self.damageyaw > - 45 ) && ( self.damageyaw <= 45 ) )	// Back quadrant
			deathArray[ deathArray.size ] = self lookupAnim( "death", "cover_crouch_back" );

		deathArray[ deathArray.size ] = self lookupAnim( "death", "cover_crouch_default" );

		DoDeathFromArray( deathArray );
		return true;

	case "saw":
		if ( self.a.pose == "stand" )
			DoDeathFromArray( self lookupAnim( "death", "saw_stand" ) );
		else if ( self.a.pose == "crouch" )
			DoDeathFromArray( self lookupAnim( "death", "saw_crouch" ) );
		else
			DoDeathFromArray( self lookupAnim( "death", "saw_prone" ) );
		return true;

	case "dying_crawl":
		if ( isdefined( self.a.onback ) && self.a.pose == "crouch" )
		{
			deathArray = self lookupAnim( "death", "dying_crawl_crouch" );
			DoDeathFromArray( deathArray );
		}
		else
		{
			assertex( self.a.pose == "prone", self.a.pose );
			deathArray = self lookupAnim( "death", "dying_crawl_prone" );
			DoDeathFromArray( deathArray );
		}
		return true;
	}
	return false;
}


DoDeathFromArray( deathArray )
{
	deathAnim = deathArray[ randomint( deathArray.size ) ];

	playDeathAnim( deathAnim );
	//nate - adding my own special death flag on top of special death. 
	if ( isdefined( self.deathanimscript ) )
		self [[ self.deathanimscript ]]();
}


PlayDeathSound()
{
//	if (self.team == "allies")
//		self playsound("allied_death"); 
//	else
//		self playsound("german_death"); 
	self animscripts\face::SayGenericDialogue( "death" );
}

print3dfortime( place, text, time )
{
	numframes = time * 20;
	for ( i = 0; i < numframes; i++ )
	{
		print3d( place, text );
		wait .05;
	}
}

helmetPop()
{
	if ( !isdefined( self ) )
		return;
		
		
/*
=============
///ScriptFieldDocBegin
"Name: .hatmodel"
"Summary: hatmodel"
"Module: ai"
"SPMP: singleplayer"
///ScriptDocEnd
=============
*/	

	
	if ( !isdefined( self.hatModel ) )
		return;
		
	// used to check self removableHat() in cod2... probably not necessary though

	partName = GetPartName( self.hatModel, 0 );
	model = spawn( "script_model", self.origin + ( 0, 0, 64 ) );
	model setmodel( self.hatModel );
	model.origin = self GetTagOrigin( partName );// self . origin + ( 0, 0, 64 );
	model.angles = self GetTagAngles( partName );// ( -90, 0 + randomint( 90 ), 0 + randomint( 90 ) );
	model thread helmetLaunch( self.damageDir );

	hatModel = self.hatModel;
	self.hatModel = undefined;

	wait 0.05;

	if ( !isdefined( self ) )
		return;
	self detach( hatModel, "" );
}

helmetLaunch( damageDir )
{
    launchForce = damageDir;
	launchForce = launchForce * randomFloatRange( 2000, 4000 );

	forcex = launchForce[ 0 ];
	forcey = launchForce[ 1 ];
	forcez = randomFloatRange( 1500, 3000 );

	contactPoint = self.origin + ( randomfloatrange( -1, 1 ), randomfloatrange( -1, 1 ), randomfloatrange( -1, 1 ) ) * 5;

	self PhysicsLaunchClient( contactPoint, ( forcex, forcey, forcez ) );

	wait 60;

	while ( 1 )
	{
		if ( !isdefined( self ) )
			return;

		if ( distanceSquared( self.origin, level.player.origin ) > 512 * 512 )
			break;

		wait 30;
	}

	self delete();
}


removeSelfFrom_SquadLastSeenEnemyPos( org )
{
	for ( i = 0;i < anim.squadIndex.size;i++ )
		anim.squadIndex[ i ] clearSightPosNear( org );
}


clearSightPosNear( org )
{
	if ( !isdefined( self.sightPos ) )
		return;

	if ( distance( org, self.sightPos ) < 80 )
	{
		self.sightPos = undefined;
		self.sightTime = gettime();
	}
}


shouldDoRunningForwardDeath()
{
	if ( self.a.movement != "run" )
		return false;

	if ( self getMotionAngle() > 60 || self getMotionAngle() < - 60 )
		return false;

/*
	if ( ( self.damageyaw >= 120 ) || ( self.damageyaw <= -120 ) )// Front quadrant
		return true;

	if ( ( self.damageyaw >= -45 ) && ( self.damageyaw <= 45 ) )// Back quadrant
		return true;

	return false;
*/
	return true;
}

shouldDoDirectedEnergyDeath( damageWeapon, damageMod, damagetaken, attacker )
{
	Assert( IsDefined( damageWeapon ) );
	
	if( damageMod != "MOD_ENERGY" )
	{
		return false;	
	}
	
	// currently only have standing anims
	if( self.a.pose != "stand" )
	{
		return false;	
	}
	
	// not sure if necessary
	if ( isdefined( self.a.doingLongDeath ) )
	{
		return false;
	}
	
	return true;
}

shouldDoStrongBulletDamage( damageWeapon, damageMod, damagetaken, attacker )
{
	ASSERT( IsDefined( damageWeapon ) );

	if ( isdefined( self.a.doingLongDeath ) )
	{
		return false;
	}

	if ( self.a.pose == "prone" || isdefined( self.a.onback ) )
	{
		return false;
	}
	
	if( damageWeapon == "none" )
	{
		return false;
	}
	
	if ( damagetaken > 500 )
	{
		return true;
	}
	
	if( damageMod == "MOD_MELEE" )
	{
		return false;	
	}
	
	// if I'm running, and the attacker is far enough away, sometimes let me do
	//  a running death instead.  this helps minimize repetition of strong damage animations
	//  when a line of dudes is running towards you and you're mowing them down, etc.
	if( self.a.movement == "run" && !isAttackerWithinDist( attacker, 275 ) )
	{
		if( RandomInt( 100 ) < 65 )
		{
			return false;
		}
	}
	
	if ( isSniperRifle( damageWeapon ) && self.maxHealth < damageTaken )
	{
		return true;
	}
	
	if( isShotgun( damageWeapon ) && isAttackerWithinDist( attacker, 512 ) )
	{
		return true;
	}
	
	if( isDesertEagle( damageWeapon ) && isAttackerWithinDist( attacker, 425 ) )
	{
		return true;
	}
	
	return false;
}

isDesertEagle( damageWeapon )
{
	if( damageWeapon == "deserteagle" )
	{
		return true;
	}
	
	return false;
}

isAttackerWithinDist( attacker, maxDist )
{
	if( !IsDefined( attacker ) )
	{
		return false;
	}
	
	if( Distance( self.origin, attacker.origin ) > maxDist )
	{
		return false;
	}
	
	return true;
}

getDeathAnim()
{
	if ( shouldDoDirectedEnergyDeath( self.damageWeapon, self.damageMod, self.damagetaken, self.attacker ) )
	{
		deathAnim = getDirectedEnergyDeathAnim();
		
		if ( IsDefined( deathAnim ) )
		{
			return deathAnim;
		}
	}
	
	if ( shouldDoStrongBulletDamage( self.damageWeapon, self.damageMod, self.damagetaken, self.attacker ) )
	{
		deathAnim = getStrongBulletDamageDeathAnim();
		
		if ( IsDefined( deathAnim ) )
		{
			return deathAnim;
		}
	}

	if ( isdefined( self.a.onback ) )
	{
		if ( self.a.pose == "crouch" )
			return getBackDeathAnim();
		else
			animscripts\notetracks::stopOnBack();
	}

	if ( self.a.pose == "stand" )
	{
		if ( shouldDoRunningForwardDeath() )
		{
			return getRunningForwardDeathAnim();
		}
		else
		{
			return getStandDeathAnim();
		}
	}
	else if ( self.a.pose == "crouch" )
	{
		return getCrouchDeathAnim();
	}
	else if ( self.a.pose == "prone" )
	{
		return getProneDeathAnim();
	}
}


// may return undefined
// large death animation for shotguns, snipers etc.
getStrongBulletDamageDeathAnim()
{
	damageYaw = abs( self.damageYaw );

	if ( damageYaw < 45 )
		return;

	if ( damageYaw > 150 )
	{
		if ( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower", "left_foot", "right_foot" ) )
		{
			deathArray = self lookupAnim( "death", "strong_legs" );
		}
		else if ( self.damageLocation == "torso_lower" )
		{				
			deathArray = self lookupAnim( "death", "strong_torso_lower" );
		}
		else
		{				
			deathArray = self lookupAnim( "death", "strong_default" );
			}
			
		//self.faceDamageDir = true;	
	}
	else if ( self.damageYaw < 0 )
	{
		deathArray = self lookupAnim( "death", "strong_right" );
	}
	else
	{
		deathArray = self lookupAnim( "death", "strong_left" );
	}

	return deathArray[ randomint( deathArray.size ) ];
}


getDirectedEnergyDeathAnim()
{
	// assume standing anims only for now
	assert( self.a.pose == "stand" );
	
	damageYaw = abs( self.damageYaw );

	if( damageYaw > 135) // front
	{
		animGroup = "directed_energy_stand_front_default";
		
		// just to a position test for now (don't have location data yet)
		if ( IsDefined( self.last_damage_pos ) )
		{
			if ( self.last_damage_pos[2] < ( self.origin[2] + 20 ) )
			{
				animGroup = "directed_energy_stand_front_legs";
			}
			else if ( self.last_damage_pos[2] > ( self.origin[2] + 40 ) )
			{
				animGroup = "directed_energy_stand_front_head";
			}
		}
		
		/*
		if( damageLocationIsAny( "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower", "left_foot", "right_foot" ) )
		{
			animGroup = "directed_energy_stand_front_legs";
		}
		else if( damageLocationIsAny( "head", "neck" ) )
		{
			animGroup = "directed_energy_stand_front_head";
		}
		else
		{
			animGroup = "directed_energy_stand_front_default";
		}
		*/
	}
	else
	{
		animGroup = "directed_energy_stand_back_default";
	}

	
	deathArray = self lookupAnim( "death", animGroup );
	sanim = deathArray[ randomint( deathArray.size ) ];
	//  /# IPrintLn("directed energy: " + animGroup ); #/
	return sanim;
}


getRunningForwardDeathAnim()
{
	deathArray = self lookupAnim( "death", "running_forward" );
	deathArray = animscripts\pain::removeBlockedAnims( deathArray );

	if ( !deathArray.size )
		return getStandDeathAnim();

	return deathArray[ randomint( deathArray.size ) ];
}

// remove undefined entries from array
removeUndefined( array )
{
	newArray = [];
	for ( index = 0; index < array.size; index++ )
	{
		if ( !isDefined( array[ index ] ) )
			continue;

		newArray[ newArray.size ] = array[ index ];
	}
	return newArray;
}

getStandPistolDeathAnim()
{
	deathArray = [];
	
	if ( abs( self.damageYaw ) < 50 )
	{
		deathArray = self lookupAnim( "death", "stand_pistol_forward" );
	}
	else
	{
		if ( abs( self.damageYaw ) < 110 )
		{
			deathArray = self lookupAnim( "death", "stand_pistol_front" );
		}

		if ( self.damageLocation == "torso_upper" )
		{
			deathArray = array_combine( self lookupAnim( "death", "stand_pistol_torso_upper" ), deathArray );
		}
		else if ( damageLocationIsAny( "torso_lower", "left_leg_upper", "left_leg_lower", "right_leg_upper", "right_leg_lower" ) )
		{
			deathArray = array_combine( self lookupAnim( "death", "stand_pistol_torso_upper" ), deathArray );
		}

		if ( !damageLocationIsAny( "head", "neck", "helmet", "left_foot", "right_foot", "left_hand", "right_hand", "gun" ) && randomint( 2 ) == 0 )
		{
			deathArray = array_combine( self lookupAnim( "death", "stand_pistol_upper_body" ), deathArray );
		}

		if ( deathArray.size == 0 || damageLocationIsAny( "torso_lower", "torso_upper", "neck", "head", "helmet", "right_arm_upper", "left_arm_upper" ) )
		{
			deathArray = array_combine( self lookupAnim( "death", "stand_pistol_default" ), deathArray );
	}
	}
	
	return deathArray;
}

getStandDeathAnim()
{
	deathArray = [];
	extendedDeathArray = [];

	if ( usingSidearm() )
	{
		deathArray = getStandPistolDeathAnim();
	}
	else
	{
		// torso or legs
		if ( damageLocationIsAny( "torso_lower", "left_leg_upper", "left_leg_lower", "right_leg_lower", "right_leg_lower" ) )
		{
			deathArray = self lookupAnim( "death", "stand_lower_body" );
			extendedDeathArray = self lookupAnim( "death", "stand_lower_body_extended" );
		}
		else if ( damageLocationIsAny( "head", "helmet" ) )
		{
			deathArray = self lookupAnim( "death", "stand_head" );
		}
		else if ( damageLocationIsAny( "neck" ) )
		{
			deathArray = self lookupAnim( "death", "stand_neck" );
		}
		else if ( damageLocationIsAny( "torso_upper", "left_arm_upper" ) )
		{
			deathArray = self lookupAnim( "death", "stand_left_shoulder" );
		}	
		
		if ( damageLocationIsAny( "torso_upper" ) )
		{
			deathArray = array_combine( deathArray, self lookupAnim( "death", "stand_torso_upper" ) );
			extendedDeathArray = array_combine( extendedDeathArray, self lookupAnim( "death", "stand_torso_upper_extended" ) );
		}			
		
		// quadrants
		if ( ( self.damageyaw > 135 ) || ( self.damageyaw <= -135 ) )// Front quadrant
		{
			if ( damageLocationIsAny( "neck", "head", "helmet" ) )
			{
				deathArray = array_combine( deathArray, self lookupAnim( "death", "stand_front_torso" ) );
				extendedDeathArray = array_combine( extendedDeathArray, self lookupAnim( "death", "stand_front_torso_extended" ) );
			}

			if ( damageLocationIsAny( "torso_upper" ) )
			{
				deathArray = array_combine( deathArray, self lookupAnim( "death", "stand_front_torso" ) );
				extendedDeathArray = array_combine( extendedDeathArray, self lookupAnim( "death", "stand_front_torso_extended" ) );
			}
		}
		else if ( ( self.damageyaw > -45 ) && ( self.damageyaw <= 45 ) )// Back quadrant
		{
			deathArray = array_combine( deathArray, self lookupAnim( "death", "stand_back" ) );
		}
		
		foundLocDamageDeath = ( deathArray.size > 0 );
		
		if ( !foundLocDamageDeath || RandomInt( 100 ) < 15 )
		{
			deathArray = array_combine( deathArray, self lookupAnim( "death", "stand_default" ) );
		}
		
		if ( RandomInt( 100 ) < 10 && firingDeathAllowed() )
		{
			deathArray = array_combine( deathArray, self lookupAnim( "death", "stand_default_firing" ) );
			deathArray = removeUndefined( deathArray );
		}

	}

	assertex( deathArray.size > 0, deathArray.size );
	if ( deathArray.size == 0 )
		deathArray[ deathArray.size ] = self lookupAnim( "death", "stand_backup_default" );

	if ( !self.a.disableLongDeath && self.stairsState == "none" && !isdefined( self.a.painOnStairs ) )
	{
		index = randomint( deathArray.size + extendedDeathArray.size );
		if ( index < deathArray.size )
			return deathArray[ index ];
		else
			return extendedDeathArray[ index - deathArray.size ];
	}

	assertex( deathArray.size > 0, deathArray.size );
	return deathArray[ randomint( deathArray.size ) ];
}


getCrouchDeathAnim()
{
	deathArray = [];

	if ( damageLocationIsAny( "head", "neck" ) )	// Front / Left quadrant
	{
		deathArray =  self lookupAnim( "death", "crouch_head" );
	}

	if ( damageLocationIsAny( "torso_upper", "torso_lower", "left_arm_upper", "right_arm_upper", "neck" ) )
	{
		deathArray = array_combine( deathArray, self lookupAnim( "death", "crouch_torso" ) );
	}

	if ( deathArray.size < 2 )
	{
		deathArray = array_combine( deathArray, self lookupAnim( "death", "crouch_default1" ) );
	}

	if ( deathArray.size < 2 )
	{
		deathArray = array_combine( deathArray, self lookupAnim( "death", "crouch_default2" ) );
	}

	assertex( deathArray.size > 0, deathArray.size );
	return deathArray[ randomint( deathArray.size ) ];
}


getProneDeathAnim()
{
	if ( isdefined( self.a.proneAiming ) )
		return %prone_death_quickdeath;
	else
		return %dying_crawl_death_v1;
}

getBackDeathAnim()
{
	deathArray = array( %dying_back_death_v1, %dying_back_death_v2, %dying_back_death_v3, %dying_back_death_v4 );
	return deathArray[ randomint( deathArray.size ) ];
}

firingDeathAllowed()
{
	if ( !isdefined( self.weapon ) || !usingRifleLikeWeapon() || !weaponIsAuto( self.weapon ) || self.dieQuietly )
		return false;
	
	if ( self.a.weaponPos[ "right" ] == "none" )
		return false;
		
	return true;
}

tryAddDeathAnim( animName )
{
	assert( !animHasNoteTrack( animName, "fire" ) && !animHasNoteTrack( animName, "fire_spray" ) );
	return animName;
}

tryAddFiringDeathAnim( animName )
{
	assert( animHasNoteTrack( animName, "fire" ) || animHasNoteTrack( animName, "fire_spray" ) );
	return animName;
}

playExplodeDeathAnim()
{
	if ( isdefined( self.juggernaut ) )
		return false;
		
	if ( self.damageLocation != "none" )
		return false;

	deathArray = [];

	if ( self.a.movement != "run" )
	{
		if ( ( self.damageyaw > 135 ) || ( self.damageyaw <= -135 ) )	// Front quadrant
		{
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_B_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_B_v2 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_B_v3 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_B_v4 );
		}
		else if ( ( self.damageyaw > 45 ) && ( self.damageyaw <= 135 ) )		// Right quadrant
		{
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_L_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_L_v2 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_L_v3 );
		}
		else if ( ( self.damageyaw > - 45 ) && ( self.damageyaw <= 45 ) )		// Back quadrant
		{
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_F_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_F_v2 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_F_v3 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_F_v4 );
		}
		else
		{															// Left quadrant
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_R_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_stand_R_v2 );
		}
	}
	else
	{
		if ( ( self.damageyaw > 135 ) || ( self.damageyaw <= -135 ) )	// Front quadrant
		{
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_B_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_B_v2 );
		}
		else if ( ( self.damageyaw > 45 ) && ( self.damageyaw <= 135 ) )		// Right quadrant
		{
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_L_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_L_v2 );
		}
		else if ( ( self.damageyaw > - 45 ) && ( self.damageyaw <= 45 ) )		// Back quadrant
		{
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_F_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_F_v2 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_F_v3 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_F_v4 );
		}
		else
		{															// Left quadrant
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_R_v1 );
			deathArray[ deathArray.size ] = tryAddDeathAnim( %death_explosion_run_R_v2 );
		}
	}

	deathAnim = deathArray[ randomint( deathArray.size ) ];

	if ( getdvar( "scr_expDeathMayMoveCheck", "on" ) == "on" )
	{
		localDeltaVector = getMoveDelta( deathAnim, 0, 1 );
		endPoint = self localToWorldCoords( localDeltaVector );

		if ( !self mayMoveToPoint( endPoint, false ) )
			return false;
	}

	// this should really be in the notetracks
	self animMode( "nogravity" );

	playDeathAnim( deathAnim );
	return true;
}

