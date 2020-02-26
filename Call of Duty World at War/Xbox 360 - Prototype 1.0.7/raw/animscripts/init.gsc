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
// 		homemade_error = Unexpected_anim_pose_value + self.a.pose;
// I also have a kind of assert, called as follows:
//		[[anim.assertEX(condition, message_string);
// If condition evaluates to 0, the assert fires, prints message_string and stops the server. Since 
// I don't have stack traces of any kind, the message string needs to say from where the assert was 
// called.

#include animscripts\Utility;
#include maps\_utility;
#include animscripts\Combat_utility;
#include common_scripts\Utility;
#using_animtree ("generic_human");

initWeapon( weapon, slot )
{
	self.weaponInfo[weapon] = spawnstruct();
	
	self.weaponInfo[weapon].slot = slot;
	self.weaponInfo[weapon].position = "none";
	self.weaponInfo[weapon].hasClip = true;
	if ( getWeaponClipModel( weapon ) != "" )
		self.weaponInfo[weapon].useClip = true;
	else
		self.weaponInfo[weapon].useClip = false;
}

main()
{
	self.a = spawnStruct();
	self.a.laserOn = false;
	self.primaryweapon = self.weapon;
	
	self initWeapon( self.primaryweapon, "primary" );
	self initWeapon( self.secondaryweapon, "secondary" );
	self initWeapon( self.sidearm, "sidearm" );
	
	self.a.weaponPos["left"] = "none";
	self.a.weaponPos["right"] = "none";
	self.a.weaponPos["chest"] = "none";
	self.a.weaponPos["back"] = "none";

	self.lastWeapon = self.weapon;
	
	self thread beginGrenadeTracking();
	
	firstInit();
	
	// TODO: proper ammo tracking
	self.a.rockets = 3;
	
	anim.nonstopFireguy++;
	if (anim.nonstopFireguy >= 2)
	{
		self.a.nonstopFire = true;
		anim.nonstopFireguy = 0;
	}
	else
		self.a.nonstopFire = false;
	self.a.nonstopFire = false;
	
	anim.reacquireNum--;
	if (anim.reacquireNum <= 0 && self.team == "axis")
	{
		anim.reacquireNum = 1;
     	self.a.reacquireGuy = true;
    }
	else
     	self.a.reacquireGuy = false;
	

//	SetWeaponDist();
//	SetAmmoCounts();
		
	// Set initial states for poses
	self.a.pose = "stand";
	self.a.movement = "stop";
	self.a.state = "stop";
	self.a.idleSet = "none";
	self.a.special = "none";
	self.a.gunHand = "none";	// Initialize so that PutGunInHand works properly.
	self.a.PrevPutGunInHandTime = -1;

	animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
	if(weaponclass(self.secondaryweapon) == "spread")
		animscripts\shared::placeWeaponOn( self.secondaryweapon, "back");
	
	self.a.needsToRechamber = 0;
	self.a.combatEndTime = gettime();
	self.a.script = "init";
	self.a.alertness = "casual"; // casual, alert, aiming
	self.a.lastEnemyTime = gettime();
	self.a.forced_cover = "none";
	self.a.suppressingEnemy = false;
	self.a.desired_script = "none";
	self.a.current_script = "none";
	self.a.disableLongDeath = self.team != "axis";
	self.a.lookangle = 0;
	self.a.painTime = 0;
	self.a.lastShootTime = 0;
	
	
	self.a.stance = "stand";
	//self.a.state = "idle";
	
	self._animActive = 0;
	self._lastAnimTime = 0;
//	self.a.ignoreSuppressionTime = 0;
	if (!isdefined(self.script_displaceable))
		self.script_displaceable = -1; // -1 means defaulted to off
	
	self thread deathNotify();
	self thread enemyNotify();
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
		
	self.a.yawTransition = "none";
	self.a.nodeath = false;
//	self.baseAccuracy = self.accuracy * 2.5;
	self.a.missTime = 0;
	self.a.missTimeDebounce = 0;
	self.a.disablePain = false;

	self.accuracyStationaryMod = 1;
	self.chatInitialized = false;
	self.sightPosTime = 0;
	self.sightPosLeft = true;
	self.preCombatRunEnabled = true;
	self.goodShootPosValid = false;
	self.needRecalculateGoodShootPos = true;
	self.a.grenadeFlee = %combatrun_forward_2;
	
	self.a.crouchpain = false; // for dying pain guys
	self.a.nextStandingHitDying = false;
	anim_set_next_move_to_new_cover();

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
	self.a.lastDebugPrint = "";
#/
	self.a.StopCowering = ::DoNothing;	// This is a "handler" function.  SetPoseMovement could be 
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
	if ( animscripts\weaponList::usingAutomaticWeapon() )
		self . ramboChance = 15;
	else if (animscripts\weaponList::usingSemiAutoWeapon())
		self . ramboChance = 7;
	else
		self . ramboChance = 0;
	if (self.team == "axis")
		self . ramboChance *= 2;

    self . coverIdleSelectTime = -696969;
    self.exception = [];
    
    self.exception[ "corner" ] = 1;
    self.exception[ "cover_crouch" ] = 1;
    self.exception[ "stop" ] = 1;
    self.exception[ "stop_immediate" ] = 1;
    self.exception[ "move" ] = 1;
    self.exception[ "exposed" ] = 1;
    self.exception[ "corner_normal" ] = 1;

	keys = getArrayKeys( self.exception );
	for ( i=0; i < keys.size; i++ )
	{
		clear_exception( keys[ i ] );
	}
	
	self.old = spawnstruct();

//	if (self getentitynumber() == 120)
//		self thread printvoice();

	self.reacquire_state = 0;

	self thread setNameAndRank();

	self thread animscripts\squadManager::addToSquad();

	//SetGoalFromTarget();
	
	/#
	self thread printEyeOffsetFromNode();
	#/
}

