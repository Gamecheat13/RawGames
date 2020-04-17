
main()
{
	self setModel("mp_bx_mercenary_body");
	self attach("mp_bx_mercenary_head", "", false);
}

precache()
{
	precacheModel("mp_bx_mercenary_body");
	precacheModel("mp_bx_mercenary_head");
}
