// Progress Tracker/Reporter
scripter_task( name, days, percent, note )
{
	task( "scripter", name, undefined, undefined, days, percent, note );
	level.current_task = name;
}

scripter_subtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call scripter_task() before you can call script_subtask()" );
		return;
	}

	task( "scripter", name, level.current_task, undefined, days, percent, note );
	level.current_subtask = name;
}

scripter_microtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call script_task() before you can call scripter_microtask()" );
		return;
	}

	if( !IsDefined( level.current_subtask ) )
	{
		assertmsg( "You must call scripter_subtask() before you can call scripter_microtask()" );
		return;
	}

	task( "scripter", name, level.current_task, level.current_subtask, days, percent, note );
}

builder_task( name, days, percent, note )
{
	task( "builder", name, undefined, undefined, days, percent, note );
	level.current_task = name;
}

builder_subtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call builder_task() before you can call builder_subtask()" );
		return;
	}

	task( "builder", name, level.current_task, undefined, days, percent, note );
	level.current_subtask = name;
}

builder_microtask( name, days, percent, note )
{
	if( !IsDefined( level.current_task ) )
	{
		assertmsg( "You must call builder_task() before you can call builder_microtask()" );
		return;
	}

	if( !IsDefined( level.current_subtask ) )
	{
		assertmsg( "You must call builder_subtask() before you can call builder_microtask()" );
		return;
	}

	task( "builder", name, level.current_task, level.current_subtask, days, percent, note );
}

task( type, name, main_task, sub_task, days, percent, note )
{
/#
	if( !IsDefined( level._status_export_thread_started ) )
	{
		level._status_export_thread_started = true;
		level thread export_status_thread();
	}


	if( !IsDefined( level._task_start_date ) )
	{
		script = Tolower( GetDvar( "mapname" ) ); 

		switch( level.script )
		{
			case "trn":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "mak":
				level._task_start_date = "May 28 2007";
				level._task_milestone_date = "Jun 22 2007";
				break;
	
			case "pel1":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "pel2":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "fly":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "hol1":
				level._task_start_date = "May 28 2007";
				level._task_milestone_date = "Jun 22 2007";
				break;
	
			case "hol2":
				level._task_start_date = "May 28 2007";
				level._task_milestone_date = "Jun 22 2007";
				break;
	
			case "hol3":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "see1":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "see2":
				level._task_start_date = "May 28 2007";
				level._task_milestone_date = "Jun 22 2007";
				break;
	
			case "see3":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "rhi1":
				level._task_start_date = "May 28 2007";
				level._task_milestone_date = "Jun 22 2007";
				break;
	
			case "rhi2":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "rhi3":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "oki1":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "oki2":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "oki3":
				level._task_start_date = "Jun 25 2007";
				level._task_milestone_date = "Jul 20 2007";
				break;
	
			case "ber1":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "ber2":
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
	
			case "ber3":
				level._task_start_date = "May 28 2007";
				level._task_milestone_date = "Jun 22 2007";
				break;
	
			default:
				level._task_start_date = "Apr 30 2007";
				level._task_milestone_date = "May 25 2007";
				break;
		}
	}

	if( !IsDefined( level._tasks ) )
	{
		level._tasks = [];
	}

	if( !IsDefined( level._tasks[type] ) )
	{
		level._tasks[type] = [];
	}

	if( !IsDefined( note ) )
	{
		note = "";
	}

	// Store info to array, so we just have to set it to a level var.
	array = [];
	array["name"] = name;
	array["days"] = days;
	array["percent"] = percent;
	array["notes"] = note;
	array["sub_tasks"] = [];
	array["display"] = name + " (" + percent + " percent)";

	array["start_day"] = date_to_day( level._task_start_date );

	array["start_date"] = day_to_date( array["start_day"] );

	array["due_day"] = get_due_day( array["start_day"], days );
	array["due_date"] = day_to_date( array["due_day"] );

	if( IsDefined( main_task ) )
	{
		if( IsDefined( sub_task ) )
		{
			// Add the microtask to the sub_task
			// Find the sub_task index
			size = level._tasks[type][main_task]["sub_tasks"].size;
			for( i = 0; i < size; i++ )
			{
				if( level._tasks[type][main_task]["sub_tasks"][i]["name"] == sub_task )
				{
					size2 = level._tasks[type][main_task]["sub_tasks"][i]["sub_tasks"].size;

					// DO NOT INCLUDE A DAYS for MICRO TASKS!
					array["days"] = -1;

					level._tasks[type][main_task]["sub_tasks"][i]["sub_tasks"][size2] = array;
					break;
				}
			}

			update_percent( type, main_task, sub_task );
		}
		else
		{
			// Add the subtask to the main_task
			size = level._tasks[type][main_task]["sub_tasks"].size;
			level._tasks[type][main_task]["sub_tasks"][size] = array;

			update_percent( type, main_task );
			update_days( type, main_task );
		}

	}
	else
	{
		level._tasks[type][name] = array;

		if( !IsDefined( level._tasks[type]["all_tasks"] ) )
		{
			level._tasks[type]["all_tasks"] = [];
		}

		size = level._tasks[type]["all_tasks"].size;
		level._tasks[type]["all_tasks"][size] = name;


		if( !IsDefined( level._task_types ) )
		{
			level._task_types = [];
		}

		if( check_for_dupes( level._task_types, type ) )
		{
			size = level._task_types.size;
			level._task_types[size] = type;
		}
	}
#/
}

