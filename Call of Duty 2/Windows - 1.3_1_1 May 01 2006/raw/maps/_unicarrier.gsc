#include maps\_utility;
#include maps\_cars;
#using_animtree ("vehicles");

main (model)
{
	type = "unicarrier";
	switch(model)	
	{
		case "xmodel/vehicle_uni_carrier_yw":
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_uni_carrier_yw");
			precachemodel("xmodel/vehicle_uni_carrier_ye_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_uni_carrier_ye_destroyed";
//			level.deathmodel[model] = "xmodel/vehicle_uni_carrier_yw";
			break;
		case "xmodel/vehicle_uni_carrier_gr_mud":
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_uni_carrier_gr_mud");
			precachemodel("xmodel/vehicle_uni_carrier_gr_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_uni_carrier_gr_destroyed";
			break;
		case "xmodel/vehicle_uni_carrier_yw_dirt":
			precacheturret("xmodel/vehicle_uni_carrier_yw_dirt");
			precachemodel("xmodel/vehicle_uni_carrier_yw_dirt");
			precachemodel("xmodel/vehicle_uni_carrier_ye_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_uni_carrier_ye_destroyed";
			break;
		case "xmodel/vehicle_uni_carrier_gr":
			precacheturret("mg42_bipod_stand");
			precachemodel("xmodel/vehicle_uni_carrier_gr");
			precachemodel("xmodel/vehicle_uni_carrier_gr_destroyed");
			level.deathmodel[model] = "xmodel/vehicle_uni_carrier_gr_destroyed";
			break;
			
	}
	
	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %british_universal_carrier_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 7;
	
	level.deathfx[model] = loadfx("fx/explosions/large_vehicle_explosion.efx");
	level._effect["death explosion"+model] = loadfx("fx/explosions/large_vehicle_explosion.efx");
	level.vehicleInitThread[type][model] = ::init;
	maps\_treadfx::main(type);
}


#using_animtree ("generic_human");

init ()
{
	life();
	thread kill();
	thread maps\_treads::main();
	thread runtovehicle_handle();

	positions[0]["getout"] = %bren_carrier_driver_dismount;
	positions[1]["getout"] = %bren_carrier_passenger_dismount;
	positions[2]["getout"] = %bren_carrier_back01_combatdismount;
	positions[3]["getout"] = %bren_carrier_back02_ridedismount;
	positions[4]["getout"] = %halftrack_guy03_jumpout;
	positions[5]["getout"] = %halftrack_guy02_jumpout;
	positions[6]["getout"] = %halftrack_guy05_jumpout;
	positions[7]["getout"] = %halftrack_guy02_jumpout;
	positions[8]["getout"] = %halftrack_guy02_jumpout;
	
	positions[0]["getout_combat"] = %bren_carrier_driver_dismount;
	positions[1]["getout_combat"] = %bren_carrier_passenger_dismount;
	positions[2]["getout_combat"] = %bren_carrier_back01_combatdismount;
	positions[3]["getout_combat"] = %bren_carrier_back02_combatdismount;
	

	positions[0]["idle"][0] = %bren_carrier_driver_driveidle;
	positions[0]["idleoccurrence"][0] = 500;
	positions[0]["idle"][1] = %bren_carrier_driver_drivelook;
	positions[0]["idleoccurrence"][1] = 500;
	positions[0]["idle"][2] = %bren_carrier_driver_driveshift;
	positions[0]["idleoccurrence"][2] = 500;

	positions[1]["idle"][0] = %bren_carrier_passenger_rideidle;
	positions[1]["idleoccurrence"][0] = 500;
	positions[1]["idle"][1] = %bren_carrier_passenger_ridelook;
	positions[1]["idleoccurrence"][1] = 500;
	positions[2]["idle"][0] = %bren_carrier_back01_rideidle;
	positions[2]["idleoccurrence"][0] = 500;
	positions[2]["idle"][1] = %bren_carrier_back01_ridelook;
	positions[2]["idleoccurrence"][1] = 800;
	
	positions[3]["idle"][0] = %bren_carrier_back02_rideidle;
	positions[3]["idleoccurrence"][0] = 500;
	positions[3]["idle"][1] = %bren_carrier_back02_ridelook;
	positions[3]["idleoccurrence"][1] = 500;

	positions[4]["idle"] = %halftrack_passenger_idle;
	positions[5]["idle"] = %halftrack_passenger_idle;
	positions[6]["idle"] = %halftrack_passenger_idle;
	positions[7]["idle"] = %halftrack_passenger_idle;
	positions[8]["idle"] = %halftrack_passenger_idle;
	
	positions[1]["standup"] = %bren_carrier_passenger_ride2combat;
	positions[1]["standidle"] = %bren_carrier_passenger_combatidle;
	positions[1]["standattack"] = %bren_carrier_passenger_combatfire;
//	positions[1]["fakefire"] = true;

	positions[2]["standup"] = %bren_carrier_back01_ride2combat;
	positions[2]["standidle"] = %bren_carrier_back01_combatidle;
	positions[2]["standattack"] = %bren_carrier_back01_combatfire;
	positions[2]["fakefire"] = true;

	positions[3]["standup"] = %bren_carrier_back02_ride2combat;
	positions[3]["standidle"] = %bren_carrier_back02_combatidle;
	positions[3]["standattack"] = %bren_carrier_back02_combatfire;
//	positions[3]["fakefire"] = true;

//	positions[0]["death"] = %wagon_driver_death;
//	positions[1]["death"] = %wagon_driver_death;
//	positions[2]["death"] = %death_stand_dropinplace;
//	positions[3]["death"] = %death_stand_dropinplace;
//	positions[4]["death"] = %death_stand_dropinplace;
//	positions[5]["death"] = %death_stand_dropinplace;
//	positions[6]["death"] = %death_stand_dropinplace;
//	positions[7]["death"] = %death_stand_dropinplace;
//	positions[8]["death"] = %death_stand_dropinplace;

	positions[0]["sittag"] = "tag_driver";
	positions[1]["sittag"] = "tag_passenger";
	positions[2]["sittag"] = "tag_guy10";
	positions[3]["sittag"] = "tag_guy2";
	positions[4]["sittag"] = "tag_guy5";
	positions[5]["sittag"] = "tag_guy6";
	positions[6]["sittag"] = "tag_guy7";
	positions[7]["sittag"] = "tag_guy8";
	positions[8]["sittag"] = "tag_guy9";

	positions[8]["delay"] = 0;
	positions[7]["delay"] = 0; 
	positions[5]["delay"] = 0; 
	positions[3]["delay"] = 0;
	positions[4]["delay"] = 0;
	positions[2]["delay"] = 0;	
	positions[6]["delay"] = 0;
	positions[1]["delay"] = 0;
	positions[0]["delay"] = 0;
	thread handle_attached_guys(positions.size,positions);
}
