#using scripts\codescripts\struct;

#using scripts\shared\callbacks_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\clientfield_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       




	
#namespace empgrenade;

#precache( "lui_menu", "EmpRebootIndicator" );
#precache( "lui_menu_data", "startTime" );
#precache( "lui_menu_data", "endTime" );
#precache( "lui_menu_data", "duration" );

function autoexec __init__sytem__() {     system::register("empgrenade",&__init__,undefined,undefined);    }	

function __init__()
{
	clientfield::register( "toplayer", "empd", 1, 1, "int" );
	clientfield::register( "toplayer", "empd_monitor_distance", 1, 1, "int" );
	callback::on_spawned( &on_player_spawned );
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function on_player_spawned()
{
	self endon("disconnect");

	self thread monitorEMPGrenade();
	self thread begin_other_grenade_tracking();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function monitorEMPGrenade()
{
	self endon( "disconnect" );
	self endon( "death" );
	self endon ("killEMPMonitor");
	
	self.empEndTime = 0;
	
	while(1)
	{
		self waittill( "emp_grenaded", attacker, explosionPoint );
		
		if ( !isalive( self )|| self hasPerk( "specialty_immuneemp" ) )
			continue;
		
		//MW3 emp resistance perk
		//if ( self _hasPerk( "specialty_spygame" ) )
		//	continue;
		
		hurtVictim = true;
		hurtAttacker = false;
		
		assert(isdefined(self.team));
		
		if (level.teamBased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
		{
			if(level.friendlyfire == 0) // no FF
			{
				continue;
			}
			else if(level.friendlyfire == 1) // FF
			{
				hurtattacker = false;
				hurtvictim = true;
			}
			else if(level.friendlyfire == 2) // reflect
			{
				hurtvictim = false;
				hurtattacker = true;
			}
			else if(level.friendlyfire == 3) // share
			{
				hurtattacker = true;
				hurtvictim = true;
			}
		}
		
		if ( hurtvictim && isdefined(self))
		{
			self thread applyEMP( attacker, explosionpoint );
		}
		if ( hurtattacker && isdefined(attacker))
		{
			attacker thread applyEMP( attacker, explosionpoint );
		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function applyEMP( attacker, explosionpoint )
{
	self notify( "applyEmp" );
	self endon( "applyEmp" );
	
	self endon( "disconnect" );
	self endon( "death" );
	
	wait .05;

	if ( !( isdefined( self ) && isalive( self ) ) )
	{
		return;
	}

	if ( self == attacker )
	{
		currentEmpDuration = 1;
	}
	else
	{
		distanceToExplosion = Distance( self.origin, explosionPoint );
		ratio = 1 - ( distanceToExplosion / 425 );
		
		currentEmpDuration = 3 + ( ( 6 - 3 ) * ratio );
	}
	
	if ( isdefined( self.empEndTime ))
	{
		emp_time_left_ms = self.empEndTime - GetTime();
	
		if( emp_time_left_ms > currentEmpDuration * 1000 )
		{
			self.empDuration = emp_time_left_ms / 1000;
		}
		else
		{
			self.empDuration = currentEmpDuration;
		}
	}
	else
	{
		self.empDuration = currentEmpDuration;
	}


	self.empGrenaded = true;
	self shellshock( "emp_shock", 1 ); 
	self clientfield::set_to_player( "empd", 1 );
	
//	if ( self != attacker )
//	{
//		self PlaySoundToPlayer( "chr_emp_static", self );
//	}
	
	self.empStartTime = getTime();
	self.empEndTime = self.empStartTime + (self.empDuration * 1000);
		 
	ShutdownEmpRebootIndicatorMenu();
	
	empRebootMenu = self OpenLUIMenu( "EmpRebootIndicator" );	
	self SetLuiMenuData( empRebootMenu, "endTime", int( self.empEndTime ) );
	self SetLuiMenuData( empRebootMenu, "startTime", int( self.empStartTime ) );
	
	self thread empRumbleLoop( .75 );
	self setEMPJammed( true );
	
	self thread empGrenadeDeathWaiter();
	self thread empGrenadeCleanseWaiter();
	
	
	if ( self.empDuration > 0 )
	{
		wait ( self.empDuration );	
	}
	
	if ( isdefined( self ) )
	{
		self notify( "empGrenadeTimedOut" );
		self checkToTurnOffEmp();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function empGrenadeDeathWaiter()
{
	self notify( "empGrenadeDeathWaiter" );
	self endon( "empGrenadeDeathWaiter" );
	
	self endon( "empGrenadeTimedOut" );
	
	self waittill( "death" );

	if ( isdefined( self ) )
	{
		self checkToTurnOffEmp();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function empGrenadeCleanseWaiter()
{
	self notify( "empGrenadeCleanseWaiter" );
	self endon( "empGrenadeCleanseWaiter" );
	
	self endon( "empGrenadeTimedOut" );
	
	self waittill( "gadget_cleanse_on" );

	if ( isdefined( self ) )
	{
		self checkToTurnOffEmp();
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function checkToTurnOffEmp()
{
	if ( isdefined( self ) )
	{
		self.empGrenaded = false;

		ShutdownEmpRebootIndicatorMenu();
		
		//dont shut off emp because the team is emp'd
		if( self killstreaks::EMP_IsEMPd() )
		{
			return;
		}
	
		self setEMPJammed( false );
		self clientfield::set_to_player( "empd", 0 );
	}
}

function ShutdownEmpRebootIndicatorMenu()
{
	empRebootMenu = self GetLUIMenu( "EmpRebootIndicator" );
	if( isdefined( empRebootMenu ) )
	{
		self CloseLuiMenu( empRebootMenu );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function empRumbleLoop( duration )
{
	self endon("emp_rumble_loop");
	self notify("emp_rumble_loop");
	
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
		{wait(.05);};
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function watchEMPExplosion( owner, weapon ) // self == grenade
{
	owner endon ( "disconnect" );
	owner endon ( "team_changed" );
	
	self endon( "trophy_destroyed" );

	owner AddWeaponStat( weapon, "used", 1 );

	self waittill( "explode", origin, surface );
	
	level empExplosionDamageEnts( owner, weapon, origin, 425, true );
}

function empExplosionDamageEnts( owner, weapon, origin, radius, damagePlayers )
{
	ents = GetDamageableEntArray( origin, radius );
	
	if ( !isdefined( damagePlayers ) )
	{
		damagePlayers = true;
	}

	foreach( ent in ents )
	{
		if ( !damagePlayers && IsPlayer(ent) )
		{
			continue;
		}
		
		ent DoDamage( 1, origin, owner, owner, "none", "MOD_GRENADE_SPLASH", 0, weapon );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
function begin_other_grenade_tracking()
{
	self endon( "death" );
	self endon( "disconnect" );
	
	self notify( "empTrackingStart" );	
	self endon( "empTrackingStart" );
	
	for (;;)
	{
		self waittill ( "grenade_fire", grenade, weapon, cookTime );

		if ( grenade util::isHacked() )
		{
			continue;
		}
		
		if ( weapon.isEmp )
		{
			grenade thread watchEMPExplosion( self, weapon );
		}
	}
}
