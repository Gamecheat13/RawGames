// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_usa_secserv_heavy::main();
			break;
		case 1:
			character\clientscripts\c_usa_secserv_medium::main();
			break;
	}

	self._aitype = "Ally_SEAL_Pakistan_Assault_Base";
}

precache(ai_index)
{
	character\clientscripts\c_usa_secserv_heavy::precache();
	character\clientscripts\c_usa_secserv_medium::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}