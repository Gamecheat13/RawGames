
main()
{
	self setModel("bond_sinkhole_body");
	self attach("bond_sinkhole_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_sinkhole_body");
	precacheModel("bond_sinkhole_head");
}