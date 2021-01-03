#using scripts\codescripts\struct;

#using scripts\shared\animation_shared;
#using scripts\shared\array_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\math_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;

#using scripts\shared\ai\systems\face;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace dialog;

#precache( "eventstring", "offsite_comms_message" );
#precache( "eventstring", "offsite_comms_complete" );

#precache( "string", "COOP_KAYNE_RACHEL" );
#precache( "string", "COOP_EGYPTIAN_COMMAND" );

function autoexec __init__sytem__() {     system::register("dialog",&__init__,undefined,undefined);    }

/*-----------------------------------------------------------------------------------------------------


***************************************************************************************************
Dialog Overview.
***************************************************************************************************

	This script handles all dialog functionality.
	The dialog system is automatically initialized in _load.gsc.
	
	The scripter declares each dialog line in the level using the funciton:-
		add_dialog( str_dialog_name, str_vox_file ).
		
	This module contains a series of "say_dialog()" script commands to assist scripting character VO dialog 
	requirements.
	
	To enable dialog to be scripted at any time (before the VOX audio files area available), use the 
	add_dialog() function with the dialog text as the 2nd parameter (instead of the file name).
	Now instead of playing the audio file you will get a 'placeholder' text prompt for the dialog.
	
	Adding this functionaility will stop the dialog becoming a bottleneck for the scripter, you can script your 
	dialog anytime, without habing to use 'temp' dialog commands.


***************************************************************************************************
Initializing VO lines for your level.
The script function anim_generic() is now used in place of anim_single() to play dialog on an entity.
***************************************************************************************************

	Dialog is now played on enities using the script function anim_generic() in place of anim_single().
	This has the advantage that the scripter no longer has to manage or worry about what an entities .animname
	is set to.  The dialog will automatically play using anim_generic().
	
	In Black Ops, the dialog lines were declared as follows:-
			
		level.scr_sound["mason"]["wakeup_mason"] = "vox_pow1_s03_505A_mason";			// Wake up, Mason!
		level.scr_sound["mason"]["lets_go_mason"] = "vox_pow1_s03_515A_mason";			// Lets go Mason
		level.scr_sound["woods"]["there_in_the_trees"] = "vox_pow1_s03_515A_wood";		// There in the trees Bowman
		

	In Black OPs 2 this is replaced by using the function add_dialog to declare the audio, for example:-	
	
		add_dialog( "wakeup_mason", "vox_pow1_s03_505A_mason" );		// Wake up, Mason
		add_dialog( "lets_go_mason", "vox_pow1_s03_515A_mason" );		// Lets go Mason
		add_dialog( "there_in_the_trees", "vox_pow1_s03_505A_wood" );	// There in the trees Bowman


***************************************************************************************************
Entering Tempory Dialog
***************************************************************************************************

While waiting for dialog frm the audio department you can still script all your dialog calls in script, 
using the correct play dialog commands instead of 'temp' dialog calls.

For example: A the declaration of a normal dialog line in Black Op 2 would look something like:-
		add_dialog( "wakeup_mason", "vox_pow1_s03_505A_mason" );		// Wake up, Mason
	
If the file name is not available, for now add your own text (instead of the file name and the 
temp dialog will play.
	add_dialog( "wakeup_mason", "Wake up Mason, we're ready to go" );	// Wake up, Mason

When the filename is available simply replace the temp text description with the audio file name.



***************************************************************************************************
Steps to setup working dialog in your level
***************************************************************************************************

(1) Create an init_vo() function in one of your level initialization files. This should be kept in 
	your <levelname>_anim.gsc file.

(2) The function should be called as you initialize the level.

(3) The init_vo() function has a unique entry for each dialog line and will look something like:-

	init_vo()
	{
		// Mason VO Lines
		add_dialog( "wakeup_mason", "vox_pow1_s03_505A_mason" );		// Wake up, Mason
		add_dialog( "lets_go_mason", "vox_pow1_s03_515A_mason" );		// Lets go Mason

		// Woods VO Lines
		add_dialog( "there_in_the_trees", "vox_pow1_s03_505A_wood" );	// There in the trees Bowman
	}

(4) Any missing dialog that is not available with from the audio department can still be scripterd correctly.
	To do this, use the add_dialog command, but replace the unknow filename with the placeholder VO text. 
	name with some text that you would expect to here.
    e.g.
		add_dialog( "woods_trees", "There in the trees woods" );
		level.scr_sound["generic"]["woods_trees"] = "Woods, there in the trees";
		
	When the file name is available from the audio department, replace the place holder text with the VOX 
	file name.


(5) There are a bunch of say_dialog() commands to play dialog under different circumstances.
	See the list below:-
	NOTE: All say_dialog functions should be threaded.

		say_dialog( str_vo_line, n_delay )								// Says dialog command with optional delay
		say_dialog_targetname( targetname, str_vo_line, delay )			// Uses targetname to find entity for VO
		say_dialog_flag( fl_flag, str_vo_line, delay_after_flag )		// Says dialog when flag set
		say_dialog_trigger( str_trigger_targetname, str_vo_line, delay_after_trigger )	// Says dialog after trigger hit
		say_dialog_health_lost( percentage_health_lost, e_target_ent, str_vo_line, delay_after_health_lost );
		say_dialog_func( func_pointer, str_vo_line, delay_after_func )	// Says dialog when func passes back true
		
		kill_all_pending_dialog( e_ent );				// Kills all the pending dialog calls that have been made


(6) Finally there are a number of ways to play NAG VO repeating lines. 
	These are dialog lines that keep on repeating until a flag is set, a trigger reached or other type of 
	termination	condition is met.
	
	The dialog nag commands available incluide :-

	 - add_vo_to_nag_group( group, character, vo_line )

	 - start_vo_nag_group_flag( str_group, str_end_nag_flag, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
	 - start_vo_nag_group_trigger( str_group, t_end_nag_trigger, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
	 - start_vo_nag_group_func( str_group, func_end_nag, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )

	 - delete_vo_nag_group( str_group )


(7) Examlpe of how to set up a NAG Dialog group.

	(A) Add a bunch of dialog commands to the "nag group", in this case the group is caled "mike_vo"
			add_vo_to_nag_group( "mike_vo", level.woods, "mike_for_bowan" );
			add_vo_to_nag_group( "mike_vo", level.player, "mike_lets_go" );
			add_vo_to_nag_group( "mike_vo", level.woods, "mike_we_aint_got" );
	
	(B) We now have a NAG group that can be scripted in the level with one of the start_vo_nag_group_.... calls.
		- start_vo_nag_group_flag( "mike_vo", ... )
		- start_vo_nag_group_trigger( "mike_vo", ... )
		- start_vo_nag_group_func( "mike_vo", ... )

	(C) The difference between each NAG Group Call is that they terminate in a differnet way, either by a flag,
		trigger or function returning true.


----------------------------------------------------------------------------------------------------- */


