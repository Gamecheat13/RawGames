
main()
{
	self setModel("bliss_body");
	self attach("bliss_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bliss_body");
	precacheModel("bliss_head");
}
