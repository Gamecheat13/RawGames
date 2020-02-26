//
// file: mp_array_amb.gsc
// description: level ambience script for mp_array
// scripter: 
//

#include maps\mp\_utility;
#include maps\mp\_ambientpackage;


main()
{
	level thread power_buzz();	
	//level thread satellite_data_1();	
	//level thread satellite_data_2();	
	//level thread satellite_data_3();	
	level thread satellite_streams();	
}

power_buzz()
{
	level endon ("kill_buzz");
	level.pbuzz = spawn ("script_origin", (172, -1242.5, 740.5));
	for(;;)
	{
		level.pbuzz playsound("amb_hum_c");
		wait randomfloatrange (0.9, 1.6);
	}		
}

satellite_data_1()
{
	level endon ("kill_data_stream");
	level.data_1 = getent ("satellite_dish_1", "targetname");
	if (isdefined(level.data_1))
	{
		for(;;)
		{
			level.data_1 playsound("amb_satellite_data_1");
			wait randomfloatrange (0.2, 0.8);
		}	
	}		
}

satellite_data_2()
{
	level endon ("kill_data_stream");
	level.data_2 = getent ("satellite_dish_2", "targetname");
	if (isdefined(level.data_2))
	{
		for(;;)
		{
			level.data_2 playsound("amb_satellite_data_2");
			wait randomfloatrange (0.2, 0.8);
		}	
	}	
}

satellite_data_3()
{
	level endon ("kill_data_stream");
	level.data_3 = getent ("satellite_dish_3", "targetname");
	if (isdefined(level.data_3))
	{
		for(;;)
		{
			level.data_3 playsound("amb_satellite_data_3");
			wait randomfloatrange (0.2, 0.8);
		}
	}		
}

satellite_streams()
{
	level endon ("kill_satellites");
	for(;;)
	{
		level.satnum = randomintrange(1,4);
		
		switch (level.satnum)
		{
			case 1:
				level thread satellite_data_1();	
				break;

			case 2:
				level thread satellite_data_2();	
				break;
				
			case 3:
				level thread satellite_data_3();	
				break;
		}
		
		wait (randomintrange(35, 140));
		level notify("kill_data_stream");
		
		wait (randomintrange (1, 15));
	}		


}