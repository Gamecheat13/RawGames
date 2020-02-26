#include animscripts\Utility;
#include animscripts\SetPoseMovement;
#include animscripts\Combat_utility;
#include animscripts\shared;
#include common_scripts\Utility;

#using_animtree ("generic_human");

main()
{
	prof_begin("combat_init");
	
	self endon ("killanimscript");
	
	[[ self.exception[ "exposed" ] ]]();
	
	animscripts\utility::initialize("combat");
	self.a.arrivalType = undefined;
	
	/#
	//testAnims();
	#/
	
	/#
	if ( getdvar("scr_testgrenadethrows") == "on" )
		testGrenadeThrowAnimOffsets();
	#/
	
	//if ( self.fixedNode && self isingoal( self.origin ) )
	//	self.keepClaimedNodeInGoal = true;
	
	self setup();
	
	prof_end("combat_init");
	
	self exposedCombatMainLoop();
	
	self notify( "stop_deciding_how_to_shoot" );
}

/#
testAnims()
{
	testanims = [];
	/*testanims[0] = %covercrouch_pain_front;
	testanims[1] = %covercrouch_pain_left;
	testanims[2] = %covercrouch_pain_left_2;
	testanims[3] = %covercrouch_pain_left_3;
	testanims[4] = %covercrouch_pain_right;
	testanims[5] = %covercrouch_pain_right_2;
	testanims[6] = %covercrouch_pain_right_3;*/
	//testanims[0] = %coverstand_pain_groin;
	//testanims[1] = %coverstand_pain_leg;
	
	/*testanims[0] = %shotgun_stand_reload_A;
	testanims[1] = %shotgun_stand_reload_B;
	testanims[2] = %shotgun_stand_reload_C;*/
	
	/*testanims[0] = %dying_back_death_v1;
	testanims[1] = %dying_back_death_v2;
	testanims[2] = %dying_back_death_v3;
	testanims[3] = %dying_back_death_v4;*/
	
	testanims[0] = %coverstand_mini_approach_1;
	testanims[1] = %coverstand_mini_approach_2;
	testanims[2] = %coverstand_mini_approach_3;
	testanims[3] = %coverstand_mini_approach_4;
	testanims[4] = %coverstand_mini_approach_6;
	
	
	for ( i = 0; i < testanims.size; i++ )
	{
		println(testanims[i]);
		self setFlaggedAnimKnobAllRestart( "animtest", testanims[i], %root, 1, 0, 1 );
		self waittillmatch("animtest", "end");
	}
}
#/

/#
testGrenadeThrowAnimOffsets()
{
	testanims = [];
	testanims[0] = %exposed_grenadeThrowB;
	testanims[1] = %exposed_grenadeThrowC;
	testanims[2] = %corner_standL_grenade_A;
	testanims[3] = %corner_standL_grenade_B;
	testanims[4] = %CornerCrL_grenadeA;
	testanims[5] = %CornerCrL_grenadeB;
	testanims[6] = %corner_standR_grenade_A;
	testanims[7] = %corner_standR_grenade_B;
	testanims[8] = %CornerCrR_grenadeA;
	testanims[9] = %covercrouch_grenadeA;
	testanims[10] = %covercrouch_grenadeB;
	testanims[11] = %coverstand_grenadeA;
	testanims[12] = %coverstand_grenadeB;
	testanims[13] = %prone_grenade_A;
	
	model = getGrenadeModel();
	
	self animmode("zonly_physics");
	for ( i = 0; i < testanims.size; i++ )
	{
		forward = anglestoforward( self.angles );
		right   = anglestoright( self.angles );
		startpos = self.origin;
		
		tag = "TAG_INHAND";
		
		self setFlaggedAnimKnobAllRestart( "grenadetest", testanims[i], %root, 1, 0, 1 );
		for (;;)
		{
			self waittill("grenadetest", notetrack);
			if ( notetrack == "grenade_left" || notetrack == "grenade_right" )
				self attach (model, tag);
			if ( notetrack == "grenade_throw" || notetrack == "grenade throw" )
				break;
			assert(notetrack != "end"); // we shouldn't hit "end" until after we've hit "grenade_throw"!
			if ( notetrack == "end" ) // failsafe
				break;
		}
		
		pos = self getTagOrigin( tag );
		baseoffset = pos - startpos;
		
		offset = ( vectordot( baseoffset, forward ), -1 * vectordot( baseoffset, right ), baseoffset[2] );
		
		// check our answer =)
		endpos = startpos + forward * offset[0] - right * offset[1] + (0,0,1) * offset[2];
		thread debugLine( startpos, endpos, (1,1,1), 20 );
		
		//println( "^2Grenade throw anim #" + i + " (", testanims[i], "): offset = " + pos );
		println( "else if ( throwAnim == %", testanims[i], " ) offset = ", pos, ";" );
		
		self detach(model, tag);
		
		wait 1;
	}
}
#/

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
		self set_animarray_prone();
	}
	else
	{
		assertMsg( "Unsupported self.a.pose: " + self.a.pose );
	}
	
	self.isturning = false;
	self thread stopShortly();
	self.previousPitchDelta = 0.0;
	
	self clearAnim( %root, .2 );
	self setAnim( animarray("straight_level") );
	self setAnim( %add_idle );
	self clearanim( %aim_4, .2 );
	self clearanim( %aim_6, .2 );
	self clearanim( %aim_2, .2 );
	self clearanim( %aim_8, .2 );
	
	setupAim( .2 );
	
	self thread idleThread();

	self.a.meleeState = "aim";
	self.twitchallowed = true;
}

