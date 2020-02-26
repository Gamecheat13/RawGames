#include common_scripts\utility; 
#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;
#include maps\_busing;



main()
{

//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

 

 

//***************
//mak_Base
//***************   

            declareAmbientPackage( "mak_base_pkg" );            

                        addAmbientElement( "mak_base_pkg", "amb_seagull", 30, 60, 300, 2000 );
                        addAmbientElement( "mak_base_pkg", "amb_twigsnap", 30, 120, 10, 500 );
                        
 //***************
 //mak_indoor
 //***************   
 
             declareAmbientPackage( "mak_indoor_pkg" );         

                        
//***************
//mak_bunker
//***************

            declareAmbientPackage( "mak_bunker_pkg" );
            
            
            
                        
//***************
//mak_deepforest
//***************

            declareAmbientPackage( "mak_deepforest_pkg" );

			addAmbientElement( "mak_deepforest_pkg", "amb_seagull", 30, 60, 300, 2000 );
                        addAmbientElement( "mak_deepforest_pkg", "amb_twigsnap", 30, 120, 10, 500 );
                        addAmbientElement( "mak_deepforest_pkg", "amb_shortbugs", 5, 25, 10, 500 );
                       

           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//mak_Base
//***************

            declareAmbientRoom( "mak_base_room" );

                        setAmbientRoomTone( "mak_base_room", "bgt_base" );

 //***************
 //mak_indoor
 //***************
 
             declareAmbientRoom( "mak_indoor_room" );
 
                         setAmbientRoomTone( "mak_indoor_room", "bgt_base" );


//***************
//mak_bunker
//***************

            declareAmbientRoom( "mak_bunker_room" );

                        setAmbientRoomTone( "mak_bunker_room", "bgt_bunker" );
                        
//***************
//mak_deepforest
//***************
			
		declareAmbientRoom( "mak_deepforest_room" );
			
                        setAmbientRoomTone( "mak_deepforest_room", "bgt_base" );


//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            activateAmbientPackage( "mak_base_pkg", 0 );
            activateAmbientRoom( "mak_base_room", 0 );

 

	    
    
    
    
	 /*
	    declareMusicState("cross"); //wait until fade done
	    musicAliasLoop("test_song", 10, 5);
	    musicWaitTillDone();

	    declareMusicState("fadeout"); //fade out one shot
	    musicAlias("makin_torture", 3);

	*/	





 

//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************

	
	level thread flare_fire_1();
	level thread flare_fire_2();
	
	level thread start_environmental_sounds();
	level thread start_tower_creak();
	


}
music_switch_delay(time, state)
{
	wait(time);
	setmusicstate(state);

}
ambush_stuff()
{
	setbusstate("ambush");	
	wait (0.5);
	playsoundatposition("Mak1_IGD_050A_ROEB", (0,0,0));	
	//TUEY Audio for yelling & japanese lines
	playsoundatposition( "amb_yelling_japanese", ( -702, -15232.5, 200 ) ); 
	playsoundatposition( "amb_yelling", 	( -1358, -15008.5, 200 ) ); 
	wait(0.5);
	setbusstate("RESET_SLOW");
	setmusicstate( "AMBUSH" );
	battlechatter_on(); 


}


play_tower_creaks()
{
	level endon ("tower_collapse");
	while(1)
	{
		self playsound("tower_creak");
		wait(randomintrange(8,15));
	}

}


start_explosion_test()
{
	wait (1);
	origin_left = getent("exp_origin_left", "targetname");
	origin_right = getent("exp_origin_right", "targetname");
	target_left = getent("exp_target_left", "targetname");
	target_right = getent("exp_target_right", "targetname");
	
	
	ent1 = spawn("script_origin", origin_left.origin);
	//ent1 thread line_to_me(origin_left);
	ent2 = spawn("script_origin", origin_right.origin);
	//ent2 thread line_to_me(origin_right);
	
	

	ent1 playsound ("exp_hut_4_sweet_L");
	ent2 playsound ("exp_hut_4_sweet_R");
	
	ent1 moveto (target_left.origin, 1.5);
	ent2 moveto (target_right.origin, 1.5);
	

}
line_to_me(guy)
{
	self endon ("movedone");
	while (1)
	{
		line (self.origin, guy.origin, (1,1,1));
		wait 0.05;
	}
	
}
hut_4_exp()
{
	piece = GetEnt( "hut4_sound_piece", "script_noteworthy" );
	dest_pos = piece.origin + ( 0, -2500, 0 );
	piece MoveTo( dest_pos, 3 );

	wait(0.5);
	piece playsound("exp_whoosh");
	wait(1);
	level thread start_explosion_test();

	piece waittill( "movedone" );
	piece Delete();
}
//***************
//play siren
//***************
flare_fire_1()
{ 

	level waittill("flare_fire_1");
	wait(0.1);
	flare_fire_1 = getent("flare_starter1","targetname");
	flare_fire_1 playsound("flare1");
	wait(55);
	

} 

flare_fire_2()
{ 

	level waittill("flare_fire_2");
	wait(0.1);
	flare_fire_2 = getent("flare_starter2","targetname");
	flare_fire_2 playsound("flare2");
	

}
play_environmental_sound(sound_to_play, pos)
{
	sound = spawn("script_origin", pos);
	sound playloopsound(sound_to_play);

}
start_environmental_sounds()
{
	//level waittill ("beached");
	play_environmental_sound("hut_large_fire", (-9728, -16328, 0));
	play_environmental_sound("hut_small_fire", (-10264, -17640, 144));
	play_environmental_sound("hut_small_fire", (-9848, -17456, 144));
	play_environmental_sound("hut_small_fire", (-9648, -18104, 144));
	play_environmental_sound("hut_small_fire", (-10152, -17400, 144));
	play_environmental_sound("hut_small_fire", (-10248, -17128, 144));
	play_environmental_sound("hut_small_fire", (-10344, -17280, 48));	
	play_environmental_sound("hut_large_fire", (-10111.3, -17193.6, 147.125));
	play_environmental_sound("hut_large_fire", (-9527.22,-16175.7,211));
	play_environmental_sound("hut_large_fire", (-10375.4, -15862.2, 88));
	play_environmental_sound("hut_large_fire", (-10673.9, -15731.6, 134));
	play_environmental_sound("hut_large_fire", (-10928.3, -15588.5, 128));
	
	
}
change_music_wait(state, waittime)
{
	wait(waittime);
	change_music_state(state);
}
change_music_state(state)
{
	setMusicState(state);
}
start_tower_creak()
{
	creaksound = spawn ("script_origin", (-12088, -14936, 328));
	wait(0.1);
	creaksound playloopsound("hut_creak");
	flag_wait( "event1_hut1_collapse" );
	creaksound stoploopsound();
}
play_dragging_sound()
{
	level endon("IN_BOAT");
	
	while(1)
	{
		wait(randomintrange(1,3));
		{	
			playsoundatposition("drag", (0,0,0));
		}

	}

}
play_shock_loop_manual()
{
	playsoundatposition ("player_shock_loop", (0,0,0));
	level waittill ("IN_BOAT");
	playsoundatposition ("player_shock_end", (0,0,0));

}
