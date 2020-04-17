#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

////////////////////////////////////////////////////////////////////////////////////
//                    SCIENCE CENTER A VEHICLES                
////////////////////////////////////////////////////////////////////////////////////
main()
{
	if((Getdvar( "skipto" ) == "2" ) || (Getdvar( "skipto" ) == "3" ) || (Getdvar( "skipto" ) == "4" ))
	{
		return;
	}

	level thread spawn_eastbound_lane1_vehicles();// main street
	level thread spawn_eastbound_lane2_vehicles();// main street
	level thread spawn_eastbound_lane3_vehicles();// main street
	level thread spawn_eastbound_lane4_vehicles();// main street

	
	level thread spawn_northbound_lane1_vehicles();// distant freeway
	level thread spawn_northbound_lane2_vehicles();// distant freeway

	level thread spawn_southbound_lane1_vehicles();// distant freeway
	level thread spawn_southbound_lane2_vehicles();// distant freeway
	

}

////////////////////////////////////////////////////////////////////////////////////
//                    NEAR STREET VEHICLES                
////////////////////////////////////////////////////////////////////////////////////

spawn_eastbound_lane1_vehicles()
{
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );
	
	eastbound_lane1_spawnpoint = getent( "eastbound_lane1_spawnpoint", "targetname" );
	vnode_east_lane1 = getvehiclenode("eastbound_num1_lane_traffic", "targetname");

	i = 0;
	wait( randomfloatrange( 10.0, 20.0 ) );
	
	while(1)
	{
		random_spawn_time = randomintrange(20,40);
	
		vmodel = random_vehicle_type();
		vehicle = spawnVehicle( vmodel.model, "lane1_eastbound_vehicle" + i, vmodel.vtype, (eastbound_lane1_spawnpoint.origin), (eastbound_lane1_spawnpoint.angles));
		if(IsDefined(vehicle))
		{
			level.spawn_count++;
			vehicle.vehicletype = vmodel.vtype;
			if (IsDefined(vmodel.script_noteworthy) && (vmodel.script_noteworthy == "police_car"))
			{
				vehicle thread police_car_fx();
			}
			else
			{
				vehicle thread setup_car_driver();
				wait(0.25);
			}

			level notify( "street_car_mist1" );
			vehicle.script_int = 1;
			maps\_vehicle::vehicle_init( vehicle );

			vehicle thread vehicle_track_health();
			vehicle attachpath(vnode_east_lane1);
			vehicle startpath(vnode_east_lane1);
			vehicle setspeed(25, 25, 25);
	
			vehicle thread delete_car_at_endnode();
		}
		i++;
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
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );
	
	eastbound_lane2_spawnpoint = getent( "eastbound_lane2_spawnpoint", "targetname" );
	vnode_east_lane2 = getvehiclenode("eastbound_num2_lane_traffic", "targetname");

	i = 0;
	wait( randomfloatrange( 10.0, 20.0 ) );
	
	while(1)
	{
		random_spawn_time = randomintrange(25,50);
	
		vmodel = random_vehicle_type();
		vehicle = spawnVehicle( vmodel.model, "lane2_eastbound_vehicle" + i, vmodel.vtype, (eastbound_lane2_spawnpoint.origin), (eastbound_lane2_spawnpoint.angles));
		if(IsDefined(vehicle))
		{
			level.spawn_count++;
			vehicle.vehicletype = vmodel.vtype;
			if (IsDefined(vmodel.script_noteworthy) && (vmodel.script_noteworthy == "police_car"))
			{
				vehicle thread police_car_fx();
			}	
			else
			{
				vehicle thread setup_car_driver();
				wait(0.25);
			}

			level notify( "street_car_mist1" );
			vehicle.script_int = 1;
			maps\_vehicle::vehicle_init( vehicle );

			vehicle thread vehicle_track_health();
			vehicle attachpath(vnode_east_lane2);
			vehicle startpath(vnode_east_lane2);
			vehicle setspeed(25, 25, 25);
	
			vehicle thread delete_car_at_endnode();
		}
		i++;
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

spawn_eastbound_lane3_vehicles()
{
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );
	
	eastbound_lane3_spawnpoint = getent( "eastbound_lane3_spawnpoint", "targetname" );
	vnode_east_lane3 = getvehiclenode("eastbound_num3_lane_traffic", "targetname");

	i = 0;
	wait( randomfloatrange( 10.0, 20.0 ) );
	
	while(1)
	{
		random_spawn_time = randomintrange(25,50);
	
		vmodel = random_vehicle_type();
		vehicle = spawnVehicle( vmodel.model, "lane3_eastbound_vehicle" + i, vmodel.vtype, (eastbound_lane3_spawnpoint.origin), (eastbound_lane3_spawnpoint.angles));
		if(IsDefined(vehicle))
		{
			level.spawn_count++;
			vehicle.vehicletype = vmodel.vtype;
			if (IsDefined(vmodel.script_noteworthy) && (vmodel.script_noteworthy == "police_car"))
			{
				vehicle thread police_car_fx();
			}	
			else
			{
				vehicle thread setup_car_driver();
				wait(0.25);
			}

			level notify( "street_car_mist1" );
			vehicle.script_int = 1;
			maps\_vehicle::vehicle_init( vehicle );

			vehicle thread vehicle_track_health();
			vehicle attachpath(vnode_east_lane3);
			vehicle startpath(vnode_east_lane3);
			vehicle setspeed(25, 25, 25);
	
			vehicle thread delete_car_at_endnode();
		}
		i++;
		wait( random_spawn_time );
		
		if( i == 10 )
		{
			i = 0;
		}
	}
}

