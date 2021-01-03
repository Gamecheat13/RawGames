#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\spawner_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace trigger;

function autoexec __init__sytem__() {     system::register("trigger",&__init__,undefined,undefined);    }

function __init__()
{
	level.fog_trigger_current = undefined;
	level.trigger_hint_string = [];
	level.trigger_hint_func = [];	
	
	if ( !isdefined( level.trigger_flags ) )
	{
		init_flags();
	}

	trigger_funcs = [];
	trigger_funcs[ "trigger_unlock" ]			= &trigger_unlock;
	trigger_funcs[ "flag_set" ] 				= &flag_set_trigger;
	trigger_funcs[ "flag_clear" ]				= &flag_clear_trigger;
	trigger_funcs[ "flag_set_touching" ]		= &flag_set_touching;
	trigger_funcs[ "friendly_respawn_trigger" ] = &friendly_respawn_trigger;
	trigger_funcs[ "friendly_respawn_clear" ] 	= &friendly_respawn_clear;
	trigger_funcs[ "trigger_delete" ] 			= &trigger_turns_off;
	trigger_funcs[ "trigger_delete_on_touch" ] 	= &trigger_delete_on_touch;
	trigger_funcs[ "trigger_off" ] 				= &trigger_turns_off;
	trigger_funcs[ "delete_link_chain" ] 		= &delete_link_chain;
	trigger_funcs[ "no_crouch_or_prone" ] 		= &no_crouch_or_prone_think;
	trigger_funcs[ "no_prone" ] 				= &no_prone_think;
	trigger_funcs[ "flood_spawner" ]			= &spawner::flood_trigger_think;
	trigger_funcs[ "trigger_spawner" ]			= &trigger_spawner;
	trigger_funcs[ "trigger_hint" ]				= &trigger_hint;	
	trigger_funcs[ "exploder" ]					= &trigger_exploder;

	foreach ( trig in get_all( "trigger_radius", "trigger_multiple", "trigger_once", "trigger_box" ) )
	{
		if ( (isdefined(trig.spawnflags)&&((trig.spawnflags & 256) == 256)) )
		{
			level thread trigger_look( trig );
		}
	}

	foreach ( trig in get_all() )
	{
		/#
			trig check_spawnflags();
		#/
		
		if ( trig.classname != "trigger_damage" )
		{
			if ( trig.classname != "trigger_hurt" )
			{
				if ( (isdefined(trig.spawnflags)&&((trig.spawnflags & 32) == 32)) )
				{
					level thread trigger_spawner( trig );
				}
			}
		}
		
		if ( ( trig.classname != "trigger_once" ) && is_trigger_once( trig ) )
		{
			level thread trigger_once( trig );
		}
		
		if ( isdefined( trig.script_flag_true ) )
		{
			level thread script_flag_true_trigger( trig );
		}
		
		if ( isdefined( trig.script_flag_set ) )
		{
			level thread flag_set_trigger( trig, trig.script_flag_set );
		}
		
		if ( isdefined( trig.script_flag_set_on_touching ) || isdefined( trig.script_flag_set_on_cleared ) )
		{
			level thread script_flag_set_touching( trig );
		}
				
		if ( isdefined( trig.script_flag_clear ) )
		{
			level thread flag_clear_trigger( trig, trig.script_flag_clear );
		}
		
		if ( isdefined( trig.script_flag_false ) )
		{
			level thread script_flag_false_trigger( trig );
		}
			
		if ( isdefined( trig.script_trigger_group ) )
		{
			trig thread trigger_group();
		}
			// MikeD( 06/26/07 ): Added script_notify, which will send out the value set to script_notify as a level notify once triggered
		if ( isdefined( trig.script_notify ) )
		{
			level thread trigger_notify( trig, trig.script_notify );
		}
		
		if ( isdefined( trig.script_fallback ) )
		{
			level thread spawner::fallback_think( trig );
		}
		
		if ( isdefined( trig.script_killspawner ) )
		{
			level thread kill_spawner_trigger( trig );
		}		
		
		if ( isdefined( trig.targetname ) )
		{
			// do targetname specific functions
			if ( isdefined( trigger_funcs[ trig.targetname ] ) )
			{
				level thread [[ trigger_funcs[ trig.targetname ] ]]( trig );
			}
		}
	}
}

function check_spawnflags()
{
	if ( ( isdefined( self.script_trigger_allplayers ) && self.script_trigger_allplayers )
	    && ( (isdefined(self.spawnflags)&&((self.spawnflags & 1) == 1))
	    || (isdefined(self.spawnflags)&&((self.spawnflags & 2) == 2))
	    || (isdefined(self.spawnflags)&&((self.spawnflags & 4) == 4))
	    || (isdefined(self.spawnflags)&&((self.spawnflags & 8) == 8))
	    || (isdefined(self.spawnflags)&&((self.spawnflags & 16) == 16)) ) )
	{
		//Assert( "Triggers using 'script_trigger_allplayers' are not compatible with other entity types.  Please unset spawnflags for other types." ); // TODO: put this back in, just didn't want to check in an assert at the end of the day
	}
}

