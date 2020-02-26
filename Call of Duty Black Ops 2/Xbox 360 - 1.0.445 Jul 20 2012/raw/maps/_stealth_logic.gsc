#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

#insert raw\maps\_utility.gsh;

/************************************************************************************************************/
/*																											
											CONFUSED? NEED HELP?											
																											
										come grab me: mohammad alavi										 
										badmofo@infinityward.com																	
										extention: 8044														
																											*/
/************************************************************************************************************/

/************************************************************************************************************/
/*	
  												 B A S I C S		 										  

  										HOW TO USE STEALTH SYSTEM 											  

  							(follow in this order )															  
  							1. call maps\_stealth_logic::main(); in your main level script					  
  							2. call maps\_stealth_behavior::main(); in your main level script				  
  							3. you're going to have a couple fastfile errors for animations and
  								missing rawfiles, fix those.  																											  			
  							4. call maps\_utility::stealth_ai on all ai and the player						  
  										
  							-----------------------------------------------------------------------	
  										
  											USEFUL FUNCTIONS
  							( documentation in _utility and script docs ):
  							
  							//knowing when AI are alerted to something	
  							maps\_utility::stealth_enemy_waittill_alert
  							maps\_utility::stealth_enemy_endon_alert
  						  							
  						  	//setting up custom idle and alerted reaction animations
							maps\_utility::stealth_ai_idle_and_react
							maps\_utility::stealth_ai_reach_idle_and_react
							maps\_utility::stealth_ai_reach_and_arrive_idle_and_react
							maps\_utility::stealth_ai_clear_custom_idle_and_react
							maps\_utility::stealth_ai_clear_custom_react
  																							  
  																											*/ 
/************************************************************************************************************/

/************************************************************************************************************/
/*	 																											  
  												A D V A N C E D												  					
  																											  						
  										HOW TO CREATE CUSTOM STEALTH BEHAVIOR								  					
  																											  						
  							the stealth code is split up into 2 major systems: logic and behavior.			  
  							the logic code is independent of the behavior code, which means it can			  
  							run by itself.  The behavior code however is dependant on messages from			  
  							the logic code and cannot run by itself. Both the level and all ai have			  
  							a spawnstruct '._stealth'.  Inside this struct are 2 more structs 				  
  							'.logic', and '.behavior'.  Everything to do with logic goes into 				  
  							'._stealth.logic' and with behavior goes into '._stealth.behavior'				  
  																											  
  							-----------------------------------------------------------------------			  
  																											  
  							CONCEPT OF LOGIC CODE:															  
  																											  	
  							the logic code doesn't actually tell the AI to do anything, it just 			  
  							detects whether the friendlies have been spotted, corpses have been 			  
  							found, etc, etc.  It then sets flags/sends notifies to ai.						  
  																											  							
  							Code gives axis ai an enemy on a couple different factors that the logic 		  
  							code tweaks (such as the distance an AI can hear footsteps, gunshots, 			  
  							teammates dying, etc ). The logic code also dictates how far an axis ai 		  
  							can even see an enemy based on a score calculated by the enemy's stance,  		  
  							movement speed, and	current level of awareness of the axis team.		 		  
  																											  							
  							So the logic code in a nutshell, is a simple loop that detects when 			  
  							an axis ai receives an enemy, and then clears that enemy.  this keeps			  
  							the axis from just opening fire at first sight.  It instead raises his			  
  							awareness level and possibly the whole teams if the enemy is spotted 			  
  							more than once. --> flag_set( "_stealth_alert" );										  
  																											  							
  							If friendlies or the player are spotted enough times -OR- something 			  
  							VERY bad happens like an death or a gunshot, then we skip 					  
  							intermediate levels of detection and go straight to full level of 				  
  							awareness. --> flag_set( "_stealth_spotted" );											  
  																											  	
  							-----------------------------------------------------------------------			  
  																											  							
  							CHANGING THE BEHAVIOR CODE:														  
  																											  							
  							METHOD 1:																		  
  							there are 2 ways to change the behavior code, one would be to write				  
  							your own from scratch...this is not recommended.  However if you do 			  
  							want to do this, you basically need the following:								  
  																											  							
  							1. a system loop which handles global ai settings based on the 3 level			  
  								flag messages: 'hidden', 'alert', and 'spotted'; The messages				  
  								for this are sent from all over, but they can all be traced back 			  	
  								to the function:															  
  								_stealth_logic::enemy_threat_logic();										  
  							2. a loop for individual ai based on team which handles their behavior 			  
  								based on the same 3 flag messages.											  
  							3. functions for axis ai which handle thir 3 personal levels of 				  
  								awareness and what to do when they see/find a corpse.  This is the			  
  								the "huh", "what happened", "oh shit enemy" behavior. The messages			  
  								for this are sent in the functions:											  
  								_stealth_logic::enemy_alert_level_change( type, enemy );					  
  								_stealth_logic::enemy_corpse_logic();	
  							4. functions to handle awareness of certain events as well as reactionary
  								animations for such events...the notifies for these often overlap
  								the functions above so you'll need more animation functions than
  								behavioral...the messages for these are sent by:
  								_stealth_logic::enemy_event_awareness( type )
  							5. finally - instead of calling maps\_utility::stealth_ai() on your ai, 
  								only run maps\_utility::stealth_ai_logic() to run the logic code 
  								but not the default behavior code. 							
  							
  							-----------------------------------------------------------------------	
  																	    				  																											  							
  							METHOD 2:																		  
  							the easier and recommended way to change the behavior is to replace				  
  							certain key functions the behavior code is running with your own. 				  
  							These functions can easily be replaced when calling the init functions 			  
  							for behavior: 																	  
  																											  							
  							_stealth_behavior::system_init( state_functions );										  
  							_stealth_behavior::enemy_logic( state_funcs, alert_funcs, corpse_funcs, awareness_funcs );		  
  							_stealth_behavior::friendly_logic( state_functions );							  
  																											  							
  							the utility function which should be called on all ai is where you should 		  	
  							most likely be passing the parameters. It handles both enemy_logic			  	
  							and friendly_logic ( documentation in _utility and script docs ):															  	
  								- _utility::stealth_ai( state_funcs, alert_funcs, corpse_funcs )			  	
  								- note = you should generally not send the same state_funcion to both		  	
  								- axis ai and friendly ai...	  	
  																											  							
  							all the parameters are arrays of function pointers ( and are optional )			  
  																											  							
  							- state_functions is an array of 3 with keys 'hidden', 'alert', and 			  
  							'spotted'. 																		  
  								- For ::system_init(), it's an array of 3 functions that handle global 			  
  								state changes for all AI. 													  
  								example = _stealth_behavior::system_state_alert()							  
  								- For ::enemy_logic() and ::friendly_logic, they handle individual 			  
  								changes per AI based on state.												  
  								example1 = _stealth_behavior::enemy_state_spotted()							  
  								example2 = _stealth_behavior::friendly_state_spotted()						  
  								- notice friendly_logic() only takes the state_functions array				  
  								and not the other 2...that's because it's assumed friendly behavior			  
  								only changes based on global state of awereness for the axis team, 			  
  								not indivual states	of awareness for axis ai.								  
  																											  							
  							-alert_functions is an array of 4 with keys "reset", "alerted_once", 
  							"alerted_again", and "attack" that represent individual states of 
  							awareness of axis ai.										  
  								-this is where the bread and butter of the "huh", "what's that"				  
  								behavior is derived.  highly suggested to look at the function: 			  
  								_stealth_logic::enemy_alert_level_logic( enemy ) to see how 				  
  								these awareness states are reached in the logic code.  Also for 			  
  								examples of the behavior aspect of this code look here:						  
  								example1 = _stealth_behavior::enemy_alert_level_alerted_once( enemy )		  
  								example2 = _stealth_behavior::enemy_alert_level_alerted_again( enemy )		  
  								example3 = _stealth_behavior::enemy_alert_level_attack( enemy )				  
  								example4 = _stealth_behavior::enemy_alert_level_lostem( enemy )				  
  																											  							
  							-corpse_functions is an array 2 with keys 'saw' and 'found' that 				  
  							represent individual and team states of awareness of a corpse					  
  								-these slightly tie into the enemy_alert_level* functions above				  
  								in the behavior code, so probably a good idea to look at these 				  
  								examples:																	  
  								example1 = enemy_saw_corpse_logic();										  
  								example2 = enemy_found_corpse_loop();		
  							
  							you can also set these functions after init is called ( documentation in 
  							_utility and script docs ):
  							
  								maps\_utility::stealth_ai_state_functions_set
	  							maps\_utility::stealth_ai_state_functions_default
	  							maps\_utility::stealth_ai_alert_functions_set
	  							maps\_utility::stealth_ai_alert_functions_default
	  							maps\_utility::stealth_ai_corpse_functions_set
	  							maps\_utility::stealth_ai_corpse_functions_default
	  							maps\_utility::stealth_ai_awareness_functions_set
	  							maps\_utility::stealth_ai_awareness_functions_default	
							
							and here are some usefull functions which change the detection distances
							that enemy ai will see you or your friendlies
							
								maps\_utility::stealth_detect_ranges_set
	  							maps\_utility::stealth_detect_ranges_default
	  							maps\_utility::stealth_friendly_movespeed_scale_set
	  							maps\_utility::stealth_friendly_movespeed_scale_default												  
  							
  							-----------------------------------------------------------------------	
  																											  							
  							lastly...the friendlies have a section of code in behavior which				  
  							is a smart stance handler ( they'll go into crouch or prone or lay 				  
  							still) depending on a couple factors...if you want to turn this off				  
  							just use the ent_flag_clear( "_stealth_stance_handler" ) on the ai	
  							
  							here are some usefull functions that change the distances at which
  							your friendlies use their smart stance logic to switch stances or 
  							lay still
  							
  								maps\_utility::stealth_friendly_stance_handler_distances_set
	  							maps\_utility::stealth_friendly_stance_handler_distances_default				  	
  																											*/
/************************************************************************************************************/
#define STEALTH_ENVIRONMENT_RAIN 	"rain"
#define STEALTH_ENVIRONMENT_FOLIAGE "foliage"
#define STEALTH_ENVIRONMENT_DEFAULT "default"	
	
stealth_init( enviroment )
{
	system_init( enviroment );
	thread system_message_loop();

	// KDrew (01/06/10) add optional arguement for enviroment which uses a specialized function for visibility calculations
	if( isdefined( enviroment ) )
	{
		switch( enviroment )
		{
			case STEALTH_ENVIRONMENT_FOLIAGE:
			{
				level._stealth.enviroment[ level._stealth.enviroment.size ] = STEALTH_ENVIRONMENT_FOLIAGE;
				maps\_foliage_cover::init_foliage_cover();
			}
			break;
		}
	}

	// threads clipbrush logic when placed. Use the indicated targetname to enable logic for that model.	
	array_thread( getentarray( "stealth_clipbrush", "targetname" ), ::system_handle_clipbrush );

	/#level thread debug_stealth();#/	
}

/************************************************************************************************************/
/*							STEALTH LOGIC UTILITIES...good calls for specific tweakage						*/
/************************************************************************************************************/
system_set_detect_ranges( hidden, alert, spotted )
{
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	
	//HIDDEN is self explanatory
	if( isdefined( hidden ) )
	{
		level._stealth.logic.detect_range[ "hidden" ][ "prone" ]	= hidden["prone"];
		level._stealth.logic.detect_range[ "hidden" ][ "crouch" ]	= hidden["crouch"];
		level._stealth.logic.detect_range[ "hidden" ][ "stand" ]	= hidden["stand"];	
	}
	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body
	if( isdefined( alert ) )
	{
		level._stealth.logic.detect_range[ "alert" ][ "prone" ]		= alert["prone"];
		level._stealth.logic.detect_range[ "alert" ][ "crouch" ]	= alert["crouch"];
		level._stealth.logic.detect_range[ "alert" ][ "stand" ]		= alert["stand"];	
	}
	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	if( isdefined( spotted ) )
	{
		level._stealth.logic.detect_range[ "spotted" ][ "prone" ]	= spotted["prone"];
		level._stealth.logic.detect_range[ "spotted" ][ "crouch" ]	= spotted["crouch"];
		level._stealth.logic.detect_range[ "spotted" ][ "stand" ]	= spotted["stand"];	
	}		
}

