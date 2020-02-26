#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

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

main( state_functions )
{
	system_init( state_functions );
	thread system_message_loop();	
}

/************************************************************************************************************/
/*						STEALTH BEHAVIOR UTILITIES...good calls for specific tweakage						*/
/************************************************************************************************************/
friendly_default_stance_handler_distances()
{
	//i do this because the player doesn't look as bad sneaking up on the enemies
	//friendlies however don't look as good getting so close
	hidden = [];
	hidden[ "looking_away" ][ "stand" ] 	= 500;
	hidden[ "looking_away" ][ "crouch" ] 	= -400;
	hidden[ "looking_away" ][ "prone" ] 	= 0;
	
	hidden["neutral"][ "stand" ] 			= 500;
	hidden["neutral"][ "crouch" ] 			= 200;
	hidden["neutral"][ "prone" ] 			= 50;
	
	hidden["looking_towards"][ "stand" ] 	= 800;
	hidden["looking_towards"][ "crouch" ] 	= 400;
	hidden["looking_towards"][ "prone" ] 	= 100;
	
	
	alert = [];
	alert[ "looking_away" ][ "stand" ] 		= 800;
	alert[ "looking_away" ][ "crouch" ] 	= 200;
	alert[ "looking_away" ][ "prone" ] 		= 50;
	
	alert["neutral"][ "stand" ] 			= 800;
	alert["neutral"][ "crouch" ] 			= 500;
	alert["neutral"][ "prone" ] 			= 100;
	
	alert["looking_towards"][ "stand" ] 	= 1100;
	alert["looking_towards"][ "crouch" ] 	= 700;
	alert["looking_towards"][ "prone" ] 	= 250;
	
	friendly_set_stance_handler_distances( hidden, alert );
}

friendly_set_stance_handler_distances( hidden, alert )
{
	if( isdefined( hidden ) )
	{
		self._stealth.behavior.stance_handler[ "hidden" ][ "looking_away" ][ "stand" ] 		= hidden[ "looking_away" ][ "stand" ];
		self._stealth.behavior.stance_handler[ "hidden" ][ "looking_away" ][ "crouch" ] 	= hidden[ "looking_away" ][ "crouch" ];
		self._stealth.behavior.stance_handler[ "hidden" ][ "looking_away" ][ "prone" ] 		= hidden[ "looking_away" ][ "prone" ];
		
		self._stealth.behavior.stance_handler[ "hidden" ]["neutral"][ "stand" ] 			= hidden[ "neutral" ][ "stand" ];
		self._stealth.behavior.stance_handler[ "hidden" ]["neutral"][ "crouch" ] 			= hidden[ "neutral" ][ "crouch" ];
		self._stealth.behavior.stance_handler[ "hidden" ]["neutral"][ "prone" ] 			= hidden[ "neutral" ][ "prone" ];
		
		self._stealth.behavior.stance_handler[ "hidden" ]["looking_towards"][ "stand" ] 	= hidden[ "looking_towards" ][ "stand" ];
		self._stealth.behavior.stance_handler[ "hidden" ]["looking_towards"][ "crouch" ] 	= hidden[ "looking_towards" ][ "crouch" ];
		self._stealth.behavior.stance_handler[ "hidden" ]["looking_towards"][ "prone" ] 	= hidden[ "looking_towards" ][ "prone" ];
	}
	if( isdefined( alert ) )
	{
		self._stealth.behavior.stance_handler[ "alert" ][ "looking_away" ][ "stand" ] 		= alert[ "looking_away" ][ "stand" ];
		self._stealth.behavior.stance_handler[ "alert" ][ "looking_away" ][ "crouch" ] 		= alert[ "looking_away" ][ "crouch" ];
		self._stealth.behavior.stance_handler[ "alert" ][ "looking_away" ][ "prone" ] 		= alert[ "looking_away" ][ "prone" ];
		
		self._stealth.behavior.stance_handler[ "alert" ]["neutral"][ "stand" ] 				= alert[ "neutral" ][ "stand" ];
		self._stealth.behavior.stance_handler[ "alert" ]["neutral"][ "crouch" ] 			= alert[ "neutral" ][ "crouch" ];
		self._stealth.behavior.stance_handler[ "alert" ]["neutral"][ "prone" ] 				= alert[ "neutral" ][ "prone" ];
		
		self._stealth.behavior.stance_handler[ "alert" ]["looking_towards"][ "stand" ] 		= alert[ "looking_towards" ][ "stand" ];
		self._stealth.behavior.stance_handler[ "alert" ]["looking_towards"][ "crouch" ] 	= alert[ "looking_towards" ][ "crouch" ];
		self._stealth.behavior.stance_handler[ "alert" ]["looking_towards"][ "prone" ] 		= alert[ "looking_towards" ][ "prone" ];
	}	
}

enemy_try_180_turn( pos )
{
	vec1 = anglestoforward( self.angles );
	vec2 = vectornormalize( pos - self.origin );
	//if the goal is behind him - do a 180 anim
	if( vectordot( vec1, vec2 ) < -.8 )
	{
		//is there an obstacle in his way
		start = self.origin + (0,0,16);
		end = pos + (0,0,16);
		
		spot = physicstrace(start, end);
		if( spot == end )			
			self anim_generic( self, "patrol_turn180" );
	}
}

enemy_go_back( spot )
{	
	if( ! self MayMoveToPoint( spot ) )
	{
		nodes = enemy_get_closest_pathnodes( 128, spot );
		nodes = get_array_of_closest( spot, nodes );
		spot = nodes[0].origin;
	}
	
	self setgoalpos( spot );
}

ai_create_behavior_function( name, key, function, array )
{
	self._stealth.behavior.ai_functions[ name ][ key ] = function;
}

ai_change_ai_functions( name, functions )
{
	if( !isdefined( functions ) )
		return;
		
	keys = getarraykeys( functions );
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		self ai_change_behavior_function( name, key, functions[ key ] );
	}
}

ai_change_behavior_function( name, key, function, array )
{
	/#
	if ( !isdefined( self._stealth.behavior.ai_functions[ name ][ key ] ) )
	{
		// draw whatever you like
		msg = "";
		if ( isdefined( array ) )
		{
			keys = getarraykeys( array );
			for(i=0; i<keys.sise; i++)
			{
				msg += keys[ i ];
				msg += ", ";	
			}
			assertmsg( "array index with key: " + key + " is not valid. valid array keys are: " + msg );	
		}
		else
		{
			assertmsg( "Failed to add stealth function " + key );
		}
		return;
	}
	#/

	self ai_create_behavior_function( name, key, function, array );
}

ai_clear_custom_animation_reaction()
{
	self._stealth.behavior.event.custom_animation = undefined;	
}

