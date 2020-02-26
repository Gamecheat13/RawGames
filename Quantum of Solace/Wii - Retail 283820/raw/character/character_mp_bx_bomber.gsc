
main()
{
	self setModel("mp_bx_bomber_body");
	self attach("mp_bx_bomber_head", "", false);
}

precache()
{
	precacheModel("mp_bx_bomber_body");
	precacheModel("mp_bx_bomber_head");
}
