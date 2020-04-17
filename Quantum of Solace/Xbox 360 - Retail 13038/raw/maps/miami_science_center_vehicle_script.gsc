#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

////////////////////////////////////////  vehicle script  //////////////////////////////////////
//NOTE: sciencecenter_a_vehicle
//
//
//
//
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////


// bond_veh_death monitors the health of the vehicle and calls an explosion when it reaches 0
//[vehicle] thread maps\_vehicle::bond_veh_death();

// bond_veh_flat_tire monitors which tire has been shot and calls the flat tire animation
//[vehicle] thread maps\_vehicle::bond_veh_flat_tire();

// bond_veh_running_lights creates headlights and breaklights fx
//[vehicle] thread maps\_vehicle::bond_veh_running_lights();

// bond_veh_exhaust creates exhaust fx
//[vehicle] thread maps\_vehicle::bond_veh_exhaust();

// bond_veh_exhauset crates the water splashes on a moving vehicle
//[vehicle] thread maps\_vehicle::bond_veh_roadfx();

main()
{
	// precache vehicles for street traffic
	//maps\_sedan::main("v_sedan_silver_radiant");
	//maps\_vsedan::main("v_sedan_silver_radiant");
	//maps\_vsedan::main("v_sedan_police_radiant");
//	maps\_blackhawk::main("vehicle_blackhawk");

//	level thread spawn_badguy_lane_vehicle();
	level thread spawn_cop_lane_vehicle();
	level thread spawn_car_who_hits_guy();

	level thread spawn_eastbound_lane1_vehicles();
//	level thread spawn_eastbound_lane2_vehicles();
	
	level thread spawn_northbound_lane1_vehicles();
	level thread spawn_northbound_lane2_vehicles();

	level thread spawn_southbound_lane1_vehicles();
	level thread spawn_southbound_lane2_vehicles();
	
	level thread grab_sedan_and_van();
	
//	level thread spawn_hilo_front();
}

//avulaj
//
grab_sedan_and_van()
{
	sedan = getentarray ( "dest_v_sedan", "targetname" );
	van = getentarray ( "dest_v_van", "targetname" );
	for ( i = 0; i<sedan.size; i++ )
	{
		sedan[i].vehicletype = "sedan";
		sedan[i] thread maps\_vehicle::bond_veh_death();
		sedan[i] thread maps\_vehicle::bond_veh_flat_tire();
	}
	for ( i = 0; i<van.size; i++ )
	{
		van[i].vehicletype = "sedan";
		van[i] thread maps\_vehicle::bond_veh_death();
		van[i] thread maps\_vehicle::bond_veh_flat_tire();
	}
}



//avulaj
//
spawn_car_who_hits_guy()
{
	guy = getent ( "street_guy_hit_car", "targetname" );
	guy gun_remove();
	guy thread maps\sciencecenter_a_util::global_front_delete();
	trigger = getent ( "trigger_car_hit_guy", "targetname" );
	trigger waittill ( "trigger" );
	guy startpatrolroute ( "street_guy_node_01" );
	the_car = getent( "the_car", "targetname" );
	the_car.health = 10000;
	spawnvehicle( "v_sedan_silver_radiant", "car", "sedan", ( the_car.origin ), ( the_car.angles ));
	hit_guy_lane = getvehiclenode( "hit_guy_lane", "targetname" );
	vehicle = getent( "car", "targetname" );
	vehicle.health = 10000;

	vehicle.vehicletype = "sedan";
	vehicle.script_int = 1;
	maps\_vehicle::vehicle_init( vehicle );
	// bond_veh_running_lights creates headlights and breaklights fx
	//vehicle thread maps\_vehicle::bond_veh_running_lights();

	// bond_veh_exhaust creates exhaust fx
	//vehicle thread maps\_vehicle::bond_veh_exhaust();

	// bond_veh_exhauset crates the water splashes on a moving vehicle
	//vehicle thread maps\_vehicle::bond_veh_roadfx();	

	vehicle thread vehicle_play_sound_skid_trigger();
	vehicle attachpath( hit_guy_lane );
	vehicle startpath( hit_guy_lane );
	vehicle setspeed( 25, 25, 25 );
	// bond_veh_running_lights creates headlights and breaklights fx
	//vehicle thread maps\_vehicle::bond_veh_running_lights();
		
	// bond_veh_exhaust creates exhaust fx
	//vehicle thread maps\_vehicle::bond_veh_exhaust();
		
	// bond_veh_exhauset crates the water splashes on a moving vehicle
	//vehicle thread maps\_vehicle::bond_veh_roadfx();	
}

