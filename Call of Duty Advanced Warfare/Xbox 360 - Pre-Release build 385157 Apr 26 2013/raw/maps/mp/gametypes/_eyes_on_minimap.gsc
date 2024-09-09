#include maps\mp\_utility;

init()
{
	//level thread onPlayerConnect();
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill("connected", player);

		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	}
}

onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		
		self.onMiniMap = false;
		self thread checkMiniMapEnemies();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
		
		self.onMiniMap = false;
		self unsetPerk( "specialty_radarblip", true );
	}
}	

checkMiniMapEnemies()
{
	self endon( "death" );
	self endon( "disconnect" );
		
	for(;;)
	{	
		wait( 0.05 );
		enemiesInAngle = [];
		
		foreach( player in level.players )
		{
			if ( !isDefined(player) )
				continue;
			
			if ( player == self )
				continue;
			
			if ( !isReallyAlive(player) )
				continue;

			if ( !isReallyAlive(self) )
				continue;
			
			if ( level.teambased && player.team == self.team )
				continue;
				
			tolerance = 20;

			ForwardVector = anglesToForward( self.angles );
			ToTarget = player.origin - self.origin;
			ForwardVector *= (1,1,0);
			ToTarget *= (1,1,0 );
			
			ToTarget = VectorNormalize( ToTarget );
			ForwardVector = VectorNormalize( ForwardVector );
			
			targetCosine = VectorDot( ToTarget, ForwardVector );
			facingCosine = Cos( tolerance );
		
			if ( targetCosine >= facingCosine )
			{
				if ( sightTracePassed(self getEye(), player getEye(), false, self, player ) )
				{
					self.enemiesInAngle[enemiesInAngle.size] = player;
					player.onMiniMap = true;
					player.onMiniMapTime = getTime();
					player thread placeOnMinimap();
				}
				wait( 0.05 );
			}
		}
	}
}

placeOnMinimap()
{
	self notify( "placeOnMinimap" );
	self endon( "placeOnMinimap" );
	self endon ( "death" );
	self endon ( "disconnect" );
	
	if ( level.teamBased )
	{
		self setPerk( "specialty_radarblip", true, false );
	}
	
	wait (0.2);
	self.onMiniMap = false;
	self unsetPerk( "specialty_radarblip", true );
}

