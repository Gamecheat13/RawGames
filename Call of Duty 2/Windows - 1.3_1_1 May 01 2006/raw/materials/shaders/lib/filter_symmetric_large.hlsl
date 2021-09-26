#ifndef HALF_TAP_COUNT
#error HALF_TAP_COUNT undefined
#endif
#if HALF_TAP_COUNT < 5 || HALF_TAP_COUNT > 8
#error HALF_TAP_COUNT should be from 5 to 8
#endif

#include "globals.hlsl"


struct VertexInput
{
	float4 position : POSITION;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 texCoords[HALF_TAP_COUNT] : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"


PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;
	int tapIndex;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	for ( tapIndex = 0; tapIndex < HALF_TAP_COUNT; tapIndex++ )
		pixel.texCoords[tapIndex] = float4( vertex.texCoords + filterTap[tapIndex].xy, vertex.texCoords - filterTap[tapIndex].xy );

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;
	int tapIndex;

	fragment.color = 0;
	for ( tapIndex = 0; tapIndex < HALF_TAP_COUNT; tapIndex++ )
		fragment.color += filterTap[tapIndex].w * (tex2D( colorMapSampler, pixel.texCoords[tapIndex].xy ) + tex2D( colorMapSampler, pixel.texCoords[tapIndex].zw ));

	return fragment;
}
