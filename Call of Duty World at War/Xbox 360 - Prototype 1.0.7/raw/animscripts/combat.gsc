#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include animscripts\shared;
#include common_scripts\Utility;

#using_animtree ("generic_human");

main()
{
	self endon ("killanimscript");
	
	[[ self.exception[ "exposed" ] ]]();
	
	animscripts\utility::initialize("combat");
	
	self setup();
	self thread debugyaw();
	self exposedCombatMainLoop();
	
	self notify( "stop_deciding_how_to_shoot" );
}

idleThread()
{
	self endon("killanimscript");
	self endon("kill_idle_thread");
	for(;;)
	{
		idleAnim = animArrayPickRandom( "exposed_idle" );
		self setflaggedanimlimited("idle", idleAnim );
		self waittillmatch( "idle", "end" );
		self clearanim( idleAnim, .2 );
	}
}

// SETUP FUNCTIONS
setup()
{
	if ( usingSidearm() )
		transitionTo("stand");

	if(self.a.pose == "stand")
	{
		self set_animarray_standing();
	}
	else if(self.a.pose == "crouch")
	{
		self set_animarray_crouching();
	}
	else if ( self.a.pose == "prone" )
	{
		self ExitProneWrapper(1);
		self.a.pose = "crouch";
		self set_animarray_crouching();
	}
	else
	{
		assertMsg( "Unsupported self.a.pose: " + self.a.pose );
	}
	
	self.isturning = false;
	self.a.movement = "stop";	
	self.previousPitchDelta = 0.0;
	
	self clearAnim( %root, .3 );
	self setAnim( animarray("straight_level") ); 	
	self setAnim( %add_idle );
	self clearanim( %aim_4, .2 );
	self clearanim( %aim_6, .2 );
	self clearanim( %aim_2, .2 );
	self clearanim( %aim_8, .2 );
	
	setupAim( .2 );
	
	self thread idleThread();

	self.isshooting = false; 
	self.a.meleeState = "aim";
	self.twitchallowed = true;
}

setupAim( transTime )
{
	assert( isDefined( transTime ) );
	self setAnimKnobLimited( animArray("add_aim_up"   ), 1, transTime );
	self setAnimKnobLimited( animArray("add_aim_down" ), 1, transTime );
	self setAnimKnobLimited( animArray("add_aim_left" ), 1, transTime );
	self setAnimKnobLimited( animArray("add_aim_right"), 1, transTime );
}

