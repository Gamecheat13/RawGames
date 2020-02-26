#include common_scripts\utility;
#include animscripts\traverse\shared;

#using_animtree ("generic_human");

main()
{
	// do not do code prone in this script
	
	self endon("killanimscript");

	PrepareForTraverse();
	
    startnode = self getnegotiationstartnode();
    assert( IsDefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );
	
	realHeight = startnode.traverse_height - startnode.origin[2];
    destination = (realHeight);
	
	const reps = 6;
	offset = ( 0, 0, destination / reps);
	self traverseMode("noclip"); // So he doesn't get stuck if the wall is a little too high
	for (i=0;i<reps;i++)
	{
		self Teleport (self.origin + offset);
		wait (0.05);
	}
	self traverseMode("gravity");

}
