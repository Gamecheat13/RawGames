#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_specialops;
#include maps\_so_code;
#include maps\_so_war_support;

#insert raw\maps\_utility.gsh;

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ally_squad_manager movement position defines
#define CONST_SQUAD_POSITION_NORTH		0
#define CONST_SQUAD_POSITION_WEST	 	1
#define CONST_SQUAD_POSITION_SOUTH	 	2
#define CONST_SQUAD_POSITION_EAST 		3
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// war_waves.csv table column defines - WAVE INFO
#define TABLE_WAVE					1 	//wave num
#define TABLE_DELAY 				2	// WAVE SPAWN DELAY
#define TABLE_NEXTWAVE_THRESHOLD 	3	// Minimum AI left before next wave starts
#define TABLE_SQUAD_TYPE 			4	// Squad AI type ref
#define TABLE_SQUAD_SIZE 			5	// Number of squad AIs total
#define TABLE_SPECIAL 				6	// Special AI type
#define TABLE_SPECIAL_NUM			7	// Number of special AIs
#define TABLE_BOSS_AI 				8	// Boss AIs, separated by spaces
#define TABLE_BOSS_DELAY 			9	// "1" = boss spawn immediately, "0" = boss spawns at wave aggression (end of wave)
#define TABLE_BOSS_NONAI 			10	// Boss Chopper/etc...
#define TABLE_REPEAT 				11	// Wave repeating, if 1, will endlessly repeat
#define TABLE_MINIMUM_POPULATIION 	12	// If set, the min population is set, causing wave to never end.	
#define TABLE_USER_DEFINED 			13	// user defined parameter, used in various game types to help ident data
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// war_waves.csv table column defines - AI INFO
#define TABLE_AI_REF 				1	// AI type ref
#define TABLE_AI_NAME 				2	// String name of AI
#define TABLE_AI_DESC 				3	// String description of the AI
#define TABLE_AI_CLASSNAME 			4	// Classname of the character without weapon
#define TABLE_AI_CLASSTYPE 			5	// Class of this AI type with all the attributes (weapons, health, etc)
#define TABLE_AI_BOSS 				6	// Boss flag
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//misc wave/ai related defines
#define TABLE_WAVE_DEF_INDEX_START 	0	// First index for AI Waves
#define TABLE_WAVE_DEF_INDEX_END 	25	// First index for AI Waves
#define TABLE_AI_TYPE_INDEX_START 	100	// First index for AI Type Table
#define TABLE_AI_TYPE_INDEX_END 	120	// Last index for AI Type Table
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// CONST DEFINES
	// Tweakables: Generic
#define CONST_WEAPON_DROP_RATE				1	// 0.0-1.0 rate of weapon drop when dead
#define CONST_AI_UPDATE_DELAY				4.0	// General AI update delay passed to manage_ai_relative_to_player()
#define CONST_AI_SEARCH_PLAYER_TIME			6.0	// Amount of time an ai will pole to see if it has reached the player before giving up
#define CONST_LONG_DEATH_REMOVE_DIST_MIN	540	// Min distance the closest player needs to be to allow long death force kill


	// Tweakables: Player Closest Node Tracker
#define CONST_NODE_CLOSEST_RADIUS_MIN			1		// Check for nodes closest to player greater than this distance away
#define CONST_NODE_CLOSEST_RADIUS_MAX			128		// Check for nodes closest to player less than this distance away
#define CONST_NODE_CLOSEST_RADIUS_INCREASE		64		// If a closest node check fails to find a node, increase the radius by this amount and try again
#define CONST_NODE_CLOSEST_RADIUS_INVALID		2048	// The radius max for the check for nodes should never get this big.
#define CONST_NODE_CLOSEST_HEIGHT				512		// Check for nodes closest to player within this height distance away
#define CONST_NODE_CLOSEST_HEIGHT_INCREASE		128		// If a closest node check fails to find a node, increase the height by this amount and try again


#define CONST_REGULAR_GOAL_RADIUS_DEFAULT		900
#define CONST_REGULAR_GOAL_RADIUS_AGGRESSIVE	384
#define CONST_MARTYRDOM_GOAL_RADIUS_DEFAULT		900
#define CONST_MARTYRDOM_GOAL_RADIUS_AGGRESSIVE	384
#define CONST_CLAYMORE_GOAL_RADIUS_DEFAULT		900
#define CONST_CLAYMORE_GOAL_RADIUS_AGGRESSIVE	384
#define CONST_CHEMICAL_GOAL_RADIUS_DEFAULT		512
#define CONST_CHEMICAL_GOAL_RADIUS_AGGRESSIVE	384
#define CONST_ALLY_GOAL_RADIUS					512

#define CONST_GENERIC_AI_ENGAGE_MIN				88	// Engagement min dist used by regular and special AI when aggressing (not dogs or bosses)
#define CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF	64	// Engagement min dist fall off used by regular and special AI when aggressing (not dogs or bosses)

#define CONST_MARTYRDOM_C4_SOUND_TELL_LENGTH	1.5	// length of the sound used to telegraph the c4 explosion
#define CONST_MARTYRDOM_C4_TIMER				3	// seconds till c4 explode after dropped by martyrdom AI
#define CONST_MARTYRDOM_C4_TIMER_SUBSEQUENT		0.4	// time delay before secondary explosions go off
#define CONST_MARTYRDOM_C4_PHYS_RADIUS			256	// radius of physics push cylinder volume
#define CONST_MARTYRDOM_C4_PHYS_FORCE			2	// force of the physics push
#define CONST_MARTYRDOM_C4_QUAKE_SCALE			0.4	// earthquake scale
#define CONST_MARTYRDOM_C4_QUAKE_TIME			0.8	// earthquake duration
#define CONST_MARTYRDOM_C4_QUAKE_RADIUS			600	// earthquake range

#define CONST_MARTYRDOM_C4_DMG_RADIUS			192	// c4 damage range
#define CONST_MARTYRDOM_C4_DMG_MAX				100	// c4 max damage
#define CONST_MARTYRDOM_C4_DMG_MIN				50	// c4 min damage
#define CONST_MARTYRDOM_C4_DANGER_RANGE			CONST_MARTYRDOM_C4_DMG_RADIUS - 48	// c4 bad place cylinder height and radius

#define CONST_CLAYMORE_PLACED_MAX				6	// Maximum count of AI claymores that can be placed

#define CONST_MINE_LOC_UPDATE_DELAY				0.5		// Location weight update delay
#define CONST_MINE_LOC_WEIGHT_MAX				20		// Location max weight
#define CONST_MINE_LOC_WEIGHT_INC				0.5		// Weight increase per update: Max reached in 20 updates or 10 seconds
#define CONST_MINE_LOC_WEIGHT_DECAY				0.025	// Weight decrease per update: Min reached in 800 updates or 400 seconds
#define CONST_MINE_LOC_RANGE_PLAYER				512		// Radius from the player that causes a location to have its weight increased
	
#define CONST_MINE_PLANT_CHECK_DELAY			2.0		// Time between claymore planting system checks
#define CONST_MINE_PLANT_TIME_BETWEEN			8.0		// Minimum time between consecutive plant attempts
#define CONST_MINE_PLANT_DIST_PLAYER_MIN		384		// Minimum distance that a claymore can be planted from player
#define CONST_MINE_PLANT_DIST_AI_MAX			768		// Maximum distance that an AI can travel to plant
#define CONST_MINE_PLANT_HEIGHT_AI_MAX			240		// AI won't travel half this height or above half this height to plant
#define CONST_MINE_PLANT_WEIGHT_MIN				2.0		// Min weight for a plant to occur


#define CONST_CLAYMORE_ENT_TIMER				0.75	// seconds till claymore explode after triggered
#define CONST_CLAYMORE_ENT_TRIG_ANGLE			70	// Angle player has to be in to get detected
#define CONST_CLAYMORE_ENT_TRIG_DIST_MIN		20	// Minimum claymore trig dist using player vector projected onto claymore facing
#define CONST_CLAYMORE_ENT_PHYS_RADIUS			256	// radius of physics push cylinder volume
#define CONST_CLAYMORE_ENT_PHYS_FORCE			2	// force of the physics push
#define CONST_CLAYMORE_ENT_QUAKE_SCALE			0.4	// earthquake scale
#define CONST_CLAYMORE_ENT_QUAKE_TIME			0.8	// earthquake duration
#define CONST_CLAYMORE_ENT_QUAKE_RADIUS			600	// earthquake range
#define CONST_CLAYMORE_ENT_TRIG_RADIUS			192  // the claymore detonation distance - mplayer is 192
#define CONST_CLAYMORE_ENT_DMG_RADIUS			192	// claymore damage range
#define CONST_CLAYMORE_ENT_DMG_MAX				100	// claymore max damage
#define CONST_CLAYMORE_ENT_DMG_MIN				50	// claymore min damage

// Tweakables: Ai Type Chemical
#define CONST_CHEMBOMB_ENT_TIMER				0.5	// seconds till chembomb explode after triggered
#define CONST_CHEMBOMB_ENT_TRIG_RADIUS			96	// the chembomb detonation distance
#define CONST_CHEMBOMB_CLOUD_LIFE_TIME			6.0	// how long the chemical bomb cloud remains
#define CONST_CHEMBOMB_CLOUD_BADPLACE_LIFE_TIME	1.0	// length of time in the bad place stays around

#define CONST_CHEMICAL_TANK_PHYS_RADIUS			256	// radius of physics push cylinder volume
#define CONST_CHEMICAL_TANK_PHYS_FORCE			0.5	// force of the physics push
#define CONST_CHEMICAL_TANK_QUAKE_SCALE			0.2	// earthquake scale
#define CONST_CHEMICAL_TANK_QUAKE_TIME			0.4	// earthquake duration
#define CONST_CHEMICAL_TANK_QUAKE_RADIUS		600	// earthquake range

#define CONST_CHEMICAL_TANK_DMG_RADIUS			192	// tank explosion damage range
#define CONST_CHEMICAL_TANK_DMG_MAX				20	// tank explosion max damage
#define CONST_CHEMICAL_TANK_DMG_MIN				10	// tank explosion min damage

#define CONST_CHEMICAL_CLOUD_TRIG_RADIUS		96	// chemical smoke cloud shock radius
#define CONST_CHEMICAL_CLOUD_LIFE_TIME			6.0	// length of time in seconds the cloud stays around
#define CONST_CHEMICAL_CLOUD_BADPLACE_LIFE_TIME	2.0	// length of time in seconds the badplace remains
#define CONST_CHEMICAL_CLOUD_SHOCK_TIME			1.5	// time that the shock lasts for
#define CONST_CHEMICAL_CLOUD_SHOCK_DELAY		1.0	// time in between shock applications from chemical cloud

	// Tweakables: Ai Type Boss Juggernaut
#define CONST_JUG_POP_HELMET_HEALTH_PERCENT		0.33	// Health percent threshold that causes the helmet to pop off
#define CONST_JUG_DROP_SHIELD_HEALTH_PERCENT	0.50	// Health percent threshold that causes the Juggernaut to drop his shield
#define CONST_JUG_WEAKENED						250		// at this health amount, juggernaut is weakened, ex: pain reaction
#define CONST_JUG_MIN_DAMAGE_PAIN				350		// min amount of damage needed to have pain animations play
#define CONST_JUG_MIN_DAMAGE_PAIN_WEAK			250		// min amount of damage needed to have pain animations play when weak
#define CONST_JUG_RUN_DIST						1000	// runs towards player at this distance
#define CONST_JUG_WEAKENED_RUN_DIST				500		// runs towards player at this distance when weakened and desperate
#define CONST_JUG_RIOTSHIELD_BULLET_BLOCK		1		// riotshield jug: no reaction when bullet hits shield

	// Juggernaut damage shield levels, (0-1) 0= takes no dmg, 1= taks full dmg, >1= increases damage
#define CONST_JUG_HIGH_SHIELD					0.25	// Bullet Proof Armor
#define CONST_JUG_MED_SHIELD					0.33	// Bullet Resistant Armor
#define CONST_JUG_LOW_SHIELD					0.75	// Not bare skin or cloth
#define CONST_JUG_NO_SHIELD						1.0		// Exposed area not that is not the head or splash damage with head exposed
#define CONST_JUG_KILL_ON_PAIN					9999	// Exposed head

#define CONST_CHOPPER_SPEED						60		// Chopper default speed
#define CONST_CHOPPER_ACCEL						20 		// Chopper default acceleration

// Tweakables: Ai Type Ally
#define CONST_ALLY_SQUAD_SIZE					3
#define CONST_ALLY_BULLET_SHIELD_TIME			20

// Tweakables: Ai Type Dog
#define CONST_DOG_SPAWN_OVER_TIME				50	// Dogs will spawn over this many seconds, usually estimate of wave completion time

// Tweakables: Ai Type Dogsplode
#define CONST_DOGSPLODE_C4_TIMER_NECK_SNAP		5	// Dog C4 timer used if the dog is killed during a neck snap. Gives the player time to escape.


#define CONST_MAX_SPECIAL_NODE_RADIUS			3072
#define CONST_PRIORITY_TARGET_ENGAGE_DIST		512*512

AI_global_init()
{
	if( !IsDefined(level.so) )
		level.so = SpawnStruct();

	level.so.boss_drop_target						= undefined;//if defined bosses will use this spot as a target to drop onto;
	level.so.ally_squad_size						= CONST_ALLY_SQUAD_SIZE;
}

AI_preload()
{
	AI_global_init();
	
	// AI Type: Martyrdom C4 Items
	precacheModel( "weapon_c4" );
	level._effect[ "martyrdom_c4_explosion" ] 		= loadfx( "explosions/grenadeExp_metal" );
	level._effect[ "martyrdom_dlight_red" ] 		= loadfx( "misc/dlight_red" );
	level._effect[ "martyrdom_red_blink" ]			= loadfx( "misc/power_tower_light_red_blink" );
	
	// AI Type: Claymore Items
	PrecacheModel( "weapon_claymore" );
	level._effect[ "claymore_laser" ] 				= loadfx( "misc/claymore_laser" );
	level._effect[ "claymore_explosion" ] 			= loadfx( "weapon/satchel/fx_explosion_satchel_generic" );
	level._effect[ "claymore_disabled" ]			= loadfx( "explosions/sentry_gun_explosion" );
	
	// AI Type: Chemical Warfare
//	precachemodel( "gas_canisters_backpack" );
	// JC-ToDo: If chemical AI is kept, create unique shock files specifically for him
//	precacheShellShock( "radiation_low" );
//	precacheShellShock( "radiation_med" );
//	precacheShellShock( "radiation_high" );
//	level._effect[ "chemical_tank_explosion" ]		= loadfx( "smoke/so_chemical_explode_smoke" );
//	level._effect[ "chemical_tank_smoke" ]			= loadfx( "smoke/so_chemical_stream_smoke" );
	
	// Boss dying money fx
	level._effect[ "money" ] = loadfx ("props/fx_cash_player_drop");
	
//	maps\_chopperboss::chopper_boss_load_fx();
	
	// dog needs precaching before _load
	animscripts\dog_init::initDogAnimations();
}

// ==========================================================================
// AI INIT AND DATA TABLE POPULATION
// ==========================================================================

AI_init()
{	
	// build ai spawner arrays
	if ( !isdefined( level.wave_table ) )
		level.wave_table		= level.so.LOADOUT_TABLE_DEFAULT;
		
	level.war_ai 				= [];
	level.war_boss				= [];
	level.war_ai 				= ai_type_populate();	// updates level.war_boss
	
	level.war_wave 				= [];
	level.war_wave 				= wave_populate();		// updates level.war_repeat_wave
	level.war_priority_targets 	= [];
	level.war_priority_distSQ	= CONST_PRIORITY_TARGET_ENGAGE_DIST;
	
	// threat bias
	createthreatbiasgroup( "sentry" ); 
	createthreatbiasgroup( "allies" ); 
	createthreatbiasgroup( "axis" );
	createthreatbiasgroup( "boss" );
	createthreatbiasgroup( "dogs" );
	
	setignoremegroup( "sentry", "dogs" );		// dogs ignore sentry
	setthreatbias( "sentry", "boss", 50 ); //1000 );	// make the sentry a bigger threat to boss
	setthreatbias( "sentry", "axis", 1000 );	// make the sentry a bigger threat to enemies	
	setthreatbias( "boss", "allies", 2000 );	// make the boss a bigger threat to allies
	setthreatbias( "dogs", "allies", 1000 );	// make the dogs a big threat to allies
	setthreatbias( "axis", "allies", 0 );		// make the axis a regular threat to allies
	
	foreach ( player in level.players )
	{
		player thread update_player_closest_node_think();
	}
	
	// setup AI types and run them
	level.attributes_func				= ::setup_attributes;
	level.squad_leader_behavior_func 	= ::default_ai;
	level.special_ai_behavior_func 		= ::default_ai;
	level.squad_drop_weapon_rate		= CONST_WEAPON_DROP_RATE;
	add_global_spawn_function( "axis", ::no_grenade_bag_drop );
	add_global_spawn_function( "axis", ::weapon_drop_ammo_adjustment );
	add_global_spawn_function( "axis", ::update_enemy_remaining );
	add_global_spawn_function( "axis", ::ai_on_long_death );
	add_global_spawn_function( "axis", ::ai_on_flashed );
	
	thread war_AI_regular();
	thread war_AI_martyrdom();
	// These are paired because they both lean on 
	// the mine (claymore) locations throughout the
	// map
	thread war_AI_claymore_and_chemical();
	thread war_boss_juggernaut();
	thread war_boss_chopper();
	
	// for dogs to behave when they cant get to players
	thread dog_relocate_init();
	//thread sector_position_monitor();
	
	battlechatter_on( "allies" );
	battlechatter_on( "axis" );
}


wave_populate()
{
	index_start = TABLE_WAVE_DEF_INDEX_START;
	index_end 	= TABLE_WAVE_DEF_INDEX_END;
	waves 		= [];

	for( i = index_start; i <= index_end; i++ )
	{		
		wave_num = get_wave_number_by_index( i );

		if ( !isdefined( wave_num ) || wave_num == 0 )
			continue;
		
		wave 					= spawnstruct();
		wave.idx				= i;
		wave.num				= wave_num;
		wave.startDelay			= get_wave_startdelay( wave_num );
		wave.minAIThreshold		= get_min_ai_threshold( wave_num);
		wave.squadType			= get_squad_type( wave_num );
		wave.squadArray			= get_squad_array( wave_num );
		wave.specialAI			= get_special_ai( wave_num );
		wave.specialAIquantity	= get_special_ai_quantity( wave_num );
		wave.bossDelay			= get_wave_boss_delay( wave_num );
		wave.bossAI				= get_bosses_ai( wave_num );
		wave.bossNonAI			= get_bosses_nonai( wave_num );
		wave.dogType			= get_dog_type( wave_num );
		wave.dogQuantity		= get_dog_quantity( wave_num );
		wave.repeating			= is_repeating( wave_num );
		wave.minimumPopAndTime  = get_min_pop_time( wave_num );
		waves[ wave_num ] 		= wave;
	}
	
	return waves;
}

ai_type_populate()
{
	index_start = TABLE_AI_TYPE_INDEX_START;
	index_end 	= TABLE_AI_TYPE_INDEX_END;
	ai_types	= [];

	for( i = index_start; i <= index_end; i++ )
	{		
		ref = get_ai_ref_by_index( i );
		if ( !isdefined( ref ) || ref == "" )
			continue;
		
		ai 				= spawnstruct();
		ai.idx			= i;
		ai.ref			= ref;
		ai.name			= get_ai_name( ref, i );
		ai.desc			= get_ai_desc( ref, i );
		ai.classname	= get_ai_classname( ref, i );
		ai.classtype 	= get_ai_classtype( ref, i );
		
		ai.health		= maps\_so_war_classes::get_class_health( ai.classtype );
		ai.speed		= maps\_so_war_classes::get_class_speed( ai.classtype );
		ai.accuracy		= maps\_so_war_classes::get_class_accuracy( ai.classtype );
		ai.equipment	= maps\_so_war_classes::get_class_equipment( ai.classtype );
		
		if ( is_ai_boss( ref ) )
			level.war_boss[ ref ] = ai;

		ai_types[ ref ] = ai;
	}
	return ai_types;
}

