#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
   	                                                         	                                                                                                                                               	                                                      	                                                                              	                                                          	                                    	                                     	                                                     	                                                                                      	                                                             	                                                                                                    	                                             	                                     	                                                     

/*
	util.gsc
		
	This is a utility script common to all game modes. Don't add anything with calls to game type
	specific script API calls.
*/


#precache( "lui_menu", "CPChyron" );
#precache( "lui_menu_data", "line1full" );
#precache( "lui_menu_data", "line1short" );
#precache( "lui_menu_data", "line2full" );
#precache( "lui_menu_data", "line2short" );
#precache( "lui_menu_data", "line3full" );
#precache( "lui_menu_data", "line3short" );
#precache( "lui_menu_data", "line4full" );
#precache( "lui_menu_data", "line4short" );
#precache( "lui_menu_data", "line5full" );
#precache( "lui_menu_data", "line5short" );
#precache( "lui_menu_data", "close_current_menu" );


#namespace util;


/@
"Name: empty( <a>, <b>, <c>, <d>, <e> )"
"Summary: Empty function mainly used as a place holder or default function pointer in a system."
"Module: Utility"
"CallOn: "
"OptionalArg: <a> : option arg"
"OptionalArg: <b> : option arg"
"OptionalArg: <c> : option arg"
"OptionalArg: <d> : option arg"
"OptionalArg: <e> : option arg"
"Example: default_callback = &empty;"
"SPMP: both"
@/
function empty( a, b, c, d, e )
{
}

/@
"Name: wait_network_frame()"
"Summary: Wait until a snapshot is acknowledged.  Can help control having too many spawns in one frame."
"Module: Utility"
"Example: wait_network_frame();"
"SPMP: singleplayer"
@/
function wait_network_frame()
{
	if ( NumRemoteClients() )
	{
	    snapshot_ids = getsnapshotindexarray();
	
	    acked = undefined;
	    while ( !isdefined( acked ) )
	    {
	        level waittill( "snapacknowledged" );
	        acked = snapshotacknowledged( snapshot_ids );
	    }
	}
	else
	{
		wait 0.1;
	}
}

