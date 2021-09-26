// Notes about scripts
//=====================
//
// Anim variables
// -------------- 
// Anim variables keep track of what the character is doing with respect to his 
// animations.  They know if he's standing, crouching, kneeling, walking, running, etc, 
// so that he can play appropriate transitions to get to the animation he wants.
// anim_movement - "stop", "walk", "run"
// anim_pose - "stand", "crouch", "prone", some others for pain poses.
// I'm putting functions to do the basic animations to change these variables in 
// SetPoseMovement.gsc, 
//
// Error Reporting
// ---------------
// To report a script error condition (similar to assert(0)), I assign a non-existent variable to 
// the variable homemade_error  I use the name of the non-existent variable to try to explain the 
// error.  For example:
// 		homemade_error = Unexpected_anim_pose_value + self.anim_pose;
// I also have a kind of assert, called as follows:
//		[[anim.assertEX(condition, message_string);
// If condition evaluates to 0, the assert fires, prints message_string and stops the server. Since 
// I don't have stack traces of any kind, the message string needs to say from where the assert was 
// called.

#include animscripts\Utility;
#include maps\_utility;
#include animscripts\Combat_utility;
#using_animtree ("generic_human");

main()
{
	// Initialization that should happen once per level
	if ( !isDefined (anim.NotFirstTime) ) // Use this to trigger the first init
	{
		anim.NotFirstTime = 1;
		anim.useFacialAnims = false; // remove me when facial anims are fixed

		level.player = getent("player","classname");
		level.player.invul = false;
		level.nextGrenadeDrop = randomint(3);
		anim.defaultException = animscripts\init::empty;
		/#
		if (getdebugcvar("debug_noanimscripts") == "")
			setcvar("debug_noanimscripts", "off");
		else
		if (getdebugcvar("debug_noanimscripts") == "on")
			anim.defaultException = animscripts\init::infiniteLoop;

		if (getdebugcvar("debug_grenadehand") == "")
			setcvar("debug_grenadehand", "off");
			
		if (getdebugcvar("anim_trace") == "")
			setcvar("anim_trace", "-1");
		if (getdebugcvar("anim_dotshow") == "")
			setcvar("anim_dotshow", "-1");
		if (getdebugcvar("anim_debug") == "")
			setcvar("anim_debug", "");
		if (getdebugcvar("debug_misstime") == "")
			setcvar("debug_misstime", "");
		#/
			
		anim.PutGunInHand = anim.defaultException; //animscripts\init::empty;
//		anim.PutGunInHand = animscripts\shared::PutGunInHand;

		// Global constants
        anim . CoverStandShots = 0;
        anim . lastSideStepAnim = 0;
		anim.meleeRangeSq = 64*64;
//		anim.standRangeSq = 503.06*503.06;  // was .25 normalize from melee to prone
		anim.standRangeSq = 512*512;  // was .25 normalize from melee to prone
//		anim.chargeRangeSq = 200*200;
		anim.chargeRangeSq = 200*200; //120*120;
		
		if (!isdefined (level.squadEnt))
			level.squadEnt = [];
		anim.masterGroup["axis"] = spawnstruct();
		anim.masterGroup["axis"].sightTime = 0;
		anim.masterGroup["allies"] = spawnstruct();
		anim.masterGroup["allies"].sightTime = 0;
   		anim.scriptSquadGroup = [];

		anim.combatRunAnim[0] = %combat_run_fast_3;
		anim.combatRunAnim[1] = %combatrun_forward_1;

		animscripts\death::initFatAnims();
	
		thread setupHats();
		anim.lastUpwardsDeathTime = 0;
		anim.backpedalRangeSq = 60*60;
		anim.proneRangeSq = 1000*1000;
		anim.dodgeRangeSq = 300*300;			// Guys only dodge when inside this range.
		anim.maxShuffleDistance = 50;
		anim.blindAccuracyMult["allies"] = 0.5;
		anim.blindAccuracyMult["axis"] = 0.1;
		anim.ramboAccuracyMult = 1.0;
		anim.runAccuracyMult = 0.5;
		anim.combatMemoryTimeConst = 10000;
		anim.combatMemoryTimeRand = 6000;
		anim.scriptChange = "script_change";
		anim.lastPlayerGrenade = 0;
		anim.nextAIGrenade = 0;
		setEnv("none");
		anim.noWeaponToss = false;
		anim.corner_straight_yaw_limit = 36;
		if (!isdefined(anim.optionalStepEffectFunction))
		{
			anim.optionalStepEffects = [];
			anim.optionalStepEffectFunction = ::empty;
		}

		
		/#
		if (getcvar("debug_delta") == "")
			setcvar("debug_delta", "off");
		#/
		maps\_gameskill::setSkill();
		level.painAI = undefined;
		
		
		animscripts\SetPoseMovement::InitPoseMovementFunctions();
		animscripts\WeaponList::initWeaponList();
		animscripts\face::InitLevelFace();
		
		anim.set_a_b[0] = "a";
		anim.set_a_b[1] = "b";
	
		anim.set_a_b_c[0] = "a";
		anim.set_a_b_c[1] = "b";
		anim.set_a_b_c[2] = "c";
	
		anim.set_a_c[0] = "a";
		anim.set_a_c[1] = "c";
		
		anim.num_to_letter[1] = "a";
		anim.num_to_letter[2] = "b";
		anim.num_to_letter[3] = "c";
		anim.num_to_letter[4] = "d";
		anim.num_to_letter[5] = "e";
		anim.num_to_letter[6] = "f";
		anim.num_to_letter[7] = "g";
		anim.num_to_letter[8] = "h";
		anim.num_to_letter[9] = "i";
		anim.num_to_letter[10] = "j";
		anim.startSuppressionDelay = 1.4;
		anim.maymoveCheckEnabled = true; // corner_axis doesnt do the check if this is false, for credits

		anim.badPlaces = []; // queue for animscript badplaces
		anim.badPlaceInt = 0; // assigns unique names to animscript badplaces since we cant save a badplace as an entity
		anim.player = getent("player", "classname" );

		animscripts\squadmanager::init_squadManager();
		anim.player thread animscripts\squadManager::addPlayerToSquad();

		animscripts\battleChatter::init_battleChatter();
		anim.player thread animscripts\battleChatter_ai::addToSystem();

		anim.shootQueue = 0;
		anim thread animscripts\battleChatter::bcsDebugWaiter();
		anim.reacquireNum = 0;
		anim.nonstopFireguy = 0;
		initWindowTraverse();
	}
	
	anim.nonstopFireguy++;
	if (anim.nonstopFireguy >= 2)
	{
		self.anim_nonstopFire = true;
		anim.nonstopFireguy = 0;
	}
	else
		self.anim_nonstopFire = false;
	self.anim_nonstopFire = false;
	
	

	anim.reacquireNum--;
	if (anim.reacquireNum <= 0 && self.team == "axis")
	{
		anim.reacquireNum = 1;
     	self.anim_reacquireGuy = true;
    }
	else
     	self.anim_reacquireGuy = false;
	

	SetWeaponDist();
    /*
    if (isdefined (self.script_squad))
    {
    	squadNum = int(self.script_squad);
    	index = -1;
    	for (i=0;i<anim.scriptSquadGroup.size;i++)
    	{
    		if (anim.scriptSquadGroup[i].squadNum != squadNum)
    			continue;
		    index = i;
		    break;
    	}
    	if (index == -1)
    	{
    		// New squad group
    		anim.scriptSquadGroup[anim.scriptSquadGroup.size] = spawnstruct();
    		index = anim.scriptSquadGroup.size - 1;
			anim.scriptSquadGroup[index].sightTime = 0;
			anim.scriptSquadGroup[index].squadNum = squadNum;
    	}
    	
    	self thread addToGroup(anim.scriptSquadGroup[index]);
    }
    if (!isdefined (self.group))
    {
    	assert (isdefined (anim.masterGroup[self.team]));
    	self thread addToGroup(anim.masterGroup[self.team]);
	}
	*/	 

		
	// Set initial states for poses
	self.anim_pose = "stand";
	self.anim_movement = "stop";
	self.anim_state = "stop";
	self.anim_idleSet = "none";
	self.anim_special = "none";
	self.anim_gunHand = "none";	// Initialize so that PutGunInHand works properly.
	self.anim_PrevPutGunInHandTime = -1;
	animscripts\shared::PutGunInHand("right");	
	self.anim_needsToRechamber = 0;
	self.anim_combatEndTime = gettime();
	self.anim_script = "init";
	self.anim_alertness = "casual"; // casual, alert, aiming
	self.anim_woundedBias = 0;	// 1 is left leg, -1 is right leg, 0 is neither (or upper body).
	self.anim_woundedAmount = 0;
	self.anim_woundedTime = GetTime();
	self.anim_lastWound = "upper";
	self.anim_lastEnemyTime = gettime();
	self.anim_forced_cover = "none";
	self.anim_suppressingEnemy = false;
	self.anim_lastWoundTime = 0;
	self.anim_desired_script = "none";
	self.anim_current_script = "none";
	self.anim_disableLongDeath = self.team != "axis";
	self.anim_lookangle = 0;
	self.anim_painTime = 0;
	
	self._animActive = 0;
//	self.anim_ignoreSuppressionTime = 0;
	if (!isdefined(self.script_displaceable))
		self.script_displaceable = -1; // -1 means defaulted to off
	
	self thread deathNotify();
	if (self.team == "axis")
	{
		self thread maps\_gameskill::playerInvul();
		self.baseAccuracy = 1;
		self.accuracy = 1;
	}
	else
	{
		self.baseAccuracy = 1;
		self.accuracy = 1;
	}
		
	self.anim_yawTransition = "none";
	self.anim_nodeath = false;
//	self.baseAccuracy = self.accuracy * 2.5;
	self.anim_missTime = 0;
	self.anim_missTimeDebounce = 0;
	self.anim_disablePain = false;

	self.accuracyStationaryMod = 1;
	self.chatInitialized = false;
	self.sightPosTime = 0;
	self.sightPosLeft = true;
	self.preCombatRunEnabled = true;
	self.goodShootPosValid = false;
	self.anim_grenadeFlee = %combatrun_forward_2;
	
	self.anim_crouchpain = false; // for dying pain guys
	self.anim_nextStandingHitDying = false;

/*
	if (level.gameSkill == 2)	
		self.health = int( self.health * 1.33 );
	else
	if (level.gameSkill == 3)	
		self.health = int( self.health * 1.66 );
*/
	
	// Makes AI able to throw grenades at other AI.
	if (!isdefined (self.script_forcegrenade))
		self.script_forcegrenade = 0;
/#
	self.anim_lastDebugPrint = "";
#/
	self.anim_StopCowering = ::DoNothing;	// This is a "handler" function.  SetPoseMovement could be 
											// written entirely with these.
											
	SetupUniqueAnims();

//	thread testLife();
	thread animscripts\look::lookThread();
/#
	thread animscripts\utility::UpdateDebugInfo();
#/
	
	self animscripts\weaponList::RefillClip();	// Start with a full clip.

	// state tracking
	self.lastEnemySightTime = 0; // last time we saw our current enemy
	self.combatTime = 0; // how long we've been in/out of combat
	self.lastShootTime = 0;

	self.suppressed = false; // if we're currently suppressed
	self.suppressedTime = 0; // how long we've been in/out of suppression

	self.isSuppressable = true;
//	self.groupsightpos = undefined;
	thread lastSightUpdater();
	
    // Things that were in scripts that should be done once, or on weapon switch
	if (animscripts\weaponList::usingAutomaticWeapon())
		self . ramboChance = 15;
	else if (animscripts\weaponList::usingSemiAutoWeapon())
		self . ramboChance = 7;
	else
		self . ramboChance = 0;
	if (self.team == "axis")
		self . ramboChance *= 2;

    self . coverIdleSelectTime = -696969;
	self.exception_exposed = anim.defaultException;
	self.exception_corner = anim.defaultException;
	self.exception_corner_normal = anim.defaultException;
	self.exception_cover_crouch = anim.defaultException;
	self.exception_stop = anim.defaultException;
	self.exception_stop_immediate = anim.defaultException;
	self.exception_move = anim.defaultException;
	
	self.old = spawnstruct();

	/#
		if (getdebugcvar("debug_corner") == "on")
		{
			self.exception_exposed = animscripts\init::debugCorner;
			self.exception_corner_normal = animscripts\init::debugCorner;
			self.exception_cover_crouch = animscripts\init::debugCorner;
			self.exception_stop = animscripts\init::debugCorner;
			self.exception_move = animscripts\init::debugCorner;
		}
	#/

//	if (self getentitynumber() == 120)
//		self thread printvoice();

	self.reacquire_state = 0;

	self thread setNameAndRank();

	self thread animscripts\squadManager::addToSquad();

	SetGoalFromTarget();
}

