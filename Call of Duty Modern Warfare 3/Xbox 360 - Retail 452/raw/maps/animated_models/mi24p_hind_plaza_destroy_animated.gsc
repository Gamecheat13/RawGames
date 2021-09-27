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
        
    model = "vehicle_mi24p_hind_plaza_body_destroy_animated";
    if ( SP )
    {
        level.anim_prop_models[ model ][ "self.wind" ] = %mi24p_hind_plaza_destroy_animated;
    }
    else
        level.anim_prop_models[ model ][ "self.wind" ] = "mi24p_hind_plaza_destroy_animated";
}
    