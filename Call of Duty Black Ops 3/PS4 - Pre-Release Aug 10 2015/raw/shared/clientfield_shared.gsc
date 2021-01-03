    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

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
"Example: level clientfield::register( "generator_state", 1 );"
"SPMP: both"
@/
function register( str_pool_name, str_name, n_version, n_bits, str_type )
{
	RegisterClientField( str_pool_name, str_name, n_version, n_bits, str_type );
}

/@
"Name: set( <str_field_name>, <n_value> )"
"Summary: Sets a clientfield value on an ent (also works on level)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"MandatoryArg: <n_value>: new value of clientfield"
"Example: level clientfield::set( "generator_state", 1 );"
"SPMP: both"
@/
function set( str_field_name, n_value )
{
	if( self == level )
	{
		CodeSetWorldClientField( str_field_name, n_value );
	}
	else
	{
		CodeSetClientField(self, str_field_name, n_value );
	}
}


/@
"Name: set_to_player( <str_field_name>, <n_value> )"
"Summary: Sets a clientfield value in a playerState (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: player"
"MandatoryArg: <str_field_name>: unique field name"
"MandatoryArg: <n_value>: new value of clientfield"
"Example: player clientfield::set_to_player( "is_speaking", 1 );"
"SPMP: both"
@/
function set_to_player( str_field_name, n_value )
{
	CodeSetPlayerStateClientField( self, str_field_name, n_value );
}


/@
"Name: set_player_uimodel( <str_field_name>, <n_value> )"
"Summary: Sets a clientfield value in a player uimodel (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: player"
"MandatoryArg: <str_field_name>: unique field name"
"MandatoryArg: <n_value>: new value of clientfield"
"Example: player clientfield::set_player_uimodel( "hudItems.killcamAllowRespawn", 1 );"
"SPMP: both"
@/
function set_player_uimodel( str_field_name, n_value )
{
	CodeSetUIModelClientField( self, str_field_name, n_value );
}


/@
"Name: get_player_uimodel( <str_field_name> )"
"Summary: Gets a clientfield value in a player uimodel (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: player"
"MandatoryArg: <str_field_name>: unique field name"
"Example: player clientfield::get_player_uimodel( "hudItems.killcamAllowRespawn" );"
"SPMP: both"
@/
function get_player_uimodel( str_field_name )
{
	return CodeGetUIModelClientField( self, str_field_name );
}

/@
"Name: increment( <str_field_name> )"
"Summary: Increments a clientfield value on an ent (also works on level)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"OptionalArg: [n_increment_count]: how much to increment by."
"Example: level clientfield::increment( "generator_state" );"
"SPMP: both"
@/
function increment( str_field_name, n_increment_count = 1 )
{
	for ( i = 0; i < n_increment_count; i++ )
	{
		if ( self == level )
		{
			CodeIncrementWorldClientField( str_field_name );
		}
		else
		{
			CodeIncrementClientField( self, str_field_name );
		}
	}
}

/@
"Name: increment_uimodel( <str_field_name> )"
"Summary: Increments a uimodel clientfield value on an ent (also works on level)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: uimodel path from controller"
"OptionalArg: [n_increment_count]: how much to increment by."
"Example: level clientfield::increment_uimodel( "hudItems.damageNotifies" );"
"SPMP: both"
@/
function increment_uimodel( str_field_name, n_increment_count = 1 )
{
	if ( self == level )
	{
		foreach ( player in level.players )
		{
			for ( i = 0; i < n_increment_count; i++ )
			{
				CodeIncrementUIModelClientField( player, str_field_name );
			}
		}
	}
	else
	{
		for ( i = 0; i < n_increment_count; i++ )
		{
			CodeIncrementUIModelClientField( self, str_field_name );
		}
	}
}


/@
"Name: increment_to_player( <str_field_name> )"
"Summary: Increments a clientfield value in a playerState (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: player"
"MandatoryArg: <str_field_name>: unique field name"
"OptionalArg: [n_increment_count]: how much to increment by."
"Example: player clientfield::increment_to_player( "is_speaking" );"
"SPMP: both"
@/
function increment_to_player( str_field_name, n_increment_count = 1 )
{
	for ( i = 0; i < n_increment_count; i++ )
	{
		CodeIncrementPlayerStateClientField( self, str_field_name );
	}
}


/@
"Name: get( <str_field_name> )"
"Summary: Gets a clientfield value stored on an ent (also works on level)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"Example: n_generator_state = level clientfield::get( "generator_state" );"
"SPMP: both"
@/
function get( str_field_name )
{
	if( self == level )
	{
		return CodeGetWorldClientField( str_field_name );
	}
	else
	{
		return CodeGetClientField( self, str_field_name );
	}
}


/@
"Name: get_to_player( <str_field_name> )"
"Summary: Gets a clientfield value stored in a playerState (a field that when changed only the player that it changed for receieves the change)"
"Module: Utility"
"CallOn: an entity or level"
"MandatoryArg: <str_field_name>: unique field name"
"Example: n_speaking_state = player clientfield::get_to_player( "is_speaking" );"
"SPMP: both"
@/
function get_to_player( field_name )
{
	return CodeGetPlayerStateClientField( self, field_name );
}
