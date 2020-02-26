#include common_scripts\utility;
#include maps\_utility;
#include maps\_anim;

/************************************************************************************************************/
/*																											*/
/*										HOW TO USE STEALTH SYSTEM											*/
/*																											*/
/*																											*/
/*							the stealth system doesn't take care of everything.								*/
/*							It simply handles whether enemy ai detect the player							*/
/*							and friendlies or not.  It does some reaction behavior, 						*/
/*							where they'll come over and investigate the scene, but 							*/
/*							other than that, the behavior of both friendlies and							*/
/*							enemies before and after detection is up to the designer.						*/
/*																											*/
/*							1. call maps\_stealth::main(); in your main level script						*/
/*							2. add the following anims to your _anim.gsc and your fastfile					*/
/*																											*/
/*							level.scr_anim[ "generic" ][ "patrol_jog" ]			= %patrol_jog;				*/
/*							level.scr_anim[ "generic" ][ "patrol_jog_turn180" ]	= %patrol_jog_360;			*/
/*																											*/			
/*							3. call maps\_utility::stealth_ai on ai and the player							*/
/*																											*/
/*							that's pretty much it.  														*/
/*																											*/
/*							One more usefull function in utility is:										*/
/*							maps\_utility::stealth_enemy_waittill_alert(), which lets you know				*/
/*							if the enemy has become slightly alerted or completely spotted the				*/
/*							allies.																			*/
/*																											*/
/*							also near the bottom of this script is a section called: [ INDIVIDUAL 			*/
/*							STEALTH LOGIC FOR ALLIES ] these functions aren't called implicitly				*/
/*							so that the designer can best decide how to script his ally behavior			*/
/*							however they are very usefull, so take a look at their discriptions				*/
/*							down in that section															*/
/*																											*/
/*																											*/
/*																											*/
/************************************************************************************************************/

main()
{
	initStealthDetection();	
}

/************************************************************************************************************/
/*										GLOBAL STEALTH DETECTION FOR FRIENDLIES								*/
/************************************************************************************************************/

initStealthDetection()
{
	flag_init( "_stealth_spotted" );
	flag_init( "_stealth_found_corpse" );
	level._stealth = spawnstruct();
	level._stealth.detection_level = "hidden";
	level._stealth.detection_level_alert = 0;
	level._stealth.sound_spotted = false;
	level._stealth.sound_huh = false;
	level._stealth.sound_hmph = false;
	level._stealth.corpse_array = [];
	level._stealth.corpse_position = undefined;
	level._stealth.corpse_max = int( getdvar( "ai_corpseCount" ) );
	level._stealth.corpse_sight_dist = 1500;
	level._stealth.corpse_sight_distsqrd = level._stealth.corpse_sight_dist * level._stealth.corpse_sight_dist;
	level._stealth.corpse_detect_dist = 256;
	level._stealth.corpse_detect_distsqrd = level._stealth.corpse_detect_dist * level._stealth.corpse_detect_dist;
		
	level._stealth.detect_range = [];
	
	level._stealth.detect_range[ "hidden" ] = [];
	level._stealth.detect_range[ "hidden" ][ "prone" ]	= 70;
	level._stealth.detect_range[ "hidden" ][ "crouch" ]	= 600;
	level._stealth.detect_range[ "hidden" ][ "stand" ]	= 1024;
	
	level._stealth.detect_range[ "alert" ] = [];
	level._stealth.detect_range[ "alert" ][ "prone" ]	= 140;
	level._stealth.detect_range[ "alert" ][ "crouch" ]	= 900;
	level._stealth.detect_range[ "alert" ][ "stand" ]	= 1500;
	
	level._stealth.detect_range[ "spotted" ] = [];
	level._stealth.detect_range[ "spotted" ][ "prone" ]	= 512;
	level._stealth.detect_range[ "spotted" ][ "crouch" ]= 5000;
	level._stealth.detect_range[ "spotted" ][ "stand" ]	= 8000;
	
	level._stealth.ai_event = [];
	
	level._stealth.ai_event[ "ai_eventDistDeath" ] = [];
	level._stealth.ai_event[ "ai_eventDistDeath" ][ "spotted" ] = getdvar( "ai_eventDistDeath" );
	level._stealth.ai_event[ "ai_eventDistDeath" ][ "alert" ] 	= 256;
	level._stealth.ai_event[ "ai_eventDistDeath" ][ "hidden" ] 	= 256;
	
	level._stealth.ai_event[ "ai_eventDistPain" ] = [];
	level._stealth.ai_event[ "ai_eventDistPain" ][ "spotted" ] 	= getdvar( "ai_eventDistPain" );
	level._stealth.ai_event[ "ai_eventDistPain" ][ "alert" ] 	= 256;
	level._stealth.ai_event[ "ai_eventDistPain" ][ "hidden" ] 	= 256;
	
	level._stealth.ai_event[ "ai_eventDistBullet" ] = [];
	level._stealth.ai_event[ "ai_eventDistBullet" ][ "spotted"]	= getdvar( "ai_eventDistBullet" );
	level._stealth.ai_event[ "ai_eventDistBullet" ][ "alert" ] 	= 64;
	level._stealth.ai_event[ "ai_eventDistBullet" ][ "hidden" ] = 64;
	
	level._stealth.ai_event[ "ai_eventDistFootstep" ] = [];
	level._stealth.ai_event[ "ai_eventDistFootstep" ][ "spotted"]	= getdvar( "ai_eventDistBullet" );
	level._stealth.ai_event[ "ai_eventDistFootstep" ][ "alert" ] 	= 64;
	level._stealth.ai_event[ "ai_eventDistFootstep" ][ "hidden" ] 	= 64;
	
	level._stealth.ai_event[ "ai_eventDistFootstepLite" ] = [];
	level._stealth.ai_event[ "ai_eventDistFootstepLite" ][ "spotted"]	= getdvar( "ai_eventDistBullet" );
	level._stealth.ai_event[ "ai_eventDistFootstepLite" ][ "alert" ] 	= 32;
	level._stealth.ai_event[ "ai_eventDistFootstepLite" ][ "hidden" ] 	= 32;
	
	thread AIStealthDetection_eventhandler();
	thread AIStealthDetection_state_logic();
}

