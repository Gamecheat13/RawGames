#include animscripts\Combat_utility;    
#include animscripts\Utility;
#include common_scripts\Utility;
#using_animtree ("generic_human");

cover_wall_think( coverType )
{	
	self endon("killanimscript");

    self.coverNode = self.node;
    self.coverType = coverType;
    
    if ( coverType == "crouch" )
    {
		self setup_cover_crouch();
		self.coverNode initCoverCrouchNode();
	}
	else
	{
		self setup_cover_stand();
	}

	// face the direction of our covernode
	self OrientMode( "face angle", self.coverNode.angles[1] );	

    if ( isdefined( self.node.turret ) )
		use_turret_while_i_can();

	// start additive aiming thread
	self thread animscripts\shared::trackShootEntOrPos();

	self animmode("normal");
	
	//start in hide position
	loopHide( .4 ); // need to transition to hide here in case we didn't do an approach
	self thread animscripts\shared::moveToOriginOverTime( self.coverNode.origin, .4 );
	wait( .4 );
	
	self animmode("zonly_physics");

	if ( coverType == "crouch" )
	{
		if ( self.a.pose == "prone" )
			self ExitProneWrapper(1);
		self.a.pose = "crouch"; // in case we only lerped into the pose
	}
	
	behaviorCallbacks = spawnstruct();
	behaviorCallbacks.reload				= ::coverReload;
	behaviorCallbacks.leaveCoverAndShoot	= ::leaveCoverAndShoot;
	behaviorCallbacks.look					= ::look;
	behaviorCallbacks.fastlook				= ::fastLook;
	behaviorCallbacks.idle					= ::idle;
	behaviorCallbacks.flinch				= ::flinch;
	behaviorCallbacks.grenade				= ::tryThrowingGrenade;
	behaviorCallbacks.grenadehidden			= ::tryThrowingGrenadeStayHidden;
	behaviorCallbacks.blindfire				= ::blindfire;
	
	animscripts\cover_behavior::main( behaviorCallbacks );
}

initCoverCrouchNode()
{
	if ( isdefined( self.crouchingIsOK ) )
		return;
	
	// it's only ok to crouch at this node if we can see out from a crouched position.
	crouchHeightOffset = (0,0,42);
	forward = anglesToForward( self.angles );
	self.crouchingIsOK = sightTracePassed( self.origin + crouchHeightOffset, self.origin + crouchHeightOffset + vectorScale( forward, 64 ), false, undefined );
}


setup_cover_crouch()
{
	self.rightAimLimit = 48;
	self.leftAimLimit = -48;
	self.upAimLimit = 45; 
	self.downAimLimit = -45; 		
	self setup_crouching_anim_array();
}


setup_cover_stand()
{
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45; 
	self.downAimLimit = -45;
	self setup_standing_anim_array();
}


coverReload()
{
	Reload( 2.0, animArray( "reload" ) ); // (reload no matter what)
	return true;
}


leaveCoverAndShoot( theWeaponType, mode, suppressSpot )
{
	self.keepClaimedNodeInGoal = true;
	pop_up();
	
	shootAsTold();
	
	self notify("kill_idle_thread");
	
	go_to_hide();
	self.keepClaimedNodeInGoal = false;
	
	return true;
}


shootAsTold()
{
	self endon("return_to_cover");

	while(1)
	{
		if ( self.shouldReturnToCover )
			break;
		
		if ( !isdefined( self.shootPos ) ) {
			assert( !isdefined( self.shootEnt ) );
			// give shoot_behavior a chance to iterate
			wait .05;
			waittillframeend;
			if ( isdefined( self.shootPos ) )
				continue;
			break;
		}
		
		if ( !self.bulletsInClip )
			break;
		
		// crouch only
		if ( self.coverType == "crouch" && needToChangeCoverMode() )
		{
			break;
			
			// TODO: if changing between stances without returning to cover is implemented, 
			// we can't just endon("return_to_cover") because it will cause problems when it
			// happens while changing stance.
			// see corner's implementation of this idea for a better implementation.

			// NYI
			/*changeCoverMode();
			
			// if they're moving too fast for us to respond intelligently to them,
			// give up on firing at them for the moment
			if ( needToChangeCoverMode() )
				break;
			
			continue;*/
		}
		
		self thread standIdleThread();
		
		shootUntilShootBehaviorChange();		
		self clearAnim( %additive, .2 );
	}
}


