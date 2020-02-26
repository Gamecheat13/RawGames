
#include maps\mp\_utility;

busInit()
{
	assert(level.clientscripts);

	level.busState = "";
	registerClientSys("busCmd");

	//setBusState("map_load");
}

setBusState(state)
{
	if(level.busState != state)
		setClientSysState("busCmd", state );
	level.busState = state;
}