setNameAndRank()
{
	self endon ( "death" );
	if (!isdefined (level.loadoutComplete))
		level waittill ("loadout complete");
		
	self maps\_names::get_name();
}

SetWeaponDist()
{
	self.fightDist = WeaponFightDist(self.weapon);
	if ( animscripts\weaponList::usingAutomaticWeapon() )
	{
		self.minDist = 64;
		self.maxDist = 512;
	}
	else if ( animscripts\weaponList::usingSemiAutoWeapon() )
	{
		self.minDist = 128;
		self.maxDist = 700;
	}
	else if ( animscripts\utility::usingBoltActionWeapon() )
	{
		self.minDist = 768;
		self.maxDist = 1500;
	}
}


SetGoalFromTarget()
{
	if (!isdefined(self.target))
		return;

	// assume target is an entity or a node

	// try to get an entity
	ents = getentarray(self.target, "targetname");
	if (ents.size)
	{
		ent = ents[0];
		if (ent.classname == "info_player_deathmatch")
		{
			ent = getent("player", "classname");
			assert(isdefined(ent));
		}
		self setgoalentity(ent);
		return;
	}

	// try to get a node
	nodes = getnodearray(self.target, "targetname");
	if (nodes.size)
	{
		self setgoalnode(nodes[0]);
		return;
	}

	// nothing worked
	println("^3WARNING: entity '", self.targetname, "' couldn't find target '", self.target, "'");
}

