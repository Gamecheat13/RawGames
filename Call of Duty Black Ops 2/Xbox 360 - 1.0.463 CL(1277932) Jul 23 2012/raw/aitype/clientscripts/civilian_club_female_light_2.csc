// THIS FILE IS AUTOGENERATED, DO NOT MODIFY

main()
{
	switch(self GetCharacterIndex())
	{
		case 0:
			character\clientscripts\c_mul_civ_club_female_light2::main();
			break;
		case 1:
			character\clientscripts\c_mul_civ_club_female_light3::main();
			break;
	}

	self._aitype = "Civilian_Club_Female_Light_2";
}

precache(ai_index)
{
	character\clientscripts\c_mul_civ_club_female_light2::precache();
	character\clientscripts\c_mul_civ_club_female_light3::precache();

	UseFootstepTable(ai_index, "fly_step_civf");

	SetDemoLockOnValues( ai_index, 100, 8, 0, 60, 8, 0, 60 );
}