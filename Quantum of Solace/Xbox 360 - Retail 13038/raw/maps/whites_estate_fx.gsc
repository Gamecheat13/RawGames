#include maps\_utility;

main()
{
	initFXModelAnims();
	
	precacheFX();
	
	// Register FX Events
	registerFXTargetName("fx_sprinklers_on");
	registerFXTargetName("elec_sparks_on");
	registerFXTargetName("bond_fountain_splash");
	registerFXTargetName("glass_door_burst");
	registerFXTargetName("cellar_burst");
	
	maps\createfx\whites_estate_fx::main();
	
	//turning on the quick kill effects
	level thread maps\_fx::quick_kill_fx_on();
	
	level thread intro_effects();
	level thread outro_effects();
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_we_door_kick", "targetname" );
	ent2 = getent( "fxanim_water_tank", "targetname" );
	ent3 = getent( "fxanim_cellar_doors", "targetname" );
	ent4 = getent( "fxanim_seagull_circle", "targetname" );
	ent5 = getent( "fxanim_board_break", "targetname" );
	ent6 = getent( "fxanim_door_explode", "targetname" );
	ent7 = getent( "fxanim_wine_barrels_top_01", "targetname" );
	ent8 = getent( "fxanim_wine_barrels_mid_01", "targetname" );
	ent9 = getent( "fxanim_wine_barrels_top_02", "targetname" );
	ent10 = getent( "fxanim_wine_barrels_mid_02", "targetname" );
	ent11 = getent( "fxanim_wine_barrels_top_03", "targetname" );
	ent12 = getent( "fxanim_wine_barrels_mid_03", "targetname" );
	ent13 = getent( "fxanim_wine_barrels_top_04", "targetname" );
	ent14 = getent( "fxanim_wine_barrels_mid_04", "targetname" );
	ent15 = getent( "fxanim_balcony_collapse", "targetname" );
	ent16 = getent( "fxanim_front_door", "targetname" );
	ent17 = getent( "fxanim_thick_rope_01", "targetname" );
	ent18 = getent( "fxanim_thick_rope_02", "targetname" );
	ent19 = getent( "fxanim_rope_short", "targetname" );
	ent20 = getent( "fxanim_ceiling_beams", "targetname" );
	ent21 = getent( "fxanim_painting_01", "targetname" );
	ent22 = getent( "fxanim_painting_02", "targetname" );
	ent23 = getent( "fxanim_painting_03", "targetname" );
	
	ent_array1 = getentarray( "fxanim_rope_long", "targetname" );
	ent_array2 = getentarray( "fxanim_sm_buoy_01", "targetname" );
	ent_array3 = getentarray( "fxanim_sm_buoy_02", "targetname" );
	ent_array4 = getentarray( "fxanim_sm_buoy_04", "targetname" );
		
	if (IsDefined(ent1)) { ent1 thread we_door_kick();   println("************* FX: we_door_kick *************"); }
	if (IsDefined(ent2)) { ent2 thread water_tank_anim_1(); println("************* FX: water_tank *************"); }
	if (IsDefined(ent3)) { ent3 thread cellar_doors();   println("************* FX: cellar_doors *************"); }
	if (IsDefined(ent4)) { ent4 thread seagull_circle();   println("************* FX: seagull_circle *************"); }
	if (IsDefined(ent5)) { ent5 thread board_break();   println("************* FX: board_break *************"); }
	if (IsDefined(ent6)) { ent6 thread door_explode();   println("************* FX: door_explode *************"); }
	if (IsDefined(ent7)) ent7 thread wine_barrels_top_01();
	if (IsDefined(ent8)) ent8 thread wine_barrels_mid_01();
	if (IsDefined(ent9)) ent9 thread wine_barrels_top_02();
	if (IsDefined(ent10)) ent10 thread wine_barrels_mid_02();
	if (IsDefined(ent11)) ent11 thread wine_barrels_top_03();
	if (IsDefined(ent12)) ent12 thread wine_barrels_mid_03();
	if (IsDefined(ent13)) ent13 thread wine_barrels_top_04();
	if (IsDefined(ent14)) ent14 thread wine_barrels_mid_04();
	if (IsDefined(ent15)) { ent15 thread balcony_collapse();   println("************* FX: balcony_collapse *************"); }
	if (IsDefined(ent16)) { ent16 thread front_door();   println("************* FX: front_door *************"); }
	if (IsDefined(ent17)) { ent17 thread thick_rope_01();   println("************* FX: thick_rope_01 *************"); }
	if (IsDefined(ent18)) { ent18 thread thick_rope_02();   println("************* FX: thick_rope_02 *************"); }
	if (IsDefined(ent19)) { ent19 thread rope_short();   println("************* FX: rope_short *************"); }
	if (IsDefined(ent20)) { ent20 thread ceiling_beams();   println("************* FX: ceiling_beams *************"); }
	if (IsDefined(ent21)) { ent21 thread painting_01();   println("************* FX: painting_01 *************"); }
	if (IsDefined(ent22)) { ent22 thread painting_02();   println("************* FX: painting_02 *************"); }
	if (IsDefined(ent23)) { ent23 thread painting_03();   println("************* FX: painting_03 *************"); }
	
	if (IsDefined(ent_array1)) { ent_array1 thread rope_long();   println("************* FX: rope_long *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread sm_buoy_01();   println("************* FX: sm_buoy_01 *************"); }
	if (IsDefined(ent_array3)) { ent_array3 thread sm_buoy_02();   println("************* FX: sm_buoy_02 *************"); }
	if (IsDefined(ent_array4)) { ent_array4 thread sm_buoy_04();   println("************* FX: sm_buoy_04 *************"); }

}

intro_effects()
{		
	level thread aston_effects();
	level thread white_effects();
	level thread suv_effects2();
	level thread suv_effects();
	
}
outro_effects()
{		
	level thread copter_effects1();
	level thread copter_effects2();
	level thread copter_effects3();
	level thread copter_effects4();
	
}

//attach exhaust
//CG - NOTE, re-exporting the .cutscene could break this!

white_effects()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		white_model = getent("WhitesEstate_Spawn_6", "targetname");
		if( isdefined( white_model ) )
		{
			break;
		}			
	}	
	
	println("****** FX: white_model found! ******");
	white_model waittillmatch("anim_notetrack", "entry_wound");
	println("****** FX: note_entry_wound found! ******");
	level thread link_effect_to_ent( white_model, "whites_hit", "L_foot", (0,0,0), (-90,0,0) );
	
}





