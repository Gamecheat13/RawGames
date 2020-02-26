#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;

precacheLevelStuff()
{
	precacheString( &"VILLAGE_ASSAULT_OBJECTIVE_SECURE_VILLAGE" );
	precacheString( &"VILLAGE_ASSAULT_OBJECTIVE_SECURE_VILLAGE_NOCOUNT" );	
	precacheString( &"VILLAGE_ASSAULT_OBJECTIVE_LOCATE_ALASAD" );
	precacheString( &"SCRIPT_ARMOR_DAMAGE" );
	precacheModel( "sundirection_arrow" );
	precacheItem( "mi28_ffar_village_assault" );
	
	level.air_support_fx_yellow = loadfx( "misc/ui_pickup_available" );
	level.air_support_fx_red 	= loadfx( "misc/ui_pickup_unavailable" );
	level.ffar_mi28_muzzleflash = loadfx( "muzzleflashes/cobra_rocket_flash_wv" );
	
	level.weaponClipModels = [];
	level.weaponClipModels[0] = "weapon_ak47_clip";
	level.weaponClipModels[1] = "weapon_mp5_clip";
	level.weaponClipModels[2] = "weapon_m16_clip";
	level.weaponClipModels[3] = "weapon_g36_clip";
	level.weaponClipModels[4] = "weapon_dragunov_clip";
	level.weaponClipModels[5] = "weapon_g3_clip";
}

setLevelDVars()
{
	setSavedDvar( "r_specularColorScale", "1.8" );
	
	if ( getdvar( "village_assault_debug_marker") == "" )
		setdvar( "village_assault_debug_marker", "0" );
	
	setculldist( 6500 );
	
	level.seekersUsingColors = false;
	level.BMP_Safety_Distance = 512 * 512;
	level.goodFriendlyDistanceFromPlayerSquared = 512 * 512;
	level.chopperSupportCallsRemaining = 3;
	level.chopperSupportHoverLocations = [];
	hoverEnts = getentarray( "chopper_location", "targetname" );
	for( i = 0 ; i < hoverEnts.size ; i++ )
	{
		level.chopperSupportHoverLocations[ level.chopperSupportHoverLocations.size ] = hoverEnts[ i ].origin;
		hoverEnts[ i ] delete();
	}
	assert( level.chopperSupportHoverLocations.size > 0 );
	level.cosine[ "25" ] = cos( 25 );
	level.cosine[ "45" ] = cos( 45 );
	level.cosine[ "55" ] = cos( 55 );
	level.cosine[ "60" ] = cos( 60 );
	level.cosine[ "70" ] = cos( 70 );
	
	level.next_genocide_audio = 0;
	level.genocide_audio[ 0 ] = "assault_killing_distance1";
	level.genocide_audio[ 1 ] = "assault_killing_interior1";
	level.genocide_audio[ 2 ] = "assault_killing_interior2";
	level.genocide_audio[ 3 ] = "assault_killing_interior3";
	
	level.timedAutosaveNumber = 0;
	level.timedAutosaveTime = undefined;
	skill = getdifficulty();
	switch( skill )
	{
		case "gimp":
		case "easy":
			level.timedAutosaveTime = 60;
			break;
		case "medium":
			level.timedAutosaveTime = 120;
			break;
		case "hard":
		case "difficult":
			level.timedAutosaveTime = 180;
			break;
		case "fu":
			level.timedAutosaveTime = 0;
			break;
	}
	assert( isdefined( level.timedAutosaveTime ) );
}

scriptCalls()
{
	maps\_mi28::main( "vehicle_mi-28_flying" );
	maps\_bmp::main( "vehicle_bmp_woodland" );
	maps\createart\village_assault_art::main();
	maps\village_assault_fx::main();
	maps\_c4::main();
	maps\_load::main();
	maps\_load::set_player_viewhand_model( "viewhands_player_sas_woodland" );
	maps\_javelin::init();
	maps\village_assault_anim::main();
	level thread maps\village_assault_amb::main();
	maps\_compass::setupMiniMap("compass_map_village_assault");
	
	animscripts\dog_init::initDogAnimations();
	
	array_thread( getentarray( "seek_player", "script_noteworthy" ), ::add_spawn_function, ::seek_player );
	array_thread( getentarray( "seek_player_smart", "script_noteworthy" ), ::add_spawn_function, ::seek_player_smart );
	array_thread( getentarray( "dog", "script_noteworthy" ), ::add_spawn_function, ::seek_player_smart );
	array_thread( getentarray( "enemy_color_hint_trigger", "targetname" ), ::enemy_color_hint_trigger_think );
	array_thread( getentarray( "genocide_audio_trigger", "targetname" ), ::genocide_audio_trigger );
	//array_thread( getentarray( "dead_civilian", "targetname" ), ::dead_civilian );
	array_thread( getentarray( "trigger_upstairs_guys", "targetname" ), ::trigger_upstairs_guys );
	
	add_hint_string( "call_air_support1", &"SCRIPT_LEARN_CHOPPER_AIR_SUPPORT1", ::delete_hint_print_activated_air_support );
	add_hint_string( "call_air_support2", &"SCRIPT_LEARN_CHOPPER_AIR_SUPPORT2", ::delete_hint_print_called_air_support );
	
	thread chopper_air_support();
	thread vehicle_patrol_init();
	thread roaming_bmp();
	thread timedAutosaves();
	thread maps\_weather::rainLight( 1 );
	//thread maps\_weather::rainHard( 1 );
	
	if ( getdvar( "village_assault_disable_gameplay") == "1" )
		thread disable_gameplay();
	
	wait 0.05;
	//array_thread( getentarray( "distracted_guy_spawn", "targetname" ), ::distracted_guys_spawn );
	//array_thread( getentarray( "assasination", "targetname" ), ::assasination );
	
	wait 1.0;
	objective_add( 1, "current", &"VILLAGE_ASSAULT_OBJECTIVE_LOCATE_ALASAD", ( 0, 0, 0 ) );
}

disable_gameplay()
{
	array_thread( getentarray( "trigger_multiple", "classname" ), ::disable_gameplay_trigger );
	array_thread( getentarray( "trigger_radius", "classname" ), ::disable_gameplay_trigger );
}

disable_gameplay_trigger()
{
	gameplayTrigger = false;
	
	if ( self.spawnflags & 32 )
		gameplayTrigger = true;
	
	if ( isdefined( self.targetname ) )
	{
		if ( self.targetname == "flood_and_secure" )
			gameplayTrigger = true;
		else if ( self.targetname == "flood_spawner" )
			gameplayTrigger = true;
	}
	
	if ( gameplayTrigger )
		self thread trigger_off();
}

spawn_starting_friendlies( sTargetname )
{
	level.friendlies = [];
	spawners = getentarray( sTargetname, "targetname" );
	for( i = 0 ; i < spawners.size ; i++ )
	{
		friend = spawners[ i ] stalingradSpawn();
		if ( spawn_failed( friend ) )
			assertMsg( "A friendly failed to spawn" );
		
		friend.goalradius = 32;
		friend.fixednode = false;
		
		if ( issubstr( friend.classname, "price" ) )
			level.price = friend;
		
		if ( friend isHero() )
			friend thread magic_bullet_shield( undefined, 5.0 );
		
		level.friendlies[ level.friendlies.size ] = friend;
		
		friend thread friendly_adjust_movement_speed();
	}
	
	assert( isdefined( level.price ) );
	level.price.animname = "price";
	level.price make_hero();
	
	//array_thread( getaiarray( "allies" ), ::replace_on_death );
	assert( level.friendlies.size == spawners.size );
}

