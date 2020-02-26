// Test clientside script for ber3b

#include clientscripts\_utility;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\ber3b_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\ber3b_amb::main();	
		
	clientscripts\_vehicle::build_treadfx( "il2" );	// set up il2 for dust fx.
		
	thread diary_reading();
	
	// This needs to be called after all systems have been registered.
	thread waitforclient(0);
}

diary_reading()
{
	level waittill( "diaryreading_start" );
	
	// level is different for each client and the server
	level.readingDiary = true;
	
	player = GetLocalPlayers()[0];
	
	soundAlias = "diary_neutral";
	alignment = clientscripts\_russian_diary::diary_award_think();  // austin's hotness that gives the cheeve
	
	if( alignment == level.diary_outcome_good )
	{
		soundAlias = "diary_merciful";
	}
	else if( alignment == level.diary_outcome_evil )
	{
		soundAlias = "diary_merciless";
	}
	
	//println( "*** Client: Starting diary" );
	level.diaryID = PlaySound( 0, soundAlias, player.origin );
	level.pagesID = PlaySound( 0, "pages", player.origin );
	thread diary_reading_skip();
	
	while( SoundPlaying( level.diaryID ) && level.readingDiary )
	{
		wait( 0.1 );
	}
	
	// make sure it ended, if it didn't, it was skipped and we have to fade the clip out
	//println( "*** Client: Checking if diary was skipped" );
	if( SoundPlaying( level.diaryID ) )
	{
		fadeOutAndStopSound( level.diaryID, 0.25 );
		fadeOutAndStopSound( level.pagesID, 0.25 );
	}
	
	level notify( "diary_reading_stop" );
}

diary_reading_skip()
{
	//println( "*** Client: Starting diary skip thread" );
	
	level endon( "diary_reading_stop" );
	
	level waittill( "diary_skip" );
	
	//println( "*** Client: SKIPPING DIARY" );
	level.readingDiary = false;
}

fadeOutAndStopSound( id, time )
{
	//println( "*** Client: Fading sound out" );
	rate = 0;
	
	if( time != 0 )
	{
		rate = 1.0 / time;
	}

	SetSoundVolumeRate( id, rate );
	SetSoundVolume( id, 0.0 );

	while( GetSoundVolume( id ) > .0001 )
	{
		wait( 0.1 );
	}

	StopSound( id );
}
