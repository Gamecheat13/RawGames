#include common_scripts\utility;
#include maps\_utility;

onFirstPlayerConnect()
{
	level waittill( "connecting_first_player", player );
	
	// put any calls here that you want to happen when the FIRST player connects to the game
	println( "First player connected to game." );
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill( "connecting", player );

		player thread onPlayerDisconnect();
		player thread onPlayerSpawned();
		player thread onPlayerKilled();
	
		// put any calls here that you want to happen when the player connects to the game
		println( "Player connected to game." );
	
//		player SetWeaponAmmoClip( "thompson", 0 );
//		player SetWeaponAmmoClip( "m1garand", 0 );
//		player SetWeaponAmmoStock( "thompson", 0 );
//		player setweaponammostock( "m1garand",0);
//		player setweaponammostock("fraggrenade",0);
//		player setweaponammoclip("fraggrenade",0);
//		player setweaponammostock("m8_white_smoke",0);
//		player setweaponammoclip("m8_white_smoke",0);
//		player setweaponammoclip("rocket_barrage",0);
//		player setweaponammostock("rocket_barrage",0);
//		player takeweapon("thompson");
//		player takeweapon("rocket_barrage");
		
	}
}

onPlayerDisconnect()
{
	self waittill( "disconnect" );
	
	// put any calls here that you want to happen when the player disconnects from the game
	// this is a good place to do any clean up you need to do
	println( "Player disconnected from the game." );
}

onPlayerSpawned()
{
	self endon( "disconnect" );	
	
	for(;;)
	{
		self waittill( "spawned_player" );
		self thread monitor_movement_speed();
		self thread maps\oki3_dpad_asset::airstrike_player_init();
	}
}

onPlayerKilled()
{
	self endon("disconnect");
	
	for(;;)
	{
		self waittill( "killed_player" );

		// put any calls here that you want to happen when the player gets killed
		//println( "Player killed at " + self.origin );
		
	}
}	

monitor_movement_speed()
{
	self endon("disconnect");
	
	level.old_player_move_speed = 180;
	while(1)
	{
		if(level.player_move_speed != level.old_player_move_speed )
		{
			self maps\oki3_util::set_player_speed( level.player_move_speed,5 );
			level.player_old_move_speed = level.player_move_speed;
		}
		wait(1);
	}
		
}