function trigger_unlock( trigger )
{
	// trigger unlocks unlock another trigger. When that trigger is hit, all unlocked triggers relock
	// trigger_unlocks with the same script_noteworthy relock the same triggers
	
	noteworthy = "not_set";
	if( isdefined( trigger.script_noteworthy ) )
	{
		noteworthy = trigger.script_noteworthy;
	}
		
	target_triggers = GetEntArray( trigger.target, "targetname" );

	trigger thread trigger_unlock_death( trigger.target );

	while ( true )
	{
		array::run_all( target_triggers, &TriggerEnable, false );
		
		trigger waittill( "trigger" );
		
		array::run_all( target_triggers, &TriggerEnable, true );
		
		wait_for_an_unlocked_trigger( target_triggers, noteworthy );

		array::notify_all( target_triggers, "relock" );
	}
}

function trigger_unlock_death( target )
{
	self waittill( "death" );
	target_triggers = GetEntArray( target, "targetname" );
	array::run_all( target_triggers, &TriggerEnable, false );
}

function wait_for_an_unlocked_trigger( triggers, noteworthy )
{
	level endon( "unlocked_trigger_hit" + noteworthy );
	ent = SpawnStruct();
	for( i = 0; i < triggers.size; i++ )
	{
		triggers[i] thread report_trigger( ent, noteworthy );
	}
	ent waittill( "trigger" );
	level notify( "unlocked_trigger_hit" + noteworthy );
}

function report_trigger( ent, noteworthy )
{
	self endon( "relock" );
	level endon( "unlocked_trigger_hit" + noteworthy );
	self waittill( "trigger" );
	ent notify( "trigger" );
}

function get_trigger_look_target()
{
	if ( isdefined( self.target ) )
	{
		a_potential_targets = GetEntArray( self.target, "targetname" );
		a_targets = [];
		
		foreach ( target in a_potential_targets )
		{
			if ( ( target.classname === "script_origin" ) )
			{
				if ( !isdefined( a_targets ) ) a_targets = []; else if ( !IsArray( a_targets ) ) a_targets = array( a_targets ); a_targets[a_targets.size]=target;;
			}
		}
		
		a_potential_target_structs = struct::get_array( self.target );
		a_targets = ArrayCombine( a_targets, a_potential_target_structs, true, false );
		
		if ( a_targets.size > 0 )
		{
			Assert( a_targets.size == 1, "Look tigger at " + self.origin + " targets multiple origins/structs." );
			e_target = a_targets[0];
		}
	}
	
	if(!isdefined(e_target))e_target=self;
	
	return e_target;
}

function trigger_look( trigger )
{
	trigger endon( "death" );
	
	e_target = trigger get_trigger_look_target();
	
	if ( isdefined( trigger.script_flag ) && !isdefined( level.flag[trigger.script_flag] ) )
	{
		level flag::init( trigger.script_flag, undefined, true );
	}
	
	a_parameters = [];
	if ( isdefined( trigger.script_parameters ) )
	{
		a_parameters = StrTok( trigger.script_parameters, ",; " );
	}
	
	b_ads_check = IsInArray( a_parameters, "check_ads" );
		
	while ( true )
	{
		trigger waittill( "trigger", e_other );
		
		if ( IsPlayer( e_other ) )
		{
			while ( isdefined( e_other ) && e_other IsTouching( trigger ) )
			{
				if ( e_other util::is_looking_at( e_target, trigger.script_dot, ( isdefined( trigger.script_trace ) && trigger.script_trace ) )
					&& ( !b_ads_check || !e_other util::is_ads() ) )
				{
					trigger notify( "trigger_look", e_other );
					
					if ( isdefined( trigger.script_flag ) )
					{
						level flag::set( trigger.script_flag );
					}
				}
				else
				{
					if ( isdefined( trigger.script_flag ) )
					{
						level flag::clear( trigger.script_flag );
					}
				}
				
				{wait(.05);};
			}
			
			if ( isdefined( trigger.script_flag ) )
			{
				level flag::clear( trigger.script_flag );
			}
		}
		else
		{
			AssertMsg( "Look triggers only support players." );
		}
	}
}

function trigger_spawner( trigger )
{
	a_spawners = GetSpawnerArray( trigger.target, "targetname" );
	
	Assert( a_spawners.size > 0, "Triggers with flag TRIGGER_SPAWN at " + trigger.origin + " must target at least one spawner." );
	
	trigger endon( "death" );
	trigger wait_till();
	
	foreach ( sp in a_spawners )
	{
		if ( isdefined( sp ) )
		{
			sp thread trigger_spawner_spawn();
		}
	}
}

function trigger_spawner_spawn()
{
	self endon( "death" );
	
	self flag::script_flag_wait();
	self util::script_delay();
	
	self spawner::spawn();
}

