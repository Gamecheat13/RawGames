#include maps\mp\_utility;

init()
{
	if ( level.onlineGame )
	{
		level thread onPlayerSpawned();
		level thread onPlayerConnect();
	}
}

onPlayerConnect()
{
	for ( ;; )
	{
		level waittill( "connecting", player );
		//this could be more efficient... check for fireTeam
		player thread initTeamSpawnElements();
	}
}

onPlayerSpawned()
{
	level endon("game_ended");
	
	for(;;)
	{
		level waittill( "player_spawned", player );
		
		if ( IsAI( player ) )
			continue;

		player.partnerSpawning = false;
		
		if ( isDefined( player.isInFireTeam ) )
		    continue;
		else
		{
			player.firstSpawn = false;
			
			player.fireTeamMembers = player getFireteamMembers();
			
			if ( player.fireTeamMembers.size > 0 && player.fireTeamMembers.size < 2 )
			{
				player.isInFireTeam = true;
				player.partner = player.fireTeamMembers[0];
			}
			else
			{
				player.isInFireTeam = false;
			}
		}
	}
}


initTeamSpawnElements()
{
	if ( !isDefined( self.kc_teamSpawnText ) )
	{
		self.kc_teamSpawnText = newClientHudElem(self);
		self.kc_teamSpawnText.archived = false;		
		self.kc_teamSpawnText.y = 34;
		self.kc_teamSpawnText.alignX = "left";
		self.kc_teamSpawnText.alignY = "top";
		self.kc_teamSpawnText.horzAlign = "center";
		self.kc_teamSpawnText.vertAlign = "middle";
		self.kc_teamSpawnText.sort = 10; // force to draw after the bars
		self.kc_teamSpawnText.font = "small";
		self.kc_teamSpawnText.foreground = true;
		self.kc_teamSpawnText.hideWhenInMenu = true;
		
		if ( level.splitscreen )
		{
			self.kc_teamSpawnText.x = 16;
			self.kc_teamSpawnText.fontscale = 1.2;
		}
		else
		{
			self.kc_teamSpawnText.x = 62;
			self.kc_teamSpawnText.fontscale = 1.6;
		}
	}
	
	if ( !isDefined( self.kc_randomSpawnText ) )
	{
		self.kc_randomSpawnText = newClientHudElem(self);
		self.kc_randomSpawnText.archived = false;		
		self.kc_randomSpawnText.y = 58;
		self.kc_randomSpawnText.alignX = "left";
		self.kc_randomSpawnText.alignY = "top";
		self.kc_randomSpawnText.horzAlign = "center";
		self.kc_randomSpawnText.vertAlign = "middle";
		self.kc_randomSpawnText.sort = 10; // force to draw after the bars
		self.kc_randomSpawnText.font = "small";
		self.kc_randomSpawnText.foreground = true;
		self.kc_randomSpawnText.hideWhenInMenu = true;
		
		if ( level.splitscreen )
		{
			self.kc_randomSpawnText.x = 16;
			self.kc_randomSpawnText.fontscale = 1.2;
		}
		else
		{
			self.kc_randomSpawnText.x = 62;
			self.kc_randomSpawnText.fontscale = 1.6;
		}
	}
}

fireTeamWait( onScreenMessage )
{
	self setLowerMessage( "waiting_info", onScreenMessage, undefined, undefined, undefined, undefined, undefined, undefined, true ); 
	self.clearFireTeamMessage = true;   			
    wait( 1.0 );
}