system_default_detect_ranges()
{
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	= 70;
	hidden[ "crouch" ]	= 600;
	hidden[ "stand" ]	= 1024;
	
	//ALERT levels are when the same AI has sighted the same enemy twice OR found a body	
	alert = [];
	alert[ "prone" ]	= 140;
	alert[ "crouch" ]	= 900;
	alert[ "stand" ]	= 1500;

	//SPOTTED is when they are completely aware and go into NORMAL COD AI mode...however, the
	//distance they can see you is still limited by these numbers because of the assumption that
	//you're wearing a ghillie suit in woodsy areas
	spotted = [];
	spotted[ "prone" ]	= 512;
	spotted[ "crouch" ]	= 5000;
	spotted[ "stand" ]	= 8000;
	
	system_set_detect_ranges( hidden, alert, spotted );
}

friendly_default_movespeed_scale()
{
	hidden = [];
	hidden[ "prone" ]	= 3;
	hidden[ "crouch" ]	= 2;
	hidden[ "stand" ]	= 2;
	
	alert = [];
	alert[ "prone" ]	= 2;
	alert[ "crouch" ]	= 2;
	alert[ "stand" ]	= 2;
	
	spotted = [];
	spotted[ "prone" ]	= 2;
	spotted[ "crouch" ]	= 2;
	spotted[ "stand" ]	= 2;
	
	self friendly_set_movespeed_scale( hidden, alert, spotted );	
}

//PARAMETER CLEANUP
friendly_set_movespeed_scale( hidden, alert, spotted/*, shadow*/ )
{
	if( isdefined( hidden ) )
	{
		self._stealth.logic.movespeed_scale[ "hidden" ][ "prone" ] 		= hidden[ "prone" ];
		self._stealth.logic.movespeed_scale[ "hidden" ][ "crouch" ] 	= hidden[ "crouch" ];
		self._stealth.logic.movespeed_scale[ "hidden" ][ "stand" ] 		= hidden[ "stand" ];
	}
	if( isdefined( alert ) )
	{
		self._stealth.logic.movespeed_scale[ "alert" ][ "prone" ] 		= alert[ "prone" ];
		self._stealth.logic.movespeed_scale[ "alert" ][ "crouch" ] 		= alert[ "crouch" ];
		self._stealth.logic.movespeed_scale[ "alert" ][ "stand" ] 		= alert[ "stand" ];
	}
	if( isdefined( spotted ) )
	{
		self._stealth.logic.movespeed_scale[ "spotted" ][ "prone" ] 	= spotted[ "prone" ];
		self._stealth.logic.movespeed_scale[ "spotted" ][ "crouch" ] 	= spotted[ "crouch" ];
		self._stealth.logic.movespeed_scale[ "spotted" ][ "stand" ] 	= spotted[ "stand" ];
	}	
}

/************************************************************************************************************/
/*								SYSTEM STEALTH DETECTION FOR FRIENDLIES	AND ENEMIES							*/
/************************************************************************************************************/

system_init( enviroment )
{
	//these are for detection levels
	flag_init( "_stealth_hidden" );
	flag_init( "_stealth_alert"	);
	flag_init( "_stealth_spotted" );
	//these are for levels of awareness about a corpse
	flag_init( "_stealth_found_corpse" );
	
	//we start off as hidden - so set the flag
	flag_set( "_stealth_hidden" );
	
	//under stealth we have a logic struct and a behavior struct...the behavior struct is created and
	//handled in the _stealth_behavior system OR in the designers own script
	level._stealth = spawnstruct();
	level._stealth.logic = spawnstruct();

	// environment setup
	if( !IsDefined( enviroment ) )
		enviroment = STEALTH_ENVIRONMENT_DEFAULT;
	
	level._stealth.enviroment = [];
	level._stealth.environment[0] = enviroment;
	
	//friendly and player detection initilization
	level._stealth.logic.detection_level = "hidden";
	level._stealth.logic.detect_range = [];
	level._stealth.logic.detect_range[ "alert" ] = [];
	level._stealth.logic.detect_range[ "hidden" ] = [];
	level._stealth.logic.detect_range[ "spotted" ] = [];
	
	system_default_detect_ranges();
	system_default_corpse_detect_ranges();
	
	//these are event handlers...they're already running in the game normally, but with these numbers we can
	//tweak how well they AI can detect these events...for stealth gameplay we bring the numbers for 
	//footsteps, death of a teammate, etc, etc rediculously lower than normal COD gameplay
	level._stealth.logic.ai_event = [];
	
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "spotted" ] 	= GetDvar( "ai_eventDistDeath" );//1024
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "alert" ] 	= 512;
	level._stealth.logic.ai_event[ "ai_eventDistDeath" ][ "hidden" ] 	= 256;
	
	level._stealth.logic.ai_event[ "ai_eventDistPain" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistPain" ][ "spotted" ] 	= GetDvar( "ai_eventDistPain" );//512
	level._stealth.logic.ai_event[ "ai_eventDistPain" ][ "alert" ] 		= 384;
	level._stealth.logic.ai_event[ "ai_eventDistPain" ][ "hidden" ] 	= 256;
	
	level._stealth.logic.ai_event[ "ai_eventDistExplosion" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistExplosion" ][ "spotted"]	= 4000;//GetDvar( "ai_eventDistExplosion" );
	level._stealth.logic.ai_event[ "ai_eventDistExplosion" ][ "alert" ] 	= 4000;
	level._stealth.logic.ai_event[ "ai_eventDistExplosion" ][ "hidden" ] 	= 4000;
	
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "spotted"]	= GetDvar( "ai_eventDistBullet" );
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "alert" ] 	= 64;
	level._stealth.logic.ai_event[ "ai_eventDistBullet" ][ "hidden" ] 	= 64;
	
	level._stealth.logic.ai_event[ "ai_eventDistFootstep" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistFootstep" ][ "spotted"]		= GetDvar( "ai_eventDistFootstep" );// 512
	level._stealth.logic.ai_event[ "ai_eventDistFootstep" ][ "alert" ] 		= 64;
	level._stealth.logic.ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 	= 64;
	
	level._stealth.logic.ai_event[ "ai_eventDistFootstepLite" ] = [];
	level._stealth.logic.ai_event[ "ai_eventDistFootstepLite" ][ "spotted"]	= GetDvar( "ai_eventDistFootstepLite" );//256
	level._stealth.logic.ai_event[ "ai_eventDistFootstepLite" ][ "alert" ] 	= 32;
	level._stealth.logic.ai_event[ "ai_eventDistFootstepLite" ][ "hidden" ] 	= 32;
	
	level._stealth.logic.system_state_functions = [];
	level._stealth.logic.system_state_functions[ "hidden" ] 	= ::system_state_hidden;
	level._stealth.logic.system_state_functions[ "alert" ] 		= ::system_state_alert;
	level._stealth.logic.system_state_functions[ "spotted" ] 	= ::system_state_spotted;

	// SUMEET -This is used in battle chatter system.
	anim.eventActionMinWait["threat"]["self"] 		= 20000;
	anim.eventActionMinWait["threat"]["squad"] 		= 30000;
	
	system_init_shadows();
}


system_default_corpse_detect_ranges()
{
	//corpse detection initilization
	level._stealth.logic.corpse = spawnstruct();
	level._stealth.logic.corpse.array = [];
	level._stealth.logic.corpse.last_pos = undefined;
	level._stealth.logic.corpse.max_num = int( GetDvar( "ai_corpseCount" ) ); //can actually be set to 0 on PC...need to fix
	
	level._stealth.logic.corpse.sight_dist = 256; //this is how far they can see to see a corpse
	level._stealth.logic.corpse.detect_dist = 128; //this is at what distance they automatically see a corpse
	level._stealth.logic.corpse.found_dist = 64; //this is at what distance they actually find a corpse

	//this is good for optimization
	level._stealth.logic.corpse.sight_distsqrd 	= level._stealth.logic.corpse.sight_dist * level._stealth.logic.corpse.sight_dist;
	level._stealth.logic.corpse.detect_distsqrd = level._stealth.logic.corpse.detect_dist * level._stealth.logic.corpse.detect_dist;
	level._stealth.logic.corpse.found_distsqrd 	= level._stealth.logic.corpse.found_dist * level._stealth.logic.corpse.found_dist;

	//corpse height
	level._stealth.logic.corpse.corpse_height = [];
	level._stealth.logic.corpse.corpse_height[ "spotted" ]	= 10;
	level._stealth.logic.corpse.corpse_height[ "alert" ]	= 10;
	level._stealth.logic.corpse.corpse_height[ "hidden" ]	= 6;
}

system_init_shadows()
{
	array_thread( getentarray( "_stealth_shadow" , "targetname" ), ::stealth_shadow_volumes );
	array_thread( getentarray( "stealth_shadow" , "targetname" ), ::stealth_shadow_volumes );
}

stealth_shadow_volumes()
{
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	self endon( "death" );//it can be deleted
	
	while( 1 )
	{
		self waittill( "trigger", other );
		
		if( !isalive( other ) )
		{
			continue;
		}
		
		if( other ent_flag( "_stealth_in_shadow" ) )
		{
			continue;
		}
		
		other thread stealth_shadow_ai_in_volume( self );
	}
}

system_message_loop()
{
	funcs = level._stealth.logic.system_state_functions;
	//these handle global "what to do" based on current state
	thread system_message_handler( "_stealth_hidden", "hidden", funcs[ "hidden" ] );
	thread system_message_handler( "_stealth_alert", "alert", funcs[ "alert" ] );
	thread system_message_handler( "_stealth_spotted", "spotted", funcs[ "spotted" ] );
}

system_message_handler( _flag, detection_level, function )
{
	level endon( "_stealth_stop_stealth_logic" );
	
	while(1)
	{
		flag_wait( _flag );
		system_event_change( detection_level );
		level._stealth.logic.detection_level = detection_level;
		level notify("_stealth_detection_level_change");
		thread [[ function ]]();
		
		flag_waitopen( _flag );
	}
}

//this function basically sets the ai event distance handlers based on the global awareness of ai...
system_event_change( name )
{
	keys = getarraykeys( level._stealth.logic.ai_event );
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		setsaveddvar( key, level._stealth.logic.ai_event[ key ][ name ] );
	}	
}

//if system specific settings need to be made for this state...they go there
system_state_spotted()
{
	flag_clear( "_stealth_hidden" );
	flag_clear( "_stealth_alert" );
	
	level endon("_stealth_detection_level_change");
	level endon( "_stealth_stop_stealth_logic" );
	
	//we clear alert and possibly set it again in the same frame below...
	//we want to catch the notify
	waittillframeend;
	
	ai = getaispeciesarray( "axis", "all" );
	while( ai.size )
	{
		clear = true;
		ai = getaispeciesarray( "axis", "all" );
		for(i=0; i<ai.size; i++)
		{
			if( isalive( ai[ i ].enemy ) )
			{
				clear = false;
				break;	
			}	
		}
		
		//basically if everyone lost their enemy...then we're back to alert
		if(clear)
		{
			//there might be guys still looking so give them 1 second and check again
			wait 1;
			
			ai = getaispeciesarray( "axis", "all" );
			for(i=0; i<ai.size; i++)
			{
				if( isalive( ai[ i ].enemy ) )
				{
					clear = false;
					break;	
				}	
			}
		}
		//we're past the 2nd test so we should break for real this time.
		if( clear )
		{
			break;
		}
			
		wait .1;
		ai = getaispeciesarray( "axis", "all" );
	}
	//if there are no ai we also get here...now there's no point in checking here if we should
	//set the flag for hidden because as soon as the flat is set for alert, the message loop will catch it 
	//and level notify( "_stealth_detection_level_change" ) which will end this function
	flag_clear( "_stealth_spotted" );
	flag_set( "_stealth_alert" );
}