ai_clear_custom_animation_reaction_and_idle()
{
	self._stealth.behavior.event.custom_animation.node notify( "stop_loop" );
	self stopanimscripted();
	self ai_clear_custom_animation_reaction();
}

ai_set_custom_animation_reaction( node, anime, tag, ender )
{
	self._stealth.behavior.event.custom_animation = spawnstruct();
	
	self._stealth.behavior.event.custom_animation.node = node;
	self._stealth.behavior.event.custom_animation.anime = anime;
	self._stealth.behavior.event.custom_animation.tag = tag;
	self._stealth.behavior.event.custom_animation.ender = ender;
}

/************************************************************************************************************/
/*								GLOBAL STEALTH BEHAVIOR FOR FRIENDLIES AND ENEMIES							*/
/************************************************************************************************************/

system_init( state_functions )
{
	assertEX( isdefined( level._stealth ), "There is no level._stealth struct.  You ran stealth behavior before running the detection logic.  Run _stealth_logic::main() in your level load first" );
	
	//this is our behavior struct inside of _stealth...everything we do will go in here.
	level._stealth.behavior = spawnstruct();
	
	//bools to see if a sound has just been played
	level._stealth.behavior.sound = [];
	level._stealth.behavior.sound[ "huh" ] 		= false;
	level._stealth.behavior.sound[ "hmph" ] 	= false;
	level._stealth.behavior.sound[ "wtf" ] 		= false;
	level._stealth.behavior.sound[ "spotted" ] 	= false;
	level._stealth.behavior.sound[ "corpse" ] 	= false;
	level._stealth.behavior.sound[ "alert" ] 	= false;	
	
	level._stealth.behavior.corpse = spawnstruct();
	level._stealth.behavior.corpse.last_pos = (0,0,-100000);
	level._stealth.behavior.corpse.search_radius = 256;
	level._stealth.behavior.corpse.node_array = undefined;
	
	level._stealth.behavior.system_state_functions = [];
	system_init_state_functions( state_functions );
	
	maps\_stealth_anims::main();
	
	flag_init( "finding_explostion_spot" );
}

system_init_state_functions( state_functions )
{
	custom_state_functions = false;
	if( isdefined( state_functions ) )
	{
		if( isdefined( state_functions[ "hidden" ] ) && 
			isdefined( state_functions[ "alert" ] ) &&
			isdefined( state_functions[ "spotted" ] ) )
		{
			custom_state_functions = true;
		}
		else
		{
			assertmsg( "you sent _stealth_behavior::main( <option_state_function_array> ) a variable but it was invalid.  The variable needs to be an array of 3 indicies with values 'hidden', 'alert' and 'spotted'.  These indicies must be function pointers to the system functions you wish to handle those 3 states." );
		}
	}
	if( !custom_state_functions )
	{	
		system_set_state_function( "hidden", ::system_state_hidden );
		system_set_state_function( "alert", ::system_state_alert );
		system_set_state_function( "spotted", ::system_state_spotted );
	}
	else
	{
		system_set_state_function( "hidden", state_functions[ "hidden" ] );
		system_set_state_function( "alert", state_functions[ "alert" ] );
		system_set_state_function( "spotted", state_functions[ "spotted" ] );
	}
}

system_message_loop()
{
	funcs = level._stealth.behavior.system_state_functions;
	//these handle global "what to do" based on current state
	thread system_message_handler( "_stealth_hidden", 	funcs[ "hidden" ] );
	thread system_message_handler( "_stealth_alert", 	funcs[ "alert" ] );
	thread system_message_handler( "_stealth_spotted", 	funcs[ "spotted" ] );
}

system_message_handler( _flag, function )
{
	while(1)
	{
		flag_wait( _flag );
		thread [[ function ]]();
		
		flag_waitopen( _flag );
	}
}

system_state_spotted()
{
	battlechatter_on( "axis" );
}

system_state_alert()
{
	level._stealth.behavior.sound[ "spotted" ] = false;
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );	
}

system_state_hidden()
{
	level._stealth.behavior.sound[ "spotted" ] = false;
	battlechatter_off( "axis" );
	battlechatter_off( "allies" );	
}

system_set_state_function( detection_state, function )
{
	if( !(detection_state == "hidden" ||  detection_state == "alert" ||  detection_state == "spotted" ) )
		assertmsg( "you sent _stealth_behavior::system_set_state_function( <detection_state>, <function> ) a bad detection state. Only valid states are 'hidden', 'alert', and 'spotted'" );
	
	level._stealth.behavior.system_state_functions[ detection_state ] = function;
}

/************************************************************************************************************/
/*									INDIVIDUAL STEALTH BEHAVIOR FOR ENEMIES									*/
/************************************************************************************************************/

enemy_logic( state_functions, alert_functions, corpse_functions, awareness_functions )
{	
	self enemy_init( state_functions, alert_functions, corpse_functions, awareness_functions );
	self thread enemy_Message_Loop(); // state functions effect this
	self thread enemy_Threat_Loop(); // alert functinos effect this
	self thread enemy_Awareness_Loop();
	self thread enemy_Animation_Loop();
	self thread enemy_Corpse_Loop(); //corpse functions effect this
}


enemy_init( state_functions, alert_functions, corpse_functions, awareness_functions )
{
	assertEX( isdefined( self._stealth ), "There is no self._stealth struct.  You ran stealth behavior before running the detection logic.  Run _stealth_logic::enemy_init() on this AI first" );
	
	//this is our behavior struct inside of _stealth...everything we do will go in here.
	self._stealth.behavior = spawnstruct();	
		
	self._stealth.behavior.sndnum 	= randomintrange(1,4);//this gives our ai a unique persistant voice actor
	
	//AI FUNCTIONS
	self._stealth.behavior.ai_functions = [];
	self._stealth.behavior.ai_functions[ "state" ] = [];
	self._stealth.behavior.ai_functions[ "alert" ] = [];
	self._stealth.behavior.ai_functions[ "corpse" ] = [];
	self._stealth.behavior.ai_functions[ "awareness" ] = [];
	
	self enemy_default_ai_functions( "state" );
	self enemy_default_ai_functions( "alert" );
	self enemy_default_ai_functions( "corpse" );
	self enemy_default_ai_functions( "awareness" );
	self enemy_default_ai_functions( "animation" );
		
	self ai_change_ai_functions( "state", state_functions );
	self ai_change_ai_functions( "alert", alert_functions );
	self ai_change_ai_functions( "corpse", corpse_functions );
	self ai_change_ai_functions( "awareness", awareness_functions );
				
	self ent_flag_init( "_stealth_enemy_alert_level_action" );
	self ent_flag_init( "_stealth_running_to_corpse" );
	self ent_flag_init( "_stealth_behavior_reaction_anim" );
	self ent_flag_init( "_stealth_behavior_first_reaction" );
	
	self._stealth.behavior.event = spawnstruct();
	
	if( self._stealth.logic.dog )
		self enemy_dog_init();
}

