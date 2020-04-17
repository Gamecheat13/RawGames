/*-----------------------------------------------------
Ambient stuff
-----------------------------------------------------*/
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{

//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

 

 
 

//***************
//Bay_Ext_1shot
//***************   

            declareAmbientPackage( "Bay_Ext_1shot" );            

                        addAmbientElement( "Bay_Ext_1shot", "amb_shiphorn", 6, 45, 500, 1000 );
			addAmbientElement( "Bay_Ext_1shot", "amb_seagull", 6, 45, 500, 1000 );
			
//***************
//ship_ext_pkg
//***************   

            declareAmbientPackage( "ship_ext_pkg" );            

                        addAmbientElement( "ship_ext_pkg", "amb_seagull", 6, 45, 500, 1000 );			
 
//***************
//ship_int_pkg
//***************   

            declareAmbientPackage( "ship_int_pkg" );            

                        //addAmbientElement( "ship_int_pkg", "amb_seagull", 6, 45, 500, 1000 );
			
 

           
//************************************************************************************************
//                                              ROOMS
//************************************************************************************************

 
//***************
//Bay_Ext_Tone
//***************

            declareAmbientRoom( "Bay_Ext_Tone" );

                        setAmbientRoomTone( "Bay_Ext_Tone", "bgt_bay" );
                        
//***************
 //ship_ext_room
 //***************

             declareAmbientRoom( "ship_ext_room" );
                         setAmbientRoomTone( "ship_ext_room", "amb_bg_barge_ext" );                        
                        
 //***************
 //ship_int_room
 //***************

             declareAmbientRoom( "ship_int_room" );
                         setAmbientRoomTone( "ship_int_room", "amb_bg_barge_int" );
                         
                         
                         
//************************************************************************************************

//                                              ACTIVATE DEFAULT AMBIENT SETTINGS

//************************************************************************************************

            setBaseAmbientPackageAndRoom( "Bay_Ext_1shot", "Bay_Ext_Tone" );



//*************************************************************************************************

//                                              START SCRIPTS

//*************************************************************************************************


	// finally, call this to allow the trigger initialization to complete, since it was waiting for all declarations
	// so that it could perform error checking
	signalAmbientPackageDeclarationComplete();

}



