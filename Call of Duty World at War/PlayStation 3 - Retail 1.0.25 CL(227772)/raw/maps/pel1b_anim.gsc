// Animation Level File
#include maps\_utility;
#include common_scripts\utility; 
#include maps\_anim;
#using_animtree("generic_human");

main()
{
	anim_loader();
	anim_loader_items();

	// dog animation setup
	setup_dog_anim();
}

anim_loader()
{
	//-- Flaming Death Animations for guys at cave entrance
	level.flame_anim[0] = %ai_flame_death_a;
	level.flame_anim[1] = %ai_flame_death_b;
	level.flame_anim[2] = %ai_flame_death_c;
	level.flame_anim[3] = %ai_flame_death_d;
	
	// event 1 explosion anim
	level.explosion_anim["explosion_death"][0] = %death_explosion_left11;
	level.explosion_anim["explosion_death"][1] = %death_explosion_right13;
	level.explosion_anim["explosion_death"][2] = %death_explosion_forward13;
	
	

	// grass guys
	level.scr_anim["bunkers"]["prone_anim_fast"] 	= %ch_grass_prone2run_fast;
	level.scr_anim["bunkers"]["prone_anim_fast_b"]	= %ch_grass_prone2run_fast_b;


	// vehicle ride idle animations
	// tag_passenger4
	level.scr_anim["rider4"]["idle"] = %crew_sherman_passenger4_combatidle;
	//tag_passenger5
	level.scr_anim["rider5"]["idle"] = %crew_sherman_passenger5_combatidle;
	//tag_passenger6
	level.scr_anim["rider6"]["idle"] = %crew_sherman_passenger6_combatidle;

	// special anim for roebuck
	level.scr_anim["roebuck"]["idle"] = %crew_sherman_passenger4_combatidle_long;
	

	// vehicle ride dismount animations.
	// tag_passenger4
	level.scr_anim["rider4"]["dismounta"] = %crew_sherman_passenger4_combatdismount_a;
	level.scr_anim["rider4"]["dismountb"] = %crew_sherman_passenger4_combatdismount_b;

	//tag_passenger5
	level.scr_anim["rider5"]["dismounta"] = %crew_sherman_passenger5_combatdismount_a;
	level.scr_anim["rider5"]["dismountb"] =	%crew_sherman_passenger5_combatdismount_b;

	//tag_passenger6
	level.scr_anim["rider6"]["dismounta"] = %crew_sherman_passenger6_combatdismount_a;
	level.scr_anim["rider6"]["dismountb"] = %crew_sherman_passenger6_combatdismount_b;

	// suicide event
	level.scr_anim["guy1"]["grenade_event"] 	= %ch_peleliu1b_suicidegrenade_guy1;
	level.scr_anim["guy1"]["grenade_event_death"] 	= %ch_peleliu1b_suicidegrenade_guy1_death;
	level.scr_anim["guy2"]["grenade_event"] 	= %ch_peleliu1b_suicidegrenade_guy2;
	level.scr_anim["guy2"]["grenade_event_death"] 	= %ch_peleliu1b_suicidegrenade_guy2_death;

	// POW event
	
	level.scr_anim["ally_held_down"]["vignette"] 	= %ch_makinraid_held_down_head_shot_guy3;
	level.scr_anim["ally_held_down"]["death"] 		= %ch_makinraid_held_down_head_shot_guy3_death;

	level.scr_anim["axis2_held_down"]["vignette"] 	= %ch_makinraid_held_down_head_shot_guy2;
	level.scr_anim["axis1_held_down"]["vignette"] 	= %ch_makinraid_held_down_head_shot_guy1;

	// INTRO DIALOGUE
	//The 200mm on the point still has white beach targeted.
	level.scr_sound["generic"]["intro1"] 		= "Pel1B_IGD_000A_ROEB"; 

	//We all saw first hand what that means when he hit shore.
	level.scr_sound["generic"]["intro2"] 		= "Pel1B_IGD_001A_ROEB";

	//Any attempt to bring in reinforcements just leads to the same outcome…
	level.scr_sound["generic"]["intro3"] 		= "Pel1B_IGD_002A_ROEB";

	//A fucking bloodbath…
	level.scr_sound["generic"]["intro4"] 		= "Pel1B_IGD_003A_POLO";
	
	//Yeah... well...Major Gordon's suspended any further landings until it's knocked out.
	level.scr_sound["generic"]["intro5"] 		= "Pel1B_IGD_004A_ROEB";
	
	//Now listen - 
	level.scr_sound["generic"]["intro6"] 		= "Pel1B_IGD_005A_ROEB";

	//Tojo's got a network of tunnels and caves running through the whole damn rock…
	level.scr_sound["generic"]["intro7"] 		= "Pel1B_IGD_006A_ROEB";

	//We're trying to flush 'em out with the dogs... but we all know how stubborn these bastards are.
	level.scr_sound["generic"]["intro8"] 		= "Pel1B_IGD_007A_ROEB";
	
	//Be prepared for close quarter fighting…
	level.scr_sound["generic"]["intro9"] 		= "Pel1B_IGD_008A_ROEB";
	
	//It ain't gonna be pretty.
	level.scr_sound["generic"]["intro10"] 		= "Pel1B_IGD_009A_ROEB";
	
	//Watch each other's backs…
	level.scr_sound["generic"]["intro11"] 		= "Pel1B_IGD_010A_ROEB";
	
	//Don't get caught out.
	level.scr_sound["generic"]["intro12"] 		= "Pel1B_IGD_011A_ROEB";
	
	//Incoming!!!
	level.scr_sound["generic"]["intro13"] 		= "Pel1B_IGD_012A_POLO";
	
	//Get off the tank!!!
 	level.scr_sound["generic"]["intro14"] 		= "Pel1B_IGD_013A_ROEB";

	//Get to cover, now!
	level.scr_sound["generic"]["intro15"] 		= "Pel1B_IGD_014A_ROEB";


	//----

	//Japanese infantry!
	level.scr_sound["generic"]["event1"] 		= "Pel1B_IGD_015A_POLO";

	//Get behind that fallen tree!
	level.scr_sound["generic"]["event2"] 		= "Pel1B_IGD_016A_POLO";

	//We got artillery coming from the northeast!
	level.scr_sound["generic"]["event3"] 		= "Pel1B_IGD_017A_POLO";

	//We need to move up and knock 'em out!
	level.scr_sound["generic"]["event4"] 		= "Pel1B_IGD_018A_ROEB";

	//Move along the riverbed!
	level.scr_sound["generic"]["event5"] 		= "Pel1B_IGD_019A_ROEB";

	//Flank them!
	level.scr_sound["generic"]["event6"] 		= "Pel1B_IGD_020A_ROEB";

	//Miller! Get on that triple 25!
	level.scr_sound["generic"]["event7"] 		= "Pel1B_IGD_021A_ROEB";

	//Watch that bunker on the left!
	level.scr_sound["generic"]["event8"] 		= "Pel1B_IGD_022A_ROEB";

	//Make sure it's clear!
	level.scr_sound["generic"]["event9"] 		= "Pel1B_IGD_023A_ROEB";

	//First position - Down!
 	level.scr_sound["generic"]["event10"] 		= "Pel1B_IGD_024A_ROEB";

	//There's another one up ahead!
	level.scr_sound["generic"]["event11"] 		= "Pel1B_IGD_025A_ROEB";

	//Clear it out - so our tanks can move up!
	level.scr_sound["generic"]["event12"] 		= "Pel1B_IGD_026A_ROEB";

	//Take out that damn artillery position!!!
	level.scr_sound["generic"]["event13"] 		= "Pel1B_IGD_027A_ROEB";

	//Get off me!!!
	level.scr_sound["generic"]["event14"] 		= "Pel1B_IGD_028A_USR1";

	//Get your damn hands off me!!!
 	level.scr_sound["generic"]["event15"] 		= "Pel1B_IGD_029A_USR1";

	//Help!!!
	level.scr_sound["generic"]["event16"] 		= "Pel1B_IGD_030A_USR1";

	//Thank God you showed up.
	level.scr_sound["generic"]["event17"] 		= "Pel1B_IGD_031A_USR1";

	//Let's go!
	level.scr_sound["generic"]["event18"] 		= "Pel1B_IGD_032A_ROEB";

	/// ALEX  /////////////////////////////////////////

	// explosion death
	level.scr_anim["generic"]["death_explosion_forward"] = %death_explosion_forward13;

	// jog and look
	level.scr_anim["generic"]["jog1"] = %ch_makinraid_creepy_run_guy1;
	level.scr_anim["generic"]["jog2"] = %ch_makinraid_creepy_run_guy2;
	level.scr_anim["generic"]["jog3"] = %ch_makinraid_creepy_run_guy3;
	level.scr_anim["generic"]["jog4"] = %ch_makinraid_creepy_run_guy4;

	// Outro
	level.scr_anim["walker"]["outro"] = %ch_peleliu1b_outro_roebuck;
	addNotetrack_attach( "walker", "attach_smoke", "projectile_us_smoke_grenade", "tag_weapon_left", "outro" );
	addNotetrack_customFunction( "walker", "attach_smoke", ::pacing_throw_smoke,  "outro" );	
	//level thread addNotetrack_detach( "walker", "detach", "projectile_us_smoke_grenade", "tag_weapon_left", "outro" );	
	
	level.scr_anim["sarge"]["outro"] = %ch_peleliu1b_outro_polonski;
	level.scr_anim["radio_guy"]["outro"] = %ch_peleliu1b_outro_radio;
	
	level.scr_anim["walker"]["outro_loop"][0] = %ch_peleliu1b_outro_roebuck_loop;
	level.scr_anim["sarge"]["outro_loop"][0] = %ch_peleliu1b_outro_polonski_loop;
	level.scr_anim["radio_guy"]["outro_loop"][0] = %ch_peleliu1b_outro_radio_loop;
	
	level.scr_anim["walker"]["outro_in"] = %ch_peleliu1b_outro_roebuck_in;
	level.scr_anim["sarge"]["outro_in"] = %ch_peleliu1b_outro_polonski_in;
	level.scr_anim["radio_guy"]["outro_in"] = %ch_peleliu1b_outro_radio_in;

	addnotetrack_dialogue( "radio_guy", "dialog", "outro", "Pel1B_OUT_004A_ROOK" );
	addnotetrack_dialogue( "walker", "dialog", "outro", "Pel1B_OUT_000A_ROEB" );
	addnotetrack_dialogue( "walker", "dialog", "outro", "Pel1B_OUT_001A_ROEB" );
	addnotetrack_dialogue( "sarge", "dialog", "outro", "Pel1B_OUT_002A_POLO" );
	addnotetrack_dialogue( "walker", "dialog", "outro", "Pel1B_OUT_003A_ROEB" );
	addNotetrack_customFunction("walker", "fade_out", ::outro_fade_out, "outro");
	
	// temp outro dialog
	level.scr_sound["sarge"]["outro1"] 		= "Pel1B_OUT_000A_ROEB"; 
	level.scr_sound["sarge"]["outro2"] 		= "Pel1B_OUT_001A_ROEB"; 
	level.scr_sound["walker"]["outro3"] 	= "Pel1B_OUT_002A_POLO";
	level.scr_sound["sarge"]["outro4"] 		= "Pel1B_OUT_003A_ROEB";
	level.scr_sound["radio_guy"]["outro5"] 	= "Pel1B_OUT_004A_ROOK";

	// ev2_dialogs
	level.scr_sound["generic"]["good_work"] 	= "Pel1B_IGD_033A_ROEB";
	level.scr_sound["generic"]["move_gully"] 	= "Pel1B_IGD_034A_ROEB";
	level.scr_sound["generic"]["watch_trees"] 	= "Pel1B_IGD_035A_POLO";
	level.scr_sound["generic"]["keep_tight"] 	= "Pel1B_IGD_036A_ROEB";

	level.scr_sound["generic"]["airforce_know"] 	= "Pel1B_IGD_040A_POLO";
	level.scr_sound["generic"]["heads_down"] 		= "Pel1B_IGD_039A_ROEB";

	level.scr_sound["generic"]["tanks_cover"] 	= "Pel1B_IGD_037A_ROEB";
	level.scr_sound["generic"]["help_clear"] 	= "Pel1B_IGD_038A_ROEB";
	level.scr_sound["generic"]["stay_cover"] 	= "Pel1B_IGD_041A_ROEB";

	level.scr_sound["generic"]["tank_move_up"] 	= "Pel1B_IGD_042A_POLO";
	level.scr_sound["generic"]["move_with_it"] 	= "Pel1B_IGD_043A_ROEB";
	level.scr_sound["generic"]["go_now"] 		= "Pel1B_IGD_044A_ROEB";
	level.scr_sound["generic"]["stay_with"] 	= "Pel1B_IGD_045A_ROEB";

	level.scr_sound["generic"]["watch_tank"] 	= "Pel1B_IGD_046A_ROEB";

	level.scr_sound["generic"]["take_left"] 	= "Pel1B_IGD_048A_ROEB";
	level.scr_sound["generic"]["hear_you"] 		= "Pel1B_IGD_049A_POLO";
	level.scr_sound["generic"]["this_is_it"] 	= "Pel1B_IGD_050A_ROEB";
	level.scr_sound["generic"]["clear_caves"] 	= "Pel1B_IGD_051A_ROEB";

	level.scr_sound["generic"]["stay_with_me"] 	= "Pel1B_IGD_052A_ROEB";
	level.scr_sound["generic"]["miller_here"] 	= "Pel1B_IGD_053A_POLO";


	level.scr_sound["generic"]["temp1"] 	= "Pel1B_IGD_000A_ROEB";
	level.scr_sound["generic"]["temp2"] 	= "Pel1B_IGD_001A_ROEB";
	level.scr_sound["generic"]["temp3"] 	= "Pel1B_IGD_002A_ROEB";
	level.scr_sound["generic"]["temp4"] 	= "Pel1B_IGD_003A_POLO";
	level.scr_sound["generic"]["temp5"] 	= "Pel1B_IGD_004A_ROEB";


	// dog
	level.scr_anim[ "dog_handler" ][ "wait_loop" ][0]	= %ch_peleliu1b_handler_loop;
	level.scr_anim[ "dog_handler" ][ "send_dog" ]	= %ch_peleliu1b_handler_out;
}

