#using_animtree("generic_human");
main()
{
	thread dialogue();
	thread wounded_animations();
}

dialogue()
{
	level.scr_text["randall"]["hill400_defend_rnd_intro1"]	= "Dog Company listen up. We're the only ones left - everyone else is either dead or wounded.";
	level.scrsound["randall"]["hill400_defend_rnd_intro1"]	= "hill400_defend_rnd_intro1";
	
	level.scr_text["randall"]["hill400_defend_rnd_intro2"] 	= "Battalion has promised to relieve us soon, but I wouldn't hold my breath, until we get some --(interrupted)";
	level.scrsound["randall"]["hill400_defend_rnd_intro2"]	= "hill400_defend_rnd_intro2";

	//hill400_defend_countatkannounce - "German counterattack!!!" - O.S.
	//hill400_defend_countatkannounce - "Counterattack!!!"	- O.S.

	level.scr_text["randall"]["hill400_defend_rnd_mortarteams1"] 	= "Taylor! Get out there and take out those Kraut mortar teams!  Everyone else, get to your stations, MOVE!!";
	level.scrsound["randall"]["hill400_defend_rnd_mortarteams1"]	= "hill400_defend_rnd_mortarteams1";
	level.scr_face["randall"]["hill400_defend_rnd_mortarteams1"]	= (%silotownassault_rnd_sc01_02_t1_head); 
	
	level.scr_text["randall"]["hill400_defend_rnd_securedoor"] 	= "Carter, wait for 1st squad to move out, then secure the main door!";
	level.scrsound["randall"]["hill400_defend_rnd_securedoor"]	= "hill400_defend_rnd_securedoor";	
	level.scr_face["randall"]["hill400_defend_rnd_securedoor"]	= (%bergstein_rnd_sc10_02_t4_head); //silotownassault_rnd_sc08_03_t1_head
	
	level.scr_text["carter"]["hill400_defend_gr9_yessir"] 	= "Yes sir!";
	level.scrsound["carter"]["hill400_defend_gr9_yessir"]		= "hill400_defend_gr9_yessir";	
	level.scr_face["carter"]["hill400_defend_gr9_yessir"]		= (%bergstein_rnd_sc10_03_t2_head);	
	
	level.scr_text["randall"]["hill400_defend_rnd_mortarteams2"] 	= "Don't let the Krauts get into this bunker! We got a lotta wounded in here!!";
	level.scrsound["randall"]["hill400_defend_rnd_mortarteams2"]	= "hill400_defend_rnd_mortarteams2";	
	level.scr_face["randall"]["hill400_defend_rnd_mortarteams2"]	= (%bergstein_rnd_sc10_02_t4_head); //toujaneride_pri_sc04_01_t2_head
	
	level.scr_text["randall"]["hill400_defend_rnd_wounded"] 	= "McCloskey, give me a hand with these men!";
	level.scrsound["randall"]["hill400_defend_rnd_wounded"]		= "hill400_defend_rnd_wounded";	

	level.scr_text["mccloskey"]["hill400_defend_mcc_whoareguys"] 	= "McCloskey: Who are those guys, Sarge?";
	level.scrsound["mccloskey"]["hill400_defend_mcc_whoareguys"]	= "hill400_defend_mcc_whoareguys";
	level.scr_face["mccloskey"]["hill400_defend_mcc_whoareguys"]	= (%bergstein_rnd_sc10_01_t3_head);

	level.scr_text["randall"]["hill400_defend_rnd_guardianangels"] 	= "Guardian angels, McCloskey. P-51 Mustangs, and not a blessed moment too soon...Great job guys, we did it.";
	level.scrsound["randall"]["hill400_defend_rnd_guardianangels"]	= "hill400_defend_rnd_guardianangels";	
	//level.scr_face["randall"]["hill400_defend_rnd_guardianangels"]	= (%silotownassault_rnd_sc01_05_t1_head);
	level.scr_anim["randall"]["hill400_defend_rnd_guardianangels_anim"] = (%bergstein_end_dialogue);

	level.scr_anim["randall"]["final_scene_idle"][0] = (%patrolstand_idle);

	level.ambientChatter = [];

	//Germans Attacking During Mortars
	
	index = 0;
	
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi1_morterteam"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi2_ammunition"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi2_dontgoaround"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi2_thosefour"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi2_firstandthird"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi3_spreadout"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index] 	= "hill400_defend_gi1_fatherland"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index] 	= "hill400_defend_gi1_gonostopping"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi2_mgnest"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi3_mortar"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi3_followme"; index++;
	level.scrsound["axis_chatter"]["duringmortars"][index]	= "hill400_defend_gi3_halftracksnorthwest"; index++;

	level.ambientChatter["axis_chatter"]["duringmortars"] = index;	

	//Germans Second Wave Start
	
	index = 0;
	
	level.scrsound["axis_chatter"]["secondwavestart"][index]	= "hill400_defend_gi3_forward"; index++;
	level.scrsound["axis_chatter"]["secondwavestart"][index] 	= "hill400_defend_gi1_keytodefense"; index++;
	
	level.ambientChatter["axis_chatter"]["secondwavestart"] = index;
	
	//Germans Second Wave During Attack
	
	index = 0;
	
	level.scrsound["axis_chatter"]["secondwaveattack"][index] 	= "hill400_defend_gi1_killtheamericans"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi1_dontstop"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi1_dieswine"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi1_keepadvancing"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi1_youstupidpig"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi2_ineedmen"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi2_goaroundright"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi3_contactcommander"; index++;
	level.scrsound["axis_chatter"]["secondwaveattack"][index]	= "hill400_defend_gi3_minefield"; index++;
	
	level.ambientChatter["axis_chatter"]["secondwaveattack"] = index;
	
	//Germans Third Wave Stars
	
	index = 0;
	
	level.scrsound["axis_chatter"]["thirdwavestart"][index]	= "hill400_defend_gi3_attack"; index++;
	level.scrsound["axis_chatter"]["thirdwavestart"][index]	= "hill400_defend_gi2_manymen"; index++;
	
	level.ambientChatter["axis_chatter"]["thirdwavestart"] = index;
	
	//Germans Third Wave During Attack
	
	index = 0;
	
	level.scrsound["axis_chatter"]["thirdwaveattack"][index] 	= "hill400_defend_gi1_circletotheright"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index] 	= "hill400_defend_gi1_takethishill"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi2_rightflank"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi2_coveringfire"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index] 	= "hill400_defend_gi1_makethempay"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi2_american"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi2_bringyourmen"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi2_keepfiring"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi2_donthide"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index] 	= "hill400_defend_gi1_americansarelosing"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi3_inposition"; index++;
	level.scrsound["axis_chatter"]["thirdwaveattack"][index]	= "hill400_defend_gi3_eastridge"; index++;
	
	level.ambientChatter["axis_chatter"]["thirdwaveattack"] = index;
	
	//Germans Third Wave During Attack When Tanks Are Around
	
	index = 0;
	
	level.scrsound["axis_chatter"]["thirdwavetanks"][index]	= "hill400_defend_gi3_attackleftflank"; index++;
	level.scrsound["axis_chatter"]["thirdwavetanks"][index] = "hill400_defend_gi1_openfire"; index++;
	level.scrsound["axis_chatter"]["thirdwavetanks"][index]	= "hill400_defend_gi3_stuckinmud"; index++;
	
	level.ambientChatter["axis_chatter"]["thirdwavetanks"] = index;
	
	//Bunker In Danger (player in the fuzzy zone)
	
	index = 0;
	
	level.scrsound["axis_chatter"]["bunkerdanger"][index]	= "hill400_defend_gi3_rushbunker"; index++;
	level.scrsound["axis_chatter"]["bunkerdanger"][index]	= "hill400_defend_gi3_takenoprisoners"; index++;
	level.scrsound["axis_chatter"]["bunkerdanger"][index]	= "hill400_defend_gi3_flankbunker"; index++;
	level.scrsound["axis_chatter"]["bunkerdanger"][index]	= "hill400_defend_gi3_suppressingfire"; index++;
	level.scrsound["axis_chatter"]["bunkerdanger"][index] 	= "hill400_defend_gi1_clearthatbunker"; index++;
	
	level.ambientChatter["axis_chatter"]["bunkerdanger"] = index;
	
	//Germans Dying
	
	index = 0;
	
	level.scrsound["axis_chatter"]["dying"][index] 	= "hill400_defend_gi1_medic"; index++;
	level.scrsound["axis_chatter"]["dying"][index] 	= "hill400_defend_gi1_helpmedic"; index++;	
	level.scrsound["axis_chatter"]["dying"][index]	= "hill400_defend_gi2_ahhhh"; index++;
	level.scrsound["axis_chatter"]["dying"][index]	= "hill400_defend_gi2_nein"; index++;
	level.scrsound["axis_chatter"]["dying"][index]	= "hill400_defend_gi3_mother"; index++;
	level.scrsound["axis_chatter"]["dying"][index] 	= "hill400_defend_gi3_needmedic"; index++;
	
	level.ambientChatter["axis_chatter"]["dying"] = index;
	
	//Germans Retreating
	
	index = 0;
	
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi2_whatthehell"; index++;
	level.scrsound["axis_chatter"]["retreat"][index] 	= "hill400_defend_gi2_airplane"; index++;
	level.scrsound["axis_chatter"]["retreat"][index] 	= "hill400_defend_gi2_damnplanes"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi2_airsupport"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi2_thehill"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi1_enemyaircraft"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi1_watchoutplanes"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi1_havetoretreat"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi1_thisishopeless"; index++;	
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi3_pullback"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi3_gofirstcompany"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi3_thirdplatoon"; index++;
	level.scrsound["axis_chatter"]["retreat"][index]	= "hill400_defend_gi3_stretcherbearers"; index++;
	
	level.ambientChatter["axis_chatter"]["retreat"] = index;
	
	//Americans at End of Each Attack Wave 1
	
	index = 0;
	
	//"Don't let down! They're testing our defenses!! The real attack's about to come!!"
	level.scrsound["allies_chatter"]["prebarrage1"][index] 	= "hill400_defend_waveprep1"; index++;
	
	//"Let’s move it people! Gather weapons and ammo!"
	level.scrsound["allies_chatter"]["prebarrage1"][index] 	= "hill400_defend_gr1_gatherweapons"; index++;

	//"That was just the first group! They'll bring up a second wave any minute now!! Reload and gather weapons and ammo!!"
	level.scrsound["allies_chatter"]["prebarrage1"][index] 	= "hill400_defend_justfirstgroup"; index++;
	
	level.ambientChatter["allies_chatter"]["prebarrage1"] = index;
	
	//Americans at End of Each Attack Wave 2
	
	index = 0;
	
	//"Listen up!!! Reinforcements are on the way!! E.T.A. five minutes!!!"
	level.scrsound["allies_chatter"]["prebarrage2"][index] 	= "hill400_defend_fiveminutes1"; index++;
	
	//"Reinforcements in five!!! Hang in there!!!"
	level.scrsound["allies_chatter"]["prebarrage2"][index] 	= "hill400_defend_fiveminutes2"; index++;
	
	//"Gather weapons and ammo!! Reload your weapons!!!"
	level.scrsound["allies_chatter"]["prebarrage2"][index] 	= "hill400_defend_waveprep2"; index++;
	
	//"Use enemy weapons if you’re outta ammo! Use whatever ya got!"
	level.scrsound["allies_chatter"]["prebarrage2"][index] 	= "hill400_defend_gr1_useenemyweapons"; index++;
	
	level.ambientChatter["allies_chatter"]["prebarrage2"] = index;
	
	//Americans Artillery Barrage Warnings 1
	
	index = 0;
	
	//"Get to your foxholes! Get to your foxholes!"
	level.scrsound["allies_incoming"]["barragecover1"][index]	= "hill400_defend_gr2_gettoyourfoxholes"; index++;
	
	//"Find some cover!!! Take cover!!!"
	level.scrsound["allies_incoming"]["barragecover1"][index]	= "hill400_defend_gr2_findsomecover"; index++;
	
	//"INCOMING!!!!!!"
	level.scrsound["allies_incoming"]["barragecover1"][index]	= "hill400_defend_gr1_incoming"; index++;

	level.ambientChatter["allies_incoming"]["barragecover1"] = index;
	
	//Americans Artillery Barrage Warnings 2

	index = 0;
	
	//"More Kraut artilleryyy!!! Take coverrr!!!!"
	level.scrsound["allies_incoming"]["barragecover2"][index]	= "hill400_defend_morearty"; index++;
	
	//"Artillery barrage!!! Take cover!!!"
	level.scrsound["allies_incoming"]["barragecover2"][index]	= "hill400_defend_barrage1"; index++;
	
	//"Everyone get to cover!! Move!!! Get to cover!!!!"
	level.scrsound["allies_incoming"]["barragecover2"][index]	= "hill400_defend_barrage2"; index++;
	
	level.ambientChatter["allies_incoming"]["barragecover2"] = index;

	//Braeburn's special warnings

	level.scrsound["braeburn"]["taylortakecover"]	= "hill400_defend_bra_taylortakecover";
	level.scrsound["braeburn"]["notgonnalast"]		= "hill400_defend_bra_notgonnalast";
	
	//Americans Post Barrage Moving Out	
	
	level.scrsound["braeburn"]["herewego"]			= "hill400_defend_bra_herewego";
	//++++DIALOGUE need more go go go type of stuff from generic Rangers
	
	//Americans Fighting Third Wave
	
	index = 0;
	
	//level.scrsound["allies_chatter"]["thirdwave"][index] 	= "hill400_defend_gr1_outta30cal"; index++;
	level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr4_displacesecondsquad"; index++;
	//level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr5_wevelostcomms"; index++;
	level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr5_simmonsboyd"; index++;
	level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr4_keepittogether"; index++;
	level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr4_imout"; index++;
	//level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr3_outta30cal"; index++;
	//level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr3_changebarrels"; index++;
	level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr4_targetsacrossroad"; index++;
	level.scrsound["allies_chatter"]["thirdwave"][index]	= "hill400_defend_gr1_keepfiring"; index++;
	
	level.ambientChatter["allies_chatter"]["thirdwave"] = index;
	
	//Americans Fighting Late Third Wave Music Kicks In
	
	index = 0;
	
	level.scrsound["allies_chatter"]["thirdwavelate"][index]	= "hill400_defend_gr4_whosgotbandolier"; index++;
	level.scrsound["allies_chatter"]["thirdwavelate"][index]	= "hill400_defend_gr1_standyourground"; index++;
	//level.scrsound["allies_chatter"]["thirdwavelate"][index] 	= "hill400_defend_gr3_takemybar"; index++;
	level.scrsound["allies_chatter"]["thirdwavelate"][index] 	= "hill400_defend_gr3_ahhh"; index++;
	level.scrsound["allies_chatter"]["thirdwavelate"][index] 	= "hill400_defend_gr3_imhit"; index++;
	level.scrsound["allies_chatter"]["thirdwavelate"][index] 	= "hill400_defend_gr6_pullback"; index++;
	level.scrsound["allies_chatter"]["thirdwavelate"][index] 	= "hill400_defend_gr6_wasteyourammo"; index++;

	level.ambientChatter["allies_chatter"]["thirdwavelate"] = index;

	//Americans Are In Bad Shape Near End of Third Wave

	index = 0;

	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr6_medicaaagh"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr5_medicaaaagh"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr7_medicaargh"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr6_tothatbunker"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr6_no"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr8_medicaaagh"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr2_medic"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr2_hermansdown"; index++;
	level.scrsound["allies_chatter"]["medicscream"][index] 	= "hill400_defend_gr2_andersonshit"; index++;
	
	level.ambientChatter["allies_chatter"]["medicscream"] = index;
	
	//Germans Retreat
	
	index = 0;
	
	level.scrsound["allies_chatter"]["victory"][index] 		= "hill400_defend_gr7_givingupfight"; index++;
	level.scrsound["allies_chatter"]["victory"][index] 		= "hill400_defend_gr8_theyhadenough"; index++;
	//++++FIND OUTlevel.scrsound["allies_chatter"]["victory"][index] 		= "hill400_defend_gr6_rightkeeprunn"; index++;
	
	level.ambientChatter["allies_chatter"]["victory"] = index;
	
	index = 0;
	
	level.scrsound["allies_chatter"]["tankarrival"][index]	= "hill400_defend_gr1_tankstooclose"; index++;
	
	level.ambientChatter["allies_chatter"]["tankarrival"] = index;
}

