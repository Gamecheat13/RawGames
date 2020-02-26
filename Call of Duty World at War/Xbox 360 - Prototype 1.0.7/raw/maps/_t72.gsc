#include maps\_vehicle_aianim;
#using_animtree ("tank");
main(model,type)
{
	if(!isdefined(type))
		type = "t72";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	switch(model)	
	{
		case "vehicle_t72_tank":
			precachemodel("vehicle_t72_tank");
			precachemodel("vehicle_t72_tank_d_body");
//			precachemodel("vehicle_t72_tank_d");
//			level.vehicle_deathmodel[model] = "vehicle_t72_tank_d";
			level.vehicle_deathmodel[model] = "vehicle_t72_tank_d_body";
			break;
	}
	precachevehicle(type);
	
//	level.vehicleanimtree[model] = #animtree;
//	level.vehicle_DriveIdle[model] = %british_crusader_tank_drive_idle;
//	level.vehicle_DriveIdle_normal_speed[model] = 10;

	// death fx stuff
	level.vehicle_death_fx[type] = [];
	deathfx = loadfx ("explosions/large_vehicle_explosion");
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
	
	turrets = maps\_vehicle::build_turret(undefined,"t72_turret2","tag_turret2","vehicle_t72_tank_pkt_coaxial_mg",true);
	level.vehicle_mgturret[type] = turrets;

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
	level.vehicle_hasMainTurret[model] = true;
	level.vehicle_turretfiretime[model] = 8;
	
	//enables vehicle on the compass
	level.vehicle_compassicon[type] = false;
	
	//when the riders on this vehicle get attacked the vehicle gets unloaded
//	level.vehicle_unloadwhenattacked[type] = true;
	
//	level.vehicle_aianims[type] = setanims();
//	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);
	
	// this vehicle will recieve a random name from _vehiclenames
//	level.vehicle_hasname[type] = true;
	
	// might want to rethink implementation on this or other things.  Tanks have convenient tag_walk0-6 or somesuch
//	level.vehicle_walkercount[type] = 6;

}

init_local()
{
	self.frontarmorregen = .33;  // percentage of damage to regenerate for attacks from the front
}

#using_animtree ("tank");
set_vehicle_anims(positions)
{
	/*
	positions[0].vehicle_getinanim = %tigertank_hatch_open;
	positions[1].vehicle_getoutanim = %tigertank_hatch_open;
	*/
	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<11;i++)
		positions[i] = spawnstruct();

	positions[0].getout_delete = true;

