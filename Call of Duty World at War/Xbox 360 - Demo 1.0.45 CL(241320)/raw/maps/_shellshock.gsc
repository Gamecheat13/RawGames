
// SCRIPTER_MOD
// MikeD( 3/22/2007 ): No more level.player
main( origin, duration, shock_range, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock, stanceLockDuration )
{
	assertex( IsDefined( origin ), "_shellshock::main() needs a origin passed in now for coop consideration." );


	if( !IsDefined( shock_range ) )
	{
		shock_range = 500; 
	}

	if( !IsDefined( duration ) )
	{
		duration = 12; 
	}
	else if( duration < 7 )
	{
		duration = 7; 
	}
	
	if( !IsDefined( nMaxDamageBase ) )
	{
		nMaxDamageBase = 150; 
	}
	
	if( !IsDefined( nRanDamageBase ) )
	{
		nRanDamageBase = 100; 
	}
	
	if( !IsDefined( nMinDamageBase ) )
	{
		nMinDamageBase = 100; 
	}
	
	if( !IsDefined( customShellShock ) )
	{
		customShellShock = "default"; 
	}
	
	players = maps\_utility::get_players(); 
	for( q = 0; q < players.size; q++ )
	{
		if( Distancesquared( players[q].origin, origin ) < shock_range * shock_range )
		{
			players[q] thread shellshock_thread( duration, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock, stanceLockDuration ); 
		}
	}
}
		
shellshock_thread( duration, nMaxDamageBase, nRanDamageBase, nMinDamageBase, nExposed, customShellShock, stanceLockDuration )
{		
	origin = self GetOrigin() +( 0, 8, 2 ); 
	range = 320;

	if( IsDefined( nRanDamageBase ) && nRanDamageBase > 0 )
	{
		maxdamage = nMaxDamageBase + RandomInt( nRanDamageBase ); 
	}
	else
	{
		maxdamage = nMaxDamageBase; 
	}

	mindamage = nMinDamageBase; 
	
	self PlaySound( "weapons_rocket_explosion" ); 
	wait( 0.25 ); 
	
	RadiusDamage( origin, range, maxdamage, mindamage ); 
	Earthquake( 0.75, 2, origin, 2250 ); 

	if( IsAlive( self ) )
	{
		self AllowStand( false ); 
		self AllowCrouch( false ); 
		self AllowProne( true ); 
		
		wait( 0.15 ); 
		self ViewKick( 127, self.origin );  //Amount should be in the range 0-127, and is normalized "damage".  No damage is done.

		// SCRIPTER_MOD
		// JesseS (3/27/07): CustomShellShock passed in here

 
		self ShellShock( customShellShock, duration ); 
		
		if( !IsDefined( nExposed ) )
		{
			level thread playerHitable( duration ); 
		}
		
		// SCRIPTER_MOD
		// SRS 8/13/2008: now we can customize the duration for which player stance is locked
		if( !IsDefined( stanceLockDuration ) )
		{
			stanceLockDuration = 1.5;
		}
		
		wait( stanceLockDuration ); 
		
		self AllowStand( true ); 
		self AllowCrouch( true ); 
	}
}

playerHitable( duration )
{
	self.shellshocked = true; 
	self.ignoreme = true; 
	level notify( "player is shell shocked" ); 
	level endon( "player is shell shocked" ); 
	wait( duration - 1 ); 
	self.shellshocked = false; 
	self.ignoreme = false; 
}