stopShortly()
{
	self endon("killanimscript");
	self endon("melee");
	// we want to stop at about the time we blend out of whatever we were just doing.
	wait .2;
	self.a.movement = "stop";
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
	self.a.array = [];

	if ( usingSidearm() )
	{
		self.a.array["add_aim_up"] = %pistol_stand_aim_8_add;
		self.a.array["add_aim_down"] = %pistol_stand_aim_2_add;
		self.a.array["add_aim_left"] = %pistol_stand_aim_4_add;
		self.a.array["add_aim_right"] = %pistol_stand_aim_6_add;  
	
		self.a.array["straight_level"] = %pistol_stand_aim_5;
		self.a.array["fire"] = %pistol_stand_fire_A;

		self.a.array["single"] = array( %pistol_stand_fire_A );

		self.a.array["reload"] = array( %pistol_stand_reload_A );
		self.a.array["reload_crouchhide"] = array();

		self.a.array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );
		
		self.a.array["turn_left_45"] = %pistol_stand_turn45L;
		self.a.array["turn_left_90"] = %pistol_stand_turn90L;
		self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
		self.a.array["turn_left_180"] = %pistol_stand_turn180L;
		self.a.array["turn_right_45"] = %pistol_stand_turn45R;
		self.a.array["turn_right_90"] = %pistol_stand_turn90R;
		self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
		self.a.array["turn_right_180"] = %pistol_stand_turn180L;
	
		self.a.array["add_turn_aim_up"] = %pistol_stand_aim_8_alt;
		self.a.array["add_turn_aim_down"] = %pistol_stand_aim_2_alt;
		self.a.array["add_turn_aim_left"] = %pistol_stand_aim_4_alt;
		self.a.array["add_turn_aim_right"] = %pistol_stand_aim_6_alt;
	}
	else if ( weaponAnims() == "rocketlauncher" )
	{
		self.a.array["add_aim_up"] = %RPG_stand_aim_8;
		self.a.array["add_aim_down"] = %RPG_stand_aim_2;
		self.a.array["add_aim_left"] = %RPG_stand_aim_4;
		self.a.array["add_aim_right"] = %RPG_stand_aim_6;  

		self.a.array["fire"] = %RPG_stand_fire;
		self.a.array["straight_level"] = %RPG_stand_aim_5;
		self.a.array["reload"] = array( %RPG_stand_reload );
		self.a.array["reload_crouchhide"] = array();

		self.a.array["exposed_idle"] = array( %RPG_stand_idle );
		
		self.a.array["single"] = array( %exposed_shoot_semi1 );
		
		self.a.array["crouch_2_stand"] = %exposed_crouch_2_stand;
		self.a.array["crouch_2_prone"] = %crouch_2_prone;
		self.a.array["stand_2_crouch"] = %exposed_stand_2_crouch;
		self.a.array["stand_2_prone"] = %stand_2_prone;
		self.a.array["prone_2_crouch"] = %prone_2_crouch;
		self.a.array["prone_2_stand"] = %prone_2_stand;

		self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
		self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
		self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
		self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
		self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
		self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
		self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
		self.a.array["turn_right_180"] = %exposed_tracking_turn180L;		

		self.a.array["add_turn_aim_up"] = %exposed_turn_aim_8;
		self.a.array["add_turn_aim_down"] = %exposed_turn_aim_2;
		self.a.array["add_turn_aim_left"] = %exposed_turn_aim_4;
		self.a.array["add_turn_aim_right"] = %exposed_turn_aim_6;
	}
	else
	{
		// uncomment this once shotgun_aim_4 and shotgun_aim_6 are fixed
		if ( self usingShotgun() )
		{
			self.a.array["add_aim_up"] = %shotgun_aim_8;
			self.a.array["add_aim_down"] = %shotgun_aim_2;
			self.a.array["add_aim_left"] = %shotgun_aim_4;
			self.a.array["add_aim_right"] = %shotgun_aim_6;
			
			self.a.array["straight_level"] = %shotgun_aim_5;
			self.a.array["reload"] = array( %shotgun_stand_reload_A, %shotgun_stand_reload_B, %shotgun_stand_reload_C, %shotgun_stand_reload_C, %shotgun_stand_reload_C ); // (C is standing, want it more often)
			self.a.array["reload_crouchhide"] = array( %shotgun_stand_reload_A, %shotgun_stand_reload_B );
		}
		else if ( self isCQBWalking() )
		{
			self.a.array["add_aim_up"] = %CQB_stand_aim8;
			self.a.array["add_aim_down"] = %CQB_stand_aim2;
			self.a.array["add_aim_left"] = %CQB_stand_aim4;
			self.a.array["add_aim_right"] = %CQB_stand_aim6;
			
			self.a.array["fire"] = %exposed_shoot_auto_v3;
			self.a.array["straight_level"] = %CQB_stand_aim5;
			self.a.array["reload"] = array( %CQB_stand_reload_steady );
			self.a.array["reload_crouchhide"] = array( %CQB_stand_reload_knee );
		}
		else
		{
			self.a.array["add_aim_up"] = %exposed_aim_8;
			self.a.array["add_aim_down"] = %exposed_aim_2;
			self.a.array["add_aim_left"] = %exposed_aim_4;
			self.a.array["add_aim_right"] = %exposed_aim_6;  
	
			self.a.array["fire"] = %exposed_shoot_auto_v3;
			self.a.array["straight_level"] = %exposed_aim_5;
			self.a.array["reload"] = array( %exposed_reload ); // %exposed_reloadb, %exposed_reloadc
			self.a.array["reload_crouchhide"] = array( %exposed_reloadb );
		}
		
		self.a.array["exposed_idle"] = array( %exposed_idle_alert_v1, %exposed_idle_alert_v2, %exposed_idle_alert_v3 );

		self.a.array["burst2"] = %exposed_shoot_burst3; // ( will be stopped after second bullet)
		self.a.array["burst3"] = %exposed_shoot_burst3;
		self.a.array["burst4"] = %exposed_shoot_burst4;
		self.a.array["burst5"] = %exposed_shoot_burst5;
		self.a.array["burst6"] = %exposed_shoot_burst6;
	
		self.a.array["idle1"] = %exposed_idle_alert_v1;
		self.a.array["idle2"] = %exposed_idle_alert_v2;
		self.a.array["idle3"] = %exposed_idle_alert_v3;

		if ( isdefined( self.weapon ) && weaponClass( self.weapon ) == "spread" )
		{
			self.a.array["single"] = array( %shotgun_stand_fire_1A, %shotgun_stand_fire_1B );
		}
		else
		{
			self.a.array["single"] = array( %exposed_shoot_semi1 );
		}

		self.a.array["semi2"] = %exposed_shoot_semi2;
		self.a.array["semi3"] = %exposed_shoot_semi3;
		self.a.array["semi4"] = %exposed_shoot_semi4;
		self.a.array["semi5"] = %exposed_shoot_semi5;
		
		self.a.array["crouch_2_stand"] = %exposed_crouch_2_stand;
		self.a.array["crouch_2_prone"] = %crouch_2_prone;
		self.a.array["stand_2_crouch"] = %exposed_stand_2_crouch;
		self.a.array["stand_2_prone"] = %stand_2_prone;
		self.a.array["prone_2_crouch"] = %prone_2_crouch;
		self.a.array["prone_2_stand"] = %prone_2_stand;

		self.a.array["turn_left_45"] = %exposed_tracking_turn45L;
		self.a.array["turn_left_90"] = %exposed_tracking_turn90L;
		self.a.array["turn_left_135"] = %exposed_tracking_turn135L;
		self.a.array["turn_left_180"] = %exposed_tracking_turn180L;
		self.a.array["turn_right_45"] = %exposed_tracking_turn45R;
		self.a.array["turn_right_90"] = %exposed_tracking_turn90R;
		self.a.array["turn_right_135"] = %exposed_tracking_turn135R;
		self.a.array["turn_right_180"] = %exposed_tracking_turn180L;		

		self.a.array["add_turn_aim_up"] = %exposed_turn_aim_8;
		self.a.array["add_turn_aim_down"] = %exposed_turn_aim_2;
		self.a.array["add_turn_aim_left"] = %exposed_turn_aim_4;
		self.a.array["add_turn_aim_right"] = %exposed_turn_aim_6;
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
}

