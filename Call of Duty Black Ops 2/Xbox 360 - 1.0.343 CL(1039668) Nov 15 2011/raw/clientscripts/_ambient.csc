#include clientscripts\_utility;
#include clientscripts\_utility_code;




init(local_client_num)
{
	clocks_init(local_client_num);
}

clocks_init(clientNum)
{
	// the format should be an array (hour, min, sec), military time
	//	if we pass in a 1 then we'll get GMT 0 London time, else we get the local time on the kit
	curr_time = GetSystemTime();

	// put the hands in the right place
	hours = curr_time[0];
	if( hours > 12 )
	{
		hours -= 12;
	}
	if( hours == 0 )
	{
		hours = 12;
	}
	minutes = curr_time[1];
	seconds = curr_time[2];
	
	// set the starting time
	// hoping that all of the hands start pointing straight up at 12
	// each hour is 30 degrees of rotation ...
	//	it should also rotate a little bit each time the minute hand moves
	//	the math is 30 degrees of rotations in 3600 seconds (1 hour)
	hour_hand = GetEntArray(clientNum, "hour_hand", "targetname");
	hour_values = [];
	hour_values["hand_time"] = hours;
	hour_values["rotate"] = 30;
	hour_values["rotate_bit"] = 30 / 3600;
	// we need to do the first rotation based on the beginning time, if we don't do this the time will look like it's off a little bit
	hour_values["first_rotate"] = ((minutes * 60) + seconds) * hour_values["rotate_bit"];
	
	// each minute is 6 degrees of rotation ...
	//	it should also rotate a little bit each time the second hand moves
	//	the math is 6 degrees of rotations in 60 seconds (1 minute)
	minute_hand = GetEntArray(clientNum, "minute_hand", "targetname");
	minute_values = [];
	minute_values["hand_time"] = minutes;
	minute_values["rotate"] = 6;
	minute_values["rotate_bit"] = 6 / 60;
	// we need to do the first rotation based on the beginning time, if we don't do this the time will look like it's off a little bit
	minute_values["first_rotate"] = seconds * minute_values["rotate_bit"];

	// each second is 6 degrees of rotation
	second_hand = GetEntArray(clientNum, "second_hand", "targetname");
	second_values = [];
	second_values["hand_time"] = seconds;
	second_values["rotate"] = 6;
	second_values["rotate_bit"] = 6;

	hour_hand_array = GetEntArray(clientNum, "hour_hand", "targetname");
	if( IsDefined(hour_hand_array) )
	{
		println("**********hour_hand_array is defined, size: " + hour_hand_array.size);
		array_thread( hour_hand_array, ::clock_run, hour_values );
	}
	minute_hand_array = GetEntArray(clientNum, "minute_hand", "targetname");
	if( IsDefined(minute_hand_array) )
	{
		println("**********minute_hand_array is defined, size: " + minute_hand_array.size);
		array_thread( minute_hand_array, ::clock_run, minute_values );
	}
	second_hand_array = GetEntArray(clientNum, "second_hand", "targetname");
	if( IsDefined(second_hand_array) )
	{
		println("**********second_hand_array is defined, size: " + second_hand_array.size);
		array_thread( second_hand_array, ::clock_run, second_values );
	}

}

clock_run(time_values) // self == either hour hand, minute hand, or second hand
{
	self endon("entityshutdown");

	// hour hands will have script_noteworthy = time zone if they want a different time zone
	if( IsDefined(self.script_noteworthy) )
	{
		hour = time_values["hand_time"];
		curr_time = GetSystemTime(1);

		switch( ToLower(self.script_noteworthy) )
		{
		case "honolulu":	// GMT -10
			hour = curr_time[0] - 10;
			break;
		case "alaska":		// GMT -9
			hour = curr_time[0] - 9;
			break;
		case "los angeles":	// GMT -8
			hour = curr_time[0] - 8;
			break;
		case "denver":		// GMT -7
			hour = curr_time[0] - 7;
			break;
		case "chicago":		// GMT -6
			hour = curr_time[0] - 6;
			break;
		case "new york":	// GMT -5
			hour = curr_time[0] - 5;
			break;
		case "halifax":		// GMT -4
			hour = curr_time[0] - 4;
			break;
		case "greenland":	// GMT -3
			hour = curr_time[0] - 3;
			break;
		case "london":		// GMT 0
			hour = curr_time[0];
			break;
		case "paris":		// GMT +1
			hour = curr_time[0] + 1;
			break;
		case "helsinki":	// GMT +2
			hour = curr_time[0] + 2;
			break;
		case "moscow":		// GMT +3
			hour = curr_time[0] + 3;
			break;
		case "china":		// GMT +8
			hour = curr_time[0] + 8;
			break;
		}

		if( hour < 1 )
		{
			hour += 12;
		}
		if( hour > 12 )
		{
			hour -= 12;
		}
		time_values["hand_time"] = hour;
	}

	while( !ClientHasSnapshot(0))
	{
		wait(0.1);
	}

	self RotatePitch(time_values["hand_time"] * time_values["rotate"], 0.05);
	self waittill("rotatedone");

	while( !ClientHasSnapshot(0))
	{
		wait(0.1);
	}
	
	if( IsDefined(time_values["first_rotate"]) )
	{
		self RotatePitch(time_values["first_rotate"], 0.05);
		self waittill("rotatedone");
	}

	prev_time = GetSystemTime();

	while(true)
	{
		curr_time = GetSystemTime();
		if( prev_time != curr_time )
		{
			while( !ClientHasSnapshot(0))
			{
				wait(0.1);
			}


			self RotatePitch(time_values["rotate_bit"], 0.05);

			prev_time = curr_time;
		}

		wait(1.0);
	}
}
