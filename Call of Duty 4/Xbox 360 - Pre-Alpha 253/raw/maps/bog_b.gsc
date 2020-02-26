/* Random Interior Spawning:
group AI and Trigger with "script_random_killspawner"
grouped AI get "script_randomspawn" on them. One of the groups lives, the others get deleted
*/

#include maps\_utility;
#include maps\_anim;
#include common_scripts\utility;
#using_animtree( "generic_human" );
main()
{
	setdvar( "scr_dof_enable", "1" );
	
	if ( getdvar( "bog_camerashake") == "" )
		setdvar( "bog_camerashake", "1" );
		
	if ( getdvar( "bog_debug_tank") == "" )
		setdvar( "bog_debug_tank", "0" );
	
	if ( getdvar( "bog_debug_flyby") == "" )
		setdvar( "bog_debug_flyby", "0" );
	
	add_start( "arch", ::start_arch );
	add_start( "alley", ::start_alley );
	add_start( "t72", ::start_t72 );
	default_start( ::start_bog );
	
	level.radioForcedTransmissionQueue = [];
	
	precacheModel( "vehicle_mig29_desert" );
	precacheModel( "vehicle_t72_tank_d_animated_sequence" );
	precacheString( &"BOG_B_OBJ_ESCORT_TANK" );
	precacheItem( "m1a1_turret_blank" );
	
	maps\_m1a1::main( "vehicle_m1a1_abrams" );
	maps\_t72::main( "vehicle_t72_tank" );
	maps\_mi17::main( "vehicle_mi17_woodland_fly_cheap" );
	maps\createart\bog_b_art::main();
	maps\bog_b_fx::main();
	maps\_load::main();
	maps\bog_b_anim::main();
	maps\_compass::setupMiniMap( "compass_map_bog_b" );
	thread maps\bog_b_amb::main();
	thread maps\_mortar::bog_style_mortar();
	thread fog_adjust();
	thread teamsSplitUp();
	thread mg_killers();
	thread mg_alley_deadzone();
	thread lastSequence();
	thread playerInit();
	
	level.cosine = [];
	level.cosine[ "35" ] = cos( 35 );
	level.cosine[ "65" ] = cos( 65 );
	level.cosine[ "80" ] = cos( 80 );
	
	level.exploderArray = [];
	level.exploderArray[ 0 ][ 0 ] = setupExploder( 105 );
	level.exploderArray[ 0 ][ 1 ] = setupExploder( 104 );
	level.exploderArray[ 0 ][ 2 ] = setupExploder( 102 );
	level.exploderArray[ 0 ][ 3 ] = setupExploder( 103 );
	level.exploderArray[ 1 ][ 0 ] = setupExploder( 100, ::killSpawner, 7 );
	level.exploderArray[ 1 ][ 1 ] = setupExploder( 101 );
	level.exploderArray[ 2 ][ 0 ] = setupExploder( 200 );
	level.exploderArray[ 2 ][ 1 ] = setupExploder( 201 );
	
	flag_init( "tank_clear_to_shoot" );
	flag_init( "mg_killer_in_position" );
	flag_init( "door_idle_guy_idling" );
	flag_init( "price_at_spotter" );
	flag_init( "ok_to_do_spotting" );
	flag_init( "tank_in_final_position" );
	flag_init( "tank_turret_aimed_at_t72" );
	flag_init( "friendly_reactions_over" );
	flag_init( "t72_in_final_position" );
	flag_init( "t72_exploded" );
	flag_init( "betting_dialog_over" );
	flag_init( "abrams_move_shoot_t72" );
	flag_init( "abrams_advance_to_end_level" );
	flag_init( "allowTankFire" );
	
	// friendly respawn init;
	flag_set( "respawn_friendlies" );
	set_promotion_order( "r", "y" );
	set_empty_promotion_order( "y" );
	set_empty_promotion_order( "g" );
	
	array_thread( getentarray( "stragglers_chase", "targetname" ), ::stragglers_chase );
	array_thread( getentarray( "flyby", "targetname" ), ::flyby );
	array_thread( getentarray( "chain_and_home", "script_noteworthy" ), ::add_spawn_function, ::chain_and_home );
	array_thread( getentarray( "rpg_tank_shooter", "script_noteworthy" ), ::add_spawn_function, ::rpg_tank_shooter );
	array_thread( getentarray( "rpg_tank_shooter_fall", "script_noteworthy" ), ::add_spawn_function, ::rpg_tank_shooter );
	array_thread( getentarray( "alley_mg_gunner", "script_noteworthy" ), ::add_spawn_function, ::alley_mg_gunner );
	array_thread( getentarray( "vehicle_path_disconnector", "targetname" ), ::vehicle_path_disconnector );
	array_thread( getentarray( "delete_ai", "targetname" ), ::delete_ai_in_zone );
	array_thread( getentarray( "autosave_when_trigger_cleared", "targetname" ), ::autosave_when_trigger_cleared );
	wait 0.05;
	
	clip = getent( "truck_clip_before", "targetname" );
	assert( isdefined( clip ) );
	clip notsolid();
	clip delete();
	
	level.abrams = getent( "abrams", "targetname" );
	if ( !isdefined( level.abrams ) )
		level.abrams = maps\_vehicle::waittill_vehiclespawn( "abrams" );
	assert( isdefined( level.abrams ) );
	level.abrams.forwardEnt = spawn( "script_origin", level.abrams getTagOrigin( "tag_flash" ) );
	level.abrams.forwardEnt linkto( level.abrams );
	assert( isdefined( level.abrams ) );
	
	objective_add( 1, "current", &"BOG_B_OBJ_ESCORT_TANK", ( 4347, -4683, 130 ) );
	
	level.tire_fire = getent( "tire_fire", "targetname" );
	assert( isdefined( level.tire_fire ) );
	playfxontag( level._effect["firelp_large_pm"], level.tire_fire, "tag_origin" );
	
	wait 6.5;
	getent( "player_spawn_safety_brush", "targetname" ) delete();
}

