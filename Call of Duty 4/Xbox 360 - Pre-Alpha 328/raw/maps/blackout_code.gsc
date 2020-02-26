#include maps\_hud_util;
#include maps\_utility;
#include maps\_debug;
#include animscripts\utility;
#include maps\_vehicle;
#include maps\blackout;
#include common_scripts\utility;
#include maps\_stealth_logic;
#include maps\_anim;

print3DthreadZip( sMessage )
{
	self notify( "stop_3dprint" );
	self endon( "stop_3dprint" );
	self endon( "death" );

	for ( ;; )
	{
		if ( isdefined( self ) )
			print3d( self.origin + ( 0, 0, 0 ), sMessage, ( 1, 1, 1 ), 1, 0.5 );
		wait( 0.05 );
	}
}



bm21_think( sTargetname )
{
	eVehile = spawn_vehicle_from_targetname( sTargetname );
	eVehile thread bm21_artillery_think();

}

bm21_artillery_think()
{
	self endon( "death" );

	aTargets = [];
	tokens = strtok( self.script_linkto, " " );
	for ( i = 0; i < tokens.size; i ++ )
		aTargets[ aTargets.size ] = getent( tokens[ i ], "script_linkname" );
		
	assertEx( aTargets.size > 1, "Vehicle at position " + self.origin + " needs to scriptLinkTo more than 1 script_origin artillery targets" );
	for ( ;; )
	{
		flag_wait( "bm21s_fire" );
		bm21_fires_until_flagged( aTargets  );
	}
}

bm21_fires_until_flagged( aTargets )
{
	level endon( "bm21s_fire" );
	aTargets = array_randomize( aTargets );

	wait( randomfloatrange( 4, 10 ) );
	
	for ( i = 0;i < aTargets.size;i ++ )
	{
		iTimesToFire = 5 + randomint( 6 );
		for ( i2 = 0;i2 < iTimesToFire;i2 ++ )
		{
			if ( i2 == 0 )
			{
				self setturrettargetent( aTargets[ i ] );
				self waittill( "turret_rotate_stopped" );	
				wait( 1 );	
			}

			self notify( "shoot_target", aTargets[ i ] );
			wait( .25 );
		}
	}
}

die_soon()
{
	self endon( "death" );
	wait( randomfloatrange( 0.5, 1.5 ) );
	self dodamage( self.health + 150, ( 0, 0, 0 ) );
}



second_shack_trigger()
{
	self waittill( "trigger" );
	/*
	axis = getaiarray( "axis" );
	if ( axis.size )
	{
		array_thread( axis, ::die_soon );
		flag_wait( "hut_cleared" );
	}
	*/
	thread chess_guys();
	thread sleepy_shack();
	flag_set( "second_shacks" );
}

sleepy_shack()
{
	shack_guys = getentarray( "shack_guy", "targetname" );
	array_thread( shack_guys, ::spawn_ai );
	
	shack_light = getent( "shack_light", "targetname" );
	intensity = shack_light getLightIntensity();
	shack_light setLightIntensity( 0 );
	
	flag_wait( "second_shacks" );
	flag_wait( "high_alert" );
	wait( 1.5 );
	
	sleep_alert_trigger = getent( "sleep_alert_trigger", "targetname" );
	if ( level.player istouching( sleep_alert_trigger ) )
	{
		// don't flick the lights on if the player is standing in a place that reveals our lack of light flicking animation
		return;
	}
	
	// light flickers on
	/*
	shack_light setLightIntensity( intensity );
	wait( 0.3 );
	shack_light setLightIntensity( 0 );
	wait( 0.01 );
	shack_light setLightIntensity( intensity );
	wait( 0.2 );
	shack_light setLightIntensity( 0 );
	wait( 1 );

	timer = 2;
	timer *= 20;
	
	for ( i = 0; i < timer; i++ )
	{
		new_intensity = intensity * ( 1 / ( timer - i ) );
		new_intensity *= randomfloatrange( 0.3, 1.7 );
		shack_light setLightIntensity( new_intensity );
		wait( 0.05 );
	}
	*/

	timer = 2;
	timer *= 20;
	for ( i = 0; i < timer; i++ )
	{
		new_intensity = intensity * ( 1 / ( timer - i ) );
		new_intensity *= randomfloatrange( 0.3, 1.7 );
		shack_light setLightIntensity( new_intensity );
		wait( 0.05 );
	}
	
	shack_light setLightIntensity( intensity );
}

guy_stops_animating_on_high_alert( node, react_anim, built_in )
{
	self endon( "death" );
//	flag_assert( "high_alert" );
	level waittill( "high_alert" );
	node notify( "stop_loop" );
	
	// animates from elsewhere?
	if ( isdefined( built_in ) )
		return;
	
	if ( isdefined( react_anim ) )
	{
		self anim_generic( self, react_anim );
	}
	else
	{
		self stopanimscripted();
	}
}
	
chess_guys()
{
	level endon( "chess_cleared" );	
	
	guy1 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_1" );
	guy2 = get_guy_with_script_noteworthy_from_spawner( "chess_guy_2" );

	node = getent( "chess_ent", "targetname" );
	
	guy1.animname = "chess_guy1";
	guy2.animname = "chess_guy2";
	
	guys = [];
	guys[ guys.size ] = guy1;
	guys[ guys.size ] = guy2;
	
	array_thread( guys, ::chess_guy_init, node );

	node thread anim_loop( guys, "idle", undefined, "stop_loop" );

	chess_guys_play_chess_until_alert( node, guys );
	
	guys = array_removeDead( guys );
	assert ( guys.size, "Should still be guys alive if chess_cleared hasnt happened" );
	
	node anim_single( guys, "surprise" );
}

chess_guy_init( node )
{
	self.allowdeath = true;
	self thread custom_stealth_ai();
	self thread guy_stops_animating_on_high_alert( node, undefined, true );
}

chess_guys_play_chess_until_alert( node, guys )
{
	level endon( "high_alert" );
	chess_alert_trigger = getent( "chess_alert_trigger", "targetname" );
	
	for ( ;; )
	{
		chess_alert_trigger waittill( "trigger" );
		
		for ( i = 0; i < guys.size; i++ )
		{
			if ( !isalive( guys [ i ] ) )
				continue;
				
			if ( guys[ i ] cansee( level.player ) )
			{
				flag_set( "high_alert" );
				return;
			}
		}
	}
}

