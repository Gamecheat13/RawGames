#using scripts\codescripts\struct;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\_load;

#using scripts\shared\exploder_shared; // from Barry's mp_barry_test map
#using scripts\shared\util_shared;

#using scripts\cp\cp_ctistaert_test_amb; //for fx
#using scripts\cp\cp_ctistaert_test_fx;

//#using scripts\shared\monsters_core_shared; //ai
#using scripts\shared\callbacks_shared;
#using scripts\shared\spawner_shared;

#using scripts\cp\_load;
#using scripts\cp\_util;





#using scripts\shared\trigger_shared; //triggers

#namespace trigger;
	
function main()
{
	//needs to be first for create fx
	cp_ctistaert_test_fx::main();

	load::main();

	cp_ctistaert_test_amb::main();
	
	wait 5;
	
	level.player = GetPlayers()[0];
		
	level thread setup_fx_triggers();
	level thread dog_scene();	
	level thread timed_looper( "expd" );
	level thread switchtwo();
	level thread switchone();
	level thread lightone();
	level thread lighttwo();
	level thread lightthree();	
	level thread lightfour();
		
	eleobj = new elevator1();
	[[eleobj]]->ele_up();
}

function setup_fx_triggers()
{
	t_one_shot_start = getent( "start_one_shot", "targetname" );
	t_one_shot_stop = getent( "stop_one_shot", "targetname" );
	t_loop_start = getent( "start_loop", "targetname" );
	t_loop_stop = getent( "stop_loop", "targetname" );	
	
	t_one_shot_start thread fire_one_shot( "exploder_test_oneshot" );
	t_one_shot_stop thread stop_one_shot( "exploder_test_oneshot" );
	t_loop_start thread fire_one_shot( "exploder_loop" );
	t_loop_stop thread stop_one_shot( "exploder_loop" );	
}

function fire_one_shot( str_effect )
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", e_triggered );
		ActivateClientRadiantExploder( str_effect );
		util::wait_till_not_touching( e_triggered, self );
	}
}

function stop_one_shot( str_effect )
{
	self endon( "death" );
	
	while( true )
	{
		self waittill( "trigger", e_triggered );
		DeactivateClientRadiantExploder( str_effect );
		util::wait_till_not_touching( e_triggered, self );
	}	
}

function timed_looper( str_effect )
{
	while( true )
	{
		exploder::exploder( str_effect );
		wait 10;
		exploder::stop_exploder( str_effect );
		wait 10;
	}
}

function dog_scene()
{
	wait 1;
	
	self endon("death");

	level trigger::wait_till("dog_scene");

	dog = getEnt("zombie_dog","targetname");

	heli_endpos = getent("drone_crash_pos","targetname");
	
	if(IsDefined(dog) && IsDefined(true))
	{
		dog moveto(heli_endpos.origin, 5);
	
		IPrintLnBold("LOL");
	}
}

class elevator1
{	
	function ele_up()
	{
		wait 1;
		self endon("death");
		
		while(1)
		{
			level trigger::wait_till("pushon");
	
			floorpad = getent("pusher1","targetname");
			
			for(index = 1; index <= 9; index++)
			{
				lever = getent("pusher" + index,"targetname");
			
				if(IsDefined(lever))
				{
					
					lever MoveZ(370, 5);
					IPrintLnBold("GOING UP");
				}
			}
			if(IsDefined(level.player))
			{
				level.player PlayerLinkTo(floorpad);
			}
			if(!IsDefined(level.player))
			{
				IPrintLnBold("PLAYER NOT DEFINED");
			}
			wait 5;
			level.player Unlink();
			ele_down();	

		}
	}
	
	function ele_down()
	{
		
		level trigger::wait_till("pushoff");
		
		pushstart = getent("pushstart_pos","targetname");
		
		for(index =  1; index <= 9; index++)
		{
			lever = getent("pusher" + index,"targetname");
		
			if(IsDefined(lever))
			{
				lever MoveZ(-370, 5);
				IPrintLnBold("GOING DOWN");
			}
		}
		wait 5;
	}
}

function switchone()
{
	wait 1;

	while(1)
	{
		level trigger::wait_till("switch1");
		SetGravity(400);
		IPrintLnBold("Gravity 400");
		wait 1;
	}
}

function switchtwo()	
{
	wait 1;
	
	while(1)
	{
		level trigger::wait_till("switch2");
		SetGravity(800);
		IPrintLnBold("Gravity 800");
		wait 1;
	}
	
}

function lightone()
{
	wait 1;

	while(1)
	{
		level trigger::wait_till("light1");
		setlightingstate( 0 );
		IPrintLnBold("Lighting State 1");
		wait 1;
	}
}

function lighttwo()
{
	wait 1;

	while(1)
	{
		level trigger::wait_till("light2");
		setlightingstate( 1 );
		IPrintLnBold("Lighting State 2");
		wait 1;
	}
}

function lightthree()
{
	wait 1;

	while(1)
	{
		level trigger::wait_till("light3");
		setlightingstate( 2 );
		IPrintLnBold("Lighting State 3");
		wait 1;
	}
}

function lightfour()
{
	wait 1;

	while(1)
	{
		level trigger::wait_till("light4");
		setlightingstate( 3 );
		IPrintLnBold("Lighting State 4");
		wait 1;
	}
}