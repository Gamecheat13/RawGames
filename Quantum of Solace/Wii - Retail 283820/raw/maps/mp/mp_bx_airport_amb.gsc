
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "airport_int_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "airport_int_room" );
 
                           setAmbientRoomTone( "airport_int_room", "bgt_airport_int_1" );
                        
                        








            setBaseAmbientPackageAndRoom( "airport_int_loop", "airport_int_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

