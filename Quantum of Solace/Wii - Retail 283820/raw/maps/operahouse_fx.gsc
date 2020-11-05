#include maps\_utility;

main()
{
	precacheFX();
	maps\createfx\operahouse_fx::main();

	initFXModelAnims();

	
	level thread maps\_fx::quick_kill_fx_on();
	
	level thread wait_animate_siren();
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_stage_fall", "targetname" );
	
	ent_array1 = getentarray( "fxanim_big_buoy_01", "targetname" );
	ent_array2 = getentarray( "fxanim_big_buoy_02", "targetname" );
	ent_array3 = getentarray( "fxanim_sm_buoy_01", "targetname" );
	ent_array4 = getentarray( "fxanim_sm_buoy_02", "targetname" );
	ent_array5 = getentarray( "fxanim_sm_buoy_03", "targetname" );
	ent_array6 = getentarray( "fxanim_sm_buoy_04", "targetname" );
	ent_array7 = getentarray( "fxanim_thick_rope_01", "targetname" );
	ent_array8 = getentarray( "fxanim_thick_rope_02", "targetname" );
	ent_array9 = getentarray( "fxanim_boat", "targetname" );
	
	if (IsDefined(ent1))
	{ 
		ent1 thread stage_fall_1(); println("************* FX: stage_fall_1 *************"); 
		ent1 thread init_stage_lights();
	}
	
	if (IsDefined(ent_array1)) { ent_array1 thread big_buoy_01();   println("************* FX: big_buoy_01 *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread big_buoy_02();   println("************* FX: big_buoy_02 *************"); }
	if (IsDefined(ent_array3)) { ent_array3 thread sm_buoy_01();   println("************* FX: sm_buoy_01 *************"); }
	if (IsDefined(ent_array4)) { ent_array4 thread sm_buoy_02();   println("************* FX: sm_buoy_02 *************"); }
	if (IsDefined(ent_array5)) { ent_array5 thread sm_buoy_03();   println("************* FX: sm_buoy_03 *************"); }
	if (IsDefined(ent_array6)) { ent_array6 thread sm_buoy_04();   println("************* FX: sm_buoy_04 *************"); }
	if (IsDefined(ent_array7)) { ent_array7 thread thick_rope_01();   println("************* FX: thick_rope_01 *************"); }
	if (IsDefined(ent_array8)) { ent_array8 thread thick_rope_02();   println("************* FX: thick_rope_02 *************"); }
	if (IsDefined(ent_array9)) { array_thread ( ent_array9, ::rowboat ) ;   println("************* FX: rowboat *************"); }
}

#using_animtree("fxanim_stage_fall_1");
stage_fall_1()
{
	level waittill("stage_fall_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_stage_fall_1", self.origin, self.angles, %fxanim_stage_fall_1);
	
	
	self link_effect_to_ent("opera_stage_sparks_r", "stage_jnt", (-100,1100,720), (90,0,0));
	self link_effect_to_ent("opera_stage_sparks_r", "stage_jnt", (-50,-350,600), (90,0,0));
	
	level waittill("stage_fall_2_start");
	self stopanimscripted();
	self stopuseanimtree();
	stage_fall_2();
}

link_effect_to_ent( effectID, bone, offset, angle )
{
	ent_tag = Spawn( "script_model", self.origin );
	ent_tag SetModel( "tag_origin" );
	PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
	ent_tag.angles = self.angles;
	ent_tag LinkTo( self, bone, offset, angle );

}

#using_animtree("fxanim_stage_fall_2");
stage_fall_2()
{
	self UseAnimTree(#animtree);
	self animscripted("a_stage_fall_2", self.origin, self.angles, %fxanim_stage_fall_2);
}


#using_animtree("vehicles");
boat_crash()
{
	self UseAnimTree(#animtree);
	self animscripted("a_fxanim_boat_crash", self.origin, self.angles, %fxanim_boat_crash);
	
	if (animhasnotetrack(%fxanim_boat_crash, "boat_wake"))
	{
		self thread fx_boat_trail();
		self waittillmatch("a_fxanim_boat_crash", "boat_wake"); 
		self link_effect_to_ent("opera_boat_splash", "tag_body", (400,200,-60), (-90,0,0)); 
				
		self waittillmatch("a_fxanim_boat_crash", "dock_impact_1"); 
		self link_effect_to_ent("opera_boat_sparks", "tag_body", (250,140,100), (-90,0,0));
		self link_effect_to_ent("opera_boat_sparks2", "tag_body", (-250,140,100), (-90,0,0));
		level notify("fx_dock_smash");
		
		self waittillmatch("a_fxanim_boat_crash", "dock_impact_2"); 
	}	
}

fx_boat_trail()
{

	loop_count = 0;
	
	while (loop_count < 46)
	{
		
		

		wait(0.1);
		loop_count++;
	}
}

#using_animtree("vehicles");
boat_depart()
{
	self UseAnimTree(#animtree);
	self animscripted("a_v_boat_depart_1", self.origin, self.angles, %v_boat_depart_1);
}

#using_animtree("fxanim_big_buoy_01");
big_buoy_01()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_big_buoy_01", self[i].origin, self[i].angles, %fxanim_big_buoy_01);
		wait(randomfloatrange(0.5,1.5));
		self[i] link_effect_to_ent("opera_buoy_light", "large_buoy_jnt", (0,3.6,60), (0,0,0));
	}
}

#using_animtree("fxanim_big_buoy_02");
big_buoy_02()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_big_buoy_02", self[i].origin, self[i].angles, %fxanim_big_buoy_02);
		wait(randomfloatrange(0.5,1.5));
		self[i] link_effect_to_ent("opera_buoy_light", "large_buoy_jnt", (0,3.6,60), (0,0,0));
	}
}

#using_animtree("fxanim_sm_buoy_01");
sm_buoy_01()
{
	wait(randomfloatrange(0.5,2.5));
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_sm_buoy_01", self[i].origin, self[i].angles, %fxanim_sm_buoy_01);
	}
}