/@
"Name: trigger_notify()"
"Summary: Sends out a level notify of the trigger's script_notify once triggered"
"Module: Trigger"
"CallOn: "
"Example: trigger thread trigger_notify(); "
"SPMP: singleplayer"
@/
function trigger_notify( trigger, msg )
{
	trigger endon( "death" );
	
	other = trigger wait_till();
	
	if( isdefined( trigger.target ) )
	{
		a_target_ents = GetEntArray( trigger.target, "targetname" );
		
		foreach ( notify_ent in a_target_ents )
		{
			notify_ent notify( msg, other );
		}
	}
	
	level notify( msg, other );
}

function flag_set_trigger( trigger, str_flag )
{
	trigger endon( "death" );
	
	if(!isdefined(str_flag))str_flag=trigger.script_flag;

	if ( !isdefined( level.flag[ str_flag ] ) )
	{
		level flag::init( str_flag, undefined, true );
	}
	
	while ( true )
	{
		trigger wait_till();

		if ( isdefined( trigger.targetname ) && ( trigger.targetname == "flag_set" ) )
		{
			// this is a "flag_set" trigger so support script_delay
			// generic triggers don't use script_dealy for flag setting because the
			// script_delay might be intended for something else

			trigger util::script_delay();
		}
		
		level flag::set( str_flag );
	}
}

function flag_clear_trigger( trigger, str_flag )
{
	trigger endon( "death" );
	
	if(!isdefined(str_flag))str_flag=trigger.script_flag;

	if ( !isdefined( level.flag[ str_flag ] ) )
	{
		level flag::init( str_flag, undefined, true );
	}

	while ( true )
	{
		trigger wait_till();

		if ( isdefined( trigger.targetname ) && ( trigger.targetname == "flag_clear" ) )
		{
			// this is a "level flag::clear" trigger so support script_delay
			// generic triggers don't use script_dealy for flag clearing because the
			// script_delay might be intended for something else

			trigger util::script_delay();
		}

		level flag::clear( str_flag );
	}
}

function add_tokens_to_trigger_flags( tokens )
{
	for( i = 0; i < tokens.size; i++ )
	{
		flag = tokens[i];
		if( !isdefined( level.trigger_flags[flag] ) )
		{
			level.trigger_flags[flag] = [];
		}
		
		level.trigger_flags[flag][level.trigger_flags[flag].size] = self;
	}
}

function script_flag_false_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = util::create_flags_and_return_tokens( trigger.script_flag_false );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_based_on_flags();
}

function script_flag_true_trigger( trigger )
{
	// all of these flags must be false for the trigger to be enabled
	tokens = util::create_flags_and_return_tokens( trigger.script_flag_true );
	trigger add_tokens_to_trigger_flags( tokens );
	trigger update_based_on_flags();
}

function friendly_respawn_trigger( trigger )
{
	trigger endon( "death" );
	
	spawners = GetEntArray( trigger.target, "targetname" );
	assert( spawners.size == 1, "friendly_respawn_trigger targets multiple spawner with targetname " + trigger.target + ". Should target just 1 spawner." );
	spawner = spawners[0];
	assert( !isdefined( spawner.script_forcecolor ), "targeted spawner at " + spawner.origin + " should not have script_forcecolor set!" );
	spawners = undefined;
	
	spawner endon( "death" );
	
	while ( true )
	{
		trigger waittill( "trigger" );
		
		// SRS 12/20/2007: updated to allow for multiple color chains to be reinforced from different areas
		if( isdefined( trigger.script_forcecolor ) )
		{
			level.respawn_spawners_specific[trigger.script_forcecolor] = spawner;
		}
		else
		{
			level.respawn_spawner = spawner;
		}
		level flag::set( "respawn_friendlies" );
		wait( 0.5 );
	}
}

function friendly_respawn_clear( trigger )
{
	trigger endon( "death" );
	
	while ( true )
	{
		trigger waittill( "trigger" );
		level flag::clear( "respawn_friendlies" );
		wait 0.5;
	}
}

function trigger_turns_off( trigger )
{
	trigger wait_till();
	trigger TriggerEnable( false );
	
	if( !isdefined( trigger.script_linkTo ) )
	{
		return;
	}
	
	// also turn off all triggers this trigger links to
	tokens = Strtok( trigger.script_linkto, " " );
	for( i = 0; i < tokens.size; i++ )
	{
		array::run_all( GetEntArray( tokens[i], "script_linkname" ), &TriggerEnable, false );
	}
}

