#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\tweakables_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weapons;
#using scripts\shared\weapons\_weapon_utils;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_dev;
#using scripts\cp\gametypes\_spawning;
#using scripts\cp\gametypes\_spawnlogic;
#using scripts\cp\gametypes\_weapons;

#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;
#using scripts\cp\killstreaks\_supplydrop;




















	
#precache( "string", "KILLSTREAK_EARNED_DOGS" );
#precache( "string", "KILLSTREAK_DOGS_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_DOGS_INBOUND" );
#precache( "eventstring", "mpl_killstreak_dogs" ); 

#namespace dogs;	

function init()
{
	level.dog_targets = [];
	level.dog_targets[ level.dog_targets.size ] = "trigger_radius";
	level.dog_targets[ level.dog_targets.size ] = "trigger_multiple";
	level.dog_targets[ level.dog_targets.size ] = "trigger_use_touch";

	level.dog_spawns = [];
	//init_spawns();
	
	/#
		level thread devgui_dog_think();
	#/

	level.dogsOnFlashDogs = &flash_dogs;
}

function init_spawns()
{
	spawns = GetNodeArray( "spawn", "script_noteworthy" );

	if ( !IsDefined( spawns ) || !spawns.size )
	{
		/# println( "No dog spawn nodes found in map" ); #/
		return;
	}

	dog_spawner = GetEnt( "dog_spawner", "targetname" );

	if ( !IsDefined( dog_spawner ) )
	{
		/# println( "No dog_spawner entity found in map" ); #/
		return;
	}

	valid = spawnlogic::get_spawnpoint_array( "mp_tdm_spawn" );
	dog = dog_spawner SpawnFromSpawner();

	foreach( spawn in spawns )
	{
		valid = ArraySort( valid, spawn.origin, false );

		for( i = 0; i < 5; i++ )
		{
			if ( dog FindPath( spawn.origin, valid[i].origin, true, false ) )
			{
				level.dog_spawns[ level.dog_spawns.size ] = spawn;
				break;
			}
		}
	}

/#
	if ( !level.dog_spawns.size )
	{
		println( "No dog spawns connect to MP spawn nodes" ); 
	}
#/	
	
	dog delete();
}

function initKillstreak()
{
	// register the dog hardpoint
	if ( tweakables::getTweakableValue( "killstreak", "allowdogs" ) )
	{
		killstreaks::register("dogs", "dogs", "killstreak_dogs","dogs_used",&useKillstreakDogs, true);
		killstreaks::register_strings("dogs", &"KILLSTREAK_EARNED_DOGS", &"KILLSTREAK_DOGS_NOT_AVAILABLE", &"KILLSTREAK_DOGS_INBOUND" );
		killstreaks::register_dialog("dogs", "mpl_killstreak_dogs", "kls_dogs_used", "","kls_dogs_enemy", "", "kls_dogs_ready");
		killstreaks::register_dev_dvar("dogs", "scr_givedogs");
		killstreaks::set_team_kill_penalty_scale( "dogs", 0.0 );
	
		killstreaks::register_alt_weapon("dogs", "dog_bite" );
	}
}

function useKillstreakDogs(hardpointType)
{
	if ( !dog_killstreak_init() )
		return false;

	if ( !self killstreakrules::isKillstreakAllowed( hardpointType, self.team ) )
		return false;

	killstreak_id = self killstreakrules::killstreakStart( "dogs", self.team );

	self thread ownerHadActiveDogs();
	
	if ( killstreak_id == -1 )
		return false;
		
	if ( level.teambased )
	{
		foreach( team in level.teams )
		{
			if ( team == self.team )
				continue;
				
			//thread battlechatter::on_killstreak_used( "dogs", team );
		}
	}
	
	self killstreaks::play_killstreak_start_dialog( "dogs", self.team, true );
	//self AddPlayerStat( "DOGS_USED", 1 );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( GetWeapon( "dogs" ), "used", 1 );

	ownerDeathCount = self.deathCount;

	level thread dog_manager_spawn_dogs( self, ownerDeathCount, killstreak_id );
	level notify( "called_in_the_dogs" );
	return true;
}