bog_dialog()
{
	wait 4;
	battlechatter_off( "allies" );
	
	excluders = [];
	excluders[0] = level.price;
	
	generic_marine1 = get_closest_ai_exclude ( level.player.origin ,  "allies", excluders );
	assert( isdefined( generic_marine1 ) );
	
	excluders[1] = generic_marine1;
	generic_marine2 = get_closest_ai_exclude ( level.player.origin ,  "allies", excluders );
	assert( isdefined( generic_marine2 ) );
	
	if ( !generic_marine1 isHero() )
		generic_marine1 thread magic_bullet_shield();
	
	if ( !generic_marine2 isHero() )
		generic_marine2 thread magic_bullet_shield();
	
	generic_marine1.animname = "marine1";
	generic_marine2.animname = "marine2";
	
	generic_marine1 anim_single_solo ( generic_marine1, "getyourass" );
	wait 1;
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "wereclear" ] );
	flag_wait( "evemy_helicopter_reinforcement_spawned" );
	wait 8;
	generic_marine2 anim_single_solo ( generic_marine2, "enemyair" );
	wait 0.05;
	level.price anim_single_solo ( level.price, "grabrpg" );
	wait 10;
	generic_marine1 anim_single_solo ( generic_marine1, "rightflank" );
	
	if ( !generic_marine1 isHero() )
		generic_marine1 notify( "stop magic bullet shield" );
	
	if ( !generic_marine2 isHero() )
		generic_marine2 notify( "stop magic bullet shield" );
	
	battlechatter_on( "allies" );
}

isHero()
{
	if ( !isdefined( self ) )
		return false;
	
	if ( !isdefined( self.script_noteworthy ) )
		return false;
	
	if ( self.script_noteworthy == "hero" )
		return true;
	
	return false;
}

fog_adjust()
{
	fog_in = getent( "fog_in", "targetname" );
	fog_out = getent( "fog_out", "targetname" );
	
	assert( isdefined( fog_in ) );
	assert( isdefined( fog_out ) );
	
	for(;;)
	{
		fog_in waittill( "trigger" );
		setExpFog(0, 2842, 0.642709, 0.626383, 0.5, 3.0);
		
		fog_out waittill( "trigger" );
		setExpFog(0, 3842, 0.642709, 0.626383, 0.5, 3.0);
	}
}

start_bog()
{
	spawn_starting_friendlies( "friendly_starting_spawner" );
	
	thread ignored_till_fastrope( "introchopper1" );
	thread ignored_till_fastrope( "introchopper2" );
	
	while( !isdefined( level.abrams ) )
		wait 0.05;
	
	thread tank_advancement_bog();
	
	thread bog_dialog();
	
	level.player.ignoreme = true;
	wait 4;
	level.player.ignoreme = false;
}

start_arch()
{
	spawn_starting_friendlies( "friendly_starting_spawner_arch" );
	
	start = getent( "playerstart_arch", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
	
	wait 0.05;
	
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
	
	while( !isdefined( level.abrams ) )
		wait 0.05;
	
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	level.abrams attachPath( tank_path_2 );
	
	thread tank_advancement_arch();
}

start_alley()
{
	spawn_starting_friendlies( "friendly_starting_spawner_alley" );
	
	start = getent( "playerstart_alley", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
	
	wait 0.05;
	
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
	
	thread tank_advancement_alley();
}

start_t72()
{
	spawn_starting_friendlies( "friendly_starting_spawner_t72" );
	
	start = getent( "playerstart_t72", "targetname" );
	level.player setOrigin( start.origin );
	level.player setPlayerAngles( ( 0, start.angles[1], 0 ) );
	
	wait 0.05;
	
	ai = getaiarray( "axis" );
	for( i = 0 ; i < ai.size ; i++ )
	{
		ai[i] notify( "stop magic bullet shield" );
		ai[i] delete();
	}
	
	thread advanceAlleyFriendliesToEnd();
	
	wait 1;
	while( !isdefined( level.abrams ) )
		wait 0.05;
}

spawn_starting_friendlies( sTargetname )
{
	spawners = getentarray( sTargetname, "targetname" );
	for( i = 0 ; i < spawners.size ; i++ )
	{
		friend = spawners[ i ] stalingradSpawn();
		if ( spawn_failed( friend ) )
			assertMsg( "A friendly failed to spawn" );
		friend.goalradius = 32;
		
		if ( issubstr( friend.classname, "price" ) )
			level.price = friend;
		
		if ( issubstr( friend.classname, "mark" ) )
			level.grigsby = friend;
		
		if ( friend isHero() )
			friend thread magic_bullet_shield();
	}
	
	assert( isdefined( level.price ) );
	level.price.animname = "price";
	level.price make_hero();
	
	assert( isdefined( level.grigsby ) );
	level.grigsby.animname = "grigsby";
	level.grigsby make_hero();
	
	array_thread( getaiarray( "allies" ), ::replace_on_death );
}

ignored_till_fastrope( sTargetname )
{
	vehicle = undefined;
	vehicle = getent( sTargetname, "targetname" );
	if ( !isdefined( vehicle ) )
		vehicle = maps\_vehicle::waittill_vehiclespawn( sTargetname );
	
	assert( isdefined( vehicle.riders ) );
	
	for( i = 0 ; i < vehicle.riders.size ; i++ )
	{
		vehicle.riders[i].ignoreme = true;
		//vehicle.riders[i] thread magic_bullet_shield();
	}
	
	vehicle waittill( "unload" );
	
	wait 5;
	
	for( i = 0 ; i < vehicle.riders.size ; i++ )
	{
		vehicle.riders[i].ignoreme = false;
		//vehicle.riders[i] thread stop_magic_bullet_shield();
	}
}

stragglers_chase()
{
	assert( isdefined( self.target ) );
	volume = getent( self.target, "targetname" );
	assert( isdefined( volume ) );
	
	self waittill( "trigger" );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( !( enemies[ i ] istouching( volume ) ) )
			continue;
		
		enemies[i].goalradius = 600;
		enemies[i] setgoalentity( level.player );
	}
}

truck_crush_tank_in_position()
{
	node = getVehicleNode( "truck_crush_node", "script_noteworthy" );
	assert( isdefined( node ) );
	node waittill( "trigger" );
	level.abrams setSpeed( 0, 999999999, 999999999 );
	flag_set( "truck_crush_tank_in_position" );
}

chain_and_home()
{
	self endon( "death" );
	
	self waittill( "reached_path_end" );
	
	newGoalRadius = distance( self.origin, level.player.origin );
	
	for(;;)
	{
		wait 5;
		self.goalradius = newGoalRadius;
			
		self setgoalentity ( level.player );
		newGoalRadius -= 175;
		if ( newGoalRadius < 512 )
		{
			newGoalRadius = 512;
			return;
		}
	}
}

rpg_tank_shooter()
{
	self endon( "death" );
	
	// when this guy spawns he tries to shoot the tank with his RPG
	self waittill( "goal" );
	
	if ( ( isdefined( self.script_noteworthy ) ) && ( self.script_noteworthy == "rpg_tank_shooter_fall" ) )
		self thread roof_guy_fall_on_death();
	
	self setentitytarget( level.abrams );
	wait 10;
	if ( isdefined( self ) )
		self clearEnemy();
}

roof_guy_fall_on_death()
{
	self endon( "death" );
	self.health = 10;
	for(;;)
	{
		self.deathanim = %exposed_death_neckgrab;
		self.deathFunction = ::roof_guy_fall_death_function;
		wait 0.05;
	}
}

roof_guy_fall_death_function()
{
	self setanim( %exposed_death_neckgrab );
	wait 3;
	self startragdoll();
}

attack_troops()
{
	self notify( "stop_attacking_troops" );
	self endon( "stop_attacking_troops" );
	self endon( "death" );
	wait 1;
	for(;;)
	{
		eTarget = maps\_helicopter_globals::getEnemyTarget( 10000, level.cosine[ "80" ], true, false, false, true );
		if ( isdefined( eTarget ) )
		{
			targetLoc = eTarget.origin + ( 0, 0, 32 );
			self setTurretTargetVec( targetLoc );
			
			if ( getdvar( "bog_debug_tank") == "1" )
				thread draw_line_until_notify( level.abrams.origin + ( 0, 0, 32 ), targetLoc, 1, 0, 0, self, "stop_drawing_line" );
			
			self waittill_notify_or_timeout( "turret_rotate_stopped", 3.0 );
			self clearTurretTarget();
			
			if ( getdvar( "bog_debug_tank") == "1" )
			{
				self notify( "stop_drawing_line" );
				thread draw_line_until_notify( level.abrams.origin + ( 0, 0, 32 ), targetLoc, 0, 1, 0, self, "stop_drawing_line" );
			}
		}
		wait( randomfloatrange( 2, 5 ) );
		
		if ( getdvar( "bog_debug_tank") == "1" )
			self notify( "stop_drawing_line" );
	}
}

tank_turret_forward()
{	
	getent( "tank_turret_forward", "targetname" ) waittill( "trigger" );
	self notify( "stop_attacking_troops" );
	
	self setturrettargetent( self.forwardEnt );
	self waittill_notify_or_timeout( "turret_rotate_stopped", 4.0 );
	self clearTurretTarget();
}

ambush_ahead_dialog()
{
	battlechatter_off( "allies" );
	
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "possibleambush" ] );
	wait 3;
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "standclear" ] );
	
	battlechatter_on( "allies" );
	
	flag_set( "tank_clear_to_shoot" );
}