spawn_eastbound_lane4_vehicles()
{
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );
	
	eastbound_lane4_spawnpoint = getent( "eastbound_lane4_spawnpoint", "targetname" );
	vnode_east_lane4 = getvehiclenode("eastbound_num4_lane_traffic", "targetname");

	i = 0;
	wait( randomfloatrange( 10.0, 20.0 ) );
	
	while(1)
	{
		random_spawn_time = randomintrange(25,50);
	
		vmodel = random_vehicle_type();
		vehicle = spawnVehicle( vmodel.model, "lane4_eastbound_vehicle" + i, vmodel.vtype, (eastbound_lane4_spawnpoint.origin), (eastbound_lane4_spawnpoint.angles));
		if(IsDefined(vehicle))
		{	
			level.spawn_count++;
			vehicle.vehicletype = vmodel.vtype;
			if (IsDefined(vmodel.script_noteworthy) && (vmodel.script_noteworthy == "police_car"))
			{
				vehicle thread police_car_fx();
			}	
			else
			{
				vehicle thread setup_car_driver();
				wait(0.25);
			}

			level notify( "street_car_mist1" );
			vehicle.script_int = 1;
			maps\_vehicle::vehicle_init( vehicle );

			vehicle thread vehicle_track_health();
			vehicle attachpath(vnode_east_lane4);
			vehicle startpath(vnode_east_lane4);
			vehicle setspeed(25, 25, 25);
	
			vehicle thread delete_car_at_endnode();
		}
		i++;
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
	self delete_car_cutscene();
	self waittill( "reached_end_node" );
	
	self delete();
	level.spawn_deleted++;
}
// DCS: delete existing cars for cinematic.
delete_car_cutscene()
{
	self endon("reached_end_node");
	
	level waittill("delete_current_traffic");
	self delete();
	level.spawn_deleted++;
}	

police_car_fx()
{
	self endon("reached_end_node");
	level endon("delete_current_traffic");
	
	while (IsDefined(self))
	{
		wait( .5 );
		dist = Distance( level.player.origin, self.origin );
		if  ( dist <= 1000 )
		{
			if(IsDefined(self))
			{
				self thread police_siren_play();
			}
			break;
		}
	}
}