aston_effects()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		aston_model = getent("WhitesEstate_Spawn_7", "targetname");
		if( isdefined( aston_model ) )
		{
			break;
		}			
	}	
	
	println("****** FX: aston_model found! ******");
	aston_model waittillmatch("anim_notetrack", "exhaust");
	level thread link_effect_to_ent( aston_model, "whites_car_exhaust", "tag_tailpipe", (0,0,0), (-90,0,0) );
	level thread link_effect_to_ent( aston_model, "whites_car_exhaust", "tag_tailpipe2", (0,0,0), (-90,0,0) );		
	
	aston_model waittillmatch("anim_notetrack", "gravel");
	level thread link_effect_to_ent( aston_model, "whites_car_gravel", "tag_wheel_back_left", (11,0,0), (00,0,0) );
	level thread link_effect_to_ent( aston_model, "whites_car_gravel", "tag_wheel_back_right", (11,0,0), (0,0,0) );
	
}

suv_effects2()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		suv_model = getent("WhitesEstate_Spawn_17", "targetname");
		if( isdefined( suv_model ) )
		{
			break;
		}			
	}	
	

		println("****** FX: suv1_model found! ******");

  wait(4.0);
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel2", "tag_wheel_back_left", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel2", "tag_wheel_back_right", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel2", "tag_wheel_front_right", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel2", "tag_wheel_front_left", (0,0,0), (-0,0,0) );
	
}