AIStealthDetection()
{
	self AIStealthDetection_init();
	
	if( isPlayer( self ) )
		self thread AIStealthDetection_movespeed();
	
		
	while( isalive( self ) )
	{
		if( self._stealth.stance_change )
		{
			self._stealth.stance = self._stealth.oldstance;
			self._stealth.stance_change_down -= .05;
		}
		else
		{	
			if( isPlayer( self ) )
				self._stealth.stance = level.player getstance();	
			else
				self._stealth.stance = self.a.pose;
				
			self._stealth.oldstance = self._stealth.stance;
		}
		
		//we do this because the player is still moving at a high speed when he goes
		//into a lower stance - which messes with the movespeed multiplier calculation
		//so we want to delay it a moment to give the player a chance to slow down
		switch(self._stealth.stance)
		{
			case "prone":
				if(self._stealth.oldstance != "prone")
					self._stealth.stance_change = .2;
				self._stealth.stance = self._stealth.oldstance;
				break;
			case "crouch":
				if(self._stealth.oldstance == "stand")
					self._stealth.stance_change = .2;
				self._stealth.stance = self._stealth.oldstance;
				break;
		}
				
		self.maxVisibleDist = self AIStealthDetection_compute_score();
		
		wait 0.05;
	}
}

AIStealthDetection_compute_score( stance )
{
	if( !isdefined( stance ) )
		stance = self._stealth.stance;
		
	score_range = level._stealth.detect_range[ level._stealth.detection_level ][ stance ];
	score_move = self._stealth.movespeed_multiplier[ level._stealth.detection_level ][ stance ];
	return ( score_range + score_move );
}

AIStealthDetection_init()
{
	self._stealth = spawnstruct();
	self._stealth.stance_change = false;
	
	if( isPlayer( self ) )
		self._stealth.oldstance = level.player getstance();	
	else
		self._stealth.oldstance = self.a.pose;
	
	self._stealth.spotted_list = [];
	self AIStealthDetection_init_Movespeed();
}

AIStealthDetection_init_Movespeed()
{
	self._stealth.movespeed_multiplier = [];
	
	self._stealth.movespeed_multiplier[ "hidden" ] = [];
	self._stealth.movespeed_multiplier[ "hidden" ][ "prone" ] 	= 0;
	self._stealth.movespeed_multiplier[ "hidden" ][ "crouch" ] 	= 0;
	self._stealth.movespeed_multiplier[ "hidden" ][ "stand" ] 	= 0;
	
	self._stealth.movespeed_multiplier[ "alert" ] = [];
	self._stealth.movespeed_multiplier[ "alert" ][ "prone" ] 	= 0;
	self._stealth.movespeed_multiplier[ "alert" ][ "crouch" ] 	= 0;
	self._stealth.movespeed_multiplier[ "alert" ][ "stand" ] 	= 0;
	
	self._stealth.movespeed_multiplier[ "spotted" ] = [];
	self._stealth.movespeed_multiplier[ "spotted" ][ "prone" ] 	= 0;
	self._stealth.movespeed_multiplier[ "spotted" ][ "crouch" ] = 0;
	self._stealth.movespeed_multiplier[ "spotted" ][ "stand" ] 	= 0;
}

AIStealthDetection_movespeed()
{
	oldangles = self getplayerangles();
	
	while(1)
	{
		score_move = length( self getVelocity() );
		score_turn = length( oldangles - self getplayerangles() );
		if( score_turn > 30 )
			score_turn = 30;
		
		score = score_move + score_turn;
		
		//seperated these out instead of keeping inside a forloop if i ever
		//want to get more specific about how each setting is scored...
		self._stealth.movespeed_multiplier[ "hidden" ][ "prone" ] 	= ( score ) * 3;
		self._stealth.movespeed_multiplier[ "spotted" ][ "prone" ] 	= ( score ) * 2;
		self._stealth.movespeed_multiplier[ "alert" ][ "prone" ] 	= ( score ) * 2;
		
		self._stealth.movespeed_multiplier[ "hidden" ][ "crouch" ] 	= ( score ) * 2;
		self._stealth.movespeed_multiplier[ "spotted" ][ "crouch" ] = ( score ) * 2;
		self._stealth.movespeed_multiplier[ "alert" ][ "crouch" ] 	= ( score ) * 2;
		
		self._stealth.movespeed_multiplier[ "hidden" ][ "stand" ] 	= ( score ) * 2;
		self._stealth.movespeed_multiplier[ "spotted" ][ "stand" ] 	= ( score ) * 2;
		self._stealth.movespeed_multiplier[ "alert" ][ "stand" ] 	= ( score ) * 2;
		
		oldangles = self getplayerangles();
		wait .1;
	}
}

