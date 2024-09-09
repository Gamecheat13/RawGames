#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#include maps\_vehicle;
#include maps\_shg_utility;

main()
{
	PreCacheModel( "weapon_javelin_tactics_friendly" );
	PreCacheModel( "weapon_smaw_tactics_friendly" );
	PreCacheModel( "vehicle_gaz_tigr_base_tactics_enemy" );
	PreCacheModel( "vehicle_x4walker_wheels_tactics_friendly" );
	PreCacheModel( "weapon_dshk_turret_tactics_enemy" );
	PreCacheModel( "vehicle_pdrone_tactics_friendly" );
	PreCacheModel( "vehicle_walker_tank_tactics_enemy" );
	PreCacheModel( "weapon_rpg7_tactics_friendly" );
	
	flag_init( "tactics_mode_on" );
	
	level.tactics_objects = [];
	level.tactics_objectives = [];
	level.tactics_tools = [];
	
	add_global_spawn_function( "axis", ::monitor_rpg_drop );
}

add_object_to_tactics_system( object )
{
	if (!IsDefined(level.tactics_objects))
		return;

	if( IsSubStr( object.classname, "vehicle" ) )
	{
		object thread remove_vehicle_from_tactics_array_on_death();
	}
	
	if( IsSubStr( object.classname, "x4walker" ) )
	{
		object thread remove_turret_on_mount();
	}
	
	level.tactics_objects[ level.tactics_objects.size ] = object;
}

remove_object_from_tactics_system( object )
{
	object remove_from_arrays();
}

monitor_tactics_mode()
{
	level.player endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	level.player thread monitor_player_rpg_drop();
	
	while( true )
	{
		if( level.player ButtonPressed( "DPAD_UP" ) )
		{	
			foreach( object in level.tactics_objects )
			{
				if( !IsDefined( object ) )
				{
					continue;
				}
				
				if( object.tactics_type == "objective" && !is_in_array( level.tactics_objectives, object ) )
				{
					level.tactics_objectives[ level.tactics_objectives.size ] = object;
				}
				else if( object.tactics_type == "tool" && !is_in_array( level.tactics_tools, object ) )
				{
					level.tactics_tools[ level.tactics_tools.size ] = object;
				}
			}
			
			if( !flag( "tactics_mode_on" ) )
			{
				level.player notify( "start_tactics_mode" );
				thread change_to_tactics_models();
				//thread draw_tactics_lines( level.tactics_objectives, level.tactics_tools );
				thread draw_text_hud( level.player, level.tactics_objectives, level.tactics_tools );
			}
			
			flag_set( "tactics_mode_on" );
		}
		else
		{
			if( flag( "tactics_mode_on" ) )
			{
				level.player notify( "stop_tactics_mode" );
				thread change_to_original_models();
			}
			
			flag_clear( "tactics_mode_on" );
			
		}
		
		wait( 0.05 );
	}
}

change_to_tactics_models()
{
	foreach( object in level.tactics_objects )
	{
		AssertEx( IsDefined( object.tactics_model ), "tactics objects must specify a tactics model" );
		if( isDefined( object ) )
			object SetModel( object.tactics_model );
	}
}

change_to_original_models()
{
	foreach( object in level.tactics_objects )
	{
		AssertEx( IsDefined( object.original_model ), "tactics objects must specify an original model" );
		if( isDefined( object ) )
			object SetModel( object.original_model );
	}
}

draw_tactics_lines( objectives, tools )
{
	level.player endon( "stop_tactics_mode" );
	level.player endon( "death" );
	
	while( true )
	{
		foreach( objective in objectives )
		{
			foreach( tool in tools )
			{
				if( !isDefined( tool ) || ( isDefined( tool.no_line ) && tool.no_line ) )
				{
					continue;
				}
				
				Line( tool.origin, objective.origin + ( 0, 0, 72 ), ( 1, .44, .39 ), 1, false, 1 );
			}
		}
		
		wait( 0.05 );
	}
}