function ownerHadActiveDogs()
{
	self endon( "disconnect" );
	self.dogsActive = true;
	self.dogsActiveKillstreak = 0;
	self util::waittill_any( "death", "game_over", "dogs_complete" );
	
	self.dogsActiveKillstreak = 0;
	self.dogsActive = undefined;
}

function dog_killstreak_init()
{
	dog_spawner = GetEnt( "dog_spawner", "targetname" );

	if( !isdefined( dog_spawner ) )
	{
	/#	println( "No dog spawners found in map" );	#/
		return false;
	}

	spawns = GetNodeArray( "spawn", "script_noteworthy" );	

	if ( level.dog_spawns.size <= 0 )
	{
	/#	println( "No dog spawn nodes found in map" );	#/
		return false;
	}

	exits = GetNodeArray( "exit", "script_noteworthy" );	

	if ( exits.size <= 0 )
	{
	/#	println( "No dog exit nodes found in map" );	#/
		return false;
	}

	return true;
}

function dog_set_model()
{
	self SetModel( "german_shepherd_vest" );
	self SetEnemyModel( "german_shepherd_vest_black" );
}

function init_dog()
{
	assert( IsAi( self ) );

	self.targetname = "attack_dog";
	
	self.animTree = "dog.atr";
	self.type = "dog";
	self.accuracy = 0.2;
	self.health = 100;
	self.maxhealth = 100;  // this currently does not hook to code maxhealth
	self.secondaryweapon = "";
	self.sidearm = "";
	self.grenadeAmmo = 0;
	self.goalradius = 128;
	self.noDodgeMove = true;
	self.ignoreSuppression = true;
	self.suppressionThreshold = 1;
	self.disableArrivals = false;
	self.pathEnemyFightDist = 512;
	self.soundMod = "dog";

	self thread dog_health_regen();
	self thread selfDefenseChallenge();
}

function get_spawn_node( owner, team )
{
	assert( level.dog_spawns.size > 0 );
	return array::random( level.dog_spawns );
}

function get_score_for_spawn( origin, team )
{
	players = GetPlayers();
	score = 0;

	foreach( player in players )
	{
		if ( !isdefined( player ) )
		{
			continue;
		}

		if ( !IsAlive( player ) )
		{
			continue;
		}

		if ( player.sessionstate != "playing" )
		{
			continue;
		}

		if ( DistanceSquared( player.origin, origin ) > 2048 * 2048 )
		{
			continue;
		}

		if ( player.team == team )
		{
			score++;
		}
		else
		{
			score--;
		}
	}

	return score;
}

function dog_set_owner( owner, team, requiredDeathCount )
{
	self SetEntityOwner( owner );
	self.team = team;

	self.requiredDeathCount = requiredDeathCount;
}

function dog_create_spawn_influencer()
{
	self spawning::create_entity_enemy_influencer( "dog" );
}

function dog_manager_spawn_dog( owner, team, spawn_node, requiredDeathCount )
{
	dog_spawner = GetEnt( "dog_spawner", "targetname" );
	
	dog = dog_spawner SpawnFromSpawner();
	dog ForceTeleport( spawn_node.origin, spawn_node.angles );
	
	dog init_dog();
	dog dog_set_owner( owner, team, requiredDeathCount );
	dog dog_set_model();
	dog dog_create_spawn_influencer();
	
	dog thread dog_owner_kills();
	dog thread dog_notify_level_on_death();
	dog thread dog_patrol();
	dog thread monitor_dog_special_grenades();

	return dog;
}

function monitor_dog_special_grenades() // self == dog
{
	// watch and see if the dog gets damage from a flash or concussion
	//	smoke and tabun handle themselves
	self endon("death");

	while(1)
	{
		self waittill( "damage", damage, attacker, direction_vec, point, type, modelName, tagName, partName, weapon, iDFlags );

		if( weapon_utils::isFlashOrStunWeapon( weapon ) )
		{
			damage_area = spawn( "trigger_radius", self.origin, 0, 128, 128 );
			attacker thread dogs::flash_dogs( damage_area );
			{wait(.05);};
			damage_area delete();
		}
	}
}

