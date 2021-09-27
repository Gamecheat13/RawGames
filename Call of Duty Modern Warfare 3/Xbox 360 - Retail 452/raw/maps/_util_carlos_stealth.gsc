#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_hud_util;
#include maps\_utility_code;

stop_anim_interrupt( guy )
{
	guy notify( "end_reaction" );
	guy maps\_stealth_utility::disable_stealth_for_ai();
}

waittill_no_suspicious_enemies()
{
	wait( 0.5 );
	while( 1 )
	{
		if ( enemies_are_unaware() )
			break;
		wait( 0.2 );
	}
	if ( flag_exist( "_stealth_spotted" ) )
		flag_waitopen( "_stealth_spotted" );
}

enemies_are_unaware()
{
	ai = GetAIArray( "axis" );
	foreach ( a in ai )
	{
		if ( a ent_flag_exist( "_stealth_enabled" ) && a ent_flag( "_stealth_enabled" ) )
		{
			if (
				a ent_flag( "_stealth_bad_event_listener" ) || 
				a ent_flag( "_stealth_behavior_reaction_anim" ) ||
				a ent_flag( "_stealth_enemy_alert_level_action" ) ||
				a ent_flag( "_stealth_behavior_reaction_anim_in_progress" )
			 	)
			 return false;
		}
	}
	if ( isdefined( level._stealth ) )
	{
		return maps\_stealth_utility::stealth_is_everything_normal();
	}
	else
	return true;
}