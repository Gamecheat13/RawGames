
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "white_estate_ext_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "white_estate_ext_room" );
 
                           setAmbientRoomTone( "white_estate_ext_room", "bgt_white_estate_ext_1" );
                        
                        








            setBaseAmbientPackageAndRoom( "white_estate_ext_loop", "white_estate_ext_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