function dog_manager_spawn_dogs( owner, deathCount, killstreak_id )
{
	requiredDeathCount = deathCount;
	team = owner.team;
	
	level.dog_abort = false;
	owner thread dog_manager_abort();
	level thread dog_manager_game_ended();

	for ( count = 0; count < 10; )
	{
		if ( level.dog_abort )
		{
			break;
		}

		dogs = dog_manager_get_dogs();

		while ( dogs.size < 5 && count < 10 && !level.dog_abort )
		{
			node = get_spawn_node( owner, team );
			level dog_manager_spawn_dog( owner, team, node, requiredDeathCount );
			count++;

			wait ( randomfloatrange( 2, 5 ) );
			dogs = dog_manager_get_dogs();
		}

		level waittill( "dog_died" );
	}

	for ( ;; )
	{
		dogs = dog_manager_get_dogs();

		if ( dogs.size <= 0 )
		{
			killstreakrules::killstreakStop( "dogs", team, killstreak_id );
			if ( isdefined( owner ) )
			{
				owner notify( "dogs_complete" );
			}
			return;
		}

		level waittill( "dog_died" );
	}
}

function dog_abort()
{
	level.dog_abort = true;

	dogs = dog_manager_get_dogs();

	foreach( dog in dogs )
	{
		dog notify( "abort" );
	}
	
	level notify( "dog_abort" );
}

function dog_manager_abort()
{
	level endon( "dog_abort" );
	self util::wait_endon( 45, "disconnect", "joined_team", "joined_spectators" );
	dog_abort();
}

function dog_manager_game_ended()
{
	level endon( "dog_abort" );

	level waittill( "game_ended" );
	dog_abort();
}

function dog_notify_level_on_death()
{
	self waittill( "death" );
	level notify( "dog_died" );
}

function dog_leave()
{
	// have them run to an exit node
	self clearentitytarget();
	self.ignoreall = true;
	self.goalradius = 30;
	self SetGoal( self dog_get_exit_node() );
	
	self util::wait_endon( 20, "goal", "bad_path" );
	self delete();
}

function dog_patrol()
{
	self endon( "death" );
/#
	self endon( "debug_patrol" );
#/

	for ( ;; )
	{
		if ( level.dog_abort )
		{
			self dog_leave();
			return;
		}

		if ( isdefined( self.enemy ) )
		{
			wait( RandomIntRange( 3, 5 ) );
			continue;
		}

		nodes = [];

		objectives = dog_patrol_near_objective();

		for ( i = 0; i < objectives.size; i++ )
		{
			objective = array::random( objectives );

			nodes = GetNodesInRadius( objective.origin, 256, 64, 512, "Path", 16 );

			if ( nodes.size )
			{
				break;
			}
		}
		
		if ( !nodes.size )
		{
			player = self dog_patrol_near_enemy();

			if ( isdefined( player ) )
			{
				nodes = GetNodesInRadius( player.origin, 1024, 0, 128, "Path", 8 );
			}
		}

		if ( !nodes.size && isdefined( self.script_owner ) )
		{
			if ( IsAlive( self.script_owner ) && self.script_owner.sessionstate == "playing" )
			{
				nodes = GetNodesInRadius( self.script_owner.origin, 512, 256, 512, "Path", 16 );
			}
		}

		if ( !nodes.size )
		{
			nodes = GetNodesInRadius( self.origin, 1024, 512, 512, "Path" );
		}

		if ( nodes.size )
		{
			nodes = array::randomize( nodes );

			foreach( node in nodes )
			{
				if ( isdefined( node.script_noteworthy ) )
				{
					continue;
				}

				if ( isdefined( node.dog_claimed ) && IsAlive( node.dog_claimed ) )
				{
					continue;
				}

				self SetGoal( node );
				node.dog_claimed = self;

				nodes = [];
				event = self util::waittill_any_return( "goal", "bad_path", "enemy", "abort" );

				if ( event == "goal" )
				{
					util::wait_endon( RandomIntRange( 3, 5 ), "damage", "enemy", "abort" );
				}

				node.dog_claimed = undefined;
				break;
			}
		}

		wait( 0.5 );
	}
}