playRadioSound( soundAlias )
{
	if ( !isdefined( level.radio_in_use ) )
		level.radio_in_use = false;
	
	soundPlayed = false;
	soundPlayed = playAliasOverRadio( soundAlias );
	if ( soundPlayed )
		return;
	
	level.radioForcedTransmissionQueue[ level.radioForcedTransmissionQueue.size ] = soundAlias;
	while( !soundPlayed )
	{
		if ( level.radio_in_use )
			level waittill ( "radio_not_in_use" );
		soundPlayed = playAliasOverRadio( level.radioForcedTransmissionQueue[ 0 ] );
		if ( !level.radio_in_use && !soundPlayed )
			assertMsg( "The radio wasn't in use but the sound still did not play. This should never happen." );
	}
	level.radioForcedTransmissionQueue = array_remove_index( level.radioForcedTransmissionQueue, 0 );
}

playAliasOverRadio( soundAlias )
{
	if ( level.radio_in_use )
		return false;
	
	level.radio_in_use = true;
	level.player playLocalSound( soundAlias, "playSoundOverRadio_done" );
	level.player waittill( "playSoundOverRadio_done" );
	level.radio_in_use = false;
	level.lastRadioTransmission = getTime();
	level notify ( "radio_not_in_use" );
	return true;
}

shoot_buildings( exploderGroup )
{
	self notify( "stop_attacking_troops" );
	
	flag_wait( "tank_clear_to_shoot" );
	
	for(;;)
	{
		if ( level.exploderArray[ exploderGroup ].size <= 0 )
			break;
		
		nextExploderIndex = undefined;
		nextExploderIndex = getNextExploder( exploderGroup );
		if ( !isdefined( nextExploderIndex ) )	
		{
			wait randomfloat( 2, 4 );
			continue;
		}
		
		shoot_exploder( level.exploderArray[ exploderGroup ][ nextExploderIndex ] );
		level.exploderArray[ exploderGroup ] = array_remove_index ( level.exploderArray[ exploderGroup ], nextExploderIndex );
		
		wait randomfloat( 6, 10 );
	}
	
	self notify( "abrams_shot_explodergroup" );
}

setupExploder( exploderNum, explodedFunction, parm1 )
{
	exploderStruct = spawnStruct();
	
	exploderStruct.iNumber = int( exploderNum );
	exploderStruct.sNumber = string( exploderNum );
	
	// find the related origin
	origins = getentarray( "exploder_tank_target", "targetname" );
	for( i = 0 ; i < origins.size ; i++ )
	{
		assert( isdefined( origins[ i ].script_noteworthy ) );
		if ( origins[ i ].script_noteworthy == exploderStruct.sNumber )
			exploderStruct.origin = origins[ i ].origin;
	}
	assert( isdefined( exploderStruct.origin ) );
	
	// find the area trigger if one exists
	areatrigs = getentarray( "exploder_area", "targetname" );
	for( i = 0 ; i < areatrigs.size ; i++ )
	{
		assert( isdefined( areatrigs[ i ].script_noteworthy ) );
		if ( areatrigs[ i ].script_noteworthy == exploderStruct.sNumber )
			exploderStruct.areaTrig = areatrigs[ i ];
	}
	
	exploderStruct.explodedFunction = explodedFunction;
	exploderStruct.parm1 = parm1;
	
	return exploderStruct;
}

getNextExploder( exploderGroup )
{
	// try to find one that the player is looking at
	
	// if the exploder has an area trigger make sure the player isn't touching it
	validIndicies = [];
	for( i = 0 ; i < level.exploderArray[ exploderGroup ].size ; i++ )
	{
		if ( isdefined( level.exploderArray[ exploderGroup ][ i ].areaTrig ) && level.player isTouching( level.exploderArray[ exploderGroup ][ i ].areaTrig ) )
			continue;
		validIndicies[ validIndicies.size ] = i;
	}
	if ( validIndicies.size == 0 )
		return undefined;
	
	// if the player is looking at one of the valid exploders then use that one
	for( i = 0 ; i < validIndicies.size ; i++ )
	{
		qInFOV = within_fov( level.player getEye(), level.player getPlayerAngles(), level.exploderArray[ exploderGroup ][ validIndicies[ i ] ].origin, level.cosine[ "35" ] );
		if ( qInFOV )
			return validIndicies[ i ];
	}
	return validIndicies[ 0 ];
}

