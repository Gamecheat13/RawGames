/*
 * Feature Civilians
 *
 * Implementation: Sumeet Jakatdar
 *	
 * 
*/

#include common_scripts\utility;
#include animscripts\Utility;
#include maps\_anim;

// --------------------------------------------------------------------------------
// ---- Animation setup functions ----
// --------------------------------------------------------------------------------
#using_animtree( "generic_human" );
setup_civilian_override_animations()
{
	// run cycles for scared civilian
	level.civilian["stand"]["scared_run"] = array( 
												  %civilian_run_hunched_A,
												  %civilian_run_hunched_B,
												  %civilian_run_hunched_C,
												  %civilian_run_upright	
												 );
}


// --------------------------------------------------------------------------------
// ---- Scripted idle and react animations before civilians runs around ----
// --------------------------------------------------------------------------------

/@
"Name: civilian_ai_idle_and_react( <guy>, <idle_anim>, <reaction_anim> )"
"Summary: This starts civilian AI in an idle animation defined by <idle_anim> and then plays the reaction animation defined by <reaction_anim> when appropriate."
"Module: civilian"
"CallOn: reference node or ent"
"MandatoryArg: <self>: the node or reference entity or self to play the animation off of" 
"MandatoryArg: <guy> : the actor doing the animation"
"MandatoryArg: <idle_anim> : the idle animation to play (setup so anim_generic can use)"
"MandatoryArg: <reaction_anim> : the reaction animation to play (setup so anim_generic can use)"
"MandatoryArg: <react_flag> : when this flag is set, AI will react, can be a notify too."
"Example: node civilian_ai_idle_and_react( self, "smoke_idle", "smoke_react" );"
"SPMP: singleplayer"
@/	
civilian_ai_idle_and_react( guy, idle_anim, reaction_anim, tag, react_flag )
{
	ender = react_flag;
	
	if( !guy is_civilian() )
		Assert( "civilian_ai_idle_and_react function should only be called on civilian AI" );
	
	self thread maps\_anim::anim_generic_loop( guy, idle_anim, ender );
	self civilian_ai_set_custom_animation_reaction( self, reaction_anim, tag, ender );
}

civilian_ai_set_custom_animation_reaction( node, animation, tag, ender )
{
	self endon("death");

	// waittill the idle animation ender is fired, and then start the react animation
	self waittill( ender );
	
	self civilian_animation_react( node, animation, tag );	
}


civilian_animation_react( node, animation, tag )
{
	self endon( "death" );
	self endon( "pain_death" );

	// Play the reaction
	if ( IsDefined( tag ) )
	{
		node anim_generic_aligned( self, animation, tag );
	}
	else
	{
		node anim_generic_custom_animmode( self, "gravity", animation );
	}
}