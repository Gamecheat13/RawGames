main()
{
	// create a view position entity and spawn the player at it as a spectator, then lock their view
	
	game["menu_main"] = "background_main";
	precacheMenu(game["menu_main"]);

	level.callbackStartGameType = ::void;
	level.callbackPlayerDisconnect = ::void;
	level.callbackPlayerDamage = ::void;
	level.callbackPlayerKilled = ::void;
	level.callbackPlayerConnect = ::Callback_PlayerConnect;

	level.xenon = (getdvar("xenonGame") == "true"); // for lack of a better place to put it
	setDvar( "ui_gametype_text", "@MP_TEAM_HARDPOINT" );	//TEMP
	maps\mp\gametypes\_hud::init();
	maps\mp\_menus::init();
}

Callback_PlayerConnect()
{
	self waittill( "begin" );
	level notify( "connected", self );

	if( !isdefined( level.hasSpawned ) )
	{
		spawnOrigin = (-125, -223, -56);
		spawnAngles = (0, 30, 0);
		self spawn( spawnOrigin, spawnAngles );

		level.hasSpawned = true;
		level.player = self;
	}
	else
		kick(self.name);
}

void()
{
}