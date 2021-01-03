#using scripts\shared\system_shared;

//REGISTER SHARED SYSTEMS - DO NOT REMOVE
#using scripts\shared\duplicaterender_mgr;
#using scripts\shared\fx_shared;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\water_surface;
#using scripts\shared\postfx_shared;


//Weapons
#using scripts\shared\weapons_shared;
#using scripts\shared\weapons\_empgrenade;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace load;

function autoexec __init__sytem__() {     system::register("load",&__init__,undefined,undefined);    }

function __init__()
{
	/# level thread first_frame(); #/
}

/#

function first_frame()
{
	level.first_frame = true;
	wait 0.05;
	level.first_frame = undefined;
}

#/

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ART REVIEW - Set up the level to run for art/geo review (no event scripting) - should be called from load::main //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

function art_review()
{
	if ( GetDvarString( "art_review" ) == "" )
	{
		SetDvar( "art_review", "0" );
	}
	
	if ( GetDvarString( "art_review" ) == "1" )
	{
		level waittill( "forever" );
	}
}

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// !ART REVIEW                                                                                                     //
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