function dog_patrol_near_objective()
{
	if ( !isdefined( level.dog_objectives ) )
	{
		level.dog_objectives = [];
		level.dog_objective_next_update = 0;
	}

	if ( level.gameType == "tdm" || level.gameType == "dm" )
	{
		return level.dog_objectives;
	}
	
	if ( GetTime() >= level.dog_objective_next_update )
	{
		level.dog_objectives = [];

		foreach( target in level.dog_targets )
		{
			ents = GetEntArray( target, "classname" );

			foreach( ent in ents )
			{
				if ( level.gameType == "koth" )
				{
					if ( isdefined( ent.targetname ) && ent.targetname == "radiotrigger" )
					{
						level.dog_objectives[ level.dog_objectives.size ] = ent;
					}

					continue;
				}

				if ( level.gameType == "sd" )
				{
					if ( isdefined( ent.targetname ) && ent.targetname == "bombzone" )
					{
						level.dog_objectives[ level.dog_objectives.size ] = ent;
					}

					continue;
				}

				if ( !isdefined( ent.script_gameobjectname ) )
				{
					continue;
				}

				if ( !IsSubStr( ent.script_gameobjectname, level.gameType ) )
				{
					continue;
				}

				level.dog_objectives[ level.dog_objectives.size ] = ent;
			}
		}

		level.dog_objective_next_update = GetTime() + RandomIntRange( 5000, 10000 );
	}

	return level.dog_objectives;
}

function dog_patrol_near_enemy()
{
	players = GetPlayers();
	
	closest = undefined;
	distSq = 99999999;
	
	foreach( player in players )
	{
		if ( !isdefined( player ) )
		{
			continue;
		}

		if ( !IsAlive( player ) )
		{
			continue;
		}

		if ( player.sessionstate != "playing" )
		{
			continue;
		}

		if ( isdefined( self.script_owner ) && player == self.script_owner )
		{
			continue;
		}

		if ( level.teambased )
		{
			if ( player.team == self.team )
			{
				continue;
			}
		}

		if ( GetTime() - player.lastFireTime > 3000 )
		{
			continue;
		}

		if ( !isdefined( closest ) )
		{
			closest = player;
			distSq = DistanceSquared( self.origin, player.origin );
			continue;
		}

		d = DistanceSquared( self.origin, player.origin );

		if ( d < distSq )
		{
			closest = player;
			distSq = d;
		}
	}

	return closest;
}

function dog_manager_get_dogs()
{
	dogs = GetEntArray( "attack_dog", "targetname" );
	return dogs;
}

function dog_owner_kills()
{
	if ( !isdefined( self.script_owner ) )
		return;
		
	self endon("clear_owner");
	self endon("death");
	self.script_owner endon("disconnect");
	
	while(1)
	{
		self waittill("killed", player);
		self.script_owner notify( "dog_handler" );
	}	
}

function dog_health_regen()
{
	self endon( "death" );

	interval = 0.5;
	regen_interval = Int( ( self.health / 5 ) * interval );
	regen_start = 2;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction, point, type, tagName, modelName, partname, weapon, iDFlags );
		self trackAttackerDamage( attacker );
		
		self thread dog_health_regen_think( regen_start, interval, regen_interval );
	}
}

function trackAttackerDamage( attacker )
{
	if ( !isdefined( attacker ) || !isPlayer( attacker ) || !isdefined( self.script_owner ) )
	{
		return;
	}
	
	if ( ( level.teambased && attacker.team == self.script_owner.team ) || attacker == self ) 
	{
		return;
	}

	if ( !isdefined( self.attackerData ) || !isdefined( self.attackers ) ) 
	{
		self.attackerData = [];
		self.attackers = [];
	}
	if ( !isdefined( self.attackerData[attacker.clientid] ) )
	{
		self.attackerClientID[attacker.clientid] = spawnstruct();
		self.attackers[ self.attackers.size ] = attacker;
	}
}

function resetAttackerDamage()
{
	self.attackerData = [];
	self.attackers = [];
}