descriptions()
{
	descriptions = getentarray( "description", "targetname" );
	for ( i = 0;i < descriptions.size;i ++ )
		descriptions[ i ] thread print3DthreadZip( descriptions[ i ].script_noteworthy );
}


 /* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
    MAIN TOWN START
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * */ 
AA_town_init()
{
	thread bm21_spawn_and_think();
}


bm21_spawn_and_think()
{
	flag_set( "bm21s_fire" );
	aBM21targetnames = [];
	aBM21targetnames[ aBM21targetnames.size ] = "bm21_01";
	aBM21targetnames[ aBM21targetnames.size ] = "bm21_02";
	aBM21targetnames[ aBM21targetnames.size ] = "bm21_03";
//	aBM21targetnames[ 3 ] = "bm21_04";
	
	for ( i = 0;i < aBM21targetnames.size;i ++ )
		thread bm21_think( aBM21targetnames[ i ] );
}


empty( fuk )
{
}

custom_stealth_ai()
{
/*
	alert_functions[1] = ::empty;
	alert_functions[2] = ::empty;
	alert_functions[3] = ::empty;
*/
	
	awareness_functions = [];
	/*
	if ( isdefined( self.stealth_whizby_reaction ) )
	{
		awareness_functions[ "bulletwhizby"	] = ::enemy_awareness_reaction_whizby;
	}
	*/
	
//	awareness_functions[ "explode" ] = ::enemy_hears_explosion;

	alert_functions = [];
//	alert_functions[ "attack" ] = ::enemy_attacks;
	
	
	thread stealth_ai( undefined, alert_functions, undefined, awareness_functions );
}

enemy_attacks( type )
{
	self endon ( "death" );
	self endon( "pain_death" );
	
	self thread maps\_stealth_behavior::enemy_announce_spotted( self.origin );
			
	//might have to link this into enemy_awareness_reaction_attack() at some point
//	self setgoalpos( enemy.origin );
	self.goalradius = 2048;
}

enemy_hears_explosion( type )
{
	anime = "_stealth_behavior_whizby_" + randomint( 5 );	
	
	self ent_flag_set( "_stealth_behavior_first_reaction" );
	self ent_flag_set( "_stealth_behavior_reaction_anim" );
	
	self stopanimscripted();
	self notify( "stop_animmode" );
	self notify( "end_patrol" );
	
	waittillframeend;

	self.allowdeath = true;
	self anim_generic_custom_animmode( self, "gravity", "bored_alert" );

	//self stopanimscripted();
	self ent_flag_clear( "_stealth_behavior_reaction_anim" );
	self.goalradius = 1024;
}

enemy_awareness_reaction_whizby( type )
{
	self endon( "death" );
	
	enemy = self._stealth.logic.event.awareness[ type ];
	
/*
	vec1 = undefined;
	if( isplayer( enemy ) )
		vec1 = anglestoforward( enemy getplayerangles() );
	else
		vec1 = anglestoforward( enemy gettagangles( "tag_flash" ) );
	
	point = enemy.origin + vector_multiply( vec1, distance( enemy.origin, self.origin ) );
	
	vec1 = vectornormalize( point - self.origin );
	vec2 = anglestoright( self.angles );
	
	anime = undefined;
	
	if( vectordot( vec1, vec2 ) > 0 )
		anime = "_stealth_behavior_whizby_right";
	else
		anime = "_stealth_behavior_whizby_left";
*/
	
	if( self ent_flag( "_stealth_behavior_first_reaction" ) )
		return;	
	
	anime = "_stealth_behavior_whizby_" + randomint( 5 );	
	
	self ent_flag_set( "_stealth_behavior_first_reaction" );
	self ent_flag_set( "_stealth_behavior_reaction_anim" );
	
	self stopanimscripted();
	self notify( "stop_animmode" );
	self notify( "end_patrol" );
	
	waittillframeend;

	self.allowdeath = true;
	self anim_generic_custom_animmode( self, "gravity", self.stealth_whizby_reaction );

	//self stopanimscripted();
	self ent_flag_clear( "_stealth_behavior_reaction_anim" );
}


hut_think()
{
	self set_generic_run_anim( "casual_patrol_walk" );
	custom_stealth_ai();
	
	self.disablearrivals = true;
}

pier_trigger_think()
{
	self waittill( "trigger", other );
	
	other.allowdeath = true;

	other thread anim_generic( other, "smoke" );
	other endon( "death" );
	other waittill( "damage" );
	other stopanimscripted();
//	@$e90._stealth.logic.alert_level.lvl
//	bored_alert
//	self stealth_enemy_waittill_alert();
}

no_crouch_or_prone_think()
{
	for ( ;; )
	{
		self waittill( "trigger" );
		while ( level.player istouching( self ) )
		{
			waittillframeend;  // in case the player leaves a trigger while he steps into another. This way this is the last stance setter in the frame
			level.player AllowProne( false );
			level.player AllowCrouch( false );
			wait( 0.05 );
		}
		level.player AllowProne( true );
		level.player AllowCrouch( true );
	}
}

no_prone_think()
{
	for ( ;; )
	{
		self waittill( "trigger" );
		
		waittillframeend;  // in case the player leaves a trigger while he steps into another. This way this is the last stance setter in the frame
		
		level.player AllowProne( false );
		while ( level.player istouching( self ) )
		{
			wait( 0.05 );
		}
		level.player AllowProne( true );
	}
}

reach_and_idle_relative_to_target( reach, idle, react )
{
	targ = getent( self.target, "targetname" );
	targ thread stealth_ai_reach_idle_and_react( self, reach, idle, react );
}

idle_relative_to_target( idle, react )
{
	targ = getent( self.target, "targetname" );
	targ thread stealth_ai_idle_and_react( self, idle, react );
}

hut_sentry()
{
/*
	self set_generic_run_anim( "casual_patrol_walk" );
	self.stealth_whizby_reaction = "bored_alert";
	custom_stealth_ai();
	self.disablearrivals = true;
*/
}

signal_stop()
{
	self waittill( "trigger", other );
	
	// big battle going on
	if ( flag( "high_alert" ) )
		return;

	other handSignal( "stop" );
	
}

bored_guy()
{
	self endon( "death" );
	
	targ = getent( self.target, "targetname" );
	
	targ thread anim_generic_loop( self, "bored_idle", undefined, "stop_idle" );
	flag_wait( "high_alert" );
	targ notify( "stop_idle" );
	self stopanimscripted();
}