function script_flag_set_touching( trigger )
{
	trigger endon( "death" );
	
	if ( isdefined( trigger.script_flag_set_on_touching ) )
	{
		level flag::init( trigger.script_flag_set_on_touching, undefined, true );
	}
	
	if ( isdefined( trigger.script_flag_set_on_cleared ) )
	{
		level flag::init( trigger.script_flag_set_on_cleared, undefined, true );
	}
	
	trigger thread _detect_touched();
	
	while ( true )
	{
		trigger.script_touched = false;
		
		{wait(.05);};
		waittillframeend; // wait for touched variable to update for this frame
		
		if ( !trigger.script_touched )
		{
			// HACK: wait one more frame if it isn't touched - saw a strange issue where
			// the trigger thought it wasn't touched for a frame when another player joined
			// even though the first player was still standing in the trigger
			{wait(.05);};
			waittillframeend;
		}
		
		if ( trigger.script_touched )
		{
			if ( isdefined( trigger.script_flag_set_on_touching ) )
			{
				level flag::set( trigger.script_flag_set_on_touching );
			}
			
			if ( isdefined( trigger.script_flag_set_on_cleared ) )
			{
				level flag::clear( trigger.script_flag_set_on_cleared );
			}
		}
		else
		{
			if ( isdefined( trigger.script_flag_set_on_touching ) )
			{
				level flag::clear( trigger.script_flag_set_on_touching );
			}
			
			if ( isdefined( trigger.script_flag_set_on_cleared ) )
			{
				level flag::set( trigger.script_flag_set_on_cleared );
			}
		}
	}	
}

function _detect_touched()
{
	self endon( "death" );
	
	while ( true )
	{
		self waittill( "trigger" );
		self.script_touched = true;
	}
}

function trigger_delete_on_touch( trigger )
{
	while ( true )
	{
		trigger waittill( "trigger", other );
		if( isdefined( other ) )
		{
			// might've been removed before we got it
			other Delete();
		}
	}
}

function flag_set_touching( trigger )
{
	str_flag = trigger.script_flag;
	
	if ( !isdefined( level.flag[ str_flag ] ) )
	{
		level flag::init( str_flag, undefined, true );
	}
	
	while ( true )
	{
		trigger waittill( "trigger", other );
		
		level flag::set( str_flag );
		while ( IsAlive( other ) && other IsTouching( trigger ) && isdefined( trigger ) )
		{
			wait( 0.25 );
		}
		
		level flag::clear( str_flag );
	}
}

function trigger_once( trig )
{
	trig endon( "death" );
	
	if ( is_look_trigger( trig ) )
	{
		trig waittill( "trigger_look" );
	}
	else
	{
		trig waittill( "trigger" );
	}
	
	waittillframeend;
	waittillframeend;

	if ( isdefined( trig ) )
	{
/#
		println( "" );
		println( "*** trigger debug: deleting trigger with ent#: " + trig getentitynumber() + " at origin: " + trig.origin );
		println( "" );
#/

		trig Delete();
	}
}

function trigger_hint( trigger )
{
	assert( isdefined( trigger.script_hint ), "Trigger_hint at " + trigger.origin + " has no .script_hint" );
	
	trigger endon( "death" );
	
	if ( !isdefined( level.displayed_hints ) )
	{
		level.displayed_hints = [];
	}
	
	waittillframeend;	// give level script a chance to set the hint string and optional boolean functions on this hint

	assert( isdefined( level.trigger_hint_string[ trigger.script_hint ] ), "Trigger_hint with hint " + trigger.script_hint + " had no hint string assigned to it. Define hint strings with util::add_hint_string()" );
	
	trigger waittill( "trigger", other );
	
	assert( IsPlayer( other ), "Tried to do a trigger_hint on a non player entity" );
	
	if ( isdefined( level.displayed_hints[ trigger.script_hint ] ) )
	{
		return;
	}
	
	level.displayed_hints[ trigger.script_hint ] = true;
	
	display_hint( trigger.script_hint );
}

function trigger_exploder( trigger )
{
	trigger endon( "death" );
	while (true)
	{
		trigger waittill( "trigger" );
		if (isdefined(trigger.target ))
		{
			ActivateClientRadiantExploder( trigger.target );
		}
	}
}	
	

/@
"Name: display_hint( <hint> )"
"Summary: Displays a hint created with add_hint_string."
"Module: Utility"
"MandatoryArg: <hint> : The hint reference created with add_hint_string."
"Example: display_hint( "huzzah" )"
"SPMP: singleplayer"
@/
function display_hint( hint )
{
	if ( GetDvarString( "chaplincheat" ) == "1" )
	{
		return;
	}

	// hint triggers have an optional function they can boolean off of to determine if the hint will occur
	// such as not doing the NVG hint if the player is using NVGs already
	if( isdefined( level.trigger_hint_func[ hint ] ) )
	{
		if( [[ level.trigger_hint_func[ hint ] ]]() )
		{
			return;
		}

		_hint_print( level.trigger_hint_string[ hint ], level.trigger_hint_func[ hint ] );
	}
	else
	{
		_hint_print( level.trigger_hint_string[ hint ] );
	}
}