// ==========================================================================
// REGISTER AI XP/CREDITS
// ==========================================================================

giveXp_kill( victim, XP_mod )
{
	assert( isPlayer( self ), "Trying to give XP to non Player" );
	assert( isdefined( victim ), "Trying to give XP reward on something that is not defined" );
	
	XP_type = "kill";
	if ( isdefined( victim.ai_type ) )
		XP_type = "war_ai_" + victim.ai_type.ref;
	
	value = undefined;

/*
	if ( isdefined( XP_mod ) )
	{
		reward = maps\_rank::getScoreInfoValue( XP_type );
		if ( isdefined( reward ) )
			value = reward * XP_mod;
	}
*/
	
//	self givexp( XP_type, value );
}



// ==========================================================================
// GLOBAL AI STUFF
// ==========================================================================

// In the function that manages AI position - manage_ai_relative_to_player() - AI
// are told to go to the closest healthy player. If that player is in a position the
// AI cannot get to, they receive a notification from code of "bad_path". This
// happens whether SetGoalPos() or SetGoalEnity() is used. The result of this
// situation is the AI do not move from their current location. To keep the AI in
// war moving towards the player, keep track of each player's closest path node
// AI that receive a bad path notification can then grab the current closest node
// to their target player and go there. - JC

update_player_closest_node_think()
{
	Assert( IsPlayer( self ), "Self should be a player in update_player_closest_node_think()" );
	
	self endon( "death" );
	level endon( "special_op_terminated" );
	
	flag_wait("intro_complete");
	max_radius = CONST_NODE_CLOSEST_RADIUS_MAX;
	min_radius = CONST_NODE_CLOSEST_RADIUS_MIN;
	max_height = CONST_NODE_CLOSEST_HEIGHT;
	
	while ( 1 )
	{
		
		nodes = GetNodesInRadiusSorted( self.origin, max_radius, min_radius, max_height );
		if ( !IsDefined( nodes ) || !nodes.size )
		{
			max_radius += CONST_NODE_CLOSEST_RADIUS_INCREASE;
			max_height += CONST_NODE_CLOSEST_HEIGHT_INCREASE;
			
			/#
			if ( self isinmovemode( "ufo", "noclip" ) == false )
			{
				Assert( max_radius < CONST_NODE_CLOSEST_RADIUS_INVALID, "The max radius check for the close nodes should never get larger than: " + CONST_NODE_CLOSEST_RADIUS_INVALID );
			}
			#/
			
			wait 0.1;
			continue;	
		}
		
		self.node_closest = nodes[0];
		
		// Rest the test case values
		max_radius = CONST_NODE_CLOSEST_RADIUS_MAX;
		min_radius = CONST_NODE_CLOSEST_RADIUS_MIN;
		max_height = CONST_NODE_CLOSEST_HEIGHT;
		
		wait 0.2;
	}
	
}

update_enemy_remaining()
{
	level endon( "special_op_terminated" );
	
	// Let the AI and vehicle spawn logic run so that 
	// the level.bosses array and the level.dogs array
	// are updated before grabbing the final ai count;
	waittillframeend;
	
	level.enemy_remaining = get_war_enemies_living().size;
	level notify( "axis_spawned" );
	
	self waittill( "death" );
	
	// Again, let the level.bosses and level.dog arrays
	// get updated then update the enemy remaining
	waittillframeend;
	
	enemies_alive = get_war_enemies_living();
	
	level.enemy_remaining = enemies_alive.size;
	level notify( "axis_died" );
	
	// If ai are done spawning and only one enemy is left 
	// and it's an AI that is not a dog stop long deaths
	if	(
		flag( "aggressive_mode" ) 
	&&	enemies_alive.size == 1
	&&	isai( enemies_alive[ 0 ] )
	&&	enemies_alive[ 0 ].type != "dog"
		)
	{
		enemies_alive[ 0 ] thread prevent_long_death();
	}
}

get_war_enemies_living()
{
	enemy_array = getaiarray( "axis" );
	
	// Add non ai bosses, duplicates are removed by array_merge()
	if ( IsDefined( level.bosses ) && level.bosses.size )
		enemy_array = array_merge( enemy_array, level.bosses );
		
	enemy_array = array_merge( enemy_array, dog_get_living() );
		
	return enemy_array;
}

prevent_long_death()
{
	level endon( "special_op_terminated" );
	self endon( "death" );
	
	if ( !isdefined( self.a.doingLongDeath ) )
	{
		self disable_long_death();
		return;
	}
	
	// Once the players are far enough away / out of
	// site kill the ai so he doesn't hand around in
	// in long death delaying the round end
	while ( 1 )
	{
		safe_to_kill = true;
		
		foreach ( player in level.players )
		{
			player_too_close = Distance2D( player.origin, self.origin ) < CONST_LONG_DEATH_REMOVE_DIST_MIN;
			
			if ( player_too_close )
			{
				safe_to_kill = false;
				break;	
			}
			
			if ( self CanSee( player ) )
			{
				safe_to_kill = false;
				break;
			}
			
			// One trace per script update
			wait 0.05;
		}
		
		if ( safe_to_kill )
		{
			attacker = self get_last_attacker();
			
			if ( isdefined( attacker ) )
				self Kill( self.origin, attacker );
			else
				self Kill( self.origin );
			
			return;
		}
		
		wait 0.1;
	}
}

get_last_attacker()
{
	assert( isdefined( self ), "Self must be defined to check for last attacker." );
	
	attacker = undefined;
	
	// use the last attacker if available
	if ( isdefined( self.attacker_list ) && self.attacker_list.size )
		attacker = self.attacker_list[ self.attacker_list.size - 1 ];
		
	return attacker;
}

weapon_drop_ammo_adjustment()
{
	if ( !isai( self ) || isdefined( self.type ) && self.type == "dog" )
		return;
	
	level endon( "special_op_terminated" );
	
	self waittill( "weapon_dropped", weapon );
	
	if ( !isdefined( weapon ) )
		return;

	offset 				= ( 0, 0, 10000 );
	weapon_name 		= GetSubStr( weapon.classname, 7 );
	weapon.origin 		-= offset;	// not give player chance to pick up before setup is done
	wait 				( 0.05 );	// wait till anim is done and such
	
	if ( !isdefined( level.armory ) || !isdefined( level.armory[ "weapon" ] ) )
		return;
	
	weapon_struct		= level.armory[ "weapon" ][ weapon_name ];
	//weapon_struct 	= level.armory_all_items[ weapon_name ];
	
	if ( !isdefined( weapon ) || !isdefined( weapon_struct ) )
		return;
	
	assert( isdefined( weapon_struct.dropclip ) && isdefined( weapon_struct.dropstock ) );
	
	ammo_in_clip 		= weapon_struct.dropclip;
	ammo_stock 			= weapon_struct.dropstock;
	//ammo_in_clip 		= int( max( CONST_WEAPON_DROP_AMMO_CLIP_MIN, clip_percentage * WeaponClipSize( weapon_name ) ) );
	//ammo_stock 		= int( max( CONST_WEAPON_DROP_AMMO_STOCK_MIN, stock_percentage * WeaponMaxAmmo( weapon_name ) ) );
	weapon				ItemWeaponSetAmmo( ammo_in_clip, ammo_stock );
	
	// for alt mode such as m203 and shotty attachments
	// give min of 1 ammo
	alt_weapon 			= WeaponAltWeaponName( weapon_name );
	if( alt_weapon != "none" )
	{
		alt_clip 		= int( max( 1, WeaponClipSize( alt_weapon ) ) );
		alt_stock 		= int( max( 1, WeaponMaxAmmo( alt_weapon ) ) );
		weapon 			ItemWeaponSetAmmo( alt_clip, alt_stock, 1 );
	}
	weapon.origin 		+= offset;
}

no_grenade_bag_drop()
{
	// every axis resets this value when spawned, am forcing this here
	level.nextGrenadeDrop	= 100000;	// no grenade bag drop!	
}

// displays money FX where an AI died
money_fx_on_death()
{
	level endon( "special_op_terminated" );

	self waittill( "death" );
	
	// if self is removed instead of killed, then no money should display
	if ( !isdefined( self ) )
		return;
		
	playFx( level._effect[ "money" ], self.origin + ( 0, 0, 32 ) );
}

ai_on_long_death()
{
	if ( !isai( self ) || isdefined( self.type ) && self.type == "dog" )
		return;
		
	self endon( "death" );
	level endon( "special_op_terminated" );
	
	self waittill( "long_death" );
	
	self waittill( "flashbang", amount_distance, amount_angle, attacker, attackerteam );
	
	if ( isdefined( attacker ) && isdefined( attacker.team ) && attacker.team == "allies" )
		self kill( self.origin, attacker );
}

ai_on_flashed()
{
	self endon( "death" );
	level endon( "special_op_terminated" );
	
	self waittill( "flashbang", flash_origin, flash_dist, flash_angle, attacker );
	
	if ( IsDefined( attacker ) && IsPlayer( attacker ) )
	{
		attacker maps\_damagefeedback::updateDamageFeedback( );
	}
}

// get ai type ref
get_ai_type_ref()
{
	assert( isdefined( self ) && isalive( self ), "Trying to AI type when AI is undefined or dead." );
		
	if ( isdefined( self.ai_type ) )
		return self.ai_type.ref;	
	
	if ( isdefined( level.leaders ) )
	{
		foreach( leader in level.leaders )
		{
			if ( leader == self )
				return get_squad_type( level.current_wave );
		}
	}
	
	// squad follower
	if ( isdefined( self.leader ) && isAI( self.leader ) )
		return get_squad_type( level.current_wave );

	assert( false, "Failed to assign AI_type_ref for AI: " + self.unique_id );
	return undefined;
}

get_special_ai_array( ref )
{
	assert( isdefined( ref ) );
	
	arr_ai_type = [];
	
	if ( isdefined( level.special_ai ) && level.special_ai.size )
	{
		foreach( ai in level.special_ai )
			if ( isalive( ai ) && isdefined( ai.ai_type ) && issubstr(ai get_ai_type_ref(), ref ) )
				arr_ai_type[ arr_ai_type.size ] = ai;
	}
	
	return arr_ai_type;
}

// default ai behavior director function
default_ai()
{
	assert( isdefined( self ) && isalive( self ) && isAI( self ), "Default AI behavior func was called on nonAI or is removed/dead." );
	
	self notify( "ai_behavior_change" );
	
	self.aggressivemode = true;		// don't linger at cover when you cant see your enemy
	self.aggressing = undefined;
	ai_ref = self [[ level.attributes_func ]]();
	
	//iprintln( ai_ref + " AI behavior: default" );
	
	if ( issubstr(ai_ref,"martyrdom" ))
	{
		self thread behavior_special_ai_martyrdom();
		return;
	}
		
	if ( issubstr(ai_ref,"claymore" ))
	{
		self thread behavior_special_ai_claymore();
		return;
	}
		
	if ( issubstr(ai_ref,"chemical" ))
	{
		self thread behavior_special_ai_chemical();
		return;
	}
	// all special ai cases should be handled by this point
	
	self thread default_squad_leader();
	// juggernaut bosses use different behavior functions elsewhere
}

// aggressive ai behavior director function
aggressive_ai()
{
	assert( isdefined( self ) && isalive( self ) && isAI( self ), "Default AI behavior func was called on nonAI or is removed/dead." );
	
	self notify( "ai_behavior_change" );
	
	self.aggressivemode = true;		// don't linger at cover when you cant see your enemy
	self.aggressing = true;
	ai_ref = self [[ level.attributes_func ]]();
	
	//iprintln( ai_ref + " AI behavior: aggressive" );
	
	if ( issubstr(ai_ref,"martyrdom" ))
	{
		self thread behavior_special_ai_martyrdom();
		return;
	}
		
	if ( issubstr(ai_ref,"claymore") )
	{
		self thread behavior_special_ai_claymore();
		return;
	}
		
	if ( issubstr(ai_ref,"chemical" ))
	{
		self thread behavior_special_ai_chemical();
		return;
	}
	// all special ai cases should be handled by this point
	
	self thread aggressive_squad_leader();
	// juggernaut bosses use different behavior functions elsewhere
}

// setups up AI attributes from data table, such as health, speed etc...
setup_attributes()
{
	// If ai attributes already set up skip attributes
	if ( isdefined( self.attributes_set ) && isdefined( self.ai_type ) )
		return self.ai_type.ref;
	
	// self is live AI this is called on
	ai_ref = self get_ai_type_ref();

	// live AI carries info struct about his class
	if ( !isdefined( self.ai_type ) )
	{
		ai_type_struct = get_ai_struct( ai_ref );
		assert( isdefined( ai_type_struct ), "Failed to find struct for AI type: " + ai_ref );
		self.ai_type = ai_type_struct;
	}
	
	// ================== AI attributes ====================
	is_vehicle = ( isdefined( self.code_classname ) && self.code_classname == "script_vehicle" );
	
	// ==== set health
	set_health = self.ai_type.health;
	// vehicle health is handled differently by vehicle script and requires setting
	// vehicle.script_startinghealth on the spawner, which is done in chopper_spawn_from_targetname(...)
	if ( isdefined( set_health ) && !is_vehicle )
		self.health = set_health;
	
	// ==== set movement speed scale
	speed_scale = self.ai_type.speed;
	if ( isdefined( speed_scale ) )
	{
		if ( is_vehicle )
			self Vehicle_SetSpeed( CONST_CHOPPER_SPEED * speed_scale, CONST_CHOPPER_ACCEL * speed_scale );
		else
			self.moveplaybackrate = speed_scale;
	}

	// ==== set base accuracy
	set_accuracy = self.ai_type.accuracy;
	if ( isdefined( set_accuracy ) )
		self set_baseaccuracy( set_accuracy );
	
	// ==== set equipment
	equipmentArray	= self.ai_type.equipment;
	foreach ( equipment in equipmentArray )
	{
		if ( equipment == "fraggrenade" )
		{
			self.grenadeammo = 2;
			self.grenadeweapon = "fraggrenade";
		}
		
		if ( equipment == "flash_grenade" )
		{
			self.grenadeammo = 2;
			self.grenadeweapon = "flash_grenade";
		}
	}
	
	// ==== weapon drop rate
	if( isdefined( self.dropweapon ) && self.dropweapon && isdefined( level.squad_drop_weapon_rate ) )
	{
		drop_chance = randomfloat( 1 );
		if( drop_chance > level.squad_drop_weapon_rate )
			self.dropweapon = false; 	// this avoids weapon being all weird when AI dies
	}
	
	self.attributes_set = true;
	return ai_ref;
}

// Boss behaviors
war_boss_behavior()
{
	self endon( "death" );
	
	msg = "Boss does not have AI_Type struct, should have been passed when spawning by AI_Type.";
	assert( isdefined( self.ai_type ), msg );
	
	// run this first before overriding the attributes with csv data
	if( IsSubStr( self.targetname, "jug_" ) )
		self maps\_juggernaut::make_juggernaut( false );

	boss_ref = self [[ level.attributes_func ]]();
	
	if ( !isdefined( boss_ref ) )
		return;
	
	if ( boss_ref == "jug_regular" )
	{
		self global_jug_behavior();
		self thread boss_jug_regular();
		return;
	}
	if ( boss_ref == "jug_headshot" )
	{
		self global_jug_behavior();
		self thread boss_jug_headshot();
		return;
	}
	if ( boss_ref == "jug_explosive" )
	{
		self global_jug_behavior();
		self thread boss_jug_explosive();
		return;
	}
	if ( boss_ref == "jug_riotshield" )
	{
		self global_jug_behavior();
		self thread boss_jug_riotshield();
		return;
	}
	
	//assert( false, "Boss type: " + boss_name + " is not valid!" );
}

// ==========================================================================
// REGULAR SQUAD AI
// ==========================================================================

// setup for regular squad AIs
war_AI_regular()
{
	// in case we want to setup something globally in level for this type of AI
	
}

// used for default squad leader behaviors
default_squad_leader()
{
	self.goalradius = CONST_REGULAR_GOAL_RADIUS_DEFAULT;
	self.aggressing = undefined;	// this function can be called raw and .aggressing needs to be udpated
	
	//self.pathenemyfightdist = 1028;
	//self.pathenemylookahead = 1028;
	
	self setengagementmindist( 300, 200 );
	self setengagementmaxdist( 512, 768 );

	self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change demotion" );
}

// used when there are a few left and we are wraping up the wave
aggressive_squad_leader()
{
	self.goalradius = CONST_REGULAR_GOAL_RADIUS_AGGRESSIVE;
	self.aggressing = true;		// this function can be called raw and .aggressing needs to be udpated
	
	//self.pathenemyfightdist = 1028;
	//self.pathenemylookahead = 1028;
	
	self enable_heat_behavior( true );
	self disable_react();
	
	self setengagementmindist( CONST_GENERIC_AI_ENGAGE_MIN, CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF );
	self setengagementmaxdist( 512, 768 );
	
	self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change demotion" );
}

spawn_enemy_squad_by_chopper( squad_size, statusCallback, pathFilter )
{
	dropTarget = level.player.origin;
	
	if( !IsDefined( pathFilter ) )
		pathFilter = "script_unload";
			
	path_start = chopper_wait_for_closest_open_path_start( dropTarget, "drop_path_start", pathFilter );
	
	chopper = maps\_so_war_support::chopper_spawn_from_targetname_and_drive( "jug_drop_chopper", path_start.origin, path_start, "axis" );
	
	// removed from remote missile targeting due to this chopper being in godon mode
	//chopper thread maps\_remotemissile_utility::setup_remote_missile_target();
	
	chopper.script_vehicle_selfremove = true;
	chopper Vehicle_SetSpeed( 40 + randomint(15), 30, 30 );
	
	chopper.custom_unload = true;
	
	if( IsDefined( statusCallback ) )
		chopper thread chopper_monitor_death( statusCallback );

	// In case the chopper can be killed
	chopper endon( "death" );

	chopper waittill( "unload" );
	
	squad_type 	= get_squad_type( level.current_wave );
	classname 	= get_ai_classname( squad_type );
	
	// set up the spawner list
	ai_spawner 	= maps\_so_code::get_spawners_by_classname( classname )[ 0 ];
	assert( isdefined( ai_spawner ), "No ai spawner with classname: " + classname );
	
	// all the same for now
	enemy_spawners = [];
	for( i=0; i < squad_size; i++ )
	{
		enemy_spawners[ i ] = ai_spawner;
		enemy_spawners[ i ].targetname = squad_type; // for filling stuff out later in enemy_setup
	}
	
	// rappel on down
	enemy_squad = chopper_rappel( chopper, enemy_spawners, statusCallback, "new_guy" );
	
	// set up the squad
	enemy_squad = maps\_utility::array_removeDead( enemy_squad );
	for( i=0; i < enemy_squad.size; i++ )
	{
		if( i == 0 )
			enemy_squad[i] thread maps\_squad_enemies::setup_leader( enemy_squad );
		else
			enemy_squad[i] thread maps\_squad_enemies::setup_follower( enemy_squad[0] );
	}

	chopper notify( "unloaded" );

	chopper vehicle_resumepathvehicle();
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );	

	// AP_TODO: delete when end reached
	level thread removeChopper( chopper, 10, path_start );

	return enemy_squad;
}

