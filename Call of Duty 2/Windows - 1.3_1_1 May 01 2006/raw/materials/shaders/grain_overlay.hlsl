#include "lib/globals.hlsl"

#ifdef USE_DETAIL
#error "USE_DETAIL already defined"
#endif // #ifdef USE_DETAIL
#define USE_DETAIL 0

struct VertexInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelInput
{
	float4 position : POSITION;
	float4 color : COLOR;
	float2 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "lib/transform.hlsl"
#include "lib/shade.hlsl"

PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.color = vertex.color;
	float uOffset = 647 * gameTime.z;
	uOffset = uOffset % 8;
	float vOffset = 219 * gameTime.z;
	vOffset = vOffset % 8;
	pixel.texCoords = vertex.texCoords + float2(uOffset,vOffset);

	return pixel;
}


PixelOutput ps_main( const PixelInput pixel )
{
	PixelOutput fragment;

	fragment.color = ColoredTexturedDiffuse( pixel.color, pixel.texCoords );

	return fragment;
}
