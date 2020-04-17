// _unlock_mechanisms.gsc
// handles unlock sequences for doors and other locked objects

#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

main()
{
	if ( getdvar("ui_lockpick_ignoretags") == "" )
		setDvar("ui_lockpick_ignoretags", false);
}

init_electronic(locked)
{
	if (!IsDefined(locked))
	{
		locked = true;
	}

	if (locked)
	{
		self red_light();
	}
	else
	{
		self green_light();
	}
}

unlock_electronic(node)
{
	if (GetDVarInt("bypass_lockhacks") == 1)
	{
		return true;
	}
	
	check_for_existing_lockpicks();
				
	if(!isDefined(self.lockname) || self.lockname == "none")
	    return false;

	self thread elecLockpickActivated(node);

	self waittill("lockpick_done");
	return level.player.lockSuccess;	
}

unlock_mechanical()
{
	self mechLockpickActivated();
	self waittill( "lockpick_done" );
	return level.player.lockSuccess;
}

///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////
//
// Ported from AR's phone stuff
//
///////////////////////////////////////////
///////////////////////////////////////////
///////////////////////////////////////////	

// self is whatever entity you want to attach a lock to. 
// make sure it has a member called "lockname" which will specify 
// which lock to attach - see the definition of InitLockFromString
// for currently available locknames.

mechLockpickActivated()
{
	check_for_existing_lockpicks();
	if(!isDefined(self.lockname) || self.lockname == "none")
	    return;

	mltriggers = getEntArray( "trigger_radius", "classname" ); //"mechlockpick", "targetname" );
	//mltriggers = getnodearray( "mechlockpick", "targetname" );	
	player = level.player;
	for( index = 0; index < mltriggers.size; index++ )
	{
	    //if(!isDefined(mltriggers[index].lockname) || mltriggers[index].lockname == "none")
	    //    continue;
	        
	    self InitLockFromString();  // this is expecting lockname  
	        
		//iprintln( mltriggers[index].targetname );
		//if( player isTouching( mltriggers[index] ) && (mltriggers[index].locktype == "mechanical") )
		if( player isTouching( mltriggers[index] ) && (self.locktype == "mechanical") )
		{
			//mltriggers[index] setHintString( "" );
			//script_origin = getEnt( mltriggers[index].target, "targetname" );
			//TEMP
			self.mltrigger = mltriggers[index];
			//script_origin = mltriggers[index];
			script_origin = level.player;
			if( isDefined( script_origin ) )
			{
				tempOrigin = spawn("script_origin", script_origin getorigin() );
				//tempOrigin.angles = ( script_origin.angles[0], script_origin.angles[1] - 90, script_origin.angles[2] );
				tempOrigin.angles = script_origin.angles;
				tempOrigin.targetname = "special_lockpick_origin";
				level.player.savedOrigin = level.player getOrigin();
				//level.player linkto( script_origin );
			}
			wait 0.25;
			
			//level.player maps\_gameobjects::_disableWeapon();
			
			//if( !isDefined(mltriggers[index].script_string) || (mltriggers[index].script_string == "none"))
			if(!isDefined(self.interactionName))
			    continue; 			
			
			//start_interaction( player, mltriggers[index].script_string );
			start_interaction( player, self.interactionName );
			self thread waitForClink();
			self thread waitForTapTooSoft();
			self thread waitForTapJustRight();
			self thread waitForTapTooHard();
			self thread waitForResetPin();
			self thread waitForSwirlSuccess();
			self thread waitForNextPin();
			self thread waitForMechLockAbort();
			self thread waitForPinFailure();

			level.player setclientdvar( "phone_context_available", "no" );

			return;
		}
	}
	iprintln("You aren't close enough to a lock.");
	level.player.lockSuccess = false;
	level.player notify("lockpick_done");
	//self cleanupElecLock(false);
}

