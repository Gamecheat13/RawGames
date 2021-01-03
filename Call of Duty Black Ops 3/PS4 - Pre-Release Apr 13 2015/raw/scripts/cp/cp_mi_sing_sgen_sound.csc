#using scripts\codescripts\struct;
#using scripts\shared\audio_shared;
#using scripts\shared\array_shared;
#using scripts\shared\trigger_shared;
#using scripts\codescripts\struct;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	thread decon_light();
	thread force_underwater_context();
	thread release_underwater_context();
	level thread sndMusicRampers();
	level thread sndScares();
	level thread sndJumpLand();
}
function decon_light()
{
	level notify ("light_on");
}
function force_underwater_context() //forces water to be under context---rooms are not working right
{
	level waittill("tuwc"); //trigger under water context	
	
	setsoundcontext ("ringoff_plr", "underwater"); //for weapon decay's
	wait(1);
	
	setsoundcontext ("water", "under");	//for swimming and whizby's
}
function release_underwater_context()
{
	level waittill("tuwco"); //trigger under water context	
	setsoundcontext ("ringoff_plr", "outdoor"); //for weapon decay's
	wait(1);
	
	setsoundcontext ("water", "default");	//for swimming and whizby's
}

function sndMusicRampers()
{
	level thread sndRobotHall();
}
function sndRobotHall()
{
	level waittill( "sndRHStart" );
	
	level thread sndRobotHallEnd();
	
	target_origin = (412,-2936,-5067);
	player = getlocalplayer(0);
	
	level.tensionActive = true;
	
	level sndRamperThink( player, target_origin, "mus_robothall_layer_1", 0, 1, 250, 1300, "mus_robothall_layer_2", 0, 1, 50, 700 );
}
function sndRobotHallEnd()
{
	level waittill( "sndRHStop" );
	level.tensionActive = false;
}
function sndRamperThink(player, target_origin, alias1, min_vol1, max_vol1, min_dist1, max_dist1, alias2, min_vol2, max_vol2, min_dist2, max_dist2, end_alias )
{
	if( !isdefined( player ) )
		return;
	
	volume1 = undefined;
	volume2 = undefined;
	
	if( isdefined( alias1 ) )
	{
		sndLoop1_ent = spawn(0, (0,0,0), "script_origin" );
		sndLoop1_ID = sndLoop1_ent playloopsound( alias1, 3 );
		sndLoop1_min_volume = min_vol1;
		sndLoop1_max_volume = max_vol1;
		sndLoop1_min_distance = min_dist1;
		sndLoop1_max_distance = max_dist1;
		volume1 = 0;
	}
	
	if( isdefined( alias2 ) )
	{
		sndLoop2_ent = spawn(0, (0,0,0), "script_origin" );
		sndLoop2_ID = sndLoop2_ent playloopsound( alias2, 3 );
		sndLoop2_min_volume = min_vol2;
		sndLoop2_max_volume = max_vol2;
		sndLoop2_min_distance = min_dist2;
		sndLoop2_max_distance = max_dist2;
		volume2 = 0;
	}
	
	while( ( isdefined( level.tensionActive ) && level.tensionActive ) )
	{
		distance = distance( target_origin, player.origin );
		if( isdefined( volume1 ) )
		{
			volume1 = audio::scale_speed( sndLoop1_min_distance, sndLoop1_max_distance, sndLoop1_min_volume, sndLoop1_max_volume, distance );
			volume1 = abs(1-volume1);
			setsoundvolume( sndLoop1_ID, volume1 );
		}
		
		if( isdefined( volume2 ) )
		{
			volume2 = audio::scale_speed( sndLoop2_min_distance, sndLoop2_max_distance, sndLoop2_min_volume, sndLoop2_max_volume, distance );
			volume2 = abs(1-volume2);
			setsoundvolume( sndLoop2_ID, volume2 );
		}
		
		wait(.1);
	}
	
	if( isdefined( end_alias ) )
	{
		playsound( 0, end_alias, (0,0,0) );
	}
	
	if( isdefined( sndLoop1_ent ) )
		sndLoop1_ent delete();
	
	if( isdefined( sndLoop2_ent ) )
		sndLoop2_ent delete();
}

function sndScares()
{
	scareTrigs = getentarray( 0, "sndScares", "targetname" );
	if( !isdefined( scareTrigs ) || scareTrigs.size <= 0 )
	{
		return;
	}
	
	array::thread_all( scareTrigs,&sndScareTrig);
}
function sndScareTrig()
{
	target = struct::get(self.target,"targetname");
	
	while(1)
	{
		self waittill( "trigger", who );
		if( who isplayer() )
		{
			playsound( 0, self.script_sound, target.origin );
			break;
		}
	}
	
}
function sndJumpLand()
{
	jumpTrigs = getentarray( 0, "sndJumpLand", "targetname" );
	if( !isdefined( jumpTrigs ) || jumpTrigs.size <= 0 )
	{
		return;
	}
	
	array::thread_all( jumpTrigs,&sndJumpLandTrig);
}
function sndJumpLandTrig()
{
	while(1)
	{
		self waittill( "trigger", who );

		self thread trigger::function_thread( who,&sndJumpLandTrigPlaysound );
	}
}
function sndJumpLandTrigPlaysound(ent)
{
	playsound( 0, self.script_sound, ent.origin );
}