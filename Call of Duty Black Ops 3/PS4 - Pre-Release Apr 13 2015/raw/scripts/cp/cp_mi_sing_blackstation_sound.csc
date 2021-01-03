#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	
}

function sndWindSystem(localClientNum, oldVal, newVal, bNewEnt, bInitialSnap, fieldName, bWasDemoJump)
{	
	if( newVal )
	{
		if( !isdefined( self.sndWindEnt1 ) )
		{
			self.sndWindEnt1 = spawn( 0, self.origin, "script_origin" );
			soundID1 = self.sndWindEnt1 playloopsound( "amb_scripted_wind_normal", 2 );
			setsoundvolume( soundID1, 1 );
		}
		
		if( !isdefined( self.sndWindEnt2 ) )
		{
			self.sndWindEnt2 = spawn( 0, self.origin, "script_origin" );
		}
		
		soundID1 = self.sndWindEnt1 playloopsound( "amb_scripted_wind_normal", 2 );
		soundID2 = self.sndWindEnt2 playloopsound( "amb_scripted_wind_heavy", 2 );
		
		switch( newVal )
		{
			case 1:
				setsoundvolume( soundID1, 1 );
				setsoundvolume( soundID2, 0 );
				break;
			case 2:
				setsoundvolume( soundID1, .7 );
				setsoundvolume( soundID2, 1 );
				break;
		}
	}
	else
	{
		if( isdefined( self.sndWindEnt1 ) )
		{
			self.sndWindEnt1 delete();
			self.sndWindEnt1 = undefined;
		}
		
		if( isdefined( self.sndWindEnt2 ) )
		{
			self.sndWindEnt2 delete();
			self.sndWindEnt2 = undefined;
		}
	}
}