elecLockpickActivated(node)
{
	ignore_tags = getdvar("ui_lockpick_ignoretags");
	if ((ignore_tags == "0") || (ignore_tags == ""))
	{
		setDvar("ui_lockpick_complexity","1");
		setDvar("ui_lockpick_speed","1");
		setDvar("ui_lockpick_code","4");

		if (IsDefined(self.lockparams))
		{
			token = strtok(self.lockparams, ": ");
			for(i = 0; i < token.size; i++)
			{
				switch (token[i])
				{
				case "complexity":
					i++;
					setDvar("ui_lockpick_complexity", token[i]);
					break;
				case "speed":
					i++;
					setDvar("ui_lockpick_speed", token[i]);
					break;
				case "code":
					i++;
					setDvar("ui_lockpick_code", token[i]);
					break;
				}
			}
		}
	}

	if ( level.player openlockhack( ) )
	{
		wait 0.5;

		// Play 3rd person animation for Bond
		// level thread play_lock_hack_anim(node);

		// Change camera view for lockpick PIP
		// cam_num = RandomIntRange(0, 2); // 3 lock_hack cams setup in interaction.cam, pick random
		// camera = level.player CustomCamera_Push("external", "interaction", "lock_hack" + cam_num);
		//camera = level.player CustomCamera_Push("external", "interaction", "lock_hack");
		// self Hide(); // hide the door so you don't see the camera cliping through it

		while (1)
		{
			if ( getdvar( "ui_lockpick_result" ) != "" ) {
				if ( getdvar( "ui_lockpick_result" ) == "success" )
					level.player.lockSuccess = true;
				else
					level.player.lockSuccess = false;
 				
				break;
			}
			wait 0.05;
		}
		// Pop custom camera back to first-person (or whatever it was)
		// level.player CustomCamera_Pop(camera, 0.05, 0.05, 0.05);
		// self Show();

		// stop_lock_hack_anim();
 
		wait 1.5; // wait for phone animation before opening door
	} else {
		// couldn't open lock hacker - probably because phone menu was open.
		level.player.lockSuccess = false;

		wait .05; // so we don't notify "lockpick_done" before other threads have a chance to wait for it
	}
 
 	level.player setclientdvar( "phone_context_available", "no" );

	if (level.player.lockSuccess)
	{
		level notify("ACH_LOCK_PASS");
		green_light();
	}

	self notify("lockpick_done");
	level.player notify("lockpick_done");
 
 	//self cleanupElecLock(level.player.lockSuccess);
}

play_lock_hack_anim(node)
{
	if (IsDefined(node))
	{
		level.player SetOrigin(node.origin);
		level.player SetPlayerAngles(node.angles);
	}

	level endon("stop_lock_hack_anim");

	while (true)
	{
		level.player PlayerAnimScriptEvent("phonehacklock");
		wait .05;
	}
}

stop_lock_hack_anim()
{
	level notify("stop_lock_hack_anim");
	level.player PlayerAnimScriptEvent("");
}

waitForElecLockAbort()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		if( level.player ButtonPressed( "BUTTON_A" ) )
		{
			end_interaction( level.player );
			wait 0.05;
			start_interaction( level.player, "ElecLockEnd" );
			level.player.lockSuccess = false;
			level.player notify("lockpick_done");
			//level.player switchFromPhoneContextMode();
			self cleanupElecLock(false);
			wait 5.0;
		}
		wait 0.05;
	}
}

waitForElecLockDone()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "ElecLockDone" );
		level.player.lockSuccess = true;
		level.player notify("lockpick_done");
		self cleanupElecLock(true);
	}
}

waitForElecLockFail()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "ElecLockFail" );
		level.player.lockSuccess = false;
		level.player notify("lockpick_done");
		self cleanupElecLock(false);
	}
}

waitForMechLockAbort()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		if( level.player useButtonPressed() )
		{
			end_interaction( level.player );
			wait 0.05;
			start_interaction( level.player, "MechLockEnd" );
			level.player.lockSuccess = false;
			//level.player notify("lockpick_done");
			//level.player switchFromPhoneContextMode();
			cleanupMechLock(false);
			wait 5.0;
		}
		wait 0.05;
	}
}

waitForClink()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "Clink" );
		pinIdx = self.pinIcons.size;
		self.pinIcons[pinIdx] = createIcon( "mechlock_pin_" + self.pinPos[pinIdx] + "_rest", 64, 128 );
		self.pinIcons[pinIdx] setPoint( "TOP", "TOP", (pinIdx-self.halfPinCount) * 64, 30 );
		if( pinIdx == self.currentPin )
		{
			self.pinGlowIcon = createIcon( "mechlock_pin_glow", 64, 128 );
			self.pinGlowIcon setPoint( "TOP", "TOP", (pinIdx-self.halfPinCount) * 64, 30 );
		}
	}
}

waitForResetPin()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "ResetPin" );
		self.pinIcons[self.currentPin] destroyElem();
		self.pinIcons[self.currentPin] = createIcon( "mechlock_pin_" + self.pinPos[self.currentPin] + "_rest", 64, 128 );
		self.pinIcons[self.currentPin] setPoint( "TOP", "TOP", (self.currentPin-self.halfPinCount) * 64, 30 );
	}
}

waitForTapTooSoft()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "TapTooSoft" );
		//iprintln( "TapTooSoft" );
		self.pinIcons[self.currentPin] destroyElem();
		self.pinIcons[self.currentPin] = createIcon( "mechlock_pin_" + self.pinPos[self.currentPin] + "_low", 64, 128 );
		self.pinIcons[self.currentPin] setPoint( "TOP", "TOP", (self.currentPin-self.halfPinCount) * 64, 30 );
	}
}

