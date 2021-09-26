#include maps\_cars;
#include maps\_utility;
#using_animtree ("vehicles");

main(model)
{
	level.vehicleInitThread["kubelwagon"][model] = ::init;
	switch(model)	
	{
		case "xmodel/vehicle_german_kubel":
			precachemodel("xmodel/vehicle_german_kubel");
			precachemodel("xmodel/vehicle_german_kubel_d");
			level.deathmodel[model] = "xmodel/vehicle_german_kubel_d";  // temp  no damage model built yet
			break;
		case "xmodel/vehicle_german_kubel_nomandy":
			precachemodel("xmodel/vehicle_german_kubel_nomandy");
			precachemodel("xmodel/vehicle_german_kubel_normandy_d");
			level.deathmodel[model] = "xmodel/vehicle_german_kubel_normandy_d";  // temp  no damage model built yet
			break;
	}

	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_kubelwagen_jeep_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;
	
	//level.deathfx[model] = loadfx("fx/explosions/explosion1.efx");

	level.deathfx[model] = 	loadfx("fx/explosions/large_vehicle_explosion.efx");
	
	level.deathfx_extra[model]["loop"] = loadfx("fx/fire/halftrack_fire.efx");
	level.deathfx_extra[model]["tag"] = "tag_body";
	level.deathfx_extra[model]["delay"] = 1;
	
	maps\_treadfx::main("Kubelwagon");
}

#using_animtree ("generic_human");

init()
{
	if(!isdefined(self.script_team))
		self.script_team = "axis";
	thread kill();
	thread maps\_treads::main();
	thread life();

	self.guygetinque = [];

	positions[0]["getout"] = %wagon_driver_jumpout;
	positions[1]["getout"] = %wagon_passenger_jumpout;
	positions[2]["getout"] = %wagon_backleft_jumpout;
	positions[3]["getout"] = %wagon_backleft_jumpout;

	positions[0]["idle"][0] = %kubelwagon_elder_driveidleA;
	positions[0]["idleoccurrence"][0] = 500;
	positions[1]["idle"][0] = %kubelwagon_moody_sitidle;
	positions[1]["idleoccurrence"][0] = 500;
	positions[2]["idle"][0] = %kubelwagon_moody_sitidle;
	positions[2]["idleoccurrence"][0] = 1800;
	positions[3]["idle"][0] = %kubelwagon_moody_sitidle;
	positions[3]["idleoccurrence"][0] = 1400;

	positions[0]["idle"][1] = %kubelwagon_elder_driveidleB;
	positions[0]["idleoccurrence"][1] = 300;
	
	//positions[1]["idle"][1] = %wagon_passenger_idle_look;
	//positions[2]["idle"][1] = %wagon_backleft_idle_look;
	
	positions[0]["idle"][2] = %wagon_driver_point;
	positions[0]["idleoccurrence"][2] = 100;
	positions[0]["idle"][3] = %wagon_driver_look;
	positions[0]["idleoccurrence"][3] = 100;

	positions[0]["duckin"] = %wagon_driver_duck;
	positions[0]["duckout"] = %wagon_driver_duck_return;
	
	//positions[0]["duckidle"][0] = %wagon_driver_duck_idle;
	positions[0]["duckidle"][0] = %kubelwagon_moody_sitidle;
	
	positions[0]["duckidleoccurrence"][0] = 100;
	positions[0]["duckidleoccurrence"][1] = 100;
	
	//positions[0]["duckidle"][1] = %wagon_driver_duck_look;
	positions[0]["duckidle"][1] = %kubelwagon_moody_sitidle;
	
	positions[1]["standup"] = %wagon_passenger_up;
	positions[2]["standup"] = %wagon_backleft_up;
	positions[1]["standdown"] = %wagon_passenger_down;
	positions[2]["standdown"] = %wagon_backleft_down;

	positions[1]["standidle"] = %wagon_passenger_idle_up;
	positions[2]["standidle"] = %wagon_backleft_idle_up;
	positions[3]["standidle"] = %wagon_backleft_idle_up;

	positions[1]["standattack"] = %wagon_passenger_fire;
	positions[2]["standattack"] = %wagon_backleft_fire;
	positions[3]["standattack"] = %wagon_backleft_fire;


	positions[1]["standattackforward"] = %wagon_passenger_fire;
	positions[2]["standattackforward"] = %wagon_backleft_fire;
	positions[3]["standattackforward"] = %wagon_backleft_fire;

	positions[1]["standattackleft"] = %wagon_passenger_fire;
	positions[2]["standattackleft"] = %wagon_backleft_fire_left60;
	positions[3]["standattackleft"] = %wagon_backleft_fire_left60;

	positions[1]["standattackright"] = %wagon_passenger_fire;
	positions[2]["standattackright"] = %wagon_backleft_fire_right60;
	positions[3]["standattackright"] = %wagon_backleft_fire_right60;

	positions[1]["standattack"] = %wagon_passenger_fire;
	positions[2]["standattack"] = %wagon_backleft_fire;
	positions[3]["standattack"] = %wagon_backleft_fire;

	positions[1]["standattackthreads"][0] =  ::fire;
	positions[2]["standattackthreads"][0] = ::fire;
	positions[3]["standattackthreads"][0] = ::fire;

	positions[1]["standattacktracks"][0] = "end";
	positions[2]["standattacktracks"][0] = "end";
	positions[3]["standattacktracks"][0] = "end";

	positions[0]["closedoor"] = %germantruck_driver_closedoor;
	positions[1]["closedoor"] = %germantruck_driver_closedoor;
	positions[2]["closedoor"] = %germantruck_driver_closedoor;
	positions[3]["closedoor"] = %germantruck_driver_closedoor;

	positions[0]["sittag"] = "tag_driver";
	positions[1]["sittag"] = "tag_passenger";
	positions[2]["sittag"] = "tag_guy0";
	positions[3]["sittag"] = "tag_guy1";

	positions[0]["death"] = %wagon_driver_death;
	positions[1]["death"] = %wagon_passenger_death;
	positions[2]["death"] = %wagon_backleft_death_hit;
	positions[3]["death"] = %wagon_backleft_death_hit;

	positions[2]["deathfast"] = %wagon_backleft_death_hit;
	positions[3]["deathfast"] = %wagon_backleft_death_hit;
	
	positions[2]["deathslow"] = %wagon_backleft_slowdeath_hit;
	positions[3]["deathslow"] = %wagon_backleft_slowdeath_hit;

	positions[2]["deathrollfast"] = %wagon_backleft_death_roll;
	positions[3]["deathrollfast"] = %wagon_backleft_death_roll;

	positions[2]["deathrollslow"] = %wagon_backleft_slowdeath_roll;
	positions[3]["deathrollslow"] = %wagon_backleft_slowdeath_roll;
	
	positions[0]["deathscript"] = ::guy_deathinvehicle;
	positions[1]["deathscript"] = ::guy_deathinvehicle;
	positions[2]["deathscript"] = ::guy_deathinvehicle;
	positions[3]["deathscript"] = ::guy_deathinvehicle;

	positions[0]["deathloop"] = %wagon_driver_death;
	positions[1]["deathloop"] = %wagon_passenger_death;

	thread handle_attached_guys(3,positions);
	thread attack();
	
}