enemy_default_ai_functions( name )
{
	switch( name )
	{
		case "state":
			//state functions
			self ai_create_behavior_function( "state", "hidden", ::enemy_state_hidden );
			self ai_create_behavior_function( "state", "alert", ::enemy_state_alert );
			self ai_create_behavior_function( "state","spotted", ::enemy_state_spotted );
			break;
		case "alert":
			//alert level functions
			self ai_create_behavior_function( "alert", "reset", ::enemy_alert_level_lostem );
			self ai_create_behavior_function( "alert", "alerted_once", ::enemy_alert_level_alerted_once );
			self ai_create_behavior_function( "alert", "alerted_again", ::enemy_alert_level_alerted_again );
			self ai_create_behavior_function( "alert", "attack", ::enemy_alert_level_attack );
			break;
		case "corpse":
			//corpse functions
			self ai_create_behavior_function( "corpse", "saw", ::enemy_corpse_saw_behavior );
			self ai_create_behavior_function( "corpse", "found", ::enemy_corpse_found_behavior );
			break;
		case "awareness":
			//awareness functions						
			self ai_create_behavior_function( "awareness", "heard_scream", ::enemy_awareness_reaction_heard_scream );
			self ai_create_behavior_function( "awareness", "explode", 	::enemy_awareness_reaction_explosion );
			
			break;
		case "animation":
			self ai_create_behavior_function( "animation", "wrapper", 			::enemy_animation_wrapper );
			
			if( self._stealth.logic.dog )
			{
				self ai_create_behavior_function( "animation", "reset", 			::enemy_animation_nothing );
				self ai_create_behavior_function( "animation", "attack", 			::dog_animation_generic );
				
				self ai_create_behavior_function( "animation", "heard_scream", 		::dog_animation_generic );				
				self ai_create_behavior_function( "animation", "bulletwhizby", 		::dog_animation_wakeup_fast );
				self ai_create_behavior_function( "animation", "projectile_impact", ::dog_animation_wakeup_slow );
				self ai_create_behavior_function( "animation", "explode", 			::dog_animation_wakeup_fast );
			}
			else
			{
				self ai_create_behavior_function( "animation", "reset", 			::enemy_animation_nothing );
				self ai_create_behavior_function( "animation", "alerted_once", 		::enemy_animation_nothing );
				self ai_create_behavior_function( "animation", "alerted_again", 	::enemy_animation_nothing );
				self ai_create_behavior_function( "animation", "attack", 			::enemy_animation_attack );
				
				self ai_create_behavior_function( "animation", "heard_scream", 		::enemy_animation_generic );
				
				self ai_create_behavior_function( "animation", "heard_corpse", 		::enemy_animation_generic );
				self ai_create_behavior_function( "animation", "saw_corpse", 		::enemy_animation_generic );
				self ai_create_behavior_function( "animation", "found_corpse", 		::enemy_animation_generic );
				
				self ai_create_behavior_function( "animation", "bulletwhizby", 		::enemy_animation_whizby );
				self ai_create_behavior_function( "animation", "projectile_impact", ::enemy_animation_whizby );
				self ai_create_behavior_function( "animation", "explode", 			::enemy_animation_generic );
			}
			break;
	}	
}

enemy_dog_init()
{
	if( threatbiasgroupexists( "dog" ) )
		self setthreatbiasgroup( "dog" );
		
	if( isdefined( self.enemy ) || isdefined( self.favoriteenemy ) )
		return;
	
	self.ignoreme = true;
	self.ignoreall = true;
		
	//we do this because we assume dogs are sleeping...
	self thread anim_generic_loop( self, "_stealth_dog_sleeping", undefined, "stop_loop" );
}

enemy_Message_Loop()
{
	funcs = self._stealth.behavior.ai_functions[ "state" ];
	//these handle global "what to do" based on current state
	self thread ai_message_handler( "_stealth_hidden", 	funcs[ "hidden" ] );
	self thread ai_message_handler( "_stealth_alert", 	funcs[ "alert" ] );
	self thread ai_message_handler( "_stealth_spotted", funcs[ "spotted" ] );
}

ai_message_handler( _flag, function )
{
	self endon( "death" );
	self endon( "pain_death" );
	
	while(1)
	{
		flag_wait( _flag );
		self thread [[ function ]]();
		
		flag_waitopen( _flag );
	}
}

enemy_state_hidden()
{
	level endon("_stealth_detection_level_change");
	
	self.fovcosine = .5;//60 degrees to either side...120 cone...2/3 of the default
	self.favoriteenemy = undefined;
	
	if( self._stealth.logic.dog )
		return;
		
	self.dieQuietly = true;
	if( !isdefined( self.old_baseAccuracy ) )
		self.old_baseAccuracy = self.baseaccuracy;
	if( !isdefined( self.old_Accuracy ) )
		self.old_Accuracy = self.accuracy;
		
	self.baseAccuracy 	= self.old_baseAccuracy;
	self.Accuracy 		= self.old_Accuracy;
	self.fixednode		= true;
	self clearenemy();
}

enemy_state_alert()
{
	level endon("_stealth_detection_level_change");
}

//this is called by some functions like finding a corpse or
//hearing an explosion that go into alert - but dont want to put into alert
//state because alert state shares it's behavior with a guy simply
//thinkgin he saw something twice
enemy_reaction_state_alert()
{
	self.fovcosine = .01;//90 degrees to either side...180 cone...default view cone
	self.ignoreall = false;
	self.dieQuietly 	= false;
	self clear_run_anim();
	self.fixednode		= false;
}

enemy_state_spotted()
{
	level endon("_stealth_detection_level_change");
	
	self.fovcosine = .01;//90 degrees to either side...180 cone...default view cone
	self.ignoreall = false;
	
	if( !self._stealth.logic.dog )
	{
		self.dieQuietly 	= false;
		self clear_run_anim();
		self.baseAccuracy 	*= 3;
		self.Accuracy 		*= 3;
		self.fixednode		= false;
		
		self enemy_stop_current_behavior();
	}
	
	if( !isdefined( self.enemy ) )
		self waittill_notify_or_timeout( "enemy", randomfloatrange(1, 3) );

	if( self._stealth.logic.dog )
		self.favoriteenemy = level.player;
	else if( randomint(100) > 25 )
		self.favoriteenemy = level.player; // 75% chance that favorite enemy is the player
}

/************************************************************************************************************/
/*										ANIMATION REACTION CODE FOR ENEMIES									*/
/************************************************************************************************************/

