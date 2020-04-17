
main()
{
	self setModel("mp_bx_mastermind_body");
	self attach("mp_bx_mastermind_head", "", false);
}

precache()
{
	precacheModel("mp_bx_mastermind_body");
	precacheModel("mp_bx_mastermind_head");
}
