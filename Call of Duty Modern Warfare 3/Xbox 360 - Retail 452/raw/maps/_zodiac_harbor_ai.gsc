#include animscripts\combat_utility;
#include animscripts\shared;
#include animscripts\utility;
#include maps\_utility;
#include maps\_shg_common;
#using_animtree( "generic_human" );

debug_setup()
{
	entnum = self getentitynumber();
	name = "zodiac_idle" + entnum;
	y=160;
	if (isdefined(level._zodiac_idle_y))
	{
		y = level._zodiac_idle_y + 20;
		level._zodiac_idle_y = y;
	}
	else
		level._zodiac_idle_y = y;
	CreateDebugTextHud( name, 20, y, (1,1,1) );
	self.zodiac_last_update = 1.0;
	self.zodiac_ticked = 1;
	self thread debug_thread();
}

debug_thread()
{
	self endon("death");
	entnum = self getentitynumber();
	name = "zodiac_idle" + entnum;
	entname = self.script_friendname;
	if (!isdefined(entname))
		entname = self.script_noteworthy;
	if (!isdefined(entname))
		entname = ""+entnum;
	while (true)
	{
		waittillframeend;
		if (!self.zodiac_ticked)
		{
			self.zodiac_last_update -= 0.05;
			c = self.zodiac_last_update;
			if (self.zodiac_last_update <= 0)
			{
				self.zodiac_last_update = 0.0;
				PrintDebugTextStringHud( name, entname + ":" );	// clear out the comment
				c = 1.0;
			}
			ChangeDebugTextHudColor( name, (c,c,c) );
		}
		self.zodiac_ticked = 0;
		wait 0.05;
	}
}

debug_update( comment )
{
/*
	self.zodiac_ticked = 1;
	entnum = self getentitynumber();
	entname = self.script_friendname;
	if (!isdefined(entname))
		entname = self.script_noteworthy;
	if (!isdefined(entname))
		entname = ""+entnum;
		
	name = "zodiac_idle" + entnum;
	if (comment != "")
	{
		PrintDebugTextStringHud( name, entname + ":" + comment );
		self.zodiac_last_update = 1.0;
	}
	else
	{
		self.zodiac_last_update -= 0.05;
		if (self.zodiac_last_update <= 0)
		{
			self.zodiac_last_update = 0.0;
			PrintDebugTextStringHud( name, entname + ":" + comment );
		}
	}
	c = self.zodiac_last_update;
	if (self.zodiac_last_update <= 0)
		c = 1.0;
	ChangeDebugTextHudColor( name, (c,c,c) );
*/
}

main()
{
	anim.boatanims = [];
	anim.boatanims[ "left" ] = spawnstruct();
	anim.boatanims[ "left" ].base = %zodiac_aim_left;
	anim.boatanims[ "left" ].trans = %zodiac_harbor_trans_R2L; // Why would we use the "R_2_L" animation to transition from the "left" pose to the "right" pose, you ask? I don't know, my friend. I don't know.
	anim.boatanims[ "left" ].aim = spawnstruct();
	anim.boatanims[ "left" ].aim.left = %zodiac_harbor_rightside_aim4;
	anim.boatanims[ "left" ].aim.center = %zodiac_harbor_rightside_aim5;
	anim.boatanims[ "left" ].aim.right = %zodiac_harbor_rightside_aim6;
	anim.boatanims[ "left" ].reload = array( %zodiac_harbor_rightside_reload );
	anim.boatanims[ "left" ].leftAimLimit = -49;
	anim.boatanims[ "left" ].rightAimLimit = 48;
	anim.boatanims[ "left" ].slowidle = %zodiac_harbor_rightside_idle;
	anim.boatanims[ "left" ].idle = %zodiac_harbor_rightside_bump_idle;
	anim.boatanims[ "left" ].altidle = %zodiac_harbor_rightside_idle_short;
	anim.boatanims[ "left" ].react = %zodiac_harbor_rightside_react;
	anim.boatanims[ "left" ].twitch = array( %zodiac_harbor_rightside_shift, %zodiac_harbor_rightside_react );
	
	anim.boatanims[ "right" ] = spawnstruct();
	anim.boatanims[ "right" ].base = %zodiac_aim_right;
	anim.boatanims[ "right" ].trans = %zodiac_harbor_trans_L2R;
	anim.boatanims[ "right" ].aim = spawnstruct();
	anim.boatanims[ "right" ].aim.left = %zodiac_harbor_leftside_aim4;
	anim.boatanims[ "right" ].aim.center = %zodiac_harbor_leftside_aim5;
	anim.boatanims[ "right" ].aim.right = %zodiac_harbor_leftside_aim6;
	anim.boatanims[ "right" ].reload = array( %zodiac_harbor_leftside_reload, %zodiac_harbor_leftside_reloadB );
	anim.boatanims[ "right" ].slowidle = %zodiac_harbor_leftside_idle;
	anim.boatanims[ "right" ].idle = %zodiac_harbor_leftside_bump_idle;
	anim.boatanims[ "right" ].altidle = %zodiac_harbor_leftside_idle_short;
	anim.boatanims[ "right" ].twitch = array( %zodiac_harbor_leftside_duck );
	anim.boatanims[ "right" ].react = %zodiac_harbor_leftside_react;
	anim.boatanims[ "right" ].leftAimLimit = -51;
	anim.boatanims[ "right" ].rightAimLimit = 51;
}

