#include "globals.hlsl"


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
	float3 fogColor : COLOR1;
	float2 texCoords : TEXCOORD0;
};


struct PixelOutput
{
	float4 color : COLOR;
};


#include "transform.hlsl"
#include "fogcalc.hlsl"
#include "shade.hlsl"

// Define:
//   Cp: color of the unfogged pixel
//   Cm: color of the multiply decal
//   Cf: fog color
//   f:  fog factor (0 == fully fogged)
// Then, the current color of a fogged pixel when a multiply materials are applied is
//   Cp * f + Cf * (1 - f)
// After the multiply material is applied, the pixel value becomes
//   [Cp * f + Cf * (1 - f)] * Cm
//   Cp * Cm * f + Cf * Cm * (1 - f)
// The desired color is the color attained by multiplying the unfogged pixel color before applying fog:
//   Cp * Cm * f + Cf * (1 - f)
// The difference between the actual and desired colors is
//   Cf * (1 - f) * (1 - Cm)
// So, the incorrect fogging can be corrected by adding "(Cf * (1 - f)) * (1 - Cm)" to the framebuffer.

PixelInput vs_main( const VertexInput vertex )
{
	PixelInput pixel;

	pixel = (PixelInput)0;
	pixel.position = Transform_ObjectToClip( vertex.position );
	pixel.texCoords = vertex.texCoords;
	pixel.color = vertex.color;
	pixel.fogColor = saturate(1 - Fog_VertexFactor( vertex )) * fogColor;

	return pixel;
}
