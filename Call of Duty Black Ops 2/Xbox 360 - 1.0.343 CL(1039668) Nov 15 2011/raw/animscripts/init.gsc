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
//		[[anim.assert(condition, message_string);
// If condition evaluates to 0, the assert fires, prints message_string and stops the server. Since 
// I don't have stack traces of any kind, the message string needs to say from where the assert was 
// called.

#include animscripts\utility;
#include maps\_utility;
#include animscripts\combat_utility;
#include common_scripts\utility;
#include animscripts\Debug;
#include animscripts\anims;

#insert raw\common_scripts\utility.gsh;

#using_animtree ("generic_human");

//--------------------------------------------------------------------------------
// Weapon Initialization
//--------------------------------------------------------------------------------
initWeapon( weapon )
{
	self.weaponInfo[weapon] = SpawnStruct();
	
	self.weaponInfo[weapon].position = "none";
	self.weaponInfo[weapon].hasClip = true;

	if ( getWeaponClipModel( weapon ) != "" )
		self.weaponInfo[weapon].useClip = true;
	else
		self.weaponInfo[weapon].useClip = false;
}

isWeaponInitialized( weapon )
{
	return IsDefined( self.weaponInfo[ weapon ] );
}

//--------------------------------------------------------------------------------
// Main
//--------------------------------------------------------------------------------
main()
{
	self.a = SpawnStruct();
//	self.a.laserOn = false;

	// Init weapons to "none"
	// This is done here for now, but might be better to
	// just have the converter set the empty weapon slots to "none" instead of ""
	if (self.weapon == "")
		self.weapon = "none";

	// primary weapon
	self.primaryweapon = self.weapon;

	// secondary weapon
	if (self.secondaryweapon == "")
		self.secondaryweapon = "none";

	self.primaryweapon = animscripts\assign_weapon::assign_random_weapon();
	self.secondaryweapon = animscripts\random_weapon::get_weapon_name_with_attachments(self.secondaryweapon);
	
	self thread animscripts\assign_weapon::set_random_camo_drop();
	
	self.weapon = self.primaryweapon;

	self.looking_at_entity = false;

	self.initial_primaryweapon = self.primaryweapon;
	self.initial_secondaryweapon = self.secondaryweapon;
	
	self initWeapon( self.primaryweapon);
	self initWeapon( self.secondaryweapon );
	self initWeapon( self.sidearm );

	self.weapon_positions = [];
	self.weapon_positions[self.weapon_positions.size] = "left";
	self.weapon_positions[self.weapon_positions.size] = "right";
	self.weapon_positions[self.weapon_positions.size] = "chest";
	self.weapon_positions[self.weapon_positions.size] = "back";

	for (i = 0; i < self.weapon_positions.size; i++)
	{
		self.a.weaponPos[self.weapon_positions[i]] = "none";
	}

	self.lastWeapon = self.weapon;
	self.root_anim = %root;
	
	self thread beginGrenadeTracking();
	
	firstInit();

	hasRocketLauncher = usingRocketLauncher();
	self.a.neverLean = hasRocketLauncher;

	self.animType = setAnimType();
	self.lastAnimType = self.animType;
	self animscripts\anims::clearAnimCache();
	
	if( IsDefined( level.setup_anim_array_callback ) )
	{
		[[level.setup_anim_array_callback]]( self.animType );
	}

	// try setting the heat exposed set
	self.heat = false;
		
	self.isSniper = isSniperRifle( self.primaryweapon );
	
	// TODO: proper ammo tracking
	self.bulletsInClip = 0;
	self.a.rockets = 3;
	self.a.rocketVisible = true;

	// LDS - For if you don't want a panzerschreck guys to switch weapons based on range
	self.a.allow_weapon_switch				= true;
	self.a.weapon_switch_ASAP				= false;
	self.a.weapon_switch_time				= GetTime();
	self.a.weapon_switch_for_distance_time	= -1;

	self.a.nextAllowedSwitchSidesTime		= GetTime();
	self.a.lastSwitchSidesTime				= GetTime();

	self.a.allowEvasiveMovement				= true;
	
	self.a.allow_sideArm					= true;
	self.a.allow_shooting					= true;

	// used for turning at cover nodes
	self.turnToMatchNode = false;
		
	
	SetWeaponDist();
	

	// Set initial states for poses
	self.a.pose = "stand";
	self.a.prevPose = self.a.pose;
	self.a.movement = "stop";
	self.a.state = "stop";
	self.a.special = "none";
	self.a.gunHand = "none";	// Initialize so that PutGunInHand works properly.
	self.a.PrevPutGunInHandTime = -1;

	animscripts\shared::placeWeaponOn( self.primaryweapon, "right" );
	if ( weaponclass( self.secondaryweapon ) != "none" && weaponclass( self.secondaryweapon ) != "pistol" )
	{
		animscripts\shared::placeWeaponOn( self.secondaryweapon, "back");
	}
	
	self.a.combatEndTime = GetTime();
	self.a.script = "init";
	self.a.alertness = "casual"; // casual, alert, aiming
	self.a.lastEnemyTime = GetTime();
	self.a.forced_cover = "none";
	self.a.suppressingEnemy = false;
	self.a.desired_script = "none";
	self.a.current_script = "none";
	self.a.disableLongDeath = self.team != "axis" && self.team != "team3";
	self.a.lookangle = 0;
	self.a.painTime = 0;
	self.a.lastShootTime = 0;
	self.a.nextGrenadeTryTime = 0;

	// set up all the aiming stuff
	self.a.isAiming		= false;
	self.rightAimLimit	=  45;
	self.leftAimLimit	= -45;
	self.upAimLimit		=  45;
	self.downAimLimit	= -45;

	// setup the speed variables
	self.walk			= false;
	self.sprint			= false;

	self animscripts\shared::setAimingAnims( %aim_2, %aim_4, %aim_6, %aim_8 );
	self thread animscripts\shared::trackLoop();
	
	self call_overloaded_func( "animscripts\react", "init_react_timers" );

	self.a.magicReloadWhenReachEnemy = false;
	
//	if ( self.team == "allies" && !issubstr( self.classname, "russian" ) && weapons_with_ir( self.weapon ) )
//	{
//		// only select allies have IR laser and beacon
////		self.has_ir = true;	
//	}
	
	self.a.flamepainTime = 0;

	// MikeD (10/8/2007): Flamethrower shoot compatibility
	if( self usingGasWeapon() )
	{
		self.a.flamethrowerShootDelay_min = 250;
		self.a.flamethrowerShootDelay_max = 500;
		self.a.flamethrowerShootTime_min = 500;
		self.a.flamethrowerShootTime_max = 3000;
		self.a.flamethrowerShootSwitch = false;
		self.a.flamethrowerShootSwitchTimer = 0;
		self.disableArrivals = true;
		self.disableExits = true;
	}
	
	self.a.postScriptFunc = undefined;
	self.a.stance = "stand";
	//self.a.state = "idle";

//	self.a.ignoreSuppressionTime = 0;
	
	self thread deathNotify();

	// use the GDT settings to start with
	self.baseAccuracy = self.accuracy;

	// set default accuracy mod
	if( !IsDefined(self.script_accuracy) )
	{
		self.script_accuracy = 1;
	}
	
	// scale baseAccuracy based on number of coop players
	if( self.team == "axis" || self.team == "team3" )
		self thread maps\_gameskill::axisAccuracyControl();
	else if (self.team == "allies")
		self thread maps\_gameskill::alliesAccuracyControl();
		
	self.a.missTime = 0;
	
	self.a.yawTransition = "none";
	self.a.nodeath = false;
	self.a.missTime = 0;
	self.a.missTimeDebounce = 0;
	self.a.disablePain = false;
	self.a.disableReact = false;

	self.accuracyStationaryMod = 1;
	self.chatInitialized = false;
	self.sightPosTime = 0;
	self.sightPosLeft = true;
	self.preCombatRunEnabled = true;
	self.goodShootPosValid = false;
	self.needRecalculateGoodShootPos = true;

	self.a.grenadeFlee = call_overloaded_func( "animscripts\run", "GetRunAnim" );
	
	self.a.crouchpain = false; // for dying pain guys
	self.a.nextStandingHitDying = false;
	
	// Makes AI able to throw grenades at other AI.
	if (!IsDefined (self.script_forcegrenade))
	{
		self.script_forcegrenade = 0;
	}
		
/#
	self.a.lastDebugPrint = "";
#/
	self.a.StopCowering = ::DoNothing;
	
	SetupUniqueAnims();

//	thread testLife();

/#
	thread animscripts\debug::UpdateDebugInfo();
#/
	
	self animscripts\weaponList::RefillClip();	// Start with a full clip.

	// state tracking
	self.lastEnemySightTime = 0; // last time we saw our current enemy
	self.combatTime = 0; // how long we've been in/out of combat

	self.suppressed = false; // if we're currently suppressed
	self.suppressedTime = 0; // how long we've been in/out of suppression

	if ( self.team == "allies" )
		self.suppressionThreshold = 0.75;
	else
		self.suppressionThreshold = 0.5;
		
	// Random range makes the grenades less accurate and do less damage, but also makes it difficult to throw back.
	if ( self.team == "allies" )
		self.randomGrenadeRange = 0;
	else
		self.randomGrenadeRange = 128;
		    
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
	
	self.old = SpawnStruct();
	
	self.reacquire_state = 0;
		
	self thread setNameAndRank();
	
	self thread animscripts\squadManager::addToSquad(); // slooooow
	
	self.shouldConserveAmmoTime = 0;
	
	/#
	self thread printEyeOffsetFromNode();
	self thread showLikelyEnemyPathDir();
	#/
	
	self thread monitorFlash();
	self thread onDeath();
}