DoNothing()
{
}

// Debug thread to see when stances are being allowed
PollAllowedStancesThread()
{
	for (;;)
	{
		if (self isStanceAllowed("stand"))
		{
			line[0] = "stand allowed";
			color[0] = (0,1,0);
		}
		else
		{
			line[0] = "stand not allowed";
			color[0] = (1,0,0);
		}
		if (self isStanceAllowed("crouch"))
		{
			line[1] = "crouch allowed";
			color[1] = (0,1,0);
		}
		else
		{
			line[1] = "crouch not allowed";
			color[1] = (1,0,0);
		}
		if (self isStanceAllowed("prone"))
		{
			line[2] = "prone allowed";
			color[2] = (0,1,0);
		}
		else
		{
			line[2] = "prone not allowed";
			color[2] = (1,0,0);
		}


		aboveHead = self GetEye() + (0,0,30);
		offset = (0,0,-10);
		for (i=0 ; i<line.size ; i++)
		{
			textPos = ( aboveHead[0]+(offset[0]*i), aboveHead[1]+(offset[1]*i), aboveHead[2]+(offset[2]*i) );
			print3d (textPos, line[i], color[i], 1, 0.75);	// origin, text, RGB, alpha, scale
		}
		wait 0.05;
	}
}

/#
printvoice()
{
	for(;;)
	{
		println (self.voice);
		aboveHead = self GetEye() + (0,0,10);
		print3d (aboveHead, self.voice, (1,0,0), 1, 0.75);	// origin, text, RGB, alpha, scale
		wait 0.05;
	}
}
#/


