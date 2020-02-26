#include common_scripts\utility;
#include maps\mp\_utility;
init()
{	
	precacheitem("baseweapon_mms_mp");
	setdvar("cg_rangeFinderActiveWidth", "460");
	setdvar("cg_rangeFinderActiveHeight", "320");
	setdvar("cg_airburstlasetime", "0.2");
	setdvar("cg_airbrustlaseflashtime", "0.25");
	
	setdvar("bg_chargeShotDischargeWhenQueueReachesMax", true);
	setdvar("bg_chargeShotAutoDischargeDelay", "5000");
	setdvar("bg_chargeShotDamageIncreasePerBullet", "1.3");
	setdvar("bg_chargeShotViewKickIncreasePerBullet", "0.5");
	setdvar("bg_chargeShotQueueTime", "350");

	
	setdvar("cg_sonarAttachmentFov", "50");
	setdvar("cg_sonarAttachmentMaxDist", "1000");
	setdvar("cg_sonarAttachmentMaxSpeed", "1.5");
	setdvar("cg_sonarAttachmentFadeFriendlies", "0");
	setdvar("cg_sonarAttachmentDistanceFactor", "3");
	setdvar("cg_sonarAttachmentSpeedDelay", "0.6");
	setdvar("cg_sonarAttachmentBlur", "1.5");

	setdvar("shieldImpactBulletShakeScale",       "0.25");
	setdvar("riotshield_bullet_damage_scale",     "0.025");
	setdvar("riotshield_melee_damage_scale",      "1");
	setdvar("riotshield_explosive_damage_scale",  "0.75");
	setdvar("riotshield_projectile_damage_scale", "0.001");
	setdvar("riotshield_deployed_health",          "300");
	setdvar("riotshield_destroyed_cleanup_time",    "15");
	
	setdvar("riotshield_placement_trace_boxdims", "32 32 30");
	setdvar("riotshield_placement_collmap_dims", "11 16 30");
	
	setdvar("riotshield_deploy_pitch_max", 				"20");
	setdvar("riotshield_deploy_roll_max", 				"25");
	setdvar("riotshield_deploy_limit_radius",			"100");
	setdvar("riotshield_deploy_zdiff_max",				"30");
}