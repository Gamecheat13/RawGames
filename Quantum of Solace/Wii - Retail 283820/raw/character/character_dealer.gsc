
main()
{
	self setModel("dealer_body");
	self attach("dealer_head", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("dealer_body");
	precacheModel("dealer_head");
	precacheModel("hands_white_1");
}
