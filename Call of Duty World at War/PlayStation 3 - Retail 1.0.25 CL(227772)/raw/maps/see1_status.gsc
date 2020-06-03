// Status Level File

main()
{
	event1();
	event2();
	event3();
	event4();
	event5();
}

event1()
{
	maps\_status::scripter_task( "Event1", 5, 0, "" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "IGC Camera", 1, 0, "not yet implemented" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}

event2()
{
	maps\_status::scripter_task( "Event2", 5, 100, "done" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}

event3()
{
	maps\_status::scripter_task( "Event3", 5, 90, "need IGC" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "IGC Camera", 1, 0, "not yet implemented" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}

event4()
{
	maps\_status::scripter_task( "Event4", 5, 90, "need IGC" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "IGC Camera", 1, 0, "not yet implemented" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}

event5()
{
	maps\_status::scripter_task( "Event5", 5, 90, "need IGC" );
		maps\_status::scripter_subtask( "Objectives", 1, 100, "done" );
		maps\_status::scripter_subtask( "Gameplay", 1, 100, "done" );
		maps\_status::scripter_subtask( "IGC Camera", 1, 0, "not yet implemented" );
		maps\_status::scripter_subtask( "Animation", 1, 100, "no canned animations" );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100, "no level specific fx yet" );
}

