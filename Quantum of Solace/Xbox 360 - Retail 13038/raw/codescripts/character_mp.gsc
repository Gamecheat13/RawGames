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
	return getdvarint("g_useGear");
}

randomElement(a)
{
	return a[randomint(a.size)];
}

attachFromArray(a)
{
	idx = randomint(a.size);
	self attach(a[idx], "", true);
	return idx;
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
