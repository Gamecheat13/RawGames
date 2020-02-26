

#include maps\_utility;

#include common_scripts\ambientpackage;

#include maps\_fx;

 

 

main()

{











			
			
 
 
 
 
 
 
  
 
             declareAmbientPackage( "operahouse_ext_1_pkg" );            

   			
        
 
 
 
 
 
 
  
 
             declareAmbientPackage( "operahouse_ext_2_pkg" );            

   			
 
 






  	             	
  	             	
 
 
 
 
 
 
  
 
             declareAmbientRoom( "operahouse_ext_1" );
  
 
                        setAmbientRoomTone( "operahouse_ext_1", "amb_bg_opera_ext_01", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "operahouse_ext_1", "city", 1, 0.9 );
  	             	

 
 
 
 
 
 
  
 
             declareAmbientRoom( "operahouse_ext_2" );
  
 
                        setAmbientRoomTone( "operahouse_ext_2", "amb_bg_opera_ext_02", 0.3, 0.5 );
  	             	setAmbientRoomReverb( "operahouse_ext_2", "city", 1, 0.9 );

  

             



 



 



 
            setBaseAmbientPackageAndRoom( "operahouse_ext_1_pkg", "operahouse_ext_1" );

 

                                    signalAmbientPackageDeclarationComplete();


 


 



 




	loopSound("steam_leak_high", (5253, -430, -376), 8.874);
	loopSound("steam_leak_low", (5253, -430, -376), 7.679);
	loopSound("steam_leak_high", (5248, -1047, -348), 8.874);
	loopSound("steam_leak_low", (5248, -1047, -348), 7.679);
	loopSound("transformer_hum", (4815,-687,-334), 5.45);
	loopSound("transformer_hum_02", (3929,-348,540), 5.45);
	loopSound("gas_lantern", (3516, -1419, -378), 4.287);
	loopSound("gas_lantern", (5220, -1591, -211), 4.287);
	loopSound("gas_lantern", (5211, -1910, -199), 4.287);
	
	loopSound("pipe_hiss", (6503, -930, -322), 0.649);
	loopSound("pipe_hiss_02", (6602, -731, -266), 0.649);
	loopSound("pipe_hiss_02", (6191, -489, -163), 0.649);
	loopSound("pipe_hiss_02", (2156, -2813, -267), 0.649);
	loopSound("pipe_hiss_03", (2249, -3246, -328), 0.649);
	
	loopSound("light_buzz_03", (6269, -429, -250), 5.099);
	loopSound("light_buzz_04", (6269, -429, -250), 5.099);
	loopSound("light_buzz_03", (7267, -866, -252), 5.099);
	loopSound("light_buzz_04", (7267, -866, -252), 5.099);
	loopSound("light_buzz_03", (5281, 273, -178), 5.099);
	loopSound("light_buzz_04", (5281, 273, -178), 5.099);
	loopSound("light_buzz_03", (4957, 1319, -186), 5.099);
	loopSound("light_buzz_04", (4957, 1319, -186), 5.099);
	loopSound("light_buzz_03", (3983, 2015, -180), 5.099);
	loopSound("light_buzz_04", (3983, 2015, -180), 5.099);
	
	loopSound("light_buzz_05", (5040, -435, -339), 5.099);
	loopSound("light_buzz_06", (5040, -435, -339), 5.099);
	loopSound("light_buzz_05", (5026, -1028, -340), 5.099);
	loopSound("light_buzz_06", (5026, -1028, -340), 5.099);
	loopSound("light_buzz_05", (5471, -923, -358), 5.099);
	loopSound("light_buzz_06", (5471, -923, -358), 5.099);
	loopSound("light_buzz_05", (5467, -703, -357), 5.099);
	loopSound("light_buzz_06", (5467, -703, -357), 5.099);
	loopSound("light_buzz_05", (3966, -1271, 55), 5.099);
	loopSound("light_buzz_06", (3966, -1271, 55), 5.099);
	loopSound("light_buzz_05", (3948, -1197, 521), 5.099);
	loopSound("light_buzz_06", (3948, -1197, 521), 5.099);
	loopSound("light_buzz_05", (5576, -777, -337), 5.099);
	loopSound("light_buzz_06", (5576, -777, -337), 5.099);
	
	
	 



 



 



 

 

            

            

            
            
 	    
 	    
   	    start_static_zone_emitters();
	    
  	    level thread play_slow_rope_creaks_a();

 	    level thread play_slow_rope_creaks_b();

	    level thread play_metal_creaks_a();

	    level thread play_metal_creaks_b();

	    level thread play_metal_groans_a();
	    
	    level thread play_metal_groans_b();
	    
	    level thread start_vocal();
	    
	    level thread start_mozart();
	    
	    level thread start_pa_system();
	    
	    
	    
	    level thread play_ships_bell();
}

 


 



 





