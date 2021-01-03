#using scripts\codescripts\struct;

#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\shared\util_shared;

#precache( "client_fx", "_t6/weapon/claymore/fx_claymore_laser" );

function init( localClientNum )
{
	level._effect["fx_claymore_laser"] = "_t6/weapon/claymore/fx_claymore_laser";
}

function spawned( localClientNum )
{
	self endon( "entityshutdown" );

	self util::waittill_dobj(localClientNum);

	while( true )
	{
		if( isdefined( self.stunned ) && self.stunned )
		{
			wait( 0.1 );
			continue;
		}


		self.claymoreLaserFXId = PlayFXOnTag( localClientNum, level._effect["fx_claymore_laser"], self, "tag_fx" );

		self waittill( "stunned" );
		stopfx(localClientNum, self.claymoreLaserFXId);

	}
}
