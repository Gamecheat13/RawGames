main()
{
	precacheFX();
	
	level.scr_sound["flak88_explode"]	= "flak88_explode";
}

precacheFX()
{
	
	level._effect["flak_explosion"]		= loadfx("explosions/large_vehicle_explosion");
}