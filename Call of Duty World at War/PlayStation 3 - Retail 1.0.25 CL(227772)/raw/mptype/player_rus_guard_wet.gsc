// THIS FILE IS AUTOGENERATED, DO NOT MODIFY
main()
{

	switch( codescripts\character::get_random_character(4) )
	{
	case 0:
		character\char_rus_wet_player1::main();
		break;
	case 1:
		character\char_rus_wet_player2::main();
		break;
	case 2:
		character\char_rus_wet_player3::main();
		break;
	case 3:
		character\char_rus_wet_player4::main();
		break;
	}
}

precache()
{
	character\char_rus_wet_player1::precache();
	character\char_rus_wet_player2::precache();
	character\char_rus_wet_player3::precache();
	character\char_rus_wet_player4::precache();
}