//
//weapons_with_ir( weapon )
//{
//	weapons[0] = "m4_grenadier";
//	weapons[1] = "m4_grunt";
//	weapons[2] = "m4_silencer";
//	weapons[3] = "m4m203";
//
//	if ( !IsDefined( weapon ) )
//		return false;
//
//	for( i = 0 ; i < weapons.size ; i ++ )
//	{
//		if ( issubstr( weapon, weapons[i] ) )
//			return true;
//	}
//	return false;
//}

/#
printEyeOffsetFromNode()
{
	self endon("death");

	while(1)
	{
		if ( GetDvarint( "scr_eyeoffset") == self getentnum() )
		{
			if ( IsDefined( self.coverNode ) )
			{
				offset = self geteye() - self.coverNode.origin;
				forward = AnglesToForward(self.coverNode.angles);
				right = AnglesToRight(self.coverNode.angles);
				trueoffset = (vectordot(right, offset), vectordot(forward, offset), offset[2]);
				println( trueoffset );
			}
		}
		else
		{
			wait 2;
		}
			
		wait .1;
	}
}

showLikelyEnemyPathDir()
{
	self endon("death");

	if ( GetDvar( "scr_showlikelyenemypathdir") == "" )
	{
		SetDvar( "scr_showlikelyenemypathdir", "-1" );
	}

	while(1)
	{
		if ( GetDvarint( "scr_showlikelyenemypathdir") == self getentnum() )
		{
			yaw = self.angles[1];
			dir = self getAnglesToLikelyEnemyPath();
		
			if ( IsDefined( dir ) )
			{
				yaw = dir[1];
			}

			printpos = self.origin + (0,0,60) + AnglesToForward((0,yaw,0)) * 100;
			line( self.origin + (0,0,60), printpos );

			if ( IsDefined( dir ) )
			{
				Print3d( printpos, "likelyEnemyPathDir: " + yaw, (1,1,1), 1, 0.5 );
			}
			else
			{
				Print3d( printpos, "likelyEnemyPathDir: undefined", (1,1,1), 1, 0.5 );
			}
			
			wait .05;
		}
		else
		{
			wait 2;
		}
	}
}
#/