draw_line_toshootpos()
{
	while(1)
	{
		if( isdefined( self.shootpos ) )
			Line( self.shootpos, self.origin, (1,0,0), 1 );
		if( isdefined( self.favoriteenemy ) )
			Line( self.favoriteenemy.origin, self.origin, (0,0,1), 1 );
		if( isdefined( self.zodiac_enemy ) )
			Line( self.zodiac_enemy.origin, self.origin, (0,1,0), 1 );
		wait .05;
	}
	
}

endthink() // this function is not called right now, but it should be if an AI ever gets off a zodiac.
{
	self.a.specialShootBehavior = undefined;
}

think()
{
//	self thread debug_setup();
	self endon ( "killanimscript" ); // (includes death)
	
	if( !ent_flag_exist( "transitioning_positions" ) )
		ent_flag_init( "transitioning_positions" );     
	else
		ent_flag_clear( "transitioning_positions" );
		
	animscripts\utility::initialize( "zodiac" );
	
	self.in_air = false;
	self.a.boatAimYaw = 0;
	if( !isdefined( self.a.boat_pose ) )
		self.a.boat_pose = "right";
		
	self.a.last_boat_pose_switch = gettime() + 1000;
	self.a.auto_switch_if_not_target = gettime() + RandomIntRange(3000,6000);
	
	self.a.lastBoatTwitchTime = gettime() + 1000;
	
	self childthread animscripts\shoot_behavior::decideWhatAndHowToShoot( "normal" );
	
	self.altidle_playing = gettime() + 1000;
	self.altidle_weight = 1.0;
	
	self.wait_to_start_aiming = gettime() + 2000;
	self.aimblendtime = 0.1;
	if (isdefined(self.aimblendtime_start))
		self.aimblendtime = self.aimblendtime_start;
	
	self setup_anim_array_boat();
	
	self.a.wantBoatReloadTime = undefined;
	
	self.a.specialShootBehavior = ::zodiacShootBehavior;
	
	self childthread watchVelocity();
	self childthread idleAimDir();
//	self childthread draw_line_toshootpos();
	
	for ( ;; )
	{
		
		if (!needToReact())
		{
			self thread disableBoatIdle();
			
			if ( self shouldReload() )
			{
				self boatReload();
				continue;
			}
			
			newPose = needToChangePose();
			if ( newPose != "none" )
			{
				assert( newPose != self.a.boat_pose );
				
				transanim = anim.boatanims[ self.a.boat_pose ].trans;
				self.a.boat_pose = newPose;
				ent_flag_set( "transitioning_positions" );
				self setFlaggedAnimKnobAllRestart( "trans", transanim, %body, 1, 0.2 );
				self animscripts\notetracks::DoNoteTracksForTime( getAnimLength( transanim ) - 0.3, "trans" );
				self.a.last_boat_pose_switch = gettime();
				self.a.auto_switch_if_not_target = gettime() + RandomIntRange(3000,6000);
				ent_flag_clear( "transitioning_positions" );
				
				theanim = anim.boatanims[ self.a.boat_pose ].aim.center;
				self setAnimKnobAllRestart( theanim, %body, 1, 0.2 );
				self notify( "boat_pose_change" );
				
				self.a.boatAimYaw = 0;
				self setup_anim_array_boat();
				
				continue;
			}
			
			if ( shouldDoTwitch() )
			{
				doBoatTwitch();
				continue;
			}
		}
		
		// we want the additive idle for anything after this point in the loop (shooting or aiming)
		self thread enableBoatIdle();
		
		if ( aimedAtShootEntOrPos() )
		{
			self shootUntilNeedToChangePose();
			continue;
		}
		else
		{
			self updateBoatAim();
		}
		
		wait .1;

	}
	
	self waittill( "forever" );
}

