#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_gamelogic;
#include maps\mp\bots\_bots_util;
#include maps\mp\bots\_bots_strategy;
#include maps\mp\bots\_bots_personality;

//=======================================================
//		Place Holder
//=======================================================
main()
{
	setup_callbacks();
}

setup_callbacks()
{
	level.default_squadmate_think = level.agent_funcs["squadmate"]["think"];
	level.agent_funcs["squadmate"]["think"] = ::agent_squadmember_dom_think;
	level.agent_funcs["player"]["think"] = ::agent_player_dom_think;
}

agent_player_dom_think()
{
	self thread maps\mp\bots\_bots_gametype_dom::bot_dom_think();
}

agent_squadmember_dom_think()
{
	self notify( "bot_dom_think" );
	self endon(  "bot_dom_think" );

	self endon( "death" );
	self endon( "disconnect" );
	level endon( "game_ended" );
	
	while(1)
	{
		should_perform_default_think = true;
		
		owner_flag = undefined;
		foreach( trigger in self.owner.touchTriggers )
		{
			if ( trigger.useobj.id == "domFlag" )
				owner_flag = trigger;
		}
		
		if ( IsDefined(owner_flag) )
		{
			owner_flag_team = owner_flag maps\mp\gametypes\dom::getFlagTeam();
			if ( owner_flag_team != self.team )
			{
				if ( !self maps\mp\bots\_bots_gametype_dom::bot_is_capturing_flag( owner_flag ) )
					self maps\mp\bots\_bots_gametype_dom::capture_flag(owner_flag, "critical");
				
				should_perform_default_think = false;
			}
		}
		
		if ( should_perform_default_think )
			self [[ level.default_squadmate_think ]]();
		
		wait(0.05);
	}
}