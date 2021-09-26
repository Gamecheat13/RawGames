main()
{	
	if (getcvar("duhoc_writedata") == "")
		setcvar("duhoc_writedata","0");
	if (getcvarint("duhoc_writedata") > 0)
	{
		create_file();
		return;
	}
	else
		load();
	
	//Delete these now un-needed script_origins
	
	locations = getentarray("muzzleflash","targetname");
	for (i=0;i<locations.size;i++)
		locations[i] delete();
	
	trigs = getentarray("bullet_impacts","targetname");
	for (i=0;i<trigs.size;i++)
	{
		trigs[i].dataIndex = i;
		delete_chain_origins(getent(trigs[i].target,"targetname"));
	}
}

create_file()
{	
	//muzzleflash locations
	create_file_muzzleflash();
	
	//bullet strafe locations and information
	create_file_bulletStrafe();
}

create_file_muzzleflash()
{
	level.muzzleflashLocation = [];
	locations = getentarray("muzzleflash","targetname");
}

create_file_bulletStrafe()
{
	level.bulletStrafe = [];
	trigs = getentarray("bullet_impacts","targetname");
	for (i=0;i<trigs.size;i++)
	{
		//put info on the trigger
		trigs[i].dataIndex = i;
		trigs[i] create_file_bulletStrafe_single(i);
	}
}

create_file_bulletStrafe_single(indexNum)
{
	//2d array containing locations of the hit points
	
	eOrigin = getent(self.target,"targetname");
	subIndex = 0;
	for (;;)
	{
		subIndex++;
		if (!isdefined(eOrigin.target))
			return;
		eOrigin = getent(eOrigin.target,"targetname");
		if (!isdefined(eOrigin))
			return;
	}
}

delete_chain_origins(first)
{
	if (!isdefined(first.target))
		return;
	orgs = getentarray(first.target,"targetname");
	
	for (i=0;i<orgs.size;i++)
		delete_chain_origins(orgs[i]);
	first delete();
}

