// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_yem_houthis_light::main();
			break;
		case 1:
			character\clientscripts\c_yem_houthis_medium::main();
			break;
	}

	self._aitype = "Enemy_Terrorist_Yemen_SMG_Base";
}

precache(ai_index)
{
	character\clientscripts\c_yem_houthis_light::precache();
	character\clientscripts\c_yem_houthis_medium::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}