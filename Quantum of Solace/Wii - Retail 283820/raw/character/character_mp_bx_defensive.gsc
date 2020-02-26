
main()
{
	self setModel("mp_bx_defensive_body");
	self attach("mp_bx_defensive_head", "", false);
}

precache()
{
	precacheModel("mp_bx_defensive_body");
	precacheModel("mp_bx_defensive_head");
}