set_animarray_standing()
{
	array = [];

	if ( usingSidearm() )
	{
		array["add_aim_up"] = %pistol_stand_aim_8_add;
		array["add_aim_down"] = %pistol_stand_aim_2_add;
		array["add_aim_left"] = %pistol_stand_aim_4_add;
		array["add_aim_right"] = %pistol_stand_aim_6_add;  
	
		array["turn_left_45"] = %pistol_stand_turn45L;
		array["turn_left_90"] = %pistol_stand_turn90L;
		array["turn_left_135"] = %exposed_tracking_turn135L;
		array["turn_left_180"] = %pistol_stand_turn180L;
		array["turn_right_45"] = %pistol_stand_turn45R;
		array["turn_right_90"] = %pistol_stand_turn90R;
		array["turn_right_135"] = %exposed_tracking_turn135R;
		array["turn_right_180"] = %pistol_stand_turn180L;
	
		array["straight_level"] = %pistol_stand_aim_5;
		array["shoot_single"] = %pistol_stand_fire_A;
		array["fire"] = %pistol_stand_fire_A;

		array["single"] = %pistol_stand_fire_A;

		array["reload"] = array( %pistol_stand_reload_A );
		array["reload_crouchhide"] = array();

		array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
		
		array["add_turn_aim_up"] = %pistol_stand_aim_8_alt;
		array["add_turn_aim_down"] = %pistol_stand_aim_2_alt;
		array["add_turn_aim_left"] = %pistol_stand_aim_4_alt;
		array["add_turn_aim_right"] = %pistol_stand_aim_6_alt;
	}
	else if ( weaponAnims() == "rocketlauncher" )
	{
		array["add_aim_up"] = %RPG_stand_aim_8;
		array["add_aim_down"] = %RPG_stand_aim_2;
		array["add_aim_left"] = %RPG_stand_aim_4;
		array["add_aim_right"] = %RPG_stand_aim_6;  

		array["turn_left_45"] = %exposed_tracking_turn45L;
		array["turn_left_90"] = %exposed_tracking_turn90L;
		array["turn_left_135"] = %exposed_tracking_turn135L;
		array["turn_left_180"] = %exposed_tracking_turn180L;
		array["turn_right_45"] = %exposed_tracking_turn45R;
		array["turn_right_90"] = %exposed_tracking_turn90R;
		array["turn_right_135"] = %exposed_tracking_turn135R;
		array["turn_right_180"] = %exposed_tracking_turn180L;		

		array["fire"] = %RPG_stand_fire;
		array["straight_level"] = %RPG_stand_aim_5;
		array["reload"] = array( %RPG_stand_reload );
		array["reload_crouchhide"] = array();

		array["exposed_idle"] = array( %RPG_stand_idle );
		
		array["add_turn_aim_up"] = %exposed_turn_aim_8;
		array["add_turn_aim_down"] = %exposed_turn_aim_2;
		array["add_turn_aim_left"] = %exposed_turn_aim_4;
		array["add_turn_aim_right"] = %exposed_turn_aim_6;
		
		array["single"] = %exposed_shoot_semi1;
		
		array["change_stance_to_crouch"] = %exposed_stand_2_crouch;
	}
	else
	{
		array["add_aim_up"] = %exposed_aim_8;
		array["add_aim_down"] = %exposed_aim_2;
		array["add_aim_left"] = %exposed_aim_4;
		array["add_aim_right"] = %exposed_aim_6;  

		array["turn_left_45"] = %exposed_tracking_turn45L;
		array["turn_left_90"] = %exposed_tracking_turn90L;
		array["turn_left_135"] = %exposed_tracking_turn135L;
		array["turn_left_180"] = %exposed_tracking_turn180L;
		array["turn_right_45"] = %exposed_tracking_turn45R;
		array["turn_right_90"] = %exposed_tracking_turn90R;
		array["turn_right_135"] = %exposed_tracking_turn135R;
		array["turn_right_180"] = %exposed_tracking_turn180L;		

		array["fire"] = %exposed_shoot_auto_v3;
		array["straight_level"] = %exposed_aim_5;
//		array["reload"] = array( %exposed_reload, %exposed_reloadb, %exposed_reloadc );
		array["reload"] = array( %exposed_reload );
		array["reload_crouchhide"] = array( %exposed_reloadb );
		
		array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );

		array["add_turn_aim_up"] = %exposed_turn_aim_8;
		array["add_turn_aim_down"] = %exposed_turn_aim_2;
		array["add_turn_aim_left"] = %exposed_turn_aim_4;
		array["add_turn_aim_right"] = %exposed_turn_aim_6;
		
		array["burst2"] = %exposed_shoot_burst3; // ( will be stopped after second bullet)
		array["burst3"] = %exposed_shoot_burst3;
		array["burst4"] = %exposed_shoot_burst4;
		array["burst5"] = %exposed_shoot_burst5;
		array["burst6"] = %exposed_shoot_burst6;
	
		array["idle1"] = %exposed_idle_alert_v1;
		array["idle2"] = %exposed_idle_alert_v2;
		array["idle3"] = %exposed_idle_alert_v3;
	//	array["idle4"] = %exposed_idle_alert_v4;
	//	array["idle5"] = %exposed_idle_alert_v5;

		array["single"] = %exposed_shoot_semi1;

		array["semi2"] = %exposed_shoot_semi2;
		array["semi3"] = %exposed_shoot_semi3;
		array["semi4"] = %exposed_shoot_semi4;
		array["semi5"] = %exposed_shoot_semi5;
		
		array["change_stance_to_crouch"] = %exposed_stand_2_crouch;
	}
	self.turnThreshold = 35;
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;

	self.turnleft180limit =  -130;
	self.turnright180limit = 130;
	self.turnleft90limit = -70;
	self.turnright90limit = 70; 

	self.a.array = array;
}

