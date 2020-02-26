/*==================================================================================
: Utility Functions: _strength_test.gsc 

Contains the all the functions neeeded to setup a strength test fight in your map
 - Includes helper functions for audio, text prompts and fight cnfiguration

------------------------------------------------------------------------------------

*** SETTING UP A STRENGTH TEST EVENT IN YOUR MAP ***

Script Initialization: 

	- Initializing the players interactive models for FULLBODY and HANDS
	  This is usually setup in _loadout.gsc in the init_loadout() function
	  However you can call this in your main function is you need to.
		// Script call example
			set_player_interactive_hands( "viewmodel_usa_jungmar_player");
			set_player_interactive_model( "viewmodel_usa_jungmar_player_fullbody" );
	

Animation Initialization: 
	
	 - Animation Setup
	   You need to setup animations for the attacker and the player
	   
		// Script Call: Setting up the enenmy attacker.
						(Optional) Note you can use a notetrack to play a custom death on the enemy attacker on sucess.
   			level.scr_anim["e_strength_enemy"]["strength_test_start"] = %ch_khe_E3_nvaturretDive_nva01;
			level.scr_anim["e_strength_enemy"]["strength_test_loop"][0] = %ch_khe_E3_nvaturretDive_choke_nva01;
			level.scr_anim["e_strength_enemy"]["strength_test_success"] = %ch_khe_E3_nvaturretDive_success_nva01;
			addNotetrack_customFunction("e_strength_enemy", "boom", ::nva_boom, "strength_test_success");	

		// Script Call: Setting up the player.
			// Setup marine full body
			level.scr_model["player_body"] = level.player_interactive_model;
			level.scr_animtree["player_body"] = #animtree;

			// Setup marine interactive hands
			level.scr_model["player_hands"] = level.player_interactive_hands;
			level.scr_animtree["player_hands"] = #animtree;

			// Player strength test anims
			level.scr_anim["player_body"]["strength_test_start"] = %ch_khe_E3_nvaturretDive_player;
			level.scr_anim["player_body"]["strength_test_loop"][0] = %ch_khe_E3_nvaturretDive_choke_player;
			level.scr_anim["player_body"]["strength_test_success"] = %ch_khe_E3_nvaturretDive_success_player;


CSV: Asssets Needed

	// Strength test AI animations
		xanim,ch_khe_E3_nvaturretDive_nva01
		xanim,ch_khe_E3_nvaturretDive_choke_nva01
		xanim,ch_khe_E3_nvaturretDive_success_nva01	

	// Strength test PLAYER animations
		xanim,ch_khe_E3_nvaturretDive_player
		xanim,ch_khe_E3_nvaturretDive_choke_player
		xanim,ch_khe_E3_nvaturretDive_success_player

	
Radiant:	
	- Place a script_origin in the correct place in the map to play the strength test from, add a targetname


Triggering a Strength Test Event in Script:
	- The following script calls will start a strength test fight	
	
		player = getplayers()[0];
		// This call is an optional helper function to add custom audio effects
		player maps\_strength_test::set_strength_test_audio( "evt_khe_nva_hth_start", "evt_khe_nva_hth_loop" );
		player maps\_strength_test::strength_test_start( <aligned origin targetname>, 
														 <enemy spawner targetname>, 
														 <String to display on screen during the fight> );


Script Helper Functions:

	// Used to change the difficulty (called on the player)
	// This can be called to change the number of button presses needed or the timeout of the event
	// The default is (15, 8)
	player set_strengthtest_difficulty( max_button_presses, fail_time );

	// Used to add custom audio
	player set_strength_test_audio( enemy_attack_shout, enemy_fighting_looping_audio );


************************************************************************************/


#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;


/*==============================================================
SELF: player
PURPOSE: Setup the Strength Test Audio
RETURNS: 
CREATOR: MikeA
===============================================================*/

set_strengthtest_difficulty( max_button_presses, fail_time )
{
	self.strengthtest_max_button_presses = max_button_presses;
	self.strengthtest_fail_time = fail_time;
}


/*==============================================================
SELF: player
PURPOSE: Setup the Strength Test Audio
RETURNS: 
CREATOR: MikeA
===============================================================*/

set_strength_test_audio( enemy_attack, fight_looping )
{
	self.strengthtest_enemy_attack_audio = enemy_attack;
	self.strengthtest_fight_looping_audio = fight_looping;
}


/*======================================================================
SELF: player
PURPOSE: Puts the player in a strength test fight and controls the fight
RETURNS: 
CREATOR: MikeA
=======================================================================*/

