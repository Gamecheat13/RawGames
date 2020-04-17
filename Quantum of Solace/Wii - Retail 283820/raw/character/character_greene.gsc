
main()
{
	self setModel("greene_body");
	self attach("greene_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("greene_body");
	precacheModel("greene_head");
}
