// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	character\clientscripts\c_usa_secserv_light::main();
	self._aitype = "So_Ally_Sniper_Base";
}

precache(ai_index)
{
	character\clientscripts\c_usa_secserv_light::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}