#using scripts\codescripts\struct;
#using scripts\shared\array_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\abilities\_ability_util;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\cp\cp_mi_cairo_ramses_dead_event;

#namespace dead_guidance;


function autoexec __init__sytem__() {     system::register("dead_guidance",&__init__,undefined,undefined);    }

function __init__() 
{
	level.DEAD_CONTROL_WEAPON = GetWeapon( "hands_dni_control" ); //, "dynzoom" );
	
	callback::on_spawned( &on_player_spawned );
}

function on_player_spawned() 
{
	self endon( "disconnect" );

	self ClearDEADTarget();
	thread DEADToggleLoop();
}

function ClearDEADTarget( weapon )
{
	self notify( "ap_cleartarget" );

 	self.deadTarget = undefined;

	self WeaponLockRemoveSlot(-1);
	
	if( IsDefined( self.dead_system_ui ) )
	{
		self thread cp_mi_cairo_ramses_dead_event::reticule_white();
		self thread cp_mi_cairo_ramses_dead_event::hide_health_bar();
	}		
}

function DEADToggleLoop()
{
	self endon( "disconnect" );
	self endon ( "death" );
	
	for (;;) 
	{
		self waittill( "weapon_change", weapon );

		while ( weapon == level.DEAD_CONTROL_WEAPON )
		{
			self thread APLockLoop(weapon);

			self waittill( "weapon_change", new_weapon );

			self notify( "dead_off" );
			self ClearDEADTarget(weapon);
			weapon = new_weapon;
		}
	}
}

function APLockLoop(weapon)
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon( "dead_off" );
	
	for (;;)
	{
		{wait(.05);};

		//active lock
		if ( IsDefined(self.deadTarget) && self.deadLockFinalized )
		{
			//lost for some reason
			if ( ! self IsStillValidTarget( weapon, self.deadTarget ) )
			{
				self ClearDEADTarget(weapon);
			}
			else
			{
				//no longer in crosshairs - demote to tracking
				if (!InsideAPReticleLocked( self.deadTarget ) )
				{
					//lose the lock, but it still qualifies as a valid target to track - so put it back into that category
					self weaponlockfree( self.deadTarget);
					self.deadLockFinalized = false;
					self.deadLocking = true;
					self WeaponLockStart( self.deadTarget, 0 );
					if( IsDefined( self.dead_system_ui ) )
					{
						self thread cp_mi_cairo_ramses_dead_event::reticule_white();
						self thread cp_mi_cairo_ramses_dead_event::hide_health_bar();
					}		
				}
			}
		}
		
		if ( IsDefined(self.deadTarget) && self.deadLocking )
		{
			//lost for some reason
			if ( ! self IsStillValidTarget( weapon, self.deadTarget ) )
			{
				self ClearDEADTarget(weapon);
			}
			else
			{
				//inside of circle - active lock		
				if (InsideAPReticleLocked( self.deadTarget ) )
				{
					self.deadLockFinalized = true;
					self.deadLocking = false;
					if( IsDefined( self.dead_system_ui ) )
					{
						self thread cp_mi_cairo_ramses_dead_event::reticule_red();
						self thread cp_mi_cairo_ramses_dead_event::update_target_health_bars( self.deadTarget );
					}
					self WeaponLockFinalize( self.deadTarget, 0 );
				}
			}
		}
		
		bestTarget = self GetBestTarget(weapon);

		if ( !IsDefined(bestTarget) )
		{
			continue;
		}

		//always track and pick against the best target - "locks" are frame to frame
		if (IsDefined(bestTarget))
		{
			if (!IsDefined(self.deadTarget) || bestTarget != self.deadTarget)
			{
				self ClearDEADTarget(weapon);

				//pick a different target
				self.deadTarget = bestTarget;
				self.deadLockFinalized = false;
				self.deadLocking = true;
				self WeaponLockStart(self.deadTarget,0);
			}
		}
	}
}

function DestroyLockOnCanceledMessage()
{
	if( isdefined( self.LockOnCanceledMessage ) )
		self.LockOnCanceledMessage destroy();
}

function GetBestTarget(weapon)
{
	//todo:  get all airborne targets
	targetsAll = target_getArray();
	targetsValid = [];

	for ( idx = 0; idx < targetsAll.size; idx++ )
	{
		if ( isdefined(targetsAll[idx].team) && targetsAll[idx].team != self.team) 
		{
			if ( self InsideDEADReticleNoLock( targetsAll[idx] ) )
			{
				if (self LockSightTest(targetsAll[idx]))
				{
					targetsValid[targetsValid.size] = targetsAll[idx];
				}
			}
		}
	}

	if ( targetsValid.size == 0 )
		return undefined;

	//find the best target 
	playerForward = AnglesToForward(self GetPlayerAngles());
	dots=[];
	for (i=0;i<targetsValid.size;i++)
	{
		newitem=spawnstruct();
		newitem.index = i;
		newitem.dot = VectorDot(playerForward,VectorNormalize(targetsValid[i].origin-self.origin));
		array::insertion_sort(dots,&TargetInsertionSortCompare,newitem);
	}
	
	foreach(dot in dots)
	{
		return targetsValid[dot.index];
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

function InsideDEADReticleNoLock( target )
{
	return target_isinRect( target, self, 65, 100, 100);
}

function InsideAPReticleLocked( target )
{
	radius = self getLockOnRadius();
	return target_isincircle( target, self, 65, radius );
}

function IsStillValidTarget( weapon, ent )
{
	if ( ! isdefined( ent ) )
		return false;
	if ( ! IsAlive(ent) )
		return false;
	if ( ! target_isTarget( ent ) )
		return false;
	if ( ! self InsideDEADReticleNoLock( ent ) )
		return false;

	return true;
}

function LockSightTest( target )
{
	eyePos = self GetEye();
	
	if ( !isdefined( target ) ) //targets can disapear during targeting.
		return false;
	
	passed = BulletTracePassed( eyePos, target getshootatpos(), false, target );
	if ( passed )
		return true;

	return false;
}