shoot_exploder( exploderStruct )
{
	level.abrams thread tank_shooting_exploder_dialog( exploderStruct.iNumber );		
	
	level.abrams waittill( "target_aquired" );
	level.abrams setTurretTargetVec( exploderStruct.origin );
	level.abrams waittill_notify_or_timeout( "turret_rotate_stopped", 3.0 );
	level.abrams clearTurretTarget();
	level.abrams.readyToFire = true;
	
	flag_wait( "allowTankFire" );
	level.abrams.readyToFire = undefined;
	level.abrams notify( "turret_fire" );
	flag_clear( "allowTankFire" );
	wait 0.2;
	
	//blow up the wall now
	exploder( exploderStruct.iNumber );
	
	if ( isdefined( exploderStruct.explodedFunction ) )
	{
		if ( isdefined( exploderStruct.parm1 ) )
			level thread [[ exploderStruct.explodedFunction ]]( exploderStruct.parm1 );
		else
			level thread [[ exploderStruct.explodedFunction ]]();
	}
	
	wait 0.05;
	radiusDamage( exploderStruct.origin, 300, 5000, 1000 );
	badplace_cylinder( exploderStruct.sNumber, 7.0, exploderStruct.origin, 200, 300, "axis" );
}

tank_shooting_exploder_dialog( exploderNum )
{
	assert( isdefined( exploderNum ) );
	
	if ( exploderNum == 105 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "2story1_ground" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire1" ] );
	}
	else if ( exploderNum == 104 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "2story1_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 102 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up3" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story11_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired3" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire3" ] );
	}
	else if ( exploderNum == 103 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up4" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story1130_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire1" ] );
	}
	else if ( exploderNum == 100 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story1230_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 101 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "3story11_2ndfloor" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 200 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up1" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired2" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire2" ] );
	}
	else if ( exploderNum == 201 )
	{
		self.haltFire = true;
		level.player playRadioSound( level.scr_sound[ "tank_loader" ][ "up3" ] );
		self notify( "target_aquired" );
		while( !isdefined( self.readyToFire ) )
			wait 0.05;
		level.player playRadioSound( level.scr_sound[ "tank_gunner" ][ "targetacquired1" ] );
		level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "fire1" ] );
	}
	else
	{
		wait 0.05;
		self notify( "target_aquired" );
		wait 0.05;
	}
	
	self.readyToFire = true;
	flag_set( "allowTankFire" );
}

killSpawner( num )
{
	thread maps\_spawner::kill_spawnerNum( num );
}

alley_mg_gunner()
{
	self.ignoreme = true;
	self thread magic_bullet_shield();
	flag_wait( "mg_killer_in_position" );
	self notify( "stop magic bullet shield" );
}

mg_killers()
{
	// player enters alley, do dialog and wait for player to advance or timeout
	getent( "player_in_alley", "targetname" ) waittill( "trigger" );
	getent( "spawn_mg_killers", "targetname" ) wait_for_trigger_or_timeout( 5.0 );
	
	// then friendlies spawn and kill the mg gunners in the windows
	spawner1 = getent( "mg_killer1", "targetname" );
	spawner2 = getent( "mg_killer2", "targetname" );
	
	killer1 = spawner1 stalingradSpawn();
	if ( spawn_failed( killer1 ) )
		assertMsg( "mg killer 1 failed to spawn" );
		
	killer2 = spawner2 stalingradSpawn();
	if ( spawn_failed( killer2 ) )
		assertMsg( "mg killer 2 failed to spawn" );
	
	killer1 thread magic_bullet_shield();
	killer1.ignoreme = true;
	
	killer2 thread magic_bullet_shield();
	killer2.ignoreme = true;
	
	mg_killers_kickdoor( killer1, killer2 );
	
	// run upstairs now
	mg_killer_node = getnode( "mg_killer_node", "targetname" );
	assert( isdefined( mg_killer_node ) );
	assert( isdefined( mg_killer_node.radius ) );
	
	killer1 setgoalnode( mg_killer_node );
	killer1 thread mg_killer_delete_on_goal();
	killer1.goalradius = mg_killer_node.radius;
	
	killer2.goalradius = mg_killer_node.radius;
	killer2 setgoalnode( mg_killer_node );
	killer2 thread mg_killer_delete_on_goal();
	
	flag_wait( "mg_killer_in_position" );
	
	fx_origin = getentarray( "kill_mg_grenade_location", "targetname" );
	assert( fx_origin.size == 2 );
	
	for( i = 0 ; i < 4 ; i++ )
	{
		fx_origin[ 0 ] playsound( level.scr_sound[ "mg_kill_grenade_bounce" ] );
		wait( randomfloatrange( 0.1, 0.3 ) );
	}
	
	radiusDamage( fx_origin[ 0 ].origin, 300, 5000, 1000 );
	fx_origin[ 0 ] playsound( level.scr_sound[ "mg_kill_grenade_explode" ] );
	playfx( level._effect[ "mg_kill_grenade" ], fx_origin[ 0 ].origin );
	exploder( 107 );
	wait 0.7;
	radiusDamage( fx_origin[ 1 ].origin, 300, 5000, 1000 );
	fx_origin[ 1 ] playsound( level.scr_sound[ "mg_kill_grenade_explode" ] );
	playfx( level._effect[ "mg_kill_grenade" ], fx_origin[ 1 ].origin );
	wait 1;
	fx_origin[ 0 ] thread play_sound_in_space( level.scr_sound[ "gm2" ][ "clear" ] );
	wait 1.2;
	fx_origin[ 1 ] thread play_sound_in_space( level.scr_sound[ "gm3" ][ "clear" ] );
}

mg_killers_kickdoor( guy1, guy2 )
{
	guys[ 0 ] = guy1;
	guys[ 1 ] = guy2;
	
	guys[ 0 ].animname = "mgkiller_left";
	guys[ 1 ].animname = "mgkiller_right";
	
	thread mg_killers_kickdoor_dialog( guys[ 1 ] );
	
	kill_mg_scripted_node = getent( "kill_mg_scripted_node", "targetname" );
	assert( isdefined( kill_mg_scripted_node ) );
	
	// guy1 waits at the door until guy2 arrives
	thread mg_killer_guy1_idle( kill_mg_scripted_node, guys[ 0 ] );
	wait 1;
	kill_mg_scripted_node anim_reach_solo ( guys[ 1 ], "enter" );
	flag_wait( "door_idle_guy_idling" );
	guys[ 0 ] notify( "stop_door_idle" );
	kill_mg_scripted_node anim_single( guys, "enter" );
}

