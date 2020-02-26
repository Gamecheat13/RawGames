
main()
{
	self setModel("mr_white_body");
	self attach("mr_white_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("mr_white_body");
	precacheModel("mr_white_head");
}
