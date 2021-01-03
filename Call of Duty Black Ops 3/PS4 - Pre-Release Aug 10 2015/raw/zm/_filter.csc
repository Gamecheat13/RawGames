#using scripts\codescripts\struct;

#using scripts\shared\filter_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#namespace filter;

	
//-----------------------------------------------------------------------------
//
// Filter ( zombies turned overlay )
//
//-----------------------------------------------------------------------------

function init_filter_zm_turned( player )
{
	init_filter_indices();
	map_material_helper( player, "generic_filter_zm_turned" );
}
	
function enable_filter_zm_turned( player, filterid, overlayid )
{
	setfilterpassmaterial( player.localClientNum, filterid, 0, level.filter_matid["generic_filter_zm_turned"] );
	setfilterpassenabled( player.localClientNum, filterid, 0, true );
}
	
function disable_filter_zm_turned( player, filterid, overlayid )
{
	setfilterpassenabled( player.localClientNum, filterid, 0, false );
}
