// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	body = xmodelalias\mi6_agent_bodies::getnextmodel();
	self setModel( body );
	self attach("body_guard_2_head", "", false);
	hatModel = xmodelalias\body_guard_2_facial_alias::getnextmodel();
	self.hatModel = hatModel;
	self attach(self.hatModel, "", true);
	self.voice = "american";
}

precache()
{
	codescripts\character::precacheModelArray(xmodelalias\mi6_agent_bodies::main());
	precacheModel("body_guard_2_head");
	codescripts\character::precacheModelArray(xmodelalias\body_guard_2_facial_alias::main());
}