#using_animtree("duhoc_wounded");
wounded_animations()
{
	level.scr_animtree["wounded"] = #animtree;
	
	//laying down, arm on chest (head pointed direction of node)
	level.scr_anim["wounded"]["chest"][0]			= %wounded_chestguy_idle;
	level.scr_anim["wounded"]["chestweight"][0]		= 6;
	level.scr_anim["wounded"]["chest"][1]			= %wounded_chestguy_twitch;
	level.scr_anim["wounded"]["chestweight"][1]		= 1;
	level.scr_anim["wounded"]["chest"][2]			= %wounded_chestguy_twitch;
	level.scr_anim["wounded"]["chestweight"][2]		= 1;
	
	level.scrsound["wounded"]["chest"][1]			= "rs1_painedgroan1";
	level.scrsound["wounded"]["chest"][2]			= "rs1_painedgroan2";
	level.scrsound["wounded"]["chest"][2]			= "rs1_painedgroan3";
	
	//laying down, knees bent, holding groin (feet pointed direction of node)
	level.scr_anim["wounded"]["groin"][0]			= %wounded_groinguy_idle;
	level.scr_anim["wounded"]["groinweight"][0]		= 6;
	level.scr_anim["wounded"]["groin"][1]			= %wounded_groinguy_twitch;
	level.scr_anim["wounded"]["groinweight"][1]		= 1;
	level.scr_anim["wounded"]["groin"][2]			= %wounded_groinguy_twitch;
	level.scr_anim["wounded"]["groinweight"][2]		= 1;
	
	level.scrsound["wounded"]["groin"][1]			= "rs2_painedgroan1";
	level.scrsound["wounded"]["groin"][2]			= "rs2_painedgroan2";
	level.scrsound["wounded"]["groin"][2]			= "rs2_painedgroan3";
	
	//laying down, grasping neck (head pointed direction of node)
	level.scr_anim["wounded"]["neck"][0]			= %wounded_neckguy_idle;
	level.scr_anim["wounded"]["neckweight"][0]		= 6;
	level.scr_anim["wounded"]["neck"][1]			= %wounded_neckguy_twitch;
	level.scr_anim["wounded"]["neckweight"][1]		= 1;
	
	level.scrsound["wounded"]["neck"][1]			= "rs1_painedgroan1";
	level.scrsound["wounded"]["neck"][1]			= "rs1_painedgroan2";
	level.scrsound["wounded"]["neck"][1]			= "rs1_painedgroan3";
	
	//laying down on side almost fetal position (head pointed direction of node)
	level.scr_anim["wounded"]["side"][0]			= %wounded_sideguy_idle;
	level.scr_anim["wounded"]["sideweight"][0]		= 6;
	level.scr_anim["wounded"]["side"][1]			= %wounded_sideguy_twitch;
	level.scr_anim["wounded"]["sideweight"][1]		= 1;
	
	level.scrsound["wounded"]["side"][1]			= "rs2_painedgroan1";
	level.scrsound["wounded"]["side"][1]			= "rs2_painedgroan2";
	level.scrsound["wounded"]["side"][1]			= "rs2_painedgroan3";
	
	//sitting upright, hand on chest (facing 10:30)
	level.scr_anim["wounded"]["sitting"][0]			= %brecourt_woundedman_idle;
}

