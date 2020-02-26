#include common_scripts\utility;
#include maps\_utility;

enemy_register()
{
	thread enemy_override_bc();
}

enemy_override_bc()
{
	while ( !isdefined( self.chatinitialized ) && !self.chatinitialized )
		wait 0.05;
	
	self.countryid = "RU";
}

enemy_seek_player( goalradius, delay )
{
	self endon( "death" );
	
	// accuracy tweak
	self.baseaccuracy = self.baseaccuracy * level.seeker_accuracy_nerf;
	
	if ( isdefined( delay ) )
		wait delay;
	
	if ( isdefined( self.target ) )
		self waittill( "goal" );
	
	if ( level.players.size == 2 )
	{
		if ( randomint( 100 ) > 50 )
			self setgoalentity( level.players[ 0 ] );
		else
			self setgoalentity( level.players[ 1 ] );
	}
	else
		self setgoalentity( level.player );
	
	self.goalradius = goalradius;
}

enemy_move_to_struct( trig, seek_goalradius, stay, duration )
{
	self endon( "death" );
	self setgoalpos( self.origin );
	self.goalradius = 16;
	self disable_exits();
	
	node = getnode( self.target, "targetname" );
	if( !isdefined( node ) )
		node = getstruct( self.target, "targetname" );
	
	goal_type = undefined;
	//only nodes and structs dont have classnames - ents do
	if ( !isdefined( node.classname ) )
	{
		//only structs don't have types, nodes do
		if ( !isdefined( node.type ) )
			goal_type = "struct";
		else
			goal_type = "node";
	}
	else
	{
		goal_type = "origin";
	}
	
	require_player_dist = 300;
	
	// wait till player hits move in trigger
	if( isdefined( trig ) )
		getent( trig + "_movein_trig", "targetname" ) waittill( "trigger" );
	
	//calling this because i DO want the radius to explode	
	self thread maps\_spawner::go_to_node( node, goal_type, undefined, require_player_dist );
	
	wait 1;
	self enable_exits();
	
	if( isdefined( stay ) && stay && isdefined( duration ) )
		enemy_seek_player( seek_goalradius, duration );
	else
		enemy_seek_player( seek_goalradius );
}

past_enemy_remove( enemy_group, num )
{
	flag_wait( enemy_group + "_kill" );

	enemy_array = getaiarray( "axis" );
	guys_to_delete = [];
	foreach ( guy in enemy_array )
		if ( isdefined( guy.script_noteworthy ) && guy.script_noteworthy == enemy_group )
			guys_to_delete[ guys_to_delete.size ] = guy;	
	
	if( isdefined( num ) && ( num > 0 ) && ( num < guys_to_delete.size ) )
	{
		random_guys_to_delete = array_randomize( guys_to_delete );	
		guys_to_delete = [];
		
		for( i = 0; i < num; i++ )
			guys_to_delete[ guys_to_delete.size ] = random_guys_to_delete[ i ];
	}

	thread AI_delete_when_out_of_sight( guys_to_delete, 512 );
}

type_script_model_civilian()
{
	if ( !isdefined( self.code_classname ) )
		return false;
	
	if ( !isdefined( self.model ) )
		return false;
	
	if ( self.code_classname == "script_model" && self.model == "body_complete_civilian_suit_male_1" )
		return true;
		
	return false;
}

hide_destroyed_parts()
{
	poles = getentarray( "massacre_post_post_exp", "targetname" );
	foreach( pole in poles )
	{
		pieces = getentarray( pole.target, "targetname" );
		
		foreach( piece in pieces )
			piece hide();
			
		pole hide();
	}
}