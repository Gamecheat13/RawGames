
main()
{
	self setModel("carter_body");
	self attach("carter_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("carter_body");
	precacheModel("carter_head");
}
