// Test clientside script for see2

#include clientscripts\_utility;
#include clientscripts\_music;

main()
{

	// _load!
	clientscripts\_load::main();

	clientscripts\see2_fx::main();

//	thread clientscripts\_fx::fx_init(0);
	thread clientscripts\_audio::audio_init(0);

	thread clientscripts\see2_amb::main();

	clientscripts\_see2_panzeriv::main( "vehicle_ger_tracked_panzer4v1" );
	clientscripts\_see2_panther::main( "vehicle_ger_tracked_panther" );
	clientscripts\_see2_tiger::main( "vehicle_ger_tracked_king_tiger" );
	clientscripts\_see2_ot34::main( "vehicle_rus_tracked_ot34" );
	clientscripts\_see2_t34::main( "vehicle_rus_tracked_t34" );
	clientscripts\_truck::main( "vehicle_ger_wheeled_opel_blitz" );
	
	clientscripts\_vehicle::build_treadfx( "il2" );	// set up il2 for dust fx.
	
	// This needs to be called after all systems have been registered.
	thread waitforclient(0);
	
	thread event1_aaa_client();
	//thread client_distance_planes( "ev1_field_planes", "start_distance_planes_field_1" );
	thread client_field_planes( "ev1_field_planes", "start_distance_planes_field_1", 20, 15, 20 );
	thread client_field_planes( "ev1_field_blow_up_planes", "start_distance_planes_field_1", 50, 10, 20 );

	println("*** Client : see2 running...");
}

event1_aaa_client()
{
	level waittill ("aaa_begin");
	
	point1 = getent(0, "field_aaa_tracer_1","targetname");
	point2 = getent(0, "field_aaa_tracer_2","targetname");
	point3 = getent(0, "field_aaa_tracer_3","targetname");
	point4 = getent(0, "field_aaa_tracer_4","targetname");
	point5 = getent(0, "field_aaa_tracer_5","targetname");
	//point6 = getent(0, "event1_aaa_fx_point6","targetname");
	
			
	point1 thread event1_ambient_aaa_fx_think("end_field_fire");
	point1 thread event1_ambient_aaa_fx_rotate();
	wait 1.5;
	
	point2 thread event1_ambient_aaa_fx_think();
	point2 thread event1_ambient_aaa_fx_rotate();
	wait 1.5;
	point3 thread event1_ambient_aaa_fx_think();
	point3 thread event1_ambient_aaa_fx_rotate();	

	//thread aaa_flak(); -- TODO: PUT THIS BACK IN

	wait 1.5;	
	point4 thread event1_ambient_aaa_fx_think();
	point4 thread event1_ambient_aaa_fx_rotate();
	wait 1.5;	
	point5 thread event1_ambient_aaa_fx_think();
	point5 thread event1_ambient_aaa_fx_rotate();	
	
	//wait 1.5;
	//point6 thread event1_ambient_aaa_fx_think();
	//point6 thread event1_ambient_aaa_fx_rotate();		
}


event1_ambient_aaa_fx_think(endon_string)
{
	if (isdefined(endon_string))
	{
		level endon (endon_string);
	}
	
	while (1)
	{
		//if (!flag("ambients_on"))
		//{
		//	wait randomfloatrange(1, 4.0);
		//	continue;
		//}
			
		firetime = randomintrange (3, 8);
		
		for (i = 0; i < firetime * 5; i++)
		{
			playfx (0, level._effect["aaa_tracer"], self.origin, anglestoforward(self.angles ));
			// muzzle pop sound from gary
			playsound (0, "pacific_fake_fire", self.origin);
			wait 0.2;
		}
		wait randomintrange (1,3);
	}		
}

event1_ambient_aaa_fx_rotate()
{
	going_forward = true;
	
	while (1)
	{
			self rotateto((312.6, 180, -90), randomfloatrange (3.5,6));
			self waittill ("rotatedone");
			self rotateto((307.4, 1.7, 90), randomfloatrange(3.5,6));
			self waittill ("rotatedone");
	}
}


//-- Plane Stuff

client_distance_planes( str_structname, str_waittill )
{
	level endon( str_waittill + "_stop" );
	level waittill( str_waittill );
	
	
	plane_splines = GetStructArray( str_structname, "targetname" );
	
	while(1)
	{
		for( i = 0; i < plane_splines.size; i++ )
		{
			plane_splines[i] thread client_spawn_and_path_plane();
		}
		
		wait(5);
	}
}

client_field_planes( str_structname, str_waittill, spawn_percent, delay_min, delay_max )
{
	level endon( str_waittill + "_stop" );
	level waittill( str_waittill );

	plane_splines = GetStructArray( str_structname, "targetname" );
	players = getlocalplayers();
	
	planes_max = 5;
	planes_spawned = 0;
	
	//-- ambient planes that just constantly fly
	while(1)
	{
		for( j = 0; j < plane_splines.size && planes_spawned < planes_max; j++ )
		{
			random_spawn = RandomIntRange(0, 100);
			
			if(random_spawn < spawn_percent)
			{
				for( i = 0; i < players.size; i++ )
				{
					plane_splines[j] thread client_spawn_and_path_plane( i );
				}
				
				planes_spawned++;
			}
		}
	
		planes_spawned = 0;
		random_wait = RandomIntRange(delay_min, delay_max);
		realwait( random_wait );
	}
}