draw_text_hud( player, objectives, tools )
{
	foreach( objective in objectives )
	{
		objective thread draw_text_hud_objective( player );
	}
	
	foreach( tool in tools )
	{
		tool thread draw_text_hud_tool( player );
	}
}

OBJECTIVE_COLOR = ( 1, .44, .39 );
OBJECTIVE_ALPHA = 1;
TOOL_COLOR = ( 0.3, 1, 0.6 );
TOOL_ALPHA = .5;

draw_text_hud_objective( player )
{
	if( !IsDefined( self.description ) )
		return;
	
	Assert(!IsDefined(self.drawing_warzone_hud));
	self.drawing_warzone_hud = true;
	
	elem_tag = spawn_tag_origin();
	elem_tag linkto_with_world_offset( self, undefined, ( 0, 0, 72 ) );
	
	label_elem = NewClientHudElem( player );
	label_elem SetTargetEnt( elem_tag );
	
	label_elem.positioninworld = true;
	label_elem SetText(self.description);
	label_elem.color = OBJECTIVE_COLOR;
	label_elem.alpha = OBJECTIVE_ALPHA;
	label_elem.alignx = "center";
	label_elem.aligny = "middle";
	label_elem thread scale_3d_hud_elem( elem_tag, player );
	label_elem SetPulseFX( 60, 999999, 0 );	
	
	self wait_till_should_stop_drawing( player );
	
	label_elem Destroy();
	elem_tag Delete();
	if( IsDefined( self ) )
		self.drawing_warzone_hud = undefined;
}

draw_text_hud_tool( player )
{
	if( !IsDefined( self.description ) )
		return;
	
	Assert(!IsDefined(self.drawing_warzone_hud));
	self.drawing_warzone_hud = true;
	
	elem_tag = spawn_tag_origin();
	elem_tag linkto_with_world_offset( self, undefined, ( 0, 0, 72 ) );
	
	label_elem = NewClientHudElem( player );
	label_elem SetTargetEnt( elem_tag );	
	label_elem.positioninworld = true;
	label_elem SetText(self.description);
	label_elem.color = TOOL_COLOR;
	label_elem.alpha = TOOL_ALPHA;
	label_elem.alignx = "center";
	label_elem.aligny = "middle";
	label_elem.z = -.5;	
	label_elem thread scale_3d_hud_elem( elem_tag, player );
	label_elem SetPulseFX( 60, 999999, 0 );
	
	distance_elem = NewClientHudElem( player );
	distance_elem SetTargetEnt( elem_tag );
	distance_elem.positioninworld = true;
	distance_elem.color = TOOL_COLOR;
	distance_elem.alpha = TOOL_ALPHA;
	distance_elem.alignx = "center";
	distance_elem.aligny = "middle";
	distance_elem.z = .5;	
	distance_elem thread scale_3d_hud_elem( elem_tag, player );
	distance_elem thread hud_elem_update_distance( elem_tag, player );
	
	self wait_till_should_stop_drawing( player );
	
	label_elem Destroy();
	distance_elem Destroy();
	elem_tag Delete();
	if( IsDefined( self ) )
		self.drawing_warzone_hud = undefined;
}

wait_till_should_stop_drawing( player )
{
	self endon("death");
	player endon( "stop_tactics_mode" );
	player endon( "death" );
	
	level waittill("forever");
}

scale_3d_hud_elem(elem_tag, player)
{
	self endon( "death" );
	while( true )
	{	
		self.fontscale = linear_map_clamp( Distance( elem_tag.origin, player GetEye() ), 16, 1024, 2.5, 1.5 );
		waitframe();
	}
}

hud_elem_update_distance( elem_tag, player )
{
	self endon( "death" );
	
	wait .8;
	
	while( true )
	{		
		distance_in_meters = Distance( elem_tag.origin, player GetEye() ) / 39.370079;
		self SetText( Int( distance_in_meters + .5 ) );
		waitframe();
	}
}

