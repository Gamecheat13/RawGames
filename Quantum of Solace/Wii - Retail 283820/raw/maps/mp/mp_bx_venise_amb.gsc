
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "venise_ext_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "venise_ext_room" );
 
                           setAmbientRoomTone( "venise_ext_room", "bgt_venise_ext_1" );
                        
                        








            setBaseAmbientPackageAndRoom( "venise_ext_loop", "venise_ext_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