//avulaj
//self = the AI guy walking across the street
car_guy_meet()
{
	//this is the node that kicks off the skid sound then the honk
	node = getvehiclenode( "auto3234", "targetname" );
	the_car = getent( "the_car", "targetname" );
	hit_guy_lane2 = getvehiclenode( "hit_guy_lane2", "targetname" );
	vehicle = getent( "car", "targetname" );
//	pos = self.origin + ( 0, 0,64 );
//	color = ( 0, .5, 0 );            
//	scale = 1.5;       
//	Print3d( pos, "Hey, I'm walking here!", color, 1, scale, 120 );
	//TEMP uncomment once the sound allies has been created
	self CmdPlayAnim( "Civ_SC_CarNearHit", false );
	wait( 1 );
	self playsound( "SCJW_MiaG01A_012A", "convers_012A" ); //this plays//Hey I'm walking here.
	self waittill ( "convers_012A" );
	level thread traffic();
	vehicle waittill( "reached_end_node" );
	pos = vehicle.origin + ( 0, 0,80 );
	color = ( 0, .5, 0 );            
	scale = 1.5;       
//	Print3d( pos, "HONK!", color, 1, scale, 120 );
//	vehicle playsound ( "Auto_Skid_Stop" );
//	vehicle playsound ( "Auto_Horn_Blasts" );
	vehicle setspeed( 0, 25, 25 );
	if ( isdefined ( self ))
	{
		self stoppatrolroute();
		wait ( .5 );
		if ( isdefined ( self ))
		{
			self startpatrolroute ( "street_guy_node_02" );
		}
	}
	wait ( 3 );
	vehicle attachpath( hit_guy_lane2 );
	vehicle startpath( hit_guy_lane2 );
	vehicle setspeed( 25, 25, 25 );

	level thread spawn_eastbound_lane2_vehicles();
	vehicle thread delete_car_at_endnode();
}

//avulaj
//this plays a skid sound and a honk when the vehicle passes through the trigger
vehicle_play_sound_skid_trigger()
{
	trigger = getent ( "vehicle_play_sound_skid", "targetname" );
	trigger waittill ( "trigger" );

	self playsound ( "Auto_Skid_Stop" );
	wait ( 1.5 );
	self playsound ( "Auto_Horn_Blasts" );
}

//avulaj
//
//spawn_badguy_lane_vehicle()
//{
//	badguy_car = getent( "badguy_car", "targetname" );
//	spawnvehicle( "v_sedan_silver_radiant", "badguy", "sedan", ( badguy_car.origin ), ( badguy_car.angles ));
//	badguy_lane = getvehiclenode( "badguy_car_lane", "targetname" );
//	vehicle = getent( "badguy", "targetname" );
//	vehicle attachpath( badguy_lane );
//	vehicle startpath( badguy_lane );
//	vehicle setspeed( 65, 65, 65 );
//	wait( 2 );
//	level thread spawn_cop_lane_vehicle();
	
//	vehicle thread delete_car_at_endnode();
//}

//avulaj
//
spawn_cop_lane_vehicle()
{
	police_car = getent( "police_car", "targetname" );
	//spawnvehicle( "v_sedan_silver_radiant", "police", "sedan", ( police_car.origin ), ( police_car.angles ));
	vehicle = spawnvehicle( "v_sedan_police_radiant", "police", "sedan", ( police_car.origin ), ( police_car.angles ));
	cop_lane = getvehiclenode( "cop_car_lane", "targetname" );
	//vehicle = getent( "police", "targetname" );
	vehicle.health = 10000;
	vehicle.vehicletype = "sedan";
	vehicle.script_int = 1;
	maps\_vehicle::vehicle_init( vehicle );
	vehicle attachpath( cop_lane );
	vehicle startpath( cop_lane );
	// bond_veh_running_lights creates headlights and breaklights fx
	//vehicle thread maps\_vehicle::bond_veh_running_lights();
		
	// bond_veh_exhaust creates exhaust fx
	//vehicle thread maps\_vehicle::bond_veh_exhaust();
		
	// bond_veh_exhauset crates the water splashes on a moving vehicle
	//vehicle thread maps\_vehicle::bond_veh_roadfx();	
	while ( 1 )
	{
		wait( .5 );
		dist = Distance( level.player.origin, vehicle.origin );
		//iprintlnbold( dist );
		if  ( dist <= 1000 )
		{
			vehicle thread police_siren_play();
			vehicle setspeed( 60, 60, 60 );
			vehicle thread delete_car_at_endnode();
			break;
		}
	}
//	pos = vehicle.origin + ( 0, 0,64 );
//	color = ( 0, .5, 0 );            
//	scale = 1.5;       
//	Print3d( pos, "POLICE LIGHTS", color, 1, scale, 60 );
//	level thread traffic();
}