// Set all unique animation variables for a character - unique run animations, unique playback rate, 
// whatever.  This function can get called several times during a level, so it needs to produce the same 
// "random" values on successive calls.
SetupUniqueAnims()
{

	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		/*
		switch ( self getentitynumber() % 3 )
		{
		case 0:
			self.anim_combatrunanim = anim.combatRunAnim;
			self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_1;
			break;
		case 1:
			self.anim_combatrunanim = anim.combatRunAnim;
			self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_2;
			break;
		case 2:
			self.anim_combatrunanim = anim.combatRunAnim;
			self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_3;
			break;
		}
		*/
		self.anim_combatrunanim = %combat_run_fast_pistol;
		self.anim_crouchrunanim = %pistol_crouchrun_loop_forward_1;
		
	}
	else
	{
		// There are four crouchrun loops but three run loops, and we want to make sure that the number three 
		// ones always get assigned together, so assign crouchrun 4 to 1/3 of the guys who get run 1 or 2.
		switch ( self getentitynumber() % 3 )
		{
		case 0:
			self.anim_combatrunanim = random(anim.combatRunAnim);
			if ( self getentitynumber() % 9 < 6 )
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_2; //1
			}
			else
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_2; // 4
			}
			break;
		case 1:
			self.anim_combatrunanim = random(anim.combatRunAnim);
			if ( self getentitynumber() % 9 < 3 )
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_2; //4
			}
			else
			{
				self.anim_crouchrunanim = %crouchrun_loop_forward_2;
			}
			break;
		case 2:
			self.anim_combatrunanim = random(anim.combatRunAnim);
			self.anim_crouchrunanim = %crouchrun_loop_forward_2; // 3
			break;
		}
	}
	if (!isDefined(self.animplaybackrate))
	{
		self.animplaybackrate = 0.8 + randomfloat(0.4);
	}
}