start_static_zone_emitters()
{
	opera_shoreline_zone_var = getent("opera_shore_line_zone", "targetname");

	if(IsDefined(opera_shoreline_zone_var))
	{
		opera_shoreline_zone_var playloopsound("amb_opera_shoreline");
	}
	
	opera_water_lap_zone_var = getent("opera_water_lap_zone", "targetname");

	if(IsDefined(opera_water_lap_zone_var))
	{
		opera_water_lap_zone_var playloopsound("opera_water_lap_close");
	}

	opera_water_lap_b_zone_var = getent("opera_water_lap_b_zone", "targetname");

	if(IsDefined(opera_water_lap_b_zone_var))
	{
		opera_water_lap_b_zone_var playloopsound("opera_water_lap_close_02");
	}

	opera_water_lap_c_zone_var = getent("opera_water_lap_c_zone", "targetname");

	if(IsDefined(opera_water_lap_c_zone_var))
	{
		opera_water_lap_c_zone_var playloopsound("opera_water_lap_close_03");
	}

	opera_water_lap_d_zone_var = getent("opera_water_lap_d_zone", "targetname");

	if(IsDefined(opera_water_lap_d_zone_var))
	{
		opera_water_lap_d_zone_var playloopsound("opera_water_lap_close_04");
	}

	rope_creak_hi_a_zone_var = getent("rope_creak_hi_a_zone", "targetname");
	
	if(IsDefined(rope_creak_hi_a_zone_var))
	{
		rope_creak_hi_a_zone_var playloopsound("rope_creak_hi_01");
	}

	rope_creak_hi_b_zone_var = getent("rope_creak_hi_b_zone", "targetname");
	
	if(IsDefined(rope_creak_hi_b_zone_var))
	{
		rope_creak_hi_b_zone_var playloopsound("rope_creak_hi_02");
	}

	light_buzz_a_zone_var = getent("light_buzz_a_zone", "targetname");
	
	if(IsDefined(light_buzz_a_zone_var))
	{
		light_buzz_a_zone_var playloopsound("light_buzz_01");
	}

}	

play_slow_rope_creaks_a()
{
	level endon ("insert_notify");
	while (1)
	{
		slow_rope_creaks_a_zone_var = getent("slow_rope_creaks_a_zone", "targetname");
		if(IsDefined(slow_rope_creaks_a_zone_var))
		{
			wait( RandomFloatRange( 8.5, 10.0 ) );
			slow_rope_creaks_a_zone_var playsound("slow_rope_creak_01");
		}
		
		wait(0.01);
	}
}	

play_slow_rope_creaks_b()
{
	level endon ("insert_notify");
	while (1)
	{
		slow_rope_creaks_b_zone_var = getent("slow_rope_creaks_b_zone", "targetname");
		if(IsDefined(slow_rope_creaks_b_zone_var))
		{
			wait( RandomFloatRange( 7.5, 11.0 ) );
			slow_rope_creaks_b_zone_var playsound("slow_rope_creak_02");
		}
		
		wait(0.01);
	}
}	

play_metal_creaks_a()
{
	level endon ("insert_notify");
	while (1)
	{
		metal_creaks_a_zone_var = getent("metal_creaks_a_zone", "targetname");
		if(IsDefined(metal_creaks_a_zone_var))
		{
			wait( RandomFloatRange( 9.5, 13.0 ) );
			metal_creaks_a_zone_var playsound("metal_creak_01");
		}
		
		wait(0.01);
	}
}	

play_metal_creaks_b()
{
	level endon ("insert_notify");
	while (1)
	{
		metal_creaks_b_zone_var = getent("metal_creaks_b_zone", "targetname");
		if(IsDefined(metal_creaks_b_zone_var))
		{
			wait( RandomFloatRange( 7.0, 12.5 ) );
			metal_creaks_b_zone_var playsound("metal_creak_02");
		}
		
		wait(0.01);
	}
}