//if system specific settings need to be made for this state...they go there	
system_state_alert()
{
	flag_clear( "_stealth_hidden" );
//	flag_clear( "_stealth_spotted" );
	
	level endon("_stealth_detection_level_change");
	level endon( "_stealth_stop_stealth_logic" );
	
	//we clear hidden and possibly set it again in the same frame below...
	//we want to catch the notify
	waittillframeend;
	
	//alert will last for 15 seconds and go back to normal
	count = 15;
	const interval = .1;
	
	while( count > 0 )
	{
		ai = getaispeciesarray( "axis", "all" );
		if( !ai.size )
		{
			break;
		}
		
		wait interval;
		count -= interval;
	}
	
	flag_waitopen( "_stealth_found_corpse" );
	//if all ai are dead - then we go back to hidden again
	flag_clear( "_stealth_spotted" );
	flag_clear( "_stealth_alert" );
	flag_set( "_stealth_hidden" );
}

//if system specific settings need to be made for this state...they go there
system_state_hidden()
{
	level endon("_stealth_detection_level_change");
	level endon( "_stealth_stop_stealth_logic" );
}



/************************************************************************************************************/
/*								INDIVIDUAL STEALTH DETECTION FOR FRIENDLIES									*/
/************************************************************************************************************/

friendly_logic()
{
	self endon( "death" );
	self endon( "pain_death" ); 
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	
	self friendly_init();
	
	current_stance_func = self._stealth.logic.current_stance_func;
	
	//for right now - we only do this for player...the system actually looks good doing it for player only,
	//but maybe in the future we'll want to change this...if we do theres a bunch of evaluation stuff 
	//based on stance in the _behavior script that will have to be changed.
	if( isPlayer( self ) )
	{
		self thread friendly_movespeed_calc_loop();
	}
	
	while( 1 )
	{
		//find the current stance
		self [[ current_stance_func ]]();		
		
		//now compute maxVisibleDist based on current awareness level, stance, and movement speed
		self.maxVisibleDist = self friendly_compute_score();
		
		//maxVisibleDist is not under the _stealth struct because it's actually an AI value that
		//code reads - this decides how visible you are to enemies
		
		wait .05;
	}
}

friendly_init()
{
	assert( !isdefined( self._stealth ), "you called maps\_stealth_logic::friendly_init() twice on the same ai or player" );
	
	self._stealth = spawnstruct();
	self._stealth.logic = spawnstruct();
	
	if( isPlayer( self ) )
	{
		self._stealth.logic.getstance_func 		= ::friendly_getstance_player;
		self._stealth.logic.getangles_func 		= ::friendly_getangles_player;
		if( level.Console )
		{
			self._stealth.logic.getvelocity_func	= ::friendly_getvelocity;
		}
		else
		{
			self._stealth.logic.getvelocity_func	= ::player_getvelocity_pc;
			self._stealth.logic.player_pc_velocity 	= 0;
		}
		self._stealth.logic.current_stance_func = ::friendly_compute_stances_player;
	}
	else
	{
		self._stealth.logic.getstance_func 		= ::friendly_getstance_ai;
		self._stealth.logic.getangles_func 		= ::friendly_getangles_ai;
		self._stealth.logic.getvelocity_func	= ::friendly_getvelocity;
		self._stealth.logic.current_stance_func = ::friendly_compute_stances_ai;
	}
	
	self._stealth.logic.stance_change_time 	= .2;
	self._stealth.logic.stance_change	 	= 0;
	self._stealth.logic.oldstance 			= self [[ self._stealth.logic.getstance_func ]]();
	self._stealth.logic.stance 				= self [[ self._stealth.logic.getstance_func ]]();
	
	self._stealth.logic.spotted_list 	= [];
	
	self._stealth.logic.movespeed_multiplier = [];
	self._stealth.logic.movespeed_scale = [];
	
	self._stealth.logic.movespeed_multiplier[ "hidden" ] = [];
	self._stealth.logic.movespeed_multiplier[ "hidden" ][ "prone" ] 	= 0;
	self._stealth.logic.movespeed_multiplier[ "hidden" ][ "crouch" ] 	= 0;
	self._stealth.logic.movespeed_multiplier[ "hidden" ][ "stand" ] 	= 0;
	
	self._stealth.logic.movespeed_multiplier[ "alert" ] = [];
	self._stealth.logic.movespeed_multiplier[ "alert" ][ "prone" ] 		= 0;
	self._stealth.logic.movespeed_multiplier[ "alert" ][ "crouch" ] 	= 0;
	self._stealth.logic.movespeed_multiplier[ "alert" ][ "stand" ] 		= 0;
	
	self._stealth.logic.movespeed_multiplier[ "spotted" ] = [];
	self._stealth.logic.movespeed_multiplier[ "spotted" ][ "prone" ] 	= 0;
	self._stealth.logic.movespeed_multiplier[ "spotted" ][ "crouch" ] 	= 0;
	self._stealth.logic.movespeed_multiplier[ "spotted" ][ "stand" ] 	= 0;
	
	friendly_default_movespeed_scale();
	
	if( self ent_flag_exist( "_stealth_in_shadow" ) )
	   self ent_flag_clear( "_stealth_in_shadow" );
	else
		self ent_flag_init( "_stealth_in_shadow" );
	
	// BJoyal (11/19/09) check to see if foliage is used
	if( self ent_flag_exist( "_stealth_in_foliage" ) )
	   self ent_flag_clear( "_stealth_in_foliage" );
	else
		self ent_flag_init( "_stealth_in_foliage" );
}

friendly_getvelocity()
{
	return length( self getVelocity() );
}

player_getvelocity_pc()
{
	velocity = length( self getVelocity() );
	
	stance = self._stealth.logic.stance;
	
	add = [];
	add[ "stand" ] = 30;
	add[ "crouch" ] = 15;
	add[ "prone" ] = 4;
	
	sub = [];
	sub[ "stand" ] = 40;
	sub[ "crouch" ] = 25;
	sub[ "prone" ] = 10;
	
	if( !velocity )
	{
		self._stealth.logic.player_pc_velocity = 0;
	}
	else if( velocity >	self._stealth.logic.player_pc_velocity )
	{
		self._stealth.logic.player_pc_velocity += add[ stance ];
		if( self._stealth.logic.player_pc_velocity > velocity )
		{
			self._stealth.logic.player_pc_velocity = velocity;
		}
	}
	else if( velocity <	self._stealth.logic.player_pc_velocity )
	{
		self._stealth.logic.player_pc_velocity -= sub[ stance ];
		if( self._stealth.logic.player_pc_velocity < 0 )
		{
			self._stealth.logic.player_pc_velocity = 0;
		}
	}
	
	//println( self._stealth.logic.player_pc_velocity );
	return self._stealth.logic.player_pc_velocity;
}

friendly_movespeed_calc_loop()
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	
	angles_func = self._stealth.logic.getangles_func;
	velocity_func = self._stealth.logic.getvelocity_func;
	oldangles = self [[ angles_func ]]();
	
	while(1)
	{
		score = undefined;
		
		//if he's in shadow - movement has no effect
		if( self ent_flag( "_stealth_in_shadow" ) )
		{
			score = 0;
		}
		else
		{
			score_move = self [[ velocity_func ]]();
			score_turn = length( oldangles - self [[ angles_func ]]() );
			if( score_turn > 30 )
			{
				score_turn = 30;
			}
			
			score = score_move + score_turn;
		}			
			
		//seperated these out instead of keeping inside a forloop if i ever
		//want to get more specific about how each setting is scored...
		self._stealth.logic.movespeed_multiplier[ "hidden" ][ "prone" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "hidden" ][ "prone" ];
		self._stealth.logic.movespeed_multiplier[ "spotted" ][ "prone" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "spotted" ][ "prone" ];
		self._stealth.logic.movespeed_multiplier[ "alert" ][ "prone" ] 		= ( score ) * self._stealth.logic.movespeed_scale[ "alert" ][ "prone" ];
		
		self._stealth.logic.movespeed_multiplier[ "hidden" ][ "crouch" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "hidden" ][ "crouch" ];
		self._stealth.logic.movespeed_multiplier[ "spotted" ][ "crouch" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "spotted" ][ "crouch" ];
		self._stealth.logic.movespeed_multiplier[ "alert" ][ "crouch" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "alert" ][ "crouch" ];
		
		self._stealth.logic.movespeed_multiplier[ "hidden" ][ "stand" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "hidden" ][ "stand" ];
		self._stealth.logic.movespeed_multiplier[ "spotted" ][ "stand" ] 	= ( score ) * self._stealth.logic.movespeed_scale[ "spotted" ][ "stand" ];
		self._stealth.logic.movespeed_multiplier[ "alert" ][ "stand" ] 		= ( score ) * self._stealth.logic.movespeed_scale[ "alert" ][ "stand" ];
		
		oldangles = self [[ angles_func ]]();
		wait .1;
	}
}

friendly_compute_score( stance )
{
	if( !isdefined( stance ) )
	{
		stance = self._stealth.logic.stance;
	}
		
	detection_level = level._stealth.logic.detection_level;
		
	score_range = level._stealth.logic.detect_range[ detection_level ][ stance ];
	if( self ent_flag( "_stealth_in_shadow" ) )
	{
		score_range *= .5;
		if( score_range < level._stealth.logic.detect_range[ "hidden" ][ "prone" ] )
		{
			score_range = level._stealth.logic.detect_range[ "hidden" ][ "prone" ];	
		}
	}

	if( !IsAI( self ) && IsAlive( self ))
	{
		if( self ent_flag( "_stealth_in_foliage" ) ) // && !flag( "_stealth_spotted" ) )	// BJoyal (11/19/09) check to see if foliage is used and that the entity is a player
		{
			score_range = [[ maps\_foliage_cover::calculate_foliage_cover ]]( stance );	// function set in _foliage_cover.gsc (by default)
		}
	}
	
	
	score_move = self._stealth.logic.movespeed_multiplier[ detection_level ][ stance ];
	if ( isdefined( self._stealth_move_detection_cap ) && score_move > self._stealth_move_detection_cap )
	{
		score_move = self._stealth_move_detection_cap;
	}
		
	return ( score_range + score_move );
}

friendly_getstance_ai()
{
	return self.a.pose;
}

friendly_getstance_player()
{
	// Alex Liu: Changed level.player to player 1
	players = get_players();
	return players[0] getstance();
}

friendly_getangles_ai()
{
	return self.angles;	
}

friendly_getangles_player()
{
	return self getplayerangles();
}

friendly_compute_stances_ai()
{
	self._stealth.logic.stance = self [[ self._stealth.logic.getstance_func ]]();
	self._stealth.logic.oldstance = self._stealth.logic.stance;
}

