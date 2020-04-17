


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
		red_light();
	}
	else
	{
		green_light();
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
















mechLockpickActivated()
{
	check_for_existing_lockpicks();
	if(!isDefined(self.lockname) || self.lockname == "none")
	    return;

	mltriggers = getEntArray( "trigger_radius", "classname" ); 
	
	player = level.player;
	for( index = 0; index < mltriggers.size; index++ )
	{
	    
	    
	        
	    self InitLockFromString();  
	        
		
		
		if( player isTouching( mltriggers[index] ) && (self.locktype == "mechanical") )
		{
			
			
			
			self.mltrigger = mltriggers[index];
			
			script_origin = level.player;
			if( isDefined( script_origin ) )
			{
				tempOrigin = spawn("script_origin", script_origin getorigin() );
				
				tempOrigin.angles = script_origin.angles;
				tempOrigin.targetname = "special_lockpick_origin";
				level.player.savedOrigin = level.player getOrigin();
				
			}
			wait 0.25;
			
			
			
			
			if(!isDefined(self.interactionName))
			    continue; 			
			
			
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

		
		

		
		
		
		
		

		
		if( IsDefined( level.byPassPhoneIsRaised ) )
		{
			level.player NotifyPhoneRaised();
		}
		
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
		
		
		

		
 
		wait 1.5; 
	} else {
		
		level.player.lockSuccess = false;

		wait .05; 
	}
 
 	level.player setclientdvar( "phone_context_available", "no" );

	if (level.player.lockSuccess)
	{
		level notify("ACH_LOCK_PASS");
		green_light();
	}

	self notify("lockpick_done");
	level.player notify("lockpick_done");
 
 	
}

play_lock_hack_anim(node)
{
	if (IsDefined(node))
	{
		level.player SetOrigin(node.origin);
		
		
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
		if( level.player ButtonPressed( "BUTTON_A" ) || level.player ButtonPressed( "NUNCHUK_BUTTON_C" ))
		{
			end_interaction( level.player );
			wait 0.05;
			start_interaction( level.player, "ElecLockEnd" );
			level.player.lockSuccess = false;
			level.player notify("lockpick_done");
			
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
			
			level.player.lockSuccess = false;
            self notify("lockpick_done");
			
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
	
	script_origin = self.mltrigger;
	if( isDefined( script_origin ) )
	{
		
		if( finished == true )
		{
			
		}
		else
		{
			
		}
		
		
		
		
	}
	
	if( finished == true )
	{
		
		
		
		
		
		
		
	}
	else
	{
		wait 0.5;
		
	}
	
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
	

	if( IsDefined( self.eltrigger ) )
	{
		script_origin = self.eltrigger;
	

		if( isDefined( script_origin ) )
		{
			
			if( finished == true )
			{
				
			}
			else
			{
				
			}
			
			
			
			
			
			
		}
	}
	
	if( finished == true )
	{
		
		
		
		
		
		
		
	}
	else
	{
		wait 0.5;
		
	}
	
}

setOriginSoon( newOrigin, waittime )
{
	wait waittime;
	self setOrigin( newOrigin );
}








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
    
    
    
    
    
    
    
    
    
    if(self.lockname == "eleclock_1")
    {
        self.locktype = "electronic";
        self.interactionName = "Eleclock";
        
        self.lockInitialized = true;
    }
    
    
    
    
    

	if (self.locktype == "electronic")
	{
		self init_electronic(locked);
	}
    
    
    
    return;

}

















setup_lock(lockname)
{
	self.lockname = lockname;
	self InitLockFromString();
}


check_for_existing_lockpicks()
{















	
}





can_use_lock()
{
	eye = level.player geteye();
	

	dot = VectorDot(VectorNormalize(self.origin - eye), AnglesToForward(level.player getviewangles()));
	dist_sq = int(DistanceSquared(self.origin, eye));

	if ((dist_sq > 85*85) || (dot < .80))
	{
		return false;
	}

	return true;
}
