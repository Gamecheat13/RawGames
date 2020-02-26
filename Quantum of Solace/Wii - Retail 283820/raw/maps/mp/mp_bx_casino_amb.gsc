
#include maps\mp\_utility;
#include common_scripts\ambientpackage;



main()
{





 

 





            declareAmbientPackage( "casino_int_loop" );       

                        
			
 
		


           




 





            declareAmbientRoom( "casino_int_ball_room" );
 
                           setAmbientRoomTone( "casino_int_ball_room", "bgt_casino_int_1" );
                        








            setBaseAmbientPackageAndRoom( "casino_int_loop", "casino_int_ball_room" );

			signalAmbientPackageDeclarationComplete();
 

 








}

