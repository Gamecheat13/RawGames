
























#include animscripts\Utility;
#include maps\_utility;

#include common_scripts\Utility;
#using_animtree ("generic_human");

initWeapon( weapon, slot )
{
	self.weaponInfo[weapon] = spawnstruct();
	
	self.weaponInfo[weapon].position = "none";
	self.weaponInfo[weapon].hasClip = true;
	if ( getWeaponClipModel( weapon ) != "" )
		self.weaponInfo[weapon].useClip = true;
	else
		self.weaponInfo[weapon].useClip = false;
}

main()
{
	level.nextGrenadeDrop = randomint(3);
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
  	animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );












































































































































































































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

showLikelyEnemyPathDir()
{
	self endon("death");
	if ( getdvar("scr_showlikelyenemypathdir") == "" )
		setdvar( "scr_showlikelyenemypathdir", "-1" );
	while(1)
	{
		if ( getdvarint("scr_showlikelyenemypathdir") == self getentnum() )
		{
			yaw = self.angles[1];
			dir = self getAnglesToLikelyEnemyPath();
			if ( isdefined( dir ) )
				yaw = dir[1];
			printpos = self.origin + (0,0,60) + anglestoforward((0,yaw,0)) * 100;
			line( self.origin + (0,0,60), printpos );
			if ( isdefined( dir ) )
				print3d( printpos, "likelyEnemyPathDir: " + yaw, (1,1,1), 1, 0.5 );
			else
				print3d( printpos, "likelyEnemyPathDir: undefined", (1,1,1), 1, 0.5 );
			
			wait .05;
		}
		else
			wait 2;
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



}


DoNothing()
{
}


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
			print3d (textPos, line[i], color[i], 1, 0.75);	
		}
		wait 0.05;
	}
}





SetupUniqueAnims()
{
	if ( (self animscripts\utility::weaponAnims() == "pistol") || (self animscripts\utility::weaponAnims() == "none") )
	{
		self.a.combatrunanim = %combat_run_fast_pistol;
		self.a.crouchrunanim = %pistol_crouchrun_loop_forward_1;
	}
	else
	{
		
		
		switch ( self getentitynumber() % 3 )
		{
		case 0:
			self.a.combatrunanim = anim.combatRunAnim[0];
			
			if ( self getentitynumber() % 9 < 6 )
				self.a.crouchrunanim = %crouchrun_loop_forward_2; 
			else
				self.a.crouchrunanim = %crouchrun_loop_forward_2; 
			break;
		case 1:
			self.a.combatrunanim = anim.combatRunAnim[0];
			
			
			if ( self getentitynumber() % 9 < 3 )
				self.a.crouchrunanim = %crouchrun_loop_forward_2; 
			else
				self.a.crouchrunanim = %crouchrun_loop_forward_2;
			break;
		case 2:
			self.a.combatrunanim = anim.combatRunAnim[0];
			self.a.crouchrunanim = %crouchrun_loop_forward_2; 
			break;
		}
	}
	
	if ( !isDefined( self.animplaybackrate ) )
	{
		set_anim_playback_rate();
	}
}

set_anim_playback_rate()
{
	self.animplaybackrate = 0.9 + randomfloat( 0.2 );
}


infiniteLoop(one, two, three, whatever)
{
	anim waittill("new exceptions");
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
			
				
			personalSightPos = self.origin;
			self.personalSightTime = -1;
		}
		
		lastEnemy = self.enemy;
		
		
		
	
		if (isdefined (self.lastEnemySightPos) && isalive (self.enemy))
		{
			
			
			if (distance(self.enemy.origin, self.lastEnemySightPos) < 100)
			{
				personalSightPos = self.lastEnemySightPos;
				self.personalSightTime = gettime();

				
				hasLastEnemySightPos = true;
			}
			else
			if (self.enemy == level.player)
			{
				
				hasLastEnemySightPos = false;
			}
		}
		else
			hasLastEnemySightPos = false;




		

		
		
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

		print3d (self.lastEnemySightPos, "X", (0.2,0.5,1.0), 1, 1.0);	

		
	}
	#/
}

previewAccuracy()
{
	/#
	if (!isdefined (level.offsetNum))
		level.offsetNum = 0;
		

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
			
	}
	#/
}

trackVelocity()
{
	self endon ("death");

	for (;;)
	{

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



deathNotify()
{
	self waittill ("death", other);
	if (isdefined(other))
	{
		
		if (other == level.player)
			setdvar("autodifficulty_frac", getdvarint("autodifficulty_frac") + 2);
	}
	
	
	self notify (anim.scriptChange);
}


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




















































}

coverLeftTest()
{




















































}


showAnim(animname)
{
	wait (0.05);
	self clearanim(%body, 0);
	self animMode ( "gravity" ); 
	self.keepClaimedNode = true;
	self setflaggedanim("finished", animname, 1, 0, 1);
	self waittillmatch ("finished", "end");
}


setupHats()
{












































































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
	
	
	
	if ( delta[0] < 32 )
		println( "^0 ^1" + debugname + " doesn't go out from the node far enough in the given split time (delta = " + delta + ")" );
	
	
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
			
			if ( isdefined( anim.coverTransAngles[ trans ][i] ) )
			{
				correctAngle = AngleClamp180( idealTransAngles[i] + idealAdd );
				actualAngle = AngleClamp180( anim.coverTransAngles[ trans ][i] );
				if ( AbsAngleClamp180( actualAngle - correctAngle ) > 7 )
				{
					println( "^1Cover approach animation has bad yaw delta: anim.coverTrans[\"" + trans + "\"][" + i + "]; is ^2" + actualAngle + "^1, should be closer to ^2" + correctAngle + "^1." );
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

			if ( isdefined( anim.coverExitAngles[ trans ][i] ) )
			{
				correctAngle = AngleClamp180( -1 * (idealTransAngles[i] + idealAdd + 180) );
				actualAngle = AngleClamp180( anim.coverExitAngles[ trans ][i] );
				if ( AbsAngleClamp180( actualAngle - correctAngle ) > 7 )
				{
					println( "^1Cover exit animation has bad yaw delta: anim.coverTrans[\"" + trans + "\"][" + i + "]; is ^2" + actualAngle + "^1, should be closer to ^2" + correctAngle + "^1." );
				}
			}
		}
	}
}
#/

getExitSplitTime( approachType, dir )
{
	return anim.coverExitSplit[ approachType ][ dir ];
	
	
}

getTransSplitTime( approachType, dir )
{
	return anim.coverTransSplit[ approachType ][ dir ];
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





























































































































































































}

setNextPlayerGrenadeTime()
{
	waittillframeend;
	
	if ( isdefined( anim.playerGrenadeRangeTime ) )
	{
		maxTime = int(anim.playerGrenadeRangeTime * 0.7);
		if ( maxTime < 1 )
			maxTime = 1;
		anim.nextPlayerGrenadeTime = randomIntRange( 0, maxTime );
	}
	else
	{
		anim.nextPlayerGrenadeTime = randomIntRange( 0, 20000 );
	}
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
