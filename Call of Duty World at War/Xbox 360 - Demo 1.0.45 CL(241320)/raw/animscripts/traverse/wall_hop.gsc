// Fence_climb.gsc
// Makes the character climb a 48 unit fence
// TEMP - copied wall dive until we get an animation
// Makes the character dive over a low wall

#include animscripts\traverse\shared; 

main()
{
	if( IsDefined( self.is_zombie ) && self.is_zombie )
	{
		wall_hop_zombie(); 
	}
	else if( self.type == "human" )
	{
		wall_hop_human();
	}
	else if( self.type == "dog" )
	{
		dog_wall_and_window_hop( "wallhop", 40 ); 
	}
}

#using_animtree( "generic_human" ); 

wall_hop_human()
{
	if( RandomInt( 100 ) < 30 )
	{
		self advancedTraverse( %traverse_wallhop_3, 39.875 ); 
	}
	else
	{
		self advancedTraverse( %traverse_wallhop, 39.875 ); 
	}
}

wall_hop_zombie()
{
	if( self.has_legs )
	{
		if( RandomInt( 100 ) < 50 )
		{
			self advancedTraverse( %ai_zombie_traverse_v1, 39.875 );
		}
		else
		{
			self advancedTraverse( %ai_zombie_traverse_v2, 39.875 );
		}
	}
	else
	{
		self advancedTraverse( %ai_zombie_traverse_crawl_v1, 39.875 );
	}
}