shootUntilShootBehaviorChange()
{
	self endon("shoot_behavior_change");
	self endon("stopShooting");
	
	if ( self.coverType == "crouch" )
		self thread angleRangeThread(); // gives stopShooting notify when shootPosOutsideLegalYawRange returns true
	
	if ( self.shootStyle == "full" )
	{
		self FireUntilOutOfAmmo( animArray("fire"), false );
	}
	else if ( self.shootStyle == "burst" || self.shootStyle == "single" || self.shootStyle == "semi" )
	{
		while(1)
		{
			numShots = 1;
			if ( self.shootStyle == "burst" || self.shootStyle == "semi" )
				numShots = animscripts\shared::decideNumShots();	
				
			if ( numShots == 1 )
				self FireUntilOutOfAmmo( animArray( "single" ), true, numShots );
			else
				self FireUntilOutOfAmmo( animArray( self.shootStyle + numShots ), true, numShots );
			
			if ( !self.bulletsInClip )
				break;
			
			burstDelay();
		}
	}
	else
	{
		assert( self.shootStyle == "none" );
		self waittill( "the end of all time" ); // waits for the endons to happen
	}
}


idle()
{
	self endon("end_idle");
	
	if ( randomint(2) == 0 && animArrayAnyExist("hide_idle_twitch") )
		idleanim = animArrayPickRandom("hide_idle_twitch");
	else
		idleanim = animarray("hide_idle");
	
	playIdleAnimation( idleAnim );
	
	return true;
}

flinch()
{
	if ( !animArrayAnyExist( "hide_idle_flinch" ) )
		return false;
	
	forward = anglesToForward( self.angles );
	stepto = self.origin + vectorScale( forward, -16 );
	
	if ( !self mayMoveToPoint( stepto ) )
		return false;
	
	self notify("end_idle");
	
	self animmode("zonly_physics");
	self.keepClaimedNodeInGoal = true;
	
	flinchanim = animArrayPickRandom("hide_idle_flinch");
	playIdleAnimation( flinchanim );
	
	self.keepClaimedNodeInGoal = false;
	
	return true;
}

playIdleAnimation( idleAnim )
{
	self setFlaggedAnimKnobAllRestart( "idle", idleAnim, %body, 1, .1, 1);
	self.a.coverMode = "hide";
	
	self animscripts\shared::DoNoteTracks( "idle" );
}

look( lookTime )
{
	if ( !isdefined( self.a.array["hide_to_look"] ) )
		return false;
	
	if ( !peekOut() )
		return false;
	
	animscripts\shared::playLookAnimation( animArray("look_idle"), lookTime ); // TODO: replace
	
	lookanim = undefined;
	if ( self isSuppressedWrapper() )
		lookanim = animArray("look_to_hide_fast");
	else
		lookanim = animArray("look_to_hide");
	
	self setflaggedanimknoballrestart( "looking_end", lookanim, %body, 1, .1 );
	animscripts\shared::DoNoteTracks( "looking_end" );
	
	return true;
}

peekOut()
{
	// assuming no delta, so no maymovetopoint check
	
	self setFlaggedAnimKnobAll( "looking_start", animArray("hide_to_look"), %body, 1, .2 );
	animscripts\shared::DoNoteTracks( "looking_start" );
	
	return true;
}

fastLook()
{
	self setFlaggedAnimKnobAllRestart( "look", animArrayPickRandom( "look" ), %body, 1, .1 );
	self animscripts\shared::DoNoteTracks( "look" );
	
	return true;
}


standIdleThread()
{
	self endon("killanimscript");
	self notify("kill_idle_thread");
	self endon("kill_idle_thread");
	
	self setAnim( %add_idle, 1, .2 );
	standIdleThreadInternal();
	self clearAnim( %add_idle, .2 );
}

// TODO: need new idles for lean and crouch?
standIdleThreadInternal()
{
	self endon("shoot_behavior_change");
	self endon("stop_shooting");
	self endon("return_to_cover");
	
	assert( animArrayAnyExist("exposed_idle") );
	for(;;)
	{
		self setFlaggedAnimKnobLimited( "idle", animArrayPickRandom( "exposed_idle" ), 1, .2 );
		
		self waittillmatch( "idle", "end" );
	}
}


