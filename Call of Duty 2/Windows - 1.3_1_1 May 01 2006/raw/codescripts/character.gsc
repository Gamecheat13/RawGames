setModelFromArray(a)
{
	self setModel(a[randomint(a.size)]);
}

precacheModelArray(a)
{
	for (i = 0; i < a.size; i++)
		precacheModel(a[i]);
}

useOptionalModels()
{
	return getcvarint("g_useGear");
}

randomElement(a)
{
	return a[randomint(a.size)];
}

attachFromArray(a)
{
	self attach(randomElement(a), "", true);
}

new()
{
	self detachAll();
	oldGunHand = self.anim_gunHand;
	if (!isdefined(oldGunHand))
		return;
	self.anim_gunHand = "none";
	self [[anim.PutGunInHand]](oldGunHand);
}

save()
{
	info["gunHand"] = self.anim_gunHand;
	info["gunInHand"] = self.anim_gunInHand;
	info["model"] = self.model;
	info["hatModel"] = self.hatModel;
	if (isdefined (self.name))
	{
		info["name"] = self.name;
		println ("Save: Guy has name ", self.name);
	}
	else
		println ("save: Guy had no name!");
		
	attachSize = self getAttachSize();
	for (i = 0; i < attachSize; i++)
	{
		info["attach"][i]["model"] = self getAttachModelName(i);
		info["attach"][i]["tag"] = self getAttachTagName(i);
	}
	return info;
}

load(info)
{
	self detachAll();
	self.anim_gunHand = info["gunHand"];
	self.anim_gunInHand = info["gunInHand"];
	self setModel(info["model"]);
	self.hatModel = info["hatModel"];
	if (isdefined (info["name"]))
	{
		self.name = info["name"];
		println ("Load: Guy has name ", self.name);
	}
	else
		println ("Load: Guy had no name!");
		
	attachInfo = info["attach"];
	attachSize = attachInfo.size;
	for (i = 0; i < attachSize; i++)
		self attach(attachInfo[i]["model"], attachInfo[i]["tag"]);
}

precache(info)
{
	if (isdefined (info["name"]))
		println ("Precache: Guy has name ", info["name"]);
	else
		println ("Precache: Guy had no name!");

	precacheModel(info["model"]);

	attachInfo = info["attach"];
	attachSize = attachInfo.size;
	for (i = 0; i < attachSize; i++)
		precacheModel(attachInfo[i]["model"]);
}

/*
sample save/precache/load usage (precache is only required if there are any waits in the level script before load):

save:
	info = foley codescripts\character::save();
	game["foley"] = info;
	changelevel("burnville", 0, true);

precache:
	codescripts\character::precache(game["foley"]);

load:
	foley codescripts\character::load(game["foley"]);

*/
