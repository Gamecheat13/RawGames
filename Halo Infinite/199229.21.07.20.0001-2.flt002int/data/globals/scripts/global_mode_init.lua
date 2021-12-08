-- Copyright (C) Microsoft. All rights reserved.

REQUIRES('globals/scripts/callbacks/GlobalCallbacks.lua')

--## SERVER
global GlobalModeInitData:table =
{
	Slayer =
	{
		DefaultArgs =
			hmake SlayerInitArgs
			{
				instanceName = "Slayer",
			},
	},
}