//avulaj
//
police_siren_play()
{
	self playsound ( "Police_Siren_QuickStart" );
	self playloopsound ( "Police_Siren_Loop" );
}

#using_animtree("generic_human");
setup_car_driver()
{
	driver = Spawn( "script_model", self GetTagOrigin( "tag_driver" ) );
	driver.angles = self.angles;
	driver character\character_tourist_1::main();
	driver LinkTo( self, "tag_driver" );
	
//	passenger = Spawn( "script_model", self GetTagOrigin( "tag_passenger01" ) );
//	passenger.angles = self.angles;
//	passenger character\character_tourist_1::main();
//	passenger LinkTo( self, "tag_passenger01" );
	
	// play anims
	driver useAnimTree(#animtree);
	driver setFlaggedAnimKnobRestart("idle", %vehicle_driver);
//	passenger useAnimTree(#animtree);
//	passenger setFlaggedAnimKnobRestart("idle", %vehicle_passenger);
	
	// delete at end node.
	self thread delete_driver_cutscene(driver);
	self waittill("reached_end_node");
	driver delete();
//	passenger delete();

}
delete_driver_cutscene(driver)
{
	self endon("reached_end_node");
	
	level waittill("delete_current_traffic");
	driver delete();
}	

vehicle_track_health()
{
	self endon("reached_end_node");
	self.health = 10000;
	
	while(IsDefined(self))
	{	
		self waittill("damage", amount, attacker);
		if(attacker == level.player)
		{
			self setspeed(50, 60, 25);
			self playsound("van_peel_out");

			wait(1.0);
			missionfailedwrapper();
			return;
		}	
		wait(0.1);
	}	
}		
////////////////////////////////////////////////////////////////////////////////////
//                    FAR FREEWAY VEHICLES                
////////////////////////////////////////////////////////////////////////////////////

// spawn street vehicle functions
spawn_northbound_lane1_vehicles()
{
	northbound_lane1_spawnpoint = getent( "northbound_lane1_spawnpoint", "targetname" );
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );

	i = 0;
	wait( 10 );
	
	while(i <= 50)
	{
		if( i >= 30 )
		{
			random_spawn_time = randomintrange(120,180);
		}
		else
		{
			random_spawn_time = randomintrange(45,60);
		}	
		

		spawnvehicle("v_sedan_us_silver_radiant", "lane1_northbound_vehicle" + i, "sedan", (northbound_lane1_spawnpoint.origin), (northbound_lane1_spawnpoint.angles));
		level.spawn_count++;
		vnode_north_lane1 = getvehiclenode("northbound_num1_lane_traffic", "targetname");
		vehicle = getent( "lane1_northbound_vehicle" + i, "targetname" );

		vehicle.script_int = 1;
		vehicle.health = 10000;
		vehicle attachpath(vnode_north_lane1);
		vehicle startpath(vnode_north_lane1);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );
		
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
	while(i <= 50)
	{
		if( i >= 30 )
		{
			random_spawn_time = randomintrange(120,180);
		}
		else
		{
			random_spawn_time = randomintrange(45,60);
		}	
		
		spawnvehicle("v_sedan_us_silver_radiant", "lane2_northbound_vehicle" + i, "sedan", (northbound_lane2_spawnpoint.origin), (northbound_lane2_spawnpoint.angles));
		level.spawn_count++;
		vnode_north_lane2 = getvehiclenode("northbound_num2_lane_traffic", "targetname");
		vehicle = getent( "lane2_northbound_vehicle" + i, "targetname" );

		vehicle.script_int = 1;
		vehicle.health = 10000;
		vehicle attachpath(vnode_north_lane2);
		vehicle startpath(vnode_north_lane2);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );

	}
}

