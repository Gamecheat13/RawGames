
#include maps\_utility;
#include maps\_cars;
#using_animtree ("vehicles");

main(model)
{
	level.vehicleInitThread["jeep"][model] = ::init;
	switch(model)	
	{
		case "xmodel/vehicle_africa_jeep":
			precachemodel("xmodel/vehicle_africa_jeep");
			precachemodel("xmodel/vehicle_africa_jeep_dmg");
			level.deathmodel["xmodel/vehicle_africa_jeep"] = ("xmodel/vehicle_africa_jeep_dmg");
			break;
		case "xmodel/vehicle_africa_jeep_can":
			precachemodel("xmodel/vehicle_africa_jeep_can");
			precachemodel("xmodel/vehicle_africa_jeep_can_dmg");
			level.deathmodel["xmodel/vehicle_africa_jeep_can"] = ("xmodel/vehicle_africa_jeep_can_dmg");
			break;
		case "xmodel/vehicle_africa_jeep_cot":
			precachemodel("xmodel/vehicle_africa_jeep_cot");
			precachemodel("xmodel/vehicle_africa_jeep_cot_dmg");
			level.deathmodel["xmodel/vehicle_africa_jeep_cot"] = ("xmodel/vehicle_africa_jeep_cot_dmg");
			break;
		case "xmodel/vehicle_american_jeep":
			precachemodel("xmodel/vehicle_american_jeep");
			precachemodel("xmodel/vehicle_american_jeep_damage");
			level.deathmodel["xmodel/vehicle_american_jeep"] = ("xmodel/vehicle_american_jeep_damage");
			break;
		case "xmodel/vehicle_american_jeep_can":
			precachemodel("xmodel/vehicle_american_jeep_can");
			precachemodel("xmodel/vehicle_american_jeep_can_damage");
			level.deathmodel["xmodel/vehicle_american_jeep_can"] = ("xmodel/vehicle_american_jeep_can_damage");
			break;
		case "xmodel/vehicle_american_jeep_cot":
			precachemodel("xmodel/vehicle_american_jeep_cot");
			precachemodel("xmodel/vehicle_american_jeep_cot_damage");
			level.deathmodel["xmodel/vehicle_american_jeep_can"] = ("xmodel/vehicle_american_jeep_cot_damage");
			break;
		case "xmodel/vehicle_russia_jeep":
			precachemodel("xmodel/vehicle_russia_jeep");
			precachemodel("xmodel/vehicle_russia_jeep_dmg");
			level.deathmodel["xmodel/vehicle_russia_jeep"] = ("xmodel/vehicle_russia_jeep_dmg");
			break;
		case "xmodel/vehicle_russia_jeep_cot":
			precachemodel("xmodel/vehicle_russia_jeep_cot");
			precachemodel("xmodel/vehicle_russia_jeep_cot_dmg");
			level.deathmodel["xmodel/vehicle_russia_jeep_cot"] = ("xmodel/vehicle_russia_jeep_cot_dmg");
			break;
		case "xmodel/vehicle_russia_jeep_can":
			precachemodel("xmodel/vehicle_russia_jeep_can");
			precachemodel("xmodel/vehicle_russia_jeep_can_dmg");
			level.deathmodel["xmodel/vehicle_russia_jeep_can"] = ("xmodel/vehicle_russia_jeep_can_dmg");
			break;
	}
	
	level._vehicleanimtree[model] = #animtree;
	level._vehicledriveidle[model] = %german_kubelwagen_jeep_drive_idle;
	level._vehicledriveidle_normal_speed[model] = 10;

	level.deathfx[model] = 	loadfx("fx/explosions/large_vehicle_explosion.efx");

	level.deathfx_extra[model]["loop"] = loadfx("fx/fire/halftrack_fire.efx");
	level.deathfx_extra[model]["tag"] = "tag_body";
	level.deathfx_extra[model]["delay"] = 1;
	
	maps\_treadfx::main("jeep");
}

#using_animtree ("generic_human");