set_animarray_crouching()
{
	assert( !usingSidearm() );

	array = [];

	if ( weaponAnims() == "rocketlauncher" )
	{
		array["add_aim_up"] = %RPG_crouch_aim_8;
		array["add_aim_down"] = %RPG_crouch_aim_2;
		array["add_aim_left"] = %RPG_crouch_aim_4;
		array["add_aim_right"] = %RPG_crouch_aim_6;
	
		// temp: only have 90 degree turns for crouching, will look bad but work
		array["turn_left_45"] = %exposed_crouch_turn_left;
		array["turn_left_90"] = %exposed_crouch_turn_left;
		array["turn_left_135"] = %exposed_crouch_turn_left;
		array["turn_left_180"] = %exposed_crouch_turn_left;
		array["turn_right_45"] = %exposed_crouch_turn_right;
		array["turn_right_90"] = %exposed_crouch_turn_right;
		array["turn_right_135"] = %exposed_crouch_turn_right;
		array["turn_right_180"] = %exposed_crouch_turn_right;
	
		array["straight_level"] = %RPG_crouch_aim_5;
		array["fire"] = %RPG_crouch_fire;
		array["reload"] = array( %RPG_crouch_reload );
	
		array["add_turn_aim_up"] = %exposed_crouch_turn_aim_8;
		array["add_turn_aim_down"] = %exposed_crouch_turn_aim_2;
		array["add_turn_aim_left"] = %exposed_crouch_turn_aim_4;
		array["add_turn_aim_right"] = %exposed_crouch_turn_aim_6;
	
		array["single"] = %RPG_crouch_fire;
	
		array["exposed_idle"] = array( %RPG_crouch_idle );
		
		array["change_stance_to_stand"] = %exposed_crouch_2_stand;
	}
	else
	{
		array["add_aim_up"] = %exposed_crouch_aim_8;
		array["add_aim_down"] = %exposed_crouch_aim_2;
		array["add_aim_left"] = %exposed_crouch_aim_4;
		array["add_aim_right"] = %exposed_crouch_aim_6;
	
		// temp: only have 90 degree turns for crouching, will look bad but work
		array["turn_left_45"] = %exposed_crouch_turn_left;
		array["turn_left_90"] = %exposed_crouch_turn_left;
		array["turn_left_135"] = %exposed_crouch_turn_left;
		array["turn_left_180"] = %exposed_crouch_turn_left;
		array["turn_right_45"] = %exposed_crouch_turn_right;
		array["turn_right_90"] = %exposed_crouch_turn_right;
		array["turn_right_135"] = %exposed_crouch_turn_right;
		array["turn_right_180"] = %exposed_crouch_turn_right;
	
		array["straight_level"] = %exposed_crouch_aim_5;
		array["fire"] = %exposed_crouch_shoot_auto_v2;
		array["reload"] = array( %exposed_crouch_reload );
	
		array["single"] = %exposed_crouch_shoot_semi1;

		array["burst2"] = %exposed_crouch_shoot_burst3;
		array["burst3"] = %exposed_crouch_shoot_burst3;
		array["burst4"] = %exposed_crouch_shoot_burst4;
		array["burst5"] = %exposed_crouch_shoot_burst5;
		array["burst6"] = %exposed_crouch_shoot_burst6;
	
		array["add_turn_aim_up"] = %exposed_crouch_turn_aim_8;
		array["add_turn_aim_down"] = %exposed_crouch_turn_aim_2;
		array["add_turn_aim_left"] = %exposed_crouch_turn_aim_4;
		array["add_turn_aim_right"] = %exposed_crouch_turn_aim_6;
	
		array["semi2"] = %exposed_crouch_shoot_semi2;
		array["semi3"] = %exposed_crouch_shoot_semi3;
		array["semi4"] = %exposed_crouch_shoot_semi4;
		array["semi5"] = %exposed_crouch_shoot_semi5;
	
		array["exposed_idle"] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
		
		array["change_stance_to_stand"] = %exposed_crouch_2_stand;
	}
	self.turnThreshold = 45;
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;

	self.turnleft180limit =  -130;
	self.turnright180limit = 130;
	self.turnleft90limit = -70;
	self.turnright90limit = 70;
	
	self.a.array = array;
}

exposedCombatMainLoop()
{
	self endon ("killanimscript");
	self endon ("melee");
	
	self thread watchShootEntVelocity();
	
	self thread trackShootEntOrPos();
	
	self.a.exposedReloading = false;
	self thread ReacquireWhenNecessary();
	
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
	
	self animMode("zonly_physics");
	
	// before, we oriented to enemy briefly and then changed to face current.
	// now we just face current immediately and rely on turning.
	self OrientMode( "face angle", self.angles[1] );
	nextShootTime = 0;
	
	for(;;)
	{
		if ( self weaponAnims() == "rocketlauncher" )
			self.deathFunction = undefined;
		
		if ( EnsureStanceIsAllowed() )
			continue;

		if ( self.a.pose == "stand" )
			self set_animarray_standing();
		else if ( self.a.pose == "crouch" )
			self set_animarray_crouching();
		
		if ( TryMelee() )
			return;
		
		if ( !isdefined( self.shootPos ) )
		{
			assert( !isdefined( self.shootEnt ) );
			if ( noEnemyBehavior() )
				continue;
			
			wait(0.05);
			continue;
		}
		
		assert( isdefined( self.shootPos ) ); // we can use self.shootPos after this point.
		
		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		if ( lengthsquared( self.origin - self.shootPos ) < squared( 285 ) && self.a.pose != "stand" && self isStanceAllowed("stand") )
		{
			transitionTo("stand");
			continue;
		}

		// TODO: reenable grenade throws but avoid doing them at stupid times like after a weapon switch or reload
		if ( isdefined( self.enemy ) && considerThrowGrenade() ) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
			continue;
		
		if ( NeedToReload( 0 ) )
		{
			if ( !usingSidearm() && weaponAnims() != "rocketlauncher" && lengthsquared( self.origin - self.shootPos ) < squared( 512 ) && self isStanceAllowed("stand") )
			{
				// we need to be standing to switch weapons
				if ( self.a.pose != "stand" )
				{
					transitionTo("stand");
					continue;
				}
			
				if ( self tryUsingSidearm() )
					continue;
			}
			
			if ( self exposedReload(0) )
				continue;
		}
		
		if ( self weaponAnims() == "rocketlauncher" && self.a.pose != "crouch" && randomFloat( 1 ) > 0.65 )
			self.deathFunction = ::rpgDeath;

		yawToShootEntOrPos = getPredictedAimYawToShootEntOrPos( .25 ); // yaw to where we think our enemy will be in x seconds
		
		if (yawToShootEntOrPos < 0-self.turnThreshold)
		{
			self turn("left", 0-yawToShootEntOrPos);
			continue;
		}
		if (yawToShootEntOrPos > self.turnThreshold)
		{
			self turn("right",  yawToShootEntOrPos);
			continue;
		}
		
		if ( usingSidearm() && self.a.pose == "stand" && lengthsquared( self.origin - self.shootPos ) > squared( 512 ) && !self cansee( self.enemy ) )
			switchToLastWeapon( %pistol_stand_switch );
		
		if ( aimedAtShootEntOrPos() && gettime() >= nextShootTime )
		{
			self shootUntilNeedToTurn();
			self clearAnim( %additive, .2 );
			continue;
		}

		// idleThread() is running, so just waiting a bit will cause us to idle
		wait(0.05);
	}
}