hut_tv()
{
	// tv turns off when it gets shot
	
	light = getent( "tv_light", "targetname" );
	light thread maps\_lights::television();
	
	// did the tv get shot?
	wait_for_targetname_trigger( "tv_trigger" );
	
	light notify( "light_off" );
	light setLightIntensity( 0 );
}


friendly_think()
{
	self.baseaccuracy = 3;
	for ( ;; )
	{
		self.ignoreme = true;
		self.ignoreall = true;
		flag_wait( "high_alert" );
		self.ignoreme = false;
		self.ignoreall = false;
		flag_waitopen( "high_alert" );
	}
}

shack_sleeper()
{
	self endon( "death" );
	self thread high_alert_on_death();
	self.allowdeath = true;
	
	chair = spawn_anim_model( "chair" );
	
	thread idle_relative_to_target( "sleep_idle", "sleep_react" );
	targ = getent( self.target, "targetname" );
//	targ thread drawOriginForever();
//	targ thread anim_generic_loop( self, "sleep_idle", undefined, "stop_idle" );
	targ thread anim_first_frame_solo( chair, "chair_react" );

	flag_wait( "high_alert" );
	chair notify( "stop_first_frame" );
//	targ notify( "stop_idle" );
//	targ thread anim_generic( self, "sleep_react" );
	targ thread anim_single_solo( chair, "chair_react" );
	wait( 3.73 * 0.77 );

	self stopanimscripted();
	self notify( "single anim", "end" );
}

high_alert_on_death()
{
	self waittill( "death" );
	flag_set( "_stealth_spotted" );
}

outpost_objectives()
{
	hut_obj_org = getent( "hut_obj_org", "targetname" );
	Objective_Add( 1, "current", "Eliminate the outer guard posts.", hut_obj_org.origin );
	
	flag_wait( "hut_cleared" );
	chess_obj_org = getent( "chess_obj_org", "targetname" );
	objective_position( 1, chess_obj_org.origin );
	
	delaythread( 3, ::hut_friendlies_chats_about_russians );

	flag_wait( "chess_cleared" );
	shack_obj_org = getent( "shack_obj_org", "targetname" );
	objective_position( 1, shack_obj_org.origin );
	
	flag_wait( "shack_cleared" );
	objective_complete( 1 );
	autosave_by_name( "other_huts_cleared" );
	
	field_org = getent( "field_org", "targetname" );
	Objective_Add( 2, "current", "Meet the Russian Loyalists at the field.", field_org.origin );
}

field_russian_think()
{
	self thread magic_bullet_shield();
	self allowedstances( "prone" );	
	self.fixednode = false;
	flag_wait( "russians_stand_up" );
	if ( cointoss() )
		self allowedstances( "stand" );
	else
		self allowedstances( "crouch" );
	
	if ( isdefined( self.script_linkto ) )
	{
		self allowedstances( "stand" );
		path = getent( self.script_linkto, "script_linkname" );
		self.disablearrivals = true;
		self.disableexits = true;
		self maps\_spawner::go_to_node( path, 1 );
		self.disablearrivals = false;
		self.disableexits = false;
	}

	flag_wait( "go_up_hill" );
	self allowedstances( "stand", "crouch", "prone" );
	wait( randomfloatrange( 0.1, 1.7 ) );
	hilltop_delete_node = getnode( "hilltop_delete_node", "targetname" );
	self setgoalnode( hilltop_delete_node );
	self.goalradius = 16;
	self waittill( "goal" );
	self stop_magic_bullet_shield();
	self delete();
	
	// prone_to_stand_1, prone_to_stand_2, prone_to_stand_3
//	self anim_generic( self, "prone_to_stand_" + ( randomint( 3 ) + 1 ) );
}

hilltop_mortar_team( msg )
{
	ent = getent( msg, "targetname" );
	self.goalradius = 16;
	self setgoalpos( ent.origin );
}

russian_leader_think()
{
	level.kamarov = self;
	level.kamarov thread magic_bullet_shield();
}

kamarov()
{
	return level.kamarov.script_friendname;
}

setup_sas_buddies()
{
	level.price = getent( "price", "targetname" );
	level.price.animname = "price";
	level.gaz = getent( "gaz", "targetname" );
	level.gaz.animname = "gaz";
	level.bob = getent( "bob", "targetname" );
	level.bob.animname = "bob";
	
	level.price make_hero();
	level.gaz make_hero();
	level.bob make_hero();
	
	allies = getaiarray( "allies" );
	array_thread( allies, ::sas_main_think );
}

sas_main_think()
{
	self ent_flag_init( "rappelled" );
	thread magic_bullet_shield();
	
	if ( !flag( "go_up_hill" ) )
	{
		enable_cqbwalk();
	
		flag_wait( "go_up_hill" );	
		disable_cqbwalk();
		wait( randomfloat( 3, 4 ) );
		hilltop_friendly_orgs = getentarray( "hilltop_friendly_org", "targetname" );
		
		
		for ( i = 0; i < hilltop_friendly_orgs.size; i++ )
		{
			if ( !isdefined( hilltop_friendly_orgs[ i ].used ) )
			{
				hilltop_friendly_orgs[ i ].used = true;
				self setgoalpos( hilltop_friendly_orgs[ i ].origin );
				self.goalradius = 16;
				break;
			}
		}
	}
	
	self notify( "stop_going_to_node" );

	if ( !flag( "go_to_overlook" ) )
	{
		flag_wait( "go_to_overlook" );
	
		nodes = [];
		nodes[ "price" ] = "price_overlook_node";
		nodes[ "gaz" ] = "gaz_overlook_node";
		nodes[ "bob" ] = "bob_overlook_node";
		node = getnode( nodes[ self.animname ], "targetname" );
		
		self setgoalnode( node );
		self.goalradius = 16;
		
		if ( self == level.price )
		{
			flag_wait( "over_here" );
			flag_wait( "player_near_overlook" );
			
			// Sniper team in position. Gaz, cover the left flank.                                                
			level.price dialogue_queue( "in_position" );

			// Roger. Covering left flank.                                                                       
			level.gaz dialogue_queue( "cover_left_flank" );
		}
	}
	
	if ( !flag( "overlook_attack_begins" ) )
	{
		self.ignoreall = true;
		self.ignoreme = true;
		flag_wait( "overlook_attack_begins" );
		self.ignoreall = false;
	}

	if ( !flag( "power_plant_cleared" ) )
	{
		flag_wait( "power_plant_cleared" );
		
		if ( !self ent_flag( "rappelled" ) )
		{
			if ( self == level.price )
			{
				// Tangos neutralized! All clear!                                                                     
				level.gaz dialogue_queue( "tangos_neutralized" );
				
				// Soap, get to the edge of the cliff and cover Kamarov's men! Move!                                
				level.price dialogue_queue( "cover_cliff" );
			}
			
			self set_force_color( "g" );
			self.ignoreme = true;
	
			flag_wait( "head_to_rappel_spot" );

			self set_force_color( "p" );
			self.ignoreall = true;
			self ent_flag_wait( "rappelled" );
			self.ignoreall = false;
		}
	}

	self set_force_color( "r" );
	flag_wait( "rpg_guy_attacks_bm21s" );
	self set_force_color( "o" );
}


