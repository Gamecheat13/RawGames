
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "facility_int_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "facility_int_room" );
 
                           setAmbientRoomTone( "facility_int_room", "bgt_facility_int_1" );
                        
                        








            setBaseAmbientPackageAndRoom( "facility_int_loop", "facility_int_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

