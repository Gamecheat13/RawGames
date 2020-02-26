#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	if(!isdefined(type))
		type = "blackhawk";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	deathfx = loadfx ("explosions/large_vehicle_explosion");
	switch(model)	
	{
		case "vehicle_blackhawk":
			precachemodel("vehicle_blackhawk");
			precachemodel("vehicle_blackhawk");
			level.vehicle_deathmodel[model] = "vehicle_blackhawk";
			break;
		case "vehicle_mi24p_hind_desert":
			precachemodel("vehicle_mi24p_hind_desert");
			precachemodel("vehicle_mi24p_hind_desert");
			level.vehicle_deathmodel[model] = "vehicle_mi24p_hind_desert";
			break;
		case "vehicle_mi24p_hind_woodland":
			precachemodel("vehicle_mi24p_hind_woodland");
			precachemodel("vehicle_mi24p_hind_woodland");
			level.vehicle_deathmodel[model] = "vehicle_mi24p_hind_woodland";
			break;
		case "vehicle_mi24p_hind_woodland_opened_door":
			precachemodel("vehicle_mi24p_hind_woodland_opened_door");
			precachemodel("vehicle_mi24p_hind_woodland_opened_door");
			level.vehicle_deathmodel[model] = "vehicle_mi24p_hind_woodland_opened_door";
			break;
			
			
			
		
	}
	precachevehicle(type);
	
	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %bh_rotors;
	level.vehicle_DriveIdle_normal_speed[model] = 0;  // 0 makes it animate even while idle.

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
	
	level.vehicle_aianims[type] = setanims();
	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);
	
	// this vehicle will recieve a random name from _vehiclenames
//	level.vehicle_hasname[type] = true;
	
	// might want to rethink implementation on this or other things.  Tanks have convenient tag_walk0-6 or somesuch
//	level.vehicle_walkercount[type] = 6;

		//trying to be generic with the naming on this but this particular attached model is the rope
		level.vehicle_attachedmodels[type] = set_attached_models();
		
		level.vehicle_unloadgroups[type] = Unload_Groups();

}

init_local()
{

//	self.originheightoffset = 116;  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.originheightoffset = distance(self gettagorigin("tag_origin"), self gettagorigin("tag_ground"));  //TODO-FIXME: this is ugly. Derive from distance between tag_origin and tag_base or whatever that tag was.
	self.fastropeoffset = 762; //TODO-FIXME: this is ugly. If only there were a getanimendorigin() command
	
	self.script_badplace = false; //All helicopters dont need to create bad places
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
//	positions[0].vehicle_getinanim = %tigertank_hatch_open;
	
	for(i=0;i<positions.size;i++)
		positions[i].vehicle_getoutanim = %bh_idle;

	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	for(i=0;i<9;i++)
		positions[i] = spawnstruct();
		
	positions[0].idle = %bh_Pilot_idle;
	positions[1].idle = %bh_coPilot_idle;
	
	// 1, 2, 4, 5, 8,  6
	positions[2].idle = %bh_1_idle;
	positions[3].idle = %bh_2_idle;
	positions[4].idle = %bh_4_idle;
	positions[5].idle = %bh_5_idle;
	positions[6].idle = %bh_8_idle;
	positions[7].idle = %bh_6_idle;
	positions[8].idle = %bh_7_idle;
//	positions[9].idle = %bh_2_idle;

	
	positions[0].sittag = "tag_detach";
	positions[1].sittag = "tag_detach";
	positions[2].sittag = "tag_detach";
	positions[3].sittag = "tag_detach";
	positions[4].sittag = "tag_detach";
	positions[5].sittag = "tag_detach";
	positions[6].sittag = "tag_detach";
	positions[7].sittag = "tag_detach";
	positions[8].sittag = "tag_detach";
//	positions[9].sittag = "tag_detach";
	
//	positions[0].getout = %bh_Pilot_idle;
//	positions[1].getout = %bh_coPilot_idle;

/*
	positions[2].getout = %bh_1_begining;
	positions[3].getout = %bh_2_begining;
	positions[4].getout = %bh_3_begining;
	positions[5].getout = %bh_4_begining;
	positions[6].getout = %bh_5_begining;
	positions[7].getout = %bh_6_begining;
	positions[8].getout = %bh_7_begining;
	positions[9].getout = %bh_2_begining;
*/

	// 1, 2, 4, 5, 8,  6
	positions[2].getout = %bh_1_drop;
	positions[3].getout = %bh_2_drop;
	positions[4].getout = %bh_4_drop;
	positions[5].getout = %bh_5_drop;
	positions[6].getout = %bh_8_drop;
	positions[7].getout = %bh_6_drop;
	positions[8].getout = %bh_7_drop;
//	positions[9].getout = %bh_7_drop;





	positions[2].getoutsnd = "fastrope_loop_npc";
	positions[3].getoutsnd = "fastrope_loop_npc";
	positions[4].getoutsnd = "fastrope_loop_npc";
	positions[5].getoutsnd = "fastrope_loop_npc";
	positions[6].getoutsnd = "fastrope_loop_npc";
	positions[7].getoutsnd = "fastrope_loop_npc";
	positions[8].getoutsnd = "fastrope_loop_npc";
//	positions[9].getoutsnd = "fastrope_loop_npc";

	
//	positions[0].getoutloop = %bh_Pilot_idle;
//	positions[1].getoutloop = %bh_coPilot_idle;

/*
	positions[2].getoutloop = %bh_fastrope_loop;
	positions[3].getoutloop = %bh_fastrope_loop;
	positions[4].getoutloop = %bh_fastrope_loop;
	positions[5].getoutloop = %bh_fastrope_loop;
	positions[6].getoutloop = %bh_fastrope_loop;
	positions[7].getoutloop = %bh_fastrope_loop;
	positions[8].getoutloop = %bh_fastrope_loop;
	positions[9].getoutloop = %bh_fastrope_loop;
*/
	positions[2].getoutloopsnd = "fastrope_loop_npc";
	positions[3].getoutloopsnd = "fastrope_loop_npc";
	positions[4].getoutloopsnd = "fastrope_loop_npc";
	positions[5].getoutloopsnd = "fastrope_loop_npc";
	positions[6].getoutloopsnd = "fastrope_loop_npc";
	positions[7].getoutloopsnd = "fastrope_loop_npc";
	positions[8].getoutloopsnd = "fastrope_loop_npc";
//	positions[9].getoutloopsnd = "fastrope_loop_npc";
	
//	positions[0].getoutland = %bh_Pilot_idle;
//	positions[1].getoutland = %bh_coPilot_idle;
/*
	positions[2].getoutland = %bh_fastrope_land;
	positions[3].getoutland = %bh_fastrope_land;
	positions[4].getoutland = %bh_fastrope_land;
	positions[5].getoutland = %bh_fastrope_land;
	positions[6].getoutland = %bh_fastrope_land;
	positions[7].getoutland = %bh_fastrope_land;
	positions[8].getoutland = %bh_fastrope_land;
	positions[9].getoutland = %bh_fastrope_land;
*/	
	
//	positions[0].getoutrig = "TAG_FastRope_LE";
//	positions[1].getoutrig = "TAG_FastRope_LE";

	// 1, 2, 4, 5, 6, & 8


	positions[2].getoutrig = "TAG_FastRope_RI"; //1
	positions[3].getoutrig = "TAG_FastRope_RI";	//2
	positions[4].getoutrig = "TAG_FastRope_LE";	//4
	positions[5].getoutrig = "TAG_FastRope_LE";	//5
	positions[6].getoutrig = "TAG_FastRope_RI"; //8
	positions[7].getoutrig = "TAG_FastRope_LE"; //6
	positions[8].getoutrig = "TAG_FastRope_RI"; //7
//	positions[9].getoutrig = "TAG_FastRope_RI";
	return positions;                           
}                                             