strength_test_start( align_node_targetname, enemy_spawner_targetname, button_prompt_text )
{
	self endon( "death" );

	// Make sure the player flags are initialized
	if( !self flag_exists( "start_strength_test" ) )
	{
		self ent_flag_init( "start_strength_test" );
		self ent_flag_init( "strength_test_half_way" );
		self ent_flag_init( "strength_test_complete" );
	}
	
	// Clear the player flags
	self ent_flag_clear( "start_strength_test" );
	self ent_flag_clear( "strength_test_half_way" );
	self ent_flag_clear( "strength_test_complete" );


	// Make sure we atleast have the default difficulty settings
	if( !IsDefined(self.strengthtest_max_button_presses) )
	{
		self set_strengthtest_difficulty( 15, 8 );
	}

	level thread maps\_strength_test::strength_test_update( self, button_prompt_text );

	// Get the align node
	align_node = GetEnt( align_node_targetname, "targetname" );

	// Setup the Player Body
	self DisableWeapons();
	self HideViewModel();
	self.body = spawn_anim_model( "player_body" );
	self PlayerLinkToAbsolute( self.body, "tag_player" );

	// Spawn in the Enemy Guy
	e_enemy = simple_spawn_single( enemy_spawner_targetname );
	e_enemy.dieQuietly = true; //kevin avoid death sounds
	
	// Set the animname of the eneny entity for animation references
	e_enemy.animname = "e_strength_enemy";
	e_enemy.ignoreall = true;
	e_enemy.ignoreme = true;
	
	e_enemy magic_bullet_shield();

	// Play the jump foley
	if( IsDefined(self.strengthtest_enemy_attack_audio) )
	{
		e_enemy playsound( self.strengthtest_enemy_attack_audio );
	}

	// Depth of field
	self attacking_enemy_dof();

	// Play the dive
	actors = array( self.body, e_enemy );
	align_node anim_single_aligned( actors, "strength_test_start" );
	
	self ent_flag_set( "start_strength_test" );
	
	// Play the flight audio loop
	align_node thread anim_loop_aligned(actors, "strength_test_loop");

	sound_org = spawn("script_origin", (0,0,0));
	
	if( IsDefined(self.strengthtest_fight_looping_audio) )
	{
		sound_org playloopsound ( self.strengthtest_fight_looping_audio );
	}
		
	// Wait for test complete
	self ent_flag_wait( "strength_test_complete" );
	
	// TUEY - FOR AUDIO
	level clientnotify ("vcd");
	
	// Set the blur back to normal since player won
	self SetBlur( 0, 0.5 );	
	sound_org stoploopsound (.5);

	e_enemy stop_magic_bullet_shield();

	// Punch him out!
	self thread punch_out_rumble();
	
	align_node anim_single_aligned(actors, "strength_test_success");

	// back to normal
	self maps\_art::setdefaultdepthoffield();
	self UnLink();
	self.body delete();
	self ShowViewModel();
	self EnableWeapons();
	self SetStance( "stand" );
}


/*==============================================================
SELF: level
PURPOSE: Strength Test Update Function
RETURNS: 
CREATOR: MikeA
===============================================================*/

strength_test_update( player, button_prompt_text )
{
	player ent_flag_wait( "start_strength_test" );

	player endon("death");

	level endon( "end" );

	// Show the prompt on the screen
	player thread strength_test_button_prompt( button_prompt_text );

	// Vars for strength test
	player.strengthtest_button_presses = 0;
	
	// The smaller the number the longer it will take to decay from full.
	// example: 0.2 will drain a full meter in 5 seconds. while 2 will drain it in 0.5 seconds
	DECAY_RATE = 0.2;

	// 0 == down; 1 == up; 2 == pressed; 3 == released (doing this to avoid more script strings)  
	button_state = 1; 

	// Rumble function sets rumble based on value of player.strengthtest_button_presses
	player thread strength_test_fighting_rumble();

	// Fails mission when you are idle based on int passed in.
	player thread strength_test_fail_timer();

	//if( !IsGodMode( player ) )
	{
		// ACB - Strength Test button watcher
		while( player.strengthtest_button_presses <= player.strengthtest_max_button_presses * 0.05 ) 
		{
			if( !player ent_flag( "strength_test_half_way" ) && 
				player.strengthtest_button_presses >= ((player.strengthtest_max_button_presses * 0.05) * 0.5) )
			{
				player ent_flag_set( "strength_test_half_way" );
			}

			// Fix for button press always returning true on hold. checks for button states
			if( player UseButtonPressed() )
			{
				// Makes sure fast presses are counted.
				if(button_state == 1 || button_state == 3)	//if "up" or "released"
				{
					button_state = 2;			//set to "pressed"
				}
				else if(button_state == 2)		//if still "pressed"
				{
					button_state = 0;			//set to down  
				}
			}
			else
			{
				// Make sure fast releases are counted
				if(button_state == 0 || button_state == 2)	//if "down" or "pressed"
				{
					button_state = 3;			//set to "released" 
				}
				else if(button_state == 3 )		//if still "released"
				{
					button_state = 1;			//set to "up" 
				}
			}

			// Decrements per frame if button is "up"
			if(button_state == 1)
			{
				player.strengthtest_button_presses -= DECAY_RATE * 0.05;
			}	

			// Increments strength test if button is "pressed".
			if(button_state == 2 ) 
			{
				player.strengthtest_button_presses += 1/player.strengthtest_max_button_presses;
			}
			
			// Stop decay 
			if( player.strengthtest_button_presses <= 0 )
			{
				player.strengthtest_button_presses = 0;
			}			

			wait( 0.05 );
		}
	}

	player ent_flag_set( "strength_test_complete" );
}


