#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	if(!isdefined(type))
		type = "seaknight";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	deathfx = loadfx ("explosions/large_vehicle_explosion");
	switch(model)	
	{
		case "vehicle_ch46e":
			precachemodel("vehicle_ch46e");
			precachemodel("vehicle_ch46e");
			level.vehicle_deathmodel[model] = "vehicle_ch46e";
			break;
	}
	precachevehicle(type);
	
	level.vehicleanimtree[model] = #animtree;
//	level.vehicle_DriveIdle[model] = %bh_rotors;
//	level.vehicle_DriveIdle_normal_speed[model] = 0;  // 0 makes it animate even while idle.

	// death fx stuff
	level.vehicle_death_fx[type] = [];
	//this builds an array of effects, timings and such that will be processed by _maps\_vehicle::kill();
//	turretfire = 	loadfx("fire/crusader_fire_turret_large");
//	enginefire =  	loadfx("fire/tank_fire_engine");
	//_______________________build_deathfx( array, effect, tag, sound, bEffectLooping, delay, bSoundlooping )
//	effects = maps\_vehicle::build_deathfx(undefined,enginefire,"tag_right_wheel_03",undefined,true,1,true);
//	effects = maps\_vehicle::build_deathfx(effects,enginefire,"tag_left_wheel_05",undefined,true,1,true);
//	effects = maps\_vehicle::build_deathfx(effects,turretfire,"tag_turret","smallfire",true,1,true);
	effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	level.vehicle_death_fx[type] = effects;
	
	//this is the top string the vehicle will get when you aim at it.
//	level.vehicletypefancy[type] = &"VEHICLENAME_CRUSADER_TANK";

	//specify turrets 
	//_______________________build_turret ( array , 		info, 			tag, 			model, 				bAicontrolled )	
//	turrets = maps\_vehicle::build_turret(undefined,"mg42_tank_crusader","tag_turret3","weapon_machinegun_crusader2",false);
//	turrets = maps\_vehicle::build_turret(turrets,"mg42_tank_crusader","tag_turret2","weapon_machinegun_crusader2",false);
//	level.vehicle_mgturret[type] = turrets;
	
	// sets the various treadfx for a vehicle, if not called vehicles of this type won't do cool treadfx
	maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//rumble that loops during driving of vehicle
	//build_rumble( rumble , scale , duration , radius , basetime , randomaditionaltime )
//	level.vehicle_rumble[type] = maps\_vehicle::build_rumble("tank_rumble", 0.15,4.5,600,1,1);
	
	//build_quake ( scale, duration, radius )
//	level.vehicle_death_earthquake[type] = maps\_vehicle::build_quake(0.25,3,1050);

	//set default team for this vehicletype
	level.vehicle_team[type] = "allies";	
	
	//enables turret
	level.vehicle_hasMainTurret[model] = false;
	
	//enables vehicle on the compass
//	level.vehicle_compassicon[type] = true;
	
	//when the riders on this vehicle get attacked the vehicle gets unloaded
//	level.vehicle_unloadwhenattacked[type] = true;
	
//	level.vehicle_aianims[type] = setanims();
//	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);
	
	// this vehicle will recieve a random name from _vehiclenames
//	level.vehicle_hasname[type] = true;
	
	// might want to rethink implementation on this or other things.  Tanks have convenient tag_walk0-6 or somesuch
//	level.vehicle_walkercount[type] = 6;

		//trying to be generic with the naming on this but this particular attached model is the rope
//		level.vehicle_attachedmodels[type] = set_attached_models();
		
//		level.vehicle_unloadgroups[type] = Unload_Groups();

}

init_local()
{
	self.originheightoffset = 116;  //TODO-FIXME: this is ugly.
	self.fastropeoffset = 652; //TODO-FIXME: this is ugly.
	self.script_badplace = false; //All helicopters dont need to create bad places
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	ropemodel = "rope_test";
	precachemodel(ropemodel);
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<0;i++)
		positions[i] = spawnstruct();
//copy from _blackhawk when anims are rigged.
	return positions;

}



unload_groups()
{

}


set_attached_models()
{

}