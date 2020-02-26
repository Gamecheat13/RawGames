///////////////////////////////////////////////////////////////////
// _aicivilian
//
// revision date: 2/07/08
// 
//	Spawner Keys Used
//		script_pacifist - (default 1) set to "0" to disable cowering
//		script_cheap - (default 1) set to "0" to disable pushing
//
//
///////////////////////////////////////////////////////////////////
#include common_scripts\utility;
#include maps\_utility;

///////////////////////////////////////////////////////////////////
// Civilian cowering
///////////////////////////////////////////////////////////////////
cower()
{
	// endon conditions
	self endon( "death" );

	// check for cower override
	if( IsDefined( self.script_pacifist ) && (self.script_pacifist == 0) )
	{
		return;
	}

	// set default state of cowering
	if( !IsDefined( self.cower_active ) )
	{
		self.cower_active = false;
	}
	
	// check for bond weapons unholstered
	while( true )
	{
		// LOS check
		if( !sightTracePassed( self.origin + (0, 0, 32), level.player GetEye(), false, undefined ) )
		{
			self.cower_active = false;
			sWpn = undefined;
			wait( 1 );
			continue;
		}

		// weapon check
		sWpn = level.player GetCurrentWeapon();
		if( !IsDefined( sWpn ) || (sWpn == "")  || (sWpn == "phone")  || (sWpn == "none"))
		{
			self.cower_active = false;
		}
		else
		{
			if( !self.cower_active )
			{
				self thread cower_anim();
			}
			self.cower_active = true;
		}
		wait( 1 );
	}
}

cower_anim()
{
	// endon conditions
	self endon( "death" );
	wait( 0.05 );
	
	while( IsDefined( self.cower_active ) && ( self.cower_active == true ) )
	{
		self CmdAction( "Flinch", true, 3 );
		wait( 3 );
	}
}


///////////////////////////////////////////////////////////////////
// Civilian pushing Bond
///////////////////////////////////////////////////////////////////
bump()
{
	// endon conditions
	self endon( "death" );

	// check for cower override
	if( IsDefined( self.script_cheap ) && (self.script_cheap == 0) )
	{
		return;
	}

	// allow ai to push player
	self PushPlayer( true );

	// loop the player
	while( true )
	{
		// check to see if civ is cowering 
		if( IsDefined( self.cower_active ) && ( self.cower_active == true ) )
		{	
			wait( 0.1 );
			continue;
		}

		// check for player dist and velocity
		if( (Distance(self.origin, level.player.origin ) < 32) && (level.player GetSpeed() > 40) )
		{
			self CmdAction( "pain" );
			wait( 3 );
		}
		else
		{
			wait( 0.1 );
		}
	}
}
