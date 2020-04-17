/*-----------------------------------------------------
Ambient stuff
-----------------------------------------------------*/
#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;



main()
{
level.mobile_sound = getent("GET_civilians_walla_male","targetname");

//************************************************************************************************
//                                              Looping Emitters
//************************************************************************************************


//First Floor Water Laps

	loopSound("get_waterlap_floor1_LP", (2516, -4286, 123), 37.69);

//Second Floor Water Laps
	loopSound("get_waterlap_floor2_LP", (2300, -4706, 368), 37.69);
	loopSound("get_waterlap_floor2_LP", (2561, -4820, 349), 37.69);
	loopSound("get_waterlap_floor2_LP", (2834, -4762, 351), 37.69);
	loopSound("get_waterlap_floor2_LP", (2947, -4531, 349), 37.69);
	loopSound("get_waterlap_floor2_LP", (2689, -4239, 348), 37.69);
	loopSound("get_waterlap_floor2_LP", (2577, -3846, 349), 37.69);

//Third Floor Water Laps
	loopSound("get_waterlap_floor2_LP", (2839, -4525, 485), 37.69);
	loopSound("get_waterlap_floor2_LP", (2777, -4781, 485), 37.69);

//Flies
	loopSound("GET_Flies_Loop", (1755, 551, 206), 13);	
	loopSound("GET_Flies_Loop", (1034, 505, 211), 13);	


//************************************************************************************************
//                                              Temp Quick Kill Crap
//************************************************************************************************

	bond = level.player; 

	// example: the "wpn_p99_fire_plyr" soundalias is played when the "action_1" notetrack is sent by bond
	// interaction_add_repeating_notetrack_sound( "action_1", "wpn_p99_fire_plyr", bond );


//QKGrbPnch Input
//FRAME 209 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_gp_input", "snd_gp_input", bond );

//QKGrbPnch Lead
//FRAME 195 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_gp_lead", "snd_gp_lead", bond );

//QKGrbPnch Success
//FRAME 230 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_gp_sucsess", "snd_gp_success", bond );

//QKGrbPnch Fail
//FRAME 230 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_gp_fail", "snd_gp_fail", bond );

//QKNeckSnap Input
//FRAME 112 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_ns_input", "snd_ns_input", bond );

//QKNeckSnap Lead
//FRAME 97 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_ns_lead", "snd_ns_lead", bond );

//QKNeckSnap Success
//FRAME 132 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_ns_sucsess", "snd_ns_success", bond );

//QKNeckSnap Fail
//FRAME 170 First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_ns_fail", "snd_ns_fail", bond );

//QKRoofThrow Lead
// First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_tr_lead", "snd_tr_lead", bond );

//QKRoofThrow Success
// First Frame Of Anim
	interaction_add_repeating_notetrack_sound( "notesound_tr_sucsess", "snd_tr_success", bond );





	

//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

 

//***************
//Venice_Ext_1shot
//***************   

            declareAmbientPackage( "Venice_Ext_1shot" );       

                        //addAmbientElement( "Venice_Ext_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Venice_Ext_1shot", "amb_boats", 6, 45, 500, 1000 );
			
//***************
//gettler_house_floor1_pkg
//***************

            declareAmbientPackage( "gettler_house_floor1_pkg" );       

                        //addAmbientElement( "Venice_Ext_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Venice_Ext_1shot", "amb_boats", 6, 45, 500, 1000 ); 
//***************
//gettler_house_floor2_pkg
//***************

            declareAmbientPackage( "gettler_house_floor2_pkg" );       

                        //addAmbientElement( "Venice_Ext_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Venice_Ext_1shot", "amb_boats", 6, 45, 500, 1000 );                        
//***************
//gettler_house_floor3_pkg
//***************

            declareAmbientPackage( "gettler_house_floor3_pkg" );       

                        //addAmbientElement( "Venice_Ext_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Venice_Ext_1shot", "amb_boats", 6, 45, 500, 1000 );                        
//***************
//gettler_house_floor4_pkg
//***************

            declareAmbientPackage( "gettler_house_floor4_pkg" );       

                        //addAmbientElement( "Venice_Ext_1shot", "amb_birds", 6, 45, 500, 1000 );
			//addAmbientElement( "Venice_Ext_1shot", "amb_boats", 6, 45, 500, 1000 ); 


           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

//***************
//GET_AMB_EXT_MainStreet
//***************

            declareAmbientRoom( "GET_AMB_EXT_MainStreet" );

                        setAmbientRoomTone( "GET_AMB_EXT_MainStreet", "GET_AMB_EXT_MainStreet", 2, 5 );
			setAmbientRoomReverb( "GET_AMB_EXT_MainStreet", "city", 1, .7 );
//***************
//GET_AMB_EXT_Street_1
//***************

            declareAmbientRoom( "GET_AMB_EXT_Street_1" );

                        setAmbientRoomTone( "GET_AMB_EXT_Street_1", "GET_AMB_EXT_Street_1", .5, 1 );
			setAmbientRoomReverb( "GET_AMB_EXT_Street_1", "city", 1, .7 );


//***************
//GET_AMB_EXT_Street_2
//***************

            declareAmbientRoom( "GET_AMB_EXT_Street_2" );

                        setAmbientRoomTone( "GET_AMB_EXT_Street_2", "GET_AMB_EXT_Street_2", .5, 2 );
			setAmbientRoomReverb( "GET_AMB_EXT_Street_2", "city", 1, .7 );


//***************
//GET_AMB_EXT_Harbour
//***************

            declareAmbientRoom( "GET_AMB_EXT_Harbour" );

                        setAmbientRoomTone( "GET_AMB_EXT_Harbour", "GET_AMB_EXT_Harbour", 1, 5 );
			setAmbientRoomReverb( "GET_AMB_EXT_Harbour", "city", 1, .7 );

//***************
//GET_AMB_EXT_Sewer
//***************

            declareAmbientRoom( "GET_AMB_EXT_Sewer" );

                        setAmbientRoomTone( "GET_AMB_EXT_Sewer", "GET_AMB_EXT_Sewer", 1, 1 );
			setAmbientRoomReverb( "GET_AMB_EXT_Sewer", "stoneroom", 1, .2 );



//***************
//GET_AMB_EXT_Construction_Site
//***************

            declareAmbientRoom( "GET_AMB_EXT_Construction_Site" );

                        setAmbientRoomTone( "GET_AMB_EXT_Construction_Site", "GET_AMB_EXT_Construction_Site", .5, 2 );
			setAmbientRoomReverb( "GET_AMB_EXT_Construction_Site", "city", 1, .9 );


//***************
//GET_AMB_INT_Court
//***************

            declareAmbientRoom( "GET_AMB_INT_Court" );

                        setAmbientRoomTone( "GET_AMB_INT_Court", "GET_AMB_INT_Court", .5, 2 );
			setAmbientRoomReverb( "GET_AMB_INT_Court", "paddedcell", 1, .6 );


//***************
//GET_AMB_INT_Corridor
//***************

            declareAmbientRoom( "GET_AMB_INT_Corridor" );

                        setAmbientRoomTone( "GET_AMB_INT_Corridor", "GET_AMB_INT_Corridor", 1, 2);
			setAmbientRoomReverb( "GET_AMB_INT_Corridor", "stoneroom", 1, .4 );

//***************
//GET_AMB_INT_Corridor2
//***************

            declareAmbientRoom( "GET_AMB_INT_Corridor2" );

                        setAmbientRoomTone( "GET_AMB_INT_Corridor2", "GET_AMB_INT_Corridor2", 1, 2);
			setAmbientRoomReverb( "GET_AMB_INT_Corridor2", "stoneroom", 1, .4 );

//***************
//GET_AMB_INT_House
//***************

            declareAmbientRoom( "GET_AMB_INT_House" );

                        setAmbientRoomTone( "GET_AMB_INT_House", "GET_AMB_INT_House", .5, 1);
			setAmbientRoomReverb( "GET_AMB_INT_House", "room", 1, .4 );
			
//***************
//GET_AMB_INT_House_Harbour
//***************

            declareAmbientRoom( "GET_AMB_INT_House_Harbour" );

                        setAmbientRoomTone( "GET_AMB_INT_House_Harbour", "GET_AMB_INT_House_Harbour", 1, 2);
			setAmbientRoomReverb( "GET_AMB_INT_House_Harbour", "room", 1, .4 );
						


 
//***************
//Venice_Ext_Tone
//***************

            declareAmbientRoom( "Venice_Ext_Tone" );

                        setAmbientRoomTone( "Venice_Ext_Tone", "GET_AMB_EXT_Courtyard" );
			setAmbientRoomReverb( "Venice_Ext_Tone", "city", 1, .7 );
                        
//***************
//gettler_house_floor1_room
//***************

            declareAmbientRoom( "gettler_house_floor1_room" );

                        setAmbientRoomTone( "gettler_house_floor1_room", "GET_AMB_INT_Floor1" );
			setAmbientRoomReverb( "gettler_house_floor1_room", "stoneroom", 1, .5 );                        
 
//***************
//gettler_house_floor2_room
//***************

            declareAmbientRoom( "gettler_house_floor2_room" );

                        setAmbientRoomTone( "gettler_house_floor2_room", "GET_AMB_INT_Floor2" );
			setAmbientRoomReverb( "gettler_house_floor2_room", "stoneroom", 1, .5 );
                        
//***************
//gettler_house_floor3_room
//***************

            declareAmbientRoom( "gettler_house_floor3_room" );

                        setAmbientRoomTone( "gettler_house_floor3_room", "GET_AMB_INT_Floor3" ); 
			setAmbientRoomReverb( "gettler_house_floor3_room", "stoneroom", 1, .5 );  
                        
//***************
//gettler_house_floor4_room
//***************

            declareAmbientRoom( "gettler_house_floor4_room" );

                        setAmbientRoomTone( "gettler_house_floor4_room", "GET_AMB_INT_Floor4" );
			setAmbientRoomReverb( "gettler_house_floor4_room", "stoneroom", 1, .5 );                          
            

//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "Venice_Ext_1shot", "GET_AMB_EXT_Street_1");

			signalAmbientPackageDeclarationComplete();
 

 

//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


	array_thread(GetEntArray("can_trigger", "targetname"), ::can); 

	array_thread(GetEntArray("bag_trigger", "targetname"), ::bag); 
	
	array_thread(GetEntArray("box_trigger", "targetname"), ::box); 

}


end_level_sound_fade()
{
	//fadetime = 5;
	//soundfade( fadetime );
	//wait fadetime;
	//level.player playlocalsound( "VESP_VenG01_007A" );
	wait 4;
	level notify("end_level");
}

 
//*************************************************************************************************

 

//                                              Functions

 

//*************************************************************************************************


	

//************ can ************

can()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("can_bump");
				//iprintlnbold ("SOUND: can");
				level notify("noise_trigger_can");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}


//************ bag ************

bag()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("bag_bump");
				//iprintlnbold ("SOUND: bag");
				level notify("noise_trigger_bag");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}


//************ box ************

box()
{
	

			
		while (1)
		{
			self waittill ("trigger");
			
			//if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			//{
				self playsound ("box_bump");
				//iprintlnbold ("SOUND: box");
				level notify("noise_trigger_box");
				while ( level.player isTouching(self))
				
				{
				wait 0.1;
				}
			//}
			
			//else
			//{
				//iprintlnbold("too soft!");
				//while ( level.player isTouching(self))
				//{
				//wait 0.1;
				//}
			//}
		}
		

	
}