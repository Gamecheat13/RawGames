#using scripts\codescripts\struct;
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\_load;
#using scripts\mp\_util;

#using scripts\mp\mp_metro_fx;
#using scripts\mp\mp_metro_sound;

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       



function main()
{
	mp_metro_fx::main();
	mp_metro_sound::main();
	
	clientfield::register( "scriptmover", "mp_metro_train_timer", 1, 1, "int", &trainTimerSpawned, true, !true );
		
	load::main();

	util::waitforclient( 0 );	// This needs to be called after all systems have been registered.
}

function train_countdown( localClientNum )
{
	self endon( "entityshutdown" );
	angles = ( self.angles[0], -self.angles[1], 0 );

	
	minutesOrigin = self.origin + ( cos(self.angles[1] ) * 37, sin( self.angles[1] ) * 37, 0 );
	numberModelMinutes = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", minutesOrigin, angles );
	
	colonOrigin = self.origin + ( cos(self.angles[1]) * 37 * 2, sin( self.angles[1] ) * 37 * 2, 0 );
	numberModelcolon = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", colonOrigin, angles );
	
	tensOrigin = self.origin - ( cos(self.angles[1]) * 37, sin( self.angles[1] ) * 37, 0 );
	numberModelTens = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", tensOrigin, angles );
	
	onesOrigin = self.origin - ( cos(self.angles[1]) * 37 * 2, sin( self.angles[1] ) * 37 * 2, 0 );
	numberModelOnes = util::spawn_model( localClientNum, "p7_3d_txt_antiqua_bold_00_brushed_aluminum", onesOrigin, angles );

	currentNumber = 1;

	currentNumberLarge = 0;
	for ( ;; )
	{		
		currentNumber++;
		if ( currentNumber > 9 )
		{
			currentNumber = 0;
		}
			
		displayNumber = int( ceil( ( self.angles[2]) ) );
		if ( displayNumber < 0 )
		{
			displayNumber += 360;
		}
		
		if ( displayNumber < 0 || displayNumber > 360 )
		{
			displayNumber = 0;
		}
		
		numberModelOnes setModel( "p7_3d_txt_antiqua_bold_0" + ( displayNumber % 10 ) + "_brushed_aluminum");
		
		numberModelTens setModel( "p7_3d_txt_antiqua_bold_0" + ( int( ( displayNumber % 60 ) / 10  ) ) + "_brushed_aluminum");
		
		numberModelMinutes setModel( "p7_3d_txt_antiqua_bold_0" + ( int( displayNumber / 60 ) ) + "_brushed_aluminum");
		
		wait( 0.05 );
	}
}

function trainTimerSpawned( localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump )
{
	if ( !newVal )
		return;

	if ( newVal == 1 )
	{
		self thread train_countdown( localClientNum );
	}
}