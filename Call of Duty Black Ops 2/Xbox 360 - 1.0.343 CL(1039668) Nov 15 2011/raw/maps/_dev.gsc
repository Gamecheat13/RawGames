#include common_scripts\utility;
#include maps\_utility;

/#
init()
{
	thread equipment_dev_gui();
	thread perk_dev_gui();
}

equipment_dev_gui()
{
	equipment = [];

	//array starts at '1' because I need the first element to empty as GetDvarInt() returns zero if it's undefined.
	equipment[1] = "satchel_charge_sp";

	//Init my dvar
	SetDvar("scr_give_equipment", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every .5 seconds in the form of an int
		devgui_int = GetDvarint( "scr_give_equipment");

		//"" returns as zero with GetDvarInt
		if(devgui_int != 0)
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				players[i] TakeWeapon( equipment[devgui_int] );
				players[i] GiveWeapon( equipment[devgui_int] );
				players[i] SetActionSlot( 1, "weapon", equipment[devgui_int] );
			}
			SetDvar("scr_give_equipment", "0");
		}
	}
}

perk_dev_gui()
{
	//Init my dvar
	SetDvar("scr_give_perk", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every .5 seconds in the form of an int

		//"" returns as zero with GetDvarInt
		if(GetDvar( "scr_giveperk" ) != "")
		{
			players = get_players();
			for( i = 0; i < players.size; i++ )
			{
				players[i] setPerk( GetDvar( "scr_giveperk" ) );
			}
			SetDvar("scr_giveperk", "");
		}
	}
}
#/