blackout_stealth_settings()
{
	//these values represent the BASE huristic for max visible distance base meaning 
	//when the character is completely still and not turning or moving
	//HIDDEN is self explanatory
	hidden = [];
	hidden[ "prone" ]	= 70;
	hidden[ "crouch" ]	= 260;
	hidden[ "stand" ]	= 380;
	
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
	
	stealth_detect_ranges_set( hidden, alert, spotted );
}


spawn_idler_with_targetname( targetname, anime )
{
	guy = get_guy_with_targetname_from_spawner( targetname );
	guy thread idle_until_detection( anime );
}

spawn_idler_with_script_noteworthy( script_noteworthy, anime )
{
	guy = get_guy_with_script_noteworthy_from_spawner( script_noteworthy );
	guy thread idle_until_detection( anime );
}

idle_until_detection( anime )
{
	self thread custom_stealth_ai();

	targ = getent( self.target, "targetname" );
	targ thread anim_generic_loop( self, anime );
	self endon( "death" );

	self stealth_enemy_waittill_alert();
	self stopanimscripted();
	targ notify( "stop_loop" );
	
	flag_wait( "_stealth_found_corpse" );
	wait( 1 );
	flag_set( "high_alert" );
}

setup_player()
{
	level.player thread stealth_ai();
	level.player._stealth_move_detection_cap = 100;
}


hilltop_sniper()
{
	guys = get_guys_with_targetname_from_spawner( "hilltop_sniper" );
	array_thread( guys, ::hilltop_sniper_moves_in );
	array_thread( guys, ::ground_allied_forces );
}

hilltop_sniper_moves_in()
{
	self endon( "death" );
	self.ignoreall = true;
	self.ignoreme = true;
	
//	wait_for_targetname_trigger( "prone_trigger" );
//	self thread anim_custommode( self, "prone_dive" );
	
	
	targ = getent( self.target, "targetname" );
	
	targ anim_generic_reach( self, "prone_dive" );
	self allowedstances( "prone" );
	targ thread anim_generic_custom_animmode( self, "gravity", "prone_dive" );
	wait( 1.2 );
	self notify( "stop_animmode" );
	
	targ = getnode( targ.target, "targetname" );
	
	self setgoalpos( targ.origin );
	self.goalradius = 32;

	flag_wait( "overlook_attack_begins" );
	self allowedstances( "prone", "crouch" );
	
	self.ignoreall = false;
	self.ignoreme = false;
}

hut_cleared()
{
	flag_wait( "hut_guys" );
	flag_wait( "pier_guys" );
	flag_set( "hut_cleared" );
}


set_high_alert()
{
	for ( ;; )
	{
		level waittill( "_stealth_spotted" );
		if ( flag( "_stealth_spotted" ) )
		{
			flag_set( "high_alert" );
		}
		else
		{
			flag_clear( "high_alert" );
		}
	}	
}

overlook_runner_think()
{
	self endon( "death" );
	overlook_enemy_waits_for_player();
	overlook_enemy_leaves_stealth();
}

street_walker_think()
{
	self endon( "death" );
	overlook_enemy_waits_for_player();
	// ends when stealth is broken
	maps\_patrol::patrol( self.target );
	overlook_enemy_leaves_stealth();
}

overlook_enemy_waits_for_player()
{
	self thread custom_stealth_ai();
	flag_wait( "player_at_overlook" );
}
	
overlook_enemy_leaves_stealth()
{

	flag_wait( "_stealth_spotted" );
	
	
//	if ( !isdefined( level.attention_getter ) )
	{
		level.attention_getter = true;
		overlook_attention = getent( "overlook_attention", "targetname" );
		self setgoalpos( overlook_attention.origin );
		self.goalradius = overlook_attention.radius;
		self waittill( "goal" );
		if ( !flag( "overlook_attention" ) )
		{
			flag_set( "overlook_attention" );
			wait( 3 );
		}
	}

	set_goalpos_and_volume_from_targetname( "enemy_overlook_defense" );
}

breach_first_building()
{
	breach_guys = get_guys_with_targetname_from_spawner( "breach_spawner" );
	/*
	breach_guys = [];
	breach_guys[ breach_guys.size ] = get_closest_colored_friendly( "c" );
	breach_guys[ breach_guys.size ] = get_closest_colored_friendly( "b" );
	*/
	
	for ( i = 0; i < breach_guys.size; i++ )
	{
		spawn_failed( breach_guys[ i ] );
	}
	
	array_thread( breach_guys, ::pre_breach );

	first_house_breach_volume = getent( "first_breach_volume", "targetname" );
	first_house_breach_volume maps\_breach::breach_think( breach_guys, "explosive_breach_left" );
	
	array_thread( breach_guys, ::post_breach );
	flag_set( "breach_complete" );
}

pre_breach()
{
	self thread magic_bullet_shield();
	self.ignoreall = true;
	self.ignoreme = true;
}

post_breach()
{
	self stop_magic_bullet_shield();
//	self enable_ai_color();
	self.ignoreall = false;
	self.ignoreme = false;
	self delete();
}

spawn_replacement_baddies()
{
	level endon( "cliff_fighting" );
	count = 10;
	spawners = getentarray( "enemy_reinforce_spawner", "targetname" );
	
	spawners = array_randomize( spawners );
	array_thread( spawners, ::add_spawn_function, ::fall_back_to_defensive_position );

	index = 0;	
	for ( ;; )
	{
		axis = getaiarray( "axis" );
		if ( axis.size > 10 )
		{
			wait( 1 );
			continue;
		}

		spawner = spawners[ index ];
		spawner.count = 1;
		spawner spawn_ai();
		index++;
		if ( index >= spawners.size )
			index = 0;

		wait( 0.5 );
	}
}

