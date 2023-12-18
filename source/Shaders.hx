package;

import flixel.system.FlxAssets.FlxShader;
import flixel.system.FlxAssets.FlxShader;
import openfl.display.BitmapData;
import openfl.display.ShaderInput;
import openfl.utils.Assets;
import flixel.FlxG;
import openfl.Lib;
import flixel.math.FlxPoint;

class OverlayShader extends FlxShader
{
	@:glFragmentSource('
		#pragma header
		uniform vec4 uBlendColor;

		vec3 blendLighten(base:Vec3, blend:Vec3) : Vec3 {
			return mix(
				1.0 - 2.0 * (1.0 - base) * (1.0 - blend),
				2.0 * base * blend,
				step( base, vec3(0.5) )
			);
		}

		vec4 blendLighten(vec4 base, vec4 blend, float opacity)
		{
			return (blendLighten(base, blend) * opacity + base * (1.0 - opacity));
		}

		void main()
		{
			vec4 base = texture2D(bitmap, openfl_TextureCoordv);
			gl_FragColor = blendLighten(base, uBlendColor, uBlendColor.a);
		}')
	public function new()
	{
		super();
	}
}

class InvertColorShader extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4((1.0 - color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b) * color.a,   color.a);
        }'
    )

    public function new()
    {
        super();
    }
}

class RedColorShaderTest extends FlxShader
{
    @:glFragmentSource('
        #pragma header

        void main()
        {
            vec4 color = flixel_texture2D(bitmap, openfl_TextureCoordv);
            gl_FragColor = vec4((color.r) * color.a, (1.0 - color.g) * color.a, (1.0 - color.b, color.a);
        }'
    )

    public function new()
    {
        super();
    }
}

class ChromaticAberration extends FlxShader
{
	@:glFragmentSource('
		#pragma header

		uniform float rOffset;
		uniform float gOffset;
		uniform float bOffset;

		void main()
		{
			vec4 col1 = texture2D(bitmap, openfl_TextureCoordv.st - vec2(rOffset * 0.5, 0.0));
			vec4 col2 = texture2D(bitmap, openfl_TextureCoordv.st + vec2(rOffset, 0.0));
			vec4 col3 = texture2D(bitmap, openfl_TextureCoordv.st + vec2(bOffset * 2.5, 0.0));
			vec4 toUse = texture2D(bitmap, openfl_TextureCoordv);
			toUse.r = col1.r;
			toUse.g = col2.g;
			toUse.b = col3.b;
			//float someshit = col4.r + col4.g + col4.b;

			gl_FragColor = toUse;
		}')
	public function new()
	{
		super();

		rOffset.value = [0.0];
		gOffset.value = [0.0];
		bOffset.value = [0.0];
	}
}

class Static extends FlxShader //broken on my pc may work on others need a new graphix card
{
	@:glFragmentSource('
		float rand(vec2 co){
			return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
		}

		void mainImage( out vec4 fragColor, in vec2 fragCoord )
		{

			vec2 uv = fragCoord.xy / iResolution.xy;
			float r = rand(uv*iTime);
			vec4 VI = texture(iChannel0,uv);
			VI*=r; 
			fragColor = vec4(VI);
		}'
		)
	public function new()
    {
        super();
    }
}

class VCRDistortionEffect
{
  public var shader:VCRDistortionShader = new VCRDistortionShader();
  public function new(){
    shader.iTime.value = [0];
    shader.vignetteOn.value = [true];
    shader.perspectiveOn.value = [true];
    shader.distortionOn.value = [true];
    shader.scanlinesOn.value = [true];
    shader.vignetteMoving.value = [true];
    shader.noiseOn.value = [true];
    shader.glitchModifier.value = [1];
    shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
    var noise = Assets.getBitmapData(Paths.getPreloadPath('shared/images/noise2.png'));
    shader.noiseTex.input = noise;
    shader.curvateOn.value = [true];
  }

  public function update(elapsed:Float){
    shader.iTime.value[0] += elapsed;
    shader.iResolution.value = [Lib.current.stage.stageWidth,Lib.current.stage.stageHeight];
  }

