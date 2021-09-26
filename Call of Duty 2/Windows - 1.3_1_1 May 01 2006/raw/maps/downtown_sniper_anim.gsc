#using_animtree("generic_human");
main()
{
	level.scr_anim["soldier4"]["ready"]	= (%downtown_sniper_ready);
	level.scr_anim["soldier4"]["loop"][0]	= (%downtown_sniper_loop);
	level.scr_anim["soldier4"]["react"]	= (%downtown_sniper_react);

	level.scr_anim["volsky"]["idle"][0]	= (%downtownsniper_binoculars_scanidle);
	level.scr_anim["volsky"]["idle"][1]	= (%downtownsniper_binoculars_lowerandlook);
	level.scr_anim["volsky"]["idle"][2]	= (%downtownsniper_binoculars_scanupdown);
	level.scr_anim["volsky"]["turnbacktwitch"]	= (%downtownsniper_binoculars_turnbacktwitch);

	level.scrsound["propaganda"]["propaganda1"] = "downtownsniper_gplv_propaganda1";
	level.scrsound["propaganda"]["propaganda2"] = "downtownsniper_gplv_propaganda2";
	level.scrsound["propaganda"]["propaganda3"] = "downtownsniper_gplv_propaganda3";
	level.scrsound["propaganda"]["propaganda4"] = "downtownsniper_gplv_propaganda4";
	level.scrsound["propaganda"]["propaganda5"] = "downtownsniper_gplv_propaganda5";
	level.scrsound["propaganda"]["propaganda6"] = "downtownsniper_gplv_propaganda6";
	level.scrsound["propaganda"]["propaganda7"] = "downtownsniper_gplv_propaganda7";
	level.scrsound["propaganda"]["propaganda8"] = "downtownsniper_gplv_propaganda8";

	level.scr_text["soldier1"]["firstfloorisclear"] = "First floor is clear!";
	level.scrsound["soldier1"]["firstfloorisclear"] = "downtownsniper_rs1_firstfloorisclear";

	level.scr_text["soldier1"]["watchforsnipers"] = "Comrades! Watch out for sni-";
	level.scrsound["soldier1"]["watchforsnipers"] = "downtownsniper_rs1_watchforsnipers";

	level.scr_text["volsky"]["pickuprifle"] = "Vasili, pick up that sniper rifle!";
	level.scrsound["volsky"]["pickuprifle"] = "downtownsniper_volsky_pickuprifle";

	level.scr_text["volsky"]["waitpavel"] = "Good, now wait for Pavel to get the sniper's attention.";
	level.scrsound["volsky"]["waitpavel"] = "downtownsniper_volsky_waitpavel";

	level.scr_text["volsky"]["paveldoit"] = "Pavel... do it.";
	level.scrsound["volsky"]["paveldoit"] = "downtownsniper_volsky_paveldoit";

	level.scr_text["soldier4"]["yescomrade"] = "Yes Comrade.";
	level.scrsound["soldier4"]["yescomrade"] = "downtownsniper_rs4_yescomrade";

	level.scr_text["volsky"]["movewindow"] = "Move to a different position Vasili - the sniper already knows you are there.";
	level.scr_text["volsky"]["movewindow"] = "downtownsniper_volsky_movewindow";
	
	level.scr_text["soldier4"]["hesdead"] = "He's dead…good shot Comrade.";
	level.scrsound["soldier4"]["hesdead"] = "downtownsniper_rs4_hesdead";

	level.scr_text["volsky"]["letsmoveon"] = "Well done Vasili. Now let's move on. We still have to secure the rest of city hall.";
	level.scrsound["volsky"]["letsmoveon"] = "downtownsniper_volsky_letsmoveon";

	level.scr_text["volsky"]["enemyretreating"] = "Look Comrades, the enemy is retreating!!!";
	level.scrsound["volsky"]["enemyretreating"] = "downtownsniper_volsky_enemyretreating";

	level.scr_text["soldier4"]["groundfloorclear"] = "Ground floor is clear!";
	level.scrsound["soldier4"]["groundfloorclear"] = "downtownsniper_rs4_groundfloorclear";

	level.scr_text["volsky"]["topfloorclear"] = "Top floor clear!";
	level.scrsound["volsky"]["topfloorclear"] = "downtownsniper_volsky_topfloorclear";

	level.scr_text["volsky"]["preparecounter"] = "The building is secure Comrades! We must prepare for their counterattack! Take up defensive positions!";
	level.scrsound["volsky"]["preparecounter"] = "downtownsniper_volsky_preparecounter";

	level.scr_text["volsky"]["startingattackloud"] = "THEY'RE STARTING THE ATTAACK!!!";
	level.scrsound["volsky"]["startingattackloud"] = "downtownsniper_volsky_startingattackloud";

	level.scr_text["soldier4"]["heretheycome"] = "Here they cooome!!! Hold this position Comrades!!!";
	level.scrsound["soldier4"]["heretheycome"] = "downtownsniper_rs4_heretheycome";

	level.scr_text["soldier1"]["reinforcementscoming1"] = "Friendly reinforcements are here!";
	level.scrsound["soldier1"]["reinforcementscoming1"] = "downtownsniper_rs1_reinforcementscoming1";

	level.scr_text["soldier1"]["reinforcementscoming2"] = "More friendly reinforcements have arrived!";
	level.scrsound["soldier1"]["reinforcementscoming2"] = "downtownsniper_rs1_reinforcementscoming2";

	level.scr_text["soldier4"]["reinforcementscoming3"] = "Third squad is here to reinforce our position!";
	level.scrsound["soldier4"]["reinforcementscoming3"] = "downtownsniper_rs4_reinforcementscoming3";

	level.scr_text["volsky"]["redbuildingleftloud"] = "MG42 gunner! There! Red building on the left.";
	level.scrsound["volsky"]["redbuildingleftloud"] = "downtownsniper_volsky_redbuildingleftloud";

	level.scr_text["volsky"]["secondfloorleftloud"] = "MG42! Second floor, left building!";
	level.scrsound["volsky"]["secondfloorleftloud"] = "downtownsniper_volsky_secondfloorleftloud";

	level.scr_text["volsky"]["redbldgfourthfloorloud"] = "MG42! Red building, fourth floor!";
	level.scrsound["volsky"]["redbldgfourthfloorloud"] = "downtownsniper_volsky_redbldgfourthfloorloud";

	level.scr_text["volsky"]["graybldgsecondfloorloud"] = "MG42 gunner! Gray building, second floor!";
	level.scrsound["volsky"]["graybldgsecondfloorloud"] = "downtownsniper_volsky_graybldgsecondfloorloud";

	level.scr_text["volsky"]["graybldgmiddlefloorloud"] = "Look! MG42 gunner! Gray building middle floor!";
	level.scrsound["volsky"]["graybldgmiddlefloorloud"] = "downtownsniper_volsky_graybldgmiddlefloorloud";

	level.scr_text["volsky"]["graybldgfourthfloorloud"] = "MG42! Gray building, fourth floor!";
	level.scrsound["volsky"]["graybldgfourthfloorloud"] = "downtownsniper_volsky_graybldgfourthfloorloud";

	level.scr_text["volsky"]["mg42frontlinesloud"] = "The Germans are moving an MG42 to the front lines! Quickly, take it out!";
	level.scrsound["volsky"]["mg42frontlinesloud"] = "downtownsniper_volsky_mg42frontlinesloud";

	level.scr_text["volsky"]["anothermg42loud"] = "Vassili! Another MG42 gunner is trying to deploy in the square!";
	level.scrsound["volsky"]["anothermg42loud"] = "downtownsniper_volsky_anothermg42loud";

	level.scr_text["volsky"]["mg42squareloud"] = "MG42 out in the square!";
	level.scrsound["volsky"]["mg42squareloud"] = "downtownsniper_volsky_mg42squareloud";

	level.scr_text["volsky"]["mg42movingfrontlineloud"] = "MG42 gunner moving to the front line!";
	level.scrsound["volsky"]["mg42movingfrontlineloud"] = "downtownsniper_volsky_mg42movingfrontlineloud";

	level.scr_text["volsky"]["anotherinsquareloud"] = "Another MG42 in the square!";
	level.scrsound["volsky"]["anotherinsquareloud"] = "downtownsniper_volsky_anotherinsquareloud";

	level.scr_text["volsky"]["enemyhalftrackapp"] = "Enemy halftrack approaching!!!";
	level.scrsound["volsky"]["enemyhalftrackapp"] = "downtownsniper_volsky_enemyhalftrackapp";

	level.scr_text["volsky"]["findantitank"] = "Vasili! Find an anti-tank weapon and take it out!";
	level.scrsound["volsky"]["findantitank"] = "downtownsniper_volsky_findantitank";

	level.scrsound["volsky"]["thirdfloorleft"] = "downtownsniper_volsky_thirdfloorleft";
	level.scrsound["volsky"]["redbldgsecondfloor"] = "downtownsniper_volsky_redbldgsecondfloor";
	level.scrsound["volsky"]["leftfourthfloor"] = "downtownsniper_volsky_leftfourthfloor";
	level.scrsound["volsky"]["fourthfloorgray"] = "downtownsniper_volsky_fourthfloorgray";
	level.scrsound["volsky"]["graysecondfloor"] = "downtownsniper_volsky_graysecondfloor";

	level.scr_text["soldier4"]["givingup"] = "The fascists are giving up the fight! ";
	level.scrsound["soldier4"]["givingup"] = "downtownsniper_rs4_givingup";

	level.scr_text["soldier4"]["runcowardshaha"] = "Run you cowards! Ha haaa!!!";
	level.scrsound["soldier4"]["runcowardshaha"] = "downtownsniper_rs4_runcowardshaha";

	level.scr_text["volsky"]["germansfallingback"] = "The Germans are falling back!";
	level.scrsound["volsky"]["germansfallingback"] = "downtownsniper_volsky_germansfallingback";

	level.scr_text["volsky"]["numbersdidntcomeup"] = "Well Vassili. It looks like our numbers didn’t come up today. Not yet, anyways.";
	level.scrsound["volsky"]["numbersdidntcomeup"]		= "downtownsniper_volsky_numbersdidntcomeup";
	level.scr_face["volsky"]["numbersdidntcomeup"]		= %downtownsniper_vsk_sc26_01_t2_head;
/*
	level.scr_text[""][""] = "";
	level.scrsound[""][""] = "";
*/
}