// todo: put in shared code?
linkto_with_world_offset(parent, tag, world_offset)
{
	thread linkto_with_world_offset_internal(parent, tag, world_offset);
}

unlinkto_with_world_offset()
{
	self notify( "stop_link_with_world_offset" );
}

linkto_with_world_offset_internal(parent, tag, world_offset)
{
	self endon( "death" );
	parent endon( "death" );
	self endon( "stop_link_with_world_offset" );
	
	while( true )
	{
		waittillframeend;
		if ( IsDefined( tag ) )
			self.origin = parent GetTagOrigin( tag ) + world_offset;
		else
			self.origin = parent.origin + world_offset;
		waitframe();
	}
}


monitor_rpg_drop()
{
	level.player endon( "death" );
	if( !IsSubStr( self.classname, "rpg" ) )
	{
		return;
	}
	
	self waittill( "weapon_dropped", weapon );
	if( IsDefined( weapon ) && IsSubStr( weapon.classname, "rpg" ) )
	{
		weapon add_rpg_to_tactics_system();
	}
}

add_rpg_to_tactics_system()
{
	self.description = "SMAW";
	self.original_model = self.model;
	self.tactics_model = "weapon_smaw_tactics_friendly";
	self.tactics_type = "tool";
	level.tactics_objects = array_add( level.tactics_objects, self );
	self thread remove_from_tactics_array_on_pickup();
	self thread remove_from_tactics_array_on_delete();
}

remove_from_tactics_array_on_pickup()
{
	level.player endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	while( true )
	{
		level.player waittill( "pickup", weapon );
		
		if( weapon == self )
		{
			self remove_from_arrays();
		}
	}
}

remove_from_tactics_array_on_delete()
{
	level.player endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	while( IsDefined( self ) )
	{
		wait( 0.05 );
	}
	
	self remove_from_arrays();
}

monitor_player_rpg_drop()
{
	level.player endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	while( true )
	{
		level.player waittill( "pickup", weapon, dropped_weapon );
		
		if( IsDefined( dropped_weapon ) && IsSubStr( dropped_weapon.classname, "smaw_nolock_fusion" ) )
		{
			dropped_weapon add_rpg_to_tactics_system();
		}
	}
}

remove_vehicle_from_tactics_array_on_death()
{
	level.player endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	self waittill( "death" );
	
	level.tactics_objects = array_remove( level.tactics_objects, self );
	level.tactics_tools = array_remove( level.tactics_tools, self );
	level.tactics_objectives = array_remove( level.tactics_objectives, self );
	
	if ( IsDefined( self ) && IsDefined( self.mgturret ) && IsDefined( self.mgturret[0] ) )
	{
		level.tactics_objects = array_remove( level.tactics_objects, self.mgturret[0] );
		level.tactics_tools = array_remove( level.tactics_tools, self.mgturret[0] );
		level.tactics_objectives = array_remove( level.tactics_objectives, self.mgturret[0] );
	}
}

remove_turret_on_mount()
{
	level.player endon( "death" );
	self endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	self waittill( "vehicle_mount" );
	self thread add_turret_on_dismount();
	self remove_from_arrays();
}

add_turret_on_dismount()
{
	level.player endon( "death" );
	self endon( "death" );
	level.player endon( "end_tactics_mode" );
	
	self waittill( "vehicle_dismount" );
	add_object_to_tactics_system( self );
}


remove_from_arrays()
{
	if (!IsDefined(level.tactics_objects))
		return;
	
	if( is_in_array( level.tactics_objects, self ) )
	{
		level.tactics_objects = array_remove( level.tactics_objects, self );
	}
	
	if( is_in_array( level.tactics_tools, self ) )
	{
		level.tactics_tools = array_remove( level.tactics_tools, self );
	}
	else if( is_in_array( level.tactics_objectives, self ) )
	{
		level.tactics_objectives = array_remove( level.tactics_objectives, self );
	}
}