enemy_Animation_Loop()
{
	wrapper_func = self._stealth.behavior.ai_functions[ "animation" ][ "wrapper" ];//enemy_animation_wrapper
	
	self endon( "death" );
	self endon( "pain_death" );
	
	while(1)
	{
		self waittill( "event_awareness", type );
		
		self thread [[ wrapper_func ]]( type );
	}
}

enemy_animation_wrapper( type )
{
	self endon( "death" );
	self endon( "pain_death" );
				
	//ALWAYS RUN THIS UNLESS YOU'RE SURE YOU KNOW WHAT YOU"RE DOING
	if( self enemy_animation_pre_anim( type ) )
		return;	
	
	self enemy_animation_do_anim( type );
	
	//ALWAYS RUN THIS UNLESS YOU'RE SURE YOU KNOW WHAT YOU"RE DOING
	self enemy_animation_post_anim( type );
}

enemy_animation_do_anim( type )
{
	if( isdefined( self._stealth.behavior.event.custom_animation ) )
	{
		self enemy_animation_custom();
		return;
	}	
	
	//do default behavior	
	function = self._stealth.behavior.ai_functions[ "animation" ][ type ];
	
	self [[ function ]]( type );
}

enemy_animation_custom()
{
	self endon( "death" );
	self endon( "pain_death" );
	
	node = self._stealth.behavior.event.custom_animation.node;
	anime = self._stealth.behavior.event.custom_animation.anime;
	tag = self._stealth.behavior.event.custom_animation.tag;
	ender = self._stealth.behavior.event.custom_animation.ender;
	
	self ent_flag_set( "_stealth_behavior_reaction_anim" );
	
	// wouldn't normally do this - but since this is specific to stealth script
	// i figured it would be ok to set allowdeath.
	self.allowdeath = true; 
	
	//cut the loop
	node notify( ender );
	
	//this is the reaction
	node anim_generic( self, anime, tag );
	
	//once you the the reaction once - you dont wanna ever do it again...especially not off this node
	self ai_clear_custom_animation_reaction();
}

enemy_animation_pre_anim( type )
{
	self notify ( "enemy_awareness_reaction" );
	
	//this means that something really bad happened...a first reaction
	//to the player being spotted or something equally bad like a bullet
	//whizby
	if( self ent_flag( "_stealth_behavior_first_reaction" ) )
		return true;	
		
	//this function doesn't stop behavior if _stealth_behavior_reaction_anim
	//is set - because stoping behavior means ending current animations
	//and since reacting is an animation - we want to set the flag
	//AFTER we've stopped the current ones
	self enemy_stop_current_behavior();
				
	switch( type )
	{		
		case "explode":
		case "heard_corpse":
		case "saw_corpse":
		case "found_corpse":
			//all the cases above this dont break - so they all will do the same thing when they get to this line
			self ent_flag_set( "_stealth_behavior_reaction_anim" );
			break;
		case "reset":
		case "alerted_once":
		case "alerted_again":
			//all the cases above this dont break - so they all will do the same thing when they get to this line
			// which is absolutely nothing
			break;
		default:
			self ent_flag_set( "_stealth_behavior_first_reaction" );
			self ent_flag_set( "_stealth_behavior_reaction_anim" );
			break;
	}
	
	return false;
}

enemy_animation_post_anim( type )
{
	switch( type )
	{
		default:
			self ent_flag_clear( "_stealth_behavior_reaction_anim" );
			break;	
	}
}

enemy_animation_whizby( type )
{				
	self.allowdeath = true;

	anime = "_stealth_behavior_whizby_" + randomint( 5 );	
	self thread anim_generic_custom_animmode( self, "gravity", anime );
	
	wait 1.5;
	
	self notify( "stop_animmode" );
}

enemy_animation_attack( type )
{				
	enemy = self._stealth.logic.event.awareness[ type ];
	
	if( distance( enemy.origin, self.origin ) < 256 )
		anime = "_stealth_behavior_spotted_short";
	else
		anime = "_stealth_behavior_spotted_short";
	
	self.allowdeath = true;
	self thread anim_generic_custom_animmode( self, "gravity", anime );
	
	self waittill_notify_or_timeout( anime, randomfloatrange( 1.5, 3 ) );
	
	self notify( "stop_animmode" );
}

enemy_animation_nothing( type )
{
	//these dont actually do anything, however their existance
	//allows for custom reaction animations to be played even
	//at this alert stage
}

enemy_animation_generic( type )
{
	self.allowdeath = true;
	
	anime = "_stealth_behavior_generic";	
	
	self anim_generic_custom_animmode( self, "gravity", anime );
}

dog_animation_generic( type )
{
	self.allowdeath = true;
	
	anime = undefined;
	if ( randomint( 100 ) < 50 )
		anime = "_stealth_dog_wakeup_fast";	
	else
		anime = "_stealth_dog_wakeup_slow";	
	
	self anim_generic_custom_animmode( self, "gravity", anime );
}

dog_animation_wakeup_fast( type )
{
	self.allowdeath = true;
	
	anime = "_stealth_dog_wakeup_fast";	
	
	self anim_generic_custom_animmode( self, "gravity", anime );
}
dog_animation_wakeup_slow( type )
{
	self.allowdeath = true;
	
	anime = "_stealth_dog_wakeup_slow";	
	
	self anim_generic_custom_animmode( self, "gravity", anime );
}

/************************************************************************************************************/
/*										AWARENESS BEHAVIOR CODE FOR ENEMIES									*/
/************************************************************************************************************/

enemy_Awareness_Loop()
{		
	func = self._stealth.behavior.ai_functions[ "awareness" ];
	
	self endon( "death" );
	self endon( "pain_death" );
	
	while(1)
	{
		self waittill( "event_awareness", type );
		
		if( isdefined( func[ type ] ) )
			self thread [[ func[ type ] ]]( type );
	}
}

enemy_awareness_reaction_explosion( type )
{
	self endon( "_stealth_enemy_alert_level_change" );
	self endon ( "enemy_awareness_reaction" );
	self endon ( "_stealth_saw_corpse" );
	level endon( "_stealth_found_corpse" );
	level endon("_stealth_spotted");
		
	enemy_reaction_state_alert();	
	
	spot = self enemy_find_original_goal();;
			
	self enemy_stop_current_behavior();
		
	origin = self._stealth.logic.event.awareness[ type ];
	origin = enemy_awareness_find_explosion_spot( origin );
		
	self thread enemy_announce_wtf();
	
	if( origin == (0,0,0) )
		return;
	
	wait randomfloat( 1 );
	self setgoalpos( origin );
	self.goalradius = randomintrange( 200, 400 );
		
	self.disablearrivals = false;
	self.disableexits = false;
	
	self waittill( "goal" );
	self setgoalpos( self.origin );
	self.goalradius = 4;	
	
	wait randomfloatrange( 30, 50 );
	
	self thread enemy_announce_hmph();
		
	self enemy_try_180_turn( spot );
	
	if( isdefined( self.last_patrol_goal ) )
	{		
		self.target = self.last_patrol_goal.targetname;
		self thread maps\_patrol::patrol();
	}
	else
	{
		self set_generic_run_anim( "patrol_walk" );
		self.disablearrivals = true;
		self.disableexits = true;	
		self enemy_go_back( spot );
	}
}