/*===================================================================
SELF:		level
PURPOSE:	System internal initialize of the VO system
RETURNS:	nothing
===================================================================*/

function __init__()
{
	level.vo = SpawnStruct();
	level.vo.nag_groups = [];
}

/@
"Name: add( <str_dialog_name>, <str_vox_file - VOX FILE NAME or Temp Dialog to play if no file exists yet> )"
"Summary: Adds a dialog audio vo call to the dialog system, unsig the animname .generic"
"Module: _dialog"
"CallOn: level"
"MandatoryArg: <str_dialog_name> string - The string name used to reference the dialog"
"MandatoryArg: <str_vox_file> string - The VOX file name, or temp dialog string to play if the VOX file doesn't exist"
"Example: add_dialog( "come_here_woods", "vox_pow1_s03_505A_wood" );"
"SPMP: singleplayer"
@/

function add( str_dialog_name, str_vox_file )
{
	assert( isdefined( str_dialog_name ), "Undefined - str_dialog_name, passed to add_dialog()" );
	assert( isdefined( str_vox_file ), "Undefined - str_vox_file, passed to add_dialog()" );
	
	if(!isdefined(level.scr_sound))level.scr_sound=[];
	if(!isdefined(level.scr_sound[ "generic" ]))level.scr_sound[ "generic" ]=[];
	
	level.scr_sound[ "generic" ][ str_dialog_name ] = str_vox_file;
	
	animation::add_global_notetrack_handler( "vox#" + str_dialog_name, &notetrack_say, false, str_dialog_name );
}

function notetrack_say( str_vo_line )
{
	if ( IsPlayer( self ) )
	{
		if ( self flagsys::get( "shared_igc" ) )
		{
			player_say( str_vo_line );
		}
		else
		{
			say( str_vo_line );
		}
	}
	else if ( is_player_dialog( str_vo_line ) )
	{
		// Player vo notetrack is set on a non-player entity.
		// This should make it work as if it was set on the player animation.
		level player_say( str_vo_line );
	}
	else
	{
		say( str_vo_line );
	}
}

function is_player_dialog( str_script_id )
{
	return ( StrStartsWith( str_script_id, "plyr_" ) );
}

/@
"Name: say( <str_vo_line>, [n_delay], [b_fake_ent], [e_to_player] )"
"Summary: Plays a dialog line on an entity.  CAn play temp strings or script ids for <level>_voice.gsc"
"CallOn: Entity who says the dialog"
"MandatoryArg: <str_vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay] - Optional time delay before the dialog line plays"
"OptionalArg:  [b_fake_ent] - set to true when trying to play VO off of a script origin or other entity with no health"
"OptionalArg:  [e_to_player] - the player that should hear the dialog.  All other players will hear nothing."
"Example: e_mason dialog::say( "come_here_woods", 2 );"
@/
function say( str_vo_line, n_delay, b_fake_ent = false, e_to_player )
{
	ent = self;
	if ( self == level )
	{
		ent = Spawn( "script_origin", ( 0, 0, 0 ) );
		b_fake_ent = true;
	}
	
	ent endon( "death" );
	ent thread _say( str_vo_line, n_delay, b_fake_ent, e_to_player );
	ent waittillmatch( "done speaking", str_vo_line );
	
	if ( self == level )
	{
		ent Delete();
	}
}

function private _say( str_vo_line, n_delay, b_fake_ent = false, e_to_player )
{
	self endon( "death" );
	
	self.is_about_to_talk = true;
	self thread _on_kill_pending_dialog( str_vo_line );
	
	level endon( "kill_pending_dialog" );
	self endon( "kill_pending_dialog" );
	
	_add_to_spoken_dialog( str_vo_line );

	if ( isdefined( n_delay ) && ( n_delay > 0 ) )
	{
		wait( n_delay );
	}

	if ( self.classname === "script_origin" )
	{
		b_fake_ent = true;
	}
	
	if ( !b_fake_ent )
	{
		// Entity health checks	
		if ( !isdefined( self.health ) || ( self.health <= 0 ) )
		{
			if ( !IsPlayer( self ) || !( isdefined( self.laststand ) && self.laststand ) )
			{
				AssertMsg( "Attempting to play dialog on a dead entity." );
				self.is_about_to_talk = undefined;
				self notify( "done speaking", str_vo_line );
				return;
			}
		}
	}
	
	self.is_talking = true;
	
	self face::SaySpecificDialogue( false, str_vo_line, 1.0, undefined, undefined, undefined, e_to_player );
	
	self waittillmatch( "done speaking", str_vo_line );
	
	self.is_talking = undefined;
	self.is_about_to_talk = undefined;
}

function _on_kill_pending_dialog( str_vo_line )
{
	self endon( "death" );
	util::waittill_any_ents_two( level, "kill_pending_dialog", self, "kill_pending_dialog" );
	self.is_about_to_talk = undefined;
}

