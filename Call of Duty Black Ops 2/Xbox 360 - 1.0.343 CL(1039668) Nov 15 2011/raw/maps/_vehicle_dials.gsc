#include animscripts\utility;
#include common_scripts\utility;

#using_animtree( "vehicles" );

add_dial_vehicle( base_anim )
{
	self notify( "kill_dials" );
	
	if( !IsDefined( self.vehicletype ) )
	{
		PrintLn( "^1WARNING: Trying to make a non-vehicle entity a vehicle with animated dials!" );
		return;
	}
	
	if( !IsDefined( level.dial_animations ) )
	{
		level.dial_animations = [];
	}
	
	self UseAnimTree( #animtree );
	
	level.dial_animations[ self.vehicletype ] = [];
	self.dial_vehicle = true;
	self SetAnim( base_anim, 1, 0, 0 );
	
	self thread update_dial_anims();
	self thread cleanup_dial_anims();
}

add_animated_dial( dial_name, dial_anim, value_func )
{
	if( !IsDefined( self.vehicletype ) )
	{
		PrintLn( "^1WARNING: Trying to add dial anims for a non-vehicle entity!" );
		return;
	}
	if( !IsDefined( level.dial_animations[ self.vehicletype ] ) || !IsDefined( self.dial_vehicle ) || !self.dial_vehicle )
	{
		PrintLn( "^1WARNING: Trying to add dial anims for a vehicle that has not been set up as a dial vehicle! Call add_dial_vehicle first!" );
		return;
	}
	level.dial_animations[ self.vehicletype ][ dial_name ] = [];
	level.dial_animations[ self.vehicletype ][ dial_name ]["anim"] = dial_anim;
	level.dial_animations[ self.vehicletype ][ dial_name ]["func"] = value_func;
	
	self SetAnim( dial_anim, 1, 0, 0 );
}

update_dial_anims()
{
	self endon( "kill_dials" );
	self endon( "death" );
	
	while( IsDefined( self.dial_vehicle ) && self.dial_vehicle )
	{
		keys = GetArrayKeys( level.dial_animations[ self.vehicletype ] );
		for( i = 0; i < level.dial_animations[ self.vehicletype ].size; i++ )
		{
			anim_array = level.dial_animations[ self.vehicletype ][ keys[i] ];
			value = self [[ anim_array["func"] ]]();
			if( value > 0.999 )
			{
				value = 0.999;
			}
			if( value < 0.001 )
			{
				value = 0.001;
			}
			self SetAnimTime( anim_array["anim"], value );
		}
		
		wait( 0.05 );
	}
}

cleanup_dial_anims()
{
	self waittill( "death" );

	if (IsDefined(self))
	{
		self notify( "kill_dials" );
		self.dial_vehicle = false;
		self ClearAnim( %root, 0.2 );
	}
}