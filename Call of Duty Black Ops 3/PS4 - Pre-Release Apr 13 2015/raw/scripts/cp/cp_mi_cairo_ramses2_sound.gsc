#using scripts\codescripts\struct;
#using scripts\shared\util_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\voice\voice_ramses;
#using scripts\shared\flag_shared;

function main()
{
	voice_ramses::init_voice();              // add this
	level thread IGCwait("sndDemostreet1","igcds1");
	level thread IGCwait("sndDemostreet2","igcds2");
	level thread IGCwait("sndDemostreet3","igcds3");
	level thread IGCwait("sndDemostreet4","igcds4");
	level thread outrowait("sndOutroFoley", "outrofoley", "sndOutro", "outroduck");
//	level thread IGCwait("sndvtolcollapse1","igcvtol1");
//	level thread IGCwait("sndvtolcollapse2","igcvtol2");
	level thread quad_plaza_music();
	level thread area_defend_retreat_music();
	level thread quad_plaza_outro();
	level thread jeep_drive_in_music();
}

function IGCwait(arg1, arg2)
{
	level waittill( arg1 );
	level util::clientnotify( arg2 );
}

function outrowait(arg1, arg2, arg3, arg4)
{	
	level waittill (arg1);
	level util::clientnotify(arg2);
	level waittill (arg3);
	level util::clientnotify( arg4 );
}
	
function quad_plaza_music()
{
	wait(5);
	
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	//level flag::wait_till( "quad_tank_3_spawned" );
	level waittill ("t3_spawn");
	wait (1);
	level.mus_ent playloopsound ("mus_ramses_quad_tank");
	
	level flag::wait_till( "third_quadtank_killed" );
	
	level.mus_ent stoploopsound ();
	
	
}
function jeep_drive_in_music()
{
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	level waittill ("drive_music");
	
	//level.mus_ent playloopsound ("mus_ramses_quad_tank");
	playsoundatposition ("mus_ramses_jeep_drive_in", level.mus_ent.origin);
	
	
	///level waittill ("quad_dead");
	
	///level.mus_ent stoploopsound ();
	
	
}
function area_defend_retreat_music()
{
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	level waittill ("area_defend_music");
	
	wait (1);
	//level.mus_ent playloopsound ("mus_ramses_quad_tank");
	playsoundatposition ("mus_ramses_retreat_spike_area", level.mus_ent.origin);
	
	
	///level waittill ("quad_dead");
	
	///level.mus_ent stoploopsound ();
	
	
}
function quad_plaza_outro()
{
	if(!IsDefined(level.music_ent))
	{
		level.mus_ent = spawn ("script_origin", (0,0,0));
	}
	
	level waittill ("start_outro");
		
	playsoundatposition ("mus_ramses_quad_outro", level.mus_ent.origin);
	
	//level waittill ("quad_dead");
	
	//level.mus_ent stoploopsound ();
	
	
}