/@
"Name: player_say( <str_vo_line>, [n_delay] )"
"Summary: Plays a dialog line on a player.  Only this player will hear it."
"CallOn: Player or level for all players"
"MandatoryArg: <str_vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay] - Optional time delay before the dialog line plays"
"Example: level.players[0] dialog::player_say( "come_here_woods" );"
@/
function player_say( str_vo_line, n_delay )
{
	if ( self == level )
	{
		foreach ( player in level.activeplayers )
		{
			player thread player_say( str_vo_line, n_delay );
		}
		
		array::wait_till_match( level.activeplayers, "done speaking", str_vo_line );
	}
	else
	{
		say( str_vo_line, n_delay, false, self );
	}
}

/@
"Name: remote( <vo_line>, [n_delay], [str_type = "dni"], [e_to_player] )"
"Summary: Plays a dialog line as if it was heard through a communications system (DNI)"
"CallOn: level"
"MandatoryArg: <vo_line> string - The script id of the vo line added via dialog::add (in <level>_voice.gsc)"
"OptionalArg:  [n_delay] - Optional time delay before the dialog line plays"
"OptionalArg:  [str_type] - What type of remote dialog.  Defaults to "dni""
"OptionalArg:  [e_to_player] - the player that should hear the dialog.  All other players will hear nothing."
"Example: level dialog::remote( "come_here_woods" );"
@/
function remote( str_vo_line, n_delay, str_type = "dni", e_to_player )
{
	if ( str_type === "dni" )
	{
		// See if we can get away with parsing the vo script id for who's speaking
		a_script_id = StrTok( str_vo_line, "_" );
		
		str_who = &"COOP_KAYNE_RACHEL";
		
		switch ( a_script_id[0] )
		{
			case "kane":
				str_who = &"COOP_KAYNE_RACHEL";
				break;
			case "ecmd":
				str_who = &"COOP_EGYPTIAN_COMMAND";
				break;
			case "khal": // TODO: use real ID for Khalil.
				str_who = &"COOP_EGYPTIAN_COMMAND";
				break;
			default: // Stub so all VOs will play.
				str_who = &"COOP_EGYPTIAN_COMMAND";
				break;
		}
				
		foreach ( player in level.players )
		{
			if ( !isDefined( e_to_player ) || e_to_player == player )
				player LUINotifyEvent( &"offsite_comms_message", 1, str_who );
		}
	}
	
	level say( str_vo_line, n_delay, true, e_to_player );
	
	if ( str_type === "dni" )
	{	
		foreach ( player in level.players )
		{
			if ( !isDefined( e_to_player ) || e_to_player == player )
				player LUINotifyEvent( &"offsite_comms_complete" );
		}
	}
}

function _add_to_spoken_dialog( str_line )
{
	if ( !isdefined( level._spoken_dialog ) )
	{
		level._spoken_dialog = [];
	}
	
	if ( !isdefined( level._spoken_dialog ) ) level._spoken_dialog = []; else if ( !IsArray( level._spoken_dialog ) ) level._spoken_dialog = array( level._spoken_dialog ); level._spoken_dialog[level._spoken_dialog.size]=str_line;;
}