chopper_monitor_death( callback )
{
	level endon( "special_op_terminated" );
	
	self waittill( "death" );
	
	[[ callback ]]( "chopper_death", self );
}

/@
"Name: spawn_tag_origin()"
"Summary: Spawn a script model with tag_origin model"
"Module: Utility"
"Example: ent = spawn_tag_origin();"
"SPMP: both"
@/
spawn_tag_origin()
{
	tag_origin = spawn( "script_model", ( 0, 0, 0 ) );
	tag_origin setmodel( "tag_origin" );
	tag_origin hide();
	if ( isdefined( self.origin ) )
		tag_origin.origin = self.origin;
	if ( isdefined( self.angles ) )
		tag_origin.angles = self.angles;

	return tag_origin;
}

// ==========================================================================
// MARTYRDOM AI
// ==========================================================================

behavior_special_ai_martyrdom()
{
	self endon( "death" );
	self endon( "ai_behavior_change" );
	
	// setup AI martyrdom ability
	if ( !isdefined( self.special_ability ) )
		self thread martyrdom_ability();
	
	engage_min_dist				= 0;
	engage_min_dist_fall_off	= 0;
	
	if ( isdefined( self.aggressing ) && self.aggressing )
	{
		engage_min_dist 			= CONST_GENERIC_AI_ENGAGE_MIN;
		engage_min_dist_fall_off	= CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF;
		self.goalradius 			= CONST_MARTYRDOM_GOAL_RADIUS_AGGRESSIVE;	
		
		self enable_heat_behavior( true );
		self disable_react();
	}
	else
	{
		engage_min_dist				= 200;
		engage_min_dist_fall_off	= 100;
		self.goalradius				= CONST_MARTYRDOM_GOAL_RADIUS_DEFAULT;
	}
	
	//self.pathenemyfightdist = 1028;
	//self.pathenemylookahead = 1028;
	
	self setengagementmindist( engage_min_dist, engage_min_dist_fall_off );
	self setengagementmaxdist( 512, 768 );
	
	self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change" );
}

war_AI_martyrdom()
{
	
}

martyrdom_ability()
{
	self.special_ability = true;
	self.forceLongDeath = true;
	
	// Chest and Back c4
	self thread attach_c4( "tag_bipod", (5,0,4), (80,0,0) );
	self thread attach_c4( "tag_stowed_back", (-2,-3,0), (90,90,0) );
	
	self thread detonate_c4_when_dead( CONST_MARTYRDOM_C4_TIMER, CONST_MARTYRDOM_C4_TIMER_SUBSEQUENT );
}

attach_c4( tag, origin_offset, angles_offset )
{
	assert( isdefined( tag ), "attach_c4() passed undfined tag." );
	
	if ( !isdefined( origin_offset ) )
		origin_offset = ( 0, 0, 0 );
	if ( !isdefined( angles_offset ) )
		angles_offset = ( 0, 0, 0 );
	
	c4_model = spawn( "script_model", self gettagorigin( tag ) + origin_offset );
	c4_model setmodel( "weapon_c4" );
	
	c4_model linkto( self, tag, origin_offset, angles_offset );
	
	if ( !isdefined( self.c4_attachments ) )
		self.c4_attachments = [];	
	
	self.c4_attachments[ self.c4_attachments.size ] = c4_model;
}

detonate_c4_when_dead( timer, subsequent_timer )
{
	self waittill_any( "long_death", "death" );
	
	if ( !isdefined( self ) || !isdefined( self.c4_attachments ) || self.c4_attachments.size == 0 )
		return;
	
	// Passed to the c4 damage call so that players can chain kill for points
	attacker = self get_last_attacker();
	
	// Doggy Hack: If the player snapped the dog's neck
	// then give the player more time to get up from the 
	// c4 blast.
	if ( isdefined( self.dog_neck_snapped ) )
	{
		timer = CONST_DOGSPLODE_C4_TIMER_NECK_SNAP;
	}
	
	// Play individual blink fx
	for ( i = 0; i < self.c4_attachments.size; i++ )
	{
		playfxontag( getfx( "martyrdom_dlight_red" ), self.c4_attachments[ i ], "tag_fx" );
		playfxontag( getfx( "martyrdom_red_blink" ), self.c4_attachments[ i ], "tag_fx" );
	}
	
	// In case self is invalid after wait grab the c4 array
	c4_array = self.c4_attachments;
	self.c4_attachments = undefined;
	
	BadPlace_Cylinder( "", timer, c4_array[ 0 ].origin, CONST_MARTYRDOM_C4_DANGER_RANGE, CONST_MARTYRDOM_C4_DANGER_RANGE, "axis", "allies" );
	
	// Start the sound telegraph so that the explosion happens
	// as the sound finishes playing
	time_before_sound = max( timer - CONST_MARTYRDOM_C4_SOUND_TELL_LENGTH, 0 );
	if ( time_before_sound > 0 )
	{
		timer -= time_before_sound;
		wait time_before_sound;	
	}
	
	c4_array[ 0 ] playsound( "semtex_warning" );
	
	wait timer;
	
	// Make sure the lowest c4 explodes first
	c4_array = sortbydistance( c4_array, c4_array[0].origin + (0,0,-120) );
	
	// Blow 'em
	for ( i = 0; i < c4_array.size; i++ )
	{
		if ( !isdefined( c4_array[ i ] ) )
			continue;
		
		playfx( level._effect[ "martyrdom_c4_explosion" ], c4_array[ i ].origin );
		
		c4_array[ i ] playsound( "detpack_explo_main", "sound_done" );
		PhysicsExplosionCylinder( c4_array[ i ].origin, CONST_MARTYRDOM_C4_PHYS_RADIUS, 1, CONST_MARTYRDOM_C4_PHYS_FORCE );
		earthquake( CONST_MARTYRDOM_C4_QUAKE_SCALE, CONST_MARTYRDOM_C4_QUAKE_TIME, c4_array[ i ].origin, CONST_MARTYRDOM_C4_QUAKE_RADIUS );
		
		// In case the attacker is removed, make sure a removed entity
		// is not passed to radiusdamage() o_O
		if ( !isdefined( attacker ) )
			attacker = undefined;
		
		c4_array[ i ] radiusdamage( c4_array[ i ].origin, CONST_MARTYRDOM_C4_DMG_RADIUS, CONST_MARTYRDOM_C4_DMG_MAX, CONST_MARTYRDOM_C4_DMG_MIN, attacker, "MOD_EXPLOSIVE" );
		
//		stopfxontag( getfx( "martyrdom_dlight_red" ), c4_array[ i ], "tag_fx" );
//		stopfxontag( getfx( "martyrdom_red_blink" ), c4_array[ i ], "tag_fx" );
		
		c4_array[ i ] thread ent_linked_delete();
		
		wait subsequent_timer;
	}
}

// ==========================================================================
// CLAYMORE AI
// ==========================================================================

behavior_special_ai_claymore()
{
	// If currently planting ignore new behavior calls from the
	// war wave logic
	if ( isdefined( self.planting ) )
		return;

	self endon( "death" );
	self endon( "ai_behavior_change" );
	
	engage_min_dist				= 0;
	engage_min_dist_fall_off	= 0;
	self.claymore = true;
	
	if ( isdefined( self.aggressing ) && self.aggressing )
	{
		engage_min_dist 			= CONST_GENERIC_AI_ENGAGE_MIN;
		engage_min_dist_fall_off	= CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF;
		self.goalradius 			= CONST_CLAYMORE_GOAL_RADIUS_AGGRESSIVE;
		
		self enable_heat_behavior( true );
		self disable_react();
	}
	else
	{
		engage_min_dist				= 300;
		engage_min_dist_fall_off	= 200;
		self.goalradius 			= CONST_CLAYMORE_GOAL_RADIUS_DEFAULT;
	}
	
	self setengagementmindist( engage_min_dist, engage_min_dist_fall_off );
	self setengagementmaxdist( 512, 768 );
	
	self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change" );
}

war_AI_claymore_and_chemical()
{	
	mine_locs_populate();
	thread mine_locs_manage_weights();
	
	mine_ai_types = array("claymore","chemical");
	thread mine_locs_manage_planting( mine_ai_types );
}

mine_locs_populate()
{
	level.so_mine_locs = [];
	level.so_mine_locs = get_all_mine_locs();
	
	assert( level.so_mine_locs.size, "Map has no mine location structs placed." );
	
	foreach( mine_loc in level.so_mine_locs )
	{
		mine_loc.weight = 0.0;
	}
}

mine_locs_attempt_plant( array_ai_types )
{
	if ( isdefined( level.so_mines ) && level.so_mines.size >= CONST_CLAYMORE_PLACED_MAX )
		return false;
		
	ai_mine = [];
	
	foreach ( ai_type in array_ai_types )
	{
		ai_mine = array_combine( ai_mine, get_special_ai_array( ai_type ) );
	}
	
	ai_mine = mine_ai_remove_busy( ai_mine );
	
	if ( !ai_mine.size )
		return false;
		
	valid_locs = mine_locs_get_valid( CONST_MINE_PLANT_DIST_PLAYER_MIN, CONST_MINE_PLANT_WEIGHT_MIN );
	valid_locs = mine_locs_sorted_by_weight( valid_locs );
	
	foreach( loc in valid_locs )
	{
		foreach( ai in ai_mine )
		{
			ai_mine_dist = distance2d( loc.origin, ai.origin );
			
			// Early out if outside plant cylinder
			if	( 
				ai_mine_dist > CONST_MINE_PLANT_DIST_AI_MAX ||
				loc.origin[2] < ai.origin[2] - CONST_MINE_PLANT_HEIGHT_AI_MAX * 0.5 ||
				loc.origin[2] > ai.origin[2] + CONST_MINE_PLANT_HEIGHT_AI_MAX * 0.5
				)
				continue;
			
			player_closest = getclosest( loc.origin, level.players );
			player_mine_dist = distance2d( loc.origin, player_closest.origin );
			
			if ( ai_mine_dist < player_mine_dist )
			{
				ai thread behavior_special_ai_mine_place( loc );
				return true;	
			}
		}
	}
	
	return false;
}

mine_ai_remove_busy( array_ai )
{	
	ai_not_planting = [];
	foreach( ai in 	array_ai )
	{
		if ( !isdefined( ai.planting ) )
			ai_not_planting[ ai_not_planting.size ] = ai;
	}
			
	return ai_not_planting;
}

// Exchange sort
mine_locs_sorted_by_weight( locs )
{
	for( i = 0; i < locs.size - 1; i++ )
	{
		index_small = 0;
		for ( j = i + 1; j < locs.size; j++ )
		{
			if ( locs[ j ].weight < locs[ i ].weight )
			{
				loc_ref = locs[ j ];
				locs[ j ] = locs[ i ];
				locs[ i ] = loc_ref;	
			}
		}	
	}
	
	return locs;
}

mine_locs_get_valid( dist_min, weight_min )
{
	assert( isdefined( level.so_mine_locs ) && level.so_mine_locs.size, "Level not prepped with claymore plant locations." );
	
	locs_valid = [];
	
	foreach( loc in level.so_mine_locs )
		if ( loc mine_loc_valid_plant( dist_min, weight_min ) )
			locs_valid[ locs_valid.size ] = loc;
	
	return locs_valid;
}

mine_loc_valid_plant( dist_min, weight_min )
{
	assert( isdefined( self.weight ) );
	assert( isdefined( dist_min ) && dist_min >= 0 );
	assert( isdefined( weight_min ) );
	
	if ( isdefined( self.occupied ) || self.weight < weight_min )
		return false;
		
	foreach( player in level.players )
		if ( distance2d( self.origin, player.origin ) < dist_min )
			return false;
	
	return true;
}

mine_locs_manage_weights()
{
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		foreach( loc in level.so_mine_locs )
		{
			increased = false;
			
			foreach( player in level.players )
			{
				if ( !isDefined(level.so.ignore_mine_dist_check) )
				{
					loc mine_loc_adjust_weight( true );
					increased = true;
				}
				else
				if ( distance2d( loc.origin, player.origin ) <= CONST_MINE_LOC_RANGE_PLAYER )
				{
					loc mine_loc_adjust_weight( true );
					increased = true;
				}
			}
			
			if ( !increased )
				loc mine_loc_adjust_weight( false );
		}
		
		wait CONST_MINE_LOC_UPDATE_DELAY;
	}
}

mine_loc_adjust_weight( increment )
{
	if ( increment )
		self.weight = min( CONST_MINE_LOC_WEIGHT_MAX, self.weight + CONST_MINE_LOC_WEIGHT_INC );	
	else
		self.weight = max( 0, self.weight - CONST_MINE_LOC_WEIGHT_DECAY );
}

mine_locs_manage_planting( array_ai_types )
{
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		if ( mine_locs_attempt_plant( array_ai_types ) )
			wait CONST_MINE_PLANT_TIME_BETWEEN;
		else
			wait CONST_MINE_PLANT_CHECK_DELAY;
			
	}
}

behavior_special_ai_mine_place( loc_struct )
{
	assert( !isdefined( loc_struct.occupied ), "Claymore placed on already occupied location." );
	
	// Do not endon ai_behavior_change as this behavior
	// takes priority over new behavior
	self endon( "death" );
	
	self.planting = true;
	self notify( "ai_behavior_change" );
	
	loc_struct.occupied = true;
	
	self thread mine_ai_planting_death( loc_struct );
	
	goal_radius = self.goalradius;
	self.goalradius = 48;
	self.ignoreall = true;
	self.ignoreme = true;
	
	self setgoalpos( loc_struct.origin );
		
	msg = self waittill_any_timeout( 60, "goal", "bad_path" );
	
	if ( msg != "goal" )
	{
		loc_struct.occupied = undefined;
		
		if ( msg == "bad_path" )
		{
			// Remove invalid location
			level.so_mine_locs = array_remove_nokeys( level.so_mine_locs, loc_struct );
		
			// JC-ToDo: Add debug draw logic to identify invalid locations in the map
			println( "Error: bad claymore mine location: " + loc_struct.origin[0] + ", " + loc_struct.origin[1] + ", " + loc_struct.origin[2] );
        }
	}
	else
	{
		self allowedstances( "crouch" );

		mine = undefined;
		
		// TODO: replace this with animation at some point
		self SetGoalPos( self.origin );
		wait( 1 );
		
		ai_ref = self get_ai_type_ref();
		if ( issubstr(ai_ref,"claymore") )
		{
			mine = self claymore_create( loc_struct.origin, loc_struct.angles );
			
			RecordLine( self.origin, loc_struct.origin, (0,1,0), "Script", self );
		
			mine playsound( "so_claymore_plant" );
		
			mine thread claymore_on_trigger();
			mine thread claymore_on_damage();
			mine thread claymore_on_emp();
			mine thread check_bombsquad_visibility("weapon_claymore_detect");
		
		    level notify( "ai_claymore_planted" );
		}
		else if ( issubstr(ai_ref,"chemical") )
		{
			mine = self chembomb_create( loc_struct.origin, loc_struct.angles );
			
			mine playsound( "so_claymore_plant" );
			
			mine thread chembomb_on_trigger();
			mine thread chembomb_on_damage();
			
			level notify( "ai_chembomb_planted" );
		}
		else
		{
			AssertMsg( "Invalid AI type told to plant mine: " + ai_ref );
		}
		
		Assert( IsDefined( mine ), "Failed to create mine using AI Type: " + ai_ref );

		// If a mine was successfully created store it and continue
		if ( IsDefined( mine ) )
		{
			if ( !isdefined( level.so_mines ) )
				level.so_mines = [];
			
			level.so_mines[ level.so_mines.size ] = mine;
			
			mine thread mine_on_death( loc_struct );
		
			wait 0.25;

			// Drop the weight down so AI don't place at the same point
			// over and over
			loc_struct.weight *= 0.5;
		}
	}
	
	self allowedstances( "prone", "crouch", "stand" );
	self.goalradius = goal_radius;
	self.ignoreall = false;
	self.ignoreme = false;
	
	self.planting = undefined;
	self notify( "planting_done" );
	
	// Go back to basic aggressing or default behavior
	ai_ref = self get_ai_type_ref();
	if ( IsSubStr(ai_ref, "claymore") )
	{
		self thread behavior_special_ai_claymore();
	}
	else if ( IsSubStr(ai_ref, "chemical") )
	{
		self thread behavior_special_ai_chemical();
	}
}

mine_ai_planting_death( loc_struct )
{	
	self endon( "planting_done" );
	level endon( "special_op_terminated" );
	
	self waittill( "death" );
	
	loc_struct.occupied = undefined;
}

claymore_create( origin, angles, drop )
{
	assert( isdefined( origin ) );
	assert( isdefined( angles ) );
	
	claymore = spawn( "script_model", origin );
	claymore setmodel( "weapon_claymore" );
	
	if ( !isdefined( drop ) || drop )
		claymore.origin = GROUNDPOS( self, origin );
	
	claymore.angles = (0, angles[ 1 ], 0);
	
	playfxontag( getfx( "claymore_laser" ), claymore, "tag_fx" );
	
	if ( isdefined( self ) && isalive( self ) )
		claymore.owner = self;
	
	return claymore;
}

claymore_on_trigger()
{
	self endon( "death" );
	level endon( "special_op_terminated" );

	trig_spawn_flags = 6;	// AI_ALLIES AI_NEUTRAL & player
	
	trig_claymore = spawn( "trigger_radius", self.origin + ( 0, 0, 0 - CONST_CLAYMORE_ENT_TRIG_RADIUS ), trig_spawn_flags, CONST_CLAYMORE_ENT_TRIG_RADIUS, CONST_CLAYMORE_ENT_TRIG_RADIUS * 2 );

	self thread mine_delete_on_death( trig_claymore );

	while ( 1 )
	{
		trig_claymore waittill( "trigger", activator );

		if ( isdefined( self.owner ) && activator == self.owner )
			continue;
		
		if ( isdefined( self.disabled ) )
		{
			self waittill( "enabled" );
			continue;	
		}
		
		if ( activator claymore_on_trigger_laser_check( self ) )
		{
			self notify( "triggered" );	
			self claymore_detonate( CONST_CLAYMORE_ENT_TIMER );
			
			return;
		}
	}
}

// Ripped right from mp/_weapons.gsc - Joe
claymore_on_trigger_laser_check( claymore )
{
	if ( isDefined( claymore.disabled ) )
		return false;

	pos = self.origin + ( 0, 0, 32 );

	dirToPos = pos - claymore.origin;
	claymoreForward = anglesToForward( claymore.angles );

	dist = vectorDot( dirToPos, claymoreForward );
	if ( dist < CONST_CLAYMORE_ENT_TRIG_DIST_MIN )
		return false;

	dirToPos = vectornormalize( dirToPos );
	
	dot = vectorDot( dirToPos, claymoreForward );
	
	if ( !isdefined( level.so_claymore_trig_dot ) )
		level.so_claymore_trig_dot = cos( CONST_CLAYMORE_ENT_TRIG_ANGLE );
	
	return( dot > level.so_claymore_trig_dot );
}

claymore_detonate( timer )
{
	assert( isdefined( self ) );
	
	if ( isdefined( self.so_claymore_activated ) )
		return;
		
	self.so_claymore_activated = true;
		
	level endon( "special_op_terminated" );
		
	self playsound( "claymore_activated_SP" );
	
	if ( isdefined( timer ) && timer > 0 )
		wait timer;

	assert( isdefined( self ) );
	
	self playsound( "detpack_explo_main", "sound_done" );
	playfx( level._effect[ "claymore_explosion" ], self.origin );
	physicsexplosioncylinder( self.origin, CONST_CLAYMORE_ENT_PHYS_RADIUS, 1, CONST_CLAYMORE_ENT_PHYS_FORCE );
	earthquake( CONST_CLAYMORE_ENT_QUAKE_SCALE, CONST_CLAYMORE_ENT_QUAKE_TIME, self.origin, CONST_CLAYMORE_ENT_QUAKE_RADIUS );
	
//	stopfxontag( getfx( "claymore_laser" ), self, "tag_fx" );
	
	radiusdamage( self.origin, CONST_CLAYMORE_ENT_DMG_RADIUS, CONST_CLAYMORE_ENT_DMG_MAX, CONST_CLAYMORE_ENT_DMG_MIN, undefined, "MOD_EXPLOSIVE" );

	level.so_mine_last_detonate_time = gettime();
	
	if ( isdefined( self ) )
		self delete();	
}