friendly_compute_stances_player()
{
	stance = self [[ self._stealth.logic.getstance_func ]]();
	
	//first - are we going through a stance change?  if so - then forget this part entirely...because
	//this is the logic that tells us whether to go through a stance change or not, and if we calculate
	//it when we're already going through one...then the timer gets reset every frmae and we'll never ever
	//come out of this state
	if( !self._stealth.logic.stance_change )
	{
		//is our current stance the same as our old stance? if not, then figure out if we were moving up
		//of moving down...if moving down
		switch( stance )
		{
			case "prone":
				if( self._stealth.logic.oldstance != "prone" )
				{
					self._stealth.logic.stance_change = self._stealth.logic.stance_change_time;
				}
				break;
			case "crouch":
				if( self._stealth.logic.oldstance == "stand" )
				{
					self._stealth.logic.stance_change = self._stealth.logic.stance_change_time;
				}
				break;
		}
	}
	//ok so this means we're moving down...if so then make our current stance actually our 
	//old stance over .2 seconds until we actually get to the lower stance in the game
	//we do this because the player is still moving at a high speed when he goes
	//into a lower stance - which messes with the movespeed multiplier calculation
	//so we want to delay it a moment to give the player a chance to slow down
	if( self._stealth.logic.stance_change )
	{
		self._stealth.logic.stance = self._stealth.logic.oldstance;
		// fuckin retarded floating point miscaclculation that i need to detect for...this will
		// never hit 0 - it will hit an incredibly small number, then go negative...ghey
		if( self._stealth.logic.stance_change > .05 )
		{
			self._stealth.logic.stance_change -= .05; 
		}
		else 
		{
			self._stealth.logic.stance_change = 0;
			self._stealth.logic.stance = stance;
			self._stealth.logic.oldstance = stance;
		}
	}
	//otherwise lets set our stance to the current stance...and make our old stance also the current stance
	//we can set the old stance at the same time, because we already decided above that either our old stance
	//was the same stance, or that we just finished go through a stance change, and either way - it's safe to set 
	//the old stance
	else
	{
		self._stealth.logic.stance = stance;
		self._stealth.logic.oldstance = stance;
	}
}

/************************************************************************************************************/
/*										INDIVIDUAL STEALTH DETECTION FOR ENEMIES							*/
/************************************************************************************************************/

enemy_logic()
{	
	self enemy_init();
	
	self thread enemy_threat_logic();
	
	// SUMEET_TODO - clean this thing for the next game.
	if( !IsDefined( self.stealth_nocorpselogic ) )
		self thread enemy_corpse_logic();
		
	self thread enemy_corpse_death();	
}

enemy_init()
{
	assert( !isdefined( self._stealth ), "you called maps\_stealth_logic::enemy_init() twice on the same ai" );
	
	self clearenemy();
	self._stealth = spawnstruct();
	self._stealth.logic = spawnstruct();
	
	self._stealth.logic.dog = false;
	if( issubstr( self.classname, "dog" ) )
	{
		self._stealth.logic.dog = true;	
	}
					
	self._stealth.logic.alert_level = spawnstruct();
	self._stealth.logic.alert_level.lvl = undefined;
	self._stealth.logic.alert_level.enemy = undefined;
	
	self._stealth.logic.stoptime = 0;
	
	self._stealth.logic.corpse = spawnstruct();
	self._stealth.logic.corpse.corpse_entity = undefined;
	
	self ent_flag_init( "_stealth_saw_corpse" );
	self ent_flag_init( "_stealth_found_corpse" );
		
	self enemy_event_listeners_init();
	
	self ent_flag_init( "_stealth_in_shadow" );
	self ent_flag_init( "_stealth_in_foliage" );	// BJoyal (11/19/09) check to see if foliage is used
}

// EVENT HANDLING -->
enemy_event_listeners_init()
{
	self ent_flag_init( "_stealth_bad_event_listener" );
	
	self._stealth.logic.event = spawnstruct();
	self._stealth.logic.event.listener = [];
	
	self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "grenade danger";
	self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "gunshot";
	self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "silenced_shot";
	self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "projectile_impact";
	
	if( level._stealth.environment[0] != STEALTH_ENVIRONMENT_RAIN ) // in heavy rain, AI cant listen to bulletwhizby
		self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "bulletwhizby";

	for(i=0; i<self._stealth.logic.event.listener.size; i++)
	{
		self addAIEventListener( self._stealth.logic.event.listener[ i ] );
	}
	
	self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "explode";//ai_eventDistExplosion
	self._stealth.logic.event.listener[ self._stealth.logic.event.listener.size ] = "doFlashBanged";//ai_eventDistExplosion

	for(i=0; i<self._stealth.logic.event.listener.size; i++)
	{
		self thread enemy_event_listeners_logic( self._stealth.logic.event.listener[ i ] );
	}
	
	self thread enemy_event_declare_to_team( "damage", "ai_eventDistPain" );
	self thread enemy_event_declare_to_team( "death", "ai_eventDistDeath" );
	self thread enemy_event_listeners_proc();
	
	self._stealth.logic.event.awareness = [];
	
	//a lot of these overlap with event listeners - because even though the event 
	//listeners above will cause a spotted state - we still want to know
	//why the ai got an enemy and perhaps do specific animations based on that	
	
	self thread enemy_event_awareness( "reset" );			//this is actually notified in this script
	self thread enemy_event_awareness( "alerted_once" );	//this is actually notified in this script
	self thread enemy_event_awareness( "alerted_again" );	//this is actually notified in this script
	self thread enemy_event_awareness( "attack" );			//this is actually notified in this script
	
	self thread enemy_event_awareness( "heard_scream" );	//this is called from behavior
	self thread enemy_event_awareness( "heard_corpse" );	//this is called from behavior
	self thread enemy_event_awareness( "saw_corpse" );		//this is actually notified in this script
	self thread enemy_event_awareness( "found_corpse" );	//this is actually notified in this script
	
	self thread enemy_event_awareness( "explode" );
	self thread enemy_event_awareness( "doFlashBanged" );
	
	if( level._stealth.environment[0] != STEALTH_ENVIRONMENT_RAIN ) // in heavy rain, AI cant listen to bulletwhizby
		self thread enemy_event_awareness( "bulletwhizby" );
	
	self thread enemy_event_awareness( "projectile_impact" );
}

enemy_event_listeners_logic( type )
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
		
	while(1)
	{
		self waittill( type );
		self ent_flag_set( "_stealth_bad_event_listener" );
	}
}

//this function resets all event listeners after they happen...so that we can detect each one multiple times
enemy_event_listeners_proc()
{	
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	
	while(1)
	{
		self ent_flag_wait( "_stealth_bad_event_listener" );
		
		wait .65;
		//this time is set so high because apparently the ai can take up to .5 seconds to 
		//detect you as an enemy after they have received an event listener...
		//EDIT: after testing i've noticed that they still miss the event because they 
		//receive an enemy even after .65 seconds of receiving the event...but it's more
		//fun this way actually...to get away with it once in a while.
		self ent_flag_clear( "_stealth_bad_event_listener" );
	}
}

enemy_event_awareness( type )
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	//just to create the key so it exists so other scripts (mainly behavior )
	//can reference it and see what awareness options it has
	self._stealth.logic.event.awareness[ type ] = true; 
	
	var = undefined;
		
	while( 1 )
	{		
		self waittill( type, var1, var2 );
		
		//i can't remember why this check is here...however it's breaking some dogs, so for dogs at least
		//i dont do the check...maybe this was here before all animations for reactions depended on this system
		//and maybe it was to prevent behaviors from starting when AI already had enemies - but that's all taken 
		//care of in the behavior system...but I dont want to take it out unless i notice NONE dog AI have the same
		//problem (where they recieve an enemy, but dont break out of their idle animation to go attack )
		
		if( !self._stealth.logic.dog )
		{
			if( flag( "_stealth_spotted" ) && ( isdefined( self.enemy ) || isdefined( self.favoriteenemy ) ) )
			{
				continue;
			}
		}
			
		switch( type )
		{
			case "projectile_impact":
				var = var2; // the impact point
				break;	
			default:
				var = var1; // usually an origin or ai
				break;		
		}
		
		self._stealth.logic.event.awareness[ type ] = var;
		self notify( "event_awareness", type );
		level notify( "event_awareness", type );
	
		waittillframeend;//wait a frame to make sure stealth_spotted didn't get set this frame
	
		if( !flag( "_stealth_spotted" ) && type != "alerted_once" )
		{
			flag_set( "_stealth_alert" );
		}
	}
}

enemy_event_declare_to_team( type, name )
{
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
		
	other = undefined;
	team = self.team;
	
	while( 1 )
	{
		if( !isalive( self ) )
		{
			return;
		}

		self waittill( type, var1, var2 );
		
		switch( type )
		{
			case "death":
				other = var1;
				break;
			case "damage":
				other = var2;
				break;				
		}
		
		if( !isdefined( other ) )
		{
			continue;
		}
					
		// Alex Liu: Removed other == level.player check, replacing it with isPlayer()
		if( isPlayer( other ) || ( isdefined( other.team ) && other.team != team ) )
		{
			break;
		}
	}

	if( !isdefined( self ) )
	{
	 	// in case of deletion
		return;		
	}
	
	ai = getaispeciesarray( "axis", "all" );
	
	check = int( level._stealth.logic.ai_event[ name ][ level._stealth.logic.detection_level ] );
	
	for(i=0; i<ai.size; i++)
	{
		if( !isalive( ai[i] ) )
		{
			continue;
		}
		if( !isdefined( ai[i]._stealth ) )
		{
			continue;
		}
		if( distancesquared( ai[i].origin, self.origin ) > check*check )
		{
			continue;
		}
		
		ai[i] ent_flag_set( "_stealth_bad_event_listener" );
	}
}
// <-- EVENT HANDLING


/************************************************************************************************************/
/*										THREAT DETECTION CODE FOR ENEMIES									*/
/************************************************************************************************************/
enemy_threat_logic()
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
			
	while(1)
	{
		self waittill("enemy");
		
		//for now don't do this part for dogs...maybe in the future we'll 
		//add support for alerted dog behavior but most likely not
		//this is also assuming that the dogs are ignoring everyone
		//will probably have to come back to this once we have sleeping dog
		//animations.
		if ( !isalive( self.enemy ) )
			continue;
			
		// is the enemy inside foliage? SUMEET_TODO - make this more modular
		enemy_in_foliage = IsInArray( level._stealth.enviroment, STEALTH_ENVIRONMENT_FOLIAGE ) && IsDefined( self.enemy maps\_foliage_cover::get_current_foliage_trigger() );
		
		if( enemy_in_foliage )
		{
			if( distancesquared( self.origin, self.enemy.origin ) > self.enemy.maxVisibleDist*self.enemy.maxVisibleDist )	
			{
				self clearenemy();
				wait(0.25);
				continue;
			}
		}	
		
		if( !flag( "_stealth_spotted" ) && !self._stealth.logic.dog )
		{
			if( !(self enemy_alert_level_logic( self.enemy ) ) )
			{
				continue;
			}
		}
		else //if we hit this line it means we're not the first ones to find the enemy
		{
			self enemy_alert_level_change( "attack", self.enemy );
		}
		
		self thread enemy_threat_set_spotted();
				
		//wait a minimum of 20 seconds before trying to lose your enemy
		wait 20;
		
		while( isdefined( self.enemy ) )
		{
			if( distancesquared( self.origin, self.enemy.origin ) > self.maxVisibleDist*self.maxVisibleDist )	
			{
				self clearenemy();
			}
			
			wait (0.25);
		}
		
		//if we ever break out - if means everyone actually managed to hide...unbelievable
		enemy_alert_level_change( "reset", undefined );
	}
}

enemy_threat_set_spotted()
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	
	wait randomfloatrange( .25, .5 );
	
	flag_set( "_stealth_spotted" );
}

