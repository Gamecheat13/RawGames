


#using_animtree ("generic_human");

main()
{
	
	
	self endon("killanimscript");
	
    startnode = self getnegotiationstartnode();
    assert( isdefined( startnode ) );
    self OrientMode( "face angle", startnode.angles[1] );
	
	realHeight = startnode.traverse_height - startnode.origin[2];
    destination = (realHeight);
	
	reps = 6;
	offset = ( 0, 0, destination / reps);
	self traverseMode("noclip"); 
	for (i=0;i<reps;i++)
	{
		self teleport (self.origin + offset);
		wait (0.05);
	}
	self traverseMode("gravity");

}
