//
#include clientscripts\mp\_fx;
#include clientscripts\mp\_utility;
#include clientscripts\mp\_music;

#insert raw\common_scripts\utility.gsh;

main()
{
	level thread wait_for_teleport_aftereffect();
	
	waitforallclients();

	level.portal_effect = level._effect["zombie_pentagon_teleporter"];
	
	players = getlocalplayers();
	for ( i = 0; i < players.size; i++ )
	{
		players[i] thread teleporter_fx_setup(i);
		players[i] thread teleporter_fx_cool_down(i);
	}
}

//-------------------------------------------------------------------------------
//	DCS 091510: setting up portal fx with client flags.
//-------------------------------------------------------------------------------
teleporter_fx_setup(ClientNum)
{
	teleporters = GetEntArray(ClientNum, "pentagon_teleport_fx", "targetname");
	level.fxents[ClientNum] = [];
	level.packtime[ClientNum] = true;

	for ( i = 0; i < teleporters.size; i++ )
	{
		fx_ent = Spawn(ClientNum,teleporters[i].origin,"script_model");
		fx_ent SetModel("tag_origin");
		fx_ent.angles = teleporters[i].angles;
		
		ARRAY_ADD(level.fxents[ClientNum], fx_ent);
	}
}

teleporter_fx_init(ClientNum, set, newEnt)
{
	fx_array = level.fxents[ClientNum];
	
	if ( set &&  level.packtime[ClientNum] == true)
	{
		println("*** Client : regular portal fx on. ", ClientNum);
		level.packtime[ClientNum] = false;

		for ( i = 0; i < fx_array.size; i++ )
		{
			if(IsDefined(fx_array[i].portalfx))
			{
				deletefx(ClientNum, fx_array[i].portalfx);
			}

			wait(0.01);
			fx_array[i].portalfx = PlayFXOnTag(ClientNum,level.portal_effect, fx_array[i],"tag_origin" );
			PlaySound( ClientNum, "evt_teleporter_start", fx_array[i].origin );
			fx_array[i] PlayLoopSound( "evt_teleporter_loop", 1.75 );
		}
	}
}

//-------------------------------------------------------------------------------
teleporter_fx_cool_down(ClientNum)
{

	while(true)
	{
		
		level waittill("cool_fx", ClientNum);

		players = GetLocalPlayers();

		if(level.packtime[ClientNum] == false)
		{
			// find closest possible current fx point.
			fx_pos = undefined;
			closest = 512;				
	
			for ( i = 0; i < level.fxents[ClientNum].size; i++ )
			{
				if(IsDefined(level.fxents[ClientNum][i]))
				{
					if(closest > Distance(level.fxents[ClientNum][i].origin, players[ClientNum].origin))
					{
						closest = Distance(level.fxents[ClientNum][i].origin, players[ClientNum].origin);
						fx_pos = level.fxents[ClientNum][i];
					}
				}
			}
	
			if(IsDefined(fx_pos)&& IsDefined(fx_pos.portalfx))
			{
				deletefx(ClientNum, fx_pos.portalfx);
				fx_pos.portalfx = PlayFXOnTag(ClientNum,level._effect["zombie_pent_portal_cool"], fx_pos,"tag_origin" );			
				
				self thread turn_off_cool_down_fx(fx_pos, ClientNum);
				
			}
		}	
		wait(0.1);
	}		
}

turn_off_cool_down_fx(fx_pos, ClientNum)
{
	fx_pos thread cool_down_timer();
	fx_pos waittill("cool_down_over");

	if(IsDefined(fx_pos) && IsDefined(fx_pos.portalfx))
	{
		deletefx(ClientNum, fx_pos.portalfx);
		if(level.packtime[ClientNum] == false)
		{
			fx_pos.portalfx = PlayFXOnTag(ClientNum,level.portal_effect, fx_pos,"tag_origin" );
		}
	}	
}

cool_down_timer()
{
	time = 0;
	self.defcon_active = false;
	self thread pack_cooldown_listener();
	while(!self.defcon_active && time < 20 )
	{
		wait(1);
		time++;
	}	
	self notify("cool_down_over");
}

pack_cooldown_listener()
{
	self endon ("cool_down_over");
	
	level waittill("end_cool_downs");
	self.defcon_active = true;
}				
//-------------------------------------------------------------------------------
wait_for_teleport_aftereffect()
{
	while( true )
	{
		level waittill( "ae1", ClientNum );
		
		VisionSetNaked( ClientNum, "flare", 0.4 );
	}
}

