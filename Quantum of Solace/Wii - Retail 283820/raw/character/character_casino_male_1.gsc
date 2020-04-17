
main()
{
	codescripts\character::setModelFromArray(xmodelalias\casino_male_bodies::main());
	headArray = xmodelalias\casino_male_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self attach("hands_white_1_low_lod", "", false);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\casino_male_bodies::main());
	codescripts\character::precacheModelArray(xmodelalias\casino_male_heads::main());
	precacheModel("hands_white_1_low_lod");
}
