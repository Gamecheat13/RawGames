
main()
{
	self setModel("mp_bx_sharpshooter_body");
	self attach("mp_bx_sharpshooter_head", "", false);
}

precache()
{
	precacheModel("mp_bx_sharpshooter_body");
	precacheModel("mp_bx_sharpshooter_head");
}
