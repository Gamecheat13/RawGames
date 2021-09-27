
TEDDY_DROP_WAIT = 180;
TEDDY_LIFE = 30;

main()
{
	maps\mp\mp_carbon_precache::main();
	maps\createart\mp_carbon_art::main();
	maps\mp\mp_carbon_fx::main();
	maps\mp\_explosive_barrels::main();

	maps\mp\_load::main();
	
	AmbientPlay( "ambient_mp_carbon" );
	
	maps\mp\_compass::setupMiniMap( "compass_map_mp_carbon" );	
	
	setdvar( "r_lightGridEnableTweaks", 1 );
	setdvar( "r_lightGridIntensity", 1.33 );
	
	if ( level.ps3 )
		setdvar( "sm_sunShadowScale", "0.5" ); // ps3 optimization
	else
		setdvar( "sm_sunShadowScale", "0.8" ); // optimization
	
	game["attackers"] = "allies";
	game["defenders"] = "axis";

	audio_settings();
	
	precacheModel( "com_teddy_bear" );	
	level thread teddyDropper();
}

audio_settings()
{
//	maps\mp\_audio::add_reverb( "name", "room type", wetlevel, drylevel, fadetime )
	maps\mp\_audio::add_reverb( "default", "mountains", 0.2, 0.9, 2 );
}

teddyDropper()
{
	level endon ( "game_ended" );
	
	teddySpawner = common_scripts\utility::getStruct( "teddy_1", "targetname" );
	
	while ( true )
	{
		wait( TEDDY_DROP_WAIT );
						
		teddy = spawn( "script_model", teddySpawner.origin );	
		teddy setModel( "com_teddy_bear" );
		teddy.angles = ( (0,0,0) + (RandomInt(360),RandomInt(360),RandomInt(360)) );
		teddy show();
		
		teddy PhysicsLaunchServer();		
		teddy thread teddyPhysicsWaiter();
	}
}

teddyPhysicsWaiter()
{
	self waittill( "physics_finished" );

	level thread teddyTimeOut( self );
		
	if ( abs(self.origin[2] - level.lowSpawn.origin[2]) > 3000 )
	{
		self delete();	
	}	
}

teddyTimeOut( teddy )
{
	level endon ( "game_ended" );
	teddy endon( "death" );
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( TEDDY_LIFE );

	teddy delete();	
}
