#include maps\_utility;

main()
{
	initFXModelAnims();
	
	precacheFX();

	registerFXTargetName("deck_fire");

	flare_fx();

	maps\createfx\sink_hole_fx::main();
	
	//turning on the quick kill effects
	level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_fuselage_loop", "targetname" );
	ent2 = getent( "fxanim_fuselage_nonloop", "targetname" );
	ent3 = getent( "fxanim_rope_short", "targetname" );
	ent4 = getent( "fxanim_engine_toss", "targetname" );
	ent5 = getent( "fxanim_boulder_fall", "targetname" );
	ent6 = getent( "fxanim_wing_fall", "targetname" );

	if (IsDefined(ent1)) { ent1 thread fuselage_loop();   println("************* FX: fuselage_loop *************"); }
	if (IsDefined(ent2)) { ent2 thread fuselage_nonloop();   println("************* FX: fuselage_nonloop *************"); }
	if (IsDefined(ent3)) { ent3 thread rope_short();   println("************* FX: rope_short *************"); }
	if (IsDefined(ent4)) { ent4 thread engine_toss();   println("************* FX: engine_toss *************"); }
	if (IsDefined(ent5)) { ent5 thread boulder_fall();   println("************* FX: boulder_fall *************"); }
	if (IsDefined(ent6)) { ent6 thread wing_fall();   println("************* FX: wing_fall *************"); }
}

#using_animtree("fxanim_fuselage_loop");
fuselage_loop()
{
	level waittill("fuselage_loop_start");
	self UseAnimTree(#animtree);
	self animscripted("a_fuselage_loop", self.origin, self.angles, %fxanim_fuselage_loop);
	while (true)
	{
		self waittillmatch("a_fuselage_loop", "door_slam");
		self PlaySound("sink_hole_plane_door", "sink_hole_plane_door_done", true);
	}
}

#using_animtree("fxanim_fuselage_nonloop");
fuselage_nonloop()
{
	level waittill("fuselage_nonloop_start");
	self UseAnimTree(#animtree);
	self animscripted("a_fuselage_nonloop", self.origin, self.angles, %fxanim_fuselage_nonloop);
}

#using_animtree("fxanim_rope_short");
rope_short()
{
	level waittill("fuselage_loop_start");
	self UseAnimTree(#animtree);
	self animscripted("a_rope_short", self.origin, self.angles, %fxanim_rope_short);
}

#using_animtree("fxanim_engine_toss");
engine_toss()
{
	level waittill("engine_toss_start");
	self UseAnimTree(#animtree);
	self animscripted("a_engine_toss", self.origin, self.angles, %fxanim_engine_toss);
	playfxontag ( level._effect["helicopter_crashing"], self, "engine_body_jnt" );
	playfxontag ( level._effect["engine_explosion"], self, "engine_body_jnt" );
	self waittillmatch("a_engine_toss", "egine_hit");
//	println("************* FX: engine_explosion *************");
	level notify("engine_explosion");                        
	playfxontag ( level._effect["engine_explosion"], self, "engine_body_jnt" );


}

#using_animtree("fxanim_boulder_fall");
boulder_fall()
{
	level waittill("boulder_fall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_boulder_fall", self.origin, self.angles, %fxanim_boulder_fall);
}

#using_animtree("fxanim_wing_fall");
wing_fall()
{
	level waittill("wing_fall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_wing_fall", self.origin, self.angles, %fxanim_wing_fall);
	level notify ("wing_fall");
	playfxontag ( level._effect["wing_fall"], self, "wing_fire_jnt" );

}



precacheFX()
{
	level._effect["airplane_explosion"]		= loadfx ("props/large_propane");
	level._effect["science_lightbeam05"]	= loadfx ("vehicles/chopper_searchlight");
	//level._effect["science_lightbeam05"]	= loadfx ("maps/barge/barge_spotlight");
	//level._effect["small_fire"]			= loadfx ("maps/miamisciencecenter/science_floor_smallfire");
	//level._effect["deck_fire"]			= loadfx ("maps/barge/barge_deck_fire01");
	//level._effect["fuel_fire"]			= loadfx ("maps/sinkhole/big_fire");

	//level._effect["chopper_cyclone"]		= loadfx ("maps/sinkhole/sink_chopper_cyclone");
	level._effect["chopper_cyclone"]		= loadfx ("maps/SinkHole/sink_chopper_cyclone_emit");

	level._effect["collapse_dust_oneshot"]	= loadfx ("maps/sinkhole/sink_collapse_dust_oneshot");
	level._effect["flare"]					= loadfx ("maps/sinkhole/sink_flare");
	level._effect["smoke"]					= loadfx ("maps/sinkhole/sink_smoke");
	level._effect["thick_smoke"]			= loadfx ("maps/sinkhole/sink_thick_smoke");
	level._effect["copter_dust"]			= loadfx ("maps/sinkhole/sink_copter_dust");

	level._effect["rpg_explosion"]			= loadfx ("maps/MiamiScienceCenter/science_chopper_boom");
	//level._effect["tnt_explosion"]		= loadfx ("explosions/crate_tnt");

	level._effect["bullet_vol"]				= loadfx ("maps/casino/casino_vent_bullet_vol");
	level._effect["engine_explosion"]		= loadfx ("props/welding_exp");
	level._effect["rocks_hit_copter"]		= loadfx ("maps/sinkhole/sink_rocks_hit_copter");
	level._effect["helicopter_crashing"]	= loadfx ("maps/MiamiScienceCenter/science_chopper_fire");
	level._effect["helicopter_smoking"]		= loadfx ("maps/sinkhole/sink_traling_smoke_emit");
	
	level._effect["chopper_light_red"]		= loadfx ("props/blackhawk_red_light");
	level._effect["chopper_light_red2"]		= loadfx ("props/blackhawk_red_light2");
	level._effect["wing_fall"]	= loadfx ("maps/sinkhole/wing_dust");
	level._effect["wing_fall2"]	= loadfx ("maps/sinkhole/wing_dust2");

	level._effect["sparks"]	= loadfx ("maps/sinkhole/sink_sparks");
	level._effect["smolder"] = loadfx ("maps/sinkhole/sink_smolder");


if ( level.ps3 == true )
	{
	level._effect["med_fire"]				= loadfx ("maps/sinkhole/sink_med_fire_ps3");
	level._effect["collapse_dust"]			= loadfx ("maps/sinkhole/sink_collapse_dust_runner_PS3");
	level._effect["smoke_fire"]				= loadfx ("maps/sinkhole/sink_large_fire_PS3");
	level._effect["big_fire"]				= loadfx ("maps/sinkhole/sink_very_large_fire_PS3");

	}
else
	{
	level._effect["med_fire"]				= loadfx ("maps/sinkhole/sink_med_fire");
	level._effect["collapse_dust"]			= loadfx ("maps/sinkhole/sink_collapse_dust_runner");
	level._effect["smoke_fire"]				= loadfx ("maps/sinkhole/sink_large_fire");
	level._effect["big_fire"]				= loadfx ("maps/sinkhole/sink_very_large_fire");

	}
	

}


flare_fx()
{
	potential_flares = GetEntArray("script_model", "classname");
	for (i = 0; i < potential_flares.size; i++)
	{
		if (potential_flares[i].model == "p_msc_flare")
		{
			Playfx(level._effect["flare"], potential_flares[i].origin);
			//iprintlnbold("SOUND: flare");
			potential_flares[i] playloopsound("sink_hole_flareloop"); 
		}
	}
}
