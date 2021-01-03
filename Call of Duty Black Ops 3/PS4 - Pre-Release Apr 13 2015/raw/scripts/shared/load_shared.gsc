#namespace loadout;

function is_warlord_perk( itemIndex )
{
	return false;
}

function is_item_excluded( itemIndex )
{
	if ( !level.onlineGame )
	{
		return false;
	}

	numExclusions = level.itemExclusions.size;
	
	for ( exclusionIndex = 0; exclusionIndex < numExclusions; exclusionIndex++ )
	{
		if ( itemIndex == level.itemExclusions[ exclusionIndex ] )
		{
			return true;
		}
	}
	
	return false;
}


function getLoadoutItemFromDDLStats( customClassNum, loadoutSlot )
{
	itemIndex = self GetLoadoutItem( customClassNum, loadoutSlot );
	
	if ( is_item_excluded( itemIndex ) && !is_warlord_perk( itemIndex ) )
	{
		return 0;
	}
	
	return itemIndex;
}

function initWeaponAttachments( weapon )
{
	self.currentWeaponStartTime = getTime();
	
	self.currentWeapon = weapon;
}