enemy_alert_level_logic( enemy )
{
	// enemy is not stealthy one bit
	if ( !isdefined( enemy._stealth ) )
	{
		return true;
	}
	
	//add this ai to this spotted list
	if( !isdefined( enemy._stealth.logic.spotted_list[ self.ai_number ] ) )
	{
		enemy._stealth.logic.spotted_list[ self.ai_number ] = 0;
	}
	
	//if we haven't had a chance since out last time to hide...then don't increase our spotted number
	if( !self._stealth.logic.stoptime )
	{
		enemy._stealth.logic.spotted_list[ self.ai_number ]++;
	}
	
	//the first check means that a gun shot or something equally bad happened	
	//the second check is to see if you've been spotted already twice before
	if( self ent_flag( "_stealth_bad_event_listener" ) || enemy._stealth.logic.spotted_list[ self.ai_number ] > 2 )
	{
		self enemy_alert_level_change( "attack", enemy );
		return true; 
	}
	
	//***************				IMPORTANT 			*************************//
	//- since code will constantly give him an enemy - we need to keep clearing it 
	//for stealth gameplay to work...and we need to make sure we do this before we do anything else because 
	//the next line down could return from this function...so this line of code can't really be moved
	self clearenemy();
	
	//ok so if we're not attacking - then we should wait the right amount of time since the 
	//last occurance to make sure the player has time to hide
	if( self._stealth.logic.stoptime )
	{
		return false;		
	}
		
	//this makes the ai look smart by being aware of your presence
	switch( enemy._stealth.logic.spotted_list[ self.ai_number ] )
	{
		case 1:
			self enemy_alert_level_change( "alerted_once", enemy );
			break;
		case 2:	
			self enemy_alert_level_change( "alerted_again", enemy );
			break;
	}
	
	//forget about him after a while
	self thread enemy_alert_level_forget( enemy );
	//give the player a chance to hide with this
	self thread enemy_alert_level_waittime( enemy );	
	return false;
}

enemy_alert_level_forget( enemy )
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	//after 60 seconds - forget about it
	wait 60;	
	
	assert( enemy._stealth.logic.spotted_list[ self.ai_number ], "enemy._stealth.spotted_list[ self.ai_number ] is already 0 but being told to forget" );
	enemy._stealth.logic.spotted_list[ self.ai_number ]--;
}

enemy_alert_level_waittime( enemy )
{
	self endon( "death" );
	
	timefrac = distance( self.origin, enemy.origin ) * .0005;
	self._stealth.logic.stoptime = .25 + timefrac;
	
	//iprintlnbold( self._stealth.stoptime );
	
	//this makes sure that if someone else spots you...then this quits earler
	//then the givin amount of time for the player to try and hide again
	flag_wait_or_timeout("_stealth_spotted", self._stealth.logic.stoptime );
	
	self._stealth.logic.stoptime = 0;
}

enemy_alert_level_change( type, enemy )
{
	level notify("_stealth_enemy_alert_level_change");
	self notify("_stealth_enemy_alert_level_change");
	// this notifies attack on the 3rd one and gives our awareness event an enemy
	self notify( type, enemy ); 
		
	self._stealth.logic.alert_level.lvl = type;
	self._stealth.logic.alert_level.enemy = enemy;
}


/************************************************************************************************************/
/*										CORPSE DETECTION CODE FOR ENEMIES									*/
/************************************************************************************************************/

enemy_corpse_logic()
{
	//dogs can be a corpse - but not find one
	if( self._stealth.logic.dog )
	{
		return;
	}
		
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
			
	self thread enemy_corpse_found_loop();
	while(1)
	{
		while( !flag( "_stealth_spotted" ) )
		{		
			found = false;
			saw = false;
			corpse = undefined;
			
			for(i=0; i<level._stealth.logic.corpse.array.size; i++)
			{
				corpse = level._stealth.logic.corpse.array[ i ];
				distsqrd = distancesquared( self.origin, corpse.origin );
							
				// check if the corpse is inside a foliage trigger, 
				// if yes then use foliage cover corpse detection distances
				// SUMEET_TODO - make this more modular 
				if( IsInArray( level._stealth.enviroment, STEALTH_ENVIRONMENT_FOLIAGE ) && corpse.hidden_in_foliage )
				{
					found_distsqrd	=  level._stealth.logic.corpse.foliage_found_distsqrd;
					sight_distsqrd  =  level._stealth.logic.corpse.foliage_sight_distsqrd;	
					detect_distsqrd =  level._stealth.logic.corpse.foliage_detect_distsqrd;
				}
				else
				{
					found_distsqrd	=  level._stealth.logic.corpse.found_distsqrd;
					sight_distsqrd  =  level._stealth.logic.corpse.sight_distsqrd;
					detect_distsqrd =  level._stealth.logic.corpse.detect_distsqrd;
				}

				//are we so close that we actually found one?
				if( distsqrd < found_distsqrd )
				{	
					found = true;
					break;	
				}
				
				//that's the only check for finding a guy - now lets see if we just see anyone
				//and make sure not to make any duplicates...we don't want to notify seeing the 
				//same corpse multiple times
				
				//have we already seen this guy?
				if( isdefined( self._stealth.logic.corpse.corpse_entity ) )
				{
					if( self._stealth.logic.corpse.corpse_entity == corpse )
					{
						continue;
					}
					
					//ok so it's a new guy - is this one closer than the one we already have?
					distsqrd2 = distancesquared( self.origin, self._stealth.logic.corpse.corpse_entity.origin );
					if( distsqrd2 <= distsqrd )
					{
						continue;
					}
				}			
									
				//are we close enough to check?
				if( distsqrd > sight_distsqrd )
				{
					continue;		
				}
											
				//ok how about close enough to automatically see one?
				if( distsqrd < detect_distsqrd )
				{
					//do we have clear line of sight to the corpse
					if( self cansee( corpse ) )	
					{
						saw = true;
						break;
					}
				}
				
				//if not do we happen to look at him at this distance?
				angles = self gettagangles( "tag_eye" );
				origin = self gettagorigin( "tag_eye" );
				
				sight 			= anglestoforward( angles );
				vec_to_corpse 	= vectornormalize( corpse.origin - origin ); 
				
				//are we looking towards a corpse
				if( vectordot( sight, vec_to_corpse ) > .55 )
				{
					//do we have clear line of sight to the corpse
					if( self cansee( corpse ) )	
					{
						saw = true;
						break;
					}
				}
			}
			if( found )
			{
				if( !ent_flag( "_stealth_found_corpse" ) )
				{
					self ent_flag_set( "_stealth_found_corpse" );
				}
				else
				{
					self notify( "_stealth_found_corpse" );
				}
				
				//if he found it then we can clear his seeing one
				self ent_flag_clear( "_stealth_saw_corpse" );
				
				self thread enemy_corpse_found( corpse );
				
				self notify( "found_corpse", corpse );
			}
			else if( saw )
			{
				self._stealth.logic.corpse.corpse_entity = corpse;
				
				if( !ent_flag( "_stealth_saw_corpse" ) )
				{
					self ent_flag_set( "_stealth_saw_corpse" );
				}
				else
				{
					self notify( "_stealth_saw_corpse" );
				}
				
				level notify( "_stealth_saw_corpse" );
				self notify( "saw_corpse", corpse );
			}
			
			wait .05;
		}		
	
		flag_waitopen( "_stealth_spotted" );
	}
}

//this makes sure every enemy gets turned into a corpse
enemy_corpse_death()
{
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_corpse_logic" );
	
	id = self.ai_number;
	
	self waittill("death");
	
	//this means the ai was deleted - not killed
	if( !isdefined( self.origin ) )
	{
		return;
	}
		
	//corpses have some body mass, so we add inches to compensate for some foilage clip
	height = level._stealth.logic.corpse.corpse_height[ level._stealth.logic.detection_level ];
	offset = ( 0,0, height );
	
	corpse = spawn("script_origin", self.origin + offset );
	
	corpse.targetname = "corpse";
	corpse.ai_number  = id;
	corpse.script_noteworthy = corpse.targetname + "_" + corpse.ai_number;

	// is the corpse inside foliage?
	if( IsInArray( level._stealth.enviroment, STEALTH_ENVIRONMENT_FOLIAGE ) && IsDefined( self maps\_foliage_cover::get_current_foliage_trigger() ) )
	{
		corpse.hidden_in_foliage = true;
	}
	else
	{
		corpse.hidden_in_foliage = false;
	}

	corpse endon("death");
	
	//this wait give the body a chance to fall...	
	while( isdefined( self.origin ) )
	{
		corpse.origin = self.origin + offset;
		wait .01;
	}
	
	if( level.cheatStates[ "sf_use_tire_explosion" ] )
	{
		wait .25;
	}
	
	corpse enemy_corpse_add_to_stack();
}

enemy_corpse_add_to_stack()
{
	if( level._stealth.logic.corpse.array.size == level._stealth.logic.corpse.max_num)
	{
		enemy_corpse_shorten_stack();
	}
	
	level._stealth.logic.corpse.array[ level._stealth.logic.corpse.array.size ] = self;
}

enemy_corpse_shorten_stack()
{
	array1 = [];
	array2 = level._stealth.logic.corpse.array;
	remove = level._stealth.logic.corpse.array[0];
	
	//drop the oldest guy - which would be 0
	for(i=1; i<level._stealth.logic.corpse.max_num; i++)
	{
		array1[ array1.size ] = array2[ i ];
	}

	level._stealth.logic.corpse.array = array1;
	
	remove delete();
}

enemy_corpse_found( corpse )
{			
	level._stealth.logic.corpse.last_pos = corpse.origin;
	ArrayRemoveValue( level._stealth.logic.corpse.array, corpse );


	if ( isdefined( self.no_corpse_announce ) )	
	{
		level notify( "_stealth_no_corpse_announce" );
		self notify( "event_awareness", "found_corpse" );
		return;
	}
		
	//give a chance
	wait randomfloatrange( .25, .5 );
			
	if( !flag( "_stealth_found_corpse" ) )
	{
		flag_set( "_stealth_found_corpse" );
	}
	else
	{
		level notify( "_stealth_found_corpse" );
	}
		
	thread enemy_corpse_clear();
}

