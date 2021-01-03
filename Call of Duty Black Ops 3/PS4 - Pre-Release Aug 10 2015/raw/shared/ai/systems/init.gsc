#using scripts\shared\gameskill_shared;
#using scripts\shared\name_shared;
#using scripts\shared\util_shared;
#using scripts\shared\ai\systems\debug;
#using scripts\shared\ai\systems\shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\weaponList;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                  	                             	  	                                      


#using_animtree("generic");

//--------------------------------------------------------------------------------
// Weapon Initialization
//--------------------------------------------------------------------------------
function initWeapon( weapon )
{
	self.weaponInfo[weapon] = SpawnStruct();
	
	self.weaponInfo[weapon].position = "none";
	self.weaponInfo[weapon].hasClip = true;

	if ( IsDefined( weapon.ClipModel ) )
		self.weaponInfo[weapon].useClip = true;
	else
		self.weaponInfo[weapon].useClip = false;
}

//--------------------------------------------------------------------------------
// Main
//--------------------------------------------------------------------------------
function main()
{
	self.a = SpawnStruct();
	
	// Init weapons to "none"
	// This is done here for now, but might be better to
	// just have the converter set the empty weapon slots to "none" instead of ""
	if ( self.weapon == level.weaponNone )
		self AiUtility::setCurrentWeapon( level.weaponNone );

	// primary weapon
	self AiUtility::setPrimaryWeapon(self.weapon);

	// secondary weapon
	if ( self.secondaryweapon == level.weaponNone )
		self AiUtility::setSecondaryWeapon( level.weaponNone );

	self AiUtility::setSecondaryWeapon( self.secondaryweapon );	
	self AiUtility::setCurrentWeapon(self.primaryweapon);

	self.initial_primaryweapon = self.primaryweapon;
	self.initial_secondaryweapon = self.secondaryweapon;
	
	self initWeapon( self.primaryweapon );
	self initWeapon( self.secondaryweapon );
	self initWeapon( self.sidearm );

	self.weapon_positions = [];
	self.weapon_positions[self.weapon_positions.size] = "left";
	self.weapon_positions[self.weapon_positions.size] = "right";
	self.weapon_positions[self.weapon_positions.size] = "chest";
	self.weapon_positions[self.weapon_positions.size] = "back";

	for (i = 0; i < self.weapon_positions.size; i++)
	{
		self.a.weaponPos[self.weapon_positions[i]] = level.weaponNone;
	}

	self.lastWeapon = self.weapon;
		
	self thread beginGrenadeTracking();
	self thread globalGrenadeTracking();
	
	firstInit();
		
	// AI_TODO - Proper ammo tracking for rocketlauncher AI's
	self.a.rockets = 3;
	self.a.rocketVisible = true;
	
	// Set initial states for poses
	self.a.pose = "stand";
	self.a.prevPose = self.a.pose;
	self.a.movement = "stop";
	self.a.special = "none";
	self.a.gunHand = "none";	// Initialize so that PutGunInHand works properly.
	
	shared::placeWeaponOn( self.primaryweapon, "right" );
	if ( isdefined( self.secondaryweaponclass ) && self.secondaryweaponclass != "none" && self.secondaryweaponclass != "pistol" )
		shared::placeWeaponOn( self.secondaryweapon, "back");
		
	self.a.combatEndTime = GetTime();
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
	
	self.a.postScriptFunc = undefined;
	
	// use the GDT settings to start with
	self.baseAccuracy = self.accuracy;

	// set default accuracy mod
	if( !isdefined(self.script_accuracy) )
		self.script_accuracy = 1;
	
	// scale baseAccuracy based on number of coop players
	if( self.team == "axis" || self.team == "team3" )
		self thread gameskill::axisAccuracyControl();
	else if (self.team == "allies")
		self thread gameskill::alliesAccuracyControl();

	self.a.missTime = 0;
	self.bulletsInClip = self.weapon.clipSize;

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
	
	self.reacquire_state = 0;
		
	self thread setNameAndRank();	
}

function setNameAndRank()
{
	self endon ( "death" );

	self name::get();
}

function DoNothing()
{
}

function set_anim_playback_rate()
{
	self.animplaybackrate = 0.9 + RandomFloat( 0.2 );
	self.moveplaybackrate = 1; 
}

function trackVelocity()
{
	self endon ("death");

	for (;;)
	{
		self.oldOrigin = self.origin;
		wait (0.2);
	}
}

