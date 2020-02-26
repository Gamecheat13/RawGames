// wall_hop_down_80.gsc
// Makes the character climb a 40 unit fence and drop down 80+ units

#include animscripts\traverse\shared; 

main()
{
	if( self.type == "human" )
	{
		wall_hop_down_human(); 
	}
	else if( self.type == "dog" )
	{
		assertMsg( "wall_hop_down_80.gsc - does not support dogs at the moment" );
	}
}

#using_animtree( "generic_human" );
wall_hop_down_human()
{
	traverseData = [];
	if( RandomInt( 100 ) < 30 )
	{
		traverseData["traverseAnim"] = %ai_traverse_wallhop_down_3;
	}
	else
	{
		traverseData["traverseAnim"] = %ai_traverse_wallhop_down;
	}

	DoTraverse( traverseData );
}