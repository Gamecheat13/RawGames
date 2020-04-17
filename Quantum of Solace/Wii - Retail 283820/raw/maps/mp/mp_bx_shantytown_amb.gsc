
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "shantytown_ext_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "shantytown_ext_room" );
 
                           setAmbientRoomTone( "shantytown_ext_room", "bgt_shantytown_ext_1" );
                        
                        








            setBaseAmbientPackageAndRoom( "shantytown_ext_loop", "shantytown_ext_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