/*
	positions[0].getout = %crusader_tankride_guy0_closehatch;
	positions[1].getout = %crusader_tankride_guy1_combatdismount;
	positions[2].getout = %crusader_tankride_guy2_jumptocombatrun;
	positions[3].getout = %crusader_tankride_guy3_combatdismount;
	positions[4].getout = %crusader_tankride_guy4_combatdismount;
	positions[5].getout = %crusader_tankride_guy3_combatdismount;
	positions[6].getout = %crusader_tankride_guy6_jumptocombatrun;
	positions[7].getout = %crusader_tankride_guy3_combatdismount;
	positions[8].getout = %crusader_tankride_guy1_combatdismount;
	positions[9].getout = %crusader_tankride_guy1_combatdismount;
	positions[10].getout = %crusader_tankride_guy1_combatdismount;

	positions[0].idle[0] = %crusader_tankride_guy0_driving_idle;
	positions[1].idle[0] = %crusader_tankride_guy3_driving_idle;
	positions[2].idle[0] = %crusader_tankride_guy2_driving_idle;
	positions[3].idle[0] = %crusader_tankride_guy3_driving_idle;
	positions[4].idle[0] = %crusader_Tankride_guy4_driving_idle;
	positions[5].idle[0] = %crusader_tankride_guy3_driving_idle;
	positions[6].idle[0] = %crusader_tankride_guy6_driving_idle;
	positions[7].idle[0] = %crusader_tankride_guy3_driving_idle;
	positions[8].idle[0] = %crusader_Tankride_guy4_driving_idle;
	positions[9].idle[0] = %crusader_Tankride_guy4_driving_idle;
	positions[10].idle[0] = %crusader_Tankride_guy4_driving_idle;

	positions[0].idle[1] = %crusader_tankride_guy0_lookingaround;
	positions[1].idle[1] = %crusader_tankride_guy3_lookingaround;
	positions[2].idle[1] = %crusader_tankride_guy2_lookingaround;
	positions[3].idle[1] = %crusader_tankride_guy3_lookingaround;
	positions[4].idle[1] = %crusader_Tankride_guy4_lookingaround;
	positions[5].idle[1] = %crusader_tankride_guy3_lookingaround;
	positions[6].idle[1] = %crusader_tankride_guy6_lookingaround;
	positions[7].idle[1] = %crusader_tankride_guy3_lookingaround;
	positions[8].idle[1] = %crusader_Tankride_guy4_lookingaround;
	positions[9].idle[1] = %crusader_Tankride_guy4_lookingaround;
	positions[10].idle[1] = %crusader_Tankride_guy4_lookingaround;

	positions[0].explosion_death = 	%death_explosion_up10;
	positions[1].explosion_death = 	%death_explosion_forward13;
	positions[2].explosion_death = 	%death_explosion_back13;
	positions[3].explosion_death = 	%death_explosion_left11;
	positions[4].explosion_death = 	%death_explosion_forward13;
	positions[5].explosion_death = 	%death_explosion_right13;
	positions[6].explosion_death = 	%death_explosion_back13;
	positions[7].explosion_death = 	%death_explosion_left11;
	positions[8].explosion_death = 	%death_explosion_forward13;
	positions[9].explosion_death = 	%death_explosion_right13;
	positions[10].explosion_death = 	%death_explosion_back13;

	positions[0].deathscript = ::deathremove;
	positions[1].deathscript = ::deathremove;
	positions[2].deathscript = ::deathremove;
	positions[3].deathscript = ::deathremove;
	positions[4].deathscript = ::deathremove;
	positions[5].deathscript = ::deathremove;
	positions[6].deathscript = ::deathremove;
	positions[7].deathscript = ::deathremove;
	positions[8].deathscript = ::deathremove;
	positions[9].deathscript = ::deathremove;
	positions[10].deathscript = ::deathremove;
	
	positions[0].idle_right = %crusader_tankride_guy0_leanright;
	positions[1].idle_right = %crusader_Tankride_guy1_leanright;
	positions[2].idle_right = %crusader_tankride_guy2_leanleft;
	positions[3].idle_right = %crusader_tankride_guy3_leanback;
	positions[4].idle_right = %crusader_Tankride_guy4_leanright;
	positions[5].idle_right = %crusader_tankride_guy3_leanforward;
	positions[6].idle_right = %crusader_tankride_guy6_leanleft;
	positions[7].idle_right = %crusader_Tankride_guy4_leanleft;
	positions[8].idle_right = %crusader_Tankride_guy4_leanright;
	positions[9].idle_right = %crusader_Tankride_guy1_leanright;
	positions[10].idle_right = %crusader_Tankride_guy1_leanright;

	positions[0].idle_left = %crusader_tankride_guy0_leanleft;
	positions[1].idle_left = %crusader_Tankride_guy1_leanleft;
	positions[2].idle_left = %crusader_tankride_guy2_leanleft;
	positions[3].idle_left = %crusader_tankride_guy3_leanforward;
	positions[4].idle_left = %crusader_Tankride_guy4_leanleft;
	positions[5].idle_left = %crusader_tankride_guy3_leanback;
	positions[6].idle_left = %crusader_tankride_guy6_leanright;
	positions[7].idle_left = %crusader_tankride_guy3_leanback;
	positions[8].idle_left = %crusader_Tankride_guy4_leanleft;
	positions[9].idle_left = %crusader_Tankride_guy1_leanleft;
	positions[10].idle_left = %crusader_Tankride_guy1_leanleft;
	
	for(i=0;i<positions.size;i++)
	{
		positions[i].idle_hardright = positions[i].idle_right;
		positions[i].idle_hardleft = positions[i].idle_left;
		positions[i].sittag = "tag_guy"+i;
		positions[i].idleoccurrence[0] = 1000;
		positions[i].idleoccurrence[1] = 200;
	}
*/
	return positions;
}

