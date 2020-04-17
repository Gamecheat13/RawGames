
main()
{
	self setModel("lechiffre_tux_body");
	self attach("lechiffre_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("lechiffre_tux_body");
	precacheModel("lechiffre_head");
}