infiniteLoop(one, two, three, whatever)
{
	anim endon ("new exceptions");
	for (;;)
	{
		wait (1500);
	}
}

empty(one, two, three, whatever)
{
}


removeFirstArrayIndex(array)
{
	newArray = [];
	for (i=1;i<array.size;i++)
		newArray[newArray.size] = array[i];
	return newArray;
}


// Changes the AI's aim based on how recently they saw their enemy
lastSightUpdater()
{
	self endon ("death");
	self.personalSightTime = -1;
	personalSightPos = self.origin;
	
	reacquireTime = 3000;
	thread trackVelocity();
	
	thread previewSightPos();
	thread previewAccuracy();

	lastEnemy = undefined;
	hasLastEnemySightPos = false;
	for (;;)
	{
		if (!isdefined (self.squad))
		{
			wait (0.2);
			continue;
		}
		
		if (isdefined (lastEnemy) && isalive (self.enemy) && lastEnemy != self.enemy)
		{
			/*
			// Reset your accuracy if your enemy just changed to the player
			if (self.enemy == level.player && level.gameSkill <= 9)
				thread resetAccuracy();
			*/
				
			personalSightPos = self.origin;
			self.personalSightTime = -1;
		}
		
		lastEnemy = self.enemy;
		
		/*
		if (isdefined(self.squad.sightpos))
		{
			if (!isdefined (lastGroupSightSpot))
			{
				self.goodShootPos = undefined;
				thread resetAccuracy();
			}
			else
			{
				if (distance (lastGroupSightSpot, self.squad.sightpos) > 80)
				{
					self.goodShootPos = undefined;
					thread resetAccuracy();
				}
			}
		}
		*/
		
	
		if (isdefined (self.lastEnemySightPos) && isalive (self.enemy))
		{
			// If you have no personalSightPos or the enemy position has changed or
			// the enemy is near the last place you saw him, then refresh it
			if (distance(self.enemy.origin, self.lastEnemySightPos) < 100)
			{
				personalSightPos = self.lastEnemySightPos;
				self.personalSightTime = gettime();

				/*
				if (!hasLastEnemySightPos && self.enemy == level.player && level.gameSkill <= 9)
					thread resetAccuracy();
				*/
				hasLastEnemySightPos = true;
			}
			else
			if (self.enemy == level.player)
			{
				/*
				if (level.gameSkill <= 9)
					self.accuracy = 0;
				self notify ("reset_accuracy");
				*/
				hasLastEnemySightPos = false;
			}
		}
		else
			hasLastEnemySightPos = false;

//				if (newtime - personalSightTime > reacquireTime)
//					thread resetAccuracy();

		/*	
		if (!isdefined (self.squad.sightpos))
		{
 			if (isdefined (personalSightPos))
 			{
				self.squad.sightpos = personalSightPos;
				self.squad.sightTime = personalSightTime;
			}
			wait (0.05);
			continue;
		}
		*/

		/*
		if (self.personalSightTime > self.squad.sightTime && isalive (self.enemy))
		{
			self.squad.sightpos = personalSightPos;
			self.squad.sightTime = self.personalSightTime;
			self.squad.sightEnemy = self.enemy;
			self.squad thread clearEnemy();
		}
		else
		{
			personalSightPos = self.squad.sightpos;
			personalSightTime = self.squad.sightTime;
		}
		*/
		
		wait (0.05);
	}
}

clearEnemy()
{
	self notify ("stop waiting for enemy to die");
	self endon ("stop waiting for enemy to die");
	self.sightEnemy waittill ("death");
	self.sightpos = undefined;
	self.sightTime = 0;
	self.sightEnemy = undefined;
}

