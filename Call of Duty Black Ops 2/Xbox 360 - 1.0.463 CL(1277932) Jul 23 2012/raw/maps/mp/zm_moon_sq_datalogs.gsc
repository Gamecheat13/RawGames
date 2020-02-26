/* zombie_moon_sq_datalogs.gsc
 *
 * Purpose : 	Sidequest logic for audio datalogs.
 *		
 * 
 * Author : 	Dan L
 * 
 */

#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\zombies\_zm_utility; 
#include maps\mp\zombies\_zm_sidequests;


init()
{
	datalogs = array(	"vox_story_2_log_1", 
										"vox_story_2_log_2", 
										"vox_story_2_log_3", 
										"vox_story_2_log_4", 
										"vox_story_2_log_5", 
										"vox_story_2_log_6");
	
	datalogs_delay = [];
	datalogs_delay["vox_story_2_log_1"] = 40;
	datalogs_delay["vox_story_2_log_2"] = 28;
	datalogs_delay["vox_story_2_log_3"] = 29;
	datalogs_delay["vox_story_2_log_4"] = 52;
	datalogs_delay["vox_story_2_log_5"] = 37;
	datalogs_delay["vox_story_2_log_6"] = 138;
										

	i = 0;
	
	datalog_locs = getstructarray("sq_datalog", "targetname");
	player = getstruct("sq_reel_to_reel", "targetname");
	
	datalog_locs = array_randomize(datalog_locs);
	
	while(i < datalogs.size)
	{
		log_struct = datalog_locs[0];
		
		log = Spawn("script_model", log_struct.origin);
		if(IsDefined(log_struct.angles))
		{
			log.angles = log_struct.angles;
		}
		log SetModel("p_glo_data_recorder01_static_reel");
//t6todo		log thread fake_use("pickedup");
		
		log waittill("pickedup", who);
		who._has_log = true;
		log Delete();
		who add_sidequest_icon("sq", "datalog");		
		
//t6todo		player thread fake_use("placed", ::log_qualifier);
		player waittill("placed", who);
	
		who._has_log = undefined;
		who remove_sidequest_icon("sq", "datalog");
		
		sound_ent = Spawn("script_origin", player.origin);
		
		sound_ent PlaySound( datalogs[i], "sounddone" ); 
		sound_ent playloopsound( "vox_radio_egg_snapshot", 1 );
		wait( datalogs_delay[datalogs[i]] );
		sound_ent stoploopsound( 1 );
		
		i++;
		
		datalog_locs = array_remove(datalog_locs, log_struct );
		datalog_locs = array_randomize(datalog_locs);
	}	
}

log_qualifier()
{
	if(IsDefined(self._has_log))
	{
		return true;
	}
	
	return false;
}