friendly_adjust_movement_speed()
{
	self endon( "death" );
	
	for(;;)
	{
		wait randomfloatrange( 1.0, 3.0 );
		
		while( friendly_should_speed_up() )
		{
			self.moveplaybackrate = 2.0;
			wait 0.05;
		}
		
		self.moveplaybackrate = 1.0;
	}
}

friendly_should_speed_up()
{
	prof_begin( "friendly_movement_rate_math" );
	
	if ( !isdefined( self.goalpos ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	if ( distanceSquared( self.origin, self.goalpos ) <= level.goodFriendlyDistanceFromPlayerSquared )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	// check if AI is visible in player's FOV
	if ( within_fov( level.player.origin, level.player getPlayerAngles(), self.origin, level.cosine[ "60" ] ) )
	{
		prof_end( "friendly_movement_rate_math" );
		return false;
	}
	
	prof_end( "friendly_movement_rate_math" );
	
	return true;
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

friendly_sight_distance( fDistance )
{
	dist = fDistance * fDistance;
	for( i = 0 ; i < level.friendlies.size ; i++ )
		level.friendlies[ i ].maxsightdistsqrd = dist;
}

friendly_movement_speed( speed )
{
	for( i = 0 ; i < level.friendlies.size ; i++ )
		level.friendlies[ i ].moveplaybackrate = speed;
}

friendly_stance( stance1, stance2, stance3 )
{
	for( i = 0 ; i < level.friendlies.size ; i++ )
	{
		if ( isdefined ( stance3 ) )
			level.friendlies[ i ] allowedStances( stance1, stance2, stance3 );
		else
		if ( isdefined ( stance2 ) )
			level.friendlies[ i ] allowedStances( stance1, stance2 );
		else
		level.friendlies[ i ] allowedStances( stance1 );
	}
}

distracted_guys_spawn()
{
	script_org = getent( self.target, "targetname" );
	assert( isdefined( script_org ) );
	assert( script_org.classname == "script_origin" );
	distractedGuyStruct = spawnStruct();
	
	targeted = getentarray( script_org.target, "targetname" );
	distractedGuyStruct.alert_triggers = [];
	distractedGuyStruct.spawners = [];
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if ( issubstr( targeted[ i ].classname, "trigger" ) )
		{
			assert( isdefined( targeted[ i ].script_noteworthy ) );
			distractedGuyStruct.alert_triggers[ distractedGuyStruct.alert_triggers.size ] = targeted[ i ];
		}
		else if ( targeted[ i ] isSpawner() )
		{
			assert( isdefined( targeted[ i ].script_animation ) );
			distractedGuyStruct.spawners[ distractedGuyStruct.spawners.size ] = targeted[ i ];
		}
	}
	assert( distractedGuyStruct.alert_triggers.size > 0 );
	assert( distractedGuyStruct.spawners.size > 0 );
	
	distractedGuyStruct.nodes = [];
	for( i = 0 ; i < distractedGuyStruct.spawners.size ; i++ )
	{
		assert( isdefined( distractedGuyStruct.spawners[ i ].target ) );
		node = getnode( distractedGuyStruct.spawners[ i ].target, "targetname" );
		assert( isdefined( node ) );
		distractedGuyStruct.nodes[ distractedGuyStruct.nodes.size ] = node;
	}
	
	assert( distractedGuyStruct.nodes.size > 0 );
	assert( distractedGuyStruct.nodes.size == distractedGuyStruct.spawners.size );
	
	self waittill( "trigger" );
	
	// spawn the guys
	distractedGuyStruct.guys = [];
	for( i = 0 ; i < distractedGuyStruct.spawners.size ; i++ )
	{
		spawned = distractedGuyStruct.spawners[ i ] stalingradSpawn();
		if ( spawn_failed( spawned ) )
		{
			assertMsg( "distracted guy failed to spawn" );
			return;
		}
		distractedGuyStruct.guys[ distractedGuyStruct.guys.size ] = spawned;
	}
	assert( distractedGuyStruct.guys.size > 0 );
	
	thread distractedGuys_animate( distractedGuyStruct );
}

distractedGuys_animate( distractedGuyStruct )
{
	for( i = 0 ; i < distractedGuyStruct.alert_triggers.size ; i++ )
		distractedGuyStruct.alert_triggers[ i ] thread distractedGuys_alert_trigger( distractedGuyStruct );
	
	for( i = 0 ; i < distractedGuyStruct.guys.size ; i++ )
	{
		distractedGuyStruct.guys[ i ].distracted = true;
		//distractedGuyStruct.guys[ i ].ignoreme = true;
		distractedGuyStruct.guys[ i ] thread alert_event_notify( distractedGuyStruct );
		distractedGuyStruct.guys[ i ].animname = distractedGuyStruct.guys[ i ].script_animation;
		distractedGuyStruct.nodes[ i ] thread anim_loop_solo( distractedGuyStruct.guys[ i ], "idle", undefined, "stop_idle" );
		distractedGuyStruct.guys[ i ].allowdeath = true;
		if ( isdefined( level.scr_anim[ distractedGuyStruct.guys[ i ].animname ][ "death" ] ) )
			distractedGuyStruct.guys[ i ].deathanim = level.scr_anim[ distractedGuyStruct.guys[ i ].animname ][ "death" ];
	}
	
	thread distractedGuys_alert( distractedGuyStruct );
}

distractedGuys_alert_trigger( distractedGuyStruct )
{
	self waittill( self.script_noteworthy );
	distractedGuyStruct notify( "alerted" );
}

distractedGuys_alert( distractedGuyStruct )
{
	switch( distractedGuyStruct.guys.size )
	{
		case 1:
			level waittill_any_ents(	distractedGuyStruct, "alerted",
										distractedGuyStruct.guys[ 0 ] , "alerted",
										distractedGuyStruct.guys[ 0 ], "death",
										distractedGuyStruct.guys[ 0 ], "damage" );
			break;
		case 2:
			level waittill_any_ents(	distractedGuyStruct, "alerted",
										distractedGuyStruct.guys[ 0 ] , "alerted",
										distractedGuyStruct.guys[ 0 ], "death",
										distractedGuyStruct.guys[ 0 ], "damage",
										distractedGuyStruct.guys[ 1 ], "alerted",
										distractedGuyStruct.guys[ 1 ], "death",
										distractedGuyStruct.guys[ 1 ], "damage" );
			break;
	}
	
	distractedGuyStruct notify( "alerted" );
	wait randomfloatrange( 0, 1.3 );
	
	for( i = 0 ; i < distractedGuyStruct.guys.size ; i++ )
	{
		if ( !isalive( distractedGuyStruct.guys[ i ] ) )
			continue;
		
		distractedGuyStruct.guys[ i ].distracted = undefined;
		//distractedGuyStruct.guys[ i ].ignoreme = false;
		distractedGuyStruct.guys[ i ] notify( "alerted" );
		distractedGuyStruct.guys[ i ] notify( "stop_idle" );
		distractedGuyStruct.guys[ i ].deathanim = undefined;
		if ( isdefined( level.scr_anim[ distractedGuyStruct.guys[ i ].animname ][ "react" ] ) )
			distractedGuyStruct.nodes[ i ] thread anim_single_solo( distractedGuyStruct.guys[ i ], "react" );
		else
			distractedGuyStruct.guys[ i ] stopanimscripted();
	}
}

assasination()
{
	targeted = getentarray( self.target, "targetname" );
	script_org = undefined;
	assasinate_trigger = undefined;
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if ( targeted[ i ].classname == "script_origin" )
			script_org = targeted[ i ];
		if ( issubstr( targeted[ i ].classname, "trigger" ) )
			assasinate_trigger = targeted[ i ];
	}
	assert( isdefined( script_org ) );
	assasinationStruct = spawnStruct();
	if ( isdefined( assasinate_trigger ) )
		assasinationStruct.assasinate_trigger = assasinate_trigger;
	
	targeted = getentarray( script_org.target, "targetname" );
	assasinationStruct.assasination_triggers = [];
	assasinationStruct.spawners = [];
	for( i = 0 ; i < targeted.size ; i++ )
	{
		if ( issubstr( targeted[ i ].classname, "trigger" ) )
		{
			assert( isdefined( targeted[ i ].script_noteworthy ) );
			assasinationStruct.assasination_triggers[ assasinationStruct.assasination_triggers.size ] = targeted[ i ];
		}
		else if ( targeted[ i ] isSpawner() )
		{
			assasinationStruct.spawners[ assasinationStruct.spawners.size ] = targeted[ i ];
		}
	}
	assert( assasinationStruct.assasination_triggers.size > 0 );
	assert( assasinationStruct.spawners.size > 0 );
	
	for( i = 0 ; i < assasinationStruct.spawners.size ; i++ )
	{
		assert( isdefined( assasinationStruct.spawners[ i ].target ) );
		node = getnode( assasinationStruct.spawners[ i ].target, "targetname" );
		assert( isdefined( node ) );
		assasinationStruct.spawners[ i ].animnode = node;
	}
		
	self waittill( "trigger" );
	
	// spawn the guys
	assasinationStruct.guys = [];
	for( i = 0 ; i < assasinationStruct.spawners.size ; i++ )
	{
		spawned = assasinationStruct.spawners[ i ] stalingradSpawn();
		if ( spawn_failed( spawned ) )
		{
			assertMsg( "assasination guy failed to spawn" );
			return;
		}
		assert( isdefined( assasinationStruct.spawners[ i ].animnode ) );
		spawned.animnode = assasinationStruct.spawners[ i ].animnode;
		assasinationStruct.guys[ assasinationStruct.guys.size ] = spawned;
	}
	assert( assasinationStruct.guys.size > 0 );
	assasinationStruct.executioners = [];
	allGuys = assasinationStruct.guys;
	for( i = 0 ; i < allGuys.size ; i++ )
	{
		if ( allGuys[ i ].team != "axis" )
		{
			//allGuys[ i ].ignoreme = true;
			continue;
		}
		
		assasinationStruct.executioners[ assasinationStruct.executioners.size ] = allGuys[ i ];
		assasinationStruct.guys = array_remove( assasinationStruct.guys, allGuys[ i ] );
	}
	assert( assasinationStruct.executioners.size > 0 );
	assert( assasinationStruct.guys.size > 0 );
	assert( assasinationStruct.guys.size + assasinationStruct.executioners.size == assasinationStruct.spawners.size );
	
	thread assasination_think( assasinationStruct );
}

assasination_think( assasinationStruct )
{
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
		assasinationStruct.executioners[ i ] endon( "death" );
	
	for( i = 0 ; i < assasinationStruct.guys.size ; i++ )
		thread assasination_assasinated_idle( assasinationStruct, i );
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
		thread assasination_executioner_idle( assasinationStruct, i );
	
	thread assasination_alert( assasinationStruct );

	assasinationStruct waittill_any( "alerted", "assasinate" );
	
	createthreatbiasgroup( "executioner" );
	createthreatbiasgroup( "assasinated" );
	setthreatbias( "assasinated", "executioner", 100000 );
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
	{
		assasinationStruct.executioners[ i ] setthreatbiasgroup( "executioner" );
		assasinationStruct.executioners[ i ] notify( "stop_idle" );
		assasinationStruct.executioners[ i ] stopanimscripted();
		assasinationStruct.executioners[ i ].goalradius = 16;
		assasinationStruct.executioners[ i ] setGoalNode( assasinationStruct.executioners[ i ].animnode );
		assasinationStruct.executioners[ i ].old_baseAccuracy = assasinationStruct.executioners[ i ].baseAccuracy;
		assasinationStruct.executioners[ i ].baseAccuracy = 1000;
	}
	
	for( i = 0 ; i < assasinationStruct.guys.size ; i++ )
	{
		assasinationStruct.guys[ i ] setthreatbiasgroup( "assasinated" );
		assasinationStruct.guys[ i ].deathanim = level.scr_anim[ "assasinated" ][ "knees_fall" ];
		assasinationStruct.guys[ i ] thread assasination_ragdoll_death();
		assasinationStruct.guys[ i ].allowdeath = true;
		//assasinationStruct.guys[ i ].ignoreme = false;
	}
	
	switch( assasinationStruct.guys.size )
	{
		case 1:
			assasinationStruct.guys[ 0 ] waittill( "death" );
			break;
		case 2:
			waittill_multiple_ents( assasinationStruct.guys[ 0 ], "death", assasinationStruct.guys[ 1 ], "death" );
			break;
		case 3:
			waittill_multiple_ents( assasinationStruct.guys[ 0 ], "death", assasinationStruct.guys[ 1 ], "death", assasinationStruct.guys[ 2 ], "death" );
			break;
		case 4:
			waittill_multiple_ents( assasinationStruct.guys[ 0 ], "death", assasinationStruct.guys[ 1 ], "death", assasinationStruct.guys[ 2 ], "death", assasinationStruct.guys[ 3 ], "death" );
			break;
	}
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
	{
		assasinationStruct.executioners[ i ].baseAccuracy = assasinationStruct.executioners[ i ].old_baseAccuracy;
		assasinationStruct.executioners[ i ].old_baseAccuracy = undefined;
	}
}

assasination_alert( assasinationStruct )
{
	for( i = 0 ; i < assasinationStruct.assasination_triggers.size ; i++ )
		assasinationStruct.assasination_triggers[ i ] thread assasination_kill_trigger( assasinationStruct );
	
	for( i = 0 ; i < assasinationStruct.executioners.size ; i++ )
	{
		assasinationStruct.executioners[ i ] thread alert_event_notify( assasinationStruct );
		thread assasination_alert_thread( assasinationStruct.executioners[ i ], assasinationStruct );
	}
}

assasination_alert_thread( guy, assasinationStruct )
{
	level waittill_any_ents(	assasinationStruct, "alerted",
								guy , "alerted",
								guy, "death",
								guy, "damage" );
	
	assasinationStruct notify( "assasinate" );
}

assasination_ragdoll_death()
{
	self waittill( "death" );
	wait 0.5;
	if ( isdefined( self ) )
		self startRagDoll();
}

assasination_assasinated_idle( assasinationStruct, guyIndex )
{
	assasinationStruct.guys[ guyIndex ] thread gun_remove();
	assasinationStruct.guys[ guyIndex ].animname = "assasinated";
	if ( randomint( 3 ) == 0 )
	{
		if ( randomint( 3 ) == 0 )
			assasinationStruct.guys[ guyIndex ].animnode anim_single_solo( assasinationStruct.guys[ guyIndex ], "stand_idle2" );
		assasinationStruct.guys[ guyIndex ].animnode anim_single_solo( assasinationStruct.guys[ guyIndex ], "stand_fall" );
	}
	assasinationStruct.guys[ guyIndex ].animnode thread anim_loop_solo( assasinationStruct.guys[ guyIndex ], "knees_idle", undefined, "stop_idle" );
}

assasination_executioner_idle( assasinationStruct, guyIndex )
{
	assasinationStruct.executioners[ guyIndex ].allowdeath = true;
	assasinationStruct.executioners[ guyIndex ].animname = "executioner";
	assasinationStruct.executioners[ guyIndex ].animnode thread anim_loop_solo( assasinationStruct.executioners[ guyIndex ], "idle", undefined, "stop_idle" );
}

assasination_kill_trigger( assasinationStruct )
{
	self waittill( self.script_noteworthy );
	assasinationStruct notify( "assasinate" );
}

alert_event_notify( struct )
{
	struct endon( "alerted" );
	self endon( "death" );
	
	self thread add_event_listener( "grenade danger" );
	self thread add_event_listener( "gunshot" );
	self thread add_event_listener( "silenced_shot" );
	self thread add_event_listener( "bulletwhizby" );
	self thread add_event_listener( "projectile_impact" );
	
	self waittill( "event_notify" );
	
	struct notify( "alerted" );
}

add_event_listener( sEventString )
{
	self endon( "death" );
	self endon( "event_notify" );
	self addAIEventListener( sEventString );
	self waittill( sEventString );
	self removeAIEventListener( sEventString );
	self notify( "event_notify" );
}

seek_player()
{
	self endon( "death" );
	
	if ( ( isdefined( self.distracted ) ) && ( self.distracted == true ) )
		self waittill( "alerted" );
	
	self.goalradius = 600;
	self setgoalentity( level.player );
}

enemy_color_hint_trigger_think()
{
	for(;;)
	{
		// trigger is hit - notify the targeted trigger to make enemies use color nodes
		self waittill( "trigger" );
		
		//iprintlnbold( "using colors" );
		getent( self.target, "targetname" ) notify( "trigger" );
		level.seekersUsingColors = true;
		
		while( level.player isTouching( self ) )
			wait 0.1;
		
		// player not in trigger anymore - make enemies use players goal pos
		level.seekersUsingColors = false;
		level notify( "seekers_chase_player" );
	}
}

seek_player_smart()
{
	self endon( "death" );
	
	if ( ( isdefined( self.distracted ) ) && ( self.distracted == true ) )
		self waittill( "alerted" );
	
	self set_force_color( "r" );
	for(;;)
	{
		if ( !level.seekersUsingColors )
		{
			//iprintlnbold( "using player" );
			self.goalradius = 2000;
			self.pathenemyfightdist = 1500;
			self setEngagementMinDist( 1300, 1000 );
			self setgoalentity( level.player );
		}
		level waittill( "seekers_chase_player" );
	}
}

waittill_ai_in_volume_dead( volumeTargetname )
{
	volume = getent( volumeTargetname, "targetname" );
	axis = getaiarray( "axis" );
	volumeAxis = [];
	for( i = 0 ; i < axis.size ; i++ )
	{
		if ( !axis[ i ] isTouching( volume ) )
			continue;
		volumeAxis[ volumeAxis.size ] = axis[ i ];
	}
	
	if( volumeAxis.size > 0 )
		waittill_dead( volumeAxis );
}

add_objective_building( aiGroupNum )
{
	if ( !isdefined( level._ai_group ) )
		return;
	
	if ( !isdefined( level._ai_group[ aiGroupNum ] ) )
		return;
	
	// Create objective top clear buildings if it hasn't been created yet
	if ( !isdefined( level.buildings_remaining ) )
	{
		level.buildings_remaining = 0;
		objective_add( 0, "current", &"VILLAGE_ASSAULT_OBJECTIVE_SECURE_VILLAGE_NOCOUNT", ( 0, 0, 0 ) );
	}
	
	// Add a building to the objective text
	level.buildings_remaining++;
	objective_string_nomessage( 0, &"VILLAGE_ASSAULT_OBJECTIVE_SECURE_VILLAGE", level.buildings_remaining );
	
	// Find the matching script_origin building location for this objective. It will have the same script_aigroup as the AI
	all_obj_locs = getentarray( "objective_location", "targetname" );
	objective_location = undefined;
	for( i = 0 ; i < all_obj_locs.size ; i++ )
	{
		assert( isdefined( all_obj_locs[ i ].script_aigroup ) );
		if ( all_obj_locs[ i ].script_aigroup != aiGroupNum )
			continue;
		objective_location = all_obj_locs[ i ].origin;
		break;
	}
	assert( isdefined( objective_location ) );
	objectivePositionIndex = level.buildings_remaining;
	
	// Add waypoint to this building for the objective
	objective_additionalposition( 0, objectivePositionIndex, objective_location );
	
	// Wait until all AI at this building objective are dead
	waittill_aigroupcleared( aiGroupNum );
	
	wait randomfloatrange( 1.5, 3.0 );
	
	// Buildings cleared - Remove waypoint and update objective text
	level.buildings_remaining--;
	objective_additionalposition( 0, objectivePositionIndex, ( 0, 0, 0 ) );
	objective_string( 0, &"VILLAGE_ASSAULT_OBJECTIVE_SECURE_VILLAGE", level.buildings_remaining );
	
	// Autosave the game at this point
	thread doAutoSave( "building_" + aiGroupNum + "_cleared" );
	
	// If all buildings cleared mark the objective as "done"
	if ( level.buildings_remaining <= 0 )
	{
		objective_state( 0, "done" );
		wait 5;
		missionsuccess( "scoutsniper" );
	}
}

chopper_air_support()
{
	for(;;)
	{
		while( level.player getcurrentweapon() != "cobra_air_support" )
			wait 0.05;
		
		thread chopper_air_support_activate();
		
		while( level.player getcurrentweapon() == "cobra_air_support" )
			wait 0.05;
		
		level notify( "air_support_canceled" );
		thread chopper_air_support_deactive();
	}
}

chopper_air_support_activate()
{
	level endon( "air_support_canceled" );
	level endon( "air_support_called" );
	thread chopper_air_support_paint_target();
	
	// Make the arrow
	level.chopperAttackArrow = spawn( "script_model", ( 0, 0, 0 ) );
	level.chopperAttackArrow setModel( "tag_origin" );
	level.chopperAttackArrow.angles = ( -90, 0, 0 );
	level.chopperAttackArrow.offset = 4;
	
	playfxontag( level.air_support_fx_yellow, level.chopperAttackArrow, "tag_origin" );
	
	level.playerActivatedAirSupport = true;
	
	coord = undefined;
	
	traceOffset = 15;
	traceLength = 15000;
	minValidLength = 300 * 300;
	
	trace = [];
	
	trace[ 0 ] = spawnStruct();
	trace[ 0 ].offsetDir = "vertical";
	trace[ 0 ].offsetDist = traceOffset;
	
	trace[ 1 ] = spawnStruct();
	trace[ 1 ].offsetDir = "vertical";
	trace[ 1 ].offsetDist = traceOffset * -1;
	
	trace[ 2 ] = spawnStruct();
	trace[ 2 ].offsetDir = "horizontal";
	trace[ 2 ].offsetDist = traceOffset;
	
	trace[ 3 ] = spawnStruct();
	trace[ 3 ].offsetDir = "horizontal";
	trace[ 3 ].offsetDist = traceOffset * -1;
	
	for(;;)
	{
		wait 0.05;
		
		prof_begin( "spotting_marker" );
		
		// Trace to where the player is looking
		direction = level.player getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = level.player getEye();
		
		for ( i = 0 ; i < trace.size ; i++ )
		{
			start = eye;
			vec = undefined;
			if ( trace[ i ].offsetDir == "vertical" )
				vec = anglesToUp( direction );
			else if ( trace[ i ].offsetDir == "horizontal" )
				vec = anglesToRight( direction );
			assert( isdefined( vec ) );
			start = start + vector_multiply( vec, trace[ i ].offsetDist );
			trace[ i ].trace = bullettrace( start, start + vector_multiply( direction_vec , traceLength ), 0, undefined );
			trace[ i ].length = distanceSquared( start, trace[ i ].trace[ "position" ] );
			
			if ( getdvar( "village_assault_debug_marker") == "1" )
				thread draw_line_for_time( start, trace[ i ].trace[ "position" ], 1, 1, 1, 0.05 );
		}
		
		validLocations = [];
		validNormals = [];
		for ( i = 0 ; i < trace.size ; i++ )
		{
			if ( trace[ i ].length < minValidLength )
				continue;
			index = validLocations.size;
			validLocations[ index ] = trace[ i ].trace[ "position" ];
			validNormals[ index ] = trace[ i ].trace[ "normal" ];
			
			if ( getdvar( "village_assault_debug_marker") == "1" )
				thread draw_line_for_time( level.player getEye(), validLocations[ index ], 0, 1, 0, 0.05 );
		}
		
		// if all points are too close just use all of them since none are good
		if ( validLocations.size == 0 )
		{
			for ( i = 0 ; i < trace.size ; i++ )
			{
				validLocations[ i ] = trace[ i ].trace[ "position" ];
				validNormals[ i ] = trace[ i ].trace[ "normal" ];
			}
		}
		
		assert( validLocations.size > 0 );
		
		if ( validLocations.size == 4 )
		{
			fxLocation = findAveragePointVec( validLocations[ 0 ], validLocations[ 1 ], validLocations[ 2 ], validLocations[ 3 ] );
			fxNormal = findAveragePointVec( validNormals[ 0 ], validNormals[ 1 ], validNormals[ 2 ], validNormals[ 3 ] );
		}
		else if ( validLocations.size == 3 )
		{
			fxLocation = findAveragePointVec( validLocations[ 0 ], validLocations[ 1 ], validLocations[ 2 ] );
			fxNormal = findAveragePointVec( validNormals[ 0 ], validNormals[ 1 ], validNormals[ 2 ] );
		}
		else if ( validLocations.size == 2 )
		{
			fxLocation = findAveragePointVec( validLocations[ 0 ], validLocations[ 1 ] );
			fxNormal = findAveragePointVec( validNormals[ 0 ], validNormals[ 1 ] );
		}
		else
		{
			fxLocation = validLocations[ 0 ];
			fxNormal = validNormals[ 0 ];
		}
		
		if ( getdvar( "village_assault_debug_marker") == "1" )
			thread draw_line_for_time( level.player getEye(), fxLocation, 1, 0, 0, 0.05 );
		
		// Draw the arrow and circle around the arrow
		//thread drawChopperAttackArrow( fxLocation, vectorScale( direction_vec, -1 ) );
		thread drawChopperAttackArrow( fxLocation, fxNormal );
		
		prof_end( "spotting_marker" );
	}
}

findAveragePointVec( point1, point2, point3, point4 )
{
	assert( isdefined( point1 ) );
	assert( isdefined( point2 ) );
	
	if ( isdefined( point4 ) )
	{
		x = findAveragePoint( point1[ 0 ], point2[ 0 ], point3[ 0 ], point4[ 0 ] );
		y = findAveragePoint( point1[ 1 ], point2[ 1 ], point3[ 1 ], point4[ 1 ] );
		z = findAveragePoint( point1[ 2 ], point2[ 2 ], point3[ 2 ], point4[ 2 ] );
	}
	else if ( isdefined( point3 ) )
	{
		x = findAveragePoint( point1[ 0 ], point2[ 0 ], point3[ 0 ] );
		y = findAveragePoint( point1[ 1 ], point2[ 1 ], point3[ 1 ] );
		z = findAveragePoint( point1[ 2 ], point2[ 2 ], point3[ 2 ] );
	}
	else
	{	
		x = findAveragePoint( point1[ 0 ], point2[ 0 ] );
		y = findAveragePoint( point1[ 1 ], point2[ 1 ] );
		z = findAveragePoint( point1[ 2 ], point2[ 2 ] );
	}
	return( x, y, z );
}

findAveragePoint( point1, point2, point3, point4 )
{
	assert( isdefined( point1 ) );
	assert( isdefined( point2 ) );
	
	if ( isdefined( point4 ) )
		return ( ( point1 + point2 + point3 + point4 ) / 4 );
	else if ( isdefined( point3 ) )
		return ( ( point1 + point2 + point3 ) / 3 );
	else
		return ( ( point1 + point2 ) / 2 );
}

chopper_air_support_deactive()
{
	wait 0.05;
	if ( isdefined( level.chopperAttackArrow ) )
		level.chopperAttackArrow delete();
}

chopper_air_support_paint_target()
{
	level endon( "air_support_canceled" );
	level.player waittill ( "weapon_fired" );
	
	level.playerCalledAirSupport = true;
	
	thread chopper_air_support_mark();
	
	// give player his weapon back
	weaponList = level.player GetWeaponsListPrimaries();
	if ( isdefined( weaponList[ 0 ] ) )
		level.player switchToWeapon( weaponList[ 0 ] );
	
	thread chopper_air_support_call_chopper( level.chopperAttackArrow.origin );
	
	level notify( "air_support_called" );
	chopper_air_support_deactive();
	
	level.chopperSupportCallsRemaining--;
	
	if ( level.chopperSupportCallsRemaining >= 2 )
		level.player playLocalSound( "village_assault_plt_positiveid" );
	else
	if ( level.chopperSupportCallsRemaining == 1 )
		level.player playLocalSound( "village_assault_plt_cominhot" );
	else
	if ( level.chopperSupportCallsRemaining <= 0 )
		level.player playLocalSound( "village_assault_plt_standby" );
}

chopper_air_support_mark()
{
	marker = spawn( "script_model", level.chopperAttackArrow.origin );
	marker setModel( "tag_origin" );
	marker.angles = level.chopperAttackArrow.angles;
	
	wait 0.1;
	
	playfxontag( level.air_support_fx_red, marker, "tag_origin" );
	
	wait 5.0;
	
	marker delete();
}

chopper_air_support_call_chopper( coordinate )
{
	closestPoint = findBestChopperWaypoint( coordinate, 45 );
	if ( closestPoint <= -1 )
	{
		wait 0.05;
		closestPoint = findBestChopperWaypoint( coordinate, 60 );
	}
	assertEx( closestPoint > -1, "Chopper couldn't calculate any valid locations to fly to. Bug this to LDs!" );
	
	if ( getdvar( "debug_chopper_air_support") == "1" )
		print3d( level.chopperSupportHoverLocations[ closestPoint ] + ( 0, 0,20 ), "chosen", ( 0, 0, 1 ), 1.0, 3.0, 10000 );
	
	// spawn the chopper
	level.chopper = maps\_vehicle::spawn_vehicle_from_targetname( "chopper" );
	assert( isdefined( level.chopper ) );
	level.chopper endon( "death" );
	
	returnToBasePos = level.chopper.origin;
	
	// fly chopper to that point and make it face the direction of the target
	eTarget = spawn( "script_origin", coordinate );
	level.chopper setLookAtEnt( eTarget );
	
	level.chopper setspeed( 65, 10, 20 );
	level.chopper sethoverparams( 250, 60, 35 );
	yawAngle = vectorToAngles( coordinate - level.chopperSupportHoverLocations[ closestPoint ] );
	level.chopper setgoalyaw( yawAngle[ 1 ] );
	level.chopper setvehgoalpos( level.chopperSupportHoverLocations[ closestPoint ], true );
	
	level.chopper setNearGoalNotifyDist( 4000 );
	level.chopper waittill( "near_goal" );
	level.chopper thread chopper_ai_mode();
	level.chopper settargetyaw( yawAngle[ 1 ] );
	
	level.chopper waittill( "goal" );
	
	// kill all the spawners nearby the coordinate
	killspawns = getentarray( "helicopter_force_kill_spawn", "targetname" );
	for ( i = 0 ; i < killspawns.size ; i++ )
	{
		if ( eTarget isTouching( killspawns[ i ] ) )
		{
			assert( isdefined( killspawns[ i ].target ) );
			trig = getentarray( killspawns[ i ].target, "targetname" );
			for ( j = 0 ; j < trig.size ; j++ )
				trig[ j ] notify( "trigger" );
		}
	}
	
	level.chopper thread chopper_ai_mode_missiles( eTarget );
	
	badplace_cylinder( "air_support_AOE", 30.0, eTarget.origin, 1050, 10000, "allies" );
	thread chopper_air_support_end( returnToBasePos );
	
}

player_activated_air_support()
{
	return isdefined( level.playerActivatedAirSupport );
}

player_called_air_support()
{
	return isdefined( level.playerCalledAirSupport );
}

delete_hint_print_activated_air_support()
{
	if ( isdefined( level.air_support_hint_delete ) )
	{
		level.air_support_hint_delete = undefined;
		return true;
	}
	
	return isdefined( level.playerActivatedAirSupport );
}

delete_hint_print_called_air_support()
{
	if ( isdefined( level.air_support_hint_delete ) )
	{
		level.air_support_hint_delete = undefined;
		return true;
	}
	
	return isdefined( level.playerCalledAirSupport );
}

findBestChopperWaypoint( coordinate, fov_angle )
{
	if ( getdvar( "debug_chopper_air_support") == "1" )
		iprintln( "chopper deciding which location to fly to" );
	
	playerCoordinate = level.player.origin;
	playerFaceAngle = level.player getPlayerAngles();
	targetFaceAngle = playerFaceAngle + ( 0, 180, 0 );
	cos = cos( fov_angle );
	
	closestPoint = -1;
	closestDist = 1000000000;
	minimumSaveDistance = 1000 * 1000;
	for( i = 0 ; i < level.chopperSupportHoverLocations.size ; i++ )
	{
		p = level.chopperSupportHoverLocations[ i ];
		
		// dont use the point if it's not on the same side of the target as the player ( using imaginary perpindicular line to players facing direction )
		if( !within_fov( flat_origin( coordinate ), flat_angle( targetFaceAngle ), flat_origin( p ), cos ) )
			continue;
		
		// get the closest point on the segment to the point
		nearestPointOnLine = pointOnSegmentNearestToPoint( coordinate, playerCoordinate, p );
		d = distanceSquared( nearestPointOnLine, p );
		
		// make sure the chopper wont fly to a location too close to the target
		if ( d < minimumSaveDistance )
			continue;
		
		if( d < closestDist )
		{
			closestPoint = i;
			closestDist = d;
		}
		
		if ( getdvar( "debug_chopper_air_support") == "1" )
			print3d( p, d, ( 1, 1, 1 ), 1.0, 3.0, 10000 );
	}
	return closestPoint;
}

chopper_air_support_end( returnToBasePos )
{
	wait 30;
	
	level notify( "air_support_over" );
	flyHomeVec = vectorToAngles( returnToBasePos - level.chopper.origin );
	
	level.chopper clearLookatEnt();
	level.chopper setTargetYaw( flyHomeVec[ 1 ] );
	level.chopper setVehGoalPos( returnToBasePos );
	
	level.chopper waittill( "goal" );
	level.chopper delete();
	level.chopper = undefined;
	
	if( level.chopperSupportCallsRemaining > 0 )
		level.player giveStartAmmo( "cobra_air_support" );
}

chopper_ai_mode()
{
	self thread chopper_ai_mode_aim_turret();
	self thread chopper_ai_mode_shoot_turret();
	self thread chopper_ai_mode_flares();
}

chopper_ai_mode_aim_turret()
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	for(;;)
	{
		eTarget = maps\_helicopter_globals::getEnemyTarget( 6000, level.cosine[ "45" ], true, true, true, true );
		if( isdefined( eTarget ) )
		{
			eTargetOffset = ( 0, 0, 0 );
			if ( isdefined( eTarget.script_targetoffset_z ) )
				eTargetOffset += ( 0, 0, eTarget.script_targetoffset_z );
			else if ( isSentient( eTarget ) )
				eTargetOffset = ( 0, 0, 32 );
			self setTurretTargetEnt( eTarget, eTargetOffset );
		}
		wait randomfloatrange( 0.2, 1.0 );
	}
}

