	

busInit()
{
	level.activeBusState = "";
	level.nextBusState = "";
	level.busStates = [];

	registerDefaults();

	thread updateBus(true);

	thread busSaveWait();

	clientscripts\_utility::registerSystem("busCmd", ::busCmdHandler);
}

busSaveWait()
{
	for(;;)
	{
		level waittill("save_restore");

		if(level.nextBusState == "")
			level.nextBusState = level.activeBusState;
		level.activeBusState = "";

		if(level.nextBusState == "")
		{ //force back to level default if none has been specified
			busStateDeactivate();
			busStateActivate("slow_on");
		}

		println("resetting bus state to "+level.nextBusState);

		thread updateBus(false);
	}
}


busCmdHandler(clientNum, state, oldState)
{
	if(clientNum != 0)
	{
		return;
	}

	level.nextBusState = state;

	println("bussing debug: got state '"+state+"'");
	
	level notify("new_bus");
}


setBusState(state)
{
	level.nextBusState = state;

	println("bussing debug: set state '"+state+"'");
	
	level notify("new_bus");
}


updateBus(forcefade)
{
	level endon("save_restore");

	if(forcefade)
	{
		busStateDeactivate();
		busStateActivate("immediate_off");

		wait(1.0);

		busStateDeactivate();
		busStateActivate("slow_on");
	}

	while(1)
	{
		if(level.activeBusState == level.nextBusState) //state didn't change during transition
		{
			level waittill("new_bus");
		}
		
		println("got bus change current'"+level.activeBusState+"' next '"+level.nextBusState+"'");

		if(level.activeBusState == level.nextBusState) //got same one twice, ignore
		{
			continue;
		}
		assert(isdefined(level.nextBusState));
		assert(isdefined(level.activeBusState));

		busStateDeactivate();

		next = level.nextBusState; //save since this state could change while we are activating

		if(next != "")
		{
			busStateActivate(next);
		}

		level.activeBusState = next;
	}
}


busStateActivate(name)
{
	println("activating bus '"+name+"'");

	state = level.busStates[name];

	if(!isdefined(state))
	{
		println("invalid bus state '"+name+"'");
		return;
	}

	assert(isdefined(state.time));

//	setBusFadeTime(state.time);

	keys = getArrayKeys( state.levels );

	assert(isdefined(keys));
	
//	for( i = 0 ; i < keys.size ; i ++ )
//	{
//		setBusVolume(keys[i],state.levels[keys[i]]);		
//	}
}


busStateDeactivate()
{
	println("deactivating bus ");

//	setBusFadeTime(.5);
	
//	for(i=0; i<GetBusCount(); i++)
//	{
//		setBusVolume(GetBusName(i),1.0);
//	}
}


declareBusState(name)
{
	if ( !isdefined( level.busStates ) )
	{
		return;
	}

	level.busDeclareName = name;

	if ( isdefined( level.busStates[name] ) )
	{
		return;
	}

	level.busStates[name] = spawnStruct();
	level.busStates[name].time = 0.5;
	level.busStates[name].levels = [];

}

busVolume(busname, value)
{
	level.busStates[level.busDeclareName].levels[busname] = value;
}


busFadeTime(time)
{
	level.busStates[level.busDeclareName].time = time;
}


busIsIn(bus, names)
{
	for(j=0; j<names.size; j++)
	{
		if(bus == names[j])
		{
			return true;
		}
	}
	return false;
}


busVolumes(names, value)
{
	for(j=0; j<names.size; j++)
	{
		busVolume(names[j], value);
	}
}


busVolumeAll(value)
{
//	for(i=0; i<GetBusCount(); i++)
//	{
//		busVolume(GetBusName(i),value);
//	}
}


argsAsDict(a,b,c,d,e,f,g,h,i)
{
	//icky but good syntax for the user
	names = [];

	if(isdefined(a))
		names[0] = a;
	if(isdefined(b))
		names[1] = b;
	if(isdefined(c))
		names[2] = c;
	if(isdefined(d))
		names[3] = d;
	if(isdefined(e))
		names[4] = e;
	if(isdefined(f))
		names[5] = f;
	if(isdefined(g))
		names[6] =  g;
	if(isdefined(h))
		names[7] =  h;
	if(isdefined(i))
		names[8] = i;
	return names;
}


busVolumesExcept(a,b,c,d,e,f,g,h,i)
{
	
	args = argsAsDict(a,b,c,d,e,f,g,h,i);
	
	value = args[args.size-1];
	names = [];
	
	for(i = 0; i<args.size-1; i++)
		names[i] = args[i];

//	for(i=0; i<GetBusCount(); i++)
//	{
//		name = GetBusName(i);
//		if(!busIsIn(GetBusName(i), names))
//		{
//			busVolume(name, value);
//		}
//	}
	
}


registerDefaults()
{
	declareBusState("map_load");
	busFadeTime(.25);
	busVolumesExcept("music", "ui", 0);

	declareBusState("map_start");
	busFadeTime(1);
	busVolumeAll(1);

	declareBusState("default");
	busFadeTime(.25);
	busVolumeAll(1);

	declareBusState("all_off");
	busVolumeAll(0);

	declareBusState("map_end");
	busFadeTime(2);
	busVolumesExcept("music", "ui", 0);
	
	declareBusState("last_stand_start");
	busFadeTime(0.1);
	busVolumesExcept("full_vol", "ui", 0.6);
	
	declareBusState("last_stand_duration");
	busFadeTime(29.9);
	busVolumesExcept("full_vol", "ui", 0.05);

	declareBusState("immediate_off");
	busFadeTime(.01);
	busVolumesExcept( "ui", 0.0);

	declareBusState("slow_on");
	busVolumesExcept( "ui", 1.0);
	busFadeTime(1);

	declareBusState("zombie_death");
	busvolumesexcept("music", 0.0);
	busfadetime(10);


}


