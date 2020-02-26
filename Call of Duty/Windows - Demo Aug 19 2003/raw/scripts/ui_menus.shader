//Main Menu background
main_back
{
	nopicmip
	nomipmaps
	{
		map ui/assets/main_back.tga
		//blendFunc blend
		alphaGen vertex
	}
}
main_back_top
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/main_back_top.tga
		//blendFunc blend
		alphaGen vertex
	}
}
main_back_bottom
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/main_back_bottom.tga
		//blendFunc blend
		alphaGen vertex
	}
}
main_back_top_soviet
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/main_back_top_soviet.tga
		//blendFunc blend
		alphaGen vertex
	}
}
main_back_bottom_soviet
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/main_back_bottom_soviet.tga
		//blendFunc blend
		alphaGen vertex
	}
}
main_back_top_british
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/main_back_top_british.tga
		//blendFunc blend
		alphaGen vertex
	}
}
main_back_bottom_british
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/main_back_bottom_british.tga
		//blendFunc blend
		alphaGen vertex
	}
}
// TEMP FROM WOLF MENU
backimage2
{
	nopicmip
	nomipmaps
	{
		map ui/assets/backimage2.tga
		//blendFunc blend
		alphaGen vertex
	}
}

// TEMP FROM WOLF MENU
backimage4
{
	nopicmip
	nomipmaps
	{
		map ui/assets/backimage4.tga
		blendFunc blend
	}
}

bands
{
	nopicmip
	nomipmaps
	{
		map ui/assets/bands.tga
		blendFunc blend
		//tcmod stretch sin 1 .2 0 1
		tcmod scroll -0.03 0 
		rgbGen wave sawtooth 2 .7 0 .5
	}
	{
		map ui/assets/bandsa.tga
		blendFunc blend
		//tcmod stretch sin 1 .1 0 1 
		//tcmod turb  1 .01 0 .1
		tcmod scroll 0.05 0
	}
}

band2
{
	nopicmip
	nomipmaps
	{
		map ui/assets/band2.tga
		blendFunc blend
		rgbGen wave sawtooth 2 .5 0 .5
	}
}

BLACKGRAD
{
	nopicmip
	nomipmaps
	{
		map ui/assets/BLACKGRAD.tga
		blendFunc blend
	}
}

// Display when a level is loaded that doesn't have a level shot of its own
menu/art/unknownmap
{
	nopicmip
	nomipmaps
	{
		map levelshots/unknownmap.tga
	}
}
