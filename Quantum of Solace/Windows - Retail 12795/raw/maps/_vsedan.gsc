#include maps\_vehicle_aianim;
#include maps\_vehicle;

#using_animtree("vehicles");

main(model, type)
{
	if(!isdefined(type))
	{
		if (model == "v_astonmartindbs_radiant")
		{
			type = "aston_martin";	// Aston Martin has its own type because it has a different wheel radius.
		}
		else
		{
			type = "sedan";
		}
	}

	build_template(type, model);
	build_localinit(::init_local);

	//deathfx = loadfx ("explosions/large_vehicle_explosion");

	level.vehicle_hasMainTurret[model] = false;	//no turret

	switch(model)	
	{
		case "v_sedan_blue_radiant":
			precachemodel("v_sedan_blue_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_blue_radiant";
			break;

		case "v_sedan_gray_radiant":
			precachemodel("v_sedan_gray_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_gray_radiant";
			break;

		case "v_sedan_silver_radiant":
			precachemodel("v_sedan_silver_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_silver_radiant";
			break;
			
		case "v_sedan_clean_gunmetal_radiant":
			precachemodel("v_sedan_clean_gunmetal_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_gunmetal_radiant";
			break;
			
		case "v_sedan_clean_silver_radiant":
			precachemodel("v_sedan_clean_silver_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_silver_radiant";
			break;
			
		case "v_sedan_clean_black_radiant":
			precachemodel("v_sedan_clean_black_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_clean_black_radiant";
			break;

		case "v_sedan_tan_radiant":
			precachemodel("v_sedan_tan_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_tan_radiant";
			break;

		case "v_sedan_police_radiant":
			precachemodel("v_sedan_police_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_police_radiant";
			break;

		case "v_astonmartindbs_radiant":
			precachemodel("v_astonmartindbs_radiant");
			level.vehicle_deathmodel[model] = "v_astonmartindbs_radiant";
			break;
			
		case "v_sedan_us_gunmetal_radiant":
			precachemodel("v_sedan_us_gunmetal_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_gunmetal_radiant";
			break;	

		case "v_sedan_us_black_radiant":
			precachemodel("v_sedan_us_black_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_black_radiant";
			break;				

		case "v_sedan_us_silver_radiant":
			precachemodel("v_sedan_us_silver_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_silver_radiant";
			break;	

		case "v_sedan_us_blue_radiant":
			precachemodel("v_sedan_us_blue_radiant");
			level.vehicle_deathmodel[model] = "v_sedan_us_blue_radiant";
			break;	

		case "v_sedan_luxury_radiant_silver":
			precachemodel("v_sedan_luxury_radiant_silver");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_silver";
			break;	

		case "v_sedan_luxury_radiant_black":
			precachemodel("v_sedan_luxury_radiant_black");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_black";
			break;	

		case "v_sedan_luxury_radiant_darkblue":
			precachemodel("v_sedan_luxury_radiant_darkblue");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_darkblue";
			break;	

		case "v_sedan_luxury_radiant_darksilver":
			precachemodel("v_sedan_luxury_radiant_darksilver");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_darksilver";
			break;	

		case "v_sedan_luxury_radiant_red":
			precachemodel("v_sedan_luxury_radiant_red");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_red";
			break;	

		case "v_sedan_luxury_radiant_pearl":
			precachemodel("v_sedan_luxury_radiant_pearl");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_pearl";
			break;	

		case "v_sedan_luxury_radiant_lightblue":
			precachemodel("v_sedan_luxury_radiant_lightblue");
			level.vehicle_deathmodel[model] = "v_sedan_luxury_radiant_lightblue";
			break;	
		
	}
	
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

	// _brian_b_03/07/08: damage fx
	level._vehicle_damage_effect[type]["grind"] = Loadfx("impacts/large_metalhit");

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
	
	//level.vehicle_aianims[type] = setanims();
//	level.vehicle_aianims[type] = set_vehicle_anims(level.vehicle_aianims[type]);
	build_aianims(::setanims, ::set_vehicle_anims);
	
	// this vehicle will recieve a random name from _vehiclenames
//	level.vehicle_hasname[type] = true;
	
	// might want to rethink implementation on this or other things.  Tanks have convenient tag_walk0-6 or somesuch
//	level.vehicle_walkercount[type] = 6;

	//BOND_MOD: vehicle damage
	maps\_vehicle_damage::setup(model);
}

init_local()
{
}

#using_animtree("tank");
set_vehicle_anims(positions)
{
	return positions;
}

#using_animtree("generic_human");
setanims()
{
	positions = [];
	return positions;
}