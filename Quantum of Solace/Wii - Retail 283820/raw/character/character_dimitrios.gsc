
main()
{
	self setModel("dimitrios_body");
	self attach("dimitrios_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("dimitrios_body");
	precacheModel("dimitrios_head");
}
