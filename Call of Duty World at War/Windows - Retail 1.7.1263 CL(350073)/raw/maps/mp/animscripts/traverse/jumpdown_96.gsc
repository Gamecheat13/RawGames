#include maps\mp\animscripts\traverse\shared;

main()
{
	startnode = self getnegotiationstartnode();
	endnode = self getnegotiationendnode();
	assert( isdefined( startnode ) );
	assert( isdefined( endnode ) );

	if ( isdefined(self.traverse_height) )
	{
		dropheight = self.traverse_height;
	}
	else
	{
		dropheight = startnode.origin[2];
	}
	
	starttrace = ( endnode.origin[0], endnode.origin[1], dropheight );
	trace = bulletTrace( starttrace, endnode.origin - (0,0,80), false, self );

	height = 96;
	
	if ( trace["fraction"] < 1.0 )
	{
		hitPos = trace["position"];
		
		height = dropheight - hitPos[2];
	}
	
	if ( self.type == "dog" )
	{
		if ( height <= 56 )
		{
			dog_jump_down( height, 7 );
		}
		else
		{
			dog_jump_down_far( height, 11, 0.65 );
		}
	}
}