setNameAndRank()
{
	self endon ( "death" );

	if (!IsDefined (level.loadoutComplete))
	{
		level waittill ("loadout complete");
	}

	self maps\_names::get_name();
}

SetWeaponDist()
{
	if (AIHasPrimaryWeapon())
	{
		// get the min and max damage distance for the primary weapon
		primaryweapon_fightdist_min 	   = WeaponFightDist(self.primaryweapon);
		primaryweapon_fightdist_max 	   = WeaponMaxDist(self.primaryweapon);
		self.primaryweapon_fightdist_minSq = primaryweapon_fightdist_min * primaryweapon_fightdist_min;
		self.primaryweapon_fightdist_maxSq = primaryweapon_fightdist_max * primaryweapon_fightdist_max;
		
	}

	if (AIHasSecondaryWeapon())
	{
		// get the min and max damage distance for the seondary weapon
		secondaryweapon_fightdist_min        = WeaponFightDist(self.secondaryweapon);
		secondaryweapon_fightdist_max        = WeaponMaxDist(self.secondaryweapon);
		self.secondaryweapon_fightdist_minSq = secondaryweapon_fightdist_min * secondaryweapon_fightdist_min;
		self.secondaryweapon_fightdist_maxSq = secondaryweapon_fightdist_max * secondaryweapon_fightdist_max;
	}
	
}

DoNothing()
{
}

SetupUniqueAnims()
{
	if ( !IsDefined( self.animplaybackrate ) || !IsDefined( self.moveplaybackrate ) )
	{
		set_anim_playback_rate();
	}
}

set_anim_playback_rate()
{
	self.animplaybackrate = 0.9 + RandomFloat( 0.2 );
	self.moveplaybackrate = 1; 
}


infiniteLoop(one, two, three, whatever)
{
	anim waittill("new exceptions");
}

