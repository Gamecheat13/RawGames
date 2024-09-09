#include common_scripts\_destructible;
#using_animtree( "destructibles" );

toy_oxygen_tank( version )
{
	//---------------------------------------------------------------------
	// Oxygen Tanks 01 and 02
	//---------------------------------------------------------------------
	destructible_create( "toy_oxygen_tank_" + version, "tag_origin", 150, undefined, 32, "no_melee" );
				destructible_healthdrain( 12, 0.2, 64, "allies" );
				destructible_loopsound( "oxygen_tank_leak_loop" );
				destructible_fx( "tag_cap", "fx/props/oxygen_tank" + version + "_cap" );
				destructible_loopfx( "tag_cap", "fx/distortion/oxygen_tank_leak", 0.4 );
			destructible_state( undefined, "machinery_oxygen_tank" + version + "_dam", 300, undefined, 32, "no_melee" );
				destructible_fx( "tag_fx", "fx/explosions/oxygen_tank" + version + "_explosion", false );
				destructible_sound( "oxygen_tank_explode" );
				destructible_explode( 7000, 8000, 150, 256, 16, 150, undefined, 32 );
				destructible_state( undefined, "machinery_oxygen_tank" + version + "_des", undefined, undefined, "no_melee" );
}