// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_afg_mullah_omar_cin::main();
	self._aitype = "Hero_Rebel_Leader_Afghan";
}

precache(ai_index)
{
	character\clientscripts\c_afg_mullah_omar_cin::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}