shouldReload()
{
	if ( NeedToReload( 0 ) )
	{
		// it looks bad to reload when we have targets.
		// we'll reload when we get a chance.
		
		if ( !isDefined( self.a.wantBoatReloadTime ) )
			self.a.wantBoatReloadTime = gettime();
		self animscripts\weaponList::RefillClip();
	}
	
	if ( isDefined( self.a.wantBoatReloadTime ) )
	{
		// don't wait too long.
		if ( gettime() - self.a.wantBoatReloadTime > 2500 )
			return true;
		
		if ( !canAimAtEnemy() )
			return true;
		
		if ( self.a.lastShootTime < gettime() - 1500 )
			return true;
	}
	
	return false;
}

boatReload()
{
	reloads = anim.boatanims[ self.a.boat_pose ].reload;
	reloadanim = reloads[ randomint( reloads.size ) ];
	
	self.a.wantBoatReloadTime = undefined;
	
	self setFlaggedAnimKnobAllRestart( "reload", reloadanim, %body, 1, 0.2 );
	self wait_for_animcomplete_or_react( reloadanim );
	//self animscripts\shared::DoNoteTracks( "reload" );
	
	self animscripts\weaponList::RefillClip();
}

disableBoatIdle()
{
	if ( !isDefined( self.a.boatIdle ) )
		return;
	
	self endon( "killanimscript" );
	
	// actually wait a bit before clearing it in case we still want it
	self endon( "want_boat_idle" );
	wait .05;
	
	self notify( "end_boat_idle" );
	self.a.boatIdle = undefined;
	
	self clearAnim( %zodiac_idle, 0.2 );
}

resetAtEndOfAnim( time, idleAnim, baseIdleAnim )
{
	self endon("starting_altidle");
	wait time;
	self setAnim( idleAnim, 0, 0.2 );
	self setAnim( baseIdleAnim, 1, 0.2 );
}

needToReact()
{
	react = self.in_air;
	if (isdefined(self.vehicle) && isdefined(self.vehicle.event))
	{
		if (self.vehicle.event[ "bump_big" ][ "passenger" ] )
		{
			react = true;
		}
		if (self.vehicle.event[ "jump" ][ "passenger" ] )
		{
			react = true;
		}
	}
	return react;
}

