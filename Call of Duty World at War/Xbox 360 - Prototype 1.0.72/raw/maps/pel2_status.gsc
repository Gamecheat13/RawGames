// Status Level File

main()
{
/#
	event1();
	event2();
	event3();
	event4();
#/
}

event1()
{
/#
	maps\_status::scripter_task( "Event1", 5, 10 );
		maps\_status::scripter_subtask( "Objectives", 1, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 15 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 0 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 0 );
#/
}

event2()
{
/#
	maps\_status::scripter_task( "Event2", 5, 10 );
		maps\_status::scripter_subtask( "Objectives", 1, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 20 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 0 );
#/
}

event3()
{
/#
	maps\_status::scripter_task( "Event3", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 15 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 0 );
#/
}

event4()
{
/#
	maps\_status::scripter_task( "Event4", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 0 );
		maps\_status::scripter_subtask( "Gameplay", 1, 0 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 0 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 0 );
#/
}

