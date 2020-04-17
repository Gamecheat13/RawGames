
main()
{
	codescripts\character::setModelFromArray(xmodelalias\obanno_henchman_bodies::main());
	headArray = xmodelalias\obanno_henchman_2_heads::main();
	headIdx = codescripts\character::attachFromArray(headArray);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\obanno_henchman_bodies::main());
	codescripts\character::precacheModelArray(xmodelalias\obanno_henchman_2_heads::main());
}