enemy_awareness_find_explosion_spot( origin )
{
	if( !isdefined( level._stealth.behavior.event_explosion_pos ) )
	{
		level._stealth.behavior.event_explosion_pos = ( 0,0,0 );
		
		dist = 512;
		nodes = enemy_get_closest_pathnodes( dist, origin );
		if( isdefined( nodes ) && nodes.size )
		{
			nodes = get_array_of_closest( origin, nodes );
			level._stealth.behavior.event_explosion_pos = nodes[0].origin;
		}
		waittillframeend;
		level notify( "found_explostion_spot" );
	}
	else
		level waittill( "found_explostion_spot" );
	
	return level._stealth.behavior.event_explosion_pos;
}

enemy_awareness_reaction_heard_scream( type )
{
	origin = self._stealth.logic.event.awareness[ type ];
	
	self setgoalpos( origin );	
}

/************************************************************************************************************/
/*										THREAT BEHAVIOR CODE FOR ENEMIES									*/
/************************************************************************************************************/

enemy_Threat_Loop()
{
	self endon("death");
	self endon( "pain_death" );
	
	if( self._stealth.logic.dog )
		self thread enemy_threat_logic_dog();
		
	while(1)
	{
		self waittill("_stealth_enemy_alert_level_change");
		
		type = self._stealth.logic.alert_level.lvl;
		enemy = self._stealth.logic.alert_level.enemy;
		
		self thread enemy_alert_level_change( type, enemy );
	}
}

//we do this because we assume dogs are sleeping...if so, then they'll never get an enemy
//because to make that assumption we set their ignorall to true in their init...so we need
//to give them the ability to find an enemy once they take damage...we might extend this in 
//the future to also do the same thing if an ai gets too close or makes too much noise
enemy_threat_logic_dog()
{
	self endon( "death" );
	self endon( "pain_death" );
		
	self waittill( "pain" );
	self.ignoreall = false;
}

enemy_alert_level_change( type, enemy )
{	
	self ent_flag_set( "_stealth_enemy_alert_level_action" );	
	funcs = self._stealth.behavior.ai_functions[ "alert" ];
	
	self thread [[ funcs[ type ] ]]( enemy );
}

enemy_alert_level_normal()
{
	self endon("_stealth_enemy_alert_level_change");
	self endon("death");
	self endon( "pain_death" );
	
	spot = self enemy_find_original_goal();
	self enemy_stop_current_behavior();
	
	self waittill( "normal" );
	
	self ent_flag_clear( "_stealth_enemy_alert_level_action" );
	self flag_waitopen( "_stealth_found_corpse" );
	
	//if( !isdefined( self._stealth.logic.corpse.corpse_entity ) )
	self thread enemy_announce_hmph();
		
	if( isdefined( self.last_patrol_goal ) )
	{
		self.target = self.last_patrol_goal.targetname;
		
		self enemy_try_180_turn( self.last_patrol_goal.origin );
		self thread maps\_patrol::patrol();
	}
	else
		self enemy_go_back( spot );
}

enemy_find_original_goal()
{
	if( isdefined( self.last_set_goalnode ) )
		return self.last_set_goalnode.origin;
	
	if( isdefined( self.last_set_goalpos ) )
		return self.last_set_goalpos;
		
	return self.origin;
}

enemy_alert_level_lostem( enemy )
{
	//the ONLY time you'll ever recieve a 0 as a type of alert and get sent to this function is if
	//the allies were spotted, probably had a big fire fight, and managed to actually get away and 
	//hide while there are still enemy ai alive.
	//if this happens - we don't want them to chase the player down, but we dont want them to act like 
	//nothing ever happened before...so we need a special function for this case
	self notify( "normal" );
}

enemy_alert_level_alerted_once( enemy )
{	
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	self endon( "pain_death" );
	
	self thread enemy_announce_huh();
	self thread enemy_alert_level_normal();	
	
	if( isdefined( self.last_patrol_goal ) )
	{
		// we can call patrol walk and not stealth walk because we know the _patrol code is running
		self set_generic_run_anim(  "patrol_walk" ); 
		self.disablearrivals = true;
		self.disableexits = true;	
	}
	
	vec = vectornormalize(enemy.origin - self.origin);
	dist = distance( enemy.origin, self.origin);
	dist *= .25;
	
	if(dist < 64)
		dist = 64;
	if(dist > 128)
		dist = 128;
		
	vec = vector_multiply( vec, dist );
		
	spot = self.origin + vec + (0,0,16);
	end = spot + ( (0,0,-96) );
	
	spot = physicstrace( spot, end );
	if (spot == end )
		return;
		
	self setgoalpos( spot );
	self.goalradius = 4;
	
	//we do the timeout - because sometimes this puts his goal into a postion that
	//is invalid and he'll never actually hit his goal...so we time out after 2 seconds
	self waittill_notify_or_timeout("goal", 2);
	
	wait 3;
	self notify( "normal" );
}

