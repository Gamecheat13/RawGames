main()
{
	level._effect[ "wood" ]				 = loadfx( "explosions/grenadeExp_wood" );
	level._effect[ "dust" ]				 = loadfx( "explosions/grenadeExp_dirt_1" );
	level._effect[ "brick" ]			 = loadfx( "explosions/grenadeExp_concrete_1" );

	ambientFX();
	maps\createfx\mp_showdown_fx::main();
}

ambientFX()
{

}