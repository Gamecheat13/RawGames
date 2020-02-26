#include maps\_utility;

main()
{

	initFXModelAnims();
	
	precacheFX();
	
	registerFXTargetName("fx_DBS_alarm");
	
	maps\createfx\casino_poison_fx::main();
	
	
	level thread auto_createfx_candle();
	
	
	level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_martini_fall", "targetname" );
	ent2 = getent( "fxanim_table_tip_1", "targetname" );
	ent3 = getent( "fxanim_table_tip_2", "targetname" );
	
	
		
	if (IsDefined(ent1)) { ent1 thread martini_fall();   println("************* FX: martini_fall *************"); }
	if (IsDefined(ent2)) { ent2 thread table_tip_1();   println("************* FX: table_tip_1 *************"); }
	if (IsDefined(ent3)) { ent3 thread table_tip_2();   println("************* FX: table_tip_2 *************"); }
	
	
}

#using_animtree("fxanim_martini_fall");
martini_fall()
{
	level waittill("martini_fall_start");
	self UseAnimTree(#animtree);
	self animscripted("a_martini_fall", self.origin, self.angles, %fxanim_martini_fall);
}

#using_animtree("fxanim_table_tip_1");
table_tip_1()
{
	level waittill("table_tip_1_start");
	self UseAnimTree(#animtree);
	self animscripted("a_table_tip_1", self.origin, self.angles, %fxanim_table_tip_1);
}

#using_animtree("fxanim_table_tip_2");
table_tip_2()
{
	level waittill("table_tip_2_start");
	self UseAnimTree(#animtree);
	self animscripted("a_table_tip_2", self.origin, self.angles, %fxanim_table_tip_2);
}



precacheFX()
{
	level._effect["poison_heat_distortion"] 	= loadfx ( "distortion/distortion_fs_poison" );
	level._effect["poison_heat_distortion2"] 	= loadfx ( "distortion/distortion_fs_poison2" );
	level._effect["science_lightbeam04"] 		= loadfx ("maps/miamisciencecenter/science_lightbeam04");
	level._effect["casino_faucet_water"] 		= loadfx ("maps/casino/casino_faucet_water");
	level._effect["casino_table_light_vol1"] 	= loadfx ("maps/casino/casino_table_light_vol1");
	
	
	level._effect["casino_candle_flame"] 		= loadfx ("maps/casino/casino_candle_flame1");
	level._effect["casino_lamp4_glow"] 			= loadfx ("maps/casino/casino_lamp4_glow");	
	level._effect["casino_lamp1_glow"] 			= loadfx ("maps/casino/casino_lamp1_glow");
	level._effect["casino_4halos_courtyard01"] 	= loadfx ("maps/casino/casino_4halos_courtyard01");
	level._effect["casino_lamp4_glow_far"]	 	= loadfx ("maps/casino/casino_lamp4_glow_far");
	level._effect["casino_exterior_halo2"] 		= loadfx ("maps/casino/casino_exterior_halo2");	
	level._effect["casino_lamp2_glow_far"] 		= loadfx ("maps/casino/casino_lamp2_glow_far");
	level._effect["casino_lamp3_glow_far"] 		= loadfx ("maps/casino/casino_lamp3_glow_far");
	level._effect["casino_parking_light_vol"]	= loadfx ("maps/casino/casino_parking_light_vol");
	level._effect["casino_dbs_headlight1"] 		= loadfx ("maps/casino/casino_dbs_headlight1");
	level._effect["casino_dbs_signalight1"] 	= loadfx ("maps/casino/casino_dbs_signalight1");
	level._effect["casino_dbs_tailight1"] 		= loadfx ("maps/casino/casino_dbs_tailight1");
	level._effect["casino_dbs_ilight1"] 		= loadfx ("maps/casino/casino_dbs_ilight1");
	level._effect["casino_leaves1"] 			= loadfx ("maps/casino/casino_leaves1");
	level._effect["casino_cigar_smoke1"] 		= loadfx ("maps/casino/casino_cigar_smoke1");
	level._effect["casino_cigar_smoke2"] 		= loadfx ("maps/casino/casino_cigar_smoke2");
	level._effect["vehicle_night_headlight02"]	= loadfx ("vehicles/night/vehicle_night_headlight02");
	level._effect["vehicle_night_taillight"]	= loadfx ("vehicles/night/vehicle_night_taillight");
	level._effect["defibrilator_light"]	 		= loadfx ("misc/light_blinking_red_sm");
	
	
}



auto_createfx_candle()
{
	wait( 1 );
	all_cntrpiece = GetEntArray("cntrpiece", "script_noteworthy");
	
	
	
	if (IsDefined(all_cntrpiece)) 
	{
		for (i = 0; i < all_cntrpiece.size; i++)
		{
			
			link_effect_to_ent(all_cntrpiece[i], "casino_candle_flame");
			wait( 0.05 ); 
		}
	}
}


link_effect_to_ent(ent, effect)
{
	ent_tag = Spawn("script_model", ent.origin + (0, 0, 12));
	ent_tag SetModel("tag_origin");
	ent_tag.angles = ent.angles;
	ent_tag LinkTo(ent);
		
	PlayFxOnTag(level._effect[effect], ent_tag, "tag_origin");
}