set_animarray_crouching()
{
	assert( !usingSidearm() );

	self.a.array = [];

	if ( weaponAnims() == "rocketlauncher" )
	{
		self.a.array["add_aim_up"] = %RPG_crouch_aim_8;
		self.a.array["add_aim_down"] = %RPG_crouch_aim_2;
		self.a.array["add_aim_left"] = %RPG_crouch_aim_4;
		self.a.array["add_aim_right"] = %RPG_crouch_aim_6;
	
		self.a.array["straight_level"] = %RPG_crouch_aim_5;
		self.a.array["fire"] = %RPG_crouch_fire;
		self.a.array["reload"] = array( %RPG_crouch_reload );
	
		self.a.array["single"] = array( %RPG_crouch_fire );
	
		self.a.array["exposed_idle"] = array( %RPG_crouch_idle );
	}
	else
	{
		self.a.array["add_aim_up"] = %exposed_crouch_aim_8;
		self.a.array["add_aim_down"] = %exposed_crouch_aim_2;
		self.a.array["add_aim_left"] = %exposed_crouch_aim_4;
		self.a.array["add_aim_right"] = %exposed_crouch_aim_6;
	
		self.a.array["straight_level"] = %exposed_crouch_aim_5;
		self.a.array["fire"] = %exposed_crouch_shoot_auto_v2;
	
		if ( isdefined( self.weapon ) && weaponClass( self.weapon ) == "spread" )
		{
			self.a.array["single"] = array( %shotgun_crouch_fire );
			self.a.array["reload"] = array( %shotgun_crouch_reload );
		}
		else
		{
			self.a.array["single"] = array( %exposed_crouch_shoot_semi1 );
			self.a.array["reload"] = array( %exposed_crouch_reload );
		}

		self.a.array["burst2"] = %exposed_crouch_shoot_burst3;
		self.a.array["burst3"] = %exposed_crouch_shoot_burst3;
		self.a.array["burst4"] = %exposed_crouch_shoot_burst4;
		self.a.array["burst5"] = %exposed_crouch_shoot_burst5;
		self.a.array["burst6"] = %exposed_crouch_shoot_burst6;
	
		self.a.array["semi2"] = %exposed_crouch_shoot_semi2;
		self.a.array["semi3"] = %exposed_crouch_shoot_semi3;
		self.a.array["semi4"] = %exposed_crouch_shoot_semi4;
		self.a.array["semi5"] = %exposed_crouch_shoot_semi5;
	
		self.a.array["exposed_idle"] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
	}
	
	// we probably need an RPG version of this one
	self.a.array["crouch_2_stand"] = %exposed_crouch_2_stand;
	self.a.array["crouch_2_prone"] = %crouch_2_prone;
	self.a.array["stand_2_crouch"] = %exposed_stand_2_crouch;
	self.a.array["stand_2_prone"] = %stand_2_prone;
	self.a.array["prone_2_crouch"] = %prone_2_crouch;
	self.a.array["prone_2_stand"] = %prone_2_stand;
	
	// temp: only have 90 degree turns for crouching, will look bad but work
	self.a.array["turn_left_45"] = %exposed_crouch_turn_left;
	self.a.array["turn_left_90"] = %exposed_crouch_turn_left;
	self.a.array["turn_left_135"] = %exposed_crouch_turn_left;
	self.a.array["turn_left_180"] = %exposed_crouch_turn_left;
	self.a.array["turn_right_45"] = %exposed_crouch_turn_right;
	self.a.array["turn_right_90"] = %exposed_crouch_turn_right;
	self.a.array["turn_right_135"] = %exposed_crouch_turn_right;
	self.a.array["turn_right_180"] = %exposed_crouch_turn_right;

	self.a.array["add_turn_aim_up"] = %exposed_crouch_turn_aim_8;
	self.a.array["add_turn_aim_down"] = %exposed_crouch_turn_aim_2;
	self.a.array["add_turn_aim_left"] = %exposed_crouch_turn_aim_4;
	self.a.array["add_turn_aim_right"] = %exposed_crouch_turn_aim_6;

	self.turnThreshold = 45;
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;

	self.turnleft180limit =  -130;
	self.turnright180limit = 130;
	self.turnleft90limit = -70;
	self.turnright90limit = 70;
}