update_percent( type, main_task, sub_task )
{
/#
	if( IsDefined( sub_task ) )
	{
		index = undefined;
		size = level._tasks[type][main_task]["sub_tasks"].size;
		for( i = 0; i < size; i++ )
		{
			if( level._tasks[type][main_task]["sub_tasks"][i]["name"] == sub_task )
			{
				index = i;
				break;
			}
		}

		size = level._tasks[type][main_task]["sub_tasks"][index]["sub_tasks"].size;
		accum = 0;
		for( i = 0; i < size; i++ )
		{
			accum += level._tasks[type][main_task]["sub_tasks"][index]["sub_tasks"][i]["percent"];
	
		}

		percent = accum / size;
		level._tasks[type][main_task]["sub_tasks"][index]["percent"] = percent;
		level._tasks[type][main_task]["sub_tasks"][index]["display"] = level._tasks[type][main_task]["sub_tasks"][index]["name"] + " (" + percent + " percent)";		
	}

	size = level._tasks[type][main_task]["sub_tasks"].size;
	accum = 0;
	for( i = 0; i < size; i++ )
	{
		accum += level._tasks[type][main_task]["sub_tasks"][i]["percent"];
	}

	percent = accum / size;
	level._tasks[type][main_task]["percent"] = percent;
	level._tasks[type][main_task]["display"] = level._tasks[type][main_task]["name"] + " (" + percent + " percent)";
#/
}

update_days( type, main_task )
{
/#
	size = level._tasks[type][main_task]["sub_tasks"].size;
	accum = 0;
	for( i = 0; i < size; i++ )
	{
		accum += level._tasks[type][main_task]["sub_tasks"][i]["days"];
	}

	level._tasks[type][main_task]["days"] = accum;

	set_start_day( type, main_task );

	level._tasks[type][main_task]["start_date"] = day_to_date( level._tasks[type][main_task]["start_day"] );

	level._tasks[type][main_task]["due_day"] = get_due_day( level._tasks[type][main_task]["start_day"], level._tasks[type][main_task]["days"] );
	level._tasks[type][main_task]["due_date"] = day_to_date( level._tasks[type][main_task]["due_day"] );

#/
}

set_start_day( type, main_task )
{
	index = -1;
	if( IsDefined( level._tasks[type]["all_tasks"] ) )
	{
		size = level._tasks[type]["all_tasks"].size;
		for( i = 0; i < size; i++ )
		{
			if( level._tasks[type]["all_tasks"][i] == main_task )
			{
				index = i;
				break;
			}
		}
	}

	// Figure out the previous task finish date.
	if( index > 0 )
	{
		previous_name = level._tasks[type]["all_tasks"][index - 1];

		level._tasks[type][main_task]["start_day"] = date_to_day( level._tasks[type][previous_name]["due_date"] ) + 1;

		while( is_day_off( level._tasks[type][main_task]["start_day"] ) )
		{
			level._tasks[type][main_task]["start_day"]++;
		}
	}
	else
	{
		level._tasks[type][main_task]["start_day"] = date_to_day( level._task_start_date );
	}
}

show_task( name )
{
/#
	level thread show_task_thread( name );
#/
}

show_task_thread( name )
{
/#
	level notify( "stop_show_task" );
	level endon( "stop_show_task" );

	if( GetDvar( "status_show" ) == "" )
	{
		SetDvar( "status_show", "off" );
	}

	if( IsDefined( level._status_current_hud ) )
	{
		remove_hud( level._status_current_hud );
	}

	if( !IsDefined( level._status_export_thread_started ) )
	{
		level._status_export_thread_started = true;
		level thread export_status_thread();
	}

	old_type = "none";
	old_dvar = "none";
	while( 1 )
	{
		if( old_type != GetDvar( "status_show" ) )
		{
			type = GetDvar( "status_show" );

			if( type != "off" )
			{
				if( !IsDefined( level._tasks[type] ) )
				{
					println( "^1_status PRINT: '" + type + "' is not specified as a task type." );
					SetDvar( "status_show", "scripter" );
					wait( 0.25 );
					continue;
				}
	
				if( !IsDefined( level._tasks[type][name] ) )
				{
					assertmsg( "_status ASSERT: '" + name + "' name is not specified for the given task type, '" + type + "'" );
					SetDvar( "status_show", "scripter" );
					wait( 0.25 );
					continue;
				}
			}

			if( IsDefined( level._status_current_hud ) )
			{
				remove_hud( level._status_current_hud );
			}

			old_type = type;

			if( type == "off" )
			{
				continue;
			}

			x = 10;
			level._status_y = 80;
			level._status_current_hud = name;

			// Status, Start Date, Days Remaining, Overall Status
			start_date = "Start Date: " + level._tasks[type][name]["start_date"];
			new_hud( name, start_date, x, level._status_y - 60 );

			start_date = "Due Date: " + level._tasks[type][name]["due_date"];
			new_hud( name, start_date, x, level._status_y - 48 );

			status = "Status: ";
			new_hud( name, status, x, level._status_y - 36 );

			show_status( type, name, x );

//			level._tasks[type][name]["display"] = level._tasks[type][name]["display"] + " (Days: " + level._tasks[type][name]["days"] + ")";
			new_hud( name, level._tasks[type][name]["display"], x, level._status_y, undefined, hud_color( level._tasks[type][name]["percent"] ) );
		
			show_subtasks( name, level._tasks[type][name]["sub_tasks"], x );
		}

		wait( 1 );
	}
#/
}

show_status( type, name, x )
{
	quote = get_status_quote( type, name );

	color = ( 1, 1, 1 );
	if( quote == "On Schedule" )
	{
		color = ( 0, 1, 0 );
	}
	else if( quote == "Ahead of Schedule" )
	{
		color = ( 0, 1, 0 );
	}
	else if( quote == "A Bit Behind Schedule" )
	{
		color = ( 1, 1, 0 );
	}
	else if( quote == "Behind Schedule" )
	{
		color = ( 1, 0, 0 );
	}
	else if( quote == "COMPLETED" )
	{
		color = ( 0, 1, 0 );
	}

	new_hud( name, quote, x + 35, level._status_y - 36, undefined, color );		

	days = level._tasks[type][name]["days"]; // How long it will take to finish.
	days_remaining = days_remaining( level._tasks[type][name]["start_day"], days );
	expected_percent = 100 - ( ( 100 / days ) * days_remaining ); // Daily work percent for this task.

	expected = "Expected Percent: " + expected_percent;
	new_hud( name, expected, x, level._status_y - 24 );

	days_remaining_string = "Days Remaining: " + days_remaining;
	new_hud( name, days_remaining_string, x, level._status_y - 12 );
}

