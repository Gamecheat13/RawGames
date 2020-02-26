
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "sciencecenter_a_ext_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "sciencecenter_a_ext_room" );
 
                           setAmbientRoomTone( "sciencecenter_a_ext_room", "bgt_sciencecenter_a_ext_1" );
                        
                        








            setBaseAmbientPackageAndRoom( "sciencecenter_a_ext_loop", "sciencecenter_a_ext_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

