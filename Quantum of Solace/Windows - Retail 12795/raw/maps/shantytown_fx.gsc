#include maps\_utility;
#using_animtree("fx_shantytown_shackExplode1");

main()
{
	// Register event names for event-driven FX, creates a link to 
	// the game FX editor, "CreateFX"
	// Registered events are easy to find!
	// precache (test - not for pruduction)
	
	//Used for hiding placeholder fx -----------
	registerFXTargetName("fx_debug");							// This notify will be sent to the level when event occurs, to hook particle triggering
	registerFXTargetName("fx_OK");								
	// ------------------------------------
	
	
	registerFXTargetName("fx_propane_exp1");									// INITIAL EXPLOSION
	//registerFXTargetName("Alley_fire_ignite");								// INITIAL EXPLOSION
	//registerFXTargetName("Alley_ceiling_crash_1");  					// TEL POLE 1     									(FIRE INCREASES)
	//registerFXTargetName("Alley_ceiling_crash_2");  					// BEAM DIPS DOWN 									(WITH DEBRIS FX)
	//registerFXTargetName("Alley_ceiling_crash_3");  					// PANEL FALLS    									(  )
	//registerFXTargetName("Alley_fire_secondary explosion");				// SECONDARY EXPLOSION OFF TO RIGHS
	//registerFXTargetName("Alley_ceiling_crash_4");  					// CEILING COLLAPSES BLOCKING REAR	(JUST PARTICLES, NO MODEL ANIM)
	//registerFXTargetName("Alley_door_smash");  								// BOND BASHES DOOR WITH SHOULDER		
	//registerFXTargetName("Alley_ceiling_crash_5");  					// TEL POLE 2												
	//registerFXTargetName("Alley_Smoke_Column");  							// separating the smoke column so we can delete the other FX aftre the player passes through
	
	
	registerFXTargetName("shop_explosion");								// small propane/welding tanks explode in the garage/shop area
	registerFXTargetName("truck_explosion");								// starts the truck exploding right before level's end

	initFXModelAnims();
	
	precacheFX();
	
	maps\createfx\shantytown_fx::main();
	
	//START PROPANE FIRE THREAD
	//thread StartPropaneFire(500);
	
	// Uncomment the next line to test the notify sequence for Fire Alley - MM
	// thread testalley();
	
	
	//turn on approved fx previously hidden as debug
	level notify("fx_OK");

//=======================================================
//=======================================================
// View FX Test	

	eye = getent( "viewfx", "targetname" );	
	
			
	if (IsDefined(eye))
	{
		vision_fx = playfxontag(level._effect["grenade_teargas_viewfx"], eye, "TAG_ORIGIN");
		eye thread doFxUpdate();
	}	
	
//=======================================================
//=======================================================

	//turning on the quick kill effects
	level thread maps\_fx::quick_kill_fx_on();
}


//=======================================================
//=======================================================
// View FX Test

doFxUpdate()
{
	wait(1.0);
	
	println();
	println();
	println("************************************************************************************************************************************************");
	println("************************************************************************************************************************************************");
	println();
	println();
	
	tLerp = 0.03333;
	
	while(1)
	{
		if (IsDefined(level.player))
		{
			posvector = level.player getViewOrigin();
			dirvector = level.player getViewAngles();
			//print("-");
			self moveTo  (posvector, tLerp );
			// rotateTo(dirvector, tLerp );
		}
		wait(0.03);
	}
}
//=======================================================
//=======================================================