//WIP.. posible to unload different sets of people wirh vehicle notify ("unload",set); sets defined here.
unload_groups()
{
	unload_groups = [];
	unload_groups["left"] = [];
	unload_groups["right"] = [];
	unload_groups["both"] = [];

	unload_groups["left"][unload_groups["left"].size] = 4;
	unload_groups["left"][unload_groups["left"].size] = 5;
	unload_groups["left"][unload_groups["left"].size] = 7;

	unload_groups["right"][unload_groups["right"].size] = 2;
	unload_groups["right"][unload_groups["right"].size] = 3;
	unload_groups["right"][unload_groups["right"].size] = 6;
	unload_groups["right"][unload_groups["right"].size] = 8;

	unload_groups["both"][unload_groups["both"].size] = 2;
	unload_groups["both"][unload_groups["both"].size] = 3;
	unload_groups["both"][unload_groups["both"].size] = 4;
	unload_groups["both"][unload_groups["both"].size] = 5;
	unload_groups["both"][unload_groups["both"].size] = 6;
	unload_groups["both"][unload_groups["both"].size] = 7;
	unload_groups["both"][unload_groups["both"].size] = 8;

	unload_groups["default"] = unload_groups["both"];
	
	return unload_groups;
	
}


set_attached_models()
{
	array = [];
	array["TAG_FastRope_LE"] = spawnstruct();
	array["TAG_FastRope_LE"].model = "rope_test";
	array["TAG_FastRope_LE"].tag = "TAG_FastRope_LE";
	array["TAG_FastRope_LE"].idleanim = %rope_idle;
	array["TAG_FastRope_LE"].dropanim = %rope_drop;

	array["TAG_FastRope_RI"] = spawnstruct();
	array["TAG_FastRope_RI"].model = "rope_test";
	array["TAG_FastRope_RI"].tag = "TAG_FastRope_RI";
	array["TAG_FastRope_RI"].idleanim = %rope_idle;
	array["TAG_FastRope_RI"].dropanim = %rope_drop;
	
	strings = getarraykeys(array);
	
	for(i=0;i<strings.size;i++)
	{
			precachemodel(array[strings[i]].model);
	}

	return array;
}