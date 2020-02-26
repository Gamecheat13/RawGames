#include clientscripts\mp\_utility;

// creates a list of wait and speed times to ensure that they are the same for multiple split-screen players
init()
{
	level.fxanim_max_anims = 128;
	
	level.scr_anim = [];
	level.scr_anim[ "fxanim_props" ] = [];

	level.fxanim_waits = [];
	level.fxanim_speeds = [];

	for ( i = 0; i < level.fxanim_max_anims; i++ )
	{
		level.fxanim_waits[ i ] = RandomFloatRange( 0.1, 1.5 );
		level.fxanim_speeds[ i ] = RandomFloatRange( 0.75, 1.4 );
	}
}

fxanim_init( localClientNum )
{
	a_fxanims = GetEntArray( localClientNum, "fxanim", "targetname" );
	assert( a_fxanims.size <= level.fxanim_max_anims );

	for ( i = 0; i < a_fxanims.size; i++ )
	{
		a_fxanims[i] thread fxanim_think( localClientNum, level.fxanim_waits[i], level.fxanim_speeds[i] );
	}
}

// ----------------------------------------------------------------------------------------------------
// ---- KVP-Based FXANIM System ----
// ----------------------------------------------------------------------------------------------------
#using_animtree( "fxanim_props" );

fxanim_think( localClientNum, random_wait, random_speed )	
{	
	self endon( "death" );
	self endon( "entityshutdown" );
	self endon( "delete" );

	self waittill_dobj( localClientNum );

	if ( is_true( self.fxanim_hide ) )
	{
		self Hide();
	}
	
	self fxanim_wait( random_wait );		// if defined, wait until the animation is told to start
	self Show();
	
	self UseAnimTree( #animtree );	
	speed = fxanim_get_speed( random_speed );
	
	a_anim_list = self build_anim_structure();
	
	for ( i = 0; i < a_anim_list.size; i++ )	
	{
		str_scene = a_anim_list[i]["scene"];
		is_loop = a_anim_list[i]["is_loop"];
		str_change_on = a_anim_list[i]["change_on"];
		is_change_after = a_anim_list[i]["is_after"];

		self SetAnim( level.scr_anim[ "fxanim_props" ][ str_scene ], 1.0, 0.0, speed );
		
		if ( IsDefined( str_change_on ) )
		{
			if ( str_change_on == "none" )
			{
				self wait_for_anim_to_end( is_loop );
			}
			else
			{
				level waittill( str_change_on );	
			}		
			
			if( is_change_after )
			{
				self wait_for_anim_to_end( is_loop );
			}
		}
	}
}



// Delay playing the animation based on the set kvps.
// self = model the fxanim will be played on
fxanim_wait( wait_time )
{
	if ( IsDefined( self.fxanim_waittill_1 ) )
	{
		if ( self.fxanim_waittill_1 == "random" )
		{
			wait( wait_time );
		}
		else
		{
			level waittill( self.fxanim_waittill_1 );	
		}
	}	
	
	if ( IsDefined( self.fxanim_wait ) )
	{
		wait self.fxanim_wait;
	}
	else if ( IsDefined( self.fxanim_wait_min ) && IsDefined( self.fxanim_wait_max ) )
	{
		n_wait_time = RandomFloatRange( self.fxanim_wait_min, self.fxanim_wait_max );
		wait n_wait_time;
	}
}

fxanim_get_speed( random_speed )
{
	if ( !IsDefined( self.speed ) )
	{
		self.speed = 1;
	}

	if ( IsString( self.speed ) && self.speed == "random" )
	{
		return random_speed;
	}

	return self.speed;
}

// returns the scene, based on the fxanim_scene key.  
// Used in case there are multiple scenes defined, such as when an fxanim_change_on is defined
// self = the parent fxanim model
fxanim_get_scene( index )
{
	str_scene = self.fxanim_scene;
	
	a_scenes = StrTok( str_scene, " " );	
	
	// Assert( IsDefined( a_scenes[index] ), "fxanim at origin " + self.origin + " should have at least " + (index + 1) + " scenes defined in fxanim_scene, seperated by spaces." );
		
	return a_scenes[index];
}	



// Grabs all anims defined on the model and puts the relevent anim info (scene, is_loop, change on)
// and puts them into an array.  
// Self = the fxanim model
build_anim_structure()
{
	a_anims = [];
	a_is_anim_loop = [];
	if( IsDefined( self.fxanim_scene_1 ) )
	{
		Assert( !IsDefined( self.fxanim_scene_1_loop ), "FXANIM at origin " + self.origin + " has both an fxanim_scene_1 and fxanim_scene_1_loop.  Only one can be present" );
		a_anims[0] = self.fxanim_scene_1;
		a_is_anim_loop[0] = false;
	}
	else if( IsDefined( self.fxanim_scene_1_loop ) )
	{
		a_anims[0] = self.fxanim_scene_1_loop;
		a_is_anim_loop[0] = true;
	}
	
	if( IsDefined( self.fxanim_scene_2 ) )
	{
		Assert( !IsDefined( self.fxanim_scene_2_loop ), "FXANIM at origin " + self.origin + " has both an fxanim_scene_2 and fxanim_scene_2_loop.  Only one can be present" );
		a_anims[1] = self.fxanim_scene_2;
		a_is_anim_loop[1] = false;
	}
	else if( IsDefined( self.fxanim_scene_2_loop ) )
	{
		a_anims[1] = self.fxanim_scene_2_loop;
		a_is_anim_loop[1] = true;
	}
	
	if( IsDefined( self.fxanim_scene_3 ) )
	{
		Assert( !IsDefined( self.fxanim_scene_3_loop ), "FXANIM at origin " + self.origin + " has both an fxanim_scene_3 and fxanim_scene_3_loop.  Only one can be present" );
		a_anims[2] = self.fxanim_scene_3;
		a_is_anim_loop[2] = false;
	}
	else if( IsDefined( self.fxanim_scene_3_loop ) )
	{
		a_anims[2] = self.fxanim_scene_3_loop;
		a_is_anim_loop[2] = true;
	}	
	
	a_change_on = [];
	a_change_on[0] = self.fxanim_waittill_2;
	a_change_on[1] = self.fxanim_waittill_3;
	
	a_anim_list = [];
	
	for ( i = 0; IsDefined( a_anims[i] ); i++ )
	{
		a_anim_list[i]["scene"] = a_anims[i];
		
		a_anim_list[i]["is_loop"] = a_is_anim_loop[i];
		
		a_anim_list[i]["is_after"] = false;
		if( IsDefined( a_anims[i + 1] ) )
		{
			a_anim_list[i]["is_after"] = false;
			if( IsDefined( a_change_on[i] ) )
			{
				a_changer = StrTok( a_change_on[i], " " );
				
				a_anim_list[i]["change_on"] = a_changer[0];
				
				if( IsDefined( a_changer[1] ) && a_changer[1] == "after" )
				{
					a_anim_list[i]["is_after"] = true;
				}
			}
			else
			{
				a_anim_list[i]["change_on"] = "none";
			}
		}
	}
	
	return a_anim_list;
}



// Wait for the current anim to end
// self is the model animating 
wait_for_anim_to_end( is_loop )
{
	if( is_loop )
	{
		self waittillmatch( "looping anim", "end" );
	}
	else 
	{
		self waittillmatch( "single anim", "end" );
	}	
}