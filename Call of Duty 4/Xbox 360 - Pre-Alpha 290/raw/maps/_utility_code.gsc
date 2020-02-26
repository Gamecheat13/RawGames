#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;
/*
	Functions called only from _utility
*/

linetime_proc( start, end, color, timer )
{
	for( i=0; i < timer * 20; i++ )
	{
		line( start, end, color );
		wait( 0.05 );
	}
}

structarray_swap( object1, object2 )
{
	index1 = object1.struct_array_index;
	index2 = object2.struct_array_index; 
	self.array[ index2 ] = object1;
	self.array[ index1 ] = object2;
	self.array[ index1 ].struct_array_index = index1;
	self.array[ index2 ].struct_array_index = index2;
}

waitSpread_code( start, end )
{
	waittillframeend; // give every other waitspreader in this frame a chance to increment wait_spreaders

	assert( level.wait_spreaders >= 1 );

	allotment = [];
	
	if( level.wait_spreaders == 1 )
	{
		allotment[ 0 ] = randomfloatrange( start, end );
		level.wait_spreader_allotment = allotment;
		level.active_wait_spread = undefined;
		return;
	}
	
	allotment[ 0 ] = start;
	allotment[ allotment.size ] = end;

	for( i=1; i < level.wait_spreaders - 1; i ++ )
	{
		allotment = waitSpread_insert( allotment );
	}

	level.wait_spreader_allotment = array_randomize( allotment );
	level.active_wait_spread = undefined;
}

waitSpread_insert( allotment )
{
	gapIndex = -1;
	gap = 0;
	// get the largest waitspread gap
	for( p=0; p < allotment.size - 1; p++ )
	{
		newgap = allotment[ p + 1 ] - allotment[ p ];
		if( newgap <= gap )
			continue;
			
		gap = newgap;
		gapIndex = p;
	}

	assert( gap > 0 );
	newAllotment = [];
	
	for( i=0; i < allotment.size; i++ )
	{
		if( gapIndex == i - 1 )
		{
			newAllotment[ newAllotment.size ] = randomfloatrange( allotment[ gapIndex ], allotment[ gapIndex + 1 ] );
		}
		newAllotment[ newAllotment.size ] = allotment[ i ];
	}
	
	return newAllotment;
}


waittill_objective_event_proc( requireTrigger )
{
	while( level.deathSpawner[ self.script_deathChain ] > 0 )
		level waittill( "spawner_expired" + self.script_deathChain );

	if( requireTrigger )
		self waittill( "trigger" );
		
	flag = self get_trigger_flag();
	flag_set( flag );
}


stop_magic_bullet_shield_on_notify( newhealth, anim_nextStandingHitDying )
{
	self endon( "death" );
	self waittill( "stop magic bullet shield" );
	self.magic_bullet_shield = undefined;
	if( self.health > newhealth )
	{
		// the designer may have intentionally set the guys health lower, so don't overwrite it.
		self.health = newhealth;
	}
	self.a.nextStandingHitDying = anim_nextStandingHitDying;
}


wait_until_done_speaking()
{
	self endon( "death" );
	while( self.isSpeaking )
	{
		wait( 0.05 );
	}
}

wait_for_trigger_think( ent )
{
	self endon( "death" );
	ent endon( "trigger" );
	self waittill( "trigger" );
	
	ent notify( "trigger" );
}

wait_for_trigger( msg, type  )
{	
	triggers = getentarray( msg, type );
	ent = spawnstruct();
	
	array_thread( triggers, ::wait_for_trigger_think, ent );
	ent waittill( "trigger" );
}


ent_waits_for_level_notify( msg )
{
	level waittill( msg );
	self notify( "done" );
}

ent_waits_for_trigger( trigger )
{
	trigger waittill( "trigger" );
	self notify( "done" );
}

ent_times_out( timer )
{
	wait( timer );
	self notify( "done" );
}

update_debug_friendlycolor_on_death()
{
	self notify( "debug_color_update" );
	self endon( "debug_color_update" );
	num = self.ai_number;
	self waittill( "death" );
	level.debug_color_friendlies[ num ] = undefined;

	// updates the debug color friendlies info
	level notify( "updated_color_friendlies" );
}


update_debug_friendlycolor( num )
{
	thread update_debug_friendlycolor_on_death();
	if( isdefined( self.script_forceColor ) )
	{
		level.debug_color_friendlies[ num ] = self.script_forceColor;
	}
	else
	{
		level.debug_color_friendlies[ num ] = undefined;
	}
	// updates the debug color friendlies info
	level notify( "updated_color_friendlies" );
}

insure_player_does_not_set_forcecolor_twice_in_one_frame()
{
	/#
	assertEx( !isdefined( self.setforcecolor ), "Tried to set forceColor on an ai twice in one frame. Don't spam set_force_color." );
	self.setforcecolor = true;
	waittillframeend;
	if( !isalive( self ) )
		return;
	self.setforcecolor = undefined;
	#/
}


