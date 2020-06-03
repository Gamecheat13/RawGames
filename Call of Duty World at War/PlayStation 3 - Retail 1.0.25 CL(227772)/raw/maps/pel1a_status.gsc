#include maps\_utility;
main()
{
/#
	event3();
	event4();

	#/
}

event3()
{
/#
		maps\_status::scripter_task( "Event 3 - Mortar Teams", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}

event4()
{
/#
		maps\_status::scripter_task( "Event 4 - The Road", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}