init()
{
	if(!isdefined(self.script_team))
		self.script_team = "allies";
	thread kill();
	thread maps\_treads::main();
	thread life();
	thread runtovehicle_handle();

	positions[0]["idle"] = %carchase_driver_drive;
	positions[1]["idle"] = %carchase_pass_drive;
	positions[2]["idle"] = %carchase_back_drive;
	positions[3]["idle"] = %carchase_back_drive;

	positions[0]["idle_right"] = %carchase_driver_right;
	positions[1]["idle_right"] = %carchase_pass_right;
	positions[2]["idle_right"] = %carchase_back_right;
	positions[3]["idle_right"] = %carchase_back_right;

	positions[0]["idle_left"] = %carchase_driver_left;
	positions[1]["idle_left"] = %carchase_pass_left;
	positions[2]["idle_left"] = %carchase_back_left;
	positions[3]["idle_left"] = %carchase_back_left;

	positions[0]["idle_hardright"] = %carchase_driver_hard_right;
	positions[1]["idle_hardright"] = %carchase_pass_hard_right;
	positions[2]["idle_hardright"] = %carchase_back_hard_right;
	positions[3]["idle_hardright"] = %carchase_back_hard_right;

	positions[0]["idle_hardleft"] = %carchase_driver_hard_left;
	positions[1]["idle_hardleft"] = %carchase_pass_hard_left;
	positions[2]["idle_hardleft"] = %carchase_back_hard_left;
	positions[3]["idle_hardleft"] = %carchase_back_hard_left;
	
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

	positions[1]["standattackthreads"][0] = ::fire;
	positions[2]["standattackthreads"][0] = ::fire;
	positions[3]["standattackthreads"][0] = ::fire;

	positions[1]["standattacktracks"][0] = "end";
	positions[2]["standattacktracks"][0] = "end";
	positions[3]["standattacktracks"][0] = "end";

	positions[0]["closedoor"] = %germantruck_driver_closedoor;
	positions[1]["closedoor"] = %germantruck_driver_closedoor;
	positions[2]["closedoor"] = %germantruck_driver_closedoor;
	positions[3]["closedoor"] = %germantruck_driver_closedoor;

	positions[0]["getout"] = %carchase_driver_norm_getout;
	positions[1]["getout"] = %carchase_pass_norm_getout;
	positions[2]["getout"] = %carchase_back_norm_getout;
	positions[3]["getout"] = %matmata_jeep_bs4_jumpout;

	positions[0]["getin"] = %carchase_driver_norm_getin;
	positions[1]["getin"] = %carchase_pass_norm_getin;
	positions[2]["getin"] = %carchase_back_norm_getin;
	positions[3]["getin"] = %carchase_back_norm_getin;


	positions[0]["sittag"] = "tag_driver";
	positions[1]["sittag"] = "tag_passenger";
	positions[2]["sittag"] = "tag_guy0";
	positions[3]["sittag"] = "tag_guy1";

	positions[0]["death"] = %wagon_driver_death;
	positions[1]["death"] = %eldaba_jeep_passenger_death;
	positions[2]["death"] = %eldaba_jeep_passenger_death;
	positions[3]["death"] = %eldaba_jeep_passenger_death;


//	positions[2]["deathfast"] = %wagon_backleft_death_hit;
//	positions[3]["deathfast"] = %wagon_backleft_death_hit;
	
//	positions[2]["deathslow"] = %wagon_backleft_slowdeath_hit;
//	positions[3]["deathslow"] = %wagon_backleft_slowdeath_hit;

//	positions[2]["deathrollfast"] = %wagon_backleft_death_roll;
//	positions[3]["deathrollfast"] = %wagon_backleft_death_roll;

//	positions[2]["deathrollslow"] = %wagon_backleft_slowdeath_roll;
//	positions[3]["deathrollslow"] = %wagon_backleft_slowdeath_roll;
	
	positions[0]["deathscript"] = ::guy_deathinvehicle;
	positions[1]["deathscript"] = ::guy_deathinvehicle;
	positions[2]["deathscript"] = ::guy_deathinvehicle;
	positions[3]["deathscript"] = ::guy_deathinvehicle;

	positions[0]["deathloop"] = %wagon_driver_death;
	positions[1]["deathloop"] = %eldaba_jeep_passenger_death;
	positions[2]["deathloop"] = %eldaba_jeep_passenger_death;
	positions[3]["deathloop"] = %eldaba_jeep_passenger_death;

	thread handle_attached_guys(4,positions);
//	thread attack();
}

