
set_player_rig_spawn_function( player_rig_spawn_function )
{
	AssertEx( !IsDefined( level.player_rig_spawn_function ), "player rig spawn function already defined?" );
	level.player_rig_spawn_function = player_rig_spawn_function;
}

#using_animtree( "player" );
spawn_player_rig()
{
	player_rig = undefined;
	if ( IsDefined( level.player_rig_spawn_function ) )
	{
		player_rig = [[level.player_rig_spawn_function]]();
		player_rig.animname = "_vehicle_player_rig";
	}
	else
	{
		// spawn default body rig
		player_rig = Spawn( "script_model", (0,0,0) );
		player_rig.animname = "_vehicle_player_rig";
		player_rig UseAnimTree( #animtree );
		player_rig SetModel( "viewbody_generic_s1" );
	}
	
	return player_rig;
}

add_vehicle_anim( classname, anim_mode, anim_entry )
{
	if ( !IsDefined( level.vehicle_anims ) )
		level.vehicle_anims = [];
	
	if ( !IsDefined( level.vehicle_anims[ classname ] ) )
		level.vehicle_anims[ classname ] = [];
	
	level.vehicle_anims[ classname ][ anim_mode ] = anim_entry;
}

add_vehicle_player_anim( classname, anim_mode, anim_entry )
{
	level.scr_anim[ "_vehicle_player_rig" ][ anim_mode ] = anim_entry;
}

get_vehicle_anim( anim_mode )
{
	return level.vehicle_anims[ self.classname ][ anim_mode ];
}

get_vehicle_player_anim( anim_mode )
{
	return level.scr_anim[ "_vehicle_player_rig" ][ anim_mode ];
}

wait_for_vehicle_mount()
{
	self endon( "guy_entered" );
	self waittill( "vehicle_mount", player );
	self.player_driver = player;
}

wait_for_vehicle_dismount()
{
	self waittill( "vehicle_dismount", player );
	if ( IsDefined( player ) )
	{
		player.drivingVehicle = undefined;
	}
	self.player_driver = undefined;
}