suv_effects()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		suv_model = getent("WhitesEstate_Spawn_19", "targetname");
		if( isdefined( suv_model ) )
		{
			break;
		}			
	}	
	

	level thread link_effect_to_ent( suv_model, "whites_suv_gravel", "tag_wheel_back_left", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel", "tag_wheel_back_right", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel", "tag_wheel_front_right", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( suv_model, "whites_suv_gravel", "tag_wheel_front_left", (0,0,0), (-0,0,0) );
	
}

copter_effects1()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		copter_model = getent("Blood_Barrell_Spawn_37", "targetname");
		if( isdefined( copter_model ) )
		{
			break;
		}			
	}	
	level thread link_effect_to_ent( copter_model, "whites_heli_smoke_emit", "tag_engine_left", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( copter_model, "copter_dust_outro_1", "tag_engine_left", (0,0,0), (-0,0,0) );
  level notify( "fx_outro_smoke" );
}

copter_effects2()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		copter_model = getent("Blood_Barrell_Spawn_39", "targetname");
		if( isdefined( copter_model ) )
		{
			break;
		}			
	}	
	level thread link_effect_to_ent( copter_model, "whites_heli_smoke_emit_2", "tag_engine_left", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( copter_model, "copter_dust_outro_2", "tag_engine_left", (0,0,0), (-0,0,0) );
}

copter_effects3()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		copter_model = getent("Blood_Barrell_Spawn_41", "targetname");
		if( isdefined( copter_model ) )
		{
			break;
		}			
	}	
	level thread link_effect_to_ent( copter_model, "whites_heli_smoke_emit_3", "tag_engine_left", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( copter_model, "copter_dust_outro_2", "tag_engine_left", (0,0,0), (-0,0,0) );
	println("****** FX: note_before LandingSkid_scrape  ******");
	copter_model waittillmatch("anim_notetrack", "note_landingskid_scrape");
	println("****** FX: note_LandingSkid_scrape found! ******");
	level thread link_effect_to_ent( copter_model, "copter_sparks_outro_1", "wheel_front_l_base_jnt", (0,0,0), (-0,0,0) );
	level thread link_effect_to_ent( copter_model, "copter_impact_outro_1", "wheel_front_l_base_jnt", (0,0,0), (-0,0,0) );
}

copter_effects4()
{
	wait(0.1);
	
	while(1)
	{
		wait(0.033);
		copter_model = getent("Blood_Barrell_Spawn_43", "targetname");
		if( isdefined( copter_model ) )
		{
			break;
		}			
	}	
	level thread link_effect_to_ent( copter_model, "whites_heli_smoke_emit_3", "tag_engine_left", (0,0,0), (-0,0,0) );
}


link_effect_to_ent( ent, effectID, tag, offset, angle )
{
	ent_tag = Spawn( "script_model", ent.origin );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = ent.angles;
	ent_tag LinkTo( ent, tag, offset, angle );
		
	println("****** FX: link_fx_to_ent: = " + ent.model + " ******");
	PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
}