needToTurn()
{
	yawToShootEntOrPos = getPredictedAimYawToShootEntOrPos( .25 ); // yaw to where we think our enemy will be in x seconds
	
	return (abs( yawToShootEntOrPos ) > self.turnThreshold);
}

EnsureStanceIsAllowed()
{
	curstance = self.a.pose;
	
	assert( curstance == "stand" || curstance == "crouch" );

	if ( !self isStanceAllowed( curstance ) )
	{
		otherstance = "crouch";
		if ( curstance == "crouch" )
			otherstance = "stand";
		
		if ( self isStanceAllowed( otherstance ) )
		{
			if ( curstance == "stand" && usingSidearm() )
			{
				switchToLastWeapon( %pistol_stand_switch );
				return true;
			}
			
			transitionTo( otherstance );
			return true;
		}
	}
	return false;
}

noEnemyBehavior()
{
	self setanim( %aim_4, 0, .5 );
	self setanim( %aim_6, 0, .5 );
	self setanim( %aim_2, 0, .5 );
	self setanim( %aim_8, 0, .5 );
	
	if ( self exposedReload( 0.99999 ) )
		return true;
	
	if ( usingSidearm() )
	{
		// switch back to main weapon so we can reload it too before another enemy appears
		switchToLastWeapon( %pistol_stand_switch );
		return true;
	}
	
	return false;
}

watchShootEntVelocity()
{
	self endon("killanimscript");

	self.shootEntVelocity = (0,0,0);

	prevshootent = undefined;
	prevpos = self.origin;
	
	interval = .15;
	
	while(1)
	{
		if ( isdefined( self.shootEnt ) && isdefined( prevshootent ) && self.shootEnt == prevshootent )
		{
			curpos = self.shootEnt.origin;
			self.shootEntVelocity = vectorScale( curpos - prevpos, 1 / interval );
			prevpos = curpos;
		}
		else
		{
			if ( isdefined( self.shootEnt ) )
				prevpos = self.shootEnt.origin;
			else
				prevpos = self.origin;
			prevshootent = self.shootEnt;
			
			self.shootEntVelocity = (0,0,0);
		}
		
		wait interval;
	}
}

endtwitch()
{
	self endon("killanimscript");
	wait(10);
	self.twitchallowed = true;	
}
debugYaw()
{
//	num = 0; 
//	for(;;)
//	{
//		println(num);
//		num++;
//		wait(1);	
//	}

//	for(;;)
//	{
//		if(!isdefined(self) || !isdefined(self.enemy))
//		{
//			wait(0.05);
//			continue;	
//		}	
//		println(getYawToEnemy());
//		wait(0.05);
//	}	
	
}

turnLastResort()
{
	//println("could not turn");
	self OrientMode("face enemy");

	interval = .05;
	max = 20; // 1 / interval
	
	// wait until our angle is good or up to 1 second, then stop
	for ( i = 0; i < max; i++ )
	{
		if ( abs( self getYawToEnemy() ) < 5 )
			break;
		wait interval;
	}
	
	self OrientMode( "face current" );	
}

