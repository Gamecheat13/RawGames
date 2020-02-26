
#include common_scripts\utility; 
#include maps\_utility;
#include maps\_anim;

#insert raw\common_scripts\utility.gsh;


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

main()
{
	level.vo = SpawnStruct();
	level.vo.nag_groups = [];
}


/@
"Name: add_dialog( <str_dialog_name>, <str_vox_file - VOX FILE NAME or Temp Dialog to play if no file exists yet> )"
"Summary: Adds a dialog audio vo call to the dialog system, unsig the animname .generic"
"Module: _dialog"
"CallOn: level"
"MandatoryArg: <str_dialog_name> string - The string name used to reference the dialog"
"MandatoryArg: <str_vox_file> string - The VOX file name, or temp dialog string to play if the VOX file doesn't exist"
"Example: add_dialog( "come_here_woods", "vox_pow1_s03_505A_wood" );"
"SPMP: singleplayer"
@/

add_dialog( str_dialog_name, str_vox_file )
{
	assert( IsDefined(str_dialog_name), "Undefined - str_dialog_name, passed to add_dialog()" );
	assert( IsDefined(str_vox_file), "Undefined - str_vox_file, passed to add_dialog()" );

	if( !IsDefined(level.scr_sound["generic"]) )
	{
		level.scr_sound["generic"] = [];
	}
	level.scr_sound["generic"][str_dialog_name] = str_vox_file;
}


/@
"Name: say_dialog( <vo_line>, [n_delay] )"
"Summary: Plays a dialog line on an entity from the array level.scr_sound"
"Module: _dialog"
"CallOn: Entity who says the dialog"
"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay] - Optional time delay before the dialog line plays"
"Example: e_mason say_dialog( "come_here_woods", 2 );"
"SPMP: singleplayer"
@/

say_dialog( str_vo_line, n_delay )
{    
	self endon( "death" );
	level endon( "kill_pending_dialog" );
	self endon( "kill_pending_dialog" );

	if( IsDefined(n_delay) )
	{
		wait( n_delay );
	}
	
	// Maybe the guy died while waiting?
	if( !IsDefined(self) )
	{
		return;
	}

	// Entity health checks	
	if( !IsDefined(self.health) )
	{
		return;
	}
	if( self.health <= 0 )
	{
		return;
	}

	// TODO: Remove this when we have all the correct VO
	// Play the VOX file using anim_generic
	// If the VOX file is not defined, use a temp display for the VO
	str_vox_file = level.scr_sound["generic"][str_vo_line];
	
	self.is_talking = true;
	
	if(isdefined(str_vox_file))
	{
		if((str_vox_file[0] == "v") && (str_vox_file[1] == "o") && (str_vox_file[2] == "x") )
		{
			self anim_generic( self, str_vo_line );
		}		
		else
		{
			add_temp_dialog_line_internal( "TEMP VO", str_vox_file, 0 );
		}
	}
	else
	{
		add_temp_dialog_line_internal("MISSING VO",str_vo_line,0);
	}
	
	self.is_talking = undefined;
	
	waittillframeend;
}


/@
"Name: say_dialog_targetname( <targetname>, <vo_line>, [n_delay] )"
"Summary: Plays dialog from the array level.scr_sound, using the targetname to find the entity"
"Module: _dialog"
"CallOn: entity"
"MandatoryArg: <targetname> string - Entities targetname"
"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay] - Optional time delay before the dialog line plays"
"Example: say_dialog_targetname( "woods", "come_here_woods", 2 );"
"SPMP: singleplayer"
@/

say_dialog_targetname( targetname, str_vo_line, delay )
{
	e_guy = GetEnt( targetname, "targetname" );
	
	assert( IsDefined(e_guy), "say_dialog_targetname - no entity with targetname: " + targetname );

	e_guy say_dialog( str_vo_line, delay );
}


/@
"Name: say_dialog_flag( <flag>, <vo_line>, [n_delay_after_flag] )"
"Summary: Plays dialog from the array level.scr_sound, once the flag has been set"
"Module: _dialog"
"CallOn: Entity who says the dialog"
"MandatoryArg: <flag> flag - Flag to set that triggers the dialog"
"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay_after_flag] - Optional time delay (after flag set) before the dialog line plays"
"Example: e_guy say_dialog_flag( fl_area_clear, "come_here_woods", 2 );"
"SPMP: singleplayer"
@/