/#
printEyeOffsetFromNode()
{
	self endon("death");
	while(1)
	{
		if ( getdvarint("scr_eyeoffset") == self getentnum() )
		{
			if ( isdefined( self.coverNode ) )
			{
				offset = self geteye() - self.coverNode.origin;
				forward = anglestoforward(self.coverNode.angles);
				right = anglestoright(self.coverNode.angles);
				trueoffset = (vectordot(right, offset), vectordot(forward, offset), offset[2]);
				println( trueoffset );
			}
		}
		else
			wait 2;
		wait .1;
	}
}
#/

setNameAndRank()
{
	self endon ( "death" );
	if (!isdefined (level.loadoutComplete))
		level waittill ("loadout complete");
		
	self maps\_names::get_name();
}

SetWeaponDist()
{
	// changed to pathenemyFightdist and pathenemyLookahead and engagementMinDist etc
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
	else if ( animscripts\weaponList::usingShotgunWeapon() )
	{
		self.minDist = 16; 
		self.maxDist = 256;	
	}
}


SetAmmoCounts()
{
//	self.ammoCounts[self.weapon] = getAIMaxAmmo(self.weapon);
//	self.ammoCounts[self.secondaryweapon] = getAIMaxAmmo(self.secondaryweapon);
//	self.ammoCounts[self.sidearm] = getAIMaxAmmo(self.sidearm);
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


		aboveHead = self getshootatpos() + (0,0,30);
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
		aboveHead = self getshootatpos() + (0,0,10);
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
			self.a.combatrunanim = anim.combatRunAnim;
			self.a.crouchrunanim = %pistol_crouchrun_loop_forward_1;
			break;
		case 1:
			self.a.combatrunanim = anim.combatRunAnim;
			self.a.crouchrunanim = %pistol_crouchrun_loop_forward_2;
			break;
		case 2:
			self.a.combatrunanim = anim.combatRunAnim;
			self.a.crouchrunanim = %pistol_crouchrun_loop_forward_3;
			break;
		}
		*/
		self.a.combatrunanim = %combat_run_fast_pistol;
		self.a.crouchrunanim = %pistol_crouchrun_loop_forward_1;
		
	}
	else
	{
		// There are four crouchrun loops but three run loops, and we want to make sure that the number three 
		// ones always get assigned together, so assign crouchrun 4 to 1/3 of the guys who get run 1 or 2.
		switch ( self getentitynumber() % 3 )
		{
		case 0:
			self.a.combatrunanim = anim.combatRunAnim[0];
		//	self.a.combatrunanim = random(anim.combatRunAnim);
			
			if ( self getentitynumber() % 9 < 6 )
			{
				self.a.crouchrunanim = %crouchrun_loop_forward_2; //1
			}
			else
			{
				self.a.crouchrunanim = %crouchrun_loop_forward_2; // 4
			}
			break;
		case 1:
			self.a.combatrunanim = anim.combatRunAnim[0];
			//self.a.combatrunanim = random(anim.combatRunAnim);
			
			if ( self getentitynumber() % 9 < 3 )
			{
				self.a.crouchrunanim = %crouchrun_loop_forward_2; //4
			}
			else
			{
				self.a.crouchrunanim = %crouchrun_loop_forward_2;
			}
			break;
		case 2:
			self.a.combatrunanim = anim.combatRunAnim[0];
			//self.a.combatrunanim = random(anim.combatRunAnim);
			self.a.crouchrunanim = %crouchrun_loop_forward_2; // 3
			break;
		}
	}
	if (!isDefined(self.animplaybackrate))
	{
		set_anim_playback_rate();
	}
}

