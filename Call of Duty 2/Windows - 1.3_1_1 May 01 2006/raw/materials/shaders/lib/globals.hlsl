#define		SIZECONST_WIDTH			0
#define		SIZECONST_HEIGHT		1
#define		SIZECONST_INV_WIDTH		2
#define		SIZECONST_INV_HEIGHT	3

float4x4	worldMatrix : register( c4 );
float4x4	viewMatrix;
float4x4	projectionMatrix;
float4x4	worldViewMatrix : register( c8 );
float4x4	viewProjectionMatrix;
float4x4	worldViewProjectionMatrix : register( c0 );

float4x4	inverseWorldMatrix;
float4x4	inverseViewMatrix;
float4x4	inverseProjectionMatrix;
float4x4	inverseWorldViewMatrix;
float4x4	inverseViewProjectionMatrix;
float4x4	inverseWorldViewProjectionMatrix;

float4x4	transposeWorldMatrix;
float4x4	transposeViewMatrix;
float4x4	transposeProjectionMatrix;
float4x4	transposeWorldViewMatrix;
float4x4	transposeViewProjectionMatrix;
float4x4	transposeWorldViewProjectionMatrix;

float4x4	inverseTransposeWorldMatrix : register( c8 );
float4x4	inverseTransposeViewMatrix;
float4x4	inverseTransposeProjectionMatrix;
float4x4	inverseTransposeWorldViewMatrix;
float4x4	inverseTransposeViewProjectionMatrix;
float4x4	inverseTransposeWorldViewProjectionMatrix;

float4x4	shadowLookupMatrix : register( c12 );

float4x4 	worldOutdoorLookupMatrix : register( c12 );

float4		lightGridColorsR0 : register( c8 );
float4		lightGridColorsR1 : register( c9 );
float4 		lightGridColorsG0 : register( c10 );
float4 		lightGridColorsG1 : register( c11 );
float4 		lightGridColorsB0 : register( c12 );
float4 		lightGridColorsB1 : register( c13 );
sampler 	lightGridWeightSampler0;
sampler 	lightGridWeightSampler1;

float4 		lightingLookupScale;
float4 		baseLightingCoords;
sampler		smodelLightingSampler;

float4		lightPosition0 : register( c16 );
float4		lightDirection0;
float4		lightColor0 : register( c17 );
float4		lightAmbient0 : register( c18 );
float4		lightSpecular0 : register( c19 );

float4		lightPosition1;
float4		lightDirection1;
float4		lightColor1;
float4		lightAmbient1;
float4		lightSpecular1;

float4		eyePosition : register( c20 );

float4		nearPlaneOrg;
float4		nearPlaneDx;
float4		nearPlaneDy;

#define		GLOW_SETUP_CUTOFF				0
#define		GLOW_SETUP_CUTOFF_RESCALE		1
#define		GLOW_SETUP_DESATURATION			3
float4		glowSetup;

#define		GLOW_APPLY_SKY_BLEED_INTENSITY	0
#define		GLOW_APPLY_BLOOM_INTENSITY		3
float4		glowApply;

float3		fogConsts : register( c11 );
float4		fogColor : register( c21 );
float4		meanBrightness;
float4		materialColor;

float4		gameTime;

float4		renderTargetSize;
float4		clipSpaceLookupScale;
float4		clipSpaceLookupOffset;
float4		shadowmapSize : register( c22 );
float4		shadowParms;
float4		specularStrength;

float4		particleCloudColor;
float4		particleCloudMatrix;
float4		outdoorFeatherParms;

float4		waterMapParms;
float4 		featherParms;

float4		filterTap[8] : register( c8 );

sampler		colorMapSampler;
sampler		lightmapSamplerSun;
sampler		lightmapSamplerR;
sampler		lightmapSamplerG;
sampler		lightmapSamplerB;
sampler		lightmapWeightSampler;
sampler		dynamicShadowSampler;
sampler		shadowCookieSampler;
sampler		normalMapSampler;
sampler		specularMapSampler;
sampler		specularitySampler;
sampler		attenuationSampler;
sampler		cubeMapSampler;
sampler		floatZSampler;
sampler 	outdoorMapSampler;

sampler		detailMapSampler;
float4		detailScale;

static const half3	colorIntensityScale = half3( 0.299, 0.587, 0.114 );


//
// Fog defines
//
#if defined( XENON ) && (defined( FOG_EXP ) || defined( FOG_LINEAR ))
	#define PIXEL_FOG
#endif

#if defined( PIXEL_FOG ) || defined( FOG_EXP ) || defined( FOG_LINEAR )
	#define USE_FOG 1
#else
	#define USE_FOG 0
#endif

#ifdef PIXEL_FOG
	#define FOG_SEMANTIC	TEXCOORD7
#else
	#define FOG_SEMANTIC	FOG
#endif


//
// Normal map defines
//
#ifdef PC
#define NORMAL_MAP_CHANNELS	wy
#endif

#ifdef XENON
#define NORMAL_MAP_CHANNELS	xy
#endif

