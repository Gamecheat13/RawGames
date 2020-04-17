
main()
{
	self setModel("mp_bx_mi6agent_body");
	self attach("mp_bx_mi6agent_head", "", false);
}

precache()
{
	precacheModel("mp_bx_mi6agent_body");
	precacheModel("mp_bx_mi6agent_head");
}