// Changes the AI's aim based on how recently they saw their enemy
lastSightUpdater()
{
	self endon ("death");

	self.personalSightTime = -1;
	personalSightPos = self.origin;
	
	//const reacquireTime = 3000;
	thread trackVelocity();
	
	thread previewSightPos();
	thread previewAccuracy();

	lastEnemy = undefined;
	hasLastEnemySightPos = false;

	for (;;)
	{
		if (!IsDefined (self.squad))
		{
			wait (0.2);
			continue;
		}
		
		if (IsDefined (lastEnemy) && IsAlive (self.enemy) && lastEnemy != self.enemy)
		{
			personalSightPos = self.origin;
			self.personalSightTime = -1;
		}
		
		lastEnemy = self.enemy;
		
		/*
		if (IsDefined(self.squad.sightpos))
		{
			if (!IsDefined (lastGroupSightSpot))
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
		
	
		if (IsDefined (self.lastEnemySightPos) && IsAlive (self.enemy))
		{
			// If you have no personalSightPos or the enemy position has changed or
			// the enemy is near the last place you saw him, then refresh it
			if (distancesquared(self.enemy.origin, self.lastEnemySightPos) < (100*100) )
			{
				personalSightPos = self.lastEnemySightPos;
				self.personalSightTime = GetTime();

				hasLastEnemySightPos = true;
			}
			else if ( IsPlayer(self.enemy) )
			{
				hasLastEnemySightPos = false;
			}
		}
		else
		{
			hasLastEnemySightPos = false;
		}

//				if (newtime - personalSightTime > reacquireTime)
//					thread resetAccuracy();

		/*	
		if (!IsDefined (self.squad.sightpos))
		{
 			if (IsDefined (personalSightPos))
 			{
				self.squad.sightpos = personalSightPos;
				self.squad.sightTime = personalSightTime;
			}
			wait (0.05);
			continue;
		}
		*/

		/*
		if (self.personalSightTime > self.squad.sightTime && IsAlive (self.enemy))
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
		if (GetDebugDvar ("debug_lastsightpos") != "on")
		{
			wait (1);
			continue;
		}
		
		wait (0.05);

		if (!IsDefined(self.lastEnemySightPos))
		{
			continue;
		}

		Print3d (self.lastEnemySightPos, "X", (0.2,0.5,1.0), 1, 1.0);	// origin, text, RGB, alpha, scale
//		Print3d (getEnemySightPos(), "X " + self.squad.members.size, (0.2,0.5,1.0), 1, 1.0);	// origin, text, RGB, alpha, scale
	}
	#/
}

previewAccuracy()
{
	/#
	if (!IsDefined (level.offsetNum))
	{
		level.offsetNum = 0;
	}
		
//	offset = level.offsetNum;
	const offset = 1;
	level.offsetNum++;
	if (level.offsetNum > 5)
	{
		level.offsetNum = 1;
	}

	self endon ("death");

	for (;;)
	{
		if (GetDebugDvar("debug_accuracypreview") != "on")
		{
			wait (1);
			continue;
		}
		
		wait (0.05);
		Print3d (self.origin + (0,0,70 + 25*offset ), self.accuracy, (0.2,0.5,1.0), 1, 1.15);
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

// Cleans up scripts on death
deathNotify()
{
	self waittill( "death", other );
	self notify( anim.scriptChange );
}

testLife()
{
	for (;;)
	{
		if (!IsAlive(self))
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
	assert (IsAlive(self));
	for (;;)
	{
		assert (IsAlive(self), "This should never be hittable due to endon killanimscript. Make your peace and prepare to die.");
		if (IsAlive(self))
			wait (0.05);
	}
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
	transTypes[7] = "exposed_crouch";
	transTypes[8] = "pillar";
	transTypes[9] = "pillar_crouch";
	transTypes[10] = "stand_saw";
	transTypes[11] = "prone_saw";
	transTypes[12] = "crouch_saw";

	anim.approach_types = [];
	const standing = 0;
	const crouching = 1;
	
	anim.approach_types[ "Cover Left" ] = [];
	anim.approach_types[ "Cover Left" ][ standing ] = "left";
	anim.approach_types[ "Cover Left" ][ crouching ] = "left_crouch";
		
	anim.approach_types[ "Cover Right" ] = [];
	anim.approach_types[ "Cover Right" ][ standing ] = "right";
	anim.approach_types[ "Cover Right" ][ crouching ] = "right_crouch";
		
	anim.approach_types[ "Cover Crouch" ] = [];
	anim.approach_types[ "Cover Crouch" ][ standing ] = "crouch";
	anim.approach_types[ "Cover Crouch" ][ crouching ] = "crouch";
	anim.approach_types[ "Conceal Crouch" ] = anim.approach_types[ "Cover Crouch" ];
	anim.approach_types[ "Cover Crouch Window" ] = anim.approach_types[ "Cover Crouch" ];
	
	anim.approach_types[ "Cover Stand" ] = [];
	anim.approach_types[ "Cover Stand" ][ standing ] = "stand";
	anim.approach_types[ "Cover Stand" ][ crouching ] = "stand";
	anim.approach_types[ "Conceal Stand" ] = anim.approach_types[ "Cover Stand" ];
	
	anim.approach_types[ "Cover Prone" ] = [];
	anim.approach_types[ "Cover Prone" ][ standing ] = "exposed";
	anim.approach_types[ "Cover Prone" ][ crouching ] = "exposed";
	anim.approach_types[ "Conceal Prone" ] = anim.approach_types[ "Cover Prone" ];

	anim.approach_types[ "Cover Pillar" ] = [];
	anim.approach_types[ "Cover Pillar" ][ standing ] = "pillar";
	anim.approach_types[ "Cover Pillar" ][ crouching ] = "pillar_crouch";
	
	anim.approach_types[ "Path" ] = [];
	anim.approach_types[ "Path" ][ standing ] = "exposed";
	anim.approach_types[ "Path" ][ crouching ] = "exposed_crouch";
	anim.approach_types[ "Exposed" ] = [];
	anim.approach_types[ "Exposed" ][ standing ] = "exposed";
	anim.approach_types[ "Exposed" ][ crouching ] = "exposed_crouch";
	anim.approach_types[ "Guard"] = anim.approach_types[ "Path" ];
	anim.approach_types[ "Turret"] = anim.approach_types[ "Path" ];
	
	/#
	level thread call_overloaded_func( "animscripts\cover_arrival", "coverArrivalDebugTool" );
	#/
	
	/* ALEXP_TODO: figure out how to automate this
	for ( i = 7; i <= 8; i++ )
	{
		/#
		FindBestSplitTime( anim.coverTrans["left"       ][i], true , false, "anim.coverTransSplit[\"left\"]["+i+"]", "stand left arrival in dir " + i );
		FindBestSplitTime( anim.coverTrans["left_crouch"][i], true , false, "anim.coverTransSplit[\"left_crouch\"]["+i+"]", "crouch left arrival in dir " + i );
		FindBestSplitTime( anim.coverExit ["left"       ][i], false, false, "anim.coverExitSplit[\"left\"]["+i+"]", "stand left exit in dir " + i );
		FindBestSplitTime( anim.coverExit ["left_crouch"][i], false, false, "anim.coverExitSplit[\"left_crouch\"]["+i+"]", "crouch left exit in dir " + i );
		
		AssertIsValidLeftSplitDelta( DeltaRotate( anim.coverTransDist["left"][i], 180 - anim.coverTransAngles["left"][i] ), "stand left arrival in dir " + i );
		AssertIsValidLeftSplitDelta( DeltaRotate( anim.coverTransDist["left_crouch"][i], 180 - anim.coverTransAngles["left_crouch"][i] ), "crouch left arrival in dir " + i );
		AssertIsValidLeftSplitDelta( anim.coverExitDist["left"][i], "stand left exit in dir " + i );
		AssertIsValidLeftSplitDelta( anim.coverExitDist["left_crouch"][i], "crouch left exit in dir " + i );
		#/
	}

	for ( i = 8; i <= 9; i++ )
	{
		/#
		FindBestSplitTime( anim.coverTrans["right"       ][i], true , true, "anim.coverTransSplit[\"right\"]["+i+"]", "stand right arrival in dir " + i );
		FindBestSplitTime( anim.coverTrans["right_crouch"][i], true , true, "anim.coverTransSplit[\"right_crouch\"]["+i+"]", "crouch right arrival in dir " + i );
		FindBestSplitTime( anim.coverExit ["right"       ][i], false, true, "anim.coverExitSplit[\"right\"]["+i+"]", "stand right exit in dir " + i );
		FindBestSplitTime( anim.coverExit ["right_crouch"][i], false, true, "anim.coverExitSplit[\"right_crouch\"]["+i+"]", "crouch right exit in dir " + i );

		AssertIsValidRightSplitDelta( DeltaRotate( anim.coverTransDist["right"][i], 180 - anim.coverTransAngles["right"][i] ), "stand right arrival in dir " + i );
		AssertIsValidRightSplitDelta( DeltaRotate( anim.coverTransDist["right_crouch"][i], 180 - anim.coverTransAngles["right_crouch"][i] ), "crouch right arrival in dir " + i );
		AssertIsValidRightSplitDelta( anim.coverExitDist["right"][i], "stand right exit in dir " + i );
		AssertIsValidRightSplitDelta( anim.coverExitDist["right_crouch"][i], "crouch right exit in dir " + i );
		#/
	}
	*/

	/#
	//thread checkApproachAngles( transTypes );
	#/
}

/#
FindBestSplitTime( exitanim, isapproach, isright, arrayname, debugname )
{
	angleDelta = getAngleDelta( exitanim, 0, 1 );
	fullDelta = getMoveDelta( exitanim, 0, 1 );
	const numiter = 1000;
	
	bestsplit = -1;
	bestvalue = -100000000;
	bestdelta = (0,0,0);

	for ( i = 0; i < numiter; i++ )
	{
		splitTime = 1.0 * i / (numiter - 1);
		
		delta = getMoveDelta( exitanim, 0, splitTime );
		if ( isapproach )
		{
			delta = DeltaRotate( fullDelta - delta, 180 - angleDelta );
		}

		if ( isright )
		{
			delta = ( delta[0], 0 - delta[1], delta[2] );
		}
		
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
	//println("^0 ^2" + debugname + " has best split time at " + bestsplit + ", delta of " + bestdelta );
	println( "^0 ^2" + arrayname + " = " + bestsplit + "; // delta of " + bestdelta );
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
	{
		println( "^0 ^1" + debugname + " doesn't go out from the node far enough in the given split time (delta = " + delta + ")" );
	}
	
	// assert the delta doesn't go into the wall
	if ( delta[1] < 0 )
	{
		println( "^0 ^1" + debugname + " goes into the wall during the given split time (delta = " + delta + ")" );
	}
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
			{
				idealAdd = 90;
			}
			else if ( trans == "right" || trans == "right_crouch" )
			{
				idealAdd = -90;
			}
			
			if ( IsDefined( anim.coverTransAngles[ trans ][i] ) )
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
			{
				idealAdd = 90;
			}
			else if ( trans == "right" || trans == "right_crouch" )
			{
				idealAdd = -90;
			}

			if ( IsDefined( anim.coverExitAngles[ trans ][i] ) )
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
	
	/*exitAnim = anim.coverExit[ approachType ][ dir ];
	exitAlignTimes = getNotetrackTimes( exitAnim, "exit_align" );
	
	assert( exitAlignTimes.size == 1 );
	if ( exitAlignTimes.size == 0 )
		return .5;
	
	return exitAlignTimes[0];*/
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
	// Initialization that should happen once per level
	if ( IsDefined (anim.NotFirstTime) ) // Use this to trigger the first init
	{
		return;
	}
	
	anim.NotFirstTime = true;
	
	anim.useFacialAnims = false; // remove me when facial anims are fixed

	init_overloaded_funcs();

	if ( !IsDefined( anim.dog_health ) )
	{
		anim.dog_health = 1;
	}
		
	if ( !IsDefined( anim.dog_presstime ) )
	{
//		anim.dog_presstime = 350;
		anim.dog_presstime = 1000;
	}
		
	anim.dog_presstime = 1000;
	PrintLn("anim.dog_presstime = " + anim.dog_presstime);
		
	if ( !IsDefined( anim.dog_hits_before_kill ) )
	{
		anim.dog_hits_before_kill = 1;
	}
		
	/#
	if ( GetDvar( "scr_forceshotgun") == "on" )
	{
		precacheItem("winchester1200");
	}
	#/

	//level.player = getent("player","classname");
	//level.player.invul = false;

	level.nextGrenadeDrop = RandomInt(3);
	anim.defaultException = ::empty;
	
	/#
	if (GetDebugDvar("debug_noanimscripts") == "")
	{
		SetDvar("debug_noanimscripts", "off");
	}
	else if (GetDebugDvar("debug_noanimscripts") == "on")
	{
		anim.defaultException = animscripts\init::infiniteLoop;
	}

	if (GetDebugDvar("debug_grenadehand") == "")
	{
		SetDvar("debug_grenadehand", "off");
	}
		
	if (GetDebugDvar("anim_trace") == "")
	{
		SetDvar("anim_trace", "-1");
	}

	if (GetDebugDvar("anim_dotshow") == "")
	{
		SetDvar("anim_dotshow", "-1");
	}

	if (GetDebugDvar("anim_debug") == "")
	{
		SetDvar("anim_debug", "");
	}

	if (GetDebugDvar("debug_misstime") == "")
	{
		SetDvar("debug_misstime", "");
	}

	if (GetDvar( "modern") == "")
	{
		SetDvar("modern", "on");
	}
	#/
	
	anim.sniperRifles = [];
	anim.sniperRifles["dragunov_sp"] = 1;
	anim.sniperRifles["wa2000_sp"] = 1;
	anim.sniperRifles["l96a1_sp"] = 1;
	anim.sniperRifles["psg1_sp"] = 1;
	
	if ( GetDvar( "scr_ai_auto_fire_rate") == "" )
	{
		SetDvar("scr_ai_auto_fire_rate", "1.0");
	}
		
	SetDvar( "scr_expDeathMayMoveCheck", "on" );
	
	maps\_names::setup_names();

	// Global constants
    anim.CoverStandShots = 0;
    anim.lastSideStepAnim = 0;
    anim.meleeRange = 64;
	anim.meleeRangeSq = anim.meleeRange * anim.meleeRange;
	anim.standRangeSq = 512*512;
	anim.chargeRangeSq = 200*200;
	anim.chargeLongRangeSq = 512*512;
	anim.aiVsAiMeleeRangeSq = 400*400;
	
	anim.animFlagNameIndex = 0;

	if( IsDefined( level.setup_anims_callback ) )
	{
		[[level.setup_anims_callback]]();
	}

	initMoveStartStopTransitions();
	
	// AI react behavior
	call_overloaded_func( "animscripts\react", "react_init" );

	thread setupHats();
	
	anim.lastUpwardsDeathTime = 0;
	anim.backpedalRangeSq = 60*60;
	anim.proneRangeSq = 512*512;
	anim.dodgeRangeSq = 300*300;			// Guys only dodge when inside this range.
	anim.blindAccuracyMult["allies"] = 0.5;
	anim.blindAccuracyMult["axis"] = 0.1;
	anim.blindAccuracyMult["team3"] = 0.1;
	anim.runAccuracyMult = 0.5;
	anim.combatMemoryTimeConst = 10000;
	anim.combatMemoryTimeRand = 6000;
	anim.scriptChange = "script_change";

	// rambo behavior 
	anim.ramboAccuracyMult = 1.0;
	anim.ramboSwitchAngle  = 30; // angle to enemy to switch to 45 degree rambo animations 
	
	anim.grenadeTimers["player_frag_grenade_sp"] = randomIntRange( 1000, 20000 );
	anim.grenadeTimers["player_flash_grenade_sp"] = randomIntRange( 1000, 20000 );
	anim.grenadeTimers["player_double_grenade"] = randomIntRange( 10000, 60000 );
	anim.grenadeTimers["AI_frag_grenade_sp"] = randomIntRange( 0, 20000 );
	anim.grenadeTimers["AI_flash_grenade_sp"] = randomIntRange( 0, 20000 );

	anim.numGrenadesInProgressTowardsPlayer = 0;
	anim.lastGrenadeLandedNearPlayerTime = -1000000;
	anim.lastFragGrenadeToPlayerStart    = -1000000;
	thread setNextPlayerGrenadeTime();

	/#
	thread animscripts\combat_utility::grenadeTimerDebug();
	#/
		
	setEnv("none");

	anim.noWeaponToss = false;
	anim.corner_straight_yaw_limit = 36;

	// scripted mode uses a special function. Faster to use a function pointer based on script than use an if statement in a popular loop.
	anim.fire_notetrack_functions = [];
	anim.fire_notetrack_functions[ "scripted" ] = animscripts\shared::fire_straight;
	anim.fire_notetrack_functions[ "cover_right" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "cover_left" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "cover_crouch" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "cover_stand" ] = animscripts\shared::shootNotetrack;
	anim.fire_notetrack_functions[ "move" ] = animscripts\shared::shootNotetrack;
	
	anim.shootEnemyWrapper_func = ::shootEnemyWrapper_normal;
	
	// MikeD (10/8/2007): Flamethrower shoot function
	anim.shootFlameThrowerWrapper_func = ::shootFlameThrowerWrapper_normal;
	
	// string based array for notetracks
	anim.notetracks = [];
	animscripts\shared::registerNoteTracks();

	if ( !IsDefined( level.flag ) )
	{
		level.flag = [];
		level.flags_lock = [];
	}

	maps\_gameskill::setSkill();
	level.painAI = undefined;
	
	animscripts\SetPoseMovement::InitPoseMovementFunctions();
	animscripts\face::InitLevelFace();
	
//	anim.set_array_exposed["stand"] = animscripts\exposed_modern::set_animarray_standing;
//	anim.set_array_exposed["crouch"] = animscripts\exposed_modern::set_animarray_standing;
	
	// probabilities of burst fire shots

// MikeD (1/27/2008): Adjusting burstFireNumShots
//	anim.burstFireNumShots =     array( 1, 2,2,2, 3,3,3,3, 4,4,     5 );
	anim.burstFireNumShots =     array( 1, 2,2,2, 3,3,3,   4,4,     5,5,5,5 );
	anim.fastBurstFireNumShots = array(    2,     3,3,3,   4,4,4,   5,5,5,5,5 );
	anim.semiFireNumShots =      array( 1, 2,2,   3,3,     4,4,4,4, 5,5 );
	
	anim.startSuppressionDelay = 1.4;
	anim.maymoveCheckEnabled = true; // corner_axis doesnt do the check if this is false, for credits

	anim.badPlaces = []; // queue for animscript badplaces
	anim.badPlaceInt = 0; // assigns unique names to animscript badplaces since we cant save a badplace as an entity

	animscripts\squadmanager::init_squadManager();

	initWindowTraverse();
		
	level thread call_overloaded_func( "animscripts\cqb", "setupCQBPointsOfInterest" );
	
	anim.coverCrouchLeanPitch = -55;
	
	anim.lastCarExplosionTime = -100000;

	setupRandomTable();
	
	thread AITurnNotifies();
	
	// BJoyal (3/2/11) - Changing from the random_weapon system to the assign_weapon system
	anim animscripts\random_weapon::create_weapon_drop_array();

	// all globals for animscripts go here
	animscripts\combat::CombatGlobalsInit();
	animscripts\move::MoveGlobalsInit();
	animscripts\cover_behavior::CoverGlobalsInit();
	animscripts\pain::PainGloabalsInit();
	animscripts\death::DeathGlobalsInit();
}

init_overloaded_funcs()
{
	if ( GetDvar( "zombiemode" ) == "0" )
	{
		register_overloaded_func( "animscripts\react",			"init_react_timers",			animscripts\react::init_react_timers );
		register_overloaded_func( "animscripts\react",			"react_init",					animscripts\react::react_init );
		register_overloaded_func( "animscripts\run",			"GetRunAnim",					animscripts\run::GetRunAnim );
		register_overloaded_func( "animscripts\init",			"SetWeaponDist",				animscripts\init::SetWeaponDist );
		register_overloaded_func( "animscripts\cqb",			"setupCQBPointsOfInterest",		animscripts\cqb::setupCQBPointsOfInterest );
		register_overloaded_func( "animscripts\anims_table",	"try_heat",						animscripts\anims_table::try_heat );

		register_overloaded_func( "animscripts\anims_table",	"setup_heat_anim_array",		animscripts\anims_table::setup_heat_anim_array );
		register_overloaded_func( "animscripts\anims_table",	"reset_heat_anim_array",		animscripts\anims_table::reset_heat_anim_array );

		register_overloaded_func( "animscripts\anims_table",	"setup_cqb_anim_array",		    animscripts\anims_table::setup_cqb_anim_array );
		register_overloaded_func( "animscripts\anims_table",	"reset_cqb_anim_array",		    animscripts\anims_table::reset_cqb_anim_array );

		/#register_overloaded_func( "animscripts\cover_arrival", "coverArrivalDebugTool", animscripts\cover_arrival::coverArrivalDebugTool );#/
	}
}


balcony_init()
{
	anim.balcony_node_types = [];
	anim.balcony_node_types["Cover Stand"]			= 1;
	anim.balcony_node_types["Cover Crouch"]			= 1;
	anim.balcony_node_types["Cover Crouch Window"]	= 1;
	anim.balcony_node_types["Conceal Stand"]		= 1;
	anim.balcony_node_types["Conceal Crouch"]		= 1;
	anim.balcony_node_types["Guard"]				= 1;
	anim.balcony_node_types["Exposed"]				= 1;

	anim.balcony_nodes = [];

	all_nodes = GetAllNodes();
	for (i = 0; i < all_nodes.size; i++)
	{
		node = all_nodes[i];
		if (isBalconyNode(node))
		{
			ARRAY_ADD(anim.balcony_nodes, node);
		}
	}
}

onPlayerConnect()
{
	player = self;
	
	// make sure the init has been called
	firstInit();

	player.invul = false;
	
	println("*************************************init::onPlayerConnect");
	player thread animscripts\combat_utility::player_init();

	player thread animscripts\combat_utility::watchReloading();
	player thread animscripts\squadManager::addPlayerToSquad();
}

AITurnNotifies()
{
	numTurnsThisFrame = 0;
	const maxAIPerFrame = 3;
	while(1)
	{
		ai = GetAIArray();
		if ( ai.size == 0 )
		{
			wait .05;
			numTurnsThisFrame = 0;
			continue;
		}
		for ( i = 0; i < ai.size; i++ )
		{
			if ( !IsDefined( ai[i] ) )
			{
				continue;
			}

			ai[i] notify("do_slow_things");
			numTurnsThisFrame++;
			if ( numTurnsThisFrame == maxAIPerFrame )
			{
				wait .05;
				numTurnsThisFrame = 0;
			}
		}
	}
}

setNextPlayerGrenadeTime()
{
	waittillframeend;
	// might not be defined if maps\_load::main() wasn't called
	if ( IsDefined( anim.playerGrenadeRangeTime ) )
	{
		maxTime = int( anim.playerGrenadeRangeTime * 0.7 );
		if ( maxTime < 1 )
		{
			maxTime = 1;
		}

		anim.grenadeTimers["player_frag_grenade_sp"] = randomIntRange( 0, maxTime );
		anim.grenadeTimers["player_flash_grenade_sp"] = randomIntRange( 0, maxTime );
	}
	
	if ( IsDefined( anim.playerDoubleGrenadeTime ) )
	{
		maxTime = int( anim.playerDoubleGrenadeTime );
		minTime = int( maxTime / 2 );
		if ( maxTime <= minTime )
		{
			maxTime = minTime + 1;
		}

		anim.grenadeTimers["player_double_grenade"] = randomIntRange( minTime, maxTime );
	}
}

beginGrenadeTracking()
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weaponName );
		grenade thread grenade_earthQuake();
	}
}

