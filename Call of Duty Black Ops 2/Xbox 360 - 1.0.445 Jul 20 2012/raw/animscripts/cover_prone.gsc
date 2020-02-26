#include maps\_utility;
#include animscripts\combat_utility;    
#include animscripts\utility;
#include animscripts\shared;
#include animscripts\anims;
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;

#using_animtree ("generic_human");

// TODO:
// - figure out why aiming range is incorrect (aiming arc seems a bit off)

main()
{
    self trackScriptState( "Cover Prone Main", "code" );
	self endon("killanimscript");
    animscripts\utility::initialize( "cover_prone" );

	// TODO: run cover crouch or exposed crouch
	if ( self.weaponclass == "rocketlauncher" )
	{
		animscripts\combat::main();
		return;
	}
	
	if ( IsDefined( self.a.arrivalType ) && self.a.arrivalType == "prone_saw" )
	{
		assert( IsDefined( self.node.turretInfo ) );
		self animscripts\cover_wall::useSelfPlacedTurret( "saw_bipod_prone", "weapon_saw_MG_Setup" );
	}
	else if ( IsDefined( self.node.turret ) )
	{
		self animscripts\cover_wall::useStationaryTurret();
	}

	// if we're too close to our enemy, stand up
	if ( IsDefined( self.enemy ) && lengthSquared( self.origin - self.enemy.origin ) < ( 512*512 ) )
	{
		self thread animscripts\combat::main();
		return;
	}

	self setup_cover_prone();

    self.coverNode = self.node;    
	assert( IsDefined(self.coverNode) );

	self OrientMode( "face angle", self.coverNode.angles[1] );	

	self setProneAnimNodes( -45, 45, %prone_legs_down, %exposed_modern, %prone_legs_up );
	if ( self.a.pose != "prone" )
	{
		self transitionTo( "prone" );
	}
	else
	{
		self EnterProneWrapper( 0 );
	}
		
	self SetAnimKnobAll( animArray("straight_level"), %body, 1, 0.1, 1 );

	// face the direction of our covernode
	self OrientMode( "face angle", self.coverNode.angles[1] );	
	self AnimMode("zonly_physics");
	
	self proneCombatMainLoop();
	
	self notify( "stop_deciding_how_to_shoot" );
	
}

idleThread()
{
	self endon("killanimscript");
	self endon("kill_idle_thread");

	for(;;)
	{
		idleAnim = animArrayPickRandom( "prone_idle" );
		self setflaggedanimlimited( "idle", idleAnim );
		self waittillmatch( "idle", "end" );
		self ClearAnim( idleAnim, .2 );
	}
}

UpdateProneWrapper( time )
{
	self UpdateProne( %prone_aim_feet_45up, %prone_aim_feet_45down, 1, time, 1 );
}

proneCombatMainLoop()
{
	self endon ("killanimscript");
	self endon ("melee");
	
	self thread trackShootEntOrPos();

	self SetAnim( %add_idle );
	self thread idleThread();
	
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );

	const nextShootTime = 0;
	
//	self resetGiveUpOnEnemyTime();
	
	desynched = (GetTime() > 2500);

	for(;;)
	{
		self animscripts\utility::IsInCombat(); // reset our in-combat state
		
		self UpdateProneWrapper( 0.05 );
		
		if ( !desynched )
		{
			wait ( 0.05 + RandomFloat( 1.5 ) );
			desynched = true;
			continue;
		}
		
		if ( !IsDefined( self.shootPos ) )
		{
			assert( !IsDefined( self.shootEnt ) );
			if ( considerThrowGrenade() )
			{
				continue;
			}

			wait(0.05);
			continue;
		}
		
		assert( IsDefined( self.shootPos ) ); // we can use self.shootPos after this point.
//		self resetGiveUpOnEnemyTime();
		
		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );

		if ( self.a.pose != "crouch" && self IsStanceAllowed("crouch") && distSqToShootPos < ( 400*400 ) )
		{
			if ( distSqToShootPos < ( 285*285 ) )
			{
				transitionTo( "crouch" );
				self thread animscripts\combat::main();
				return;
			}
		}

		if ( considerThrowGrenade() ) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
		{
			continue;
		}
		
		if ( self proneReload() )
		{
			continue;
		}

		if ( aimedAtShootEntOrPos() && GetTime() >= nextShootTime )
		{
			shootUntilShootBehaviorChange();
			
			// MikeD (10/11/2007): Stop the flamethrower from shooting once the shoot behavior changes.
			self flamethrower_stop_shoot();

			self ClearAnim( %add_fire, .2 );
			continue;
		}
		
		// idleThread() is running, so just waiting a bit will cause us to idle
		wait(0.05);
	}
	
}	