dialog_and_anim(index)
{
	switch(index)
	{
		case 0:
			break;
		
		case 1:
	  	break;
		
		default:
			assertex(false, "Hit a bad case in the dialog and anim function");
			break;
	}
}


dog_handler_anim()
{
	anim_struct = getstruct( "dog_anim", "targetname" );

	anim_struct anim_reach_solo( self, "send_dog" );
	flag_set( "dog_handler_in_position" );
	self AllowedStances( "crouch" );
	//anim_struct thread anim_loop_solo( self, "wait_loop" );

	flag_wait( "dog_in_position" );
	self stopanimscripted();
	anim_struct thread anim_loop_solo( self, "wait_loop" );
	wait( 4 );
	self AllowedStances( "crouch", "stand", "prone" );
	self stopanimscripted();
	anim_struct anim_single_solo( self, "send_dog" );
}


dog_victim_think()
{
	wait( 2 );

	spawner = getent( "dog_victim", "targetname" );
	victim = spawner stalingradSpawn( true );
	spawn_failed( victim );

	victim setthreatbiasgroup( "victim" );	

	victim.pacifist = 1;
	victim.health = 1;
}


#using_animtree("dog");
setup_dog_anim()
{
	level.scr_anim["dog"]["combat_idle"]		= %german_shepherd_idle;
	level.scr_anim["dog"]["combat_idle_bark"]	= %german_shepherd_attackidle_bark;
	level.scr_anim["dog"]["combat_combat_run"]	= %german_shepherd_run_attack;

	level.scr_anim["dog"]["wait_loop_reach"]	= %ch_peleliu1b_dog_Loop;
	level.scr_anim["dog"]["wait_loop"][0]	= %ch_peleliu1b_dog_Loop;
	level.scr_anim["dog"]["send_dog"]	= %ch_peleliu1b_dog_out;
}

