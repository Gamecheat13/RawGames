


#using_animtree ("generic_human");

main()
{
	self endon("killanimscript");
	self endon("death");

	self traverseMode("noclip");

	node = self getnegotiationstartnode();
	assert(isdefined(node));

	if (!(node.spawnflags & 2048))
	{
		assertmsg("Trying to use door animscript one non-door node.");
		return;
	}
	else if( !isDefined(node.doorRef) || node.doorRef.size == 0 )
    {
        assertmsg("Door node has no door.");
        return;
    }    

    if(isdefined(node.disabled))
    {
        if(node.disabled == true)
        {
            return;
        }
    }

    door = node.doorRef[0];

    if(door._doors_barred)
        return;
    
    if( door maps\_doors::is_door_locked(node) && !self maps\_doors::can_unlock_this_door(door, node) )
    	return;
    
    if (!door maps\_doors::is_door_open() && (!IsDefined(self._doors_traversing_door) || !self._doors_traversing_door))
    {
		self._doors_traversing_door = true;
        wait 1.0;											
       
	    
		keepDoorOpen = 0;        
        if( self GetAlertState() == "alert_red" )
		{
			keepDoorOpen = 1;
		}
                
		node maps\_doors::open_door_from_door_node( keepDoorOpen );
		self._doors_traversing_door = false;
    }
}