get_status_quote( type, name )
{
	quote = "SHOULD NOT SEE THIS!";

	percent = level._tasks[type][name]["percent"];

	if( percent < 100 )
	{
		days = level._tasks[type][name]["days"]; // How long it will take to finish.
		days_remaining = days_remaining( level._tasks[type][name]["start_day"], days );
		expected_percent = 100 - ( ( 100 / days ) * days_remaining ); // Daily work percent for this task.

		diff = percent - expected_percent;
		if( expected_percent < 0 || abs( diff ) < 10 ) // < 0 means more than 100 percent.
		{
			quote = "On schedule";
		}
		else if( percent > expected_percent )
		{
			quote = "Ahead of Schedule";
		}
		else if( percent < expected_percent )
		{
			if( diff > -20 )
			{
				quote = "A Bit Behind Schedule";
			}
			else
			{
				quote = "Behind Schedule";
			}
		}
	}
	else
	{
		quote = "COMPLETED";
	}

	return quote;
}

days_remaining( start_day, days )
{
/#
	date = GetDate();

	curr_day_num = date_to_day( date );
	days_remaining = ( start_day + days ) - curr_day_num;

	return days_remaining;
#/
}

date_to_day( date )
{
/#
	new_str = "";
	i_start = 0;
	count = 0;
	for( i = 0; i < date.size; i++ )
	{
		if( date[i] == " " )
		{
			count++;

			if( count == 2 )
			{
				break;
			}
			continue;
		}
	
		if( count == 1 )
		{
			new_str = new_str + date[i];
		}
	}

	day_num = int( new_str );
	month_num = get_month_number( date );

	year_day = 0;
	for( i = 1; i < month_num; i++ )
	{
		year_day += month_days( i );
	}

	year_day += day_num;

	return year_day;
#/
}

get_due_day( start_day, days )
{
/#
	due_day = start_day + ( days - 1 ); // Minus 1, since we actually start on the morning of the start_day.

//println( "^3BEFORE DUE DAY = ", due_day );
	for( i = 0; i < days; i++ )
	{
		if( is_day_off( start_day + i ) )
		{
			due_day += 1;
			days += 1;
		}
	}

//println( "^3AFTER DUE DAY = ", due_day );
	return due_day;
#/
}

get_estimated_due_date( type )
{
/#
	size = level._tasks[type]["all_tasks"].size;
	last_task = level._tasks[type]["all_tasks"][size - 1];
	return level._tasks[type][last_task]["due_date"];
#/
}

is_day_off( day )
{
/#
	day_off = false;
	// Check weekends
	the_mod = day % 7;

	if( the_mod == 6 ) // Saturday
	{
//println( "Saturday" );
		day_off = true;
	}
	else if( the_mod == 0 ) // Sunday
	{
//println( "Sunday" );
		day_off = true;
	}

	return day_off;
#/
}

day_to_date( day, just_day_number )
{
/#
	if( !IsDefined( just_day_number ) )
	{
		just_day_number = false;
	}

	year = get_year();

	while( 1 )
	{
		if( day > days_in_year( year ) )
		{
			day = day - days_in_year( year );
			year++;
		}
		else
		{
			break;
		}
	}

	date = 1; // Start Jan 1
	date_string = "";
	for( i = 1; i < 13; i++ )
	{
		if( day > days_in_year( get_year() ) )
		{
			date_string = date_string + get_month_string( i ) + " " + day + " " + year;
		}
		else
		{
			if( day > month_days( i ) )
			{
				day -= month_days( i );
			}
			else
			{
				date_string = date_string + get_month_string( i ) + " " + day + " " + year;

				if( just_day_number )
				{
					return day;
				}
				else
				{
					return date_string;
				}
			}
		}
	}

	return "BUG!";
#/
}

get_month_number( date )
{
/#
	new_str = "";
	for( i = 0; i < 3; i++ )
	{
		new_str = new_str + date[i];
	}

	num = -1;

	if( new_str == "Jan" )
	{
		return 1;
	}
	else if( new_str == "Feb" )
	{
		return 2;
	}
	else if( new_str == "Mar" )
	{
		return 3;
	}
	else if( new_str == "Apr" )
	{
		return 4;
	}
	else if( new_str == "May" )
	{
		return 5;
	}
	else if( new_str == "Jun" )
	{
		return 6;
	}
	else if( new_str == "Jul" )
	{
		return 7;
	}
	else if( new_str == "Aug" )
	{
		return 8;
	}
	else if( new_str == "Sep" )
	{
		return 9;
	}
	else if( new_str == "Oct" )
	{
		return 10;
	}
	else if( new_str == "Nov" )
	{
		return 11;
	}
	else if( new_str == "Dec" )
	{
		return 12;
	}
#/
}

get_month_string( num )
{
/#
	if( num == 1 )
	{
		return "Jan";
	}
	else if( num == 2 )
	{
		return "Feb";
	}
	else if( num == 3 )
	{
		return "Mar";
	}
	else if( num == 4 )
	{
		return "Apr";
	}
	else if( num == 5 )
	{
		return "May";
	}
	else if( num == 6 )
	{
		return "Jun";
	}
	else if( num == 7 )
	{
		return "Jul";
	}
	else if( num == 8 )
	{
		return "Aug";
	}
	else if( num == 9 )
	{
		return "Sep";
	}
	else if( num == 10 )
	{
		return "Oct";
	}
	else if( num == 11 )
	{
		return "Nov";
	}
	else if( num == 12 )
	{
		return "Dec";
	}
#/
}

days_in_year( year )
{
/#
	if( is_leapyear( year ) )
	{
		return 366;
	}
	
	return 365;
#/
}