load()
{
	level.muzzleflashLocation[0] = (3956,-3819,1060);
	level.muzzleflashLocation[1] = (3837,-3827,1060);
	level.muzzleflashLocation[2] = (3619,-4037,1021);
	level.muzzleflashLocation[3] = (3371,-4006,1020);
	level.muzzleflashLocation[4] = (3175,-4019,1024);
	level.muzzleflashLocation[5] = (3114,-4000,1028);
	level.muzzleflashLocation[6] = (2903,-3910,1037);
	level.muzzleflashLocation[7] = (2722,-3930,1047);
	level.muzzleflashLocation[8] = (2577,-3925,1063);
	level.muzzleflashLocation[9] = (2464,-3941,1081);
	level.muzzleflashLocation[10] = (2291,-3966,1113);
	level.muzzleflashLocation[11] = (2153,-3925,1131);
	level.muzzleflashLocation[12] = (1943,-3934,1150);
	level.muzzleflashLocation[13] = (1792,-3946,1155);
	level.muzzleflashLocation[14] = (1619,-3918,1156);
	level.muzzleflashLocation[15] = (1440,-3882,1151);
	level.muzzleflashLocation[16] = (1249,-3885,1140);
	level.muzzleflashLocation[17] = (1084,-3825,1135);
	level.muzzleflashLocation[18] = (209,-3946,941);
	level.muzzleflashLocation[19] = (325,-3800,989);
	level.muzzleflashLocation[20] = (-352,-3905,1149);
	level.muzzleflashLocation[21] = (-463,-3917,1156);
	level.muzzleflashLocation[22] = (-631,-3929,1158);
	level.muzzleflashLocation[23] = (-772,-3918,1166);
	level.muzzleflashLocation[24] = (-901,-3951,1167);
	level.muzzleflashLocation[25] = (-1056,-4025,1166);
	level.muzzleflashLocation[26] = (-12,-3833,1027);
	level.muzzleflashLocation[27] = (-1231,-4068,1133);
	level.muzzleflashLocation[28] = (-1380,-4131,1133);
	level.muzzleflashLocation[29] = (-1548,-4171,1121);
	level.muzzleflashLocation[30] = (-1672,-4191,1113);
	level.muzzleflashLocation[31] = (-1791,-4203,1110);
	level.muzzleflashLocation[32] = (-1962,-4212,1119);
	level.muzzleflashLocation[33] = (-2066,-4244,1129);
	level.muzzleflashLocation[34] = (-2159,-4290,1136);
	level.muzzleflashLocation[35] = (-2252,-4291,1143);
	level.muzzleflashLocation[36] = (-2382,-4258,1154);
	level.muzzleflashLocation[37] = (-2636,-4239,1169);
	level.muzzleflashLocation[38] = (-2802,-4315,1171);
	level.muzzleflashLocation[39] = (-2960,-4394,1170);
	level.muzzleflashLocation[40] = (-3089,-4436,1160);
	level.muzzleflashLocation[41] = (-3252,-4431,1137);
	level.muzzleflashLocation[42] = (-3403,-4440,1117);
	level.muzzleflashLocation[43] = (-3585,-4438,1117);
	level.muzzleflashLocation[44] = (-3773,-4428,1143);
	level.muzzleflashLocation[45] = (-4111,-4470,1159);
	level.muzzleflashLocation[46] = (-4283,-4573,1159);
	level.muzzleflashLocation[47] = (-4441,-4651,1159);
	level.muzzleflashLocation[48] = (-164,-3865,1125);
	
	level.bulletStrafe[0][0]["coord"] = (3677,-10385,-55);
	level.bulletStrafe[0][0]["type"] = "water";
	level.bulletStrafe[0][1]["coord"] = (3690,-10412,-55);
	level.bulletStrafe[0][1]["type"] = "water";
	level.bulletStrafe[0][2]["coord"] = (3702,-10442,-55);
	level.bulletStrafe[0][2]["type"] = "water";
	level.bulletStrafe[0][3]["coord"] = (3716,-10478,-55);
	level.bulletStrafe[0][3]["type"] = "water";
	level.bulletStrafe[0][4]["coord"] = (3729,-10517,-55);
	level.bulletStrafe[0][4]["type"] = "water";
	level.bulletStrafe[0][5]["coord"] = (3736,-10569,-55);
	level.bulletStrafe[0][5]["type"] = "water";
	level.bulletStrafe[0][6]["coord"] = (3731,-10625,-55);
	level.bulletStrafe[0][6]["type"] = "water";
	level.bulletStrafe[0][7]["coord"] = (3723,-10672,-55);
	level.bulletStrafe[0][7]["type"] = "water";
	level.bulletStrafe[1][0]["coord"] = (1989,-5016,-18);
	level.bulletStrafe[1][0]["type"] = "beach";
	level.bulletStrafe[1][1]["coord"] = (1975,-4972,-16);
	level.bulletStrafe[1][1]["type"] = "beach";
	level.bulletStrafe[1][2]["coord"] = (1952,-4982,-19);
	level.bulletStrafe[1][2]["type"] = "beach";
	level.bulletStrafe[1][3]["coord"] = (1972,-4913,-13);
	level.bulletStrafe[1][3]["type"] = "beach";
	level.bulletStrafe[1][4]["coord"] = (1944,-4935,-17);
	level.bulletStrafe[1][4]["type"] = "beach";
	level.bulletStrafe[1][5]["coord"] = (1959,-4885,-13);
	level.bulletStrafe[1][5]["type"] = "beach";
	level.bulletStrafe[1][6]["coord"] = (1952,-4852,-11);
	level.bulletStrafe[1][6]["type"] = "beach";
	level.bulletStrafe[1][7]["coord"] = (1928,-4866,-13);
	level.bulletStrafe[1][7]["type"] = "beach";
	level.bulletStrafe[1][8]["coord"] = (1952,-4806,-9);
	level.bulletStrafe[1][8]["type"] = "beach";
	level.bulletStrafe[1][9]["coord"] = (1945,-4820,-10);
	level.bulletStrafe[1][9]["type"] = "beach";
	level.bulletStrafe[1][10]["coord"] = (1935,-4835,-11);
	level.bulletStrafe[1][10]["type"] = "beach";
	level.bulletStrafe[1][11]["coord"] = (1913,-4832,-13);
	level.bulletStrafe[1][11]["type"] = "beach";
	level.bulletStrafe[2][0]["coord"] = (3253,-8946,-55);
	level.bulletStrafe[2][0]["type"] = "water";
	level.bulletStrafe[2][1]["coord"] = (3283,-8959,-55);
	level.bulletStrafe[2][1]["type"] = "water";
	level.bulletStrafe[2][2]["coord"] = (3318,-8975,-55);
	level.bulletStrafe[2][2]["type"] = "water";
	level.bulletStrafe[2][3]["coord"] = (3355,-8993,-55);
	level.bulletStrafe[2][3]["type"] = "water";
	level.bulletStrafe[2][4]["coord"] = (3396,-9025,-55);
	level.bulletStrafe[2][4]["type"] = "water";
	level.bulletStrafe[2][5]["coord"] = (3432,-9068,-55);
	level.bulletStrafe[2][5]["type"] = "water";
	level.bulletStrafe[2][6]["coord"] = (3460,-9107,-55);
	level.bulletStrafe[2][6]["type"] = "water";
	level.bulletStrafe[3][0]["coord"] = (1936,-4793,-9);
	level.bulletStrafe[3][0]["type"] = "beach";
	level.bulletStrafe[3][1]["coord"] = (1920,-4821,-11);
	level.bulletStrafe[3][1]["type"] = "beach";
	level.bulletStrafe[3][2]["coord"] = (1901,-4854,-15);
	level.bulletStrafe[3][2]["type"] = "beach";
	level.bulletStrafe[3][3]["coord"] = (1886,-4888,-19);
	level.bulletStrafe[3][3]["type"] = "beach";
	level.bulletStrafe[3][4]["coord"] = (1866,-4934,-24);
	level.bulletStrafe[3][4]["type"] = "beach";
	level.bulletStrafe[3][5]["coord"] = (1851,-4981,-31);
	level.bulletStrafe[3][5]["type"] = "beach";
	level.bulletStrafe[3][6]["coord"] = (1841,-5043,-38);
	level.bulletStrafe[3][6]["type"] = "beach";
	level.bulletStrafe[4][0]["coord"] = (2215,-4838,-13);
	level.bulletStrafe[4][0]["type"] = "beach";
	level.bulletStrafe[4][1]["coord"] = (2265,-4847,-21);
	level.bulletStrafe[4][1]["type"] = "beach";
	level.bulletStrafe[4][2]["coord"] = (2252,-4833,-18);
	level.bulletStrafe[4][2]["type"] = "beach";
	level.bulletStrafe[4][3]["coord"] = (2191,-4831,-11);
	level.bulletStrafe[4][3]["type"] = "beach";
	level.bulletStrafe[4][4]["coord"] = (2213,-4865,-15);
	level.bulletStrafe[4][4]["type"] = "beach";
	level.bulletStrafe[4][5]["coord"] = (2250,-4840,19);
	level.bulletStrafe[4][5]["type"] = "beach";
	level.bulletStrafe[4][6]["coord"] = (2272,-4872,-24);
	level.bulletStrafe[4][6]["type"] = "beach";
	level.bulletStrafe[4][7]["coord"] = (2322,-4884,-33);
	level.bulletStrafe[4][7]["type"] = "beach";
	level.bulletStrafe[4][8]["coord"] = (2303,-4867,-27);
	level.bulletStrafe[4][8]["type"] = "beach";
	level.bulletStrafe[4][9]["coord"] = (2321,-4850,-26);
	level.bulletStrafe[4][9]["type"] = "beach";
	level.bulletStrafe[4][10]["coord"] = (2281,-4847,-23);
	level.bulletStrafe[4][10]["type"] = "water";
	level.bulletStrafe[4][11]["coord"] = (2247,-4853,18);
	level.bulletStrafe[4][11]["type"] = "water";
	level.bulletStrafe[4][12]["coord"] = (2180,-4811,-10);
	level.bulletStrafe[4][12]["type"] = "water";
	level.bulletStrafe[5][0]["coord"] = (1120,-4726,-41);
	level.bulletStrafe[5][0]["type"] = "beach";
	level.bulletStrafe[5][1]["coord"] = (1152,-4751,-45);
	level.bulletStrafe[5][1]["type"] = "beach";
	level.bulletStrafe[5][2]["coord"] = (1154,-4773,-46);
	level.bulletStrafe[5][2]["type"] = "beach";
	level.bulletStrafe[5][3]["coord"] = (1194,-4784,-49);
	level.bulletStrafe[5][3]["type"] = "beach";
	level.bulletStrafe[5][4]["coord"] = (1234,-4826,-51);
	level.bulletStrafe[5][4]["type"] = "beach";
	level.bulletStrafe[5][5]["coord"] = (1207,-4816,-51);
	level.bulletStrafe[5][5]["type"] = "beach";
	level.bulletStrafe[5][6]["coord"] = (1258,-4852,-52);
	level.bulletStrafe[5][6]["type"] = "beach";
	level.bulletStrafe[6][0]["coord"] = (921,-5042,-55);
	level.bulletStrafe[6][0]["type"] = "water";
	level.bulletStrafe[6][1]["coord"] = (949,-5018,-55);
	level.bulletStrafe[6][1]["type"] = "water";
	level.bulletStrafe[6][2]["coord"] = (966,-4991,-55);
	level.bulletStrafe[6][2]["type"] = "water";
	level.bulletStrafe[6][3]["coord"] = (940,-5001,-55);
	level.bulletStrafe[6][3]["type"] = "water";
	level.bulletStrafe[6][4]["coord"] = (924,-4979,-55);
	level.bulletStrafe[6][4]["type"] = "beach";
	level.bulletStrafe[6][5]["coord"] = (952,-4970,-55);
	level.bulletStrafe[6][5]["type"] = "beach";
	level.bulletStrafe[6][6]["coord"] = (1024,-4954,-55);
	level.bulletStrafe[6][6]["type"] = "beach";
	level.bulletStrafe[6][7]["coord"] = (1048,-4898,-53);
	level.bulletStrafe[6][7]["type"] = "beach";
	level.bulletStrafe[6][8]["coord"] = (1072,-4890,-53);
	level.bulletStrafe[6][8]["type"] = "beach";
	level.bulletStrafe[6][9]["coord"] = (1088,-4914,-55);
	level.bulletStrafe[6][9]["type"] = "beach";
	level.bulletStrafe[6][10]["coord"] = (1096,-4882,-53);
	level.bulletStrafe[6][10]["type"] = "beach";
	level.bulletStrafe[7][0]["coord"] = (1574,-4999,-55);
	level.bulletStrafe[7][0]["type"] = "beach";
	level.bulletStrafe[7][1]["coord"] = (1597,-5030,-55);
	level.bulletStrafe[7][1]["type"] = "beach";
	level.bulletStrafe[7][2]["coord"] = (1624,-5041,-55);
	level.bulletStrafe[7][2]["type"] = "beach";
	level.bulletStrafe[7][3]["coord"] = (1619,-5000,-54);
	level.bulletStrafe[7][3]["type"] = "beach";
	level.bulletStrafe[7][4]["coord"] = (1643,-5014,-55);
	level.bulletStrafe[7][4]["type"] = "beach";
	level.bulletStrafe[7][5]["coord"] = (1606,-5018,-55);
	level.bulletStrafe[7][5]["type"] = "beach";
	level.bulletStrafe[7][6]["coord"] = (1645,-5051,-55);
	level.bulletStrafe[7][6]["type"] = "beach";
	level.bulletStrafe[7][7]["coord"] = (1641,-4994,-54);
	level.bulletStrafe[7][7]["type"] = "beach";
	level.bulletStrafe[7][8]["coord"] = (1627,-4970,-53);
	level.bulletStrafe[7][8]["type"] = "beach";
	level.bulletStrafe[7][9]["coord"] = (1597,-4979,-54);
	level.bulletStrafe[7][9]["type"] = "beach";
	level.bulletStrafe[7][10]["coord"] = (1596,-5002,-55);
	level.bulletStrafe[7][10]["type"] = "beach";
	level.bulletStrafe[7][11]["coord"] = (1624,-5022,-55);
	level.bulletStrafe[7][11]["type"] = "beach";
	level.bulletStrafe[7][12]["coord"] = (1633,-4991,-54);
	level.bulletStrafe[7][12]["type"] = "beach";
	level.bulletStrafe[7][13]["coord"] = (1612,-4961,-52);
	level.bulletStrafe[7][13]["type"] = "beach";
	level.bulletStrafe[7][14]["coord"] = (1624,-4932,-50);
	level.bulletStrafe[7][14]["type"] = "beach";
}