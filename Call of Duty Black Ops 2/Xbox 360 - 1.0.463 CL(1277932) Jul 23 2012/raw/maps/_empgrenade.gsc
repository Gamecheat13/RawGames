#include maps\_utility;
#include common_scripts\utility;

#define N_EMP_DURATION	10

init()
{
	precacheShellshock("flashbang");
//	thread onPlayerConnect();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
//onPlayerConnect()
//{
//	for(;;)
//	{
//		level waittill("connected", player);
//		player thread onPlayerSpawned();
//	}
//}
//
//
////******************************************************************
////                                                                 *
////                                                                 *
////******************************************************************
//onPlayerSpawned()
//{
//	self endon("disconnect");
//
//	for(;;)
//	{
//		self waittill( "spawned_player" );
//		self thread monitorEMPGrenade();
//	}
//}


//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
monitorEMPGrenade()
{
	self endon( "disconnect" );
	self endon( "death" );

	while(1)
	{
		self waittill( "emp_grenaded", attacker );
		
		if ( !isalive( self ))
			continue;
		
		self thread applyEMP();

		//MW3 emp resistance perk
		//if ( self _hasPerk( "specialty_spygame" ) )
		//	continue;

//		hurtVictim = true;
//		hurtAttacker = false;
//		
//		assert(isdefined(self.team));
//		
//		if (level.teamBased && isdefined(attacker) && isdefined(attacker.team) && attacker.team == self.team && attacker != self)
//		{
//			if(level.friendlyfire == 0) // no FF
//			{
//				continue;
//			}
//			else if(level.friendlyfire == 1) // FF
//			{
//				hurtattacker = false;
//				hurtvictim = true;
//			}
//			else if(level.friendlyfire == 2) // reflect
//			{
//				hurtvictim = false;
//				hurtattacker = true;
//			}
//			else if(level.friendlyfire == 3) // share
//			{
//				hurtattacker = true;
//				hurtvictim = true;
//			}
//		}
//
//		if ( hurtvictim && isDefined(self))
//		{
//			self thread applyEMP();
//		}
//		if ( hurtattacker && isDefined(attacker))
//		{
//			attacker thread applyEMP();
//		}
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
applyEMP()
{
	self notify( "applyEmp" );
	self endon( "applyEmp" );
	
	self endon( "disconnect" );
	self endon( "death" );
	
	wait .05;
	
	self.empGrenaded = true;
	self shellshock( "flashbang", 1 ); 
	self thread empRumbleLoop( .75 );
	self setEMPJammed( true );
	
	// 2 versions.  One fades over time, the other is full strength for the duration.
	//	Take your pick.
	rpc( "clientscripts/_empgrenade", "emp_filter_over_time", N_EMP_DURATION );
//	rpc( "clientscripts/_empgrenade", "emp_filter_on" );
	self hide_hud();
	SetSavedDvar( "cg_drawCrosshair", 0 );
	
	self thread empGrenadeDeathWaiter();
	self thread checkToTurnOffEmp();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
empGrenadeDeathWaiter()
{
	self notify( "empGrenadeDeathWaiter" );
	self endon( "empGrenadeDeathWaiter" );
	
	self endon( "empGrenadeTimedOut" );
	
	self waittill( "death" );
	
	self checkToTurnOffEmp();
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
checkToTurnOffEmp()
{
	self endon( "disconnect" );
	self endon( "death" );

	//wait ( N_EMP_DURATION );
	self waittill_notify_or_timeout( "empGrenadeShutOff", N_EMP_DURATION );

	self show_hud();	// this needs to be called so we have the correct number of attempts to hide/show the hud

	if ( !IsDefined( self._hide_hud_count ) )	// set to undefined when it reaches zero
	{
		self notify( "empGrenadeTimedOut" );
		self.empGrenaded = false;

		//dont shut off emp because the team is emp'd
	//	if ( (level.teamBased && maps\mp\killstreaks\_emp::EMP_IsTeamEMPed(self.team)) || (!level.teamBased && isDefined( level.empPlayer ) && level.empPlayer != self) )
	//		return;
		
		self setEMPJammed( false );
		rpc( "clientscripts/_empgrenade", "emp_filter_off" );
		SetSavedDvar( "cg_drawCrosshair", 1 );
	}
}

//******************************************************************
//                                                                 *
//                                                                 *
//******************************************************************
empRumbleLoop( duration )
{
	self endon("emp_rumble_loop");
	self notify("emp_rumble_loop");
	
	goalTime = getTime() + duration * 1000;
	
	while ( getTime() < goalTime )
	{
		self PlayRumbleOnEntity( "damage_heavy" );
		wait( 0.05 );
	}
}