pop_up()
{
	if( self.a.coverMode != "hide" )
		return;

    if ( self.coverType == "crouch" )
		self setup_cover_crouch();
	else
		self setup_cover_stand();

	self.a.special = "none";

	self.a.coverMode = getBestCoverMode();
	
	self.changingCoverPos = true;
	
	popupAnim = animArray("hide_2_" + self.a.coverMode);
	
	self setFlaggedAnimKnobAllRestart( "anim", popUpAnim, %body, 1 , .1, 1.0 );
	self thread animscripts\shared::DoNoteTracks( "anim" );

	if ( animHasNoteTrack( popupAnim, "start_aim" ) )
	{
		self waittillmatch( "anim", "start_aim" );
		timeleft = getAnimLength( popupAnim ) * (1 - self getAnimTime( popupAnim ));
	}
	else
	{
		self waittillmatch( "anim", "end" );
		timeleft = .1;
	}
	
	self setup_additive_aim( timeleft );
	wait(timeleft);
	
	self.changingCoverPos = false;
	
	self clearAnim( popUpAnim, .2 );
}


setup_additive_aim( transTime )
{
	self setAnimKnobAll( animArray( self.a.coverMode + "_aim" ), %body, 1, transTime );
	if ( self.a.coverMode == "crouch" )
	{
		self setanimlimited(%covercrouch_aim2_add,1,0);
		self setanimlimited(%covercrouch_aim4_add,1,0);
		self setanimlimited(%covercrouch_aim6_add,1,0);
		self setanimlimited(%covercrouch_aim8_add,1,0);
	}
	else if ( self.a.coverMode == "stand" )
	{
		self setanimlimited(%exposed_aim_2,1,0);
		self setanimlimited(%exposed_aim_4,1,0);
		self setanimlimited(%exposed_aim_6,1,0);
		self setanimlimited(%exposed_aim_8,1,0);
	}
	else if ( self.a.coverMode == "lean" )
	{
		self setanimlimited(%exposed_aim_2,1,0);
		self setanimlimited(%exposed_aim_4,1,0);
		self setanimlimited(%exposed_aim_6,1,0);
		self setanimlimited(%exposed_aim_8,1,0);
		// these don't seem to have 45 degree aiming limits,
		// so i'm using the exposed ones instead
		/*self setanimlimited(%covercrouch_lean_aim2_add,1,0);
		self setanimlimited(%covercrouch_lean_aim4_add,1,0);
		self setanimlimited(%covercrouch_lean_aim6_add,1,0);
		self setanimlimited(%covercrouch_lean_aim8_add,1,0);*/
	}
}


go_to_hide()
{
	self notify("return_to_cover");
	
	self.changingCoverPos = true;
	
	self setFlaggedAnimKnobAll( "anim" , animArray( self.a.coverMode + "_2_hide" ), %body, 1, 0.2 );
	self clearAnim( %exposed_modern, 0.2 );
	
	self animscripts\shared::DoNoteTracks( "anim" );
	
	self.a.coverMode = "hide";
	
	if ( self.coverType == "stand" )
		self.a.special = "cover_stand";
	else
		self.a.special = "cover_crouch";
	
	self.changingCoverPos = false;
}


tryThrowingGrenadeStayHidden()
{
	// TODO: check suppression and add rambo grenade support
	return tryThrowingGrenade( true );
}


tryThrowingGrenade(safe)
{
	theanim = undefined;
	if ( isdefined(safe) && safe )
		theanim = animArrayPickRandom("grenade_safe");
	else
		theanim = animArrayPickRandom("grenade_exposed");
	
	self animMode ( "zonly_physics" ); // Unlatch the feet
	self.keepClaimedNodeInGoal = true;
	threwGrenade = TryGrenadePos( getEnemySightPos(), theanim, (32,20,64) );
	self.keepClaimedNodeInGoal = false;
	return threwGrenade;
}


blindfire()
{
	if ( !animArrayAnyExist( "blind_fire" ) )
		return false;
	
	self animMode ( "zonly_physics" );
	self.keepClaimedNodeInGoal = true;

	self setflaggedanimknobAll("blindfire", animArrayPickRandom("blind_fire"), %body, 1, 0, 1);
	result = self animscripts\shared::DoNoteTracks("blindfire");

	self.keepClaimedNodeInGoal = false;
	
	return true;
}

