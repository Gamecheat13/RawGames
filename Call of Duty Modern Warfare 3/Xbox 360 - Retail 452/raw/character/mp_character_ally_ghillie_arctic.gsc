// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{
	self setModel("mp_body_ally_ghillie_desert_sniper");
	self attach("head_ally_arctic_sniper", "", true);
	self.headModel = "head_ally_arctic_sniper";
	self setViewmodel("viewhands_iw5_ghillie_arctic");
	self.voice = "delta";
}

precache()
{
	precacheModel("mp_body_ally_ghillie_desert_sniper");
	precacheModel("head_ally_arctic_sniper");
	precacheModel("viewhands_iw5_ghillie_arctic");
}