play_metal_groans_a()
{
	level endon ("insert_notify");
	while (1)
	{
		metal_groans_a_zone_var = getent("metal_groans_a_zone", "targetname");
		if(IsDefined(metal_groans_a_zone_var))
		{
			wait( RandomFloatRange( 8.5, 14.0 ) );
			metal_groans_a_zone_var playsound("metal_groan_01");
		}
		
		wait(0.01);
	}
}	

play_metal_groans_b()
{
	level endon ("insert_notify");
	while (1)
	{
		metal_groans_b_zone_var = getent("metal_groans_b_zone", "targetname");
		if(IsDefined(metal_groans_b_zone_var))
		{
			wait( RandomFloatRange( 7.5, 16.0 ) );
			metal_groans_b_zone_var playsound("metal_groan_02");
		}
		
		wait(0.01);
	}
}	

start_pa_system()
{
	pa_system_trig_var = GetEnt("pa_system_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(pa_system_trig_var))
	{
		while (1)
		{
			pa_system_trig_var waittill ("trigger");
			
			pa_system_zone_var = getent("pa_system_zone", "targetname");
	
			if(IsDefined(pa_system_zone_var))
			{
				wait(12.5);
				pa_system_zone_var stoploopsound();
				pa_system_zone_var playloopsound("pa_connect");
				wait(15.2);
				pa_system_zone_var stoploopsound();
				pa_system_zone_var playloopsound("mendelssohn");
				wait(24.9);
				pa_system_zone_var stoploopsound();
				pa_system_zone_var playloopsound("wagner");
			}
			
			wait(0.01);
		}
	}	
}

start_mozart()
{
	schubert_trig_var = GetEnt("schubert_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(schubert_trig_var))
	{
		while (1)
		{
			schubert_trig_var waittill ("trigger");
			
			pa_system_zone_var2 = getent("pa_system_zone", "targetname");
	
			if(IsDefined(pa_system_zone_var2))
			{
				wait(0.5);
				pa_system_zone_var2 stoploopsound();
				pa_system_zone_var2 playloopsound("mozart");
			}
			
			wait(0.01);
		}
	}	
}

start_vocal()
{
			
	pa_system_zone_var3 = getent("pa_system_zone", "targetname");

	if(IsDefined(pa_system_zone_var3))
	{
		wait(0.5);
		pa_system_zone_var3 playloopsound("vocal");
	}
			
}


	

play_ships_bell()
{
	ships_bell_trig_var = GetEnt("ships_bell_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(ships_bell_trig_var))
	{
		while (1)
		{
			ships_bell_trig_var waittill ("trigger");
			
			ships_bell_org_var = getent("ships_bell_org", "targetname");
	
			if(IsDefined(ships_bell_org_var))
			{
				wait(5.5);
				ships_bell_org_var playsound("ships_bell");
			}
			
			wait(0.01);
		}
	}	
}


snd_light_flicker(bool_flicker, intensity_min, intensity_max, sound_name, sound_length_min, sound_length_max)
{
	if (!IsDefined(self.light_intensity_start))
	{
		self.light_intensity_start = self GetLightIntensity();
	}

	if (!IsDefined(intensity_min))
	{
		intensity_min = 0;
	}

	if (!IsDefined(intensity_max))
	{
		intensity_max = self.light_intensity_start;
	}

	if ((IsDefined(bool_flicker)) && (!bool_flicker))
	{
		self notify("stop_light_flicker");
		wait .05;
		self SetLightIntensity(intensity_min);
	}
	else
	{
		self endon("stop_light_flicker");

		
		
			
		
		t = ( RandomFloatRange( sound_length_min, sound_length_max ) );

		while (true)
		{
			if (IsDefined(sound_name))
			{
				if (t >= ( RandomFloatRange( sound_length_min, sound_length_max )))
				{
					self playsound(sound_name);
					t = 0;
				}
			}

			self SetLightIntensity(RandomFloatRange(intensity_min, intensity_max + 1));

			wait .05;
			t += .05;
		}
	}
}

play_stage_move_01()
{
	stage_move_01a_org = spawn("script_origin", (3744, -889, 39));
	stage_move_01b_org = spawn("script_origin", (3670, -894, 438));
	stage_move_01c_org = spawn("script_origin", (3945, -584, 215));
	stage_move_01a_org playsound("stage_move_01a");
	stage_move_01b_org playsound("stage_move_01b");
	stage_move_01c_org playsound("stage_move_01c");
	
	
	
}	

play_stage_move_02()
{
	stage_move_02_org = spawn("script_origin", (3695, -731, -199));
	stage_move_02_org playsound("stage_move_02");
	
	
	
}	

play_stage_move_03()
{
	stage_move_03_org = spawn("script_origin", (4382, -672, 86));
	stage_move_03_org playsound("stage_move_03");
	
	
	
}	

play_stage_move_04()
{
	stage_move_04a_org = spawn("script_origin", (4242, -678, 8));
	stage_move_04b_org = spawn("script_origin", (4800, -687, -33));
	stage_move_04c_org = spawn("script_origin", (3977, -1031, 98));
	stage_move_04d_org = spawn("script_origin", (3948, -682, 312));
	stage_move_04a_org linkto(level.stage.arm);
	stage_move_04b_org linkto(level.stage.arm);
	stage_move_04c_org linkto(level.stage.screen_l);
	stage_move_04d_org linkto(level.stage.iris);
	stage_move_04a_org playsound("stage_move_04a");
	stage_move_04b_org playsound("stage_move_04b");
	stage_move_04d_org playsound("stage_move_04d");
	wait(2.0);
	stage_move_04c_org playsound("stage_move_04c");
	
	
	
}

stop_wagner()
{
	pa_system_zone_var4 = getent("pa_system_zone", "targetname");

	if(IsDefined(pa_system_zone_var4))
	{
		wait(0.5);
		pa_system_zone_var4 stoploopsound();
		pa_system_zone_var4 playsound("pa_stop");
	}
}

start_mozart_02()
{
	pa_system_zone_var5 = getent("pa_system_zone", "targetname");
	
	if(IsDefined(pa_system_zone_var5))
	{
		wait(3.2);
		pa_system_zone_var5 playloopsound("mozart_02");
	}
}	

start_offenbach()
{
	offenbach_trig_var = GetEnt("offenbach_trig", "targetname");
	level endon ("insert_notify");
	if(IsDefined(offenbach_trig_var))
	{
		while (1)
		{
			offenbach_trig_var waittill ("trigger");
			
			pa_system_zone_var6 = getent("pa_system_zone", "targetname");
	
			if(IsDefined(pa_system_zone_var6))
			{
				wait(3.5);
				pa_system_zone_var6 stoploopsound();
				pa_system_zone_var6 playloopsound("offenbach");
			}
			
			wait(0.01);
		}
	}	
}

start_rimsky()
{
			
	pa_system_zone_var6 = getent("pa_system_zone", "targetname");

	if(IsDefined(pa_system_zone_var6))
	{
		wait(2.5);
		pa_system_zone_var6 stoploopsound();
		pa_system_zone_var6 playloopsound("rimsky");
	}
			
}

start_liszt()
{
			
	pa_system_zone_var6 = getent("pa_system_zone", "targetname");

	if(IsDefined(pa_system_zone_var6))
	{
		wait(2.5);
		pa_system_zone_var6 stoploopsound();
		pa_system_zone_var6 playloopsound("liszt");
	}
			
}

start_dvorak()
{
			
	pa_system_zone_var6 = getent("pa_system_zone", "targetname");

	if(IsDefined(pa_system_zone_var6))
	{
		wait(2.5);
		pa_system_zone_var6 stoploopsound();
		pa_system_zone_var6 playloopsound("dvorak");
	}
			
}

play_container_lower()
{
	container_hook_org = spawn("script_origin", (7195, -1064, -74));
	container_splash_org = spawn("script_origin", (7071, -1050, -383));
	container_hook_org playsound("container_lower");
	container_splash_org playsound("container_splash");
	wait(10.0);
	container_hook_org delete();
	container_splash_org delete();
}
	
play_boat_crash()
{
	patrol_boat_org = spawn("script_origin", (5452, 1620, -289));
	crash_a_org = spawn("script_origin", (5423, 1167, -347));
	crash_b_org = spawn("script_origin", (4985, 1477, -303));
	patrol_boat_org playsound("boat_crash");
	wait(3.6);
	crash_a_org playsound("boat_crash_a");
	crash_a_org playloopsound("dock_fire_01", 1.8);
	crash_b_org playsound("boat_crash_b_02");
	wait(0.4);
	crash_b_org playsound("boat_crash_b");
	wait(10.0);
	patrol_boat_org delete();
}	
