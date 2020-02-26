
main()
{
	self setModel("bond_whiteestate_body");
	self attach("bond_whiteestate_head", "", false);
	self.voice = "american";
}

precache()
{
	precacheModel("bond_whiteestate_body");
	precacheModel("bond_whiteestate_head");
}