///////////////////////////////////////////////////////////////////////////////
//
// 									**** client_spawn_and_path_plane ***
//
// The first script struct must have:
//      - struct.SCRIPT_STRING (string) - this is what model needs to be spawned
//			- struct.SCRIPT_DELAY  (float)  - this is the time it takes to move from 1 node to the next
//      - struct.TARGETNAME    (string) - you know, so you can grab the struct
//      - struct.TARGET        (string) - the next node, if there is no target then the plane will delete itself
//
////////////////////////////////////////////////////////////////////////////////

removefakeentonsaverestore(client, fake, endon_string)
{
	self endon(endon_string);
	level waittill("save_restore");
	
	println("Deleting fake ent " + fake + " for client " + client);
	
	deletefakeent(client, fake);
}

plane_sound_thread(client_num, plane)
{
	if(client_num != 0)
		return;

	level endon("save_restore");
	
	fake = spawnfakeent(client_num);

	//plane thread removefakeentonsaverestore(0, fake, "sound_done");
	
	setfakeentorg(client_num, fake, plane.origin);
	playLoopSound(client_num, fake, "amb_planes",1);
	
	while(isdefined(plane) && isdefined(fake))
	{
		setfakeentorg(client_num, fake, plane.origin);
		wait(.01);
	}
	
	println("plane sound thread ending.");
	plane notify("sound_done");
	deletefakeent(0,fake);
}

delete_plane_on_save_restore()
{
	self endon("plane done");
	level waittill("save_restore");
	
	println("Deleting plane.");
	
	self delete();
}

client_spawn_and_path_plane( client_num )
{
	level endon("save_restore");
	_trans_time = self.script_delay;
	_modelname = self.script_string;
	
	if( !IsDefined(client_num) )
	{
		client_num = 0;
	}
	
	plane = Spawn( client_num, self.origin, "script_model" );
	plane thread delete_plane_on_save_restore();
	plane SetModel( _modelname );
	//plane.angles = self.angles;
	plane RotateTo( self.angles, 0.05 );
	wait(0.05);
	
	thread plane_sound_thread(client_num,plane);
	
	plane.current_node = self;
	current_node = self;
	next_node = self;
	
	while( IsDefined( current_node.target ) )
	{
		next_node = GetStruct( current_node.target, "targetname" );
		
		plane MoveTo( next_node.origin, _trans_time );
		plane RotateTo( next_node.angles, _trans_time );
		//wait( _trans_time - 0.05 ); //-- to prevent single frame hitch
		realWait( _trans_time - 0.05 );
		
		/////////////////////////////////////////////////////////////////////////////////////////////
		//-- Behaviors that can occur at this node
		//
		//  - "blow_up", just blow up the plane with an fx
		//  - "fire_rocket", use a script struct system to fire rockets and have them explode on the ground
		//  
		//Note: If you don't want any of this behaviour, then just comment it out
		/////////////////////////////////////////////////////////////////////////////////////////////
		
		if(IsDefined( current_node.script_noteworthy ))
		{
			plane_action = current_node.script_noteworthy;
			
			if( plane_action == "blow_up" )
			{
				blow_up_chance = RandomIntRange(0, 100);
				
				if( blow_up_chance < current_node.script_int )
				{
					PlayFX( client_num, level._effect[current_node.script_string], plane.origin );
					plane Delete();
					return;
				}
			}
			
			if( plane_action == "fire_rocket" )
			{
				plane thread client_plane_fire_rocket( client_num );		
			}
		}
		
		current_node = next_node;
		plane.current_node = current_node;
	}

	plane notify("plane done");

	plane Delete();
}

delete_rocket_on_saverestore()
{
	self endon("rocket done");
	level waittill("save_restore");
	
	println("Deleting rocket.");
	
	self delete();
}

client_plane_fire_rocket(client_num)
{
	self endon("save_restore");
	start_pos = self.origin;
	end_pos_struct = GetStruct( self.current_node.script_string, "targetname" );
	end_pos = end_pos_struct.origin;
	
	rocket = spawn(client_num, self.origin, "script_model" );
	
	rocket thread delete_rocket_on_saverestore();
	
	rocket.angles = self.angles;
	rocket setmodel("katyusha_rocket");
	
	angles = VectorToAngles( end_pos - start_pos );
	rocket.angles = angles;
	distance = distance( start_pos, end_pos );
	time = distance/4200;
	
	rocket thread client_rocket_trail( client_num );
	rocket MoveTo( end_pos, time );
	
	realWait(time);
	
	playfx( client_num, level._effect["pc132_explode"], rocket.origin ); //-- impact FX
	
	rocket notify( "rocket done" );
	rocket Delete();
}

client_rocket_trail( client_num )
{
	self endon( "rocket done" );
	level endon( "save_restore" );
	
	while(1)
	{
		PlayFX( client_num, level._effect["client_rocket_trail"], self.origin );
		realWait(0.1);
	}
}