#using scripts\shared\scene_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

function autoexec __init__()
{
	// set up arrays even if there are no structs in the level
	
	if ( !isdefined( level.struct ) )
	{
		init_structs();
	}
}

function init_structs()
{
	level.struct = [];
	level.scriptbundles = [];
	level.scriptbundlelists = [];
	
	level.struct_class_names = [];
	level.struct_class_names[ "target" ] = [];
	level.struct_class_names[ "targetname" ] = [];
	level.struct_class_names[ "script_noteworthy" ] = [];
	level.struct_class_names[ "script_linkname" ] = [];
	level.struct_class_names[ "script_label" ] = [];
	level.struct_class_names[ "classname" ] = [];
	level.struct_class_names[ "script_unitrigger_type" ] = [];
	level.struct_class_names[ "scriptbundlename" ] = [];
	level.struct_class_names[ "prefabname" ] = [];
}

function CreateStruct( struct, type, name )
{
	if ( !isdefined( level.struct ) )
	{
		init_structs();
	}
		
	if ( isdefined( type ) )
	{
		if ( !isdefined( level.scriptbundles[ type ] ) )
	    {
		    level.scriptbundles[ type ] = [];
	    }
		    
		if ( isdefined( level.scriptbundles[ type ][ name ] ) )
		{
			return level.scriptbundles[ type ][ name ];
		}
		
		// save a couple more vars for script bundles
		struct.configstringfiletype = undefined;
		struct.igdtseqnum = undefined;
	
		if ( type == "scene" )
		{
			level.scriptbundles[ type ][ name ] = scene::remove_invalid_scene_objects( struct );
		}
		else if( type == "mpdialog_player" && !SessionModeIsMultiplayerGame() )
		{
			// do nothing, save vars
		}
		else
		{
			level.scriptbundles[ type ][ name ] = struct;
		}
	}
	else
	{
		struct init();
	}
}

function CreateScriptBundleList( items, assetType, name )
{
	if ( !isdefined( level.struct ) )
	{
		init_structs();
	}
	
	level.scriptbundlelists[ assetType ][ name ] = items;
}

function init()
{
	if ( !isdefined( level.struct ) ) level.struct = []; else if ( !IsArray( level.struct ) ) level.struct = array( level.struct ); level.struct[level.struct.size]=self;;
	
	if(!isdefined(self.angles))self.angles=( 0, 0, 0 );
	
	if ( isdefined( self.targetname ) )
	{
		if ( !isdefined( level.struct_class_names[ "targetname" ][ self.targetname ] ) ) level.struct_class_names[ "targetname" ][ self.targetname ] = []; else if ( !IsArray( level.struct_class_names[ "targetname" ][ self.targetname ] ) ) level.struct_class_names[ "targetname" ][ self.targetname ] = array( level.struct_class_names[ "targetname" ][ self.targetname ] ); level.struct_class_names[ "targetname" ][ self.targetname ][level.struct_class_names[ "targetname" ][ self.targetname ].size]=self;;
	}
	
	if ( isdefined( self.target ) )
	{
		if ( !isdefined( level.struct_class_names[ "target" ][ self.target ] ) ) level.struct_class_names[ "target" ][ self.target ] = []; else if ( !IsArray( level.struct_class_names[ "target" ][ self.target ] ) ) level.struct_class_names[ "target" ][ self.target ] = array( level.struct_class_names[ "target" ][ self.target ] ); level.struct_class_names[ "target" ][ self.target ][level.struct_class_names[ "target" ][ self.target ].size]=self;;
	}
	
	if ( isdefined( self.script_noteworthy ) )
	{
		if ( !isdefined( level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ] ) ) level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ] = []; else if ( !IsArray( level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ] ) ) level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ] = array( level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ] ); level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ][level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ].size]=self;;
	}
	
	if ( isdefined( self.script_linkname ) )
	{
		Assert( !isdefined( level.struct_class_names[ "script_linkname" ][ self.script_linkname ] ), "Two structs have the same linkname" );
		level.struct_class_names[ "script_linkname" ][ self.script_linkname ][ 0 ] = self;
	}
	
	if ( isdefined( self.script_label ) )
	{
		if ( !isdefined( level.struct_class_names[ "script_label" ][ self.script_label ] ) ) level.struct_class_names[ "script_label" ][ self.script_label ] = []; else if ( !IsArray( level.struct_class_names[ "script_label" ][ self.script_label ] ) ) level.struct_class_names[ "script_label" ][ self.script_label ] = array( level.struct_class_names[ "script_label" ][ self.script_label ] ); level.struct_class_names[ "script_label" ][ self.script_label ][level.struct_class_names[ "script_label" ][ self.script_label ].size]=self;;
	}
	
	if ( isdefined( self.classname ) )
	{
		if ( !isdefined( level.struct_class_names[ "classname" ][ self.classname ] ) ) level.struct_class_names[ "classname" ][ self.classname ] = []; else if ( !IsArray( level.struct_class_names[ "classname" ][ self.classname ] ) ) level.struct_class_names[ "classname" ][ self.classname ] = array( level.struct_class_names[ "classname" ][ self.classname ] ); level.struct_class_names[ "classname" ][ self.classname ][level.struct_class_names[ "classname" ][ self.classname ].size]=self;;
	}
	
	if ( isdefined( self.script_unitrigger_type ) )
	{
		if ( !isdefined( level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ] ) ) level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ] = []; else if ( !IsArray( level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ] ) ) level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ] = array( level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ] ); level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ][level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ].size]=self;;
	}
	
	if ( isdefined( self.scriptbundlename ) )
	{
		if ( !isdefined( level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ] ) ) level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ] = []; else if ( !IsArray( level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ] ) ) level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ] = array( level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ] ); level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ][level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ].size]=self;;
	}
	
	if ( isdefined( self.prefabname ) )
	{
		if ( !isdefined( level.struct_class_names[ "prefabname" ][ self.prefabname ] ) ) level.struct_class_names[ "prefabname" ][ self.prefabname ] = []; else if ( !IsArray( level.struct_class_names[ "prefabname" ][ self.prefabname ] ) ) level.struct_class_names[ "prefabname" ][ self.prefabname ] = array( level.struct_class_names[ "prefabname" ][ self.prefabname ] ); level.struct_class_names[ "prefabname" ][ self.prefabname ][level.struct_class_names[ "prefabname" ][ self.prefabname ].size]=self;;
	}
}