#using_animtree("fxanim_we_door_kick");
we_door_kick()
{
	level waittill("we_door_kick_start");
	self UseAnimTree(#animtree);
	self animscripted("a_we_door_kick", self.origin, self.angles, %fxanim_we_door_kick);
	level notify("fx_boathouse_glass");
}

#using_animtree("fxanim_water_tank_shake");
water_tank_anim_1()
{
	level waittill("water_tank_shake_start");
	self UseAnimTree(#animtree);
	self animscripted("a_water_tank_shake", self.origin, self.angles, %fxanim_water_tank_shake);
	
	//starting steam effects
	steamfx1 = spawnfx( level._effect["whites_tank_steam1"], (-2259.85, -1114.4, -99.69), (0,45,0) );
	steamfx2 = spawnfx( level._effect["whites_tank_steam2"], self.origin+(-11,-30,-10) );
	triggerFx( steamfx1 );
	triggerFx( steamfx2 );

	
	level waittill("water_tank_explode_start");
	self stopanimscripted();
	self stopuseanimtree();
	
	//removing the steam effects
	steamfx1 delete();
	steamfx2 delete();
	
	water_tank_explode();
	level notify("fx_steamtank");
	level notify("glass_door_burst");
}

#using_animtree("fxanim_water_tank_explode");
water_tank_explode()
{
	self UseAnimTree(#animtree);
	self animscripted("a_water_tank_explode", self.origin, self.angles, %fxanim_water_tank_explode);	
}

#using_animtree("fxanim_cellar_doors");
cellar_doors()
{
	level waittill("cellar_doors_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cellar_doors", self.origin, self.angles, %fxanim_cellar_doors);
	level notify("cellar_burst");
}

#using_animtree("fxanim_seagull_circle");
seagull_circle()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_seagull_circle", self.origin, self.angles, %fxanim_seagull_circle);
}

#using_animtree("fxanim_board_break");
board_break()
{
	level waittill("board_break_start");
	self UseAnimTree(#animtree);
	self animscripted("a_board_break", self.origin, self.angles, %fxanim_board_break);
}

#using_animtree("fxanim_door_explode");
door_explode()
{
	level waittill("door_explode_start");
	self UseAnimTree(#animtree);
	self animscripted("a_door_explode", self.origin, self.angles, %fxanim_door_explode);
}

#using_animtree("fxanim_wine_barrels_top");
wine_barrels_top_01()
{
	level waittill("wine_barrels_top_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_top_01", self.origin, self.angles, %fxanim_wine_barrels_top);
	level notify("fx_barrel_01_top");
}

#using_animtree("fxanim_wine_barrels_mid");
wine_barrels_mid_01()
{
	level waittill("wine_barrels_mid_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_mid_01", self.origin, self.angles, %fxanim_wine_barrels_mid);
	level notify("fx_barrel_01_med");
}

#using_animtree("fxanim_wine_barrels_top");
wine_barrels_top_02()
{
	level waittill("wine_barrels_top_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_top_02", self.origin, self.angles, %fxanim_wine_barrels_top);
	level notify("fx_barrel_02_top");
}

#using_animtree("fxanim_wine_barrels_mid");
wine_barrels_mid_02()
{
	level waittill("wine_barrels_mid_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_mid_02", self.origin, self.angles, %fxanim_wine_barrels_mid);
	level notify("fx_barrel_02_med");
}

#using_animtree("fxanim_wine_barrels_top");
wine_barrels_top_03()
{
	level waittill("wine_barrels_top_03_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_top_03", self.origin, self.angles, %fxanim_wine_barrels_top);
	level notify("fx_barrel_03_top");
}

#using_animtree("fxanim_wine_barrels_mid");
wine_barrels_mid_03()
{
	level waittill("wine_barrels_mid_03_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_mid_03", self.origin, self.angles, %fxanim_wine_barrels_mid);
	level notify("fx_barrel_03_med");
}

#using_animtree("fxanim_wine_barrels_top");
wine_barrels_top_04()
{
	level waittill("wine_barrels_top_04_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_top_04", self.origin, self.angles, %fxanim_wine_barrels_top);
	level notify("fx_barrel_04_top");
}

#using_animtree("fxanim_wine_barrels_mid");
wine_barrels_mid_04()
{
	level waittill("wine_barrels_mid_04_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wine_barrels_mid_04", self.origin, self.angles, %fxanim_wine_barrels_mid);
	level notify("fx_barrel_04_med");
}

#using_animtree("fxanim_balcony_collapse");
balcony_collapse()
{
	level waittill("balcony_collapse_start");
	self UseAnimTree(#animtree);
	self animscripted("a_balcony_collapse", self.origin, self.angles, %fxanim_balcony_collapse);
}

#using_animtree("fxanim_front_door");
front_door()
{
	level waittill("front_door_start");
	self UseAnimTree(#animtree);
	self animscripted("a_front_door", self.origin, self.angles, %fxanim_front_door);
}

#using_animtree("fxanim_thick_rope_01");
thick_rope_01()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_thick_rope_01", self.origin, self.angles, %fxanim_thick_rope_01);
}

#using_animtree("fxanim_thick_rope_02");
thick_rope_02()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_thick_rope_02", self.origin, self.angles, %fxanim_thick_rope_02);
}

#using_animtree("fxanim_rope_short");
rope_short()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_rope_short", self.origin, self.angles, %fxanim_rope_short);
}

#using_animtree("fxanim_rope_long");
rope_long()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_rope_long", self[i].origin, self[i].angles, %fxanim_rope_long);
	}
}

#using_animtree("fxanim_ceiling_beams");
ceiling_beams()
{
	level waittill("ceiling_beams_start");
	self UseAnimTree(#animtree);
	self animscripted("a_ceiling_beams", self.origin, self.angles, %fxanim_ceiling_beams);
}

#using_animtree("fxanim_painting_01");
painting_01()
{
	level waittill("painting_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_painting_01", self.origin, self.angles, %fxanim_painting_01);
}

#using_animtree("fxanim_painting_02");
painting_02()
{
	level waittill("painting_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_painting_02", self.origin, self.angles, %fxanim_painting_02);
}

#using_animtree("fxanim_painting_03");
painting_03()
{
	level waittill("painting_03_start");
	self UseAnimTree(#animtree);
	self animscripted("a_painting_03", self.origin, self.angles, %fxanim_painting_03);
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

precacheFX()
{

	level._effect["dust_01"] = loadfx ("dust/dust_trail_IR");
	level._effect["dust_02"] = loadfx ("dust/sand_aftermath");
	level._effect["fx_metalhit_lg"] = loadfx ("impacts/large_metalhit");
	level._effect["bullet_cellar_godray"] = loadfx ("maps/Whites_Estate/bullet_efx_cellar");
	
	level._effect["whites_water_sparkles"] 		= loadfx ( "maps/Whites_Estate/whites_water_sparkles" );
	//level._effect["whites_sprinklers1"] 		= loadfx ( "maps/Whites_Estate/whites_sprinklers1" );
	//level._effect["whites_sprinklers2"] 		= loadfx ( "maps/Whites_Estate/whites_sprinklers2" );
	level._effect["whites_pier_pole"] 			= loadfx ( "maps/Whites_Estate/whites_pier_pole" );
	level._effect["whites_fountain_lg2"] 		= loadfx ( "maps/Whites_Estate/whites_fountain_lg2" );
	level._effect["whites_fountain_med"] 		= loadfx ( "maps/Whites_Estate/whites_fountain_med" );
	level._effect["whites_fountain_lg"] 		= loadfx ( "maps/Whites_Estate/whites_fountain_lg" );
	level._effect["whites_fountain_sm"] 		= loadfx ( "maps/Whites_Estate/whites_fountain_sm" );
	level._effect["whites_fountain1"] 			= loadfx ( "maps/Whites_Estate/whites_fountain1" );
	level._effect["whites_fountain2"] 			= loadfx ( "maps/Whites_Estate/whites_fountain2" );
	level._effect["whites_fountain3"] 			= loadfx ( "maps/Whites_Estate/whites_fountain3" );
	level._effect["whites_falling_leaves1"] 	= loadfx ( "maps/Whites_Estate/whites_falling_leaves1" );
	level._effect["whites_falling_leaves2"] 	= loadfx ( "maps/Whites_Estate/whites_falling_leaves2" );
	level._effect["whites_falling_leaves3"] 	= loadfx ( "maps/Whites_Estate/whites_falling_leaves3" ); //pink ones
	level._effect["whites_water_disturb01"] 	= loadfx ( "maps/Whites_Estate/whites_water_disturb01" );
	level._effect["whites_chopper_cyclone"] 	= loadfx ( "maps/Whites_Estate/whites_chopper_cyclone" );
	level._effect["whites_boathouse_dust"] 		= loadfx ( "maps/Whites_Estate/whites_boathouse_dust" );
	level._effect["whites_boathouse_glass"] 	= loadfx ( "maps/Whites_Estate/whites_boathouse_glass" );
	level._effect["whites_insects1"] 			= loadfx ( "maps/Whites_Estate/whites_insects1" );
	level._effect["whites_insects2"] 			= loadfx ( "maps/Whites_Estate/whites_insects2" );
	level._effect["koi_sanke_r1"] 				= loadfx ( "misc/koi_sanke_r" );
	level._effect["koi_sanke_r2"] 				= loadfx ( "misc/koi_sanke_r2" );
	level._effect["flying_bees"] 				= loadfx ( "misc/flying_bees" );
	level._effect["flying_bees2"] 				= loadfx ( "misc/flying_bees2" );
	level._effect["explosion_1"] 				= loadfx ( "maps/Whites_Estate/whites_explosion_2" );
	level._effect["electric_spark"] 			= loadfx ( "maps/Whites_Estate/whites_lamp_sparks" );
	level._effect["whites_fountain_splash"] 	= loadfx ( "maps/Whites_Estate/whites_fountain_splash1" );
	level._effect["whites_cellar_burst"] 		= loadfx ( "maps/Whites_Estate/whites_cellar_burst" );
	level._effect["fire_ball"] = loadfx ("maps/whites_estate/whites_explosion_2");
	level._effect["small_fire"] = loadfx ("maps/whites_estate/whites_small_fire");	
	level._effect["wall_fire"] = loadfx ("maps/whites_estate/whites_wall_fire");
	level._effect["exp_2"] = loadfx ("maps/whites_estate/whites_explosion_2");
	level._effect["exp_3"] = loadfx ("maps/whites_estate/whites_explosion_3");
	level._effect["tiny_fire"] = loadfx ("maps/whites_estate/whites_tiny_fire_emitter");
	level._effect["teeny_fire"] = loadfx ("maps/whites_estate/whites_tiny_fire");
	level._effect["ceiling_smoke"] = loadfx ("maps/whites_estate/whites_ceiling_smoke");
	level._effect["room_smoke"] = loadfx ("maps/whites_estate/whites_smoke_2");
	level._effect["heat"] = loadfx ("maps/whites_estate/whites_heat");
	level._effect["conc_grenade"] = loadfx ("weapons/concussion_grenade");
	level._effect["monitor_sparks"] = loadfx ("props/monitor_hit");
	
	
//	level._effect["propane_boom"] = loadfx ("maps/shantytown/shanty_propane_runner2");
//	level._effect["estate_car_explosion"] = loadfx ("explosions/small_vehicle_explosion");
//	level._effect["water_steam"] = loadfx ("maps/Casino/casino_sauna_steam");
//	level._effect["water_gush"] = loadfx ("maps/Casino/casino_spa_splash1");

	//greenhouse tank explosion
	level._effect["whites_tank_steam1"] 	= loadfx ( "maps/Whites_Estate/whites_tank_steam1" );
	level._effect["whites_tank_steam2"] 	= loadfx ( "maps/Whites_Estate/whites_tank_steam2" );
	level._effect["whites_tank_steam4"] 	= loadfx ( "maps/Whites_Estate/whites_tank_steam4" );
	level._effect["whites_embers1"] 		= loadfx ( "maps/Whites_Estate/whites_embers1" );
	//level._effect["whites_ceiling_fire1"] 	= loadfx ( "maps/Whites_Estate/whites_ceiling_fire1" );
	
	level._effect["barrel_smash_top"] 			= loadfx ( "maps/Whites_Estate/whites_w_barrel_top" );
	level._effect["barrel_smash_med"] 			= loadfx ( "maps/Whites_Estate/whites_w_barrel_med" );
	
	//IGC effects
	level._effect["whites_car_exhaust"] = loadfx ("maps/whites_estate/whites_car_exhaust_emit");
	level._effect["whites_car_gravel"] = loadfx ("maps/whites_estate/whites_car_gravel_emit");
	level._effect["whites_suv_gravel"] = loadfx ("maps/whites_estate/whites_suv_gravel_emit");
	level._effect["whites_suv_gravel2"] = loadfx ("maps/whites_estate/whites_suv_gravel_emit2");
	level._effect["whites_hit"] = loadfx ("maps/whites_estate/whites_bodyhit");
	level._effect["copter_dust"] = loadfx ("maps/whites_estate/whites_copter_cyclone_emit");
	level._effect["whites_heli_smoke_emit"] = loadfx ("maps/whites_estate/whites_heli_smoke_emit");
	level._effect["whites_heli_smoke_emit_2"] = loadfx ("maps/whites_estate/whites_heli_smoke_emit_2");
	level._effect["copter_dust_outro_1"] = loadfx ("maps/whites_estate/whites_copter_cyclone_outro_1");
	level._effect["copter_dust_outro_2"] = loadfx ("maps/whites_estate/whites_copter_cyclone_outro_2");
	level._effect["copter_sparks_outro_1"] = loadfx ("maps/whites_estate/whites_outro_sparkrunner");
	level._effect["copter_impact_outro_1"] = loadfx ("maps/whites_estate/whites_chopper_cyclone");
	level._effect["whites_heli_smoke_emit_3"] = loadfx ("maps/whites_estate/whites_heli_smoke_emit_3");
	level._effect["whites_outro_smoke"] = loadfx ("maps/whites_estate/whites_outro_smoke");
	level._effect["whites_smoke_conserv"] = loadfx ("maps/whites_estate/whites_smoke_conserv");
	
	//level._effect["speed_boat_wake"] = loadfx("maps/whites_estate/whites_speedboat");
	level._effect["speed_boat_wake"] = loadfx("maps/shantytown/shanty_speedboat_spray2");

if ( level.ps3 == true )
	{
		level._effect["med_fire"] = loadfx ("maps/whites_estate/whites_med_fire5_PS3");
		level._effect["whites_tank_steam3"] 	= loadfx ( "maps/Whites_Estate/whites_tank_steam3_PS3" );
		level._effect["large_fire"] = loadfx ("maps/whites_estate/whites_med_fire5_2_PS3");
		level._effect["whites_greenhouse_glass1"] = loadfx ( "maps/Whites_Estate/whites_greenhouse_glass_1_PS3" );
		level._effect["whites_greenhouse_glass2"] = loadfx ( "maps/Whites_Estate/whites_greenhouse_glass_2_PS3" );
		level._effect["large_boom"] = loadfx ("maps/whites_estate/whites_explosion_2_PS3");
	}
else
	{
		level._effect["med_fire"] = loadfx ("maps/whites_estate/whites_med_fire5");
		level._effect["whites_tank_steam3"] 	= loadfx ( "maps/Whites_Estate/whites_tank_steam3" );
		level._effect["large_fire"] = loadfx ("maps/whites_estate/whites_med_fire5_2");
		level._effect["whites_greenhouse_glass1"] = loadfx ( "maps/Whites_Estate/whites_greenhouse_glass_1" );
		level._effect["whites_greenhouse_glass2"] = loadfx ( "maps/Whites_Estate/whites_greenhouse_glass_2" );
		level._effect["large_boom"] = loadfx ("maps/whites_estate/whites_explosion_2");
	}
	
}
