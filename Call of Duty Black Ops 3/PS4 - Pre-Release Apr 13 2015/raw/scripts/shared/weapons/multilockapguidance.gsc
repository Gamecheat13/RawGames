#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_util;

                                          	  	                                                                                  	        
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "string", "MP_CANNOT_LOCKON_TO_TARGET" );

#namespace multilockap_guidance;

	//#define MAX_SIMULTANEOUS_LOCKONS	5 this number corresponds to a code define

function autoexec __init__sytem__() {     system::register("multilockap_guidance",&__init__,undefined,undefined);    }

function __init__()
{
	callback::on_spawned( &on_player_spawned );
	SetDvar( "scr_max_simLocks",3 );
}

function on_player_spawned()
{
	self endon( "disconnect" );

	self ClearAPTarget();
	thread APToggleLoop();
	self thread APFiredNotify();
}

function ClearAPTarget( weapon, whom )
{
	if (!IsDefined(self.multiLockList))
	{
		self.multiLockList=[];
	}
	
	if (IsDefined(whom))
	{
		for(i=0;i<self.multiLockList.size;i++)
		{
			 if (whom.apTarget == self.multiLockList[i].apTarget)
			 { 
			 	if (isdefined(self.multiLockList[i].apTarget))
				{
					self.multiLockList[i].apTarget notify( "missile_unlocked" );
			 	}
				self notify( "stop_sound"+whom.apSoundId );
			 	self WeaponLockRemoveSlot(i);
				ArrayRemoveValue(self.multiLockList,whom,false);
				break;
			 }
		}
	}
	else
	{
		for(i=0;i<self.multiLockList.size;i++)
		{
			self.multiLockList[i].apTarget notify( "missile_unlocked" );
			self notify( "stop_sound"+self.multiLockList[i].apSoundId );
		}
		self.multiLockList = [];
	}

	if (self.multiLockList.size==0)
	{
		self StopRumble( "stinger_lock_rumble" );

		self WeaponLockRemoveSlot(-1);
	
		if (IsDefined(weapon))
		{
			if (IsDefined(weapon.lockonSeekerSearchSound))
				self StopLocalSound( weapon.lockonSeekerSearchSound );
			if (IsDefined(weapon.lockonSeekerLockedSound))
				self StopLocalSound( weapon.lockonSeekerLockedSound );
		}
	
		self DestroyLockOnCanceledMessage();
	}
}


function APFiredNotify()
{
	self endon( "disconnect" );
	self endon ( "death" );

	while ( true )
	{
		self waittill( "missile_fire", missile, weapon );

		if ( weapon.lockonType == "AP Multi" )
		{
			foreach(target in self.multiLockList)
			{
				if( isdefined(target.apTarget) && target.apLockFinalized )
				{
					target.apTarget notify( "stinger_fired_at_me", missile, weapon, self );
				}
			}
		}
	}
}

function APToggleLoop()
{
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;)
	{
		self waittill( "weapon_change", weapon );

		while ( weapon.lockonType == "AP Multi" )
		{
			abort = false;

			while( !( self PlayerAds() == 1.0 ) )
			{
				{wait(.05);};

				currentWeapon = self GetCurrentWeapon();
				if ( currentWeapon.lockonType != "AP Multi" )
				{
					abort = true;
					break;
				}
			}

			if ( abort )
			{
				break;
			}

			self thread APLockLoop(weapon);

			while( ( self PlayerAds() == 1.0 ) )
			{
				{wait(.05);};
			}

			self notify( "ap_off" );
			self ClearAPTarget(weapon);

			weapon = self GetCurrentWeapon();
		}
	}
}

