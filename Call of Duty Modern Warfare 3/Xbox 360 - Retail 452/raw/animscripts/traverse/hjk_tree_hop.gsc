// hjk_tree_hop.gsc
// Makes the character step over a fallen tree

#include animscripts\traverse\shared;

main()
{
	if ( self.type == "dog" )
		dog_wall_and_window_hop( "wallhop", 40 );
	else
		tree_hop_human();
}

#using_animtree( "generic_human" );

tree_hop_human()
{
	if( isdefined( self.type ) && self.type == "civilian" )
	{
		self advancedTraverse( %so_hijack_civ_log_jump, 39.875 );
	}
	else
	{
		self advancedTraverse( %traverse_wallhop_3, 39.875 );
	}
}