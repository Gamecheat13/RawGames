

#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;


main()

{

	precacheshellshock( "sinkhole_begin" );






           





 
 
 

 
	declareAmbientPackage( "outdoors_pkg" );
	
	                  addAmbientElement( "outdoors_pkg", "cave_1shots", 5, 25, 50, 1000 );
			


	declareAmbientRoom( "amb_sink_hole_cavern" );

	setAmbientRoomTone( "amb_sink_hole_cavern", "amb_sink_hole_cavern", 1, 2 );                                           
	setAmbientRoomReverb( "amb_sink_hole_cavern", "stoneroom", 1, .7 );


	
	
	
	setBaseAmbientPackageAndRoom( "outdoors_pkg", "amb_sink_hole_cavern" );












 












	
	loopSound("sink_hole_fireloop_1", (1393, 1036, -574) , 8.363);
	
	loopSound("sink_hole_fireloop_3", (1544, 1024, -651)  , 9.822);
	
	loopSound("sink_hole_fireloop_2", (1334, 551, -549) , 7.584);
	

	loopSound("sink_hole_fireloop_1", (2358, 373, -577) , 8.363);	

	loopSound("sink_hole_fireloop_3", (2821, 547, -679)  , 9.822);	
	
	

	
	loopSound("sink_hole_fireloop_1", (3644, -161, -842)  , 8.363);
	
	loopSound("sink_hole_fireloop_1", (4643, -869, -834)  , 8.363);	
	
	

	loopSound("sink_hole_fireloop_1", (960, -173, -377) , 8.363);	
	

	loopSound("sink_hole_fireloop_1", (104, 13, -60)  , 8.363);	
	
	loopSound("sink_hole_fireloop_1", (-1154, -419, -397) , 8.363);







	
	
	signalAmbientPackageDeclarationComplete();
	
	
	
	
	
	

 



}





rock_crumble()
{


			
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("rock_crumble");
				self playsound ("rock_dust");
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
			
			else
			{
				
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}

				
		}
		

	
}



fire_loop()
{
	self playloopsound ("sink_hole_fireloop");	

}

