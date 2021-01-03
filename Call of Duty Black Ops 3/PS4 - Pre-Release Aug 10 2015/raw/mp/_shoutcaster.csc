#using scripts\codescripts\struct;

#using scripts\shared\system_shared;

#namespace shoutcaster;





function is_shoutcaster(localClientNum)
{
		return IsShoutcaster(localClientNum);
}

function get_team_color_id( localClientNum, team )
{
	if ( team == "allies" )
	{
		return GetShoutcasterSetting(localClientNum, "shoutcaster_fe_team1_color" );
	}
	
	return GetShoutcasterSetting(localClientNum, "shoutcaster_fe_team2_color" );
}

function get_team_color_fx( localClientNum, team, script_bundle )
{
	color = get_team_color_id( localClientNum, team );
	return 	script_bundle.objects[color].fx_colorid;
}

function get_color_fx( localClientNum, script_bundle )
{
	effects = [];
	effects["allies"] = get_team_color_fx( localClientNum, "allies", script_bundle );
	effects["axis"] = get_team_color_fx( localClientNum, "axis", script_bundle );
	return 	effects;
}

function is_friendly( localClientNum )
{
	localplayer = getlocalplayer( localClientNum );
	
	scorepanel_flipped = GetShoutcasterSetting(localClientNum, "shoutcaster_flip_scorepanel" );
	
	if ( !scorepanel_flipped )
		friendly = ( self.team == "allies" );	
	else
		friendly = ( self.team == "axis" );
	
	return friendly;
}