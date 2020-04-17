
main()
{
	self setModel("mp_bx_scout_body");
	self attach("mp_bx_scout_head", "", false);
}

precache()
{
	precacheModel("mp_bx_scout_body");
	precacheModel("mp_bx_scout_head");
}