function dog_health_regen_think( delay, interval, regen_interval )
{
	self endon( "death" );
	self endon( "damage" );

	wait( delay );

	for ( step = 0; step <= 5; step += interval )
	{
		if ( self.health >= 100 )
		{
			break;
		}

		self.health += regen_interval;
		wait( interval );
	}

	self resetAttackerDamage();
	self.health = 100;
}

function selfDefenseChallenge()
{
	self waittill ("death", attacker);

	if ( isdefined( attacker ) && isPlayer( attacker ) )
	{
		if (isdefined ( self.script_owner ) && self.script_owner == attacker)
			return;
		if ( level.teambased && isdefined ( self.script_owner ) && self.script_owner.team == attacker.team )
			return;

		if ( isdefined( self.attackers ) )
		{
			foreach ( player in self.attackers )
			{
				if ( player != attacker )
				{
					scoreevents::processScoreEvent( "killed_dog_assist", player );
				}
			}
		}
		attacker notify ("selfdefense_dog");	
	}
		
}

function dog_get_exit_node()
{
	exits = GetNodeArray( "exit", "script_noteworthy" );
	return array::get_closest( self.origin, exits );
}

function flash_dogs( area )
{
	self endon("disconnect");

	dogs = dog_manager_get_dogs();

	foreach( dog in dogs )
	{
		if ( !isalive(dog) )
			continue;

		if ( dog istouching(area) )
		{
			do_flash = true;
			if ( isPlayer( self ) )
			{
				if ( level.teamBased && (dog.team == self.team) )
				{
					do_flash = false;
				}
				else if ( !level.teambased && isdefined(dog.script_owner) && self == dog.script_owner )
				{
					do_flash = false;
				}
			}

			if ( isdefined( dog.lastFlashed ) && dog.lastFlashed + 1500 > gettime()  )
			{	
				do_flash = false;
			}

			if ( do_flash )
			{
				dog setFlashBanged( true, 500 );
				dog.lastFlashed = gettime();
			}
		}	
	}
}

/#

function devgui_dog_think()
{
	SetDvar( "devgui_dog", "" );

	debug_patrol = false;

	for( ;; )
	{
		cmd = GetDvarString( "devgui_dog" );

		switch( cmd )
		{
		case "spawn_friendly":	
			player = util::getHostPlayer();
			devgui_dog_spawn( player.team );
			break;

		case "spawn_enemy":	
			player = util::getHostPlayer();
			foreach( team in level.teams )
			{
				if ( team == player.team )
					continue;
				
				devgui_dog_spawn( team );
			}
			break;

		case "delete_dogs":
			level dog_abort();
			break;

		case "dog_camera":
			devgui_dog_camera();
			break;

		case "spawn_crate":
			devgui_crate_spawn();
			break;

		case "delete_crates":
			devgui_crate_delete();
			break;

		case "show_spawns":
			devgui_spawn_show();
			break;
		
		case "show_exits":
			devgui_exit_show();
			break;

		case "debug_route":
			devgui_debug_route();
			break;
		}

		if ( cmd != "" )
		{
			SetDvar( "devgui_dog", "" );
		}

		wait( 0.5 );
	}
}

function devgui_dog_spawn( team )
{
	player = util::getHostPlayer();

	dog_spawner = GetEnt( "dog_spawner", "targetname" );
	level.dog_abort = false;
	
	if( !isdefined( dog_spawner ) )
	{
		iprintln( "No dog spawners found in map" );
		return;
	}

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	nodes = GetNodesInRadius( trace["position"], 256, 0, 128, "Path", 8 ); 

	if ( !nodes.size )
	{
		iprintln( "No nodes found near crosshair position" );
		return;
	}

	iprintln( "Spawning dog at your crosshair position" );
	node = array::get_closest( trace["position"], nodes );
	
	dog = dog_manager_spawn_dog( player, player.team, node, 5 );

	if ( team != player.team )
	{
		dog.team = team;
		dog ClearEntityOwner();
		dog notify ( "clear_owner" );
	}
}

