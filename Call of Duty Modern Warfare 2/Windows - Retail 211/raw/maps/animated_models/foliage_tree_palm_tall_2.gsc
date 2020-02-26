#include common_scripts\utility;

#using_animtree( "animated_props" );
main()
{
	if( !isdefined ( level.anim_prop_models ) )
		level.anim_prop_models = [];
		
	// Would use isSP() but this runs before we can
	mapname = tolower( getdvar( "mapname" ) );
	SP = true;
	if ( string_starts_with( mapname, "mp_" ) )
		SP = false;
		
	model = "foliage_tree_palm_tall_2";
	if ( SP )
	{
		level.anim_prop_models[ model ][ "still" ] = %palmtree_tall2_still;
		level.anim_prop_models[ model ][ "strong" ] = %palmtree_tall2_sway;
	}
	else
		level.anim_prop_models[ model ][ "strong" ] = "palmtree_mp_tall2_sway";
}