turn( direction, amount )
{
	self animMode ( "zonly_physics" );
	
	angle = 0;
	if ( amount > 157.5 )
		angle = 180;
	else if ( amount > 112.5 )
		angle = 135;
	else if ( amount > 67.5 )
		angle = 90;
	else
		angle = 45;
	
	animname = "turn_" + direction + "_" + angle;
	
	self setAnimKnob(%exposed_aiming, 1, .2);
	
	// we do the turn animation even if the delta isn't allowed, because a little foot sliding looks better than turntabling.
	/*if ( !isDeltaAllowed( animarray(animname) ) )
	{
		self turnLastResort();
		return;
	}*/
	
	oldangle = self.angles[1];
	

	self.isturning = true;
	
	self _TurningAimingOn( .2 );
	
	self setAnimLimited( %turn, 1, .2 );
	
	self setFlaggedAnimKnobLimitedRestart( "turn", animarray(animname), 1, 0 );
	self notify("turning");
	self.isshooting = false;
	self thread shootWhileTurning();
	
	self animscripts\shared::DoNoteTracks( "turn" );
	
	self setanimlimited( %turn, 0, .2 );
	
	self _TurningAimingOff( .2 );
	
	self clearanim( %turn, .2 );
	self setanimknob( %exposed_aiming, 1, .2, 1 );


	// if we didn't actually turn, code prevented us from doing so.
	// give up and turntable; it's better than trying the same thing again.
	if ( self.angles[1] == oldangle )
		self turnLastResort();
	
	
	self notify("done turning");
	self.isturning = false;
}

_TurningAimingOn( transTime )
{
	self setAnimLimited    ( animarray("straight_level")    , 0, transTime );
	
	/*self setanimlimited( animarray("add_aim_up"   )     , 0, transTime );
	self setanimlimited( animarray("add_aim_down" )     , 0, transTime );
	self setanimlimited( animarray("add_aim_left" )     , 0, transTime );
	self setanimlimited( animarray("add_aim_right")     , 0, transTime );*/
	
	/*self setAnimKnobLimited( animarray("add_turn_aim_up"   ), 1, transTime );
	self setAnimKnobLimited( animarray("add_turn_aim_down" ), 1, transTime );
	self setAnimKnobLimited( animarray("add_turn_aim_left" ), 1, transTime );
	self setAnimKnobLimited( animarray("add_turn_aim_right"), 1, transTime );*/
	
	self setAnim( %add_idle, 0, transTime );
}

_TurningAimingOff( transTime )
{
	self setAnimLimited    ( animarray("straight_level")    , 1, transTime );
	
	/*self setAnimKnobLimited( animarray("add_aim_up"   )     , 1, transTime );
	self setAnimKnobLimited( animarray("add_aim_down" )     , 1, transTime );
	self setAnimKnobLimited( animarray("add_aim_left" )     , 1, transTime );
	self setAnimKnobLimited( animarray("add_aim_right")     , 1, transTime );*/
	
	/*self setanimlimited( animarray("add_turn_aim_up"   ), 0, transTime );
	self setanimlimited( animarray("add_turn_aim_down" ), 0, transTime );
	self setanimlimited( animarray("add_turn_aim_left" ), 0, transTime );
	self setanimlimited( animarray("add_turn_aim_right"), 0, transTime );*/
	
	self setAnim( %add_idle, 1, transTime );
}

shootWhileTurning()
{
	self endon("killanimscript");
	self endon("done turning");
	
	shootUntilShootBehaviorChange();
	
	self clearAnim( %additive, .2 );
}

shootUntilNeedToTurn()
{
	self thread watchForNeedToTurnOrTimeout();
	self endon("need_to_turn");
	
	self thread keepTryingToMelee();
	
	shootUntilShootBehaviorChange();
	
	self notify("stop_watching_for_need_to_turn");
	self notify("stop_trying_to_melee");
}

watchForNeedToTurnOrTimeout()
{
	self endon("killanimscript");
	self endon("stop_watching_for_need_to_turn");
	
	endtime = gettime() + 4000 + randomint(2000);
	
	while(1)
	{
		if ( gettime() > endtime || abs( self animscripts\shared::getAimYawToShootEntOrPos() ) > self.turnThreshold )
		{
			self notify("need_to_turn");
			break;
		}
		wait .1;
	}
}

shootUntilShootBehaviorChange()
{
	self endon("shoot_behavior_change");

	maps\_gameskill::resetAccuracyAndPause();
	
	if ( self weaponAnims() == "rocketlauncher" )
		wait ( randomFloat( 2.0 ) );
	
	if ( self.shootStyle == "full" )
	{
		self FireUntilOutOfAmmo( animArray( "fire" ), false );
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
		self waittill( "hell freezes over" ); // waits for the endons to happen
	}
}