waitForTapJustRight()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "TapJustRight" );
		//iprintln( "TapJustRight" );
		self.pinIcons[self.currentPin] destroyElem();
		self.pinIcons[self.currentPin] = createIcon( "mechlock_pin_" + self.pinPos[self.currentPin] + "_good", 64, 128 );
		self.pinIcons[self.currentPin] setPoint( "TOP", "TOP", (self.currentPin-self.halfPinCount) * 64, 30 );
	}
}

waitForTapTooHard()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "TapTooHard" );
		//iprintln( "TapTooHard" );
		self.pinIcons[self.currentPin] destroyElem();
		self.pinIcons[self.currentPin] = createIcon( "mechlock_pin_" + self.pinPos[self.currentPin] + "_high", 64, 128 );
		self.pinIcons[self.currentPin] setPoint( "TOP", "TOP", (self.currentPin-self.halfPinCount) * 64, 30 );
	}
}

waitForPinFailure()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "PinFailure" );
		self.currentPin--;
		if( self.currentPin >= 0 )
		{
			self.pinGlowIcon setPoint( "TOP", "TOP", (self.currentPin - self.halfPinCount)*64, 30 );
		}
		else
		{
			end_interaction( level.player );
			wait 0.05;
			//start_interaction( level.player, "MechLockEnd" );
			level.player.lockSuccess = false;
            self notify("lockpick_done");
			//level.player switchFromPhoneContextMode();
			cleanupMechLock(false);
			wait 5.0;
		}
	}
}

waitForSwirlSuccess()
{
	self endon("lockpick_done");
	while ( 1 )
	{
		level.player waittill( "SwirlSuccess" );
		self.pinIcons[self.currentPin] destroyElem();
		self.pinIcons[self.currentPin] = createIcon( "mechlock_pin_" + self.pinPos[self.currentPin] + "_turn", 64, 128 );
		self.pinIcons[self.currentPin] setPoint( "TOP", "TOP", (self.currentPin - self.halfPinCount) * 64, 30 );
	}
}

waitForNextPin()
{
	self endon("lockpick_done");
	while( 1 )
	{
		level.player waittill( "NextPin" );
		self.currentPin++;
		if( self.currentPin != self.pinCount )
		{
			self.pinGlowIcon setPoint( "TOP", "TOP", (self.currentPin - self.halfPinCount)*64, 30 );
		}
		else
		{
			if( isdefined( self.mltrigger ) )
			{
				if( isDefined( self.mltrigger.onPick ) )
				{
					[[self.mltrigger.onPick]]();
				}
			}
			level.player.lockSuccess = true;
			level.player notify("lockpick_done");
			self cleanupMechLock(true);
		}
	}
}

cleanupMechLock(finished)
{
	if ( !isDefined( self.pinIcons ) )
	{
		return;
	}
	for( index = 0; index < self.pinIcons.size; index++ )
	{
		self.pinIcons[index] destroyElem();
	}
	self.pinIcons = undefined;
	if( isDefined( self.pinGlowIcon ) )
	{
		self.pinGlowIcon destroyElem();
	}
	self.pinGlowIcon = undefined;
	self.currentPin = undefined;
	///script_origin = getEnt( self.mltrigger.target, "targetname" );
	script_origin = self.mltrigger;
	if( isDefined( script_origin ) )
	{
		//level.player unlink();
		if( finished == true )
		{
			//level.player thread setOriginSoon(level.player.savedOrigin, 1.75);
		}
		else
		{
			//level.player thread setOriginSoon(level.player.savedOrigin, 1);
		}
		//check_for_existing_lockpicks();
		//temporigin = getEnt( "special_lockpick_origin", "targetname" );
		//if( isDefined( temporigin ) )
		//   temporigin thread deleteSoon(1.5);
	}
	//level.player maps\_gameobjects::_enableWeapon();
	if( finished == true )
	{
		//if( isdefined( self.mltrigger ) )
		//{
		//	self.mltrigger delete();
		//	self.mltrigger = undefined;
		//}
		//level.player notify( "delete_phone_trigger" );
		//level.player switchFromPhoneContextMode();
	}
	else
	{
		wait 0.5;
		//level.player setclientdvar( "phone_context_available", "Mechanical Lockpick Available" );
	}
	//resetTriggerHints();
	self notify("lockpick_done");
	level.player notify("lockpick_done");
}

deleteSoon( time )
{
	wait time;
	if (isDefined( self ))
	{
		self delete();
	}	
}

