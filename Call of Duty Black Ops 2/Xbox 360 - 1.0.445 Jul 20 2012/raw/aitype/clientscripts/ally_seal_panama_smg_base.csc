// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_usa_seal80s_heavy::main();
			break;
		case 1:
			character\clientscripts\c_usa_seal80s_medium::main();
			break;
		case 2:
			character\clientscripts\c_usa_seal80s_light::main();
			break;
	}

	self._aitype = "Ally_SEAL_Panama_SMG_Base";
}

precache(ai_index)
{
	character\clientscripts\c_usa_seal80s_heavy::precache();
	character\clientscripts\c_usa_seal80s_medium::precache();
	character\clientscripts\c_usa_seal80s_light::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}