mine_delete_on_death( trig )
{
	level endon( "special_op_terminated" );
	
	self waittill( "death" );

	level.so_mines = array_remove_nokeys( level.so_mines, self );
	
	wait 0.05;
	
	if ( isdefined( trig ) )
		trig delete();
}

claymore_on_damage()
{
	self endon( "death" );
	self endon( "triggered" );
	
	level endon( "special_op_terminated" );

	// Apparently health has to be set before candamage so that health can be set after... - JC
	self.health = 100;
	self setcandamage( true );
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	self waittill( "damage", amount, attacker );
	
	timer = 0.05;
	if ( mine_so_detonated_recently() )
		timer = 0.1 + randomfloat( 0.4 );
		
	self claymore_detonate( timer );
}

mine_so_detonated_recently()
{
	return IsDefined( level.so_mine_last_detonate_time ) && gettime() - level.so_mine_last_detonate_time < 400;
}

// JC-ToDo: Currently there is no script logic managing emp_damage
// delegation like there is in multiplayer so this won't ever run.
claymore_on_emp()
{
	self endon( "death" );
	self endon( "triggered" );
	
	level endon( "special_op_terminated" );

	while( 1 )
	{
		self waittill( "emp_damage", attacker, duration );

		plaYfxOnTag( getfx( "claymore_disabled" ), self, "tag_origin" );

		self.disabled = true;
		self notify( "disabled" );

		wait( duration );

		self.disabled = undefined;
		self notify( "enabled" );
	}	
}

check_bombsquad_visibility( model )
{
	self endon( "death" );
	self endon( "triggered" );
	
	level endon( "special_op_terminated" );
	
	recon_model = Spawn( "script_model", self.origin );
	recon_model.angles = self.angles;
	recon_model SetModel( model );
	
	self thread delete_recon_model( recon_model );
	
	while( true )
	{
		player = get_players()[0];
		if( IsDefined( player ) && player HasPerk( "specialty_detectexplosive" ) )
		{
			recon_model Show();
		}
		else
		{
			recon_model Hide();
		}
		wait 0.05;
	}
}

delete_recon_model( recon_model )
{
	self waittill_either( "death", "triggered" );
	
	recon_model Delete();
}

mine_on_death( struct_loc )
{
	assert( isdefined( struct_loc ) && isdefined( struct_loc.occupied ), "Mine on death called on undefined entity or mine that was not occupied." );
	
	level endon( "special_op_terminated" );
	
	self waittill( "death" );
	struct_loc.occupied = undefined;
}

// ==========================================================================
// CHEMICAL WARFARE AI
// ==========================================================================

behavior_special_ai_chemical()
{
	// If currently planting ignore new behavior calls from the
	// war wave logic
	if ( isdefined( self.planting ) )
		return;
		
	self endon( "death" );
	self endon( "ai_behavior_change" );
	
	// setup AI chemical ability
	if ( !isdefined( self.special_ability ) )
		self thread chemical_ability();
	
	engage_min_dist				= 0;
	engage_min_dist_fall_off	= 0;
	
	if ( isdefined( self.aggressing ) && self.aggressing )
	{
		engage_min_dist 			= CONST_GENERIC_AI_ENGAGE_MIN;
		engage_min_dist_fall_off	= CONST_GENERIC_AI_ENGAGE_MIN_FALL_OFF;
		self.goalradius 			= CONST_CHEMICAL_GOAL_RADIUS_AGGRESSIVE;
		
		self enable_heat_behavior( true );
		self disable_react();
	}
	else
	{
		engage_min_dist				= 120;
		engage_min_dist_fall_off	= 60;
		self.goalradius 			= CONST_CHEMICAL_GOAL_RADIUS_DEFAULT;
	}
	
	self setengagementmindist( engage_min_dist, engage_min_dist_fall_off );
	self setengagementmaxdist( 512, 768 );
	
	self thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, self.goalradius, "ai_behavior_change" );
}

chemical_ability()
{
	self.special_ability = true;
	
	self.ignoresuppression 				= true;
	self.no_pistol_switch 				= true;
	self.noRunNGun 						= true;
	self.disableExits 					= true;
	self.disableArrivals 				= true;
	self.disableBulletWhizbyReaction 	= true;
	self.combatMode 					= "no_cover";
	self.neverSprintForVariation 		= true;
	
	// Prevent laying down with tank
	self disable_long_death();
	
	self disable_react();
	
	tank = self chemical_ability_attach_tank( "tag_shield_back", (0,0,0), (0,90,0) );
	
	self thread chemical_ability_tank_spew( tank );
	self thread chemical_ability_on_tank_damage( tank );
	self thread chemical_ability_on_death( tank );
}

chemical_ability_attach_tank( tag, origin_offset, angle_offset )
{	
	tank = spawn( "script_model", self gettagorigin( tag ) + origin_offset );
	tank setmodel( "gas_canisters_backpack" );
	tank.health = 99999;
	tank setcandamage( true );
	
	tank linkto( self, tag, origin_offset, angle_offset );
	
	return tank;
}

chemical_ability_tank_spew( tank )
{
	self endon( "death" );
	tank endon( "death" );
	
	while( 1 )
	{
		playfxontag( getfx( "chemical_tank_smoke" ), self, "tag_shield_back" );
		wait 0.05;
	}
}

chemical_ability_on_tank_damage( tank )
{
	self endon( "death" );
	self endon( "tank_detonated" );
	
	level endon( "special_op_terminated" );

	while( 1 )
	{
		tank waittill( "damage", damage, attacker, dir, point, dmg_type, model, tag, part, dFlags, weapon );
		
		if	( 
			isPlayer( attacker ) 
		||	dmg_type == "MOD_EXPLOSIVE"
		||	dmg_type == "MOD_GRENADE" 
		||	dmg_type == "MOD_GRENADE_SPLASH"
			)
		{
			// Thread because this function ends on death
			self thread  maps\_so_war_support::so_kill_ai( attacker, dmg_type, weapon );
			return;
		}
	}
}

chemical_ability_on_death( tank )
{
	self endon( "tank_detonated" );
	
	level endon( "special_op_terminated" );
	
	self waittill( "death", attacker );
	
	if ( !isdefined( self ) )
	{
		if ( isdefined( tank ) )
		{
			wait 0.05;
			tank delete();
		}
		return;
	}
	
	self thread chemical_ability_detonate( tank, attacker );
}

chemical_ability_detonate( tank, attacker )
{
	if ( !isdefined( tank ) || isdefined( tank.detonated ) )
		return;
		
	tank.detonated = true;
	
	//Assert( isdefined( self ), "Self not valid after death for tank detonation. This shouldn't happen." );
	if ( !isdefined( self ) )
		return;
	
	self notify( "tank_detonated" );
	explode_origin = self.origin;
	
	tank playsound( "detpack_explo_main", "sound_done" );
	PhysicsExplosionCylinder( explode_origin, CONST_CHEMICAL_TANK_PHYS_RADIUS, 1, CONST_CHEMICAL_TANK_PHYS_FORCE );
	earthquake( CONST_CHEMICAL_TANK_QUAKE_SCALE, CONST_CHEMICAL_TANK_QUAKE_TIME, explode_origin, CONST_CHEMICAL_TANK_QUAKE_RADIUS );
	
	// Clear removed attacker reference
	attacker = ( isdefined( attacker ) ? attacker : undefined );
	
	// Trying not having the tank do damage so tanks don't chain react
	//tank radiusdamage( tank.origin, CONST_CHEMICAL_TANK_DMG_RADIUS, CONST_CHEMICAL_TANK_DMG_MAX, CONST_CHEMICAL_TANK_DMG_MIN, attacker, "MOD_GRENADE_SPLASH" );
	
	// Smoke
	playfx( getfx( "chemical_tank_explosion" ), explode_origin );
	
	thread chemical_ability_gas_cloud( explode_origin, CONST_CHEMICAL_CLOUD_LIFE_TIME, CONST_CHEMICAL_CLOUD_BADPLACE_LIFE_TIME );
	
	tank unlink();
	// Wait at least 0.05 to avoid error: cannot delete during think :-/
	wait 0.05;
	tank delete();
}

chemical_ability_gas_cloud( cloud_origin, cloud_time, bad_place_time )
{
	level endon( "special_op_terminated" );
	
	trig_spawn_flags = 7;	// AI_AXIS AI_ALLIES AI_NEUTRAL player	
	trig_smoke = spawn( "trigger_radius", cloud_origin + ( 0, 0, 0 - CONST_CHEMICAL_CLOUD_TRIG_RADIUS ), trig_spawn_flags, CONST_CHEMICAL_CLOUD_TRIG_RADIUS, CONST_CHEMICAL_CLOUD_TRIG_RADIUS * 2 );
	BadPlace_Cylinder( "", bad_place_time, cloud_origin, CONST_CHEMICAL_CLOUD_TRIG_RADIUS, CONST_CHEMICAL_CLOUD_TRIG_RADIUS, "axis", "allies" );
	
	trig_smoke endon( "smoke_done" );
	trig_smoke thread do_in_order( ::_wait, cloud_time, ::send_notify, "smoke_done" );
	
	while ( 1 )
	{
		trig_smoke waittill( "trigger", activator );
		
		if ( !isdefined( activator ) || !isalive( activator ) )
			continue;
		
		// If the player isn't currently gassed, gas them
		// with the appropriate shell shock
		if ( isplayer( activator ) )
		{
			// If player is down don't stomp the laststand shocks
			if ( is_player_down( activator ) || is_player_down_and_out( activator ) )
				continue;
				
			// Don't gas if player is already gassed
			if ( isdefined( activator.gassed ) )
				continue;
			
			shock_type = "";
			current_time = gettime();
			
			if	(
				!isdefined( activator.gassed_before )
			||	( isdefined( activator.gas_time ) && current_time - activator.gas_time > CONST_CHEMICAL_CLOUD_SHOCK_TIME * 1000 )
				)
			{
				shock_type = "radiation_low";
			}
			else
			{
				if ( activator.gas_shock == "radiation_low" )
					shock_type = "radiation_med";
				else
					shock_type = "radiation_high";
			}
			
			activator.gassed_before = true;
			activator.gas_shock = shock_type;
			activator.gas_time = current_time;
			activator shellshock( shock_type, CONST_CHEMICAL_CLOUD_SHOCK_TIME );
			
			activator.gassed = true;
			activator thread chemical_ability_remove_gas_flag( CONST_CHEMICAL_CLOUD_SHOCK_DELAY );
		}
		
		if ( isAI( activator ) )
		{
			// JC-ToDo: Add AI gas functionality, vomitting, running away, etc.	
		}
	}
}

chemical_ability_remove_gas_flag( delay )
{
	assert( isdefined( self ) && isdefined( self.gassed ), "Invalid self or missing gas flag to remove" );
	self endon( "death" );
	wait delay;
	self.gassed = undefined;
}

chembomb_create( origin, angles, drop )
{
	assert( isdefined( origin ) );
	assert( isdefined( angles ) );
	
	chembomb = spawn( "script_model", origin );
	chembomb setmodel( "ims_scorpion_explosive1" );
	
	if ( !isdefined( drop ) || drop )
	{
		// Drop to the ground with an offset since
		// the model origin is lower than the claymore
		chembomb.origin = GROUNDPOS( self, origin ) + ( 0, 0, 5 );
	}

	chembomb.angles = (0, angles[ 1 ], 0);
	
	chembomb.tag_origin = chembomb spawn_tag_origin();
	
	chembomb.tag_origin LinkTo( chembomb, "tag_explosive1", (0,0,6), (-90, 0, 0) );
	
	PlayFXOnTag( getfx( "chemical_mine_spew" ), chembomb.tag_origin, "tag_origin" );
	
	if ( isdefined( self ) && isalive( self ) )
		chembomb.owner = self;
	
	return chembomb;
}

chembomb_on_trigger()
{
	self endon( "death" );
	level endon( "special_op_terminated" );

	trig_spawn_flags = 6;	// AI_ALLIES AI_NEUTRAL & player
	
	trig_mine = spawn( "trigger_radius", self.origin + ( 0, 0, 0 - CONST_CHEMBOMB_ENT_TRIG_RADIUS ), trig_spawn_flags, CONST_CHEMBOMB_ENT_TRIG_RADIUS, CONST_CHEMBOMB_ENT_TRIG_RADIUS * 2 );

	self thread mine_delete_on_death( trig_mine );
	
	while ( 1 )
	{
		trig_mine waittill( "trigger", activator );

		if ( isdefined( self.owner ) && activator == self.owner )
			continue;
		
		if ( isdefined( self.disabled ) )
		{
			self waittill( "enabled" );
			continue;	
		}
		
		self notify( "triggered" );	
		self chembomb_detonate( CONST_CHEMBOMB_ENT_TIMER );
		return;
	}
}

chembomb_on_damage()
{
	self endon( "death" );
	self endon( "triggered" );
	
	level endon( "special_op_terminated" );

	// Apparently health has to be set before candamage so that health can be set after... - JC
	self.health = 100;
	self setcandamage( true );
	self.maxhealth = 100000;
	self.health = self.maxhealth;
	
	self waittill( "damage", amount, attacker );
	
	timer = 0.05;
	if ( mine_so_detonated_recently() )
		timer = 0.1 + randomfloat( 0.4 );
		
	self chembomb_detonate( timer );
}

chembomb_detonate( timer )
{
	Assert( IsDefined( self ) );
	
	if ( IsDefined( self.chembomb_activated ) )
		return;
		
	self.chembomb_activated = true;
	
	level endon( "special_op_terminated" );
		
	self PlaySound( "claymore_activated_SP" );
	
	if ( IsDefined( timer ) && timer > 0 )
		wait timer;

	Assert( IsDefined( self ) );
	
	level.so_mine_last_detonate_time = GetTime();
	
	self PlaySound( "detpack_explo_main", "sound_done" );
	PhysicsExplosionCylinder( self.origin, CONST_CHEMICAL_TANK_PHYS_RADIUS, 1, CONST_CHEMICAL_TANK_PHYS_FORCE );
	Earthquake( CONST_CHEMICAL_TANK_QUAKE_SCALE,CONST_CHEMICAL_TANK_QUAKE_TIME, self.origin, CONST_CHEMICAL_TANK_QUAKE_RADIUS );
	
	// Smoke
	PlayFX( getfx( "chemical_tank_explosion" ), self.origin );
	
	// Turn off spew
//	StopFXOnTag( getfx( "chemical_mine_spew" ), self.tag_origin, "tag_origin" );
	
	thread chemical_ability_gas_cloud( self.origin, CONST_CHEMBOMB_CLOUD_LIFE_TIME, CONST_CHEMBOMB_CLOUD_BADPLACE_LIFE_TIME );
	
	self.tag_origin Delete();
	
	// Prevent cannot delete during think error though may not
	// be necessary because it's not linked... -JC
	wait 0.05;
	
	if ( IsDefined( self ) )
		self Delete();
}

// ==========================================================================
// DOG TEST
// ==========================================================================

dog_relocate_init()
{
	level.dog_reloc_trig_array = getentarray( "dog_relocate", "targetname" );
	
	if ( !isdefined( level.dog_reloc_trig_array ) || level.dog_reloc_trig_array.size == 0 )
		return;
		
	foreach ( loc_trig in level.dog_reloc_trig_array )
	{
		assert( isdefined( loc_trig.target ) );
		reloc_struct = getstruct( loc_trig.target, "targetname" );
		loc_trig.reloc_origin = reloc_struct.origin;
		loc_trig thread dog_reloc_monitor();
	}
}

dog_reloc_monitor()
{
	level endon( "special_op_terminated" );
	
	while ( 1 )
	{
		self waittill( "trigger", player );
		while ( player istouching( self ) )
		{
			player.dog_reloc = self.reloc_origin;
			wait 0.05;
		}
		player.dog_reloc = undefined;
	}
}

spawn_dogs( dog_type, quantity )
{
	level endon( "special_op_terminated" );
	level endon( "wave_ended" );
	
	if ( !isdefined( dog_type ) || dog_type == "" || !isdefined( quantity ) || !quantity )
		return;
	
	level.dogs = [];
	
	// spawn far away from both players
	avoid_locs = [];
	foreach ( player in level.players )
		avoid_locs[ avoid_locs.size ] = player;

	dog_spawner			= getentarray( "dog_spawner_war", "targetname" )[ 0 ];
	assert( isdefined( dog_spawner ), "No dog spawner while trying to spawn dog; targetname = dog_spawner" );
	
	// dog_setup() will gives dogs c4 if this is true
	level.dogs_attach_c4 = isdefined( dog_type ) && dog_type == "dog_splode";
	
	// doggy go!
	dog_spawner add_spawn_function( ::dog_setup );
	dog_spawner add_spawn_function( ::dog_seek_player );
	dog_spawner add_spawn_function( ::dog_register_death );	
	
	for ( i = 0; i < quantity; i ++ )
	{	
		spawn_loc 			= get_furthest_from_these( level.wave_spawn_locs, avoid_locs, 4 );
		dog_spawner.count 	= 1;
		dog_spawner.origin 	= spawn_loc.origin;
		dog_spawner.angles 	= (isDefined(spawn_loc.angles)?spawn_loc.angles:(0,0,0));
		wait_between_spawn 	= int ( ( (CONST_DOG_SPAWN_OVER_TIME-10) + randomint(10) )/quantity );
		
		// Let get_dog_count() know a dog is on the way
		level.war_dog_spawning = true;
		
		doggy = simple_spawn_single(dog_spawner, undefined, undefined, undefined, undefined, undefined, undefined, true);	
		if (isDefined(doggy))
		{
			doggy.ai_type = get_ai_struct( dog_type );
			doggy setthreatbiasgroup( "dogs" );
			doggy [[ level.attributes_func ]](); // dog gets: health and speed from this func
	
			//assert( isdefined( doggy ), "Doggy failed to spawn even though it was forced spawned." );
			level.dogs[ level.dogs.size ] = doggy;
		}
		
		// Dog has now been spawned and is in the level.dogs array
		level.war_dog_spawning = undefined;
		
		// if aggressive, then send out all dogs
		if ( !flag( "aggressive_mode" ) )
			waittill_any_timeout( wait_between_spawn, "aggressive_mode" );
		
		wait 0.05; // in case aggressive_mode is triggered in the same frame
	}
}

dog_setup()
{
	// Make dogs ignore other dogs c4. I mean c'mon, they're dogs. They don't know any better.
	// ... or do they? DON DON DONGGG!
	self.badplaceawareness = 0;
	self.grenadeawareness = 0;
	
	if ( isdefined( level.dogs_attach_c4 ) && level.dogs_attach_c4 )
	{
		self thread attach_c4( "j_hip_base_ri", (6,6,-3), (0,0,0) );
		self thread attach_c4( "j_hip_base_le", (-6,-6,3), (0,0,0) );
		
		// Keep c4 time consistent with martyrdom c4. If the dog
		// is killed during pin this function adjustst the time
		self thread detonate_c4_when_dead( CONST_MARTYRDOM_C4_TIMER, CONST_MARTYRDOM_C4_TIMER_SUBSEQUENT );
	}
}

