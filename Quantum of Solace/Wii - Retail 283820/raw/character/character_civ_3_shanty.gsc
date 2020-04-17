
main()
{
	codescripts\character::setModelFromArray(xmodelalias\shanty_thug_bodies_B1_A1b::main());
	self attach("head_m_b_04", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\shanty_thug_bodies_B1_A1b::main());
	precacheModel("head_m_b_04");
}