fall_back_to_defensive_position()
{
	self endon( "death" );
	
	if ( !flag( "mgs_cleared" ) )
	{
		set_goalpos_and_volume_from_targetname( "enemy_overlook_defense" );
		flag_wait( "mgs_cleared" );
	}
	
	if ( !flag( "player_reaches_cliff_area" ) )
	{
		set_goalpos_and_volume_from_targetname( "enemy_first_defense" );
		flag_wait( "player_reaches_cliff_area" );
	}
	
	defend_second_area();
}

teleport_and_take_node_by_targetname( targetname )
{
	nodes = getnodearray( targetname, "targetname" );
	for ( i = 0; i < nodes.size; i++ )
	{
		node = nodes[ i ];
		if ( isdefined( node.taken ) )
			continue;
		node.taken = true;
		self teleport( node.origin );
		self.goalradius = 32;
		self setgoalnode( node );
		return;
	}
}

set_flag_on_player_damage( msg )
{
	flag_assert( msg );
	level endon( msg );
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "damage", amt, entity, enemy_org, impact_org );
		if ( !isalive( entity ) )
			continue;
		if ( entity != level.player )
			continue;
		
		thread set_flag_and_die( msg, impact_org );
	}
}

set_flag_and_die( msg, impact_org )
{
	flag_set( msg );
	self dodamage( self.health + 150, impact_org );
}

ground_allied_forces()
{
	self endon( "death" );
	if ( !flag( "breach_complete" ) )
	{
		flag_wait( "breach_complete" );
		wait( 0.1 );	// if we disable color the guys dont respawn so we just overwrite color by setting the new goal position
		
		set_goalpos_and_volume_from_targetname( "ally_first_offense" );
		self.ranit = true;
	}

	if ( !flag( "player_reaches_cliff_area" ) )
	{
		flag_wait( "player_reaches_cliff_area" );
		self set_force_color( "c" );
		teleport_and_take_node_by_targetname( "ally_cliff_start_node" );
		self.baseaccuracy = 0;
	}
	
	if ( !flag( "cliff_look" ) )
	{
		self set_force_color( "c" );
		self thread deletable_magic_bullet_shield();
		flag_wait( "cliff_look" );
		self stop_magic_bullet_shield();
	}

	if ( !flag( "cliff_moveup" ) )
	{
		self set_force_color( "c" );
		if ( issubstr( self.classname, "_AT_" ) )
		{
			thread rocket_guy_targets_bmp();
		}
		
		flag_wait( "cliff_moveup" );	
	
//		wait( 0.1 );	// if we disable color the guys dont respawn so we just overwrite color by setting the new goal position

//		set_goalpos_and_volume_from_targetname( "ally_second_attack" );
		
		flag_wait( "cliff_complete" );
	}

	self disable_ai_color();

	self notify( "disable_reinforcement" );
	cliff_remove_node = getnode( "cliff_remove_node", "targetname" );
	self setgoalnode( cliff_remove_node );
	self.goalradius = 32;
	self waittill( "goal" );
	self delete();
}

rocket_guy_targets_bmp()
{
	self endon( "death" );
	// they both continue on from the same flag
	if ( !isalive( level.enemy_bmp ) )
		waittillframeend;
	if ( !isalive( level.enemy_bmp ) )
		return;
		
	self setentitytarget( level.enemy_bmp, 0.6 );
	level.enemy_bmp waittill( "death" );
	self clearentitytarget();
}

set_goalpos_and_volume_from_targetname( targetname )
{
	org = getent( targetname, "targetname" );
	volume = getent( org.target, "targetname" );
	
	self.fixednode = false;
	self.goalheight = 512;
//	self disable_ai_color();
	
	self allowedstances( "stand", "prone", "crouch" );	
	self setgoalpos( org.origin );
	self.goalradius = org.radius;
	self setgoalvolume( volume );
}

turn_off_stealth()
{
	// end of stealth for the level
	level waittill( "_stealth_spotted" );
	level notify( "_stealth_stop_stealth_logic" );
}

blackout_guy_leaves_ignore( guy )
{
	guy endon( "death" );
	self waittill( "trigger" );
	guy.ignoreme = false;
}

blackout_guy_animates( noteworthy, anime, theflag, timer )
{
	if ( !isdefined( level.flag[ theflag ] ) )
		flag_init( theflag );
	
	guy = get_guy_with_script_noteworthy_from_spawner( noteworthy );
	guy endon( "death" );
	targ = getent( guy.target, "targetname" );
	guy set_generic_deathanim( anime + "_death" );

	guy.ignoreme = true;
	if ( isdefined( guy.script_linkto ) )
	{
		toks = strtok( guy.script_linkto, " " );
		for ( i = 0; i < toks.size; i++ )
		{
			// links to the trigger that forces ignore off
			trig = getent( toks[ i ], "script_linkname" );
			if ( !isdefined( trig ) )
				continue;
			trig thread blackout_guy_leaves_ignore( guy );
		}
	}
	
	guy.allowdeath = true;
	guy.health = 1;

	targ thread anim_generic_first_frame( guy, anime );
	flag_wait( theflag );
	targ thread anim_generic( guy, anime );
	wait( timer );
	guy.ignoreme = false;
}

blackout_guy_animates_loop( noteworthy, anime, theflag )
{	
	guy = get_guy_with_script_noteworthy_from_spawner( noteworthy );
	guy endon( "death" );
	targ = getent( guy.target, "targetname" );
	guy set_generic_deathanim( anime + "_death" );

	guy.ignoreme = true;
	if ( isdefined( guy.script_linkto ) )
	{
		// links to the trigger that forces ignore off
		trig = getent( guy.script_linkto, "script_linkname" );
		trig thread blackout_guy_leaves_ignore( guy );
	}
		
	guy.allowdeath = true;
	guy.health = 1;

	targ thread anim_generic_loop( guy, anime );
	level waittill( "price_aims_at" + theflag );
	
	level.price waittill( "goal" );
	wait( 2.2 );
	guy.ignoreme = false;
}

