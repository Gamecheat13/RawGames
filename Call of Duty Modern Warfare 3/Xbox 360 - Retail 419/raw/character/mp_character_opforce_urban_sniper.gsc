// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_opforce_russian_urban_sniper");
	self attach("head_opforce_russian_urban_sniper", "", true);
	self.headModel = "head_opforce_russian_urban_sniper";
	self setViewmodel("viewhands_russian_a");
	self.voice = "russian";
}

precache()
{
	precacheModel("mp_body_opforce_russian_urban_sniper");
	precacheModel("head_opforce_russian_urban_sniper");
	precacheModel("viewhands_russian_a");
}