function _hint_print( string, breakfunc )
{
	const MYFADEINTIME = 1.0;
	const MYFLASHTIME = 0.75;
	const MYALPHAHIGH = 0.95;
	const MYALPHALOW = 0.4;
	
	level flag::wait_till_clear( "global_hint_in_use" );
	level flag::set( "global_hint_in_use" );

	Hint = hud::createFontString( "objective", 2 );
	
	//Hint.color = ( 1, 1, .5 ); //remove color so that color highlighting on PC can show up.
	Hint.alpha = 0.9;
	Hint.x = 0;
	Hint.y = -68;
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
	_hint_print_wait( MYFADEINTIME );

	if ( isdefined( breakfunc ) )
	{
		for ( ;; )
		{
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHALOW;
			_hint_print_wait( MYFLASHTIME, breakfunc );
	
			if ( [[ breakfunc ]]() )
			{
				break;
			}
	
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHAHIGH;
			_hint_print_wait( MYFLASHTIME );
	
			if ( [[ breakfunc ]]() )
			{
				break;
			}
		}
	}
	else
	{
		for ( i = 0; i < 5; i++ )
		{
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHALOW;
			_hint_print_wait( MYFLASHTIME );
	
			Hint FadeOverTime( MYFLASHTIME );
			Hint.alpha = MYALPHAHIGH;
			_hint_print_wait( MYFLASHTIME );
		}
	}
		
	Hint Destroy();
	level flag::clear( "global_hint_in_use" );
}

function _hint_print_wait( length, breakfunc )
{
	if ( !isdefined( breakfunc ) )
	{
		wait( length );
		return;
	}

	timer = length * 20;
	for ( i = 0; i < timer; i++ )
	{
		if ( [[ breakfunc ]]() )
		{
			break;
		}
		{wait(.05);};
	}	
}

/@
"Name: get_all(type1, type2, type3, type4, type5, type6, type7, type8, type9)"
"Summary: Gets all triggers on the map.  If only want certain types, can specify those"
"Module: Level"
"CallOn: N/A"
"OptionalArg: <type1-9> 	: Classname of Trigger to get."
"Example: trigs = get_all();"
"SPMP: singleplayer"
@/
function get_all( type1, type2, type3, type4, type5, type6, type7, type8, type9 )
{
	if ( !isdefined( type1 ) )
	{
		type1 = "trigger_damage";
		type2 = "trigger_hurt";
		type3 = "trigger_lookat";
		type4 = "trigger_once";
		type5 = "trigger_radius";
		type6 = "trigger_use";
		type7 = "trigger_use_touch";
		type8 = "trigger_box";
		type9 = "trigger_multiple";
		type10 = "trigger_out_of_bounds";
	}
	
	assert( _is_valid_trigger_type( type1 ) );
	trigs = GetEntArray( type1, "classname"  );
	
	if ( isdefined( type2 ) )
	{
		assert( _is_valid_trigger_type( type2 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type2, "classname" ), true, false );
	}
	
	if ( isdefined( type3 ) )
	{
		assert( _is_valid_trigger_type( type3 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type3, "classname" ), true, false );
	}
	
	if ( isdefined( type4 ) )
	{
		assert( _is_valid_trigger_type( type4 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type4, "classname" ), true, false );
	}
	
	if ( isdefined( type5 ) )
	{
		assert( _is_valid_trigger_type( type5 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type5, "classname" ), true, false );
	}
	
	if ( isdefined( type6 ) )
	{
		assert( _is_valid_trigger_type( type6 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type6, "classname" ), true, false );
	}
	
	if ( isdefined( type7 ) )
	{
		assert( _is_valid_trigger_type( type7 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type7, "classname" ), true, false );
	}
	
	if ( isdefined( type8 ) )
	{
		assert( _is_valid_trigger_type( type8 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type8, "classname" ), true, false );
	}
	
	if ( isdefined( type9 ) )
	{
		assert( _is_valid_trigger_type( type9 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type9, "classname" ), true, false );
	}
	
	if ( isdefined( type10 ) )
	{
		assert( _is_valid_trigger_type( type9 ) );
		trigs = ArrayCombine( trigs, GetEntArray( type10, "classname" ), true, false );
	}
		
	return trigs;
}
	
function _is_valid_trigger_type( type )
{
	switch ( type )
	{
		case "trigger_damage":
		case "trigger_hurt":
		case "trigger_lookat":
		case "trigger_once":
		case "trigger_radius":
		case "trigger_use":
		case "trigger_use_touch":
		case "trigger_box":
		case "trigger_multiple":
		case "trigger_out_of_bounds":
			return true;
			break;
		default:
			return false;
	}
}

