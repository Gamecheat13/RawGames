#include common_scripts\utility;

#using_animtree( "animated_props" );
main()
{
	if( !isdefined ( level.anim_prop_models ) )
		level.anim_prop_models = [];
	
	if ( !isdefined( level.anim_prop_init_threads ) )
		level.anim_prop_init_threads = [];
	
	// Would use isSP() but this runs before we can
	mapname = tolower( getdvar( "mapname" ) );
	SP = true;
	if ( string_starts_with( mapname, "mp_" ) )
		SP = false;
		
	model = "foliage_paris_tree_plane_medium_animated";
	if ( SP )
	{
		level.anim_prop_init_threads[ model ] = ::local_init;
		
		level.anim_prop_models[ model ][ "idle" ] = %paris_tree_plane_medium_idle;
		level.anim_prop_models[ model ][ "windy_idle" ] = %paris_tree_plane_medium_windy_idle;
	}
	else
		level.anim_prop_models[ model ][ "idle" ] = "paris_tree_plane_medium_idle";
}

local_init()
{
	self UseAnimTree( #animtree );
	animation = level.anim_prop_models[ self.model ][ "idle" ];
	
	self SetAnim( animation, 1, 0.2, 1 );
	self SetAnimTime( animation, RandomFloatRange( 0, 1 ) );
}