setupRandomTable()
{
	// 60 is chosen because it is divisible by 1,2,3,4,5, and 6,
	// and it's also high enough to get some good randomness over different seed values
	anim.randomIntTableSize = 60;
	
	// anim.randomIntTable is a permutation of integers 0 through anim.randomIntTableSize - 1
	anim.randomIntTable = [];
	for ( i = 0; i < anim.randomIntTableSize; i++ )
	{
		anim.randomIntTable[i] = i;
	}
	
	for ( i = 0; i < anim.randomIntTableSize; i++ )
	{
		switchwith = RandomInt( anim.randomIntTableSize );
		temp = anim.randomIntTable[i];
		anim.randomIntTable[i] = anim.randomIntTable[switchwith];
		anim.randomIntTable[switchwith] = temp;
	}
}

endOnDeath()
{
	self waittill( "death" );
	waittillframeend;
	self notify ( "end_explode" );
}

grenade_earthQuake() //self == grenade
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	earthquake( 0.3, 0.5, position, 400 );
}

onDeath()
{
	self waittill("death");
	if ( !IsDefined( self ) )
	{
		// we were deleted and we're not running the death script.
		// still safe to access our variables as a removed entity though:
		if ( IsDefined( self.a.usingTurret ) )
		{
			self.a.usingTurret delete();
		}
	}
}