previewSightPos()
{
	/#
	self endon ("death");
	for (;;)
	{
		if (getdebugcvar ("debug_lastsightpos") != "on")
		{
			wait (1);
			continue;
		}
		
		wait (0.05);
		if (!isdefined(self.lastEnemySightPos))
			continue;

		print3d (self.lastEnemySightPos, "X", (0.2,0.5,1.0), 1, 1.0);	// origin, text, RGB, alpha, scale
//		print3d (getEnemySightPos(), "X " + self.squad.members.size, (0.2,0.5,1.0), 1, 1.0);	// origin, text, RGB, alpha, scale
		
	}
	#/
}

previewAccuracy()
{
	/#
	if (!isdefined (level.offsetNum))
		level.offsetNum = 0;
		
//	offset = level.offsetNum;
	offset = 1;
	level.offsetNum++;
	if (level.offsetNum > 5)
		level.offsetNum = 1;
	self endon ("death");
	for (;;)
	{
		if (getdebugcvar ("debug_accuracypreview") != "on")
		{
			wait (1);
			continue;
		}
		
		wait (0.05);
		print3d (self.origin + (0,0,70 + 25*offset ), self.accuracy, (0.2,0.5,1.0), 1, 1.15);
			// origin, text, RGB, alpha, scale
	}
	#/
}

trackVelocity()
{
	self endon ("death");

	for (;;)
	{
//		println ("keep claimed node: " + self.keepClaimedNode);
		self.oldOrigin = self.origin;
		wait (0.2);
	}
}

// Cleans up scripts on death
deathNotify()
{
	self waittill ("death");
	self notify (anim.scriptChange);
}
/*
addToGroup(group)
{
	if (maps\_utility::spawn_failed(self))
		return;
		
	// Wait gives the level scripts a chance to put the guy into a group.
	wait (0.05);

	if (!isalive (self))
		return;
	
	if (isdefined(self.group))
		return;
		
	if (!isdefined(group.ai))
		group.ai = [];
		
	self.group = group;
	group.ai[group.ai.size] = self;
	
	self waittill ("death");
	newAI = [];
	for (i=0;i<group.ai.size;i++)
	{
		if (!isalive(group.ai[i]))
			continue;
		newAI[newAI.size] = group.ai[i];
	}
	group.ai = newAI;
}
*/

testLife()
{
	for (;;)
	{
		if (!isalive(self))
			break;
		thread testLifeThink();
		wait (0.05);
	}
}

testLifeThink()
{
	self notify ("new test");
	self endon ("new test");
	
	self endon ("killanimscript");
	assert (isalive(self));
	for (;;)
	{
		assertEX (isalive(self), "This should never be hittable due to endon killanimscript. Make your peace and prepare to die.");
		if (isalive(self))
			wait (0.05);
	}
}

debugCorner()
{
	self thread debugCornerProc();
}

debugCornerProc()
{
	if (!isdefined (self.node))
	{
		wait (0.5);
		self dodamage( (self.health *0.5), (0,0,0) );
		level notify ("debug_next_corner");
		return;
	}

	if (self.node.type == "Cover Right")
		coverRightTest();
	else
		coverLeftTest();

	level notify ("debug_next_corner");
}

coverRightTest()
{
	self endon ("death");
	self OrientMode( "face angle", self.node.angles[1]-90 );
	showAnim(%corner_right_stand_alert2look);
	showAnim(%corner_right_stand_alertlookidle);
	showAnim(%corner_right_stand_look2alert);
	
	showAnim(%corner_right_stand_alert2aimleft);
	showAnim(%corner_right_stand_aimleft2alert);
	
	showAnim(%corner_right_stand_alert2aimstraight);
	showAnim(%corner_right_stand_aimstraight2alert);
	
	showAnim(%corner_right_stand_alert2aimright);
	showAnim(%corner_right_stand_aimright2alert);
	
	showAnim(%corner_right_stand_alert2aimbehind);
	showAnim(%corner_right_stand_behind2right);
	
	showAnim(%corner_right_stand_right2straight);
	showAnim(%corner_right_stand_straight2left);
	
	showAnim(%corner_right_stand_left2straight);
	showAnim(%corner_right_stand_straight2right);
	
	showAnim(%corner_right_stand_right2behind);
	showAnim(%corner_right_stand_aimbehind2alert);

	showAnim(%corner_right_crouch_alert2look);
	showAnim(%corner_right_crouch_alertlookidle);
	showAnim(%corner_right_crouch_look2alert);
	
	showAnim(%corner_right_crouch_alert2aimleft);
	showAnim(%corner_right_crouch_aimleft2alert);
	
	showAnim(%corner_right_crouch_alert2aimstraight);
	showAnim(%corner_right_crouch_aimstraight2alert);
	
	showAnim(%corner_right_crouch_alert2aimright);
	showAnim(%corner_right_crouch_aimright2alert);
	
	showAnim(%corner_right_crouch_alert2aimbehind);
	showAnim(%corner_right_crouch_behind2right);
	
	showAnim(%corner_right_crouch_right2straight);
	showAnim(%corner_right_crouch_straight2left);
	
	showAnim(%corner_right_crouch_left2straight);
	showAnim(%corner_right_crouch_straight2right);
	
	showAnim(%corner_right_crouch_right2behind);
	showAnim(%corner_right_crouch_aimbehind2alert);
	self delete();
}

