#using scripts\codescripts\struct;

#using scripts\shared\flagsys_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace debug_menu;

function open( localClientNum, a_menu_items )
{
	close( localClientNum );
	level flagsys::set( "menu_open" );
	
	PopulateScriptDebugMenu( localClientNum, a_menu_items );
	LuiLoad( "uieditor.menus.ScriptDebugMenu" );
//#if XFILE_VERSION >= 293
	level.scriptDebugMenu = CreateLUIMenu( localClientNum, "ScriptDebugMenu" );
	OpenLUIMenu( localClientNum, level.scriptDebugMenu );
//#else // #if XFILE_VERSION >= 293
//	OpenLUIMenu( localClientNum, "ScriptDebugMenu" );
//#endif // #if XFILE_VERSION >= 293
}

function close( localClientNum )
{
	level flagsys::clear( "menu_open" );
//#if XFILE_VERSION >= 293
	if ( isdefined( level.scriptDebugMenu ) )
	{
		CloseLUIMenu( localClientNum, level.scriptDebugMenu );
		level.scriptDebugMenu = undefined;
	}
//#else // #if XFILE_VERSION >= 293
//	CloseLUIMenu( localClientNum, "ScriptDebugMenu" );
//#endif // #if XFILE_VERSION >= 293
}

/@
"Name: set_debug_menu_item_text( <localClientNum>, <index>, <name> )"
"Summary: "
"Module: Util"
"MandatoryArg: <localClientNum>: Number of the local client on the machine."
"MandatoryArg: <index>: The index of the item in the list to update."
"MandatoryArg: <name>: The new text to update the item."
"Example: util::set_debug_menu_item_text( localClientNum, index, name )"
"SPMP: both"
@/
function set_item_text( localClientNum, index, name )
{
	controllerModel = GetUIModelForController( localClientNum );
	parentModel = GetUIModel( controllerModel, "cscDebugMenu.listItem" + index );
	model = GetUIModel( parentModel, "name" );
	
	SetUIModelValue( model, name );
}

/@
"Name: set_debug_menu_item_color( <localClientNum>, <index>, <color> )"
"Summary: "
"Module: Util"
"MandatoryArg: <localClientNum>: Number of the local client on the machine."
"MandatoryArg: <index>: The index of the item in the list to update."
"MandatoryArg: <color>: The new color to update the item."
"Example: util::set_debug_menu_item_color( localClientNum, index, color )"
"SPMP: both"
@/
function set_item_color( localClientNum, index, color )
{
	controllerModel = GetUIModelForController( localClientNum );
	parentModel = GetUIModel( controllerModel, "cscDebugMenu.listItem" + index );
	model = GetUIModel( parentModel, "color" );
	
	if ( IsVec( color ) )
	{
		color = "" + color[0] * 255 + " " + color[1] * 255 + " " + color[2] * 255;
	}
	
	SetUIModelValue( model, color );
}
