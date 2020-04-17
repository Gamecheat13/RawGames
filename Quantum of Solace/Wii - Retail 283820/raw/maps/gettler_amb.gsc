
#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;



main()
{
level.mobile_sound = getent("GET_civilians_walla_male","targetname");








	loopSound("get_waterlap_floor1_LP", (2516, -4286, 123), 37.69);


	loopSound("get_waterlap_floor2_LP", (2300, -4706, 368), 37.69);
	loopSound("get_waterlap_floor2_LP", (2561, -4820, 349), 37.69);
	loopSound("get_waterlap_floor2_LP", (2834, -4762, 351), 37.69);
	loopSound("get_waterlap_floor2_LP", (2947, -4531, 349), 37.69);
	loopSound("get_waterlap_floor2_LP", (2689, -4239, 348), 37.69);
	loopSound("get_waterlap_floor2_LP", (2577, -3846, 349), 37.69);


	loopSound("get_waterlap_floor2_LP", (2839, -4525, 485), 37.69);
	loopSound("get_waterlap_floor2_LP", (2777, -4781, 485), 37.69);








	bond = level.player; 

	
	




	interaction_add_repeating_notetrack_sound( "notesound_gp_input", "snd_gp_input", bond );



	interaction_add_repeating_notetrack_sound( "notesound_gp_lead", "snd_gp_lead", bond );



	interaction_add_repeating_notetrack_sound( "notesound_gp_sucsess", "snd_gp_success", bond );



	interaction_add_repeating_notetrack_sound( "notesound_gp_fail", "snd_gp_fail", bond );



	interaction_add_repeating_notetrack_sound( "notesound_ns_input", "snd_ns_input", bond );



	interaction_add_repeating_notetrack_sound( "notesound_ns_lead", "snd_ns_lead", bond );



	interaction_add_repeating_notetrack_sound( "notesound_ns_sucsess", "snd_ns_success", bond );



	interaction_add_repeating_notetrack_sound( "notesound_ns_fail", "snd_ns_fail", bond );



	interaction_add_repeating_notetrack_sound( "notesound_tr_lead", "snd_tr_lead", bond );



	interaction_add_repeating_notetrack_sound( "notesound_tr_sucsess", "snd_tr_success", bond );





	





 





            declareAmbientPackage( "Venice_Ext_1shot" );       

                        
			
			




            declareAmbientPackage( "gettler_house_floor1_pkg" );       

                        
			




            declareAmbientPackage( "gettler_house_floor2_pkg" );       

                        
			




            declareAmbientPackage( "gettler_house_floor3_pkg" );       

                        
			




            declareAmbientPackage( "gettler_house_floor4_pkg" );       

                        
			


           








            declareAmbientRoom( "GET_AMB_EXT_MainStreet" );

                        setAmbientRoomTone( "GET_AMB_EXT_MainStreet", "GET_AMB_EXT_MainStreet", 2, 5 );
			setAmbientRoomReverb( "GET_AMB_EXT_MainStreet", "city", 1, .7 );




            declareAmbientRoom( "GET_AMB_EXT_Street_1" );

                        setAmbientRoomTone( "GET_AMB_EXT_Street_1", "GET_AMB_EXT_Street_1", .5, 2 );
			setAmbientRoomReverb( "GET_AMB_EXT_Street_1", "city", 1, .7 );






            declareAmbientRoom( "GET_AMB_EXT_Street_2" );

                        setAmbientRoomTone( "GET_AMB_EXT_Street_2", "GET_AMB_EXT_Street_2", 1, 2 );
			setAmbientRoomReverb( "GET_AMB_EXT_Street_2", "city", 1, .7 );






            declareAmbientRoom( "GET_AMB_EXT_Harbour" );

                        setAmbientRoomTone( "GET_AMB_EXT_Harbour", "GET_AMB_EXT_Harbour", 1, 5 );
			setAmbientRoomReverb( "GET_AMB_EXT_Harbour", "city", 1, .7 );





            declareAmbientRoom( "GET_AMB_EXT_Sewer" );

                        setAmbientRoomTone( "GET_AMB_EXT_Sewer", "GET_AMB_EXT_Sewer", 1, 2 );
			setAmbientRoomReverb( "GET_AMB_EXT_Sewer", "stoneroom", 1, .7 );







            declareAmbientRoom( "GET_AMB_EXT_Construction_Site" );

                        setAmbientRoomTone( "GET_AMB_EXT_Construction_Site", "GET_AMB_EXT_Construction_Site", 2, 2 );
			setAmbientRoomReverb( "GET_AMB_EXT_Construction_Site", "city", 1, .7 );






            declareAmbientRoom( "GET_AMB_INT_Court" );

                        setAmbientRoomTone( "GET_AMB_INT_Court", "GET_AMB_INT_Court", .5, 2 );
			setAmbientRoomReverb( "GET_AMB_INT_Court", "paddedcell", 1, .4 );






            declareAmbientRoom( "GET_AMB_INT_Corridor" );

                        setAmbientRoomTone( "GET_AMB_INT_Corridor", "GET_AMB_INT_Corridor", 1, 2);
			setAmbientRoomReverb( "GET_AMB_INT_Corridor", "stoneroom", 1, .7 );





            declareAmbientRoom( "GET_AMB_INT_House" );

                        setAmbientRoomTone( "GET_AMB_INT_House", "GET_AMB_INT_House", 1, 2);
			setAmbientRoomReverb( "GET_AMB_INT_House", "room", 1, .7 );
			




            declareAmbientRoom( "GET_AMB_INT_House_Harbour" );

                        setAmbientRoomTone( "GET_AMB_INT_House_Harbour", "GET_AMB_INT_House_Harbour", 1, 2);
			setAmbientRoomReverb( "GET_AMB_INT_House_Harbour", "room", 1, .7 );
						


 




            declareAmbientRoom( "Venice_Ext_Tone" );

                        setAmbientRoomTone( "Venice_Ext_Tone", "GET_AMB_EXT_Courtyard" );
			setAmbientRoomReverb( "Venice_Ext_Tone", "city", 1, .7 );
                        




            declareAmbientRoom( "gettler_house_floor1_room" );

                        setAmbientRoomTone( "gettler_house_floor1_room", "GET_AMB_INT_Floor1" );
			setAmbientRoomReverb( "gettler_house_floor1_room", "stoneroom", 1, .5 );                        
 




            declareAmbientRoom( "gettler_house_floor2_room" );

                        setAmbientRoomTone( "gettler_house_floor2_room", "GET_AMB_INT_Floor2" );
			setAmbientRoomReverb( "gettler_house_floor2_room", "stoneroom", 1, .5 );
                        




            declareAmbientRoom( "gettler_house_floor3_room" );

                        setAmbientRoomTone( "gettler_house_floor3_room", "GET_AMB_INT_Floor3" ); 
			setAmbientRoomReverb( "gettler_house_floor3_room", "stoneroom", 1, .5 );  
                        




            declareAmbientRoom( "gettler_house_floor4_room" );

                        setAmbientRoomTone( "gettler_house_floor4_room", "GET_AMB_INT_Floor4" );
			setAmbientRoomReverb( "gettler_house_floor4_room", "stoneroom", 1, .5 );                          
            







            setBaseAmbientPackageAndRoom( "Venice_Ext_1shot", "GET_AMB_EXT_Street_1");

			signalAmbientPackageDeclarationComplete();
 

 








}


end_level_sound_fade()
{
	
	
	
	
	wait 4;
	level notify("end_level");
}

