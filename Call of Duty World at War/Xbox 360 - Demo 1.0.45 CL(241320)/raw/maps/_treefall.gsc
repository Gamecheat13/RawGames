//_treefall.gsc
// Used to allow stuff to knock over trees.
// To Use:	Make a trigger, give it the targetname of  "treetrig." Target the trigger at script_model tree.
//					Trigger should probably have the vehicle flag set.	

main()
{
	// Grab all treetrigs
	treetrigs = getentarray ("treetrig","targetname");
	
	// Get them all threaded and waiting to be triggered.
	for(i=0;i<treetrigs.size;i++)
	{
		treetrigs[i] thread treefall();
	}
}

treefall()
{
	if(!isdefined (self.target))
	{
		println ("notarget for tree trigger at ",self getorigin());
		return;
	}
	
	tree = getent(self.target, "targetname");

	if(!isdefined (tree))
	{
		println("no tree");
		return;
	}
	
	// treecol can be script_brushmodel collision, targeted by the treemodel. This will delete when the tree falls.
	treecol = undefined;
	if(isdefined(tree.target))
	{
		treecol = getent(tree.target,"targetname");
	}
	self waittill ("trigger", triggerer);

	self delete();
	treeorg = spawn("script_origin", tree.origin);
	treeorg.origin = tree.origin;
	treeorg.angles = triggerer.angles;
	
	// SCRIPTER_MOD: JesseS (5/12/200) - took out soudn reference
	// TODO: add back sound for tree falling
	//treeorg playsound ("tankdrive_treefall");
	if(triggerer.classname == "script_vehicle")
	{
		triggerer joltbody((treeorg.origin + (0,0,64)),.3,.67,11);
	}
	
 	treeang = tree.angles;
	ang = treeorg.angles;
	org = triggerer.origin;
	pos1 = (org[0],org[1],0);
	org = tree.origin;
	pos2 = (org[0],org[1],0);
	treeorg.angles = vectortoangles(pos1 - pos2);
	tree linkto(treeorg);
	
	if(isdefined(treecol))
	{
		treecol delete();
	}
	
	treeorg rotatepitch(-90,1.1,.05,.2);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(5,.21,.05,.15);
	treeorg waittill("rotatedone");
	treeorg rotatepitch(-5,.26,.15,.1);
	treeorg waittill("rotatedone");
	tree unlink();
	treeorg delete();
}