chopper_ai_mode_shoot_turret()
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	for(;;)
	{
		randomShots = randomintrange( 30, 60 );
		self setVehWeapon( "hind_turret" );
		for( i = 0 ; i < randomShots ; i++ )
		{
			self fireWeapon( "tag_flash" );
			wait 0.05;
		}
		wait randomfloatrange( 1.0, 1.75 );
	}
}

chopper_ai_mode_flares()
{
	self endon( "death" );
	level endon( "air_support_over" );
	
	for(;;)
	{
		iNumFlares = randomintrange( 2, 8 );
		thread maps\_helicopter_globals::flares_fire_burst( self, iNumFlares, 1, 5.0 );
		wait randomfloatrange( 4.0, 8.0 );
	}
}

chopper_ai_mode_missiles( eTarget )
{
	eTargetOriginal = eTarget;
	
	self endon( "death" );
	level endon( "air_support_over" );
	for(;;)
	{
		iShots = randomintrange( 1, 5 );
		eTarget = maps\_helicopter_globals::getEnemyTarget( 6000, level.cosine[ "25" ], true, true, true, true );
		if ( ( isdefined( eTarget ) ) && ( isdefined( eTarget.origin ) ) )
			self maps\_helicopter_globals::fire_missile( "ffar_mi28_village_assault", iShots, eTarget );
		else
			self maps\_helicopter_globals::fire_missile( "ffar_mi28_village_assault", iShots, eTargetOriginal );
		wait randomfloatrange( 3.5, 6.0 );
	}
}

