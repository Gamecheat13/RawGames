init()
{
	// constants
	level.diary_event_invalid	= -1;
	level.diary_event_sniper	= 15;
	level.diary_event_ber2		= 16;
	level.diary_event_see1		= 17;
	
	level.diary_outcome_neutral = 0;
	level.diary_outcome_good	= 1;
	level.diary_outcome_evil	= 2;
	
	level thread diary_good_think();
	level thread diary_evil_think();
}


diary_good_think()
{
	level waittill( "pcg" );
	
	//println( "*** Client: diary_good_think received notify");
		
	event = diary_get_event_index();
		
	if ( event == level.diary_event_invalid )
	{
		return;
	}
			
	diary_save_outcome( event, level.diary_outcome_good );
}


diary_evil_think()
{
	level waittill( "pce" );
	
	//println( "*** Client: diary_evil_think received notify");
	
	event = diary_get_event_index();
		
	if ( event == level.diary_event_invalid )
	{
		return;
	}
			
	diary_save_outcome( event, level.diary_outcome_evil );
}


diary_get_event_index()
{
	index = level.diary_event_invalid;
	
	switch( GetDvar( "mapname" ) )
	{
		case "sniper":
			index = level.diary_event_sniper;
		break;
		
		case "ber2":
			index = level.diary_event_ber2;
		break;
		
		case "see1":
			index = level.diary_event_see1;
		break;
		
		default:
			assertmsg( "Unknown level for russian diary achievement: '" + GetDvar( "mapname" ) + "'" );
		break;
	}
	
	return index;
}


diary_save_outcome( event, outcome )
{
	if ( event == level.diary_event_invalid )
	{
		assertmsg( "Invalid russian diary event" );
		return;
	}
		
	if ( outcome != level.diary_outcome_good && outcome != level.diary_outcome_evil )
	{
		assertmsg( "Unknown russian diary outcome: '" + outcome + "'" );
		return;
	}
	
	SetPersistentProfileVar( event, outcome );
	println( "*** Client: Saving event: " + event + " With outcome: " + outcome );
	
	// and save it to the gamer profile
	UpdateGamerProfile( 0 );
	
	if( getlocalplayers().size > 1 )
	{
		clientscripts\_utility::splitscreen_populate_dvars( 1 );
		SetPersistentProfileVar( event, outcome );
		UpdateGamerProfile( 1 );
		clientscripts\_utility::splitscreen_restore_dvars();
		
		println( "*** Client: Saving splitscreen event: " + event + " With outcome: " + outcome );
	}
}


diary_award_think()
{
	alignment = level.diary_outcome_neutral;
	
	if ( GetDvar( "mapname" ) != "ber3b" )
	{
		// only award achievements on ber3b
		return alignment;
	}
	
	event1 = GetPersistentProfileVar( level.diary_event_sniper );
	println( "*** Client: sniper event is " + event1 );
	event2 = GetPersistentProfileVar( level.diary_event_ber2 );
	println( "*** Client: ber2 event is " + event2 );
	event3 = GetPersistentProfileVar( level.diary_event_see1 );
	println( "*** Client: see1 event is " + event3 );
	
	if ( event1 == level.diary_outcome_good && 
		 event2 == level.diary_outcome_good &&
		 event3 == level.diary_outcome_good )
	{
		alignment = level.diary_outcome_good;
	}
	
	if ( event1 == level.diary_outcome_evil && 
		 event2 == level.diary_outcome_evil &&
		 event3 == level.diary_outcome_evil )
	{
		alignment = level.diary_outcome_evil;
	}
	
	
	if( getlocalplayers().size > 1 )
	{
		clientscripts\_utility::splitscreen_populate_dvars( 1 );
		
		event1 = GetPersistentProfileVar( level.diary_event_sniper );
		println( "*** Splitscreen Client: sniper event is " + event1 );
		event2 = GetPersistentProfileVar( level.diary_event_ber2 );
		println( "*** Splitscreen Client: ber2 event is " + event2 );
		event3 = GetPersistentProfileVar( level.diary_event_see1 );
		println( "*** Splitscreen Client: see1 event is " + event3 );
		
		
		clientscripts\_utility::splitscreen_restore_dvars();
	}
	
	return alignment;
}
