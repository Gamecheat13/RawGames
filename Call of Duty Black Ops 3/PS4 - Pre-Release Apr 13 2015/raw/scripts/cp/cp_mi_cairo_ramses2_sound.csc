#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	thread hospital_walla();
	level thread setIGCsnapshot("igcds1", "cp_ramses_demostreet_1");
	level thread setIGCsnapshot("igcds2", "cp_ramses_demostreet_2");
	level thread setIGCsnapshot("igcds3", "cp_ramses_demostreet_3", "igc");
	level thread setIGCsnapshot("igcds4", "default", "normal");
	level thread setIGCsnapshot("igcvtol1", "cp_ramses_preplaza");
	level thread setIGCsnapshot("igcvtol2", "default");
	level thread setOutrosnapshot("outrofoley", "outroduck");
	level thread set_PreVtol_snapshot();
	level thread play_IGC_fire_loop();
}
function hospital_walla()
{
	level notify ("walla_off");
}
function setIGCsnapshot(arg1, arg2, arg3)
{
	level waittill( arg1 );
	audio::snd_set_snapshot( arg2 );
	
	if( isdefined( arg3 ) )
	{
		setsoundcontext( "foley", arg3 );
	}
}

function setOutrosnapshot(arg1, arg2)
{
	level waittill (arg1);
	setsoundcontext( "foley", "igc" );
	level waittill (arg2);
	audio::snd_set_snapshot("cp_ramses_outro");
	
}
function set_PreVtol_snapshot()
{
	level waittill ("pres");
	audio::snd_set_snapshot( "cp_ramses_pre_vtol" );
	level waittill( "pst" );	
	audio::snd_set_snapshot( "default" );	
}
function play_IGC_fire_loop()
{
	audio::playloopat ("amb_vtol_fire_loop", (8101,-16182,322));
	
}