drawChopperAttackArrow( coord, normal )
{	
	assert( isdefined( level.chopperAttackArrow ) );
	
	coord += vector_multiply( normal, level.chopperAttackArrow.offset );
	level.chopperAttackArrow.origin = coord;
	level.chopperAttackArrow rotateTo( vectortoangles( normal ), 0.2 );
}

getClosestInFOV( startOrigin, arrayEnts, fov_angle, minDistance )
{
	cos = cos( fov_angle );
	
	closestEnt = undefined;
	secondClosestEnt = undefined;
	closestDist = 1000000000;
	for( i = 0 ; i < arrayEnts.size ; i++ )
	{
		//if( !within_fov( flat_origin( startOrigin ), flat_angle( level.player getPlayerAngles() ), flat_origin( arrayEnts[ i ].origin ), cos ) )
		//	continue;
		
		d = distancesquared( startOrigin, arrayEnts[ i ].origin );
		
		if ( d < minDistance )
			continue;
		
		if( d < closestDist )
		{
			secondClosestEnt = closestEnt;
			closestEnt = arrayEnts[ i ];
			closestDist = d;
		}
	}
	array = [];
	array[ 0 ] = closestEnt;
	array[ 1 ] = secondClosestEnt;
	return array;
}

vehicle_c4_think()
{
	iEntityNumber = self getentitynumber();
	rearOrgOffset = (0, -33, 10);
	rearAngOffset = (0, 90, -90);
	frontOrgOffset = (129, 0, 35);
	frontAngOffset = (0, 90, 144);	
	
	self maps\_c4::c4_location( "rear_hatch_open_jnt_left", rearOrgOffset,  rearAngOffset );
	self maps\_c4::c4_location( "tag_origin", frontOrgOffset, frontAngOffset );
	self.rearC4location = spawn( "script_origin", self.origin );
	self.frontC4location = spawn( "script_origin", self.origin );
	self.rearC4location linkto( self, "rear_hatch_open_jnt_left", rearOrgOffset, rearAngOffset );
	self.frontC4location linkto( self, "tag_origin", frontOrgOffset, frontAngOffset );
	
	self waittill( "c4_detonation" );

	self.frontC4location delete();
	self.rearC4location delete();
	
	self thread vehicle_death( iEntityNumber );
}