mg_killers_kickdoor_dialog( guy )
{
	guy anim_single_solo( guy, "comingleft" );
	level.price thread anim_single_solo( level.price, "rogerthat" );
}

mg_killer_guy1_idle( node, guy )
{
	node anim_reach_and_idle_solo( guy, "idle_reach", "idle", "stop_door_idle" );
	flag_set( "door_idle_guy_idling" );
}

mg_killer_doorOpen( guy )
{
	// called from a notetrack
	mg_killer_door = getent( "mg_killer_door", "targetname" );
	assert( isdefined( mg_killer_door ) );
	mg_killer_door connectPaths();
	mg_killer_door rotateYaw( -140, 0.5, 0, 0 );
	wait 0.5;
	mg_killer_door disconnectPaths();
}

mg_killer_delete_on_goal()
{
	self endon( "death" );
	self waittill( "goal" );
	flag_set( "mg_killer_in_position" );
	thread advanceAlleyFriendliesToEnd();
	self notify( "stop magic bullet shield" );
	self delete();
}

mg_alley_deadzone()
{
	level endon( "mg_killer_in_position" );
	
	zone = getent( "mg_alley_dead_zone", "targetname" );
	assert( isdefined( zone ) );
	assert( isdefined( zone.target ) );
	damageLoc = getent( zone.target, "targetname" ).origin;
	assert( isdefined( damageLoc ) );
	
	zone waittill( "trigger" );
	
	// player is a dead man now!
	gunners = getentarray( "alley_mg_gunner", "targetname" );
	for( i = 0 ; i < gunners.size ; i++ )
	{
		if ( !isAI( gunners[ i ] ) )
			continue;
		gunners[ i ] setentitytarget( level.player );
	}
	
	dmgAmount = ( level.player.health / 3 );
	while( isalive( level.player ) )
	{
		level.player doDamage ( dmgAmount, damageLoc );
		wait randomfloatrange( 0.05, 0.3 );
	}
}

flyby()
{
	assert( isdefined( self.target ) );
	origins = getentarray( self.target, "targetname" );
	assert( origins.size > 0 );
	for( i = 0 ; i < origins.size ; i++ )
		self thread flyby_go( origins[ i ] );
}

flyby_go( origin1 )
{
	assert( isdefined( origin1 ) );
	assert( isdefined( origin1.target ) );
	origin2 = getent( origin1.target, "targetname" );
	assert( isdefined( origin2 ) );
	
	// Get starting and ending point for the plane
	center = ( ( ( origin1.origin[ 0 ] + origin2.origin[ 0 ] ) / 2 ), ( ( origin1.origin[ 1 ] + origin2.origin[ 1 ] ) / 2 ), 0 );
	angle = VectorToAngles( origin2.origin - origin1.origin );
	
	direction = ( 0, angle[ 1 ], 0 );
	planeStartingDistance = -20000;
	planeEndingDistance = 20000;
	planeFlySpeed = 4000;
	
	startPoint = center + vector_multiply( anglestoforward( direction ), planeStartingDistance );
	startPoint += ( 0, 0, origin1.origin[ 2 ] );
	endPoint = center + vector_multiply( anglestoforward( direction ), planeEndingDistance );
	endPoint += ( 0, 0, origin2.origin[ 2 ] );
	
	self waittill( "trigger" );
	
	// Spawn the plane
	plane = spawn( "script_model", startPoint );
	plane setModel( "vehicle_mig29_desert" );
	plane.angles = direction;
	
	// Make the plane fly by
	d = abs( planeStartingDistance - planeEndingDistance );
	flyTime = ( d / planeFlySpeed );
	
	// Draw some debug lines of the plane's path
	if ( getdvar( "bog_debug_flyby") == "1" )
	{
		thread draw_line_for_time( center, center + ( 0, 0, 200 ), 0, 0, 1, flyTime );
		thread draw_line_for_time( origin1.origin, origin2.origin, .1, .2, .4, flyTime );
		thread draw_line_for_time( center, startPoint, 0, .4, 0, flyTime );
		thread draw_line_for_time( center, endPoint, 0, .8, 0, flyTime );
		thread draw_line_to_ent_for_time( center, plane, 1, 0, 0, flyTime );
	}
	
	plane moveTo( endPoint, flyTime, 0, 0 );
	thread flyby_planeSound( plane );
	
	// Delete the plane after it's flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}

flyby_afterburner( plane )
{
	plane endon( "delete" );
	wait randomfloatrange( 0.5, 2.5 );
	for (;;)
	{
		playfxontag( level._effect["afterburner"], plane, "tag_engine_right" );
		playfxontag( level._effect["afterburner"], plane, "tag_engine_left" );
		wait 0.1;
	}
}

flyby_planeSound( plane )
{
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !maps\_mig29::playerisclose( plane ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( maps\_mig29::playerisinfront( plane ) )
		wait .05;
	wait .5;
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	thread flyby_afterburner( plane );
	while( maps\_mig29::playerisclose( plane ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}

teamsSplitUp()
{
	getent( "teams_split_up", "script_noteworthy" ) waittill( "trigger" );
	
	area = getent( "price_inside_split_up_house", "targetname" );
	for(;;)
	{
		area waittill( "trigger", ent );
		if ( !isdefined( ent ) )
			continue;
		if ( ent == level.price )
			break;
	}
	
	anim_single_solo( level.price, "keeppinned" );
	if ( isdefined( level.grigsby ) )
	{
		level.grigsby.animname = "grigsby";
		thread anim_single_solo( level.grigsby, "staysharp" );
	}
}

lastSequence()
{
	thread t72_in_final_position();
	
	// wait till player has entered the last building
	getent( "last_building_trigger", "targetname" ) waittill( "trigger" );
	
	// delete yellow and green friendlies since they are respawned upstairs
	colorsToDelete = [];
	colorsToDelete[ 0 ] = "y";
	colorsToDelete[ 1 ] = "g";
	for( i = 0 ; i < colorsToDelete.size ; i++ )
	{
		guys = get_force_color_guys( "allies", colorsToDelete[ i ] );
		for( j = 0 ; j < guys.size ; j++ )
		{
			guys[ j ] notify( "disable_reinforcement" );
			guys[ j ] notify( "stop magic bullet shield" );
			guys[ j ] delete();
		}
	}
	
	// spawn new guys upstairs ( excluding the door blocking guys )
	spawners = getentarray( "last_sequence_spawner", "targetname" );
	assert( spawners.size == 2 );
	for( i = 0 ; i < spawners.size ; i++ )
	{
		guy = spawners[ i ] stalingradSpawn();
		if ( spawn_failed( guy ) )
			assertMsg( "Friendly upstairs in last building failed to spawn!" );
	}
	
	// spawn the guys that guard the door - two of them, one for each door. Only one will play the animation
	guardSpawners = getentarray( "door_blocker_spawner", "targetname" );
	assert( guardSpawners.size == 2 );
	for( i = 0 ; i < guardSpawners.size ; i++ )
	{
		assert( isdefined( guardSpawners[ i ].target ) );
		trigger = getent( guardSpawners[ i ].target, "targetname" );
		assert( isdefined( trigger ) );
		node = getnode( guardSpawners[ i ].target, "targetname" );
		assert( isdefined( node ) );
		guy = guardSpawners[ i ] stalingradSpawn();
		if ( spawn_failed( guy ) )
			assertMsg( "Friendly upstairs in last building failed to spawn!" );
		if ( i == 0 )
			thread lastSequence_guard1( guy, node, trigger );
		else
			thread lastSequence_guard2( guy, node, trigger );
	}
	
	//make friendlies and enemies ignore each other and make allies not die
	thread friendly_reinforcements_magic_bullet();
	array_thread( getaiarray( "allies" ), ::magic_bullet_shield );
	setignoremegroup( "allies", "axis" );
	setignoremegroup( "axis", "allies" );
	level.player.ignoreme = true;
	
	// delete all the axis remaining in the level for now
	array_thread( getaiarray( "axis" ), ::self_delete );
	
	flag_wait( "price_at_spotter" );
	flag_wait( "ok_to_do_spotting" );
	
	priceNode = getnode( "price_last_node", "targetname" );
	level.price anim_single_solo( level.price, "casual_2_spot" );
	level.price thread anim_loop_solo( level.price, "spot", undefined, "stop_idle" );
	level.price thread anim_single_solo( level.price, "t72behind" );
	wait 3;
	flag_set( "abrams_move_shoot_t72" );
	wait 1.5;
	//priceNode thread anim_single_solo( level.price, "spot_2_casual" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "switchmanual" ] );
	
	thread finalGenericDialog();
	flag_wait( "betting_dialog_over" );
	
	//wait for the tank to be in position and turret aligned
	flag_wait( "tank_in_final_position" );
	flag_wait( "tank_turret_aimed_at_t72" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "takeshot" ] );
	
	//-------------------------------------
	// tank should be shot and explode here
	//-------------------------------------
	level.abrams clearTurretTarget();
	level.abrams setVehWeapon( "m1a1_turret_blank" );
	wait 0.05;
	level.abrams notify( "turret_fire" );
	exploder( 400 );
	
	end_sequence_physics_explosion = getentarray( "end_sequence_physics_explosion", "targetname" );
	for( i = 0 ; i < end_sequence_physics_explosion.size ; i++ )
		physicsExplosionSphere( end_sequence_physics_explosion[ i ].origin, 550, 100, 1.2 );
	
	wait .2;
	level thread t72_explosion_explode();
	//-------------------------------------
	//-------------------------------------
	//-------------------------------------
	
	flag_wait( "friendly_reactions_over" );
	
	anim_single_solo( level.price, "niceshootingpig" );
	
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "comingthrough" ] );
	
	flag_set( "abrams_advance_to_end_level" );
	
	wait 2;
	
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "wethereyet" ] );
	level.player playRadioSound( level.scr_sound[ "hq_radio" ][ "statusover" ] );
	anim_single_solo( level.price, "cargo" );
	
	missionsuccess( "ac130", false );
}

