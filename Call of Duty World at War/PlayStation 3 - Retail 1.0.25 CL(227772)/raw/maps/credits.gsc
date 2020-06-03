#include common_scripts\utility; 
#include maps\_utility; 
#include maps\_music;


// - Fountain scene from Sniper
// - Flamethrower
// 		- Flamethrower on bunker in Pel1
// -

main()
{
	if( GetDvar( "credits_frommenu" ) == "1" )
	{
		level.credits_frommenu = true;
	}
	else
	{
		SetDvar( "credits_frommenu", "0" ); 
	}

	if( GetDvar( "test_scenes" ) == "" )
	{
		SetDvar( "test_scenes", "0" );
	}
	
	level.credits_active = true;
	init_flags();

	maps\credits_fx::main();

	maps\_load::main();
	
	maps\credits_list::init_credits();
	precache_models();
	
	flag_wait( "all_players_connected" );
	
	SetDvar( "credits_active", "1" );

	script_model_link_ent = Spawn( "script_model", get_players()[0].origin );
	script_model_link_ent SetModel("tag_origin");
	
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player playerLinkToAbsolute( script_model_link_ent, "tag_origin" );
		player SetCanDamage( false );
		player FreezeControls( true );
		player SetClientDvar( "hud_showStance", "0" ); 
		player SetClientDvar( "compass", "0" ); 
		player SetClientDvar( "ammoCounterHide", "1" );
		player SetClientDvar( "miniscoreboardhide", "1" );
	}

	SetDvar( "credits_load", "0" );

	share_screen( get_host(), true, true ); 

	// Play the credits:
	level thread maps\credits_list::play_credits();
	setmusicstate("CREDITS");

	flag_wait( "credits_ended" );
	level thread nextmission_wait();
}

nextmission_wait()
{
	flag_wait( "credits_ended" );
	
	// fade to black
	fadetoblack = NewHudElem(); 
	fadetoblack.x = 0; 
	fadetoblack.y = 0; 
	fadetoblack.alpha = 0; 
		
	fadetoblack.horzAlign = "fullscreen"; 
	fadetoblack.vertAlign = "fullscreen"; 
	fadetoblack.foreground = false;  // arcademode compatible
	fadetoblack.sort = 50;  // arcademode compatible
	fadetoblack SetShader( "black", 640, 480 ); 

	// Fade into black
	fadetoblack FadeOverTime( 0.05 );
	fadetoblack.alpha = 1;

	wait(0.05);
	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", "1" ); 
		player SetClientDvar( "compass", "1" ); 
		player SetClientDvar( "ammoCounterHide", "0" );
		player SetClientDvar( "miniscoreboardhide", "0" );
	}

	SetDvar( "credits_active", "0" );

//	if ( IsDefined( level.credits_frommenu ) && level.credits_frommenu )
//	{
//		changelevel( "" );
//	}
//	else
//	{
		maps\_endmission::credits_end();
//	}
}

init_flags()
{
	flag_init( "play_scene" );
}

init_dvars()
{
	SetDvar( "credits_active", "1" );

	players = get_players(); 
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];
		player SetClientDvar( "hud_showStance", 0 );
		player SetClientDvar( "compass", "0" );
		player SetClientDvar( "ammoCounterHide", "1" );
		player SetClientDvar( "miniscoreboardhide", "1" );
	}
}

precache_models()
{
	PrecacheModel( "viewmodel_usa_marine_player" );
	PrecacheModel( "tag_origin" );
}

init_spawn_functions()
{
	create_spawner_function( "tree_sniper_climber", "script_noteworthy", ::tree_sniper_spawner );
}

play_scene_controller()
{
	if( GetDvarInt( "test_scenes" ) > 0 )
	{
		return;
	}

	time = 0;
	for( i = 0; i < level.credit_list.size; i++ )
	{
		if( IsDefined( level.credit_list[i].delay ) )
		{
			delay = level.credit_list[i].delay;
		}
		else if( level.credit_list[i].type == "spacesmall" )
		{
			delay = level.spacesmall_delay;
		}
		else
		{
			delay = level.default_line_delay;
		}
		time += delay;
	}

	scenes = getstructarray( "scene", "targetname" );
	div_time = time / ( scenes.size + 1 );

	for( i = 0; i < scenes.size; i++ )
	{
		wait( div_time );
		flag_set( "play_scene" );
	}
}

