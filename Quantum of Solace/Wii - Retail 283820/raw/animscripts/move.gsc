

#include animscripts\utility;
#include animscripts\shared;
#include common_scripts\utility;

#using_animtree ("generic_human");

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
	








	previousScript = self.a.script;	
    animscripts\utility::initialize("move");
 	if (self.moveMode == "run")
	{
		
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
			
			self animscripts\battleChatter_ai::evaluateMoveEvent (true);
			break;

		default:
			
			self animscripts\battleChatter_ai::evaluateMoveEvent (false);
			break;
		}
	}
	self animscripts\battlechatter::playBattleChatter();
	

	
	
	
	
	
	
	
	
	
	self.cqb_track_thread = undefined;
	
	MoveMainLoop();
}

MoveMainLoop()
{
	for (;;)
	{
		
		
		
		self animscripts\face::SetIdleFaceDelayed(anim.alertface); 
		
		
		if ( self shouldCQB() )
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

shouldCQB()
{
	return self isCQBWalking() && !isdefined( self.grenade );
}

CQBTracking()
{
	self notify("want_cqb_tracking");
	
	if ( isdefined( self.cqb_track_thread ) )
		return;
	self.cqb_track_thread = true;
	
	self endon("killanimscript");
	self endon("end_cqb_tracking");
	
	self.rightAimLimit = 45;
	self.leftAimLimit = -45;
	self.upAimLimit = 45;
	self.downAimLimit = -45;
	
	self setAnimLimited( %walk_aim_2 );
	self setAnimLimited( %walk_aim_4 );
	self setAnimLimited( %walk_aim_6 );
	self setAnimLimited( %walk_aim_8 );
	
	self.shootEnt = undefined;
	self.shootPos = undefined;
	
	self trackLoop( %w_aim_2, %w_aim_4, %w_aim_6, %w_aim_8 );
}
DontCQBTrackUnlessWeMoveCQBAgain()
{
	self endon("killanimscript");
	self endon("want_cqb_tracking");
	
	wait .05;
	
	self notify("end_cqb_tracking");
	self.cqb_track_thread = undefined;
}

MoveCQB()
{
	animscripts\run::changeWeaponStandRun();
	
	self endon("movemode");
	
	if ( self.a.pose != "stand" )
	{
		if ( self.a.pose == "prone" )
			self ExitProneWrapper( 1 );
		self.a.pose = "stand";
	}
	self.a.movement = self.moveMode;
	
	self clearanim(%combatrun, 0.2);
	
	self thread CQBTracking();
	
	rate = 1;
	if ( self.moveMode == "walk" )
		rate = 0.7;
	rate *= self.animplaybackrate;
	
	
	self setFlaggedAnimKnobAll( "runanim", %run_CQB_F_search_v1, %walk_and_run_loops, 1, 0.3, rate );
	
	
	animWeights = animscripts\utility::QuadrantAnimWeights( self getMotionAngle() );
	self setanim(%combatrun_forward, animWeights["front"], 0.2, rate);
	self setanim(%walk_backward, animWeights["back"], 0.2, rate);
	self setanim(%walk_left, animWeights["left"], 0.2, rate);
	self setanim(%walk_right, animWeights["right"], 0.2, rate);
	
	animscripts\shared::DoNoteTracksForTime( 0.2, "runanim" );
	
	self thread DontCQBTrackUnlessWeMoveCQBAgain();
}

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
	
	if (distance(self.origin, self.node.origin) > self.goalradius)
		return true;
	if (distance(self.origin, self.node.origin) < 80)
		return true;

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
