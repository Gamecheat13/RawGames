#include maps\_props;

#using_animtree( "generic_human" );
main()
{
	add_smoking_notetracks( "generic" );
	level.scr_anim[ "generic" ][ "smoke_balcony_idle" ][ 0 ]				 = %oilrig_balcony_smoke_idle;
	level.scr_anim[ "generic" ][ "smoke_balcony_react" ]					 = %patrol_bored_react_look_advance;
	level.scr_anim[ "generic" ][ "smoke_balcony_death" ]					 = %oilrig_balcony_death;
}