play_scenes()
{
//	wait( 0.05 ); // This is needed so we're out of the _callbackglobal stuff and no longer a spectator.
	level thread play_scene_controller();

	player = get_host();
	player DisableWeapons();
	player EnableInvulnerability();
	player.ignoreme = true;

	ent = Spawn( "script_model", player.origin );
	ent SetModel( "tag_origin" );
	ent Hide();

	player PlayerLinkTo( ent, "tag_origin", 1, 10, 10, 10, 10, false );
	player.linked_object = ent;

	fadein_fog(); // Make sure the fog is set before playing

	scenes = getstructarray( "scene", "targetname" );
	scenes = array_randomize( scenes );

	for( i = 0; i < scenes.size; i++ )
	{
		if( GetDvarInt( "test_scenes" ) == 0 )
		{
			flag_wait( "play_scene" );
			flag_clear( "play_scene" );
		}

		play_the_scene( player, scenes[i] );

		if( GetDvarInt( "test_scenes" ) > 0 )
		{
			wait( 5 );
		}
	}

}

play_the_scene( player, struct )
{
	player.linked_object.origin = struct.origin - ( 0, 0, 66 );
	player.linked_object.angles = struct.angles;
	wait( 0.1 );

	fadeout_fog( struct );

	level thread player_movement( player, struct );

	switch( struct.script_noteworthy )
	{
		case "spawn_guys":
			scene_spawn_guys( struct );
			break;

		default:
			assertMsg( "unsupported scene" );
	}

	fadein_fog();
}

player_movement( player, struct )
{
	structs = get_targeted_structs( struct );

	if( structs.size > 0 )
	{
		get_duration_of_structs( struct, structs );

		for( i = 0; i < structs.size; i++ )
		{
			time = structs[i].dist / structs[i].speed;
			player.linked_object MoveTo( structs[i].origin - ( 0, 0, 66 ), time );
			player.linked_object RotateTo( structs[i].angles, time );
			wait( time - 0.1 );
		}
	}
}

get_targeted_structs( struct )
{
	structs = [];

	while( IsDefined( struct.target ) )
	{
		next_struct = getstruct( struct.target, "targetname" );

		if( !IsDefined( next_struct ) )
		{
			break;
		}

		structs[structs.size] = next_struct;
		struct = next_struct;
	}

	return structs;
}

get_duration_of_structs( struct, structs )
{
	curr_pos = struct.origin;
	for( i = 0; i < structs.size; i++ )
	{
		structs[i].dist = Distance( curr_pos, structs[i].origin );
		structs[i].speed = structs[i].dist / ( struct.script_wait / ( structs.size ) );

		curr_pos = structs[i].origin;
	}
}

scene_spawn_guys( struct )
{
	struct script_delay();

	spawners = GetEntArray( struct.target, "targetname" );
	guys = spawn_guys( spawners );

	wait( 0.1 );
	struct script_wait();

	for( i = 0; i < guys.size; i++ )
	{
		if( IsDefined( guys[i] ) && IsAlive( guys[i] ) && !IsDefined( guys[i].script_death ) )
		{
			guys[i] thread bloody_death( 1 );
		}
	}

	wait( 3 );
}

fadeout_fog( struct )
{
	if( IsDefined( struct.script_start_dist ) )
	{
		start_dist = struct.script_start_dist;
	}
	else
	{
		start_dist = 50;
	}

	if( IsDefined( struct.radius ) )
	{
		halfway_dist = struct.radius * 0.5;
	}
	else if( IsDefined( struct.script_halfway_dist ) )
	{
		halfway_dist = struct.script_halfway_dist;
	}
	else
	{
		halfway_dist = 256;
	}

	if( IsDefined( struct.script_halfway_height ) )
	{
		halfway_height = struct.script_halfway_height;
	}
	else
	{
		halfway_height = 512;
	}

	if( IsDefined( struct.script_base_height ) )
	{
		base_height = struct.script_base_height;
	}
	else
	{
		base_height = struct.origin[2] - 100;
	}


	if( IsDefined( struct.script_color ) )
	{
		color = struct.script_color;
	}
	else
	{
		color = ( 0, 0, 0 );
	}

	if( IsDefined( struct.script_transition_time ) )
	{
		trans_time = struct.script_transition_time;
	}
	else
	{
		trans_time = 3;
	}

	SetVolFog( start_dist, halfway_dist, halfway_height, base_height, color[0], color[1], color[2], trans_time );
	level.bg_hud FadeOverTime( trans_time * 0.3 );
	level.bg_hud.alpha = 0;
}

