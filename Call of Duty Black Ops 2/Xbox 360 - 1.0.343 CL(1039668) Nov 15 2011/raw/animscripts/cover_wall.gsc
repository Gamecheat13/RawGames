#include animscripts\anims;
#include animscripts\combat_utility;
#include animscripts\cover_utility;
#include animscripts\utility;
#include common_scripts\Utility;
#include maps\_utility;

#using_animtree ("generic_human");

cover_wall_think( coverType )
{	
	self endon("killanimscript");

	assert( IsDefined(self.node) );
    self.coverNode = self.node;
	self.coverType = coverType;

	if ( !isDefined( self.coverNode.turret ) )
		animscripts\cover_utility::turnToMatchNodeDirection( 0 );
    
    if ( coverType == "crouch" )
    {
		self setup_cover_crouch();
		self initCoverCrouchNode();
	}
	else
	{
		self setup_cover_stand();
	}

	// get out of prone if necessary
	if( self.a.pose != "stand" && self.a.pose != "crouch" )
	{
		assert( self.a.pose == "prone" );
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
	}

	self.a.standIdleThread = undefined;

	// face the direction of our covernode
	self OrientMode( "face angle", self.coverNode.angles[1] );	

	if ( IsDefined( self.coverNode.turret ) )
	{
		self useStationaryTurret();
	}
	
	self AnimMode("normal");
	
	//start in Hide position
	if ( coverType == "crouch" && self.a.pose == "stand" )
	{
		transAnim = animArray( "stand_2_hide" );
		time = getAnimLength( transAnim );
		self SetAnimKnobAllRestart( transAnim, %body, 1, 0.2 );
		self thread animscripts\shared::moveToOriginOverTime( self.coverNode.origin, time );
		wait time;
		self.a.coverMode = "Hide";
	}
	else
	{
		loopHide( .4 ); // need to transition to Hide here in case we didn't do an approach
		self thread animscripts\shared::moveToOriginOverTime( self.coverNode.origin, .4 );
		wait( .2 );

		if ( coverType == "crouch" )
		{
			self.a.pose = "crouch";
		}

		wait( .2 );
	}

	self AnimMode("zonly_physics");

	if ( coverType == "crouch" )
	{
		if ( self.a.pose == "prone" )
		{
			self ExitProneWrapper(1);
		}

		self.a.pose = "crouch"; // in case we only lerped into the pose
	}

	if ( self.coverType == "stand" )
	{
		self.a.special = "cover_stand";
	}
	else
	{
		self.a.special = "cover_crouch";
	}

	behaviorCallbacks = SpawnStruct();
	behaviorCallbacks.reload				= ::coverReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::leaveCoverAndShoot;
	behaviorCallbacks.look					= ::look;
	behaviorCallbacks.fastlook				= ::fastLook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.flinch				= ::flinch;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= animscripts\cover_utility::blindfire;
	behaviorCallbacks.resetWeaponAnims		= ::resetWeaponAnims;
	behaviorCallbacks.rambo					= ::rambo;	
	animscripts\cover_behavior::main( behaviorCallbacks );
}

initCoverCrouchNode()
{
	if ( IsDefined( self.covernode.crouchingIsOK ) )
		return;
	
	// it's only ok to crouch at this node if we can see out from a crouched position.
	crouchHeightOffset = (0,0,42);
	forward = AnglesToForward( self.angles );
	self.covernode.crouchingIsOK = sightTracePassed( self.origin + crouchHeightOffset, self.origin + crouchHeightOffset + VectorScale( forward, 64 ), false, undefined );
}

setup_cover_crouch()
{
	self.rightAimLimit = 48;
	self.leftAimLimit = -48;
	self.upAimLimit = 45; 
	self.downAimLimit = -45; 		
}

setup_cover_stand()
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45; 
	self.downAimLimit = -45;
}

coverReload()
{
	return Reload( 2.0, animArrayPickRandom( "reload" ) );
}

leaveCoverAndShoot( theWeaponType, mode, suppressSpot )
{
	self.keepClaimedNodeIfValid = true;
	
	if ( !pop_up() )
	{
		/#self animscripts\debug::debugPopState( undefined, "no room to pop up" );#/
		return false;
	}
	
	shootAsTold();
	
	self notify("kill_idle_thread");

	if ( IsDefined( self.shootPos ) )
	{
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );
		// too close for RPG or out of ammo
		
		if( animscripts\shared::shouldThrowDownWeapon() )
		{
			//println("cover_wall:shouldThrowDownWeapon was true"); // ALEXP_PRINT
			animscripts\shared::throwDownWeapon();

			resetWeaponAnims();
		}
	}

	go_to_hide();

	self.keepClaimedNodeIfValid = false;
	
	return true;
}

