#using scripts\codescripts\struct;

#using scripts\shared\audio_shared;
#using scripts\shared\array_shared;
#using scripts\shared\music_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

                          



function main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

//		_ambientpackage::activateAmbientPackage( 0, "_pkg", 0 );
//		_ambientpackage::activateAmbientRoom( 0, "_room", 0 );		


	music::declareMusicState("WAVE");
		music::musicAliasloop("mus_theatre_underscore", 4, 2);	
		
	music::declareMusicState("EGG");
		music::musicAlias("mus_zmb_secret_song", 1);
		
	music::declareMusicState( "SILENCE");
	    music::musicAlias("null", 1 );
	    
	/*    
	    
 		//DEFAULT OUTDOOR
 		_ambientpackage::declareAmbientRoom( "outside", true );
 		_ambientpackage::declareAmbientPackage( "outside" );
 		_ambientpackage::setAmbientRoomReverb( "outside", "RV_ZOMBIES_OUTDOOR", 1, 1 );
 		_ambientpackage::setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
 		_ambientpackage::setAmbientRoomTone( "outside", "ghost_wind", 1.5, 2 );
   	_ambientpackage::addAmbientElement( "outside", "ember", .1, .6, 50, 150 ); 
      
    //SMALL INTERIOR
 		_ambientpackage::declareAmbientRoom( "int_small_room" );
 		_ambientpackage::declareAmbientPackage( "int_small_pkg" );
 		_ambientpackage::setAmbientRoomReverb ("int_small_room","RV_ZOMBIES_MEDIUM_ROOM", 1, 1 );
 		_ambientpackage::setAmbientRoomContext( "int_small_room", "ringoff_plr", "indoor" );
    	
   	//LARGE INTERIOR
 		_ambientpackage::declareAmbientRoom( "int_large_room" );
 		_ambientpackage::declareAmbientPackage( "int_large_pkg" ); 
 		_ambientpackage::setAmbientRoomReverb ("int_large_room","RV_ZOMBIES_LARGE_ROOM", 1, 1 );
 		_ambientpackage::setAmbientRoomContext( "int_large_room", "ringoff_plr", "indoor" );
   	             	
	  //DARKROOM
	  _ambientpackage::declareAmbientRoom( "darkroom" );
	  _ambientpackage::declareAmbientPackage( "darkroom" );
 		_ambientpackage::setAmbientRoomReverb ("darkroom","RV_ZOMBIES_MEDIUM_ROOM", 1, 1 );
 		_ambientpackage::setAmbientRoomContext( "darkroom", "ringoff_plr", "indoor" );
 		

//************************************************************************************************
//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************

  _ambientpackage::activateAmbientPackage( 0, "outside", 0 );
  _ambientpackage::activateAmbientRoom( 0, "outside", 0 );

  */

  music::declareMusicState("SPLASH_SCREEN"); //one shot dont transition until done
		music::musicAlias("mx_splash_screen", 12);	
		music::musicWaitTillDone();

	//C. Ayers 9/10/10: Adding these in for future use, once this branch has what I'll be submitting on Treyarch branch	
	music::declareMusicState("WAVE");
	  music::musicAliasloop("mus_zombie_wave_loop", 0, 4);
	   //music::musicAliasloop("mus_factory_underscore", 0, 4);
		
	music::declareMusicState("EGG");
	   music::musicAlias("mus_factory_egg", 1 );
		
	music::declareMusicState( "SILENCE" );
	    music::musicAlias("null", 1 );   

	//thread _waw_zombiemode_radio::init();
	thread start_lights();
	
	//TELEPORTER
	thread teleport_pad_init(0);
	thread teleport_pad_init(1);
	thread teleport_pad_init(2);
	
	thread teleport_2d();
	
	thread pa_init(0);
	thread pa_init(1);
	thread pa_init(2);
	thread pa_single_init();
	
	thread homepad_loop();
	thread power_audio_2d();
	thread linkall_2d();	
	
	thread crazy_power();
	thread flip_sparks();
}