/*

	level.scrsound["allies_chatter"][index] 				= "hill400_defend_gr6_wasamedic"; index++;
	
	level.scr_text["randall"]["hill400_defend_rnd_dogfive"]			= "Dog Five, this is Dog Three, over.";
	level.scrsound["randall"]["hill400_defend_rnd_dogfive"]			= "hill400_defend_rnd_dogfive";
	level.scr_text["braeburn"]["dogthree"]			= "Dog Three, this is Dog Five! Go ahead!";
	level.scrsound["braeburn"]["dogthree"]			= "hill400_defend_bra_dogthree";
	level.scr_text["braeburn"]["rogerout"]			= "Roger! Out!";
	level.scrsound["braeburn"]["rogerout"]			= "hill400_defend_bra_rogerout";
	level.scr_text["braeburn"]["gotowork"]			= "Time to go to work! Sarge reports halftracks coming in from the south!";
	level.scrsound["braeburn"]["gotowork"]			= "hill400_defend_bra_gotowork";

	level.scrsound["braeburn"]["vehicles0"]				= "hill400_defend_bra_advancingfromsouth";
	level.scrsound["braeburn"]["vehicles1"]				= "hill400_defend_bra_krautsfromwest";
	level.scrsound["braeburn"]["vehicles2"]				= "hill400_defend_bra_halftrackswest";
	level.scrsound["braeburn"]["vehicles3"]				= "hill400_defend_bra_tankstoeast";
		
	level.scrsound["braeburn"]["takecover"]			= "hill400_defend_braeburn_takecover";
	level.scr_text["randall"]["getbackhere"]		= "Get back heeere! Get to your foxholes!! Move! Move!! Get outta there!!!";
	level.scrsound["randall"]["getbackhere"]		= "hill400_defend_rnd_getbackhere";
	level.scr_text["randall"]["gettocover"]			= "Get back heeere!! Get to coverrrr!!! Move! Move! Get outta the open!!!";
	level.scrsound["randall"]["gettocover"]			= "hill400_defend_rnd_gettocover";
	level.scr_text["braeburn"]["moveit"]			= "Move it Taylor!!! We gotta get -";
	level.scrsound["braeburn"]["moveit"]			= "hill400_defend_braeburn_moveit";
*/
