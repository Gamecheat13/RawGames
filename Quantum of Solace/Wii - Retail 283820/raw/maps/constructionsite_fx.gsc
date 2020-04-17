#include maps\_utility;

main()
{
	

	initFXModelAnims();
	
	precacheFX();
	
	
	registerFXTargetName("fx_pipes_impact");
	registerFXTargetName("fx_digger_impact");
	registerFXTargetName("fx_shack_dust");
	registerFXTargetName("fx_acetylene_exp1");
	registerFXTargetName("fx_acetylene_exp2");
	registerFXTargetName("fx_birds_takeoff1");
	registerFXTargetName("fx_birds_takeoff2");
	registerFXTargetName("fx_drywall_dust");
	registerFXTargetName("fx_roofdent_dust");
	registerFXTargetName("fx_elevator_impact");
	registerFXTargetName("fx_scissorlift_impact");
	registerFXTargetName("fx_foliage_burst");

	maps\createfx\constructionsite_fx::main();
	
	
	level thread maps\_fx::quick_kill_fx_on();
}

initFXModelAnims()
{
	ent1 = getent( "fxanim_pipe_drop_01", "targetname" );
	ent2 = getent( "fxanim_cement_crush", "targetname" );
	ent3 = getent( "fxanim_drywall_break", "targetname" );
	ent4 = getent( "fxanim_propane_fall", "targetname" );
	ent5 = getent( "fxanim_fence_door", "targetname" );
	ent6 = getent( "fxanim_pipe_break", "targetname" );
	ent7 = getent( "fxanim_pipe_drop_02", "targetname" );
	
	ent9 = getent( "fxanim_streamer_4", "targetname" );
	ent10 = getent( "fxanim_streamer_5", "targetname" );
	
	ent_array1 = getentarray( "fxanim_ibeam_wire_tight", "targetname" );
	ent_array2 = getentarray( "fxanim_ibeam_wire_loose", "targetname" );
	
	if (IsDefined(ent1)) { ent1 thread pipe_drop_01();   println("************* FX: pipe_drop_01 *************"); }
	if (IsDefined(ent2)) { ent2 thread cement_crush();   println("************* FX: cement_crush *************"); }
	if (IsDefined(ent3)) { ent3 thread drywall_break();   println("************* FX: drywall_break *************"); }
	if (IsDefined(ent4)) { ent4 thread propane_fall();   println("************* FX: propane_fall *************"); }
	if (IsDefined(ent5)) { ent5 thread fence_door();   println("************* FX: fence_door *************"); }
	if (IsDefined(ent6)) { ent6 thread pipe_break();   println("************* FX: pipe_break *************"); }
	if (IsDefined(ent7)) { ent7 thread pipe_drop_02();   println("************* FX: pipe_drop_02 *************"); }
	
	if (IsDefined(ent9)) { ent9 thread streamer_4();   println("************* FX: streamer_4 *************"); }
	if (IsDefined(ent10)) { ent10 thread streamer_5();   println("************* FX: streamer_5 *************"); }
	
	if (IsDefined(ent_array1)) { ent_array1 thread ibeam_wire_tight();   println("************* FX: ibeam_wire_tight *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread ibeam_wire_loose();   println("************* FX: ibeam_wire_loose *************"); }
}

#using_animtree("fxanim_pipe_drop_01");
pipe_drop_01()
{	
	level waittill("pipe_drop_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_pipe_drop", self.origin, self.angles, %fxanim_pipe_drop_01);
	
	
	if (animhasnotetrack(%fxanim_pipe_drop_01, "pipe_burst"))
	{
		self waittillmatch("a_pipe_drop", "pipe_burst");
		level notify("fx_pipes_impact");		
	}
}

#using_animtree("fxanim_cement_crush");
cement_crush()
{
	level waittill("cement_crush_start");
	self UseAnimTree(#animtree);
	self animscripted("a_cement_crush", self.origin, self.angles, %fxanim_cement_crush);
}

#using_animtree("fxanim_drywall_break");
drywall_break()
{
	level waittill("drywall_break_start");
	self UseAnimTree(#animtree);
	self animscripted("a_drywall_break", self.origin, self.angles, %fxanim_drywall_break);
}

#using_animtree("fxanim_propane_fall");
propane_fall()
{
	level waittill("propane_fall_start");	
	self UseAnimTree(#animtree);
	self animscripted("a_propane_fall", self.origin, self.angles, %fxanim_propane_fall);
	
	level waittill("propane_explode_now");
	wait(3);
	level notify("fx_acetylene_exp1");	
}

#using_animtree("fxanim_fence_door");
fence_door()
{
	level waittill("fence_door_start");
	self UseAnimTree(#animtree);
	self animscripted("a_fence_door", self.origin, self.angles, %fxanim_fence_door);
}

#using_animtree("fxanim_pipe_break");
pipe_break()
{
	level waittill("pipe_break_start");
	self UseAnimTree(#animtree);
	self animscripted("a_pipe_break", self.origin, self.angles, %fxanim_pipe_break);
}

#using_animtree("fxanim_pipe_drop_02");
pipe_drop_02()
{
	level waittill("pipe_drop_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_pipe_drop_02", self.origin, self.angles, %fxanim_pipe_drop_02);
}




#using_animtree("fxanim_ibeam_wire_tight");
ibeam_wire_tight()
{
	level waittill("ibeam_wire_tight_start");
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_ibeam_wire_tight", self[i].origin, self[i].angles, %fxanim_ibeam_wire_tight);
	}
}

#using_animtree("fxanim_ibeam_wire_loose");
ibeam_wire_loose()
{
	level waittill("ibeam_wire_loose_start");
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_ibeam_wire_loose", self[i].origin, self[i].angles, %fxanim_ibeam_wire_loose);
	}
}

#using_animtree("fxanim_streamer_4");
streamer_4()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_streamer_4", self.origin, self.angles, %fxanim_streamer_4);
}

#using_animtree("fxanim_streamer_5");
streamer_5()
{
	wait(1.0);
	self UseAnimTree(#animtree);
	self animscripted("a_streamer_5", self.origin, self.angles, %fxanim_streamer_5);
}



revivetest()
{
	reviveeffect( 1 );
	
	while( 1 )
	{		
		dval = 0.0;		
		for(i = 0; i < 10; i++)
		{			
			reviveeffectcenter( 1.9, 0.5, dval, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97 );
			dval = (dval + 0.1);
			wait(0.1);
		}

		dval = 1.0;		
		for(i = 0; i < 10; i++)
		{			
			reviveeffectcenter( 1.9, 0.5, dval, 1.56, 1.57, 1.69, 0.97, 1.0, 0.97 );
			dval = (dval - 0.1);
			wait(0.1);
		}
		wait( 3 );
	}
	
	
	
	
	
}

precacheFX()
{
	
	precacheShellshock( "default" );
	level._effect["fxspark01"] 		= loadfx ( "impacts/large_metalhit" );
	level._effect["fxwall01"] 		= loadfx ( "explosions/grenadeExp_concrete_1" );
	level._effect["fxsteam01"] 		= loadfx ( "impacts/pipe_steam" );
	level._effect["fxdust01"] 		= loadfx ( "dust/dust_trail_IR" );
	level._effect["fxfire2"] 		= loadfx ( "fire/flame_small_em" );
	level._effect["fxfire3"] 		= loadfx ( "fire/firelp_med_pm" );
	level._effect["water_pipe"] 	= loadfx ( "maps/constructionsite/const_water_pipe1" );		
	level._effect["falling_sand"] 	= loadfx ( "maps/constructionsite/const_falling_sand" );
	level._effect["sun_dust"] 		= loadfx ( "maps/constructionsite/const_sun_dust" );
	
	level._effect["fxburningfire"] 	= loadfx ( "maps/constructionsite/consite_burning_fire" );
	level._effect["fxceilingdebris1"] = loadfx ( "maps/constructionsite/const_ceilingdebris1" );
	level._effect["fxdusthaze1"] 	= loadfx ( "maps/constructionsite/const_dusthaze1" );
	level._effect["fxdusthaze2"] 	= loadfx ( "maps/constructionsite/const_dusthaze2" );
	level._effect["fxcuttersparks1"] = loadfx ( "maps/constructionsite/const_cuttersparks1" );	
	level._effect["fxsparkshower1"] = loadfx ( "maps/constructionsite/const_spark_shower1" );
	level._effect["fxsparkshower2"] = loadfx ( "maps/constructionsite/const_spark_shower2" );
	level._effect["fxdripwater1"] 	= loadfx ( "maps/constructionsite/const_dripping_water1" );
	level._effect["fxdripwater2"] 	= loadfx ( "maps/constructionsite/const_dripping_water2" );	
	level._effect["fxsteamvent1"] 	= loadfx ( "maps/constructionsite/const_steamventing1" );
	level._effect["fxsteamvent2"] 	= loadfx ( "maps/constructionsite/const_steamventing2" );
	level._effect["fxventingmist"] = loadfx ( "maps/constructionsite/const_steamventing3" );	
	level._effect["fxaltitudeair"] = loadfx ( "maps/constructionsite/const_altitude_air" );	
	level._effect["fxworkerFX1"] 	= loadfx ( "maps/constructionsite/const_workerFX1" );	
	level._effect["fxworkerFX2"] 	= loadfx ( "maps/constructionsite/const_workerFX2" );
	level._effect["fxworkerFX3"] 	= loadfx ( "maps/constructionsite/const_workerFX3" );
	level._effect["fxeSparks1"] 	= loadfx ( "maps/constructionsite/const_electrifiedSparks1" );	
	level._effect["fxpatchyFire1"] = loadfx ( "maps/constructionsite/const_patchyFire1" );
	level._effect["fxflys"] 		= loadfx ( "maps/constructionsite/const_gnats_fiesty" ); 
	level._effect["water_gush"] 	= loadfx ( "maps/casino/aston_vomit01" );
	
	level._effect["const_pipes_impact"] 	= loadfx ( "maps/constructionsite/const_pipes_impact" );
	
	level._effect["const_footstep_splash01"] 	= loadfx ( "maps/constructionsite/const_footstep_splash01" );
	level._effect["const_footstep_dust01"] 		= loadfx ( "maps/constructionsite/const_footstep_dust01" );
	level._effect["const_hitDust1"] 			= loadfx ( "maps/constructionsite/const_hitDust1" );
	level._effect["const_c4_exp"] 				= loadfx ( "maps/constructionsite/const_c4_exp" );
	level._effect["const_ShoulderBash1"] 		= loadfx ( "maps/constructionsite/const_ShoulderBash1" );
	level._effect["const_ElectrifiedPlayer1"] 	= loadfx ( "maps/constructionsite/const_ElectrifiedPlayer1" );
	level._effect["const_ElectrifiedPlayer2"] 	= loadfx ( "maps/constructionsite/const_ElectrifiedPlayer2" );
	level._effect["const_ElectrifiedPlayer3"] 	= loadfx ( "maps/constructionsite/const_ElectrifiedPlayer3" );
	level._effect["const_ElectrifiedPlayer4"]	= loadfx ( "maps/constructionsite/const_ElectrifiedPlayer4" );
	level._effect["const_CartCrash"] 			= loadfx ( "maps/constructionsite/const_CartCrash" );
	level._effect["const_bulletGodRays1"] 		= loadfx ( "maps/constructionsite/const_bulletGodRays1" );
	level._effect["const_StairsExplode"] 		= loadfx ( "maps/constructionsite/const_StairsExplode" );
	level._effect["const_AcetyleneTorch"] 		= loadfx ( "maps/constructionsite/const_AcetyleneTorch" );
	level._effect["const_CatwalkFire1"] 		= loadfx ( "maps/constructionsite/const_CatwalkFire1" );
	level._effect["const_Acetylene_Exp1"] 		= loadfx ( "maps/constructionsite/const_Acetylene_Exp1" );
	level._effect["const_Acetylene_Exp2"] 		= loadfx ( "maps/constructionsite/const_Acetylene_Exp2" );
	level._effect["const_Acetylene_Exp3"] 		= loadfx ( "maps/constructionsite/const_Acetylene_Exp3" );
	level._effect["const_AftermathFire1"] 		= loadfx ( "maps/constructionsite/const_AftermathFire1" );
	level._effect["const_MetalCrashSparks1"] 	= loadfx ( "maps/constructionsite/const_MetalCrashSparks1" );
	level._effect["const_MetalCrashDebris1"] 	= loadfx ( "maps/constructionsite/const_MetalCrashDebris1" );
	
	
	level._effect["const_DiggerCementImpact"] 	= loadfx ( "maps/constructionsite/const_digger_cement_impact" );
	level._effect["const_ShackDust"] 			= loadfx ( "maps/constructionsite/const_shack_dust" );
	level._effect["const_foliage_burst"] 		= loadfx ( "maps/constructionsite/const_foliage_burst" );
	level._effect["const_foliage_burst2"] 		= loadfx ( "maps/constructionsite/const_foliage_burst2" );
	level._effect["const_DrywallDust"] 			= loadfx ( "maps/constructionsite/const_drywall_dust" );
	level._effect["const_RoofDentDust"] 		= loadfx ( "maps/constructionsite/const_roofdent_dust" );
	level._effect["const_elevator_dust"] 		= loadfx ( "maps/constructionsite/const_elevator_smk_plume" );	
	level._effect["const_scissorlift_dust"] 		= loadfx ( "maps/constructionsite/const_scissor_dust_plume" );	
	level._effect["const_fireball_2"] 			= loadfx ( "maps/constructionsite/const_gas_explosion_emit" );	
	level._effect["const_elevator_sparks"] 		= loadfx ( "maps/constructionsite/const_MetalCrashSparks2" );	
	level._effect["const_cranepallet_dust"] 	= loadfx ( "maps/constructionsite/const_cranepallet_dust" );
	level._effect["const_glass_impact"] 		= loadfx ( "maps/constructionsite/const_glass_impact" );
	level._effect["const_digger_ws_runner"] 	= loadfx ( "maps/constructionsite/const_digger_ws_runner" );
	level._effect["const_digger_aftermath"] 	= loadfx ( "maps/constructionsite/const_digger_aftermath" );
	level._effect["const_oil_spray1"]			= loadfx ( "maps/constructionsite/const_oil_spray1" );
}