set_anim_playback_rate()
{
	self.animplaybackrate = 0.8 + randomfloat( 0.4 );
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
		if (getdebugdvar ("debug_lastsightpos") != "on")
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
		if (getdebugdvar ("debug_accuracypreview") != "on")
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

enemyNotify()
{
	self endon ("death");
	if (1) return;
	for (;;)
	{
		self waittill ("enemy");
		if (!isalive(self.enemy))
			continue;
		while (self.enemy == level.player)
		{
			if (hasEnemySightPos())
				level.lastPlayerSighted = gettime();
			wait (2);
		}
	}
}


// Cleans up scripts on death
deathNotify()
{
	self waittill ("death", other);
	if (isdefined(other))
	{
		// increase the difficulty slightly on a kill
		if (other == level.player)
			setdvar("autodifficulty_frac", getdvarint("autodifficulty_frac") + 2);
	}
	
	
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
	addNoHat("character_british_africa_price");
	addNoHat("character_british_normandy_price");
	addNoHat("character_british_normandy_price");
	addNoHat("character_german_winter_masked_dark");
	addNoHat("character_russian_trench_d");

	anim.noHatClassname = []; // tracks which models arent meant to have detachable hats.		
	addNoHatClassname("actor_ally_rus_volsky");

	anim.metalHat = []; // tracks which models arent meant to have detachable hats.		
	addMetalHat("character_british_duhoc_driver");
	addMetalHat("character_us_ranger_cpl_a");
	addMetalHat("character_us_ranger_lt_coffey");
	addMetalHat("character_us_ranger_medic_wells");
	addMetalHat("character_us_ranger_pvt_a");
	addMetalHat("character_us_ranger_pvt_a_low");
	addMetalHat("character_us_ranger_pvt_a_wounded");
	addMetalHat("character_us_ranger_pvt_b");
	addMetalHat("character_us_ranger_pvt_b_low");
	addMetalHat("character_us_ranger_pvt_b_wounded");
	addMetalHat("character_us_ranger_pvt_braeburn");
	addMetalHat("character_us_ranger_pvt_c");
	addMetalHat("character_us_ranger_pvt_c_low");
	addMetalHat("character_us_ranger_pvt_d");
	addMetalHat("character_us_ranger_pvt_d_low");
	addMetalHat("character_us_ranger_pvt_mccloskey");
	addMetalHat("character_us_ranger_radio");
	addMetalHat("character_us_ranger_sgt_randall");
	addMetalHat("character_us_wet_ranger_cpl_a");
	addMetalHat("character_us_wet_ranger_lt_coffey");
	addMetalHat("character_us_wet_ranger_medic_wells");
	addMetalHat("character_us_wet_ranger_pvt_a");
	addMetalHat("character_us_wet_ranger_pvt_a_low");
	addMetalHat("character_us_wet_ranger_pvt_a_wounded");
	addMetalHat("character_us_wet_ranger_pvt_b");
	addMetalHat("character_us_wet_ranger_pvt_b_low");
	addMetalHat("character_us_wet_ranger_pvt_b_wounded");
	addMetalHat("character_us_wet_ranger_pvt_braeburn");
	addMetalHat("character_us_wet_ranger_pvt_c");
	addMetalHat("character_us_wet_ranger_pvt_c_low");
	addMetalHat("character_us_wet_ranger_pvt_d");
	addMetalHat("character_us_wet_ranger_pvt_d_low");
	addMetalHat("character_us_wet_ranger_pvt_mccloskey");
	addMetalHat("character_us_wet_ranger_radio");
	addMetalHat("character_us_wet_ranger_sgt_randall");
	addMetalHat("character_british_afrca_body");
	addMetalHat("character_british_afrca_body_low");
	addMetalHat("character_british_afrca_mac_body");
	addMetalHat("character_british_afrca_mac_radio");
	addMetalHat("character_british_afrca_mcgregor_low");
	addMetalHat("character_british_afrca_shortsleeve_body");
	addMetalHat("character_british_normandy_a");
	addMetalHat("character_british_normandy_b");
	addMetalHat("character_british_normandy_c");
	addMetalHat("character_british_normandy_mac_body");
	addMetalHat("character_german_afrca_body");
	addMetalHat("character_german_afrca_casualbody");
	addMetalHat("character_german_camo_fat");
	addMetalHat("character_german_normandy_coat_dark");
	addMetalHat("character_german_normandy_fat");
	addMetalHat("character_german_normandy_fat_injured");
	addMetalHat("character_german_normandy_officer");
	addMetalHat("character_german_normandy_thin");
	addMetalHat("character_german_normandy_thin_injured");
	addMetalHat("character_german_winter_light");
	addMetalHat("character_german_winter_masked_dark");
	addMetalHat("character_german_winter_mg42_low");
	addMetalHat("character_russian_padded_b");
	addMetalHat("character_russian_trench_b");
	
	anim.fatGuy = []; // fat models
	addFatGuy("character_german_camo_fat");
	addFatGuy("character_german_normandy_fat");
	addFatGuy("character_russian_trench_a");
	addFatGuy("character_german_normandy_fat_injured");
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

initMoveStartStopTransitions()
{
	transTypes = [];
	transTypes[0] = "left";
	transTypes[1] = "right";
	transTypes[2] = "left_crouch";
	transTypes[3] = "right_crouch";
	transTypes[4] = "crouch";
	transTypes[5] = "stand";
	transTypes[6] = "exposed";
	
	// CORNER TRANSITIONS ANIMS
	anim.cornerTrans = [];
	anim.cornerExit = [];
	
	anim.traverseInfo = [];
	// indicies indicate the keyboard numpad directions (8 is forward)
	// 7  8  9
	// 4     6	 <- 5 is invalid
	// 1  2  3

	/*************************************************
	*    Entrance Animations
	*************************************************/
	
	anim.cornerTrans["right"       ][1] = %corner_standR_trans_IN_1;
	anim.cornerTrans["right"       ][2] = %corner_standR_trans_IN_2;
	anim.cornerTrans["right"       ][3] = %corner_standR_trans_IN_3;
	anim.cornerTrans["right"       ][4] = %corner_standR_trans_IN_4;
	anim.cornerTrans["right"       ][6] = %corner_standR_trans_IN_6;
	//im.cornerTrans["right"       ][7] = can't approach from this direction;
	anim.cornerTrans["right"       ][8] = %corner_standR_trans_IN_8;
	anim.cornerTrans["right"       ][9] = %corner_standR_trans_IN_9;

	anim.cornerTrans["right_crouch"][1] = %CornerCrR_trans_IN_ML;
	anim.cornerTrans["right_crouch"][2] = %CornerCrR_trans_IN_M;
	anim.cornerTrans["right_crouch"][3] = %CornerCrR_trans_IN_MR;
	anim.cornerTrans["right_crouch"][4] = %CornerCrR_trans_IN_L;
	anim.cornerTrans["right_crouch"][6] = %CornerCrR_trans_IN_R;
	//im.cornerTrans["right_crouch"][7] = can't approach from this direction;
	anim.cornerTrans["right_crouch"][8] = %CornerCrR_trans_IN_F;
	anim.cornerTrans["right_crouch"][9] = %CornerCrR_trans_IN_MF;

	anim.cornerTrans["left"        ][1] = %corner_standL_trans_IN_1;
	anim.cornerTrans["left"        ][2] = %corner_standL_trans_IN_2;
	anim.cornerTrans["left"        ][3] = %corner_standL_trans_IN_3;
	anim.cornerTrans["left"        ][4] = %corner_standL_trans_IN_4;
	anim.cornerTrans["left"        ][6] = %corner_standL_trans_IN_6;
	anim.cornerTrans["left"        ][7] = %corner_standL_trans_IN_7;
	anim.cornerTrans["left"        ][8] = %corner_standL_trans_IN_8;
	//im.cornerTrans["left"        ][9] = can't approach from this direction;
	
	anim.cornerTrans["left_crouch" ][1] = %CornerCrL_trans_IN_ML;
	anim.cornerTrans["left_crouch" ][2] = %CornerCrL_trans_IN_M;
	anim.cornerTrans["left_crouch" ][3] = %CornerCrL_trans_IN_MR;
	anim.cornerTrans["left_crouch" ][4] = %CornerCrL_trans_IN_L;
	anim.cornerTrans["left_crouch" ][6] = %CornerCrL_trans_IN_R;
	anim.cornerTrans["left_crouch" ][7] = %CornerCrL_trans_IN_MF;
	anim.cornerTrans["left_crouch" ][8] = %CornerCrL_trans_IN_F;
	//im.cornerTrans["left_crouch" ][9] = can't approach from this direction;
	
	anim.cornerTrans["crouch"      ][1] = %covercrouch_run_in_ML;
	anim.cornerTrans["crouch"      ][2] = %covercrouch_run_in_M;
	anim.cornerTrans["crouch"      ][3] = %covercrouch_run_in_MR;
	anim.cornerTrans["crouch"      ][4] = %covercrouch_run_in_L;
	anim.cornerTrans["crouch"      ][6] = %covercrouch_run_in_R;
	//im.cornerTrans["crouch"      ][7] = can't approach from this direction;
	//im.cornerTrans["crouch"      ][8] = can't approach from this direction;
	//im.cornerTrans["crouch"      ][9] = can't approach from this direction;
	
	anim.cornerTrans["stand"       ][1] = %coverstand_trans_IN_ML;
	anim.cornerTrans["stand"       ][2] = %coverstand_trans_IN_M;
	anim.cornerTrans["stand"       ][3] = %coverstand_trans_IN_MR;
	anim.cornerTrans["stand"       ][4] = %coverstand_trans_IN_L;
	anim.cornerTrans["stand"       ][6] = %coverstand_trans_IN_R;
	//im.cornerTrans["stand"       ][7] = can't approach from this direction;
	//im.cornerTrans["stand"       ][8] = can't approach from this direction;
	//im.cornerTrans["stand"       ][9] = can't approach from this direction;
	
	// we need 45 degree angle approaches for exposed...
	anim.cornerTrans["exposed"     ] = []; // need this or it chokes on the next line due to assigning undefined...
	anim.cornerTrans["exposed"     ][1] = undefined;
	anim.cornerTrans["exposed"     ][2] = %run_2_stand_F_6;
	anim.cornerTrans["exposed"     ][3] = undefined;
	anim.cornerTrans["exposed"     ][4] = %run_2_stand_90L;
	anim.cornerTrans["exposed"     ][6] = %run_2_stand_90R;
	anim.cornerTrans["exposed"     ][7] = undefined;
	anim.cornerTrans["exposed"     ][8] = %run_2_stand_180L;
	anim.cornerTrans["exposed"     ][9] = undefined;
	
	
	/*************************************************
	*    Exit Animations
	*************************************************/

	anim.cornerExit["right"       ][1] = %corner_standR_trans_OUT_1;
	anim.cornerExit["right"       ][2] = %corner_standR_trans_OUT_2;
	anim.cornerExit["right"       ][3] = %corner_standR_trans_OUT_3;
	anim.cornerExit["right"       ][4] = %corner_standR_trans_OUT_4;
	anim.cornerExit["right"       ][6] = %corner_standR_trans_OUT_6;
	//im.cornerExit["right"       ][7] = can't approach from this direction;
	anim.cornerExit["right"       ][8] = %corner_standR_trans_OUT_8;
	anim.cornerExit["right"       ][9] = %corner_standR_trans_OUT_9;
	
	anim.cornerExit["right_crouch"][1] = %CornerCrR_trans_OUT_ML;
	anim.cornerExit["right_crouch"][2] = %CornerCrR_trans_OUT_M;
	anim.cornerExit["right_crouch"][3] = %CornerCrR_trans_OUT_MR;
	anim.cornerExit["right_crouch"][4] = %CornerCrR_trans_OUT_L;
	anim.cornerExit["right_crouch"][6] = %CornerCrR_trans_OUT_R;
	//im.cornerExit["right_crouch"][7] = can't approach from this direction;
	anim.cornerExit["right_crouch"][8] = %CornerCrR_trans_OUT_F;
	anim.cornerExit["right_crouch"][9] = %CornerCrR_trans_OUT_MF;
	
	anim.cornerExit["left"        ][1] = %corner_standL_trans_OUT_1;
	anim.cornerExit["left"        ][2] = %corner_standL_trans_OUT_2;
	anim.cornerExit["left"        ][3] = %corner_standL_trans_OUT_3;
	anim.cornerExit["left"        ][4] = %corner_standL_trans_OUT_4;
	anim.cornerExit["left"        ][6] = %corner_standL_trans_OUT_6;
	anim.cornerExit["left"        ][7] = %corner_standL_trans_OUT_7;
	anim.cornerExit["left"        ][8] = %corner_standL_trans_OUT_8;
	//im.cornerExit["left"        ][9] = can't approach from this direction;
	
	anim.cornerExit["left_crouch" ][1] = %CornerCrL_trans_OUT_ML;
	anim.cornerExit["left_crouch" ][2] = %CornerCrL_trans_OUT_M;
	anim.cornerExit["left_crouch" ][3] = %CornerCrL_trans_OUT_MR;
	anim.cornerExit["left_crouch" ][4] = %CornerCrL_trans_OUT_L;
	anim.cornerExit["left_crouch" ][6] = %CornerCrL_trans_OUT_R;
	anim.cornerExit["left_crouch" ][7] = %CornerCrL_trans_OUT_MF;
	anim.cornerExit["left_crouch" ][8] = %CornerCrL_trans_OUT_F;
	//im.cornerExit["left_crouch" ][9] = can't approach from this direction;
	
	anim.cornerExit["crouch"      ][1] = %covercrouch_run_out_ML;
	anim.cornerExit["crouch"      ][2] = %covercrouch_run_out_M;
	anim.cornerExit["crouch"      ][3] = %covercrouch_run_out_MR;
	anim.cornerExit["crouch"      ][4] = %covercrouch_run_out_L;
	anim.cornerExit["crouch"      ][6] = %covercrouch_run_out_R;
	//im.cornerExit["crouch"      ][7] = can't approach from this direction;
	//im.cornerExit["crouch"      ][8] = can't approach from this direction;
	//im.cornerExit["crouch"      ][9] = can't approach from this direction;
	
	anim.cornerExit["stand"       ][1] = %coverstand_trans_OUT_ML;
	anim.cornerExit["stand"       ][2] = %coverstand_trans_OUT_M;
	anim.cornerExit["stand"       ][3] = %coverstand_trans_OUT_MR;
	anim.cornerExit["stand"       ][4] = %coverstand_trans_OUT_L;
	anim.cornerExit["stand"       ][6] = %coverstand_trans_OUT_R;
	//im.cornerExit["stand"       ][7] = can't approach from this direction;
	//im.cornerExit["stand"       ][8] = can't approach from this direction;
	//im.cornerExit["stand"       ][9] = can't approach from this direction;
	
	// we need 45 degree angle exits for exposed...
	anim.cornerExit["exposed"     ] = []; // need this or it chokes on the next line due to assigning undefined...
	anim.cornerExit["exposed"     ][1] = undefined;
	anim.cornerExit["exposed"     ][2] = %stand_2_run_180_med; // there is also _short, doesn't look as good
	anim.cornerExit["exposed"     ][3] = undefined;
	anim.cornerExit["exposed"     ][4] = %stand_2_run_L;
	anim.cornerExit["exposed"     ][6] = %stand_2_run_R;
	anim.cornerExit["exposed"     ][7] = undefined;
	anim.cornerExit["exposed"     ][8] = %stand_2_run_F_2;
	anim.cornerExit["exposed"     ][9] = undefined;
	
	
	/*************************************************
	*    Traverse Animations
	*************************************************/

	anim.cornerTrans["wall_over_96"][1] = %traverse90_IN_ML;
	anim.cornerTrans["wall_over_96"][2] = %traverse90_IN_M;
	anim.cornerTrans["wall_over_96"][3] = %traverse90_IN_MR;
	anim.traverseInfo["wall_over_96"]["height"] = 96;
	
	/*
	anim.cornerTrans["wall_over_40"][1] = %traverse40_IN_ML;
	anim.cornerTrans["wall_over_40"][2] = %traverse40_IN_M;
	anim.cornerTrans["wall_over_40"][3] = %traverse40_IN_MR;
	*/
	
	
	
	anim.cornerTransDist = [];
	anim.cornerExitDist = [];
	
	// this is the distance moved to get around corner for 7, 8, 9 directions
	anim.cornerExitPostDist = [];

	// this is the distance moved to get around corner for 7, 8, 9 directions
	anim.cornerTransPreDist = [];
	
	anim.cornerTransAngles = [];
	anim.cornerExitAngles = [];

	for ( i = 1; i <= 6; i++ )
	{
		if ( i == 5 )
			continue;
		
		for ( j = 0; j < transTypes.size; j++ )
		{
			trans = transTypes[j];
			
			if ( isdefined( anim.cornerTrans[ trans ][i] ) )
			{
				anim.cornerTransDist  [ trans ][i] = getMoveDelta ( anim.cornerTrans[ trans ][i], 0, 1 );
				anim.cornerTransAngles[ trans ][i] = getAngleDelta( anim.cornerTrans[ trans ][i], 0, 1 );
			}
			
			if ( isdefined( anim.cornerExit [ trans ][i] ) )
			{
				anim.cornerExitDist   [ trans ][i] = getMoveDelta ( anim.cornerExit [ trans ][i], 0, 1 );
				anim.cornerExitAngles [ trans ][i] = getAngleDelta( anim.cornerExit [ trans ][i], 0, 1 );
			}
		}

		if ( isDefined( anim.cornerTrans["wall_over_96"][i] ) )
			anim.cornerTransDist["wall_over_96"][i] = getMoveDelta( anim.cornerTrans["wall_over_96"][i], 0, 1 );
	}
	
	trans = "exposed";
	for ( i = 7; i <= 9; i++ )
	{
		if ( isdefined( anim.cornerTrans[ trans ][i] ) )
		{
			anim.cornerTransDist  [ trans ][i] = getMoveDelta ( anim.cornerTrans[ trans ][i], 0, 1 );
			anim.cornerTransAngles[ trans ][i] = getAngleDelta( anim.cornerTrans[ trans ][i], 0, 1 );
		}
		
		if ( isdefined( anim.cornerExit [ trans ][i] ) )
		{
			anim.cornerExitDist   [ trans ][i] = getMoveDelta ( anim.cornerExit [ trans ][i], 0, 1 );
			anim.cornerExitAngles [ trans ][i] = getAngleDelta( anim.cornerExit [ trans ][i], 0, 1 );
		}
	}
	
	anim.longestExposedApproachDist = 0;
	for ( i = 1; i <= 9; i++ )
	{
		if ( !isdefined( anim.cornerTrans["exposed"][i] ) )
			continue;
		
		len = length( anim.cornerTransDist["exposed"][i] );
		if ( len > anim.longestExposedApproachDist )
			anim.longestExposedApproachDist = len;
	}

	// the FindBestSplitTime calls below are used to find these values.
	// all of this is for corner nodes.
	anim.cornerExitSplit = [];
	anim.cornerTransSplit = [];
	
	anim.cornerExitSplit["left"][7] = 0.702; // TODO: best split time available, but still inside wall
	anim.cornerExitSplit["left"][8] = 0.616;
	anim.cornerExitSplit["left_crouch"][7] = 0.765; // TODO: best split time available, but still inside wall
	anim.cornerExitSplit["left_crouch"][8] = 0.588; // TODO: best split time available, but still inside wall
	anim.cornerExitSplit["right"][8] = 0.440;
	anim.cornerExitSplit["right"][9] = 0.522;
	anim.cornerExitSplit["right_crouch"][8] = 0.637;
	anim.cornerExitSplit["right_crouch"][9] = 0.594; // TODO: best split time available, but still inside wall
	
	anim.cornerTransSplit["left"][7] = 0.370; // TODO: best split time available, but still inside wall
	anim.cornerTransSplit["left"][8] = 0.460;
	anim.cornerTransSplit["left_crouch"][7] = 0.277;
	anim.cornerTransSplit["left_crouch"][8] = 0.339;
	anim.cornerTransSplit["right"][8] = 0.458;
	anim.cornerTransSplit["right"][9] = 0.495;
	anim.cornerTransSplit["right_crouch"][8] = 0.370; // TODO: best split time available, but still inside wall
	anim.cornerTransSplit["right_crouch"][9] = 0.369;
	
	for ( i = 7; i <= 8; i++ )
	{
		anim.cornerTransPreDist["left"        ][i] = getMoveDelta ( anim.cornerTrans["left"        ][i], 0, getTransSplitTime( "left", i ) );
		anim.cornerTransDist   ["left"        ][i] = getMoveDelta ( anim.cornerTrans["left"        ][i], 0, 1 ) - anim.cornerTransPreDist["left"][i];
		anim.cornerTransAngles ["left"        ][i] = getAngleDelta( anim.cornerTrans["left"        ][i], 0, 1 );
		anim.cornerTransPreDist["left_crouch" ][i] = getMoveDelta ( anim.cornerTrans["left_crouch" ][i], 0, getTransSplitTime( "left_crouch", i ) );
		anim.cornerTransDist   ["left_crouch" ][i] = getMoveDelta ( anim.cornerTrans["left_crouch" ][i], 0, 1 ) - anim.cornerTransPreDist["left_crouch"][i];
		anim.cornerTransAngles ["left_crouch" ][i] = getAngleDelta( anim.cornerTrans["left_crouch" ][i], 0, 1 );

		anim.cornerExitDist    ["left"        ][i] = getMoveDelta ( anim.cornerExit ["left"        ][i], 0, getExitSplitTime( "left", i ) );
		anim.cornerExitPostDist["left"        ][i] = getMoveDelta ( anim.cornerExit ["left"        ][i], 0, 1 ) - anim.cornerExitDist["left"][i];
		anim.cornerExitAngles  ["left"        ][i] = getAngleDelta( anim.cornerExit ["left"        ][i], 0, 1 );
		anim.cornerExitDist    ["left_crouch" ][i] = getMoveDelta ( anim.cornerExit ["left_crouch" ][i], 0, getExitSplitTime( "left_crouch", i ) );
		anim.cornerExitPostDist["left_crouch" ][i] = getMoveDelta ( anim.cornerExit ["left_crouch" ][i], 0, 1 ) - anim.cornerExitDist["left_crouch"][i];
		anim.cornerExitAngles  ["left_crouch" ][i] = getAngleDelta( anim.cornerExit ["left"        ][i], 0, 1 );
		
		/#
		/*FindBestSplitTime( anim.cornerTrans["left"       ][i], true , false, "stand left arrival in dir " + i );
		FindBestSplitTime( anim.cornerTrans["left_crouch"][i], true , false, "crouch left arrival in dir " + i );
		FindBestSplitTime( anim.cornerExit ["left"       ][i], false, false, "stand left exit in dir " + i );
		FindBestSplitTime( anim.cornerExit ["left_crouch"][i], false, false, "crouch left exit in dir " + i );*/
		
		/*AssertIsValidLeftSplitDelta( DeltaRotate( anim.cornerTransDist["left"][i], 180 - anim.cornerTransAngles["left"][i] ), "stand left arrival in dir " + i );
		AssertIsValidLeftSplitDelta( DeltaRotate( anim.cornerTransDist["left_crouch"][i], 180 - anim.cornerTransAngles["left_crouch"][i] ), "crouch left arrival in dir " + i );
		AssertIsValidLeftSplitDelta( anim.cornerExitDist["left"][i], "stand left exit in dir " + i );
		AssertIsValidLeftSplitDelta( anim.cornerExitDist["left_crouch"][i], "crouch left exit in dir " + i );*/
		#/
	}

	for ( i = 8; i <= 9; i++ )
	{
		anim.cornerTransPreDist["right"       ][i] = getMoveDelta ( anim.cornerTrans["right"       ][i], 0, getTransSplitTime( "right", i ) );
		anim.cornerTransDist   ["right"       ][i] = getMoveDelta ( anim.cornerTrans["right"       ][i], 0, 1 ) - anim.cornerTransPreDist["right"][i];
		anim.cornerTransAngles ["right"       ][i] = getAngleDelta( anim.cornerTrans["right"       ][i], 0, 1 );
		anim.cornerTransPreDist["right_crouch"][i] = getMoveDelta ( anim.cornerTrans["right_crouch"][i], 0, getTransSplitTime( "right_crouch", i ) );
		anim.cornerTransDist   ["right_crouch"][i] = getMoveDelta ( anim.cornerTrans["right_crouch"][i], 0, 1 ) - anim.cornerTransPreDist["right_crouch"][i];
		anim.cornerTransAngles ["right_crouch"][i] = getAngleDelta( anim.cornerTrans["right_crouch"][i], 0, 1 );

		anim.cornerExitDist    ["right"       ][i] = getMoveDelta ( anim.cornerExit ["right"       ][i], 0, getExitSplitTime( "right", i ) );
		anim.cornerExitPostDist["right"       ][i] = getMoveDelta ( anim.cornerExit ["right"       ][i], 0, 1 ) - anim.cornerExitDist["right"][i];
		anim.cornerExitAngles  ["right"       ][i] = getAngleDelta( anim.cornerExit ["right"       ][i], 0, 1 );
		anim.cornerExitDist    ["right_crouch"][i] = getMoveDelta ( anim.cornerExit ["right_crouch"][i], 0, getExitSplitTime( "right_crouch", i ) );
		anim.cornerExitPostDist["right_crouch"][i] = getMoveDelta ( anim.cornerExit ["right_crouch"][i], 0, 1 ) - anim.cornerExitDist["right_crouch"][i];
		anim.cornerExitAngles  ["right_crouch"][i] = getAngleDelta( anim.cornerExit ["right_crouch"][i], 0, 1 );

		/#
		/*FindBestSplitTime( anim.cornerTrans["right"       ][i], true , true, "stand right arrival in dir " + i );
		FindBestSplitTime( anim.cornerTrans["right_crouch"][i], true , true, "crouch right arrival in dir " + i );
		FindBestSplitTime( anim.cornerExit ["right"       ][i], false, true, "stand right exit in dir " + i );
		FindBestSplitTime( anim.cornerExit ["right_crouch"][i], false, true, "crouch right exit in dir " + i );*/

		/*AssertIsValidRightSplitDelta( DeltaRotate( anim.cornerTransDist["right"][i], 180 - anim.cornerTransAngles["right"][i] ), "stand right arrival in dir " + i );
		AssertIsValidRightSplitDelta( DeltaRotate( anim.cornerTransDist["right_crouch"][i], 180 - anim.cornerTransAngles["right_crouch"][i] ), "crouch right arrival in dir " + i );
		AssertIsValidRightSplitDelta( anim.cornerExitDist["right"][i], "stand right exit in dir " + i );
		AssertIsValidRightSplitDelta( anim.cornerExitDist["right_crouch"][i], "crouch right exit in dir " + i );*/
		#/
	}

	/#
	//thread checkApproachAngles( transTypes );
	#/
}

/#
FindBestSplitTime( exitanim, isapproach, isright, debugname )
{
	angleDelta = getAngleDelta( exitanim, 0, 1 );
	fullDelta = getMoveDelta( exitanim, 0, 1 );
	numiter = 1000;
	
	bestsplit = -1;
	bestvalue = -100000000;
	bestdelta = (0,0,0);

	for ( i = 0; i < numiter; i++ )
	{
		splitTime = 1.0 * i / (numiter - 1);
		
		delta = getMoveDelta( exitanim, 0, splitTime );
		if ( isapproach )
			delta = DeltaRotate( fullDelta - delta, 180 - angleDelta );
		if ( isright )
			delta = ( delta[0], 0 - delta[1], delta[2] );
		
		val = min( delta[0] - 32, delta[1] );
		
		if ( val > bestvalue || bestsplit < 0 )
		{
			bestvalue = val;
			bestsplit = splitTime;
			bestdelta = delta;
		}
	}
	
	if ( bestdelta[0] < 32 || bestdelta[1] < 0 )
	{
		println( "^0 ^1" + debugname + " has no valid split time available! Best was at " + bestsplit + ", delta of " + bestdelta );
		return;
	}
	println("^0 ^2" + debugname + " has best split time at " + bestsplit + ", delta of " + bestdelta );
}


DeltaRotate( delta, yaw )
{
	cosine = cos( yaw );
	sine = sin( yaw );
	return ( delta[0] * cosine - delta[1] * sine, delta[1] * cosine + delta[0] * sine, 0);
}

AssertIsValidLeftSplitDelta( delta, debugname )
{
	// in a delta, x is forward and y is left
	
	// assert the delta goes out far enough from the node
	if ( delta[0] < 32 )
		println( "^0 ^1" + debugname + " doesn't go out from the node far enough in the given split time (delta = " + delta + ")" );
	
	// assert the delta doesn't go into the wall
	if ( delta[1] < 0 )
		println( "^0 ^1" + debugname + " goes into the wall during the given split time (delta = " + delta + ")" );
}

AssertIsValidRightSplitDelta( delta, debugname )
{
	delta = ( delta[0], 0 - delta[1], delta[2] );
	return AssertIsValidLeftSplitDelta( delta, debugname );
}

checkApproachAngles( transTypes )
{
	idealTransAngles[1] = 45;
	idealTransAngles[2] = 0;
	idealTransAngles[3] = -45;
	idealTransAngles[4] = 90;
	idealTransAngles[6] = -90;
	idealTransAngles[7] = 135;
	idealTransAngles[8] = 180;
	idealTransAngles[9] = -135;
	
	wait .05;
	
	for ( i = 1; i <= 9; i++ )
	{
		for ( j = 0; j < transTypes.size; j++ )
		{
			trans = transTypes[j];
			
			idealAdd = 0;
			if ( trans == "left" || trans == "left_crouch" )
				idealAdd = 90;
			else if ( trans == "right" || trans == "right_crouch" )
				idealAdd = -90;
			
			if ( isdefined( anim.cornerTransAngles[ trans ][i] ) )
			{
				correctAngle = AngleClamp( idealTransAngles[i] + idealAdd, "-180 to 180" );
				actualAngle = AngleClamp( anim.cornerTransAngles[ trans ][i], "-180 to 180" );
				if ( abs( AngleClamp( actualAngle - correctAngle, "-180 to 180" ) ) > 7 )
				{
					println( "^1Cover approach animation has bad yaw delta: anim.cornerTrans[\"" + trans + "\"][" + i + "]; is ^2" + actualAngle + "^1, should be closer to ^2" + correctAngle + "^1." );
				}
			}
		}
	}

	for ( i = 1; i <= 9; i++ )
	{
		for ( j = 0; j < transTypes.size; j++ )
		{
			trans = transTypes[j];
			
			idealAdd = 0;
			if ( trans == "left" || trans == "left_crouch" )
				idealAdd = 90;
			else if ( trans == "right" || trans == "right_crouch" )
				idealAdd = -90;

			if ( isdefined( anim.cornerExitAngles[ trans ][i] ) )
			{
				correctAngle = AngleClamp( -1 * (idealTransAngles[i] + idealAdd + 180), "-180 to 180" );
				actualAngle = AngleClamp( anim.cornerExitAngles[ trans ][i], "-180 to 180" );
				if ( abs( AngleClamp( actualAngle - correctAngle, "-180 to 180" ) ) > 7 )
				{
					println( "^1Cover exit animation has bad yaw delta: anim.cornerTrans[\"" + trans + "\"][" + i + "]; is ^2" + actualAngle + "^1, should be closer to ^2" + correctAngle + "^1." );
				}
			}
		}
	}
}
#/

getExitSplitTime( approachType, dir )
{
	return anim.cornerExitSplit[ approachType ][ dir ];
	
	/*exitAnim = anim.cornerExit[ approachType ][ dir ];
	exitAlignTimes = getNotetrackTimes( exitAnim, "exit_align" );
	
	assert( exitAlignTimes.size == 1 );
	if ( exitAlignTimes.size == 0 )
		return .5;
	
	return exitAlignTimes[0];*/
}

getTransSplitTime( approachType, dir )
{
	return anim.cornerTransSplit[ approachType ][ dir ];
}


frameFraction(startFrame, endFrame, middleFrame)
{
	assert( startFrame < endFrame );
	assert( startFrame <= middleFrame );
	assert( middleFrame <= endFrame );
	return (middleFrame - startFrame) / (endFrame - startFrame);
}


firstInit()
{
	// Initialization that should happen once per level
	if ( isDefined (anim.NotFirstTime) ) // Use this to trigger the first init
		return;
	
	anim.NotFirstTime = 1;
	anim.useFacialAnims = false; // remove me when facial anims are fixed

	level.player = getent("player","classname");
	level.player.invul = false;
	level.nextGrenadeDrop = randomint(3);
	level.lastPlayerSighted = 100;
	anim.defaultException = animscripts\init::empty;
	/#
	if (getdebugdvar("debug_noanimscripts") == "")
		setdvar("debug_noanimscripts", "off");
	else
	if (getdebugdvar("debug_noanimscripts") == "on")
		anim.defaultException = animscripts\init::infiniteLoop;

	if (getdebugdvar("debug_grenadehand") == "")
		setdvar("debug_grenadehand", "off");
		
	if (getdebugdvar("anim_trace") == "")
		setdvar("anim_trace", "-1");
	if (getdebugdvar("anim_dotshow") == "")
		setdvar("anim_dotshow", "-1");
	if (getdebugdvar("anim_debug") == "")
		setdvar("anim_debug", "");
	if (getdebugdvar("debug_misstime") == "")
		setdvar("debug_misstime", "");
	if (getdvar("modern") == "")
		setdvar("modern", "on");
	#/

	init_mg_anims();	

	// Global constants
    anim . CoverStandShots = 0;
    anim . lastSideStepAnim = 0;
    anim.meleeRange = 64;
	anim.meleeRangeSq = anim.meleeRange * anim.meleeRange;
//		anim.standRangeSq = 503.06*503.06;  // was .25 normalize from melee to prone
	anim.standRangeSq = 512*512;  // was .25 normalize from melee to prone
//		anim.chargeRangeSq = 200*200;
	anim.chargeRangeSq = 200*200;
	anim.chargeLongRangeSq = 512*512;
	
	if (!isdefined (level.squadEnt))
		level.squadEnt = [];
	anim.masterGroup["axis"] = spawnstruct();
	anim.masterGroup["axis"].sightTime = 0;
	anim.masterGroup["allies"] = spawnstruct();
	anim.masterGroup["allies"].sightTime = 0;
	anim.scriptSquadGroup = [];

	anim.combatRunAnim[0] = %combat_run_fast_3;
	anim.combatRunAnim[1] = %combatrun_forward_1;

	initMoveStartStopTransitions();
	animscripts\dog_init::initDogAnimations();

	thread setupHats();
	anim.lastUpwardsDeathTime = 0;
	anim.backpedalRangeSq = 60*60;
	anim.proneRangeSq = 512*512;
	anim.dodgeRangeSq = 300*300;			// Guys only dodge when inside this range.
	anim.maxShuffleDistance = 20;
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
	
	
	// scripted mode uses a special function. Faster to use a function pointer based on script than use an if statement in a popular loop.
	anim.fire_notetrack_functions = [];
	anim.fire_notetrack_functions[ "scripted" ] = animscripts\shared::fire_straight;
	anim.fire_notetrack_functions[ "cover_right" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "cover_left" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "cover_crouch" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "cover_stand" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "move" ] = animscripts\shared::shootNotetrack;
	

	
	/#
	if (getdvar("debug_delta") == "")
		setdvar("debug_delta", "off");
	#/
	if ( !isdefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}

	
	maps\_gameskill::setSkill();
	level.painAI = undefined;
	
	
	animscripts\SetPoseMovement::InitPoseMovementFunctions();
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
	
//	anim.set_array_exposed["stand"] = animscripts\exposed_modern::set_animarray_standing;
//	anim.set_array_exposed["crouch"] = animscripts\exposed_modern::set_animarray_standing;
	
	// probabilities of burst fire shots
	anim.burstFireNumShots = array( 1, 2,2,2, 3,3,3,3, 4,4, 5 );
	anim.semiFireNumShots = array( 1, 2,2, 3,3, 4,4,4,4, 5,5,5 );
	anim.autoFireNumShots = array( 10, 30 );
	
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
	
	anim.coverCrouchLeanPitch = -55;
	
	level.player thread watchReloading();
}

init_mg_anims()
{
	level.mg_animmg = [];
	level.mg_animmg[ "pain" ] = %standMG42gunner_pain;

	level.mg_animmg[ "bipod_stand_setup" ] = %mg42_sandbag_setup;
	level.mg_animmg[ "bipod_prone_setup" ] = %mg42_prone_setup;
}


beginGrenadeTracking()
{
	self endon ( "death" );
	
	self waittill ( "grenade_fire", grenade, weaponName );
	grenade thread grenade_earthQuake();
}


endOnDeath()
{
	self waittill( "death" );
	waittillframeend;
	self notify ( "end_explode" );
}


grenade_earthQuake()
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	earthquake( 0.3, 0.5, position, 400 );
}