//avulaj
//
police_siren_play()
{
	self playsound ( "Police_Siren_QuickStart" );
	//wait ( 1 );
	self playloopsound ( "Police_Siren_Loop" );
}

//avulaj
//this spawns the traffic for the eastbound lane 3 & 4 once the cop and badguy have passed by
traffic()
{
	level thread spawn_eastbound_lane3_vehicles();
	level thread spawn_eastbound_lane4_vehicles();
}

//avulaj
//
mono_move_0()
{
	light_fx = loadfx ( "maps/MiamiScienceCenter/science_lightbeam05" );
	light_left = getent ( "mono_left_light_0", "targetname" );
	light_right = getent ( "mono_right_light_0", "targetname" );
	playfxontag ( light_fx, light_left, "tag_origin" );
	playfxontag ( light_fx, light_right, "tag_origin" );

	mono = getent ( "back_mono_e_mono_0", "targetname" );
	mono movey ( 8000, 10, 5 );
	light_left movey ( 8000, 10, 5 );
	light_right movey ( 8000, 10, 5 );
	mono playsound ( "elevated_train_horn" );
	wait( 1 );
	mono playloopsound ( "elevated_train_loop" );
	mono waittill ( "movedone" );
	mono delete();
	light_left delete();
	light_right delete();
}

//avulaj
//
mono_move()
{
	light_fx = loadfx ( "maps/MiamiScienceCenter/science_lightbeam05" );
	light_left = getent ( "mono_left_light", "targetname" );
	light_right = getent ( "mono_right_light", "targetname" );
	playfxontag ( light_fx, light_left, "tag_origin" );
	playfxontag ( light_fx, light_right, "tag_origin" );

	mono = getent ( "back_mono_e_mono", "targetname" );
	//iprintlnbold( "monorail" );
	wait( 8 );
	//iprintlnbold( "monorail GO" );
	while ( 1 )
	{
		mono movex ( -12000, 15, 5 );
		light_left movex ( -12000, 15, 5 );
		light_right movex ( -12000, 15, 5 );
		mono playloopsound ( "elevated_train_loop" );
		wait ( 15 );
		mono movex ( 12000, .1 );
		light_left movex ( 12000, .1 );
		light_right movex ( 12000, .1 );
		wait ( 60 );
	}
}

// spawn street vehicle functions
//spawn_hilo_front()
//{
//	front_heli_spawn_point = getent( "front_heli_spawn_point", "targetname" );
//	wait( 5 );
	
//	spawnvehicle("vehicle_blackhawk", "test_hilo", "blackhawk", (front_heli_spawn_point.origin), (front_heli_spawn_point.angles));
//	front_heli = getvehiclenode("front_heli", "targetname");
//	vehicle = getent( "test_hilo", "targetname" );
//	vehicle attachpath( front_heli );
//	vehicle startpath( front_heli );
//	vehicle setspeed(65, 65, 65);
	
//	vehicle thread delete_car_at_endnode();
//}