coverLeftTest()
{
	self endon ("death");
	self OrientMode( "face angle", self.node.angles[1]+90 );
	showAnim(%corner_left_stand_alert2look);
	showAnim(%corner_left_stand_alertlookidle);
	showAnim(%corner_left_stand_look2alert);
	
	showAnim(%corner_left_stand_alert2aimright);
	showAnim(%corner_left_stand_aimright2alert);
	
	showAnim(%corner_left_stand_alert2aimstraight);
	showAnim(%corner_left_stand_aimstraight2alert);
	
	showAnim(%corner_left_stand_alert2aimleft);
	showAnim(%corner_left_stand_aimleft2alert);
	
	showAnim(%corner_left_stand_alert2aimbehind);
	showAnim(%corner_left_stand_behind2left);
	
	showAnim(%corner_left_stand_left2straight);
	showAnim(%corner_left_stand_straight2right);
	
	showAnim(%corner_left_stand_right2straight);
	showAnim(%corner_left_stand_straight2left);
	
	showAnim(%corner_left_stand_left2behind);
	showAnim(%corner_left_stand_aimbehind2alert);

	showAnim(%corner_left_crouch_alert2look);
	showAnim(%corner_left_crouch_alertlookidle);
	showAnim(%corner_left_crouch_look2alert);
	
	showAnim(%corner_left_crouch_alert2aimright);
	showAnim(%corner_left_crouch_aimright2alert);
	
	showAnim(%corner_left_crouch_alert2aimstraight);
	showAnim(%corner_left_crouch_aimstraight2alert);
	
	showAnim(%corner_left_crouch_alert2aimleft);
	showAnim(%corner_left_crouch_aimright2alert);
	
	showAnim(%corner_left_crouch_alert2aimbehind);
	showAnim(%corner_left_crouch_behind2left);
	
	showAnim(%corner_left_crouch_left2straight);
	showAnim(%corner_left_crouch_straight2right);
	
	showAnim(%corner_left_crouch_right2straight);
	showAnim(%corner_left_crouch_straight2left);
	
	showAnim(%corner_left_crouch_left2behind);
	showAnim(%corner_left_crouch_aimbehind2alert);
	self delete();
		
}


showAnim(animname)
{
	wait (0.05);
	self clearanim(%body, 0);
	self animMode ( "gravity" ); // Unlatch the feet
	self.keepClaimedNode = true;
	self setflaggedanim("finished", animname, 1, 0, 1);
	self waittillmatch ("finished", "end");
}


