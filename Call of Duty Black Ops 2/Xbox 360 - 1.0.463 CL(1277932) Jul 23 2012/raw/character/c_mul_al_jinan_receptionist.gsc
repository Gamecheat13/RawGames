// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("c_mul_al_jinan_receptionist_body");
	self.headModel = codescripts\character::randomElement(xmodelalias\c_mul_civ_club_female_head_als::main());
	self attach(self.headModel, "", true);
	self.voice = "american";
	self.skeleton = "base";
}

precache()
{
	precacheModel("c_mul_al_jinan_receptionist_body");
	codescripts\character::precacheModelArray(xmodelalias\c_mul_civ_club_female_head_als::main());
}