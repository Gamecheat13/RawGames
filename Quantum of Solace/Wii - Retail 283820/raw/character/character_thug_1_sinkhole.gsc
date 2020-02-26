
main()
{
	self setModel("sinkhole_thug_body");
	self attach("sinkhole_thug_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("sinkhole_thug_body");
	precacheModel("sinkhole_thug_head");
}