#using_animtree("fxanim_sm_buoy_02");
sm_buoy_02()
{
	wait(randomfloatrange(0.5,2.5));
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_sm_buoy_02", self[i].origin, self[i].angles, %fxanim_sm_buoy_02);
	}
}

#using_animtree("fxanim_sm_buoy_03");
sm_buoy_03()
{
	wait(randomfloatrange(0.5,2.5));
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_sm_buoy_03", self[i].origin, self[i].angles, %fxanim_sm_buoy_03);
	}
}

#using_animtree("fxanim_sm_buoy_04");
sm_buoy_04()
{
	wait(randomfloatrange(0.5,2.5));
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_sm_buoy_04", self[i].origin, self[i].angles, %fxanim_sm_buoy_04);
	}
}

#using_animtree("fxanim_thick_rope_01");
thick_rope_01()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_thick_rope_01", self[i].origin, self[i].angles, %fxanim_thick_rope_01);
	}
}

#using_animtree("fxanim_thick_rope_02");
thick_rope_02()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_thick_rope_02", self[i].origin, self[i].angles, %fxanim_thick_rope_02);
	}
}



#using_animtree("vehicles");
rowboat( )
{
	if ( IsDefined( self.target ) )
	{
		tarp = GetEnt( self.target, "targetname" );
		tarp LinkTo( self, "tag_body" );
	}

	self UseAnimTree(#animtree);
	self animscripted("a_v_boat_float", self.origin, self.angles, %v_boat_float);
}


precacheFX()
{
	
	level._effect["light_green"]		= Loadfx ("misc/camera_green");
	level._effect["light_red_solid"]	= Loadfx ("misc/camera_red_solid");
	level._effect["spark"]				= Loadfx ("props/electric_box" );
	
	level._effect["tank_explosion"]		= loadfx ("props/welding_exp");
	level._effect["cloud_bank"]			= loadfx ("weather/cloud_bank");
	level._effect["cloud_bank_a"]		= loadfx ("weather/cloud_bank_a");
	level._effect["bigbang"]			= loadfx ("props/welding_exp");
	
	level._effect["opera_large_fire"]			= loadfx ("maps/operahouse/opera_large_fire");
	level._effect["opera_confetti1"]			= loadfx ("maps/operahouse/opera_confetti1");
	level._effect["opera_stage_light_blue"]		= loadfx ("maps/operahouse/opera_stage_light_blue");
	
	level._effect["opera_stage_light_blue2"]	= loadfx ("maps/operahouse/opera_stage_light_blue");
	level._effect["opera_stage_light_green"]	= loadfx ("maps/operahouse/opera_stage_light_green");
	level._effect["opera_stage_light_red"]		= loadfx ("maps/operahouse/opera_stage_light_red");
	level._effect["opera_stage_light_purple"]	= loadfx ("maps/operahouse/opera_stage_light_red");
	level._effect["opera_stage_fog"]			= loadfx ("maps/operahouse/opera_stage_fog");
	level._effect["opera_understage_fog1"]		= loadfx ("maps/operahouse/opera_understage_fog1");
	level._effect["opera_understage_fog2"]		= loadfx ("maps/operahouse/opera_understage_fog2");
	level._effect["opera_stage_sparks_r"]		= loadfx ("maps/operahouse/opera_stage_sparks_r");
	level._effect["opera_buoy_light"]			= loadfx ("maps/operahouse/opera_buoy_light");
	level._effect["opera_pierlight_vol"]		= loadfx ("maps/operahouse/opera_pierlight_vol");
	level._effect["opera_floodlight_vol1"]		= loadfx ("maps/operahouse/opera_floodlight_vol1");
	level._effect["opera_floodlight_vol2"]		= loadfx ("maps/operahouse/opera_floodlight_vol2");
	level._effect["opera_floodlight_vol3"]		= loadfx ("maps/operahouse/opera_floodlight_vol3");
	level._effect["opera_redlight_vol"]			= loadfx ("maps/operahouse/opera_redlight_vol");
	level._effect["opera_warmlight_vol"]		= loadfx ("maps/operahouse/opera_warmlight_vol");
	level._effect["opera_water_splash1"]		= loadfx ("maps/operahouse/opera_water_splash1");
	level._effect["opera_water_splash2"]		= loadfx ("maps/operahouse/opera_water_splash2");
	level._effect["opera_siren_light"]			= loadfx ("maps/operahouse/opera_siren_light");
	level._effect["opera_siren_light_blink"]	= loadfx ("maps/operahouse/opera_siren_light_blink");
	level._effect["opera_firelight"]			= loadfx ("maps/operahouse/opera_firelight");
	level._effect["opera_fluorescent_lamp1"]	= loadfx ("maps/operahouse/opera_fluorescent_lamp1");
	level._effect["opera_fluorescent_lamp2"]	= loadfx ("maps/operahouse/opera_fluorescent_lamp2");
	level._effect["opera_spotlight1"]			= loadfx ("maps/operahouse/opera_spotlight1");
	level._effect["opera_spotlight2"]			= loadfx ("maps/operahouse/opera_spotlight2");
	level._effect["opera_work_light_vol"] 		= loadfx ("maps/operahouse/opera_worklight_vol");
	level._effect["opera_pipe_steam1"] 			= loadfx ("maps/operahouse/opera_pipe_steam1");
	level._effect["opera_pipe_steam2"] 			= loadfx ("maps/operahouse/opera_pipe_steam2");
	level._effect["opera_water_fog1"] 			= loadfx ("maps/operahouse/opera_water_fog1");
	
	
	level._effect["vehicle_night_headlight02"]	 	= loadfx ("vehicles/night/vehicle_night_headlight02");
	level._effect["vehicle_night_taillight"]	 	= loadfx ("vehicles/night/vehicle_night_taillight");
	
	
	
	level._effect["opera_boat_splash"] 			= loadfx ("maps/operahouse/opera_boat_splash2");
	level._effect["opera_dock_smash"] 			= loadfx ("maps/operahouse/opera_dock_smash");
	level._effect["opera_boat_sparks"] 			= loadfx ("maps/operahouse/opera_boat_sparks");
	level._effect["opera_boat_sparks2"] 		= loadfx ("maps/operahouse/opera_boat_sparks2");
	
}

wait_animate_siren()
{
	level waittill("fx_siren_start");
	level rotate_effect("opera_siren_light", (5241.82,-596.251,-117.515), (90,90,0), 3);
}

rotate_effect(effect, start_origin, start_angle, anim_time)
{
	
	
	ent_tag = undefined;
	ent_tag = Spawn("script_model", start_origin);
	ent_tag SetModel("tag_origin");
	ent_tag.angles = start_angle;
		
	PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
	
	
	level thread kill_siren_fx(ent_tag);
	
	while(IsDefined(ent_tag))
	{
		ent_tag rotatevelocity( ( 300,0,0 ), anim_time );
		wait(anim_time);
	}
}

kill_siren_fx(ent_tag)
{
	level waittill("fx_siren_stop");
	ent_tag delete();
}



createLinkedEffect( origin, angles, fxid, link_tag  )
{
	ent = Spawn( "script_model", origin );
	ent SetModel( "tag_origin" );
	PlayFXOnTag ( level._effect[fxid], ent, "tag_origin" );
	ent.angles = angles;
	ent LinkTo( self, link_tag );
}


init_stage_lights()
{
	self createLinkedEffect( 
		(3943.74,164.709,755.298),
		(65.4184,181.286,-8.07589), 
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3940.87,81.7734,754.04),
		(65.4184,181.286,-8.07589),
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3942.06,16.2642,756.392),
		(65.4184,181.286,-8.07589),
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3940.14,-893.601,757.617),
		(65.4184,181.286,-8.07589),
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3938.63,-1036.69,757.216),
		(65.4184,181.286,-8.07589),
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3938.57,-1135.95,756.772),
		(65.4184,181.286,-8.07589),
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3942.64,126.559,751.82),
		(64.144,185.774,-18.7348),
		"opera_stage_light_purple",
		"stage_jnt" );

	self createLinkedEffect(
		(3939.15,-1100.25,755.796),
		(64.144,185.774,-18.7348),
		"opera_stage_light_purple",
		"stage_jnt" );

	self createLinkedEffect(
		(3938.89,48.9229,750.274),
		(87.6388,167.844,75.0411),
		"opera_stage_light_blue",
		"stage_jnt" );

	self createLinkedEffect(
		(3941.24,-989.884,758.21),
		(55.6886,179.118,86.4589),
		"opera_stage_light_blue",
		"stage_jnt" );

	self createLinkedEffect(
		(3944.65,-1318.81,628.108),
		(55.6886,179.118,86.4589),
		"opera_stage_light_blue",
		"stage_jnt" );

	self createLinkedEffect(
		(3944.76,-1208.87,629.399),
		(65.4184,181.286,-8.07589),
		"opera_stage_light_blue2",
		"stage_jnt" );

	self createLinkedEffect(
		(3944.12,-1367.29,627.133),
		(64.144,185.774,-18.7348),
		"opera_stage_light_purple",
		"stage_jnt" );

	self createLinkedEffect(
		(3935.48,-940.476,758.323),
		(64.144,185.774,-18.7348),
		"opera_stage_light_purple",
		"stage_jnt" );

	self createLinkedEffect(
		(3953.34,-1283.11,49.4872),
		(292.549,232.238,-90.666),
		"opera_work_light_vol",
		"stage_jnt" );
}