enableBoatIdle()
{
	self notify( "want_boat_idle" );
	
	bestidle = "normal";
	boatspeed = Length(self.boatvelocity);
	if (boatspeed > 170)
		bestidle = "alt";	// bouncy ride
	
	if (isdefined(self.forceidle) && self.forceidle)
	{
		if (isdefined(self.vehicle) && isdefined(self.vehicle.event))
		{	// we ignore events while forcing idle
			self.vehicle.event[ "jump" ][ "passenger" ] = false;
			self.vehicle.event[ "bump_big" ][ "passenger" ] = false;
			self.vehicle.event[ "bump" ][ "passenger" ] = false;
			boatspeed = 0;
			bestidle = "normal";
		}
	}
	if ( isdefined( self.a.boatIdle ) && (self.a.boatIdle == bestidle) && (bestidle == "normal") )
		return;
	self.a.boatIdle = bestidle;
	
	self endon( "end_boat_idle" );
	comment = "";
	
	idleAnim = undefined;
	weight = 1;
	if (bestidle == "alt")
	{
		baseIdleAnim = anim.boatanims[ self.a.boat_pose ].idle;
		idleAnim = anim.boatanims[ self.a.boat_pose ].altidle;
		weight = (boatspeed-170)/500;
		event = false;
		react = false;
		if (isdefined(self.vehicle) && isdefined(self.vehicle.event))
		{
			if (self.vehicle.event[ "jump" ][ "passenger" ] )
			{
				comment = comment + "jump ";
				self.in_air = true;
				self.vehicle.event[ "jump" ][ "passenger" ] = false;
				weight += 1.0;
				react = true;
				event = true;
			}
			else if (self.vehicle.event[ "bump_big" ][ "passenger" ] )
			{
				comment = comment + "big ";
				self.in_air = false;
				self.vehicle.event[ "bump_big" ][ "passenger" ] = false;
				weight += 1.0;
				event = true;
			}
			else if (self.vehicle.event[ "bump" ][ "passenger" ] )
			{
				comment = comment + "small ";
				self.in_air = false;
				self.vehicle.event[ "bump" ][ "passenger" ] = false;
				weight += 0.5;
				event = true;
			}
		}
		if (react)
		{
			comment = comment + "react ";
			twitchAnim = anim.boatanims[ self.a.boat_pose ].react;
			self setFlaggedAnimKnobAllRestart( "twitch", twitchAnim, %body, 1, 0.2 );
			//self animscripts\shared::DoNoteTracks( "twitch" );
			time = GetAnimLength(twitchAnim);
			if (time > 0.5)	// we want a short react, since we'll land soon
				time = 0.5;
			self.altidle_playing = gettime() + 1000*time;
			self.altidle_weight = 2.0;	// highest priority
			self thread debug_update(comment);
			return;
		}
		else if (self.in_air)
		{	// don't clobber the react while in air
			if (self.altidle_playing < gettime())
				self.in_air = false;	// safety
			time = self.altidle_playing - gettime();
			comment = comment + "react " + time + " ";
			self thread debug_update(comment);
			return;
		}
		else
		{
			if (weight < 0)
				weight = 0;
			if (weight > 1.0)
				weight = 1.0;
			if ( isDefined( idleAnim ) && (weight > 0) )
			{
				if ((self.altidle_playing < gettime()) || (event && (weight > self.altidle_weight)))
				{	// only start a new one if we're done with the previous or we have a bigger weight
					comment = comment + "restart "+weight+" ";
					self notify("starting_altidle");
					time = GetAnimLength(idleAnim);
					self.altidle_playing = gettime() + 1000*time;
					self.altidle_weight = weight;
					self setAnimRestart( idleAnim, weight, 0.2 );
					self setAnim( baseIdleAnim, 1-weight, 0.2 );
					self thread resetAtEndOfAnim( time, idleAnim, baseIdleAnim );
				}
				else if (weight > self.altidle_weight)
				{
					comment = comment + "bigger "+weight+" ";
					self.altidle_weight = weight;
					self setAnim( idleAnim, weight, 0.2 );
					self setAnim( baseIdleAnim, 1-weight, 0.2 );
				}
				self thread debug_update(comment);
				return;
			}
		}
	}
	if ((bestidle == "normal") || !isdefined(idleAnim))
		idleAnim = anim.boatanims[ self.a.boat_pose ].idle;
	if ( isDefined( idleAnim ) )
	{
		slowIdleAnim = anim.boatanims[ self.a.boat_pose ].slowidle;
		if (boatspeed > 85)
			weight = 1.0;
		else
			weight = boatspeed/85;
		comment = comment + "idle "+weight+" ";
		self.altidle_playing = gettime();
		self.altidle_weight = 0;
		blendtime = 0.2;
		if (isdefined(self.start_from_cinematic))
		{
			blendtime = 0.0;
		}
		self setAnimKnob( slowidleAnim, 1-weight, blendtime );
		self setAnimKnob( idleAnim, weight, blendtime );
	}
	self thread debug_update(comment);
}

shouldDoTwitch()
{
	if (isdefined(self.forceidle) && self.forceidle)
		return false;
			
	if ( self.a.lastShootTime > gettime() - 2000 )
		return false;
	
	if ( gettime() < self.a.lastBoatTwitchTime + 1500 )
		return false;
	
	if ( self enemyToShoot() )
		return false;
	
	if ( !isDefined( anim.boatanims[ self.a.boat_pose ].twitch ) )
		return false;
	
	return true;
}

wait_for_animcomplete_or_react( anm )
{
	time = GetAnimLength(anm);
	while (time > 0)
	{
		if (needToReact())
			break;
		time -= 0.05;
		wait 0.05;
	}
}

doBoatTwitch()
{
	twitches = anim.boatanims[ self.a.boat_pose ].twitch;
	
	twitchAnim = twitches[ randomint( twitches.size ) ];
	for ( i = 0; i < 5; i++ )
	{
		if ( !isdefined( self.a.lastBoatTwitchAnim ) || twitchAnim != self.a.lastBoatTwitchAnim )
			break;
		twitchAnim = twitches[ randomint( twitches.size ) ];
	}
	
	self setFlaggedAnimKnobAllRestart( "twitch", twitchAnim, %body, 1, 0.2 );
	self wait_for_animcomplete_or_react( twitchAnim );
	//self animscripts\shared::DoNoteTracks( "twitch" );
	
	self.a.lastBoatTwitchAnim = twitchAnim;
	self.a.lastBoatTwitchTime = gettime();
}