vehicle_death( iEntityNumber )
{
	self notify( "clear_c4" );
	setplayerignoreradiusdamage( true );

	//-----------------------
	// FINAL EXPLOSION
	//-----------------------
	earthquake( 0.6, 2, self.origin, 2000 );
	self notify( "death" );
	thread play_sound_in_space( "exp_armor_vehicle", self gettagorigin( "tag_turret" ) );
	AI = get_ai_within_radius( 1024, self.origin, "axis" );
	if ( (isdefined(AI)) && (AI.size > 0) )
		array_thread(AI, ::AI_stun, .85);
	
	radiusdamage( self.origin, 256, 200, 100 );
	
	if ( distancesquared( self.origin, level.player.origin ) <= ( 256 * 256 ) )
		level.player dodamage( level.player.health / 3, ( 0, 0, 0 ) );
}

AI_stun( fAmount )
{
	self endon( "death" );
	if( ( isdefined( self ) ) && ( isalive( self ) ) && ( self getFlashBangedStrength() == 0 ) )
		self setFlashBanged( true, fAmount );
}

get_ai_within_radius( fRadius, org, sTeam )
{
	if( isdefined( sTeam ) )
		ai = getaiarray( sTeam );
	else
		ai = getaiarray();
	
	aDudes = [];
	for( i = 0 ; i < ai.size ; i++ )
	{
		if ( distance( org, self.origin ) <= fRadius )
			array_add( aDudes, ai[ i ] );
	}
	return aDudes;
}