function APLockLoop(weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "ap_off" );

	lockLength = self getLockOnSpeed();
	self.multiLockList = [];
	
	for (;;)
	{
		{wait(.05);};

		//-------------------------
		// Four possible states:
		//      No missile in the tube, so CLU will not search for targets.
		//		CLU has a lock.
		//		CLU is locking on to a target.
		//		CLU is searching for a target to begin locking on to.
		//-------------------------

		do
		{
			done=true;
			foreach(target in self.multiLockList)
			{
				if ( target.apLockFinalized )
				{
					if ( ! IsStillValidTarget( weapon, target.apTarget ) )
					{
						self ClearAPTarget(weapon, target);
						//start over because the array has changed and it'll mess up foreach
						done = false;
						break;
					}
				}
			}
		}
		while (!done);
		

		inLockingState=false;
		
		do
		{
			done=true;
			for(i=0;i<self.multiLockList.size;i++)
			{
				target=self.multiLockList[i];
				if ( target.apLocking )
				{
					if ( ! IsStillValidTarget( weapon, target.apTarget ) )
					{
						self ClearAPTarget(weapon, target);
						//start over because the array has changed and it'll mess up foreach
						done=false;
						break;
					}
		
					inLockingState=true;
					
					timePassed = getTime() - target.apLockStartTime;
					if ( timePassed < lockLength )
						continue;
		
					assert( isdefined( target.apTarget ) );
					target.apLockFinalized = true;
					target.apLocking = false;
					target.apLockPending = false;
					self WeaponLockFinalize( target.apTarget, i );
					self thread SeekerSound( weapon.lockonSeekerLockedSound, weapon.lockonSeekerLockedSoundLoops, target.apSoundId );
					target.apTarget notify( "missile_lock", self, weapon );
				}
			}
		}
		while (!done);
		
		//if anyone is in the locking state, then don't allow pending to change state to locking (this will make locking sequential)
		if (!inLockingState)
		{
			do
			{
				done=true;
				for(i=0;i<self.multiLockList.size;i++)
				{
					target=self.multiLockList[i];
					if ( target.apLockPending )
					{
						if ( ! IsStillValidTarget( weapon, target.apTarget ) )
						{
							self ClearAPTarget(weapon, target);
							//start over because the array has changed and it'll mess up foreach
							done=false;
							break;
						}
			
						target.apLockStartTime = getTime();

						target.apLockFinalized = false;
						target.apLockPending = false;
						target.apLocking = true;

						self thread SeekerSound( weapon.lockonSeekerSearchSound, weapon.lockonSeekerSearchSoundLoops, target.apSoundId );
						
						done=true;
						break;
					}
				}
			}
			while (!done);
		}

		if (self.multiLockList.size>=GetDvarInt( "scr_max_simLocks" ) || self.multiLockList.size>=self GetWeaponAmmoClip(weapon))
		{
			continue;
		}
		
		bestTarget = self GetBestTarget(weapon);

		if ( !IsDefined(bestTarget) && self.multiLockList.size==0 )
		{
			self DestroyLockOnCanceledMessage();
			continue;
		}

		//append to the lock list if we have the space
		if (IsDefined(bestTarget) && self.multiLockList.size<GetDvarInt( "scr_max_simLocks" ) && self.multiLockList.size<self GetWeaponAmmoClip(weapon))
		{
			self WeaponLockStart(bestTarget.apTarget,self.multiLockList.size);
			self.multiLockList[self.multiLockList.size] = bestTarget;
		}
	}
}

function DestroyLockOnCanceledMessage()
{
	if( isdefined( self.LockOnCanceledMessage ) )
		self.LockOnCanceledMessage destroy();
}

function DisplayLockOnCanceledMessage()
{
	if( isdefined( self.LockOnCanceledMessage ) )
		return;

	self.LockOnCanceledMessage = newclienthudelem( self );
	self.LockOnCanceledMessage.fontScale = 1.25;
	self.LockOnCanceledMessage.x = 0;
	self.LockOnCanceledMessage.y = 50; 
	self.LockOnCanceledMessage.alignX = "center";
	self.LockOnCanceledMessage.alignY = "top";
	self.LockOnCanceledMessage.horzAlign = "center";
	self.LockOnCanceledMessage.vertAlign = "top";
	self.LockOnCanceledMessage.foreground = true;
	self.LockOnCanceledMessage.hidewhendead = false;
	self.LockOnCanceledMessage.hidewheninmenu = true;
	self.LockOnCanceledMessage.archived = false;
	self.LockOnCanceledMessage.alpha = 1.0;
	self.LockOnCanceledMessage SetText( &"MP_CANNOT_LOCKON_TO_TARGET" );
}

