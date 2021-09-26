main()
{
	precacheFX();
//	spawnWorldFX();
	randomGroundDust();
	
}

precacheFX()
{
	//footstep fx
	animscripts\utility::setFootstepEffect ("mud",			loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("grass",		loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("dirt",			loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("concrete",		loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("rock",			loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("asphalt",		loadfx ("fx/impacts/footstep_dust_brown.efx"));
	animscripts\utility::setFootstepEffect ("plaster",		loadfx ("fx/impacts/footstep_dust_brown.efx"));

	level._effect["dust_wind_brown_thick"]		= loadfx ("fx/dust/dust_wind_brown_thick.efx");
	level._effect["thin_light_smoke_S"]			= loadfx ("fx/smoke/thin_light_smoke_S.efx");
	level._effect["planeshoot"]					= loadfx ("fx/muzzleflashes/mg42hv_far.efx");
 	level._effect["planeenginesmoke"]			= loadfx ("fx/fire/fire_airplane_trail.efx");  
	level._effect["planeexplosion"]				= loadfx ("fx/explosions/matmata_plane_explosion.efx");
	level._effect["boom"] 						= loadfx("fx/explosions/mortarExp_beach.efx");
	level._effect["vehicle_steam"]				= loadfx ("fx/smoke/vehicle_steam.efx");

}

spawnWorldFX()
{

	/*
	//originals DO NOT DELETE
	maps\_fx::loopfx("dust_wind_brown_thick", (2680,5237,-24), 6, (2680,5237,75));
	maps\_fx::loopfx("dust_wind_brown_thick", (3179,5779,-35), 6, (3179,5779,64));
	maps\_fx::loopfx("dust_wind_brown_thick", (4388,5719,28), 6, (4388,5719,127));
	maps\_fx::loopfx("dust_wind_brown_thick", (4310,6481,-21), 6, (4310,6481,78));
	maps\_fx::loopfx("dust_wind_brown_thick", (4262,6958,-53), 6, (4262,6958,46));
	maps\_fx::loopfx("dust_wind_brown_thick", (4130,7484,-42), 6, (4130,7484,57));
	maps\_fx::loopfx("dust_wind_brown_thick", (3676,8177,-34), 6, (3676,8177,64));
	maps\_fx::loopfx("dust_wind_brown_thick", (4887,8341,-34), 6, (4887,8341,64));
	maps\_fx::loopfx("dust_wind_brown_thick", (4916,9095,-21), 6, (4916,9095,77));
	maps\_fx::loopfx("dust_wind_brown_thick", (5692,9073,-25), 6, (5692,9073,73));
	maps\_fx::loopfx("dust_wind_brown_thick", (5728,8419,-102), 6, (5728,8419,-3));
	maps\_fx::loopfx("dust_wind_brown_thick", (5601,6986,-2), 6, (5601,6986,96));
	maps\_fx::loopfx("dust_wind_brown_thick", (5663,7645,-18), 6, (5663,7645,80));
	maps\_fx::loopfx("dust_wind_brown_thick", (5353,6341,-55), 6, (5353,6341,43));
	maps\_fx::loopfx("dust_wind_brown_thick", (5070,5750,-13), 6, (5070,5750,85));
	maps\_fx::loopfx("dust_wind_brown_thick", (4864,5251,6), 6, (4864,5251,105));
	maps\_fx::loopfx("dust_wind_brown_thick", (4861,4743,14), 6, (4861,4743,113));
	maps\_fx::loopfx("dust_wind_brown_thick", (2723,6147,-35), 6, (2723,6147,64));
	maps\_fx::loopfx("dust_wind_brown_thick", (1656,7191,-17), 6, (1656,7191,81));
	maps\_fx::loopfx("dust_wind_brown_thick", (1629,6260,-4), 6, (1629,6260,94));
	maps\_fx::loopfx("dust_wind_brown_thick", (1646,5685,0), 6, (1646,5685,98));
	maps\_fx::loopfx("dust_wind_brown_thick", (6608,6118,-56), 6, (6608,6118,42));
	maps\_fx::loopfx("dust_wind_brown_thick", (4888,4171,-31), 6, (4888,4171,67));
	maps\_fx::loopfx("dust_wind_brown_thick", (5346,3734,3), 6, (5346,3734,101));
	maps\_fx::loopfx("dust_wind_brown_thick", (5721,4058,-31), 6, (5721,4058,66));
	*/
}

randomGroundDust()
{
	index = 0;
	
	//random dust fx originals above
	fxorigin [index] = 	(2680,5237,-24);		fxvector [index] =  (2680,5237,75);	index++;
	fxorigin [index] = 	(3179,5779,-35);		fxvector [index] =  (3179,5779,64);	index++;
	fxorigin [index] = 	(4388,5719,28);			fxvector [index] =  (4388,5719,127);	index++;
	fxorigin [index] = 	(4310,6481,-21);		fxvector [index] =  (4310,6481,78);	index++;
	fxorigin [index] = 	(4262,6958,-53);		fxvector [index] =  (4262,6958,46);	index++;
	fxorigin [index] = 	(4130,7484,-42);		fxvector [index] =  (4130,7484,57);	index++;
	fxorigin [index] = 	(3676,8177,-34);		fxvector [index] =  (3676,8177,64);	index++;
	fxorigin [index] = 	(4887,8341,-34);		fxvector [index] =  (4887,8341,64);	index++;
	fxorigin [index] = 	(4916,9095,-21);		fxvector [index] =  (4916,9095,77);	index++;
	fxorigin [index] = 	(5692,9073,-25);		fxvector [index] =  (5692,9073,73);	index++;
	fxorigin [index] = 	(5728,8419,-102);		fxvector [index] =  (5728,8419,-3);	index++;
	fxorigin [index] = 	(5601,6986,-2);			fxvector [index] =  (5601,6986,96);	index++;
	fxorigin [index] = 	(5663,7645,-18);		fxvector [index] =  (5663,7645,80);	index++;
	fxorigin [index] = 	(5353,6341,-55);		fxvector [index] =  (5353,6341,43);	index++;
	fxorigin [index] = 	(5070,5750,-13);		fxvector [index] =  (5070,5750,85);	index++;
	fxorigin [index] = 	(4864,5251,6);			fxvector [index] =  (4864,5251,105);	index++;
	fxorigin [index] = 	(4861,4743,14);			fxvector [index] =  (4861,4743,113);	index++;
	fxorigin [index] = 	(2723,6147,-35);		fxvector [index] =  (2723,6147,64);	index++;
	fxorigin [index] = 	(1656,7191,-17);		fxvector [index] =  (1656,7191,81);	index++;
	fxorigin [index] = 	(1629,6260,-4);			fxvector [index] =  (1629,6260,94);	index++;
	fxorigin [index] = 	(1646,5685,0);			fxvector [index] =  (1646,5685,98);	index++;
	fxorigin [index] = 	(6608,6118,-56);		fxvector [index] =  (6608,6118,42);	index++;
	fxorigin [index] = 	(4888,4171,-31);		fxvector [index] =  (4888,4171,67);	index++;
	fxorigin [index] = 	(5346,3734,3);			fxvector [index] =  (5346,3734,101);	index++;
	fxorigin [index] = 	(5721,4058,-31);		fxvector [index] =  (5721,4058,66);	index++;

	for (i = 0; i < fxorigin.size; i++)
	{
		maps\_fx::gunfireloopfxVec ("dust_wind_brown_thick", fxorigin [i], fxvector [i],	// Origin
							3, 5,					// Number of shots
							2, 4,					// seconds between shots
							3, 4);					// seconds between sets of shots.
	}	
}