month_days( month_num )
{
/#
	if( month_num < 8 )
	{
		if( month_num % 2 )
		{
			// Odd Months
			return 31;
		}
		else
		{
			// Even Months
			if( month_num == 2 )
			{
				if( is_leapyear() )
				{
					return 29;
				}
				else
				{
					return 28;
				}
			}
			return 30;
		}
	}
	else
	{
		if( !( month_num % 2 ) ) // August and on have 31 days.
		{
			// Odd Months
			return 31;
		}
		else
		{
			// Even Months
			if( month_num == 2 )
			{
				if( is_leapyear() )
				{
					return 29;
				}
				else
				{
					return 28;
				}
			}
			return 30;
		}
	}
#/
}

is_leapyear( year )
{
/#
	if( !IsDefined( year ) )
	{
		date = GetDate();
		year = get_year();
	}

	if( year & 4 == 1 )
	{
		return true;
	}

	return false;
#/
}

get_year()
{
/#
	date = GetDate();

	new_str = "";
	count = 2;
	for( i = 0; i < date.size; i++ )
	{
		if( date[i] == " " && count > 0 )
		{
			count--;
			continue;
		}

		if( count == 0 )
		{
			new_str = new_str + date[i];
		}
	}

	return int( new_str );
#/
}

show_subtasks( hud_name, sub_tasks, x )
{
/#
	x += 25;
	if( IsDefined( sub_tasks ) && sub_tasks.size > 0 )
	{
		for( i = 0; i < sub_tasks.size; i++ )
		{
			level._status_y += 12;
//			sub_tasks[i]["display"] = sub_tasks[i]["display"] + " (Days: " + sub_tasks[i]["days"] + ")";
			new_hud( hud_name, sub_tasks[i]["display"], x, level._status_y, undefined, hud_color( sub_tasks[i]["percent"] ) );
			show_subtasks( hud_name, sub_tasks[i]["sub_tasks"], x );
		}
	}
#/
}

new_hud( hud_name, msg, x, y, scale, color )
{
/#
	if( !IsDefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !IsDefined( level.hud_array[hud_name] ) )
	{
		level.hud_array[hud_name] = [];
	}

	hud = set_hudelem( msg, x, y, scale, undefined, color );
	level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
	return hud;
#/
}

hud_color( percent )
{
/#
	if( percent > 80 )
	{
		color = ( 0, 1, 0 );
	}
	else if( percent < 40 )
	{
		color = ( 1, 0, 0 );
	}
	else // Everything inbetween
	{
		color = ( 1, 1, 0 );
	}

	return color;
#/
}

remove_hud( hud_name )
{
/#
	if( !IsDefined( level.hud_array[hud_name] ) )
	{
		return;
	}

	huds = level.hud_array[hud_name];
	for( i = 0; i < huds.size; i++ )
	{
		destroy_hud( huds[i] );
	}

	level.hud_array[hud_name] = undefined;
#/
}

destroy_hud( hud )
{
/#
	if( IsDefined( hud ) )
	{
		hud Destroy();
	}
#/
}


//------------------------------------------------------//
// set_hudelem( [text], x, y, [scale], [alpha], [color] )//
//		Actually creates the hudelem					//
//------------------------------------------------------//
// self		- n/a										//
// text		- The text to be displayed					//
// x		- Sets the x position of the hudelem		//
// y		- Sets the y position of the hudelem		//
// scale	- Sets the scale of the hudelem				//
// alpha	- Sets the alpha of the hudelem				//
// color	- Sets the color of the hudelem				//
//------------------------------------------------------//
set_hudelem( text, x, y, scale, alpha, color )
{
/#
	if( !IsDefined( alpha ) )
	{
		alpha = 1;
	}

	if( !IsDefined( scale ) )
	{
		scale = 1;
	}

	if( !IsDefined( color ) )
	{
		color = ( 1, 1, 1 );
	}

	hud = NewHudElem();
	hud.location = 0;
	hud.alignX = "left";
	hud.alignY = "middle";
	hud.foreground = 1;
	hud.fontScale = scale;
	hud.sort = 20;
	hud.alpha = alpha;
	hud.x = x;
	hud.y = y;
	hud.og_scale = scale;
	hud.color = color;

	if( IsDefined( text ) )
	{
		hud SetText( text );
	}

	return hud;
#/
}

export_status_thread()
{
/#
	SetDvar( "status_export", "none" );
	while( 1 )
	{
		dvar = GetDvar( "status_export" );
		if( dvar == "none" )
		{
			wait( 1 );
			continue;
		}

		if( dvar == "detailed" )
		{
			export_to_html( "detailed" );
		}
		else
		{
			export_to_html( "task" );
		}

		SetDvar( "status_export", "none" );
	}
#/
}

export_to_html( type )
{
/#
	if( !IsDefined( level._tasks ) )
	{
		assertmsg( "_status ASSERT: No tasks specified!" );
	}

	fullpath_file = "status/" + level.script + "_status.html";

	file = OpenFile( fullpath_file, "write" );
	assertex( file != -1, "File not writeable (maybe you should check it out): " + fullpath_file );
	if( file < 0 )
	{
		return;
	}

	tab = "    ";
	write_header( file );

// BODY
	fprintln( file, "<body>" );
	write_project_header( file, type );

	if( type == "detailed" )
	{
		write_gantt_chart( file );
		write_tasks( file );		
	}
	else
	{
		write_tasks( file );
	}

	tab = "    ";
    fprintln( file, tab + "<div class=\"footer\">" );
    fprintln( file, tab + tab +"<div>This file was generated by _status.gsc</div>" );
    fprintln( file, tab + "</div>" );
	fprintln( file, "</body>" );

	saved = CloseFile( file );
	assertex( saved == 1, "File not saved (see above message?): " + fullpath_file );

	if( !saved )
	{
	}
#/
}