cleanupElecLock(finished)
{
	//iprintln( "You picked the lock!" );

	if( IsDefined( self.eltrigger ) )
	{
		script_origin = self.eltrigger;
	

		if( isDefined( script_origin ) )
		{
			//level.player unlink();
			if( finished == true )
			{
				//level.player thread setOriginSoon(level.player.savedOrigin, 1.75);
			}
			else
			{
				//level.player thread setOriginSoon(level.player.savedOrigin, 1);
			}
			//check_for_existing_lockpicks();
			//temporigin = getEnt( "special_lockpick_origin", "targetname" );
			//if (isDefined( temporigin ))
			//{
			//	temporigin thread deleteSoon(1.5);
			//}
		}
	}
	//level.player maps\_gameobjects::_enableWeapon();
	if( finished == true )
	{
		//if( isdefined( self.eltrigger ) )
		//{
		//	self.eltrigger delete();
		//	self.eltrigger = undefined;
		//}
		//level.player notify( "delete_phone_trigger" );
		//level.player switchFromPhoneContextMode();
	}
	else
	{
		wait 0.5;
		//level.player setclientdvar( "phone_context_available", "Electronic Lockpick Available" );
	}
	//resetTriggerHints();
}

setOriginSoon( newOrigin, waittime )
{
	wait waittime;
	self setOrigin( newOrigin );
}

//////////////////////////////////////////////////////////////////
//                                                              //
// specific locks defined here                                  //
//                                                              //
//////////////////////////////////////////////////////////////////

// call this from whatever entity has the lock
InitLockFromString(locked)
{
    if(isDefined(self.lockInitialized))
        return;

	if(!isDefined(self.lockname))
	    return;

	self.locktype = "none";

	if (!IsDefined(locked))
	{
		locked = true;
	}

    //////////////////////////////////////////////////////////////
    //                                                          //
    //  mechlock_1                                              //
    //                                                          //
    //  Three-pin mechanical, easy difficulty                   //
    //                                                          //
    //////////////////////////////////////////////////////////////

    if(self.lockname == "mechlock_1")
    {
        self.locktype = "mechanical";
        self.interactionName = "ThreePinLock";
        self.pinPos[0] = "med";
        self.pinPos[1] = "low";
        self.pinPos[2] = "high";
		self.pinCount = self.pinPos.size;    
		self.pinIcons = [];
		self.currentPin = 0;
		self.halfPinCount = (self.pinCount-1)/2;
		
        self.lockInitialized = true;
    }
    
    //////////////////////////////////////////////////////////////
    //                                                          //
    //  eleclock_1                                              //
    //                                                          //
    //  Test electronic lock                                    //
    //                                                          //
    //////////////////////////////////////////////////////////////
    
    if(self.lockname == "eleclock_1")
    {
        self.locktype = "electronic";
        self.interactionName = "Eleclock";
        
        self.lockInitialized = true;
    }
    
    //////////////////////////////////////////////////////////////
    
    
    // etc

	if (self.locktype == "electronic")
	{
		self init_electronic(locked);
	}
    
    // TODO default lock
    
    return;

}


//*************************************************************//
//  NON-DOOR LOCK FUNCTIONS                                    // 
//*************************************************************//


//
//  setup_lock 
// 
//  Call this on whatever you want to attach a lock to.
//  Will handle the initial setup.
//  
//  locktype should be a string defined in InitLockFromString().
//  Add new locktype strings to that function as necessary.
//  
//
setup_lock(lockname)
{
	self.lockname = lockname;
	self InitLockFromString();
}

// in case we somehow didn't get things cleaned up properly before
check_for_existing_lockpicks()
{

//
// Removeing this code stops the player being transported to the origin of the 1st electronic lockpick for each
// subsequent lockpick you try.
// MikeA 01/28/08
//
//	lockpick_origin = getEntArray( "special_lockpick_origin", "targetname" );
//	num = 0;
//	while (isDefined(lockpick_origin[num]))
//	{
//		lockpick_origin[num] delete();
//		num++;
//	}
//	wait(0.1);

	
}


//
// can_use_lock - test to see if the player is (still) in position
//
can_use_lock()
{
	//// make sure nothing is in the way and we are close enough
	//if(	!sightTracePassed(level.player GetEye(), self.origin, false, undefined) ||
	//	(distance(level.player.origin, self.origin) > 85) ||
	//	(distance(level.player.origin, self.origin) < 0.8))
	//{
	//	return false;
	//}

	eye = level.player geteye();
	//eye = level.player.origin + (0, 0, 70);

	dot = VectorDot(VectorNormalize(self.origin - eye), AnglesToForward(level.player getviewangles()));
	dist_sq = int(DistanceSquared(self.origin, eye));

	if(	(dist_sq > 85*85) || 
		(dot < .80) || 
		!sightTracePassed(eye, self.origin, false, undefined)) 
	{
		return false;
	}

	return true;
}