set_animarray_prone()
{
	assert( !usingSidearm() );

	self.a.array = [];

	self.a.array["add_aim_up"] = %prone_aim_8_add;
	self.a.array["add_aim_down"] = %prone_aim_2_add;
	self.a.array["add_aim_left"] = %prone_aim_4_add;
	self.a.array["add_aim_right"] = %prone_aim_6_add;

	self.a.array["straight_level"] = %prone_aim_5;
	self.a.array["fire"] = %prone_fire_1;

	self.a.array["single"] = array( %prone_fire_1 );
	self.a.array["reload"] = array( %prone_reload );

	self.a.array["burst2"] = %prone_fire_burst;
	self.a.array["burst3"] = %prone_fire_burst;
	self.a.array["burst4"] = %prone_fire_burst;
	self.a.array["burst5"] = %prone_fire_burst;
	self.a.array["burst6"] = %prone_fire_burst;

	self.a.array["semi2"] = %prone_fire_burst;
	self.a.array["semi3"] = %prone_fire_burst;
	self.a.array["semi4"] = %prone_fire_burst;
	self.a.array["semi5"] = %prone_fire_burst;

	self.a.array["exposed_idle"] = array( %exposed_crouch_idle_alert_v1, %exposed_crouch_idle_alert_v2, %exposed_crouch_idle_alert_v3 );
		
	self.a.array["crouch_2_stand"] = %exposed_crouch_2_stand;
	self.a.array["crouch_2_prone"] = %crouch_2_prone;
	self.a.array["stand_2_crouch"] = %exposed_stand_2_crouch;
	self.a.array["stand_2_prone"] = %stand_2_prone;
	self.a.array["prone_2_crouch"] = %prone_2_crouch;
	self.a.array["prone_2_stand"] = %prone_2_stand;	

	self.turnThreshold = 45;
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;

	self.turnleft180limit =  -130;
	self.turnright180limit = 130;
	self.turnleft90limit = -70;
	self.turnright90limit = 70;
}


