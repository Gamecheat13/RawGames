#include maps\_utility;
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
		maps\_status::scripter_task( "Event 1 - Insertion", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100);
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 0 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 100, 100 );
#/
}

event2()
{
/#
		maps\_status::scripter_task( "Event 2 – Fire Support", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );			
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 100, 100 );

#/
}

event3()
{
/#
		maps\_status::scripter_task( "Event 3 – The Raid", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}

event4()
{
/#
		maps\_status::scripter_task( "Event 4 - Bonsai Charge", 5, 100 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );	
		maps\_status::scripter_subtask( "FX (if applicable)", 1, 100 );
#/
}