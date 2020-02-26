

#include maps\_utility;

#include common_scripts\ambientpackage;

#include maps\_fx;

 

 

main()

{









 






 

            declareAmbientPackage( "constructionsite_ext_pkg" );      
            

 
 
 
 
 
 
  
 
             declareAmbientPackage( "constructionsite_ext_wind_pkg" );  
             


 
 
 
 
 
  
 
             declareAmbientPackage( "constructionsite_ext_wind_low_pkg" );            






           








 
 
 
 
 
  
 
             declareAmbientRoom( "constructionsite_ext" );
 
  
 
                         setAmbientRoomTone( "constructionsite_ext", "amb_bg_constructionsite_ext" );
                         

 
 
 
 
 
  
 
             declareAmbientRoom( "constructionsite_int" );
 
  
 
                         setAmbientRoomTone( "constructionsite_int", "amb_bg_constructionsite_ext" );
                       	 setAmbientRoomReverb( "constructionsite_int", "hallway", 1, .5 );

   
  
 
  
  
  
  
  
   
  
              declareAmbientRoom( "constructionsite_ext_wind" );
  
   
  
                          setAmbientRoomTone( "constructionsite_ext_wind", "amb_bg_constructionsite_ext_wind" );
 
   

 
   
   
   
   
   
    
   
               declareAmbientRoom( "constructionsite_ext_wind_low" );
   
    
   
                           setAmbientRoomTone( "constructionsite_ext_wind_low", "amb_bg_constructionsite_ext_wind_low" );
  
 

 


                         



 



 



 
        setBaseAmbientPackageAndRoom( "constructionsite_ext_pkg", "constructionsite_ext" );

 

                                    signalAmbientPackageDeclarationComplete();



 

 

 



 



 



	
	loopSound("water_splashing_close", (-1125, -3471, -23), 7.808);
	loopSound("water_splashing_far", (-1125, -3471, -23), 6.570);
	loopSound("water_spray_close", (-1120, -3307, 102), 8.929);
	
	loopSound("dirt_fall_close", (-836, -3554, 24), 5.391);
	loopSound("dirt_fall_far", (-836, -3554, 24), 4.554);
	loopSound("dirt_fall_mid", (-836, -3554, 24), 4.138);
	
	
	loopSound("earth_mover_idle", (-652, -3821, 77), 22.185);
	
	loopSound("grinder_low_constant_01", (-662, -2022, 558), 3.392);
	loopSound("grinder_low_constant_01", (-765, -1890, 333), 3.392);
	loopSound("grinder_low_constant_01", (-623, -1702, 587), 3.392);
	
	loopSound("portable_generator", (-835, -3218, 152), 5.917);
	
	loopSound("welding_torch", (-618, -1273, 598), 6.185);
	
	loopSound("crane_rattle_loop", (1416, -768, 1672), 9.174);
	loopSound("crane_low_rumble", (2200, -2368, 1344), 14.848);
	
	loopSound("cement_mixer_close", (-603, -2009, 575), 7.534);
	loopSound("cement_mixer_far", (-603, -2009, 575), 5.518);







 



 



 

 

            

            

            
            
 	
	    
	    
	    
	    level thread climb_exert_one_play();
	    level thread jump_exert_one_play();
	    level thread climb_exert_two_play();
	    level thread ships_horn_play();
	    level thread jump_hurt_one_play();
	    level thread kill_jump_hurt_one();
	    level thread climb_exert_three_play();



 

}

 


 



 



crane_load_drop()
{
	pipe_crane_hook_var = GetEnt("pipe_crane_hook_org", "targetname");
	pipe_crane_load_var = GetEnt("pipe_crane_load_org", "targetname");
	pipe_crane_hook_var playsound("crane_load_fall");
	wait(0.46);
	pipe_crane_load_var playsound("crane_load_crash");

	
}

ships_horn_play()
{
	ships_horn_trigger_var = GetEnt("ships_horn_trigger", "targetname");
	ships_horn_org_var = GetEnt("ships_horn_org", "targetname");
	
	level endon ("insert_notify");
	while (1)
	{
		ships_horn_trigger_var waittill ("trigger");
		ships_horn_org_var playsound ("ships_horn");
	}
}	

jump_exert_one_play()
{
	jump_exert_one_trig_var = GetEnt("jump_exert_one_trig", "targetname");
	
	level endon ("insert_notify");
	while (1)
	{
		jump_exert_one_trig_var waittill ("trigger");
		level.player playlocalsound ("jump_exert_one");
	}
}	

climb_exert_one_play()
{
	climb_exert_one_trig_var = GetEnt("climb_exert_one_trig", "targetname");
	
	level endon ("insert_notify");
	while (1)
	{
		climb_exert_one_trig_var waittill ("trigger");
		level.player playlocalsound ("climb_exert_one");
	}
}	

climb_exert_two_play()
{
	climb_exert_two_trig_var = GetEnt("climb_exert_two_trig", "targetname");
	
	level endon ("insert_notify");
	while (1)
	{
		climb_exert_two_trig_var waittill ("trigger");
		level.player playlocalsound ("climb_exert_two");
	}
}	

jump_hurt_one_play()
{
	jump_hurt_one_trig_var = GetEnt("jump_hurt_one_trig", "targetname");
	
	level endon ("no_jump_hurt_one");
	while (1)
	{
		jump_hurt_one_trig_var waittill ("trigger");
		level.player playlocalsound ("jump_hurt_one");
	}
}

kill_jump_hurt_one()
{

	triggerstop = getent("kill_jump_hurt_one_trig", "targetname");
	triggerstop waittill ("trigger");
	level notify("no_jump_hurt_one");

}

climb_exert_three_play()
{
	climb_exert_three_trig_var = GetEnt("climb_exert_three_trig", "targetname");
	
	level endon ("insert_notify");
	while (1)
	{
		climb_exert_three_trig_var waittill ("trigger");
		level.player playlocalsound ("climb_exert_three");
	}
}	