roaming_bmp()
{
	bmp = maps\_vehicle::waittill_vehiclespawn( "roaming_bmp" );
	assert( isdefined( bmp ) );
	
	target_set( bmp, ( 0, 0, 32 ) );
	target_setJavelinOnly( bmp, true );
	
	bmp thread vehicle_patrol_think();
	bmp thread vehicle_turret_think();
	bmp thread vehicle_c4_think();
	bmp thread maps\_vehicle::damage_hints();
	bmp thread bmp_autosave_on_death();
}

vehicle_patrol_init()
{
	level.aVehicleNodes = [];
	array1 = getvehiclenodearray( "go_forward", "script_noteworthy" );
	array2 = getvehiclenodearray( "go_backward", "script_noteworthy" );
	level.aVehicleNodes = array_merge( array1, array2 );	
}

vehicle_patrol_think()
{
	self endon( "death" );

	ePathstart = self.attachedpath;
	self waittill( "reached_end_node" );
	
	for(;;)
	{
		prof_begin( "bmp_logic" );
		
		//-----------------------
		// REINITIALIZE ALL VARIABLES
		//-----------------------
		aLinked_nodes = [];
		eCurrentNode = undefined;
		go_backward_node = undefined;
		go_forward_node = undefined;
		eStartNode = undefined;
		closestEndNodes = undefined;
		
		//-----------------------
		// GET LAST NODE IN CHAIN (CURRENT POSITION
		//-----------------------
		assert( isdefined( ePathstart ) );
		eCurrentNode = ePathstart get_last_ent_in_chain( "vehiclenode" );

		//-----------------------
		// GET ALL NODES THAT ARE GROUPED WITH THIS PATH END
		//-----------------------
		aLinked_nodes = level.aVehicleNodes;
		aLinked_nodes = array_remove( aLinked_nodes, eCurrentNode);
		aVehicleNodes = level.aVehicleNodes;
		sScript_vehiclenodegroup = eCurrentNode.script_vehiclenodegroup;
		assert(isdefined(sScript_vehiclenodegroup));
		for(i=0;i<aVehicleNodes.size;i++)
		{
			assertEx((isdefined(aVehicleNodes[i].script_vehiclenodegroup)), "Vehiclenode at " + aVehicleNodes[i].origin + " needs to be assigned a script_vehiclenodegroup");
			if ( aVehicleNodes[i].script_vehiclenodegroup != sScript_vehiclenodegroup )
				aLinked_nodes = array_remove( aLinked_nodes, aVehicleNodes[i] );
		}
		//-----------------------
		// GET START NODES TO GO FORWARD/BACKWARD FROM HERE
		//-----------------------
		assertEx(aLinked_nodes.size > 0, "Ends of vehicle paths need to be grouped with at least one other chain of nodes for moving forward, backward or both");
		for(i=0;i<aLinked_nodes.size;i++)
		{
			if ( isdefined(aLinked_nodes[i].script_noteworthy) && (aLinked_nodes[i].script_noteworthy == "go_backward") )
			{
				go_backward_node = aLinked_nodes[i];
				go_backward_node.end = undefined;				
			}

			else if ( isdefined(aLinked_nodes[i].script_noteworthy) && (aLinked_nodes[i].script_noteworthy == "go_forward") )
			{
				go_forward_node = aLinked_nodes[i];
				go_forward_node.end = undefined;
			}
		}
		
		//-----------------------
		// DEFINE THE END NODE FOR EACH START NODE
		//-----------------------
		if ( isdefined( go_backward_node ) )
			go_backward_node.end = go_backward_node get_last_ent_in_chain( "vehiclenode" );
		
		if ( isdefined( go_forward_node ) )
			go_forward_node.end = go_forward_node get_last_ent_in_chain( "vehiclenode" );
				
		//-----------------------
		// STAY PUT, OR START A NEW PATH?
		//-----------------------
		closestEndNodes = getClosestInFOV( level.player.origin, level.aVehicleNodes, 55, level.BMP_Safety_Distance );
		assert( isdefined( closestEndNodes[ 0 ] ) );
		assert( isdefined( closestEndNodes[ 0 ].script_vehiclenodegroup ) );
		if ( isdefined( closestEndNodes[ 1 ] ) )
		{
			assert( isdefined( closestEndNodes[ 1 ].script_vehiclenodegroup ) );
			if ( closestEndNodes[ 1 ].script_vehiclenodegroup < closestEndNodes[ 0 ].script_vehiclenodegroup )
			{
				temp = closestEndNodes[ 0 ];
				closestEndNodes[ 0 ] = closestEndNodes[ 1 ];
				closestEndNodes[ 1 ] = temp;
			}
		}
		if ( closestEndNodes[ 0 ] == eCurrentNode )
			eStartNode = undefined;
		else if ( ( isdefined( go_forward_node ) ) && ( closestEndNodes[ 0 ].script_vehiclenodegroup >= go_forward_node.end.script_vehiclenodegroup ) )
			eStartNode = go_forward_node;
		else if ( ( isdefined( go_backward_node ) ) && ( closestEndNodes[ 0 ].script_vehiclenodegroup <= go_backward_node.end.script_vehiclenodegroup ) )
			eStartNode = go_backward_node;
		
		prof_end( "bmp_logic" );
		
		//-----------------------
		// GO ON THE NEW PATH TO GET CLOSER TO PLAYER OTHERWISE STAY PUT
		//-----------------------
		if ( isdefined(eStartNode) )
		{
			self attachpath( eStartNode );
			ePathstart = eStartNode;
			wait randomfloatrange( 0.2, 1.2 );
			self resumeSpeed( 100 );
			self waittill( "reached_end_node" );
		}
		else
		{
			wait randomfloatrange( 3, 6 );
		}
	}
}