function devgui_dog_camera()
{
	player = util::getHostPlayer();

	if ( !isdefined( level.devgui_dog_camera ) )
	{
		level.devgui_dog_camera = 0;
	}

	dog = undefined;
	dogs = dog_manager_get_dogs();

	if ( dogs.size <= 0 )
	{
		level.devgui_dog_camera = undefined;
		player CameraActivate( false );	
		return;
	}
	
	for ( i = 0; i < dogs.size; i++ )
	{
		dog = dogs[i];

		if ( !isdefined( dog ) || !IsAlive( dog ) )
		{
			dog = undefined;
			continue;
		}

		if ( !isdefined( dog.cam ) )
		{
			forward = AnglesToForward( dog.angles );
			dog.cam = spawn( "script_model", dog.origin + ( 0, 0, 50 ) + forward * -100 );
			dog.cam SetModel( "tag_origin" );
			dog.cam LinkTo( dog );
		}

		if ( dog GetEntityNumber() <= level.devgui_dog_camera )
		{
			dog = undefined;
			continue;
		}

		break;
	}
	
	if ( isdefined( dog ) )
	{
		level.devgui_dog_camera = dog GetEntityNumber();
		
		player CameraSetPosition( dog.cam );
		player CameraSetLookAt( dog );
		player CameraActivate( true );	
	}
	else
	{
		level.devgui_dog_camera = undefined;
		player CameraActivate( false );	
	}
}

function devgui_crate_spawn()
{
	player = util::getHostPlayer();

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	killCamEnt = spawn( "script_model", player.origin );
	level thread supplydrop::dropCrate( trace[ "position" ] + ( 0, 0, 25 ), direction, "supplydrop", player, player.team, killcamEnt );
}

function devgui_crate_delete()
{
	if ( !isdefined( level.devgui_crates ) )
	{
		return;
	}

	for ( i = 0; i < level.devgui_crates.size; i++ )
	{
		level.devgui_crates[i] delete();
	}

	level.devgui_crates = [];
}

function devgui_spawn_show()
{
	if ( !isdefined( level.dog_spawn_show ) )
	{
		level.dog_spawn_show = true;
	}
	else
	{
		level.dog_spawn_show = !level.dog_spawn_show;
	}

	if ( !level.dog_spawn_show )
	{
		level notify( "hide_dog_spawns" );
		return;
	}

	spawns = level.dog_spawns;
	color = ( 0, 1, 0 );

	for ( i = 0; i < spawns.size; i++ )
	{
		dev::showOneSpawnPoint( spawns[i], color, "hide_dog_spawns", 32, "dog_spawn" );
	}
}

function devgui_exit_show()
{
	if ( !isdefined( level.dog_exit_show ) )
	{
		level.dog_exit_show = true;
	}
	else
	{
		level.dog_exit_show = !level.dog_exit_show;
	}

	if ( !level.dog_exit_show )
	{
		level notify( "hide_dog_exits" );
		return;
	}

	exits = GetNodeArray( "exit", "script_noteworthy" );
	color = ( 1, 0, 0 );

	for ( i = 0; i < exits.size; i++ )
	{
		dev::showOneSpawnPoint( exits[i], color, "hide_dog_exits", 32, "dog_exit" );
	}
}

function dog_debug_patrol( node1, node2 )
{
	self endon( "death" );
	self endon( "debug_patrol" );

	for( ;; )
	{
		self SetGoal( node1 );
		self util::waittill_any( "goal", "bad_path" );
		wait( 1 );

		self SetGoal( node2 );
		self util::waittill_any( "goal", "bad_path" );
		wait( 1 );
	}
}

function devgui_debug_route()
{
	iprintln( "Choose nodes with 'A' or press 'B' to cancel" );
	nodes = dev::dev_get_node_pair();
	
	if ( !isdefined( nodes ) )
	{
		iprintln( "Route Debug Cancelled" );
		return;
	}

	iprintln( "Sending dog to chosen nodes" );
	dogs = dog_manager_get_dogs();

	if ( isdefined( dogs[0] ) )
	{
		dogs[0] notify( "debug_patrol" );
		dogs[0] thread dog_debug_patrol( nodes[0], nodes[1] );
	}
}

#/
