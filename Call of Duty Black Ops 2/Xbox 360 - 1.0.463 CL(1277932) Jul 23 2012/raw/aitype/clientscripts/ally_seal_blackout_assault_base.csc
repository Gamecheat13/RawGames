// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_usa_future_seal_1::main();
	self._aitype = "Ally_SEAL_Blackout_Assault_Base";
}

precache(ai_index)
{
	character\clientscripts\c_usa_future_seal_1::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}