blackout_door_guy()
{
	guy = get_guy_with_script_noteworthy_from_spawner( "door_spawner" );
	guy.animname = "doorguy";
	guy endon( "death" );
	targ = getent( guy.target, "targetname" );
	door = spawn_anim_model( "door" );
	
	guy set_deathanim( "death_2" );
	guy.allowdeath = true;
	guy.a.nodeath = true;
	guy.health = 1000;
	guy.ignoreme = true;

	guys = [];
	guys[ guys.size ] = door;
	guys[ guys.size ] = guy;
	
	thread blackout_door_death( door, targ, guy );

	targ thread anim_loop( guys, "idle" );
	flag_wait( "turned_corner" );

	targ notify( "stop_loop" );
//	targ anim_single( guys, "open" );
	targ anim_single( guys, "close" );
//	wait( 0.2 );
//	targ anim_single( guys, "fire_1" );
//	targ anim_single( guys, "fire_2" );
	targ thread anim_single( guys, "fire_3" );
	wait( 0.05 ); // or the animtime comes too soon
	guy setanimtime( guy getanim( "fire_3" ), 0.4 );
	door setanimtime( door getanim( "fire_3" ), 0.4 );
	targ waittill( "fire_3" );
	targ anim_single( guys, "fire_3" );
	targ thread anim_loop( guys, "idle" );

	wait( 1 );
	guy.ignoreme = false;	
}

blackout_door_death( door, targ, guy )
{
	guy waittill( "damage" );
	guys = [];
	guys[ guys.size ] = door;
	guys[ guys.size ] = guy;
	targ thread anim_single( guys, "death_2" );
	wait( 0.5 );
	guy dodamage( guy.health + 150, (0,0,0) );
}

price_hunts_house()
{
//	level.price thread price_attack_hunt();
	flags = [];
	flags[ flags.size ] = "lightswitch";
	flags[ flags.size ] = "wall";
	flags[ flags.size ] = "corner";
	flags[ flags.size ] = "hide";
	flags[ flags.size ] = "door";

	level.price.goalradius = 16;	
	node = getnode( "blackout_chain", "targetname" );
	level.price setgoalnode( node );

	level.price thread price_checks_goal_for_noteworthy();
	
	for ( i = 0; i < flags.size - 1; i++ )
	{
		thread price_cqb_aims_at_target( flags[ i ] );
		flag_wait( flags[ i ] );
		
		if ( !isdefined( node.target ) )
			break;
			
		node = getnode( node.target, "targetname" );
		level.price setgoalnode( node );
	}
	
	level.price set_force_color( "r" );
}

price_checks_goal_for_noteworthy()
{
	self endon( "stop_checking_node_noteworthy" );
	used = [];
	
	for ( ;; )
	{
		self waittill( "goal" );
		while ( !isdefined( self.node ) )
		{
			wait( 0.05 );
		}
		
		node = self.node;
		if ( isdefined( used[ node.origin + "" ] ) )
			continue;
		used[ node.origin + "" ] = true;
		
		if ( distance( node.origin, self.origin ) > self.goalradius )
			continue;
		
		if ( !isdefined( node.script_noteworthy ) )
			continue;

		if ( node.script_noteworthy == "signal_moveup" )
		{
			threadCQB_stand_signal_move_up = getent( "CQB_stand_signal_move_up", "targetname" );
			price_signals_moveup();
		}
	}
}

price_signals_moveup()
{
	while ( isalive( level.price.enemy ) )
		wait( 0.05 );
		
	level.price handsignal( "moveup", "enemy" );
}

price_cqb_aims_at_target( deathflag )
{
	level notify( "price_gets_new_cqb_targ" );
	level endon( "price_gets_new_cqb_targ" );
	for ( ;; )
	{
		if ( deathflag == "hide" )
		{
			special = getent( "hide_target", "targetname" );
			level.price cqb_aim( special );
			level notify( "price_aims_at" + deathflag );
			wait( 0.05 );
			continue;
		}
		
		keys = getarraykeys( level.deathflags[ deathflag ][ "ai" ] );
		if ( keys.size )
		{
			level.price cqb_aim( level.deathflags[ deathflag ][ "ai" ][ keys[ 0 ] ] );
			level notify( "price_aims_at" + deathflag );
			return;
		}
		wait( 0.05 );
	}
}

price_attack_hunt()
{
	for ( ;; )
	{
		self.noshoot = true;
		if ( !isalive( self.enemy ) )
		{
			wait( 0.05 );
			continue;
		}
		
		if ( !isdefined( self.enemy.dont_hit_me ) )
		{
			self.noshoot = undefined;
		}
		else
		{
			assertex( self.enemy.dont_hit_me, ".dont_hit_me has to be true or undefined" );
		}
		wait( 0.05 );
	}
}


spawn_replacement_cliff_baddies()
{
	level endon( "cliff_complete" );

	count = 10;
	spawners = getentarray( "later_spawner", "targetname" );
	
	spawners = array_randomize( spawners );
	array_thread( spawners, ::add_spawn_function, ::defend_second_area );

	index = 0;	
	for ( ;; )
	{
		axis = getaiarray( "axis" );
		if ( axis.size > 10 )
		{
			wait( 1 );
			continue;
		}

		spawner = spawners[ index ];
		spawner.count = 1;
		spawner spawn_ai();
		index++;
		if ( index >= spawners.size )
			index = 0;

		wait( 0.5 );
	}
}

defend_second_area()
{
	self endon( "death" );
	teleport_and_take_node_by_targetname( "enemy_cliff_start_node" );
	if ( !flag( "cliff_look" ) )
	{
		self.health = 50000;
		thread set_flag_on_player_damage( "cliff_look" );
		flag_wait( "cliff_look" );
		self.health = 100;
	}
	thread track_defender_deaths();

	self.baseaccuracy = 0;
	flag_wait( "cliff_moveup" );
	set_goalpos_and_volume_from_targetname( "enemy_cliff_defense" );
	
	flag_wait( "cliff_complete" );
	cliff_enemy_delete_org = getent( "cliff_enemy_delete_org", "targetname" );
	self setgoalpos( cliff_enemy_delete_org.origin );
	self.goalradius = 32;
	self waittill( "goal" );
	self delete();
}

roof_spawner_think()
{
	self.ignoreme = true;
}

track_defender_deaths()
{
	self waittill( "death" );
	level.defenders_killed++;
	if ( level.defenders_killed >= 3 )
		flag_set( "cliff_moveup" );
}

