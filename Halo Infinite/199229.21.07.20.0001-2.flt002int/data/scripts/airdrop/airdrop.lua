-- Copyright (c) Microsoft. All rights reserved.
--## SERVER

-- namespace
global AirDrop = {};

hstructure AirDropZone
	location:vector;
	range:number;
end

hstructure AirDropShip
	vehicleDefinition:tag;
	vehicleConfiguration:tag;
	pilotDefinition:tag;
end