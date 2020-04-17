
main()
{
	self setModel("mp_bx_bond_body");
	self attach("mp_bx_bond_head", "", false);
}

precache()
{
	precacheModel("mp_bx_bond_body");
	precacheModel("mp_bx_bond_head");
}