/#
function checkApproachAngles( transTypes )
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
			{
				idealAdd = 90;
			}
			else if ( trans == "right" || trans == "right_crouch" )
			{
				idealAdd = -90;
			}

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

function getExitSplitTime( approachType, dir )
{
	return anim.coverExitSplit[ approachType ][ dir ];
}

function getTransSplitTime( approachType, dir )
{
	return anim.coverTransSplit[ approachType ][ dir ];
}

function firstInit()
{
	// Initialization that should happen once per level
	if ( IsDefined(anim.NotFirstTime) ) // Use this to trigger the first init
	{
		return;
	}
	
	anim.NotFirstTime = true;
		
	name::setup();
	
	anim.grenadeTimers["player_frag_grenade_sp"] = randomIntRange( 1000, 20000 );
	anim.grenadeTimers["player_flash_grenade_sp"] = randomIntRange( 1000, 20000 );
	anim.grenadeTimers["player_double_grenade"] = randomIntRange( 10000, 60000 );
	anim.grenadeTimers["AI_frag_grenade_sp"] = randomIntRange( 0, 20000 );
	anim.grenadeTimers["AI_flash_grenade_sp"] = randomIntRange( 0, 20000 );

	anim.numGrenadesInProgressTowardsPlayer = 0;
	anim.lastGrenadeLandedNearPlayerTime = -1000000;
	anim.lastFragGrenadeToPlayerStart    = -1000000;
	thread setNextPlayerGrenadeTime();
	
	if ( !isdefined( level.flag ) )
	{
		level.flag = [];
	}

	level.painAI = undefined;
	anim.coverCrouchLeanPitch = -55;
}


function onPlayerConnect()
{
	player = self;
	
	firstInit();
	
	player.invul = false;
}

function setNextPlayerGrenadeTime()
{
	waittillframeend;
	// might not be defined if load::main() wasn't called
	if ( isdefined( anim.playerGrenadeRangeTime ) )
	{
		maxTime = int( anim.playerGrenadeRangeTime * 0.7 );
		if ( maxTime < 1 )
		{
			maxTime = 1;
		}

		anim.grenadeTimers["player_frag_grenade_sp"] = randomIntRange( 0, maxTime );
		anim.grenadeTimers["player_flash_grenade_sp"] = randomIntRange( 0, maxTime );
	}
	
	if ( isdefined( anim.playerDoubleGrenadeTime ) )
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

function AddToMissiles(grenade)
{
	if(!isdefined(level.missileEntities))level.missileEntities=[];
	if ( !isdefined( level.missileEntities ) ) level.missileEntities = []; else if ( !IsArray( level.missileEntities ) ) level.missileEntities = array( level.missileEntities ); level.missileEntities[level.missileEntities.size]=grenade;;
	
	while ( IsDefined(grenade) )
	{
		{wait(.05);};
	}
	
	ArrayRemoveValue(level.missileEntities,grenade);
}


function globalGrenadeTracking()
{
	if(!isdefined(level.missileEntities))level.missileEntities=[];
	
	self endon ( "death" );
	self thread globalGrenadeLauncherTracking();
	self thread globalMissileTracking();
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapon );
		grenade.owner=self;
		grenade.weapon = weapon;
		level thread AddToMissiles(grenade); 
	}
}

function globalGrenadeLauncherTracking()
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self waittill ( "grenade_launcher_fire", grenade, weapon );
		grenade.owner=self;
		grenade.weapon = weapon;
		level thread AddToMissiles(grenade); 
	}
}

function globalMissileTracking()
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self waittill ( "missile_fire", grenade, weapon );
		grenade.owner=self;
		grenade.weapon = weapon;
		level thread AddToMissiles(grenade); 
	}
}

function beginGrenadeTracking()
{
	self endon ( "death" );
	
	for ( ;; )
	{
		self waittill ( "grenade_fire", grenade, weapon );
		grenade thread grenade_earthQuake();
	}
}

function endOnDeath()
{
	self waittill( "death" );
	waittillframeend;
	self notify ( "end_explode" );
}

function grenade_earthQuake() //self == grenade
{
	self thread endOnDeath();
	self endon( "end_explode" );
	self waittill( "explode", position );
	PlayRumbleOnPosition( "grenade_rumble", position );
	earthquake( 0.3, 0.5, position, 400 );
}


//--------------------------------------------------------------------------------
// end script
//--------------------------------------------------------------------------------

function end_script()
{
}
