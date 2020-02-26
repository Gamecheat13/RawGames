skins/105mm
{
	{
		map textures/sfx/environmap_wilderness1day.jpg
		tcGen environment
	}
	{
		map skins\105mm.tga
		blendFunc blend
		rgbGen lightingdiffuse
	}
}

skins/flakk88
{
	{
		map textures/sfx/environmap_wilderness1day.jpg
		tcGen environment
	}
	{
		map skins\flakk88.tga
		blendFunc blend
		rgbGen lightingdiffuse
	}
}

oldtextures/russia/smoke/citysmoke_inner
{
	sort innerBlend
	qer_editorimage textures/russia/smoke/smoke.tga
	{
		map clamp   textures/russia/smoke/smoke.tga
		blendFunc blend
		rgbGen vertex
		alphaGen const 0.5
	}
}

oldtextures/russia/smoke/citysmoke_outer
{
	sort outerBlend
	qer_editorimage textures/russia/smoke/smoke.tga
	{
		map clamp textures/russia/smoke/smoke.tga
		blendFunc blend
		rgbGen vertex
		alphaGen const 0.5
	}
}

textures/russia/smoke/citysmoke_outer
{
	qer_trans 0.32
	sort outerBlend
	qer_editorimage textures/russia/smoke/smokealpha.tga
	{
		map clamp   textures/russia/smoke/smokemask.tga
		blendFunc blend
		rgbGen vertex
		alphaGen const 0.4
	nextbundle
		map textures/russia/smoke/smokebase.tga
//		tcMod scroll 0.002 .01
		tcMod scale 4 0.5
		tcMod scroll 0.002 .003
	}
}

textures/russia/smoke/citysmoke_inner
{
	qer_trans 0.32
	sort innerBlend
	qer_editorimage textures/russia/smoke/smokealpha.tga
	{
		map clamp   textures/russia/smoke/smokemask.tga
		blendFunc blend
		rgbGen vertex
		alphaGen const 1 // 0.65
	nextbundle
//		rgbGen const 0.5
		map textures/russia/smoke/smokebase.tga
//		map textures/common/case512.jpg
//		tcMod scroll 0.001 .02
		tcMod scale -4 0.5
		tcMod scroll 0.001 .005
	}
}

textures/russia/smoke/citysmoke_ending_inner
{
	qer_trans 0.32
	sort innerBlend
	qer_editorimage textures/russia/smoke/smokealpha.tga
	{
		map clamp   textures/russia/smoke/smokemask.tga
		blendFunc blend
		rgbGen vertex
		alphaGen const 1 // 0.65
	nextbundle
//		rgbGen const 0.5
		map textures/russia/smoke/smokebase.tga
//		map textures/common/case512.jpg
//		tcMod scroll 0.001 .02
		tcMod scale -4 0.5
		tcMod scroll 0.001 .005
	}
}

textures/russia/smoke/citysmoke_ending_outer
{
	qer_trans 0.32
	sort outerBlend
	qer_editorimage textures/russia/smoke/smokealpha.tga
	{
		map clamp   textures/russia/smoke/smokemask.tga
		blendFunc blend
		rgbGen vertex
		alphaGen const 0.65
	nextbundle
		map textures/russia/smoke/smokebase.tga
//		tcMod scroll 0.002 .01
		tcMod scale 4 0.5
		tcMod scroll 0.002 .003
	}
}
