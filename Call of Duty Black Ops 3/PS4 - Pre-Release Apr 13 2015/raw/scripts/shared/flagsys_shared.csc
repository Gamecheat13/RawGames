#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace flagsys;

/*
 * flagsys treats undefined flags as "cleared" and won't assert if not initialized
 * Use regular flags by default and only use the flagsys functions when you need to
 * as these are more error prone.
 * 
 * Never use these for level progression.
*/

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
	if ( !isdefined( self.flag ) )
	{
		self.flag = [];
	}
	
	self.flag[ str_flag ] = true;
	self notify( str_flag );
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
	if ( isdefined( self.flag ) && ( isdefined( self.flag[ str_flag ] ) && self.flag[ str_flag ] ) )
	{
		self.flag[ str_flag ] = undefined;
		self notify( str_flag );
	}
}

function set_val( str_flag, b_val )
{
	Assert( isdefined( b_val ), "value must be specified in flagsys::set_val" );
	
	if ( b_val )
	{
		set( str_flag );
	}
	else
	{
		clear( str_flag );
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
	set( !get( str_flag ) );
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
	return ( isdefined( self.flag ) && ( isdefined( self.flag[ str_flag ] ) && self.flag[ str_flag ] ) );
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
	clear( str_flag );
}

function script_flag_wait()
{
	if ( isdefined( self.script_flag_wait ) )
	{
		self wait_till( self.script_flag_wait );
		return true;
	}
	
	return false;
}