function start_lights()
{
	level waittill ("pl1");

	array::thread_all(struct::get_array( "dyn_light", "targetname" ),&light_sound);
	array::thread_all(struct::get_array( "switch_progress", "targetname" ),&switch_progress_sound);
	array::thread_all(struct::get_array( "dyn_generator", "targetname" ),&generator_sound);
	array::thread_all(struct::get_array( "dyn_breakers", "targetname" ),&breakers_sound);

}

function light_sound()
{
	if(isdefined( self ) )
	{
		playsound(0,"evt_light_start", self.origin);
		e1 = audio::playloopat("amb_light_buzz",self.origin);
	}
}

function generator_sound()
{
	if(isdefined( self ) )
	{
		wait(3);
		playsound(0, "evt_switch_progress", self.origin);
		playsound(0, "evt_gen_start", self.origin);
		g1 = audio::playloopat("evt_gen_loop",self.origin);
	}
}

function breakers_sound()
{
	if(isdefined( self ) )
	{
		playsound(0, "evt_break_start", self.origin);
		b1 = audio::playloopat("evt_break_loop",self.origin);
	}
}

function switch_progress_sound()
{
	if(isdefined( self.script_noteworthy ) )	
	{
    if( self.script_noteworthy == "1" )
    	time = .5;
    else if( self.script_noteworthy == "2" )
    	time = 1;
    else if( self.script_noteworthy == "3" )
    	time = 1.5;
    else if( self.script_noteworthy == "4" )
    	time = 2;
    else if( self.script_noteworthy == "5" )
    	time = 2.5;
    else
    	time = 0;
    	
		wait(time);
		playsound(0, "evt_switch_progress", self.origin);
	}
}


//TELEPORTER
function homepad_loop()
{
	level waittill( "pap1" );
	homepad = struct::get( "homepad_power_looper", "targetname" );
	home_breaker = struct::get( "homepad_breaker", "targetname" );
	
	if(isdefined( homepad ))
	{
		audio::playloopat( "amb_homepad_power_loop", homepad.origin );
	}
	if(isdefined( home_breaker ) )
	{
		audio::playloopat( "amb_break_arc", home_breaker.origin );
	}
}

function teleport_pad_init( pad )  //Plays loopers on each pad as they get activated, threads the teleportation audio
{
	telepad = struct::get_array( "telepad_" + pad, "targetname" );
	telepad_loop = struct::get_array( "telepad_" + pad + "_looper", "targetname" );
	homepad = struct::get_array( "homepad", "targetname" );
	
	level waittill( "tp" + pad);
	array::thread_all( telepad_loop,&telepad_loop );
	array::thread_all( telepad,&teleportation_audio, pad );
	array::thread_all( homepad,&teleportation_audio, pad );
}

function telepad_loop()
{
	audio::playloopat( "amb_power_loop", self.origin );
}

function teleportation_audio( pad )  //Plays warmup and cooldown audio for homepad and telepads
{
	teleport_delay = 2;
	
	while(1)
	{
		level waittill( "tpw" + pad );

		if(IsDefined( self.script_sound ))
		{
			if(self.targetname == "telepad_" + pad) //Sounds play right after each other
			{
				playsound( 0, self.script_sound + "_warmup", self.origin );
				waitrealtime(teleport_delay);
				playsound( 0, self.script_sound + "_cooldown", self.origin );
			}
			if(self.targetname == "homepad") //Sounds wait until 2 seconds before transportation
			{
				waitrealtime(teleport_delay);
				playsound( 0, self.script_sound + "_warmup", self.origin );
				playsound( 0, self.script_sound + "_cooldown", self.origin );
			}
		}
	}		
}

//***PA System***
//Plays sounds off of PA structs strewn throughout the map


function pa_init( pad )
{
	pa_sys = struct::get_array( "pa_system", "targetname" );
	
	//array::thread_all( pa_sys,&pa_teleport, pad );
	//array::thread_all( pa_sys,&pa_countdown, pad );
	//array::thread_all( pa_sys,&pa_countdown_success, pad );
}

