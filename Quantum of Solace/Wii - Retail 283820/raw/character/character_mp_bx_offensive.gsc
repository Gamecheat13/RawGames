
main()
{
	self setModel("mp_bx_offensive_body");
	self attach("mp_bx_offensive_head", "", false);
}

precache()
{
	precacheModel("mp_bx_offensive_body");
	precacheModel("mp_bx_offensive_head");
}