new_color_being_set( color )
{
	self notify( "new_color_being_set" );
	self.new_force_color_being_set = true;
	maps\_colors::left_color_node();

	self endon( "new_color_being_set" );
	self endon( "death" );

	// insure we're only getting one color change, multiple in one frame will get overwritten.
	waittillframeend;
	waittillframeend;
	
	if( isdefined( self.script_forceColor ) )
	{
		// grab the current colorCode that AI of this color are forced to, if there is one
		self.currentColorCode = level.currentColorForced[ self.team ][ self.script_forceColor ];
		self thread maps\_colors::goto_current_ColorIndex();
	}
	
	self.new_force_color_being_set = undefined;
	self notify( "done_setting_new_color" );
	/#
	update_debug_friendlycolor( self.ai_number );
	#/
}

radio_queue_thread( msg )
{
	queueTime = gettime();
	for( ;; )
	{
		if( !isdefined( self._radio_queue ) )
			break;
			
		self waittill( "finished_radio" );
		if( gettime() > queueTime + 5000 )
			return;
	}

	self._radio_queue = true;	
	level.player play_sound_on_entity( level.scr_radio[ msg ] );
	self._radio_queue = undefined;
	self notify( "finished_radio" );
}


delayThread_proc( func, timer, param1, param2, param3, param4 )
{
	self endon( "death" );
	wait( timer );
	if( isdefined( param4 ) )
		thread [[ func ]]( param1, param2, param3, param4 );
	else
	if( isdefined( param3 ) )
		thread [[ func ]]( param1, param2, param3 );
	else
	if( isdefined( param2 ) )
		thread [[ func ]]( param1, param2 );
	else
	if( isdefined( param1 ) )
		thread [[ func ]]( param1 );
	else
		thread [[ func ]]();
}

wait_for_flag_or_time_elapses( flagname, timer )
{
	level endon( flagname );
	wait( timer );
}

ent_wait_for_flag_or_time_elapses( flagname, timer )
{
	self endon( flagname );
	wait( timer );
}

waittill_either_function_internal( ent, func, parm )
{
	ent endon( "done" );
	[[ func ]]( parm );
	ent notify( "done" );
}


HintPrintWait( length, breakfunc )
{
	if ( !isdefined( breakfunc ) )
	{
		wait( length );
		return;
	}

	timer = length*20;
	for ( i=0; i < timer; i++ )
	{
		if ( [[ breakfunc ]]() )
			break;
		wait( 0.05 );
	}	
}

HintPrint( string, breakfunc )
{
	MYFADEINTIME = 1.0;
	MYFLASHTIME = 0.75;
	MYALPHAHIGH = 0.95;
	MYALPHALOW = 0.4;

	Hint = createFontString( "default", 2 );
	
	Hint.color = ( 1, 1, .5 );
	Hint.alpha = 0.9;
	Hint.x = 0;
	Hint.y = -60;
	Hint.alignx = "center";
	Hint.aligny = "middle";
	Hint.horzAlign = "center";
	Hint.vertAlign = "middle";
	Hint.foreground = false;
	Hint.hidewhendead = true;

	Hint setText( string );

	Hint.alpha = 0;
	Hint FadeOverTime( MYFADEINTIME );
	Hint.alpha = MYALPHAHIGH;
	HintPrintWait( MYFADEINTIME );

	if ( isdefined( breakfunc ) )
	{
		for (;;)
		{
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHALOW;
			HintPrintWait( MYFLASHTIME, breakfunc );
	
			if ( [[ breakfunc ]]() )
				break;
	
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHAHIGH;
			HintPrintWait( MYFLASHTIME );
	
			if ( [[ breakfunc ]]() )
				break;
		}
	}
	else
	{
		for ( i=0; i < 5; i++ )
		{
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHALOW;
			HintPrintWait( MYFLASHTIME );
	
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHAHIGH;
			HintPrintWait( MYFLASHTIME );
		}
	}
		
	Hint Destroy();
}


lerp_player_view_to_tag_internal( tag, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, hit_geo )
{
	if( isdefined( self.first_frame_time ) && self.first_frame_time == gettime() )
	{
		// the base ai / vehicle / model just was put into the first frame and it takes a server frame for the
		// tags to get into position
		wait( 0.10 );
	}
	
	origin = self gettagorigin( tag );
	angles = self gettagangles( tag );
	lerp_player_view_to_position( origin, angles, lerptime, fraction, right_arc, left_arc, top_arc, bottom_arc, true );
	
	if ( hit_geo )
		return;
		
	level.player playerlinkto( self, tag, fraction, right_arc, left_arc, top_arc, bottom_arc, false );
}

function_stack_proc( caller, func, param1, param2, param3, param4 )
{
	if( !isdefined(caller.function_stack) )
		caller.function_stack = [];
	
	caller.function_stack [ caller.function_stack.size ] = self;
	
	while(caller.function_stack[0] != self )
		caller waittill("level_function_stack_ready");
	
	if( isdefined( param4 ) )
		caller [[ func ]]( param1, param2, param3, param4 );
	else
	if( isdefined( param3 ) )
		caller [[ func ]]( param1, param2, param3 );
	else
	if( isdefined( param2 ) )
		caller [[ func ]]( param1, param2 );
	else
	if( isdefined( param1 ) )
		caller [[ func ]]( param1 );
	else
		caller [[ func ]]();
	
	caller.function_stack = array_remove( caller.function_stack, self );
	
	caller notify("level_function_stack_ready");
	self notify("function_done");
}