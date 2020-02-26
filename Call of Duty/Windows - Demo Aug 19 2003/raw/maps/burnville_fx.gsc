main()
{
	precacheFX();
    spawnWorldFX();    
}

precacheFX()
{
    level._effect["fireheavysmoke"]		= loadfx ("fx/fire/fireheavysmoke.efx");
    level._effect["flameout"]			= loadfx ("fx/tagged/flameout.efx");      
    level._effect["medfire"]			= loadfx ("fx/fire/tinybon.efx"); 
    level._effect["smallbon"]			= loadfx ("fx/fire/smallbon.efx"); 
    level._effect["medFireTop"]			= loadfx ("fx/fire/medFireTop.efx"); 
    level._effect["bigFireTop"]			= loadfx ("fx/fire/medFireTop.efx"); 
    level._effect["smallFire"]			= loadfx ("fx/fire/smallFireWindow.efx"); 
    level._effect["smallFireWindow"]	= loadfx ("fx/fire/smallbon.efx");
    level._effect["antiair_tracers"]	= loadfx ("fx/atmosphere/antiair_tracers.efx");
    level._effect["antiair_tracerscloseup"]	= loadfx ("fx/atmosphere/antiair_tracers.efx");
    level._effect["cloudflash1"]		= loadfx ("fx/atmosphere/cloudflash1.efx");
    level._effect["longrangeflash_altocloud"]	= loadfx ("fx/atmosphere/longrangeflash_altocloud.efx");
    level._effect["distantfire"]		= loadfx ("fx/fire/distantfire.efx");
    level._effect["flash2flak"]			= loadfx ("fx/atmosphere/flash2flak.efx");
    level._effect["flash2flak2"]		= loadfx ("fx/atmosphere/flash2flak2.efx");
    level._effect["distant88s"]			= loadfx ("fx/atmosphere/distant88s.efx");
    level._effect["smoke1"]			= loadfx ("fx/smoke/smokecurtain.efx");
    level._effect["smoke2"]			= loadfx ("fx/smoke/firesmoke_col2.efx");
    level._effect["smoke3"]			= loadfx ("fx/smoke/firesmoke_col1.efx");
    level._effect["smoke_window"]			= loadfx ("fx/smoke/windowsmoke_col1.efx");
    level._effect["smoke"]			= loadfx ("fx/smoke/underlitsmoke.efx");
    level._effect["firesmall"]			= loadfx ("fx/fire/firesmall.efx");
    level._effect["shootdrop1"]			= loadfx ("fx/atmosphere/shootdrop1.efx");
    level._effect["c47flyover2d"]		= loadfx ("fx/atmosphere/c47flyover2d.efx");
    level._effect["lowlevelburst"]		= loadfx ("fx/atmosphere/lowlevelburst.efx");
    level._effect["fireWall"]			= loadfx ("fx/fire/extreme_butwide3.efx");
    level._effect["rooffire"]			= loadfx ("fx/fire/tinybon.efx");
    level._effect["lowFire"]			= loadfx ("fx/fire/em_fire1.efx");
    level._effect["fireWall2"]			= loadfx ("fx/fire/extreme_butwide2.efx");
    level._effect["fireWall3"]			= loadfx ("fx/fire/firewallfacade.efx");
    level._effect["fireWall3a"]			= loadfx ("fx/fire/firewallfacade_x.efx");
    level._effect["fireWall1"]			= loadfx ("fx/fire/firewallfacade_1.efx");
      
}


