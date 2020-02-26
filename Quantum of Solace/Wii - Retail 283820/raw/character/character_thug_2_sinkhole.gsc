
main()
{
	self setModel("sinkhole_thug_body");
	self attach("sinkhole_thug_head", "", false);
	self.hatModel = "sinkhole_helmet";
	self attach(self.hatModel);
	self.voice = "american";
}

precache()
{
	precacheModel("sinkhole_thug_body");
	precacheModel("sinkhole_thug_head");
	precacheModel("sinkhole_helmet");
}
