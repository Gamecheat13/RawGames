
main()
{
	self setModel("elite_body");
	self attach("elite_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("elite_body");
	precacheModel("elite_head");
}