t72_explosion_explode()
{
	level.t72 thread t72_explosionFX();

	level.t72 useAnimTree( level.scr_animtree[ "tank_explosion" ] );
	level.t72 setFlaggedAnim( "tank_explosion_anim", level.scr_anim[ "tank" ][ "explosion" ], 1, 0.1, 1 );
	level.t72 setmodel( "vehicle_t72_tank_d_animated_sequence" );
	
	level.t72 waittillmatch( "tank_explosion_anim", "turret_explosion" );
	level.t72 thread play_sound_in_space( "bog_scn_tankturret_exp" );
	wait 0.8;
	level.t72 thread play_sound_in_space( "bog_scn_tankturret_crash" );
}

t72_explosionFX()
{
	playfxontag( level._effect[ "t72_explosion" ], level.t72, "tag_deathfx" );
	level.t72 thread play_sound_in_space( "explo_metal_rand" );
	physicsExplosionSphere( level.t72.origin, 1000, 20, 2 );
	playfxontag( level._effect[ "t72_ammo_breach" ], level.t72, "tag_deathfx" );
	wait 3.5;
	thread friendlyReactionAnims();
	flag_set( "t72_exploded" );
	playfxontag( level._effect[ "t72_ammo_explosion" ], level.t72, "tag_deathfx" );
	playfxontag( level._effect[ "firelp_large_pm" ], level.t72, "tag_deathfx" );
	wait .15;
	physicsExplosionSphere( level.t72.origin, 1000, 100, 2 );
//	playfx( level._effect["thin_black_smoke_M"], self.origin );
}

abrams_setup_t72()
{
	assert( isdefined( level.t72 ) );
	thread abrams_moveto_t72();
	thread abrams_aimat_t72();
}

abrams_moveto_t72()
{
	level.abrams resumeSpeed( 3 );
	level.abrams setWaitNode( getvehiclenode( "tank_shoots_t72_node", "script_noteworthy" ) );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 1000, 1000 );
	flag_set( "tank_in_final_position" );
}

abrams_aimat_t72()
{
	flag_wait( "t72_in_final_position" );
	flag_set( "tank_in_final_position" );
	level.abrams setTurretTargetVec( level.t72.origin + ( 0, 0, 50 ) );
	level.abrams waittill_notify_or_timeout( "turret_rotate_stopped", 3.0 );
	flag_set( "tank_turret_aimed_at_t72" );
}

friendly_reinforcements_magic_bullet()
{
	for(;;)
	{
		level waittill( "reinforcement_spawned", reinforcement );
		
		if ( !isdefined( reinforcement ) )
			continue;
		
		if ( !isalive( reinforcement ) )
			continue;
		
		reinforcement thread magic_bullet_shield();
	}
}

getFiveFriendliesTimeout( timeout )
{
	level endon( "got 5 friendlies" );
	wait timeout;
	assertMsg( "Failed to get 5 alive friendlies for a scripted sequence" );
}

