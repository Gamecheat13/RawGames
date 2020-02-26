main()
{
	precachemodel ("xmodel/temp");
	windows = getentarray("window","targetname");
	if(!isdefined(windows))
		return;
	windowfx = loadfx ("fx/impacts/glass_shatter2.efx");


	for(i=0;i<windows.size;i++)
	{
		windows[i] thread window(windowfx);
	}
}
window(windowfx)
{
	if(!isdefined(self.target))
	{
		println("no target key found for window trigger at ", self getorigin());
		return;
	}
	window = getent(self.target,"targetname");
	if(!isdefined(window))
	{
		println("window not found for window trigger at ", self getorigin());
		return;
	}
	
	self enableGrenadeTouchDamage();
	window disableGrenadeBounce();
	
	if(isdefined(window.target))
		brokenwindow = getent(window.target,"targetname");
	org = spawn("script_origin",self getorigin());

	windoworg = window getorigin();
	selforg = self getorigin();
	sampledist = 1;
	spacing = 24;
	while(org istouching(self))
	{
		org.origin += (sampledist,0,0);
	}
	xendorg = org.origin;
	xdist = org.origin[0]-selforg[0];
	org.origin = selforg;
	while(org istouching(self))
	{
		org.origin += (0,sampledist,0);
	}
	yendorg = org.origin;
	ydist = org.origin[1]-selforg[1];
	org.origin = selforg;
	while(org istouching(self))
	{
		org.origin += (0,0,sampledist);
	}
	zendorg = org.origin;
	zdist = org.origin[2]-selforg[2];
	point = [];
	if(ydist>xdist)
	{
		direction = vectornormalize(xendorg-selforg);
		xcount = (int)(yendorg[1]-windoworg[1])/spacing;
		if(!(xcount))
			xcount = 1;
		ycount = (int)(zendorg[2]-windoworg[2])/spacing;
		if(!(ycount))
			ycount = 1;
		xoffset = xcount*spacing;
		yoffset = ycount*spacing;
		basex = windoworg[1]-xoffset+spacing/2;
		basey = windoworg[2]-yoffset+spacing/2;
		for(x=0;x<xcount*2;x++)
		{
			for(y=0;y<ycount*2;y++)
			{
				xspot = basex+x*spacing;
				yspot = basey+y*spacing;
				point[x][y] = (windoworg[0],xspot,yspot);
			}
		}
	}
	else
	{
		direction = vectornormalize(yendorg-selforg);
		xcount = (int)(xendorg[0]-windoworg[0])/spacing;
		if(!(xcount))
			xcount = 1;
		ycount = (int)(zendorg[2]-windoworg[2])/spacing;
		if(!(ycount))
			ycount = 1;
		xoffset = xcount*spacing;
		yoffset = ycount*spacing;
		basex = windoworg[0]-xoffset+spacing/2;
		basey = windoworg[2]-yoffset+spacing/2;
		for(x=0;x<xcount*2;x++)
		{
			for(y=0;y<ycount*2;y++)
			{
				xspot = basex+x*spacing;
				yspot = basey+y*spacing;
				point[x][y] = (xspot,windoworg[1],yspot);
			}
		}
	}
	org delete();
	window show();
	if(isdefined(brokenwindow))
	{
		brokenwindow hide();
		brokenwindow notsolid();
	}
	breaktype = self breakwait();
	if(isdefined(brokenwindow))
	{
		brokenwindow show();
	}
	window hide();
	if(breaktype != "smallbreak")  // bigbreak
		direction = maps\_utility::vectormultiply(direction,5);
	for(i=0;i<point.size;i++)
	{
		for(j=0;j<point[i].size;j++)
		{
			playfx(windowfx,point[i][j],direction);

		}
	}
	wait 1;
	window delete();
	self delete();
}

lineto(org1,org2,time)
{
	if(!isdefined(time))
		time = 10000;
	timer = gettime()+time;

	while(gettime()<timer)
	{
		line(org1,org2,(1,0,0),1);
		wait .05;
	}
}

tempspawnthing(org)
{
	thing = spawn("script_model",org);
	thing setmodel ("xmodel/temp");
	wait 4;
	thing delete();
}

breakwait()
{
	totaldamage = 0;
	while(1)
	{
		self waittill ("damage",amount);
		if(amount > 200)
		{
			return ("bigbreak");
		}
		totaldamage += amount;
		if(totaldamage > 300)
			break;

	}
	return ("smallbreak");
}
