#include maps\_utility;

main()
{
	precacheFX();
	spawnWorldFX();
	maps\createfx\interior_concept_fx::main();
}


precacheFX()
{
	level._effect["paper_falling_burning"]				= loadfx ("misc/paper_falling_burning");
	level._effect["battlefield_smokebank_S"]			= loadfx ("smoke/battlefield_smokebank_S");
	level._effect["ic_grnd_smoke"]						= loadfx ("smoke/ic_grnd_smoke");

}

spawnWorldFX()
{	 

}	
