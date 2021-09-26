#using_animtree("generic_human");
main(model)
{
	level.tankai_loadanims[model] = ::loadanims;
}

loadanims()
{
	waittillframeend;
	level.scr_animtree["tankriders"] = #animtree;
	
	if (!isdefined (self.animname))
		self.animname = ("tankrider" + self.tankanimNumber);
	
	//crusader
	switch (self.tankanimNumber)
	{
		case 0:
			//tank commander animation
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy0_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy0_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_tankride_guy0_leanleft);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_tankride_guy0_leanright);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy0_closehatch);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_up10);
			break;
		case 1:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy3_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy3_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_Tankride_guy1_leanleft);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_Tankride_guy1_leanright);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_tankride_guy3_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy1_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_forward13);
			break;
		case 2:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy2_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy2_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_tankride_guy2_leanright);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_tankride_guy2_leanleft);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy2_jumptocombatrun);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_tankride_guy2_reactiontwitch);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_back13);
			break;
		case 3:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy3_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy3_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_tankride_guy3_leanforward);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_tankride_guy3_leanback);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_tankride_guy3_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy3_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_left11);
			break;
		case 4:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_Tankride_guy4_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_Tankride_guy4_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_Tankride_guy4_leanleft);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_Tankride_guy4_leanright);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_Tankride_guy4_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy4_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_forward13);
			break;
		case 5:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy3_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy3_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_tankride_guy3_leanback);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_tankride_guy3_leanforward);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_tankride_guy3_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy3_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_right13);
			break;
		case 6:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy6_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy6_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_tankride_guy6_leanright);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_tankride_guy6_leanleft);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_tankride_guy6_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy6_jumptocombatrun);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_back13);
			break;
		case 7:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_tankride_guy3_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_tankride_guy3_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_tankride_guy3_leanback);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_Tankride_guy4_leanleft);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_tankride_guy3_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy3_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_left11);
			break;
		case 8:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_Tankride_guy4_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_Tankride_guy4_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_Tankride_guy4_leanleft);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_Tankride_guy4_leanright);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_Tankride_guy4_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy1_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_forward13);
			break;
		case 9:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_Tankride_guy4_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_Tankride_guy4_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_Tankride_guy1_leanleft);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_Tankride_guy1_leanright);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_Tankride_guy4_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy1_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_right13);
			break;
		case 10:
			level.scr_anim[self.animname]["tankidle"]		= (%crusader_Tankride_guy4_driving_idle);
			level.scr_anim[self.animname]["tanktwitch"]		= (%crusader_Tankride_guy4_lookingaround);
			level.scr_anim[self.animname]["leanleft"]		= (%crusader_Tankride_guy1_leanleft);
			level.scr_anim[self.animname]["leanright"]		= (%crusader_Tankride_guy1_leanright);
			level.scr_anim[self.animname]["reaction"]		= (%crusader_Tankride_guy4_reactiontwitch);
			level.scr_anim[self.animname]["jumpoff"]		= (%crusader_tankride_guy1_combatdismount);
			level.scr_anim[self.animname]["blowup"]			= (%death_explosion_back13);
			break;
	}
}