considerThrowGrenade()
{
	threw = false;
	// if the player is within a sane distance, try throwing a grenade
	if(valueIsWithin(lengthSquared((self.origin - self.enemy GetOrigin())),squared(512),squared(1024)) && !self.isshooting && self.a.pose == "stand")
	{
//		if(randomint(100) > 75)
//		{
			yaw = getyawtoenemy();
			if(yaw < 15 && yaw > -15)
			{
				throwAnims = [];
				if ( isDeltaAllowed(%exposed_grenadeThrowB) )
					throwAnims[throwAnims.size] = %exposed_grenadeThrowB;
				if ( isDeltaAllowed(%exposed_grenadeThrowC) )
					throwAnims[throwAnims.size] = %exposed_grenadeThrowC;
				
				if ( throwAnims.size > 0 )
				{
					self setanim(%exposed_aiming, 0, .1);
					self animMode( "zonly_physics" );
					
					setAnimAimWeight(0, 0);
					
					threw = TryGrenade( throwAnims[randomint(throwAnims.size)], (32,0,64) );
					
					self setanim(%exposed_aiming, 1, .1);
					
					if ( threw )
						setAnimAimWeight(1, .5); // ease into aiming
					else
						setAnimAimWeight(1, 0);
				}
			}
//		}
	}
	
	return threw;
}

transitionTo(newPose)
{
	self.isshooting = false;
	if ( newPose == self.a.pose )
		return;
	
	self clearanim( %root, .3 );
	
	self notify("kill_idle_thread");
	
	transanim = animarray("change_stance_to_" + newPose);
	self setFlaggedAnimRestart( "trans", transanim, 1, .2, 2 ); // temp: playing at 2x speed because it's too slow
	self thread finishNoteTracks( "trans" );
	
	wait (getanimlength( transanim ) * .5 - .25); // TODO: do this less hacky when "start_aim" is in

	//assert( self.a.pose == newPose ); // TODO: put this back when the notetracks are in
	self.a.pose = newPose; // failsafe

	if ( newPose == "stand" )
		self set_animarray_standing();
	else if ( newPose == "crouch" )
		self set_animarray_crouching();
		
	self setAnimKnobAllRestart( animarray("straight_level"), %body, 1, .25 );
	setupAim( .25 );
	
	self setAnim( %add_idle );
	self thread idleThread();
}

keepTryingToMelee()
{
	self endon("killanimscript");
	self endon("stop_trying_to_melee");
	self endon("done turning");
	self endon("need_to_turn");
	self endon("shoot_behavior_change");
	
	while(1)
	{
		wait .2 + randomfloat(.3);
		
		// this function is running when we're doing something like shooting or reloading.
		// we only want to melee if we would look really stupid by continuing to do what we're trying to get done.
		// only melee if our enemy is very close.
		if ( isdefined(self.enemy) && (distanceSquared(self.enemy.origin, self.origin) < 100*100) && TryMelee() )
			return;
	}
}

TryMelee()
{
	if ( !isdefined( self.enemy ) )
		return false;
	
	// can't melee while sidearm is out.
	// we rely on main loop to put away sidearm if necessary.
	if ( usingSidearm() )
		return false;
	
	if ( !usingSidearm() || !NeedToReload( 0 ) )
	{
		// we have other options, so don't melee unless we're really close
		if ( distanceSquared(self.enemy.origin, self.origin) > 128*128 )
			return false;
	}

	canMelee = animscripts\melee::CanMeleeDesperate();
	
	if ( !canMelee )
		return false;

	// TODO: this is dangerous. during a weapon switch, our enemy might die/change or the situation might change in other ways.
	// TryMelee needs to return false if it's not possible to *immediately* start a melee,
	// so the global logic function needs to be the one to do the weapon switch if it's necessary.
	//switchToLastWeapon( %pistol_stand_switch_F );
	
	self thread animscripts\melee::MeleeCombat();
	self notify("melee");

	return true;
}

exposedReload(threshold)
{
	if ( NeedToReload( threshold ) )
	{
		self.a.exposedReloading = true;
		
		reloadAnim = animArrayPickRandom( "reload" );
		
		// if crouching will give us cover while reloading, do it
		if ( self.a.pose == "stand" && animArrayAnyExist( "reload_crouchhide" ) && isdefined( self.enemy ) && self canSee( self.enemy ) )
		{
			if ( !sightTracePassed( self.origin + (0,0,50), self.enemy getShootAtPos(), false, undefined ) )
				reloadAnim = animArrayPickRandom( "reload_crouchhide" );
		}
		
		self thread keepTryingToMelee();
		
		self setanim(%reload,1,.2);
		self setanim(%exposed_aiming, 0, .2);
		
		self.finishedReload = false;
		self doReloadAnim( reloadAnim, threshold > .05 ); // this will return at the time when we should start aiming
		self notify("abort_reload"); // make sure threads that doReloadAnim() started finish
		
		if ( self.finishedReload )
			self animscripts\weaponList::RefillClip();
		
		self setanimrestart(%exposed_aiming,1,.2);
		self clearanim(%reload,.2);
		
		self notify("stop_trying_to_melee");
		
		self.a.exposedReloading = false;
		
		return true;
	}
	
	return false;
}

