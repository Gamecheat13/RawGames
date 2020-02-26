#include maps\mp\animscripts\traverse\shared;

main()
{
	if ( self.type == "dog" )
		dog_wall_and_window_hop( "traverse_window", 40 );
		
// 	if( IsDefined( self.is_zombie ) && self.is_zombie &&  !self.isdog)
// 	{
// 		if(self.animname == "quad_zombie" )
// 		{
// 			wall_hop_quad();
// 		}
// 		else
// 		{
// 			wall_hop_zombie();
// 		}	 
// 	}
// 	else if( self.isdog )
// 	{
// 		dog_wall_and_window_hop( "wallhop", 40 ); 
// 	}
}

// #using_animtree( "generic_human" ); 
// 
// wall_hop_zombie()
// {
// 	traverseData = [];
// 	if( self.has_legs )
// 	{
// 		switch (self.zombie_move_speed)
// 		{
// 		case "walk":
// 			traverseData[ "traverseAnim" ] = array(
// 				%ai_zombie_traverse_v1,
// 				%ai_zombie_traverse_v2
// 				);
// 			break;
// 		case "run":
// 			traverseData[ "traverseAnim" ] = array(
// 				%ai_zombie_traverse_v5
// 				);
// 			break;
// 		case "sprint":
// 			traverseData[ "traverseAnim" ] = array(
// 				%ai_zombie_traverse_v6,
// 				%ai_zombie_traverse_v7
// 				);
// 			break;
// 		default:
// 			assertmsg("Zombie move speed of '" + self.zombie_move_speed + "' is not supported for wall hop.");
// 		}
// 	}
// 	else
// 	{
// 		traverseData[ "traverseAnim" ] = array(
// 			%ai_zombie_traverse_crawl_v1,
// 			%ai_zombie_traverse_v4
// 			);
// 	}
// 
// 	self DoTraverse(traverseData);
// }
// 
// wall_hop_quad()
// {
// 	traverseData = [];
// 
// 	if( self.has_legs )
// 	{
// 			traverseData[ "traverseAnim" ] = array(
// 				%ai_zombie_traverse_v3
// 				);		
// 	}
// 	else
// 	{
// 		traverseData[ "traverseAnim" ] = array(
// 			%ai_zombie_traverse_crawl_v1,
// 			%ai_zombie_traverse_v4
// 			);
// 	}	
// 	DoTraverse( traverseData );
// }	