dog_register_death()
{
	self waittill( "death" );
	
	level.dogs = dog_get_living();
}

dog_seek_player()
{
	level endon( "special_op_terminated" );
	level endon( "wave_ended" );
	self endon( "death" );
	
	// TO DO: Tweak
	self.moveplaybackrate 	= 0.75;
	self.goalheight 		= 80;
	self.goalradius 		= 300;
	
	update_delay = 1.0;
	
	while ( 1 )
	{	
		closest_player = get_closest_player_healthy( self.origin );
		if ( !IsDefined( closest_player ) )
		{
			closest_player 	= get_closest_player( self.origin );
		}

		if ( IsDefined( closest_player ) )
		{
			if ( IsDefined( closest_player.dog_reloc ) )
			{
				self SetGoalPos( closest_player.dog_reloc );
			}
			// Code doesn't notify dogs with "bad_path" when 
			// they're given a bad goal position or bad goal
			// entity. Because of this, assume the dog was given
			// a bad location while the target player is outside
			// of the dog's goal radius and send the dog to the
			// closest node to that player.
			else if ( DistanceSquared( self.origin, closest_player.origin ) > SQR(self.goalradius))
			{
				// If the player is in a bad location that the dog
				// cannot path to the dog does not respond to
				// the SetGoalPos() call in manage_ai_go_to_player_node().
				// To force the dog to respond to this call make him
				// ignoreall until he's within his goal radius of the 
				// target player. -_-
				self.ignoreall = true;
				self manage_ai_go_to_player_node( closest_player );
			}
			else
			{
				// See the ignorall comment in the above
				// if block to know why this has to be done
				self.ignoreall = false;
				self SetGoalPos( closest_player.origin );
			}
		}

		wait update_delay;
	}
}

// ==========================================================================
// JUGGERNAUT BOSSES
// ==========================================================================

add_level_boss()
{
	assert( IsDefined(self) && IsAlive(self) );

	level.bosses[ level.bosses.size ] = self;
	self thread clear_from_boss_array_when_dead();
	self.isboss = true;

	flag_set( "bosses_spawned" );
}

war_boss_juggernaut()
{
	// juggernaut currently is handled by _so_war.gsc
}

is_juggernaut_used( AI_bosses )
{
	foreach( boss_ref in AI_bosses )
		if ( issubstr( boss_ref, "jug_" ) )	
			return true;
			
	return false;
}

spawn_juggernaut( boss_ref, path_start )
{
	//iprintlnbold( "Boss: Juggernaut!" );
	level endon( "special_op_terminated" );
	
	// there is a wait in drop_jug_by_chopper
	boss = drop_jug_by_chopper( boss_ref, path_start );
	
	if ( !isdefined( boss ) )
		return;

	// keeps track of boss type on boss AI
	boss.ai_type = get_ai_struct( boss_ref );
		
	// give juggernaut loot if any is available
	boss maps\_so_war_loot::loot_roll( 0.0 );

	boss add_level_boss();
	
	// Wait till the vehicle is done with the Juggernaut before
	// setting him up
	//boss waittill( "jumpedout" );
	level notify( "juggernaut_jumpedout" );
	
	boss thread war_boss_behavior();
}

// spawn juggernaut by spawner_type and dropped in by chopper
drop_jug_by_chopper( spawner_type, chopper_path )
{
	spawner = get_spawners_by_targetname( spawner_type )[ 0 ];
	assert( isdefined( spawner ), "Type: " + spawner_type + " does not have a spawner present in level." );
	
	// plays money FX when dead
	//spawner add_spawn_function( ::money_fx_on_death );

	// This flags the desired path as in use before a potential wait occurs
	// because a chopper spawner is in use
	chopper = maps\_so_war_support::chopper_spawn_from_targetname_and_drive( "jug_drop_chopper", chopper_path.origin, chopper_path, "axis" );
	chopper SetTeam( "axis" );
//	chopper thread maps\_chopperboss::chopper_path_release(  "reached_dynamic_path_end death deathspin" );
	
	// Juggernaut choppers should not get shot down.
	chopper godon();
	
	// removed from remote missile targeting due to this chopper being in godon mode
	//chopper thread maps\_remotemissile_utility::setup_remote_missile_target();
	
	chopper.script_vehicle_selfremove = true;
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );
	chopper thread chopper_drop_smoke_at_unloading();
	
	// load pilot and the Juggernaut
	//chopper chopper_spawn_pilot_from_targetname( "jug_drop_chopper_pilot" );
	//boss = chopper chopper_spawn_passenger( spawner );

	chopper.custom_unload = true;

	// In case the chopper can be killed
	chopper endon( "death" );

	// AP_TODO: port over their vehicle rider stuff, if we want it
	//chopper chopper_spawn_pilot_from_targetname( "friendly_support_delta" );

	chopper waittill( "unload" );

	// let the smoke settle in
	wait(1);

	// AP_TODO: if this was handled internally via vehicle ai anim stuff, then the chopper would wait automatically
	chopper Vehicle_SetSpeed( 0, 30, 30 );	

	boss = chopper_rappel( chopper, array(spawner) )[0];

	chopper notify( "unloaded" );

	boss setthreatbiasgroup( "boss" );

	chopper vehicle_resumepathvehicle();
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );	

	// AP_TODO: delete when end reached
	level thread removeChopper( chopper, 10, chopper_path );

	return boss;
}

spawn_bigdog( boss_ref, path_start )
{
	//iprintlnbold( "Boss: Juggernaut!" );
	level endon( "special_op_terminated" );

	// there is a wait in drop_jug_by_chopper
	boss = drop_bigdog_by_chopper( boss_ref, path_start );

	if ( !isdefined( boss ) )
		return;

	// keeps track of boss type on boss AI
	boss.ai_type = get_ai_struct( boss_ref );

	// give juggernaut loot if any is available
	boss maps\_so_war_loot::loot_roll( 0.0 );

	boss add_level_boss();

	// Wait till the vehicle is done with the Juggernaut before
	// setting him up
	//boss waittill( "jumpedout" );
	level notify( "juggernaut_jumpedout" );

	boss thread war_boss_behavior();
}

drop_bigdog_by_chopper( spawner_type, chopper_path )
{
	spawner = get_spawners_by_targetname( spawner_type )[ 0 ];
	assert( isdefined( spawner ), "Type: " + spawner_type + " does not have a spawner present in level." );

	spawnGuards = false;
	if( IsSubStr(spawner_type, "guards") )
	{
		spawnGuards = true;

		jug_spawner = get_spawners_by_targetname( "jug_regular" )[ 0 ];
		assert( isdefined( jug_spawner ), "Type: " + "jug_regular" + " does not have a spawner present in level." );
	}

	// This flags the desired path as in use before a potential wait occurs
	// because a chopper spawner is in use
	chopper = maps\_so_war_support::chopper_spawn_from_targetname_and_drive( "jug_drop_chopper", chopper_path.origin, chopper_path, "axis" );
	chopper SetTeam( "axis" );
	//	chopper thread maps\_chopperboss::chopper_path_release(  "reached_dynamic_path_end death deathspin" );

	// attach the bigdog
	spawner.count = 1; // make sure count > 0
	spawner.origin = chopper.origin + (0, 0, -200);

	bigdog = simple_spawn_single( spawner );
	bigdog LinkTo( chopper );

	// Juggernaut choppers should not get shot down.
	chopper godon();

	chopper.script_vehicle_selfremove = true;
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );
	chopper thread chopper_drop_smoke_at_unloading();

	chopper.custom_unload = true;

	// In case the chopper can be killed
	chopper endon( "death" );

	chopper waittill( "unload" );

	// AP_TODO: if this was handled internally via vehicle ai anim stuff, then the chopper would wait automatically
	chopper Vehicle_SetSpeed( 0, 30, 30 );	

	bigdog Unlink();

	bigdog thread enemy_setup( spawner.targetname );
	bigdog thread manage_ai_relative_to_player( 2.0, 256, "new_bigdog_behavior", "stop_hunting" );

	// retaliate on heavy damage
	bigdog.hitCountLauncherThreshold = 5;

	// bring it down
	groundPos = GROUNDPOS( self, bigdog.origin );
	
	offset = bigdog.origin - groundPos;

	frames = int(3 * 20);
	offsetreduction = VectorScale( offset, 1.0 / frames );

	for ( i = 0; i < frames; i++ )
	{
		offset -= offsetreduction;
		bigdog ForceTeleport( groundPos + offset );
		wait .05;
	}

	bigdog notify("rappel_done");
	bigdog setthreatbiasgroup( "boss" );

	if( spawnGuards )
	{
		bigdog_guards = chopper_rappel( chopper, array(jug_spawner, jug_spawner), ::setup_bigdog_guard, bigdog );

		array_thread( bigdog_guards, ::add_level_boss );
	}

	chopper notify( "unloaded" );

	chopper vehicle_resumepathvehicle();
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );	

	// AP_TODO: delete when end reached
	level thread removeChopper( chopper, 10, chopper_path );

	return bigdog;
}

setup_bigdog_guard( bigdog )
{
	self waittill( "rappel_done" );

	self maps\_juggernaut::make_juggernaut( false );
	self global_jug_behavior();
	self thread boss_jug_bigdog_guard();
	self thread maps\_juggernaut::juggernaut_protect_behavior( bigdog );
}

removeChopper( chopper, waitTime, chopperPath )
{
	wait( waitTime );
	if (isDefined(chopper))
		chopper Delete();

	chopperPath.in_use = undefined;
}

// progressively behave or look different when damaged
progressive_damaged()
{
	self endon( "death" );
	self endon( "new_jug_behavior" );
	
	while ( 1 )
	{
		if ( self.health <= CONST_JUG_WEAKENED )
		{
			self.walkDist 				= CONST_JUG_WEAKENED_RUN_DIST;
			self.walkDistFacingMotion 	= CONST_JUG_WEAKENED_RUN_DIST;

			// walkDist isn't hooked up in t6
			level.JUGGERNAUT_SPRINTDISTSQ = CONST_JUG_WEAKENED_RUN_DIST * CONST_JUG_WEAKENED_RUN_DIST;
		}
		else
		{
			self.walkDist 				= CONST_JUG_RUN_DIST; //500;
			self.walkDistFacingMotion 	= CONST_JUG_RUN_DIST; //500;

			// walkDist isn't hooked up in t6
			level.JUGGERNAUT_SPRINTDISTSQ = CONST_JUG_RUN_DIST * CONST_JUG_RUN_DIST;
		}

		// TO DO: armor plate falling and different behaviors
		wait 0.05;
	}	
}

// AI damage factors, amount of damage taken per damage type and hit location
damage_factor()
{
/*  "MOD_UNKNOWN"
	"MOD_PISTOL_BULLET"
	"MOD_RIFLE_BULLET"
	"MOD_GRENADE"
	"MOD_GRENADE_SPLASH"
	"MOD_PROJECTILE"	
	"MOD_PROJECTILE_SPLASH"
	"MOD_MELEE"
	"MOD_HEAD_SHOT"
	"MOD_CRUSH"
	"MOD_TELEFRAG"	
	"MOD_FALLING"
	"MOD_SUICIDE"
	"MOD_TRIGGER_HURT"
	"MOD_EXPLOSIVE"
	"MOD_IMPACT"		*/	

	self endon( "death" );
	self endon( "new_jug_behavior" );
	
	// need this so we dont have anything else increasing its health when hit
	self.bullet_resistance = 0;
	while ( 1 )
	{
		self waittill( "damage", amount, attacker, direction_vec, point, type, modelName, tagName, partName, iDFlags, weapon );
		
		// No damage modification when bullet shield is on
		if ( isdefined( self.magic_bullet_shield ) )
			continue;
		
		// damage types:
		damage_heal = 0;
		headshot = false;
		
		if(	type == "MOD_MELEE" )
		{
			if ( isdefined( attacker ) && isplayer( attacker ) && isdefined( weapon ) && IsSubStr( weapon, "riotshield_so" ) )
				damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "melee_riotshield" ] );
			else
				damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "melee" ] );
		}
		else if	(	
			   type == "MOD_EXPLOSIVE"
			|| type == "MOD_GRENADE" 
			|| type == "MOD_GRENADE_SPLASH" 
			|| type == "MOD_PROJECTILE" 
			|| type == "MOD_PROJECTILE_SPLASH" 
				)
		{
			damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "explosive" ] );
		}
		else
		{
			// damage locations:
			if(	self was_headshot() )
			{
				damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "headshot" ] );
				headshot = true;
			}
			else
				damage_heal = self dmg_factor_calc( amount, self.dmg_factor[ "bodyshot" ] );
		}
		
		damage_heal = int( damage_heal );
		
		if ( damage_heal < 0 && abs( damage_heal ) >= self.health )
		{
			// If we're force killing the AI make sure to flag that it was a headshot
			// so that the was_headshot() function in war code can return correctly.
			if ( headshot )
				self.died_of_headshot = true;
					
			// Thread because this function ends on death
			self thread  maps\_so_war_support::so_kill_ai( attacker, type, weapon );
		}
		else
		{
			self.health += damage_heal;
		}
		
		self notify( "dmg_factored" );
	}
}

dmg_factor_calc( amount, dmg_factor )
{
	damage_heal = 0;
	
	if ( isdefined( dmg_factor ) && dmg_factor )
		damage_heal = int( amount * ( 1 - dmg_factor ) );
		
	return damage_heal;
}

// global juggernaut behavior
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
global_jug_behavior()
{
	// damge taken: (0-1) 1 = full damage - no shield; 0 = no damage - full shield
	self.dmg_factor[ "headshot" ] 			= 1;	// 100% damage to head
	self.dmg_factor[ "bodyshot" ] 			= 1;	// 100% damage to rest of body
	self.dmg_factor[ "melee" ] 				= 1;	// 100% damage by melee
	self.dmg_factor[ "melee_riotshield" ] 	= 1;	// 100% damage by riotshield
	self.dmg_factor[ "explosive" ] 			= 1;	// 100% damage by explosives

	self.dropweapon = false;
	self.minPainDamage = CONST_JUG_MIN_DAMAGE_PAIN;
	self.overrideActorDamage = undefined; // war does it own thing in damage_factor
	self set_battlechatter( false );
	self.aggressing = true;
	
	self thread damage_factor();
	self thread progressive_damaged();
}

boss_jug_helmet_pop( health_percent, arr_dmg_factor )
{
	assert( isdefined( self.dmg_factor ) && self.dmg_factor.size, "Juggernaut passed without dmg_factor array filled." );
	
	self endon( "death" );
	
	health_original = self.health;
	if ( isdefined( self.ai_type ) )
		health_original = self.ai_type.health;
	
	while ( 1 )
	{
		if ( self.health / health_original <= health_percent )
		{
			self animscripts\death::helmetpop();
			
			dmg_factor_size = self.dmg_factor.size;
			self.dmg_factor = array_combine_keys( self.dmg_factor, arr_dmg_factor );
			assert( self.dmg_factor.size == dmg_factor_size, "Damage factor array size changed, passed factor array had invalid keys." );
			
			return;
		}
		
		self waittill( "dmg_factored" );
	}
}

// regular juggernaut behavior
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
boss_jug_regular()
{
	self.dmg_factor[ "headshot" ] 			= CONST_JUG_LOW_SHIELD;
	self.dmg_factor[ "bodyshot" ] 			= CONST_JUG_MED_SHIELD;
	self.dmg_factor[ "melee" ] 				= CONST_JUG_HIGH_SHIELD;
	self.dmg_factor[ "melee_riotshield" ] 	= CONST_JUG_HIGH_SHIELD;
	
	self.dmg_factor[ "explosive" ] 			= CONST_JUG_MED_SHIELD;
	
	self setengagementmindist( 100, 60 );
	self setengagementmaxdist( 512, 768 );
		
	// Pulled from Juggernaut Hunting logic
	self.goalradius = 128;
	self.goalheight = 81;
	
//	Jug Does not currently have a helmet that can be popped
	// Pop helmet and adjust damage factor
//	arr_dmg_adjust = [];
//	arr_dmg_adjust[ "headshot" ] = CONST_JUG_KILL_ON_PAIN;
//	arr_dmg_adjust[ "explosive" ] = CONST_JUG_NO_SHIELD;
//	self thread boss_jug_helmet_pop( CONST_JUG_POP_HELMET_HEALTH_PERCENT, arr_dmg_adjust );
	
	// Hunt player
	self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
}

// juggernaut headshot only behavior
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=

boss_jug_headshot()
{
	// strong against all by the head
	self.dmg_factor[ "headshot" ] 			= CONST_JUG_NO_SHIELD;
	self.dmg_factor[ "bodyshot" ] 			= CONST_JUG_MED_SHIELD;
	self.dmg_factor[ "melee" ] 				= CONST_JUG_HIGH_SHIELD;
	self.dmg_factor[ "melee_riotshield" ] 	= CONST_JUG_HIGH_SHIELD;
	
	self.dmg_factor[ "explosive" ] 			= CONST_JUG_NO_SHIELD;
	
	self setengagementmindist( 100, 60 );
	self setengagementmaxdist( 512, 768 );
	
	// Pulled from Juggernaut Hunting logic
	self.goalradius = 128;
	self.goalheight = 81;
	
	// Hunt player
	self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
}

// juggernaut explosive only behavior
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
boss_jug_explosive()
{
	// explosives best, defense against
	self.dmg_factor[ "headshot" ] 			= CONST_JUG_MED_SHIELD;
	self.dmg_factor[ "bodyshot" ] 			= CONST_JUG_HIGH_SHIELD;
	self.dmg_factor[ "melee" ] 				= CONST_JUG_HIGH_SHIELD;
	self.dmg_factor[ "melee_riotshield" ] 	= CONST_JUG_HIGH_SHIELD;
	
	self.dmg_factor[ "explosive" ] 			= CONST_JUG_NO_SHIELD;

	self setengagementmindist( 100, 60 );
	self setengagementmaxdist( 512, 768 );
	
	// Pulled from Juggernaut Hunting logic
	self.goalradius = 128;
	self.goalheight = 81;
	
	// Hunt player
	self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
}

// juggernaut riotshield behavior
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
boss_jug_riotshield()
{
	self endon( "death" );
	self endon( "riotshield_damaged" );
	
	// weak against all but it has a riot shield
	self.dmg_factor[ "headshot" ] 			= CONST_JUG_LOW_SHIELD;
	self.dmg_factor[ "bodyshot" ] 			= CONST_JUG_LOW_SHIELD;
	self.dmg_factor[ "melee" ] 				= CONST_JUG_MED_SHIELD;
	self.dmg_factor[ "melee_riotshield" ] 	= CONST_JUG_MED_SHIELD;
	self.dmg_factor[ "explosive" ] 			= CONST_JUG_NO_SHIELD;
	
	self.dropRiotshield = true;
	
	// NOTE: Since subclass_riotshield() is called instead of subclass_juggernaut()
	//       We must take what is in subclass_juggernaut() that doesn't conflict with riotshield
	//		 and place it here for correct juggernaut behavior while using riotshield.
	self subclass_juggernaut_riotshield();
	
	// Drop the shield when damaged or when health low
	self thread juggernaut_abandon_shield();
	
	if ( CONST_JUG_RIOTSHIELD_BULLET_BLOCK )
		self.shieldBulletBlockLimit = 9999; // no reaction to bullet hits on shield

	self setengagementmindist( 100, 60 );
	self setengagementmaxdist( 512, 768 );
	
	// Pulled from Juggernaut Hunting logic
	self.goalradius = 128;
	self.goalheight = 81;
	self.usechokepoints = false;
	
	// Hunt player
	self thread manage_ai_relative_to_player( 2.0, self.goalradius, "new_jug_behavior", "stop_hunting" );
	
	// This needs to be set over and over because riotshield
	// logic sets this at certain points
	while ( 1 )
	{
		if ( self.health <= CONST_JUG_WEAKENED )
			self.minPainDamage = CONST_JUG_MIN_DAMAGE_PAIN_WEAK;
		else
			self.minPainDamage = CONST_JUG_MIN_DAMAGE_PAIN;
		wait 0.05;
	}
}