setupHats()
{
	anim.noHat = []; // tracks which models arent meant to have detachable hats.		
	addNoHat("xmodel/character_british_africa_price");
	addNoHat("xmodel/character_british_normandy_price");
	addNoHat("xmodel/character_british_normandy_price");
	addNoHat("xmodel/character_german_winter_masked_dark");
	addNoHat("xmodel/character_russian_trench_d");

	anim.noHatClassname = []; // tracks which models arent meant to have detachable hats.		
	addNoHatClassname("actor_ally_rus_volsky");

	anim.metalHat = []; // tracks which models arent meant to have detachable hats.		
	addMetalHat("xmodel/character_british_duhoc_driver");
	addMetalHat("xmodel/character_us_ranger_cpl_a");
	addMetalHat("xmodel/character_us_ranger_lt_coffey");
	addMetalHat("xmodel/character_us_ranger_medic_wells");
	addMetalHat("xmodel/character_us_ranger_pvt_a");
	addMetalHat("xmodel/character_us_ranger_pvt_a_low");
	addMetalHat("xmodel/character_us_ranger_pvt_a_wounded");
	addMetalHat("xmodel/character_us_ranger_pvt_b");
	addMetalHat("xmodel/character_us_ranger_pvt_b_low");
	addMetalHat("xmodel/character_us_ranger_pvt_b_wounded");
	addMetalHat("xmodel/character_us_ranger_pvt_braeburn");
	addMetalHat("xmodel/character_us_ranger_pvt_c");
	addMetalHat("xmodel/character_us_ranger_pvt_c_low");
	addMetalHat("xmodel/character_us_ranger_pvt_d");
	addMetalHat("xmodel/character_us_ranger_pvt_d_low");
	addMetalHat("xmodel/character_us_ranger_pvt_mccloskey");
	addMetalHat("xmodel/character_us_ranger_radio");
	addMetalHat("xmodel/character_us_ranger_sgt_randall");
	addMetalHat("xmodel/character_us_wet_ranger_cpl_a");
	addMetalHat("xmodel/character_us_wet_ranger_lt_coffey");
	addMetalHat("xmodel/character_us_wet_ranger_medic_wells");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_a");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_a_low");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_a_wounded");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_b");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_b_low");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_b_wounded");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_braeburn");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_c");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_c_low");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_d");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_d_low");
	addMetalHat("xmodel/character_us_wet_ranger_pvt_mccloskey");
	addMetalHat("xmodel/character_us_wet_ranger_radio");
	addMetalHat("xmodel/character_us_wet_ranger_sgt_randall");
	addMetalHat("xmodel/character_british_afrca_body");
	addMetalHat("xmodel/character_british_afrca_body_low");
	addMetalHat("xmodel/character_british_afrca_mac_body");
	addMetalHat("xmodel/character_british_afrca_mac_radio");
	addMetalHat("xmodel/character_british_afrca_mcgregor_low");
	addMetalHat("xmodel/character_british_afrca_shortsleeve_body");
	addMetalHat("xmodel/character_british_normandy_a");
	addMetalHat("xmodel/character_british_normandy_b");
	addMetalHat("xmodel/character_british_normandy_c");
	addMetalHat("xmodel/character_british_normandy_mac_body");
	addMetalHat("xmodel/character_german_afrca_body");
	addMetalHat("xmodel/character_german_afrca_casualbody");
	addMetalHat("xmodel/character_german_camo_fat");
	addMetalHat("xmodel/character_german_normandy_coat_dark");
	addMetalHat("xmodel/character_german_normandy_fat");
	addMetalHat("xmodel/character_german_normandy_fat_injured");
	addMetalHat("xmodel/character_german_normandy_officer");
	addMetalHat("xmodel/character_german_normandy_thin");
	addMetalHat("xmodel/character_german_normandy_thin_injured");
	addMetalHat("xmodel/character_german_winter_light");
	addMetalHat("xmodel/character_german_winter_masked_dark");
	addMetalHat("xmodel/character_german_winter_mg42_low");
	addMetalHat("xmodel/character_russian_padded_b");
	addMetalHat("xmodel/character_russian_trench_b");
	
	anim.fatGuy = []; // fat models
	addFatGuy("xmodel/character_german_camo_fat");
	addFatGuy("xmodel/character_german_normandy_fat");
	addFatGuy("xmodel/character_russian_trench_a");
	addFatGuy("xmodel/character_german_normandy_fat_injured");
}	

addNoHat(model)
{
	anim.noHat[model] = 1;
}

addNoHatClassname(model)
{
	anim.noHatClassname[model] = 1;
}

addMetalHat(model)
{
	anim.metalHat[model] = 1;
}

addFatGuy(model)
{
	anim.fatGuy[model] = 1;
}



initWindowTraverse()
{
	// used to blend the traverse window_down smoothly at the end
	level.window_down_height[0] = -36.8552;
	level.window_down_height[1] = -27.0095;
	level.window_down_height[2] = -15.5981;
	level.window_down_height[3] = -4.37769;
	level.window_down_height[4] = 17.7776;
	level.window_down_height[5] = 59.8499;
	level.window_down_height[6] = 104.808;
	level.window_down_height[7] = 152.325;
	level.window_down_height[8] = 201.052;
	level.window_down_height[9] = 250.244;
	level.window_down_height[10] = 298.971;
	level.window_down_height[11] = 330.681;
}