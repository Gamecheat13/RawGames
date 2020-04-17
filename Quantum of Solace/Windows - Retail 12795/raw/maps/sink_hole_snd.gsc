/*-----------------------------------------------------

Ambient stuff

-----------------------------------------------------*/

#include maps\_utility;
#include common_scripts\ambientpackage;
#include maps\_fx;


main()

{

	precacheshellshock( "sinkhole_begin" );


//************************************************************************************************
//                                              Ambient Packages
//************************************************************************************************

           

//************************************************************************************************
//ROOMS
//************************************************************************************************

 //***************
 //amb_sink_hole_cavern
 //***************

 
	declareAmbientPackage( "outdoors_pkg" );
	
	                  addAmbientElement( "outdoors_pkg", "cave_1shots", 5, 25, 50, 1000 );
			//addAmbientElement( "outdoors_pkg", "cistern_debris", 6, 15, 50, 500 );


	declareAmbientRoom( "amb_sink_hole_cavern" );

	setAmbientRoomTone( "amb_sink_hole_cavern", "amb_sink_hole_cavern", 1, 2 );                                           
	setAmbientRoomReverb( "amb_sink_hole_cavern", "cave", 1, .3 );


	// set the base ambientpackage and ambientroom, which are used when not touching any ambientPackageTriggers
	// the other trigger based packages will be activated automatically when the player is touching them
	
	setBaseAmbientPackageAndRoom( "outdoors_pkg", "amb_sink_hole_cavern" );

//************************************************************************************************
//ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************



//************************************************************************************************
//Zone Emitters
//************************************************************************************************


 

//*************************************************************************************************
//Static Loops
//*************************************************************************************************

// fireloop_1 is a fire burning hot, chemical-sih
// fireloop_2 has some metal in it, good for burning parts
// fireloop_3 has some wood in it, crackle and pos.  



// fires by fuselage
	// rock
	loopSound("sink_hole_fireloop_1", (1393, 1036, -574) , 8.363);
	// engine
	loopSound("sink_hole_fireloop_3", (1544, 1024, -651)  , 9.822);
	// rock on right, before fuselage
	loopSound("sink_hole_fireloop_2", (1334, 551, -549) , 7.584);
	
// 1st past fuselage, pass on right, side before rock event 
	loopSound("sink_hole_fireloop_1", (2358, 373, -577) , 8.363);	
// 2nd past fuselage, pass on right, side before rock event 
	loopSound("sink_hole_fireloop_3", (2821, 547, -679)  , 9.822);	
	
	
// past rock collpase
	//on right
	loopSound("sink_hole_fireloop_1", (3644, -161, -842)  , 8.363);
	// on left 
	loopSound("sink_hole_fireloop_1", (4643, -869, -834)  , 8.363);	
	
	
// up on the hill, other side of fuselage during the big battle	
	loopSound("sink_hole_fireloop_1", (960, -173, -377) , 8.363);	
	
// up on the hill, after final helicrash	
	loopSound("sink_hole_fireloop_1", (104, 13, -60)  , 8.363);	
	
	loopSound("sink_hole_fireloop_1", (-1154, -419, -397) , 8.363);
	
	
// in the bowl, engine part on fire
	loopSound("sink_hole_fireloop_2", (2118, -1113, -663)  , 7.584);




//*************************************************************************************************
//START SCRIPTS
//*************************************************************************************************
	// finally, call this to allow the trigger initialization to complete, since it was waiting for all declarations
	// so that it could perform error checking
	signalAmbientPackageDeclarationComplete();
	
	
	//array_thread(GetEntArray("rock_crumble_trigger", "targetname"), ::rock_crumble);
	//array_thread(GetEntArray("fire_trigger", "targetname"), ::fire_loop);
	
	

 
//*************************************************************************************************
//Functions
//*************************************************************************************************
}



//************ puddles ************

rock_crumble()
{


			
	
		while (1)
		{
			self waittill ("trigger");
			
			
			if ( 100 < lengthsquared( level.player getplayervelocity() ) )
			{
				self playsound ("rock_crumble");
				self playsound ("rock_dust");
				//iprintlnbold ("SOUND: rock crumble");
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}
			
			else
			{
				//iprintlnbold("too soft!");
				while ( level.player isTouching(self))
				{
				wait 0.1;
				}
			}

				
		}
		

	
}

//************ fires ************

fire_loop()
{
	self playloopsound ("sink_hole_fireloop");	

}

