main () 
{ 
     //larger number means fx will play less frequently. 
    
	if(isdefined(level.tread_override_thread)) 
	{ 
		self thread [[level.tread_override_thread]](	"tag_origin", "back_left", (160,0,0));
//		self thread maps\libya::tread( "tag_origin", "back_left", (160,0,0) ); 

	} 
	else 
	{
		self.TuningValue = 35;
		self thread tread("tag_wheel_back_left","back_left"); 
		self thread tread("tag_wheel_back_right","back_right"); 
	}
}

tread (tagname, side, relativeOffset)
{
	self endon ("death");
	if (!isDefined(relativeOffset) )
		relativeOffset = (0,0,0);
	treadfx = treadget(self, side);
	for (;;)
	{
		speed = self getspeed();
		if (speed == 0)
		{
			wait 0.1;
			continue;
		}
		waitTime = (1 / speed);
		waitTime = (waitTime * self.TuningValue);
		if (waitTime < 0.1)
			waitTime = 0.1;
		else if (waitTime > 0.3)
			waitTime = 0.3;
		wait waitTime;
		lastfx = treadfx;
		treadfx = treadget(self, side);
		if(treadfx != -1)
		{
			ang = self getTagAngles(tagname);
			forwardVec = anglestoforward(ang);
			rightVec = anglestoright(ang);
			upVec = anglestoup(ang);
			effectOrigin = self getTagOrigin(tagname);
			effectOrigin += maps\_utility::vectorMultiply(forwardVec, relativeOffset[0]);
			effectOrigin += maps\_utility::vectorMultiply(rightVec, relativeOffset[1]);
			effectOrigin += maps\_utility::vectorMultiply(upVec, relativeOffset[2]);
			forwardVec = maps\_utility::vectorMultiply(forwardVec, waitTime);
			playfx (treadfx, effectOrigin, (0,0,0) - forwardVec);
		}
	}
}

treadget (vehicle, side)
{
	surface = self getwheelsurface(side);
	if (!isdefined (vehicle.vehicletype))
	{
		treadfx = -1;
		return treadfx;
	}
	
	if(!isdefined(level._effect[vehicle.vehicletype]))
	{
		println("no treads setup for vehicle type: ",vehicle.vehicletype);
		wait 1;
		return -1;
	}
	treadfx = level._effect[vehicle.vehicletype][surface];
	
	if(surface == "ice")
		self notify ("iminwater");
	
	if(!isdefined(treadfx))
		treadfx = -1;
	
	return treadfx;
}