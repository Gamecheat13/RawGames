
main()
{
	self setModel("mp_bx_henchmen_body");
	self attach("mp_bx_henchmen_head", "", false);
}

precache()
{
	precacheModel("mp_bx_henchmen_body");
	precacheModel("mp_bx_henchmen_head");
}