finalGenericDialog()
{
	// get 5 friendlies excluding price
	allies = getaiarray( "allies" );
	friendsToSpeak = [];
	for( i = 0 ; i < allies.size ; i++ )
	{
		if ( allies[ i ] == level.price )
			continue;
		friendsToSpeak[ friendsToSpeak.size ] = allies[ i ];
	}
	
	// friendlies could be dead when this is called so we have to wait until reinforcements have spawned till we have 5 guys
	// dont try for too long though, time out after say 8 seconds.
	level thread getFiveFriendliesTimeout( 8.0 );
	for(;;)
	{
		if ( friendsToSpeak.size >= 5 )
			break;
		
		level waittill( "reinforcement_spawned", reinforcement );
		
		if ( !isdefined( reinforcement ) )
			continue;
		
		if ( !isalive( reinforcement ) )
			continue;
		
		friendsToSpeak[ friendsToSpeak.size ] = reinforcement;
	}
	assert( friendsToSpeak.size >= 5 );
	level notify( "got 5 friendlies" );
	
	friendsToSpeak[ 0 ].animname = "gm1";
	friendsToSpeak[ 1 ].animname = "gm2";
	friendsToSpeak[ 2 ].animname = "gm3";
	friendsToSpeak[ 3 ].animname = "gm4";
	friendsToSpeak[ 4 ].animname = "gm5";
	
	thread anim_single_solo( friendsToSpeak[ 0 ], "callit" );
	wait 2.0;
	thread anim_single_solo( friendsToSpeak[ 1 ], "afterlast" );
	wait 3.0;
	thread anim_single_solo( friendsToSpeak[ 0 ], "youreon" );
	wait 1.4;
	
	flag_set( "betting_dialog_over" );
	flag_wait( "t72_exploded" );
	
	wait 2;
	
	friendsToSpeak[ 0 ].animname = "gm1";
	friendsToSpeak[ 1 ].animname = "gm2";
	friendsToSpeak[ 2 ].animname = "gm3";
	friendsToSpeak[ 3 ].animname = "gm4";
	friendsToSpeak[ 4 ].animname = "gm5";
	
	thread anim_single_solo( friendsToSpeak[ 0 ], "wooyeah" );
	wait 1.5;
	thread anim_single_solo( friendsToSpeak[ 1 ], "holyshit" );
	wait 1.75;
	thread anim_single_solo( friendsToSpeak[ 2 ], "hellyeah" );
	wait 2.1;
	thread anim_single_solo( friendsToSpeak[ 3 ], "yeahwoo" );
	wait 1.5;
	thread anim_single_solo( friendsToSpeak[ 4 ], "talkinabout" );
	wait 2.3;
	
	flag_set( "friendly_reactions_over" );
}

friendlyReactionAnims()
{
	allies = getAIArray( "allies" );
	for( i = 0 ; i < allies.size ; i++ )
	{
		if ( !isAlive( allies[ i ] ) )
			continue;
		
		if ( allies[ i ] == level.price )
		{
			allies[ i ] thread price_react_and_loop();
		}
		else if ( ( isdefined( allies[ i ].script_noteworthy ) ) && ( allies[ i ].script_noteworthy == "doorguard" ) )
		{
			allies[ i ] thread guard_react_and_celebrate();
		}
		else
		{
			allies[ i ].animname = "casualcrouch";
			allies[ i ] thread anim_single_solo( allies[ i ], "react" );
		}
	}
}

guard_react_and_celebrate()
{
	self.animname = "guard";
	self anim_single_solo( self, "react" );
	wait 1.0;
	self thread anim_single_solo( self, "celebrate" );
}

price_react_and_loop()
{
	//priceNode = getnode( "price_last_node", "targetname" );
	self notify( "stop_idle" );
	self anim_single_solo( self, "react" );
	self thread anim_loop_solo( self, "spot", undefined, "stop_idle" );
}

lastSequence_guard1( guy, node, trigger )
{
	level endon( "guy1 cancel" );
	
	assert( isdefined( guy ) );
	assert( isdefined( node ) );
	assert( isdefined( trigger ) );
	
	guy.goalradius = 16;
	guy setGoalNode( node );
	
	trigger waittill( "trigger" );
	
	level notify( "guy2 cancel" );
	
	guy.animname = "guard";
	node anim_single_solo( guy, "stop" );
	
	flag_set( "ok_to_do_spotting" );
}

lastSequence_guard2( guy, node, trigger )
{
	level endon( "guy2 cancel" );
	
	assert( isdefined( guy ) );
	assert( isdefined( node ) );
	assert( isdefined( trigger ) );
	
	guy.goalradius = 16;
	guy setGoalNode( node );
	
	trigger waittill( "trigger" );
	
	level notify( "guy1 cancel" );
	
	guy.animname = "guard";
	node anim_single_solo( guy, "stop" );
	
	flag_set( "ok_to_do_spotting" );
}

advanceAlleyFriendliesToEnd()
{
	array_thread( get_force_color_guys( "allies", "r" ), ::magic_bullet_shield );
	wait 0.05;
	level.price set_force_color( "o" );
	level.price.goalradius = 16;
	level.price setGoalNode( getnode( "price_last_node", "targetname" ) );
	getent( "last_color_order_trigger", "targetname" ) notify( "trigger" );
	level.price waittill( "goal" );
	flag_set( "price_at_spotter" );
}

t72_in_final_position()
{
	level.t72 = maps\_vehicle::waittill_vehiclespawn( "t72" );
	assert( isdefined( level.t72 ) );
	level.t72 waittill( "reached_end_node" );
	flag_set( "t72_in_final_position" );
}

vehicle_path_disconnector()
{
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	zone notsolid();
	zone.origin -= ( 0, 0, 1024 );
	
	for(;;)
	{
		self waittill( "trigger", tank );
		assert( isdefined( tank ) );
		assert( tank == level.abrams );
		
		if ( !isdefined( zone.pathsDisconnected ) )
		{
			zone solid();
			zone disconnectpaths();
			zone notsolid();
			zone.pathsDisconnected = true;
		}
		
		thread vehicle_reconnects_paths( zone );
	}
}

vehicle_reconnects_paths( zone )
{
	zone notify( "waiting_for_path_reconnection" );
	zone endon( "waiting_for_path_reconnection" );
	wait 0.5;
	
	// paths get reconnected
	zone solid();
	zone connectpaths();
	zone notsolid();
	zone.pathsDisconnected = undefined;
}

playerInit()
{	
    level.player DisableWeapons();
	flag_wait( "pullup_weapon" );
    level.player EnableWeapons();
	level.player switchToWeapon( "m4_grenadier" );
}

delete_ai_in_zone()
{
	assert( isdefined( self.target ) );
	zone = getent( self.target, "targetname" );
	assert( isdefined( zone ) );
	
	self waittill( "trigger" );
	
	axis = getaiarray( "axis" );
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( axis[ i ] isTouching( zone ) )
			axis[ i ] delete();
	}
}