write_project_header( file, type )
{
/#
	tab = "    ";
	fprintln( file, tab + "<h1 class=\"proj-title\">" );
	fprintln( file, tab + tab + "<a name=\"project\" id=\"project\">" );
	fprintln( file, tab + tab + tab + "Level: " + level.script );
	fprintln( file, tab + tab + "</a>" );
	fprintln( file, tab + "</h1>" );
	fprintln( file, tab + "<table class=\"proj-header\">" );
	fprintln( file, tab + "<tr>" );
	fprintln( file, tab + tab + "<td class=\"header\">Report Date:</td>" );
	fprintln( file, tab + tab + "<td>" + GetDate() + "</td>" );
	fprintln( file, tab + "</tr>" );
	fprintln( file, tab + "<tr>" );
	fprintln( file, tab + tab + "<td class=\"header\">Start Date: </td>" );
	fprintln( file, tab + tab + "<td>" + level._task_start_date + "</td>" );
	fprintln( file, tab + "</tr>" );
//	fprintln( file, tab + "<tr>" );
//	fprintln( file, tab + tab + "<td class=\"header\">Expected Finish:</td>" );
//	fprintln( file, tab + tab + "<td>????</td>" );
//	fprintln( file, tab + "</tr>" );
	fprintln( file, tab + "<tr>" );
	fprintln( file, tab + tab + "<td class=\"header\">Milestone Date:</td>" );
	fprintln( file, tab + tab + "<td>" + level._task_milestone_date + "</td>" );
	fprintln( file, tab + "</tr>" );
	fprintln( file, tab + "<tr>" );
	fprintln( file, tab + tab + "<td class=\"header\">Estimated Date:</td>" );
	fprintln( file, tab + tab + "<td>" + get_estimated_due_date( "scripter" ) + "</td>" );
	fprintln( file, tab + "</tr>" );
	fprintln( file, tab + "</table>" );
#/
}

write_gantt_chart( file )
{
/#
	tab = "    ";

	size = level._task_types.size;
	use_odd = true;
	for( i = 0; i < size; i++ )
	{
		type = level._task_types[i];

		write_gantt_chart_header( file, type );

		tasks = level._tasks[type]["all_tasks"].size;

		task_num = 0;
		for( q = 0; q < tasks; q++ )
		{
			main_task = level._tasks[type]["all_tasks"][q];

			if( use_odd )
			{
				use_odd = false;
			}
			else
			{
				use_odd = true;
			}

			sub_tasks = level._tasks[type][main_task]["sub_tasks"].size;

			task_num++;

			level._tasks[type][main_task]["quote"] = get_status_quote( type, main_task );

			write_gantt_row( file, level._tasks[type][main_task], task_num, use_odd, 0, sub_tasks > 0 );
		}

		fprintln( file, tab + tab + tab + tab + tab + "</table>" );
		fprintln( file, tab + tab + tab + tab + "</div>" );

		estimated_due_date = get_estimated_due_date( type );

		if( date_to_day( estimated_due_date ) > date_to_day( level._task_milestone_date ) )
		{
			days = figure_days_amount( level._task_start_date, estimated_due_date );
		}
		else
		{
			days = figure_days_amount( level._task_start_date, level._task_milestone_date );
		}

		if( days % 7 > 0 )
		{
			days = ( 7 - ( days % 7 ) ) + days;
		}

		overall_width = days * 19 + ( days - 1 );
		// "Week #" header
		fprintln( file, tab + tab + tab + "<td>" );
//        fprintln( file, tab + tab + tab + tab + "<div class=\"scroll-div\" style=\"width: " + overall_width + "px; border-color: #aaa #aaa #aaa #fff;\">" );
        fprintln( file, tab + tab + tab + tab + "<div class=\"gantt-scroll-div\" style=\"border-color: #aaa #aaa #aaa #fff;\">" );
        fprintln( file, tab + tab + tab + tab + tab + "<table style= \"width: " + overall_width + "px; cellspacing=\"0\" cellpadding=\"0\" border=\"1\">" );
        fprintln( file, tab + tab + tab + tab + tab + tab + "<tr class=\"header\" align=\"left\">" );

		weeks = int( days / 7 );

		for( i = 0; i < weeks; i++ )
		{
       		fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th align=\"center\" colspan=\"5\">" + "Week #" + ( i + 1 ) + "</th>" );
      		fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th colspan=\"2\"></th>" );
		}

        fprintln( file, tab + tab + tab + tab + tab + tab + "</tr>" );	

		// "Day #" header
        fprintln( file, tab + tab + tab + tab + tab + tab + "<tr class=\"header\" align=\"left\">" );

		start = date_to_day( level._task_start_date );
		for( i = 0; i < days; i++ )
		{
        	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th class=\"gantt-day-header\" align=\"center\">" + day_to_date( start + i, true ) + "</th>" );
		}

		fprintln( file, tab + tab + tab + tab + tab + tab + "</tr>" );

		// The actual graph
		use_odd = true;
		columns = days;
		for( q = 0; q < tasks; q++ )
		{
			main_task = level._tasks[type]["all_tasks"][q];

			if( use_odd )
			{
				use_odd = false;
			}
			else
			{
				use_odd = true;
			}

			sub_tasks = level._tasks[type][main_task]["sub_tasks"].size;

			task_num++;

			level._tasks[type][main_task]["quote"] = get_status_quote( type, main_task );

			if( i == 0 )
			{
				write_gantt_graph_row( file, level._tasks[type][main_task]["start_date"], level._tasks[type][main_task]["due_date"], use_odd, columns, overall_width );
			}
			else
			{
				write_gantt_graph_row( file, level._tasks[type][main_task]["start_date"], level._tasks[type][main_task]["due_date"], use_odd, columns, overall_width );
			}
		}

        fprintln( file, tab + tab + tab + tab + tab + "</table>" );
        fprintln( file, tab + tab + tab + tab + "</div>" );
        fprintln( file, tab + tab + tab + "</td>" );
        fprintln( file, tab + tab + "</tr>" );
        fprintln( file, tab + "</table>" );
	}
#/
}

figure_days_amount( begin_date, end_date )
{
/#
	start_day = date_to_day( begin_date );
	end_day = date_to_day( end_date );

	return ( end_day - start_day );
#/
}

