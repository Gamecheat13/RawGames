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
        
    model = "seatown_canopy_1section_02";
    if ( SP )
    {
        level.anim_prop_models[ model ][ "self.wind" ] = %seatown_canopy_1section_02_sway;
    }
    else
        level.anim_prop_models[ model ][ "self.wind" ] = "seatown_canopy_1section_02_sway";
}
    