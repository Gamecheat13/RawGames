#using_animtree("generic_human");
main()
{
	dialog();

	level.scr_anim["generic"]["nade_throw"]	 		= (%crouch_grenade_throw);
}

dialog()
{
	level.scrsound["randall"]["duhocdefend_rnd_movinginsouth"]	= "duhocdefend_rnd_movinginsouth";
	level.scr_text["randall"]["duhocdefend_rnd_movinginsouth"]	= "Krauts moving in from the souuuuth!!!";
	level.scrsound["randall"]["duhocdefend_rnd_halftrackcover"]	= "duhocdefend_rnd_halftrackcover";
	level.scrsound["randall"]["duhocdefend_rnd_htwestcover"]	= "duhocdefend_rnd_htwestcover";
	level.scr_text["randall"]["duhocdefend_rnd_htwestcover"]	= "Kraut halftrack to the west!! Take cover!!!";
	level.scrsound["randall"]["duhocdefend_rnd_fallbackorchard"]	= "duhocdefend_rnd_fallbackorchard";
	level.scr_text["randall"]["duhocdefend_rnd_fallbackorchard"]	= "Everyone fall back to the orchard! Let's go let's go!!! Get back to the orchard!!";
	level.scrsound["randall"]["duhocdefend_rnd_dropbackorchard"]	= "duhocdefend_rnd_dropbackorchard";
	level.scr_text["randall"]["duhocdefend_rnd_dropbackorchard"]	= "Taylor you too!!! Get back to the orchard, let's go!!";

	level.scr_anim["randall"]["duhocdefend_rnd_corporaltaylor"]	= (%duhocdefend_rnd_sc03_01_t1_head);
	level.scrsound["randall"]["duhocdefend_rnd_corporaltaylor"]	= "duhocdefend_rnd_corporaltaylor";

	level.scrsound["randall"]["duhocdefend_rnd_tryingrightflank"]	= "duhocdefend_rnd_tryingrightflank";
	level.scr_test["randall"]["duhocdefend_rnd_tryingrightflank"]	= "The Krauts are tryin' to move up the right flank! Get over there and stop 'em!!!";
	level.scrsound["randall"]["duhocdefend_rnd_holdtheline"]	= "duhocdefend_rnd_holdtheline";
	level.scr_text["randall"]["duhocdefend_rnd_holdtheline"]	= "Rangers , hold the line!!! Keep up the fire on those Krauts!!!";
	level.scrsound["randall"]["duhocdefend_rnd_mgfarmhouse"]	= "duhocdefend_rnd_mgfarmhouse";
	level.scr_text["randall"]["duhocdefend_rnd_mgfarmhouse"]	= "Corporal Taylor!! Get to the machine gun in the farmhouse window! Cover us so we  can fall back to the village!";
	level.scrsound["randall"]["duhocdefend_rnd_mgisinwindow"]	= "duhocdefend_rnd_mgisinwindow";
	level.scr_text["randall"]["duhocdefend_rnd_mgisinwindow"]	= "Taylor!! The machine gun's up in the window of the farmhouse! Get moving!!!!";
	level.scrsound["randall"]["duhocdefend_rnd_getonmg"]		= "duhocdefend_rnd_getonmg";
	level.scr_text["randall"]["duhocdefend_rnd_getonmg"]		= "Taylor! Get to the machine gun!! Move!!!";
	level.scrsound["randall"]["duhocdefend_rnd_goodwork"]		= "duhocdefend_rnd_goodwork";
	level.scr_text["randall"]["duhocdefend_rnd_goodwork"]		= "Good work Taylor!";
	level.scrsound["randall"]["duhocdefend_rnd_restlater"]		= "duhocdefend_rnd_restlater";
	level.scrsound["randall"]["duhocdefend_rnd_getoutflanked"]	= "duhocdefend_rnd_getoutflanked";
	level.scrsound["randall"]["duhocdefend_rnd_cominginwhen"]	= "duhocdefend_rnd_cominginwhen";
	level.scrsound["randall"]["duhocdefend_rnd_ableoverrun"]	= "duhocdefend_rnd_ableoverrun";
	level.scr_text["randall"]["duhocdefend_rnd_ableoverrun"]	= "Able's been overrun!!! We gotta straighten out the line!!! Pull back to phase line Charlie!! Move move!!!";
	level.scrsound["randall"]["duhocdefend_rnd_keepupcorp"]		= "duhocdefend_rnd_keepupcorp";
	level.scr_text["randall"]["duhocdefend_rnd_keepupcorp"]		= "Taylor!!! Let's go!!! You gotta keep up, Corporal!!!";
	level.scrsound["randall"]["duhocdefend_rnd_taylormove"]		= "duhocdefend_rnd_taylormove";
	level.scrsound["randall"]["duhocdefend_rnd_onfeet"]		= "duhocdefend_rnd_onfeet";
	level.scr_text["randall"]["duhocdefend_rnd_onfeet"]		= "Let's go soldier, on your feet!!!! Move move!!!";
	level.scrsound["randall"]["duhocdefend_rnd_firepower"]		= "duhocdefend_rnd_firepower";
	level.scr_text["randall"]["duhocdefend_rnd_firepower"]		= "Come on Taylor!!! We need all the firepower we can get!!! Stick with the squad, let's go!!!!";
	level.scrsound["randall"]["duhocdefend_rnd_getbackhere"]	= "duhocdefend_rnd_getbackhere";
	level.scr_text["randall"]["duhocdefend_rnd_getbackhere"]	= "Corporal Taylor!!! Where the hell are you going!! Get back here and help us out!!!";
	level.scrsound["randall"]["duhocdefend_rnd_charlie"]		= "duhocdefend_rnd_charlie";
	level.scr_text["randall"]["duhocdefend_rnd_charlie"]		= "The Krauts are gettin' close!!! Lay down suppressing fire and fall back to phase line Charlie!!! GO!!! GO!!";
	level.scrsound["randall"]["duhocdefend_rnd_charlienow"]		= "duhocdefend_rnd_charlienow";
	level.scr_text["randall"]["duhocdefend_rnd_charlienow"]		= "Taylor!! Back to phase line Charlie!!! NOW!!!! Move! Move!!!";
	level.scrsound["randall"]["duhocdefend_rnd_watchtunnel"]	= "duhocdefend_rnd_watchtunnel";
	level.scr_text["randall"]["duhocdefend_rnd_watchtunnel"]	= "Rangers, watch that bunker tunnel to the rear!! Don't let the Krauts through!!!";
	level.scrsound["randall"]["duhocdefend_rnd_lastline"]		= "duhocdefend_rnd_lastline";
	level.scr_text["randall"]["duhocdefend_rnd_lastline"]		= "This is our last - line - of - defense!!! No - falling - back!!!";
	level.scrsound["randall"]["duhocdefend_rnd_popsmoke"]		= "duhocdefend_rnd_popsmoke";
	level.scr_text["randall"]["duhocdefend_rnd_popsmoke"]		= "Taylor!!! Deploy green smoke on the roof of the bunker!!! Make sure the flyboys know we're still here!!!";
	level.scrsound["randall"]["duhocdefend_rnd_bombevery"]		= "duhocdefend_rnd_bombevery";
	level.scr_text["randall"]["duhocdefend_rnd_bombevery"]		= "Corporal Taylor!!! Deploy green smoke on the roof of the bunker!!!  They'll bomb everything in sight if they don't know where we are!!! Move!!!";
	level.scrsound["randall"]["duhocdefend_rnd_before"]		= "duhocdefend_rnd_before";
	level.scr_text["randall"]["duhocdefend_rnd_before"]		= "Taylor!!! Deploy green smoke on that bunker!!! Hurry, before the planes get here!!!";
	level.scrsound["randall"]["duhocdefend_rnd_wheresmoke"]		= "duhocdefend_rnd_wheresmoke";
	level.scr_text["randall"]["duhocdefend_rnd_wheresmoke"]		= "Dammit Taylor, where's that green smoke!!!???? Hurry!!";

	level.scrsound["braeburn"]["duhocdefend_bra_igotthrough"]	= "duhocdefend_bra_igotthrough";
	level.scr_text["braeburn"]["duhocdefend_bra_igotthrough"]	= "Sarge! I got through! The boys at Omaha Beach are on the way! We also got some flyboys coming in over the Channel!";
	level.scrsound["braeburn"]["duhocdefend_bra_aboutfivemin"]	= "duhocdefend_bra_aboutfivemin";
	level.scr_text["braeburn"]["duhocdefend_bra_aboutfivemin"]	= "About five minutes sir!";

	level.scrsound["ranger"]["duhocdefend_gr3_krautssouth"]		= "duhocdefend_gr3_krautssouth";
	level.scrsound["ranger"]["duhocdefend_gr4_krautsupsouthroad"]	= "duhocdefend_gr4_krautsupsouthroad";
	level.scrsound["ranger"]["duhocdefend_gr1_pushinginsouth"]	= "duhocdefend_gr1_pushinginsouth";
	level.scrsound["ranger"]["duhocdefend_gr1_halftrackcomingthru"]	= "duhocdefend_gr1_halftrackcomingthru";
	level.scrsound["ranger"]["duhocdefend_gr3_infantryfromwest"]	= "duhocdefend_gr3_infantryfromwest";
	level.scrsound["ranger"]["duhocdefend_gr4_infantryfromwest"]	= "duhocdefend_gr4_infantryfromwest";
	level.scrsound["ranger"]["duhocdefend_gr5_krautcompany"]	= "duhocdefend_gr5_krautcompany";
	level.scrsound["ranger"]["duhocdefend_gr6_krautcompany"]	= "duhocdefend_gr6_krautcompany";
	level.scrsound["ranger"]["duhocdefend_gr9_gertankseast"]	= "duhocdefend_gr9_gertankseast";
	level.scr_text["ranger"]["duhocdefend_gr9_gertankseast"]	= "German tanks movin' in from the east!";
	level.scrsound["ranger"]["duhocdefend_gr3_pullingback"]		= "duhocdefend_gr3_pullingback";
	level.scrsound["ranger"]["duhocdefend_gr1_germanwestflank"]	= "duhocdefend_gr1_germanwestflank";
	level.scrsound["ranger"]["duhocdefend_gr2_westflank"]		= "duhocdefend_gr2_westflank";
	level.scrsound["ranger"]["duhocdefend_gr5_acrossroad"]		= "duhocdefend_gr5_acrossroad";
	level.scrsound["ranger"]["duhocdefend_gr1_holysmokes"]		= "duhocdefend_gr1_holysmokes";
	level.scrsound["ranger"]["duhocdefend_gr1_incoming"]		= "duhocdefend_gr1_incoming";
	level.scrsound["ranger"]["duhocdefend_gr2_takecover"]		= "duhocdefend_gr2_takecover";
	level.scrsound["ranger"]["duhocdefend_gr2_fieldoffire"]		= "duhocdefend_gr2_fieldoffire";
	level.scrsound["ranger"]["duhocdefend_gr4_getouttathere"]	= "duhocdefend_gr4_getouttathere";
	level.scrsound["ranger"]["duhocdefend_gr2_fallbackpositions"]	= "duhocdefend_gr2_fallbackpositions";
	level.scrsound["ranger"]["duhocdefend_gr1_penetrationsouth"]	= "duhocdefend_gr1_penetrationsouth";
	level.scrsound["ranger"]["duhocdefend_gr1_germansleftflank"]	= "duhocdefend_gr1_germansleftflank";
	level.scrsound["ranger"]["duhocdefend_gr2_germans"]		= "duhocdefend_gr2_germans";
	level.scrsound["ranger"]["duhocdefend_gr3_movingfromeast"]	= "duhocdefend_gr3_movingfromeast";
	level.scrsound["ranger"]["duhocdefend_gr1_30caleastflank"]	= "duhocdefend_gr1_30caleastflank";	// ?
	level.scrsound["ranger"]["duhocdefend_gr2_eastflank"]		= "duhocdefend_gr2_eastflank";		// ?
	level.scrsound["ranger"]["duhocdefend_gr1_holdup"]		= "duhocdefend_gr1_holdup";
	level.scrsound["ranger"]["duhocdefend_gr2_holdhere"]		= "duhocdefend_gr2_holdhere";
	level.scrsound["ranger"]["duhocdefend_gr3_60setup"]		= "duhocdefend_gr3_60setup";
	level.scrsound["ranger"]["duhocdefend_gr3_lockandload"]		= "duhocdefend_gr3_lockandload";
	level.scrsound["ranger"]["duhocdefend_gr4_checkyourammo"]	= "duhocdefend_gr4_checkyourammo";
	level.scrsound["ranger"]["duhocdefend_gr5_getready"]		= "duhocdefend_gr5_getready";
	level.scrsound["ranger"]["duhocdefend_gr6_thisisit"]		= "duhocdefend_gr6_thisisit";
	level.scrsound["ranger"]["duhocdefend_gr1_heretheycome"]	= "duhocdefend_gr1_heretheycome";
	level.scrsound["ranger"]["duhocdefend_gr2_pushingsouth"]	= "duhocdefend_gr2_pushingsouth";
	level.scrsound["ranger"]["duhocdefend_gr5_tookthefarm"]		= "duhocdefend_gr5_tookthefarm";
	level.scrsound["ranger"]["duhocdefend_gr6_tookthefarm"]		= "duhocdefend_gr6_tookthefarm";
	level.scrsound["ranger"]["duhocdefend_gr1_germansleftflank"]	= "duhocdefend_gr1_germansleftflank";
	level.scrsound["ranger"]["duhocdefend_gr3_movingfromeast"]	= "duhocdefend_gr3_movingfromeast";
	level.scrsound["ranger"]["duhocdefend_gr3_germantroopseast"]	= "duhocdefend_gr3_germantroopseast";
	level.scrsound["ranger"]["duhocdefend_gr4_germantroopseast"]	= "duhocdefend_gr4_germantroopseast";
	level.scrsound["ranger"]["duhocdefend_gr5_comingfromeast"]	= "duhocdefend_gr5_comingfromeast";
	level.scrsound["ranger"]["duhocdefend_gr6_comingfromeast"]	= "duhocdefend_gr6_comingfromeast";
	level.scrsound["ranger"]["duhocdefend_gr5_brokenthruable"]	= "duhocdefend_gr5_brokenthruable";
	level.scr_text["ranger"]["duhocdefend_gr5_brokenthruable"]	= "The Krauts have broken through rally point Able! We're getting' outflanked, we gotta displace!!!";
	level.scrsound["ranger"]["duhocdefend_gr1_howdoyoulike"]	= "duhocdefend_gr1_howdoyoulike";
	level.scrsound["ranger"]["duhocdefend_gr1_ablecompany"]		= "duhocdefend_gr1_ablecompany";
	level.scrsound["ranger"]["duhocdefend_gr2_bakercharlie"]	= "duhocdefend_gr2_bakercharlie";
	level.scrsound["ranger"]["duhocdefend_gr2_ddtanks"]		= "duhocdefend_gr2_ddtanks";
	level.scrsound["ranger"]["duhocdefend_gr3_guardsintersection"]	= "duhocdefend_gr3_guardsintersection";
	level.scrsound["ranger"]["duhocdefend_gr3_clearfarm"]		= "duhocdefend_gr3_clearfarm";
	level.scrsound["ranger"]["duhocdefend_gr4_getmerunner"]		= "duhocdefend_gr4_getmerunner";
	level.scrsound["ranger"]["duhocdefend_gr4_getmedichere"]	= "duhocdefend_gr4_getmedichere";
	level.scrsound["ranger"]["duhocdefend_gr5_signallamp"]		= "duhocdefend_gr5_signallamp";
	level.scrsound["ranger"]["duhocdefend_gr5_keepmoving"]		= "duhocdefend_gr5_keepmoving";
	level.scrsound["ranger"]["duhocdefend_gr6_checkroadblock"]	= "duhocdefend_gr6_checkroadblock";
	level.scrsound["ranger"]["duhocdefend_rnd_giveshout"]		= "duhocdefend_rnd_giveshout";
	level.scr_text["ranger"]["duhocdefend_rnd_giveshout"]		= "We've got this area covered Taylor, get back to the other end. We'll give you a shout if the Krauts try to flank this side.";


	level.scrsound["ranger"]["duhocdefend_gr9_nextphase"]		= "duhocdefend_gr9_nextphase";
	level.scr_text["ranger"]["duhocdefend_gr9_nextphase"]		= "Let's go, let's go!!! Get yer butt over back to the next phase line!! Move!!! Everyone fall back to Charlie!!!";
	level.scrsound["ranger"]["duhocdefend_gr5_thrutunnels"]		= "duhocdefend_gr5_thrutunnels";
	level.scr_text["ranger"]["duhocdefend_gr5_thrutunnels"]		= "They're comin through the bunker tunnel!!!  Watch the last bunker on the Pointe!!!";
	level.scrsound["ranger"]["duhocdefend_gr9_thrutunnelsbig"]	= "duhocdefend_gr9_thrutunnelsbig";
	level.scr_text["ranger"]["duhocdefend_gr9_thrutunnelsbig"]	= "They're - comin - through - the -  bunker tunnel!!!!!!!  Bunker on the Pointe!!! Watch your back!!!!";
	level.scrsound["ranger"]["duhocdefend_gr5_holdtheline"]		= "duhocdefend_gr5_holdtheline";
	level.scr_text["ranger"]["duhocdefend_gr5_holdtheline"]		= "HOLD THE LIIIIINE!!!!!!";
	level.scrsound["ranger"]["duhocdefend_gr9_holdpointe"]		= "duhocdefend_gr9_holdpointe";
	level.scr_text["ranger"]["duhocdefend_gr9_holdpointe"]		= "Give 'em all you got!!!! Stand your ground!!!!";
	level.scrsound["ranger"]["duhocdefend_gr5_whereflyboys"]	= "duhocdefend_gr5_whereflyboys";
	level.scr_text["ranger"]["duhocdefend_gr5_whereflyboys"]	= "Where the hell are those flyboys!!????";
	level.scrsound["ranger"]["duhocdefend_gr5_moretunnel"]		= "duhocdefend_gr5_moretunnel";
	level.scr_text["ranger"]["duhocdefend_gr5_moretunnel"]		= "Heads uuup!!! More Krauts comin' through the bunker tunnellll!!!!";
	level.scrsound["ranger"]["duhocdefend_gr9_morekrauts"]		= "duhocdefend_gr9_morekrauts";
	level.scr_text["ranger"]["duhocdefend_gr9_morekrauts"]		= "We got more Krauts in the tunnel!!! Someone get back there and guard the rear!!!";

	level.scrsound["german"]["duhocdefend_gi1_secondcompany"]	= "duhocdefend_gi1_secondcompany";
	level.scrsound["german"]["duhocdefend_gi4_battalion"]		= "duhocdefend_gi4_battalion";
	level.scrsound["german"]["duhocdefend_gi3_threemenflank"]	= "duhocdefend_gi3_threemenflank";
	level.scrsound["german"]["duhocdefend_gi2_lieutenant"]		= "duhocdefend_gi2_lieutenant";
	level.scrsound["german"]["duhocdefend_gi4_takecover"]		= "duhocdefend_gi4_takecover";
	level.scrsound["german"]["duhocdefend_gi3_gogogo"]		= "duhocdefend_gi3_gogogo";
	level.scrsound["german"]["duhocdefend_gi3_openfire"]		= "duhocdefend_gi3_openfire";
	level.scrsound["german"]["duhocdefend_gi2_needcover"]		= "duhocdefend_gi2_needcover";
	level.scrsound["german"]["duhocdefend_gi4_southroad"]		= "duhocdefend_gi4_southroad";
	level.scrsound["german"]["duhocdefend_gi1_firstgroup"]		= "duhocdefend_gi1_firstgroup";
	level.scrsound["german"]["duhocdefend_gi1_forward"]		= "duhocdefend_gi1_forward";
	level.scrsound["german"]["duhocdefend_gi1_forward"]		= "duhocdefend_gi1_forward";
	level.scrsound["german"]["duhocdefend_gi2_forward"]		= "duhocdefend_gi2_forward";
}