// bigdog guard juggernaut behavior
// =-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=
boss_jug_bigdog_guard()
{
	self.dmg_factor[ "headshot" ] 			= CONST_JUG_LOW_SHIELD;
	self.dmg_factor[ "bodyshot" ] 			= CONST_JUG_MED_SHIELD;
	self.dmg_factor[ "melee" ] 				= CONST_JUG_HIGH_SHIELD;
	self.dmg_factor[ "melee_riotshield" ] 	= CONST_JUG_HIGH_SHIELD;

	self.dmg_factor[ "explosive" ] 			= CONST_JUG_MED_SHIELD;
}

subclass_juggernaut_riotshield()
{
	self.juggernaut 					= true;

	//self.grenadeAmmo 					= 0;
	self.doorFlashChance 				= .05;
	self.aggressivemode 				= true;
	self.ignoresuppression 				= true;
	self.no_pistol_switch 				= true;
	self.noRunNGun 						= true;
	//self.dontMelee 					= true;
	
	// This breaks sprint functionality in _riotshield.gsc
	//self.disableExits 				= true;
	
	self.disableArrivals 				= true;
	self.disableBulletWhizbyReaction 	= true;
	self.combatMode 					= "no_cover";
	self.neverSprintForVariation 		= true;
	self.a.disableLongDeath 			= true;
	self.pathEnemyFightDist 			= 128;
	self.pathenemylookahead 			= 128;
	
//	self disable_turnAnims();
	self disable_react();
	
	// Riotshield Juggernauts always win melee
	self.meleeAlwaysWin					= true;
	
	if( !self isBadGuy() )
		return;
	
	// we already have looping music
	//self thread maps\_juggernaut::juggernaut_sound_when_player_close();
	
	level notify( "juggernaut_spawned" );
	self thread subclass_juggernaut_death();
}

juggernaut_abandon_shield()
{
	self endon( "death" );
	
	self thread juggernaut_abandon_shield_low_health( CONST_JUG_DROP_SHIELD_HEALTH_PERCENT );
	
	self waittill( "riotshield_damaged" );
	wait 0.05; // waittill variant riotshield model is set up
	
	self AI_drop_riotshield();

	if ( !isAlive( self ) )
		return;
	
//	self animscripts\riotshield\riotshield::riotshield_turn_into_regular_ai();
	
	// turn regular AI into juggernaut again
//	self thread maps\_juggernaut::subclass_juggernaut();	// restore regular juggernaut settings
	
	// End existing manage_ai() and damage_factor() threads
	self notify( "new_jug_behavior" );
	
	// run regular juggernaut behavior
	self global_jug_behavior();
	self thread boss_jug_regular();
}

juggernaut_abandon_shield_low_health( health_percent )
{
	self endon( "death" );
	self endon( "riotshield_damaged" );
	
	health_original = self.health;
	if ( isdefined( self.ai_type ) )
	{
		health_original = self.ai_type.health;
	}
	
	while ( 1 )
	{
		self waittill( "damage" );
		
		if ( self.health / health_original <= health_percent )
		{
			// Drop shield
			self notify( "riotshield_damaged" );
			return;
		}
	}
}

subclass_juggernaut_death()
{
	self endon( "new_jug_behavior" );
	self waittill( "death", attacker );
	
	// if riotshield, we drop shield
	self AI_drop_riotshield();	
	
	level notify( "juggernaut_died" );
	
	if ( ! isdefined( self ) )
		return;// deleted
	if ( ! isdefined( attacker ) )
		return;
	if ( ! isplayer( attacker ) )
		return;

	//attacker player_giveachievement_wrapper( "IM_THE_JUGGERNAUT" );
}

// ==========================================================================
// ENEMY CHOPPER BOSS
// ==========================================================================

war_boss_chopper()
{
//	maps\_chopperboss::chopper_boss_locs_populate( "script_noteworthy", "so_chopper_boss_path_struct" );
}

spawn_chopper_boss( boss_ref, path_start )
{		
	//iprintlnbold( "Boss: " + boss_ref );
	level endon( "special_op_terminated" );
	
	// chopper health defined from string table is set by chopper_spawn_from_targetname(...)
	chopper_boss = chopper_spawn_from_targetname( boss_ref, path_start.origin, "axis" );
	chopper_boss chopper_spawn_pilot_from_targetname( "jug_drop_chopper_pilot" );
	
//	chopper_boss thread maps\_remotemissile_utility::setup_remote_missile_target();

	// sets ai_type attribute struct
	chopper_boss.ai_type = get_ai_struct( boss_ref );
	chopper_boss [[ level.attributes_func ]](); // chopper gets speed set in this func
	
	// xp reward init for this vehicle - AIs spawned with _spawner.gsc run this already
	//if ( isdefined( level.xp_enable ) && level.xp_enable )
	//	chopper_boss thread maps\_rank::AI_xp_init();
		
	chopper_boss add_level_boss();
	
	// Chopper uses its own behavior function vs other AIs
//	chopper_boss thread maps\_chopperboss::chopper_boss_behavior_little_bird( path_start );
//	chopper_boss thread maps\_chopperboss::chopper_path_release( "death deathspin" );

	chopper_boss setthreatbiasgroup( "boss" );
	setthreatbias( "sentry", "boss", 1500 );// make the boss a bigger threat to allies
		
	return chopper_boss;
}



// ==========================================================================
// ALLY AI
// ==========================================================================

spawn_ally_team( ally_manifest, path_start, owner )
{
	ally_team = [];
	ally_spawners = [];
	
	foreach( ally_ref in ally_manifest )
	{
		ally_spawner = get_spawners_by_targetname( ally_ref )[ 0 ];
		assert( isdefined( ally_spawner ), "No ally spawner with targetname: " + ally_ref );

		if ( !isdefined( ally_spawner ) )
			return ally_team;

		ally_spawners[ ally_spawners.size ] = ally_spawner;
	}
	
	chopper = maps\_so_war_support::chopper_spawn_from_targetname_and_drive( "ally_drop_chopper", path_start.origin, path_start, "allies" );
	chopper SetTeam( "allies" );
//	chopper thread maps\_chopperboss::chopper_path_release( "reached_dynamic_path_end death deathspin" );
	
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );	
	chopper.script_vehicle_selfremove = true;
	chopper.custom_unload = true;
	
	// In case the chopper can be killed
	chopper endon( "death" );
	
	// AP_TODO: port over their vehicle rider stuff, if we want it
	//chopper chopper_spawn_pilot_from_targetname( "friendly_support_delta" );

	chopper waittill( "unload" );

	// AP_TODO: if this was handled internally via vehicle ai anim stuff, then the chopper would wait automatically
	chopper Vehicle_SetSpeed( 0, 30, 30 );	

	ally_team = chopper_rappel( chopper, ally_spawners );

	chopper notify( "unloaded" );
	
	/*
	for ( i = 0; i < count; i++ )
	{
		ally = chopper chopper_spawn_passenger( ally_spawner, i + 2 );
		ally set_battlechatter( false );
		ally magic_bullet_shield();
		ally thread ally_remove_bullet_shield( CONST_ALLY_BULLET_SHIELD_TIME, "jumpedout" );
		ally setthreatbiasgroup( "allies" );
		ally.ignoreme = true;
		
		// Setup Ally stats such as speed, health and accuracy
		ally.ai_type = get_ai_struct( ally_ref );
		ally [[ level.attributes_func ]]();
		
		// Give Ally weapons
		ally thread setup_AI_weapon();
		
		// Attach owner to be used in XP distribution
		ally.owner = owner;
		
		ally_team[ ally_team.size ] = ally;
		wait 0.05;
	}
	*/

	chopper vehicle_resumepathvehicle();
	chopper Vehicle_SetSpeed( 60 + randomint(15), 30, 30 );	

	// AP_TODO: delete when end reached
	level thread removeChopper( chopper, 10, path_start );
		
	return ally_team;
}

chopper_rappel( chopper, ai_spawners, callback, param1 )
{
	ai_team = [];

	chopper sethoverparams( 10, 10, 10 );
	chopper setjitterparams( (10, 10, 10), 0, 0 );

	rappel_left_origin = chopper GetTagOrigin("tag_fastrope_le");
	if( !IsDefined( rappel_left_origin ) )
	{
		rappel_left_origin = chopper GetTagOrigin("tag_enter_gunner");
		assert( IsDefined(rappel_left_origin), "Heli has no rappel tags" );
	}

	rappel_struct_left = SpawnStruct();
	rappel_struct_left.origin = rappel_left_origin;
	rappel_struct_left.targetname = "ally_chopper_rappel_left";

	rappel_struct_right = SpawnStruct();

	// project the delta vector from the origin to the left struct pos onto the right vector
	delta = rappel_struct_left.origin - chopper.origin;
	dist = Abs(VectorDot(delta, AnglesToRight(chopper.angles)));

	// move the right struct to the exact spot on the other side
	rappel_struct_right.origin = rappel_struct_left.origin + AnglesToRight(chopper.angles) * (2.0 * dist);
	rappel_struct_right.targetname = "ally_chopper_rappel_right";

	create_rope = true;
	delete_rope = false;
	spawnedAllies = 0;
	count = ai_spawners.size;
	while( spawnedAllies < count )
	{
		rappel_struct = ( spawnedAllies % 2 == 0 ? rappel_struct_left : rappel_struct_right );

		// last two guys clean up the rope
		if( spawnedAllies >= count - 2 )
			delete_rope = true;

		ai_spawner = ai_spawners[spawnedAllies];

		assert( IsDefined( ai_spawner ) );
		ai_spawner.count = 1; // make sure count > 0

		new_guy = simple_spawn_single( ai_spawner );
		new_guy.target = rappel_struct.targetname;

		if( new_guy.team == "allies" )
			new_guy thread ally_setup( ai_spawner, "rappel_done" );
		else
			new_guy thread enemy_setup( ai_spawner.targetname, "rappel_done" );

		// custom callbacks
		if( IsDefined(callback) )
		{
			if( IsDefined(param1) )
				new_guy thread [[ callback ]]( param1 );
			else
				new_guy thread [[ callback ]]();
		}

		ai_team[ ai_team.size ] = new_guy;

		new_guy thread maps\_ai_rappel::start_ai_rappel(2, rappel_struct, create_rope, delete_rope);

		// longer wait after each two
		if( spawnedAllies < count - 1 )
		{
			waitTime = ( spawnedAllies % 2 == 0 ? RandomFloatRange(0.5, 1.0) : RandomFloatRange(1.0, 1.5) );
			wait( waitTime );
		}

		spawnedAllies++;

		// only first two drop rope
		if( spawnedAllies >= 2 )
			create_rope = false;
	}

	// wait till last guy is done rapelling
	ai_team[ ai_team.size - 1 ] waittill( "rappel_done" );

	wait( 0.05 );	

	return ai_team;
}

_GetEye()
{
	// self is AI or player
	if ( isdefined( self ) && isalive( self ) )
		return self geteye();
	
	return undefined;
}

ally_team_setup( allies )
{
	assert( isdefined( self ), "Chopper not passed as self so unloaded cannot be waited for." );
	assert( isdefined( allies ) && allies.size, "Invalid or empty ally array." );
	
	self endon( "death" );
		
	self waittill( "unloaded" );
	
	array_thread( allies, ::ally_setup, "rappel_done" );
}

ally_setup( spawner, waitNotify )
{
	self endon( "death" );

	assert( IsDefined(spawner) );
	
	self.spawner = spawner;
	self set_battlechatter( false );
	self.ignoreme = true;
	
	// invincible until end of unload sequence
	self magic_bullet_shield();
	
	// TODO: remove this when the gameplay is more balance and the allies don't get smoked so easily
	//self thread ally_remove_bullet_shield( CONST_ALLY_BULLET_SHIELD_TIME, waitNotify );

	// Setup Ally stats such as speed, health and accuracy
	self.ai_type = get_ai_struct( spawner.targetname );
	self [[ level.attributes_func ]]();
		
	// Give Ally weapons
	self thread setup_AI_weapon();

	if( IsDefined( waitNotify ) )
		self waittill( waitNotify );
	
	// wait for the go_to_node threads to finish to our goalradius won't get clobbered
	wait(0.05);

	if ( !isdefined( self ) || !isalive( self ) )
		return;

	// AP: use GDT settings
	// self setengagementmindist( 300, 200 );
	// self setengagementmaxdist( 512, 768 );
	self initialize_single_ally( true );
}

initialize_single_ally( addToPlayerClasses )
{
	self.goalradius = CONST_ALLY_GOAL_RADIUS;
	self disable_react();
	self setthreatbiasgroup( "allies" );
	
	self.ignoreme 				= false;
	self.fixednode 				= false;
	self.a.allow_weapon_switch 	= false;
	self.healthmax				= self.health;
	self.dropRiotshield 		= true;
	self.special_node_type 		= self.spawner.targetname;
	self set_battlechatter( true );
	self PushPlayer( false );
	
	self.bullet_resistance = 30;
	
	if( addToPlayerClasses )
	{
		self.playableAlly 	= true;
		self maps\_so_war_classes::add_to_player_classes();
	}

	self thread ally_on_death();
	self thread ally_position_manager();
	self thread ally_health_regen(1, 2); //gains 100% over 2 seconds
}

spawn_single_ally( spawner, origin, angles, addToPlayerClasses )
{
	assert( IsDefined( spawner ) );


	if( IsDefined(origin) )
		spawner.origin = origin;
	
	if( IsDefined(angles) )
		spawner.angles = angles;
	
	// make sure count > 0
	spawner.count = 1;
	spawner.script_no_threat_update_on_fisrt_frame = true;

	new_guy = simple_spawn_single( spawner );

	// Setup Ally stats such as speed, health and accuracy
	new_guy.ai_type = get_ai_struct( spawner.targetname );
	new_guy [[ level.attributes_func ]]();

	/#
	IPrintLn( "Spawning: " + new_guy.ai_type.name );
	#/
		
	// Give Ally weapons
	new_guy thread setup_AI_weapon();
	new_guy.spawner = spawner;
	new_guy initialize_single_ally( addToPlayerClasses );
	level notify("ally_spawning",new_guy);
	
	return new_guy;
}

enemy_setup( spawner_ref, waitNotify )
{
	self endon( "death" );

	self set_battlechatter( false );
	self magic_bullet_shield();
	self.ignoreme = true;

	self.ai_type = get_ai_struct( spawner_ref );
	self [[ level.attributes_func ]]();
		
	if( IsDefined( waitNotify ) )
		self waittill( waitNotify );
	else
		wait(0.05);

	if ( !isdefined( self ) || !isalive( self ) )
		return;

	self stop_magic_bullet_shield();
	self.ignoreme = false;
}


ally_remove_bullet_shield( timer, wait_before_timer )
{
	assert( isdefined( timer ), "Timer undefined." );
	self endon( "death" );
	
	if ( isdefined( wait_before_timer )	)
		self waittill( wait_before_timer );
	
	wait timer;
	
	self stop_magic_bullet_shield();
}

ally_on_death()
{
	self waittill( "death" );
	
	if( isdefined( self.owner ) && isalive( self.owner ) )
		self.owner notify( "ally_died" );
	
	level notify("ally_hud_update");
	
	// if riotshield, we drop shield
	self AI_drop_riotshield();
}

ally_on_damage()
{
	self endon( "death" );
	while(1)
	{
		self waittill("damage");
		if ( !IsDefined( self.coverNode ) )
		{
			newCover = self ally_getCoverNodeInRadius(self.origin,self.goalradius,self.specialty);
			if (isDefined(newCover))
			{
				fixnode = false;
				if ( self.fixednode == true )
				{
					self.fixednode = false;
					fixnode = true;
				}
				self UseCoverNode( newCover );
				self.fixednode = fixnode;
			}
		}
	}
}


ally_getCoverNodeInRadius(origin, radius, specialty)
{
	node 	= undefined;
	nodes 	= [];
	
	if ( isDefined(specialty) )
	{
		nodes = self FindBestCoverNodes(radius,origin); //returns SORTEd list of best covernodes.  index zero is best
		foreach (anode in nodes)
		{
			if ( isDefined(anode.script_noteworthy) && issubstr(anode.script_noteworthy,specialty) )
			{
				node = anode;
				break;
			}
		}
		
		if ( !isDefined(node) )
		{
			node = nodes[0];
		}
	}
	else
	{
		node = self FindCoverNodeAtLocation(radius,origin);
	}

	return node;

}

ally_health_regen( regenRate, overTimeInterval )
{
	self endon("death");
	
	self.healthmax 	= self.maxhealth;// .maxhealth is useless bc it gets overriden every time .health is set
	increments 		= overTimeInterval/0.05;
	regenRate  		= regenRate / increments;
	regenAmount 	= int(self.healthmax*regenRate);		
	
	/#
	self thread ally_health_debug();
	#/
	
	while(1)
	{		
		if ( self.health < self.healthmax )
		{
			self.health += regenAmount;
			level notify("ally_hud_update");

			/#
				if( GetDvarInt("war_wave_debug_frindly_health") > 0 )
				{
					RecordEntText( "Regen: " + regenAmount, self, (0,1,0), "Script" );
					println("Ent:"+self.ai_number+" regenerating health by " + regenAmount + ". Current:"+self.health);
				}
			#/
				
			if ( self.health > self.healthmax )
				self.health = self.healthmax;
		}
		
		if (!isDefineD(self.entityHeadIcons) || self.entityHeadIcons.size == 0 )
		{
			self maps\sp_killstreaks\_entityheadicons::setEntityHeadIcon("allies", GetPlayers()[0], (0,0,70));
		}
		hpR = clamp(self.health/self.healthmax,0.2,0.8);
		color = ( 1.0-(1.0*hpR), (1.0*hpR), 0.1  );
		if (isDefineD(self.entityHeadIcons) && self.entityHeadIcons.size != 0 )
		{
			self.entityHeadIcons[0].color = color; 
		//	self.entityHeadIcons[0] maps\_hud_util::showElem();
		}
		
		wait 0.05;
	}
}

/#
ally_health_debug()
{
	self endon("death");
	
	while(1)
	{	
		if( GetDvarInt("war_wave_debug_frindly_health") > 0 )
		{
			hpR = clamp(self.health/self.healthmax,0.2,0.8);
			color = ( 1.0-(1.0*hpR), (1.0*hpR), 0.1  );
			RecordEntText( "HP: " + self.health + " / " + self.healthmax, self, color, "Script" );
		}
		else
		{
			wait(0.5);
		}
		
		wait(0.05);
	}
}
#/

// ==========================================================================
// UTILITY FUNCTIONS
// ==========================================================================

setup_AI_weapon()
{
	// self is AI
	waittillframeend;
	assert( isdefined( self.ai_type ), "AI attributes aren't set correctly, or function call too early" );
	
	// Only give loot to axis
	if ( isdefined( self.team ) && self.team == "axis" )
	{
		self maps\_so_war_loot::loot_roll();
	}
	
	assert( isdefined( level.coop_incap_weapon ), "Default secondary weapon should be defined." );
	
	if ( isdefined( level.coop_incap_weapon ) )
	{
		self.sidearm = level.coop_incap_weapon;
		place_weapon_on( self.sidearm, "none" );
		
		//self forceUseWeapon( level.coop_incap_weapon, "sidearm" );
	}
	
	forced_weapon = maps\_so_war_classes::get_class_weapons( self.ai_type.classtype )[ 0 ];
	
	//assert( isdefined( forced_weapon ), "Regular or Special AI did not return a weapon which could cause them to use their SP weapon." );
	
	if ( !isdefined( forced_weapon ) || forced_weapon == self.weapon )
		return;
	
	self forceUseWeapon( forced_weapon, "primary" );
	
	assert( self.weapon == forced_weapon, "Force weapon failed to set " + forced_weapon + "as the primary weapon." );
	assert( self.primaryweapon == forced_weapon, "Force weapon failed to set " + forced_weapon + "as the primary weapon." );
}

