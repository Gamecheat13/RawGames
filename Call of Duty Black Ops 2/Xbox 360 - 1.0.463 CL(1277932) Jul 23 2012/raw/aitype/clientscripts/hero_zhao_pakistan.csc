// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_chn_afghan_zhao_cin::main();
	self._aitype = "Hero_Zhao_Pakistan";
}

precache(ai_index)
{
	character\clientscripts\c_chn_afghan_zhao_cin::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}