fadein_fog()
{
	SetVolFog( 0, 4, 7000, -2000, 0, 0, 0, 5 );
	level.bg_hud FadeOverTime( 5 );
	level.bg_hud.alpha = 1;
}

// Spawns in AI out of every spawner given
spawn_guys( spawners, target_name )
{
	guys = [];

	for( i = 0; i < spawners.size; i++ )
	{
		guy = spawn_guy( spawners[i], target_name );
		if( IsDefined( guy ) )
		{
			guys[guys.size] = guy;
		}
	}
	return guys;
}

// Spawns in an AI (and returns the spawned AI)
spawn_guy( spawner, target_name )
{
	spawner.count = 1;

	spawner script_delay();

	if( IsDefined( spawner.script_forcespawn ) && spawner.script_forcespawn )
	{
		guy = spawner StalingradSpawn(); 
	}
	else
	{
		guy = spawner DoSpawn(); 
	}

	if( !spawn_failed( guy ) )
	{
		if( IsDefined( target_name ) )
		{
			guy.targetname = target_name;
		}

		if( IsDefined( guy.script_noteworthy ) )
		{
			switch( guy.script_noteworthy )
			{
				case "nodamage":
					guy SetCanDamage( false );
					break;
			}
		}

		if( IsDefined( guy.script_death ) )
		{
			guy thread bloody_death( guy.script_death );
		}

		return guy; 
	}

	return undefined; 
}

// Kill the given AI with style (fx)
bloody_death( delay )
{
	self endon( "death" ); 

	if( !IsAi( self ) || !IsAlive( self ) )
	{
		return; 
	}

	if( IsDefined( self.bloody_death ) && self.bloody_death )
	{
		return; 
	}

	self.bloody_death = true; 

	if( IsDefined( delay ) )
	{
		wait( delay ); 
	}

	tags = []; 
	tags[0] = "j_hip_le"; 
	tags[1] = "j_hip_ri"; 
	tags[2] = "j_head"; 
	tags[3] = "j_spine4"; 
	tags[4] = "j_elbow_le"; 
	tags[5] = "j_elbow_ri"; 
	tags[6] = "j_clavicle_le"; 
	tags[7] = "j_clavicle_ri"; 
	
	for( i = 0; i < 2; i++ )
	{
		random = RandomIntRange( 0, tags.size ); 
		//vec = self GetTagOrigin( tags[random] ); 
		self thread bloody_death_fx( tags[random], undefined ); 
		wait( RandomFloat( 0.1 ) ); 
	}

	self SetCanDamage( true );

	if( self.health == 1000000 )
	{
		self DoDamage( 200, self.origin );
	}
	else
	{
		self DoDamage( self.health + 10, self.origin ); 
	}
}	

// self = the AI on which we're playing fx
bloody_death_fx( tag, fxName ) 
{ 
	if( !IsDefined( fxName ) )
	{
		fxName = level._effect["flesh_hit"]; 
	}

	PlayFxOnTag( fxName, self, tag ); 
}

// Adds a spawner function to the given key value paired entity
create_spawner_function( value, key, func )
{
	spawners = GetEntArray( value, key ); 

	for( i = 0; i < spawners.size; i++ )
	{
		spawners[i] add_spawn_function( func );
	}
}


// SCENE SPECIFIC SECTION //
tree_sniper_spawner()
{
	self endon( "death" ); 

	if( self.script_noteworthy == "tree_sniper_climber" )
	{
		self.script_noteworthy = "climb";
	}
	
	anim_node = GetNode( self.target, "targetname" ); 
	anim_point = getent( anim_node.target, "targetname" ); 
	
	self.animname = "tree_guy"; 
	
	if( self.script_noteworthy == "climb" )
	{
		self maps\_tree_snipers::do_climb( anim_point ); 
	}

	if( IsDefined( self ) )
	{
		self AllowedStances( "crouch" ); 
	}

	self thread maps\_tree_snipers::tree_death( self, anim_point ); 
}
