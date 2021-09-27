
/*QUAKED script_vehicle_littlebird_player (1 0 0) (-16 -16 -24) (16 16 32) USABLE SPAWNER

valid ai groups are:
"first_guys" - left and right side guys that need to be on first
"left" - all left guys
"right" - all right guys
"passengers" - everybody that can unload
"default"

This will be added to your precache script when compile with Repackage Zone/Script:

vehicle_scripts\_littlebird_player::main( "vehicle_little_bird_bench", undefined, "script_vehicle_littlebird_player" );

These will be added to your levels CSV when compile with Repackage Zone/Script:

include,vehicle_littlebird_bench
sound,vehicle_littlebird,vehicle_standard,all_sp

defaultmdl="vehicle_little_bird_bench"
default:"vehicletype" "littlebird_player"
default:"script_team" "allies"
*/

main( model, type, classname )
{
	vehicle_scripts\_littlebird::main( model, "littlebird_player", classname );
}