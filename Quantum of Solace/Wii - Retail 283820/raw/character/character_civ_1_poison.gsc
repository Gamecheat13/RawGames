
main()
{
	codescripts\character::setModelFromArray(xmodelalias\casino_male_bodies::main());
	self attach("casino_male_1_head", "", false);
	self attach("hands_white_1_low_lod", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\casino_male_bodies::main());
	precacheModel("casino_male_1_head");
	precacheModel("hands_white_1_low_lod");
}
