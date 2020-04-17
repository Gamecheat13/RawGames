
main()
{
	self setModel("eco_soldier_body_2");
	self attach("eco_soldier_B_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("eco_soldier_body_2");
	precacheModel("eco_soldier_B_head");
}
