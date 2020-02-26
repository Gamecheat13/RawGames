/*-----------------------------------------------------
Status file for Okinawa 2
-----------------------------------------------------*/

main()
{
/#
	//event1();
	//event2();
	//event3();
#/
}

//
// syntax reminders:
// - scripter_task( name, days, percent, note )
// - scripter_subtask( name, days, percent, note )
// - scripter_microtask( name, days, percent, note )
//  (above is the same for builder_task, etc.)
// - task( type, name, main_task, sub_task, days, percent, note )


event1()
{
/#
	maps\_status::scripter_task( "Event 1", 5, 100);
		maps\_status::scripter_subtask( "Objectives", 5, 100,"done and working, but need to breadcrumb the objectives better" );
		maps\_status::scripter_subtask( "Gameplay", 5, 100);
		maps\_status::scripter_subtask( "IGC Camera", 5, 100 , "Done! MikeD!");
		maps\_status::scripter_subtask( "Animation", 5, 100 , "all temp anims are in except the IGC anims");
		maps\_status::scripter_subtask( "FX", 1, 0 , "nothing yet except the basics");
#/
}

event2()
{
/#
	maps\_status::scripter_task( "Event 2", 5, 90,"not all friendly chains set up in caves due to geo changes");
		maps\_status::scripter_subtask( "Objectives", 5,100 );
		maps\_status::scripter_subtask( "Gameplay", 5, 100 );
		maps\_status::scripter_subtask( "Animation", 5, 100,"nothing yet" );	
		maps\_status::scripter_subtask( "FX", 3,100, "nothing yet" );
#/
}

event3()
{
/#
	maps\_status::scripter_task( "Event 3", 5, 0 );
		maps\_status::scripter_subtask( "Objectives", 5,100 );
		maps\_status::scripter_subtask( "Gameplay", 5,90,"missing friendly chains in event 3" );
		maps\_status::scripter_subtask( "Animation", 1, 100,"nothing yet" );	
		maps\_status::scripter_subtask( "FX", 1, 100,"nothing yet" );
#/

}
