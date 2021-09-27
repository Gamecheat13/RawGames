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
        
    model = "fence_tarp_68x58";
    if ( SP )
    {
        level.anim_prop_models[ model ][ "wind" ] = %fence_tarp_68x58_med_01;
    }
    else
        level.anim_prop_models[ model ][ "wind" ] = "fence_tarp_68x58_med_01";
}
    