write_gantt_graph_row( file, start_date, due_date, use_odd, columns, overall_width )
{
/#
	tab = "    ";

	if( use_odd )
	{
		fprintln( file, tab + tab + tab + tab + tab + tab + "<tr class=\"odd\">" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + tab + tab + "<tr class=\"even\">" );
	}

	start_day = date_to_day( start_date );
	day_diff = start_day - date_to_day( level._task_start_date );

	begin_width = ( day_diff * 19 ) + day_diff - 1;

	days = figure_days_amount( start_date, due_date ) + 1 ; // Add one, since we start work on the "start_date"
	progress_width = ( days * 19 ) + days - 2;

	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<td colspan=\"" + columns + "\">" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + "<div style=\"width: " + overall_width + "px; white-space: nowrap;\">" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + tab + "<div class=\"gantt-empty-begin\" style=\"width: " + begin_width + "px;\"></div>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + tab + "<div class=\"gantt-complete-notdone\" style=\"width: " + progress_width + "px;\"></div>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + tab + "<div class=\"gantt-empty-end\"></div>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + tab + "<span class=\"gantt-resources\"></span>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + "</div>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "</td>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + "</tr>" );
#/
}

write_gantt_row( file, array, task_num, use_odd, pixels, use_bold )
{
/#
	tab = "    ";

	if( use_odd )
	{
		fprintln( file, tab + tab + "<tr class=\"odd\">" );
	}
	else
	{
		fprintln( file, tab + tab + "<tr class=\"even\">" );
	}

	fprintln( file, tab + tab + tab + "<td>" );

	if( use_bold )
	{
		fprintln( file, tab + tab + tab + tab + "<a name=\"task" + task_num + "\" style=\"font-weight: bold; margin-left: " + pixels + "px\" id=\"task" + task_num + "\">" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + "<a name=\"task" + task_num + "\" style=\"margin-left: " + pixels + "px\" id=\"task" + task_num + "\">" );
	}

	if( IsDefined( array["quote"] ) )
	{
		fprintln( file, tab + tab + tab + tab + "<span>" + array["name"] + " - " + array["quote"] + "</span>" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + "<span>" + array["name"] + "</span>" );
	}

	fprintln( file, tab + tab + tab + "</td>" );

	fprintln( file, tab + tab + tab + "<td>" );
	if( array["days"] < 0 ) // DO NOT INCLUDE MICRO TASKS! (Automatically set to -1)
	{
		fprintln( file, tab + tab + tab + tab + "<span>-</span>" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + "<span>" + array["days"] + "</span>" );
	}

	fprintln( file, tab + tab + tab + "</td>" );
	fprintln( file, tab + tab + "</tr>" );
#/
}

write_gantt_chart_header( file, type )
{
/#
	tab = "    ";

	if( type == "scripter" )
	{
		type = "Scripter";
	}
	else if( type == "builder" )
	{
		type = "Builder";
	}
	
	fprintln( file, tab + "<div class=\"separator\"></div>" );
    fprintln( file, tab + "<h2>" );
    fprintln( file, tab + tab + "<a name=\"gantt\" id=\"gantt\">" + type + " " + "Estimated Schedule</a>" );
    fprintln( file, tab + "</h2>" );
	fprintln( file, tab + "<table cellspacing=\"0\" cellpadding=\"0\" border=\"0\">" );
	fprintln( file, tab + tab + "<tr>" );
	fprintln( file, tab + tab + tab + "<td>" );
	fprintln( file, tab + tab + tab + tab + "<div class=\"no-scroll-div\">" );
	fprintln( file, tab + tab + tab + tab + tab + "<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\">" );
	fprintln( file, tab + tab + tab + tab + tab + tab + "<tr class=\"header\" align=\"left\">" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th width=20\%>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + "<span>Name</span>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "</th>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th width=50>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + tab + "<span>Estimated Work Duration</span>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "</th>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + "</tr>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + "<tr class=\"header\">" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th> </th>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + tab + "<th> </th>" );
	fprintln( file, tab + tab + tab + tab + tab + tab + "</tr>" );
#/
}

write_tasks( file )
{
/#
	tab = "    ";

	size = level._task_types.size;
	use_odd = true;
	for( i = 0; i < size; i++ )
	{
		type = level._task_types[i];

		write_task_header( file, type );

		tasks = level._tasks[type]["all_tasks"].size;

		task_num = 0;
		for( q = 0; q < tasks; q++ )
		{
			main_task = level._tasks[type]["all_tasks"][q];

			if( use_odd )
			{
				use_odd = false;
			}
			else
			{
				use_odd = true;
			}

			sub_tasks = level._tasks[type][main_task]["sub_tasks"].size;

			task_num++;

			level._tasks[type][main_task]["quote"] = get_status_quote( type, main_task );

			write_task_row( file, level._tasks[type][main_task], task_num, use_odd, 0, sub_tasks > 0 );

			for( m = 0; m < sub_tasks; m++ )
			{
				if( use_odd )
				{
					use_odd = false;
				}
				else
				{
					use_odd = true;
				}

				micro_tasks = level._tasks[type][main_task]["sub_tasks"][m]["sub_tasks"].size;
				task_num++;
				write_task_row( file, level._tasks[type][main_task]["sub_tasks"][m], task_num, use_odd, 18, micro_tasks > 0 );

				for( t = 0; t < micro_tasks; t++ )
				{
					if( use_odd )
					{
						use_odd = false;
					}
					else
					{
						use_odd = true;
					}
	
					task_num++;
					write_task_row( file, level._tasks[type][main_task]["sub_tasks"][m]["sub_tasks"][t], task_num, use_odd, 36, false );
				}
			}
		}

		fprintln( file, tab + "</table>" );
		fprintln( file, tab + "</div>" );
	}
#/
}