// spawn street vehicle functions
spawn_southbound_lane1_vehicles()
{
	southbound_lane1_spawnpoint = getent( "southbound_lane1_spawnpoint", "targetname" );
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );

	i = 0;
	wait( 10 );
	
	while(i <= 50)
	{
		if( i >= 30 )
		{
			random_spawn_time = randomintrange(120,180);
		}
		else
		{
			random_spawn_time = randomintrange(45,60);
		}	
		
		spawnvehicle("v_sedan_us_silver_radiant", "lane1_southbound_vehicle" + i, "sedan", (southbound_lane1_spawnpoint.origin), (southbound_lane1_spawnpoint.angles));
		level.spawn_count++;
		vnode_south_lane1 = getvehiclenode("southbound_num1_lane_traffic", "targetname");
		vehicle = getent( "lane1_southbound_vehicle" + i, "targetname" );

		vehicle.script_int = 1;
		vehicle.health = 10000;
		vehicle attachpath(vnode_south_lane1);
		vehicle startpath(vnode_south_lane1);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );

	}
}

// spawn street vehicle functions
spawn_southbound_lane2_vehicles()
{
	southbound_lane2_spawnpoint = getent( "southbound_lane2_spawnpoint", "targetname" );
	level endon( "catwalk" );
	level endon ( "enter_back_lot" );

	i = 0;
	wait( 10 );
	
	while(i <= 50)
	{
		if( i >= 30 )
		{
			random_spawn_time = randomintrange(120,180);
		}
		else
		{
			random_spawn_time = randomintrange(45,60);
		}	
		
		spawnvehicle("v_sedan_us_silver_radiant", "lane2_southbound_vehicle" + i, "sedan", (southbound_lane2_spawnpoint.origin), (southbound_lane2_spawnpoint.angles));
		level.spawn_count++;
		vnode_south_lane2 = getvehiclenode("southbound_num2_lane_traffic", "targetname");
		vehicle = getent( "lane2_southbound_vehicle" + i, "targetname" );

		vehicle.script_int = 1;
		vehicle.health = 10000;
		vehicle attachpath(vnode_south_lane2);
		vehicle startpath(vnode_south_lane2);
		vehicle setspeed(25, 25, 25);
		i++;
		
		vehicle thread delete_car_at_endnode();
		
		wait( random_spawn_time );

	}
}

////////////////////////////////////////////////////////////////////////////////////
//                    VEHICLE TYPE RANDOMIZER                
////////////////////////////////////////////////////////////////////////////////////
// DCS
random_vehicle_type()
{

	vmodels	= [];

	vmodels[0]		  = spawnstruct();
	vmodels[0].model = "v_sedan_us_silver_radiant";
	vmodels[0].vtype = "sedan";

	vmodels[1]		  = spawnstruct();
	vmodels[1].model = "v_sedan_us_blue_radiant";
	vmodels[1].vtype = "sedan";

	vmodels[2]		  = spawnstruct();
	vmodels[2].model = "v_sedan_us_gunmetal_radiant";
	vmodels[2].vtype = "sedan";
	
	vmodels[3]		  = spawnstruct();
	vmodels[3].model = "v_van_white_rain_radiant";
	vmodels[3].vtype = "van";	
	
	vmodels[4]		  = spawnstruct();
	vmodels[4].model = "v_sedan_police_radiant";
	vmodels[4].vtype = "sedan";	
	vmodels[4].script_noteworthy = "police_car";
	

// commenting out suv's, no taillight tag.

	vmodels[5]		  = spawnstruct();
	vmodels[5].model = "v_suv_us_gunmetal_radiant";
	vmodels[5].vtype = "suv";

	vmodels[6]		  = spawnstruct();
	vmodels[6].model = "v_suv_us_red_radiant";
	vmodels[6].vtype = "suv";	
		
	vmodels[7]		  = spawnstruct();
	vmodels[7].model = "v_suv_us_blue_radiant";
	vmodels[7].vtype = "suv";

	vmodel	= vmodels[ RandomInt( vmodels.size ) ];

	return vmodel;
}

////////////////////////////////////////////////////////////////////////////////////
//                    MONORAILS                
////////////////////////////////////////////////////////////////////////////////////
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
	wait( 8 );
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
////////////////////////////////////////////////////////////////////////////////////