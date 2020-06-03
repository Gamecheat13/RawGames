//
// file: ber2_status.gsc
// description: status output script for berlin2
// scripter: slayback
//
// syntax reminders:
// - scripter_task( name, days, percent, note )
// - scripter_subtask( name, days, percent, note )
// - scripter_microtask( name, days, percent, note )
//
// to show, change status_show dvar:
// - status_show [scripter]/[builder]
// - status_show off
//

build_status()
{
/#
	event1();
	event2();
	event3();
#/
}

event1()
{
/#
	maps\_status::scripter_task( "Event_1", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "IGC Camera", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100 );
		maps\_status::scripter_subtask( "FX", 1, 100, "Can't think of any scripted FX for this event." );
#/
}

event2()
{
/#
	maps\_status::scripter_task( "Event_2", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 0, "Waiting for second pass on flame trap to implement anims" );	
		maps\_status::scripter_subtask( "FX", 1, 100, "Waiting on arty dust clouds & water fx" );
#/
}

event3()
{
/#
	maps\_status::scripter_task( "Event_3", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 1, 100 );
		maps\_status::scripter_subtask( "Gameplay", 1, 100 );
		maps\_status::scripter_subtask( "Animation", 1, 100, "Waiting on crewed arty anims." );	
		maps\_status::scripter_subtask( "FX", 1, 100, "sbmodel swaps from tank firing not blocked in yet." );
#/
}