// self = entity to play sound alias on
say_dialog_flag( fl_flag, str_vo_line, delay_after_flag )
{
	self endon( "death" );
	level endon( "kill_pending_dialog" );
	self endon( "kill_pending_dialog" );

	if( !(level flag_exists(fl_flag)) )
	{
		Assert( 0, "flag: '" + fl_flag + "' does not exist");
	}
	
	flag_wait( fl_flag );	
	
	self say_dialog( str_vo_line, delay_after_flag );
}


/@
"Name: say_dialog_trigger( <trigger>, <vo_line>, [n_delay_after_trigger] )"
"Summary: Plays dialog from the array level.scr_sound, once the trigger has been hit"
"Module: _dialog"
"CallOn: Entity who says the dialog"
"MandatoryArg: <trigger> trigger - Targetname of the trigger"
"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay_after_trigger] - Optional time delay (after trigger hit) before the dialog line plays"
"Example: e_ent say_dialog_trigger( "str_trigger_targetname", "come_here_woods", 2 );"
"SPMP: singleplayer"
@/

// self = entity to play sound alias on
say_dialog_trigger( str_trigger_targetname, str_vo_line, delay_after_trigger )
{
	self endon( "death" );
	level endon( "kill_pending_dialog" );
	self endon( "kill_pending_dialog" );

	t_trig = GetEnt( str_trigger_targetname, "targetname" );
	assert( IsDefined(t_trig), "Dialog trigger not found: " + str_trigger_targetname );
	
	t_trig waittill( "trigger" );
	
	self say_dialog( str_vo_line, delay_after_trigger );
}


/@
"Name: say_dialog_health_lost( <percentage health lost>, <ent_taking_damage>, <vo_line>, [n_delay_after_health_lost] )"
"Summary: Plays dialog from the array level.scr_sound, once the entity"
"Module: _dialog"
"CallOn: self entity"
"MandatoryArg: <percentage_health_lost> eg. (10=10% health lost, 60=60% health lost, 100=all health lost)"
"MandatoryArg: <ent_taking_damage> e_ent - The entity to check for damage loss"
"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay_after_health_lost] - Optional time delay (after after health lost) before the dialog line plays"
"Example: e_ent say_dialog_health_lost( 50, e_guy, "come_here_woods", 2 );"
"SPMP: singleplayer"
@/

say_dialog_health_lost( percentage_health_lost, e_target_ent, str_vo_line, delay_after_health_lost )
{
	self endon( "death" );
	level endon( "kill_pending_dialog" );
	self endon( "kill_pending_dialog" );

	while( 1 )
	{
		// If the entity is already dead, treat the same as all health lost
		if( !IsDefined(e_target_ent) )
		{
			health_lost = 100;
		}
		else
		{
			health_lost = 100 - ( (e_target_ent.health / e_target_ent.maxHealth) * 100 );
		}
	
		if( health_lost >= percentage_health_lost )
		{
			break;
		}
		wait( 0.01 );
	}
	
	self say_dialog( str_vo_line, delay_after_health_lost );
}


/@
"Name: say_dialog_func( <func>, <vo_line>, [n_delay_after_func] )"
"Summary: Plays dialog from the array level.scr_sound, once the function passes back true"
"Module: _dialog"
"CallOn: Entity who says the dialog"
"MandatoryArg: <func> function - Function to call, when it passes non zero the dialog will play"
"MandatoryArg: <vo_line> string - The string index of the vo line defined in level.scr_anim"
"OptionalArg:  [n_delay_after_func] - Optional time delay (after func passes) before the dialog line plays"
"Example: e_ent say_dialog_func( ::func_name, "come_here_woods", 2 );"
"SPMP: singleplayer"
@/

say_dialog_func( func_pointer, str_vo_line, delay_after_func )
{
	self endon( "death" );
	level endon( "kill_pending_dialog" );
	self endon( "kill_pending_dialog" );

	while( 1 )
	{
		if( [[func_pointer]]() )
		{
			break;
		}
		wait( 0.01 );
	}
	
	self say_dialog( str_vo_line, delay_after_func );
}



/@
"Name: kill_all_pending_dialog( [e_ent] )"
"Summary: Kills any active dialog threads waiting to play dialgue"
"Module: _dialog"
"CallOn: Entity who says the dialog"
"OptionalArg:  [e_ent] - Optional, if entity passed will only kill dialog for this entity"
"Example: kill_all_pending_dialog();"
"SPMP: singleplayer"
@/

