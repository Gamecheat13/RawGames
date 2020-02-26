
main()
{
	self setModel("eco_soldier_body");
	self attach("eco_soldier_A_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("eco_soldier_body");
	precacheModel("eco_soldier_A_head");
}
