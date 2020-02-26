#include maps\_utility;
main()
{
	array_thread(getentarray("animated_model","targetname"),::animated_model);
}

#using_animtree ("tree_desertpalm");
animated_model()
{
	level.wind = spawnstruct();
	level.wind.rate = 1;
	level.wind.weight = 1;
	level.wind.variance = .4;
	anima = [];
	self UseAnimTree(#animtree);
	switch(self.model)
	{
			case "foliage_tree_desertpalm01_animated":
				anima["still"] = %tree_desertpalm01_still;
				anima["strong"]= %tree_desertpalm01_strongwind;
				break;
			case "foliage_tree_desertpalm02_animated":
				anima["still"] = %tree_desertpalm02_still;
				anima["strong"] = %tree_desertpalm02_strongwind;
				break;
			case "foliage_tree_desertpalm03_animated":
				anima["still"] = %tree_desertpalm03_still;
				anima["strong"] = %tree_desertpalm03_strongwind;
				break;
		
	}
	
	wind = "strong";
	while(1)
	{
		thread animateme(anima,wind);
		level waittill ("windchange",wind);
	}
}


animateme(anima,animate)
{
	level endon ("windchange");
	windweight = level.wind.weight;
	windrate = level.wind.rate+randomfloat(level.wind.variance);
	self setAnim(anima["still"],1,0.4,windrate);	
	self setAnim(anima[animate],windweight,0.4,windrate);	
/*
	while(1)
	{
		self animscripted("windy",self.origin,self.angles,animate);
		self waittillmatch ("windy","end");
		
	}
*/
}