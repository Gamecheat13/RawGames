    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace shaderanim;



//-----------------------------------------------------------------------------

// TODO: table of scriptvector and shader property names (keep up to date)
//		scriptVector0:	opacity		XXX			XXX			XXX
//		scriptVector1:	crack1		XXX			XXX			XXX
//		scriptVector2:	crack2		XXX			XXX			XXX
//		scriptVector3:	crack3		XXX			XXX			XXX

//-----------------------------------------------------------------------------
	
// function shaderanim_animate_cracks
//	entity:			entity to modulate the material on.
//	localClientNum: number of the client to update.
//	vectorName:		vector to animate (scriptVector1 for red, 2 for blue, 3 for green vertex colors)
//	delay:			time to wait (in frames) before animating the crack threshold.
//	duration:		time over which to fully reveal or fade the cracks (in frames).
//	start:			value to start the crack reveal.
//	end:			value to stop the crack reveal.
function animate_crack( localClientNum, vectorName, delay, duration, start, end )
{
	self endon( "entityshutdown" );
	
	// convert frame delay to seconds
	delaySeconds = delay / 60.0;
	// wait out the delay
	wait delaySeconds;
	
	// direction of loop
	direction = 1.0;
	if ( start > end )
		direction = -1.0;

	// convert frame durations to seconds
	durationSeconds = duration / 60.0;

	// figure out the loop step
	valStep = 0;
	if ( durationSeconds > 0 )
		valStep = (end - start) / (durationSeconds / 0.01);
	timeStep = 0.01 * direction;

	value = start;
	self MapShaderConstant( localClientNum, 0, vectorName, value, 0, 0, 0 );
	for ( i = 0; i < durationSeconds; i += timeStep )
	{
		// update value
		value += valStep;
		// delay
		wait 0.01;
		// TODO: how to get the existing value so they don't get bashed?
		self MapShaderConstant( localClientNum, 0, vectorName, value, 0, 0, 0 );
	}

	self MapShaderConstant( localClientNum, 0, vectorName, end, 0, 0, 0 );
}
	
//-----------------------------------------------------------------------------

function shaderanim_update_opacity( entity, localClientNum, opacity )
{
	// TODO: how to get the existing value so they don't get bashed?
	entity MapShaderConstant( localClientNum, 0, "scriptVector0", opacity, 0, 0, 0 );
}

//-----------------------------------------------------------------------------