AIStealthDetection_state_alert()
{
	level._stealth.detection_level = "alert";
	
	level._stealth.detection_level_alert++;
	self waittill_either( "death", "normal" );
	
	if( flag( "_stealth_spotted" ) )
	{
		level._stealth.detection_level_alert = 0;
		return;
	}
	
	level._stealth.detection_level_alert--;
	
	if( level._stealth.detection_level_alert )
		return;
	
	level._stealth.detection_level = "hidden";
}

AIStealthDetection_state_logic()
{
	while(1)
	{
		flag_wait( "_stealth_spotted" );
		
		clear = true;
		
		ai = getaispeciesarray( "axis", "all" );
		for(i=0; i<ai.size; i++)
		{
			if( isdefined( ai[ i ].enemy ) )
			{
				clear = false;
				break;	
			}	
		}
		//basically if everyone lost their enemy...then we're hidden again
		if(clear)
			flag_clear( "_stealth_spotted" );

		wait .1;
	}
}

AIStealthDetection_eventhandler()
{
	AIStealthDetection_event_change( "hidden" );
	
	while(1)
	{
		flag_wait( "_stealth_spotted" );
		
		AIStealthDetection_event_change( "spotted" );
		level._stealth.detection_level = "spotted";
		battlechatter_on( "axis" );
	//	battlechatter_on( "allies" );
		
		flag_waitopen( "_stealth_spotted" );
		
		AIStealthDetection_event_change( "hidden" );
		level._stealth.detection_level = "hidden";
		level._stealth.sound_spotted = false;
		battlechatter_off( "axis" );
		battlechatter_off( "allies" );
	}
}

AIStealthDetection_event_change( name )
{
	keys = getarraykeys( level._stealth.ai_event );
	for(i=0; i<keys.size; i++)
	{
		key = keys[ i ];
		setsaveddvar( key, level._stealth.ai_event[ key ][ name ] );
	}	
}

/************************************************************************************************************/
/*										INDIVIDUAL STEALTH DETECTION FOR ENEMIES							*/
/************************************************************************************************************/

enemy_stealth_logic()
{
	self endon("death");
	self enemy_stealth_init();
	self thread enemy_stealth_wakeup();
	self thread enemy_corpse_logic();
	
	while(1)
	{
		self waittill("enemy");
		
		//for now don't do this part for dogs...maybe in the future we'll 
		//add support for alerted dog behavior but most likely not
		//this is also assuming that the dogs are ignoring everyone
		//will probably have to come back to this once we have sleeping dog
		//animations.
		if( !issubstr( self.classname, "dog" ) )
		{
			if( !flag( "_stealth_spotted" ) )
			{
				if( !(self enemy_alert_level_reaction( self.enemy ) ) )
					continue;
			}
			else//if we hit this line it means we're not the first ones to find the enemy
				self enemy_alert_level_action( 3, self.enemy );
		}
		flag_set( "_stealth_spotted" );
				
		//wait a minimum of 20 seconds before trying to lose your enemy
		wait 20;
		
		while( isdefined( self.enemy ) )
		{
			if( distance( self.origin, self.enemy.origin ) > self.maxVisibleDist )	
				self enemy_hidden_attributes();		
			wait .25;
		}
	}
}

enemy_stealth_wakeup()
{
	self endon("death");
	while(1)
	{
		flag_wait( "_stealth_spotted" );
					
		self enemy_spotted_attributes();
		self enemy_announce_spotted();
		
		flag_waitopen( "_stealth_spotted" );
	}
}

enemy_stealth_init()
{
	self._stealth = spawnstruct();
	self._stealth.stoptime = 0;
	self._stealth.sndnum = randomintrange(1,4);
	self enemy_event_listeners_init();
	self enemy_hidden_attributes();	
	
	if( issubstr( self.classname, "dog" ) )
	{
		self enemy_stealth_dog_init();
		return;
	}
	
	self ent_flag_init( "_stealth_enemy_alert_level_action" );
	self ent_flag_init( "_stealth_found_corpse" );
	self ent_flag_init( "_stealth_running_to_corpse" );
}

enemy_stealth_dog_init()
{
	self.ignoreme = true;
	self.ignoreall = true;
	
	if( threatbiasgroupexists( "dog" ) )
		self setthreatbiasgroup( "dog" );
	
	self thread enemy_stealth_dog_wakeup();
}

enemy_stealth_dog_wakeup()
{
	self endon("death");
	
	self waittill( "pain" );
	self.ignoreall = false;
}