///@
//"Name: was_dialog_said( <str_line> )"
//"Summary: checks to see if a dialog line has been said"
//"Module: _dialog"
//"CallOn: level"
//"MandatoryArg: <str_line> the dialog line to check"
//"Example: was_dialog_said( "come_here_woods" );"
//"SPMP: singleplayer"
//@/
//was_dialog_said( str_line )
//{
//	return ( isdefined( level._spoken_dialog ) && IsInArray( level._spoken_dialog, str_line ) );
//}
//
///@
//"Name: say_dialog_targetname( <targetname>, <vo_line>, [n_delay] )"
//"Summary: Plays dialog from the array level.scr_sound, using the targetname to find the entity"
//"Module: _dialog"
//"CallOn: entity"
//"MandatoryArg: <targetname> string - Entities targetname"
//"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
//"OptionalArg:  [n_delay] - Optional time delay before the dialog line plays"
//"Example: say_dialog_targetname( "woods", "come_here_woods", 2 );"
//"SPMP: singleplayer"
//@/
//
//say_dialog_targetname( targetname, str_vo_line, delay )
//{
//	e_guy = GetEnt( targetname, "targetname" );
//	
//	assert( isdefined(e_guy), "say_dialog_targetname - no entity with targetname: " + targetname );
//
//	e_guy say_dialog( str_vo_line, delay );
//}
//
//
///@
//"Name: say_dialog_flag( <flag>, <vo_line>, [n_delay_after_flag] )"
//"Summary: Plays dialog from the array level.scr_sound, once the flag has been set"
//"Module: _dialog"
//"CallOn: Entity who says the dialog"
//"MandatoryArg: <flag> flag - Flag to set that triggers the dialog"
//"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
//"OptionalArg:  [n_delay_after_flag] - Optional time delay (after flag set) before the dialog line plays"
//"Example: e_guy say_dialog_flag( fl_area_clear, "come_here_woods", 2 );"
//"SPMP: singleplayer"
//@/
//
//// self = entity to play sound alias on
//say_dialog_flag( fl_flag, str_vo_line, delay_after_flag )
//{
//	self endon( "death" );
//	level endon( "kill_pending_dialog" );
//	self endon( "kill_pending_dialog" );
//
//	if( !(level flag_exists(fl_flag)) )
//	{
//		Assert( 0, "flag: '" + fl_flag + "' does not exist");
//	}
//	
//	flag_wait( fl_flag );	
//	
//	self say_dialog( str_vo_line, delay_after_flag );
//}
//
//
///@
//"Name: say_dialog_trigger( <trigger>, <vo_line>, [n_delay_after_trigger] )"
//"Summary: Plays dialog from the array level.scr_sound, once the trigger has been hit"
//"Module: _dialog"
//"CallOn: Entity who says the dialog"
//"MandatoryArg: <trigger> trigger - Targetname of the trigger"
//"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
//"OptionalArg:  [n_delay_after_trigger] - Optional time delay (after trigger hit) before the dialog line plays"
//"Example: e_ent say_dialog_trigger( "str_trigger_targetname", "come_here_woods", 2 );"
//"SPMP: singleplayer"
//@/
//
//// self = entity to play sound alias on
//say_dialog_trigger( str_trigger_targetname, str_vo_line, delay_after_trigger )
//{
//	self endon( "death" );
//	level endon( "kill_pending_dialog" );
//	self endon( "kill_pending_dialog" );
//
//	t_trig = GetEnt( str_trigger_targetname, "targetname" );
//	assert( isdefined(t_trig), "Dialog trigger not found: " + str_trigger_targetname );
//	
//	t_trig waittill( "trigger" );
//	
//	self say_dialog( str_vo_line, delay_after_trigger );
//}
//
//
///@
//"Name: say_dialog_health_lost( <percentage health lost>, <ent_taking_damage>, <vo_line>, [n_delay_after_health_lost] )"
//"Summary: Plays dialog from the array level.scr_sound, once the entity"
//"Module: _dialog"
//"CallOn: self entity"
//"MandatoryArg: <percentage_health_lost> eg. (10=10% health lost, 60=60% health lost, 100=all health lost)"
//"MandatoryArg: <ent_taking_damage> e_ent - The entity to check for damage loss"
//"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
//"OptionalArg:  [n_delay_after_health_lost] - Optional time delay (after after health lost) before the dialog line plays"
//"Example: e_ent say_dialog_health_lost( 50, e_guy, "come_here_woods", 2 );"
//"SPMP: singleplayer"
//@/
//
//say_dialog_health_lost( percentage_health_lost, e_target_ent, str_vo_line, delay_after_health_lost )
//{
//	self endon( "death" );
//	level endon( "kill_pending_dialog" );
//	self endon( "kill_pending_dialog" );
//
//	while( 1 )
//	{
//		// If the entity is already dead, treat the same as all health lost
//		if( !isdefined(e_target_ent) )
//		{
//			health_lost = 100;
//		}
//		else
//		{
//			health_lost = 100 - ( (e_target_ent.health / e_target_ent.maxHealth) * 100 );
//		}
//	
//		if( health_lost >= percentage_health_lost )
//		{
//			break;
//		}
//		wait( 0.01 );
//	}
//	
//	self say_dialog( str_vo_line, delay_after_health_lost );
//}
//
//
///@
//"Name: say_dialog_func( <func>, <vo_line>, [n_delay_after_func] )"
//"Summary: Plays dialog from the array level.scr_sound, once the function passes back true"
//"Module: _dialog"
//"CallOn: Entity who says the dialog"
//"MandatoryArg: <func> function - Function to call, when it passes non zero the dialog will play"
//"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
//"OptionalArg:  [n_delay_after_func] - Optional time delay (after func passes) before the dialog line plays"
//"Example: e_ent say_dialog_func( ::func_name, "come_here_woods", 2 );"
//"SPMP: singleplayer"
//@/
//
//say_dialog_func( func_pointer, str_vo_line, delay_after_func )
//{
//	self endon( "death" );
//	level endon( "kill_pending_dialog" );
//	self endon( "kill_pending_dialog" );
//
//	while( 1 )
//	{
//		if( [[func_pointer]]() )
//		{
//			break;
//		}
//		wait( 0.01 );
//	}
//	
//	self say_dialog( str_vo_line, delay_after_func );
//}
//
//
//
///@
//"Name: kill_all_pending_dialog( [e_ent] )"
//"Summary: Kills any active dialog threads waiting to play dialgue"
//"Module: _dialog"
//"CallOn: Entity who says the dialog"
//"OptionalArg:  [e_ent] - Optional, if entity passed will only kill dialog for this entity"
//"Example: kill_all_pending_dialog();"
//"SPMP: singleplayer"
//@/
//
//kill_all_pending_dialog( e_ent )
//{
//	if( isdefined(e_ent) )
//	{
//		e_ent notify( "kill_pending_dialog" );
//	}
//	else
//	{
//		level notify( "kill_pending_dialog" );
//	}
//}
//
//
////*****************************************************************************
////*****************************************************************************
////*****************************************************************************
////*****************************************************************************
////*****************************************************************************
////*****************************************************************************
////*****************************************************************************
////*****************************************************************************
//
///@
//"Name: add_vo_to_nag_group( <group>, <character>, <vo_line> )"
//"Summary: Adds a vo line to a nag group.  To activate the group call one of the nag play functions"
//"Module: _dialog"
//"CallOn: level"
//"MandatoryArg: <group> string name - A unique string used to identify the nag group name."
//"MandatoryArg: <character> entity - The character or entity you want to play the vo line from."
//"MandatoryArg: <vo_line> string - The string name from level.scr_anim[]"
//"Example: add_vo_to_nag_group( "in_position_to_attack_bridge", e_woods, "mason_whats_holding_us_up" );"
//"SPMP: singleplayer"
//@/
//
//add_vo_to_nag_group( group, character, vo_line )
//{
//	Assert( isdefined( character ), "Character is missing in FN: add_vo_to_nag_groupg()" );
//	Assert( isdefined( vo_line ), "Vo Line is missing in FN: add_vo_to_nag_groupg()" );
//
//	// If the nag group doesn't exist, create a new group
//	if( !isdefined(level.vo.nag_groups[group]) )
//	{
//		level.vo.nag_groups[ group ] = SpawnStruct();
//		level.vo.nag_groups[ group ].e_ent = [];
//		level.vo.nag_groups[ group ].str_vo_line = [];
//		level.vo.nag_groups[ group ].num_nags = 0;
//	}
//
//	// Setup a struct holding the nag line information
//	ARRAY_ADD( level.vo.nag_groups[ group ].e_ent, character );
//	ARRAY_ADD( level.vo.nag_groups[ group ].str_vo_line, vo_line );
//	level.vo.nag_groups[ group ].num_nags++;
//}
//
//
///@
//"Name: start_vo_nag_group_flag( <group>, <end_flag>, <vo_repeat_delay>, [start_delay], [randomize_order], [repeat_multiplier], [func_filter] )"
//"Summary: Plays 'nag lines' from a group until a flag is set, with optional randomized order and scripter defined logic"
//"Module: _dialog"
//"CallOn: level.  Must first create a vo group using - add_vo_to_nag_group()."
//"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array().  Defaults to playing in created order."
//"MandatoryArg: <end_flag> Name of flag that will delete the nag group when set."
//"MandatoryArg: <vo_repeat_delay> Delay between each nag vo call."
//"OptionalArg:  [start_delay] Time delay before the first nag line. Defaults to 0."
//"OptionalArg:  [randomize_order] Do you want to th play the nag line =s in the created order?. Defaults to false."
//"OptionalArg:  [repeat_multiplier] A randomfloatrange( -num, num ).  Use to add some randomness to the gap between nag lines."
//"OptionalArg:  [func_filter] Function pointer that should return a bool.  If it returns false for a character when he tries to says his VO, he will not say it. Defaults to undefined."
//"Example: start_vo_nag_group_flag( "squad_a", "event1_end", 8, 2, false, 1.5, ::is_play_lost );"
//"SPMP: singleplayer"
//@/
//start_vo_nag_group_flag( str_group, str_end_nag_flag, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
//{
//	Assert( isdefined( str_end_nag_flag ), "str_end_nag_flag is missing in FN: start_vo_nag_group_flag()" );
//	level thread _start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, str_end_nag_flag );
//}
//
//
///@
//"Name: start_vo_nag_group_trigger( <group>, <t_end_nag_trigger>, <vo_repeat_delay>, [start_delay], [randomize_order], [repeat_multiplier], [func_filter] )"
//"Summary: Plays 'nag lines' from a group until a flag is set, with optional randomized order and scripter defined logic"
//"Module: _dialog"
//"CallOn: level.  Must first create a vo group using - add_vo_to_nag_group()."
//"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array().  Defaults to playing in created order."
//"MandatoryArg: <t_end_nag_trigger> Name of trigger that will delete the nag group when triggered."
//"MandatoryArg: <vo_repeat_delay> Delay between each nag vo call."
//"OptionalArg:  [start_delay] Time delay before the first nag line. Defaults to 0."
//"OptionalArg:  [randomize_order] Do you want to th play the nag line =s in the created order?. Defaults to false."
//"OptionalArg:  [repeat_multiplier] A randomfloatrange( -num, num ).  Use to add some randomness to the gap between nag lines."
//"OptionalArg:  [func_filter] Function pointer that should return a bool.  If it returns false for a character when he tries to says his VO, he will not say it. Defaults to undefined."
//"Example: start_vo_nag_group_flag( "squad_a", "event1_end", 8, 2, false, 1.5, ::is_play_lost );"
//"SPMP: singleplayer"
//@/
//start_vo_nag_group_trigger( str_group, t_end_nag_trigger, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
//{
//	Assert( isdefined(t_end_nag_trigger), "t_end_nag_trigger is missing in FN: start_vo_nag_group_trigger()" );
//	
//	// Create a flag for the trigger to set
//	str_flag_name = "vo_nag_trigger_flag_" + str_group;
//	flag_init( str_flag_name );
//
//	// A thread that sets a flag when the trigger is hit
//	level thread _set_flag_when_trigger_hit( str_flag_name, t_end_nag_trigger );
//		
//	level thread _start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, str_flag_name );
//}
//
//_set_flag_when_trigger_hit( str_flag_name, t_end_nag_trigger )
//{
//	t_end_nag_trigger waittill( "trigger" );
//	flag_set( str_flag_name );
//}
//
//
///@
//"Name: start_vo_nag_group_func( <group>, <func_end_nag>, <vo_repeat_delay>, [start_delay], [randomize_order], [repeat_multiplier], [func_filter] )"
//"Summary: Plays 'nag lines' from a group until a function passes back true, with optional randomized order and scripter defined logic"
//"Module: _dialog"
//"CallOn: level.  Must first create a vo group using - add_vo_to_nag_group()."
//"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array().  Defaults to playing in created order."
//"MandatoryArg: <func_end_nag> Name of funtion to test for true"
//"MandatoryArg: <vo_repeat_delay> Delay between each nag vo call."
//"OptionalArg:  [start_delay] Time delay before the first nag line. Defaults to 0."
//"OptionalArg:  [randomize_order] Do you want to th play the nag line =s in the created order?. Defaults to false."
//"OptionalArg:  [repeat_multiplier] A randomfloatrange( -num, num ).  Use to add some randomness to the gap between nag lines."
//"OptionalArg:  [func_filter] Function pointer that should return a bool.  If it returns false for a character when he tries to says his VO, he will not say it. Defaults to undefined."
//"Example: start_vo_nag_group_flag( "squad_a", ::vo_nag_func, 8, 2, false, 1.5, ::is_play_lost );"
//"SPMP: singleplayer"
//@/
//start_vo_nag_group_func( str_group, func_end_nag, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
//{
//	// Create a flag for the trigger to set
//	str_flag_name = "vo_nag_func_flag_" + str_group;
//	flag_init( str_flag_name );
//
//	// A thread that sets a flag when the trigger is hit
//	level thread _set_flag_when_func_true( str_flag_name, func_end_nag );
//
//	level thread _start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, str_flag_name );
//}
//
//_set_flag_when_func_true( str_flag_name, func_end_nag )
//{
//	while( 1 )
//	{
//		if( [[func_end_nag]]() )
//		{
//			break;
//		}
//		wait( 0.01 );
//	}
//	flag_set( str_flag_name );
//}
//
//
///@
//"Name: delete_vo_nag_group( <group> )"
//"Summary: Deletes and frees memory from a defined NAG Group"
//"Module: _dialog"
//"CallOn: level"
//"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array()."
//"Example: delete_vo_nag_group( "squad_a" );"
//"SPMP: singleplayer"
//@/
//
//delete_vo_nag_group( str_group )
//{
//	level.vo.nag_groups[str_group] = undefined;
//}
//
//
///*===================================================================
//SELF:		level
//PURPOSE:	internally controls the playing of VO nag lines until the termination state is reached
//RETURNS:	N/A
//===================================================================*/
//
//_start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, end_nag_flag )
//{
//	Assert( isdefined( str_group ), "Undefined 'Group' in nag call" );
//	Assert( isdefined( vo_repeat_delay ), "Undefined 'vo_repeat_delay' in nag call" );
//	
//	// Check the Nag Group exists
//	Assert( isdefined(level.vo.nag_groups[str_group]), str_group + " is not a valid VO NAG Group" );
//
//	// Delay before start?
//	if( isdefined(start_delay) )
//	{
//		wait( start_delay );
//	}
//
//	//grab the struct with the array of vo lines
//	s_vo_slot = level.vo.nag_groups[str_group];
//	
//	// By default we play the nag VO order in its implicit order, populate the array based on the amount of lines in the nag group
//	vo_indexes = [];
//	for( i = 0; i < s_vo_slot.str_vo_line.size; i++ )
//	{
//		vo_indexes[i] = i;
//	}
//
//	// Keep playing the Nag lines until the nag termination condition is met
//	while( !flag(end_nag_flag) )
//	{
//		// Do we want to randomize the play order?
//		if ( isdefined(randomize_order) && (randomize_order == 1) && (s_vo_slot.num_nags > 1) )
//		{
//			// Remmeber the last VO line played so that we don't allow the 1st new one to be the same as the last one
//			// Basically stops the possibility of playing the same dialog line twice once the loop restarts
//			last_index = vo_indexes[ vo_indexes.size - 1 ];
//
//			num_tries = 0;		
//			array_randomized = 0;
//			while( !array_randomized )
//			{
//				// Create a new random array of nag lines
//				vo_indexes = array_randomize( vo_indexes );
//				if( vo_indexes[0] != last_index )
//				{
//					array_randomized = 1;
//				}
//				// If after 20 attempt we still have the same 1st entry in the new array as the last in the old array.
//				// Use the array anyway to avoid potentially infinite loop or performance glitch.
//				else
//				{
//					num_tries++;
//					if( num_tries >= 20 )
//					{
//						break;
//					}
//				}
//			}
//		}
//
//		// The random dialog is in the struct:  s_vo_slot
//		for( i=0; i< s_vo_slot.num_nags; i++ )
//		{
//			//check to make sure the end flag hasn't been set before playing more dialog
//			if( flag( end_nag_flag ) )
//			{
//				continue;	
//			}
//			
//			index = vo_indexes[i];
//		
//			e_speaker = s_vo_slot.e_ent[index];
//			str_vo_line = s_vo_slot.str_vo_line[index];
//	
//			b_play_line = true;
//			
//			// Runs a filter function if one is defined, if it returns true
//			if ( isdefined(func_filter) && !( e_speaker[[func_filter]]() ) )
//			{
//				b_play_line = false;
//			}
//
//			if ( b_play_line )
//			{
//				e_speaker say_dialog( str_vo_line );
//			}
//
//			// Wait for the next dialog line
//			next_play_delay = vo_repeat_delay;
//			if( isdefined(repeat_multiplier) )
//			{
//				next_play_delay = next_play_delay + randomfloatrange( repeat_multiplier*-1.0, repeat_multiplier );
//			}
//			
//			if( next_play_delay > 0 )
//			{
//				wait( next_play_delay );
//			}
//		}
//	}
//	
//	// Group no longer needed, clean up the SpawnStruct
//	level.vo.nag_groups[str_group] = undefined;
//}
//
//
//
///*===================================================================
//SELF:		level
//PURPOSE:	Displays paceholder dialog as a HUD element until it is available
//RETURNS:	N/A
//===================================================================*/
//
//add_temp_dialog_line( name, msg, delay )
//{
//	level thread add_temp_dialog_line_internal( name, msg, delay );
//}
//
//
//
////////////////////////////////////////////////////// DIALOG QUEUE //////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//
//autoexec _queue_dialog_init()
//{
//	flag_init( "dialog_queue_paused" );
//	flag_init( "dialog_convo_started" );
//}
//
//queue_dialog( str_line, n_delay = 0, start_flags, cancel_flags, b_only_once = true, b_priority = false, str_team, s_func_filter )
//{
//	DEFAULT( level._dialog_queue_id, 0 );
//	level._dialog_queue_id++;
//	n_id = level._dialog_queue_id;
//	
//	if ( !isdefined( self ) )
//	{
//		return;
//	}
//	
//	e_talker = self;
//	
//	if ( !isdefined( level.talkers ) )
//	{
//		level.talkers = [];
//	}
//	
//	if ( !isdefined( str_team ) )
//	{
//		/* If team is set, we're going to grab the guy later when it's time to talk */
//		
//		_queue_dialog_add_talker( e_talker );
//		e_talker endon( "death" );
//		
//		e_talker thread _queue_dialog_on_death( str_line, n_id, b_priority );
//	}
//	
//	if ( isdefined( cancel_flags ) )
//	{
//		/* set endons or just return out based on cancel flags */
//		
//		if ( !IsArray( cancel_flags ) )
//		{
//			cancel_flags = array( cancel_flags );
//		}
//		
//		foreach ( str_flag in cancel_flags )
//		{
//			if ( flag( str_flag ) )
//			{
//				/#
//					_log_dialog( str_line, "canceled via flag set", str_flag );
//				#/
//				
//				return;
//			}
//			
//			level endon( str_flag );
//		}
//		
//		e_talker thread _queue_dialog_on_cancel( str_line, n_id, cancel_flags, b_priority );
//	}
//	
//	if ( isdefined( start_flags ) )
//	{
//		/* wait for start flags */
//		
//		if ( !IsArray( start_flags ) )
//		{
//			start_flags = array( start_flags );
//		}
//		
//		/#
//			_log_dialog( str_line, "waiting for flag", start_flags );
//		#/
//		
//		flag_wait_array( start_flags );
//	}
//	
//	if ( isdefined( str_team ) )
//	{
//		if ( n_delay > 0 )
//		{
//			// wait before we grab our talker so he deosn't get killed durring the delay nad we never hear the line
//			wait n_delay;
//			n_delay = 0;
//		}
//		
//		excluders = [];
//		a_talkers = GetAIArray( str_team );
//		if ( isdefined( s_func_filter ) )
//		{
//			for ( i = 0; i < a_talkers.size; i++ )
//			{
//				if ( !a_talkers[i] call_func( s_func_filter ) )
//				{
//					ARRAY_ADD( excluders, a_talkers[i] );
//				}
//			}
//		}
//		else
//		{
//			excluders = level.hero_list;
//		}
//		
//		e_talker = get_array_of_closest( level.player.origin, a_talkers, excluders )[0];
//		if ( IsAlive( e_talker ) )
//		{
//			e_talker thread _queue_dialog_on_cancel( str_line, n_id, cancel_flags, b_priority );
//			e_talker thread _queue_dialog_on_death( str_line, n_id, b_priority );
//			
//			e_talker endon( "death" );
//			_queue_dialog_add_talker( e_talker );
//		}
//		else
//		{
//			return;
//		}
//	}
//	
//	if ( b_priority )
//	{
//		pause_dialog_queue( str_line, b_priority );
//	}
//	
//	/#
//		_log_dialog( str_line, "waiting turn" );
//	#/
//	
//	_queue_dialog_wait_turn( str_line, b_priority );
//	
//	b_already_said = was_dialog_said( str_line );
//	if ( !b_only_once || !b_already_said )
//	{
//		/#
//			_log_dialog( str_line, "playing with a " + string( n_delay ) + " delay" );
//		#/
//		
//		if ( b_priority )
//		{
//			level._priority_dialog_playing = true;
//		}
//		
//		e_talker notify( "dialog_started:" + n_id );
//		e_talker thread maps\_dialog::say_dialog( str_line, n_delay );
//		e_talker thread _queue_dialog_on_finished( str_line, n_id, b_priority );
//	}
//	else
//	{
//		/#
//			_log_dialog( str_line, "canceled because it was said already", str_flag );
//		#/
//		
//		e_talker notify( "_queue_dialog_on_cancel" + n_id );
//		e_talker notify( "dialog_canceled:" + n_id );
//		
//		if ( b_priority )
//		{
//			level thread unpause_dialog_queue( str_line, b_priority );
//		}
//	}
//}
//
//_queue_dialog_on_finished( str_line, n_id, b_priority )
//{
//	self endon( "death" );
//	self endon( "dialog_canceled:" + n_id );
//	
//	self waittill_dialog_finished();
//	
//	self notify( "dialog_finished:" + n_id );
//	
//	/#
//		_log_dialog( str_line, "finished" );
//	#/
//	
//	if ( b_priority )
//	{
//		unpause_dialog_queue( str_line, b_priority );
//	}
//}
//
//_queue_dialog_on_death( str_line, n_id, b_priority )
//{
//	self endon( "dialog_canceled:" + n_id );
//	self endon( "dialog_finished:" + n_id );
//	
//	self waittill( "death" );
//	
//	/#
//		_log_dialog( str_line, "died" );
//	#/
//	
//	if ( b_priority )
//	{
//		level thread unpause_dialog_queue( str_line, b_priority );
//	}
//}
//
//_queue_dialog_on_cancel( str_line, n_id, cancel_flags, b_priority )
//{
//	if ( !isdefined( cancel_flags ) )
//	{
//		return;
//	}
//	
//	level notify( "_queue_dialog_on_cancel" + n_id );
//	level endon( "_queue_dialog_on_cancel" + n_id );
//	
//	if ( self != level )
//	{	
//		self endon( "death" );
//		self endon( "dialog_started:" + n_id );
//	}
//	
//	str_flag = flag_wait_any_array( cancel_flags );
//	
//	/#
//		_log_dialog( str_line, "canceled via flag set", str_flag );
//	#/
//	
//	self notify( "dialog_canceled:" + n_id );
//	self notify( "kill_pending_dialog" );
//	
//	if ( b_priority )
//	{
//		unpause_dialog_queue( str_line, b_priority );
//	}
//}
//
//pause_dialog_queue( str_line, b_priority = true )
//{
//	if ( !flag( "dialog_queue_paused" ) )
//	{
//		/#
//			_log_dialog( str_line, "PAUSING DIALOG QUEUE" );
//		#/
//		
//		flag_set( "dialog_queue_paused" );
//	}
//	
//	_queue_dialog_wait_turn( str_line, b_priority );
//}
//
//dialog_start_convo( start_flags = [], false_flags = [] )
//{
//	if ( !IsArray( start_flags ) )
//	{
//		start_flags = array( start_flags );
//	}
//	
//	if ( !IsArray( false_flags ) )
//	{
//		false_flags = array( false_flags );
//	}
//		
//	ARRAY_ADD( false_flags, "dialog_convo_started" );
//	
//	while ( true )
//	{
//		_queue_dialog_wait_turn( undefined, true );
//		
//		if ( isdefined( start_flags ) )
//		{
//			if ( any_flags_false( start_flags ) )
//			{
//				flag_wait_array( start_flags );
//				continue;
//			}
//		}
//		
//		if ( isdefined( false_flags ) )
//		{
//			if ( any_flags_true( false_flags ) )
//			{
//				flag_waitopen_array( false_flags );
//				continue;
//			}
//		}
//		
//		break;
//	}
//	
//	flag_set( "dialog_convo_started" );
//	
//	/#
//		_log_dialog( undefined, "DIALOG START CONVO" );
//	#/
//}
//
//any_flags_true( a_flags )
//{
//	foreach ( str_flag in a_flags )
//	{
//		if ( flag( str_flag ) )
//		{
//			return true;
//		}
//	}
//	
//	return false;
//}
//
//any_flags_false( a_flags )
//{
//	foreach ( str_flag in a_flags )
//	{
//		if ( !flag( str_flag ) )
//		{
//			return true;
//		}
//	}
//	
//	return false;
//}
//
//dialog_end_convo( str_kill_notify )
//{
//	/#
//		_log_dialog( undefined, "DIALOG END CONVO" );
//	#/
//		
//	if ( isdefined( str_kill_notify ) )
//	{
//		level notify( str_kill_notify );
//	}
//		
//	if ( isdefined( level.talkers ) )
//	{
//		waittill_dialog_finished_array( level.talkers );
//	}
//	
//	flag_clear( "dialog_convo_started" );
//}
//
//unpause_dialog_queue( str_line, b_priority )
//{
//	level._priority_dialog_playing = undefined;
//	
//	_queue_dialog_wait_turn( str_line, b_priority );
//	WAIT_FRAME;
//		
//	if ( !IS_TRUE( level._priority_dialog_playing ) )
//	{
//		/#
//			_log_dialog( str_line, "UNPAUSING DIALOG QUEUE" );
//		#/
//				
//		flag_clear( "dialog_queue_paused" );
//	}
//}
//
//queue_dialog_enemy( str_line, n_delay, start_flags, cancel_flags, b_only_once, s_func_filter )
//{
//	queue_dialog( str_line, n_delay, start_flags, cancel_flags, b_only_once, false, "axis", s_func_filter );
//}
//
//queue_dialog_ally( str_line, n_delay, start_flags, cancel_flags, b_only_once, s_func_filter )
//{
//	queue_dialog( str_line, n_delay, start_flags, cancel_flags, b_only_once, false, "allies", s_func_filter );
//}
//
//priority_dialog( str_line, n_delay, start_flags, cancel_flags, b_only_once, str_team, s_func_filter )
//{
//	queue_dialog( str_line, n_delay, start_flags, cancel_flags, b_only_once, true, str_team, s_func_filter );
//}
//
//priority_dialog_enemy( str_line, n_delay, start_flags, cancel_flags, b_only_once, s_func_filter )
//{
//	queue_dialog( str_line, n_delay, start_flags, cancel_flags, b_only_once, true, "axis", s_func_filter );
//}
//
//priority_dialog_ally( str_line, n_delay, start_flags, cancel_flags, b_only_once, s_func_filter )
//{
//	queue_dialog( str_line, n_delay, start_flags, cancel_flags, b_only_once, true, "allies", s_func_filter );
//}
//
//waittill_dialog_queue_finished()
//{
//	_queue_dialog_wait_turn( undefined, false );
//}
//
//_queue_dialog_add_talker( talker )
//{
//	level.talkers = add_to_array( level.talkers, talker, false );
//}
//
//_queue_dialog_wait_turn( str_line, b_priority )
//{
//	waittillframeend;
//	if ( isdefined( level.talkers ) )
//	{
//		REMOVE_UNDEFINED( level.talkers );
//		waittill_dialog_finished_array( level.talkers );
//		
//		if ( !b_priority )
//		{
//			waittillframeend;
//			
//			flag_waitopen_array( array( "dialog_queue_paused", "dialog_convo_started" ) );
//			
//			REMOVE_UNDEFINED( level.talkers );
//			waittill_dialog_finished_array( level.talkers );
//		}
//	}
//}
//
///#
//_log_dialog( str_line, str_msg, a_flags )
//{
//	if ( isdefined( a_flags ) && !IsArray( a_flags ) )
//	{
//		a_flags = array( a_flags );
//	}
//	
//	DEFAULT( str_line, "" );
//	
//	str_color = _log_dialog_get_color( str_line );
//	
//	str_log_string = "^0DIALOG: '" + str_color + str_line + "^0' " + str_msg;
//	if ( isdefined( a_flags ) )
//	{
//		str_log_string += ": " + _dialog_array_to_string( a_flags );
//	}
//	
//	PrintLn( str_log_string );
//}
//
//_log_dialog_get_color( str_line )
//{
//	if ( !isdefined( str_line ) || ( str_line == "" ) )
//	{
//		return "";
//	}
//	
//	if ( !isdefined( level._log_dialog_colors ) )
//	{
//		level._log_dialog_colors = [];
//	}
//	
//	a_lines = GetArrayKeys( level._log_dialog_colors );
//	if ( !IsInArray( a_lines, str_line ) )
//	{
//		a_colors = array( "^1", "^2", "^3", "^4", "^5", "^6", "^7" );
//		
//		DEFAULT( level._log_dialog_get_color, 0 );
//		level._log_dialog_get_color++;
//			
//		if ( level._log_dialog_get_color >= a_colors.size )
//		{
//			level._log_dialog_get_color = 0;
//		}
//		
//		level._log_dialog_colors[ str_line ] = a_colors[ level._log_dialog_get_color ];
//	}
//	
//	return level._log_dialog_colors[ str_line ];	
//}
//
//_dialog_array_to_string( array )
//{
//	str = "^0[";
//	for ( i = 0; i < array.size; i++ )
//	{
//		if ( i > 0 )
//		{
//			str += "^0,";
//		}
//		
//		str = str + " ^5" + array[i];
//	}
//	str += "^0 ]";
//	return str;
//}
//#/