setAnimType()
{
	animType	= "default";

	classname	= ToLower( self.classname );
	tokens		= StrTok( classname, "_" );

	foreach( token in tokens )
	{
		switch( token )
		{
			case "civilian":	
			case "barnes":
			case "woods":
			case "reznov":
			case "vc":
			case "spetsnaz":
			case "digbat":
				animType = token;
				return animType;
			
			case "kristina":
				animType = "female";
				return animType;
		}
	}

	return animType;
}


// Build the array of weapons that the AI can drop based on it's current weapon
create_weapon_drop_array() //self == global anim object
{
	//-- All of the non-level-specific weapons
	primary_weapons = array( 	"spectre", "uzi", "mp5k", "mac11", "skorpion", "kiparis", "mpl", "pm63", "ak74u", "aug",
														"galil", "enfield", "m14", "ak47", "famas", "commando", "g11", "m16", "fnfal",
														"m60", "stoner63", "hk21", "rpk",
														"asp", "cz75", "m1911", "makarov", "python",
														"psg1", "wa2000", "dragunov", "l96a1",
														"ithaca", "hs10", "spas", "rottweil71" );

	//-- all of the available attachments and alternate weapons														
	primary_weapon_attachments = [];
	primary_weapon_attachments["sites"] = array( "acog", "elbit", "ir", "reflex");
	primary_weapon_attachments["ammo"] = array( "extclip", "dualclip" );
	primary_weapon_attachments["barrel"] = array( "silencer" );
	primary_weapon_attachments["auto"] = array( "auto" );
	primary_weapon_alts = array( "ft", "gl", "mk" );
	
	_sp = "_sp"; //-- for adding to the weapon name
	
	anim.droppable_weapons = [];
	
	attachment_categories = array("sites", "ammo", "barrel", "auto");
	
	for(i = 0; i < primary_weapons.size; i++)
	{	
		base_weapon = primary_weapons[i] + _sp;
		anim.droppable_weapons[ base_weapon ] = [];
		
		for(l = 0; l < attachment_categories.size; l++ )
		{
			for(j = 0; j < primary_weapon_attachments[attachment_categories[l]].size; j++)
			{
				new_weapon = primary_weapons[i] + "_" + primary_weapon_attachments[attachment_categories[l]][j] + _sp;
				if(IsAssetLoaded("weapon", new_weapon))
				{
					anim.droppable_weapons[base_weapon][anim.droppable_weapons[base_weapon].size] = new_weapon;
				}
			}
		}
			
		for(j = 0; j < primary_weapon_alts.size; j++)
		{
			new_weapon = primary_weapon_alts[j] + "_" + primary_weapons[i] + _sp;
			if(IsAssetLoaded("weapon", new_weapon))
			{
				anim.droppable_weapons[base_weapon][anim.droppable_weapons[base_weapon].size] = new_weapon;
			}
		}
	}
}

//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

end_script()
{
}