function GetBestTarget(weapon)
{
	playerTargets = GetPlayers();
	vehicleTargets = target_getArray();
	targetsAll = GetAITeamArray();
	targetsAll = ArrayCombine(targetsAll, playerTargets, false, false);
	targetsAll = ArrayCombine(targetsAll, vehicleTargets, false, false);
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( level.teamBased ) //team based game modes
		{
			if ( isdefined(targetsAll[idx].team) && targetsAll[idx].team != self.team) 
			{
				if ( self InsideAPReticleNoLock( targetsAll[idx] ) )
				{
					if (self LockSightTest(targetsAll[idx]))
					{
						targetsValid[targetsValid.size] = targetsAll[idx];
					}
				}
			}
		}		
		else 
		{
			if( self InsideAPReticleNoLock( targetsAll[idx] ) ) //Free for all
			{
				if( isdefined( targetsAll[idx].owner ) && self != targetsAll[idx].owner )
				{
					if (self LockSightTest(targetsAll[idx]))
					{
						targetsValid[targetsValid.size] = targetsAll[idx];
					}
				}
			}
		}
	}

	if ( targetsValid.size == 0 )
		return undefined;

	//find the best target that isn't already in the list
	
	playerForward = AnglesToForward(self GetPlayerAngles());
	dots=[];
	for (i=0;i<targetsValid.size;i++)
	{
		newitem=spawnstruct();
		newitem.index = i;
		newitem.dot = VectorDot(playerForward,VectorNormalize(targetsValid[i].origin-self.origin));
		array::insertion_sort(dots,&TargetInsertionSortCompare,newitem);
	}
	
	index=0;
	foreach(dot in dots)
	{
		found = false;
		foreach(lock in self.multiLockList)
		{
			if (lock.apTarget == targetsValid[dot.index])
			{
				found=true;
			}
		}

		if (found)
		{
			continue;
		}
		
		newEntry = spawnstruct();
		newEntry.apTarget = targetsValid[dot.index];
		newEntry.apLockStartTime = getTime();
		newEntry.apLockPending = true;
		newEntry.apLocking = false;
		newEntry.apLockFinalized = false;
		newEntry.apLostSightlineTime = 0;
		newEntry.apSoundId = RandomInt(0x7FFFFFFF);
		return newEntry;
	}
	
	return undefined;
}

function TargetInsertionSortCompare(a, b)
{
	if (a.dot<b.dot)
		return -1;
	if (a.dot>b.dot)
		return 1;
	return 0;
}

function InsideAPReticleNoLock( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}

function InsideAPReticleLocked( target )
{
	radius = (self getLockOnLossRadius());
	return target_isincircle( target, self, 65, radius );
}

function IsStillValidTarget( weapon, ent )
{
	if ( ! isdefined( ent ) )
		return false;
	if ( ! InsideAPReticleLocked( ent ) )
		return false;
	if ( !IsAlive( ent ) )
		return false;
	if (!LockSightTest(ent))
		return false;

	return true;
}

function SeekerSound( alias, looping, id )
{
	self notify( "stop_sound"+id);

	self endon ( "stop_sound"+id );
	self endon( "disconnect" );
	self endon ( "death" );
	
	if (IsDefined(alias))
	{
		self PlayRumbleOnEntity( "stinger_lock_rumble" );
		time = SoundGetPlaybackTime(alias)*0.001;
		do 
		{
			self playLocalSound( alias );
			wait(time);
		}
		while (looping);
		self StopRumble( "stinger_lock_rumble" );
	}
}
	
function LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isdefined( target ) ) //targets can disapear during targeting.
		return false;
	
	if ( !IsAlive( target ) )
		return false;
	
	pos = target GetShootAtPos();
	if (IsDefined(pos))
	{
		passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
		if ( passed )
			return true;
	}

	pos = target GetCentroid();
	if (IsDefined(pos))
	{
		passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
		if ( passed )
			return true;
	}

	pos=target.origin;
	passed = BulletTracePassed( eyePos, pos, false, target, undefined, true, true );
	if ( passed )
		return true;

	return false;
}

