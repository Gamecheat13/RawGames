main()
{
	level._effect[ "chem_grenade" ]										 = loadfx( "smoke/smoke_chem_grenade" );
	level._effect[ "chem_rpg" ]										 = loadfx( "smoke/smoke_chem_rpg" );
	if ( !getdvarint( "r_reflectionProbeGenerate" ) )
		maps\createfx\so_nyse_ny_manhattan_fx::main();
}