exposedCombatMainLoop()
{
	self endon ("killanimscript");
	self endon ("melee");
	
	prof_begin("combat_init2");
	
	self thread trackShootEntOrPos();
	
	self thread ReacquireWhenNecessary();
	
	self thread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
	
	self thread watchShootEntVelocity();
	
	self thread attackEnemyWhenFlashed();
	
	self animMode("zonly_physics");
	
	// before, we oriented to enemy briefly and then changed to face current.
	// now we just face current immediately and rely on turning.
	self OrientMode( "face angle", self.angles[1] );
	nextShootTime = 0;
	
	self resetGiveUpOnEnemyTime();
	
	// hesitate to crouch.
	// crouching too early can look stupid because we'll tend to stand right back up in a lot of cases.
	self.a.dontCrouchTime = gettime() + randomintrange( 500, 1500 );
	
	prof_end("combat_init2");
	
	prof_begin("combat");
	
	justWaited = false;
	
	for(;;)
	{
		if ( self weaponAnims() == "rocketlauncher" )
			self.deathFunction = undefined;
		
		self IsInCombat(); // reset our in-combat state
		
		if ( !justWaited )
		{
			prof_begin("combat_setanimarray");
			if ( self.a.pose == "stand" )
				self set_animarray_standing();
			else if ( self.a.pose == "crouch" )
				self set_animarray_crouching();
			else
				self set_animarray_prone();
				
			prof_end("combat_setanimarray");
		}
		justWaited = false;
		
		prof_begin("combat_partA");
		// it is important for this to be *after* the set_animarray calls!
		if ( EnsureStanceIsAllowed() )
			continue;
		
		if ( TryMelee() )
			return;
		
		if ( !isdefined( self.shootPos ) )
		{
			assert( !isdefined( self.shootEnt ) );
			cantSeeEnemyBehavior();
			continue;
		}
		
		assert( isdefined( self.shootPos ) ); // we can use self.shootPos after this point.
		self resetGiveUpOnEnemyTime();
		
		// if we're too close to our enemy, stand up
		// (285 happens to be the same distance at which we leave cover and go into exposed if our enemy approaches)
		distSqToShootPos = lengthsquared( self.origin - self.shootPos );

		// too close for RPG or out of ammo
		if ( weaponAnims() == "rocketlauncher" && (distSqToShootPos < squared( 512 ) || self.a.rockets < 1 ) )
		{
			if ( self.a.pose != "stand" && self.a.pose != "crouch" )
				transitionTo("crouch");
			
			if ( self.a.pose == "stand" )
				animscripts\shared::throwDownWeapon( %RPG_stand_throw );
			else
				animscripts\shared::throwDownWeapon( %RPG_crouch_throw );
			
			continue;
		}

		if ( self.a.pose != "stand" && self isStanceAllowed("stand") )
		{
			if ( distSqToShootPos < squared( 285 ) )
			{
				transitionTo("stand");
				continue;
			}
			if ( standIfMakesEnemyVisible() )
				continue;
		}

		if ( needToTurn() )
		{
			yawToShootEntOrPos = getPredictedAimYawToShootEntOrPos( .25 ); // yaw to where we think our enemy will be in x seconds
			if ( TurnToFaceRelativeYaw( yawToShootEntOrPos ) )
				continue;
		}
		
		if ( considerThrowGrenade() ) // TODO: make considerThrowGrenade work with shootPos rather than only self.enemy
			continue;
		
		prof_end("combat_partA");
		
		prof_begin("combat_partB");
		
		/#
		// dev only
		if ( self.a.pose != "prone" && !usingSidearm() && isdefined( self.forceSideArm ) && self.forceSideArm )
		{
			self tryUsingSidearm();
			continue;
		}
		#/
		
		if ( NeedToReload( 0 ) )
		{
			// TODO: tweak prone exposed reloading to be considered safer
			// requiring self.weapon == self.primaryweapon because we dont want him to drop his shotgun and then, if wantshotgun = false, decide to pick up his rifle when he's done
			if ( !usingSidearm() && weaponAnims() != "rocketlauncher" && self.weapon == self.primaryweapon && lengthsquared( self.origin - self.shootPos ) < squared( 512 ) && self isStanceAllowed("stand") )
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

		if ( usingSidearm() && self.a.pose == "stand" && lengthsquared( self.origin - self.shootPos ) > squared( 512 ) )
			switchToLastWeapon( %pistol_stand_switch );
		
		if ( distSqToShootPos > squared( 600 ) && self.a.pose != "crouch" && self isStanceAllowed("crouch") && !usingSidearm() && gettime() >= self.a.dontCrouchTime )
		{
			if ( !isdefined( self.shootPos ) || sightTracePassed( self.origin + (0,0,36), self.shootPos, false, undefined ) )
			{
				transitionTo("crouch");
				continue;
			}
		}

		if ( aimedAtShootEntOrPos() && gettime() >= nextShootTime )
		{
			self shootUntilNeedToTurn();
			if ( !self usingShotgun() )
				self clearAnim( %additive, .2 );
			continue;
		}
		
		prof_end("combat_partB");

		// idleThread() is running, so just waiting a bit will cause us to idle
		exposedWait();
		justWaited = true;
	}
	
	prof_end("combat");
}

exposedWait()
{
	if ( !isdefined( self.enemy ) || !self cansee( self.enemy ) )
	{
		self endon("enemy");
		self endon("shoot_behavior_change");
		
		wait 0.3 + randomfloat( 0.2 );
	}
	else
	{
		wait 0.05;
	}
}

standIfMakesEnemyVisible()
{
	assert( self.a.pose != "stand" );
	assert( self isStanceAllowed("stand") );
	if ( isdefined( self.enemy ) && (!self cansee( self.enemy ) || !self canShoot( self.enemy getShootAtPos() )) && sightTracePassed( self.origin + (0,0,64), self.enemy getShootAtPos(), false, undefined ) )
	{
		self.a.dontCrouchTime = gettime() + 3000;
		transitionTo("stand");
		return true;
	}
	return false;
}

needToTurn()
{
	yawToShootEntOrPos = getAimYawToShootEntOrPos(); // yaw to where we think our enemy will be in x seconds
	
	return (abs( yawToShootEntOrPos ) > self.turnThreshold);
}

EnsureStanceIsAllowed()
{
	curstance = self.a.pose;
	
	if ( !self isStanceAllowed( curstance ) )
	{
		assert( curstance == "stand" || curstance == "crouch" || curstance == "prone" );
		
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

cantSeeEnemyBehavior()
{
	prof_begin("combat_cantSeeEnemyBehavior");
	
	if ( self.a.pose != "stand" && self isStanceAllowed("stand") && standIfMakesEnemyVisible() )
		return true;
	
	time = gettime();
	
	self.a.dontCrouchTime = time + 1500;
	
	if ( isdefined( self.node ) && self.node.type == "Guard" )
	{
		relYaw = AngleClamp180( self.angles[1] - self.node.angles[1] );			
		if ( self TurnToFaceRelativeYaw( relYaw ) )
			return true;
	}
	else if ( time > self.a.scriptStartTime + 1200 )
	{
		likelyEnemyDir = self getAnglesToLikelyEnemyPath();
		if ( isdefined( likelyEnemyDir ) )
		{
			relYaw = AngleClamp180( self.angles[1] - likelyEnemyDir[1] );
			if ( self TurnToFaceRelativeYaw( relYaw ) )
				return true;
		}
	}
	
	if ( considerThrowGrenade() )
		return true;
	
	givenUpOnEnemy = (self.a.nextGiveUpOnEnemyTime < time);
	
	threshold = 0;
	if ( givenUpOnEnemy )
		threshold = 0.99999;
	
	if ( self exposedReload( threshold ) )
		return true;
	
	if ( givenUpOnEnemy && usingSidearm() )
	{
		// switch back to main weapon so we can reload it too before another enemy appears
		switchToLastWeapon( %pistol_stand_switch );
		return true;
	}

	/*if ( shouldSwapShotgun() )
	{
		self swapShotgun();
		return true;
	}*/
	
	cantSeeEnemyWait();	
	return true;
}

cantSeeEnemyWait()
{
	self endon("shoot_behavior_change");
	
	wait 0.5 + randomfloat( 0.5 );
}

resetGiveUpOnEnemyTime()
{
	self.a.nextGiveUpOnEnemyTime = gettime() + randomintrange( 2000, 4000 );
}

TurnToFaceRelativeYaw( faceYaw )
{
	if ( faceYaw < 0-self.turnThreshold )
	{
		if ( self.a.pose == "prone" )
		{
			self animscripts\cover_prone::proneTo( "crouch" );
			self set_animarray_crouching();
		}

		self turn("left", 0-faceYaw);
		self maps\_gameskill::didSomethingOtherThanShooting();
		return true;
	}
	if ( faceYaw > self.turnThreshold )
	{
		if ( self.a.pose == "prone" )
		{
			self animscripts\cover_prone::proneTo( "crouch" );
			self set_animarray_crouching();
		}

		self turn("right",  faceYaw);
		self maps\_gameskill::didSomethingOtherThanShooting();
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

shouldSwapShotgun()
{
	return false; // anims aren't set up yet
	
	/*
	if ( self.a.pose != "stand" )
		return false;
	
	if ( self usingSidearm() )
		return false;
	
	usingShotgun = (weaponclass( self.primaryweapon ) == "spread");
	wantShotgun = isdefined( self.wantShotgun ) && self.wantShotgun );
	
	if ( wantShotgun == usingShotgun )
		return false;
	
	if ( !wantShotgun ) // there is no standing shotgun putaway animation
		return false;
	
	return true;*/
}

/*swapShotgun()
{
	assert( self shouldSwapShotgun() );
	assert( isdefined( self.wantShotgun ) );
	
	if ( self.wantShotgun )
	{
		self setFlaggedAnimKnobAllRestart( "weapon_swap", %shotgun_stand_pullout, %body, 1, .2, 1 );
		
		self thread DoNoteTracksWithEndon( "weapon_swap" );
		
		self waittill( "weapon_swap", "" );
		self waittill( "weapon_swap", "end" );
	}
	else
	{
		assert(false); // we don't have a standing shotgun putaway animation
	}
}*/

DoNoteTracksWithEndon( animname )
{
	self endon("killanimscript");
	self animscripts\shared::DoNoteTracks( animname );
}

endtwitch()
{
	self endon("killanimscript");
	wait(10);
	self.twitchallowed = true;	
}

turnLastResort()
{
	//println("could not turn");
	self OrientMode("face enemy");

	interval = .05;
	max = 20; // 1 / interval
	
	prevYaw = self.angles[1];
	
	framesWithoutMovement = 0;
	
	// wait until our angle is good or up to 1 second, then stop
	for ( i = 0; i < max; i++ )
	{
		wait interval;
		if ( self.angles[1] == prevYaw )
		{
			framesWithoutMovement++;
			if ( framesWithoutMovement >= 2 )
				break;
		}
		else
		{
			framesWithoutMovement = 0;
		}
		prevYaw = self.angles[1];
	}
	
	self OrientMode( "face current" );	
}

isDeltaAllowed( theanim )
{
	delta = getMoveDelta( theanim, 0, 1 );
	endPoint = self localToWorldCoords( delta );
	
	return self isInGoal( endPoint ) && self mayMoveToPoint( endPoint );
}

turn( direction, amount )
{
	knowWhereToShoot = isdefined( self.shootPos );
	rate = 1;
	transTime = 0.2;
	if ( isdefined( self.enemy ) && self canSee( self.enemy ) && distanceSquared( self.enemy.origin, self.origin ) < 512*512 )
	{
		urgency = 1.0 - (distance( self.enemy.origin, self.origin ) / 512);
		rate = 1 + urgency * 1;
		
		// ( ensure transTime <= 0.2 / rate )
		if ( rate > 2 )
			transTime = .05;
		else if ( rate > 1.3 )
			transTime = .1;
		else
			transTime = .15;
		
		if ( gettime() == self.a.scriptStartTime )
			transTime = 0.25; // if it's the first thing we're doing, always blend slowly
	}

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
	turnanim = animarray(animname);
	
	if ( isDeltaAllowed( turnanim ) )
		self animMode( "zonly_physics" );
	else
		self animmode( "angle deltas" );
	
	self setAnimKnobAll( %exposed_aiming, %body, 1, transTime );

	self.isturning = true;
	
	self _TurningAimingOn( transTime );
	
	self setAnimLimited( %turn, 1, transTime );
	
	self setFlaggedAnimKnobLimitedRestart( "turn", turnanim, 1, 0, rate );
	self notify("turning");
	
	if ( knowWhereToShoot )
		self thread shootWhileTurning();
	
	doTurnNotetracks();
	
	self setanimlimited( %turn, 0, .2 );
	
	self _TurningAimingOff( .2 );
	
	self clearanim( %turn, .2 );
	self setanimknob( %exposed_aiming, 1, .2, 1 );


	// if we didn't actually turn, code prevented us from doing so.
	// give up and turntable.
	if ( isdefined( self.turnLastResort ) )
	{
		self.turnLastResort = undefined;
		self turnLastResort();
	}
	
	if ( !self usingShotgun() )
		self clearAnim( %additive, .2 );
	
	self animMode ( "zonly_physics" );
	
	self notify("done turning");
	self.isturning = false;
}

doTurnNotetracks()
{
	self endon("turning_isnt_working");
	self thread makeSureTurnWorks();
	self animscripts\shared::DoNoteTracks( "turn" );
}

makeSureTurnWorks()
{
	self endon("killanimscript");
	self endon("done turning");
	
	startAngle = self.angles[1];
	
	wait .3;
	
	if ( self.angles[1] == startAngle )
	{
		self notify("turning_isnt_working");
		self.turnLastResort = true;
	}
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
	
	if ( self weaponAnims() == "rocketlauncher" )
		return;
	
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
		if ( gettime() > endtime || needToTurn() )
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

	if ( self weaponAnims() == "rocketlauncher" )
	{
		if ( isDefined( self.enemy ) && self.enemy != level.player )
			self.enemy animscripts\battlechatter_ai::addThreatEvent( "infantry", self, 1.0 );
		wait ( randomFloat( 2.0 ) );
	}
	
	while(1)
	{
		burstDelay(); // waits only if necessary
		
		if ( self.shootStyle == "full" )
		{
			self FireUntilOutOfAmmo( animArray( "fire" ), false, animscripts\shared::decideNumShotsForFull() );
		}
		else if ( self.shootStyle == "burst" || self.shootStyle == "single" || self.shootStyle == "semi" )
		{
			numShots = 1;
			if ( self.shootStyle == "burst" || self.shootStyle == "semi" )
				numShots = animscripts\shared::decideNumShotsForBurst();	
				
			if ( numShots == 1 )
				self FireUntilOutOfAmmo( animArrayPickRandom( "single" ), true, numShots );
			else
				self FireUntilOutOfAmmo( animArray( self.shootStyle + numShots ), true, numShots );
		}
		else
		{
			assert( self.shootStyle == "none" );
			self waittill( "hell freezes over" ); // waits for the endons to happen
		}

		if ( !self.bulletsInClip )
			break;
	}
}

considerThrowGrenade()
{
	if ( isdefined( anim.throwGrenadeAtPlayerASAP ) && isAlive( level.player ) )
	{
		if ( tryThrowGrenade( level.player, 200 ) )
			return true;
	}
	
	if ( isdefined( self.enemy ) )
		return tryThrowGrenade( self.enemy, 850 );
	
	return false;
}

tryThrowGrenade( throwAt, minDist )
{
	threw = false;

	throwSpot = throwAt.origin;
	if ( !self canSee( throwAt ) )
	{
		if ( isdefined( self.enemy ) && throwAt == self.enemy && isdefined( self.shootPos ) )
			throwSpot = self.shootPos;
	}

	if ( lengthSquared( self.origin - throwSpot ) > minDist*minDist && self.a.pose == "stand" )
	{
		yaw = GetYawToSpot( throwSpot );
		if ( yaw < 45 && yaw > -45 )
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
				
				threw = TryGrenade( throwAt, throwAnims[randomint(throwAnims.size)] );
				
				self setanim(%exposed_aiming, 1, .1);
				
				if ( threw )
					setAnimAimWeight(1, .5); // ease into aiming
				else
					setAnimAimWeight(1, 0);
			}
		}
	}
	
	if ( threw )
		self maps\_gameskill::didSomethingOtherThanShooting();
	
	return threw;
}

transitionTo( newPose )
{
	if ( newPose == self.a.pose )
		return;
	
	// no stance change anims when using sidearm!
	assert( !usingSidearm() );
	
	self clearanim( %root, .3 );
	
	self notify( "kill_idle_thread" );
	
	transAnim = animArray( self.a.pose + "_2_" + newPose );
	if ( newPose == "stand" )
		rate = 2; // gotta stand up fast!
	else
		rate = 1;
	
	if ( !animHasNoteTrack( transAnim, "anim_pose = \"" + newPose + "\"" ) )
	{
		println( "error: " + self.a.pose + "_2_" + newPose + " missing notetrack to set pose!" );
	}

	self setFlaggedAnimKnobAllRestart( "trans", transanim, %body, 1, .2, rate );
	transTime = getAnimLength( transanim ) / rate;
	playTime = transTime - 0.3;
	if ( playTime < 0.2 )
		playTime = 0.2;
	self animscripts\shared::DoNoteTracksForTime( playTime, "trans" );
	
	self.a.pose = newPose;

	if ( newPose == "stand" )
		self set_animarray_standing();
	else if ( newPose == "crouch" )
		self set_animarray_crouching();
		
	self setAnimKnobAllRestart( animarray("straight_level"), %body, 1, .25 );
	setupAim( .25 );
	
	self setAnim( %add_idle );
	self thread idleThread();
	
	self maps\_gameskill::didSomethingOtherThanShooting();
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
	
	if ( self.a.pose == "prone" )
		return false;
		
	// can't melee while sidearm is out. need animations for this.
	// we rely on main loop to put away sidearm if necessary.
	if ( usingSidearm() )
		return false;
	
	if ( !usingSidearm() || !NeedToReload( 0 ) )
	{
		// we have other options, so don't melee unless we're really close
		if ( distanceSquared(self.enemy.origin, self.origin) > 200*200 )
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
		
		self setanim( %reload,1,.2 );
		self setanim( %exposed_aiming, 0, .2 );
		
		self.finishedReload = false;
		self doReloadAnim( reloadAnim, threshold > .05 ); // this will return at the time when we should start aiming
		self notify("abort_reload"); // make sure threads that doReloadAnim() started finish
		
		if ( self.finishedReload )
			self animscripts\weaponList::RefillClip();
		
		self setanimrestart(%exposed_aiming,1,.2);
		self clearanim(%reload,.2);
		
		self notify("stop_trying_to_melee");
		
		self.a.exposedReloading = false;
		
		self maps\_gameskill::didSomethingOtherThanShooting();
		
		return true;
	}
	
	return false;
}

doReloadAnim( reloadAnim, stopWhenCanShoot )
{
	self endon("abort_reload");
	if ( stopWhenCanShoot )
		self thread abortReloadWhenCanShoot();
	
	animRate = 1;
	/*if ( !self usingSidearm() && !self usingShotgun() && isdefined( self.enemy ) && self canSee( self.enemy ) && distanceSquared( self.enemy.origin, self.origin ) < 1024*1024 )
	{
		dist = distance( self.enemy.origin, self.origin );
		urgency = 1 - ((dist - 512.0) / 512.0);
		if ( urgency > 1 )
			urgency = 1;
		animRate = 1 + urgency * 1;
	}*/
	
	// make sure we have a different flag name than before
	// or else sometimes we'll get the same notify twice
	if ( !isdefined( anim.reloadFlagNameIndex ) )
		anim.reloadFlagNameIndex = 0;
	flagName = "reload_" + anim.reloadFlagNameIndex;
	anim.reloadFlagNameIndex++;
	
	self setflaggedanimknoballrestart( flagName, reloadAnim, %root, 1, .2, animRate );
	self thread notifyOnStartAim( "abort_reload", flagName );
	self endon("start_aim");
	self animscripts\shared::DoNoteTracks( flagName );
	
	self.finishedReload = true;
}

abortReloadWhenCanShoot()
{
	self endon("abort_reload");
	self endon("killanimscript");
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
	self.finishedReload = true;
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
	self setFlaggedAnimKnobAllRestart("weapon swap", swapAnim, %body, 1, .2, 1);
	self DoNoteTracksPostCallbackWithEndon( "weapon swap", ::handlePickup, "end_weapon_swap" );
	self setAnim( self.swapAnim, 0 );
	
	self maps\_gameskill::didSomethingOtherThanShooting();
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
	
	self maps\_gameskill::didSomethingOtherThanShooting();
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

rpgDeath()
{
	if ( randomFloat( 1 ) > 0.5 )
		self SetFlaggedAnimKnobAll( "deathanim", %RPG_stand_death, %root, 1, .05, 1 );
	else
		self SetFlaggedAnimKnobAll( "deathanim", %RPG_stand_death_stagger, %root, 1, .05, 1 );

	self animscripts\shared::DoNoteTracks( "deathanim" );
	self animscripts\shared::DropAllAIWeapons();
	return;
}

ReacquireWhenNecessary()
{
	self endon("killanimscript");
	self endon("melee");
	
	self.a.exposedReloading = false;
	// don't look for a cover node right away. stand and fight.
	self.a.lookForNewCoverTime = gettime() + randomintrange( 3000, 6000 );

	if ( self.fixedNode )
		return;

	while(1)
	{
		wait .05;
		
		if ( self.fixedNode )
			return;
		
		TryExposedReacquire();
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
	if ( self.reacquire_state > 2 && gettime() >= self.a.lookForNewCoverTime && (!self.a.exposedReloading || self canSee( self.enemy )) )
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
	
	if ( self.a.exposedReloading && NeedToReload( .25 ) && self.enemy.health > self.enemy.maxhealth * .5 )
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
		if ( self.a.script != "combat" )
		{
			self.reacquire_state = 0;
			return;
		}

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
		if ( tryRunningToEnemy() )
		{
			self.reacquire_state = 0;
			return;
		}
			
		break;

	default:
		assert(self.reacquire_state == 6);
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