  public function setCurvate(state:Bool){
    shader.curvateOn.value[0] = state;
  }

  public function setVignette(state:Bool){
    shader.vignetteOn.value[0] = state;
  }

  public function setNoise(state:Bool){
    shader.noiseOn.value[0] = state;
  }

  public function setPerspective(state:Bool){
    shader.perspectiveOn.value[0] = state;
  }

  public function setGlitchModifier(modifier:Float){
    shader.glitchModifier.value[0] = modifier;
  }

  public function setDistortion(state:Bool){
    shader.distortionOn.value[0] = state;
  }

  public function setScanlines(state:Bool){
    shader.scanlinesOn.value[0] = state;
  }

  public function setVignetteMoving(state:Bool){
    shader.vignetteMoving.value[0] = state;
  }
}

class VCRDistortionShader extends FlxShader
{

  @:glFragmentSource('
    #pragma header

    uniform float iTime;
    uniform bool vignetteOn;
    uniform bool perspectiveOn;
    uniform bool distortionOn;
    uniform bool scanlinesOn;
    uniform bool vignetteMoving;
    uniform sampler2D noiseTex;
    uniform float glitchModifier;
    uniform vec3 iResolution;
    uniform bool noiseOn;
    uniform bool curvateOn;

    vec2 rotate(vec2 v, float a)
    {
      float s = sin(a);
      float c = cos(a);
      mat2 m = mat2(c, -s, s, c);
      return m * v;
    }

    vec2 vCrtCurvature (vec2 uv, float q, float daValues) {
      float x = daValues - distance (uv, vec2 (daValues, daValues));
      vec2 g = vec2 (daValues, daValues) - uv;

      if(curvateOn){
        return uv + g*x*q;
      } else {
        return uv;
      }
    }

    float onOff(float a, float b, float c)
    {
    	return step(c, sin(iTime + a*cos(iTime*b)));
    }

    float ramp(float y, float start, float end)
    {
    	float inside = step(start,y) - step(end,y);
    	float fact = (y-start)/(end-start)*inside;
    	return (1.-fact) * inside;

    }

    float rbgToluminance(vec3 rgb)
    {
      return (rgb.r * 0.3) + (rgb.g * 0.59) + (rgb.b * 0.11);
    }


    vec4 getVideo(vec2 uv)
      {
      	vec2 look = uv;
        if(distortionOn){
        	float window = 1./(1.+20.*(look.y-mod(iTime/4.,1.))*(look.y-mod(iTime/4.,1.)));
        	look.x = look.x + (sin(look.y*10. + iTime)/50.*onOff(4.,4.,.3)*(1.+cos(iTime*80.))*window)*(glitchModifier*2);
        	float vShift = 0.4*onOff(2.,3.,.9)*(sin(iTime)*sin(iTime*20.) +
        										 (0.5 + 0.1*sin(iTime*200.)*cos(iTime)));
        	look.y = mod(look.y + vShift*glitchModifier, 1.);
        }
      	vec4 video = flixel_texture2D(bitmap,look);

      	return video;
      }

    vec2 screenDistort(vec2 uv)
    {
      if(perspectiveOn){
        uv = (uv - 0.5) * 2.0;
      	uv *= 1.1;
      	uv.x *= 1.0 + pow((abs(uv.y) / 5.0), 2.0);
      	uv.y *= 1.0 + pow((abs(uv.x) / 4.0), 2.0);
      	uv  = (uv / 2.0) + 0.5;
      	uv =  uv *0.92 + 0.04;
      	return uv;
      }
    	return uv;
    }
    float random(vec2 uv)
    {
     	return fract(sin(dot(uv, vec2(15.5151, 42.2561))) * 12341.14122 * sin(iTime * 0.03));
    }
    float noise(vec2 uv)
    {
     	vec2 i = floor(uv);
        vec2 f = fract(uv);

        float a = random(i);
        float b = random(i + vec2(1.,0.));
    	float c = random(i + vec2(0., 1.));
        float d = random(i + vec2(1.));

        vec2 u = smoothstep(0., 1., f);

        return mix(a,b, u.x) + (c - a) * u.y * (1. - u.x) + (d - b) * u.x * u.y;

    }


    vec2 scandistort(vec2 uv) {
    	float scan1 = clamp(cos(uv.y * 2.0 + iTime), 0.0, 1.0);
    	float scan2 = clamp(cos(uv.y * 2.0 + iTime + 4.0) * 10.0, 0.0, 1.0);
    	float amount = scan1 * scan2 * uv.x;
      

      uv = uv * 2.0 - 1.0;
      uv *= 0.9;
      uv = (uv + 1.0) * 0.5;

    	uv.x -= 0.05 * mix(flixel_texture2D(noiseTex, vec2(uv.x, amount)).r * amount, amount, 0.9);

    	return uv;

    }

    void main()
    {
    	vec2 uv = openfl_TextureCoordv;
      vec2 uvB = vCrtCurvature(uv, 0.5, 0.5);
      vec2 curUV = screenDistort(uvB);
    	uv = scandistort(curUV);
    	vec4 video = getVideo(uv);
      float vigAmt = 1.0;
      float x =  0.;


      video.r = getVideo(vec2(x+uv.x+0.001,uv.y+0.001)).x+0.05;
      video.g = getVideo(vec2(x+uv.x+0.000,uv.y-0.002)).y+0.05;
      video.b = getVideo(vec2(x+uv.x-0.002,uv.y+0.000)).z+0.05;
      video.r += 0.08*getVideo(0.75*vec2(x+0.025, -0.027)+vec2(uv.x+0.001,uv.y+0.001)).x;
      video.g += 0.05*getVideo(0.75*vec2(x+-0.022, -0.02)+vec2(uv.x+0.000,uv.y-0.002)).y;
      video.b += 0.08*getVideo(0.75*vec2(x+-0.02, -0.018)+vec2(uv.x-0.002,uv.y+0.000)).z;

      video = clamp(video*0.6+0.4*video*video*1.0,0.0,1.0);
      if(vignetteMoving)
    	  vigAmt = 3.+.3*sin(iTime + 5.*cos(iTime*5.));

    	float vignette = (1.-vigAmt*(uv.y-.5)*(uv.y-.5))*(1.-vigAmt*(uv.x-.5)*(uv.x-.5));

      if(vignetteOn)
    	 video *= vignette;

      if(curUV.x<0 || curUV.x>1 || curUV.y<0 || curUV.y>1){
        gl_FragColor = vec4(0,0,0,0);
      }else{
        if(noiseOn){
          gl_FragColor = mix(video,vec4(noise(uv * 75.)),.05);
        }else{
          gl_FragColor = video;
        }

      }
    }
  ')
  public function new()
  {
    super();
  }
}


class NtscShader extends FlxShader {
	@:glFragmentSource('
#pragma header

#pragma format R8G8B8A8_SRGB

#define NTSC_CRT_GAMMA 2.5
#define NTSC_MONITOR_GAMMA 2.0

#define TWO_PHASE
#define COMPOSITE
//#define THREE_PHASE
// #define SVIDEO

// begin params
#define PI 3.14159265

#if defined(TWO_PHASE)
	#define CHROMA_MOD_FREQ (4.0 * PI / 15.0)
#elif defined(THREE_PHASE)
	#define CHROMA_MOD_FREQ (PI / 3.0)
#endif

#if defined(COMPOSITE)
	#define SATURATION 1.0
	#define BRIGHTNESS 1.0
	#define ARTIFACTING 1.0
	#define FRINGING 1.0
#elif defined(SVIDEO)
	#define SATURATION 1.0
	#define BRIGHTNESS 1.0
	#define ARTIFACTING 0.0
	#define FRINGING 0.0
#endif
// end params

uniform int uFrame;
uniform float uInterlace;

// fragment compatibility #defines

#if defined(COMPOSITE) || defined(SVIDEO)
mat3 mix_mat = mat3(
	BRIGHTNESS, FRINGING, FRINGING,
	ARTIFACTING, 2.0 * SATURATION, 0.0,
	ARTIFACTING, 0.0, 2.0 * SATURATION
);
#endif

// begin ntsc-rgbyuv
const mat3 yiq2rgb_mat = mat3(
	1.0, 0.956, 0.6210,
	1.0, -0.2720, -0.6474,
	1.0, -1.1060, 1.7046);

vec3 yiq2rgb(vec3 yiq)
{
	return yiq * yiq2rgb_mat;
}

const mat3 yiq_mat = mat3(
	0.2989, 0.5870, 0.1140,
	0.5959, -0.2744, -0.3216,
	0.2115, -0.5229, 0.3114
);

vec3 rgb2yiq(vec3 col)
{
	return col * yiq_mat;
}
// end ntsc-rgbyuv

#define TAPS 32
const float luma_filter[TAPS + 1] = float[TAPS + 1](
	-0.000174844,
	-0.000205844,
	-0.000149453,
	-0.000051693,
	0.000000000,
	-0.000066171,
	-0.000245058,
	-0.000432928,
	-0.000472644,
	-0.000252236,
	0.000198929,
	0.000687058,
	0.000944112,
	0.000803467,
	0.000363199,
	0.000013422,
	0.000253402,
	0.001339461,
	0.002932972,
	0.003983485,
	0.003026683,
	-0.001102056,
	-0.008373026,
	-0.016897700,
	-0.022914480,
	-0.021642347,
	-0.008863273,
	0.017271957,
	0.054921920,
	0.098342579,
	0.139044281,
	0.168055832,
	0.178571429);

const float chroma_filter[TAPS + 1] = float[TAPS + 1](
	0.001384762,
	0.001678312,
	0.002021715,
	0.002420562,
	0.002880460,
	0.003406879,
	0.004004985,
	0.004679445,
	0.005434218,
	0.006272332,
	0.007195654,
	0.008204665,
	0.009298238,
	0.010473450,
	0.011725413,
	0.013047155,
	0.014429548,
	0.015861306,
	0.017329037,
	0.018817382,
	0.020309220,
	0.021785952,
	0.023227857,
	0.024614500,
	0.025925203,
	0.027139546,
	0.028237893,
	0.029201910,
	0.030015081,
	0.030663170,
	0.031134640,
	0.031420995,
	0.031517031);

// #define fetch_offset(offset, one_x) \\
// 	pass1(uv - vec2(0.5 / openfl_TextureSize.x, 0.0) + vec2((offset) * (one_x), 0.0)).xyzw

#define fetch_offset(offset, one_x) \\
	pass1(uv + vec2((offset - 0.5) * one_x, 0.0)).xyzw

vec4 pass1(vec2 uv)
{
	vec2 fragCoord = uv * openfl_TextureSize;

	vec4 cola = texture2D(bitmap, uv).rgba;
	vec3 yiq = rgb2yiq(cola.rgb);

	#if defined(TWO_PHASE)
		float chroma_phase = PI * (mod(fragCoord.y, 2.0) + float(uFrame));
	#elif defined(THREE_PHASE)
		float chroma_phase = 0.6667 * PI * (mod(fragCoord.y, 3.0) + float(uFrame));
	#endif

	float mod_phase = chroma_phase + fragCoord.x * CHROMA_MOD_FREQ;

	float i_mod = cos(mod_phase);
	float q_mod = sin(mod_phase);

	if(uInterlace == 1.0) {
		yiq.yz *= vec2(i_mod, q_mod); // Modulate.
		yiq *= mix_mat; // Cross-talk.
		yiq.yz *= vec2(i_mod, q_mod); // Demodulate.
	}
	return vec4(yiq, cola.a);
}

void main()
{
	vec2 uv = openfl_TextureCoordv;
	vec2 fragCoord = uv * openfl_TextureSize;

	float one_x = 1.0 / openfl_TextureSize.x;
	vec4 signal = vec4(0.0);

	for (int i = 0; i < TAPS; i++)
	{
		float offset = float(i);

		vec4 sums = fetch_offset(offset - float(TAPS), one_x) +
			fetch_offset(float(TAPS) - offset, one_x);

		signal += sums * vec4(luma_filter[i], chroma_filter[i], chroma_filter[i], 1.0);
	}
	signal += pass1(uv - vec2(0.5 / openfl_TextureSize.x, 0.0)).xyzw *
		vec4(luma_filter[TAPS], chroma_filter[TAPS], chroma_filter[TAPS], 1.0);

	vec3 rgb = yiq2rgb(signal.xyz);
	float alpha = signal.a/(TAPS+1);
	vec4 color = vec4(pow(rgb, vec3(NTSC_CRT_GAMMA / NTSC_MONITOR_GAMMA)), alpha);
	gl_FragColor = color;
}
')

	var topPrefix:String = "";

	public function new() {
		topPrefix = "#version 120\n\n";
		__glSourceDirty = true;

		super();

		this.uFrame.value = [0];
		this.uInterlace.value = [1];
	}

	public var interlace(get, set):Bool;

	function get_interlace() {
		return this.uInterlace.value[0] == 1.0;
	}
	function set_interlace(val:Bool) {
		this.uInterlace.value[0] = val ? 1.0 : 0.0;
		return val;
	}

	override function __updateGL() {
		//this.uFrame.value[0]++;
		this.uFrame.value[0] = (this.uFrame.value[0] + 1) % 2;

		super.__updateGL();
	}

	@:noCompletion private override function __initGL():Void
	{
		if (__glSourceDirty || __paramBool == null)
		{
			__glSourceDirty = false;
			program = null;

			__inputBitmapData = new Array();
			__paramBool = new Array();
			__paramFloat = new Array();
			__paramInt = new Array();

			__processGLData(glVertexSource, "attribute");
			__processGLData(glVertexSource, "uniform");
			__processGLData(glFragmentSource, "uniform");
		}

		@:privateAccess if (__context != null && program == null)
		{
			var gl = __context.gl;

			#if (js && html5)
			var prefix = (precisionHint == FULL ? "precision mediump float;\n" : "precision lowp float;\n");
			#else
			var prefix = "#ifdef GL_ES\n"
				+ (precisionHint == FULL ? "#ifdef GL_FRAGMENT_PRECISION_HIGH\n"
					+ "precision highp float;\n"
					+ "#else\n"
					+ "precision mediump float;\n"
					+ "#endif\n" : "precision lowp float;\n")
				+ "#endif\n\n";
			#end

			var vertex = topPrefix + prefix + glVertexSource;
			var fragment = topPrefix + prefix + glFragmentSource;

			var id = vertex + fragment;

			if (__context.__programs.exists(id))
			{
				program = __context.__programs.get(id);
			}
			else
			{
				program = __context.createProgram(GLSL);

				// TODO
				// program.uploadSources (vertex, fragment);
				program.__glProgram = __createGLProgram(vertex, fragment);

				__context.__programs.set(id, program);
			}

			if (program != null)
			{
				glProgram = program.__glProgram;

				for (input in __inputBitmapData)
				{
					if (input.__isUniform)
					{
						input.index = gl.getUniformLocation(glProgram, input.name);
					}
					else
					{
						input.index = gl.getAttribLocation(glProgram, input.name);
					}
				}

				for (parameter in __paramBool)
				{
					if (parameter.__isUniform)
					{
						parameter.index = gl.getUniformLocation(glProgram, parameter.name);
					}
					else
					{
						parameter.index = gl.getAttribLocation(glProgram, parameter.name);
					}
				}

				for (parameter in __paramFloat)
				{
					if (parameter.__isUniform)
					{
						parameter.index = gl.getUniformLocation(glProgram, parameter.name);
					}
					else
					{
						parameter.index = gl.getAttribLocation(glProgram, parameter.name);
					}
				}

				for (parameter in __paramInt)
				{
					if (parameter.__isUniform)
					{
						parameter.index = gl.getUniformLocation(glProgram, parameter.name);
					}
					else
					{
						parameter.index = gl.getAttribLocation(glProgram, parameter.name);
					}
				}
			}
		}
	}
}

class NtscFX{
	public var shader:NtscShader;
	public function new (){
		shader = new NtscShader();
	}
}