enemyToShoot()
{
	if (!isdefined(self.enemy))
		return false;
	trace = BulletTrace( self getEye(), self.enemy.origin + (0,0,60), true, self );
	if (trace["fraction"] <= 0.99)
	{	// see if we hit the entity outright
		if (isdefined(trace["entity"]))
		{
			if (trace["entity"] == self.enemy)
				return true;
		}
	}
	if (trace["fraction"] > 0.99)	// see if we were able to trace to the end (call that good since our target is a fudged pos
		return true;
	return false;
}

zodiacShootBehavior()
{
	if ( !self enemyToShoot() ) 
	{
		self.shootent = undefined;
		self.shootpos = undefined;
		self.shootstyle = "none";
		return;
	}
	
	self.shootent = self.enemy;
	self.shootpos = self.enemy getShootAtPos();
	distSq = distanceSquared( self.origin, self.enemy.origin );
	
	if ( distSq < 4000*4000 )
		self.shootstyle = "burst";
	else
		self.shootstyle = "single";
}


watchVelocity()
{
	self endon( "killanimscript" );
	self.prevpos = self.origin;
	self.boatvelocity = (0,0,0);
	
	for ( ;; )
	{
		wait .05;
		self.boatvelocity = (self.origin - self.prevpos) / .05;
		self.prevpos = self.origin;
	}
}

waitRandomTimeBoat()
{
	self endon( "boat_pose_change" );
	wait randomfloatrange( 0.5, 3.5 );
}

idleAimDir()
{
	self endon( "killanimscript" );
	
	for ( ;; )
	{
		if ( self.a.boat_pose == "left" )
			self.idleAimYaw = randomfloatrange( -20, 40 );
		else
			self.idleAimYaw = randomfloatrange( -40, 20 );
		
		self waitRandomTimeBoat();
	}
}


getBoatAimYawToShootPos( predictionTime )
{
	if ( !isDefined( self.shootPos ) )
		return 0;
	
	predictedShootPos = self.shootPos - self.boatvelocity * predictionTime;
	
	aimYaw = getAimYawToPoint( predictedShootPos );
	return aimYaw;
}


canAimAtEnemy()
{
	if ( !isDefined( self.shootPos ) )
		return false;
	
	aimYaw = getDesiredBoatAimYaw();
	anims = anim.boatanims[ self.a.boat_pose ];
	return ( aimYaw >= anims.leftAimLimit && aimYaw <= anims.rightAimLimit );
}

getDesiredBoatAimYaw()
{
	aimYaw = 0;
	
	if ( isDefined( self.shootPos ) )
	{
		aimYaw = getBoatAimYawToShootPos( .1 );
		if ( self.a.boat_pose == "left" )
			aimYaw = AngleClamp180( aimYaw + 40.5 );
		else
			aimYaw = AngleClamp180( aimYaw - 36 );
	}
	else
	{
		aimYaw = self.idleAimYaw;
	}
	
	return aimYaw;
}

updateBoatAim()
{
	// need to be able to aim quickly because we're moving quickly, so don't cap too much
	maxTurn = 15;
	if ( !isDefined( self.shootPos ) )
		maxTurn = 5;
	
	aimYaw = getDesiredBoatAimYaw();
	
	if ( abs( aimYaw - self.a.boatAimYaw ) > maxTurn )
	{
		if ( aimYaw < self.a.boatAimYaw )
			aimYaw = self.a.boatAimYaw - maxTurn;
		else
			aimYaw = self.a.boatAimYaw + maxTurn;
	}
	
	anims = anim.boatanims[ self.a.boat_pose ];
	blendtime = 0.1;
	if (isdefined(self.start_from_cinematic))
	{
		blendtime = 0.0;
		aimYaw = 0;
	}
	if ( aimYaw < 0 )
	{
		frac = aimYaw / anims.leftAimLimit;
		if ( frac > 1 )
			frac = 1;
		self setAnimKnob( anims.aim.center, 1 - frac, blendtime );
		self setAnim    ( anims.aim.left  ,     frac, blendtime );
	}
	else
	{
		frac = aimYaw / anims.rightAimLimit;
		if ( frac > 1 )
			frac = 1;
		self setAnimKnob( anims.aim.center, 1 - frac, blendtime );
		self setAnim    ( anims.aim.right ,     frac, blendtime );
	}
	self setAnimKnobAll( anims.base, %zodiac_actions, 1, 0.2 );
	
	self.a.boatAimYaw = aimYaw;
}