dog_anim()
{
	self setthreatbiasgroup( "dog" );	
	self.ignoreall = 1;
	self.pacifist = 1;

	anim_struct = getstruct( "dog_anim", "targetname" );

	anim_struct anim_reach_solo( self, "wait_loop_reach" );
	wait( 1 );
	flag_set( "dog_in_position" );
	anim_struct thread anim_loop_solo( self, "wait_loop" );

	level thread dog_victim_think();

	wait( 4 );
	anim_struct anim_single_solo( self, "send_dog" );

	node_1 = getnode( "dog_run_to_node_1", "targetname" );
	self setgoalnode( node_1 );

	self.ignoreall = 0;
	self.pacifist = 0;

	wait( 5 );

	node_2 = getnode( "dog_run_to_node_2", "targetname" );
	self setgoalnode( node_2 );
	self waittill( "goal" );
	self notify( "death" );
	self delete();
}


outro_fade_out(anything)
{
	//Chris_P
	//screen fades to black for a few seconds before the next mission starts
	
	//define this so that nextmission can clean up the client hud elems
	level.nextmission_cleanup = ::clean_up_fadeout_hud;
	
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		players[i] thread hud_fade_to_black(1.5);
	}
	wait(6);
	nextmission();
}

#using_animtree( "animated_props" );