// spawn street vehicle functions
spawn_eastbound_lane1_vehicles()
{
	eastbound_lane1_spawnpoint = getent( "eastbound_lane1_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(16,18);
		
		//vehicle = undefined;
		//j = randomint( 3 );
		//wait( .05 );
		//if ( j == 0 )
		//{
			vehicle =  spawnvehicle("v_sedan_silver_radiant", "lane1_eastbound_vehicle" + i, "sedan", (eastbound_lane1_spawnpoint.origin), (eastbound_lane1_spawnpoint.angles));
		//}
		//else if ( j == 1 )
		//{
		//	vehicle =  spawnvehicle("v_sedan_silver_radiant", "lane1_eastbound_vehicle" + i, "sedan", (eastbound_lane1_spawnpoint.origin), (eastbound_lane1_spawnpoint.angles));
		//}
		//else if ( j == 2 )
		//{
		//	vehicle =  spawnvehicle("v_sedan_silver_radiant", "lane1_eastbound_vehicle" + i, "sedan", (eastbound_lane1_spawnpoint.origin), (eastbound_lane1_spawnpoint.angles));
		//}
		//else if ( j == 3 )
		//{
		//	vehicle =  spawnvehicle("v_sedan_silver_radiant", "lane1_eastbound_vehicle" + i, "sedan", (eastbound_lane1_spawnpoint.origin), (eastbound_lane1_spawnpoint.angles));
		//}
		level notify( "street_car_mist1" );
		vnode_east_lane1 = getvehiclenode("eastbound_num1_lane_traffic", "targetname");
		//vehicle = getent( "lane1_eastbound_vehicle" + i, "targetname" );
		//level thread maps\_vehicle::vehicle_init( vehicle );

		vehicle.vehicletype = "sedan";
		vehicle.script_int = 1;
		maps\_vehicle::vehicle_init( vehicle );
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();

		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();

		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	

		vehicle.health = 10000;
		vehicle attachpath(vnode_east_lane1);
		vehicle startpath(vnode_east_lane1);
		vehicle setspeed(25, 25, 25);

		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();
		
		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();
		
		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

// spawn street vehicle functions
spawn_eastbound_lane2_vehicles()
{
	eastbound_lane2_spawnpoint = getent( "eastbound_lane2_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(16,21);

		//vehicle = spawnvehicle("v_sedan_silver_radiant", "lane2_eastbound_vehicle" + i, "sedan", (eastbound_lane2_spawnpoint.origin), (eastbound_lane2_spawnpoint.angles));
		//vehicle = undefined;
		//j = randomint( 4 );
		//wait( .05 );
		//if ( j == 0 )
		//{
			vehicle =  spawnvehicle( "v_sedan_silver_radiant", "lane2_eastbound_vehicle" + i, "sedan", ( eastbound_lane2_spawnpoint.origin ), ( eastbound_lane2_spawnpoint.angles ));
		//}
		//else if ( j == 1 )
		//{
		//	vehicle =  spawnvehicle( "v_sedan_silver_radiant", "lane2_eastbound_vehicle" + i, "sedan", ( eastbound_lane2_spawnpoint.origin ), ( eastbound_lane2_spawnpoint.angles ));
		//}
		//else if ( j == 2 )
		//{
		//	vehicle =  spawnvehicle( "v_sedan_silver_radiant", "lane2_eastbound_vehicle" + i, "sedan", ( eastbound_lane2_spawnpoint.origin ), ( eastbound_lane2_spawnpoint.angles ));
		//}
		//else if ( j == 3 )
		//{
		//	vehicle =  spawnvehicle( "v_sedan_silver_radiant", "lane2_eastbound_vehicle" + i, "sedan", ( eastbound_lane2_spawnpoint.origin ), ( eastbound_lane2_spawnpoint.angles ));
		//}
		level notify( "street_car_mist1" );
		vnode_east_lane2 = getvehiclenode("eastbound_num2_lane_traffic", "targetname");
		//vehicle = getent( "lane2_eastbound_vehicle" + i, "targetname" );
		//level thread maps\_vehicle::vehicle_init( vehicle );
		vehicle.health = 10000;

		vehicle.vehicletype = "sedan";
		vehicle.script_int = 1;
		maps\_vehicle::vehicle_init( vehicle );
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();

		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();

		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	

		vehicle attachpath(vnode_east_lane2);
		vehicle startpath(vnode_east_lane2);
		vehicle setspeed(25, 25, 25);
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();
		
		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();
		
		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

spawn_eastbound_lane3_vehicles()
{
	eastbound_lane3_spawnpoint = getent( "eastbound_lane3_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(16,21);

		vehicle = spawnvehicle("v_sedan_silver_radiant", "lane3_eastbound_vehicle" + i, "sedan", (eastbound_lane3_spawnpoint.origin), (eastbound_lane3_spawnpoint.angles));
		level notify( "street_car_mist2" );
		vnode_east_lane3 = getvehiclenode("eastbound_num3_lane_traffic", "targetname");
		//vehicle = getent( "lane3_eastbound_vehicle" + i, "targetname" );
		//level thread maps\_vehicle::vehicle_init( vehicle );
		vehicle.health = 10000;

		vehicle.vehicletype = "sedan";
		maps\_vehicle::vehicle_init( vehicle );
		vehicle.script_int = 1;
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();

		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();

		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	

		vehicle attachpath(vnode_east_lane3);
		vehicle startpath(vnode_east_lane3);
		vehicle setspeed(35, 35, 35);
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();
		
		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();
		
		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

spawn_eastbound_lane4_vehicles()
{
	eastbound_lane4_spawnpoint = getent( "eastbound_lane4_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(18,23);

		vehicle = spawnvehicle("v_sedan_silver_radiant", "lane4_eastbound_vehicle" + i, "sedan", (eastbound_lane4_spawnpoint.origin), (eastbound_lane4_spawnpoint.angles));
		level notify( "street_car_mist2" );
		vnode_east_lane4 = getvehiclenode("eastbound_num4_lane_traffic", "targetname");
		//vehicle = getent( "lane4_eastbound_vehicle" + i, "targetname" );
		//level thread maps\_vehicle::vehicle_init( vehicle );
		vehicle.health = 10000;

		vehicle.vehicletype = "sedan";
		vehicle.script_int = 1;
		maps\_vehicle::vehicle_init( vehicle );
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();

		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();

		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	

		vehicle attachpath(vnode_east_lane4);
		vehicle startpath(vnode_east_lane4);
		vehicle setspeed(35, 35, 35);
		// bond_veh_running_lights creates headlights and breaklights fx
		//vehicle thread maps\_vehicle::bond_veh_running_lights();
		
		// bond_veh_exhaust creates exhaust fx
		//vehicle thread maps\_vehicle::bond_veh_exhaust();
		
		// bond_veh_exhauset crates the water splashes on a moving vehicle
		//vehicle thread maps\_vehicle::bond_veh_roadfx();	
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

//	delete car when it's at the end node.
delete_car_at_endnode()
{
	self waittill( "reached_end_node" );
	
	self delete();
	
}


// spawn street vehicle functions
spawn_northbound_lane1_vehicles()
{
	northbound_lane1_spawnpoint = getent( "northbound_lane1_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(14,16);

		spawnvehicle("v_sedan_silver_radiant", "lane1_northbound_vehicle" + i, "sedan", (northbound_lane1_spawnpoint.origin), (northbound_lane1_spawnpoint.angles));
		vnode_north_lane1 = getvehiclenode("northbound_num1_lane_traffic", "targetname");
		vehicle = getent( "lane1_northbound_vehicle" + i, "targetname" );
		vehicle.health = 10000;
		vehicle attachpath(vnode_north_lane1);
		vehicle startpath(vnode_north_lane1);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

// spawn street vehicle functions
spawn_northbound_lane2_vehicles()
{
	northbound_lane2_spawnpoint = getent( "northbound_lane2_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(14,16);

		spawnvehicle("v_sedan_silver_radiant", "lane2_northbound_vehicle" + i, "sedan", (northbound_lane2_spawnpoint.origin), (northbound_lane2_spawnpoint.angles));
		vnode_north_lane2 = getvehiclenode("northbound_num2_lane_traffic", "targetname");
		vehicle = getent( "lane2_northbound_vehicle" + i, "targetname" );
		vehicle.health = 10000;
		vehicle attachpath(vnode_north_lane2);
		vehicle startpath(vnode_north_lane2);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

// spawn street vehicle functions
spawn_southbound_lane1_vehicles()
{
	southbound_lane1_spawnpoint = getent( "southbound_lane1_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(14,16);

		spawnvehicle("v_sedan_silver_radiant", "lane1_southbound_vehicle" + i, "sedan", (southbound_lane1_spawnpoint.origin), (southbound_lane1_spawnpoint.angles));
		vnode_south_lane1 = getvehiclenode("southbound_num1_lane_traffic", "targetname");
		vehicle = getent( "lane1_southbound_vehicle" + i, "targetname" );
		vehicle.health = 10000;
		vehicle attachpath(vnode_south_lane1);
		vehicle startpath(vnode_south_lane1);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

// spawn street vehicle functions
spawn_southbound_lane2_vehicles()
{
	southbound_lane2_spawnpoint = getent( "southbound_lane2_spawnpoint", "targetname" );
	level endon( "catwalk" );
	i = 0;
	wait( 10 );
	
	level endon ( "enter_back_lot" );
	while(1)
	{
		random_spawn_time = randomintrange(14,16);

		spawnvehicle("v_sedan_silver_radiant", "lane2_southbound_vehicle" + i, "sedan", (southbound_lane2_spawnpoint.origin), (southbound_lane2_spawnpoint.angles));
		vnode_south_lane2 = getvehiclenode("southbound_num2_lane_traffic", "targetname");
		vehicle = getent( "lane2_southbound_vehicle" + i, "targetname" );
		vehicle.health = 10000;
		vehicle attachpath(vnode_south_lane2);
		vehicle startpath(vnode_south_lane2);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}