vehicle_turret_think()
{
	self endon( "death" );
	
	eTarget = undefined;
	
	for(;;)
	{
		prof_begin( "bmp_logic" );
		
		eTarget = maps\_helicopter_globals::getEnemyTarget( 3000, undefined, true, true, false, true );
		
		prof_end( "bmp_logic" );
		
		if ( isdefined( eTarget ) )
		{
			self setTurretTargetEnt( eTarget, ( 0, 0, 32 ) );
			self waittill_notify_or_timeout( "turret_rotate_stopped", randomfloatrange( 2.0, 3.0 ) );
			
			iFireTime = weaponfiretime( "bmp_turret" );
			assert( isdefined( iFireTime ) );
			assert( iFireTime > 0 );
			
			iShots = randomintrange( 3, 8 );
			for( i = 0 ; i < iShots ; i++ )
			{
				self fireWeapon();
				wait iFireTime;
			}
		}
		wait randomfloat( 3.0, 6.0 );
	}
}

doAutoSave( sSaveName )
{
	assert( isdefined( sSaveName ) );
	thread autosave_by_name( sSaveName );
	thread timedAutosaves();
}

bmp_autosave_on_death()
{
	self waittill( "death" );
	if ( isdefined( self ) )
		target_remove( self );
	thread doAutoSave( "bmp_destroyed" );
}

