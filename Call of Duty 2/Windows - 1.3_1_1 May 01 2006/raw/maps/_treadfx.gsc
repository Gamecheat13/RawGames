main(vehicletype)
{
	//this sets default tread and tire fx for vehicles - they can be overwritten in level scripts
	if (!isdefined (vehicletype))
		return;
	
	switch (vehicletype)
	{
		case "crusader":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
		
		case "tiger":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
		
		case "panzer2":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
		
		case "germanfordtruck":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
		
		case "blitz":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
		
		case "kubelwagon":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
			
		case "jeep":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
		
		case "armoredcar":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
			
		case "germanhalftrack":
			level._effect[vehicletype]["water"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["ice"] =			loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["mud"] =			loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_duhoc.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
			
		case "buffalo":
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =			-1;
			level._effect[vehicletype]["snow"] =		-1;
			level._effect[vehicletype]["dirt"] =		-1;
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		-1;
			level._effect[vehicletype]["cloth"] =		-1;
			level._effect[vehicletype]["sand"] =		-1;
			level._effect[vehicletype]["grass"] =		-1;
			level._effect[vehicletype]["gravel"] =		-1;
			level._effect[vehicletype]["metal"] =		-1;
			level._effect[vehicletype]["mud"] =			-1;
			level._effect[vehicletype]["rock"] =		-1;
			level._effect[vehicletype]["sand"] =		-1;
			level._effect[vehicletype]["wood"] =		-1;
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
			
			
		default: //if the vehicle isn't in this list it will use these effects
			level._effect[vehicletype]["water"] =		-1;
			level._effect[vehicletype]["ice"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["snow"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["dirt"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["asphalt"] =		-1;
			level._effect[vehicletype]["carpet"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["cloth"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["grass"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["gravel"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["metal"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["mud"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["rock"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["sand"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["wood"] =		loadfx("fx/dust/tread_dust_brown.efx");
			level._effect[vehicletype]["brick"] =		-1;
			level._effect[vehicletype]["concrete"] =	-1;
			level._effect[vehicletype]["foliage"] =		-1;
			break;
	}
}

setvehiclefx(vehicletype, material, fx)
{
	if (!isdefined (fx))
		level._effect[vehicletype][material] = -1;
	else
		level._effect[vehicletype][material] = loadfx(fx);
}