get_all_mine_locs()
{
	claymore_locs = getstructarray( "so_claymore_loc", "targetname" );
	return claymore_locs;
}

// AI Management Utils ==============================================================

AI_drop_riotshield()
{	
	// If AI was deleted, we don't drop shield.
	if ( !isdefined( self ) )
		return;
	
	// if riotshield, we drop shield
	if ( isdefined( self.weaponInfo[ "iw5_riotshield_so" ] ) )
	{
		position = self.weaponInfo[ "iw5_riotshield_so" ].position;
		
//		if ( isdefined( self.dropriotshield ) && self.dropriotshield && position != "none" )
//			self thread animscripts\shared::DropWeaponWrapper( "iw5_riotshield_so", position );
			
		self animscripts\shared::detachWeapon( "iw5_riotshield_so" );
		
		self.weaponInfo[ "iw5_riotshield_so" ].position = "none";
		self.a.weaponPos[ position ] = "none";
	}	
}

manage_ai_relative_to_player( update_delay, goal_radius, endons, notifies )
{
	self notify("manage_ai_relative_to_player");
	self endon("manage_ai_relative_to_player");
	assert( isdefined( update_delay ) );

	level endon( "special_op_terminated" );
	self endon( "death" );
	
	self.goalradius = ( isdefined( goal_radius ) ? goal_radius : self.goalradius );
		
	if ( isdefined( endons ) )
	{
		arr_endons = strtok( endons, " " );
		foreach ( e in arr_endons )
			self endon( e );
	}
	
	if ( isdefined( notifies ) )
	{	
		arr_notifies = strtok( notifies, " " );
		foreach ( n in arr_notifies )
			self notify( n );
	}

	// JC-ToDo: Currently this cleanup from data being potentially
	// left changed from a previous behavior is minimal and manageable.
	// At the same time it's super ugly and error prone. Each behavior
	// should have specific logic called or that it calls on endon to
	// clean up any AI data left changed such as sprint, goal radius,
	// move play back, etc. Currently it's only sprint.
	
	// In case the sprint / fast walk was left on when a thread was ended
	self war_disable_sprint();
	
	first_update = true;
	
	while ( 1 )
	{
		if ( isDefined(self.position_override) )
		{
			self SetGoalPos(self.position_override);
			self waittill_notify_or_timeout("goal",10);
			continue;
		}
		if ( isDefined(self.entity_override) )
		{
			self SetGoalEntity(self.entity_override);
			self waittill_notify_or_timeout("goal",10);
			continue;
		}
	
	
		close_player = get_closest_player_healthy( self.origin );
		if ( !IsDefined( close_player ) )
		{
			close_player = get_closest_player( self.origin );
		}
		
		if ( !isdefined( close_player ) )
		{
			wait update_delay;
			continue;
		}
		
		if ( first_update )
		{	
			first_update = false;
			
			// On the first update give the AI the enemy info 
			// of each player. This fixes a bug where AI
			// that spawn within their goalradius of the
			// closest player never would get their goal entity
			// set causing them to sit in their idle animation
			// until the player comes into view
			if ( self.team == "axis" )
			{
				self GetEnemyInfo( close_player );
				
				// Always send enemies at the close player
				// at the start
				
				self setgoalpos( close_player.origin );
				msg = self waittill_any_timeout( 1, "bad_path" );
				
				// kick start AI if bad path
				if ( msg == "bad_path" )
				{
					self manage_ai_go_to_player_node( close_player );
					wait 0.5;
				}
				
				self SetGoalEntity( close_player );
				// it seems that once setgoalentity() is set to player while he/she is unreachable, 
				// setgoalpos() no longer changes AI's goal pos, its always players origin regarless,
				// unless player moved and is reachable. Thus manage_ai_go_to_player_node() needs to be
				// called before setgoalentity() is ever set on the AI. - Julian
			}
			else
			{
				self SetGoalEntity( close_player );				
			}
		}
		
		// If the AI is aggressing or if the closest player 
		// is outside of the AI's goalradius send the AI
		// to the player and poll to against their distance
		if ( isdefined( self.aggressing ) || distancesquared( self.origin, close_player.origin ) > self.goalradius * self.goalradius )
		{
			// new ambush stuff so player can't just kite the AI around
			findAmbushNodes = false; // disable for now
			if( findAmbushNodes && RandomFloat(100) > 25 && self.team == "axis" && !self CanSee(close_player) && IsDefined(close_player.ambushNodes) && close_player.speed > 30 )
			{
				bestAmbushNode = undefined;
				nearestDistSq = 9999999999;

				for( i=0; i < close_player.ambushNodes.size; i++ )
				{
					ambushNode = close_player.ambushNodes[ i ][ "bestNode" ];

					if( IsDefined( ambushNode ) )
					{
						nodeDir = sign( VectorDot( close_player.travelRight, ambushNode.origin - close_player.origin ) );
						playerDir = sign( VectorDot( close_player.travelRight, self.origin - close_player.origin ) );

						distSqToNode = DistanceSquared( self.origin, ambushNode.origin );
						
						// make sure they're on the same side
						if( nodeDir == playerDir && nearestDistSq > distSqToNode )
						{
							bestAmbushNode = ambushNode;
							nearestDistSq = distSqToNode;
						}
					}
				}

				if( IsDefined( bestAmbushNode ) )
				{
					self SetGoalNode( bestAmbushNode );

					//RecordLine( self.origin, bestAmbushNode.origin, (0,0,1), "Script", self );
				}
			}
			else
			{
				if ( self.team == "allies" )
				{
					self ally_request_to_move();
				
					if ( self ally_ok_to_move(close_player.origin,8000,self.goalradius*2.5) )
					{
						myItem = self ally_find_status_by_ent();
						assert(isDefined(myItem),"item should be valid");
						myItem.request_to_move_ack = true;
					
						newCover = self ally_getCoverNodeInRadius(close_player.origin,self.goalradius,self.specialty);
					
						if (isDefined(newCover))
						{
							self setgoalnode(newCover);
						}
						else
						{
							self setgoalpos( close_player.origin );
						}
						self thread ally_move_request_death_watcher();
						self waittill("goal");
						self ally_move_request_complete();
					}
				}
				else
				{
					self setgoalentity( close_player );
				}
			}

			self war_enable_sprint();
			
			found_player = false;
			self thread manage_ai_poll_player_state( close_player );
			msg = self waittill_any_timeout( CONST_AI_SEARCH_PLAYER_TIME, "manage_ai_player_invalid", "manage_ai_player_found", "bad_path" );
			self notify( "manage_ai_stop_polling_player_state" );
				
			if ( msg == "bad_path" )
			{
				manage_ai_go_to_player_node( close_player );
				wait 0.2;
			}
			else if ( msg == "manage_ai_player_found" )
			{
					found_player = true;
			}
			
			// If the AI didn't reach the target in the given time
			// skip the wait and try again
			if ( !found_player )
			{
				continue;
			}
			else if ( isdefined( self.aggressing ) )
			{
				// wait a beat then continue to go after the player again
				wait 0.3;
				continue;	
			}
		}
		
		self war_disable_sprint();
			
		
		wait update_delay;
	}
}

ally_move_requested_already()
{
	foreach (item in level.ally_move)
	{
		if ( item.entity == self )
			return item;
	}
	return undefined;
}

ally_move_request_death_watcher()
{
	self endon("move_request_complete");
	self waittill("death");
	self ally_move_request_complete();
}
ally_move_request_complete()
{
	item = self ally_find_status_by_ent();
	assert(isDefined(item),"item should be valid");
	level.ally_move = array_remove(level.ally_move,item);
	self notify("move_request_complete");
}

ally_request_to_move()
{
	if (!isDefined(level.ally_move))
		level.ally_move = [];
		
	entry = ally_move_requested_already();
	if (!isDefined(entry))
	{
		entry = SpawnStruct();	
		level.ally_move[level.ally_move.size] = entry;
		entry.entity			= self;
		entry.request_time 		= GetTime();
		entry.request_to_move_ack 	= false;
	}
}

ally_find_status_by_ent()
{
	foreach (item in level.ally_move)
	{
		if (item.entity == self )
			return item;
	}
	return undefined;
}

ally_ok_to_move(target_spot,max_wait,max_dist)
{
	nextMover 		= undefined;
	longestWait		= -1;
	current_time 	= GetTime();
	myItem			= self ally_find_status_by_ent();

	if ( myItem.request_to_move_ack )
		return true;

	if ( isDefined(max_wait) )
	{
		if ( myItem.request_to_move_ack || (current_time - myItem.request_time > max_wait) )
			return true;
	}

	if ( isDefined(max_dist) )
	{
		dist = distancesquared( self.origin, target_spot );
		if (dist > (max_dist*max_dist) )
			return true;
	}

	foreach (item in level.ally_move)
	{
		if ( item.request_to_move_ack ) //somebody already on the move
		{
			return false;
		}
		
		if ((current_time - item.request_time) > longestWait )
		{
			nextMover 	= item.entity;
			longestWait = item.request_time;
		}
	}

	if ( !isDefined(nextMover) )
		return false;
		
	if ( nextMover == self )
		return true;

	return false;
}


manage_ai_poll_player_state( close_player )
{
	self endon( "death" );
	self endon( "manage_ai_stop_polling_player_state" );
	
	while ( 1 )
	{
		wait 0.1;
				
		if	(	
			!isdefined( close_player )
		||	!isalive( close_player )
		||	is_player_down( close_player )
			)
		{
			self notify( "manage_ai_player_invalid" );
			return;
		}
		else if ( distancesquared( self.origin, close_player.origin ) <= self.goalradius * self.goalradius )
		{
			self notify( "manage_ai_player_found" );
			return;
		}
	}
}
		
manage_ai_go_to_player_node( player )
{
	Assert( IsDefined( player.node_closest ), "Player did not have closest_node defined, this should always be defined." );
	if ( IsDefined( player.node_closest ) )
	{
		// Use SetGoalPos because multiple AI cannot be told
		// to go to the same node
		self SetGoalPos( player.node_closest.origin );
	}
}

war_enable_sprint()
{
	if ( isdefined( self.subclass ) && self.subclass == "riotshield" )
	{
		/*
		if ( isdefined( self.juggernaut ) )
		{
			self maps\_riotshield::riotshield_fastwalk_on();
		}
		else
		{
			self maps\_riotshield::riotshield_sprint_on();
		}
		*/
	}
	else
	{
		// Juggernauts have the sprint field turned on and
		// regular AI stop using cover. Sprint is not
		// turned on for regular AI because it causes them
		// to not play transition animations properly
		if ( !IsDefined( self.juggernaut ) )
		{
			self.combatMode = "no_cover";
			self thread sprint_while_enemy_not_visible();
		}
	}
}

sprint_while_enemy_not_visible()
{
	self endon("death");
	self endon("disable_sprint");

	change_movemode( "sprint" );
	sprinting = true;

	while( 1 )
	{
		if( IsDefined(self.enemy) )
		{
			// turn off sprinting if the AI can see the enemy because otherwise they can't shoot
			if( sprinting && self CanSee( self.enemy ) )
			{
				change_movemode( "run" );
				sprinting = false;
			}
			else if( !sprinting && !self CanSee( self.enemy ) )
			{
				change_movemode( "sprint" );
				sprinting = true;
			}
		}

		wait( 0.2 );
	}
}

war_disable_sprint()
{
	if ( isdefined( self.subclass ) && self.subclass == "riotshield" )
	{
		/*
		if ( isdefined( self.juggernaut ) )
		{
			self maps\_riotshield::riotshield_fastwalk_off();
		}
		else
		{
			self maps\_riotshield::riotshield_sprint_off();
		}
		*/
	}
	else
	{
		// Juggernauts have the sprint field turned off and
		// regular AI go back to using cover. Sprint was 
		// not turned on for regular AI because it causes
		// them to not play transition animations properly
		if ( !IsDefined( self.juggernaut ) )
		{
			if( self.isbigdog )
				self.combatMode = "any_exposed_nodes_only";
			else
				self.combatMode = "cover";
			
			self notify("disable_sprint");
			self change_movemode( "run" );
		}
	}
}

// AI TYPE HOOKS ==============================================================
// tablelookup( stringtable path, search column, search value, return value at column );

ai_exist( ref )
{
	return isdefined( level.war_ai ) && isdefined( level.war_ai[ ref ] );
}

get_ai_index( ref )
{
	if ( ai_exist( ref ) )
		return level.war_ai[ ref ].idx;
	
	return int( tablelookup( level.so.LOADOUT_TABLE_DEFAULT, TABLE_AI_REF, ref, level.so.TABLE_INDEX ) );	
}

get_ai_ref_by_index( idx )
{
	return tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_INDEX, idx, TABLE_AI_REF );
}

lookup_value( ref, idx, column_index )
{
	if( IsDefined(idx) )
		return tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_INDEX, idx, column_index );
	else
		return tablelookup( level.so.LOADOUT_TABLE_DEFAULT, level.so.TABLE_CLASS_REF, ref, column_index );
}

get_ai_struct( ref )
{
	msg = "Trying to get war AI_type struct before stringtable is ready, or type doesnt exist.";
	assert( ai_exist( ref ), msg );
	
	return level.war_ai[ ref ];
}

get_ai_classname( ref, idx )
{
	if ( ai_exist( ref ) )
		return level.war_ai[ ref ].classname;
		
	return lookup_value( ref, idx, TABLE_AI_CLASSNAME );
}

get_ai_classtype( ref, idx )
{
	if ( ai_exist( ref ) )
		return level.war_ai[ ref ].classtype;
		
	return lookup_value( ref, idx, TABLE_AI_CLASSTYPE );
}

get_ai_name( ref, idx )
{
	if ( ai_exist( ref ) )
		return level.war_ai[ ref ].name;
		
	return lookup_value( ref, idx, TABLE_AI_NAME );
}

get_ai_desc( ref, idx )
{
	if ( ai_exist( ref ) )
		return level.war_ai[ ref ].desc;
		
	return lookup_value( ref, idx, TABLE_AI_DESC );
}

is_ai_boss( ref, idx )
{
	if ( ai_exist( ref ) && isdefined( level.war_boss ) )
		return isdefined( level.war_boss[ ref ] );
		
	Var1 = lookup_value( ref, idx, TABLE_AI_BOSS );
	
	if ( !isdefined( Var1 ) || Var1 == "" )
		return false;

	return true;
}

// WAVE HOOKS ==============================================================
// tablelookup( stringtable path, search column, search value, return value at column );
// level.wave_table can be overriden per level

wave_exist( wave_num )
{
	return isdefined( level.war_wave ) && isdefined( level.war_wave[ wave_num ] );
}

get_wave_boss_delay( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].bossDelay;
	
	return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_BOSS_DELAY ) );	
}

get_wave_index( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].idx;
	
	return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, level.so.TABLE_INDEX ) );
}

get_wave_number_by_index( index )
{
	return int( tablelookup( level.wave_table, level.so.TABLE_INDEX, index, TABLE_WAVE ) );	
}




get_min_ai_threshold( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].minAIThreshold;
	
	return int(tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_NEXTWAVE_THRESHOLD ));
}

get_squad_type( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].squadType;
	
	return tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SQUAD_TYPE );	
}

get_ai_count( type, wave_num )
{
	ai_count = 0;
	
	switch( type )
	{
		case "special":
			quantity_array = get_special_ai_quantity( wave_num );
			foreach( value in quantity_array )
				ai_count += value;
			
			break;
			
		case "dogs":
			ai_count = get_dog_quantity( wave_num );
			break;
			
		case "boss":
			if( maps\_so_war::wave_has_boss( wave_num ) )
				ai_count = 1;
			
			break;
			
		case "regular":
			ai_count = int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SQUAD_SIZE ) );
	
			/#
				// devgui stuff
				if( GetDvarInt("war_wave_numAI") >= 0 )
				{
					ai_count = GetDvarInt("war_wave_numAI");
				}
			#/
				
			break;
		default:
			assert( 0, "bad ai type for count lookup: " + type );
			break;
	}
			
	return ai_count;
}

// breaks down the squad AI count into groups of 3s and 2s
get_squad_array( wave_num )
{	
	useCache = true;
	
	/#
		// devgui stuff
		if( GetDvarInt("war_wave_numAI") >= 0 )
		{
			useCache = false;
		}
	#/
		
	if ( useCache && wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].squadArray;
	
	// logic to convert single squad ai count number into an array of squads of 2-4 per
	squad_array = [];
	ai_count = get_ai_count( "regular", wave_num );
	
	if ( ai_count <= 3 )
	{
		squad_array[ 0 ] = ai_count;
	}
	else
	{
		remainder 	= ai_count % 3;
		squad_count = int( ai_count / 3 );
		
		// if remainder is 0
		for ( i=0; i<squad_count; i++ )
			squad_array[ i ] = 3;
		
		if ( remainder == 1 )
		{
			if ( level.merge_squad_member_max == 4 )
			{
				// if merge happens at max 4, then avoid 2 squads of 2 and joining up right after spawn
				// exchange ( ex: 3,3,3,1 -> 3,3,4 )
				squad_array[ squad_array.size - 1 ] += remainder;
			}
			else
			{
				// exchange ( ex: 3,3,3,1 -> 3,3,2,2 )
				exchange = 1;
				squad_array[ squad_array.size - 1 ] -= ( exchange );
				squad_array[ squad_array.size ] = remainder + ( exchange );
			}
		}
		else if ( remainder == 2 )
		{
			squad_array[ squad_array.size ] = remainder;
		}
	}
	
	return squad_array;
}

// string[] - array of special ais
get_special_ai( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].specialAI;

	specials = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SPECIAL );
	
	if ( isdefined( specials ) && specials != "" )
		return strtok( specials, " " );

	return undefined;
}

// int[] - array of quantities per special ai type, synced with get_special_ai( wave_num )'s array by index
get_special_ai_quantity( wave_num )
{
	useCache = true;
	
	/#
		// devgui stuff
		if( GetDvarInt("war_wave_numSpecialAI") >= 0 )
		{
			useCache = false;
		}
	#/
		
	if ( useCache && wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].specialAIquantity;
	
	special_nums = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_SPECIAL_NUM );
	
	// convert to array of ints
	special_num_array = [];
	if ( isdefined( special_nums ) && special_nums != "" )
	{
		special_nums = strtok( special_nums, " " );
		for( i=0; i<special_nums.size; i++ )
		{
			special_num_array[ i ] = int( special_nums[ i ] );
			
			/#
				// devgui stuff
				if( GetDvarInt("war_wave_numSpecialAI") >= 0 )
				{
					special_num_array[ i ] = GetDvarInt("war_wave_numSpecialAI");
				}
			#/
		}
		
		return special_num_array;
	}
	
	return undefined;
}

// int - get special ai quantity by type
get_special_ai_type_quantity( wave_num, ai_type )
{
	assert( isdefined( ai_type ), "ai_type is not defined while trying to get quantity for type." );
	
	special_ai_array 			= get_special_ai( wave_num );
	special_ai_quantity_array 	= get_special_ai_quantity( wave_num );
	
	if ( isdefined( special_ai_array ) 
		&& isdefined( special_ai_quantity_array )
		&& special_ai_array.size 
		&& special_ai_quantity_array.size 
	)
	{
		foreach( index, special in special_ai_array )
		{
			if ( ai_type == special )
				return special_ai_quantity_array[ index ];
		}
	}
	
	// if none specified, then dont spawn
	return 0;
}

