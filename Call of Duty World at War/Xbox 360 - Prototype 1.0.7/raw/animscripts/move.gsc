#include animscripts\SetPoseMovement;
#include animscripts\combat_utility;
#include animscripts\utility;
#include common_scripts\utility;

#using_animtree ("generic_human");

combatBreaker()
{
	self endon("killanimscript");
	while (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
	{
		if (seekingCoverInMyFov())
			break;
		wait (0.25);
	}
	self thread moveAgain();
}

moveAgain()
{
	self notify("killanimscript");
	animscripts\move::main();
}

seekingCoverInMyFov()
{
	// Run back to cover if you're not in your goalradius
	if (distance(self.origin, self.node.origin) > self.goalradius)
		return true;
	if (distance(self.origin, self.node.origin) < 80)
		return true;
//	print3d(self.node.origin, "node for " + self getentnum(), (1,1,0));
	enemyAngles = vectorToAngles(self.origin - self.enemy.origin);
	enemyForward = anglesToForward(enemyAngles);
	nodeAngles = vectorToAngles(self.origin - self.node.origin);
	nodeForward = anglesToForward(nodeAngles);
	return (vectorDot(enemyForward, nodeforward) > 0.1);
}

RunBreaker()
{
	self endon("killanimscript");
	for (;;)
	{
		if (isalive(self.enemy) && isdefined(self.node) && self canSee(self.enemy))
		{
			if (!seekingCoverInMyFov())
				break;
		}
		wait (0.25);
	}
	self thread moveAgain();
}

/#
drawLookaheadDir()
{
	self endon("killanimscript");
	for (;;)
	{
		line(self.origin + (0,0,20), (self.origin + vectorscale(self.lookaheaddir,64)) + (0,0,20));	
		wait(0.05);
	}
}
#/

main()
{
	prof_begin("move");
	self endon("killanimscript");

/#
	if ( getdvar("showlookaheaddir") == "on" )
		self thread drawLookaheadDir();
#/
	
	
	[[ self.exception[ "move" ] ]]();

    self trackScriptState( "Move Main", "code" );
	

	previousScript = self.a.script;	// Grab the previous script before initialize updates it.  Used for "cover me" dialogue.
    animscripts\utility::initialize("move");
 	if (self.moveMode == "run")
	{
		// Say something
		switch (previousScript)
		{
		case "concealment_crouch":
		case "concealment_prone":
		case "concealment_stand":
		case "cover_crouch":
		case "cover_left":
		case "cover_prone":
		case "cover_right":
		case "cover_stand":
		case "cover_wide_left":
		case "cover_wide_right":
		case "stalingrad_cover_crouch":
		case "hide":
		case "turret":
			// Leaving cover.  Say something like "cover me".
			self animscripts\battleChatter_ai::evaluateMoveEvent (true);
			break;

		default:
			// Say random poop.
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;
		}
	}
	self animscripts\battlechatter::playBattleChatter();

	// approach/exit stuff
	self thread animscripts\cover_arrival::setupApproachNode( true );
	self animscripts\cover_arrival::startCornerLeave();

	MoveMainLoop();
}

MoveMainLoop()
{
	for (;;)
	{
		prof_begin("move");
		
		self animscripts\face::SetIdleFaceDelayed(anim.alertface); // set default value

		if( isdefined( self.cqbwalking ) && self.cqbwalking )
		{
			self MoveCQB();
		}
		else if ( self.moveMode == "run" )
		{
			self animscripts\run::MoveRun();
		}
		else
		{
			assert( self.moveMode == "walk" );
			self animscripts\walk::MoveWalk();
		}
		
		self.exitingCover = false;
	}
}



track_target() /* void */ 
{
	self endon("killanimscript");
	self endon("stop tracking");
	
	
	//self setanimlimited(%exposed_aiming);
	
	self setanimlimited(%walk_aim_2,1,.2,1);
	self setanimlimited(%walk_aim_4,1,.2,1);
	self setanimlimited(%walk_aim_6,1,.2,1);
	self setanimlimited(%walk_aim_8,1,.2,1);
	
	aimBlendTime = 0.4;
	for(;;)
	{

		if(!isdefined(self.current_target))
		{
			wait(0.1);
			self setanimlimited(%w_aim_4,0,aimBlendTime);
			self setanimlimited(%w_aim_6,0,aimBlendTime);
			self setanimlimited(%w_aim_2,0,aimBlendTime);
			self setanimlimited(%w_aim_8,0,aimBlendTime);
			
			continue;	
		}
		
		yawDelta = getYawToSpot(self.current_target.origin);
		pitchDelta = getPitchToSpot(self.current_target.origin);			
			
		// need to have fudge factor because the gun's origin is different than our origin,
		// the closer our distance, the more we need to fudge. 
//		dist = distance(self.origin,self.spot.origin);

//		if(dist < -3 && dist > 3)
//		{
//			angleFudge = asin(-3/dist);
//			yawDelta += angleFudge; 
//		}
		if(yawDelta > 0)// && yawDelta < self.rightAimLimit)
		{
			self setanimlimited(%w_aim_4,0,aimBlendTime);			
			weight = yawDelta / self.rightAimLimit;
			if(weight > 1.0)
				weight = 1.0;
			self setanimlimited(%w_aim_6,weight,aimBlendTime);

		}

		if(yawDelta < 0)// && yawDelta > self.leftAimLimit)
		{
			self setanimlimited(%w_aim_6,0,aimBlendTime);			
			weight = yawDelta / self.leftAimLimit;
			if(weight > 1.0)
				weight = 1.0;

			self setanimlimited(%w_aim_4,weight,aimBlendTime);
		}
		
		if(pitchDelta > 0 && pitchDelta < self.upAimLimit)
		{

			self setanimlimited(%w_aim_2,0,aimBlendTime);			
			weight = pitchDelta / self.upAimLimit;
			if(weight > 1.0)
				weight = 1.0;

			self setanimlimited(%w_aim_8,weight,aimBlendTime);
		}  
		if(pitchDelta < 0 && pitchDelta > self.downAimLimit)
		{
			self setanimlimited(%w_aim_8,0,aimBlendTime);			
			weight = pitchDelta / self.downAimLimit;
			if(weight > 1.0)
				weight = 1.0;

			self setanimlimited(%w_aim_2,weight,aimBlendTime);
		}  
		wait(0.05);
	}
}

MoveCQB()
{
	self endon("movemode");
	
	self clearanim(%combatrun, 0.2);
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45; 
	self.downAimLimit = -45; 
	
	self thread track_target();
	
	
	self.a.combatrunanim = %run_CQB_F_search_v1;
	prerunAnim = self.a.combatrunanim;
	
	self setFlaggedAnimKnob( "runanim", prerunAnim, 1, 0.3 );
	
	// Play the appropriately weighted animations for the direction he's moving.
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self setanim(%combatrun_forward, animWeights["front"], 0.2, 1);
	self setanim(%walk_backward, animWeights["back"], 0.2, 1);
	self setanim(%walk_left, animWeights["left"], 0.2, 1);
	self setanim(%walk_right, animWeights["right"], 0.2, 1);
	
	animscripts\shared::DoNoteTracksForTime( 0.2, "runanim" );
}


shotgunPullout()
{
	self endon("killanimscript");

	wait ( randomfloat( 0.25 ) + 1.0 );
	self.cqbwalking = true;
	
	if ( weaponclass( self.weapon ) == "spread")
		return;
	if ( weaponclass( self.secondaryweapon ) != "spread" )
		return;
	
	self setanim( %shotgun, 1, 0, 1 );
	self setflaggedanim( "anim", %shotgun_run_pullout );
	
	wait( 0.4333 );
	//self waittillmatch("anim","gun_2_chest");
	animscripts\shared::placeWeaponOn( self.weapon, "none" );
	self thread pulloutAbortMonitor();
	
	wait( 0.5336 );
	//self waittillmatch("anim","anim_gunhand = \"right\"");
	animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
	
	self.lastweapon = self.weapon;
	self.weapon = self.secondaryweapon;
	self.secondaryweapon = self.lastweapon;
	
	self notify ( "weapon_switch_done" );
}

shotgunPutaway()
{
	self endon("killanimscript");
	
	wait(randomfloat(.25) + 1.0);
	
	if( (weaponclass(self.weapon) == "spread"))
	{
		self setanim(%shotgun,1,0,1);
		self setflaggedanim("anim",%shotgun_run_putaway);

		self waittillmatch("anim","gun_2_back");
		animscripts\shared::placeWeaponOn( self.weapon, "back" );
		self thread pulloutAbortMonitor();

		self waittillmatch("anim","anim_gunhand = \"right\"");
		animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );

		self.lastweapon = self.weapon;
		self.weapon = self.secondaryweapon;
		self.secondaryweapon = self.lastweapon;

		//animscripts\shared::donotetracks("anim");
		//self.bulletsInClip = anim.AIWeapon[tolower(self.weapon)]["clipsize"];
		self notify ( "weapon_switch_done" );
	}
	self.cqbwalking = false;
}

pulloutAbortMonitor()
{
	self endon( "weapon_switch_done" );
	
	self waittill( "killanimscript" );
	
	animscripts\shared::placeWeaponOn( self.secondaryweapon, "right" );
	self.lastweapon = self.weapon;
	self.weapon = self.secondaryweapon;
	self.secondaryweapon = self.lastweapon;	
}