enemy_corpse_found_loop()
{
	self endon( "death" );
	self endon( "pain_death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	
	while(1)
	{
		level waittill( "_stealth_found_corpse" );
		
		//make sure the flag's not notifying because it's getting cleared
		if( !flag( "_stealth_found_corpse" ) )
		{
			continue;
		}
		
		self enemy_corpse_alert_level();
	}
}	

enemy_corpse_alert_level()
{
	enemy = undefined;

	if( isdefined( self.enemy ) )
	{
		enemy = self.enemy;
	}
	else
	{	
		// Alex Liu:
		// here the AI can be alerted to the nearest player
		// NOTE: It's possible that the nearest player is better concealed than the others
		enemy = get_closest_player( self.origin );
	}
	
	//we want the ai to detect an enemy without actually causing the behavior to happen
	//so we can't use the regular alert function, because that causes a notify
	
	if( !isdefined( enemy._stealth.logic.spotted_list[ self.ai_number ] ) )
	{
		enemy._stealth.logic.spotted_list[ self.ai_number ] = 0;
	}
	
	//basically take up their alert level each time they see a corpse...but not enough
	//to start attacking the player
	switch( enemy._stealth.logic.spotted_list[ self.ai_number ] )
	{
		case 0:
			enemy._stealth.logic.spotted_list[ self.ai_number ] ++; //this takes it to 1
			self thread enemy_alert_level_forget( enemy );
			break;
		case 1:
			enemy._stealth.logic.spotted_list[ self.ai_number ] ++; //this takes it to 2
			self thread enemy_alert_level_forget( enemy );
			break;
		case 2:
			enemy._stealth.logic.spotted_list[ self.ai_number ] ++; //this takes it to 3
			self thread enemy_alert_level_forget( enemy );
			break;
	} 
	//at this point if the player fucks up - he's gonna have a lot less lenianancy on the ability to hide
	//because finding a corpse takes up everyone's awareness level.
	flag_set( "_stealth_alert" );	
}

enemy_corpse_clear()
{
	level endon( "_stealth_found_corpse" );
	level endon( "_stealth_stop_stealth_logic" );
	
	//the only way this is gonna clear - is if all the ai are dead...
	//you're never gonna forget seeing a dead body :)
	waittill_dead_or_dying( getaiarray( "axis" ), undefined, 90);
	
	flag_clear( "_stealth_found_corpse" );
}


stealth_shadow_ai_in_volume( volume )
{
	self endon( "death" );
	level endon( "_stealth_stop_stealth_logic" );
	self endon( "_stealth_stop_stealth_logic" );
	
	self ent_flag_set( "_stealth_in_shadow" );

	while( self istouching( volume ) )
	{
		wait .05;
	}
	
	self ent_flag_clear( "_stealth_in_shadow" );	
}

/************************************************************************************************************/
/*											CLIP BRUSH LOGIC												*/
/************************************************************************************************************/
//ABalanon (02/03/2011) Ported from IW script _stealth_visibility_system.gsc
//self is a scriptbrushmodel
//removed logic where it supported a stealthgroups for the time being.
system_handle_clipbrush()
{
	self endon( "death" );

	if( IsDefined( self.script_flag_wait ) )
	{
		flag_wait( self.script_flag_wait );
	}

	waittillframeend;

	spotted_flag = "_stealth_spotted";
	corpse_flag = "_stealth_found_corpse";
	event_flag = "_stealth_event";

	self SetCanDamage( true );

	self add_wait( ::waittill_msg, "damage" );
	level add_wait( ::flag_wait, spotted_flag );
	level add_wait( ::flag_wait, corpse_flag );
	level add_wait( ::flag_wait, event_flag );
	do_wait_any();

	if( self.spawnflags & 1 )
	{
		self ConnectPaths();
	}

	self Delete();
}

/************************************************************************************************************/
/*										STEALTH GAMEPLAY UTILITY FUNCTIONS									*/
/************************************************************************************************************/

/@
"Name: stealth_ai( <state_functions>, <alert_functions>, <corpse_functions>, <awareness_functions> )"
"Summary: turns on both stealth logic and behavior for an AI.  PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: An ai"
"OptionalArg: <state_functions>: an array of 3 functions with keys 'hidden', 'alert', and 'spotted' which are function pointers to overwrite default state behavior."
"OptionalArg: <alert_functions>: an array of 4 functions with keys 0-3 which are function pointers to overwrite default alerted to threat behavior."
"OptionalArg: <corpse_functions>: an array of 2 functions with keys 'saw' and 'found' which are function pointers to overwrite default behavior for seeing and finding a corpse."
"OptionalArg: <awareness_functions>: an array of functions which are function pointers to overwrite default behavior for event awareness. Currently only type and supported array key is 'explode' for explosions."
"Example: level.price stealth_ai();"
"SPMP: singleplayer"
@/
stealth_ai( state_functions, alert_functions, corpse_functions, awareness_functions )
{
	// if stealth is already started on this AI, do nothing.
	if( IsDefined( self._stealth ) )
	{
		return;
	}

	assert( isdefined( level._stealth.logic ), "call maps\_stealth_logic::main() before calling stealth_ai()" );
		
	self stealth_ai_logic();
	self stealth_ai_behavior( state_functions, alert_functions, corpse_functions, awareness_functions );
}

/@
"Name: stealth_ai_logic()"
"Summary: turns on only stealth logic for an AI.  If you're trying to run default stealth gameplay - use stealth_ai() instead. PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: An ai"
"Example: level.price stealth_ai_logic();"
"SPMP: singleplayer"
@/
stealth_ai_logic()
{
	assert( isdefined( level._stealth.logic ), "call maps\_stealth_logic::main() before calling stealth_ai_logic()" );
	
	switch( self.team )
	{
		case "allies":
			self thread maps\_stealth_logic::friendly_logic();
			break;
		case "axis":
			self thread maps\_stealth_logic::enemy_logic();
			break;
	}	
}

/@
"Name: stealth_ai_behavior( <state_functions>, <alert_functions>, <corpse_functions>, <awareness_functions> )"
"Summary: turns on only stealth behavior for an AI.  Stealth logic must already be running on the AI.  If you're trying to run default stealth gameplay - use stealth_ai() instead. PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: An ai"
"OptionalArg: <state_functions>: an array of 3 functions with keys 'hidden', 'alert', and 'spotted' which are function pointers to overwrite default state behavior."
"OptionalArg: <alert_functions>: an array of 4 functions with keys 0-3 which are function pointers to overwrite default alerted to threat behavior."
"OptionalArg: <corpse_functions>: an array of 2 functions with keys 'saw' and 'found' which are function pointers to overwrite default behavior for seeing and finding a corpse."
"OptionalArg: <awareness_functions>: an array of functions which are function pointers to overwrite default behavior for event awareness. Currently only type and supported array key is 'explode' for explosions."
"Example: level.price stealth_ai_behavior();"
"SPMP: singleplayer"
@/
stealth_ai_behavior( state_functions, alert_functions, corpse_functions, awareness_functions )
{
	assert( isdefined( level._stealth.behavior ), "call maps\_stealth_behavior::main() before calling stealth_ai_behavior()" );
	
	if( isplayer( self ) )
	{
		return;
	}
	
	switch( self.team )
	{
		case "allies":
			self thread maps\_stealth_behavior::friendly_logic( state_functions );
			break;
		case "axis":
			self thread maps\_stealth_behavior::enemy_logic( state_functions, alert_functions, corpse_functions, awareness_functions );
			break;
	}	
}

/@
"Name: stealth_enemy_waittill_alert()"
"Summary: returns when the enemy ai has been alerted to something in stealth gameplay"
"Module: Stealth"
"CallOn: An ai"
"Example: enemy stealth_enemy_waittill_alert();"
"SPMP: singleplayer"
@/
stealth_enemy_waittill_alert()
{
	if( flag( "_stealth_spotted" ) )
	{
		return;
	}
	level endon ( "_stealth_spotted" );
		
	if( flag( "_stealth_found_corpse" ) )
	{
		return;
	}
	level endon ( "_stealth_found_corpse" );
	
	self endon( "_stealth_enemy_alert_level_change" );	
	
	waittillframeend;//to ensure the ent flag below is init'ed
	
	if( self ent_flag( "_stealth_saw_corpse" ) )
	{
		return;
	}
	self endon ( "_stealth_saw_corpse" );
	
	self waittill( "event_awareness", type );	
}

/@
"Name: stealth_enemy_endon_alert()"
"Summary: notifies self of "stealth_enemy_endon_alert" when the ai has been alerted to something in stealth gameplay...a good function to thread off and catch the notify if we want to endon the notify"
"Module: Stealth"
"CallOn: An ai"
"Example: enemy thread stealth_enemy_endon_alert(); enemy endon( "stealth_enemy_endon_alert" );"
"SPMP: singleplayer"
@/
stealth_enemy_endon_alert()
{
	stealth_enemy_waittill_alert();
	//just in case we're already spotted when this function get's called
	//we want to wait one frame to allow any lines with the endon to be passed
	//so that they don't miss the notify below
	waittillframeend;
	self notify( "stealth_enemy_endon_alert" );
}

/@
"Name: stealth_detect_ranges_set( <hidden>, <alert>, <spotted> )"
"Summary: tweaks with the default detection distances for stealth gameplay.  These are based on stance. PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: "
"OptionalArg: <hidden>: an array of 3 indices with keys 'stand', 'crouch', and 'prone' which reflect the detection distance for each of those stances in the hidden state."
"OptionalArg: <alert>: an array of 3 indices with keys 'stand', 'crouch', and 'prone' which reflect the detection distance for each of those stances in the alert state."
"OptionalArg: <spotted>: an array of 3 indices with keys 'stand', 'crouch', and 'prone' which reflect the detection distance for each of those stances in the spotted state."
"Example: stealth_logic_system_detect_ranges_set( hidden_array );"
"SPMP: singleplayer"
@/
stealth_detect_ranges_set( hidden, alert, spotted )
{
	maps\_stealth_logic::system_set_detect_ranges( hidden, alert, spotted );
}

/@
"Name: stealth_detect_ranges_default()"
"Summary: sets the detection distances for stealth gameplay back to default.  These are based on stance. PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: "
"Example: stealth_detect_ranges_default();"
"SPMP: singleplayer"
@/
stealth_detect_ranges_default()
{
	maps\_stealth_logic::system_default_detect_ranges();
}

/@
"Name: stealth_detect_corpse_range_set()"
"Summary: sets the detection distances for corpse gameplay."
"Module: Stealth"
"CallOn: "
"Example: stealth_detect_corpse_range_set();"
"SPMP: singleplayer"
@/
stealth_detect_corpse_range_set( sight_dist, detect_dist, found_dist )
{
	level._stealth.logic.corpse.sight_dist  = sight_dist; //this is how far they can see to see a corpse
	level._stealth.logic.corpse.detect_dist = detect_dist; //this is at what distance they automatically see a corpse
	level._stealth.logic.corpse.found_dist  = found_dist; //this is at what distance they actually find a corpse
	
	//this is good for optimization
	level._stealth.logic.corpse.sight_distsqrd 	= level._stealth.logic.corpse.sight_dist * level._stealth.logic.corpse.sight_dist;
	level._stealth.logic.corpse.detect_distsqrd = level._stealth.logic.corpse.detect_dist * level._stealth.logic.corpse.detect_dist;
	level._stealth.logic.corpse.found_distsqrd 	= level._stealth.logic.corpse.found_dist * level._stealth.logic.corpse.found_dist;
}

/@
"Name: stealth_detect_corpse_range_default()"
"Summary: sets the detection distances for corpse gameplay to default."
"Module: Stealth"
"CallOn: "
"Example: stealth_detect_corpse_range_default();"
"SPMP: singleplayer"
@/
stealth_detect_corpse_range_default()
{
	maps\_stealth_logic::system_default_corpse_detect_ranges();
}


/@
"Name: stealth_friendly_movespeed_scale_set( <hidden>, <alert>, <spotted> )"
"Summary: sets the scalar for the movespeed score which is calculated into the huristic for stealth detection.  If the scalar is set to 0, then movement has no effect on detection.  These are based on stance and usually defualt to 2. PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"OptionalArg: <hidden>: an array of 3 indices with keys 'stand', 'crouch', and 'prone' which reflect the scalar that movement speed should be multiplied by when being caclulated for the huristic of detection for each of those stances in the hidden state."
"OptionalArg: <alert>: an array of 3 indices with keys 'stand', 'crouch', and 'prone' which reflect the scalar that movement speed should be multiplied by when being caclulated for the huristic of detection for each of those stances in the alert state."
"OptionalArg: <spotted>: an array of 3 indices with keys 'stand', 'crouch', and 'prone' which reflect the scalar that movement speed should be multiplied by when being caclulated for the huristic of detection for each of those stances in the spotted state."
"Example: level.price stealth_friendly_movespeed_scale_set( hidden );"
"SPMP: singleplayer"
@/
stealth_friendly_movespeed_scale_set( hidden, alert, spotted )
{
	self maps\_stealth_logic::friendly_set_movespeed_scale( hidden, alert, spotted );
}

/@
"Name: stealth_friendly_movespeed_scale_default()"
"Summary: sets the scalar for the movespeed score which is calculated into the huristic for stealth detection back to defaults.  If the scalar is set to 0, then movement has no effect on detection.  These are based on stance and usually defualt to 2. PLEASE refer to the top of maps\_stealth_logic.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: level.price stealth_friendly_movespeed_scale_default();"
"SPMP: singleplayer"
@/
stealth_friendly_movespeed_scale_default()
{
	self maps\_stealth_logic::friendly_default_movespeed_scale();
}

/@
"Name: stealth_friendly_stance_handler_distances_set( <hidden>, <alert> )"
"Summary: tweaks the distances for which the smart stance handler for friendlies decides which stance to be in. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"OptionalArg: <hidden>: a 2D array of 3x3 indices. the first bracket element is an array of 3 with keys 'looking_away', 'neutral' and 'looking_towards' which corrispond to which way enemies are facing relative to the friendly. the 2nd bracket element is an array of 3 with keys 'stand', 'crouch' and 'prone' corrisponding to the distances the friendly should use for the smart stance check within the parameters of the first bracket element"
"OptionalArg: <alert>: a 2D array of 3x3 indices. the first bracket element is an array of 3 with keys 'looking_away', 'neutral' and 'looking_towards' which corrispond to which way enemies are facing relative to the friendly. the 2nd bracket element is an array of 3 with keys 'stand', 'crouch' and 'prone' corrisponding to the distances the friendly should use for the smart stance check within the parameters of the first bracket element"
"Example: level.price stealth_friendly_stance_handler_distances_set( hidden );"
"SPMP: singleplayer"
@/
stealth_friendly_stance_handler_distances_set( hidden, alert )
{
	self maps\_stealth_behavior::friendly_set_stance_handler_distances( hidden, alert );
}

/@
"Name: stealth_friendly_stance_handler_distances_default()"
"Summary: sets the distances for which the smart stance handler for friendlies decides which stance to be in to default. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: level.price stealth_friendly_stance_handler_distances_default();"
"SPMP: singleplayer"
@/
stealth_friendly_stance_handler_distances_default()
{
	self maps\_stealth_behavior::friendly_default_stance_handler_distances();
}
/@
"Name: stealth_ai_state_functions_set( <state_functions> )"
"Summary: sets the state change functions for individual ai stealth behavior. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"OptionalArg: <state_functions>: an array of 3 functions with keys 'hidden', 'alert', and 'spotted' which are function pointers to overwrite default state behavior.  If some keys do not exist - those functions will use the default behavior"
"Example: level.price stealth_ai_state_functions_set( state_functions );"
"SPMP: singleplayer"
@/
stealth_ai_state_functions_set( state_functions )
{
	switch( self.team )
	{
		case "allies":
			self maps\_stealth_behavior::ai_change_ai_functions( "state", state_functions );
		case "axis":
			self maps\_stealth_behavior::ai_change_ai_functions( "state", state_functions );
	}
}

/@
"Name: stealth_ai_state_functions_default()"
"Summary: sets the state change functions for individual ai stealth behavior back to default. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: level.price stealth_ai_state_functions_default();"
"SPMP: singleplayer"
@/
stealth_ai_state_functions_default()
{
	switch( self.team )
	{
		case "allies":
			self maps\_stealth_behavior::friendly_default_ai_functions( "state" );
		case "axis":
			self maps\_stealth_behavior::enemy_default_ai_functions( "state" );
	}
}
/@
"Name: stealth_ai_alert_functions_set( <alert_functions> )"
"Summary: sets the threat alert functions for individual ai stealth behavior back. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"OptionalArg: <alert_functions>: an array of 4 functions with keys 0-3 which are function pointers to overwrite default alerted to threat behavior.  If some keys do not exist - those functions will use the default behavior"
"Example: enemy stealth_ai_alert_functions_set( alert_functions );"
"SPMP: singleplayer"
@/
stealth_ai_alert_functions_set( alert_functions )
{
	if( self.team == "allies" )
	{
		assertMsg( "stealth_ai_alert_functions_set should only be called on enemies" );
		return;
	}	
	self maps\_stealth_behavior::ai_change_ai_functions( "alert", alert_functions );
}	
/@
"Name: stealth_ai_alert_functions_default()"
"Summary: sets the threat alert functions for individual ai stealth behavior back to default. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: enemy stealth_ai_alert_functions_default();"
"SPMP: singleplayer"
@/
stealth_ai_alert_functions_default()
{
	if( self.team == "allies" )
	{
		assertMsg( "stealth_ai_alert_functions_default should only be called on enemies" );
		return;
	}	
	
	self maps\_stealth_behavior::enemy_default_ai_functions( "alert" );
}	
/@
"Name: stealth_ai_corpse_functions_set( <corpse_functions> )"
"Summary: sets the corpse awarness functions for individual ai stealth behavior. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"OptionalArg: <corpse_functions>: an array of 2 functions with keys 'saw' and 'found' which are function pointers to overwrite default behavior for seeing and finding a corpse.If some keys do not exist - those functions will use the default behavior"
"Example: enemy stealth_ai_corpse_functions_set( corpse_functions );"
"SPMP: singleplayer"
@/
stealth_ai_corpse_functions_set( corpse_functions )
{
	if( self.team == "allies" )
	{
		assertMsg( "stealth_ai_corpse_functions_set should only be called on enemies" );
		return;
	}	
	self maps\_stealth_behavior::ai_change_ai_functions( "corpse", corpse_functions );
}	
/@
"Name: stealth_ai_corpse_functions_default()"
"Summary: sets the corpse awarness functions for individual ai stealth behavior back to default. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: enemy stealth_ai_corpse_functions_default();"
"SPMP: singleplayer"
@/
stealth_ai_corpse_functions_default()
{
	if( self.team == "allies" )
	{
		assertMsg( "stealth_ai_corpse_functions_default should only be called on enemies" );
		return;
	}	
	self maps\_stealth_behavior::enemy_default_ai_functions( "corpse" );
}

/@
"Name: stealth_ai_awareness_functions_set( <awareness_functions> )"
"Summary: sets the misc event awarness functions for individual ai stealth behavior. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"OptionalArg: <awareness_functions>: an array of functions which are function pointers to overwrite default behavior for event awareness. Currently only type and supported array keys are 'explode' and 'heard_scream' . If some keys do not exist - those functions will use the default behavior"
"Example: enemy stealth_ai_awareness_functions_set( awareness_functions );"
"SPMP: singleplayer"
@/
stealth_ai_awareness_functions_set( awareness_functions )
{
	if( self.team == "allies" )
	{
		assertMsg( "stealth_ai_awareness_functions_set should only be called on enemies" );
		return;
	}	
	self maps\_stealth_behavior::ai_change_ai_functions( "awareness", awareness_functions );
}	
/@
"Name: stealth_ai_awareness_functions_default()"
"Summary: sets the misc event awarness functions for individual ai stealth behavior back to default. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: enemy stealth_ai_awareness_functions_default();"
"SPMP: singleplayer"
@/
stealth_ai_awareness_functions_default()
{
	if( self.team == "allies" )
	{
		assertMsg( "stealth_ai_awareness_functions_default should only be called on enemies" );
		return;
	}	
	self maps\_stealth_behavior::enemy_default_ai_functions( "awareness" );
}	

/@
"Name: stealth_ai_clear_custom_react_and_idle()"
"Summary: stops and clears any custom reaction and idle animation for the ai. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: enemy stealth_ai_clear_custom_react_and_idle();"
"SPMP: singleplayer"
@/
stealth_ai_clear_custom_idle_and_react()
{
	self maps\_stealth_behavior::ai_clear_custom_animation_reaction_and_idle();
}

/@
"Name: stealth_ai_clear_custom_react()"
"Summary: clears any custom reaction animation for the ai. PLEASE refer to the top of maps\_stealth_behacior.gsc for an indepth explanation of the stealth system."
"Module: Stealth"
"CallOn: AI"
"Example: enemy stealth_ai_clear_custom_react();"
"SPMP: singleplayer"
@/
stealth_ai_clear_custom_react()
{
	self maps\_stealth_behavior::ai_clear_custom_animation_reaction();
}
	
/@
"Name: stealth_ai_idle_and_react( <guy>, <idle_anim>, <reaction_anim> )"
"Summary: this starts an AI in an idle animation defined by <idle_anim> and then plays the reaction animation defined by <reaction_anim> when appropriate."
"Module: Stealth"
"CallOn: reference node or ent"
"MandatoryArg: <self>: the node or reference entity or self to play the animation off of" 
"MandatoryArg: <guy> : the actor doing the animation"
"MandatoryArg: <idle_anim> : the idle animation to play (setup so anim_generic can use)"
"MandatoryArg: <reaction_anim> : the reaction animation to play (setup so anim_generic can use)"
"Example: node stealth_ai_idle_and_react( self, "smoke_idle", "smoke_react" );"
"SPMP: singleplayer"
@/	
stealth_ai_idle_and_react( guy, idle_anim, reaction_anim, tag )
{
	if( flag( "_stealth_spotted" ) )
	{
		return;
	}
			
	ender = "stop_loop";
	
	guy.allowdeath = true;
	guy stealth_insure_enabled();
	self thread maps\_anim::anim_generic_loop( guy, idle_anim, ender );
	guy maps\_stealth_behavior::ai_set_custom_animation_reaction( self, reaction_anim, tag, ender );
}

/@
"Name: stealth_ai_reach_idle_and_react( <guy>, <reach_anim>, <idle_anim>, <reaction_anim> )"
"Summary: this has the ai reach his position and then start in an idle animation defined by <idle_anim> and then plays the reaction animation defined by <reaction_anim> when appropriate."
"Module: Stealth"
"CallOn: reference node or ent"
"MandatoryArg: <self>: the node or reference entity or self to play the animation off of" 
"MandatoryArg: <guy> : the actor doing the animation"
"MandatoryArg: <reach_anim> : the reach animation to play..often times just a copy of the idle anim not setup in a 2d array (setup so anim_generic can use)"
"MandatoryArg: <idle_anim> : the idle animation to play (setup so anim_generic can use)"
"MandatoryArg: <reaction_anim> : the reaction animation to play (setup so anim_generic can use)"
"Example: node stealth_ai_reach_idle_and_react( self, "smoke_idle_reach", "smoke_idle", "smoke_react" );"
"SPMP: singleplayer"
@/	
stealth_ai_reach_idle_and_react( guy, reach_anim, idle_anim, reaction_anim )
{
	guy stealth_insure_enabled();
	self thread stealth_ai_reach_idle_and_react_proc( guy, reach_anim, idle_anim, reaction_anim );	
}

stealth_ai_reach_idle_and_react_proc( guy, reach_anim, idle_anim, reaction_anim )
{
	guy thread stealth_enemy_endon_alert();	
	guy endon( "stealth_enemy_endon_alert" );
	guy endon( "death" );
	
	guy stealth_insure_enabled();
	self maps\_anim::anim_generic_reach( guy, reach_anim );
	stealth_ai_idle_and_react( guy, idle_anim, reaction_anim );
}

/@
"Name: stealth_ai_reach_and_arrive_idle_and_react( <guy>, <reach_anim>, <idle_anim>, <reaction_anim> )"
"Summary: this has the ai reach his position with an arrival and then start in an idle animation defined by <idle_anim> and then plays the reaction animation defined by <reaction_anim> when appropriate."
"Module: Stealth"
"CallOn: reference node or ent"
"MandatoryArg: <self>: the node or reference entity or self to play the animation off of" 
"MandatoryArg: <guy> : the actor doing the animation"
"MandatoryArg: <idle_anim> : the reach animation to play..often times just a copy of the idle anim not setup in a 2d array (setup so anim_generic can use)"
"MandatoryArg: <idle_anim> : the idle animation to play (setup so anim_generic can use)"
"MandatoryArg: <reaction_anim> : the reaction animation to play (setup so anim_generic can use)"
"Example: node stealth_ai_reach_and_arrive_idle_and_react( self, "smoke_idle_reach", "smoke_idle", "smoke_react" );"
"SPMP: singleplayer"
@/	
stealth_ai_reach_and_arrive_idle_and_react( guy, reach_anim, idle_anim, reaction_anim )
{
	guy stealth_insure_enabled();
	self thread stealth_ai_reach_and_arrive_idle_and_react_proc( guy, reach_anim, idle_anim, reaction_anim );
}

stealth_ai_reach_and_arrive_idle_and_react_proc( guy, reach_anim, idle_anim, reaction_anim )
{
	guy thread stealth_enemy_endon_alert();	
	guy endon( "stealth_enemy_endon_alert" );
	guy endon( "death" );
	
	guy stealth_insure_enabled();
	self maps\_anim::anim_generic_reach_aligned( guy, reach_anim );
	stealth_ai_idle_and_react( guy, idle_anim, reaction_anim );
}	


stealth_insure_enabled()
{
	if ( isdefined( self._stealth ) )
	{
		return;
	}
	self thread stealth_ai();
}

/************************************************************************************************************/
/*										DEBUG DISPLAY 														*/
/************************************************************************************************************/

/#

debug_stealth()
{
	wait_for_all_players();

	// only debug on the first player for right now.
	level.player = getplayers()[0];

	// create level debug huds
	create_debug_hud_elemets();
	
	// stealth debugging on level.
	level thread debug_level_stealth();

	// individuial stealth debugging on ai. SUMEET_TODO - Extend this functionality for friendly AI.
	level thread debug_ai_stealth();
}

// draws current stealth status of the level
debug_level_stealth() //self = level
{
	level endon( "_stealth_stop_stealth_logic" );

	Assert( IsDefined( level.stealth_hud_hidden ) );
	
	while(1)
	{

		// only display if the debug dvar is on
		if( !GetDvarint( "scr_debugStealth") )
		{
			destroy_debug_hud_elemets();
			wait(0.5);
			continue; 
		}

		create_debug_hud_elemets();
	
		// Current stealth state of the level.
		level.stealth_hud_hidden SetText("Hidden - ");
		level.stealth_hud_hidden_value SetValue( flag( "_stealth_hidden" ) );
			
		level.stealth_hud_alert SetText("Alert - ");
		level.stealth_hud_alert_value SetValue( flag( "_stealth_alert" ) );

		level.stealth_hud_spotted SetText("Spotted - ");
		level.stealth_hud_spotted_value SetValue(  flag( "_stealth_spotted" ) );

		level.stealth_hud_corpse SetText("Found Corpse - ");
		level.stealth_hud_corpse_value SetValue( flag( "_stealth_found_corpse" ) );

//		level.stealth_foliage_hud SetText("Foliage - ");
//		player = get_players()[0];
//		if( IsAlive( player ) && player flag_exists( "_stealth_in_foliage"  ) )
//		{
//			level.stealth_foliage_hud_value SetValue( get_players()[0] ent_flag( "_stealth_in_foliage" ) );
//		}
		
		// show self.maxVisibleDist on hud and draw a circle too, just for one/first player
		if( IsDefined( level.player.maxVisibleDist ) )
		{
			//level.stealth_visibility_hud SetText( "Visible range - ");
			level.stealth_visibility_hud_value SetValue( level.player.maxVisibleDist );

			// draws a circle with max visible distance
			circle( level.player.origin, level.player.maxVisibleDist, ( 0, 1, 0 ), false, true, 1 );
			RecordCircle( level.player.origin, level.player.maxVisibleDist, ( 0, 1, 0 ), "Script", level.player );
		}

		wait(0.05);
	}	
}

debug_ai_stealth()
{
	 // debugging for all the AI's spawning afterwords
	 array_thread( GetSpawnerTeamArray("axis"), ::add_spawn_function, ::debug_ai_stealth_draw_stealth_info );
	 
	 // debugging for existing AI
	 array_thread( GetAIArray("axis"), ::debug_ai_stealth_draw_stealth_info );
}


// This function does not use any hud elemes.
debug_ai_stealth_draw_stealth_info() // self = AI
{
	self endon( "death" );

	while(1)
	{
		// only display if the debug dvar is on
		if( !GetDvarint( "scr_debugStealth") )
		{
			wait(0.5);
			continue; 
		}
	
		// only show this information if the AI is setup to do stealth and its not a player
		if ( !IsDefined( self._stealth ) || IsPlayer( self ) )
		{
			wait(0.5);
			continue;
		}
		
		// draws the current alertness level and the last enemy of this AI
		if( IsDefined( self._stealth.logic.alert_level.lvl ) && IsDefined( self._stealth.logic.alert_level.enemy ) )
		{
			enemy = self._stealth.logic.alert_level.enemy GetEntityNumber();
		
			print3d_on_ent( "alert level - " + self._stealth.logic.alert_level.lvl +
							" current enemy - " +  enemy, 70
						  );
		}

				// saw a corpse and found a corpse flag
		if( self flag_exists( "_stealth_saw_corpse" ) )
		{
			print3d_on_ent(   "Saw a Corpse - " 		+ ent_flag( "_stealth_saw_corpse" )
							+ " Found a Corpse - " 	    + ent_flag( "_stealth_found_corpse" ), 85  
						  );	
		}		

		// print the level flags on the AI, so that we can see them onto recorder, makes it easier to debug
		print3d_on_ent(   "Hidden - " 			+ flag( "_stealth_hidden" )
						+ " Alert - " 			+ flag( "_stealth_alert" )  
						+ " Spotted - " 		+ flag( "_stealth_spotted" )
						+ " Found Corpse - " 	+ flag( "_stealth_found_corpse" )
						+ " GoalRadius - " 		+ self.goalradius, 100
					  );

		// draw line to goal position 
		if( IsDefined( self.goalpos ) )
		{
			recordLine( self.origin, self.goalpos, (1,1,1), "Script", self );
		}

		wait(0.05);
	}
}


create_debug_hud_elemets()
{
	if( !IsDefined( level.stealth_hud_hidden ) )
	{
		// hidden text
		level.stealth_hud_hidden =  NewDebugHudElem();
		level.stealth_hud_hidden.location = 0;
		level.stealth_hud_hidden.alignX = "left";
		level.stealth_hud_hidden.fontScale = 1.3;
		level.stealth_hud_hidden.x = -75;
		level.stealth_hud_hidden.y = 40;
		level.stealth_hud_hidden.color = (1,1,1);
	
		// hidden value
		level.stealth_hud_hidden_value =  NewDebugHudElem();
		level.stealth_hud_hidden_value.location = 0;
		level.stealth_hud_hidden_value.alignX = "left";
		level.stealth_hud_hidden_value.fontScale = 1.3;
		level.stealth_hud_hidden_value.x = -10;
		level.stealth_hud_hidden_value.y = 40;
		level.stealth_hud_hidden_value.color = (1,1,1);
	
		// alert text
		level.stealth_hud_alert =  NewDebugHudElem();
		level.stealth_hud_alert.location = 0;
		level.stealth_hud_alert.alignX = "left";
		level.stealth_hud_alert.fontScale = 1.3;
		level.stealth_hud_alert.x = -75;
		level.stealth_hud_alert.y = 55;
		level.stealth_hud_alert.color = (1,1,1);
	
		// alert value
		level.stealth_hud_alert_value =  NewDebugHudElem();
		level.stealth_hud_alert_value.location = 0;
		level.stealth_hud_alert_value.alignX = "left";
		level.stealth_hud_alert_value.fontScale = 1.3;
		level.stealth_hud_alert_value.x = -10;
		level.stealth_hud_alert_value.y = 55;
		level.stealth_hud_alert_value.color = (1,1,1);
	
		// spotted text
		level.stealth_hud_spotted =  NewDebugHudElem();
		level.stealth_hud_spotted.location = 0;
		level.stealth_hud_spotted.alignX = "left";
		level.stealth_hud_spotted.fontScale = 1.3;
		level.stealth_hud_spotted.x = -75;
		level.stealth_hud_spotted.y = 70;
		level.stealth_hud_spotted.color = (1,1,1);
	
		// spotted value
		level.stealth_hud_spotted_value =  NewDebugHudElem();
		level.stealth_hud_spotted_value.location = 0;
		level.stealth_hud_spotted_value.alignX = "left";
		level.stealth_hud_spotted_value.fontScale = 1.3;
		level.stealth_hud_spotted_value.x = -10;
		level.stealth_hud_spotted_value.y = 70;
		level.stealth_hud_spotted_value.color = (1,1,1);
	
		// corpse text
		level.stealth_hud_corpse =  NewDebugHudElem();
		level.stealth_hud_corpse.location = 0;
		level.stealth_hud_corpse.alignX = "left";
		level.stealth_hud_corpse.fontScale = 1.3;
		level.stealth_hud_corpse.x = -75;
		level.stealth_hud_corpse.y = 85;
		level.stealth_hud_corpse.color = (1,1,1);
	
		// corpse value
		level.stealth_hud_corpse_value =  NewDebugHudElem();
		level.stealth_hud_corpse_value.location = 0;
		level.stealth_hud_corpse_value.alignX = "left";
		level.stealth_hud_corpse_value.fontScale = 1.3;
		level.stealth_hud_corpse_value.x = 10;
		level.stealth_hud_corpse_value.y = 85;
		level.stealth_hud_corpse_value.color = (1,1,1);
	
		// player visibility text
		level.stealth_visibility_hud =  NewDebugHudElem();
		level.stealth_visibility_hud.location = 0;
		level.stealth_visibility_hud.alignX = "left";
		level.stealth_visibility_hud.fontScale = 1.3;
		level.stealth_visibility_hud.x = -75;
		level.stealth_visibility_hud.y = 100;
		level.stealth_visibility_hud.color = (1,1,1);
	
		// player visibility value
		level.stealth_visibility_hud_value =  NewDebugHudElem();
		level.stealth_visibility_hud_value.location = 0;
		level.stealth_visibility_hud_value.alignX = "left";
		level.stealth_visibility_hud_value.fontScale = 1.3;
		level.stealth_visibility_hud_value.x = 0;
		level.stealth_visibility_hud_value.y = 100;
		level.stealth_visibility_hud_value.color = (1,1,1);

		// foliage text
		level.stealth_foliage_hud =  NewDebugHudElem();
		level.stealth_foliage_hud.location = 0;
		level.stealth_foliage_hud.alignX = "left";
		level.stealth_foliage_hud.fontScale = 1.3;
		level.stealth_foliage_hud.x = -75;
		level.stealth_foliage_hud.y = 115;
		level.stealth_foliage_hud.color = (1,1,1);

		// foliage value
		level.stealth_foliage_hud_value =  NewDebugHudElem();
		level.stealth_foliage_hud_value.location = 0;
		level.stealth_foliage_hud_value.alignX = "left";
		level.stealth_foliage_hud_value.fontScale = 1.3;
		level.stealth_foliage_hud_value.x = -10;
		level.stealth_foliage_hud_value.y = 115;
		level.stealth_foliage_hud_value.color = (1,1,1);
	}
}


destroy_debug_hud_elemets()
{
	if( IsDefined( level.stealth_hud_hidden ) )
	{
		level.stealth_hud_hidden Destroy();
		level.stealth_hud_hidden_value Destroy();
		
		level.stealth_hud_alert Destroy();
		level.stealth_hud_alert_value Destroy();
	
		level.stealth_hud_spotted Destroy();
		level.stealth_hud_spotted_value Destroy();
	
		level.stealth_hud_corpse Destroy();
		level.stealth_hud_corpse_value Destroy();

		//level.stealth_visibility_hud Destroy();
		level.stealth_visibility_hud_value Destroy();

//		level.stealth_foliage_hud Destroy();
//		level.stealth_foliage_hud_value Destroy();
	}
}

print3d_on_ent( msg, offset ) 
{ 
	// recording also prints in real time.
	//Print3d( self.origin + ( 0, 0, offset ), msg );
	Record3DText( msg, self.origin + ( 0, 0, offset ), ( 1, 1, 1 ), "Script" );		
}


#/