kill_all_pending_dialog( e_ent )
{
	if( IsDefined(e_ent) )
	{
		e_ent notify( "kill_pending_dialog" );
	}
	else
	{
		level notify( "kill_pending_dialog" );
	}
}


//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************
//*****************************************************************************

/@
"Name: add_vo_to_nag_group( <group>, <character>, <vo_line> )"
"Summary: Adds a vo line to a nag group.  To activate the group call one of the nag play functions"
"Module: _dialog"
"CallOn: level"
"MandatoryArg: <group> string name - A unique string used to identify the nag group name."
"MandatoryArg: <character> entity - The character or entity you want to play the vo line from."
"MandatoryArg: <vo_line> string - The string name from level.scr_anim[]"
"Example: add_vo_to_nag_group( "in_position_to_attack_bridge", e_woods, "mason_whats_holding_us_up" );"
"SPMP: singleplayer"
@/

add_vo_to_nag_group( group, character, vo_line )
{
	Assert( IsDefined( character ), "Character is missing in FN: add_vo_to_nag_groupg()" );
	Assert( IsDefined( vo_line ), "Vo Line is missing in FN: add_vo_to_nag_groupg()" );

	// If the nag group doesn't exist, create a new group
	if( !IsDefined(level.vo.nag_groups[group]) )
	{
		level.vo.nag_groups[ group ] = SpawnStruct();
		level.vo.nag_groups[ group ].e_ent = [];
		level.vo.nag_groups[ group ].str_vo_line = [];
		level.vo.nag_groups[ group ].num_nags = 0;
	}

	// Setup a struct holding the nag line information
	ARRAY_ADD( level.vo.nag_groups[ group ].e_ent, character );
	ARRAY_ADD( level.vo.nag_groups[ group ].str_vo_line, vo_line );
	level.vo.nag_groups[ group ].num_nags++;
}


/@
"Name: start_vo_nag_group_flag( <group>, <end_flag>, <vo_repeat_delay>, [start_delay], [randomize_order], [repeat_multiplier], [func_filter] )"
"Summary: Plays 'nag lines' from a group until a flag is set, with optional randomized order and scripter defined logic"
"Module: _dialog"
"CallOn: level.  Must first create a vo group using - add_vo_to_nag_group()."
"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array().  Defaults to playing in created order."
"MandatoryArg: <end_flag> Name of flag that will delete the nag group when set."
"MandatoryArg: <vo_repeat_delay> Delay between each nag vo call."
"OptionalArg:  [start_delay] Time delay before the first nag line. Defaults to 0."
"OptionalArg:  [randomize_order] Do you want to th play the nag line =s in the created order?. Defaults to false."
"OptionalArg:  [repeat_multiplier] A randomfloatrange( -num, num ).  Use to add some randomness to the gap between nag lines."
"OptionalArg:  [func_filter] Function pointer that should return a bool.  If it returns false for a character when he tries to says his VO, he will not say it. Defaults to undefined."
"Example: start_vo_nag_group_flag( "squad_a", "event1_end", 8, 2, false, 1.5, ::is_play_lost );"
"SPMP: singleplayer"
@/
start_vo_nag_group_flag( str_group, str_end_nag_flag, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
{
	Assert( IsDefined( str_end_nag_flag ), "str_end_nag_flag is missing in FN: start_vo_nag_group_flag()" );
	level thread _start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, str_end_nag_flag );
}