write_task_row( file, array, task_num, use_odd, pixels, use_bold )
{
/#
	tab = "    ";

	if( use_odd )
	{
		fprintln( file, tab + tab + "<tr class=\"odd\">" );
	}
	else
	{
		fprintln( file, tab + tab + "<tr class=\"even\">" );
	}

	fprintln( file, tab + tab + tab + "<td>" );

	if( use_bold )
	{
		fprintln( file, tab + tab + tab + tab + "<a name=\"task" + task_num + "\" style=\"font-weight: bold; margin-left: " + pixels + "px\" id=\"task" + task_num + "\">" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + "<a name=\"task" + task_num + "\" style=\"margin-left: " + pixels + "px\" id=\"task" + task_num + "\">" );
	}

	if( IsDefined( array["quote"] ) )
	{
		fprintln( file, tab + tab + tab + tab + "<span>" + array["name"] + " - " + array["quote"] + "</span>" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + "<span>" + array["name"] + "</span>" );
	}

	fprintln( file, tab + tab + tab + "</td>" );

//	fprintln( file, tab + tab + tab + "<td>" );
//	fprintln( file, tab + tab + tab + tab + "<span>?????</span>" );
//	fprintln( file, tab + tab + tab + "</td>" );
//	fprintln( file, tab + tab + tab + "<td>" );
//	fprintln( file, tab + tab + tab + tab + "<span>?????</span>" );
//	fprintln( file, tab + tab + tab + "</td>" );

	fprintln( file, tab + tab + tab + "<td>" );
	if( array["days"] < 0 ) // DO NOT INCLUDE MICRO TASKS! (Automatically set to -1)
	{
		fprintln( file, tab + tab + tab + tab + "<span>-</span>" );
	}
	else
	{
		fprintln( file, tab + tab + tab + tab + "<span>" + array["days"] + "</span>" );
	}

	fprintln( file, tab + tab + tab + "</td>" );
	fprintln( file, tab + tab + tab + "<td>" );
	fprintln( file, tab + tab + tab + tab + "<span>" + array["percent"] + "\%</span>" );
	fprintln( file, tab + tab + tab + "</td>" );
	fprintln( file, tab + tab + tab + "<td>" );
	fprintln( file, tab + tab + tab + tab + "<span class=\"note\">" + array["notes"] + "</span>" );
	fprintln( file, tab + tab + tab + "</td>" );
	fprintln( file, tab + tab + "</tr>" );
#/
}

write_task_header( file, type )
{
/#
	tab = "    ";

	if( type == "scripter" )
	{
		type = "Scripter";
	}
	else if( type == "builder" )
	{
		type = "Builder";
	}
	
	fprintln( file, tab + "<div class=\"separator\"></div>" );
    fprintln( file, tab + "<h2>" );
    fprintln( file, tab + tab + "<a name=\"tasks\" id=\"tasks\">" + type + " " + "Tasks</a>" );
    fprintln( file, tab + "</h2>" );
    fprintln( file, tab + "<div class=\"scroll-div\">" );

	fprintln( file, tab + "<table cellspacing=\"0\" cellpadding=\"0\" border=\"1\">" );
	fprintln( file, tab + tab + "<tr class=\"header\" align=\"left\">" );
	fprintln( file, tab + tab + tab + "<th width=20\%>" );
	fprintln( file, tab + tab + tab + tab + "<span>Name</span>" );
	fprintln( file, tab + tab + tab + "</th>" );
//	fprintln( file, tab + tab + tab + "<th>" );
//	fprintln( file, tab + tab + tab + tab + "<span>Start</span>" );
//	fprintln( file, tab + tab + tab + "</th>" );
//	fprintln( file, tab + tab + tab + "<th>" );
//	fprintln( file, tab + tab + tab + tab + "<span>Finish</span>" );
//	fprintln( file, tab + tab + tab + "</th>" );
	fprintln( file, tab + tab + tab + "<th width=50>" );
	fprintln( file, tab + tab + tab + tab + "<span>Estimated Work Duration</span>" );
	fprintln( file, tab + tab + tab + "</th>" );
	fprintln( file, tab + tab + tab + "<th width=50>" );
	fprintln( file, tab + tab + tab + tab + "<span>% Completed</span>" );
	fprintln( file, tab + tab + tab + "</th>" );
	fprintln( file, tab + tab + tab + "<th>" );
	fprintln( file, tab + tab + tab + tab + "<span>Notes</span>" );
	fprintln( file, tab + tab + tab + "</th>" );
	fprintln( file, tab + tab + "</tr>" );
#/
}

