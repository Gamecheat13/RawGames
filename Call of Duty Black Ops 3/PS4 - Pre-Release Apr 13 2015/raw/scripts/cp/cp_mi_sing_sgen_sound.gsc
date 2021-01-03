#using scripts\codescripts\struct;
#using scripts\cp\_util;
#using scripts\shared\music_shared;
#using scripts\cp\voice\voice_sgen;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

function main()
{
	voice_sgen::init_voice();
	level thread raven_fly();
	level thread upper_silo_door_bang();
	level thread water_monster_scare();
	level thread robot_hallway_scare();
	level thread underwater_explosions();
	level thread underwater_bump_handling();
	level thread silo_robot_awaken();
	level thread under_silo_metal_groan();
	level thread play_dni_chamber_hum();
	level thread play_genlab_music();
	level thread play_robot_knock_music();
	level thread play_robot_ambush_music();
	
}
function play_genlab_music() 
{
	level waittill ("gen_lab_gone_hot");
	music::setmusicstate ("genlab");

	level waittill ("gen_lab_cleared");
	music::setmusicstate ("none");
	
}
function play_robot_knock_music() //will be removed when the music system is online
{
	
	level waittill ("skr");
	wait (4);
	music::setmusicstate ("knockbot");

	level waittill ("skrd");
	music::setmusicstate ("none");
	
}
function play_robot_ambush_music() 
{
	level waittill ("ambush");
	music::setmusicstate ("ambush");
	
	level waittill ("srcdd");
	music::setmusicstate ("none");
}
	
//Will Set the music for an area
function sndMusicSet(area,musicEnd=false)
{
	if( !isdefined( area ) )
		return;
	
	message_top = "Music System";
	message_mid = undefined;
	message_bot = undefined;
	
	switch( area )
	{
		case "igc_intro":
			message_mid = "Oneshot: IGC Intro Music";
			break;
		case "quadtank_intro":
			if( !musicEnd )
			{
				message_mid = "Oneshot: Quadtank Intro Stinger";
				message_bot = "Looper: Quadtank Battle Music";
			}
			else
			{
				message_mid = "StopLooper: Quadtank Battle Music";
			}
			break;
		case "sgen_enter":
			// message_mid = "Oneshot: SGEN Corporate Logo Theme";
			break;
		case "dark_battle":
			if( !musicEnd )
			{
			//	message_mid = "Oneshot: Ambush Stinger";
			//	message_bot = "Looper: Dark Battle Music";
			}
			else
			{
			//	message_mid = "StopLooper: Dark Battle Music";
			}
			break;
		case "pallas":
			if( !musicEnd )
			{
				message_mid = "Looper: Pallas Battle Music";
			}
			else
			{
				message_mid = "StopLooper: Pallas Battle Music";
				message_bot = "Oneshot: Pallas Defeat Stinger";
			}
			break;
		case "water_exit":
			if( !musicEnd )
			{
				message_mid = "Looper: Water Exit";
			}
			else
			{
				message_mid = "StopLooper: Water Exit";
				message_bot = "Oneshot: Level End";
			}
			break;	
	}
	
	foreach( player in level.players )
	{
		player thread util::screen_message_create_client( message_top, message_mid, message_bot, 200, 5 );
	}
}
function raven_fly()
{
	trigger = GetEnt ("amb_raven_fly", "targetname");
	if(IsDefined (trigger))
	{
		trigger waittill ("trigger");
		wait 2;
		playsoundatposition ("evt_raven_caw", (420,-2031,590));
	}
	
}
function upper_silo_door_bang()
{
	trigger = GetEnt ("amb_door_bang_silo_office", "targetname");
	if(IsDefined (trigger))
	{
		trigger waittill ("trigger");
		wait 0.5;
		playsoundatposition ("evt_door_bang", (660,-608,-1195));
	}
	
}
function silo_door_scare()
{
	trigger = GetEnt ("silo_door_scare", "targetname");
	if(IsDefined (trigger))
	{
		trigger waittill ("trigger");
		wait 0.5;
		playsoundatposition ("evt_silo_door_scare", (-780,874,-2806));
	}
	
}
function under_silo_metal_groan()
{
	trigger = GetEnt ("evt_metal_groan_undersilo", "targetname");
	if(IsDefined (trigger))
	{
		trigger waittill ("trigger");
		wait 3;
		playsoundatposition ("evt_dist_metal", (82,-863,-4551));
	}
}

function water_monster_scare()
{
	trigger = GetEnt ("evt_water_monster", "targetname");
	if(IsDefined (trigger))
	{
		trigger waittill ("trigger");
		wait 0.5;
		playsoundatposition ("evt_water_monster", (63,801,-4423));
	}
	
}
function robot_hallway_scare()
{
	trigger = GetEnt ("amb_robot_hallway", "targetname");
	if(IsDefined (trigger))
	{
		trigger waittill ("trigger");
		wait 0.5;
		playsoundatposition ("evt_robot_hallway", (216,-2624,-5120));
	}
	
}
function underwater_explosions()
{
	water_exp_trigs = getentarray ("evt_underwater_exp", "targetname");
	for(i =0; i < water_exp_trigs.size; i++)
	{
		water_exp_trigs[i] thread play_explosions();
	}
	
}
function play_explosions ()
{
	target = struct::get (self.target, "targetname");
	self waittill ("trigger");
	playsoundatposition (self.script_sound, target.origin);	
	
}
function underwater_bump_handling()
{
	underwater_bump_trigs = getentarray ("amb_underwater_bump", "targetname");
	for(i =0; i < underwater_bump_trigs.size; i++)
	{
		underwater_bump_trigs[i] thread play_underwater_bumps();
	}
}
function play_underwater_bumps()
{
	self waittill ("trigger");
	self playsound (self.script_sound);	
}
function silo_robot_awaken()
{
	sound_locs = getentarray ("evt_robots_awaken", "targetname");
	for(i =0; i < sound_locs.size; i++)
	{
		sound_locs[i] thread play_robot_awaken();
	}
}
function play_robot_awaken()
{
	self.counter = 0;
	
	level waittill ("ambush");
	
	while (self.counter < 2)
	{
		wait randomintrange(0, 4);
		self playsound ("evt_robots_awaken");
		self.counter ++;
	}
}
function play_dni_chamber_hum()
{
	level waittill ("enter_server");
	sound_org = getent ("amb_dni_chamber_origin", "targetname");
	if (IsDefined (sound_org))
	{
		sound_org playloopsound ("amb_dni_chamber_hum", 0);
	}
	
}


		
		
	