shootAsTold()
{
	self endon("return_to_cover");
	self endon("need_to_switch_weapons");

	self maps\_gameskill::didSomethingOtherThanShooting();

	/#self animscripts\debug::debugPushState( "shootAsTold" );#/

	while(1)
	{
		if ( self.shouldReturnToCover )
		{
			/#self animscripts\debug::debugPopState( "shootAsTold", "shouldReturnToCover is true" );#/
			break;
		}

		// HACK - AI is coming out of cover to shoot but enemy is already out of aiming range.
		// in this case, AI might get stuck waiting for aiming and look stupid idling. Its better to look 
		// for a new cover position in that case.
		if( !aimedAtShootEntOrPos() )
		{
			wait 0.5;
			waittillframeend;

			if( !aimedAtShootEntOrPos() )
			{
				self lookForBetterCover();
				/#self animscripts\debug::debugPopState( "shootAsTold", "Looking better cover as can't aim at enemy" );#/
				break;
			}
		}

		if (!IsDefined(self.shootPos))
		{
			assert( !IsDefined( self.shootEnt ) );

			// give shoot_behavior a chance to iterate
			self waittill( "do_slow_things" );
			waittillframeend;

			if ( IsDefined( self.shootPos ) )
			{
				continue;
			}

			/#self animscripts\debug::debugPopState( "shootAsTold", "shootPos undefined" );#/
			break;
		}

		if ( !self.bulletsInClip )
		{
			break;
		}
		
		// crouch only
		if ( self.coverType == "crouch" && needToChangeCoverMode() )
		{
			/#self animscripts\debug::debugPopState( "shootAsTold", "needToChangeCoverMode true" );#/
			break;
		}
		
		shootUntilShootBehaviorChange_coverWall();		

		/#self animscripts\debug::debugPopState( "shootAsTold" );#/

		// MikeD (10/11/2007): Stop the AI from firing his weapon when told to change his shoot behavior.
		self flamethrower_stop_shoot();	

		self ClearAnim( %add_fire, .2 );
		
	}
}

shootUntilShootBehaviorChange_coverWall()
{
	if ( self.coverType == "crouch" )
	{
		self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	}

	self thread standIdleThread();
	
	shootUntilShootBehaviorChange();
}

// AI_TODO: bring over IW's rambo changes. Rambo should work for both corner and wall cover.

idle()
{
	self endon("end_idle");

	while( 1 )
	{
		useTwitch = (RandomInt(2) == 0 && animArrayAnyExist("hide_idle_twitch"));
		if ( useTwitch && !self LookingAtEntity())
		{
			idleanim = animArrayPickRandom("hide_idle_twitch");
		}
		else
		{
			idleanim = animArray("hide_idle");
		}

		playIdleAnimation( idleAnim, useTwitch );
	}
}

flinch()
{
	if ( !animArrayAnyExist( "hide_idle_flinch" ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no flinch anim" );
		#/

		return false;
	}
	
	forward = AnglesToForward( self.angles );
	stepto = self.origin + VectorScale( forward, -16 );
	
	if ( !self mayMoveToPoint( stepto ) )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no room to flinch" );
		#/

		return false;
	}
	
	self AnimMode("zonly_physics");
	self.keepClaimedNodeIfValid = true;
	
	flinchanim = animArrayPickRandom("hide_idle_flinch");
	playIdleAnimation( flinchanim, true );
	
	self.keepClaimedNodeIfValid = false;
	
	return true;
}

playIdleAnimation( idleAnim, needsRestart )
{
	if ( needsRestart )
	{
		self SetFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	}
	else
	{
		self SetFlaggedAnimKnobAll       ( "idle", idleAnim, %body, 1, .1, 1);
	}
	
	self.a.coverMode = "Hide";
	
	self animscripts\shared::DoNoteTracks( "idle" );
}

look( lookTime )
{
	if ( !animArrayExist("hide_to_look") )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no look anim" );
		#/

		return false;
	}
	
	if ( !peekOut() )
	{
		return false;
	}
	
	animscripts\shared::playLookAnimation( animArray("look_idle"), lookTime ); // TODO: replace
	
	lookanim = undefined;
	if ( self isSuppressedWrapper() )
	{
		lookanim = animArray("look_to_hide_fast");
	}
	else
	{
		lookanim = animArray("look_to_hide");
	}
	
	self setflaggedanimknoballrestart( "looking_end", lookanim, %body, 1, .1 );
	animscripts\shared::DoNoteTracks( "looking_end" );
	
	return true;
}