write_header( file )
{
/#
	tab = "    ";

	fprintln( file, "<?xml version=\"1.0\" encoding=\"ISO-8859-1\"?>" );
	fprintln( file, "<head>" );
	fprintln( file, tab + "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=ISO-8859-1\" />" );
	fprintln( file, tab + "<title>" + level.script + " PROGRESS REPORT</title>" );
	fprintln( file, tab + "<meta name=\"GENERATOR\" content=\"Planner HTML output\" />" );
	fprintln( file, tab + "<style type=\"text/css\">" );
	fprintln( file, "" );
	fprintln( file, tab + "/*" );
	fprintln( file, tab + " * Fonts " );
	fprintln( file, tab + " */" );
	fprintln( file, tab + "html,body,table" );
	fprintln( file, tab + "{ " );
	fprintln( file, tab + tab + "font-family: Bitstream Vera Sans, helvetica, Arial, sans-serif;" );
	fprintln( file, tab + tab + "font-size: 12px;" );
	fprintln( file, tab + tab + "white-space: nowrap;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "tr,td,th,table,font,span,div,h1,h2,h3 " );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "font-family: Bitstream Vera Sans, helvetica, Arial, sans-serif;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "h1" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "font-size: 16px;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "h2" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "font-size: 12px;" );
	fprintln( file, tab + tab + "margin-bottom: 2px;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "div.separator" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "margin: 1em;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "/*" );
	fprintln( file, tab + " * Header" );
	fprintln( file, tab + " */" );
	fprintln( file, tab + "table.proj-header" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "border: 0;" );
	fprintln( file, tab + tab + "margin: 0;" );
	fprintln( file, tab + tab + "width: auto;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "table.proj-header .header" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "font-weight: bold;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "/*" );
	fprintln( file, tab + " * Footer" );
	fprintln( file, tab + " */" );
	fprintln( file, tab + ".footer " );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "margin-top: 50px;  " );
	fprintln( file, tab + tab + "padding-top: 2px;" );
	fprintln( file, tab + tab + "border-style: dotted;" );
	fprintln( file, tab + tab + "border-width: 1px 0 0 0;" );
	fprintln( file, tab + tab + "border-color: #999;" );
	fprintln( file, tab + tab + "font-size: 9px;" );
	fprintln( file, tab + tab + "text-align: right;" );
	fprintln( file, tab + tab + "clear: both;" );
	fprintln( file, tab + tab + "color: #666;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "a:link, a:visited" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "text-decoration: none;" );
	fprintln( file, tab + tab + "color: #666;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "a:hover[href]" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "text-decoration: underline;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, "" );
	fprintln( file, tab + "/*" );
	fprintln( file, tab + " * Tables" );
	fprintln( file, tab + " */" );
	fprintln( file, tab + ".scroll-div " );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "overflow: auto;" );
	fprintln( file, tab + tab + "border-style: solid;" );
	fprintln( file, tab + tab + "border-width: 1px;" );
	fprintln( file, tab + tab + "border-color: #aaa;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + ".gantt-scroll-div" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "width: 900px;" );
	fprintln( file, tab + tab + "overflow: auto;" );
	fprintln( file, tab + tab + "border-style: solid;" );
	fprintln( file, tab + tab + "border-width: 1px;" );
	fprintln( file, tab + tab + "border-color: #aaa;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + ".no-scroll-div " );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "border-style: solid;" );
	fprintln( file, tab + tab + "border-color: #aaa;" );
	fprintln( file, tab + tab + "border-width: 1px 0px 1px 1px;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "table" );
	fprintln( file, tab + "{" );
//	fprintln( file, tab + tab + "width: 100%;" );
	fprintln( file, tab + tab + "border-collapse: collapse;" );
	fprintln( file, tab + tab + "border-style: none;" );
	fprintln( file, tab + tab + "border-color: #fff;" );
	fprintln( file, tab + tab + "white-space: nowrap;" );
	fprintln( file, tab + tab + "margin: 0;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "tr, td, th" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "white-space: nowrap;" );
	fprintln( file, tab + tab + "vertical-align: top;" );
	fprintln( file, tab + tab + "padding-top: 1px;" );
	fprintln( file, tab + tab + "padding-bottom: 1px;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "th " );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "vertical-align: top;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "tr" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "height: 1.5em;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "tr.header" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "background-color: #aaa;" );
	fprintln( file, tab + tab + "color: #fff;" );
	fprintln( file, tab + "}" );
	fprintln( file, "" );
	fprintln( file, tab + "tr.even" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "background-color: #eee;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "tr.odd" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "background-color: #fff;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "th span, td span" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "margin-left: 6px;" );
	fprintln( file, tab + tab + "margin-right: 6px;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "span.note" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "white-space: normal;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "/*" );
	fprintln( file, tab + " * Gantt" );
	fprintln( file, tab + " */" );
	fprintln( file, tab + "div.gantt-empty-begin, div.gantt-empty-end, div.gantt-complete-done, div.gantt-complete-notdone, div.gantt-complete-notdone-behind, div.gantt-summary" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "clear: none;" );
	fprintln( file, tab + tab + "float: left; " );
	fprintln( file, tab + tab + "height: 0.75em;" );
	fprintln( file, tab + tab + "margin-top: 0.15em;" );
	fprintln( file, tab + tab + "margin-bottom: 0;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "div.gantt-complete-done" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "background-color: #55FF55;" );
	fprintln( file, tab + tab + "height: 0.75em;" );
	fprintln( file, tab + tab + "border-style: solid;" );
	fprintln( file, tab + tab + "border-width: 1px;" );        
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "div.gantt-complete-notdone" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "background-color: #8db6cd;" );
	fprintln( file, tab + tab + "border-style: solid;" );
	fprintln( file, tab + tab + "border-width: 1px;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "div.gantt-complete-notdone-behind" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "background-color: #FF5555;" );
	fprintln( file, tab + tab + "border-style: solid;" );
	fprintln( file, tab + tab + "border-width: 1px;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "div.gantt-summary" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "height: 0.3em;" );
	fprintln( file, tab + tab + "margin-top: 0.25em;" );
	fprintln( file, tab + tab + "border-bottom: 2px dashed #000;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "div.gantt-empty-end" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "margin-left: 0;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "span.gantt-milestone" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "font-size: 0.8em;" );
	fprintln( file, tab + tab + "color: #000000;" );
	fprintln( file, tab + tab + "position: relative;" );
	fprintln( file, tab + tab + "margin-left: 0;" );
	fprintln( file, tab + tab + "margin-right: 0;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "span.gantt-resources" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "margin-left: 0.5em;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "" );
	fprintln( file, tab + "th.gantt-day-header" );
	fprintln( file, tab + "{" );
	fprintln( file, tab + tab + "width: 19px;" );
	fprintln( file, tab + tab + "margin: 0;" );
	fprintln( file, tab + tab + "padding: 0;" );
	fprintln( file, tab + "}" );
	fprintln( file, tab + "</style>" );
	fprintln( file, "</head>" );
	fprintln( file, "" );
#/
}

save_complete( msg )
{
/#
	println( "Save Successful, " + msg );

	hud = set_hudelem( "Save Successful", 320, 100, 1.5 );
	hud.alignX = "center";
	hud.color = ( 0, 1, 0 );

	hud_msg = set_hudelem( msg, 320, 120, 1.3 );
	hud_msg.alignX = "center";
	hud_msg.color = ( 1, 1, 1 );

	wait( 2 );

	hud FadeOverTime( 3 );
	hud.alpha = 0;

	hud_msg FadeOverTime( 3 );
	hud_msg.alpha = 0;

	wait( 3 );
	hud Destroy();
	hud_msg Destroy();
#/
}

// Util
// Checks the array if the "single" already exists, if so it returns false.
check_for_dupes( array, single )
{
/#
	for( i = 0; i < array.size; i++ )
	{
		if( array[i] == single )
		{
			return false;
		}
	}

	return true;
#/
}

abs( x )
{
	if( x > 0 )
	{
		return x;
	}

	return 0 - x;
}