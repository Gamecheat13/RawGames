#include maps\_vehicle_aianim;
main(model,type)
{
	if(!isdefined(type))
		type = "technical";
	//specify turrets 
	//_______________________build_turret ( array , 		info, 			tag, 			model, 				bAicontrolled )	
	turrets = maps\_vehicle::build_turret(undefined,"50cal_turret_technical","tag_50cal","weapon_pickup_technical_mg50cal",true);
//	turrets = maps\_vehicle::build_turret(undefined,"cod2mg42_turret","tag_50cal","cod3mg42",true);
	level.vehicle_mgturret[type] = turrets;

	maps\_truck::main(model,type);
	level.vehicle_aianims[type] = setanims();
	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);
	level.vehicle_unloadgroups[type] = Unload_Groups();
	
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{

/*
	positions[0].vehicle_getoutanim = %door_pickup_driver_climb_out;
	positions[1].vehicle_getoutanim = %door_pickup_passenger_climb_out;
	positions[2].vehicle_getoutanim = %door_pickup_passenger_RL_climb_out;
	positions[3].vehicle_getoutanim = %door_pickup_passenger_RR_climb_out;
	*/
	return positions;
}

#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<3;i++)
		positions[i] = spawnstruct();
/*
rough pass

technical_driver_duck
technical_driver_idle
technical_driver_climb_out


technical_passenger_duck
technical_passenger_idle


technical_passenger_climb_out
technical_turret_aim_2
technical_turret_aim_8
technical_turret_death
technical_turret_jam
technical_turret_turn_L
technical_turret_turn_R
door_technical_driver_climb_out
door_technical_passenger_climb_out
*/
//	positions[0].getout_delete = true;

	positions[0].sittag = "tag_driver";
	positions[1].sittag = "tag_gunner";
	positions[2].sittag = "tag_passenger";

	positions[0].idle[0] = %technical_driver_idle;
	positions[0].idle[1] = %technical_driver_duck;
	positions[0].idleoccurrence[0] = 1000;
	positions[0].idleoccurrence[1] = 100;

/*  no anim for machine gun guy just yet
	positions[1].idle[0] = %technical_driver_idle;
	positions[1].idle[1] = %technical_driver_duck;
	positions[1].idleoccurrence[0] = 1000;
	positions[1].idleoccurrence[1] = 100;
*/	
	positions[2].idle[0] = %technical_passenger_idle;
	positions[2].idle[1] = %technical_passenger_duck;
	positions[2].idleoccurrence[0] = 1000;
	positions[2].idleoccurrence[1] = 100;

	positions[0].getout = %technical_driver_climb_out;
//	positions[1].getout = %humvee_passenger_out_L;
	positions[2].getout = %technical_passenger_climb_out;

	//positions[0].getin = %humvee_driver_climb_idle;
	//positions[1].getin = %humvee_passenger_in_L;
	//positions[2].getin = %humvee_passenger_in_R;
	
	positions[1].mgturret = 0; // which of the turrets is this guy going to use

	return positions;
}

unload_groups()
{
	unload_groups = [];
	unload_groups["passengers"] = [];
	unload_groups["passenger_and_gunner"] = [];
	unload_groups["all"] = [];

	group = "passenger_and_gunner";
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;

	group = "all";
	unload_groups[group][unload_groups[group].size] = 0;
	unload_groups[group][unload_groups[group].size] = 1;
	unload_groups[group][unload_groups[group].size] = 2;

	group = "passengers";
	unload_groups[group][unload_groups[group].size] = 2;
	unload_groups["default"] = unload_groups["all"];
	
	return unload_groups;
	
}