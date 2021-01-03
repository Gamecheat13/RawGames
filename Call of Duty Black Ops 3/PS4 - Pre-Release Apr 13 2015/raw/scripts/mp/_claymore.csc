#using scripts\codescripts\struct;

#using scripts\shared\face_utility_shared;
#using scripts\shared\system_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#namespace clientfaceanim;

function autoexec __init__sytem__() {     system::register("clientfaceanim",&__init__,undefined,undefined);    }

function __init__()
{
	level.callback_build_face_player = &BuildFace_player;
}

function BuildFace_player()
{
	level.face_anim_initialized = true;
	
//	self face::setFaceRoot( "head" );
//	self face::buildFaceState( "face_casual", true, -1, 0, "basestate", "pf_casual_idle" );
//	self face::buildFaceState( "face_alert", true, -1, 0, "basestate", "pf_alert_idle" );
//	self face::buildFaceState( "face_shoot", true, 1, 1, "eventstate", "pf_firing" );
//	self face::buildFaceState( "face_shoot_single", true, 1, 1, "eventstate", "pf_firing" );
//	self face::buildFaceState( "face_melee", true, 2, 1, "eventstate", "pf_melee" );
//	self face::buildFaceState( "face_pain", false, -1, 2, "eventstate", "pf_pain" );
//	self face::buildFaceState( "face_death", false, -1, 2, "exitstate", "pf_death" );
//	self face::buildFaceState( "face_advance", false, -1, 3, "nullstate", undefined );
}