/*=====================================================================
SELF: player
PURPOSE: Mission fail wrapper based on idle time.
RETURNS: 
CREATOR: MikeA
=====================================================================*/

strength_test_fail_timer()
{
	self endon( "death" );
	self endon( "strength_test_complete" );

	fail_time = self.strengthtest_fail_time;

	x = fail_time * 1.01;
	blur = 1;
	if ( IsDefined( self.strengthtest_blur ) && self.strengthtest_blur == 0 )
	{
		blur = 0;
	}
	
	while(1)
	{
		if( IsGodMode(self) )
		{	
			fail_time = 10;
		}
		else
		{
			if ( blur )
			{
				self SetBlur( (x - fail_time), 0.05 );
			}
			if(fail_time <= 0)
			{
				// Stop the strength test watcher and rumble logic so player cannot complete as we are failing
				level notify( "end" );

				fail_time = 0;

				if ( !IsDefined( self.strengthtest_custom_fail ) )
				{
					// Rumble and spawn breath effects for 3 secs		  
					for( i=0; i<6; i++ )
					{	
						self PlayRumbleOnEntity( "damage_heavy" );
						wait 0.5;
					}
	
					level thread strength_test_screen_out( "white", 0.25 );
					wait 0.25;
					missionFailedWrapper();
				}
				break;
			}	
		}

		wait 1;
		fail_time--;
			
		/#		
			PrintLn("loiter_time " + fail_time);
		#/		
	}
}


/*==================================================================================
SELF: player
PURPOSE: Takes player.strengthtest_button_presses and applies rumble based on range.
		 Switches between low and high rumble at 50%
RETURNS: 
CREATOR: MikeA
===================================================================================*/

strength_test_fighting_rumble()
{
	self endon( "death" );
	self endon( "strength_test_complete" );
	level endon( "end" );

	RUMBLE_RANGE = 0.5;

	self ent_flag_wait( "start_strength_test" );

	while( 1 )
	{
		if( (self.strengthtest_button_presses >= 0) && (self.strengthtest_button_presses <= 1) )
		{
			if( (self.strengthtest_button_presses >= 0) && (self.strengthtest_button_presses < RUMBLE_RANGE) )
			{
				self PlayRumbleOnEntity( "damage_light" );
				wait 0.22;
			}

			if( self.strengthtest_button_presses >= RUMBLE_RANGE && self.strengthtest_button_presses <= 1 )
			{
				self PlayRumbleOnEntity( "damage_heavy" );
				wait 0.02;				
			}
		}

		wait 0.05;
	}	
}


/*=====================================================================
SELF: player
PURPOSE: Plays a series of success rumbles if the player wins the fight
RETURNS: 
CREATOR: MikeA
=====================================================================*/

punch_out_rumble()
{
	self PlayRumbleOnEntity("damage_heavy");

	wait(1.3);

	self PlayRumbleOnEntity("damage_light");

	wait(2.5);

	self PlayRumbleOnEntity("grenade_rumble");
}


/*==============================================================
SELF: player
PURPOSE: DOF Effect when enemy attacks
RETURNS: 
CREATOR: MikeA
===============================================================*/

attacking_enemy_dof()
{
	near_start = 0;
	near_end = 25;
	far_start = 558;
	far_end = 2575;
	near_blur = 4;
	far_blur = 0.5;
	self SetDepthOfField( near_start, near_end, far_start, far_end, near_blur, far_blur);
}


/*==============================================================
SELF: player
PURPOSE: Displays the button prompt message during the fight
RETURNS: 
CREATOR: MikeA
===============================================================*/

strength_test_button_prompt( button_message )
{
	level endon( "end" );

	screen_message_create( button_message );

	self ent_flag_wait( "strength_test_complete" );

	screen_message_delete();
}


/*==============================================================
SELF: level
PURPOSE: Fade out screen over time
RETURNS: 
CREATOR: MikeA
===============================================================*/

strength_test_screen_out( shader, time )
{
	// define default values
	if( !isdefined( shader ) )
	{
		shader = "black";
	}

	if( !isdefined( time ) )
	{
		time = 2.0;
	}

	if( isdefined( level.st_fade_screen ) )
	{
		level.st_fade_screen Destroy();
	}

	level.st_fade_screen = NewHudElem(); 
	level.st_fade_screen.x = 0; 
	level.st_fade_screen.y = 0; 
	level.st_fade_screen.horzAlign = "fullscreen"; 
	level.st_fade_screen.vertAlign = "fullscreen"; 
	level.st_fade_screen.foreground = true;
	level.st_fade_screen SetShader( shader, 640, 480 );

	if( time == 0 )
	{
		level.st_fade_screen.alpha = 1; 
	}
	else
	{
		level.st_fade_screen.alpha = 0; 
		level.st_fade_screen FadeOverTime( time ); 
		level.st_fade_screen.alpha = 1; 
		wait( time );
	}
	level notify( "screen_fade_out_complete" );
}


