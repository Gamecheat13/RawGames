main()
{
	precacheFX();
	
	level.scr_sound["flak88_explode"]	= "flak88_explode";
}

precacheFX()
{
	level._effect["wood"]				= loadfx("explosions/grenadeExp_wood");
	level._effect["dust"]				= loadfx("explosions/grenadeExp_dirt_1");
	level._effect["brick"]				= loadfx("explosions/grenadeExp_concrete_1");
	level._effect["coolaidmanbrick"]	= loadfx("explosions/grenadeExp_concrete_1");
	level._effect["flak_explosion"]		= loadfx("explosions/large_vehicle_explosion");
}