get_bosses_ai( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].bossAI;

	bosses = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_BOSS_AI );
	
	if ( isdefined( bosses ) && bosses != "" )
		return strtok( bosses, " " );

	return undefined;
}

get_bosses_nonai( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].bossNonAI;
		
	bosses = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_BOSS_NONAI );
	
	if ( isdefined( bosses ) && bosses != "" )
		return strtok( bosses, " " );
		
	return undefined;
}

is_repeating( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].repeating;
		
	return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_REPEAT ) );	
}

get_wave_startdelay( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].startDelay;
		
	return int( tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_DELAY ) );	
}

get_wavenum_by_userdefined( user_defined )
{
	return int( tablelookup( level.wave_table, TABLE_USER_DEFINED, user_defined, TABLE_WAVE ) );	
}


// returns armory type if armory is unlocked at the end of this wave
get_min_pop_time( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].minimumPopAndTime;

	pop_time = tablelookup( level.wave_table, TABLE_WAVE, wave_num, TABLE_MINIMUM_POPULATIION );
	
	// convert to array of ints
	pop_time_array = [];
	if ( isdefined( pop_time ) && pop_time != "" )
	{
		pop_time = strtok( pop_time, " " );
		for( i=0; i<pop_time.size; i++ )
			pop_time_array[ i ] = int( pop_time[ i ] );
		
		return pop_time_array;
	}
	
	return undefined;
}

get_dog_type( wave_num )
{
	if ( wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].dogType;
	
	special_array = get_special_ai( wave_num );
	if ( !isdefined( special_array ) || !special_array.size )
		return "";
	
	foreach ( special in special_array )
	{
		if ( issubstr( special, "dog" ) )
			return special;
	}
	
	return "";
}

get_dog_quantity( wave_num )
{
	useCache = true;
	
	/#
		// devgui stuff
		if( GetDvarInt("war_wave_numDogs") >= 0 )
		{
			useCache = false;
		}
	#/
		
	if ( useCache && wave_exist( wave_num ) )
		return level.war_wave[ wave_num ].dogQuantity;
	
	/#
		// devgui stuff
		if( GetDvarInt("war_wave_numDogs") >= 0 )
		{
			return GetDvarInt("war_wave_numDogs");
		}
	#/
	
	dog_type = get_dog_type( wave_num );
	if ( !isdefined( dog_type ) )
		return 0;
	
	return get_special_ai_type_quantity( wave_num, dog_type );
}

// cpy from register_kill in _player_stats.gsc in MW3
specops_death_notify()
{
	self waittill( "death", attacker, cause, weapon );

	if ( !IsDefined( self ) )
	{
		return;
	}

	if ( IsDefined( attacker ) )
	{
		if ( self.team == "axis" || self.team == "team3" )
		{
			// For sentry guns with owners.
			if ( IsDefined( attacker.attacker ) )
			{
				attacker = attacker.attacker;
			}

			validAttacker = false;
			
			if ( isplayer( attacker ) )
				validAttacker = true;

			if ( is_true( level.pmc_match ) )
				validAttacker = true;

			if ( validAttacker )
			{
				player = attacker;
				if ( isdefined( attacker.owner ) )
					player = attacker.owner;

				if ( !isplayer( player ) )
				{
					// fix for enemies sometimes blowing themselves up in Spec Ops and then the mission summary
					// says 38/40 kills or whatever, eventhough you had to kill all 40 enemies to win
					if ( is_true( level.pmc_match ) )
					{
						players = get_players();
						player = players[ randomint( players.size ) ];
					}
				}

				if ( !isplayer( player ) )
					return;

				level notify( "specops_player_kill", player, self, weapon );
			}
		}
	}
}

ai_awareness()
{
	self endon("death");
	
	// turning this off for now because it messes up AI target selection
	if( true )
		return;
	
	while(1)
	{
		timeout = 1;
		major_threats = [];
		
		if ( isDefined(self.favoriteEnemy) && !isAlive(self.favoriteEnemy))
		{
			self.favoriteEnemy = undefined;
		}
		
		if ( isDefined(self.lastAttacker) && isAlive(self.lastAttacker))
		{//let the normal AI logic superceede
		}
		else
		if ( !isDefined(self.favoriteEnemy) )
		{
			major_threats[major_threats.size] = getclosest( self.origin, GetPlayers() );
			major_threats[major_threats.size] = maps\sp_killstreaks\_turret_killstreak::getClosestPlaceTurret(self.origin,self.engagemaxdist*self.engagemaxdist);
			//	: //other big threats (i.e. other team big dogs, etc)
			//	:
			//	:
			
	 
			major_threat = getclosest(self.origin, major_threats);
			
			if(isDefined(major_threat)  )
			{
				if ( !isDefined(self.enemy) || self.enemy != major_threat )
					self SetEntityTarget(major_threat);
			}
		}


		wait timeout;
	}
}


spawn_special_ai( ai_type, quantity )
{
	// pick a spawn thats far from all players
	avoid_locs = [];
	avoid_locs[ avoid_locs.size ] = level.player;
	if( is_coop() )
		avoid_locs[ avoid_locs.size ] = level.players[ 1 ];
		
	classname 	= get_ai_classname( ai_type );
	spawner 	= get_spawners_by_classname( classname )[ 0 ];
	
	for( i = 0; i < quantity; i++ )
	{	
		wait 0.05; // spawn one per frame per spawner
		
		spawn_loc 		= get_furthest_from_these( level.wave_spawn_locs, avoid_locs, 4 );
		spawner.count 	= 1;
		spawner.origin 	= spawn_loc.origin;
		spawner.angles 	= (isDefined(spawn_loc.angles)?spawn_loc.angles:(0,0,0));
		guy 			= simple_spawn_single(spawner, undefined, undefined, undefined, undefined, undefined, undefined, true);	
		if ( isDefined(guy))
		{
			guy	setthreatbiasgroup( "axis" );
			assert( isdefined( guy ), "Special AI failed to spawn even though it was forced spawned." );
			
			guy.ai_type = get_ai_struct( ai_type );
			guy.isspecial = true;
			level.special_ai[ level.special_ai.size ] = guy;
			guy thread clear_from_special_ai_array_when_dead();
			guy thread setup_AI_weapon();
			
			assert( isdefined( level.special_ai_behavior_func ), "No special AI behavior func defined!" );
			guy thread [[ level.special_ai_behavior_func ]]();
		}
	}
	
	return level.special_ai;
}

reenforcement_squad_spawn( quantity, squad_size )
{
	level endon( "special_op_terminated" );
	level endon( "wave_ended" );
	
	initial_leaders = level.leaders.size;
	squad_spawned = 0;
	while ( squad_spawned < quantity )
	{
		if ( level.leaders.size >= initial_leaders )
		{
			wait 0.05;
			continue;
		}
	
		total_AI = getaiarray();
		if ( total_AI.size >= ( 32 - squad_size ) )
		{
			wait 0.05;
			continue;
		}
		
		// squad one squad reenforcement
		squad = maps\_squad_enemies::spawn_far_squad( level.wave_spawn_locs, get_class( "leader" ), get_class( "follower" ), squad_size - 1 );
		if (isDefined(squad) )
		{
			foreach( guy in squad )
			{
				guy	setthreatbiasgroup( "axis" );
				guy thread setup_AI_weapon();
				guy thread maps\_so_war_ai::ai_awareness();
			}
				
			squad_spawned++;
		}
	}
}

reenforcement_special_ai_spawn( special_ai_type, quantity )
{
	level endon( "special_op_terminated" );
	level endon( "wave_ended" );
	
	initial_special_ais = level.special_ai.size;
	ai_spawned = 0;
	while ( ai_spawned < quantity )
	{
		if ( level.special_ai.size >= initial_special_ais )
		{
			wait 0.05;
			continue;
		}
		
		total_AI = getaiarray();
		if ( total_AI.size > 31 )
		{
			wait 0.05;
			continue;
		}
		
		// squad one squad reenforcement
		spawn_special_ai( special_ai_type, 1 );
		ai_spawned++;
		
		//iprintln( "Special AI Re-enforced" );
		wait 0.05;
	}	
}



spawn_boss()
{
	// This flag is dependenent on the spawning below happening
	// before this function gets to the end so no thread spawning!
	flag_clear( "bosses_spawned" );

	spawnImmediate = get_wave_boss_delay( level.current_wave );
	if (!spawnImmediate)
		flag_wait("aggressive_mode");
		
	AI_bosses 		= get_bosses_ai( level.current_wave );
	nonAI_bosses 	= get_bosses_nonai( level.current_wave );
	
	
	level notify( "boss_spawning", level.current_wave );
	
	level.bosses 	= [];
	jug_boss 		= false;
	chopper_boss	= false;
	bigdog_boss		= false;
		
	dropTarget		= (isDefined(level.so.boss_drop_target)?level.so.boss_drop_target:random_player_origin());
	// spawn AI bosses
	if ( isdefined( AI_bosses ) )
	{
		foreach( index, boss_ref in AI_bosses )
		{				
			if ( issubstr( boss_ref, "jug_" ) )
			{			
				path_start = chopper_wait_for_closest_open_path_start( dropTarget, "drop_path_start", "script_unload" );
				thread spawn_juggernaut( boss_ref, path_start );
				jug_boss = true;
				wait 0.5;
			}
			else if ( issubstr( boss_ref, "bigdog" ) )
			{			
				path_start = chopper_wait_for_closest_open_path_start( dropTarget, "drop_path_start", "script_unload" );
				thread spawn_bigdog( boss_ref, path_start );
				bigdog_boss = true;
				wait 0.5;
			}
		}
	}

	// spawn non AI bosses, like a chopper
	if ( isdefined( nonAI_bosses ) )
	{
		foreach( boss_ref in nonAI_bosses )
		{
			if ( issubstr( boss_ref, "chopper" ) )
			{
				chopper_boss = true;
				path_start = chopper_wait_for_closest_open_path_start( dropTarget, "chopper_boss_path_start", "script_stopnode" );
				chopper = spawn_chopper_boss( boss_ref, path_start );
			}
			else
			{
				// some other non AI boss	
			}
		}
	}
	
	// juggernaut music overrides rest
	if ( jug_boss )
		thread maps\_so_war::music_boss( "juggernaut" );
	else if ( jug_boss && chopper_boss )
		thread maps\_so_war::music_boss( "juggernaut" );
	else if ( chopper_boss )
		thread maps\_so_war::music_boss( "chopper" );
}


ally_getBestNode(center,ignoreNode)
{
	if (isDefined(self.node) )
	{
		dist = distanceSquared(self.node.origin,center);
		if (dist < SQR(self.goalradius))
		{
			if ( within_fov( self.node.origin, self.node.angles, center, cos(45) ) )
				return self.node;
		}
	}


	nodes = GetCoverNodeArray( center, self.goalradius );
	bestNode = undefined;
	bestDist = 999999;
	
	if (isDefined(ignoreNode))
		nodes = array_remove(nodes,ignoreNode);
		
	potentials = [];
	
	foreach(node in nodes)
	{
		if ( within_fov( node.origin, node.angles, center, cos(45) ) )
			potentials[potentials.size] = node;
	}
	foreach(node in potentials)
	{
		dist = distanceSquared(node.origin,center);
		if(dist<bestDist)
		{
			bestDist = dist;
			bestNode = node;
		}
	}
	
	return bestNode;
}


ally_position_snaked_monitor(node)
{
	self endon("death");
	self endon("goal");
	self notify("snaked_monitor");
	self endon ("snaked_monitor");
	
	while(1)
	{
		nodeOwner = GetNodeOwner( node );
		if( IsDefined( nodeOwner ) && nodeOwner != self )
		{
			self notify("node_snaked");
			return;
		}
		wait 0.25;
	}
}
	

ally_position_manager()
{
	level endon( "special_op_terminated" );
	self endon("death");
	
	if (!isDefined(level.squad_formation))
	{
		level.squad_formation = [];
		level.squad_formation[CONST_SQUAD_POSITION_WEST] 	= 0;
		level.squad_formation[CONST_SQUAD_POSITION_EAST] 	= 0;
		level.squad_formation[CONST_SQUAD_POSITION_SOUTH] 	= 0;
		level.squad_formation[CONST_SQUAD_POSITION_NORTH] 	= 0;
	}
	
	switch(self.spawner.targetname)
	{	
		case "friendly_assault":
			self.squad_formation_position = (level.squad_formation[CONST_SQUAD_POSITION_EAST]>level.squad_formation[CONST_SQUAD_POSITION_WEST]?CONST_SQUAD_POSITION_WEST:CONST_SQUAD_POSITION_EAST);
		break;
		case "friendly_sniper":
			self.squad_formation_position = CONST_SQUAD_POSITION_SOUTH;
		break;
		case "friendly_cqb":
			self.squad_formation_position = CONST_SQUAD_POSITION_NORTH;
		break;
		case "friendly_explosive":
			self.squad_formation_position = CONST_SQUAD_POSITION_SOUTH;
		break;
		case "friendly_heavy":
			self.squad_formation_position = CONST_SQUAD_POSITION_NORTH;
		break;
		default:
			assertmsg("Unknown spawner type");
		break;
	}
	level.squad_formation[self.squad_formation_position]++;

	msg			= undefined;
	lastNode	= undefined;
	max_dist	= 700;
	min_dist	= 128;
	
	//if i have a special node type, and there are actually nodes of that type, tighten up this guy's formation
	if ( isDefined(self.special_node_type) )
	{
		max_dist = 128;
	}

	self.squad_dist = max_dist;
	
	while(1)
	{
		if (isDefined(msg) && msg == "bad_path")
		{
			self.squad_dist = self.squad_dist * 0.85;
			if ( self.squad_dist < min_dist )
				self.squad_dist = min_dist;
		}
		else
		{
			self.squad_dist = max_dist;
		}
		
		useAnyNode = true;
		
		if (!isDefined(self.position_override) )
		{
			center	= get_sector_center_point( self.squad_formation_position, level.player, self.squad_dist );
			if ( isDefined(self.special_node_type) )
			{
				nodes = [];
				
				if (isDefined(self.special_node))
				{
					dist = distanceSquared(self.special_node.origin,center);
					if ( dist < SQR(CONST_MAX_SPECIAL_NODE_RADIUS) )
					{
						nodes[0] = self.special_node;
					}
	
					// skip the node if it's already occupied
					nodeOwner = GetNodeOwner( self.special_node );
					if( IsDefined( nodeOwner ) && nodeOwner != self && !IsPlayer(nodeOwner) )
					{
						nodes = [];
					}
				}
				
				if ( nodes.size == 0 )
					nodes = GetNodeArraySorted( self.special_node_type, "targetname", center, CONST_MAX_SPECIAL_NODE_RADIUS );
	
				if ( nodes.size != 0 )
				{
					foreach( node in nodes )
					{
						// skip the node if it's already occupied
						nodeOwner = GetNodeOwner( node );
						if( IsDefined( nodeOwner ) && nodeOwner != self && !IsPlayer(nodeOwner) )
						   continue;
						   
						if ( !isDefined(self.special_node) )
						{
							self.fixednode 		= true;
							self.oldGoalRadius 	= self.goalradius;
							
							self.special_node 	= node;
						}
						
						// only reset the goal if necessary
						if( self.goalpos != node.origin )
						{
							self.goalradius = 64;
							self SetGoalNode( node );
							self thread ally_position_snaked_monitor( node );
						}
						
						useAnyNode 			= false;
						break;
					}
				}
			}

			if (useAnyNode)
			{
				self.fixednode = false;
	
				if ( isDefined(self.special_node))
				{
					self.special_node 	= undefined;
					self.goalradius 	= self.oldGoalRadius;
				}
				if (!isDefined(self.enemy))
				{
					ignoreNode = undefined;
					if (isDefined(msg) && msg == "bad_path")
						ignoreNode = lastNode;
						
					node = ally_getBestNode(center,ignoreNode);
					lastNode	= node;
	
					if (isDefined(node))
						self SetGoalNode(node);
					else
						self setgoalpos( center );
				}
				else
				{
					self setgoalpos( center );
				}
			}
		}
		else
		{
			self setgoalpos( self.position_override );
		}
		
		msg = self waittill_any_timeout( 15, "goal", "bad_path","node_snaked");
		/#
		if( GetDvarIntDefault( "war_wave_debug_frindly_movement", 0 ))
		{
			self thread maps\_so_war_support::debug_draw_goalpos(center,(0,1,0));
		}
		#/
		
	}
}



get_sector_center_point(sector,player,dist)
{
	if(!isDefined(dist))
	{
		dist = self.goalradius;
	}
	return (player.origin + AnglesToForward((0,90 * sector,0)) * dist);
}


attack_player( player )
{
	// freeing up vars. shouldn't this be part of the stealth system itself?
	self._stealth = undefined;
	
	self GetPerfectInfo( player );
	
	if( IsSubStr( self.ai_type.ref, "jug_" ) )
		self boss_jug_regular();
	else
		self default_squad_leader();
}


priority_target_death()
{
	self waittill("death");
	foreach (target in level.war_priority_targets )
	{
		if ( target.ent == self )
		{
			level.war_priority_targets = array_remove(level.war_priority_targets,target);
		}
	}
	
}
add_priority_target(ent,dist)
{
	assert(isDefined(ent));
	
	if (!isDefined(dist))
		dist = level.war_priority_distSQ;
	
	if (ent.health <= 0 )
		return;

	ent thread priority_target_death();

	so 				= spawnstruct();
	so.ent 			= ent;
	so.distSQ 		= dist;
	so.attackers	= 0;
	
	level.war_priority_targets[level.war_priority_targets.size] = so;
}
attack_priority_target(endNote)
{
	self endon("death");
	level endon(endNote);
	
	if ( level.war_priority_targets.size == 0 )
		return;
	
	best = level.war_priority_targets[0];
	attackers = 999;
	foreach (target in level.war_priority_targets)
	{
		if ( target.attackers < attackers )
		{
			best = target;
			attackers = target.attackers;
		}
	}
	if (isDefined(best))
	{
		best.attackers++;
		self.position_override 	= best.ent.origin;
		self.priority_target 	= best;
		
		self SetGoalPos(self.position_override);
		self waittill("goal");
		self thread attack_priority_until_dead(best.ent,endNote);
	}
}
attack_priority_until_dead(target,endNote)
{
	self endon("death");
	level endon(endNote);
	
	while(isDefined(target) && target.health > 0 )
	{
		self shoot_at_target(target, "", 1, 10);
		wait 10;
	}
}
get_num_PriorityAttackers(team)
{
	ents = GetAIArray(team);
	count = 0;
	foreach (ent in ents)
	{
		if (isDefined(ent.priority_target))
			count++;
	}
	return count;
}
attack_forgetOnNotify(endNote)
{
	self endon("death");
	self waittill(endNote);
	self.position_override 	= undefined;
	self.priority_target 	= undefined;
	
}
spawn_priority_target_death_squad(team,squad_size,endNote)
{
	squad = maps\_squad_enemies::spawn_far_squad( level.wave_spawn_locs, get_class( "leader" ), get_class( "follower" ), squad_size - 1 );
	if (isDefined(squad) )
	{
		foreach( guy in squad )
		{
			guy	setthreatbiasgroup( team );
			guy SetTeam(team);
			guy thread setup_AI_weapon();
			guy thread maps\_so_war_ai::ai_awareness();
			guy thread attack_priority_target(endNote);
			guy thread attack_forgetOnNotify(endNote);
			guy thread manage_ai_relative_to_player( CONST_AI_UPDATE_DELAY, guy.goalradius, "ai_behavior_change" );
		}
	}
}