spawnWorldFX()
{
     
      maps\_fx::loopfx("smallbon", (-828, -18233, 115), 0.3);
      maps\_fx::loopfx("medfire", (-284, -17039, 225), 0.3);
      maps\_fx::loopfx("medfire", (-411, -17020, 175), 0.2);
      maps\_fx::loopfx("medfire", (-90, -14757, -22), 0.3);
      maps\_fx::loopfx("medfire", (-573, -14953, -71), 0.3);
      maps\_fx::loopfx("smallbon", (-686, -17114, 14), 0.3);
      maps\_fx::loopfx("smallbon", (3071, -15910, 126), 0.4);
      maps\_fx::loopfx("medfire", (1596, -15276, -106), 0.3);
      maps\_fx::loopfx("smallbon", (-701, -18361, 128), 0.3); 
      maps\_fx::loopfx("smallbon", (-1183, -17403, 15), 0.3);
      maps\_fx::loopfx("smallbon", (31, -16989, 220), 0.3);

	maps\_fx::loopfx("smallbon", (2725, -14916, 36), 0.3);
	maps\_fx::loopfx("medfire", (2169, -15715, -45), 0.3);
	maps\_fx::loopfx("smallbon", (959, -14741, -75), 0.3);
	maps\_fx::loopfx("smallbon", (99, -15281, -56), 0.2);
	maps\_fx::loopfx("smoke1", (1293, -16833, 274), 0.3);
	maps\_fx::loopfx("smoke1", (-596, -17111, 345), 0.3);
	maps\_fx::loopfx("smoke2", (87, -15284, 75), 0.3);
	maps\_fx::loopfx("smoke1", (2714, -14921, 114), 0.3);
	maps\_fx::loopfx("smoke1", (2060, -16287, 68), 0.3);
	
	maps\_fx::loopfx("smoke2", (400, -15674, 0), 0.3);
	maps\_fx::loopfx("smallbon", (402, -15698, -72), 0.3);

      maps\_fx::loopfx("smoke1", (868, -18498, 226), 0.3);
      maps\_fx::loopfx("fireWall2", (873, -18552, 193), 0.2);
      
      maps\_fx::loopfx("smoke2", (1556, -16402, 245), 0.3);
      maps\_fx::loopfx("smoke1", (2454, -17347, 484), 0.3);
      maps\_fx::loopfx("smoke1", (30, -17001, 286), 0.3);
      maps\_fx::loopfx("smoke", (203, -16781, 200), 0.1);
      maps\_fx::loopfx("smoke", (-2766, -16958, 76), 0.1);
      maps\_fx::loopfx("smoke3", (-701, -18361, 200), 0.2);
      maps\_fx::loopfx("smoke", (-824, -18227, 130), 0.1);
      maps\_fx::loopfx("smoke", (-1190, -17381, 86), 0.1);
      maps\_fx::loopfx("smoke3", (1612, -15260, -46), 0.2);
      maps\_fx::loopfx("smoke3", (2165, -15718, -60), 0.2);
      maps\_fx::loopfx("smoke", (-570, -14944, -62), 0.1);
      maps\_fx::loopfx("smoke", (961, -14749, -8), 0.2);
      maps\_fx::loopfx("smoke_window", (1323, -17085, 78), 0.2);//end of level window smoke
      maps\_fx::loopfx("smoke_window", (1186, -17082, 98), 0.2);//end of level window smoke
      maps\_fx::loopfx("smoke", (147, -16274, 223), 0.2);
      maps\_fx::loopfx("smoke", (101, -16284, 171), 0.2);
      maps\_fx::loopfx("fireWall3a", (2480, -17343, 234), 0.4);
      maps\_fx::loopfx("lowFire", (1285, -16939, 22), 0.3);
      maps\_fx::loopfx("lowFire", (1307, -16855, 122), 0.4);
      maps\_fx::loopfx("rooffire", (-844, -16967, 212), 0.4);
      maps\_fx::loopfx("smallbon", (2080, -16289, -29), 0.3);
      maps\_fx::loopfx("lowFire", (1570, -16400, -36), 0.4);
      maps\_fx::loopfx("lowFire", (1570, -16400, 79), 0.3);
      maps\_fx::loopfx("lowFire", (-632, -17107, 179), 0.3);
      
      maps\_fx::loopSound("medfire", (443, -15679, -3), undefined);
      maps\_fx::loopSound("medfire", (115, -16278, 137), undefined); //church roof fire
      maps\_fx::loopSound("medfire", (2159, -15706, -63), undefined);
      maps\_fx::loopSound("medfire", (1616, -15265, -78), undefined);
      maps\_fx::loopSound("medfire", (959, -14747, -25), undefined);
      maps\_fx::loopSound("medfire", (-91, -14756, -32), undefined);
      maps\_fx::loopSound("medfire", (-560, -14943, -48), undefined);
      maps\_fx::loopSound("medfire", (114, -15283, 0), undefined);
      
      maps\_fx::loopSound("bigfire", (898, -18551, 120), undefined);
      maps\_fx::loopSound("bigfire", (-705, -18352, 120), undefined);
      maps\_fx::loopSound("bigfire", (-1178, -17390, 65), undefined);
      maps\_fx::loopSound("bigfire", (-648, -17097, 131), undefined);
      maps\_fx::loopSound("bigfire", (1581, -16398, -3), undefined);
      maps\_fx::loopSound("bigfire", (1295, -16904, 84), undefined);
      maps\_fx::loopSound("bigfire", (39, -16989, 197), undefined);




/*
    maps\_fx::loopfx("medFire", (-701, -18361, 148), 0.3);
    maps\_fx::loopfx("medFireTop", (222, -16778, 234), 0.5);
    maps\_fx::loopSound("medfire", (222, -16778, 234), 7.7);
    maps\_fx::loopfx("smallFire", (-1162, -17363, 93), 0.3);
    // maps\_fx::loopSound("smallfire", (-1162, -17363, 93), 5.3);
    maps\_fx::loopfx("medFireTop", (-806, -18246, 163), 0.5);
    // maps\_fx::loopSound("medfire", (-806, -18246, 163), 7.7);
    maps\_fx::loopfx("bigFireTop", (-558, -17123, 218), 0.8);
    // maps\_fx::loopSound("bigfire", (-558, -17123, 218), 10.3);
    maps\_fx::loopfx("smallFireWindow", (1149.734985, -16797.556641, 189.330968), 0.3);
    maps\_fx::loopSound("smallfire", (1149.734985, -16797.556641, 189.330968), 5.3);
    maps\_fx::loopfx("firesmoke", (-558, -17123, 218), 0.4);
    maps\_fx::loopfx("firesmoke", (-806, -18246, 163), 0.4);
    maps\_fx::loopfx("firesmoke", (-701, -18361, 148), 0.4);
    maps\_fx::loopfx("smallFireWindow", (-261, -17003, 194), 0.3);
    maps\_fx::loopfx("smallFireWindow", (99, -16272, 196), 0.3);
    maps\_fx::loopfx("smallFireWindow", (2042, -16248, -60), 0.3);
    maps\_fx::loopfx("smallFireWindow", (1585, -15243, -68), 0.3);
    maps\_fx::loopfx("smallFireWindow", (-100, -14750, -23), 0.3);
    maps\_fx::loopSound("medfire", (-100, -14750, -23), 7.7);
    maps\_fx::loopfx("fireheavysmoke", (2753, -14926, 1), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (1572, -16385, -25), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (1776, -16339, -5), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (1102, -14809, -85), 0.3);
    maps\_fx::loopSound("medfire", (1102, -14809, -85), 7.7);
    maps\_fx::loopfx("fireheavysmoke", (-81, -14764, -23), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (135, -15207, -30), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (391, -15685, -54), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (1287, -16970, 49), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (752, -18699, 66), 0.3);
    maps\_fx::loopfx("fireheavysmoke", (-1240, -17229, 46), 0.3);
    maps\_fx::loopfx("animfire", (2153, -15729, -70), 1.3);
    //maps\_fx::loopfx("beamfire", (129, -16218, 125), 1.00);
    // level._effect["beamfire"]			= loadfx ("fx/fire/beamfire.efx");
*/

    maps\_fx::gunfireLoopfx("antiair_tracers", (5025, -14265, 227),
							1, 4,
							5.2, 3.4,
							3.2, 4.5);
    maps\_fx::gunfireLoopfx("antiair_tracers", (4025, -14265, 227),
							2, 4,
							9.2, 4.4,
							1.2, 4.5);
    maps\_fx::gunfireLoopfx("antiair_tracers", (-4932, -16709, 300),
							2, 3,
							5.1,6.4,
							2.1, 5.3);
    maps\_fx::gunfireLoopfx("antiair_tracers", (687, -13553, 144),
							2, 3,
							5.1,6.4,
							2.1, 5.3);
    maps\_fx::gunfireLoopfx("longrangeflash_altocloud", (-4287, -16109, 137),
											      1, 2,
											    10, 60,
										            10, 40);
    maps\_fx::gunfireLoopfx("longrangeflash_altocloud", (2170, -12886, 137),
											      1, 2,
											    10, 60,
										            5, 40);
    maps\_fx::gunfireLoopfx("longrangeflash_altocloud", (385, -13049, 377),
											      1, 2,
											    10, 60,
										            5, 40);

    maps\_fx::gunfireLoopfx("flash2flak", (-1156, -13252, 2694),
											      4, 8,
											    2.5, 3.6,
										            5, 20);
    maps\_fx::gunfireLoopfx("flash2flak2", (-3470, -13920, 2400),
											      3, 6,
											    0.2, 1.5,
										            5, 10);
    maps\_fx::gunfireLoopfx("flash2flak2", (762, -16389, 4543),
											      3, 6,
											    0.2, 1.5,
										            5, 20);
    maps\_fx::gunfireLoopfx("distant88s", (5711, -19112, 700),
											      4, 10,
											    10, 30,
										            15, 40);
    maps\_fx::gunfireLoopfx("distant88s", (5025, -14529, 900),
											      3, 8,
											    10, 30,
										            15, 40);
    maps\_fx::gunfireLoopfx("distant88s", (-4105, -14695, 600),
											      3, 8,
											    10, 30,
										            15, 40);
    maps\_fx::gunfireLoopfx("distant88s", (-3932, -16709, 700),
											      3, 8,
											    10, 30,
										            15, 40);
    maps\_fx::gunfireLoopfx("lowlevelburst", (-4932, -14709, 3100),
											      3, 8,
											    1, 3,
										            1, 4);
    maps\_fx::gunfireLoopfx("lowlevelburst", (-2335, -14149, 1394),
											      3, 8,
											    1, 3,
										            1, 4);
    maps\_fx::gunfireLoopfx("lowlevelburst", (444, -13344, 741),
											      3, 8,
											    0.1, 3,
										            1,2);


	/*
    maps\_fx::OneShotfx("shootdrop1", (5414, -15694, 4591),35);
    maps\_fx::OneShotfx("shootdrop1", (588, -13823, 2644),60);
    maps\_fx::OneShotfx("shootdrop1", (-1940, -22317, 2727),25);
    maps\_fx::OneShotfx("shootdrop1", (-1774, -15364, 1348),90);
    maps\_fx::OneShotfx("shootdrop1", (5414, -15694, 4591),180);
    maps\_fx::OneShotfx("c47flyover2d", (794, -23852, 827),3);
    maps\_fx::OneShotfx("c47flyover2d", (-2110, -21943, 447),21);
    maps\_fx::OneShotfx("c47flyover2d", (3851, -19836, 584),31);
    maps\_fx::OneShotfx("c47flyover2d", (5414, -15694, 4591),180);
    maps\_fx::OneShotfx("c47flyover2d", (794, -23852, 827),280);
   
    // Stacked on top of another - just a test
    maps\_fx::loopfx("medFire", (175.241379, -16753.492188, 221.960189), 0.5);
    */
}