/@
"Name: start_vo_nag_group_trigger( <group>, <t_end_nag_trigger>, <vo_repeat_delay>, [start_delay], [randomize_order], [repeat_multiplier], [func_filter] )"
"Summary: Plays 'nag lines' from a group until a flag is set, with optional randomized order and scripter defined logic"
"Module: _dialog"
"CallOn: level.  Must first create a vo group using - add_vo_to_nag_group()."
"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array().  Defaults to playing in created order."
"MandatoryArg: <t_end_nag_trigger> Name of trigger that will delete the nag group when triggered."
"MandatoryArg: <vo_repeat_delay> Delay between each nag vo call."
"OptionalArg:  [start_delay] Time delay before the first nag line. Defaults to 0."
"OptionalArg:  [randomize_order] Do you want to th play the nag line =s in the created order?. Defaults to false."
"OptionalArg:  [repeat_multiplier] A randomfloatrange( -num, num ).  Use to add some randomness to the gap between nag lines."
"OptionalArg:  [func_filter] Function pointer that should return a bool.  If it returns false for a character when he tries to says his VO, he will not say it. Defaults to undefined."
"Example: start_vo_nag_group_flag( "squad_a", "event1_end", 8, 2, false, 1.5, ::is_play_lost );"
"SPMP: singleplayer"
@/
start_vo_nag_group_trigger( str_group, t_end_nag_trigger, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
{
	Assert( IsDefined(t_end_nag_trigger), "t_end_nag_trigger is missing in FN: start_vo_nag_group_trigger()" );
	
	// Create a flag for the trigger to set
	str_flag_name = "vo_nag_trigger_flag_" + str_group;
	flag_init( str_flag_name );

	// A thread that sets a flag when the trigger is hit
	level thread _set_flag_when_trigger_hit( str_flag_name, t_end_nag_trigger );
		
	level thread _start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, str_flag_name );
}

_set_flag_when_trigger_hit( str_flag_name, t_end_nag_trigger )
{
	t_end_nag_trigger waittill( "trigger" );
	flag_set( str_flag_name );
}


/@
"Name: start_vo_nag_group_func( <group>, <func_end_nag>, <vo_repeat_delay>, [start_delay], [randomize_order], [repeat_multiplier], [func_filter] )"
"Summary: Plays 'nag lines' from a group until a function passes back true, with optional randomized order and scripter defined logic"
"Module: _dialog"
"CallOn: level.  Must first create a vo group using - add_vo_to_nag_group()."
"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array().  Defaults to playing in created order."
"MandatoryArg: <func_end_nag> Name of funtion to test for true"
"MandatoryArg: <vo_repeat_delay> Delay between each nag vo call."
"OptionalArg:  [start_delay] Time delay before the first nag line. Defaults to 0."
"OptionalArg:  [randomize_order] Do you want to th play the nag line =s in the created order?. Defaults to false."
"OptionalArg:  [repeat_multiplier] A randomfloatrange( -num, num ).  Use to add some randomness to the gap between nag lines."
"OptionalArg:  [func_filter] Function pointer that should return a bool.  If it returns false for a character when he tries to says his VO, he will not say it. Defaults to undefined."
"Example: start_vo_nag_group_flag( "squad_a", ::vo_nag_func, 8, 2, false, 1.5, ::is_play_lost );"
"SPMP: singleplayer"
@/
start_vo_nag_group_func( str_group, func_end_nag, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter )
{
	// Create a flag for the trigger to set
	str_flag_name = "vo_nag_func_flag_" + str_group;
	flag_init( str_flag_name );

	// A thread that sets a flag when the trigger is hit
	level thread _set_flag_when_func_true( str_flag_name, func_end_nag );

	level thread _start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, str_flag_name );
}

_set_flag_when_func_true( str_flag_name, func_end_nag )
{
	while( 1 )
	{
		if( [[func_end_nag]]() )
		{
			break;
		}
		wait( 0.01 );
	}
	flag_set( str_flag_name );
}


/@
"Name: delete_vo_nag_group( <group> )"
"Summary: Deletes and frees memory from a defined NAG Group"
"Module: _dialog"
"CallOn: level"
"MandatoryArg: <group> A group containing an array of nag lines created using the script fn add_to_group_nag_array()."
"Example: delete_vo_nag_group( "squad_a" );"
"SPMP: singleplayer"
@/

delete_vo_nag_group( str_group )
{
	level.vo.nag_groups[str_group] = undefined;
}


/*===================================================================
SELF:		level
PURPOSE:	internally controls the playing of VO nag lines until the termination state is reached
RETURNS:	N/A
===================================================================*/

