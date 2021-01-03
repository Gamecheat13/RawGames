    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace math;

/@
"Name: clamp(val, val_min, val_max)"
"Summary: Clamps a value between a min and max value."
"Module: Math"
"MandatoryArg: val: the value to clamp."
"MandatoryArg: val_min: the min value to clamp to."
"MandatoryArg: val_max: the mac value to clamp to."
"Example: clamped_val = clamp(8, 0, 5); // returns 5	*	clamped_val = clamp(-1, 0, 5); // returns 0"
"SPMP: both"
@/
function clamp(val, val_min, val_max)
{
	if (val < val_min)
	{
		val = val_min;
	}
	else if (val > val_max)
	{
		val = val_max;
	}

	return val;
}

/@
"Name: linear_map(val, min_a, max_a, min_b, max_b)"
"Summary: Maps a value within one range to a value in another range."
"Module: Math"
"MandatoryArg: val: the value to map."
"MandatoryArg: min_a: the min value of the range in which <val> exists."
"MandatoryArg: max_a: the max value of the range in which <val> exists."
"MandatoryArg: min_b: the min value of the range in which the return value should exist."
"MandatoryArg: max_b: the max value of the range in which the return value should exist."
"Example: fov = linear_map(speed, min_speed, max_speed, min_fov, max_fov);"
"SPMP: both"
@/
function linear_map(num, min_a, max_a, min_b, max_b)
{
	return clamp(( (num - min_a) / (max_a - min_a) * (max_b - min_b) + min_b ), min_b, max_b);
}

/@
"Name: lag(desired, curr, k, dt)"
"Summary: Changes a value from current to desired using 1st order differential lag."
"Module: Math"
"MandatoryArg: desired: desired value."
"MandatoryArg: curr: the current value."
"MandatoryArg: k: the strength of the lag ( lower = slower, higher = faster)."
"MandatoryArg: dt: time step to lag over ( usually 1 server frame )."
"Example: speed = lag(max_speed, speed, 1, 0.05);"
"SPMP: both"
@/
function lag(desired, curr, k, dt)
{
    r = 0.0;

    if (((k * dt) >= 1.0) || (k <= 0.0))
    {
        r = desired;
    }
    else
    {
        err = desired - curr;
        r = curr + k * err * dt;
    }

    return r;
}

/@
"Name: array_average( <array> )"
"Summary: Given an array of numbers, returns the average (mean) value of the array"
"Module: Utility"
"MandatoryArg: <array>: the array of numbers which will be averaged"
"Example: array_average( numbers );"
"SPMP: both"
@/
function array_average( array )
{
	assert( IsArray( array ) );
	assert( array.size > 0 );

	total = 0;

	for ( i = 0; i < array.size; i++ )
	{
		total += array[i];
	}

	return ( total / array.size );
}

/@
"Name: array_std_deviation( <array>, <mean> )"
"Summary: Given an array of numbers and the average of the array, returns the standard deviation value of the array"
"Module: Utility"
"MandatoryArg: <array>: the array of numbers"
"MandatoryArg: <mean>: the average (mean) value of the array"
"Example: array_std_deviation( numbers, avg );"
"SPMP: both"
@/
function array_std_deviation( array, mean )
{
	assert( IsArray( array ) );
	assert( array.size > 0 );

	tmp = [];
	for ( i = 0; i < array.size; i++ )
	{
		tmp[i] = ( array[i] - mean ) * ( array[i] - mean );
	}

	total = 0;
	for ( i = 0; i < tmp.size; i++ )
	{
		total = total + tmp[i];
	}

	return Sqrt( total / array.size );
}

// ----------------------------------------------------------------------------------------------------
// -- Vectors -----------------------------------------------------------------------------------------
// ----------------------------------------------------------------------------------------------------

/@
"Name: vector_compare( <vec1>, <vec2> )"
"Summary: For 3D vectors.  Returns true if the vectors are the same"
"MandatoryArg: <vec1> : A 3D vector (origin)"
"MandatoryArg: <vec2> : A 3D vector (origin)"
"Example: if (vector_compare(self.origin, node.origin){print(\"yay, i'm on the node!\");}"
"SPMP: both"
@/
function vector_compare(vec1, vec2)
{
	return (abs(vec1[0] - vec2[0]) < .001) && (abs(vec1[1] - vec2[1]) < .001) && (abs(vec1[2] - vec2[2]) < .001);
}

function random_vector(max_length)
{
	return (RandomFloatRange(-1 * max_length, max_length), RandomFloatRange(-1 * max_length, max_length), RandomFloatRange(-1 * max_length, max_length));
}

function angle_dif(oldangle, newangle)
{
    outvalue=(oldangle-newangle)%360;
     if (outvalue<0)
          outvalue+=360;
     if (outvalue>180)
          outvalue=(outvalue-360)*-1;
     return outvalue;
}

function sign( x )
{
	if ( x >= 0 )
		return 1;
	return -1;
}

function cointoss()
{
	return RandomInt( 100 ) >= 50 ;
}
