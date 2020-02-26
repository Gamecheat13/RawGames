
main()
{
	self setModel("eco_soldier_body_3");
	self attach("eco_soldier_C_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("eco_soldier_body_3");
	precacheModel("eco_soldier_C_head");
}