anim_loader_items()
{
	level.scr_anim["radio"]["outro"] = %o_peleliu1_b_outro_handset;
	level.scr_anim["radio"]["outro_loop"][0] = %o_peleliu1_b_outro_handset_loop;
}

pacing_throw_smoke( guy )
{

	wait( 2.25 );
	
	target_pos = guy GetTagOrigin( "tag_weapon_left" );
		
	count = 0;
	
	while( 1 )
	{
		//playfxontag( level._effect["target_smoke"], guy, "tag_weapon_left" );
		playfx( level._effect["target_smoke"], target_pos);		
		wait( 0.05 );
		count++;
		
		if( count > 30 )
		{
			break;	
		}
		
	}

	count = 0;

	while( 1 )
	{
		
		playfx( level._effect["target_smoke"], target_pos);		
		
		count++;
		
		if( count < 500 )
		{
			wait( 0.05 );
		}
		else if( count < 600 )
		{
			wait( 0.1 );
		}
		else if( count < 630 )
		{
			wait( 0.2 );
		}		
		// have it sputter out
		else
		{
			playfx( level._effect["target_smoke"], target_pos);
			wait( 0.25 );
			playfx( level._effect["target_smoke"], target_pos);
			wait( 0.4 );
			playfx( level._effect["target_smoke"], target_pos);
			wait( 0.15 );			
			playfx( level._effect["target_smoke"], target_pos);
			wait( 0.7 );			
			playfx( level._effect["target_smoke"], target_pos);
			wait( 0.4 );			
			playfx( level._effect["target_smoke"], target_pos);						
			break;
		}
	}
}


hud_fade_to_black(time)
{
	self endon("death");
	self endon("disconnect");
	
	if(!isDefined(time))
	{
		time = 1;
	}	
	if(!isDefined(self.warpblack))
	{
		self.warpblack = NewClientHudElem( self ); 
		self.warpblack.x = 0; 
		self.warpblack.y = 0; 
		self.warpblack.horzAlign = "fullscreen"; 
		self.warpblack.vertAlign = "fullscreen"; 
		self.warpblack.foreground = false;
		self.warpblack.sort = 50;
		
		self.warpblack.alpha = 0; 
		self.warpblack SetShader( "black", 640, 480 );	
	}
	self.warpblack FadeOverTime( time ); 
	self.warpblack.alpha = 1;	
}


clean_up_fadeout_hud()
{
	players = get_players();
	for(i=0;i<players.size;i++)
	{
		if(isDefined(players[i].warpblack))
		{
			players[i].warpblack Destroy();
		}
	}	
}
