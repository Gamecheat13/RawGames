

main()
{
	level.inventory = [];
}

inventory_create(shader,show_icon)
{
	
	if (true)
		return spawnstruct();

	
	
	assert(isdefined(shader));

	if (!isdefined(show_icon))
		show_icon = false;

	ent = newHudElem();

	ent.alignX = "right";
	ent.alignY = "top";
	ent.horzAlign = "right";
	ent.vertAlign = "top";

	ent.alpha = 0;

	ent.index = level.inventory.size;
	ent.show_icon = show_icon;

	ent setshader(shader,40, 40);	

	level.inventory[ent.index] = ent;

	inventroy_update();

	return ent;
}

inventory_hide()
{
	
	if (true)
		return;

	self.show_icon = false;
	inventroy_update();
}

inventory_show()
{
	
	if (true)
		return;

	self.show_icon = true;
	inventroy_update();
}

inventroy_update()
{
	
	if (true)
		return;

	

	x = -18;
	y = 8;

	gap = 42;
	position = 0;

	for (i=0; i < level.inventory.size; i++)
	{
		if (level.inventory[i].show_icon)
		{
			new_y = y + (gap * position);

			if (new_y != level.inventory[i].y)
			{
				level.inventory[i].x = x;
				if (level.inventory[i].alpha != 0)
					level.inventory[i] moveovertime(.3);
				level.inventory[i].y = new_y;
			}
			if (level.inventory[i].alpha != 1)
			{
				level.inventory[i] fadeovertime(.3);
				level.inventory[i].alpha = 1;
			}
			position++;
		}
		else
		{
			level.inventory[i] fadeovertime(.3);
			level.inventory[i].alpha = 0;
		}
	}
}

inventory_destroy()
{
	
	if (true)
		return;

	
	self destroy();

	index = 0;
	old_inventory = level.inventory;
	level.inventory = [];
	for (i=0; i < old_inventory.size; i++)
	{
		if (isdefined(old_inventory[i]))
			level.inventory[level.inventory.size] = old_inventory[i];
	}
	inventroy_update();
}