enemy_alert_level_alerted_again( enemy )
{	
	self endon("_stealth_enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	self endon( "pain_death" );
	
	self thread enemy_announce_huh();
	self thread enemy_alert_level_normal();
	
	self set_generic_run_anim(  "_stealth_patrol_jog" );
	self.disablearrivals = false;
	self.disableexits = false;	
		
	lastknownspot = enemy.origin;
	distance = distance( lastknownspot, self.origin );
	
	self setgoalpos( lastknownspot );	
	self.goalradius = distance * .5;
	self waittill("goal");
	
	self set_generic_run_anim(  "_stealth_patrol_walk" );
	self setgoalpos( lastknownspot );	
	self.goalradius = 64;
	self.disablearrivals = true;
	self.disableexits = true;	
	
	self waittill("goal");
	
	wait 12;
	self notify( "normal" );	
}

enemy_alert_level_attack( enemy )
{	
	self endon ( "death" );
	self endon( "pain_death" );
	
	self thread enemy_announce_spotted( self.origin );
			
	//might have to link this into enemy_animation_attack() at some point
	if ( !isdefined( self.script_stealth_dontseek ) )
		self setgoalpos( enemy.origin );
		
	self.goalradius = 2048;
}

enemy_announce_wtf()
{
	if( !( self enemy_announce_snd( "wtf" ) ) )
		return;
		
	self playsound("RU_0_reaction_casualty_generic");
}

enemy_announce_huh()
{
	if( !( self enemy_announce_snd( "huh" ) ) )
		return;
		
	alias = "scoutsniper_ru" + self._stealth.behavior.sndnum + "_huh";
	self playsound( alias );
}

enemy_announce_hmph()
{
	if( !( self enemy_announce_snd( "hmph" ) ) )
		return;
		
	alias = "scoutsniper_ru" + self._stealth.behavior.sndnum + "_hmph";
	self playsound( alias );
}

enemy_announce_spotted( pos )
{	
	self endon( "death" );
	//self endon( "pain_death" ); --> actually want to be able to still call out to buddies
	
	//this makes sure that if we're not spotted because we killed
	//this guy before he could set the flag - we dont' bring 
	//everyone over for no reason.
	flag_wait( "_stealth_spotted" );
			
	if( !( self enemy_announce_snd( "spotted" ) ) )
		return;
	
	self thread enemy_announce_spotted_bring_team( pos );	
	
	if( self._stealth.logic.dog )
		return;
			
	self playsound("RU_0_reaction_casualty_generic");
}

enemy_announce_spotted_bring_team( pos )
{	
	ai = getaispeciesarray( "axis", "all" );
	
	for(i=0; i<ai.size; i++)
	{
		if( ai[i] == self )
			continue;
		
		if( isdefined( ai[i].enemy ) )
			continue;
		
		if( isdefined( ai[i].favoriteenemy ) )
			continue;
		
		ai[i] notify( "heard_scream", pos );
	}
}

enemy_announce_corpse()
{		
	if( !( self enemy_announce_snd( "corpse" ) ) )
		return;
		
	self playsound("RU_0_reaction_casualty_generic");
}

enemy_announce_snd( type )
{
	if( level._stealth.behavior.sound[ type ] )
		return false;
	
	level._stealth.behavior.sound[ type ] = true;	
		
	self thread	enemy_announce_snd_reset( type );
	
	return true;
}

enemy_announce_snd_reset( type )
{
	if( type == "spotted" )
		return;
		
	wait 3;	
	level._stealth.behavior.sound[ type ] = false;
}

/************************************************************************************************************/
/*										CORPSE BEHAVIOR CODE FOR ENEMIES									*/
/************************************************************************************************************/

enemy_Corpse_Loop()
{
	if( self._stealth.logic.dog )
		return;
		
	self endon( "death" );
	self endon( "pain_death" );
	
	self thread enemy_found_corpse_loop();
	
	while(1)
	{
		self waittill( "_stealth_saw_corpse" );	
		self enemy_saw_corpse_logic();
	}
}

enemy_saw_corpse_logic()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "_stealth_found_corpse" );
				
	self thread enemy_announce_huh();
			
	while( 1 )
	{
		self ent_flag_waitopen( "_stealth_enemy_alert_level_action" );
		
		self enemy_corpse_saw_wrapper();
		
		//the only reason we failed - and didn't end this function 
		//is if we had an alert change so wait to go back to normal 
		//and then resume looking for the corpse
		self waittill( "normal" );
	}
}

enemy_stop_current_behavior()
{	
	if( !self ent_flag( "_stealth_behavior_reaction_anim" ) )
	{
		self stopanimscripted();
		self notify( "stop_animmode" );
		self notify( "stop_loop" );//for dogs
	}
	if( isdefined( self.last_patrol_goal ) )
	{
		self.last_patrol_goal.patrol_claimed = undefined;
		self notify( "release_node" );
		self notify( "end_patrol" );
	}	
}
    
enemy_corpse_saw_wrapper()
{				
	//if he maybe saw an enemy - that's more important
	self endon("enemy_alert_level_change");
	
	funcs = self._stealth.behavior.ai_functions[ "corpse" ];
	self [[ funcs[ "saw" ] ]]();// ::enemy_corpse_saw_behavior()
}

enemy_corpse_saw_behavior()
{
	self enemy_stop_current_behavior();	
	ent_flag_set( "_stealth_running_to_corpse" );
	
	self.disableArrivals = false;
	self.disableExits = false;
	
	self set_generic_run_anim( "_stealth_combat_jog" );
	self.goalradius = level._stealth.logic.corpse.found_dist - 4;
	self setgoalpos( self._stealth.logic.corpse.corpse_entity.origin );
}

