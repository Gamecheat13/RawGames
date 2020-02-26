ui/assets/hudbar
{
	{
		map ui/assets/hudbar.tga
		blendFunc blend
		rgbGen identity
	}
	{
		map ui/assets/duffyzot.tga
		blendFunc add
		tcmod scroll .2 2
		rgbGen wave triangle 0.4 0.1 0 1.2
	}
}

ui/assets/hudbarlarge
{
	{
		map ui/assets/hudbarlarge.tga
		blendFunc blend
		rgbGen identity
	}
	{
		map ui/assets/duffyzot.tga
		blendFunc add
		tcmod scroll .3 4
		rgbGen wave triangle 0.2 0.5 0 0.2
	}
}

ui/assets/hudbarmedium
{
	{
		map ui/assets/hudbarmedium.tga
		blendFunc blend
		rgbGen identity
	}
	{
		map ui/assets/duffyzot.tga
		blendFunc add
		tcmod scroll .4 5
		rgbGen wave triangle 0.25 0.7 0 2.2
	}
}

ui/assets/reticle_circle_quarter
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/reticle_q.tga
		blendFunc blend
	}
}

ui/assets/compassback
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/compassback.tga
		blendFunc blend
		alphaGen vertex
	}
}

ui/assets/compassneedle
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/compassneedle.tga
		blendFunc blend
		alphaGen vertex
	}
}

ui/assets/compasspointer
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/compasspointer.tga
		blendFunc blend
		alphaGen vertex
	}
}

ui/assets/checkbox_clear
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/checkbox_clear.tga
		blendFunc blend
		alphaGen vertex
	}
}

ui/assets/checkbox_fail
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/checkbox_fail.tga
		blendFunc blend
		alphaGen vertex
	}
}

ui/assets/checkbox_checked
{
	nopicmip
	nomipmaps
	{
		map clamp ui/assets/checkbox_checked.tga
		blendFunc blend
		alphaGen vertex
	}
}

//=============================================================================
// Multiplayer HUD stuff

// Wolf compass objective indicator
sprites/destroy
{
	nopicmip
	{
		map sprites/destroy.tga
		blendFunc GL_SRC_ALPHA GL_ONE_MINUS_SRC_ALPHA
		//alphaGen wave sin .6 .5 0 .3
		alphaGen wave sin .7 .4 0 .3
	}
}