/@
"Name: get( <kvp_value> , [kvp_key] )"
"Summary: Returns a struct with the specified kvp."
"MandatoryArg: <kvp_value> : kvp value"
"OptionalArg: [kvp_key] : defaults to targetname"
"Example: struct::get( "some_value", "targetname" );"
"SPMP: both"
@/
function get( kvp_value, kvp_key = "targetname" )
{
	if ( isdefined( level.struct_class_names[ kvp_key ] ) && isdefined( level.struct_class_names[ kvp_key ][ kvp_value ] ) )
	{
		/#
		if ( level.struct_class_names[ kvp_key ][ kvp_value ].size > 1 )
		{
			AssertMsg( "struct::get used for more than one struct with kvp '" + kvp_key + "' = '" + kvp_value + "'." );
			return undefined;
		}
		#/
		
		return level.struct_class_names[ kvp_key ][ kvp_value ][ 0 ];
	}
}

/@
"Name: spawn( [v_origin], [v_angles] )"
"Summary: Returns a new struct."
"OptionalArg: [v_origin] : optional origin"
"OptionalArg: [v_angles] : optional angles"
"Example: s = struct::spawn( self GetTagOrigin( "tag_origin" ) );"
@/
function spawn( v_origin = (0, 0, 0), v_angles = (0, 0, 0) )
{
	s = SpawnStruct();
	s.origin = v_origin;
	s.angles = v_angles;
	return s;
}

/@
"Name: get_array( <kvp_value> , [kvp_key] )"
"Summary: Returns an array of structs with the specified kvp."
"MandatoryArg: <kvp_value> : kvp value"
"OptionalArg: [kvp_key] : defaults to targetname"
"Example: fxemitters = struct::get_array( "streetlights", "targetname" )"
"SPMP: both"
@/
function get_array( kvp_value, kvp_key = "targetname" )
{
	if ( isdefined( level.struct_class_names[ kvp_key ][ kvp_value ] ) )
	{
		return ArrayCopy( level.struct_class_names[ kvp_key ][ kvp_value ] );
	}
	
	return [];
}

function delete()
{
	if ( isdefined( self.target ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "target" ][ self.target ], self);
	}
	
	if ( isdefined( self.targetname ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "targetname" ][ self.targetname ], self);
	}
	
	if ( isdefined( self.script_noteworthy ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "script_noteworthy" ][ self.script_noteworthy ], self);
	}
	
	if ( isdefined( self.script_linkname ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "script_linkname" ][ self.script_linkname ], self);
	}
	
	if ( isdefined( self.script_label) )
	{
		ArrayRemoveValue( level.struct_class_names[ "script_label" ][ self.script_label ], self);
	}
	
	if ( isdefined( self.classname) )
	{
		ArrayRemoveValue( level.struct_class_names[ "classname" ][ self.classname ], self);
	}
	
	if ( isdefined( self.script_unitrigger_type ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "script_unitrigger_type" ][ self.script_unitrigger_type ], self);
	}
	
	if ( isdefined( self.scriptbundlename ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "scriptbundlename" ][ self.scriptbundlename ], self);
	}
	
	if ( isdefined( self.prefabname ) )
	{
		ArrayRemoveValue( level.struct_class_names[ "prefabname" ][ self.prefabname ], self);
	}
}