timedAutosaves()
{
	level notify( "timedAutosaveThread" );
	level endon( "timedAutosaveThread" );
	
	if ( level.timedAutosaveTime == 0 )
		return;
	
	for(;;)
	{
		wait level.timedAutosaveTime;
		level.timedAutosaveNumber++;
		thread doAutoSave( "timed_autosave" + level.timedAutosaveNumber );
	}
}

genocide_audio_trigger()
{
	soundEnt = getent( self.target, "targetname" );
	assert( isdefined( soundEnt ) );
	
	self waittill( "trigger" );
	
	if ( isdefined( self.script_delay ) )
		wait self.script_delay;
	
	assert( isdefined( level.genocide_audio[ level.next_genocide_audio ] ) );
	
	soundEnt playSound( level.genocide_audio[ level.next_genocide_audio ] );
	
	level.next_genocide_audio++;
}

dead_civilian()
{
	wait randomfloatrange( 0.05, 0.2 );
	spawned = dronespawn( self );
	spawned setContents( 0 );
	spawned startRagDoll();
}

air_support_hint_print_activate()
{
	thread air_support_hint_print_call();
	
	while( !player_activated_air_support() )
	{
		thread display_hint( "call_air_support1" );
		wait 5;
		level.air_support_hint_delete = true;
		wait 20;
	}
}

air_support_hint_print_call()
{
	while( !player_activated_air_support() )
		wait 0.05;
	
	if ( !player_called_air_support() )
	{
		thread display_hint( "call_air_support2" );
		wait 5;
		level.air_support_hint_delete = true;
	}
}

trigger_upstairs_guys()
{
	assert( isdefined( self.target ) );
	
	volume = getent( self.target, "targetname" );
	assert( isdefined( volume ) );
	assert( isdefined( volume.target ) );
	
	node = getnode( volume.target, "targetname" );
	assert( isdefined( node ) );
	assert( isdefined( node.radius ) );
	
	self waittill( "trigger" );
	
	wait randomfloatrange( 5.0, 10.0 );
	
	enemies = getaiarray( "axis" );
	for( i = 0 ; i < enemies.size ; i++ )
	{
		if ( !( enemies[ i ] istouching( volume ) ) )
			continue;
		
		enemies[i].goalradius = node.radius;
		enemies[i] setgoalnode( node );
	}
}