/@
function Name: wait_till( <str_name> , str_key = "targetname", e_entity )
Summary: Waits until a trigger with the specified key / value is triggered. Returns the trigger and assigns the entity that triggered it to "trig.who".
Module: Trigger
MandatoryArg: str_name: Key value.
OptionalArg: str_key: Key name on the trigger to use, example: "targetname" or "script_noteworthy".
OptionalArg: e_entity: Wait for a specific entity to trigger the trigger.
"OptionalArg: <b_assert> : Set to false to not assert if the trigger doesn't exist"
function Example: wait_till( "player_in_building1, "script_noteworthy" );
SPMP: both
@/
function wait_till( str_name, str_key = "targetname", e_entity, b_assert = true )
{
	if ( isdefined( str_name ) )
	{
		triggers = GetEntArray( str_name, str_key );
		Assert( !b_assert || ( triggers.size > 0 ), "trigger not found: " + str_name + " key: " + str_key );
		
		if ( triggers.size > 0 )
		{
			if ( triggers.size == 1 )
			{
				trigger_hit = triggers[0];
				trigger_hit _trigger_wait( e_entity );
			}
			else
			{
				s_tracker = SpawnStruct();
				array::thread_all( triggers,&_trigger_wait_think, s_tracker, e_entity );
				s_tracker waittill( "trigger", e_other, trigger_hit );
				trigger_hit.who = e_other;
			}
				
			return trigger_hit;
		}
	}
	else
	{
		return _trigger_wait( e_entity );
	}
}

function _trigger_wait( e_entity )
{
	/#
		if ( is_look_trigger( self ) )
		{
			Assert( !IsArray( e_entity ), "LOOK triggers can only wait on one entity." );
		}
		else if ( self.classname === "trigger_damage" )
		{
			Assert( !IsArray( e_entity ), "Damage triggers can only wait on one entity." );
		}
	#/
	
	while ( true )
	{
		if ( is_look_trigger( self ) )
		{
			self waittill( "trigger_look", e_other );
			
			if ( isdefined( e_entity ) )
			{
				if ( e_other !== e_entity )
				{
					continue;
				}
			}
		}
		else if ( self.classname === "trigger_damage" )
		{
			self waittill( "trigger", e_other );
			
			if ( isdefined( e_entity ) )
			{
				if ( e_other !== e_entity )
				{
					continue;
				}
			}
		}
		else
		{
			self waittill( "trigger", e_other );
			
			if ( isdefined( e_entity ) )
			{
				if ( IsArray( e_entity ) )
				{
					if ( !array::is_touching( e_entity, self ) )
					{
						continue;
					}
				}
				else if ( !e_entity IsTouching( self ) && ( e_entity !== e_other ) )
				{
					continue;
				}
			}
		}
		
		break;
	}
	
	self.who = e_other;
	return self;
}

function _trigger_wait_think( s_tracker, e_entity )
{
	self endon( "death" );
	s_tracker endon( "trigger" );
	
	e_other = _trigger_wait( e_entity );
	s_tracker notify( "trigger", e_other, self );
}

/@
"Name: use( <str_name> , [str_key], [ent], [b_assert] )"
"Summary: Activates a trigger with the specified key / value is triggered"
"Module: Trigger"
"CallOn: "
"MandatoryArg: <str_name> : Name of the key on this trigger. If name is not passed in, func will check against self"
"OptionalArg: [str_key] : Key on the trigger to use, example: "targetname" or "script_noteworthy""
"OptionalArg: [ent] : Entity that the trigger is used by"
"OptionalArg: [b_assert] : Set to false to not assert if the trigger doesn't exist"
"Example: use( "player_in_building1, "targetname", enemy, false );"
"SPMP: singleplayer"
@/
function use( str_name, str_key = "targetname", ent, b_assert = true )
{
    if ( !isdefined( ent ) )
    {
    	ent = GetPlayers()[0];
    }

	if ( isdefined( str_name ) )
	{
		e_trig = GetEnt( str_name, str_key );
		if( !isdefined( e_trig ) )
		{
			if ( b_assert )
			{
				AssertMsg( "trigger not found: " + str_name + " key: " + str_key );
			}
			
			return;
		}
    }
	else
	{
		e_trig = self;
		str_name = self.targetname;
	}
	
	e_trig UseBy( ent );
	
	level notify( str_name, ent );	// TODO: brianb - do we need this?
	
	if ( is_look_trigger( e_trig ) )
	{
		e_trig notify( "trigger_look", ent );
	}
	
	return e_trig;
}

function set_flag_permissions( msg )
{
	// turns triggers on or off depending on if they have the proper flags set, based on their shift-g menu settings

	if ( !isdefined( level.trigger_flags ) || !isdefined( level.trigger_flags[ msg ] ) )
	{
		return;
	}

	// cheaper to do the upkeep at this time rather than with endons and waittills on the individual triggers
	level.trigger_flags[ msg ] = array::remove_undefined( level.trigger_flags[ msg ] );
	array::thread_all( level.trigger_flags[ msg ], &update_based_on_flags );
}

