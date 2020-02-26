
main()
{
	self setModel("kratt_body");
	self attach("kratt_head", "", false);
	self attach("hands_white_1", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("kratt_body");
	precacheModel("kratt_head");
	precacheModel("hands_white_1");
}
