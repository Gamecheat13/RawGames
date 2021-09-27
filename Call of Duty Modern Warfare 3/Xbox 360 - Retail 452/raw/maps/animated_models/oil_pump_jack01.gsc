#include common_scripts\utility;

#using_animtree( "animated_props" );
main()
{
	if( !isdefined ( level.anim_prop_models ) )
		level.anim_prop_models = [];
		
	// Uses .animation
	model = "oil_pump_jack01";

	if ( isSP() )
	{
		level.anim_prop_models[ model ][ "operate" ] = %oilpump_pump01;
	}
	else
		level.anim_prop_models[ model ][ "operate" ] = "oilpump_pump01";
}