proneReload( )
{
	if( NeedToReload( 0 ) )
	{
		// MikeD (10/9/2007): Flamethrower AI do not reload
		if( weaponIsGasWeapon( self.weapon ) )
		{
			return flamethrower_reload();
		}

		self maps\_dds::dds_notify_reload( undefined, ( self.team == "allies" ) );

		reloadAnim = self animArrayPickRandom( "reload" );

		//self ClearAnim( %body, .1 );
		self SetFlaggedAnimKnobAll( "reloadanim", reloadAnim, %body, 1, .1, 1 );
		self SetAnim( %exposed_aiming, 1, 0 );
		
		animscripts\shared::DoNoteTracks( "reloadanim" );

		self ClearAnim( reloadAnim, 0.2 );

		self animscripts\weaponList::RefillClip();	// This should be in the animation as a notetrack in theory.

		return true;
	}

	return false;
}

setup_cover_prone()
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45; 
	self.downAimLimit = -45;
}


tryThrowingGrenade( throwAt, safe )
{
	theanim = undefined;
	if ( IsDefined(safe) && safe )
	{
		theanim = animArrayPickRandom("grenade_safe");
	}
	else
	{
		theanim = animArrayPickRandom("grenade_exposed");
	}

	self AnimMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeIfValid = true;
	
	armOffset = (32,20,64); // needs fixing!
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeIfValid = false;
	return threwGrenade;
}

considerThrowGrenade()
{
	if ( IS_TRUE( anim.throwGrenadeAtPlayerASAP ) )
	{
		players = GetPlayers();
		for( i = 0; i < players.size; i++ )
		{
			if( IsAlive( players[i] ) )
			{
				if ( tryThrowingGrenade( players[i], 200 ) )
				{
					return true;
				}
			}
		}
	}

	if ( IsDefined( self.enemy ) )
	{
		return tryThrowingGrenade( self.enemy, 850 );
	}

	return false;
}

shouldFireWhileChangingPose()
{
	if ( IsDefined( self.node ) && DistanceSquared( self.origin, self.node.origin ) < 16*16 )
		return false; // we're on a node and can't use an animation with a delta
	
	if ( IsDefined( self.enemy ) && self canSee( self.enemy ) && !IsDefined( self.grenade ) && self getAimYawToShootEntOrPos() < 20 )
		return animscripts\move::MayShootWhileMoving();
	
	return false;
}

transitionTo( newPose )
{
	if ( newPose == self.a.pose )
		return;
	
	self ClearAnim( %root, .3 );
	
	self notify( "kill_idle_thread" );
	
	if ( shouldFireWhileChangingPose() )
		transAnim = animArray( self.a.pose + "_2_" + newPose + "_firing", "cover_prone" );
	else
		transAnim = animArray( self.a.pose + "_2_" + newPose, "cover_prone" );
		
	if ( newPose == "prone" )
	{
		// this is crucial. if it doesn't have this notetrack, we won't call enterProneWrapper!
		assert( animHasNotetrack( transAnim, "anim_pose = \"prone\"" ) );
	}
	
	self setFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, 1.0 );
	animscripts\shared::DoNoteTracks( "trans" );

	assert( self.a.pose == newPose );

	self SetAnimKnobAllRestart( animArray("straight_level"), %body, 1, .25 );
	setupAim( .25 );
}

finishNoteTracks(animname)
{
	self endon("killanimscript");
	animscripts\shared::DoNoteTracks(animname);
}

setupAim( transTime )
{
	self SetAnimKnobAll( animArray("straight_level"), %body, 1, transTime );
	self SetAnimLimited( animArray("add_aim_up"), 1, transTime );
	self SetAnimLimited( animArray("add_aim_down"), 1, transTime );
	self SetAnimLimited( animArray("add_aim_left"), 1, transTime );
	self SetAnimLimited( animArray("add_aim_right"), 1, transTime );
}

proneTo( newPose, rate )
{
	assert( self.a.pose == "prone" );
	
//	self OrientMode( "face angle", self.angles[1] );
	self ClearAnim( %root, .3 );
	
	transAnim = undefined;
	
	if ( shouldFireWhileChangingPose() )
	{
		if ( newPose == "crouch" )
		{
			transAnim = animArray("prone_2_crouch_firing", "cover_prone");
		}
		else if ( newPose == "stand" )
		{
			transAnim = animArray("prone_2_stand_firing", "cover_prone");
		}
	}
	else
	{
		if ( newPose == "crouch" )
		{
			transAnim = animArray("prone_2_crouch", "cover_prone");
		}
		else if ( newPose == "stand" )
		{
			transAnim = animArray("prone_2_stand", "cover_prone");
		}
	}
		
	assert( IsDefined( transAnim ) );

	if ( !IsDefined( rate ) )
	{
		rate = 1;
	}

	self ExitProneWrapper( getAnimLength( transAnim ) / 2 );
	self setFlaggedAnimKnobAllRestart( "trans", transAnim, %body, 1, .2, rate );
	animscripts\shared::DoNoteTracks( "trans" );

	self ClearAnim( transAnim, 0.1 );

	assert( self.a.pose == newPose );
//	self.a.pose = newPose; // failsafe
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}
