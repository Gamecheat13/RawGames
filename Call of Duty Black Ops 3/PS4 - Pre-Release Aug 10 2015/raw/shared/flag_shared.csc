#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace flag;

/@
"Name: init( <str_flag> )"
"Summary: Initialize a str_flag to be used. All flags must be initialized before using set or wait.  Some flags for ai are set by default such as 'goal', 'death', and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <str_flag> : name of the str_flag to create"
"Example: enemy init( "hq_cleared" );"
"SPMP: singleplayer"
@/
function init( str_flag, b_val = false, b_is_trigger = false )
{
	if(!isdefined(self.flag))self.flag=[];
	
	/#
	
	if ( !isdefined( level.first_frame ) )
	{
		Assert( !isdefined( self.flag[ str_flag ] ), "Attempt to reinitialize existing flag '" + str_flag + "' on entity." );
	}
	
	#/

	self.flag[ str_flag ] = b_val;
}

/@
"Name: exists( <str_flag> )"
"Summary: checks to see if a str_flag exists"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <str_flag> : name of the str_flag to check"
"Example: if ( enemy exists( "hq_cleared" ) );"
"SPMP: singleplayer"
@/
function exists( str_flag )
{
	return ( isdefined( self.flag ) && isdefined( self.flag[ str_flag ] ) );
}

/@
"Name: set( <str_flag> )"
"Summary: Sets the specified str_flag on self, all scripts using wait on self will now continue."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <str_flag> : name of the str_flag to set"
"Example: enemy set( "hq_cleared" );"
"SPMP: singleplayer"
@/
function set( str_flag )
{
	Assert( exists( str_flag ), "Attempting to set a flag '" + str_flag + "' that's not initialized." );

	self.flag[ str_flag ] = true;
	self notify( str_flag );
}

/@
"Name: delay_set( <str_flag> )"
"Summary: Sets the specified str_flag on self after a delay."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <n_dealy> : Time to delay before setting the flag"
"MandatoryArg: <str_flag> : name of the str_flag to set"
"OptionalArg: <str_cancel> : endon to cancel the falg set"
"Example: enemy delay_set( 10, "hq_cleared" );"
"SPMP: singleplayer"
@/
function delay_set( n_delay, str_flag, str_cancel )
{
	self thread _delay_set( n_delay, str_flag, str_cancel );
}

function _delay_set( n_delay, str_flag, str_cancel )
{
	if ( isdefined( str_cancel ) )
	{
		self endon( str_cancel );
	}
	
	self endon( "death" );
	
	wait n_delay;
	
	set( str_flag );
}

/@
"Name: set_for_time( <n_time>, <str_flag> )"
"Summary: Sets the specified flag, all scripts using flag_wait will now continue."
"Module: Flag"
"CallOn: "
"MandatoryArg: <n_time> : time to set the flag for"
"MandatoryArg: <str_flag> : name of the flag to set"
"Example: flag::set_for_time( 2, "hq_cleared" );"
"SPMP: both"
@/
function set_for_time( n_time, str_flag )
{
	self notify( "__flag::set_for_time__" + str_flag );
	self endon( "__flag::set_for_time__" + str_flag );
	
	set( str_flag );
	wait n_time;
	clear( str_flag );
}

/@
"Name: clear( <str_flag> )"
"Summary: Clears the specified str_flag on self."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <str_flag> : name of the str_flag to clear"
"Example: enemy clear( "hq_cleared" );"
"SPMP: singleplayer"
@/
function clear( str_flag )
{
	Assert( exists( str_flag ), "Attempting to clear a flag '" + str_flag + "' that's not initialized." );

	if ( self.flag[ str_flag ] )
	{
		self.flag[ str_flag ] = false;
		self notify( str_flag );
	}
}

/@
"Name: toggle( <str_flag> )"
"Summary: Toggles the specified ent str_flag."
"Module: Flag"
"MandatoryArg: <str_flag> : name of the str_flag to toggle"
"Example: toggle( "hq_cleared" );"
"SPMP: SP"
@/
function toggle( str_flag )
{
	if ( get( str_flag ) )
	{
		clear( str_flag );
	}
	else
	{
		set( str_flag );
	}
}

/@
"Name: get( <str_flag> )"
"Summary: Checks if the str_flag is set on self. Returns true or false."
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <str_flag> : name of the str_flag to check"
"Example: enemy get( "death" );"
"SPMP: singleplayer"
@/
function get( str_flag )
{
	Assert( exists( str_flag ), "Tried to get flag '" + str_flag + "' that's not initialized." );
	
	return self.flag[ str_flag ];
}

/@
"Name: wait( <str_flag> )"
"Summary: Waits until the specified str_flag is set on self. Even handles some default flags for ai such as 'goal' and 'damage'"
"Module: Flag"
"CallOn: Any entity (script_origin, script_struct, ai, script_model, script_brushmodel, player)"
"MandatoryArg: <str_flag> : name of the str_flag to wait on"
"Example: enemy wait( "goal" );"
"SPMP: singleplayer"
@/
function wait_till( str_flag )
{
	self endon( "death" );
	
	while ( !get( str_flag ) )
	{
		self waittill( str_flag );
	}
}

function wait_till_timeout( n_timeout, str_flag )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	wait_till( str_flag );
}

function wait_till_all( a_flags )
{
	self endon( "death" );
	
	for ( i = 0; i < a_flags.size; i++ )
	{
		str_flag = a_flags[i];
		
		if ( !get( str_flag ) )
		{
			self waittill( str_flag );
			i = -1;
		}
	}
}

function wait_till_all_timeout( n_timeout, a_flags )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	wait_till_all( a_flags );
}

function wait_till_any( a_flags )
{
	self endon( "death" );
	
	foreach ( flag in a_flags )
	{
		if ( get( flag ) )
		{
			return flag;
		}
	}

	util::waittill_any_array( a_flags );
}

function wait_till_any_timeout( n_timeout, a_flags )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	wait_till_any( a_flags );
}

function wait_till_clear( str_flag )
{
	self endon( "death" );
	
	while ( get( str_flag ) )
	{
		self waittill( str_flag );
	}
}

function wait_till_clear_timeout( n_timeout, str_flag )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	wait_till_clear( str_flag );
}

function wait_till_clear_all( a_flags )
{
	self endon( "death" );
	
	for ( i = 0; i < a_flags.size; i++ )
	{
		str_flag = a_flags[i];
		
		if ( get( str_flag ) )
		{
			self waittill( str_flag );
			i = -1;
		}
	}
}

function wait_till_clear_all_timeout( n_timeout, a_flags )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	wait_till_clear_all( a_flags );
}

function wait_till_clear_any( a_flags )
{
	self endon( "death" );
	
	while ( true )
	{
		foreach ( flag in a_flags )
		{
			if ( !get( flag ) )
			{
				return flag;
			}
		}

		util::waittill_any_array( a_flags );
	}
}

function wait_till_clear_any_timeout( n_timeout, a_flags )
{
	if ( isdefined( n_timeout ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_timeout, "timeout" );    };
	wait_till_clear_any( a_flags );
}

/@
"Name: delete( <flagname> )"
"Summary: delete a flag that has been inited to free vars"
"Module: Flag"
"CallOn: "
"MandatoryArg: <flagname> : name of the flag to create"
"Example: flag::delete( "hq_cleared" );"
"SPMP: SP"
@/
function delete( str_flag )
{
	if ( isdefined( self.flag[ str_flag ] ) )
	{
		self.flag[ str_flag ] = undefined;
	}
	else
	{
		/# PrintLn( "flag_delete() called on flag that does not exist: " + str_flag ); #/
	}
}
