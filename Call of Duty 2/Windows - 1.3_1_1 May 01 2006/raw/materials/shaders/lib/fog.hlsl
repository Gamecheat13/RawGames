#ifndef FOGVAR
#error FOGVAR undefined
#endif // #ifndef FOGVAR

#include "fogcalc.hlsl"

void Fog_VertexCalc( const VertexInput vertex, inout PixelInput pixel )
{
#if USE_FOG
	pixel.FOGVAR = Fog_VertexFactor( vertex );
#ifdef XENON
	pixel.FOGVAR = saturate( pixel.FOGVAR );
#endif
#endif
}

void Fog_PixelCalc( const PixelInput pixel, inout PixelOutput fragment )
{
#if USE_FOG
	fragment.color.rgb = lerp( fogColor.rgb, fragment.color.rgb, pixel.FOGVAR );
#endif
}