power_plant_spawner()
{
	self endon( "death" );
	self setgoalpos( self.origin );
	self.goalradius = 64;
	flag_wait( "player_reaches_cliff_area" );

	node = getnode( "power_plant_fight_node", "targetname" );
	self setgoalnode( node );
	self.goalradius = 2048;	
}

killme()
{
	self dodamage( self.health + 100, (0,0,0) );
}

overlook_turret_think()
{
	// a function the AI runs when they try to use a turret
	self.turret_function = set_turret_manual();
	self endon( "death" );
	self.ignoreme = true;
	delaythread( 32, ::set_ignoreme, false );
	delaythread( randomfloatrange( 50, 55 ), ::killme );
	
	mg_overlook_targets = getentarray( "mg_overlook_target", "targetname" );
	
	for ( ;; )
	{
		self setentitytarget( random( mg_overlook_targets ) );
		wait( randomfloatrange( 1, 2 ) );
	}
}

set_turret_manual( turret )
{
//	turret setmode( "manual_ai" );
}

power_plant_org()
{
	power_plant = getent( "power_plant", "targetname" );
	return power_plant.origin;
}

cliff_org()
{
	cliff_org = getent( "cliff_org", "targetname" );
	return cliff_org.origin;
}



overlook_player_mortarvision()
{
	level endon( "mgs_cleared" );
	// cause a mortar to go off if the player looks near an AI that is near certain spots set up in createfx
	orgs = [];
	
	ent = undefined;	
	for ( i = 0; i < level.createfxent.size; i++ )
	{
		if ( !isdefined( level.createfxent[ i ].v[ "exploder" ] ) )
			continue;
			
		if ( level.createfxent[ i ].v[ "exploder" ] != 70 )
			continue;

		ent = level.createfxent[ i ];
	
		neworg = spawnstruct();
		neworg.origin = ent.v[ "origin" ];
		
		orgs[ orgs.size ] = neworg;
	}
	
	
	flag_wait( "overlook_attack_begins" );
	wait( 5 );
	
	last_mortar_point = undefined;

	for ( ;; )
	{
		wait_for_player_to_ads_for_time( 1.5 );
		
		for ( ;; )
		{
			wait( 0.5 );
			if ( !player_is_ads() )
				break;
				
			ai = getaiarray( "axis" );
			
			eye = level.player geteye();
			angles = level.player getplayerangles();
			
			forward = anglestoforward( angles );
			end = eye + vectorScale( forward, 5000 );
			trace = bullettrace( eye, end, true, level.player );
			viewpoint = trace[ "position" ];
			
			guy = getclosest( viewpoint, ai, 500 );
			if ( !isdefined( guy ) )
				continue;
			
			mortar_point = getclosest( guy.origin, orgs, 500 );
			
			if ( !isdefined( mortar_point ) )
				continue;
		
			if ( isdefined( last_mortar_point ) )
			{
				// dont have the same one go off twice
				if ( mortar_point == last_mortar_point )
					continue;
			}	
			
			last_mortar_point = mortar_point;
			// move one of the exploders there and set it off
			ent.v[ "origin" ] = mortar_point.origin;
			ent activate_individual_exploder();
			wait( randomfloat( 8, 12 ) );
		}
	}
}

wait_for_player_to_ads_for_time( timer )
{
	ads_timer = gettime();

	for ( ;; )
	{
		if ( player_is_ads() )
		{
			if ( gettime() > ads_timer + timer )
				return;
		}
		else
		{
			ads_timer = gettime();
		}
		
		wait( 0.05 );
	}
}

player_is_ads()
{
	return level.player PlayerAds() > 0.5;
}

physics_launch_think()
{
	self hide();
	self setcandamage( true );
	for ( ;; )
	{
		self waittill( "damage", one, entity, three, four, five, six, seven );
		if ( !isdefined( entity ) )
			continue;
		if ( !isdefined( entity.model ) )
			continue;
		if ( !issubstr( entity.model, "vehicle" ) )
			continue;
		break;
	}		

			
	targ = getent( self.target, "targetname" );
	
	org = targ.origin;
//	vel = distance( self.origin, targ.origin );
	vel = targ.origin - self.origin;
	vel = vectorscale( vel, 100 );
	
	model = spawn( "script_model", (0,0,0) );
	model.angles = self.angles;
	model.origin = self.origin;
	model setmodel( self.model );
	model physicslaunch( model.origin, vel );
	self delete();
}

ally_rappels( msg, timer )
{
	node = getnode( msg, "targetname" );
	
	rope = spawn_anim_model( "rope" );
	node thread anim_first_frame_solo( rope, "rappel_start" );
	
	node anim_generic_reach( self, "rappel_start" );
	
	if ( !flag( "player_rappels" ) )
	{
		flag_wait( "player_at_rappel" );
	}

	guys = [];
	guys[ guys.size ] = self;
	guys[ guys.size ] = rope;

	node thread anim_single_solo( rope, "rappel_start" );
	node anim_generic( self, "rappel_start" );
	
	if ( !flag( "player_rappels" ) )
	{
		node thread anim_loop_solo( rope, "rappel_idle" );
		node thread anim_generic_loop( self, "rappel_idle" );
		flag_wait( "player_rappels" );
		wait( timer );
		node notify( "stop_loop" );
	}

	node thread anim_single_solo( rope, "rappel_end" );
	node anim_generic( self, "rappel_end" );
	self ent_flag_set( "rappelled" );
}

player_rappel_think()
{
	/*
	level.price thread ally_rappels( "ally1_rappel_node", 0.3 );
	level.gaz thread ally_rappels( "ally2_rappel_node", 0 );
	level.bob thread ally_rappels( "ally3_rappel_node", 0.9 );
	*/
	

	node = getnode( "player_rappel_node", "targetname" );
//	node.origin = node.origin + (0,0,64 );
	
	rope = spawn_anim_model( "player_rope" );
	node thread anim_first_frame_solo( rope, "rappel_for_player" );

	// this is the model the player will attach to for the rappel sequence
	model = spawn_anim_model( "player_rappel" );
	model hide();
	
	// put the model in the first frame so the tags are in the right place
	node anim_first_frame_solo( model, "rappel" );

	rappel_trigger = getent( "player_rappel_trigger", "targetname" );
	rappel_trigger trigger_on();
	rappel_trigger sethintstring( "Hold &&1 to rappel" );
	rappel_trigger waittill( "trigger" );	
	rappel_trigger delete();
	
	flag_set( "player_rappels" );
	
	level.player disableweapons();
	
	// this smoothly hooks the player up to the animating tag
	model lerp_player_view_to_tag( "tag_player", 0.5, 0.9, 35, 35, 45, 0 );

	// now animate the tag and then unlink the player when the animation ends
	node thread anim_single_solo( model, "rappel" );
	node thread anim_single_solo( rope, "rappel_for_player" );
	node waittill( "rappel" );
	level.player unlink();
	level.player enableweapons();
}


