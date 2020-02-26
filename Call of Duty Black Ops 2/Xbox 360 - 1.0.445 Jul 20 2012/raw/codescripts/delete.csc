main()
{
	assert(isdefined(self));
	wait 0;
	if (isdefined(self))
	{
		/# 
		if(isdefined(self.classname))
		{
			if( self.classname == "trigger_once" || self.classname == "trigger_radius" || self.classname == "trigger_multiple" )
			{
				println( "" );
				println( "*** trigger debug: delete.gsc is deleting trigger with ent#: " + self getentitynumber() + " at origin: " + self.origin );
				
				//players = GetPlayers();
				//println( "*** trigger debug: player origin is: " + players[0].origin );
				
				println( "" );
			}
		}
		#/
		self delete();
	}
}