peekOut()
{
	if ( IsDefined( self.coverNode.script_dontpeek ) )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "cover node has script_dontpeek on" );
		#/

		return false;	
	}

	if ( IsDefined( self.a.dontpeek ) )
	{
		/#
			self animscripts\debug::debugPopState( undefined, "self.a.dontpeek on" );
		#/

		return false;	
	}


	// no anim support for now
	if( usingPistol() )
	{
		/#
		self animscripts\debug::debugPopState( undefined, "no pistol anims" );
		#/

		return false;
	}

	// assuming no delta, so no maymovetopoint check
	
	self SetFlaggedAnimKnobAll( "looking_start", animArray("hide_to_look"), %body, 1, .2 );
	animscripts\shared::DoNoteTracks( "looking_start" );
	
	return true;
}

fastLook()
{
	self setFlaggedAnimKnobAllRestart( "look", animArrayPickRandom( "look" ), %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	return true;
}

// AI_TODO: consolidate this idle thread stuff like IW
standIdleThread()
{
	self endon("killanimscript");

	if (!IsDefined(self.a.standIdleThread))
	{
		self.a.standIdleThread = true;

		self SetAnim( %add_idle, 1, .2 );
		standIdleThreadInternal();
		self ClearAnim( %add_idle, .2 );
	}
}

endStandIdleThread()
{
	self.a.standIdleThread = undefined;
	self notify("end_stand_idle_thread");
}

// TODO: need new idles for lean and crouch?
standIdleThreadInternal()
{
	self endon("killanimscript");
	self endon("end_stand_idle_thread");
	
	for( i = 0; ; i++ )
	{
		flagname = "idle" + i;

		if( isValidEnemy( self.enemy ) )
		{
			idleAnim = animArrayPickRandom( "exposed_idle" );
		}
		else
		{
			idleAnim = animArrayPickRandom( "exposed_idle_noncombat" );
		}
		
		self SetFlaggedAnimKnobLimitedRestart( flagname, idleAnim, 1, 0.2 );
		
		self waittillmatch( flagname, "end" );
	}
}

// These should be adjusted in animation data
pop_up_and_hide_speed()
{
	if ( self.a.coverMode == "left" || self.a.coverMode == "right" || self.a.coverMode == "over" )
		return 1;

	return randomfasterAnimSpeed();
}

pop_up()
{
	assert( self.a.coverMode == "Hide" );
	
	newCoverMode = getBestCoverMode();
	
	// AI_TODO - investigate why would AI at cover_stand will crouch sometimes
	if(!IsDefined(newCoverMode))
		return false;
	
	popupAnim = animArray("hide_2_" + newCoverMode);
	
	if ( !self mayMoveToPoint( getAnimEndPos( popupAnim ) ) )
	{
		return false;
	}

	if ( self.coverType == "crouch" )
	{
		self setup_cover_crouch();
	}
	else
	{
		self setup_cover_stand();
	}

	self.a.special = "none";

	if ( self.coverType == "stand" )
		self.a.special = "cover_stand_aim";
	else
	{
		if( newCoverMode == "left" || newCoverMode == "right" )
			self.a.special = "cover_crouch_aim_" + newCoverMode;		
		else
			self.a.special = "cover_crouch_aim";
	}

	self.changingCoverPos = true;
	self notify("done_changing_cover_pos");
	
	self AnimMode("zonly_physics");

	animRate = pop_up_and_hide_speed();
	
	self setFlaggedAnimKnobAllRestart( "pop_up", popUpAnim, %body, 1 , .1, animRate );
	self thread DoNoteTracksForPopup( "pop_up" );

	if ( animHasNoteTrack( popupAnim, "start_aim" ) )
	{
		self waittillmatch( "pop_up", "start_aim" );
		timeleft = getAnimLength( popupAnim ) / animRate * (1 - self getAnimTime( popupAnim ));
	}
	else
	{
		self waittillmatch( "pop_up", "end" );
		timeleft = .1;
	}

	self ClearAnim( popUpAnim, timeleft + 0.05 );
	
	self.a.coverMode = newCoverMode;
	self.a.prevAttack = newCoverMode;
	self setup_additive_aim( timeleft );
	self thread animscripts\shared::trackShootEntOrPos();
	
	wait(timeleft);

	if ( self isSniper() )
	{
		thread animscripts\shoot_behavior::sniper_glint_behavior();
	}


	self.changingCoverPos = false;
	self.coverPosEstablishedTime = GetTime();
	
	self notify("stop_popup_donotetracks");
	
	return true;
}

DoNoteTracksForPopup( animname )
{
	self endon("killanimscript");
	self endon("stop_popup_donotetracks");
	self animscripts\shared::DoNoteTracks( animname );
}

setup_additive_aim( transTime )
{
	if ( self.a.coverMode == "left" || self.a.coverMode == "right" )
		aimCoverMode = "crouch";
	else
		aimCoverMode = self.a.coverMode;

	self SetAnimKnobAll(animArray(aimCoverMode + "_aim"), %body, 1, transTime);

	prefix = "";
	if( self.a.coverMode == "over" )
		prefix = "over_";

	self SetAnimLimited( animArray(prefix + "add_aim_down")		, 1, 0);
	self SetAnimLimited( animArray(prefix + "add_aim_left")		, 1, 0);
	self SetAnimLimited( animArray(prefix + "add_aim_right")	, 1, 0);
	self SetAnimLimited( animArray(prefix + "add_aim_up")		, 1, 0);
}

go_to_hide()
{
	self notify("return_to_cover");

	/#self animscripts\debug::debugPopState( "shootAsTold", "needToChangeCoverMode true" );#/
	
	self.changingCoverPos = true; 
	self notify("done_changing_cover_pos");
	
	self endStandIdleThread();

	animRate = pop_up_and_hide_speed();

	self SetFlaggedAnimKnobAll( "go_to_hide" , animArray( self.a.coverMode + "_2_hide" ), %body, 1, 0.2, animRate );
	self ClearAnim( %exposed_modern, 0.2 );
	
	self animscripts\shared::DoNoteTracks( "go_to_hide" );
	
	self animscripts\shared::stopTracking();
	
	self.a.coverMode = "Hide";
	
	if ( self.coverType == "stand" )
	{
		self.a.special = "cover_stand";
	}
	else
	{
		self.a.special = "cover_crouch";
	}
	
	self.changingCoverPos = false;
}


tryThrowingGrenadeStayHidden( throwAt )
{
	return tryThrowingGrenade( throwAt, true );
}


tryThrowingGrenade( throwAt, safe )
{
	theanim = undefined;
	
	if( animArrayExist("grenade_rambo") && Isdefined( self.ramboChance ) && randomFloat(1) < self.ramboChance )
	{	
		theAnim = animArray("grenade_rambo");				
	}
	else
	{
		if( IsDefined(safe) && safe )
			theanim = animArrayPickRandom("grenade_safe");
		else
			theanim = animArrayPickRandom("grenade_exposed");
	}
		
	self AnimMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeIfValid = true;
	
	threwGrenade = TryGrenade( throwAt, theanim );
	
	self.keepClaimedNodeIfValid = false;
	return threwGrenade;
}

createTurret( posEnt, weaponInfo, weaponModel )
{
	turret = spawnTurret( "misc_turret", posEnt.origin, weaponInfo );
	turret.angles = posEnt.angles;
	turret.aiOwner = self;
	turret SetModel( weaponModel );
	turret makeTurretUsable();
	turret setDefaultDropPitch( 0 );

	if ( IsDefined( posEnt.leftArc ) )
	{
		turret.leftArc = posEnt.leftArc;
	}

	if ( IsDefined( posEnt.rightArc ) )
	{
		turret.rightArc = posEnt.rightArc;
	}

	if ( IsDefined( posEnt.topArc ) )
	{
		turret.topArc = posEnt.topArc;
	}

	if ( IsDefined( posEnt.bottomArc ) )
	{
		turret.bottomArc = posEnt.bottomArc;
	}

	return turret;
}

deleteIfNotUsed( owner )
{
	self endon("death");
	self endon("being_used");
	
	wait .1;
	
	if ( IsDefined( owner ) )
	{
		assert( !IsDefined( owner.a.usingTurret ) || owner.a.usingTurret != self );
		owner notify("turret_use_failed");
	}

	self delete();
}

useSelfPlacedTurret( weaponInfo, weaponModel )
{
	turret = self createTurret( self.coverNode.turretInfo, weaponInfo, weaponModel );

	if ( self UseTurret( turret ) )
	{
		turret thread deleteIfNotUsed( self );
		self waittill("turret_use_failed"); // generally this won't notify, and we'll just not do any more cover_wall for now
	}
	else
	{
		turret delete();
	}
}


useStationaryTurret()
{
	assert( IsDefined( self.coverNode ) );
	assert( IsDefined( self.coverNode.turret ) );

	self.coverNode.turret.ai_node_user = self;
	if ( self.coverNode.turret maps\_turret::is_turret_enabled() )
	{
		self thread maps\_turret::use_turret( self.coverNode.turret );
	}
}

loopHide( transTime )
{
	if ( !IsDefined( transTime ) )
	{
		transTime = .1;
	}

	self SetAnimKnobAllRestart( animArray( "hide_idle" ), %body, 1, transTime );
	self.a.coverMode = "Hide";	
}

angleRangeThread()
{
	self endon ("killanimscript");
	self notify ("newAngleRangeCheck");
	self endon ("newAngleRangeCheck");
	self endon ("return_to_cover");

	while (1)
	{
		if ( needToChangeCoverMode() )
		{
			break;
		}

		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}

needToChangeCoverMode()
{
	if ( self.coverType != "crouch" )
	{
		return false;
	}
	
	pitch = getShootPosPitch( self getEye() );
	
	if ( self.a.coverMode == "lean" )
	{
		return pitch < 10;
	}
	else
	{
		return abs( pitch ) > 45;
	}
}

getBestCoverMode()
{
	modes = [];
	assert( IsDefined( self.coverNode ) );

	if ( self.coverType == "stand" )
	{
		modes = self.coverNode GetValidCoverPeekOuts();

		// normal "stand" transition takes AI away from the node
		// and make it impossible to shoot down, so check the angle first
		allowStepback = true;
		if( modes.size > 0 )
		{
			pitch = getShootPosPitch( self.coverNode.origin + getNodeOffset( self.coverNode ) );
			if( pitch > 15 )
				allowStepback = false;
		}

		if( allowStepback )
			modes[ modes.size ] = "stand";
	}
	else
	{
		pitch = getShootPosPitch( self.coverNode.origin + getNodeOffset( self.coverNode ) );

		if ( pitch > 30 )
			return "lean";
		if ( pitch > 15 || !self.coverNode.crouchingIsOK )
			return "stand";

		modes = self.coverNode GetValidCoverPeekOuts();
		modes[ modes.size ] = "crouch";
	}

	// over is only for stand cover
	if( self.coverType == "stand" && self.a.pose != "stand" )
	{
		modes = array_exclude( modes, array("over") );
	}

	return getRandomCoverMode( modes );
}

resetWeaponAnims()
{
	if ( self.coverType == "crouch" )
	{
		self setup_cover_crouch();
	}
	else
	{
		self setup_cover_stand();
	}
}

rambo()
{
	/#self animscripts\debug::debugPushState( "rambo" );#/

	if ( !hasEnemySightPos() )
		return false;

	shouldRambo = IsDefined( self.coverNode.script_forcerambo ) || ( IsDefined( self.ramboChance ) && RandomFloat(1) < self.ramboChance );

	if( shouldRambo && canRambo() )
	{
		if( ramboStepOut() )
		{			
			/#self animscripts\debug::debugPopState( "rambo" );#/
			return true;
		}
	}

	/#self animscripts\debug::debugPopState( "rambo", "not allowed or can't step out" );#/
	return false;
}

ramboStepOut()
{
	animType = "rambo";

	// we dont want to see rambo jam as often
	if( RandomFloat(1) < 0.2 && animArrayAnyExist("rambo_jam") )
		animType = "rambo_jam";

	if( self.coverType == "crouch" && !self.covernode.crouchingIsOK )
		return false;

	assert( animArrayAnyExist( animType ) );

	pitch = getShootPosPitch( self.coverNode.origin + getNodeOffset( self.coverNode ) );
	if ( pitch > 15 )
		return false;

	forward = anglesToForward( self.angles );
	ramboOutPos = self.origin + ( forward * -16 );

	/#self thread debugRamboOutPosition( ramboOutPos );#/
	if ( !self mayMoveToPoint( ramboOutPos ) )
		return false;

	ramboanim = animArrayPickRandom( animType );

	resetAnimSpecial(0);

	self AnimMode( "zonly_physics" );
	self.keepClaimedNodeIfValid = true;
	self.isRamboing = true;

	self setFlaggedAnimKnobAllRestart("rambo", ramboanim, %body, 1, 0);

	// aiming
	if( canUseBlindAiming( "rambo" ) && animType != "rambo_jam" )
	{
		self thread startBlindAiming( ramboanim, "rambo" );
		self thread stopBlindAiming( ramboanim, "rambo" );
	}

	// set target
	if( IsDefined(self.enemy) )
		self animscripts\shoot_behavior::setShootEnt( self.enemy );


	self animscripts\shared::DoNoteTracks("rambo");
	
	self.keepClaimedNodeIfValid = false;
	self.isRamboing = false;
	self.a.prevAttack = "rambo";
	waittillframeend;
	
	return true;
}

resetAnimSpecial( delay )
{
	self endon("killanimscript");

	if( delay > 0 )
		wait delay;

	self.a.special = "none";
}