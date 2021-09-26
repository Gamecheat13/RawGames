#define PI 3.14159265



VertexInput Flap ( VertexInput vertex )
{
	// Notes on gameTime variable
	// gameTime.w increases linearly forever, and appears to be measured in seconds.
	// gameTime.x is a sin wave, amplitude approx 1, period 1.
	// gameTime.y is similar, maybe a cos wave?
	// gameTime.z goes from 0 to 1 linearly then pops back to 0 once per second

	// Set the variables for the 3 sin waves
	#define overallScale	5

	#define w1scale		1.73
	#define w1angle		(4 * (PI/180))
	#define w1speed		0.9
	#define w1amp		1.5

	#define w2scale		0.75
	#define w2angle		(-10 * (PI/180))
	#define w2speed		1.5
	#define w2amp		0.6

	#define w3scale		0.31
	#define w3angle		(15 * (PI/180))
	#define w3speed		1.2
	#define w3amp		0.34


	// Calculate the position offset for the vert
	float	U =			1-vertex.texCoords[0];
	float	V =			1-vertex.texCoords[1];
	#define	w1scaleU	2*PI/w1scale * cos(w1angle)
	#define	w1scaleV	2*PI/w1scale * sin(w1angle)
	float	w1 = (w1scaleU * U) + (w1scaleV * V) + (2 * PI * gameTime.w * w1speed);
	#define	w2scaleU	2*PI/w2scale * cos(w2angle)
	#define	w2scaleV	2*PI/w2scale * sin(w2angle)
	float	w2 = (w2scaleU * U) + (w2scaleV * V) + (2 * PI * gameTime.w * w2speed);
	#define	w3scaleU	2*PI/w3scale * cos(w3angle)
	#define	w3scaleV	2*PI/w3scale * sin(w3angle)
	float	w3 = (w3scaleU * U) + (w3scaleV * V) + (2 * PI * gameTime.w * w3speed);

	float offsetAmount = overallScale * vertex.color.a * ( (w1amp*sin(w1)) + (w2amp*sin(w2)) + (w3amp*sin(w3)) );

	float4 returnPos;
	returnPos.xyz = vertex.position.xyz + (offsetAmount.xxx * vertex.normal);
	returnPos.w = vertex.position.w;

	// Calculate the new normal for the vert
	float w1normU = w1amp * w1scaleU * cos(w1); //a.b.cos(b.u+c.v+d) where offset=a.sin(b.u+c.v+d)
	float w1normV = w1amp * w1scaleV * cos(w1); //a.c.cos(b.u+c.v+d) where offset=a.sin(b.u+c.v+d)
	float w2normU = w2amp * w2scaleU * cos(w2);
	float w2normV = w2amp * w2scaleV * cos(w2);
	float w3normU = w3amp * w3scaleU * cos(w3);
	float w3normV = w3amp * w3scaleV * cos(w3);
	float normU = atan( (w1normU + w2normU + w3normU)/(2*PI) ) * vertex.color.a;
	float normV = atan( (w1normV + w2normV + w3normV)/(2*PI) ) * vertex.color.a;
	float normOut = sqrt( 1 - ((normU*normU) + (normV*normV)) );

	float3 returnNorm;
	returnNorm = (normU*vertex.tangent) + (normV*vertex.binormal) + (normOut*vertex.normal);

	VertexInput returnVert;
	returnVert.position = returnPos;
	returnVert.normal = returnNorm;
	// Since we use the vert colors to control the deformation, we don't want to use them for actual color
	returnVert.color.rgb = vertex.color.rbg;
	returnVert.color.a = 1;
	returnVert.texCoords = vertex.texCoords;
	returnVert.tangent = vertex.tangent;
	returnVert.binormal = vertex.binormal;


	return returnVert;
}


half3 Phong_DoubleSidedDiffuseLighting( const PixelInput pixel, const half3 normal, const half3 lightDir )
{
	half NdotL;
	half angleAttenuation;

	NdotL = dot( lightDir, normal );
	angleAttenuation = max( (-1*NdotL), NdotL );
	return lightColor0 * angleAttenuation;
}