use_turret_while_i_can()
{
	turret = self.node.turret;

	turret show();
	turret.solid = true;
	turret maketurretusable();

	turretWasUsed = self useTurret( turret );
	
	self waittill ( "eternity" );
	
	/*
	assert( isdefined( self.node ) );
	assert( isdefined( self.node.turret ) );
	
	turret = self.node.turret;	
	if ( !turret.isSetup )
		return;

//	turret setmode( "auto_ai" ); // auto, auto_ai, manual, manual_ai
//	turret startFiring(); // seems to be a bug with the turret being in manual mode to start with
//	wait( 1 );
	thread maps\_mg_penetration::gunner_think( turret );
	self waittill( "continue_cover_script" );
	
//	turret thread maps\_spawner::restorePitch();
//	self useturret( turret ); // dude should be near the mg42
	*/
}

use_the_turret( turret )
{
	turretWasUsed = self useTurret( turret );

/*
	if ( turretWasUsed )
	{	
//		set_exception( "move", ::turret_user_moves ); // run this before running move so we might move the turret

		self.turret = spot;
		self thread mg42_firing( spot ); // does the burst fire timings
		spot setmode( "manual_ai" );
		spot thread restorePitch();
		self.turret = spot;
		spot.owner = self;
//		self useturret( spot ); // dude should be near the mg42
//		spot setmode( "manual_ai" ); // auto, auto_ai, manual
//		self.turret = spot;
		return true;
	}
	else
	{
		spot restoredefaultdroppitch();
		return false;
	}
*/
}


setup_crouching_anim_array()
{
	anim_array = [];
	
	anim_array["hide_idle"] = %covercrouch_hide_idle;
	anim_array["hide_idle_twitch"] = array(
		%covercrouch_twitch_1,
		%covercrouch_twitch_2,
		%covercrouch_twitch_3,
		%covercrouch_twitch_4
		//%covercrouch_twitch_5 // excluding #5 because it's a wave to someone behind him, and in idle twitches we don't know if that makes sense at the time
	);
	
	anim_array["hide_idle_flinch"] = array(
		/*%covercrouch_explosion_1,
		%covercrouch_explosion_2,
		%covercrouch_explosion_3*/ // these just don't look good for flinching
	);

	anim_array["hide_2_crouch"] = %covercrouch_hide_2_aim;
	anim_array["hide_2_stand"] = %covercrouch_hide_2_stand;
	anim_array["hide_2_lean"] = %covercrouch_hide_2_lean;

	anim_array["crouch_2_hide"] = %covercrouch_aim_2_hide;
	anim_array["stand_2_hide"] = %covercrouch_stand_2_hide;
	anim_array["lean_2_hide"] = %covercrouch_lean_2_hide;
	
	anim_array["crouch_aim"] = %covercrouch_aim5;
	anim_array["stand_aim"] = %exposed_aim_5;
	anim_array["lean_aim"] = %covercrouch_lean_aim5;
	
	anim_array["fire"] = %exposed_shoot_auto_v2;
	anim_array["semi2"] = %exposed_shoot_semi2;
	anim_array["semi3"] = %exposed_shoot_semi3; 
	anim_array["semi4"] = %exposed_shoot_semi4;
	anim_array["semi5"] = %exposed_shoot_semi5;

	anim_array["single"] = %exposed_shoot_semi1;

	anim_array["burst2"] = %exposed_shoot_burst3; // (will be limited to 2 shots)
	anim_array["burst3"] = %exposed_shoot_burst3;
	anim_array["burst4"] = %exposed_shoot_burst4;
	anim_array["burst5"] = %exposed_shoot_burst5;
	anim_array["burst6"] = %exposed_shoot_burst6;

	anim_array["blind_fire"] = array( %covercrouch_blindfire_1, %covercrouch_blindfire_2, %covercrouch_blindfire_3, %covercrouch_blindfire_4 );

	anim_array["reload"] = %covercrouch_reload_hide;
	
	anim_array["grenade_safe"] = array( %covercrouch_grenadeA, %covercrouch_grenadeB );
	anim_array["grenade_exposed"] = array( %exposed_grenadeThrowB, %exposed_grenadeThrowC );

	anim_array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );

	anim_array["look"] = array( %covercrouch_hide_look );

	self.a.array = anim_array;	
}