enemy_hidden_attributes()
{
	self.fovcosine = .5;//60 degrees to either side...120 cone...2/3 of the default
	self.favoriteenemy = undefined;
	
	if( issubstr( self.classname, "dog" ) )
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

enemy_spotted_attributes()
{
	self.fovcosine = .01;//90 degrees to either side...180 cone...default view cone
	self.ignoreall = false;
	
	thread enemy_spotted_logic();
	
	if( issubstr( self.classname, "dog" ) )
		return;
	
	self.dieQuietly 	= false;
	self clear_run_anim();
	self.baseAccuracy 	*= 3;
	self.Accuracy 		*= 3;
	self.fixednode		= false;
	self stopanimscripted();	
}

enemy_spotted_logic()
{
	if( !isdefined( self.enemy ) )
		self waittill_notify_or_timeout( "enemy", randomfloatrange(1, 3) );

	if( issubstr( self.classname, "dog" ) )
		self.favoriteenemy = level.player;
	else if( randomint(100) > 25 )
		self.favoriteenemy = level.player; // 75% chance that favorite enemy is the player
	
	if( isdefined( self.enemy ) )
		self enemy_alert_level_action( 3, self.enemy );
	else if( isdefined( self.favoriteenemy ) )
		self enemy_alert_level_action( 3, self.favoriteenemy );	
}	

enemy_event_listeners_init()
{
	self._stealth.event = spawnstruct();
	self._stealth.event.bad_event_listener = false;
	self._stealth.event.listener = [];
	
	self._stealth.event.listener[ self._stealth.event.listener.size ] = "grenade danger";
	self._stealth.event.listener[ self._stealth.event.listener.size ] = "gunshot";
	self._stealth.event.listener[ self._stealth.event.listener.size ] = "bulletwhizby";
	self._stealth.event.listener[ self._stealth.event.listener.size ] = "silenced_shot";
	self._stealth.event.listener[ self._stealth.event.listener.size ] = "projectile_impact";

	for(i=0; i<self._stealth.event.listener.size; i++)
		self addAIEventListener( self._stealth.event.listener[ i ] );

	for(i=0; i<self._stealth.event.listener.size; i++)
		self thread enemy_event_listeners_logic( self._stealth.event.listener[ i ] );
	
	self thread enemy_event_declare_to_team( "damage", "ai_eventDistPain" );
	self thread enemy_event_declare_to_team( "death", "ai_eventDistDeath" );
	
	self thread enemy_event_listeners_proc();
}

enemy_event_declare_to_team( type, name )
{
	self waittill( type );
	ai = getaispeciesarray( "axis", "all" );
	
	check = int( level._stealth.ai_event[ name ][ level._stealth.detection_level ] );
	
	for(i=0; i<ai.size; i++)
	{
		if( !isalive( ai[i] ) )
			continue;
		if( !isdefined( ai[i]._stealth ) )
			continue;
		if( distance( ai[i].origin, self.origin ) > check )
			continue;
		ai[i]._stealth.event notify ("bad_event_listener" );
	}
}

enemy_event_listeners_logic( name )
{
	self endon("death");
		
	while(1)
	{
		self waittill( name );
		self._stealth.event notify ("bad_event_listener" );
	}
}

enemy_event_listeners_proc()
{	
	self endon("death");
	while(1)
	{
		self._stealth.event waittill("bad_event_listener" );
		self._stealth.event.bad_event_listener = true;
		
		wait .65;
		//this time is set so high because apparently the ai can take up to .5 seconds to 
		//detect you as an enemy after they have received an event listener
		self._stealth.event.bad_event_listener = false;
	}
}

enemy_alert_level_reaction( enemy )
{
	//add this ai to this spotted list
	if( !isdefined( enemy._stealth.spotted_list[ self.ai_number ] ) )
		enemy._stealth.spotted_list[ self.ai_number ] = 0;
	
	//if we haven't had a chance since out last time to hide...then don't increase our spotted number
	if( !self._stealth.stoptime )
		enemy._stealth.spotted_list[ self.ai_number ]++;
	
	//the first check means that a gun shot or something equally bad happened	
	//the second check is to see if you've been spotted already twice before
	if( self._stealth.event.bad_event_listener || enemy._stealth.spotted_list[ self.ai_number ] > 2 )
	{
		self enemy_alert_level_action( 3, enemy );
		return true; 
	}
	
	//***************				IMPORTANT 			*************************//
	//- since code will constantly give him an enemy - we need to keep clearing it 
	//for stealth gameplay to work...and we need to make sure we do this before we do anything else because 
	//the next line down could return from this function...so this line of code can't really be moved
	self clearenemy();
	
	//ok so if we're not attacking - then we should wait the right amount of time since the 
	//last occurance to make sure the player has time to hide
	if( self._stealth.stoptime )
		return false;		
		
	//this makes the ai look smart by being aware of your presence
	switch( enemy._stealth.spotted_list[ self.ai_number ] )
	{
		case 1:
			self enemy_alert_level_action( 1, enemy );
			break;
		case 2:	
			self enemy_alert_level_action( 2, enemy );
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
	//after 60 seconds - forget about it
	wait 60;	
	
	assertEX( enemy._stealth.spotted_list[ self.ai_number ], "enemy._stealth.spotted_list[ self.ai_number ] is already 0 but being told to forget" );
	enemy._stealth.spotted_list[ self.ai_number ]--;
}

enemy_alert_level_normal()
{
	self endon("enemy_alert_level_change");
	self endon("death");
	
	spot = self.origin;
	if( isdefined( self.last_patrol_goal ) && !self ent_flag( "_stealth_found_corpse" ) )
	{
		self.last_patrol_goal.patrol_claimed = undefined;
		self notify( "release_node" );
	}
	
	self waittill( "normal" );
	
	self ent_flag_clear( "_stealth_enemy_alert_level_action" );
	self thread enemy_alert_level_hmph();
		
	if( isdefined( self.last_patrol_goal ) )
	{
		self.target = self.last_patrol_goal.targetname;
		
		vec1 = anglestoforward( self.angles );
		vec2 = vectornormalize( self.last_patrol_goal.origin - self.origin );
		//if the goal is behind him - do a 180 anim
		if( vectordot( vec1, vec2 ) < -.8 )
		{
			//is there an obstacle in his way
			start = self.origin + (0,0,16);
			end = self.last_patrol_goal.origin + (0,0,16);
			
			spot = physicstrace(start, end);
			if( spot == end )			
				self anim_generic( self, "patrol_turn180" );
		}
		self thread maps\_patrol::patrol();
	}
	else
		self setgoalpos( spot );
}

enemy_alert_level_huh()
{
	self enemy_alert_level_reaction_snd( "huh" );
}

enemy_alert_level_hmph()
{
	self enemy_alert_level_reaction_snd( "hmph" );
}

enemy_alert_level_reaction_snd( type )
{
	switch( type)
	{
		case "huh":
			if( level._stealth.sound_huh )
				return;
			level._stealth.sound_huh = true;
			break;
		case "hmph":
			if( level._stealth.sound_hmph )
				return;
			level._stealth.sound_hmph = true;
			break;
	}
	
	alias = "scoutsniper_ru" + self._stealth.sndnum + "_" + type;
	self playsound( alias );
	
	wait 3;
	
	switch( type )
	{
		case "huh":
			level._stealth.sound_huh = false;
			break;
		case "hmph":
			level._stealth.sound_hmph = false;
			break;
	}	
}

enemy_alert_level_action( type, enemy )
{
	self notify("enemy_alert_level_change");

	if( !issubstr( self.classname, "dog" ) )
		self ent_flag_set( "_stealth_enemy_alert_level_action" );
		
	switch( type )
	{
		case 1:
			self thread enemy_alert_level_investigate( enemy );
			break;
		case 2:
			self thread enemy_alert_level_walkover( enemy );
			break;
		case 3:	
			self thread enemy_alert_level_attack( enemy );
			break;
	}
}

enemy_alert_level_investigate( enemy )
{	
	self endon("enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	
	self thread enemy_alert_level_huh();
	self thread enemy_alert_level_normal();	
	
	if( isdefined( self.last_patrol_goal ) )
	{
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
	
	self waittill_notify_or_timeout("goal", 2);
	wait 3;
	self notify( "normal" );
}

enemy_alert_level_walkover( enemy )
{	
	self endon("enemy_alert_level_change");
	level endon("_stealth_spotted");
	self endon( "death" );
	
	self thread AIStealthDetection_state_alert();
	self thread enemy_alert_level_huh();
	self thread enemy_alert_level_normal();
	
	self set_generic_run_anim(  "patrol_jog" );
	self.disablearrivals = false;
	self.disableexits = false;	
		
	lastknownspot = enemy.origin;
	distance = distance( lastknownspot, self.origin );
	
	self setgoalpos( lastknownspot );	
	self.goalradius = distance * .5;
	self waittill("goal");
	
	self set_generic_run_anim(  "patrol_walk" );
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
	self thread enemy_alert_level_normal();	
	self setgoalpos( enemy.origin );
	self.goalradius = 2048;
}

enemy_alert_level_waittime( enemy )
{
	timefrac = distance( self.origin, enemy.origin ) * .0005;
	self._stealth.stoptime = .25 + timefrac;
	
	//iprintlnbold( self._stealth.stoptime );
	
	//this makes sure that if someone else spots you...then this quits earler
	//then the givin amount of time for the player to try and hide again
	flag_wait_or_timeout("_stealth_spotted", self._stealth.stoptime );
	
	self._stealth.stoptime = 0;
}

enemy_announce_spotted()
{	
	if( level._stealth.sound_spotted )
		return;
	
	level._stealth.sound_spotted = true;
	self playsound("RU_0_reaction_casualty_generic");
}

/************************************************************************************************************/
/*										CORPSE DETECTION CODE FOR ENEMIES									*/
/************************************************************************************************************/

enemy_corpse_logic()
{
	self thread enemy_corpse_death();
	
	//dogs can be a corpse - but not find one
	if( issubstr( self.classname, "dog" ) )
		return;
		
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self thread enemy_corpse_reaction_loop();
	
	while( 1 )
	{		
		found = false;
		corpse = undefined;
		
		for(i=0; i<level._stealth.corpse_array.size; i++)
		{
			corpse = level._stealth.corpse_array[ i ];
			distsqrd = distancesquared( self.origin, corpse.origin );
							
			//are we close enough to check?
			if( distsqrd > level._stealth.corpse_sight_distsqrd )
				continue;		
			
			//are we really close to him
			if( distsqrd < level._stealth.corpse_detect_distsqrd )
			{
				//do we have clear line of sight to the corpse
				if( self cansee( corpse ) )	
				{
					found = true;
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
					found = true;
					break;
				}
			}
		}
		
		if( found )
		{
			self._stealth.corpse = corpse;
			self thread enemy_found_corpse_logic();	
			break;
		}
		
		wait .05;
	}		
}

enemy_corpse_death()
{
	self waittill("death");
	corpse = spawn("script_origin", self.origin);
	corpse.targetname = "corpse";

	wait 1;//give the body a chance to fall

	corpse enemy_corpse_add_to_stack();
}

enemy_corpse_add_to_stack()
{
	if( level._stealth.corpse_array.size == level._stealth.corpse_max)
		enemy_corpse_shorten_stack();
	
	level._stealth.corpse_array[ level._stealth.corpse_array.size ] = self;
}

enemy_corpse_shorten_stack()
{
	array1 = [];
	array2 = level._stealth.corpse_array;
	remove = level._stealth.corpse_array[0];
	
	//drop the oldest guy - which would be 0
	for(i=1; i<level._stealth.corpse_max; i++)
		array1[ array1.size ] = array2[ i ];

	level._stealth.corpse_array = array1;
	
	remove delete();
}

enemy_corpse_reaction_loop()
{
	self endon( "death" );
	
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	self endon( "_stealth_scripted_corpse_reaction" );
	
	while(1)
	{
		flag_wait( "_stealth_found_corpse" );	
		
		while( flag( "_stealth_found_corpse" ) )
		{
			
			self enemy_corpse_alert_level();
			self enemy_corpse_reaction();
			level waittill( "_stealth_found_corpse" );
		} 
	}
}

enemy_corpse_alert_level()
{
	enemy = undefined;

	if( isdefined( self.enemy ) )
		enemy = self.enemy;
	else
		enemy = level.player;
	
	if( !isdefined( enemy._stealth.spotted_list[ self.ai_number ] ) )
		enemy._stealth.spotted_list[ self.ai_number ] = 0;
	
	self thread AIStealthDetection_state_alert();

	//basically take up their alert level each time they see a corpse...but not enough
	//to start attacking the player
	switch( enemy._stealth.spotted_list[ self.ai_number ] )
	{
		case 0:
			enemy._stealth.spotted_list[ self.ai_number ] ++; //this takes it to 1
			self thread enemy_alert_level_forget( enemy );
			break;
		case 1:
			enemy._stealth.spotted_list[ self.ai_number ] ++; //this takes it to 2
			self thread enemy_alert_level_forget( enemy );
			break;
		//we dont have a case 2 because we dont want to actually set their alert
		//level to the maximum - which would be to attack the player outright
	} 
}

enemy_corpse_reaction()
{
	self.fovcosine = .01;//90 degrees to either side...180 cone...default view cone
	self.ignoreall = false;
	self.dieQuietly 	= false;
	self clear_run_anim();
	self.fixednode		= false;
	self stopanimscripted();
	
	if( !isdefined( self._stealth.corpse ) )
		wait randomfloatrange( 1, 3 );
	else
	{
		wait .5;
		if( isdefined( self._stealth.corpse ) )
			self._stealth.corpse delete();
		self._stealth.corpse = undefined;
	}
	radius = distance( level.player.origin, level._stealth.corpse_position ) * .5;
	origin = undefined;
	
	if(radius >= 256 )
	{
		vec = vectornormalize(	level.player.origin - level._stealth.corpse_position );
		vec = vector_multiply( vec, 256 );
		origin = level._stealth.corpse_position + vec;
	}
	else 	
		origin = level._stealth.corpse_position;
		
	if( radius > 256 )
		radius = 256;
	
	nodes = enemy_corpse_calc_search_nodes(radius, origin );
	node = random( nodes );
	while( isdefined( node._stealth_corpse_search_taken ) && node._stealth_corpse_search_taken == true)
		 node = random( nodes );	
		
	node._stealth_corpse_search_taken = true;
	
	self setgoalnode( node );
	self.goalradius = 4;
}

enemy_corpse_calc_search_nodes( radius, origin )
{
	nodes = getallnodes();
	
	pathnodes = [];
	
	for(i=0; i<nodes.size; i++)
	{
		if( nodes[ i ].type != "Path" )
			continue;
		
		if( distance( nodes[ i ].origin, origin ) > radius )
			continue;
		
		pathnodes[ pathnodes.size ] = nodes[ i ];
	}
	
	return pathnodes;
}

enemy_found_corpse_logic()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );
	
	level endon( "_stealth_found_corpse" );
	
	thread enemy_alert_level_huh();
	
	while( 1 )
	{
		self ent_flag_waitopen( "_stealth_enemy_alert_level_action" );
		enemy_run_to_corpse();
		//the only reason we failed - and didn't end this function 
		//is if we had an alert change so wait to go back to normal 
		//and then resume looking for the corpse
		self waittill( "normal" );
	}
}

enemy_run_to_corpse()
{
	if( flag( "_stealth_spotted" ) )
		return;
	level endon( "_stealth_spotted" );

	self ent_flag_set( "_stealth_running_to_corpse" );
	
	//if he maybe saw an enemy - that's more important
	self endon("enemy_alert_level_change");
	
	if( isdefined( self.last_patrol_goal ) )
	{
		self.last_patrol_goal.patrol_claimed = undefined;
		self notify( "release_node" );
		self notify( "end_patrol" );
	}
	
	self.disableArrivals = false;
	self.disableExits = false;
	
	self set_generic_run_anim( "combat_jog" );
	self.goalradius = 64;
	self setgoalpos( self._stealth.corpse.origin );
	self waittill("goal");

	thread enemy_announce_corpse();
}

enemy_announce_corpse()
{		
	self playsound("RU_0_reaction_casualty_generic");
	level._stealth.corpse_position = self._stealth.corpse.origin;
	level._stealth.corpse_array = array_remove( level._stealth.corpse_array, self._stealth.corpse );
		
	self ent_flag_set( "_stealth_found_corpse" );
	if( !flag( "_stealth_found_corpse" ) )
		flag_set( "_stealth_found_corpse" );
	else
		level notify( "_stealth_found_corpse" );
		
	thread enemy_corpse_clear();
}

enemy_corpse_clear()
{
	level endon( "_stealth_found_corpse" );
	
	waittill_dead_or_dying( getaiarray( "axis" ), undefined, 90);
	
	flag_clear( "_stealth_found_corpse" );
}


/************************************************************************************************************/
/*										INDIVIDUAL STEALTH LOGIC FOR ALLIES									*/
/************************************************************************************************************/

/*
	THESE ARE USEFULL FUNCTIONS FOR ALLIES THAT ARE NOT CALLED EXPLICITLY
	you can call them in script though if you want the functionality

	1. friendly_spotted_handler();
		this one is good if you have a color system set up to handle what the 
		characters do once they come out of stealth...it's also good for 
		making them less accurate and not ignored if that's what you're lookin for
		
	2. friendly_stance_handler();
		very usefull for making allies seem smart about standing crouching and proning
		once it's called, toggle on and off with ent_flag( "_stealth_stance_handler" ), 
		which defaults to off
*/

friendly_spotted_handler()
{
	goodaccuracy = 50;
	badaccuracy = 0;
	self.old_baseAccuracy = self.baseAccuracy;
	self.old_Accuracy = self.Accuracy;
	
	self.baseAccuracy = goodaccuracy;
	self.Accuracy = goodaccuracy;
	
	dist = 512;
	dist2rd = dist * dist;
	
	self ent_flag_init( "_stealth_custom_anim" );
	
	while(1)
	{
		flag_wait("_stealth_spotted");
		
		self thread friendly_spotted_getup_from_prone();
		
		self.baseAccuracy 	= badaccuracy;
		self.Accuracy 		= badaccuracy;
		self allowedstances( "prone", "crouch", "stand" );
		self stopanimscripted();
		self.ignoreall = false;
		self.ignoreme = false;
		self disable_cqbwalk();
		self enable_ai_color();
		self.disablearrivals = true;
		self.disableexits = true;
						
//		self thread friendly_spotted_use_sidearm();
		flag_waitopen( "_stealth_spotted" );
			
		self.baseAccuracy = goodaccuracy;
		self.Accuracy = goodaccuracy;
		self.forceSideArm = false;
		self.ignoreall = true;
		self.ignoreme = true;
		self disable_ai_color();
	}
}	

friendly_spotted_getup_from_prone( angles )
{
	self ent_flag_set( "_stealth_custom_anim" );
	anime = "prone_2_run_roll";
	
	if( isdefined( angles ) )
		self orientMode( "face angle", angles[1] + 20 );
		//self thread friendly_spotted_getup_from_prone_rotate( angles, anime );
	if( self._stealth.stance == "prone" )
	{
		self thread anim_generic_custom_animmode( self, "gravity", anime ); 
		length = getanimlength( getanim_generic( anime ) );
		wait ( length - .2 );
		self notify( "stop_animmode" );
		self ent_flag_clear( "_stealth_custom_anim" );
	}
}

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

//this one doesn't work yet...which is why it's commented out in friendly_spotted_handler();
//will come back to this later if it's really necessary
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


/************************************************************************************************************/
/*										SMART STANCE LOGIC FOR FRIENDLIES									*/
/************************************************************************************************************/
friendly_stance_handler()
{	
	self friendly_stance_handler_init();
	
	while(1)
	{
		while( self ent_flag( "_stealth_stance_handler" ) && !flag( "_stealth_spotted") )
		{
			self friendly_stance_handler_init_stance_up();			
			stances = [];
			stances = friendly_stance_handler_check_mightbeseen( stances );
			
			//this means we're currently visible we need to drop a stance or stay still
			if( stances[ self._stealth.stance ] )
				self thread friendly_stance_handler_change_stance_down();
			//ok coast is clear - we can go again if we were staying still
			else if( self ent_flag( "_stealth_stay_still" ) )
				self thread friendly_stance_handler_resume_path();
			//this means we can actually go one stance up
			else if( ! stances[ self._stealth.stance_up ] )
				self thread friendly_stance_handler_change_stance_up();
			//so - we're not stancing up, we're not stancing down, or staying still...lets notify
			//ourselves that we should stay in the same stance ( just in case we're about to stance up )
			else if( self ent_flag( "_stealth_stance_change" ) )
				self notify( "_stealth_stance_dont_change" );
				
			wait .05;	
		}
		
		self._stealth.staying_still = false;
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
	
	badplace_cylinder( "_stealth_" + self.ai_number + "_prone", 0, self.origin, 64, 90,"axis" ); 
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

	self notify( "stop_loop" ); 
	
/*	
	if( isdefined( self.last_set_goalnode ) )
		self set_goal_node( self.last_set_goalnode );
	
	else if( isdefined( self.last_set_goalpos ) )
		self set_goal_pos( self.last_set_goalpos );
		
*/
}

friendly_stance_handler_change_stance_down()
{
	self.moveplaybackrate = 1;
	
	self notify("_stealth_stance_down");
	
	switch( self._stealth.stance )
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
	
	switch( self._stealth.stance )
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
	ai = getaiarray("axis");
	
	stances[ self._stealth.stance ] 	= 0;
	stances[ self._stealth.stance_up ] 	= 0;
		
	for(i=0; i<ai.size; i++)
	{								
		//this is how much to add based on a fast sight trace
		dist_add_curr = self friendly_stance_handler_return_ai_sight( ai[i], self._stealth.stance );
		dist_add_up = self friendly_stance_handler_return_ai_sight( ai[i], self._stealth.stance_up );
		
		//this is the score for both the current stance and the next one up
		score_current 	= ( self AIStealthDetection_compute_score() ) + dist_add_curr;
		score_up		= ( self AIStealthDetection_compute_score( self._stealth.stance_up ) ) + dist_add_up;
			
		if( distance( ai[i].origin, self.origin ) < score_current )
		{
			stances[ self._stealth.stance ] = score_current;
			break;
		}
		
		if( distance( ai[i].origin, self.origin ) < score_up )
			stances[ self._stealth.stance_up ] = score_up;
	}
	
	return stances;
}

friendly_stance_handler_init_stance_up()
{
	//figure out what the next stance up is
	switch( self._stealth.stance )
	{
		case "prone":
			self._stealth.stance_up = "crouch";
			break;
		case "crouch":
			self._stealth.stance_up = "stand";
			break;
		case "stand":
			self._stealth.stance_up = "stand";//can't leave it as undefined
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
	state = level._stealth.detection_level;
	
	//is the ai facing us?
	if( vecdot > .3 )
		return self._stealth.stance_handler[ state ]["looking_towards"][ stance ];
	//is the ai facing away from us
	else if( vecdot < -.7 )
		return self._stealth.stance_handler[ state ]["looking_away"][ stance ];
	//the ai is kinda not facing us or away
	else 
		return self._stealth.stance_handler[ state ]["neutral"][ stance ];
}

#using_animtree( "generic_human" );
friendly_stance_handler_init()
{
	self ent_flag_init( "_stealth_stance_handler" );
	self ent_flag_init( "_stealth_stay_still" );
	self ent_flag_init( "_stealth_stance_change" );
	
	level.scr_anim[ "generic" ][ "_stealth_prone_idle" ][0] = %prone_idle;
	
	self._stealth.stance_up = undefined;
	
	//i do this because the player doesn't look as bad sneaking up on the enemies
	//friendlies however don't look as good getting so close
	self._stealth.stance_handler = [];
	self._stealth.stance_handler[ "hidden" ][ "looking_away" ][ "stand" ] 	= 500;
	self._stealth.stance_handler[ "hidden" ][ "looking_away" ][ "crouch" ] 	= -400;
	self._stealth.stance_handler[ "hidden" ][ "looking_away" ][ "prone" ] 	= 0;
	
	self._stealth.stance_handler[ "hidden" ]["neutral"][ "stand" ] 			= 500;
	self._stealth.stance_handler[ "hidden" ]["neutral"][ "crouch" ] 		= 200;
	self._stealth.stance_handler[ "hidden" ]["neutral"][ "prone" ] 			= 50;
	
	self._stealth.stance_handler[ "hidden" ]["looking_towards"][ "stand" ] 	= 800;
	self._stealth.stance_handler[ "hidden" ]["looking_towards"][ "crouch" ] = 400;
	self._stealth.stance_handler[ "hidden" ]["looking_towards"][ "prone" ] 	= 100;
	
	self._stealth.stance_handler[ "alert" ][ "looking_away" ][ "stand" ] 	= 800;
	self._stealth.stance_handler[ "alert" ][ "looking_away" ][ "crouch" ] 	= 200;
	self._stealth.stance_handler[ "alert" ][ "looking_away" ][ "prone" ] 	= 50;
	
	self._stealth.stance_handler[ "alert" ]["neutral"][ "stand" ] 			= 800;
	self._stealth.stance_handler[ "alert" ]["neutral"][ "crouch" ] 			= 500;
	self._stealth.stance_handler[ "alert" ]["neutral"][ "prone" ] 			= 100;
	
	self._stealth.stance_handler[ "alert" ]["looking_towards"][ "stand" ] 	= 1100;
	self._stealth.stance_handler[ "alert" ]["looking_towards"][ "crouch" ] 	= 700;
	self._stealth.stance_handler[ "alert" ]["looking_towards"][ "prone" ] 	= 250;
}