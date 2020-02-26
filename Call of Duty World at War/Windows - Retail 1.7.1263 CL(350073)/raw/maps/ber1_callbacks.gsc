#include maps\_utility;
#include maps\ber1_util;
#include common_scripts\utility;

// Put any calls here that you want to happen when the FIRST player connects to the game
onFirstPlayerConnect()
{
	level waittill("connecting_first_player", player);
	
	player thread onPlayerDisconnect();
	player thread onPlayerSpawned();
	player thread onPlayerKilled();
}

// Put any calls here that you want to happen when the player connects to the game
onPlayerConnect()
{
	for(;;)
	{
		level waittill("connecting", player);

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	}
}

// Put any calls here that you want to happen when the player disconnects from the game
// This is a good place to do any clean up you need to do
onPlayerDisconnect()
{
	self waittill("disconnect");
	
	println("Player disconnected from the game.");
}

// Put any calls here that you want to happen when the player spawns
// This will happen every time the player spawns
onPlayerSpawned()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("spawned_player");
		self.drone_avoid = false;
		
		self setthreatbiasgroup("players");
		
		if(isdefined(level.startskip) && !level.startskip)
		{
			self thread AttachToTrain();
		}
		
	}
}

// Put any calls here that you want to happen when the player gets killed
onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill("killed_player");
	}
}

AttachToTrain()
{
	if (isdefined(level.players_linked_to_train) && level.players_linked_to_train)
	{
		index = 0;
		players = get_players();
		for(i = 0; i < players.size; i++)
		{
			if ( players[i] == self )
			{
				index = i;
				break;
			}
		}
		
		link_to_origin = level.train_attach_points[index];
		ASSERTEX( isdefined( link_to_origin ), "Could not locate script_origin train_player_link_origin" );

		self setorigin(link_to_origin.origin);
		self PlayerLinkTo( link_to_origin );
		
		self flag_wait("loadout_given");
		
		self allowSprint(false);
		self setMoveSpeedScale(0.9);
		self disableWeapons();
	}	
}