rappel_test()
{
	level.price = getent( "price", "targetname" );
	level.price.animname = "price";
	
	node = getent( "rappel_org", "targetname" );
	
	level.player setorigin( node.origin + (0,0,-27000) );
	level.price teleport( node.origin );
	level.player setorigin( node.origin );
	
	rope = spawn_anim_model( "rope" );
	node thread anim_first_frame_solo( rope, "rappel_start" );
	
	guys = [];
	guys[ guys.size ] = level.price;
	guys[ guys.size ] = rope;

	for ( ;; )
	{
		node anim_single( guys, "rappel_start" );
		node anim_single( guys, "rappel_end" );
	}
}

cliff_bm21_blows_up()
{
	flag_wait( "saw_first_bm21" );
	bm21_03 = getent( "bm21_03", "targetname" );
	radiusdamage( bm21_03.origin, 250, 5000, 2500 );
}

farm_rpg_guy_attacks_bm21s()
{
	self thread magic_bullet_shield();
	self.ignoreme = true;
	self.IgnoreRandomBulletDamage = true;
	self waittill( "goal" );
	
	underground_bm21_target = getent( "underground_bm21_target", "targetname" );
	// aim underground so he doesnt shoot too soon
	self setentitytarget( underground_bm21_target );
	
	flag_wait( "rpg_guy_attacks_bm21s" );
	self.a.rockets = 5000;
	bm21_01 = getent( "bm21_01", "targetname" );
	/#
	if ( isalive( bm21_01 ) && !self cansee( bm21_01 ) )
	{
		// in case of mymapents
		radiusdamage( bm21_01.origin, 250, 5000, 2500 );
	}
	#/
	
	if ( isalive( bm21_01 ) )
	{
		self setentitytarget( bm21_01 );
		attractor = Missile_CreateAttractorOrigin( bm21_01.origin + (0,0,50 ), 5000, 500 );
		bm21_01.health = 500;
		bm21_01 waittill( "death" );
		Missile_DeleteAttractor( attractor );
	}

	bm21_02 = getent( "bm21_02", "targetname" );

	/#
	if ( isalive( bm21_02 ) && !self cansee( bm21_02 ) )
	{
		// in case of mymapents
		radiusdamage( bm21_02.origin, 250, 5000, 2500 );
	}
	#/
	
	if ( isalive( bm21_02 ) )
	{
		self setentitytarget( bm21_02 );
		attractor = Missile_CreateAttractorOrigin( bm21_02.origin + (0,0,50 ), 5000, 500 );
		bm21_02.health = 500;
		bm21_02 waittill( "death" );
		Missile_DeleteAttractor( attractor );
	}
	
	self.IgnoreRandomBulletDamage = false;
	self.ignoreme = false;
	self stop_magic_bullet_shield();
	self.a.rockets = 1;
	self.goalradius = 2048;
}

rappel_org()
{
	player_rappel = getent( "player_rappel", "targetname" );
	return player_rappel.origin;
}

prep_for_rappel_think()
{
	// makes friendlies rappel when they touch the trigger
	
	used = [];
	used[ 1 ] = false;
	used[ 2 ] = false;
	used[ 3 ] = false;
	
	timer[ 1 ] = 0.4;
	timer[ 2 ] = 0.8;
	timer[ 3 ] = 1.3;
	
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( isdefined( other.rappelling ) )
			continue;
			
		other.rappelling = true;
		
		for ( i = 1; i <= 3; i++ )
		{
			if ( !used[ i ] )
			{
				other thread ally_rappels( "ally" + i + "_rappel_node", timer[ i ] );
				used[ i ] = true;
				break;
			}
		}
	}
}

hut_friendlies_chats_about_russians()
{
	// The Loyalists are expecting us half a klick to the north. Move out.
	level.price dialogue_queue( "expecting_us" );

	// Loyalists eh? Are those are the good Russians or the bad Russians?                              
	level.gaz dialogue_queue( "loyalists_eh" );
	
	// Well, they won't shoot at us on sight, if that's what you're asking.                               
	level.price dialogue_queue( "wont_shoot_us" );

	// That's good enough for me sir.                                                                   
	level.gaz dialogue_queue( "good_enough" );

	autosave_by_name( "hut_cleared" );
}

price_tells_player_to_come_over()
{
	flag_wait( "over_here" );
	level endon( "breach_complete" );
	flag_assert( "breach_complete" );
	
	for ( ;; )
	{
		if ( flag( "player_near_overlook" ) )
			break;

		// Soap, over here.                                                                                    
		level.price dialogue_queue( "over_here" );
		wait( randomfloatrange( 5, 8 ) );
	}
}

overlook_price_tells_you_to_shoot_mgs()
{
	level endon( "mgs_cleared" );
	flag_assert( "mgs_cleared" );
	wait( 8 );
	
	// Soap! Hit those machine gunners in the windows!                         
	// Soap, take out the machine gunners in the windows so Kamarov's men can storm the building!          
	level.price dialogue_queue( "machine_gunners_in_windows" );
}

clear_target_radius()
{
	// kill all the baddies in the targetted radius
	self waittill( "trigger" );
	org = getent( self.target, "targetname" );
	
	ai = getaispeciesarray( "axis", "all" );
	array_thread( ai, ::die_if_near, org );
}

die_if_near( org )
{
	if ( distance( self.origin, org.origin ) > org.radius )
		return;

	self dodamage( self.health + 150, (0,0,0) );
}

price_finishes_farm()
{
	for ( ;; )
	{
		self waittill( "trigger", other );
		if ( !isalive( other ) )
			continue;
		if ( other != level.price )
		{
			other thread ignore_triggers( 1.0 );
			continue;
		}
		break;
	}
	
	flag_set( "farm_complete" );
}

informant_org()
{
	informant_org = getent( "informant_org", "targetname" );
	
	if ( !flag( "farm_complete" ) )
	{
		return informant_org.origin;	
	}

	// discovered he's not there!	
	informant_org = getent( informant_org.target, "targetname" );
	return informant_org.origin;	
}