_start_vo_nag_group( str_group, vo_repeat_delay, start_delay, randomize_order, repeat_multiplier, func_filter, end_nag_flag )
{
	Assert( IsDefined( str_group ), "Undefined 'Group' in nag call" );
	Assert( IsDefined( vo_repeat_delay ), "Undefined 'vo_repeat_delay' in nag call" );
	
	// Check the Nag Group exists
	Assert( IsDefined(level.vo.nag_groups[str_group]), str_group + " is not a valid VO NAG Group" );

	// Delay before start?
	if( IsDefined(start_delay) )
	{
		wait( start_delay );
	}

	//grab the struct with the array of vo lines
	s_vo_slot = level.vo.nag_groups[str_group];
	
	// By default we play the nag VO order in its implicit order, populate the array based on the amount of lines in the nag group
	vo_indexes = [];
	for( i = 0; i < s_vo_slot.str_vo_line.size; i++ )
	{
		vo_indexes[i] = i;
	}

	// Keep playing the Nag lines until the nag termination condition is met
	while( !flag(end_nag_flag) )
	{
		// Do we want to randomize the play order?
		if ( IsDefined(randomize_order) && (randomize_order == 1) && (s_vo_slot.num_nags > 1) )
		{
			// Remmeber the last VO line played so that we don't allow the 1st new one to be the same as the last one
			// Basically stops the possibility of playing the same dialog line twice once the loop restarts
			last_index = vo_indexes[ vo_indexes.size - 1 ];

			num_tries = 0;		
			array_randomized = 0;
			while( !array_randomized )
			{
				// Create a new random array of nag lines
				vo_indexes = array_randomize( vo_indexes );
				if( vo_indexes[0] != last_index )
				{
					array_randomized = 1;
				}
				// If after 20 attempt we still have the same 1st entry in the new array as the last in the old array.
				// Use the array anyway to avoid potentially infinite loop or performance glitch.
				else
				{
					num_tries++;
					if( num_tries >= 20 )
					{
						break;
					}
				}
			}
		}

		// The random dialog is in the struct:  s_vo_slot
		for( i=0; i< s_vo_slot.num_nags; i++ )
		{
			//check to make sure the end flag hasn't been set before playing more dialog
			if( flag( end_nag_flag ) )
			{
				continue;	
			}
			
			index = vo_indexes[i];
		
			e_speaker = s_vo_slot.e_ent[index];
			str_vo_line = s_vo_slot.str_vo_line[index];
	
			// Runs a filter function if one is defined, if it returns true
			if ( IsDefined(func_filter) && !( e_speaker[[func_filter]]() ) )
			{
				continue;
			}

			e_speaker say_dialog( str_vo_line );

			// Wait for the next dialog line
			next_play_delay = vo_repeat_delay;
			if( IsDefined(repeat_multiplier) )
			{
				next_play_delay = next_play_delay + randomfloatrange( repeat_multiplier*-1.0, repeat_multiplier );
			}
			
			if( next_play_delay > 0 )
			{
				wait( next_play_delay );
			}
		}
	}
	
	// Group no longer needed, clean up the SpawnStruct
	level.vo.nag_groups[str_group] = undefined;
}



/*===================================================================
SELF:		level
PURPOSE:	Displays paceholder dialog as a HUD element until it is available
RETURNS:	N/A
===================================================================*/

add_temp_dialog_line( name, msg, delay )
{
	level thread add_temp_dialog_line_internal( name, msg, delay );
}

add_temp_dialog_line_internal( name, msg, delay )
{
	if( IsDefined(delay) )
	{
		wait( delay );
	}

	if ( !IsDefined( level.dialog_huds ) )
	{
		level.dialog_huds = [];
	}

	for ( index = 0;; index++ )
	{
		if ( !IsDefined( level.dialog_huds[ index ] ) )
		{
			break;
		}
	}

	level.dialog_huds[ index ] = true;

	hudelem = maps\_hud_util::createFontString( "default", 1.5 );
	hudelem.location = 0;
	hudelem.alignX = "left";
	hudelem.alignY = "top";
	hudelem.foreground = 1;
	hudelem.sort = 20;

	hudelem.alpha = 0;
	hudelem fadeOverTime( 0.5 );
	hudelem.alpha = 1;
	hudelem.x = 0;									// 40
	hudelem.y = 300 + index * 18;						// 260
	hudelem.label = "<" + name + "> " + msg;
	hudelem.color = (1,1,0);

	wait( 2 );
	const timer = 2 * 20;
	hudelem fadeOverTime( 5 );
	hudelem.alpha = 0;

	for ( i=0; i<timer; i++ )
	{
		hudelem.color = ( 1, 1, 1 / ( timer - i ) );
		wait( 0.05 );
	}

	wait( 4 );

	hudelem destroy();

	level.dialog_huds[ index ] = undefined;	
}