initFXModelAnims()
{
	ent_array1 = getentarray( "fxanim_seagull_circle", "targetname" );
	ent_array2 = getentarray( "fxanim_rope_arch", "targetname" );
	ent_array3 = getentarray( "fxanim_rope_long", "targetname" );
	ent_array4 = getentarray( "fxanim_rope_short", "targetname" );
	
	ent1 = getent( "fxanim_weapon_case_lrg", "targetname" );
	ent2 = getent( "fxanim_seagull_sitting", "targetname" );
	ent3 = getent( "fxanim_banana_banner", "targetname" );
	ent4 = getent( "fxanim_board_chuck", "targetname" );
	ent5 = getent( "fxanim_window_flap_01", "targetname" );
	ent6 = getent( "fxanim_window_flap_02", "targetname" );
		
	if (IsDefined(ent_array1)) { ent_array1 thread seagull_circle();   println("************* FX: seagull_circle *************"); }
	if (IsDefined(ent_array2)) { ent_array2 thread rope_arch();   println("************* FX: rope_arch *************"); }
	if (IsDefined(ent_array3)) { ent_array3 thread rope_long();   println("************* FX: rope_long *************"); }
	if (IsDefined(ent_array4)) { ent_array4 thread rope_short();   println("************* FX: rope_short *************"); }
	
	if (IsDefined(ent1)) { ent1 thread weapon_case_lrg();   println("************* FX: weapon_case_lrg *************"); }
	if (IsDefined(ent2)) { ent2 thread seagull_sitting();   println("************* FX: seagull_sitting *************"); }
	if (IsDefined(ent3)) { ent3 thread banana_banner();   println("************* FX: banana_banner *************"); }
	if (IsDefined(ent4)) { ent4 thread board_chuck();   println("************* FX: board_chuck *************"); }
	if (IsDefined(ent5)) { ent5 thread window_flap_01(); println("************* FX: window_flap_01 *************"); }
	if (IsDefined(ent6)) { ent6 thread window_flap_02(); println("************* FX: window_flap_02 *************"); }
}

#using_animtree("fxanim_seagull_circle");
seagull_circle()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_seagull_circle", self[i].origin, self[i].angles, %fxanim_seagull_circle);
	}
}