enemy_found_corpse_loop()
{
	self endon( "death" );
	self endon( "pain_death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	funcs = self._stealth.behavior.ai_functions[ "corpse" ];
			
	while(1)
	{
		flag_wait( "_stealth_found_corpse" );	
		
		while( flag( "_stealth_found_corpse" ) )
		{
			if( self ent_flag( "_stealth_found_corpse" ) )
				self thread enemy_announce_corpse();
			else
				self notify( "heard_corpse", (0,0,0) );
			
			self enemy_reaction_state_alert();
			self [[ funcs[ "found"] ]]();// ::enemy_corpse_found_behavior()
						
			level waittill( "_stealth_found_corpse" );
		} 
	}
}

enemy_corpse_found_behavior()
{		
	self enemy_stop_current_behavior();
	
	if( level._stealth.logic.corpse.last_pos != level._stealth.behavior.corpse.last_pos )
	{	
		radius = level._stealth.behavior.corpse.search_radius;
		origin = level._stealth.logic.corpse.last_pos;	
		
		level._stealth.behavior.corpse.node_array = enemy_corpse_calc_search_nodes( radius, origin );
		
		level._stealth.behavior.corpse.last_pos = level._stealth.logic.corpse.last_pos;
	}
	
	array = level._stealth.behavior.corpse.node_array;
	
	for( i=0 ; i<array.size; i++)
	{
		if( isdefined( array[ i ]._stealth_corpse_behavior_taken ) )
			continue;
				
		self setgoalpos( array[ i ].origin );
		self.goalradius = 4;
	
		array[ i ] thread enemy_corpse_reaction_takenode();
		
		tooclose = get_array_of_closest( array[ i ].origin, array, undefined, undefined, 40 );
		array_thread( tooclose, ::enemy_corpse_reaction_takenode );
		
		break;
	}
}

enemy_corpse_reaction_takenode()
{	
	self._stealth_corpse_behavior_taken = true;
	
	//everything is going to happen within the first frame
	//so waiting a second is more than enough, to pass the
	//check for the other ai
	wait .5;
	
	self._stealth_corpse_behavior_taken = undefined;
}

enemy_corpse_calc_search_nodes( radius, origin )
{
	nodes = getstructarray( "corpse_nodes", "targetname" );
	corpsenodes = [];
	
	ai = getaiarray( "axis" );
	num = ai.size + 5;
	if( num > 32 )
		num = 32;
			
	if( nodes.size )
	{
		corpsenodes = get_array_of_closest( origin, nodes, undefined, undefined, radius );	
		
		if( corpsenodes.size >= num)
			return corpsenodes;
		
		//not enough - increase radius	
		addnodes = get_array_of_closest( origin, nodes, undefined, undefined, ( radius * 2 ) );
		corpsenodes	= array_merge( corpsenodes, addnodes );
		
		if( corpsenodes.size >= num)
			return corpsenodes;
	}
		
	//still not enough - combine with pathnodes
	pathnodes = enemy_get_closest_pathnodes( ( radius * 2 ), origin );
	corpsenodes	= array_combine( corpsenodes, pathnodes );
		
	return corpsenodes;
}

enemy_get_closest_pathnodes( radius, origin )
{
	nodes = getallnodes();
	
	pathnodes = [];
	
	radus2rd = radius * radius;
	
	for(i=0; i<nodes.size; i++)
	{
		if( nodes[ i ].type != "Path" )
			continue;
		
		if( distancesquared( nodes[ i ].origin, origin ) > radus2rd )
			continue;
		
		pathnodes[ pathnodes.size ] = nodes[ i ];
	}
	
	return pathnodes;
}

/************************************************************************************************************/
/*									INDIVIDUAL STEALTH BEHAVIOR FOR FRIENDLIES								*/
/************************************************************************************************************/

friendly_logic( state_functions )
{	
	self friendly_init( state_functions );
	self thread friendly_Message_Loop();
	self thread friendly_stance_handler();
}

friendly_init( state_functions )
{
	assertEX( isdefined( self._stealth ), "There is no self._stealth struct.  You ran stealth behavior before running the detection logic.  Run _stealth_logic::friendly_init() on this AI first" );
		
	//this is our behavior struct inside of _stealth...everything we do will go in here.
	self._stealth.behavior = spawnstruct();		
	
	self._stealth.behavior.accuracy = [];
	self._stealth.behavior.goodAccuracy = 50;
	self._stealth.behavior.badAccuracy = 0;
	
	self._stealth.behavior.old_baseAccuracy = self.baseAccuracy;
	self._stealth.behavior.old_Accuracy 	= self.Accuracy;
	
	//AI FUNCTIONS
	self._stealth.behavior.ai_functions = [];
	self._stealth.behavior.ai_functions[ "state" ] = [];
	
	self friendly_default_ai_functions( "state" );
	
	self ai_change_ai_functions( "state", state_functions );
		
		
	self ent_flag_init( "_stealth_custom_anim" );
}

friendly_default_ai_functions( name )
{	
	switch( name )
	{
		case "state":
			//state functions
			self ai_create_behavior_function( name, "hidden", ::friendly_state_hidden );
			self ai_create_behavior_function( name, "alert", ::friendly_state_alert );
			self ai_create_behavior_function( name,"spotted", ::friendly_state_spotted );
			break;
	}
}

friendly_Message_Loop()
{
	funcs = self._stealth.behavior.ai_functions[ "state" ];
	//these handle global "what to do" based on current state
	self thread ai_message_handler( "_stealth_hidden", 	funcs[ "hidden" ] );
	self thread ai_message_handler( "_stealth_alert", 	funcs[ "alert" ] );
	self thread ai_message_handler( "_stealth_spotted", funcs[ "spotted" ] );
}

friendly_state_hidden()
{
	level endon("_stealth_detection_level_change");
	
	self.baseAccuracy 	= self._stealth.behavior.goodaccuracy;
	self.Accuracy 		= self._stealth.behavior.goodaccuracy;
	self._stealth.behavior.oldgrenadeammo	= self.grenadeammo;
	self.grenadeammo	= 0;
	self.forceSideArm 	= false;
	self.ignoreall 		= true;
	self.ignoreme 		= true;
	self disable_ai_color();
	waittillframeend;
	self.fixednode		= false;
}

friendly_state_alert()
{
	level endon("_stealth_detection_level_change");
	self friendly_state_hidden();
}

friendly_state_spotted()
{
	level endon("_stealth_detection_level_change");
	
	self thread friendly_spotted_getup_from_prone();
		
	self.baseAccuracy 	= self._stealth.behavior.badaccuracy;
	self.Accuracy 		= self._stealth.behavior.badaccuracy;
	self.grenadeammo 	= self._stealth.behavior.oldgrenadeammo;
	self allowedstances( "prone", "crouch", "stand" );
	self stopanimscripted();
	self.ignoreall 	= false;
	self.ignoreme 	= false;
	self disable_cqbwalk();
	self enable_ai_color();
	self.disablearrivals 	= true;
	self.disableexits 		= true;
	self pushplayer( false );
}

friendly_spotted_getup_from_prone( angles )
{
	self endon( "death" );
	
	if( self._stealth.logic.stance != "prone" )
		return;
	
	self ent_flag_set( "_stealth_custom_anim" );
	anime = "prone_2_run_roll";
	
	if( isdefined( angles ) )
		self orientMode( "face angle", angles[1] + 20 );
		//self thread friendly_spotted_getup_from_prone_rotate( angles, anime );

	self thread anim_generic_custom_animmode( self, "gravity", anime ); 
	length = getanimlength( getanim_generic( anime ) );
	wait ( length - .2 );
	self notify( "stop_animmode" );
	self ent_flag_clear( "_stealth_custom_anim" );
}

//these don't work yet
/*
friendly_spotted_getup_from_prone_rotate( desiredAngles, anime )
{
	animation = getanim_generic( anime );
	
	//adding 25 just seems to work nice
	yawDiff =  desiredAngles[1] + 25 - self.angles[1]; //getAngleDelta( animation, 0, 1 )
	
	length = getAnimLength( animation ) - .2;
	numFrames = length / .05;
	curFrames = 1;
	
	for ( i = 0; i < numFrames; i++ )
	{
		frac 	= ( curFrames/numFrames );
		if(curFrames < numFrames )
			curFrames++;
		diff = desiredAngles[1] - self.angles[1];
		amount 	= ( diff * frac );
		
		self orientMode( "face angle", self.angles[1] + amount );
		wait .05;
	}
}

friendly_spotted_use_sidearm()
{
	dist = 600;
	dist2rd = dist * dist;
	
	while( flag("_stealth_spotted") )
	{
		ai = getaispeciesarray("axis", "all");
		close = false;
		
		for(i=0; i<ai.size; i++)
		{
			if( distancesquared( ai[i].origin, self.origin ) > dist2rd )
				continue;
			close = true;
			break;	
		}
		
		if(close)
			self.forceSideArm = true;
		else
			self.forceSideArm = false;
		
		wait .25;
		}
}
*/

/************************************************************************************************************/
/*										SMART STANCE LOGIC FOR FRIENDLIES									*/
/************************************************************************************************************/
friendly_stance_handler()
{	
	self endon( "death" );
	self endon( "pain_death" );
	
	self friendly_stance_handler_init();
	
	while(1)
	{
		while( self ent_flag( "_stealth_stance_handler" ) && !flag( "_stealth_spotted") )
		{
			self friendly_stance_handler_set_stance_up();			
			stances = [];
			stances = friendly_stance_handler_check_mightbeseen( stances );
			
			//this means we're currently visible we need to drop a stance or stay still
			if( stances[ self._stealth.logic.stance ] )
				self thread friendly_stance_handler_change_stance_down();
			//ok coast is clear - we can go again if we were staying still
			else if( self ent_flag( "_stealth_stay_still" ) )
				self thread friendly_stance_handler_resume_path();
			//this means we can actually go one stance up
			else if( ! stances[ self._stealth.behavior.stance_up ] )
				self thread friendly_stance_handler_change_stance_up();
			//so - we're not stancing up, we're not stancing down, or staying still...lets notify
			//ourselves that we should stay in the same stance ( just in case we're about to stance up )
			else if( self ent_flag( "_stealth_stance_change" ) )
				self notify( "_stealth_stance_dont_change" );
				
			wait .05;	
		}
		
		self.moveplaybackrate = 1;
		self allowedstances( "stand", "crouch", "prone" );
		
		self ent_flag_wait( "_stealth_stance_handler" );
		flag_waitopen( "_stealth_spotted" );
	}
}

friendly_stance_handler_stay_still()
{
	if( self ent_flag( "_stealth_stay_still" ) )
		return;
	self ent_flag_set( "_stealth_stay_still" );
	
	badplace_cylinder( "_stealth_" + self.ai_number + "_prone", 0, self.origin, 30, 90,"axis" ); 
	self thread friendly_stance_handler_stay_still_kill();
	self thread anim_generic_loop( self, "_stealth_prone_idle", undefined, "stop_loop" );
}

friendly_stance_handler_stay_still_kill()
{
	self endon( "_stealth_stay_still" );
	
	flag_wait( "_stealth_spotted" );
	
	badplace_delete( "_stealth_" + self.ai_number + "_prone" ); 
	self notify( "stop_loop" );
}

friendly_stance_handler_resume_path()
{	
	self ent_flag_clear( "_stealth_stay_still" );

	badplace_delete( "_stealth_" + self.ai_number + "_prone" ); 
	
	self notify( "stop_loop" ); 
}

friendly_stance_handler_change_stance_down()
{
	self.moveplaybackrate = 1;
	
	self notify("_stealth_stance_down");
	
	switch( self._stealth.logic.stance )
	{
		case "stand":
			self.moveplaybackrate = .7;
			self allowedstances( "crouch" );
			break;
		case "crouch":
			self allowedstances( "prone" );
			break;
		case "prone":
			friendly_stance_handler_stay_still();
			break;
	}
}

friendly_stance_handler_change_stance_up()
{
	self endon( "_stealth_stance_down" );
	self endon( "_stealth_stance_dont_change" );
	self endon( "_stealth_stance_handler" );
	
	if( self ent_flag( "_stealth_stance_change" ) )
		return;
	
	//we wait a sec before deciding to actually stand up - just like a real player
	self ent_flag_set( "_stealth_stance_change" );
	wait 1.5;
	//now check again
	self ent_flag_clear( "_stealth_stance_change" );
		
	self.moveplaybackrate = 1;
	
	switch( self._stealth.logic.stance )
	{
		case "prone":
			self allowedstances( "crouch" );
			break;
		case "crouch":
			self allowedstances( "stand" );
			break;
		case "stand":
			break;
	}
}

friendly_stance_handler_check_mightbeseen( stances )
{
	// not using species because we dont care about dogs...
	//when they're awake - we're already not in stealth mode anymore
	ai = getaispeciesarray("axis", "all");
	
	stances[ self._stealth.logic.stance ] 		= 0;
	stances[ self._stealth.behavior.stance_up ] = 0;
		
	for(i=0; i<ai.size; i++)
	{								
		//this is how much to add based on a fast sight trace
		dist_add_curr = self friendly_stance_handler_return_ai_sight( ai[i], self._stealth.logic.stance );
		dist_add_up = self friendly_stance_handler_return_ai_sight( ai[i], self._stealth.behavior.stance_up );
		
		//this is the score for both the current stance and the next one up
		score_current 	= ( self maps\_stealth_logic::friendly_compute_score() ) + dist_add_curr;
		score_up		= ( self maps\_stealth_logic::friendly_compute_score( self._stealth.behavior.stance_up ) ) + dist_add_up;
			
		if( distance( ai[i].origin, self.origin ) < score_current )
		{
			stances[ self._stealth.logic.stance ] = score_current;
			break;
		}
		
		if( distance( ai[i].origin, self.origin ) < score_up )
			stances[ self._stealth.behavior.stance_up ] = score_up;
	}
	
	return stances;
}

friendly_stance_handler_set_stance_up()
{
	//figure out what the next stance up is
	switch( self._stealth.logic.stance )
	{
		case "prone":
			self._stealth.behavior.stance_up = "crouch";
			break;
		case "crouch":
			self._stealth.behavior.stance_up = "stand";
			break;
		case "stand":
			self._stealth.behavior.stance_up = "stand";//can't leave it as undefined
			break;
	}
}

friendly_stance_handler_return_ai_sight( ai, stance )
{
	//check to see where the ai is facing
	vec1 = anglestoforward( ai.angles ); // this is the direction the ai is facing
	vec2 = vectornormalize( self.origin - ai.origin ); // this is the direction from him to us
	
	//comparing the dotproduct of the 2 will tell us if he's facing us and how much so..
	//0 will mean his direction is exactly perpendicular to us, 
	//1 will mean he's facing directly at us
	//-1 will mean he's facing directly away from us 
	vecdot = vectordot( vec1, vec2 );	
	state = level._stealth.logic.detection_level;
	
	//is the ai facing us?
	if( vecdot > .3 )
		return self._stealth.behavior.stance_handler[ state ]["looking_towards"][ stance ];
	//is the ai facing away from us
	else if( vecdot < -.7 )
		return self._stealth.behavior.stance_handler[ state ]["looking_away"][ stance ];
	//the ai is kinda not facing us or away
	else 
		return self._stealth.behavior.stance_handler[ state ]["neutral"][ stance ];
}

#using_animtree( "generic_human" );
friendly_stance_handler_init()
{
	self ent_flag_init( "_stealth_stance_handler" );
	self ent_flag_init( "_stealth_stay_still" );
	self ent_flag_init( "_stealth_stance_change" );
	
	level.scr_anim[ "generic" ][ "_stealth_prone_idle" ][0] = %prone_aim_idle;
	
	self._stealth.behavior.stance_up = undefined;
	self._stealth.behavior.stance_handler = [];
	self friendly_default_stance_handler_distances();	
}
