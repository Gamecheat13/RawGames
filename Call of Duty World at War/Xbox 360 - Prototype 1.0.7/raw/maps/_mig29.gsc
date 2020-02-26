#include maps\_utility;
#include maps\_vehicle_aianim;
#using_animtree ("vehicles");
main(model,type)
{
	if(!isdefined(type))
		type = "mig29";
	level.vehicleInitThread[type][model] = ::init_local;

	deathfx = undefined;
	switch(model)	
	{
		case "vehicle_mig29_desert":
			precachemodel("vehicle_mig29_desert");
			precachemodel("vehicle_mig29_desert");
			precacherumble("tank_rumble");
			level.vehicle_deathmodel[model] = "vehicle_mig29_desert";
			break;

	}
	deathfx = loadfx ("explosions/large_vehicle_explosion");
	level._effect["afterburner"]				= loadfx ("fire/jet_afterburner");
	level._effect["contrail"]					= loadfx ("smoke/jet_contrail");

	precachevehicle(type);
	
//	level.vehicleanimtree[model] = #animtree;
//	level.vehicle_DriveIdle[model] = %bh_rotors;
//	level.vehicle_DriveIdle_normal_speed[model] = 50;

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
	// maps\_treadfx::main(type);

	// give the vehicle life
	level.vehicle_life[type] = 999;
	level.vehicle_life_range_low[type] = 500;
	level.vehicle_life_range_high[type] = 1500;
	
	//rumble that loops during driving of vehicle
	//build_rumble(                                           rumble ,      scale , duration ,   radius ,    basetime ,   randomaditionaltime )
	level.vehicle_rumble[type] = maps\_vehicle::build_rumble("tank_rumble", .1,     .2,         11300,         .05,          .05);
	
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
	thread playAfterBurner();
	thread playConTrail();
}

#using_animtree ("vehicles");
set_vehicle_anims(positions)
{
	ropemodel = "rope_test";
	precachemodel(ropemodel);
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
	for(i=0;i<1;i++)
		positions[i] = spawnstruct();
		
	return positions;
}

playAfterBurner()
{
	//After Burners are pretty much like turbo boost. They don't use them all the time except when 
	//bursts of speed are needed. Needs a cool sound when they're triggered. Currently, they are set
	//to be on all the time, but it would be cool to see them engauge as they fly away.
	burnerDelay= 0.1;
	
	for (;;)
	{
		if (!isdefined(self))
			return;
		if (!isalive(self))
			return;
		playfxontag( level._effect["afterburner"], self, "tag_engine_right" );
		playfxontag( level._effect["afterburner"], self, "tag_engine_left" );
		wait burnerDelay;
	}
}

playConTrail()
{
	//This is a geoTrail effect that loops forever. It has to be enabled and disabled while playing as 
	//one effect. It can't be played in a wait loop like other effects because a geo trail is one 
	//continuous effect. ConTrails should only be played during high "G" or high speed maneuvers.
	playfxontag( level._effect["contrail"], self, "tag_right_wingtip" );
	playfxontag( level._effect["contrail"], self, "tag_left_wingtip" );
}


playerisclose(other)
{
	infront = playerisinfront(other);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_multiply(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b,level.player.origin);
	dist = distance(a,point);
	if(dist < 3000)
		return true;
	else
		return false;
}

playerisinfront(other)
{
		forwardvec = anglestoforward(flat_angle(other.angles));
		normalvec = vectorNormalize(flat_origin(level.player.origin)-other.origin);
		dot = vectordot(forwardvec,normalvec); 
		if(dot > 0)
			return true;
		else
			return false;
}

plane_sound_node()
{
		self waittill ("trigger",other);
		other endon ("death");
		self thread plane_sound_node(); // spawn new thread for next plane that passes through this pathnode
		other thread play_loop_sound_on_entity("veh_mig29_dist_loop");
		while(!playerisclose(other) )
			wait .05;
		other stop_sound ("veh_mig29_dist_loop");
		other thread play_loop_sound_on_entity("veh_mig29_close_loop");
		while(playerisinfront(other))
			wait .05;
		wait .5; // little delay for the boom
		other thread play_sound_in_space("veh_mig29_sonic_boom");
		while(playerisclose(other) )
			wait .05;
		other stop_sound ("veh_mig29_close_loop");
		other thread play_loop_sound_on_entity("veh_mig29_dist_loop");
		other waittill ("reached_end_node");
		other stop_sound ("veh_mig29_dist_loop");
		other delete();
}

stop_sound(alias)
{
	self notify ("stop sound"+alias);
}