#using_animtree("fxanim_weapon_case_lrg");
weapon_case_lrg()
{
	level waittill("weapon_case_lrg_start");
	self UseAnimTree(#animtree);
	self animscripted("a_weapon_case_lrg", self.origin, self.angles, %fxanim_weapon_case_lrg);
}

#using_animtree("fxanim_seagull_sitting");
seagull_sitting()
{
	level waittill("seagull_sitting_start");
	self UseAnimTree(#animtree);
	self animscripted("a_seagull_sitting", self.origin, self.angles, %fxanim_seagull_sitting);
}

#using_animtree("fxanim_banana_banner");
banana_banner()
{
	level waittill("banana_banner_start");
	self UseAnimTree(#animtree);
	self animscripted("a_banana_banner", self.origin, self.angles, %fxanim_banana_banner);
}

#using_animtree("fxanim_board_chuck");
board_chuck()
{
	level waittill("board_chuck_start");
	self UseAnimTree(#animtree);
	self animscripted("a_board_chuck", self.origin, self.angles, %fxanim_board_chuck);
}

#using_animtree("fxanim_rope_arch");
rope_arch()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_rope_arch", self[i].origin, self[i].angles, %fxanim_rope_arch);
	}
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

#using_animtree("fxanim_rope_short");
rope_short()
{
	wait(1.0);
	for (i=0; i<self.size; i++)
	{
		self[i] UseAnimTree(#animtree);
		self[i] animscripted("a_rope_short", self[i].origin, self[i].angles, %fxanim_rope_short);
	}
}

#using_animtree("fxanim_window_flap");
window_flap_01()
{
	level waittill("window_flap_01_start");
	self UseAnimTree(#animtree);
	self animscripted("a_window_flap_01", self.origin, self.angles, %fxanim_window_flap);
}

#using_animtree("fxanim_window_flap");
window_flap_02()
{
	level waittill("window_flap_02_start");
	self UseAnimTree(#animtree);
	self animscripted("a_window_flap_02", self.origin, self.angles, %fxanim_window_flap);
}


testalley()
{
	wait(20.0);
	level notify("Alley_fire_ignite");
	wait(5.0);
	level notify("Alley_ceiling_crash_1");
	wait(5.0);
	level notify("Alley_ceiling_crash_2");
	wait(5.0);
	level notify("Alley_ceiling_crash_3");
	wait(5.0);
	level notify("Alley_fire_secondary explosion");
	wait(5.0);
	level notify("Alley_ceiling_crash_4");
	wait(5.0);
	level notify("Alley_door_smash");
	wait(5.0);
	level notify("Alley_ceiling_crash_5");
}


precacheFX()
{	
	//level._effect["TestFX"] = loadfx ("testfx");


	level._effect["chimney_small"]						= loadfx ("smoke/chimney_small");
	
	//propane tank
	level._effect["shanty_spotfire_lg"]				= loadfx ("maps/shantytown/shanty_spotfire_lg");
	level._effect["shanty_spotfire_med"]				= loadfx ("maps/shantytown/shanty_spotfire_med");
	level._effect["shanty_spotfire_sm"]				= loadfx ("maps/shantytown/shanty_spotfire_sm");
	
	//level._effect["propane_tank_explode"]			= loadfx ("maps/shantytown/propane_tank_explode");
	level._effect["shanty_burning_fire"]			= loadfx ("maps/shantytown/shanty_spotfire_lg");
	
	//fire alley, CG - don't need these any more, removing for memory
	//level._effect["shanty_firealley_bomb"]			= loadfx ("maps/shantytown/shanty_firealley_bomb");
	//level._effect["shanty_alley_secondaryexp"]	= loadfx ("maps/shantytown/shanty_alley_secondaryexp");
	//level._effect["shanty_alley_fire_light"]		= loadfx ("maps/shantytown/shanty_alley_fire_light");
	//level._effect["shanty_alley_smoke_haze"]		= loadfx ("maps/shantytown/shanty_alley_smoke_haze");
	//level._effect["shanty_alleyflames200"]		= loadfx ("maps/shantytown/shanty_alleyflames200");
	//level._effect["shanty_alleyflames200slo"]		= loadfx ("maps/shantytown/shanty_alleyflames200slo");
	//level._effect["shanty_alleyflames50"]			= loadfx ("maps/shantytown/shanty_alleyflames50");
	//level._effect["shanty_alley_smokecolumn"]		= loadfx ("maps/shantytown/shanty_alley_smokecolumn");
	//level._effect["shanty_alleyfire_shimmer"]		= loadfx ("maps/shantytown/shanty_alleyfire_shimmer");
	//level._effect["shanty_alleyfire_cinders"]		= loadfx ("maps/shantytown/shanty_alleyfire_cinders");
	//level._effect["shanty_window_explode01"]		= loadfx ("maps/shantytown/shanty_window_explode01");
	//level._effect["shanty_window_explode02"]		= loadfx ("maps/shantytown/shanty_window_explode02");
	
	//car bomb
	level._effect["shanty_carbomb_exp"]					= loadfx ("maps/shantytown/shanty_carbomb_exp");
	level._effect["shanty_carbomb_crashland"]		= loadfx ("maps/shantytown/shanty_carbomb_crashland");
	level._effect["shanty_elec_sparks01"]				= loadfx ("maps/shantytown/shanty_elec_sparks01");
	level._effect["shanty_elec_sparks02"]				= loadfx ("maps/shantytown/shanty_elec_sparks02");
	level._effect["shanty_elec_sparks03"]				= loadfx ("maps/shantytown/shanty_elec_sparks03");
	level._effect["shanty_elec_sparks04"]				= loadfx ("maps/shantytown/shanty_elec_sparks04");
	level._effect["shanty_carbomb_polecrash"]		= loadfx ("maps/shantytown/shanty_carbomb_polecrash");

	//misc
	level._effect["Shanty_SmokeWind"]						= loadfx ("maps/shantytown/Shanty_SmokeWind");
	level._effect["Shanty_env_smoke"]						= loadfx ("maps/shantytown/Shanty_env_smoke");
	level._effect["Shanty_bbq"]									= loadfx ("maps/shantytown/Shanty_bbq");
	level._effect["shanty_startled_birds"]			= loadfx ("maps/shantytown/shanty_startled_birds");
	level._effect["shanty_container_exp"] 			= loadfx ("maps/shantytown/shanty_container_exp");
	level._effect["shanty_gnats"]						= loadfx ("maps/shantytown/shanty_gnats");
	level._effect["shanty_gnats_fiesty"]				= loadfx ("maps/shantytown/shanty_gnats_fiesty");
	level._effect["shanty_windy_trash"]					= loadfx ("maps/shantytown/shanty_windy_trash");
	level._effect["shanty_bustthrough_gate"]			= loadfx ("maps/shantytown/shanty_bustthrough_gate");
	level._effect["shanty_bar_shooting"]				= loadfx ("maps/shantytown/shanty_bar_shooting");
	level._effect["shanty_bar_aftermath"]				= loadfx ("maps/shantytown/shanty_bar_aftermath");
	
	level._effect["default_explosion"]					= loadfx ("maps/shantytown/shanty_butane_tank_exp");
	
	level._effect["shanty_windy_dust1"]					= loadfx ("maps/shantytown/shanty_windy_dust01");
	
	//temp
	level._effect["hawk"]								= loadfx ("weather/hawk");
	level._effect["firelp_small_pm_a"]					= loadfx ("fire/firelp_small_pm_a");
	level._effect["muzzleflash"]						= loadfx ("muzzleflashes/standardflashworld");
	
	//impact
	level._effect["exp_fruit_bananas"]					= loadfx ("breakables/exp_fruit_bananas");
	level._effect["exp_fruit_watermellons"]			= loadfx ("breakables/exp_fruit_watermellons");
	
	//level._effect["grenade_teargas_viewfx"] 		= loadfx ("weapons/MP/grenade_teargas_viewfx");
	
	level._effect["shanty_speedboat_spray2"] 				= loadfx ("maps/shantytown/shanty_speedboat_spray2");
	
	
	if ( level.ps3 == true ) //GEBE
	{
	level._effect["Shanty_dustywind"]						= loadfx ("maps/shantytown/Shanty_dustywind_PS3");
	level._effect["heat_shimmer"]						= loadfx ("weather/heat_shimmer_PS3");
	
	}
else
	{
	level._effect["Shanty_dustywind"]						= loadfx ("maps/shantytown/Shanty_dustywind");
	level._effect["heat_shimmer"]						= loadfx ("weather/heat_shimmer");
	
	}

}

link_effect_to_ent( effectID, bone, offset, angle )
{
	ent_tag = Spawn( "script_model", self.origin );
	ent_tag SetModel( "tag_origin" );
	ent_tag.angles = self.angles;
	ent_tag LinkTo( self, bone, offset, angle );
		
	PlayFxOnTag( level._effect[effectID], ent_tag, "tag_origin" );
}

container_propane_explosion()
{
		vPos = (-2226.84,596.46,70.0);
		vDir = (0,88,0);
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
  	playfx( level._effect["shanty_container_exp"], vPos, vFwd, vUp);
  	
  	vPos = (-1969,250,212);
  	vDir = (88.0,104,0);
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
		playfx( level._effect["shanty_startled_birds"], vPos, vFwd, vUp);
		
		vPos = (-2421,13,212);
  	vDir = (88.0,104,0);
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
		playfx( level._effect["shanty_startled_birds"], vPos, vFwd, vUp);
		
		vPos = (-2683,678,164);
  	vDir = (86.5,222.4,178.5);	
		vFwd = anglestoforward(vDir);
		vUp  = anglestoup(vDir);
		playfx( level._effect["shanty_startled_birds"], vPos, vFwd, vUp);
		
  //	playfx( level._effect["shanty_startled_birds"], (-1966,206,30),  (0,1,0));
  //	playfx( level._effect["shanty_startled_birds"], (-2790,510,30),  (0,1,0));
  //	playfx( level._effect["shanty_startled_birds"], (-2160,-300,30), (0,1,0));
  //	playfx( level._effect["shanty_startled_birds"], (-2650,-803,30), (0,1,0));
}


StartPropaneFire(delay)
{
		level waittill("propane_explode");
		
		//playfx(level._effect["shanty_spotfire_med"],	(-1055.82,-129.897,88.3064) );
		//playfx(level._effect["shanty_spotfire_med"], 	(-1175.19,-143.256,15) );
		//playfx(level._effect["shanty_spotfire_sm"], 	(-1040.94,-0.690957,13.9864) );
		//playfx(level._effect["shanty_spotfire_sm"], 	(-1078.13,168.34,8.1991) );
		//playfx(level._effect["shanty_spotfire_sm"], 	(-1027.76,189.661,0.892118) );
		//playfx(level._effect["shanty_spotfire_med"], 	(-1166.74,-169.604,9.3108) );
		//playfx(level._effect["shanty_spotfire_med"], 	(-1010.8,229.458,9.7431) ); 
}