function pa_single_init()
{
	pa_sys = struct::get_array( "pa_system", "targetname" );
	
	//array::thread_all( pa_sys,&pa_electric_trap, "bridge" );
	//array::thread_all( pa_sys,&pa_electric_trap, "wuen" );
	//array::thread_all( pa_sys,&pa_electric_trap, "warehouse" );
	//array::thread_all( pa_sys,&pa_level_start );
	//array::thread_all( pa_sys,&pa_power_on );
	
}

function pa_countdown( pad )
{
	level endon( "scd" + pad );
	
	while(1)
	{		
		level waittill( "pac" + pad );
		
		playsound( 0, "evt_pa_buzz", self.origin );
		self thread pa_play_dialog( "vox_pa_audio_link_start" );

		count = 30;
		while ( count > 0 )
		{
			play = count == 20 || count == 15 || count <= 10;
			if ( play )
			{
				playsound( 0, "vox_pa_audio_link_" + count, self.origin );
				//println("play @: " + self.origin);
			}
			
			playsound( 0, "evt_clock_tick_1sec", (0,0,0) );	
			waitrealtime( 1 );
			count--;
		}
		playsound( 0, "evt_pa_buzz", self.origin );
		wait(1.2);
		self thread pa_play_dialog( "vox_pa_audio_link_fail" );
	}
	wait(1);
}

function pa_countdown_success( pad )
{
	level waittill( "scd" + pad );
	
	playsound( 0, "evt_pa_buzz", self.origin );
	wait(1.2);
	//self pa_play_dialog( "pa_audio_link_yes" );
	self pa_play_dialog( "vox_pa_audio_act_pad_" + pad );
}

function pa_teleport( pad )  //Plays after successful teleportation, threads cooldown count
{
	while(1)
	{
		level waittill( "tpc" + pad );
		wait(1);
		
		playsound( 0, "evt_pa_buzz", self.origin );
		wait(1.2);
		self pa_play_dialog( "vox_pa_teleport_finish" );
	}
}

function pa_electric_trap( location )
{
	while(1)
	{
		level waittill( location );
		
		playsound( 0, "evt_pa_buzz", self.origin );
		wait(1.2);
		self thread pa_play_dialog( "vox_pa_trap_inuse_" + location );
		waitrealtime(48.5);
		playsound( 0, "evt_pa_buzz", self.origin );
		wait(1.2);
		self thread pa_play_dialog( "vox_pa_trap_active_" + location );
	}
}

function pa_play_dialog( alias )
{
	if( !IsDefined( self.pa_is_speaking ) )
	{
		self.pa_is_speaking = 0;	
	}
	
	if( self.pa_is_speaking != 1 )
	{
		self.pa_is_speaking = 1;
		self.pa_id = playsound( 0, alias, self.origin );
		while( SoundPlaying( self.pa_id ) )
		{
			wait( 0.01 );
		}
		self.pa_is_speaking = 0;
	}
}
	
function teleport_2d()  //Plays a 2d sound for a teleporting player 1.7 seconds after activating teleporter
{
	while(1)
	{
		level waittill( "t2d" );
		playsound( 0, "evt_teleport_2d_fnt", (0,0,0) );
		playsound( 0, "evt_teleport_2d_rear", (0,0,0) );
	}
}

function power_audio_2d()
{
	level waittill ("pl1");
	playsound( 0, "evt_power_up_2d", (0,0,0) );
}

function linkall_2d()
{
	level waittill( "pap1" );
	playsound( 0, "evt_linkall_2d", (0,0,0) );
}

function pa_level_start()
{
}

function pa_power_on()
{
	level waittill ("pl1");
	
	playsound( 0, "evt_pa_buzz", self.origin );
	wait(1.2);
	self pa_play_dialog( "vox_pa_power_on" );
}

function crazy_power()
{
	level waittill ("pl1");
	playsound( 0, "evt_crazy_power_left", (-510, 394, 102) );
	playsound( 0, "evt_crazy_power_right", (554, -1696, 156) );
}

function flip_sparks()
{
	level waittill ("pl1");
	playsound( 0, "evt_flip_sparks_left", (511, -1771, 116 ) );
	playsound( 0, "evt_flip_sparks_right", (550, -1771, 116 ) );
}

	