setup_standing_anim_array()
{	
	anim_array = [];
	
	anim_array["hide_idle"] = %coverstand_hide_idle;
	anim_array["hide_idle_twitch"] = array(
		%coverstand_hide_idle_twitch01,
		%coverstand_hide_idle_twitch02,
		%coverstand_hide_idle_twitch03,
		%coverstand_hide_idle_twitch04,
		%coverstand_hide_idle_twitch05
	);
	
	anim_array["hide_idle_flinch"] = array(
		%coverstand_react01,
		%coverstand_react02,
		%coverstand_react03,
		%coverstand_react04
	);

	anim_array["hide_2_stand"] = %coverstand_hide_2_aim;
	anim_array["stand_2_hide"] = %coverstand_aim_2_hide;

	anim_array["stand_aim"] = %exposed_aim_5;
	
	anim_array["fire"] = %exposed_shoot_auto_v2;
	anim_array["semi2"] = %exposed_shoot_semi2;
	anim_array["semi3"] = %exposed_shoot_semi3;
	anim_array["semi4"] = %exposed_shoot_semi4;
	anim_array["semi5"] = %exposed_shoot_semi5;

	anim_array["single"] = %exposed_shoot_semi1;

	anim_array["burst2"] = %exposed_shoot_burst3; // (will be limited to 2 shots)
	anim_array["burst3"] = %exposed_shoot_burst3;
	anim_array["burst4"] = %exposed_shoot_burst4;
	anim_array["burst5"] = %exposed_shoot_burst5;
	anim_array["burst6"] = %exposed_shoot_burst6;
	
	anim_array["blind_fire"] = array( %coverstand_blindfire_1, %coverstand_blindfire_2 /*, %coverstand_blindfire_3*/ ); // #3 looks silly
	
	anim_array["reload"] = %coverstand_reloadA;
	
	anim_array["look"] = array( %coverstand_look_quick, %coverstand_look_quick_v2 );
							
	anim_array["grenade_safe"] = array( %coverstand_grenadeA, %coverstand_grenadeB );
	anim_array["grenade_exposed"] = array( %exposed_grenadeThrowB, %exposed_grenadeThrowC );
							
	anim_array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
	
	anim_array["hide_to_look"] = %coverstand_look_moveup;
	anim_array["look_idle"] = %coverstand_look_idle;
	anim_array["look_to_hide"] = %coverstand_look_movedown;
	anim_array["look_to_hide_fast"] = %coverstand_look_movedown_fast;

	self.a.array = anim_array;	
}


loopHide( transTime )
{
	if ( !isdefined( transTime ) )
		transTime = .1;
	
	self setanimknoballrestart( animArray( "hide_idle" ), %body, 1, transTime );
	self.a.coverMode = "hide";	
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
			break;
		wait (0.1);
	}

	self notify ("stopShooting"); // For changing shooting pose to compensate for player moving
}


needToChangeCoverMode()
{
	return getBestCoverMode() != self.a.coverMode;
}


getBestCoverMode()
{
	if ( self.coverType != "crouch" )
		return "stand";

	offset = getShootPosVerticalComponent();
	
	if ( self.a.atConcealmentNode )
	{
		if ( offset <= -.45 )
			return "lean";
		if ( offset <= -.2 || !self.coverNode.crouchingIsOK )
			return "stand";
		return "crouch";
	}
	else
	{
		if ( offset < -.35 )
			return "lean";
		if ( offset < 0 || !self.coverNode.crouchingIsOK )
			return "stand";
		return "crouch";
	}
}


getShootPosVerticalComponent()
{
	shootPos = getEnemyEyePos();
	pos = self.coverNode.origin + getNodeOffset( self.coverNode );
	
	dir = (pos[0] - shootPos[0], pos[1] - shootPos[1], pos[2] - shootPos[2]);
	dir = VectorNormalize( dir );
	
	return dir[2] * -1;

	/*
	if ( !isdefined( self.shootPos ) )
		return 0;
	
	pos = self.coverNode.origin + getNodeOffset( self.coverNode );
	
	dir = (pos[0] - self.shootPos[0], pos[1] - self.shootPos[1], pos[2] - self.shootPos[2]);
	dir = VectorNormalize( dir );
	
	return dir[2] * -1;
	*/
}