    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\shared\array_shared;

#namespace string;

// Please contact DRoche before adding new string functions
// There is a 95%+ savings by doing string manipulation ( apart from == ) in code.  
// String function moved to code
//strStartsWith()
//strEndsWith()
//strIsNumber()
//strIsFloat()
//strIsInt()
//strStrip()

/#

function rfill( str_input, n_length, str_fill_char = " " )
{
	if ( str_fill_char == "" )
	{
		str_fill_char = " ";
	}
	
	Assert( str_fill_char.size == 1, "Fill string can only be 1 character." );
	
	str_input = "" + str_input; // convert input to string if not already
	
	n_fill_count = n_length - str_input.size;
	
	str_fill = "";
	
	if ( n_fill_count > 0 )
	{
		for ( i = 0; i < n_fill_count; i++ )
		{
			str_fill += str_fill_char;
		}
	}
	
	return ( str_fill + str_input );
}

#/