doReloadAnim( reloadAnim, stopWhenCanShoot )
{
	self endon("abort_reload");
	if ( stopWhenCanShoot )
		self thread abortReloadWhenCanShoot();
	
	// make sure we have a different flag name than before
	// or else sometimes we'll get the same notify twice
	if ( !isdefined( anim.reloadFlagNameIndex ) )
		anim.reloadFlagNameIndex = 0;
	flagName = "reload_" + anim.reloadFlagNameIndex;
	anim.reloadFlagNameIndex++;
	
	self setflaggedanimknoballrestart( flagName, reloadAnim ,%root,1,.2);
	self thread notifyOnStartAim( "abort_reload", flagName );
	self endon("start_aim");
	self animscripts\shared::DoNoteTracks( flagName );
}

abortReloadWhenCanShoot()
{
	self endon("abort_reload");
	while(1)
	{
		if ( isdefined( self.shootEnt ) && self canSee( self.shootEnt ) )
			break;
		wait .05;
	}
	self notify("abort_reload");
}

notifyOnStartAim( endonStr, flagName )
{
	self endon( endonStr );
	self waittillmatch( flagName, "start_aim" );
	self notify( "start_aim" );
}

finishNoteTracks(animname)
{
	self endon("killanimscript");
	animscripts\shared::DoNoteTracks(animname);
}

drop_turret()
{
	maps\_mgturret::dropTurret();
//	level.theturret = turret;
//	throwVel = 75 + randomInt(50);

//	self animscripts\shared::PutGunInHand("right");
	self animscripts\weaponList::RefillClip();
	self.a.needsToRechamber = 0;
	self notify ("dropped_gun");
	maps\_mgturret::restoreDefaults();
}

exception_exposed_mg42_portable()
{
	drop_turret();
}


tryUsingSidearm()
{
	switchToSidearm( %pistol_stand_pullout );
	return true;
}


switchToSidearm( swapAnim )
{
	self endon ( "killanimscript" );
	assert( self.sidearm != "" );
	
	self thread putGunBackInHandOnKillAnimScript();

	self.swapAnim = swapAnim;
	self setFlaggedAnimKnobAllRestart("weapon swap", swapAnim, %body, 1, .1, 1);
	self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePickup, "end_weapon_swap" );
	self setAnim( self.swapAnim, 0 );
}

DoNoteTracksPostCallbackWithEndon( flagName, interceptFunction, endonMsg )
{
	self endon( endonMsg );
	self animscripts\shared::DoNoteTracksPostCallback( flagName, interceptFunction );
}

handlePickup( notetrack )
{
	if ( notetrack == "pistol_pickup" )
	{
		self clearAnim( animarray("straight_level"), 0 );
		self set_animarray_standing();
	}
	else if ( notetrack == "start_aim" )
	{
		if ( self needToTurn() )
		{
			self notify("end_weapon_swap");
		}
		else
		{
			self setAnimLimited( animarray("straight_level"), 1, 0 );
			setupAim( 0 );
			self setAnim( %exposed_aiming, 1, .2 );
		}
	}
}


// %pistol_stand_switch
switchToLastWeapon( swapAnim )
{
	self endon ( "killanimscript" );

	assert( self.lastWeapon != getAISidearmWeapon() );
	assert( self.lastWeapon == getAIPrimaryWeapon() || self.lastWeapon == getAISecondaryWeapon() );
	
	self.swapAnim = swapAnim;
	self setFlaggedAnimKnobAllRestart( "weapon swap", swapAnim, %body, 1, .1, 1 );
	self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePutaway, "end_weapon_swap" );
	self setAnim( self.swapAnim, 0 );
}

handlePutaway( notetrack )
{
	if ( notetrack == "pistol_putaway" )
	{
		self clearAnim( animarray("straight_level"), 0 );
		self set_animarray_standing();
	}
	else if ( notetrack == "start_aim" )
	{
		if ( self needToTurn() )
		{
			self notify("end_weapon_swap");
		}
		else
		{
			self setAnimLimited( animarray("straight_level"), 1, 0 );
			setupAim( 0 );
			self setAnim( %exposed_aiming, 1, .2 );
		}
	}
}

squared( value )
{
	return value * value;
}

