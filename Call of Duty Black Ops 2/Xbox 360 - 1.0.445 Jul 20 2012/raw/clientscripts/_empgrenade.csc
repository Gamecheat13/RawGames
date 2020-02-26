#include clientscripts\_utility; 
#include clientscripts\_filter;

#insert raw\maps\_utility.gsh;

#define EMP_FILTER_INDEX 7
#define MIN_FILTER_INTENSITY 0.5
#define MAX_FILTER_INTENSITY 1
#define FILTER_DT 0.016667

init()
{
	level.localPlayers[0].emp_filter_duration = 0;
	
	init_filter_emp( level.localPlayers[0] );
}


//
// 	Based on MP implementation.  Stay on at full intensity for a period of time until turned off.
emp_filter_on()
{
	level notify( "emp_filter_on" );

	enable_filter_emp( level.localPlayers[0], EMP_FILTER_INDEX );
	set_filter_emp_amount( level.localPlayers[0], EMP_FILTER_INDEX, MAX_FILTER_INTENSITY );
}

//
//	Turn off filter instantly
emp_filter_off()
{
	disable_filter_emp( level.localPlayers[0], EMP_FILTER_INDEX );
}



//
//	EMP filter behavior is currently a best guess of intended effects based 
//	on flashbangs and vehicle damage filters
emp_filter_over_time( n_duration )
{
	level notify( "emp_filter_over_time" );
	level endon( "emp_filter_over_time" );

	enable_filter_emp( level.localPlayers[0], EMP_FILTER_INDEX );	
	set_filter_emp_amount( level.localPlayers[0], EMP_FILTER_INDEX, MAX_FILTER_INTENSITY );
	
	// Always start with full intensity if hit	
	n_emp_filter_intensity = MAX_FILTER_INTENSITY;
	// Only change the duration if it's greater than the current one
	if ( n_duration > level.localPlayers[0].emp_filter_duration )
	{
		level.localPlayers[0].emp_filter_duration = n_duration;
	}

	n_fade_out_step = (MAX_FILTER_INTENSITY - MIN_FILTER_INTENSITY) / level.localPlayers[0].emp_filter_duration * FILTER_DT;
	while ( n_emp_filter_intensity > MIN_FILTER_INTENSITY )
	{
		n_emp_filter_intensity -= n_fade_out_step;
		if ( n_emp_filter_intensity < MIN_FILTER_INTENSITY )
			n_emp_filter_intensity = MIN_FILTER_INTENSITY;
			
		set_filter_emp_amount( level.localPlayers[0], EMP_FILTER_INDEX, n_emp_filter_intensity );		
			
		wait( FILTER_DT );
	}

	disable_filter_emp( level.localPlayers[0], EMP_FILTER_INDEX );
}