function update_based_on_flags()
{
	true_on = true;
	if ( isdefined( self.script_flag_true ) )
	{
		true_on = false;
		tokens = util::create_flags_and_return_tokens( self.script_flag_true );
		
		// stay off unless any of the flags are true
		for( i=0; i < tokens.size; i++ )
		{
			if ( level flag::get( tokens[ i ] ) )
			{
				true_on = true;
				break;
			}
		}
	}
	
	false_on = true;
	if ( isdefined( self.script_flag_false ) )
	{
		tokens = util::create_flags_and_return_tokens( self.script_flag_false );
		
		// stay off unless all flags are false
		for( i=0; i < tokens.size; i++ )
		{
			if ( level flag::get( tokens[ i ] ) )
			{
				false_on = false;
				break;
			}
		}
	}
	
	b_enable = true_on && false_on;
	self TriggerEnable( b_enable );
}

function init_flags()
{
	level.trigger_flags = [];
}

function is_look_trigger( trig )
{
	return ( isdefined( trig ) ? (isdefined(trig.spawnflags)&&((trig.spawnflags & 256) == 256)) && !( trig.classname === "trigger_damage" ) : false );
}

function is_trigger_once( trig )
{
	return ( isdefined( trig ) ? (isdefined(trig.spawnflags)&&((trig.spawnflags & 1024) == 1024)) || ( ( self.classname === "trigger_once" ) ) : false );
}

function wait_for_either( str_targetname1, str_targetname2 )
{
	ent = SpawnStruct();
	
	array = [];
	array = ArrayCombine( array, GetEntArray( str_targetname1, "targetname" ), true, false );
	array = ArrayCombine( array, GetEntArray( str_targetname2, "targetname" ), true, false );
	
	for ( i = 0; i < array.size; i++ )
	{
		ent thread _ent_waits_for_trigger( array[ i ] );
	}

	ent waittill( "done", t_hit );
	
	return t_hit;
}

function _ent_waits_for_trigger( trigger )
{
	trigger wait_till();
	self notify( "done", trigger );
}

/@
"Name: wait_or_timeout( n_time, str_name, str_key )"
"Summary: Wait for a trigger to trigger or time passes."
"MandatoryArg: n_time: the amount of time."
"OptionalArg: str_name: name of the trigger."
"OptionalArg: str_key: KVP key of the trigger."
"Example: trigger::wait_or_timeout( 5, "my_trigger", "targetname" );"
@/
function wait_or_timeout( n_time, str_name, str_key )
{
	if ( isdefined( n_time ) ) {     __s = SpawnStruct();     __s endon( "timeout" );     __s util::delay_notify( n_time, "timeout" );    };
	wait_till( str_name, str_key );
}

/@
"Name: trigger_on_timeout( n_time, b_cancel_on_triggered, str_name, str_key )"
"Summary: Force a trigger to trigger when time passes."
"MandatoryArg: n_time: the amount of time."
"OptionalArg: b_cancel_on_triggered: don't trigger the trigger if it gets triggered before the time is up."
"OptionalArg: str_name: name of the trigger."
"OptionalArg: str_key: KVP key of the trigger."
"Example: trigger::trigger_on_timeout( 5, true, "my_trigger", "targetname" );"
@/
function trigger_on_timeout( n_time, b_cancel_on_triggered = true, str_name, str_key = "targetname" )
{
	trig = self;
	if ( isdefined( str_name ) )
	{
		trig = GetEnt( str_name, str_key );
	}
	
	if ( b_cancel_on_triggered )
	{
		if ( is_look_trigger( trig ) )
		{
			trig endon( "trigger_look" );
		}
		else
		{
			trig endon( "trigger" );
		}
	}
	
	trig endon( "death" );
	
	wait n_time;
	
	trig use();
}

function multiple_waits( str_trigger_name, str_trigger_notify )
{
	foreach ( trigger in GetEntArray( str_trigger_name, "targetname") )
	{
		trigger thread multiple_wait( str_trigger_notify );
	}
}

function multiple_wait( str_trigger_notify )// self = trigger ent
{
	level endon( str_trigger_notify );
	self waittill( "trigger" );
	level notify( str_trigger_notify );
}

/@
"Name: add_function( <str_trig_targetname>, [str_remove_on], <func>, [param_1], [param_2], [param_3], [param_4], [param_5], [param_6] )"
"Summary: Runs a function when a trigger is hit."
"Module: Utility"
"CallOn: level"
"MandatoryArg: <str_trig_targetname> : targetname of the trigger"
"OptionalArg: [str_remove_on] : remove the function on this notify to the trigger"
"MandatoryArg: <func> : pointer to a script function"
"OptionalArg: [param_1] : parameter 1 to pass to the func"
"OptionalArg: [param_2] : parameter 2 to pass to the func"
"OptionalArg: [param_3] : parameter 3 to pass to the func"
"OptionalArg: [param_4] : parameter 4 to pass to the func"
"OptionalArg: [param_5] : parameter 5 to pass to the func"
"OptionalArg: [param_6] : parameter 6 to pass to the func"
"Example: add_function( "my_trigger",&my_trigger_function );"
"SPMP: SP"
@/
function add_function( trigger, str_remove_on, func, param_1, param_2, param_3, param_4, param_5, param_6 )
{
	self thread _do_trigger_function( trigger, str_remove_on, func, param_1, param_2, param_3, param_4, param_5, param_6 );
}

