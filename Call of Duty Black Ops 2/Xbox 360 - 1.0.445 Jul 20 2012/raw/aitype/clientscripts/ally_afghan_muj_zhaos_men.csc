// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_chn_afghan_zhaosmen_1::main();
			break;
		case 1:
			character\clientscripts\c_chn_afghan_zhaosmen_2::main();
			break;
		case 2:
			character\clientscripts\c_chn_afghan_zhaosmen_3::main();
			break;
	}

	self._aitype = "Ally_Afghan_Muj_Zhaos_men";
}

precache(ai_index)
{
	character\clientscripts\c_chn_afghan_zhaosmen_1::precache();
	character\clientscripts\c_chn_afghan_zhaosmen_2::precache();
	character\clientscripts\c_chn_afghan_zhaosmen_3::precache();

	UseFootstepTable(ai_index, "default_ai");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}