/@
"Name: get_script_bundle( <str_type>, <str_name> )"
"Summary: Returns a struct with the specified script bundle definition. This is the GDT data for the bundle."
"MandatoryArg: <str_type> : The type of the script bundle"
"MandatoryArg: <str_name> : The name of the script bundle"
"Example: struct::get_script_bundle( "scene", "my_scene" );"
"SPMP: both"
@/
function get_script_bundle( str_type, str_name )
{
	if ( isdefined( level.scriptbundles[ str_type ] ) && isdefined( level.scriptbundles[ str_type ][ str_name ] ) )
	{
		return level.scriptbundles[ str_type ][ str_name ];
	}
}

/@
"Name: delete_script_bundle( <str_type>, <str_name> )"
"Summary: Deletes the specified script bundle definition. This is the GDT data for the bundle."
"MandatoryArg: <str_type> : The type of the script bundle"
"MandatoryArg: <str_name> : The name of the script bundle"
"Example: struct::delete_script_bundle( "scene", "my_scene" );"
"SPMP: both"
@/
function delete_script_bundle( str_type, str_name )
{
	if ( isdefined( level.scriptbundles[ str_type ] ) && isdefined( level.scriptbundles[ str_type ][ str_name ] ) )
	{
		level.scriptbundles[ str_type ][ str_name ] = undefined;
	}
}

/@
"Name: get_script_bundles( <str_type> )"
"Summary: Returns all of the script bundle definition structs for the specified type."
"MandatoryArg: <str_type> : The type of the script bundle"
"Example: struct::get_script_bundles( "scene" );"
"SPMP: both"
@/
function get_script_bundles( str_type )
{
	if ( isdefined( level.scriptbundles ) && isdefined( level.scriptbundles[ str_type ] ) )
	{
		return level.scriptbundles[ str_type ];
	}
	
	return [];
}

/@
"Name: get_script_bundle_list( <str_type>, <str_name> )"
"Summary: Returns a string array with the items specified by the script bundle list."
"MandatoryArg: <str_type> : The type of the script bundle in the list"
"MandatoryArg: <str_name> : The name of the script bundle list"
"Example: struct::get_script_bundle_list( "collectible", "completecollectibleslist" );"
"SPMP: both"
@/
function get_script_bundle_list( str_type, str_name )
{
	if ( isdefined( level.scriptbundlelists[ str_type ] ) && isdefined( level.scriptbundlelists[ str_type ][ str_name ] ) )
	{
		return level.scriptbundlelists[ str_type ][ str_name ];
	}
}

/@
"Name: get_script_bundle_instances( <str_type>, [str_name] )"
"Summary: Returns an array of all the script bundle instances with the specified script bundle definition and name."
"MandatoryArg: <str_type> : The type of the script bundle"
"MandatoryArg: [str_name] : The name of the script bundle"
"Example: struct::get_script_bundle_instances( "scene", "my_scene" );"
"SPMP: both"
@/
function get_script_bundle_instances( str_type, str_name = "" )
{
	a_instances = struct::get_array( "scriptbundle_" + str_type, "classname" );
	
	if ( str_name != "" )
	{
		foreach ( i, s_instance in a_instances )
		{
			if ( s_instance.name != str_name )
			{
				ArrayRemoveIndex( a_instances, i, true );
			}
		}
	}
	
	return a_instances;
}

//please don't ever call this from script - it's only for radiant live
// Search in each of the arrays for our desired struct
//	It is done this way because we have deleted the level.struct array
//	We are sacrificing performance in Radiant LiveUpdate in exchange
//	for freeing up variables in the game
function FindStruct( param1, name, index )
{
	if( IsVec( param1 ) )
	{
		position = param1;
		
		foreach ( key, _ in level.struct_class_names )
		{
			foreach ( val, s_array in level.struct_class_names[ key ] )
			{
				foreach ( struct in s_array )
				{
					if( DistanceSquared( struct.origin, position ) < 1 )
					{
						return struct;
					}
				}
			}
		}
		
		if( isdefined( level.struct ) )
		{
			foreach( struct in level.struct )
			{
				if( DistanceSquared( struct.origin, position ) < 1 )
				{
					return struct;
				}
			}
		}
	}
	else
	{
		s = get_script_bundle( param1, name );
		if( isdefined( s ) )
		{
			if( index < 0 )
			{
				return s;
			}
			else
			{
				if( isdefined( s.objects ) )
				{
					return s.objects[index];
				}
			}
		}
	}
	
	return undefined;
}