function _do_trigger_function( trigger, str_remove_on, func, param_1, param_2, param_3, param_4, param_5, param_6 )
{
	self endon( "death" );
	trigger endon( "death" );
	
	if ( isdefined( str_remove_on ) )
	{
		trigger endon( str_remove_on );
	}
	
	while ( true )
	{	
		if ( IsString( trigger ) )
		{
			wait_till( trigger );
		}
		else
		{
			trigger wait_till();
		}
		
		util::single_thread( self, func, param_1, param_2, param_3, param_4, param_5, param_6 );
	}
}

function kill_spawner_trigger( trigger )
{
	trigger trigger::wait_till();
	
	a_spawners = GetSpawnerArray( trigger.script_killspawner, "script_killspawner" );
	foreach ( sp in a_spawners )
	{
		sp Delete();
	}
	
	a_ents = GetEntArray( trigger.script_killspawner, "script_killspawner" );
	foreach ( ent in a_ents )
	{
		if ( ( ent.classname === "spawn_manager" ) && ( ent != trigger ) )
		{
			ent Delete();
		}
	}
}

function get_script_linkto_targets()
{
	targets = [];
	if( !isdefined( self.script_linkto ) )
	{
		return targets;
	}
		
	tokens = Strtok( self.script_linkto, " " );
	for( i = 0; i < tokens.size; i++ )
	{
		token = tokens[i];
		target = GetEnt( token, "script_linkname" );
		if( isdefined( target ) )
		{
			targets[targets.size] = target;
		}
	}
	
	return targets;
}

function delete_link_chain( trigger )
{
	// deletes all entities that it script_linkto's, and all entities that entity script linktos, etc.
	trigger waittill( "trigger" );

	targets = trigger get_script_linkto_targets();
	array::thread_all( targets, &delete_links_then_self );
}

function delete_links_then_self()
{
	targets = get_script_linkto_targets();
	array::thread_all( targets, &delete_links_then_self );
	self Delete();
}

function no_crouch_or_prone_think( trigger )
{
	while ( true )
	{
		trigger waittill( "trigger", other );

		if( !IsPlayer( other ) )
		{
			continue;
		}

		while( other IsTouching( trigger ) )
		{
			other AllowProne( false );
			other AllowCrouch( false );
			{wait(.05);};
		}

		other AllowProne( true );
		other AllowCrouch( true );
	}
}

function no_prone_think( trigger )
{
	while ( true )
	{
		trigger waittill( "trigger", other );

		if( !IsPlayer( other ) )
		{
			continue;
		}

		while( other IsTouching( trigger ) )
		{
			other AllowProne( false );
			{wait(.05);};
		}

		other AllowProne( true );
	}
}

function trigger_group()
{
	self thread trigger_group_remove();

	level endon( "trigger_group_" + self.script_trigger_group );
	self waittill( "trigger" );
	level notify( "trigger_group_" + self.script_trigger_group, self );
}

function trigger_group_remove()
{
	level waittill( "trigger_group_" + self.script_trigger_group, trigger );
	if( self != trigger )
	{
		self Delete();
	}
}

//trigger_thread
function function_thread(ent, on_enter_payload, on_exit_payload)
{
	ent endon("entityshutdown");
	
	if(ent ent_already_in(self))
		return;
		
	add_to_ent(ent, self);

//	iprintlnbold("Trigger " + self.targetname + " hit by ent " + ent getentitynumber());
	
	if(isdefined(on_enter_payload))
	{
		[[on_enter_payload]](ent);
	}
	
	while(isdefined(ent) && ent istouching(self))
	{
		wait(0.01);
	}

//	iprintlnbold(ent getentitynumber() + " leaves trigger " + self.targetname + ".");

	if(isdefined(ent) && isdefined(on_exit_payload))
	{
		[[on_exit_payload]](ent);
	}

	if(isdefined(ent))
	{
		remove_from_ent(ent, self);
	}
}

function ent_already_in(trig)
{
	if(!isdefined(self._triggers))
		return false;
		
	if(!isdefined(self._triggers[trig getentitynumber()]))
		return false;
		
	if(!self._triggers[trig getentitynumber()])
		return false;
		
	return true;	// We're already in this trigger volume.
}

function add_to_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
	{
		ent._triggers = [];
	}
	
	ent._triggers[trig getentitynumber()] = 1;
}

function remove_from_ent(ent, trig)
{
	if(!isdefined(ent._triggers))
		return;
		
	if(!isdefined(ent._triggers[trig getentitynumber()]))
		return;
		
	ent._triggers[trig getentitynumber()] = 0;
}
