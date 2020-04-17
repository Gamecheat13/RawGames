
main()
{
	self setModel("mitchell_body");
	self attach("mitchell_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("mitchell_body");
	precacheModel("mitchell_head");
}