rpgDeath()
{
	if ( randomFloat( 1 ) > 0.5 )
		self SetFlaggedAnimKnobAll( "deathanim", %RPG_stand_death, %root, 1, .05, 1 );
	else
		self SetFlaggedAnimKnobAll( "deathanim", %RPG_stand_death_stagger, %root, 1, .05, 1 );

	self animscripts\shared::DoNoteTracks( "deathanim" );
	self animscripts\shared::DropAIWeapon();
	return;
}

ReacquireWhenNecessary()
{
	self endon("killanimscript");
	self endon("melee");
	
	while(1)
	{
		TryExposedReacquire();
		
		wait .05;
	}
}

// this function is meant to be called many times in succession.
// each time it tries another option, until eventually it finds something it can do.
TryExposedReacquire()
{
	if ( !isValidEnemy(self.enemy) )
	{
		self.reacquire_state = 0;
		return;
	}
	
	// look for cover unless you're reloading while hidden
	// also avoid going to cover before trying a sidestep
	if ( self.reacquire_state > 2 && (self canSee( self.enemy ) || !self.a.exposedReloading) )
	{
		if ( self FindCoverNearSelf() )
		{
			self.reacquire_state = 0;
			return;
		}
	}
	
	if ( self canSee( self.enemy ) )
	{
		self.reacquire_state = 0;
		return;
	}
	
	if ( self.a.exposedReloading && NeedToReload( .25 ) )
	{
		self.reacquire_state = 0;
		return;
	}
	
	switch (self.reacquire_state)
	{
	case 0:
		if (self ReacquireStep(32))
		{
			assert(self.reacquire_state == 0);
			return;
		}
		break;

	case 1:
		if (self ReacquireStep(64))
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 2:
		if (self ReacquireStep(96))
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 3:
		self FindReacquireNode();
		self.reacquire_state++;
		// fall through

	case 4:
		node = self GetReacquireNode();
		if (isdefined(node))
		{			
			oldKeepNodeInGoal = self.keepClaimedNodeInGoal;
			oldKeepNode = self.keepClaimedNode;
			self.keepClaimedNodeInGoal = false;
			self.keepClaimedNode = false;

			if (self UseReacquireNode(node))
			{
				self.reacquire_state = 0;
			}
			else
			{
				self.keepClaimedNodeInGoal = oldKeepNodeInGoal;
				self.keepClaimedNode = oldKeepNode;
			}
			
			return;
		}
		break;

	case 5:
		self FindReacquireDirectPath();
		self.reacquire_state++;
		// fall through

	case 6:
		// attempt to find a path that does not run out of goal and that can see the enemy (shorten path by 1 each call)
		if (self TrimPathToAttack())
			return;
		// path has succeeded or fully failed
		if (self ReacquireMove())
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	case 7:
		self FindReacquireProximatePath();
		self.reacquire_state++;
		// fall through

	case 8:
		// attempt to find a path that does not run out of goal and that can see the enemy (shorten path by 1 each call)
		if (self TrimPathToAttack())
			return;
		// path has succeeded or fully failed
		if (self ReacquireMove())
		{
			self.reacquire_state = 0;
			return;
		}
		break;

	default:
		assert(self.reacquire_state == 9);
		self.reacquire_state = 0;
		if ( !(self canSee( self.enemy )) )
			self FlagEnemyUnattackable();
		return;
	}
	
	self.reacquire_state++;
}

shouldGoToNode( node )
{
	// if we're close to our enemy, and we can see them,
	// don't run away from them.
	
	if ( !isValidEnemy( self.enemy ) )
		return true;
	
	if ( !isSentient( self.enemy ) )
		return true;
	
	if ( !self cansee( self.enemy ) )
		return true;
	
	// we're in our enemy's line of sight.
	
	enemyAngles = undefined;
	if ( isplayer( self.enemy ) ) {
		enemyAngles = self.enemy getPlayerAngles();
	}
	else {
		// would like to use tag_weapon, but no way to tell if they have one or not
		enemyAngles = self.enemy.angles;
	}
	
	angleToEnemyLook = vectordot( anglesToForward( enemyAngles ), vectornormalize( self.origin - self.enemy.origin ) );
	
	// if we're far away and our enemy isn't looking at us, it's ok to move
	if ( distanceSquared( self.origin, self.enemy.origin ) > 400 * 400 && angleToEnemyLook < cos( 10 ) )
		return true;
	
	// if the cover is between us and our enemy, it's ok to move
	enemyDist = distance( self.origin, self.enemy.origin );
	if ( distance( self.enemy.origin, node.origin ) < enemyDist * .8 && distance( self.origin, node.origin ) < enemyDist * .8 )
		return true;
	
	// don't turn our back.
	return false;
}
