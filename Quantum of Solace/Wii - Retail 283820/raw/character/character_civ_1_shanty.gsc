
main()
{
	codescripts\character::setModelFromArray(xmodelalias\shanty_thug_bodies_B1_A1a::main());
	self attach("head_m_b_01", "", false);
	self.hatModel = codescripts\character::randomElement(xmodelalias\shanty_thug_hats_m_b_01::main());
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\shanty_thug_bodies_B1_A1a::main());
	precacheModel("head_m_b_01");
	codescripts\character::precacheModelArray(xmodelalias\shanty_thug_hats_m_b_01::main());
}