autosave_when_trigger_cleared()
{
	assert( isdefined( self.script_noteworthy ) );
	for(;;)
	{
		self waittill( "trigger" );
		if( !ai_touching_area( self ) )
			break;
		wait 3;
	}
	thread maps\_utility::autosave_by_name ( self.script_noteworthy );
}

waittill_zone_clear( sTargetname )
{
	assert( isdefined( sTargetname ) );
	zone = getent( sTargetname, "targetname" );
	assert( isdefined( zone ) );
	
	while( ai_touching_area( zone ) )
	{
		wait 2;
	}
}

ai_touching_area( zone )
{
	assert( isdefined( zone ) );
	axis = getaiarray( "axis" );
	for( i = 0 ; i < axis.size ; i++ )
	{
		if( axis[ i ] isTouching( zone ) )
			return true;
	}
	return false;
}

tank_advancement_bog()
{
	//--------------
	// Bog Area
	//--------------
	
	flag_init( "truck_crush_tank_in_position" );
	thread truck_crush_tank_in_position();
	
	// puts the tank turret forward when it hits a trigger just before the tank crush sequence
	level.abrams thread tank_turret_forward();
	
	// abrams shoots at enemies in the bog
	level.abrams thread attack_troops();
	
	// wait till the tank is in tank crush position
	flag_wait( "truck_crush_tank_in_position" );
	
	// wait until the player hits the tank crush trigger
	flag_wait( "truck_crush_player_in_position" );
	
	thread autosave_by_name( "tank_crush" );
	
	truck = getent( "crunch_truck_1", "targetname" );
	
	// player and tank in position, wait to see if player is looking at the tank
	// if player doesn't look at tank soon then timeout and do the sequence anyways
	timeoutTime = 10;
	for( i = 0 ; i < timeoutTime * 20 ; i++ )
	{
		if ( within_fov( level.player getEye(), level.player getPlayerAngles(), truck.origin, level.cosine[ "65" ] ) )
			break;
		wait 0.05;
	}
	tank_path_2 = getVehicleNode( "tank_path_2", "targetname" );
	level.abrams resumeSpeed( 5 );
	//getent( "truck_clip_before", "targetname" ) delete();
	level.abrams maps\_vehicle::tank_crush( truck,
											tank_path_2,
											level.scr_anim[ "tank" ][ "tank_crush" ],
											level.scr_anim[ "truck" ][ "tank_crush" ],
											level.scr_animtree[ "tank_crush" ],
											level.scr_sound[ "tank_crush" ] );
	
	thread tank_advancement_arch();
}

tank_advancement_arch()
{
	//--------------
	// Archway Road
	//--------------
	
	// price warns about guys on rooftops
	level.price thread anim_single_solo( level.price, "watchrooftops" );
	
	// tank moves up path and stops at it's stop node where it will shoot exploder group 0
	node = getvehiclenode( "stop_for_city_fight1", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	// tank says possible ambush positions up ahead
	level.abrams thread ambush_ahead_dialog();
	
	// tank in position, shoot exploder group 0
	level.abrams thread shoot_buildings( 0 );
	
	// wait until all exploders in the group have gone off
	level.abrams waittill( "abrams_shot_explodergroup" );
	
	// abrams shoots at enemies until it's clear to move up
	level.abrams thread attack_troops();
	waittill_zone_clear( "tank_zone_1" );
	
	// tank and price talk about it being clear to move up a bit
	battlechatter_off( "allies" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "movingup" ] );
	wait 0.1;
	level.price thread anim_single_solo( level.price, "roger" );
	battlechatter_on( "allies" );
	
	// tank moves up a bit and stops to shoot at exploder group 1
	level.abrams resumeSpeed( 3 );
	node = getvehiclenode( "stop_for_city_fight2", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	// tank in position, shoot exploder group 1
	level.abrams thread shoot_buildings( 1 );
	
	// wait until all exploders in the group have gone off
	level.abrams waittill( "abrams_shot_explodergroup" );
	
	// abrams shoots at enemies until it's clear to move up again
	level.abrams thread attack_troops();
	waittill_zone_clear( "tank_zone_2" );
	
	// tank tells price it's moving up to the corner
	battlechatter_off( "allies" );
	level.player playRadioSound( level.scr_sound[ "tank_commander" ][ "cleartoadvance" ] );
	wait 0.1;
	level.price anim_single_solo( level.price, "rogermoveup" );
	wait 0.1;
	level.player thread playRadioSound( level.scr_sound[ "tank_commander" ][ "rogermoving" ] );
	battlechatter_on( "allies" );
	
	// tank moves up to corner and stops to shoot at exploder group 2
	level.abrams resumeSpeed( 3 );
	node = getvehiclenode( "stop_for_city_fight3", "script_noteworthy" );
	level.abrams setWaitNode( node );
	level.abrams waittill( "reached_wait_node" );
	level.abrams setSpeed( 0, 10 );
	
	// tank in position, shoot exploder group 2
	level.abrams thread shoot_buildings( 2 );
	
	// wait until all exploders in the group have gone off
	level.abrams waittill( "abrams_shot_explodergroup" );
	
	// shoot at enemies with the MG now
	level.abrams thread attack_troops();
	
	thread tank_advancement_alley();
}

tank_advancement_alley()
{
	flag_wait( "abrams_move_shoot_t72" );
	thread abrams_setup_t72();
	
	/*
	advancementTrigger = getent( "tank_advance_to_corner", "targetname" );
	advancementTrigger waittill( "trigger" );
	
	advancementTrigger = getent( "tank_advance_to_end", "targetname" );
	advancementTrigger waittill( "trigger" );
	
	*/
	
	
	flag_wait( "abrams_advance_to_end_level" );
	
	crushNode = getvehiclenode( "tank_crush_truck2", "script_noteworthy" );
	crunch_truck_2 = getent( "crunch_truck_2", "targetname" );
	tank_path_4 = getVehicleNode( "tank_path_4", "targetname" );
	
	level.abrams setturrettargetent( level.abrams.forwardEnt );
	level.abrams waittill_notify_or_timeout( "turret_rotate_stopped", 4.0 );
	level.abrams clearTurretTarget();
	
	level.abrams resumeSpeed( 3 );
	level.abrams setWaitNode( crushNode );
	level.abrams waittill( "reached_wait_node" );
	level.abrams thread maps\_vehicle::tank_crush( crunch_truck_2,
													tank_path_4,
													level.scr_anim[ "tank" ][ "tank_crush" ],
													level.scr_anim[ "truck" ][ "tank_crush" ],
													level.scr_animtree[ "tank_crush" ],
													level.scr_sound[ "tank_crush2" ] );
}