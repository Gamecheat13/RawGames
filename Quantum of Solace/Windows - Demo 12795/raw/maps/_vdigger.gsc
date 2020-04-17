#include maps\_vehicle_aianim;

#using_animtree( "vehicles" );
main(model,type)
{
	if(!isdefined(type))
		type = "digger";
	level.vehicleInitThread[type][model] = ::init_local;

	//deathfx = loadfx ("explosions/large_vehicle_explosion");

	//enables turret
	level.vehicle_hasMainTurret[model] = false;

	switch(model)	
	{
		case "v_digger_motion_radiant":
			precachemodel("v_digger_motion_radiant");
			level.vehicle_deathmodel[model] = "v_digger_motion_radiant";
			break;

		case "v_digger_stationary_radiant":
			precachemodel("v_digger_stationary_radiant");
			level.vehicle_deathmodel[model] = "v_digger_stationary_radiant";
			break;
	}
	precachevehicle(type);
	
	level.vehicleanimtree[model] = #animtree;
	level.vehicle_DriveIdle[model] = %v_auto_tire_spin;
	level.vehicle_DriveIdle_normal_speed[model] = 10;

	// BOND MOD
	// MQL 11/29/07: build deathfx now handled by the destructible system
	// death fx stuff
	//level.vehicle_death_fx[type] = [];
	//this builds an array of effects, timings and such that will be processed by _maps\_vehicle::kill();
	//turretfire = 	loadfx("fire/crusader_fire_turret_large");
	//enginefire =  loadfx("fire/tank_fire_engine");
	//_______________________build_deathfx( array, effect, tag, sound, bEffectLooping, delay, bSoundlooping )
	//effects = maps\_vehicle::build_deathfx(undefined,enginefire,"tag_right_wheel_03",undefined,true,1,true);
	//effects = maps\_vehicle::build_deathfx(effects,enginefire,"tag_left_wheel_05",undefined,true,1,true);
	//effects = maps\_vehicle::build_deathfx(effects,turretfire,"tag_turret","smallfire",true,1,true);
	//effects = maps\_vehicle::build_deathfx(undefined,deathfx,undefined,"explo_metal_rand");
	//level.vehicle_death_fx[type] = effects;
	
	// BOND MOD
	// MQL 11/28/07: create fx for vehicles
	level.vehicle_death_fx[type] = Loadfx( "vehicles/destructible/vehicle_explosion_large" );
	level.vehicle_headlight_fx[type] = Loadfx( "vehicles/night/vehicle_night_headlight01" );
	level.vehicle_breaklight_fx[type] = Loadfx( "vehicles/night/vehicle_night_brakelight01" );
	level.vehicle_exhaust_fx[type] = Loadfx( "vehicles/night/vehicle_night_exhaust" );

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
	
	
	//enables vehicle on the compass
//	level.vehicle_compassicon[type] = true;
	
	//when the riders on this vehicle get attacked the vehicle gets unloaded
	level.vehicle_unloadwhenattacked[type] = false;
	
	level.vehicle_aianims[type] = setanims();
//	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);
	
	// this vehicle will recieve a random name from _vehiclenames
//	level.vehicle_hasname[type] = true;
	
	// might want to rethink implementation on this or other things.  Tanks have convenient tag_walk0-6 or somesuch
//	level.vehicle_walkercount[type] = 6;

}

init_local()
{
	
}

#using_animtree ("tank");
set_vehicle_anims(positions)
{

	return positions;
}


#using_animtree ("generic_human");

setanims ()
{
	positions = [];
	return positions;
}

