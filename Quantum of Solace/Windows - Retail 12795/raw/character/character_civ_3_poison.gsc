// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\casino_male_bodies::getnextmodel();
	self setModel( body );
	self attach("casino_male_3_head", "", false);
	self attach("hands_white_1_low_lod", "", false);
	hatModel = xmodelalias\casino_male_3_facial::getnextmodel();
	self.hatModel = hatModel;
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\casino_male_bodies::main());
	precacheModel("casino_male_3_head");
	precacheModel("hands_white_1_low_lod");
	codescripts\character::precacheModelArray(xmodelalias\casino_male_3_facial::main());
}