function streamer_wait()
{
	if( !isdefined( level.b_wait_for_streamer_default ) )
	{
		level.b_wait_for_streamer_default = 1;
		// Don't wait in dev builds
		/# 
			level.b_wait_for_streamer_default = 0;
		#/
	}
	
	if ( !GetDvarInt( "scr_streamer_wait", level.b_wait_for_streamer_default ) )
	{
		return;
	}
	
	if ( isdefined( 5 ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( 5, "timeout" );    }; // IsStreamerReady sometimes gets hung up which switching levels so time it out for now.
	
	if ( self == level )
	{
		n_num_streamers_ready = 0;
		
		do
		{
			util::wait_network_frame();
			
			n_num_streamers_ready = 0;
			
			foreach ( player in level.players )
			{
				if ( player IsStreamerReady() )
				{
					n_num_streamers_ready++;
				}
			}
		}
		while ( n_num_streamers_ready < level.players.size );
	}
	else
	{
		self endon( "disconnect" );
			
		do
		{
			util::wait_network_frame();
		}
		while ( !self IsStreamerReady() );
	}
}

//-- Other / Unsorted --//
/#
function draw_debug_line(start, end, timer)
{
	for (i=0;i<timer*20;i++)
	{
		line (start, end, (1,1,0.5));
		{wait(.05);};
	}
}

function debug_line( start, end, color, alpha, depthTest, duration )
{
	if ( !isdefined( color ) )
	{
		color = (1, 1, 1 );
	}
	
	if ( !isdefined( alpha ) )
	{
		alpha = 1;
	}
	
	if ( !isdefined( depthTest ) )
	{
		depthTest = 0;
	}
	
	if ( !isdefined( duration ) )
	{
		duration = 100;
	}
	
	line(start, end, color, alpha, depthTest, duration );	
}


function debug_spherical_cone( origin, domeApex, angle, slices, color, alpha, depthTest, duration )
{
	if ( !isdefined( slices ) )
	{
		slices = 10;
	}

	if ( !isdefined( color ) )
	{
		color = ( 1, 1, 1 );
	}
	
	if ( !isdefined( alpha ) )
	{
		alpha = 1;
	}
	
	if ( !isdefined( depthTest ) )
	{
		depthTest = 0;
	}
	
	if ( !isdefined( duration ) )
	{
		duration = 100;
	}
	
	sphericalcone( origin, domeApex, angle, slices, color, alpha, depthTest, duration );	
}

function debug_sphere( origin, radius, color, alpha, time )
{

	if ( !isdefined(time) )
	{
		time = 1000;
	}
	if ( !isdefined(color) )
	{
		color = (1,1,1);
	}
	
	sides = Int(10 * ( 1 + Int(radius) % 100 ));
	sphere( origin, radius, color, alpha, true, sides, time );

}
#/
	
function waittillend(msg)
{
	self waittillmatch (msg, "end");
}

function track(spot_to_track)
{
	if(isdefined(self.current_target))
	{
		if(spot_to_track == self.current_target)
			return;
	}
	self.current_target = spot_to_track;
}

function waittill_string( msg, ent )
{
	if ( msg != "death" )
	{
		self endon ("death");
	}
		
	ent endon( "die" );
	self waittill( msg );
	ent notify( "returned", msg );
}

/@
"Name: waittill_multiple( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for all of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string5> name of a notify to wait on"
"Example: guy waittill_multiple( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
function waittill_multiple( string1, string2, string3, string4, string5 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if (isdefined (string1))
	{
		self thread waittill_string (string1, ent);
		ent.threads++;
	}
	if (isdefined (string2))
	{
		self thread waittill_string (string2, ent);
		ent.threads++;
	}
	if (isdefined (string3))
	{
		self thread waittill_string (string3, ent);
		ent.threads++;
	}
	if (isdefined (string4))
	{
		self thread waittill_string (string4, ent);
		ent.threads++;
	}
	if (isdefined (string5))
	{
		self thread waittill_string (string5, ent);
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

/@
"Name: waittill_either( <string1>, <string2> )"
"Summary: Waits for one of the two specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"MandatoryArg:	<string2> name of a notify to wait on"
"Example: guy waittill_multiple( "goal", "near_goal" );"
"SPMP: both"
@/
function waittill_either( msg1, msg2 )
{
	self endon( msg1 );
	self waittill( msg2 );
}

/@
"Name: break_glass( n_radius )"
"Summary: Calls GlassRadiusDamage on the center position of an AI to break glass around him."
"Module: Utility"
"CallOn: Entity"
"OptionalArg: <n_radius> radius used for GlassRadiusDamage, defaults to 50"
"Example: guy break_glass();"
"SPMP: both"
@/
function break_glass( n_radius = 50 )
{
	const N_MIN_DAMAGE = 500;
	const N_MAX_DAMAGE = 500;
	
	//if passed as a notetrack param, convert to a float
	n_radius = Float( n_radius );
	
	// if n_radius is set to -1, remove the offset for the damage
	// Used when we have an AI dropping through a pane of glass instead of jumping through a glass window
	if( n_radius == -1 )
	{
		v_origin_offset = ( 0, 0, 0 );
		n_radius = 100;
	}
	//offset the damage from the origin of the AI
	else
	{
		v_origin_offset = ( 0, 0, 40 );	
	}
	
	GlassRadiusDamage( self.origin + v_origin_offset, n_radius, N_MAX_DAMAGE, N_MIN_DAMAGE );
}

/@
"Name: waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )"
"Summary: Waits for all of the the specified notifies on their associated entities."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"OptionalArg:	<ent3> entity to wait for <string3> on"
"OptionalArg:	<string3> notify to wait for on <ent3>"
"OptionalArg:	<ent4> entity to wait for <string4> on"
"OptionalArg:	<string4> notify to wait for on <ent4>"
"Example: guy waittill_multiple_ents( guy, "goal", guy, "pain", guy, "near_goal", player, "weapon_change" );"
"SPMP: both"
@/
function waittill_multiple_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )
{
	self endon ("death");
	ent = SpawnStruct();
	ent.threads = 0;

	if ( isdefined( ent1 ) )
	{
		assert( isdefined( string1 ) );
		ent1 thread waittill_string( string1, ent );
		ent.threads++;
	}
	if ( isdefined( ent2 ) )
	{
		assert( isdefined( string2 ) );
		ent2 thread waittill_string ( string2, ent );
		ent.threads++;
	}
	if ( isdefined( ent3 ) )
	{
		assert( isdefined( string3 ) );
		ent3 thread waittill_string ( string3, ent );
		ent.threads++;
	}
	if ( isdefined( ent4 ) )
	{
		assert( isdefined( string4 ) );
		ent4 thread waittill_string ( string4, ent );
		ent.threads++;
	}

	while (ent.threads)
	{
		ent waittill ("returned");
		ent.threads--;
	}

	ent notify ("die");
}

/@
"Name: waittill_any_return( <string1>, <string2>, <string3>, <string4>, <string5> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<string1> name of a notify to wait on"
"OptionalArg:	<string2> name of a notify to wait on"
"OptionalArg:	<string3> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string4> name of a notify to wait on"
"OptionalArg:	<string6> name of a notify to wait on"
"OptionalArg:	<string7> name of a notify to wait on"
"Example: which_notify = guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
function waittill_any_return( string1, string2, string3, string4, string5, string6, string7 )
{
	if ((!isdefined (string1) || string1 != "death") &&
	    (!isdefined (string2) || string2 != "death") &&
	    (!isdefined (string3) || string3 != "death") &&
	    (!isdefined (string4) || string4 != "death") &&
	    (!isdefined (string5) || string5 != "death") &&
	    (!isdefined (string6) || string6 != "death") &&
	    (!isdefined (string7) || string7 != "death"))
		self endon ("death");
		
	ent = SpawnStruct();

	if (isdefined (string1))
		self thread waittill_string (string1, ent);

	if (isdefined (string2))
		self thread waittill_string (string2, ent);

	if (isdefined (string3))
		self thread waittill_string (string3, ent);

	if (isdefined (string4))
		self thread waittill_string (string4, ent);

	if (isdefined (string5))
		self thread waittill_string (string5, ent);

	if (isdefined (string6))
		self thread waittill_string (string6, ent);

	if (isdefined (string7))
		self thread waittill_string (string7, ent);

	ent waittill ("returned", msg);
	ent notify ("die");
	return msg;
}

/@
"Name: waittill_any_array_return( <a_notifies> )"
"Summary: Waits for any of the the specified notifies and return which one it got."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<a_notifies> array of notifies to wait on"
"Example: str_which_notify = guy waittill_any_array_return( array( "goal", "pain", "near_goal", "bulletwhizby" ) );"
"SPMP: both"
@/
function waittill_any_array_return( a_notifies )
{
	if ( IsInArray( a_notifies, "death" ) )
	{
		self endon("death");
	}
		
	s_tracker = SpawnStruct();
	
	foreach ( str_notify in a_notifies )
	{
		if ( isdefined( str_notify ) )
		{
			self thread waittill_string( str_notify, s_tracker );
		}
	}

	s_tracker waittill( "returned", msg );
	s_tracker notify( "die" );
	return msg;
}

/@
"Name: waittill_any( <str_notify1>, <str_notify2>, <str_notify3>, <str_notify4>, <str_notify5> )"
"Summary: Waits for any of the the specified notifies."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<str_notify1> name of a notify to wait on"
"OptionalArg:	<str_notify2> name of a notify to wait on"
"OptionalArg:	<str_notify3> name of a notify to wait on"
"OptionalArg:	<str_notify4> name of a notify to wait on"
"OptionalArg:	<str_notify5> name of a notify to wait on"
"OptionalArg:	<str_notify6> name of a notify to wait on"
"Example: guy waittill_any( "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
function waittill_any( str_notify1, str_notify2, str_notify3, str_notify4, str_notify5, str_notify6 )
{
	Assert( isdefined( str_notify1 ) );
	
	waittill_any_array( array( str_notify1, str_notify2, str_notify3, str_notify4, str_notify5, str_notify6 ) );
}

/@
"Name: waittill_any_array( <a_notifies> )"
"Summary: Waits for any of the the specified notifies in the array."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<a_notifies> array of notifies to wait on"
"Example: guy waittill_any_array( array( "goal", "pain", "near_goal", "bulletwhizby" ) );"
"SPMP: both"
@/
function waittill_any_array( a_notifies )
{
	if ( !isdefined( a_notifies ) ) a_notifies = []; else if ( !IsArray( a_notifies ) ) a_notifies = array( a_notifies );;
	
	assert( isdefined( a_notifies[0] ),
		"At least the first element has to be defined for waittill_any_array." );
	
	for ( i = 1; i < a_notifies.size; i++ )
	{
		if ( isdefined( a_notifies[i] ) )
		{
			self endon( a_notifies[i] );
		}
	}
	
	self waittill( a_notifies[0] );
}

/@
"Name: waittill_any_timeout( <n_timeout>, <str_notify1>, [str_notify2], [str_notify3], [str_notify4], [str_notify5] )"
"Summary: Waits for any of the the specified notifies or times out."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<n_timeout> timeout in seconds"
"MandatoryArg:	<str_notify1> name of a notify to wait on"
"OptionalArg:	<str_notify2> name of a notify to wait on"
"OptionalArg:	<str_notify3> name of a notify to wait on"
"OptionalArg:	<str_notify4> name of a notify to wait on"
"OptionalArg:	<str_notify5> name of a notify to wait on"
"Example: guy waittill_any_timeout( 2, "goal", "pain", "near_goal", "bulletwhizby" );"
"SPMP: both"
@/
function waittill_any_timeout( n_timeout, string1, string2, string3, string4, string5 )
{
	if ( ( !isdefined( string1 ) || string1 != "death" ) &&
	( !isdefined( string2 ) || string2 != "death" ) &&
	( !isdefined( string3 ) || string3 != "death" ) &&
	( !isdefined( string4 ) || string4 != "death" ) &&
	( !isdefined( string5 ) || string5 != "death" ) )
		self endon( "death" );

	ent = spawnstruct();

	if ( isdefined( string1 ) )
		self thread waittill_string( string1, ent );

	if ( isdefined( string2 ) )
		self thread waittill_string( string2, ent );

	if ( isdefined( string3 ) )
		self thread waittill_string( string3, ent );

	if ( isdefined( string4 ) )
		self thread waittill_string( string4, ent );

	if ( isdefined( string5 ) )
		self thread waittill_string( string5, ent );

	ent thread _timeout( n_timeout );

	ent waittill( "returned", msg );
	ent notify( "die" );
	return msg;
}

function _timeout( delay )
{
	self endon( "die" );

	wait( delay );
	self notify( "returned", "timeout" );
}


/@
"Name: waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4 )"
"Summary: Waits for any of the the specified notifies on their associated entities."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"OptionalArg:	<ent3> entity to wait for <string3> on"
"OptionalArg:	<string3> notify to wait for on <ent3>"
"OptionalArg:	<ent4> entity to wait for <string4> on"
"OptionalArg:	<string4> notify to wait for on <ent4>"
"Example: guy waittill_any_ents( guy, "goal", guy, "pain", guy, "near_goal", player, "weapon_change" );"
"SPMP: both"
@/
function waittill_any_ents( ent1, string1, ent2, string2, ent3, string3, ent4, string4, ent5, string5, ent6, string6,ent7, string7 )
{
	assert( isdefined( ent1 ) );
	assert( isdefined( string1 ) );
	
	if ( ( isdefined( ent2 ) ) && ( isdefined( string2 ) ) )
		ent2 endon( string2 );

	if ( ( isdefined( ent3 ) ) && ( isdefined( string3 ) ) )
		ent3 endon( string3 );
	
	if ( ( isdefined( ent4 ) ) && ( isdefined( string4 ) ) )
		ent4 endon( string4 );
	
	if ( ( isdefined( ent5 ) ) && ( isdefined( string5 ) ) )
		ent5 endon( string5 );
	
	if ( ( isdefined( ent6 ) ) && ( isdefined( string6 ) ) )
		ent6 endon( string6 );
	
	if ( ( isdefined( ent7 ) ) && ( isdefined( string7 ) ) )
		ent7 endon( string7 );
	
	ent1 waittill( string1 );
}

/@
"Name: waittill_any_ents_two( ent1, string1, ent2, string2)"
"Summary: Waits for any of the the specified notifies on their associated entities [MAX TWO]."
"Module: Utility"
"CallOn: Entity"
"MandatoryArg:	<ent1> entity to wait for <string1> on"
"MandatoryArg:	<string1> notify to wait for on <ent1>"
"OptionalArg:	<ent2> entity to wait for <string2> on"
"OptionalArg:	<string2> notify to wait for on <ent2>"
"Example: guy waittill_any_ents_two( guy, "goal", guy, "pain");"
"SPMP: both"
@/
function waittill_any_ents_two( ent1, string1, ent2, string2 )
{
	assert( isdefined( ent1 ) );
	assert( isdefined( string1 ) );
	
	if ( ( isdefined( ent2 ) ) && ( isdefined( string2 ) ) )
		ent2 endon( string2 );

	ent1 waittill( string1 );
}

/@
"Name: isFlashed()"
"Summary: Returns true if the player or an AI is flashed"
"Module: Utility"
"CallOn: An AI"
"Example: flashed = level.price isflashed();"
"SPMP: both"
@/
function isFlashed()
{
	if ( !isdefined( self.flashEndTime ) )
		return false;
	
	return GetTime() < self.flashEndTime;
}

/@
"Name: isStunned()"
"Summary: Returns true if the player or an AI is Stunned/Concussed/Proximity"
"Module: Utility"
"CallOn: An AI"
"Example: stunned = level.price isStunned();"
"SPMP: both"
@/
function isStunned()
{
	if ( !isdefined( self.flashEndTime ) )
		return false;
	
	return GetTime() < self.flashEndTime;
}

/@
"Name: single_func( <entity>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Runs the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: entity : the entity to run through <func>"
"MandatoryArg: func> : pointer to a script function"
"OptionalArg: arg1 : parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: single_func( guy,&set_ignoreme, false );"
"SPMP: both"
@/
function single_func( entity, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	if ( !isdefined( entity ) )
	{
		entity = level;
	}

	if ( isdefined( arg6 ) )
	{
		return entity [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
	}
	else if ( isdefined( arg5 ) )
	{
		return entity [[ func ]]( arg1, arg2, arg3, arg4, arg5 );
	}
	else if ( isdefined( arg4 ) )
	{
		return entity [[ func ]]( arg1, arg2, arg3, arg4 );
	}
	else if ( isdefined( arg3 ) )
	{
		return entity [[ func ]]( arg1, arg2, arg3 );
	}
	else if ( isdefined( arg2 ) )
	{
		return entity [[ func ]]( arg1, arg2 );
	}
	else if ( isdefined( arg1 ) )
	{
		return entity [[ func ]]( arg1 );
	}
	else
	{
		return entity [[ func ]]();
	}
}

/@
"Name: new_func( <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Creates a new func with the args stored on a struct that can be called with call_func."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: func> : pointer to a script function"
"OptionalArg: arg1 : parameter 1 to pass to the func"
"OptionalArg: arg2 : parameter 2 to pass to the func"
"OptionalArg: arg3 : parameter 3 to pass to the func"
"OptionalArg: arg4 : parameter 4 to pass to the func"
"OptionalArg: arg5 : parameter 5 to pass to the func"
"OptionalArg: arg6 : parameter 6 to pass to the func"
"Example: s_callback = new_func(&set_ignoreme, false );"
"SPMP: both"
@/
function new_func( func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	s_func = SpawnStruct();
	s_func.func = func;
	s_func.arg1 = arg1;
	s_func.arg2 = arg2;
	s_func.arg3 = arg3;
	s_func.arg4 = arg4;
	s_func.arg5 = arg5;
	s_func.arg6 = arg6;
	return s_func;
}

/@
"Name: call_func( <func_struct> )"
"Summary: Runs the func and args stored on a struct created with new_func."
"Module: Utility"
"CallOn: NA"
"MandatoryArg: func_struct> : struct return by new_func"
"Example: self call_func( s_callback );"
"SPMP: both"
@/
function call_func( s_func )
{
	return single_func( self, s_func.func, s_func.arg1, s_func.arg2, s_func.arg3, s_func.arg4, s_func.arg5, s_func.arg6 );
}

/@
"Name: single_thread( <entity>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Threads the < func > function on the entity. The entity will become "self" in the specified function."
"Module: Utility"
"CallOn: "
"MandatoryArg: <entity> : the entity to thread <func> on"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: [arg1] : parameter 1 to pass to the func"
"OptionalArg: [arg2] : parameter 2 to pass to the func"
"OptionalArg: [arg3] : parameter 3 to pass to the func"
"OptionalArg: [arg4] : parameter 4 to pass to the func"
"OptionalArg: [arg5] : parameter 5 to pass to the func"
"OptionalArg: [arg6] : parameter 6 to pass to the func"
"Example: single_func( guy,&special_ai_think, "some_string", 345 );"
"SPMP: both"
@/
function single_thread(entity, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	Assert( isdefined( entity ), "Undefined entity passed to util::single_thread()" );

	if ( isdefined( arg6 ) )
	{
		entity thread [[ func ]]( arg1, arg2, arg3, arg4, arg5, arg6 );
	}
	else if ( isdefined( arg5 ) )
	{
		entity thread [[ func ]](arg1, arg2, arg3, arg4, arg5);
	}
	else if ( isdefined( arg4 ) )
	{
		entity thread [[ func ]]( arg1, arg2, arg3, arg4 );
	}
	else if ( isdefined( arg3 ) )
	{
		entity thread [[ func ]]( arg1, arg2, arg3 );
	}
	else if ( isdefined( arg2 ) )
	{
		entity thread [[ func ]]( arg1, arg2 );
	}
	else if ( isdefined( arg1 ) )
	{
		entity thread [[ func ]]( arg1 );
	}
	else
	{
		entity thread [[ func ]]();
	}
}

function script_delay()
{
	if ( isdefined( self.script_delay ) )
	{
		wait self.script_delay;
		return true;
	}
	else if ( isdefined( self.script_delay_min ) && isdefined( self.script_delay_max ) )
	{
		if ( self.script_delay_max > self.script_delay_min )
		{
			wait RandomFloatrange( self.script_delay_min, self.script_delay_max );
		}
		else
		{
			wait self.script_delay_min;
		}
		
		return true;
	}

	return false;
}

/@
"Name: timeout( <n_time>, <func>, [arg1], [arg2], [arg3], [arg4], [arg5], [arg6] )"
"Summary: Run any function with a timeout.  The function will exit when the timeout is reached."
"Module: util"
"CallOn: any"
"MandatoryArg: <n_time> : the timeout"
"MandatoryArg: <func> : the function"
"OptionalArg: [arg1] : parameter 1 to pass to the func"
"OptionalArg: [arg2] : parameter 2 to pass to the func"
"OptionalArg: [arg3] : parameter 3 to pass to the func"
"OptionalArg: [arg4] : parameter 4 to pass to the func"
"OptionalArg: [arg5] : parameter 5 to pass to the func"
"OptionalArg: [arg6] : parameter 6 to pass to the func"
"Example: ent timeout( 10, &my_function, 12, "hi" );"
"SPMP: both"
@/
function timeout( n_time, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	if ( isdefined( n_time ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_time, "timeout" );    };	
	single_func( self, func, arg1, arg2, arg3, arg4, arg5, arg6 );
}

function create_flags_and_return_tokens( flags )
{
	tokens = strtok( flags, " " );

	// create the flag if level script does not
	for( i=0; i < tokens.size; i++ )
	{
		if ( !level flag::exists( tokens[ i ] ) )
		{
			level flag::init( tokens[ i ], undefined, true );
		}
	}
	
	return tokens;
}

function fileprint_start( file )
{
	 /#
	filename = file;

//hackery here, sometimes the file just doesn't open so keep trying
//	file = -1;
//	while( file == -1 )
//	{
		file = openfile( filename, "write" );
//		if (file == -1)
//			wait .05; // try every frame untill the file becomes writeable
//	}
	level.fileprint = file;
	level.fileprintlinecount = 0;
	level.fileprint_filename = filename;
	#/
}

/@
"Name: fileprint_map_start( <filename> )"
"Summary: starts map export with the file trees\cod3\cod3\map_source\xenon_export\ < filename > .map adds header / worldspawn entity to the map.  Use this if you want to start a .map export."
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <param1> : "
"OptionalArg: <param2> : "
"Example: fileprint_map_start( filename );"
"SPMP: both"
@/

function fileprint_map_start( file )
{
	 /#
	file = "map_source/" + file + ".map";
	fileprint_start( file );

	// for the entity count
	level.fileprint_mapentcount = 0;

	fileprint_map_header( true );
	#/
	
}

function fileprint_chk( file , str )
{
	/#
		//dodging infinite loops for file dumping. kind of dangerous
		level.fileprintlinecount++;
		if (level.fileprintlinecount>400)
		{
			wait .05;
			level.fileprintlinecount++;
			level.fileprintlinecount = 0;
		}
		fprintln( file, str );
	#/
}

function fileprint_map_header( bInclude_blank_worldspawn )
{
	if ( !isdefined( bInclude_blank_worldspawn ) )
		bInclude_blank_worldspawn = false;
		
	// this may need to be updated if map format changes
	assert( isdefined( level.fileprint ) );
	 /#
	fileprint_chk( level.fileprint, "iwmap 4" );
	fileprint_chk( level.fileprint, "\"000_Global\" flags  active" );
	fileprint_chk( level.fileprint, "\"The Map\" flags" );
	
	if ( !bInclude_blank_worldspawn )
		return;
	 fileprint_map_entity_start();
	 fileprint_map_keypairprint( "classname", "worldspawn" );
	 fileprint_map_entity_end();

	#/
}

/@
"Name: fileprint_map_keypairprint( <key1> , <key2> )"
"Summary: prints a pair of keys to the current open map( by fileprint_map_start() )"
"Module: Fileprint"
"CallOn: Level"
"MandatoryArg: <key1> : "
"MandatoryArg: <key2> : "
"Example: fileprint_map_keypairprint( "classname", "script_model" );"
"SPMP: both"
@/

function fileprint_map_keypairprint( key1, key2 )
{
	 /#
	assert( isdefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "\"" + key1 + "\" \"" + key2 + "\"" );
	#/
}

/@
"Name: fileprint_map_entity_start()"
"Summary: prints entity number and opening bracket to currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_start();"
"SPMP: both"
@/

function fileprint_map_entity_start()
{
	 /#
	assert( !isdefined( level.fileprint_entitystart ) );
	level.fileprint_entitystart = true;
	assert( isdefined( level.fileprint ) );
	fileprint_chk( level.fileprint, "// entity " + level.fileprint_mapentcount );
	fileprint_chk( level.fileprint, "{" );
	level.fileprint_mapentcount ++ ;
	#/
}

/@
"Name: fileprint_map_entity_end()"
"Summary: close brackets an entity, required for the next entity to begin"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_map_entity_end();"
"SPMP: both"
@/

function fileprint_map_entity_end()
{
	 /#
	assert( isdefined( level.fileprint_entitystart ) );
	assert( isdefined( level.fileprint ) );
	level.fileprint_entitystart = undefined;
	fileprint_chk( level.fileprint, "}" );
	#/
}

/@
"Name: fileprint_end()"
"Summary: saves the currently opened file"
"Module: Fileprint"
"CallOn: Level"
"Example: fileprint_end();"
"SPMP: both"
@/
 
function fileprint_end()
{
	 /#
	assert( !isdefined( level.fileprint_entitystart ) );
	saved = closefile( level.fileprint );
	if (saved != 1)
	{
		println("-----------------------------------");
		println(" ");
		println("file write failure");
		println("file with name: "+level.fileprint_filename);
		println("make sure you checkout the file you are trying to save");
		println("note: USE P4 Search to find the file and check that one out");
		println("      Do not checkin files in from the xenonoutput folder, ");
		println("      this is junctioned to the proper directory where you need to go");
		println("junctions looks like this");
		println(" ");
		println("..\\xenonOutput\\scriptdata\\createfx      ..\\share\\raw\\maps\\createfx");
		println("..\\xenonOutput\\scriptdata\\createart     ..\\share\\raw\\maps\\createart");
		println("..\\xenonOutput\\scriptdata\\vision        ..\\share\\raw\\vision");
		println("..\\xenonOutput\\scriptdata\\scriptgen     ..\\share\\raw\\maps\\scriptgen");
		println("..\\xenonOutput\\scriptdata\\zone_source   ..\\xenon\\zone_source");
		println("..\\xenonOutput\\accuracy                  ..\\share\\raw\\accuracy");
		println("..\\xenonOutput\\scriptdata\\map_source    ..\\map_source\\xenon_export");
		println(" ");
		println("-----------------------------------");
		
		println( "File not saved( see console.log for info ) " );
	}
	level.fileprint = undefined;
	level.fileprint_filename = undefined;
	#/
}

/@
"Name: fileprint_radiant_vec( <vector> )"
"Summary: this converts a vector to a .map file readable format"
"Module: Fileprint"
"CallOn: An entity"
"MandatoryArg: <vector> : "
"Example: origin_string = fileprint_radiant_vec( vehicle.angles )"
"SPMP: both"
@/
function fileprint_radiant_vec( vector )
{
	 /#
		string = "" + vector[ 0 ] + " " + vector[ 1 ] + " " + vector[ 2 ] + "";
		return string;
	#/
}


function is_mature()
{
	return GetLocalProfileInt( "cg_mature" );
}

function is_german_build()
{
/*	if( GetDvarString( "language" ) == "german" )
	{
		return true;
	}
*/	
	return false;
}

function is_gib_restricted_build()
{
	language = GetDvarString( "language" );

	if( language == "japanese" || language == "fulljapanese" )
	{
		return true;
	}

	return false;
}

// Facial animation event notify wrappers
function death_notify_wrapper( attacker, damageType )
{
	level notify( "face", "death", self );
	self notify( "death", attacker, damageType );
}

function damage_notify_wrapper( damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags )
{
	level notify( "face", "damage", self );
	self notify( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags );
}

function explode_notify_wrapper()
{
	level notify( "face", "explode", self );
	self notify( "explode" );
}

function alert_notify_wrapper()
{
	level notify( "face", "alert", self );
	self notify( "alert" );
}

function shoot_notify_wrapper()
{
	level notify( "face", "shoot", self );
	self notify( "shoot" );
}

function melee_notify_wrapper()
{
	level notify( "face", "melee", self );
	self notify( "melee" );
}

function isUsabilityEnabled()
{
	return ( !self.disabledUsability );
}


function _disableUsability()
{
	self.disabledUsability++;
	self DisableUsability();
}


function _enableUsability()
{
	self.disabledUsability--;
	
	assert( self.disabledUsability >= 0 );
	
	if ( !self.disabledUsability )
		self EnableUsability();
}


function resetUsability()
{
	self.disabledUsability = 0;
	self EnableUsability();
}


function _disableWeapon()
{
	if (!isdefined(self.disabledWeapon))
		self.disabledWeapon = 0;

	self.disabledWeapon++;
	self disableWeapons();
}

function _enableWeapon()
{
	self.disabledWeapon--;
	
	assert( self.disabledWeapon >= 0 );
	
	if ( !self.disabledWeapon )
		self enableWeapons();
}

function isWeaponEnabled()
{
	return ( !self.disabledWeapon );
}

function orient_to_normal( normal )
{
	hor_normal = ( normal[ 0 ], normal[ 1 ], 0 );
	hor_length = Length( hor_normal );

	if ( !hor_length )
	{
		return ( 0, 0, 0 );
	}
	
	hor_dir = VectorNormalize( hor_normal );
	neg_height = normal[ 2 ] * -1;
	tangent = ( hor_dir[ 0 ] * neg_height, hor_dir[ 1 ] * neg_height, hor_length );
	plant_angle = VectorToAngles( tangent );

	//println("^6hor_normal is ", hor_normal);
	//println("^6hor_length is ", hor_length);
	//println("^6hor_dir is ", hor_dir);
	//println("^6neg_height is ", neg_height);
	//println("^6tangent is ", tangent);
	//println("^6plant_angle is ", plant_angle);

	return plant_angle;
}
/@
"Name: delay(<delay>, <endon>, <function>, <arg1>, <arg2>, <arg3>, <arg4>, <arg5>)"
"Summary: Delay the execution of a thread."
"Module: Utility"
"MandatoryArg: <time_or_notify> : Time to wait( in seconds ) or notify to wait for before sending the notify."
"OptionalArg: <str_endon> : endon to cancel the function call"
"MandatoryArg: <func> : The function to run."
"OptionalArg: <arg1> : parameter 1 to pass to the process"
"OptionalArg: <arg2> : parameter 2 to pass to the process"
"OptionalArg: <arg3> : parameter 3 to pass to the process"
"OptionalArg: <arg4> : parameter 4 to pass to the process"
"OptionalArg: <arg5> : parameter 5 to pass to the process"
"Example: delay( &flag::set, "player_can_rappel", 3 );
"SPMP: singleplayer"
@/
function delay( time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	self thread _delay( time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6 );
}

function _delay( time_or_notify, str_endon, func, arg1, arg2, arg3, arg4, arg5, arg6 )
{
	self endon( "death" );
	
	if ( isdefined( str_endon ) )
	{
		self endon( str_endon );
	}
	
	if ( IsString( time_or_notify ) )
	{
		self waittill( time_or_notify );
	}
	else
	{
		wait time_or_notify;
	}
	
	single_func( self, func, arg1, arg2, arg3, arg4, arg5, arg6 );
}

/@
"Name: delay_notify( <n_delay>, <str_notify>, [str_endon] )"
"Summary: Notifies self the string after waiting the specified delay time"
"Module: Entity"
"CallOn: An entity"
"MandatoryArg: <time_or_notify> : Time to wait( in seconds ) or notify to wait for before sending the notify."
"MandatoryArg: <str_notify> : The string to notify"
"OptionalArg: <str_endon> : Endon to cancel the notify"
"OptionalArg: <arg1> : Optional notify parameter"
"OptionalArg: <arg2> : Optional notify parameter"
"OptionalArg: <arg3> : Optional notify parameter"
"OptionalArg: <arg4> : Optional notify parameter"
"OptionalArg: <arg5> : Optional notify parameter"
"Example: vehicle delay_notify( 3.5, "start_to_smoke" );"
"SPMP: singleplayer"
@/
function delay_notify( time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5 )
{
	self thread _delay_notify( time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5 );
}

function _delay_notify( time_or_notify, str_notify, str_endon, arg1, arg2, arg3, arg4, arg5 )
{
	self endon( "death" );
	
	if ( isdefined( str_endon ) )
	{
		self endon( str_endon );
	}
	
	if ( IsString( time_or_notify ) )
	{
		self waittill( time_or_notify );
	}
	else
	{
		wait time_or_notify;
	}
	
	self notify( str_notify, arg1, arg2, arg3, arg4, arg5 );
}

/*
=============
///ScriptDocBegin
"Name: ter_op( <statement> , <true_value> , <false_value> )"
"Summary: Functon that serves as a tertiary operator in C/C++"
"Module: Utility"
"CallOn: "
"MandatoryArg: <statement>: The statement to evaluate"
"MandatoryArg: <true_value>: The value that is returned when the statement evaluates to true"
"MandatoryArg: <false_value>: That value that is returned when the statement evaluates to false"
"Example: x = ter_op( x > 5, 2, 7 );"
"SPMP: both"
///ScriptDocEnd
=============
*/
/* DEAD CODE REMOVAL
function ter_op( statement, true_value, false_value )
{
	if ( statement )
		return true_value;
	return false_value;
}
*/

/@
"Name: get_closest_player( <org> , <str_team> )"
"Summary: Returns the closest player to the given origin."
"Module: Coop"
"MandatoryArg: <origin>: The vector to use to compare the distances to"
"MandatoryArg: <str_team>: The team to get players from."
"Example: closest_player = get_closest_player( objective.origin );"
"SPMP: singleplayer"
@/
function get_closest_player( org, str_team )
{
	players = GetPlayers( str_team );
	return ArraySort( players, org, true, 1 )[0];
}

function registerClientSys(sSysName)
{
	if(!isdefined(level._clientSys))
	{
		level._clientSys = [];
	}
	
	if(level._clientSys.size >= 32)	
	{
		/#AssertMsg("Max num client systems exceeded.");#/
		return;
	}
	
	if(isdefined(level._clientSys[sSysName]))
	{
		/#AssertMsg("Attempt to re-register client system : " + sSysName);#/
		return;
	}
	else
	{
		level._clientSys[sSysName] = spawnstruct();
		level._clientSys[sSysName].sysID = ClientSysRegister(sSysName);
	}	
}

function setClientSysState(sSysName, sSysState, player)
{
	if(!isdefined(level._clientSys))
	{
		/#AssertMsg("setClientSysState called before registration of any systems.");#/
		return;
	}
	
	if(!isdefined(level._clientSys[sSysName]))
	{
		/#AssertMsg("setClientSysState called on unregistered system " + sSysName);#/
		return;
	}
	
	if(isdefined(player))
	{
		player ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
	}
	else
	{
		ClientSysSetState(level._clientSys[sSysName].sysID, sSysState);
		level._clientSys[sSysName].sysState = sSysState;
	}
}

function getClientSysState(sSysName)
{
	if(!isdefined(level._clientSys))
	{
		/#AssertMsg("Cannot getClientSysState before registering any client systems.");#/
		return "";
	}
	
	if(!isdefined(level._clientSys[sSysName]))
	{
		/#AssertMsg("Client system " + sSysName + " cannot return state, as it is unregistered.");#/
		return "";
	}
	
	if(isdefined(level._clientSys[sSysName].sysState))
	{
		return level._clientSys[sSysName].sysState;
	}
	
	return "";
}

function clientNotify(event)
{
	if(level.clientscripts)
	{
		if(IsPlayer(self))
		{
			setClientSysState("levelNotify", event, self);
		}
		else
		{
			setClientSysState("levelNotify", event);
		}
	}
}

function coopGame()
{
	return ( SessionModeIsSystemlink() || ( SessionModeIsOnlineGame() || IsSplitScreen() ) );
}

/@
"Name: is_looking_at( <ent_or_org>, [n_dot_range], [do_trace] )"
"Summary: Checks to see if an entity is facing a point within a specified dot then returns true or false. Can use bullet trace."
"Module: Entity"
"CallOn: Entity"
"MandatoryArg: <ent_or_org> entity or origin to check against"
"OptionalArg: [n_dot_range] custom dot range. Defaults to 0.8"
"OptionalArg: [do_trace] does a bullet trace along with checking the dot. Defaults to false"
"Example: is_facing_woods = player util::is_looking_at( level.woods.origin );"
"SPMP: singleplayer"
@/
function is_looking_at( ent_or_org, n_dot_range = 0.67, do_trace = false, v_offset )
{
	Assert( isdefined( ent_or_org ), "ent_or_org is required parameter for is_facing function" );

	v_point = ( IsVec( ent_or_org ) ? ent_or_org : ent_or_org.origin );
	
	if ( IsVec( v_offset ) )
	{
		v_point += v_offset;
	}
	
	b_can_see = false;
	b_use_tag_eye = false;
	
	if ( IsPlayer( self ) || IsAI( self ) )
	{
		b_use_tag_eye = true;
	}
	
	n_dot = self math::get_dot_direction( v_point, false, true, "forward", b_use_tag_eye );
	
	if ( n_dot > n_dot_range )
	{
		if ( do_trace )
		{
			v_eye = self get_eye();
			b_can_see = SightTracePassed( v_eye, v_point, false, ent_or_org );
		}
		else
		{
			b_can_see = true;
		}
	}
	
	return b_can_see;
}

/@
"Name: get_eye()"
"Summary: Get eye position accurately even on a player when linked to an entity."
"Module: Utility"
"CallOn: Player or AI"
"Example: eye_pos = player get_eye();"
"SPMP: singleplayer"
@/
function get_eye()
{
	if ( IsPlayer( self ) )
	{
		linked_ent = self GetLinkedEnt();
		if ( isdefined( linked_ent ) && ( GetDvarint( "cg_cameraUseTagCamera" ) > 0 ) )
		{
			camera = linked_ent GetTagOrigin( "tag_camera" );
			if ( isdefined( camera ) )
			{
				return camera;
			}
		}
	}

	pos = self GetEye();
	return pos;
}

/@
"Name: is_ads()"
"Summary: Returns true if the player is more than 50% ads"
"Module: Utility"
"Example: player_is_ads = level.player is_ads();"
"SPMP: singleplayer"
@/
function is_ads()
{
	return ( self playerADS() > 0.5 );
}

/@
"Name: spawn_model(<model_name>, [origin], [angles], [spawnflags])"
"Summary: Spawns a model at an origin and angles."
"Module: Utility"
"MandatoryArg: <model_name> the model name."
"OptionalArg: [origin] the origin to spawn the model at."
"OptionalArg: [angles] the angles to spawn the model at."
"OptionalArg: [spawnflags] the spawnflags for the model."
"Example: fx_model = spawn_model("tag_origin", org, ang);"
@/
function spawn_model( model_name, origin, angles, n_spawnflags = 0 )
{
	if ( !isdefined( origin ) )
	{
		origin = ( 0, 0, 0 );
	}

	model = Spawn( "script_model", origin, n_spawnflags );
	model SetModel( model_name );

	if ( isdefined( angles ) )
	{
		model.angles = angles;
	}

	return model;
}

#using_animtree( "generic" );

/@
"Name: spawn_anim_model(<model_name>, [origin], [angles], [spawnflags])"
"Summary: Spawns a model ready for animation at an origin and angles."
"Module: Utility"
"MandatoryArg: <model_name> the model name."
"OptionalArg: [origin] the origin to spawn the model at."
"OptionalArg: [angles] the angles to spawn the model at."
"OptionalArg: [spawnflags] the spawnflags for the model."
"Example: fx_model = spawn_anim_model("tag_origin", org, ang);"
@/
function spawn_anim_model( model_name, origin, angles, n_spawnflags = 0 )
{
	model = spawn_model( model_name, origin, angles, n_spawnflags );
	model UseAnimTree( #animtree );
	model.animtree = "generic";
	return model;
}

#using_animtree( "all_player" );
/@
"Name: spawn_anim_player_model(<model_name>, [origin], [angles], [spawnflags])"
"Summary: Spawns a model ready for animation at an origin and angles using the player animtree."
"Module: Utility"
"MandatoryArg: <model_name> the model name."
"OptionalArg: [origin] the origin to spawn the model at."
"OptionalArg: [angles] the angles to spawn the model at."
"OptionalArg: [spawnflags] the spawnflags for the model."
"Example: fx_model = spawn_anim_model("tag_origin", org, ang);"
@/
function spawn_anim_player_model( model_name, origin, angles, n_spawnflags = 0 )
{
	model = spawn_model( model_name, origin, angles, n_spawnflags );
	model UseAnimTree( #animtree );
	model.animtree = "all_player";
	return model;
}

/@
"Name: waittill_player_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Returns when the player can dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you are waitting for player to look at"
"OptionalArg: <arc_angle_degrees> Optional arc in degrees from the leftmost limit to the rightmost limit. e.g. 90 is a quarter circle. Default is 90."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"OptionalArg: <e_ignore> Entity to ignore for optional bullet trace"
"Example: if ( GetPlayers()[0] waittill_player_looking_at( org.origin ) )"
"SPMP: singleplayer"
@/
function waittill_player_looking_at( origin, arc_angle_degrees = 90, do_trace, e_ignore )
{
	self endon( "death" );
	
	arc_angle_degrees = AbsAngleClamp360( arc_angle_degrees );
	dot = cos( arc_angle_degrees * 0.5 );
	
	while ( !is_player_looking_at( origin, dot, do_trace, e_ignore ) )
	{
		wait .05;
	}
}

/@
"Name: waittill_player_not_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Returns when the player cannot dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you're waitting for player to look at"
"OptionalArg: <dot> Optional override dot (between 0 and 1) the higher the number, the more the player has to be looking right at the spot."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"Example: if ( GetPlayers()[0] waittill_player_not_looking_at( org.origin ) )"
"SPMP: singleplayer"
@/
function waittill_player_not_looking_at( origin, dot, do_trace )
{
	self endon( "death" );
	
	while ( is_player_looking_at( origin, dot, do_trace ) )
	{
		wait .05;
	}
}

/@
"Name: is_player_looking_at( <origin>, <dot>, <do_trace> )"
"Summary: Checks to see if the player can dot and trace to a point"
"Module: Player"
"CallOn: A Player"
"MandatoryArg: <org> The position you're checking if the player is looking at"
"OptionalArg: <dot> Optional override dot (between 0 and 1) the higher the number, the more the player has to be looking right at the spot."
"OptionalArg: <do_trace> Set to false to skip the bullet trace check"
"OptionalArg: <ignore_ent> Ignore ent passed to trace check"
"Example: if ( GetPlayers()[0] is_player_looking_at( org.origin ) )"
"SPMP: singleplayer"
@/
function is_player_looking_at(origin, dot, do_trace, ignore_ent)
{
	assert(IsPlayer(self), "player_looking_at must be called on a player.");

	if (!isdefined(dot))
	{
		dot = .7;
	}

	if (!isdefined(do_trace))
	{
		do_trace = true;
	}

	eye = self get_eye();

	delta_vec = VectorNormalize(origin - eye);
	view_vec = AnglesToForward(self GetPlayerAngles());
		
	new_dot = VectorDot( delta_vec, view_vec );
	if ( new_dot >= dot )
	{
		if (do_trace)
		{
			return BulletTracePassed( origin, eye, false, ignore_ent );
		}
		else
		{
			return true;
		}
	}
	
	return false;
}

function wait_endon( waitTime, endOnString, endonString2, endonString3, endonString4 )
{
	self endon ( endOnString );
	if ( isdefined( endonString2 ) )
		self endon ( endonString2 );
	if ( isdefined( endonString3 ) )
		self endon ( endonString3 );
	if ( isdefined( endonString4 ) )
		self endon ( endonString4 );
	
	wait ( waitTime );
	return true;
}

function WaitTillEndOnThreaded( waitCondition, callback, endCondition1, endCondition2, endCondition3 )
{
	if( isdefined( endCondition1 ) )
		self endon( endCondition1 );
	if( isdefined( endCondition2 ) )
		self endon( endCondition2 );
	if( isdefined( endCondition3 ) )
		self endon( endCondition3 );
	
	self waittill( waitCondition );
	
	if( isdefined( callback ) )
	{
		[[ callback ]]( waitCondition );
	}
}

// TIME

function new_timer( n_timer_length )
{
	s_timer = SpawnStruct();
	s_timer.n_time_created = GetTime();
	s_timer.n_length = n_timer_length;
	return s_timer;
}

function get_time()
{
	t_now = GetTime();
	return t_now - self.n_time_created;
}

function get_time_in_seconds()
{
	return get_time() / 1000;
}

function get_time_frac( n_end_time )
{
	if(!isdefined(n_end_time))n_end_time=self.n_length;	
	return ( LerpFloat( 0, 1, get_time_in_seconds() / n_end_time ) );
}

function get_time_left()
{
	if ( isdefined( self.n_length ) )
	{
		n_current_time = get_time_in_seconds();
		return ( Max( self.n_length - n_current_time, 0 ) );
	}

	return -1;
}

function is_time_left()
{
	return ( get_time_left() != 0 );
}

function timer_wait( n_wait )
{
	if ( isdefined( self.n_length ) )
	{
		n_wait = Min( n_wait, get_time_left() );
	}
	
	wait n_wait;
	
	n_current_time = get_time_in_seconds();
	
	return n_current_time;
}

// if primary weapon damage
function is_primary_damage( meansofdeath )
{
	// including pistols as well since sometimes they share ammo
	if( meansofdeath == "MOD_RIFLE_BULLET" || meansofdeath == "MOD_PISTOL_BULLET" )
		return true;
	return false;
}

function delete_on_death( ent )
{
	ent endon( "death" );
	self waittill( "death" );
	if( isdefined( ent ) )
	{
		ent delete();
	}
}

/@
"Name: wait_till_not_touching( <ent> )"
"Summary: Blocking function. Returns when entity one is no longer touching entity two or either entity dies."
"Module: Util"
"MandatoryArg: <e_to_check>: The entity you want to check"
"MandatoryArg: <e_to_touch>: The entity you want to touch"	
"Example: util::wait_till_not_touching( player, t_player_safe )"
"SPMP: singleplayer"
@/
function wait_till_not_touching( e_to_check, e_to_touch )
{
	Assert( isdefined( e_to_check ), "Undefined check entity passed to util::wait_till_not_touching" );
	Assert( isdefined( e_to_touch ), "Undefined touch entity passed to util::wait_till_not_touching" );
	
	e_to_check endon( "death" );
	e_to_touch endon( "death" );	
	
	while( e_to_check IsTouching( e_to_touch ) )
	{
		{wait(.05);};
	}
}

/@
"Name: any_player_is_touching( <ent>, <team> )"
"Summary: Return true/false if any player is touching the given entity."
"MandatoryArg: <ent>: The entity to check against if a player is touching"
"MandatoryArg: <ent>: What team to check, if undefined, checks all players"
"Example: if ( any_player_is_touching( trigger, "allies" ) )"
@/
function any_player_is_touching( ent, str_team )
{
	foreach ( player in GetPlayers( str_team ) )
	{
		if ( IsAlive( player ) && player IsTouching( ent ) )
		{
			return true;
		}
	}

	return false;
}

/@
"Name: waittill_notify_or_timeout( <msg>, <timer> )"
"Summary: Waits until the owner receives the specified notify message or the specified time runs out. Do not thread this!"
"Module: Utility"
"CallOn: an entity"
"Example: tank waittill_notify_or_timeout( "turret_on_target", 10 ); "
"MandatoryArg: <msg> : The notify to wait for."
"MandatoryArg: <timer> : The amount of time to wait until overriding the wait statement."
"SPMP: singleplayer"
@/
function waittill_notify_or_timeout( msg, timer )
{
	self endon( msg );
	wait( timer );
	return true;
}

function set_console_status()
{
	if ( !isdefined( level.Console ) )
	{
		level.Console = GetDvarString( "consoleGame" ) == "true";
	}
	else
	{
		assert( level.Console == ( GetDvarString( "consoleGame" ) == "true" ), "Level.console got set incorrectly." );
	}

	if ( !isdefined( level.Consolexenon ) )
	{
		level.xenon = GetDvarString( "xenonGame" ) == "true";
	}
	else
	{
		assert( level.xenon == ( GetDvarString( "xenonGame" ) == "true" ), "Level.xenon got set incorrectly." );
	}
}

//TODO T7 - remove this if gumps get cut
function waittill_asset_loaded( str_type, str_name )
{
	//TODO T7 - need IsAssetLoaded moved to unified
	/*while ( !IsAssetLoaded( str_type, str_name ) )
	{
		level waittill( "gump_loaded" );
	}*/
}

function script_wait( called_from_spawner = false )
{
	// co-op scaling should only affect calls from spawning functions

	// set to 1 as default, decease scalar as more players join
	coop_scalar = 1;
	if ( called_from_spawner )
	{
		players = GetPlayers();

		if (players.size == 2)
		{
			coop_scalar = 0.7;
		}
		else if (players.size == 3)
		{
			coop_scalar = 0.4;
		}
		else if (players.size == 4)
		{
			coop_scalar = 0.1;
		}
	}

	startTime = GetTime();
	if( isdefined( self.script_wait ) )
	{
		wait( self.script_wait * coop_scalar);

		if( isdefined( self.script_wait_add ) )
		{
			self.script_wait += self.script_wait_add;
		}
	}
	else if( isdefined( self.script_wait_min ) && isdefined( self.script_wait_max ) )
	{
		wait( RandomFloatrange( self.script_wait_min, self.script_wait_max ) * coop_scalar);

		if( isdefined( self.script_wait_add ) )
		{
			self.script_wait_min += self.script_wait_add;
			self.script_wait_max += self.script_wait_add;
		}
	}

	return( GetTime() - startTime );
}

function is_killstreaks_enabled()
{
	return isdefined( level.killstreaksenabled ) && level.killstreaksenabled;
}

function is_flashbanged()
{
	return isdefined( self.flashEndTime ) && gettime() < self.flashEndTime;
}

/@
"Name: magic_bullet_shield()"
"Summary: Makes an entity invulnerable to death. If it's an AI and it gets shot, it is temporarily ignored by enemies."
"Module: Entity"
"CallOn: Entity"
"Example: guy magic_bullet_shield();"
@/

function magic_bullet_shield( ent )
{
	if(!isdefined(ent))ent=self;
	
	ent.allowdeath = false;
	ent.magic_bullet_shield = true;

	/#
	ent notify("_stop_magic_bullet_shield_debug");
	level thread debug_magic_bullet_shield_death( ent );
	#/

	assert( IsAlive( ent ), "Tried to do magic_bullet_shield on a dead or undefined guy." );

	if ( IsAI( ent ) )
	{
		if ( IsActor( ent ) )
		{
			ent BloodImpact( "hero" );
		}

		ent.attackerAccuracy = 0.1;
	}
}

function debug_magic_bullet_shield_death( guy )
{
	targetname = "none";
	if ( isdefined( guy.targetname ) )
	{
		targetname = guy.targetname;
	}

	guy endon( "stop_magic_bullet_shield" );
	guy endon( "_stop_magic_bullet_shield_debug" );
	guy waittill( "death" );
	Assert( !isdefined( guy ), "Guy died with magic bullet shield on with targetname: " + targetname );
}

#using_animtree( "all_player" );
/@
"Name: spawn_player_clone( <player>, <animname> )"
"Summary: Spawns and returns a scriptmodel that is a clone of the player, and can start a player animation on the clone"
"Module: Player"
"CallOn: "
"MandatoryArg: <player> : the player that needs to be cloned"
"OptionalArg: <animname> : the animation to play on the clone"
"Example: playerClone = spawn_player_clone( player, "pb_rifle_run_lowready_f" );"
"SPMP: "
@/
	
function spawn_player_clone( player, animname )
{	
	playerClone = Spawn( "script_model", player.origin );
	playerClone.angles = player.angles;
	
	//set the body model
	bodyModel = player GetCharacterBodyModel();
	playerClone SetModel( bodyModel );
	
	//set the head
	headModel = player GetCharacterHeadModel();
	if( IsDefined( headModel ) )
	{
		playerClone Attach( headModel, "" );
	}
	
	//set the helmet model
	helmetModel = player GetCharacterHelmetModel();
	if( IsDefined( helmetModel ) )
	{
		playerClone Attach( helmetModel, "" );
	}
	
	//set the render options
	bodyRenderOptions = player GetCharacterBodyRenderOptions();
	playerClone SetBodyRenderOptions( bodyRenderOptions, bodyRenderOptions, bodyRenderOptions );
	
	//setup the animations
	playerClone UseAnimTree( #animtree );
	if( IsDefined( animname ) )
	{
		playerClone AnimScripted( "clone_anim", playerClone.origin, playerClone.angles, animname );
	}
	
	playerClone.health = 100;	
	return playerClone;
}

/@
"Name: stop_magic_bullet_shield()"
"Summary: Stops magic bullet shield on an entity, making him vulnerable to death. Note the health is not set back."
"Module: Entity"
"CallOn: Entity"
"Example: friendly stop_magic_bullet_shield();"
@/

function stop_magic_bullet_shield( ent )
{
	if(!isdefined(ent))ent=self;
	
	ent.allowdeath = true;
	ent.magic_bullet_shield = undefined;

	if ( IsAI( ent ) )
	{
		if ( IsActor( ent ) )
		{
			ent BloodImpact( "normal" );
		}

		ent.attackerAccuracy = 1;	// TODO: restore old value if we need it.
	}

	ent notify("stop_magic_bullet_shield");
}

//Round Functions
function is_one_round()
{		
	if ( level.roundLimit == 1 )
		return true;

	return false;
}

function is_first_round()
{
	if ( level.roundLimit > 1 && game[ "roundsplayed" ] == 0 )
		return true;
		
	return false;
}

function is_lastround()
{		
	if ( level.roundLimit > 1 && game[ "roundsplayed" ] >= ( level.roundLimit - 1 ) )
		return true;
		
	return false;
}

function get_rounds_won( team )
{
	return game["roundswon"][team];
}

function get_other_teams_rounds_won( skip_team )
{
	roundswon = 0;
	
	foreach ( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		roundswon += game["roundswon"][team];
	}
	return roundswon;
}

function get_rounds_played()
{
	return game["roundsplayed"];
}

function is_round_based()
{
	if ( level.roundLimit != 1 && level.roundWinLimit != 1 )
		return true;

	return false;
}

/@
"Name: within_fov( <start_origin> , <start_angles> , <end_origin> , <fov> )"
"Summary: Returns true if < end_origin > is within the players field of view, otherwise returns false."
"Module: Vector"
"CallOn: "
"MandatoryArg: <start_origin> : starting origin for FOV check( usually the players origin )"
"MandatoryArg: <start_angles> : angles to specify facing direction( usually the players angles )"
"MandatoryArg: <end_origin> : origin to check if it's in the FOV"
"MandatoryArg: <fov> : cosine of the FOV angle to use"
"Example: qBool = within_fov( level.player.origin, level.player.angles, target1.origin, cos( 45 ) );"
"SPMP: multiplayer"
@/ 
function within_fov( start_origin, start_angles, end_origin, fov )
{
	normal = VectorNormalize( end_origin - start_origin ); 
	forward = AnglesToForward( start_angles ); 
	dot = VectorDot( forward, normal ); 

	return dot >= fov; 
}

function button_held_think( which_button )
{
	self endon( "disconnect" );

	if(!isdefined(self._holding_button))self._holding_button=[];
	
	self._holding_button[ which_button ] = false;
	
	time_started = 0;
	const use_time = 250; // GetDvarInt("g_useholdtime");

	while ( true )
	{
		if ( self._holding_button[ which_button ] )
		{
			if ( !self [[ level._button_funcs[ which_button ]]]() )
			{
				self._holding_button[ which_button ] = false;
			}
		}
		else
		{
			if ( self [[ level._button_funcs[ which_button ]]]() )
			{
				if ( time_started == 0 )
				{
					time_started = GetTime();
				}

				if ( ( GetTime() - time_started ) > use_time )
				{
					self._holding_button[ which_button ] = true;
				}
			}
			else
			{
				if ( time_started != 0 )
				{
					time_started = 0;
				}
			}
		}

		{wait(.05);};
	}
}

/@
"Name: use_button_held()"
"Summary: Returns true if the player is holding down their use button."
"Module: Player"
"Example: if(player util::use_button_held())"
@/
function use_button_held()
{
	init_button_wrappers();

	if ( !isdefined( self._use_button_think_threaded ) )
	{
		self thread button_held_think( 0 );
		self._use_button_think_threaded = true;
	}

	return self._holding_button[ 0 ];
}

/@
"Name: stance_button_held()"
"Summary: Returns true if the player is holding down their use button."
"Module: Player"
"Example: if(player util::stance_button_held())"
@/
function stance_button_held()
{
	init_button_wrappers();

	if ( !isdefined( self._stance_button_think_threaded ) )
	{
		self thread button_held_think( 1 );
		self._stance_button_think_threaded = true;
	}

	return self._holding_button[ 1 ];
}

/@
"Name: ads_button_held()"
"Summary: Returns true if the player is holding down their ADS button."
"Module: Player"
"Example: if(player util::ads_button_held())"
@/
function ads_button_held()
{
	init_button_wrappers();

	if ( !isdefined( self._ads_button_think_threaded ) )
	{
		self thread button_held_think( 2 );
		self._ads_button_think_threaded = true;
	}

	return self._holding_button[ 2 ];
}

/@
"Name: attack_button_held()"
"Summary: Returns true if the player is holding down their attack button."
"Module: Player"
"Example: if(player util::attack_button_held())"
@/
function attack_button_held()
{
	init_button_wrappers();

	if ( !isdefined( self._attack_button_think_threaded ) )
	{
		self thread button_held_think( 3 );
		self._attack_button_think_threaded = true;
	}

	return self._holding_button[ 3 ];
}

/@
"Name: waittill_use_button_pressed()"
"Summary: Waits until the player is pressing their use button."
"Module: Player"
"Example: player util::waittill_use_button_pressed()"
@/
function waittill_use_button_pressed()
{
	while ( !self UseButtonPressed() )
	{
		{wait(.05);};
	}
}

/@
"Name: waittill_use_button_pressed()"
"Summary: Waits until the player is pressing their use button."
"Module: Player"
"Example: player util::waittill_use_button_pressed()"
@/
function waittill_use_button_held()
{
	while ( !self use_button_held() )
	{
		{wait(.05);};
	}
}

/@
"Name: waittill_stance_button_pressed()"
"Summary: Waits until the player is pressing their stance button."
"Module: Player"
"Example: player util::waittill_stance_button_pressed()"
@/
function waittill_stance_button_pressed()
{
	while ( !self StanceButtonPressed() )
	{
		{wait(.05);};
	}
}

/@
"Name: waittill_stance_button_held()"
"Summary: Waits until the player is pressing their stance button."
"Module: Player"
"Example: player util::waittill_stance_button_held()"
@/
function waittill_stance_button_held()
{
	while ( !self stance_button_held() )
	{
		{wait(.05);};
	}
}

/@
"Name: waittill_attack_button_pressed()"
"Summary: Waits until the player is pressing their attack button."
"Module: Player"
"Example: player util::waittill_attack_button_pressed()"
@/
function waittill_attack_button_pressed()
{
	while ( !self AttackButtonPressed() )
	{
		{wait(.05);};
	}
}

/@
"Name: waittill_ads_button_pressed()"
"Summary: Waits until the player is pressing their ads button."
"Module: Player"
"Example: player util::waittill_ads_button_pressed()"
@/
function waittill_ads_button_pressed()
{
	while ( !self AdsButtonPressed() )
	{
		{wait(.05);};
	}
}

/@
"Name: waittill_vehicle_move_up_button_pressed()"
"Summary: Waits until the player is pressing their vehicle_move_up (set in GDT) button."
"Module: Player"
"Example: player util::waittill_vehicle_move_up_button_pressed()"
@/
function waittill_vehicle_move_up_button_pressed()
{
	while ( !self VehicleMoveUpButtonPressed() )
	{
		{wait(.05);};
	}
}

function init_button_wrappers()
{
	if ( !isdefined( level._button_funcs ) )
	{
		level._button_funcs[ 0 ]		= &UseButtonPressed;
		level._button_funcs[ 2 ]		= &AdsButtonPressed;
		level._button_funcs[ 3 ]	= &AttackButtonPressed;
		level._button_funcs[ 1 ]	= &StanceButtonPressed;
		
		/#
			
		level._button_funcs[ 4 ]		= &up_button_pressed;
		level._button_funcs[ 5 ]		= &down_button_pressed;
		
		#/
	}
}

/#
	
function up_button_held()
{
	init_button_wrappers();

	if ( !isdefined( self._up_button_think_threaded ) )
	{
		self thread button_held_think( 4 );
		self._up_button_think_threaded = true;
	}

	return self._holding_button[ 4 ];
}

function down_button_held()
{
	init_button_wrappers();

	if ( !isdefined( self._down_button_think_threaded ) )
	{
		self thread button_held_think( 5 );
		self._down_button_think_threaded = true;
	}

	return self._holding_button[ 5 ];
}
	
function up_button_pressed()
{
	return ( self ButtonPressed( "UPARROW" ) || self ButtonPressed( "DPAD_UP" ) );
}

function waittill_up_button_pressed()
{
	while ( !self up_button_pressed() )
	{
		{wait(.05);};
	}
}

function down_button_pressed()
{
	return ( self ButtonPressed( "DOWNARROW" ) || self ButtonPressed( "DPAD_DOWN" ) );
}

function waittill_down_button_pressed()
{
	while ( !self down_button_pressed() )
	{
		{wait(.05);};
	}
}

#/

/@
"Name: freeze_player_controls( <boolean> )"
"Summary:  Freezes the player's controls with appropriate 'if' checks"
"Module: Player"
"CallOn: Player"
"MandatoryArg: <boolean> : true or false"
"Example: self util::freeze_player_controls( true )"
"SPMP: MP"
@/ 
function freeze_player_controls( b_frozen = true )
{
	if ( isdefined( level.hostMigrationTimer ) )
	{
		b_frozen = true;
	}

	if( b_frozen || !level.gameEnded )
	{
		self FreezeControls( b_frozen );

	}
}

function is_bot()
{
	return ( IsPlayer( self ) && isdefined ( self.pers["isBot"] ) && self.pers["isBot"] != 0 );
}

function isHacked()
{
	return ( isdefined( self.hacked ) && self.hacked );
}

function getLastWeapon()
{
	last_weapon = undefined;
	
	if( isdefined( self.lastNonKillstreakWeapon ) && self hasWeapon(self.lastNonKillstreakWeapon) )
		last_weapon = self.lastNonKillstreakWeapon;
	else if( isdefined( self.lastDroppableWeapon ) && self hasWeapon(self.lastDroppableWeapon) )
		last_weapon = self.lastDroppableWeapon;

	return last_weapon;
}

function IsEnemyPlayer( player )
{
	assert( isdefined( player ) );

	if ( !isplayer( player ) )
		return false;

	if ( level.teambased )
	{
		if ( player.team == self.team ) 
		{
			return false;
		}
	}
	else
	{
		if ( player == self )
		{
			return false;	
		}
	}
	return true;
}

// to be used with things that are slow.
// unfortunately, it can only be used with things that aren't time critical.
function WaitTillSlowProcessAllowed()
{
	while ( level.lastSlowProcessFrame == gettime() )
		wait .05;
	
	level.lastSlowProcessFrame = gettime();
}

function mayApplyScreenEffect()
{
	assert( isdefined( self ) );
	assert( IsPlayer( self ) );

	return ( !isdefined( self.viewlockedentity ) );
}

function waitTillNotMoving()
{
	if ( self isHacked() )
	{
		{wait(.05);};
		return;
	}
	
	if ( self.classname == "grenade" )
	{
		self waittill("stationary");
	}
	else
	{
		prevorigin = self.origin;
		while(1)
		{
			wait .15;
			if ( self.origin == prevorigin )
				break;
			prevorigin = self.origin;
		}
	}
}


function waitTillRollingOrNotMoving()
{
	if ( self util::isHacked() )
	{
		{wait(.05);};
		return "stationary";
	}
	
	moveState = self util::waittill_any_return("stationary", "rolling");
	return moveState;
}


function getStatsTableName()
{
	if ( SessionModeIsCampaignGame() )
	{
		return "gamedata/stats/cp/cp_statstable.csv";
	}
	else if ( SessionModeIsZombiesGame() )
	{
		return "gamedata/stats/zm/zm_statstable.csv";
	}
	else
	{
		return "gamedata/stats/mp/mp_statstable.csv";
	}
}

function getWeaponClass( weapon )
{
	if( weapon == level.weaponNone )
	{
		return undefined;
	}
	
	if ( !weapon.isValid ) 
	{
		return undefined;
	}

	if ( !isdefined ( level.weaponClassArray ) ) 
	{
		level.weaponClassArray = [];
	}

	if ( isdefined( level.weaponClassArray[weapon] ) )
	{
	    return level.weaponClassArray[weapon];
	}

	baseWeaponIndex =  GetBaseWeaponItemIndex( weapon );
	weaponClass = tableLookup( util::getStatsTableName(), 0, baseWeaponIndex, 2 ); 
	level.weaponClassArray[weapon] = weaponClass;
	return weaponClass;
}

function isUsingRemote()
{
	return( isdefined( self.usingRemote ) );
}

function deleteAfterTime( time )
{
	assert( isdefined( self ) );
	assert( isdefined( time ) );
	assert( time >= 0.05 );

	self thread deleteAfterTimeThread( time );
}

function deleteAfterTimeThread( time )
{
	self endon ( "death" );
	wait ( time );
	
	self delete();
}

function waitForTime( time )
{
	if ( !isdefined( time ) )
	{
		time = 0.0;
	}
	
	if ( time > 0.0 )
	{
		wait ( time );
	}
}

// waits for specified time and one acknowledged network frame
function waitForTimeAndNetworkFrame( time )
{
	if ( !isdefined( time ) )
	{
		time = 0.0;
	}
	
	start_time_ms = GetTime();	
	util::wait_network_frame();
	elapsed_time = (GetTime() - start_time_ms) * 0.001;
	remaining_time = time - elapsed_time;	
	
	if ( remaining_time > 0 )
	{
		wait ( remaining_time );
	}	
}


// deletes entity after specified time has passed and one network frame has been acknowledged
function deleteAfterTimeAndNetworkFrame( time )
{
	assert( isdefined( self ) );
	waitForTimeAndNetworkFrame( time );
	self delete();
}

function drawcylinder( pos, rad, height, duration, stop_notify )
{
/#
	if ( !isdefined( duration ) )
	{
		duration = 0;
	}
	
	level thread drawcylinder_think( pos, rad, height, duration, stop_notify );
#/
}

function drawcylinder_think( pos, rad, height, seconds, stop_notify )
{
/#
	if ( isdefined( stop_notify ) )
	{
		level endon( stop_notify );
	}

	stop_time = GetTime() + ( seconds * 1000 );

	currad = rad; 
	curheight = height; 

	for ( ;; )
	{
		if ( seconds > 0 && stop_time <= GetTime() )
		{
			return;
		}

		for( r = 0; r < 20; r++ )
		{
			theta = r / 20 * 360; 
			theta2 = ( r + 1 ) / 20 * 360; 

			line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, 0 ) ); 
			line( pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ), pos +( cos( theta2 ) * currad, sin( theta2 ) * currad, curheight ) ); 
			line( pos +( cos( theta ) * currad, sin( theta ) * currad, 0 ), pos +( cos( theta ) * currad, sin( theta ) * currad, curheight ) ); 
		}

		{wait(.05);};
	}
#/
}

//entities_s.a[]
function get_team_alive_players_s( teamName )
{	
	teamPlayers_s = spawn_array_struct();
	
	if (isdefined(teamName) &&
		isdefined( level.alivePlayers ) &&
		isdefined( level.alivePlayers[ teamName ] ) )
	{
		for ( i= 0; i < level.alivePlayers[ teamName ].size; i++ )
		{
			teamPlayers_s.a[ teamPlayers_s.a.size ]= level.alivePlayers[ teamName ][ i ];
		}
	}
	
	return teamPlayers_s;
}

function get_other_teams_alive_players_s( teamNameToIgnore )
{	
	teamPlayers_s = spawn_array_struct();
	
	if (isdefined(teamNameToIgnore) &&isdefined( level.alivePlayers ) )
	{
		foreach( team in level.teams )
		{
			if ( team == teamNameToIgnore )
			{
				continue;
			}
			
			foreach ( player in level.alivePlayers[ team ] )
			{
				teamPlayers_s.a[ teamPlayers_s.a.size ] = player;
			}
		}
	}
	
	return teamPlayers_s;
}



//entities_s.a[]
function get_all_alive_players_s()
{
	allPlayers_s = spawn_array_struct();
	
	if ( isdefined( level.alivePlayers ) )
	{
		keys = GetArrayKeys( level.alivePlayers );
		
		for ( i = 0; i < keys.size; i++ )
		{
			team = keys[ i ];
			
			for ( j = 0; j < level.alivePlayers[ team ].size; j++ )
			{
				allPlayers_s.a[ allPlayers_s.a.size ] = level.alivePlayers[ team ][ j ];
			}
		}
	}
	
	return allPlayers_s;
}

/@
"Name: spawn_array_struct()"
"Summary: Creates a struct with an attribute named "a" which is an empty array.  Array structs are useful for passing around arrays by reference."
"Module: Array"
"CallOn: "
"Example: fxemitters = spawn_struct_array(); fxemitters.a[ fxemitters.size ] = new_emitter;"
"SPMP: both"
@/ 
function spawn_array_struct()
{
	s= SpawnStruct();
	s.a= [];
	return s;
}


function getHostPlayer()
{
	players = GetPlayers();
	
	for ( index = 0; index < players.size; index++ )
	{
		if ( players[index] IsHost() )
			return players[index];
	}
}


function getHostPlayerForBots()
{
	players = GetPlayers();
	
	for ( index = 0; index < players.size; index++ )
	{
		if ( players[index] IsHostForBots() )
			return players[index];
	}
}



/@
"Name: get_array_of_closest( <org> , <array> , <excluders> , <max>, <maxdist> )"
"Summary: Returns an array of all the entities in < array > sorted in order of closest to farthest."
"Module: Distance"
"CallOn: "
"MandatoryArg: <org> : Origin to be closest to."
"MandatoryArg: <array> : Array of entities to check distance on."
"OptionalArg: <excluders> : Array of entities to exclude from the check."
"OptionalArg: <max> : Max size of the array to return"
"OptionalArg: <maxdist> : Max distance from the origin to return acceptable entities"
"Example: allies_sort = get_array_of_closest( originFC1.origin, allies );"
"SPMP: singleplayer"
@/
function get_array_of_closest( org, array, excluders, max, maxdist )
{
	// pass an array of entities to this function and it will return them in the order of closest
	// to the origin you pass, you can also set max to limit how many ents get returned
	
	if(!isdefined(max))max=array.size;
	if(!isdefined(excluders))excluders=[];

	maxdists2rd = undefined;
	if ( isdefined( maxdist ) )
	{
		maxdists2rd = maxdist * maxdist;
	}

	// return the array, reordered from closest to farthest
	dist = [];
	index = [];
	for ( i = 0; i < array.size; i++ )
	{
		if ( !isdefined( array[ i ] ) )
		{
			continue;
		}
		
		if ( IsInArray( excluders, array[ i ] ) )
		{
			continue;
		}

		if ( IsVec( array[i] ) )
		{
			length = DistanceSquared( org, array[ i ] );
		}
		else
		{
			length = DistanceSquared( org, array[ i ].origin );
		}

		if ( isdefined( maxdists2rd ) && maxdists2rd < length )
		{
			continue;
		}

		dist[ dist.size ] = length;
		index[ index.size ] = i;
	}

	for ( ;; )
	{
		change = false;
		for ( i = 0; i < dist.size - 1; i++ )
		{
			if ( dist[ i ] <= dist[ i + 1 ] )
			{
				continue;
			}
			
			change = true;
			temp = dist[ i ];
			dist[ i ] = dist[ i + 1 ];
			dist[ i + 1 ] = temp;
			temp = index[ i ];
			index[ i ] = index[ i + 1 ];
			index[ i + 1 ] = temp;
		}
		
		if ( !change )
		{
			break;
		}
	}

	newArray = [];
	if ( max > dist.size )
	{
		max = dist.size;
	}
	
	for ( i = 0; i < max; i++ )
	{
		newArray[ i ] = array[ index[ i ] ];
	}
	
	return newArray;
}

/@
"Name: set_lighting_state( <n_state> )"
"Summary: Sets the lighting state for the level - for all players, and handles hot-join, or on a specific player."
"CallOn: level or player"
"MandatoryArg: <n_state> : Lighting state."
"Example: set_lighting_state( 2 );"
@/
function set_lighting_state( n_state )
{
	if ( isdefined( n_state ) )
	{
		self.lighting_state = n_state;
	}
	else
	{
		self.lighting_state = level.lighting_state;
	}
	
	if ( isdefined( self.lighting_state ) )
	{
		if ( self == level )
		{
			if ( isdefined( level.activePlayers ) )
			{
				foreach( player in level.activePlayers )
				{
					player set_lighting_state( level.lighting_state );
				}
			}
		}
		else if ( IsPlayer( self ) )
		{
			self SetLightingState( self.lighting_state );
		}
		else
		{
			AssertMsg( "Can only set lighting state on level or a player." );
		}
	}
}

/@
"Name: set_sun_shadow_split_distance( <distance> )"
"Summary: Sets the sun shadow split distance  for the level - for all players, and handles hot-join, or on a specific player."
"CallOn: level or player"
"MandatoryArg: <n_state> : Lighting state."
"Example: set_lighting_state( 2 );"
@/
function set_sun_shadow_split_distance( f_distance )
{
	if ( isdefined( f_distance ) )
	{
		self.sun_shadow_split_distance = f_distance;
	}
	else
	{
		self.sun_shadow_split_distance = level.sun_shadow_split_distance;
	}
	
	if ( isdefined( self.sun_shadow_split_distance ) )
	{
		if ( self == level )
		{
			if ( isdefined( level.activePlayers ) )
			{
				foreach( player in level.activePlayers )
				{
					player set_sun_shadow_split_distance( level.sun_shadow_split_distance );
				}
			}
		}
		else if ( IsPlayer( self ) )
		{
			self SetSunShadowSplitDistance( self.sun_shadow_split_distance );
		}
		else
		{
			AssertMsg( "Can only set_sun_shadow_split_distance on level or a player." );
		}
	}
}


/@
"Name: auto_delete( n_mode, n_min_time_alive, n_dist_horizontal, n_dist_vertical )"
"Summary: Deletes an entity when it is determined to be safe to delete (sight checks, times alive, etc.)"

"CallOn: entity to delete"

"OptionalArg: [n_mode] can be DELETE_SAFE (default), DELETE_BEHIND, DELETE_BLOCKED, DELETE_BOTH, or DELETE_AGGRESSIVE (defined in shared.gsh)."
"OptionalArg: [n_min_time_alive] minimum time that the ent should be alive before deleting."
"OptionalArg: [n_dist_horizontal] minimum distance that the entity has to be at from players before deleting."
"OptionalArg: [n_dist_vertical] minimum distance that the entity has to be at from players before deleting."

"Example: ai thread auto_delete(); // DELETE_SAFE by default"
"Example: ai thread auto_delete( DELETE_BEHIND ); // delete if behind all players"
"Example: ai thread auto_delete( DELETE_BLOCKED ); // delete if no players can see"
"Example: ai thread auto_delete( DELETE_BOTH ); // delete if no players can see OR behind all players"
"Example: ai thread auto_delete( DELETE_AGGRESSIVE ); // aggressive version of DELETE_BOTH"
@/
function auto_delete( n_mode = 1, n_min_time_alive = 0, n_dist_horizontal = 0, n_dist_vertical = 0 )
{
	self endon( "death" );
	
	self notify( "__auto_delete__" );
	self endon( "__auto_delete__" );
		
	level flag::wait_till( "all_players_spawned" );
	
	if ( isdefined( level.heroes ) && IsInArray( level.heroes, self ) )
	{
		return;
	}
	
	if ( n_mode & 16 || n_mode == 1 || n_mode == 8 )
	{
		// In all of these modes, we need to potentially check both conditions
		// Setting these bits helps simplify the logic
		
		n_mode |= 2;
		n_mode |= 4;
	}
	
	n_think_time = 1;
	n_tests_to_do = 2;
	n_dot_check = 0;
	
	if ( n_mode & 16 )
	{
		n_think_time = .2;
		n_tests_to_do = 1;
		n_dot_check = .4;
	}
	
	n_test_count = 0;
	
	while ( true )
	{
		do
		{
			wait randomfloatrange(n_think_time-n_think_time/3,n_think_time+n_think_time/3);
		}
		while ( isdefined( self.birthtime ) && ( ( GetTime() - self.birthtime ) / 1000 ) < n_min_time_alive );
		
		n_tests_passed = 0;
					
		foreach ( player in level.players )
		{
			if ( n_dist_horizontal && ( Distance2DSquared( self.origin, player.origin ) < n_dist_horizontal ) )
			{
				continue;
			}
			
			if ( n_dist_vertical && ( abs( self.origin[2] - player.origin[2] ) < n_dist_vertical ) )
			{
				continue;
			}
			
			v_eye = player GetEye();
			
			b_behind = false;
			
			if ( n_mode & 2 )
			{
				v_facing = AnglesToForward( player GetPlayerAngles() );
			
				v_to_ent = VectorNormalize( self.origin - v_eye );
				n_dot = VectorDot( v_facing, v_to_ent );
				
				if ( n_dot < n_dot_check )
				{
					b_behind = true;
					
					if ( !( n_mode & 1 ) )
					{
						n_tests_passed++;
						continue;
					}
				}
			}
			
			if ( n_mode & 4 )
			{
				if ( !self SightConeTrace( v_eye, player ) )
				{
					if ( b_behind || !( n_mode & 1 ) )
						n_tests_passed++;
				}
			}
		}
		
		if ( n_tests_passed == level.players.size )
		{
			n_test_count++;
			if ( n_test_count < n_tests_to_do )
			{
				continue;
			}
			
			self notify( "_disable_reinforcement" );
			self Delete();
		}
		else
		{
			n_test_count = 0;
		}
	}
}

/@
"Name: query_ents( <a_kvps_match>, [a_kvps_ingnore], [b_ignore_spawners = false], [b_match_substrings = false] )"
"Summary: Do complex lookups for entites based on matching or mot matching a list of KVPs"

"MandatoryArg: <a_kvps_match> An associative array of KVPs to match."
"MandatoryArg: [a_kvps_ingnore] An associative array of KVPs to not match (will not return any entities that match these)."
"OptionalArg: [b_ignore_spawners] Ignore spawners (defaults to false)."
"OptionalArg: [b_match_substrings] Matches substrings of the given KVP values (only supports specific KVPs)."
"OptionalArg: [b_match_all] Set to 'true' to match *all* keys, 'false' to match *any* key."

Example:

	a_ents = util::query_ents(
		AssociativeArray( "targetname", "targetname_i_want_to_get" ),
		AssociativeArray( "script_noteworthy", "i_dont_want_anything_with_this_script_noteworthy" ),
		false,
		true
	);
@/
function query_ents( &a_kvps_match, b_match_all = true, &a_kvps_ingnore, b_ignore_spawners = false, b_match_substrings = false )
{
	a_ret = [];
	
	if ( b_match_substrings )
	{
		a_all_ents = GetEntArray();
		
		b_first = true;
		foreach ( k, v in a_kvps_match )
		{
			a_ents = _query_ents_by_substring_helper( a_all_ents, v, k, b_ignore_spawners );
			
			if ( b_first )
			{
				a_ret = a_ents;
				b_first = false;
			}
			else if ( b_match_all )
			{
				a_ret = ArrayIntersect( a_ret, a_ents );
			}
			else
			{
				a_ret = ArrayCombine( a_ret, a_ents, false, false );				
			}
		}
		
		if ( isdefined( a_kvps_ingnore ) )
		{
			foreach ( k, v in a_kvps_ingnore )
			{
				a_ents = _query_ents_by_substring_helper( a_all_ents, v, k, b_ignore_spawners );
				a_ret = array::exclude( a_ret, a_ents );
			}
		}
	}
	else
	{	
		b_first = true;
		foreach ( k, v in a_kvps_match )
		{
			a_ents = GetEntArray( v, k );
			
			if ( b_first )
			{
				a_ret = a_ents;
				b_first = false;
			}
			else if ( b_match_all )
			{
				a_ret = ArrayIntersect( a_ret, a_ents );
			}
			else
			{
				a_ret = ArrayCombine( a_ret, a_ents, false, false );				
			}
		}
		
		if ( isdefined( a_kvps_ingnore ) )
		{
			foreach ( k, v in a_kvps_ingnore )
			{
				a_ents = GetEntArray( v, k );
				a_ret = array::exclude( a_ret, a_ents );
			}
		}
	}
	
	return a_ret;
}

function _query_ents_by_substring_helper( &a_ents, str_value, str_key = "targetname", b_ignore_spawners = false )
{
	a_ret = [];
	
	foreach ( ent in a_ents )
	{
		if ( b_ignore_spawners && IsSpawner( ent ) )
		{
			continue;
		}
		
		switch ( str_key )
		{
			case "targetname":
				
				if ( IsString( ent.targetname ) && IsSubStr( ent.targetname, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			case "script_noteworthy":
				
				if ( IsString( ent.script_noteworthy ) && IsSubStr( ent.script_noteworthy, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			case "classname":
				
				if ( IsString( ent.classname ) && IsSubStr( ent.classname, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			case "vehicletype":
				
				if ( IsString( ent.vehicletype ) && IsSubStr( ent.vehicletype, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			case "script_string":
				
				if ( IsString( ent.script_string ) && IsSubStr( ent.script_string, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			case "script_color_axis":
				
				if ( IsString( ent.script_color_axis ) && IsSubStr( ent.script_color_axis, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			case "script_color_allies":
				
				if ( IsString( ent.script_color_axis ) && IsSubStr( ent.script_color_axis, str_value ) )
				{
					if ( !isdefined( a_ret ) ) a_ret = []; else if ( !IsArray( a_ret ) ) a_ret = array( a_ret ); a_ret[a_ret.size]=ent;;
				}
				break;
				
			default: Assert( "Unsupported key: '" + str_key + "' use in util::query_ents()." );
		}
	}
	
	return a_ret;
}

function get_weapon_by_name( weapon_name )
{
	split = StrTok( weapon_name, "+" );
	switch ( split.size )
	{
		default:
		case 1:
			weapon = GetWeapon( split[0] );
			break;
		case 2:
			weapon = GetWeapon( split[0], split[1] );
			break;
		case 3:
			weapon = GetWeapon( split[0], split[1], split[2] );
			break;
		case 4:
			weapon = GetWeapon( split[0], split[1], split[2], split[3] );
			break;
		case 5:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4] );
			break;
		case 6:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5] );
			break;
		case 7:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6] );
			break;
		case 8:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7] );
			break;
		case 9:
			weapon = GetWeapon( split[0], split[1], split[2], split[3], split[4], split[5], split[6], split[7], split[8] );
			break;
	}
	return weapon;
}

function is_female()
{
	return ( self GetPlayerGenderType( CurrentSessionMode() ) == "female" );
}

// get array of points on navmesh
function PositionQuery_PointArray( origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, reachableBy_Ent )
{
	if ( isdefined( reachableBy_ent ) )
	{
		queryResult = PositionQuery_Source_Navigation( origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing, reachableBy_Ent );
	}
	else
	{
		queryResult = PositionQuery_Source_Navigation( origin, minSearchRadius, maxSearchRadius, halfHeight, innerSpacing );
	}

	pointarray = [];
	foreach( pointStruct in queryResult.data )
	{
		if ( !isdefined( pointarray ) ) pointarray = []; else if ( !IsArray( pointarray ) ) pointarray = array( pointarray ); pointarray[pointarray.size]=pointStruct.origin;;
	}
	
	return pointarray;
}

function totalPlayerCount()
{
	count = 0;
	foreach( team in level.teams )
	{
		count += level.playerCount[team];
	}
	return count; 
}

function isRankEnabled()
{
	return ( isdefined( level.rankEnabled ) && level.rankEnabled );
}

function isOneRound()
{		
	if ( level.roundLimit == 1 )
		return true;

	return false;
}

function isFirstRound()
{
	if ( level.roundLimit > 1 && game[ "roundsplayed" ] == 0 )
		return true;
		
	return false;
}

function isLastRound()
{		
	if ( level.roundLimit > 1 && game[ "roundsplayed" ] >= ( level.roundLimit - 1 ) )
		return true;
		
	return false;
}

function wasLastRound()
{		
	if ( level.forcedEnd )
		return true;
	
	if ( isdefined( level.shouldPlayOvertimeRound ) )
	{
		if ( [[level.shouldPlayOvertimeRound]]() ) // start/keep playing overtime
		{
			level.nextRoundIsOvertime = true;
			return false;
		}
		else if ( isdefined( game["overtime_round"] ) ) // We were in overtime, but shouldn't play another round, we're done
		{
			return true;
		}
	}

	if ( hitRoundLimit() || hitScoreLimit() || hitRoundWinLimit() )
	{
		return true;
	}
		
	return false;
}

function hitRoundLimit()
{
	if( level.roundLimit <= 0 )
		return false;

	return ( getRoundsPlayed() >= level.roundLimit );
}

function anyTeamHitRoundWinLimit()
{
	foreach( team in level.teams )
	{
		if ( getRoundsWon(team) >= level.roundWinLimit )
			return true;
	}
	
	return false;
}

function anyTeamHitRoundLimitWithDraws()
{
	tie_wins = game["roundswon"]["tie"];
	
	foreach( team in level.teams )
	{
		if ( getRoundsWon(team) + tie_wins >= level.roundWinLimit )
			return true;
	}
	
	return false;
}

function getRoundWinLimitWinningTeam()
{
	max_wins = 0;
	winning_team = undefined;
	
	foreach( team in level.teams )
	{
		wins = getRoundsWon(team);
		
		if ( !isdefined( winning_team ) )
		{
			max_wins = wins;
			winning_team = team;
			continue;
		}
		
		if ( wins == max_wins )
		{
			winning_team = "tie";
		}
		else if ( wins > max_wins )
		{
			max_wins = wins;
			winning_team = team;
		}
	}
	
	return winning_team;
}

function hitRoundWinLimit()
{
	if( !isdefined(level.roundWinLimit) || level.roundWinLimit <= 0 )
		return false;

	if ( anyTeamHitRoundWinLimit() )
	{
		//"True" means that we should end the game
		return true;
	}
	
	//No over-time should occur if either team has more rounds won, even if there were rounds that ended in draw.
	// For example, If the round win limit is 5 and one team has one win and 4 draws occur in a row, we want to declare the 
	//team with the victory as the winner and not enter an over-time round.
	if( anyTeamHitRoundLimitWithDraws() )
	{
		//We want the game to have an over-time round if the teams are tied.
		//In a game with a win limit of 3, 3 ties in a row would cause the previous 'if' check to return 'true'.
		// We want to make sure the game doesn't end if that's the case.
		if( getRoundWinLimitWinningTeam() != "tie" )
		{
			return true;
		}
	}
	
	return false;
}


function any_team_hit_score_limit()
{
	foreach( team in level.teams )
	{
		if ( game["teamScores"][team] >= level.scoreLimit )
			return true;
	}
	
	return false;
}


function hitScoreLimit()
{
	if ( level.scoreRoundWinBased )
		return false;
		
	if( level.scoreLimit <= 0 )
		return false;

	if ( level.teamBased )
	{
		if( any_team_hit_score_limit() )
			return true;
	}
	else
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isdefined( player.pointstowin ) && ( player.pointstowin >= level.scorelimit ) )
				return true;
		}
	}
	return false;
}

function get_current_round_score_limit()
{
	return (level.roundScoreLimit * (game[ "roundsplayed" ] + 1));
}

function any_team_hit_round_score_limit()
{
	round_score_limit = get_current_round_score_limit();
	
	foreach( team in level.teams )
	{
		if ( game["teamScores"][team] >= round_score_limit )
			return true;
	}
	
	return false;
}


function hitRoundScoreLimit()
{
	if ( level.roundScoreLimit <= 0 )
		return false;
		
	if ( level.teamBased )
	{
		if( any_team_hit_round_score_limit() )
			return true;
	}
	else
	{
		roundScoreLimit = util::get_current_round_score_limit();

		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			if ( isdefined( player.pointstowin ) && ( player.pointstowin >= roundScoreLimit ) )
				return true;
		}
	}
	return false;
}

function getRoundsWon( team )
{
	return game["roundswon"][team];
}

function getOtherTeamsRoundsWon( skip_team )
{
	roundswon = 0;
	
	foreach ( team in level.teams )
	{
		if ( team == skip_team )
			continue;
			
		roundswon += game["roundswon"][team];
	}
	return roundswon;
}

function getRoundsPlayed()
{
	return game["roundsplayed"];
}

function isRoundBased()
{
	if ( level.roundLimit != 1 && level.roundWinLimit != 1 )
		return true;

	return false;
}

function GetCurrentGameMode()
{
	if( GameModeIsMode( 6 ) )
		return "leaguematch";
		
	return "publicmatch";
}

/@
"Name: ground_position( <v_start>, [n_max_dist = 5000], [n_ground_offset = 0], [e_ignore], [b_ignore_water = false], [b_ignore_glass = false] )"
"Summary: Find a ground location from a starting position."

"MandatoryArg: <v_start> Starting position."
"OptionalArg: [n_max_dist] The max distance.  If the ground isn't found within this distance, the start position will be returned"
"OptionalArg: [n_ground_offset] Return the position that is this vertical offset from the ground."
"OptionalArg: [e_ignore] Optional entity to ignore in the trace."
"OptionalArg: [b_ignore_water] Ignore water."
"OptionalArg: [b_ignore_glass] Ignore glass."

Example:
	
	v_pos = util::ground_position( ent.origin );
@/
function ground_position( v_start, n_max_dist = 5000, n_ground_offset = 0, e_ignore, b_ignore_water = false, b_ignore_glass = false )
{
	const N_TRACE_FUDGE = 5; // make sure position that is already on the ground don't go through the ground
	
	v_trace_start = v_start + ( 0, 0, N_TRACE_FUDGE );
	v_trace_end = v_trace_start + ( 0, 0, ( n_max_dist + N_TRACE_FUDGE ) * -1 );
	
	a_trace = GroundTrace( v_trace_start, v_trace_end, false, e_ignore, b_ignore_water, b_ignore_glass );
	
	if ( a_trace[ "surfacetype" ] != "none" )
	{	
		return a_trace[ "position" ] + ( 0, 0, n_ground_offset );
	}
	else
	{
		return v_start;
	}
}

/@
"Name: delayed_notify( <str_notify>, <f_delay_seconds> )"
"Summary: Notifies self object of event after a number of seconds"
"MandatoryArg: <str_notify> Notify event name."
"MandatoryArg: <f_delay_seconds> Seconds to wait."
Example: self thread util::delayed_notify( "terminate_all_the_things", 5.0 );
@/
function delayed_notify( str_notify, f_delay_seconds )
{
	wait f_delay_seconds;
	
	if ( isDefined( self ) )
	{
		self notify( str_notify );
	}
}

/@
"Name: delayed_delete( <f_delay_seconds> )"
"Summary: Deletes an entity after a number of seconds"
"MandatoryArg: <f_delay_seconds> Seconds to wait."
Example: self thread util::delayed_delete( 5.0 );
@/
function delayed_delete( str_notify, f_delay_seconds )
{
	assert( isEntity( self ) );
	
	wait f_delay_seconds;
	
	if ( isDefined( self ) && isEntity( self ) )
	{
		self delete();
	}
}

/@
"Name: do_chyron_text( str_1, str_2, str_3_full, str_3_short, str_4_full, str_4_short, str_5_full, str_5_short, n_duration )"
"Summary: Creates the chyron text display for the beginning of a campaign level. Must have a minimum of 4 full/short lines"
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_1_full> : String reference for the full version of the first line of text. E.g. Encryption# 6B-65-20-69. Protocol: Echo"
"MandatoryArg: <str_1_short> : String reference for the short version of the first line of text. E.g. Protocol: Echo. (This can be the same as the full line if not needed)"
"MandatoryArg: <str_2_full> : String reference for the full version of the second line of text. E.g. Considering the continued Rise and Fall of attacks in the region extreme caution is advised"
"MandatoryArg: <str_2_short> : String reference for the short version of the second line of text. E.g. Rise and Fall"
"MandatoryArg: <str_3_full> : String reference for the full version of the third line of text. E.g. Mission: Interrogate Dr Salim in Egypt, Ramses Station and determine the whereabouts of the targets"
"MandatoryArg: <str_3_short> : String reference for the short version of the third line of text. E.g. Egypt, Ramses Station"
"MandatoryArg: <str_4_full> : String reference for the full version of the fourth line of text. E.g. Active Mission - Day 4 "
"MandatoryArg: <str_4_short> : String reference for the short version of the fourth line of text. E.g. Active Mission - Day 4 "
"OptionalArg: <str_5_full> : String reference for the fifth line of text. E.g. Active Mission - Day 4. (Can be left blank as well)"
"OptionalArg: <str_5_full> : String reference for the fifth line of text. E.g. Active Mission - Day 4 (Can be left blank as well)"
"OptionalArg: <n_duration> : Optionally set the duration of the chyron text display. defaults to 12."	
"Example: level do_chyron_text( &"CP_MI_CAIRO_RAMSES_INTRO_LINE_1_FULL", &"CP_MI_CAIRO_RAMSES_INTRO_LINE_1_FULL",
								&"CP_MI_CAIRO_RAMSES_INTRO_LINE_2_FULL", &"CP_MI_CAIRO_RAMSES_INTRO_LINE_2_FULL",
		                        &"CP_MI_CAIRO_RAMSES_INTRO_LINE_3_FULL", &"CP_MI_CAIRO_RAMSES_INTRO_LINE_3_SHORT",
		                        &"CP_MI_CAIRO_RAMSES_INTRO_LINE_4_FULL", &"CP_MI_CAIRO_RAMSES_INTRO_LINE_4_SHORT" );"
"SPMP: server"
@/
function do_chyron_text( str_1_full , str_1_short , str_2_full , str_2_short , str_3_full , str_3_short , str_4_full , str_4_short , str_5_full = "", str_5_short = "" , n_duration )
{
	if( !isdefined( n_duration ) )
	{
		n_duration = 12;
	}
	
	foreach( player in level.players )
	{
		player thread player_set_chyron_menu( str_1_full , str_1_short , str_2_full , str_2_short , str_3_full , str_3_short , str_4_full , str_4_short , str_5_full , str_5_short , n_duration );
	}
	
	a_players = ArrayCopy( level.players ); //get snapshot of level.players, in case anyone hotjoins during this and isn't running do_chyron_menu
	
	array::wait_till( a_players , "chyron_menu_open" , 1 ); //wait to make sure menu is up for all players
	
	level notify( "chyron_menu_open" ); //scripters can use this notify to set the level start flag and remove the black screen, and/or init the opening IGC, if applicable
	
	array::wait_till( a_players , "chyron_menu_closed" , n_duration + 1 ); //wait to make sure menu is closed for all players
	
	level notify( "chyron_menu_closed" ); //scripters can use this notify to start level scripting if needed 
}

function player_set_chyron_menu( str_1_full , str_1_short , str_2_full , str_2_short , str_3_full , str_3_short , str_4_full , str_4_short , str_5_full = "", str_5_short = "" , n_duration ) //self = player
{
	self endon( "disconnect" );
	
	menuHandle = self OpenLUIMenu( "CPChyron" );
	
    self SetLUIMenuData( menuHandle, "line1full", str_1_full );
    self SetLUIMenuData( menuHandle, "line1short", str_1_short );
    self SetLUIMenuData( menuHandle, "line2full", str_2_full );
    self SetLUIMenuData( menuHandle, "line2short", str_2_short );
    self SetLUIMenuData( menuHandle, "line3full", str_3_full );
    self SetLUIMenuData( menuHandle, "line3short", str_3_short );
    
    if( !( SessionModeIsCampaignZombiesGame() ) )
    {
		self SetLUIMenuData( menuHandle, "line4full", str_4_full );
	    self SetLUIMenuData( menuHandle, "line4short", str_4_short );
	    self SetLUIMenuData( menuHandle, "line5full", str_5_full );
	    self SetLUIMenuData( menuHandle, "line5short", str_5_short );
    }
    
    self notify( "chyron_menu_open" ); 
    
    wait n_duration;
    
    self SetLUIMenuData( menuHandle, "close_current_menu", 1 );
    
	self notify( "chyron_menu_closed" ); 

    wait 0.5; //this wait was in the script from s.crowe, seems to make for a smoother transition into the IGC

    self CloseLUIMenu( menuHandle );
}

//TODO is there a more elegant way to incorporate this into a lookup table?
function get_next_safehouse( str_next_map )
{
	switch( str_next_map )
	{
		case "cp_mi_sing_blackstation":
		case "cp_mi_sing_biodomes":
		case "cp_mi_sing_sgen":
			return "cp_sh_singapore";
		case "cp_mi_cairo_infection":
		case "cp_mi_cairo_aquifer":
		case "cp_mi_cairo_lotus":
			return "cp_sh_cairo";
		default:
			return "cp_sh_mobile";
	}
}

function is_safehouse()
{
	mapname = toLower( GetDvarString( "mapname" ) );
	
	if(mapname == "cp_sh_cairo" ||
	   mapname == "cp_sh_mobile" ||
	   mapname == "cp_sh_singapore")
	{
		return true;
	}
	
	return false;
}

function is_new_cp_map()
{
	mapname = toLower( GetDvarString( "mapname" ) );
	
	switch(mapname)
	{
	case "cp_mi_cairo_aquifer":
	case "cp_mi_cairo_infection":
	case "cp_mi_cairo_lotus":
	case "cp_mi_cairo_ramses":
	case "cp_mi_eth_prologue":
	case "cp_mi_sing_biodomes":
	case "cp_mi_sing_blackstation":
	case "cp_mi_sing_chinatown":
	case "cp_mi_sing_sgen":
	case "cp_mi_sing_vengeance":
	case "cp_mi_zurich_coalescene":
	case "cp_mi_zurich_newworld":
		return true;
		
	default:
		return false;
	}
}

/#
function add_queued_debug_command( cmd )
{
	if ( !isDefined( level.dbg_cmd_queue ) )
		level thread queued_debug_commands();
	
	if ( isDefined( level.dbg_cmd_queue ) )
		array::push( level.dbg_cmd_queue, cmd, false );
}

function queued_debug_commands()
{
	self notify("queued_debug_commands");
	self endon("queued_debug_commands");
	
	if ( !isDefined( level.dbg_cmd_queue ) )
		level.dbg_cmd_queue = [];
	
	while ( 1 )
	{
		{wait(.05);};
		
		if ( level.dbg_cmd_queue.size == 0 ) 
		{
			level.dbg_cmd_queue = undefined;
			return;
		}
		
		cmd = array::pop_front( level.dbg_cmd_queue, false );
		
		AddDebugCommand( cmd );
	}
}
#/
	