updateBoatAimThread()
{
	self endon( "killanimscript" );
	self endon( "end_shootUntilNeedToChangePose" );
	
	for ( ;; )
	{
		updateBoatAim();
		wait .1;
	}
}


shootUntilNeedToChangePose()
{
	self thread watchForNeedToChangePoseOrTimeout();
	self endon( "end_shootUntilNeedToChangePose" );
	
	self thread updateBoatAimThread();
	
	shootUntilShootBehaviorChange();
	
	self notify( "end_shootUntilNeedToChangePose" );
}

watchForNeedToChangePoseOrTimeout()
{
	self endon( "killanimscript" );
	self endon( "end_shootUntilNeedToChangePose" );
	
	endtime = gettime() + 4000 + randomint( 2000 );
	wait 0.05;	// if any of the cases below are true at the start, the notify will be missed by the caller
	
	while ( 1 )
	{
		if ( gettime() > endtime || needToChangePose() != "none" )
			break;
		
		if ( self shouldReload() )
			break;
			
		if (self needToReact())
			break;
		
		wait .1;
	}
	
	self notify( "end_shootUntilNeedToChangePose" );
}

needToChangePose_other()
{
	if (isdefined(self.forceidle) && self.forceidle)
		return "none";
		
	if ( self.a.last_boat_pose_switch > gettime() - 2000 )
		return "none"; 
		
	if ( self.a.lastShootTime > gettime() - 2000 )
		return "none"; 
		
	if ( !isDefined( self.shootPos ) )
	{	// though we don't have a target, we still want to change pose sometime
		if ( self.a.auto_switch_if_not_target < gettime() )
		{
			if ( self.a.boat_pose == "left" )
				return "right";
			else
				return "left";
		}
		return "none";
	}
	
	aimYaw = getBoatAimYawToShootPos( 0.5 ); // half second prediction
	
	if ( self.a.boat_pose == "left" )
	{
		if ( aimYaw > 15 && aimYaw < 160 )
			return "right";
	}
	else if ( self.a.boat_pose == "right" )
	{
		if ( aimYaw < -15 && aimYaw > -160 )
			return "left";
	}
	
	return "none";
}

needToChangePose()
{
	if ( isdefined( self.use_auto_pose ) )
		return needToChangePose_other();
		
	if ( isDefined( self.scripted_boat_pose ) )
	{
		if ( self.a.boat_pose == self.scripted_boat_pose )
			return "none";
		
		return self.scripted_boat_pose;
	}
	
	// we always want the "left" pose now
	if ( self.a.boat_pose == "right" )
		return "left";
	
	return "none";
	
	/*
	if ( !isDefined( self.shootPos ) )
		return "none";
	
	aimYaw = getBoatAimYawToShootPos( 0.5 ); // half second prediction
	
	if ( self.a.boat_pose == "left" )
	{
		if ( aimYaw > 15 && aimYaw < 160 )
			return "right";
	}
	else if ( self.a.boat_pose == "right" )
	{
		if ( aimYaw < -15 && aimYaw > -160 )
			return "left";
	}
	
	return "none";
	*/
}


setup_anim_array_boat()
{
	self.a.array = [];
	
	self.a.array[ "fire" ] = %exposed_shoot_auto_v3;
	
	if ( self.a.boat_pose == "left" )
	{
		self.a.array[ "single" ] = array( %zodiac_harbor_rightside_fire_single );
		self.a.array[ "burst2" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "burst3" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "burst4" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "burst5" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "burst6" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "semi2" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "semi3" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "semi4" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "semi5" ] = %zodiac_harbor_rightside_fire_burst;
		self.a.array[ "semi6" ] = %zodiac_harbor_rightside_fire_burst;
	}
	else
	{
		self.a.array[ "single" ] = array( %zodiac_harbor_leftside_fire_single );
		self.a.array[ "burst2" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "burst3" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "burst4" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "burst5" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "burst6" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "semi2" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "semi3" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "semi4" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "semi5" ] = %zodiac_harbor_leftside_fire_burst;
		self.a.array[ "semi6" ] = %zodiac_harbor_leftside_fire_burst;
	}
}


