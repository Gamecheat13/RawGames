    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace clientfield;

/@
"Name: register( <str_field_name>, <n_value> )"
"Summary: Register a client field.  Client fields are variable bit length fields communicated from server to client.
"Module: Clientfield"
"MandatoryArg: <Client field pool name> Which pool the field is allocated from.  Currently supported : "world", "actor", "vehicle", "scriptmover"
"MandatoryArg: <name> Unique name to identify the field.
"MandatoryArg: <version> Number indicating version this field was added in - see _version.gsh for defines.
"MandatoryArg: <num bits> How many bits to use for the field.  Valid values are in the range of 1-32.  Only ask for as many as you need.
"MandatoryArg: <type> Type of the field.  Currently supported types "int" or "float"
"MandatoryArg: <callback func> script function to call when field changes.  func should be defined as func(localClientNum, oldVal, newVal)
"MandatoryArg: <host only> If true, field callback only happens for the splitscreen host.
"MandatoryArg: <callback for 0 when new> If true, client field will generate callbacks for a value of 0, when the entity is new.	
"Example: level clientfield::register( "generator_state", 1 );"
"SPMP: singleplayer"
@/
function register( str_pool_name, str_name, n_version, n_bits, str_type, func_callback, b_host, b_callback_for_zero_when_new )
{
	RegisterClientField( str_pool_name, str_name, n_version, n_bits, str_type, func_callback, b_host, b_callback_for_zero_when_new );
}

function get(field_name)
{
	if(self == level)
	{
		return CodeGetWorldClientField(field_name);
	}
	else
	{
		return CodeGetClientField(self, field_name);
	}
}

function get_to_player( field_name )
{
	return CodeGetPlayerStateClientField( self, field_name );
}

function get_player_uimodel( field_name )
{
	return CodeGetUIModelClientField( self, field_name );
}
