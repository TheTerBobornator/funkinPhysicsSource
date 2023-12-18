package;

import flixel.addons.display.FlxBackdrop;
import flixel.addons.effects.chainable.FlxShakeEffect;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.FlxGraphic;
#if desktop
import Discord.DiscordClient;
#end
import Section.SwagSection;
import Song.SwagSong;
import WiggleEffect.WiggleEffectType;
import flixel.FlxBasic;
import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxGame;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.FlxSubState;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.effects.FlxTrail;
import flixel.addons.effects.FlxTrailArea;
import flixel.addons.effects.chainable.FlxEffectSprite;
import flixel.addons.effects.chainable.FlxWaveEffect;
import flixel.addons.transition.FlxTransitionableState;
import flixel.graphics.atlas.FlxAtlas;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.math.FlxRect;
import flixel.system.FlxSound;
import flixel.text.FlxText;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.ui.FlxBar;
import flixel.util.FlxCollision;
import flixel.util.FlxColor;
import flixel.util.FlxSort;
import flixel.util.FlxStringUtil;
import flixel.util.FlxTimer;
import haxe.Json;
import lime.utils.Assets;
import openfl.Lib;
import openfl.display.BlendMode;
import openfl.display.StageQuality;
import openfl.filters.BitmapFilter;
import openfl.utils.Assets as OpenFlAssets;
import editors.ChartingState;
import editors.CharacterEditorState;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import Note.EventNote;
import openfl.events.KeyboardEvent;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.util.FlxSave;
import animateatlas.AtlasFrameMaker;
import Achievements;
import StageData;
import FunkinLua;
import DialogueBoxPsych;
import Conductor.Rating;
import lime.app.Application;
import lime.graphics.RenderContext;
import lime.ui.MouseButton;
import lime.ui.KeyCode;
import lime.ui.KeyModifier;
import lime.ui.Window;
import openfl.geom.Matrix;
import openfl.geom.Rectangle;
import openfl.display.Sprite;
import openfl.utils.Assets;

#if !flash 
import flixel.addons.display.FlxRuntimeShader;
import openfl.filters.ShaderFilter;
#end

#if sys
import sys.FileSystem;
import sys.io.File;
#end

#if VIDEOS_ALLOWED
//#if (hxCodec >= "2.6.1") 
//import hxcodec.VideoHandler as MP4Handler;
//import hxcodec.VideoSprite as MP4Sprite;
//#elseif (hxCodec == "2.6.0") 
//import VideoHandler as MP4Handler;
//import VideoSprite as MP4Sprite;
//#else 
//import vlc.MP4Handler; 
//import vlc.MP4Sprite; 
//#end

// CODEC 2.5.1 BREAKS THIS SHIT USE 2.6.1 ITS SO MUCH BETTER .5 IS A FUCK KILL EM ALL 1984 I FORGET THE REST IM GOING TO UPDATE TO 3.X.X IN THE NEXT UPDATE USE 2.6.1 FO NOW
import hxcodec.VideoHandler;
import hxcodec.VideoSprite;
#end

using StringTools;

class PlayState extends MusicBeatState
{
	public static var STRUM_X = 42;
	public static var STRUM_X_MIDDLESCROLL = -278;

	public static var ratingStuff:Array<Dynamic> = [
		['FFFFFFFFFFFUUUUUUUUUUUUUUUUUUU', 0.2], //From 0% to 19%
		['U Mad Bro?', 0.4], //From 20% to 39%
		['Pro Tip: Git Gud', 0.5], //From 40% to 49%
		['Trolled', 0.6], //From 50% to 59%
		['Problem?', 0.69], //From 60% to 68%
		['Free Epic Sex 2012 No Virus Full Download', 0.7], //69%
		['Trolling', 0.8], //From 70% to 79%
		['Trololololling', 0.9], //From 80% to 89%
		['Hit All The Notes!', 1], //From 90% to 99%
		['Master Troller!!', 1] //The value on this one isn't used actually, since Perfect is always "1"
	];
	public var modchartTweens:Map<String, FlxTween> = new Map<String, FlxTween>();
	public var modchartSprites:Map<String, ModchartSprite> = new Map<String, ModchartSprite>();
	public var modchartTimers:Map<String, FlxTimer> = new Map<String, FlxTimer>();
	public var modchartSounds:Map<String, FlxSound> = new Map<String, FlxSound>();
	public var modchartTexts:Map<String, ModchartText> = new Map<String, ModchartText>();
	public var modchartSaves:Map<String, FlxSave> = new Map<String, FlxSave>();

	//event variables
	private var isCameraOnForcedPos:Bool = false;
	#if (haxe >= "4.0.0")
	public var boyfriendMap:Map<String, Boyfriend> = new Map();
	public var dadMap:Map<String, Character> = new Map();
	public var gfMap:Map<String, Character> = new Map();
	public var variables:Map<String, Dynamic> = new Map();
	#else
	public var boyfriendMap:Map<String, Boyfriend> = new Map<String, Boyfriend>();
	public var dadMap:Map<String, Character> = new Map<String, Character>();
	public var gfMap:Map<String, Character> = new Map<String, Character>();
	public var variables:Map<String, Dynamic> = new Map<String, Dynamic>();
	#end

	public var BF_X:Float = 770;
	public var BF_Y:Float = 100;
	public var DAD_X:Float = 100;
	public var DAD_Y:Float = 100;
	public var GF_X:Float = 400;
	public var GF_Y:Float = 130;

	public var songSpeedTween:FlxTween;
	public var songSpeed(default, set):Float = 1;
	public var songSpeedType:String = "multiplicative";
	public var noteKillOffset:Float = 350;

	public var boyfriendGroup:FlxSpriteGroup;
	public var dadGroup:FlxSpriteGroup;
	public var gfGroup:FlxSpriteGroup;
	public static var curStage:String = '';
	public static var isPixelStage:Bool = false;
	public static var SONG:SwagSong = null;
	public static var isStoryMode:Bool = false;
	public static var storyWeek:Int = 0;
	public static var storyPlaylist:Array<String> = [];
	public static var storyDifficulty:Int = 1;
	public static var songCategory:String = 'incidents'; //variable for returning to the right menu when we have internet songs so we dont switch case every time
	public static var absurde:Bool = false;

	public var spawnTime:Float = 2000;

	public var vocals:FlxSound;

	public var dadGhostTween:FlxTween = null;
	public var gfGhostTween:FlxTween = null;
	public var bfGhostTween:FlxTween = null;
	public var dadGhost:FlxSprite = null;
	public var gfGhost:FlxSprite = null;
	public var bfGhost:FlxSprite = null;
	public var dad:Character = null;
	public var gf:Character = null;
	public var boyfriend:Boyfriend = null;

	public var notes:FlxTypedGroup<Note>;
	public var unspawnNotes:Array<Note> = [];
	public var eventNotes:Array<EventNote> = [];

	private var strumLine:FlxSprite;

	//Handles the new epic mega sexy cam code that i've done
	public static var camFollow:FlxPoint;
	public static var camFollowPos:FlxObject;
	private static var prevCamFollow:FlxPoint;
	private static var prevCamFollowPos:FlxObject;

	public var strumLineNotes:FlxTypedGroup<StrumNote>;
	public var opponentStrums:FlxTypedGroup<StrumNote>;
	public var playerStrums:FlxTypedGroup<StrumNote>;
	public var grpNoteSplashes:FlxTypedGroup<NoteSplash>;
	private var pissStain:FlxSprite;
	private var tim:FlxSprite = null;
	/**Uses notedata to determine the scroll factor so by default its 1 or 2 for down or up scroll**/
	private var curMagnetScroll:Int = 2;

	public var camZooming:Bool = false;
	public var camZoomingMult:Float = 1;
	public var camZoomingDecay:Float = 1;
	private var curSong:String = "";
	private var opponentHealthDrain:Bool = false;
	private var opponentHealthDrainAmount:Float = 0.023;
	private var singingShakeArray:Array<Bool> = [false, false];

	public var gfSpeed:Int = 1;
	public var health:Float = 1;
	public var combo:Int = 0;

	private var healthBarBG:AttachedSprite;
	public var healthBar:FlxBar;
	var songPercent:Float = 0;

	private var timeBarBG:AttachedSprite;
	public var timeBar:FlxBar;

	public var ratingsData:Array<Rating> = [];
	public var sicks:Int = 0;
	public var goods:Int = 0;
	public var bads:Int = 0;
	public var shits:Int = 0;

	private var generatedMusic:Bool = false;
	public var endingSong:Bool = false;
	public var startingSong:Bool = false;
	private var updateTime:Bool = true;
	public static var changedDifficulty:Bool = false;
	public static var chartingMode:Bool = false;

	//Gameplay settings
	public var healthGain:Float = 1;
	public var healthLoss:Float = 1;
	public var instakillOnMiss:Bool = false;
	public var cpuControlled:Bool = false;
	public var practiceMode:Bool = false;

	public var botplaySine:Float = 0;
	public var botplayTxt:FlxText;

	public var iconP1:HealthIcon;
	public var iconP2:HealthIcon;
	public var camHUD:FlxCamera;
	public var camGame:FlxCamera;
	public var camOther:FlxCamera;
	//public var camCutscene:FlxCamera;
	public var cameraSpeed:Float = 1;

	var shadersHUD:Array<BitmapFilter> = [];
	var shadersGame:Array<BitmapFilter> = [];

	var mlgShader:ColorSwap = null;

	var dialogue:Array<String> = ['blah blah blah', 'coolswag'];
	var dialogueJson:DialogueFile = null;

	var dadbattleBlack:BGSprite;
	var dadbattleLight:BGSprite;
	var dadbattleSmokes:FlxSpriteGroup;

	var noEscape1:FlxBackdrop;
	var noEscape2:FlxBackdrop;
	var evilPaintings:BGSprite;
	var evilScreen:BGSprite;

	var overlayThingy:BGSprite;

	var bg1:BGSprite;
	var bg2:BGSprite;

	var light:BGSprite;

	var trollSkele:BGSprite;
	var mcSkele:BGSprite;
	var frontSkele1:BGSprite;
	var frontSkele2:BGSprite;
	var overlay:BGSprite;

	var amazed:BGSprite;

	var cerealChair:BGSprite;
	var spoonAndBowl:BGSprite;
	var thrownTable:BGSprite;

	var idiotSun:BGSprite;
	var idiotCats:FlxTypedGroup<BGSprite>;
	var catDanec:Bool = false;
	var idiotStalkers:FlxTypedGroup<BGSprite>;
	var blackCover:FlxSprite;
	var popupFlxSprite:FlxSprite;
	
	var computer:BGSprite;
	var miniBF:BGSprite;
	var miniSanic:BGSprite;
	var danceFrog:BGSprite;
	var grooby:BGSprite;
	var datBoi:BGSprite;
	var bfWatching:BGSprite;
	var scream:BGSprite;
	var gunshots:BGSprite;

	var sonic:BGSprite;
	var shadow:BGSprite;
	var knuckles:BGSprite;

	var awesomeBG1:BGSprite;
	var awesomeBG2:BGSprite;
	var awesomeFG1:BGSprite;
	var awesomeFG2:BGSprite;
	var awesomeBoppers:FlxTypedGroup<BGSprite>;

	var malleo:BGSprite;
	var weegeeGroup:FlxTypedGroup<Character>;
	var bgShip:BGSprite;
	var bgShipGreen:BGSprite;
	var omegaWeegeeLightBig:BGSprite;
	var omegaWeegeeLightSmall:BGSprite;
	var omegaWeegeeFaces:BGSprite;
	var ship:BGSprite;
	var shipParticles:FlxEmitter;
	var barrels:BGSprite;
	var rope:BGSprite;
	var bubbles:BGSprite;
	#if VIDEOS_ALLOWED
	var weegeeVideo:VideoSprite;
	#end

	public var songScore:Int = 0;
	public var songHits:Int = 0;
	public var songMisses:Int = 0;
	public var scoreTxt:FlxText;
	var timeTxt:FlxText;
	var scoreTxtTween:FlxTween;

	public static var campaignScore:Int = 0;
	public static var campaignMisses:Int = 0;
	public static var seenCutscene:Bool = false;
	public static var deathCounter:Int = 0;

	public var defaultCamZoom:Float = 1.05;

	// how big to stretch the pixel art assets
	public static var daPixelZoom:Float = 6;
	private var singAnimations:Array<String> = ['singLEFT', 'singDOWN', 'singUP', 'singRIGHT'];

	public var inCutscene:Bool = false;
	public var skipCountdown:Bool = false;
	public var skipCredit:Bool = false;
	public var songLength:Float = 0;
	public static var mania = 0;

	public var boyfriendCameraOffset:Array<Float> = null;
	public var opponentCameraOffset:Array<Float> = null;
	public var girlfriendCameraOffset:Array<Float> = null;

	#if desktop
	// Discord RPC variables
	var storyDifficultyText:String = "";
	var detailsText:String = "";
	var detailsPausedText:String = "";
	#end

	//Achievement shit
	var keysPressed:Array<Bool> = [];
	var boyfriendIdleTime:Float = 0.0;
	var boyfriendIdled:Bool = false;

	// Lua shit
	public static var instance:PlayState;
	public var luaArray:Array<FunkinLua> = [];
	private var luaDebugGroup:FlxTypedGroup<DebugLuaText>;
	public var introSoundsSuffix:String = '';

	// Debug buttons
	private var debugKeysChart:Array<FlxKey>;
	private var debugKeysCharacter:Array<FlxKey>;

	// Less laggy controls
	private var keysArray:Array<Dynamic>;
	private var controlArray:Array<String>;

	var precacheList:Map<String, String> = new Map<String, String>();

	/**
	 * map for telling which game over and pause songs we use
	 * ignores any song that uses "upbeat", its the default one so we dont gotta worry **/ 
	public static var pauseMusicPerSongMap:Map<String, String> = new Map<String, String>();

	override public function create()
	{
		Paths.clearStoredMemory();

		// for lua
		instance = this;

		debugKeysChart = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));
		debugKeysCharacter = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_2'));

		//Ratings
		ratingsData.push(new Rating('sick')); //default rating

		var rating:Rating = new Rating('good');
		rating.ratingMod = 0.7;
		rating.score = 200;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('bad');
		rating.ratingMod = 0.4;
		rating.score = 100;
		rating.noteSplash = false;
		ratingsData.push(rating);

		var rating:Rating = new Rating('shit');
		rating.ratingMod = 0;
		rating.score = 50;
		rating.noteSplash = false;
		ratingsData.push(rating);

		if (FlxG.sound.music != null)
			FlxG.sound.music.stop();

		// Gameplay settings
		healthGain = ClientPrefs.getGameplaySetting('healthgain', 1);
		healthLoss = ClientPrefs.getGameplaySetting('healthloss', 1);
		instakillOnMiss = ClientPrefs.getGameplaySetting('instakill', false);
		practiceMode = ClientPrefs.getGameplaySetting('practice', false);
		cpuControlled = ClientPrefs.getGameplaySetting('botplay', false);

		// var gameCam:FlxCamera = FlxG.camera;
		camGame = new FlxCamera();
		//camGame.setSize(FlxG.width * 2, FlxG.height* 2); breaks scroll speed on some bgs maybe in the future? thansk anyway duskie / dsides
		//camGame.setPosition(-1 * (FlxG.width / 2), -1 * (FlxG.width / 4));
		camHUD = new FlxCamera();
		camHUD.bgColor.alpha = 0;
		//camHUD.setSize(FlxG.width * 2, FlxG.height* 2);
		//camHUD.setPosition(-1 * (FlxG.width / 2), -1 * (FlxG.width / 4));
		camOther = new FlxCamera();
		camOther.bgColor.alpha = 0;
		//camOther.setSize(FlxG.width * 2, FlxG.height* 2);
		//.setPosition(-1 * (FlxG.width / 2), -1 * (FlxG.width / 4));

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camHUD, false);
		FlxG.cameras.add(camOther, false);
		grpNoteSplashes = new FlxTypedGroup<NoteSplash>();

		FlxG.cameras.setDefaultDrawTarget(camGame, true);
		CustomFadeTransition.nextCamera = camOther;
		FlxG.mouse.visible = false;

		persistentUpdate = true;
		persistentDraw = true;

		if (SONG == null)
			SONG = Song.loadFromJson('tutorial');

		mania = SONG.mania;

		setKeys(mania, false);

		//if (PlayState.SONG.song.toLowerCase() == 'absurde')
		//	absurde = true;

		// For the "Just the Two of Us" achievement
		for (i in 0...keysArray.length)
		{
			keysPressed.push(false);
		}

		Conductor.mapBPMChanges(SONG);
		Conductor.changeBPM(SONG.bpm);

		#if desktop
		storyDifficultyText = CoolUtil.difficulties[storyDifficulty];

		// String that contains the mode defined here so it isn't necessary to call changePresence for each mode
		if (isStoryMode)
		{
			detailsText = "Story Mode: ";// + WeekData.getCurrentWeek().weekName;
		}
		else
		{
			detailsText = "Freeplay";
		}

		// String for when the game is paused
		detailsPausedText = "Paused - " + detailsText;
		#end

		GameOverSubstate.resetVariables();
		var songName:String = Paths.formatToSongPath(SONG.song);

		pauseMusicPerSongMap = 
		[
			"foretoken" => "Chill",
			"mistaken" => "Chill",
			"impending doom" => "Tense",
			"the incident" => "Tense",
			"tomfoolery" => "Tense",
			"tomfoolery (old)" => "Tense",
			"turn the trolls off" => "Chill",
			"imposter" => "Tense",
			"smile" => "Chill",
			"trollistic" => "Chill",
			"alone forever" => "Chill",
			"happiness" => "Chill",
			"controlling yourself" => "Tense",
			"spooky scary" => "Chill",
			"idiot" => "Chill"
		];

		if (pauseMusicPerSongMap.get(SONG.song.toLowerCase()) == null)
		{
			GameOverSubstate.loopSoundName = 'gameOverUpbeat';
			GameOverSubstate.endSoundName = 'gameOverUpbeatEnd';
		}
		else
		{
			GameOverSubstate.loopSoundName = 'gameOver${pauseMusicPerSongMap.get(SONG.song.toLowerCase());}';
			GameOverSubstate.endSoundName = 'gameOver${pauseMusicPerSongMap.get(SONG.song.toLowerCase());}End';
		}		

		curStage = SONG.stage;
		//trace('stage is: ' + curStage);
		if(SONG.stage == null || SONG.stage.length < 1) {
			switch (songName)
			{
				default:
					curStage = 'stage';
			}
		}
		SONG.stage = curStage;

		var stageData:StageFile = StageData.getStageFile(curStage);
		if(stageData == null) { //Stage couldn't be found, create a dummy stage for preventing a crash
			stageData = {
				directory: "",
				defaultZoom: 0.9,
				isPixelStage: false,

				boyfriend: [770, 100],
				girlfriend: [400, 130],
				opponent: [100, 100],
				hide_girlfriend: false,

				camera_boyfriend: [0, 0],
				camera_opponent: [0, 0],
				camera_girlfriend: [0, 0],
				camera_speed: 1
			};
		}

		defaultCamZoom = stageData.defaultZoom;
		isPixelStage = stageData.isPixelStage;
		BF_X = stageData.boyfriend[0];
		BF_Y = stageData.boyfriend[1];
		GF_X = stageData.girlfriend[0];
		GF_Y = stageData.girlfriend[1];
		DAD_X = stageData.opponent[0];
		DAD_Y = stageData.opponent[1];

		if(stageData.camera_speed != null)
			cameraSpeed = stageData.camera_speed;

		boyfriendCameraOffset = stageData.camera_boyfriend;
		if(boyfriendCameraOffset == null) //Fucks sake should have done it since the start :rolling_eyes:
			boyfriendCameraOffset = [0, 0];

		opponentCameraOffset = stageData.camera_opponent;
		if(opponentCameraOffset == null)
			opponentCameraOffset = [0, 0];

		girlfriendCameraOffset = stageData.camera_girlfriend;
		if(girlfriendCameraOffset == null)
			girlfriendCameraOffset = [0, 0];

		boyfriendGroup = new FlxSpriteGroup(BF_X, BF_Y);
		dadGroup = new FlxSpriteGroup(DAD_X, DAD_Y);
		gfGroup = new FlxSpriteGroup(GF_X, GF_Y);

		switch (curStage)
		{
			case 'stage': //Week 1
				var bg:BGSprite = new BGSprite('stageback', -600, -200, 0.9, 0.9);
				add(bg);

				var stageFront:BGSprite = new BGSprite('stagefront', -650, 600, 0.9, 0.9);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				if(!ClientPrefs.lowQuality) {
					var stageLight:BGSprite = new BGSprite('stage_light', -125, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					add(stageLight);
					var stageLight:BGSprite = new BGSprite('stage_light', 1225, -100, 0.9, 0.9);
					stageLight.setGraphicSize(Std.int(stageLight.width * 1.1));
					stageLight.updateHitbox();
					stageLight.flipX = true;
					add(stageLight);

					var stageCurtains:BGSprite = new BGSprite('stagecurtains', -500, -300, 1.3, 1.3);
					stageCurtains.setGraphicSize(Std.int(stageCurtains.width * 0.9));
					stageCurtains.updateHitbox();
					add(stageCurtains);
				}
				dadbattleSmokes = new FlxSpriteGroup(); //troll'd

			case 'troll-house':
				var bg:BGSprite = new BGSprite('backgrounds/troll-house/bg', -600, -400, 0.9, 0.9);
				add(bg);
				var deskShit:BGSprite = new BGSprite('backgrounds/troll-house/deskShit', -530, 240, 0.95, 0.95);
				add(deskShit);
			case 'absurde':
				var bg:BGSprite = new BGSprite('backgrounds/troll-house/bg', -600, -400, 0.9, 0.9);
				add(bg);
				var deskShit:BGSprite = new BGSprite('backgrounds/troll-house/deskShit', -530, 240, 0.95, 0.95);
				add(deskShit);
				setUpSpacebarMashMechanic('trollface', false);

			case 'troll-house-mad':
				FlxG.camera.bgColor = 0xFFff0202;
				
				noEscape1 = new FlxBackdrop(Paths.image('backgrounds/troll-house-mad/Window text_'), 0.9, 0.9, false, true, 0, 797);
				noEscape1.setPosition(915, -345);
				noEscape1.antialiasing = ClientPrefs.globalAntialiasing;
				add(noEscape1);
				noEscape2 = new FlxBackdrop(Paths.image('backgrounds/troll-house-mad/Window text_'), 0.9, 0.9, false, true, 0, 797);
				noEscape2.setPosition(915, -345 - 797);
				noEscape2.antialiasing = ClientPrefs.globalAntialiasing;
				add(noEscape2);
				evilPaintings = new BGSprite('backgrounds/troll-house-mad/paintings' + FlxG.random.int(1, 5), -600, -235, 0.9, 0.9);
				add(evilPaintings);
				var bg:BGSprite = new BGSprite('backgrounds/troll-house-mad/bgAnimated', -600, -400, 0.9, 0.9, ['bgIdle'], (ClientPrefs.shaking ? true : false));
				bg.dance();
				add(bg);
				evilScreen = new BGSprite('backgrounds/troll-house-mad/screenThing', -155, 270, 0.95, 0.95);
				add(evilScreen);
				var deskShit:BGSprite = new BGSprite('backgrounds/troll-house-mad/deskAnimated', -380, 220, 0.95, 0.95, ['deskIdle'], (ClientPrefs.shaking ? true : false));
				deskShit.dance();
				add(deskShit);
				addVignetteToStage();

				if (!ClientPrefs.photosensitivity)
				{
					// yeah???
					var desatShader:ColorSwap = new ColorSwap();
					desatShader.saturation = -0.4;
					desatShader.brightness = -0.2;

					evilPaintings.shader = desatShader.shader;
					bg.shader = desatShader.shader;
					evilScreen.shader = desatShader.shader;
					deskShit.shader = desatShader.shader;
				}

				introSoundsSuffix = '-troll';

			case 'troll-house-old':
				var bg:BGSprite = new BGSprite('backgrounds/troll-house-old/bg', -600, -220, 0.9, 0.9);
				add(bg);
				var deskShit:BGSprite = new BGSprite('backgrounds/troll-house-old/office', -300, 120, 0.9, 0.9, ['Bottom']);
				add(deskShit);
			case 'troll-house-mad-old':
				var bg:BGSprite = new BGSprite('backgrounds/troll-house-mad-old/dear god help', -600, -220, 0.9, 0.9);
				add(bg);
				var deskShit:BGSprite = new BGSprite('backgrounds/troll-house-mad-old/office', -300, 120, 0.9, 0.9, ['Bottom']);
				add(deskShit);
				introSoundsSuffix = '-troll';

			case 'bf-house':
				var bg:BGSprite = new BGSprite('backgrounds/tomfoolery/rom', -600, -400, 0.95, 0.95);
				add(bg);

				overlayThingy = new BGSprite('backgrounds/tomfoolery/shad', 0, 0, 0, 0);
				overlayThingy.screenCenter();
				addVignetteToStage();
				introSoundsSuffix = '-troll';

			case 'ttto':
				bg1 = new BGSprite('backgrounds/ttto/BG', -700, -300, 1.0, 1.0);
				bg1.setGraphicSize(Std.int(bg1.width * 2));
				bg1.updateHitbox();
				add(bg1);
				bg2 = new BGSprite('backgrounds/ttto/BGalt', -700, -300, 1.0, 1.0);
				bg2.setGraphicSize(Std.int(bg2.width * 2));
				bg2.updateHitbox();
				bg2.alpha = 0.00001;
				add(bg2);
				introSoundsSuffix = '-troll';
				FlxG.camera.bgColor = FlxColor.WHITE;

			case 'alone' | 'happy':
				var bg:BGSprite = new BGSprite('backgrounds/' + curStage + '/BGB', -600, -300, 0.7, 0.7);
				add(bg);
				overlayThingy = new BGSprite('backgrounds/' + curStage + '/BGF', -600, -300, 1, 1);
				introSoundsSuffix = '-troll';

			case 'happy-new':
				var bg:BGSprite = new BGSprite('backgrounds/happy/bgFull', -550, -150, 1, 1);
				bg.setGraphicSize(Std.int(bg.width * 0.95));
				bg.updateHitbox();
				add(bg);
				addVignetteToStage();
				introSoundsSuffix = '-troll';

			case 'trolldown':
				var bg:BGSprite = new BGSprite('backgrounds/trolldown/stageback', -800, -800, 0.9, 0.9);
				bg.setGraphicSize(Std.int(bg.width * 1.2));
				bg.updateHitbox();
				add(bg);

				var stageFront:BGSprite = new BGSprite('backgrounds/trolldown/stagefront', -650, 600);
				stageFront.setGraphicSize(Std.int(stageFront.width * 1.1));
				stageFront.updateHitbox();
				add(stageFront);
				introSoundsSuffix = '-troll';

			case 'imposter':
				var bg:BGSprite = new BGSprite('backgrounds/imposter/bg', -1100, -700, 0.9, 0.9);
				bg.angularVelocity = 30;
				bg.active = true;
				bg.setGraphicSize(Std.int(bg.width * 4.5));
				bg.updateHitbox();
				bg.screenCenter();
				add(bg);
				introSoundsSuffix = '-troll';

			case 'minecraft':
				var bg:BGSprite = new BGSprite('backgrounds/minecraft/bg', -1400, -1000);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				add(bg);

			case 'gmod':
				var bg:BGSprite = new BGSprite('backgrounds/gmod/bgNew', -600, -400, 0.95, 0.95);
				bg.setGraphicSize(Std.int(bg.width * 1.4));
				bg.updateHitbox();
				add(bg);

			case 'smile':
				var bg:BGSprite = new BGSprite('backgrounds/smile/alley', -800, -400, 1, 1);
				bg.setGraphicSize(Std.int(bg.width * 1.5));
				bg.updateHitbox();
				add(bg);
				light = new BGSprite('backgrounds/smile/lights', bg.x, bg.y, 1, 1, ['lights on', 'lights off'], false);
				light.setGraphicSize(Std.int(bg.width));
				light.updateHitbox();
				add(light);
				introSoundsSuffix = '-troll';
			
			case 'trollistic':
				bg1 = new BGSprite('backgrounds/trollistic/whittyback', -600, -300, 0.9, 0.9);
				add(bg1);
				bg2 = new BGSprite('backgrounds/trollistic/BallisticBackground', -600, -300, 0.9, 0.9, ['Background Whitty Moving'], true);
				bg2.alpha = 0.00001;
				add(bg2);
				introSoundsSuffix = '-troll';
			
			case 'graveyard':
				var fog:BGSprite = new BGSprite('backgrounds/graveyard/the-fog-is-coming', -460, -50, 0.7, 0.7);
				add(fog);
				var ground:BGSprite = new BGSprite('backgrounds/graveyard/ground', -460, -100, 1.0, 1.0);
				add(ground);
				var headstones:BGSprite = new BGSprite('backgrounds/graveyard/headstones', -460, -50, 1.0, 1.0);
				add(headstones);
				
				trollSkele = new BGSprite('backgrounds/graveyard/TrollSkull_Assets', -400, 450, 1.0, 1.0, ['TrollSkull_Assets'], false);
				add(trollSkele);
				mcSkele = new BGSprite('backgrounds/graveyard/MCSkeleton_Assets', 1300, 350, 1.0, 1.0, ['MCSkeleton_Assets'], false);
				add(mcSkele);
				//var sans:BGSprite = new BGSprite('backgrounds/graveyard/Sans_Assets', 1400, 600, 1.0, 1.0, ['Sans_Assets'], false);
				//add(sans);
				frontSkele1 = new BGSprite('backgrounds/graveyard/FrontSkeleton1_Assets', -400, 800, 1.1, 1.1, ['FrontSkeleton1_Assets'], false);
				frontSkele2 = new BGSprite('backgrounds/graveyard/FrontSkeleton2_Assets', 1500, 900, 1.1, 1.1, ['FrontSkeleton2_Assets'], false);
				overlay = new BGSprite('backgrounds/graveyard/trees', -460, -50, 1.2, 1.2);

			case 'hell':
				var bg:BGSprite = new BGSprite('backgrounds/hell/bg-improved', 0, 0, 0, 0);
				bg.screenCenter();
				add(bg);
				amazed = new BGSprite('backgrounds/hell/amazedplush', 0, 0, 0.95, 0.95, ['amazedplush idle'], true);
				amazed.screenCenter();
			
			case 'kitchen':
				FlxG.camera.bgColor = FlxColor.WHITE;
				var floor:BGSprite = new BGSprite('backgrounds/kitchen/floor', -800, 803, 1.0, 1.0);
				add(floor);
				var counter:BGSprite = new BGSprite('backgrounds/kitchen/counter', -800, 166, 0.9, 0.9);
				add(counter);
				var top:BGSprite = new BGSprite('backgrounds/kitchen/topFull', -800, -250, 0.9, 0.9);
				add(top);
				cerealChair = new BGSprite('characters/internet/cerealChair', -282, 558, 1, 1);
				cerealChair.setGraphicSize(Std.int(cerealChair.width * 1.1));
				cerealChair.updateHitbox();
				cerealChair.alpha = 0.00001;
				add(cerealChair);
				spoonAndBowl = new BGSprite('characters/internet/spoonAndBowl', 852, 875, 1, 1);
				spoonAndBowl.setGraphicSize(Std.int(spoonAndBowl.width * 1.1));
				spoonAndBowl.updateHitbox();
				spoonAndBowl.alpha = 0.00001;
				thrownTable = new BGSprite('characters/internet/tableThrowDodgable', 500, 610, 1, 1, ['tablespin0'], true);
				thrownTable.setGraphicSize(Std.int(thrownTable.width * 1.1));
				thrownTable.updateHitbox();
				thrownTable.dance();
				thrownTable.alpha = 0.00001;
				overlayThingy = new BGSprite('backgrounds/kitchen/overlayThing', -800, 75, 1.1, 1.1);

			case 'idiot':
				FlxG.camera.bgColor = FlxColor.WHITE;

				idiotSun = new BGSprite('backgrounds/idiot/thesun', 0, -1200, 0.1, 0.1, ['sun bop']);
				idiotSun.screenCenter(X);
				idiotSun.x -= 50;
				add(idiotSun);

				idiotCats = new FlxTypedGroup<BGSprite>();
				idiotCats.cameras = [camHUD];
				add(idiotCats);

				var cat1:BGSprite = new BGSprite('backgrounds/idiot/kitty', 0, 0, 0.9, 0.9, ['kitty']);
				//cat1.setPosition(-75, FlxG.height - cat1.height + 150);
				cat1.setPosition(-75, FlxG.height);
				cat1.animation.addByIndices('danceLeft', 'kitty', [0, 1, 2, 3, 4, 5, 6], '', 24, false);
				cat1.animation.addByIndices('danceRight', 'kitty', [7, 8, 9, 10, 11, 12, 13], '', 24, false);
				idiotCats.add(cat1);

				var cat2:BGSprite = new BGSprite('backgrounds/idiot/cta_idl', 0, 0, 0.9, 0.9, ['ctaidle']);
				//cat2.setPosition(FlxG.width - cat2.width - 60, FlxG.height - cat2.height);
				cat2.setPosition(FlxG.width - cat2.width - 60, FlxG.height);
				cat2.animation.addByIndices('danceLeft', 'ctaidle', [0, 1, 2, 3, 4, 5], '', 24, false);
				cat2.animation.addByIndices('danceRight', 'ctaidle', [6, 7, 8, 9, 10, 11], '', 24, false);
				idiotCats.add(cat2);

				idiotStalkers = new FlxTypedGroup<BGSprite>();
				for (i in 0...2)
				{
					var stalker:BGSprite = new BGSprite('backgrounds/idiot/stalker1', 0, 0, 1, 1, ['stalkeridle']);
					stalker.cameras = [camHUD];
					stalker.ID = i;
					stalker.setGraphicSize(Std.int(stalker.width * 0.6));
					stalker.updateHitbox();
					stalker.y = (FlxG.height - stalker.height) + 100;
					if (i == 0)
					{
						stalker.flipX = true;
						stalker.x = -100 - stalker.width;
					}
					else
						stalker.x = FlxG.width + 100;

					idiotStalkers.add(stalker);
				}

				blackCover = new FlxSprite(-FlxG.width * 2, -FlxG.height * 2).makeGraphic(FlxG.width * 5, FlxG.height * 5, FlxColor.BLACK);
				blackCover.scrollFactor.set(0, 0);
				add(blackCover);

				popupFlxSprite = new FlxSprite();
				popupFlxSprite.frames = Paths.getSparrowAtlas('backgrounds/idiot/popup');
				popupFlxSprite.animation.addByPrefix('idle', "idiotFlash", 24, true);
				popupFlxSprite.animation.play('idle', true);
			case 'derp':
				FlxG.camera.bgColor = 0xFF5fc5de;
				var buldings:BGSprite = new BGSprite('backgrounds/derp/buildings_yayy', -1000, -700, 0.7, 0.7, ['buildings yayy'], true);
				add(buldings);
				var road:BGSprite = new BGSprite('backgrounds/derp/its_called_a_road', -1500, 600, 1, 1, ['Road road road'], true);
				add(road);
				var stopSign:BGSprite = new BGSprite('backgrounds/derp/stop_sign_blur_this', 1200, 300, 1.5, 1.5, ['Stop sign'], true);
				stopSign.setGraphicSize(Std.int(stopSign.width * 0.7));
				stopSign.updateHitbox();
				add(stopSign);
				//var bg:BGSprite = new BGSprite('backgrounds/derp/bg', -800, -400, 0.9, 0.9);
				//add(bg);
			case 'msp':
				var bg:BGSprite = new BGSprite('backgrounds/msp/paint', -800, -800, 1, 1);
				bg.setGraphicSize(Std.int(bg.width * 4.5));
				bg.updateHitbox();
				add(bg);
			case 'mlg-studio':
				var bg:BGSprite = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_mainBG', -600, -200, 1, 1);
				add(bg);
				var lights:BGSprite = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_lightStands', 300, 320, 1, 1);
				add(lights);
				computer = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_computer', 750, 950, 1.3, 1.3);
				miniBF = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_computerBF', 1280, 1170, 1.3, 1.3, ['minib_idle0']);
				miniBF.animation.addByPrefix('idle', "minib_idle0", 24, true);
				miniBF.animation.addByPrefix('singLEFT', "minib_left0", 24, false);
				miniBF.animation.addByPrefix('singDOWN', "minib_down0", 24, false);
				miniBF.animation.addByPrefix('singUP', "minib_up0", 24, false);
				miniBF.animation.addByPrefix('singRIGHT', "minib_right0", 24, false);
				miniBF.animation.play('idle');
				miniSanic = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_computerSN', 1080, 1130, 1.3, 1.3, ['minisonc_idle0']);
				miniSanic.animation.addByPrefix('idle', "minisonc_idle0", 24, true);
				miniSanic.animation.addByPrefix('singLEFT', "minisonc_left0", 24, false);
				miniSanic.animation.addByPrefix('singDOWN', "minisonc_down0", 24, false);
				miniSanic.animation.addByPrefix('singUP', "minisonc_up0", 24, false);
				miniSanic.animation.addByPrefix('singRIGHT', "minisonc_right0", 24, false);
				miniSanic.animation.play('idle');

				bg2 = new BGSprite('backgrounds/mlg-studio/sanicSTAGE3_mainBG', -250, 0, 1, 1);
				bg2.setGraphicSize(Std.int(bg2.width * 1.3));
				bg2.updateHitbox();
				bg2.alpha = 0.00001;
				add(bg2);
				mlgShader = new ColorSwap();
				danceFrog = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_dancingFrog', 1170, 370, 1, 1, ['froggiedance'], true);
				danceFrog.setGraphicSize(Std.int(danceFrog.width * 1.3));
				danceFrog.updateHitbox();
				danceFrog.alpha = 0.00001;
				danceFrog.dance();
				//danceFrog.shader = mlgShader.shader;
				add(danceFrog);
				grooby = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_goobyBG', 1521, 96, 1, 1, ['goobyidle'], false);
				grooby.setGraphicSize(Std.int(grooby.width * 1.3));
				//grooby.updateHitbox();
				grooby.alpha = 0.00001;
				grooby.dance();
				add(grooby);
				datBoi = new BGSprite('backgrounds/mlg-studio/sanicSTAGE2_unicycleFrog', 1720, 260, 1, 1, ['unicyclefrogbalance'], true);
				datBoi.setGraphicSize(Std.int(datBoi.width * 1.3));
				datBoi.updateHitbox();
				datBoi.alpha = 0.00001;
				datBoi.dance();
				add(datBoi);
				bfWatching = new BGSprite('backgrounds/mlg-studio/sanicSTAGE3_bfCamera', 2200, 820, 3.6, 1, ['cambf_idle0'], false);
				bfWatching.animation.addByPrefix('turn', "cambf_turning0", 24, false);
				bfWatching.setGraphicSize(Std.int(bfWatching.width * 1.3));
				bfWatching.updateHitbox();
				bfWatching.alpha = 0.00001;
				bfWatching.animation.finishCallback = function(anim:String)
				{
					//if (anim == 'turn')
					{
						if (SONG.notes[curSection] != null)
						{
							if (SONG.notes[curSection].mustHitSection == true)
								bfWatching.flipX = true;
							else
								bfWatching.flipX = false;
						}
					}
				}
				bfWatching.dance();

				scream = new BGSprite('backgrounds/mlg-studio/scream', 950, 500, 1, 1, ['screamAnimat'], false);
				scream.animation.addByPrefix('idle', "screamAnimat", 24, true);
				scream.setGraphicSize(Std.int(scream.width * 0.8));
				//scream.updateHitbox();
				scream.alpha = 0.00001;
				scream.dance();
				gunshots = new BGSprite('backgrounds/mlg-studio/owned', 0, 0, 1, 1, ['shot'], false);
				gunshots.animation.addByPrefix('idle', "shot", 24, true);
				gunshots.setGraphicSize(Std.int(gunshots.width * 2));
				gunshots.updateHitbox();
				gunshots.alpha = 0.00001;
				gunshots.cameras = [camOther];
				gunshots.dance();
				add(gunshots);

			case 'tgt':
				var bg:BGSprite = new BGSprite('backgrounds/tgt/bg', -500, -350, 0.9, 0.9);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				add(bg);

				sonic = new BGSprite('backgrounds/tgt/bluepokemon', -480, -150, 0.9, 0.9, ['bluepokemon']);
				sonic.setGraphicSize(Std.int(sonic.width * 0.7));
				sonic.updateHitbox();
				add(sonic);
			
				shadow = new BGSprite('backgrounds/tgt/ShadowBop', 820, -300, 0.9, 0.9, ['EdgyLol']);
				shadow.setGraphicSize(Std.int(shadow.width * 0.7));
				shadow.updateHitbox();
				add(shadow);
			
				knuckles = new BGSprite('backgrounds/tgt/cracksmoekr', 1220, -50, 0.9, 0.9, ['chainsmoker']);
				knuckles.setGraphicSize(Std.int(knuckles.width * 0.7));
				knuckles.updateHitbox();
				add(knuckles);
			case 'cy-chase':
				FlxG.camera.bgColor = FlxColor.WHITE;
				var bgSquiggle:BGSprite = new BGSprite('backgrounds/cy/lineBGImproved', -2100, 400, 1.0, 1.0, ['betterLineLol'], true);
				bgSquiggle.setGraphicSize(Std.int(bgSquiggle.width * 2.5), Std.int(bgSquiggle.height));
				bgSquiggle.updateHitbox();
				add(bgSquiggle);
				addVignetteToStage(0.00001);
				introSoundsSuffix = '-troll';
			case 'white':
				FlxG.camera.bgColor = FlxColor.WHITE;
			case 'bikini-bottom':
				var bg:BGSprite = new BGSprite('backgrounds/bikini-bottom-old/bg', -800, -300, 0.6, 0.6);
				add(bg);
				var houses:BGSprite = new BGSprite('backgrounds/bikini-bottom-old/houses', 162, 95, 0.85, 0.85);
				add(houses);
				var fg:BGSprite = new BGSprite('backgrounds/bikini-bottom-old/fg', -800, 323, 1.0, 1.0);
				add(fg);
				var sponge:BGSprite = new BGSprite('backgrounds/bikini-bottom-old/sponge', 1156, -300, 0.9, 0.9);
				add(sponge);
				var squid:BGSprite = new BGSprite('backgrounds/bikini-bottom-old/squ', -800, -300, 0.95, 0.95);
				add(squid);
			case 'bikini-bottom-new':
				var bg:BGSprite = new BGSprite('backgrounds/bikini-bottom/sky', -1000, -300, 0.6, 0.6);
				bg.setGraphicSize(Std.int(bg.width * 2));
				bg.updateHitbox();
				add(bg);
				var bgSand:BGSprite = new BGSprite('backgrounds/bikini-bottom/background_floor', -800, 712, 0.7, 0.7);
				bgSand.setGraphicSize(Std.int(bgSand.width * 2));
				bgSand.updateHitbox();
				add(bgSand);
				var fg:BGSprite = new BGSprite('backgrounds/bikini-bottom/floor', -800, 1254, 1, 1);
				fg.setGraphicSize(Std.int(fg.width * 2));
				fg.updateHitbox();
				add(fg);
			//	var fgSpecial = new Floor(-800, 377, 'backgrounds/bikini-bottom/floor');
			//	fgSpecial.setGraphicSize(Std.int(fgSpecial.width * 2));
			//	fgSpecial.updateHitbox();
			//	add(fgSpecial);
				var houses:BGSprite = new BGSprite('backgrounds/bikini-bottom/houses', -900, -300, 0.85, 0.85);
				houses.setGraphicSize(Std.int(houses.width * 2));
				houses.updateHitbox();
				add(houses);
				malleo = new BGSprite('backgrounds/bikini-bottom/malleo', 2350, 300, 0.85, 0.85, ['malleo']);
				malleo.setGraphicSize(Std.int(malleo.width * 2));
				malleo.updateHitbox();
				malleo.alpha = 0.00001;
				add(malleo);
				weegeeGroup = new FlxTypedGroup<Character>();
				add(weegeeGroup);
				for (i in 0...6)
				{
					var weeg:Character = new Character(0, 0, 'weegee');
					switch (i)
					{
						case 5: 
							weeg.setPosition(300, 1020);
						case 4: 
							weeg.scrollFactor.set(0.95, 0.95);
							weeg.setPosition(700, 920);
						case 3: 
							weeg.scrollFactor.set(0.85, 0.85);
							weeg.setPosition(1100, 800);
						case 2: 
							weeg = new Character(0, 0, 'weegee-flipped');
							weeg.setPosition(3400, 1020);
							weeg.flipX = false;
						case 1: 
							weeg = new Character(0, 0, 'weegee-flipped');
							weeg.scrollFactor.set(0.95, 0.95);
							weeg.setPosition(3000, 920);
							weeg.flipX = false;
						case 0: 
							weeg = new Character(0, 0, 'weegee-flipped');
							weeg.scrollFactor.set(0.85, 0.85);
							weeg.setPosition(2600, 800);
							weeg.flipX = false;
					}
					weeg.x -= 900;
					weeg.y -= 50;
					weeg.dance();
					weeg.alpha = 0.00001;
					weegeeGroup.add(weeg);
				}
				bgShip = new BGSprite('backgrounds/bikini-bottom/night_sky', -1000, -300, 0.6, 0.6);
				bgShip.setGraphicSize(Std.int(bgShip.width * 2));
				bgShip.updateHitbox();
				bgShip.alpha = 0.00001;
				add(bgShip);
				bgShipGreen = new BGSprite('backgrounds/bikini-bottom/night_sky_alt', -1000, -300, 0.6, 0.6);
				bgShipGreen.setGraphicSize(Std.int(bgShipGreen.width * 2));
				bgShipGreen.updateHitbox();
				bgShipGreen.alpha = 0.00001;
				add(bgShipGreen);
				//wanted to do these as attachedsprite but couldnt get them to work proper oh well
				omegaWeegeeLightBig = new BGSprite('characters/internet/gigaweegee_backgroundlight', 0, 0, 0.75, 0.75);
				omegaWeegeeLightBig.alpha = 0.00001;
				add(omegaWeegeeLightBig);
				omegaWeegeeLightSmall = new BGSprite('characters/internet/gigaweegee_lightParticles', 0, 0, 0.75, 0.75);
				omegaWeegeeLightSmall.alpha = 0.00001;
				add(omegaWeegeeLightSmall);
				omegaWeegeeFaces = new BGSprite('characters/internet/gigaweegee_weegeefaces', 0, 0, 0.75, 0.75);
				omegaWeegeeFaces.angularVelocity = 50;
				omegaWeegeeFaces.active = true;
				omegaWeegeeFaces.alpha = 0.00001;
				add(omegaWeegeeFaces);
				ship = new BGSprite('backgrounds/bikini-bottom/ghostboat', -800, 750, 1, 1);
				ship.setGraphicSize(Std.int(ship.width * 2));
				ship.updateHitbox();
				ship.alpha = 0.00001;
				barrels = new BGSprite('backgrounds/bikini-bottom/barrels', -800, 1800, 1.2, 1.2);
				barrels.setGraphicSize(Std.int(barrels.width * 2));
				barrels.updateHitbox();
				barrels.alpha = 0.00001;
				rope = new BGSprite('backgrounds/bikini-bottom/strings', -800, 100, 1.2, 1.2);
				rope.setGraphicSize(Std.int(rope.width * 2));
				rope.updateHitbox();
				rope.alpha = 0.00001;
				bubbles = new BGSprite('backgrounds/bikini-bottom/bubbles', 0, 0, 1, 1, ['bubbles']);
				bubbles.alpha = 0.00001;
				bubbles.cameras = [camOther];
				bubbles.animation.play('bubbles');
				add(bubbles);

				#if VIDEOS_ALLOWED
				//load the video offscreen because im too lazy to figure out video caching
				var fakeWeegeeVideo:VideoSprite = new VideoSprite();
				fakeWeegeeVideo.playVideo(Paths.video('mama_luigi_for_you_mario'));
				fakeWeegeeVideo.graphicLoadedCallback = function()
				{
					fakeWeegeeVideo.bitmap.pause();
					fakeWeegeeVideo.bitmap.dispose();
					fakeWeegeeVideo.kill();
				}
				weegeeVideo = new VideoSprite(800, 1000);
				weegeeVideo.setGraphicSize(Std.int(weegeeVideo.width * 3.75));
				//precacheList.set('mama_luigi_for_you_mario', 'video');
				//weegeeVideo.playVideo(Paths.video('mama_luigi_for_you_mario'));
				weegeeVideo.alpha = 0.00001;
				#else
				FlxG.log.warn('Platform not supported!');
				return;
				#end
				setUpSpacebarMashMechanic('weegeespiralattempt', true);
			case 'awesome':
				awesomeBG1 = new BGSprite('backgrounds/awesome/bg1', -630, -500, 0.5, 0.5);
				add(awesomeBG1);
				awesomeBG2 = new BGSprite('backgrounds/awesome/bg2', -630, -500, 0.5, 0.5);
				add(awesomeBG2);
				awesomeFG1 = new BGSprite('backgrounds/awesome/fg', -758, 425, 1, 1); //thats a surprise tool that'll help us later
				awesomeFG1.setGraphicSize(Std.int(awesomeFG1.width * 1.1), Std.int(awesomeFG1.height));
				awesomeFG1.updateHitbox();
				add(awesomeFG1);
				awesomeFG2 = new BGSprite('backgrounds/awesome/fg', -758, 425, 1, 1);
				awesomeFG2.setGraphicSize(Std.int(awesomeFG2.width * 1.1), Std.int(awesomeFG2.height));
				awesomeFG2.updateHitbox();

				awesomeBoppers = new FlxTypedGroup<BGSprite>();
				for (i in 0...2)
				{
					var bopper:BGSprite = new BGSprite('backgrounds/awesome/audience', -1000, 250, 1.2, 1.2, ['idle0']);
					bopper.alpha = 0.00001;
					if (i == 1)
					{
						bopper.flipX = true;
						bopper.setPosition(1280, 250);
					}
					awesomeBoppers.add(bopper);
				}
			case 'skibid':
				var skibidi:BGSprite = new BGSprite('backgrounds/skibidi/skibidibgstage', -600, -200, 1, 1);
				skibidi.setGraphicSize(Std.int(skibidi.width * 2.0));
				skibidi.updateHitbox();
				add(skibidi);

			case 'todd':
				var bg:BGSprite = new BGSprite('backgrounds/todd/aesx', 0, 0, 0, 0);
				bg.screenCenter();
				add(bg);
		}

		if(isPixelStage) {
			introSoundsSuffix = '-pixel';
		}

		dadGhost = new FlxSprite();
		gfGhost = new FlxSprite();
		bfGhost = new FlxSprite();

		switch (curStage)
		{
			case 'alone' | 'happy':
				add(gfGhost);
				add(gfGroup);
				add(bfGhost);
				add(boyfriendGroup);
				boyfriendGroup.scrollFactor.set(0.7, 0.7);
				add(overlayThingy);
				add(dadGhost);
				add(dadGroup);
			case 'graveyard':
				add(gfGhost);
				add(gfGroup);
				add(dadGhost);
				add(dadGroup);
				add(bfGhost);
				add(boyfriendGroup);
				add(frontSkele1);
				add(frontSkele2);
				add(overlay);
			case 'mlg-studio':
				add(gfGhost);
				add(gfGroup);
				add(dadGhost);
				add(dadGroup);
				add(bfGhost);
				add(boyfriendGroup);
				add(computer);
				add(miniBF);
				add(miniSanic);
				add(bfWatching);
				add(scream);
			case 'kitchen':
				add(gfGhost);
				add(gfGroup);
				add(bfGhost);
				add(boyfriendGroup);
				add(dadGhost);
				add(dadGroup);
				add(spoonAndBowl);
				add(thrownTable);
				add(overlayThingy);
			case 'awesome':
				add(gfGhost);
				add(gfGroup);
				add(awesomeFG2);
				add(dadGhost);
				add(dadGroup);
				add(bfGhost);
				add(boyfriendGroup);
				add(awesomeBoppers);
			case 'bikini-bottom-new':
				add(dadGhost);
				add(dadGroup);
				shipParticles = new FlxEmitter(ship.x, ship.y + 1000);
				shipParticles.launchMode = FlxEmitterMode.SQUARE;
				shipParticles.velocity.set(-100, -1800, 100, -300, -100, -1800, 100, -300);
				shipParticles.scale.set(0.75, 0.75, 3, 3, 0.75, 0.75, 1.5, 1.5);
				shipParticles.drag.set(0, 0, 0, 0, 5, 5, 15, 15);
				shipParticles.width = ship.width;
				shipParticles.height = ship.height;
				shipParticles.alpha.set(1, 1, 0, 0);
				shipParticles.lifespan.set(1, 10);
				shipParticles.loadParticles(Paths.image('backgrounds/bikini-bottom/hi_kai'), 5000, 0);
				shipParticles.start(false, 0.1, 0);
				shipParticles.emitting = false;
				add(shipParticles);
				add(ship);
				add(gfGhost);
				add(gfGroup);
				#if VIDEOS_ALLOWED
				add(weegeeVideo);
				#end
				add(bfGhost);
				add(boyfriendGroup);
				add(barrels);
				add(rope);
			default:
				add(gfGhost);
				add(gfGroup);
				add(dadGhost);
				add(dadGroup);
				add(bfGhost);
				add(boyfriendGroup);
		}

		switch(curStage)
		{
			case 'bf-house':
				add(overlayThingy);
		}

		#if LUA_ALLOWED
		luaDebugGroup = new FlxTypedGroup<DebugLuaText>();
		luaDebugGroup.cameras = [camOther];
		add(luaDebugGroup);
		#end

		// "GLOBAL" SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('scripts/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('scripts/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/scripts/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/scripts/'));
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		// STAGE SCRIPTS
		#if (MODS_ALLOWED && LUA_ALLOWED)
		var doPush:Bool = false;
		var luaFile:String = 'stages/' + curStage + '.lua';
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}

		if(doPush)
			luaArray.push(new FunkinLua(luaFile));
		#end

		var gfVersion:String = SONG.gfVersion;
		if(gfVersion == null || gfVersion.length < 1)
		{
			switch (curStage)
			{
				case 'limo':
					gfVersion = 'gf-car';
				case 'mall' | 'mallEvil':
					gfVersion = 'gf-christmas';
				case 'school' | 'schoolEvil':
					gfVersion = 'gf-pixel';
				case 'tank':
					gfVersion = 'gf-tankmen';
				default:
					gfVersion = 'gf';
			}

			switch(Paths.formatToSongPath(SONG.song))
			{
				case 'stress':
					gfVersion = 'pico-speaker';
			}
			SONG.gfVersion = gfVersion; //Fix for the Chart Editor
		}

		gfGhost.visible = false;
		
		if (!stageData.hide_girlfriend)
		{
			gf = new Character(0, 0, gfVersion);
			startCharacterPos(gf);
			gf.scrollFactor.set(0.95, 0.95);
			gfGroup.add(gf);
			startCharacterLua(gf.curCharacter);

			gfGhost.antialiasing = gf.antialiasing;
			gfGhost.scale.copyFrom(gf.scale);
			gfGhost.updateHitbox();
		}

		dad = new Character(0, 0, SONG.player2);
		startCharacterPos(dad, true);
		dadGroup.add(dad);
		startCharacterLua(dad.curCharacter);

		boyfriend = new Boyfriend(0, 0, SONG.player1);
		startCharacterPos(boyfriend);
		boyfriendGroup.add(boyfriend);
		startCharacterLua(boyfriend.curCharacter);

		dadGhost.visible = false;
		dadGhost.antialiasing = dad.antialiasing;
		dadGhost.scale.copyFrom(dad.scale);
		dadGhost.updateHitbox();
		bfGhost.visible = false;
		bfGhost.antialiasing = boyfriend.antialiasing;
		bfGhost.scale.copyFrom(boyfriend.scale);
		bfGhost.updateHitbox();

		var camPos:FlxPoint = new FlxPoint(girlfriendCameraOffset[0], girlfriendCameraOffset[1]);
		if(gf != null)
		{
			camPos.x += gf.getGraphicMidpoint().x + gf.cameraPosition[0];
			camPos.y += gf.getGraphicMidpoint().y + gf.cameraPosition[1];
		}

		if(dad.curCharacter.startsWith('gf')) {
			dad.setPosition(GF_X, GF_Y);
			if(gf != null)
				gf.visible = false;
		}

		switch (dad.curCharacter)
		{
			case 'troll-happy':
				var chair:AttachedSprite = new AttachedSprite('characters/trolling/happyChair');
				chair.sprTracker = dad;
				chair.xAdd = 150;
				chair.yAdd = 200;
				addBehindDad(chair);
			case 'terry-insane':
				var evilTrail = new FlxTrail(dad, null, 14, 28, 0.4, 0.2);
				evilTrail.blend = HARDLIGHT;
				var erm:ColorSwap = new ColorSwap();
				erm.hue = 100;
				evilTrail.shader = erm.shader;
				addBehindDad(evilTrail);
		}

		switch (boyfriend.curCharacter)
		{
			case 'bf-happy':
				GameOverSubstate.characterName = 'bf-happy-dead';
			case 'bf-gmod':
				GameOverSubstate.characterName = 'bf-gmod';
				GameOverSubstate.deathSoundName = 'gmod_bf_dies';
				GameOverSubstate.loopSoundName = '';
		}

		switch(curStage)
		{
			case 'hell':
				addBehindBF(amazed);
		}

		var file:String = Paths.json(songName + '/dialogue'); //Checks for json/Psych Engine dialogue
		if (OpenFlAssets.exists(file)) {
			dialogueJson = DialogueBoxPsych.parseDialogue(file);
		}

		var file:String = Paths.txt(songName + '/' + songName + 'Dialogue'); //Checks for vanilla/Senpai dialogue
		if (OpenFlAssets.exists(file)) {
			dialogue = CoolUtil.coolTextFile(file);
		}
		var doof:DialogueBox = new DialogueBox(false, dialogue);
		// doof.x += 70;
		// doof.y = FlxG.height * 0.5;
		doof.scrollFactor.set();
		doof.finishThing = startCountdown;
		doof.nextDialogueThing = startNextDialogue;
		doof.skipDialogueThing = skipDialogue;

		Conductor.songPosition = -5000;

		strumLine = new FlxSprite(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, 50).makeGraphic(FlxG.width, 10);
		if(ClientPrefs.downScroll) strumLine.y = FlxG.height - 150;
		strumLine.scrollFactor.set();

		var showTime:Bool = (ClientPrefs.timeBarType != 'Disabled');
		timeTxt = new FlxText(STRUM_X + (FlxG.width / 2) - 248, 19, 400, "", 32);
		timeTxt.setFormat(Paths.font("impact.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		timeTxt.scrollFactor.set();
		timeTxt.alpha = 0;
		timeTxt.borderSize = 2;
		timeTxt.visible = showTime;
		if(ClientPrefs.downScroll) timeTxt.y = FlxG.height - 44; 

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.text = SONG.song;
		}
		updateTime = showTime;

		timeBarBG = new AttachedSprite('timeBar');
		timeBarBG.x = timeTxt.x;
		timeBarBG.y = timeTxt.y + (timeTxt.height / 4);
		timeBarBG.scrollFactor.set();
		timeBarBG.alpha = 0;
		timeBarBG.visible = showTime;
		timeBarBG.color = FlxColor.BLACK;
		timeBarBG.xAdd = -4;
		timeBarBG.yAdd = -4;
		add(timeBarBG);

		timeBar = new FlxBar(timeBarBG.x + 4, timeBarBG.y + 4, LEFT_TO_RIGHT, Std.int(timeBarBG.width - 8), Std.int(timeBarBG.height - 8), this,
			'songPercent', 0, 1);
		timeBar.scrollFactor.set();
		timeBar.createFilledBar(0xFF000000, 0xFFFFFFFF);
		timeBar.numDivisions = 800; //How much lag this causes?? Should i tone it down to idk, 400 or 200?
		timeBar.alpha = 0;
		timeBar.visible = showTime;
		add(timeBar);
		add(timeTxt);
		timeBarBG.sprTracker = timeBar;

		strumLineNotes = new FlxTypedGroup<StrumNote>();
		add(strumLineNotes);
		add(grpNoteSplashes);

		if(ClientPrefs.timeBarType == 'Song Name')
		{
			timeTxt.size = 24;
			timeTxt.y += 3;
		}

		var splash:NoteSplash = new NoteSplash(100, 100, 0);
		grpNoteSplashes.add(splash);
		splash.alpha = 0.0;

		opponentStrums = new FlxTypedGroup<StrumNote>();
		playerStrums = new FlxTypedGroup<StrumNote>();

		// startCountdown();

		generateSong(SONG.song);
		#if LUA_ALLOWED
		for (notetype in noteTypeMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_notetypes/' + notetype + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_notetypes/' + notetype + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		for (event in eventPushedMap.keys())
		{
			#if MODS_ALLOWED
			var luaToLoad:String = Paths.modFolders('custom_events/' + event + '.lua');
			if(FileSystem.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			else
			{
				luaToLoad = Paths.getPreloadPath('custom_events/' + event + '.lua');
				if(FileSystem.exists(luaToLoad))
				{
					luaArray.push(new FunkinLua(luaToLoad));
				}
			}
			#elseif sys
			var luaToLoad:String = Paths.getPreloadPath('custom_events/' + event + '.lua');
			if(OpenFlAssets.exists(luaToLoad))
			{
				luaArray.push(new FunkinLua(luaToLoad));
			}
			#end
		}
		#end
		noteTypeMap.clear();
		noteTypeMap = null;
		eventPushedMap.clear();
		eventPushedMap = null;

		// After all characters being loaded, it makes then invisible 0.01s later so that the player won't freeze when you change characters
		// add(strumLine);

		camFollow = new FlxPoint();
		camFollowPos = new FlxObject(0, 0, 1, 1);

		snapCamFollowToPos(camPos.x, camPos.y);
		if (prevCamFollow != null)
		{
			camFollow = prevCamFollow;
			prevCamFollow = null;
		}
		if (prevCamFollowPos != null)
		{
			camFollowPos = prevCamFollowPos;
			prevCamFollowPos = null;
		}
		add(camFollowPos);

		FlxG.camera.follow(camFollowPos, LOCKON, 1);
		// FlxG.camera.setScrollBounds(0, FlxG.width, 0, FlxG.height);
		FlxG.camera.zoom = defaultCamZoom;
		FlxG.camera.focusOn(camFollow);

		FlxG.worldBounds.set(0, 0, FlxG.width, FlxG.height);

		FlxG.fixedTimestep = false;
		moveCameraSection();

		healthBarBG = new AttachedSprite('healthBar');
		healthBarBG.y = FlxG.height * 0.89; 
		healthBarBG.screenCenter(X);
		healthBarBG.scrollFactor.set();
		healthBarBG.visible = !ClientPrefs.hideHud;
		healthBarBG.xAdd = -4;
		healthBarBG.yAdd = -4;
		add(healthBarBG);
		if(ClientPrefs.downScroll) healthBarBG.y = 0.11 * FlxG.height;

		healthBar = new FlxBar(healthBarBG.x + 4, healthBarBG.y + 4, RIGHT_TO_LEFT, Std.int(healthBarBG.width - 8), Std.int(healthBarBG.height - 8), this,
			'health', 0, 2);
		healthBar.scrollFactor.set();
		healthBar.visible = !ClientPrefs.hideHud;
		healthBar.alpha = ClientPrefs.healthBarAlpha;
		add(healthBar);
		healthBarBG.sprTracker = healthBar;

		iconP1 = new HealthIcon(boyfriend.healthIcon, true);
		iconP1.y = healthBar.y - 75;
		iconP1.visible = !ClientPrefs.hideHud;
		iconP1.alpha = ClientPrefs.healthBarAlpha;
		add(iconP1);

		iconP2 = new HealthIcon(dad.healthIcon, false);
		iconP2.y = healthBar.y - 75;
		iconP2.visible = !ClientPrefs.hideHud;
		iconP2.alpha = ClientPrefs.healthBarAlpha;
		add(iconP2);
		reloadHealthBarColors();

		scoreTxt = new FlxText(0, healthBarBG.y + 36, FlxG.width, "", 20);
		scoreTxt.setFormat(Paths.font("impact.otf"), 20, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		scoreTxt.scrollFactor.set();
		scoreTxt.borderSize = 1.25;
		scoreTxt.visible = !ClientPrefs.hideHud;
		add(scoreTxt);

		botplayTxt = new FlxText(400, timeBarBG.y + 55, FlxG.width - 800, "LE NOOB MODE XD LOL", 32);
		#if debug
		botplayTxt.text = '';
		#end
		botplayTxt.setFormat(Paths.font("impact.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		botplayTxt.scrollFactor.set();
		botplayTxt.borderSize = 1.25;
		botplayTxt.visible = cpuControlled;
		add(botplayTxt);
		if(ClientPrefs.downScroll) {
			botplayTxt.y = timeBarBG.y - 78;
		}

		//check for oil and magnet notes so we can preload and set up their gimmicks
		for (i in 0...unspawnNotes.length)
		{
			if (unspawnNotes[i].noteType.toLowerCase() == 'oil')
			{
				pissStain = new FlxSprite();
				pissStain.frames = Paths.getSparrowAtlas('spaghetti_popup');
				pissStain.animation.addByPrefix('open', "spaghetti", 24, false);
				pissStain.animation.play('open');
				pissStain.antialiasing = ClientPrefs.globalAntialiasing;
				pissStain.screenCenter();
				pissStain.alpha = 0.00001;
				pissStain.cameras = [camHUD];
				add(pissStain);
				break;
			}
		}
		for (i in 0...unspawnNotes.length)
		{
			if (unspawnNotes[i].noteType.toLowerCase() == 'magnet')
			{
				tim = new FlxSprite();
				tim.frames = Paths.getSparrowAtlas('tim');
				tim.animation.addByPrefix('intro', "timIntro", 24, false);
				tim.animation.addByPrefix('idle', "timIdle", 24, true);
				tim.animation.addByPrefix('miss', "timMiss", 24, false);
				tim.animation.addByPrefix('outro', "timOutro", 24, false);
				tim.animation.play('intro');
				tim.antialiasing = ClientPrefs.globalAntialiasing;
				tim.alpha = 0.00001;
				tim.cameras = [camHUD];
				tim.setGraphicSize(Std.int(tim.width * 0.7));
				tim.updateHitbox();
				add(tim);
				break;
			}
		}
		

		if (ClientPrefs.downScroll)
			curMagnetScroll = 1;
		
		if (curStage == 'idiot')
			add(idiotStalkers);

		strumLineNotes.cameras = [camHUD];
		grpNoteSplashes.cameras = [camHUD];
		notes.cameras = [camHUD];
		healthBar.cameras = [camHUD];
		healthBarBG.cameras = [camHUD];
		iconP1.cameras = [camHUD];
		iconP2.cameras = [camHUD];
		scoreTxt.cameras = [camHUD];
		botplayTxt.cameras = [camHUD];
		timeBar.cameras = [camHUD];
		timeBarBG.cameras = [camHUD];
		timeTxt.cameras = [camHUD];
		doof.cameras = [camHUD];

		// if (SONG.song == 'South')
		// FlxG.camera.alpha = 0.7;
		// UI_camera.zoom = 1;

		// cameras = [FlxG.cameras.list[1]];
		startingSong = true;

		// SONG SPECIFIC SCRIPTS
		#if LUA_ALLOWED
		var filesPushed:Array<String> = [];
		var foldersToCheck:Array<String> = [Paths.getPreloadPath('data/' + Paths.formatToSongPath(SONG.song) + '/')];

		#if MODS_ALLOWED
		foldersToCheck.insert(0, Paths.mods('data/' + Paths.formatToSongPath(SONG.song) + '/'));
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/data/' + Paths.formatToSongPath(SONG.song) + '/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/data/' + Paths.formatToSongPath(SONG.song) + '/' ));// using push instead of insert because these should run after everything else
		#end

		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				for (file in FileSystem.readDirectory(folder))
				{
					if(file.endsWith('.lua') && !filesPushed.contains(file))
					{
						luaArray.push(new FunkinLua(folder + file));
						filesPushed.push(file);
					}
				}
			}
		}
		#end

		var daSong:String = Paths.formatToSongPath(curSong);
		if (isStoryMode && !seenCutscene)
		{
			switch (daSong)
			{
				case 'trolling' | 'tomfoolery':
					var cutscenelol:StaticImageCutscene = new StaticImageCutscene();
					cutscenelol.scrollFactor.set();
					cutscenelol.finishThing = startCountdown;
					cutscenelol.cameras = [camOther];
					add(cutscenelol);

				case 'impending-doom':
					startVideo('impending_cuts');	

			//	case 'tomfoolery':
			//		startVideo('Tomfoolery');

				default:
					startCountdown();
			}
			seenCutscene = true;
		}
		else
			startCountdown();

		RecalculateRating();

		//PRECACHING MISS SOUNDS BECAUSE I THINK THEY CAN LAG PEOPLE AND FUCK THEM UP IDK HOW HAXE WORKS
		if(ClientPrefs.hitsoundVolume > 0) precacheList.set('hitsound', 'sound');
		precacheList.set('missnote1', 'sound');
		precacheList.set('missnote2', 'sound');
		precacheList.set('missnote3', 'sound');

		PauseSubState.pauseThemeName = 'Troll_Pause_Theme_'; //Reset to default
		if (PauseSubState.pauseThemeName != null)
		{
			if (pauseMusicPerSongMap.get(SONG.song.toLowerCase()) == null)
				PauseSubState.pauseThemeName += 'Upbeat';
			else
				PauseSubState.pauseThemeName += pauseMusicPerSongMap.get(SONG.song.toLowerCase());

			precacheList.set(PauseSubState.pauseThemeName, 'music');
		}

		precacheList.set('alphabet', 'image');
	
		#if desktop
		// Updating Discord Rich Presence.
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.addEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		Conductor.safeZoneOffset = (ClientPrefs.safeFrames / 60) * 1000;
		callOnLuas('onCreatePost', []);

		super.create();

		cacheCountdown();
		cachePopUpScore();
		for (key => type in precacheList)
		{
			//trace('Key $key is type $type');
			switch(type)
			{
				case 'image':
					Paths.image(key);
				case 'sound':
					Paths.sound(key);
				case 'music':
					Paths.music(key);
				case 'video':
					Paths.video(key);
			}
		}
		Paths.clearUnusedMemory();
		
		CustomFadeTransition.nextCamera = camOther;
	}

	#if (!flash && sys)
	public var runtimeShaders:Map<String, Array<String>> = new Map<String, Array<String>>();
	public function createRuntimeShader(name:String):FlxRuntimeShader
	{
		if(!ClientPrefs.shaders) return new FlxRuntimeShader();

		#if (!flash && MODS_ALLOWED && sys)
		if(!runtimeShaders.exists(name) && !initLuaShader(name))
		{
			FlxG.log.warn('Shader $name is missing!');
			return new FlxRuntimeShader();
		}

		var arr:Array<String> = runtimeShaders.get(name);
		return new FlxRuntimeShader(arr[0], arr[1]);
		#else
		FlxG.log.warn("Platform unsupported for Runtime Shaders!");
		return null;
		#end
	}

	public function initLuaShader(name:String, ?glslVersion:Int = 120)
	{
		if(!ClientPrefs.shaders) return false;

		if(runtimeShaders.exists(name))
		{
			FlxG.log.warn('Shader $name was already initialized!');
			return true;
		}

		var foldersToCheck:Array<String> = [Paths.mods('shaders/')];
		if(Paths.currentModDirectory != null && Paths.currentModDirectory.length > 0)
			foldersToCheck.insert(0, Paths.mods(Paths.currentModDirectory + '/shaders/'));

		for(mod in Paths.getGlobalMods())
			foldersToCheck.insert(0, Paths.mods(mod + '/shaders/'));
		
		for (folder in foldersToCheck)
		{
			if(FileSystem.exists(folder))
			{
				var frag:String = folder + name + '.frag';
				var vert:String = folder + name + '.vert';
				var found:Bool = false;
				if(FileSystem.exists(frag))
				{
					frag = File.getContent(frag);
					found = true;
				}
				else frag = null;

				if (FileSystem.exists(vert))
				{
					vert = File.getContent(vert);
					found = true;
				}
				else vert = null;

				if(found)
				{
					runtimeShaders.set(name, [frag, vert]);
					//trace('Found shader $name!');
					return true;
				}
			}
		}
		FlxG.log.warn('Missing shader $name .frag AND .vert files!');
		return false;
	}
	#end

	function set_songSpeed(value:Float):Float
	{
		if(generatedMusic)
		{
			var ratio:Float = value / songSpeed; //funny word huh
			for (note in notes) note.resizeByRatio(ratio);
			for (note in unspawnNotes) note.resizeByRatio(ratio);
		}
		songSpeed = value;
		noteKillOffset = 350 / songSpeed;
		return value;
	}

	public function addTextToDebug(text:String, color:FlxColor) {
		#if LUA_ALLOWED
		luaDebugGroup.forEachAlive(function(spr:DebugLuaText) {
			spr.y += 20;
		});

		if(luaDebugGroup.members.length > 34) {
			var blah = luaDebugGroup.members[34];
			blah.destroy();
			luaDebugGroup.remove(blah);
		}
		luaDebugGroup.insert(0, new DebugLuaText(text, luaDebugGroup, color));
		#end
	}

	public function reloadHealthBarColors() {
		healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
			FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			
		if (SONG.notes[curSection].gfSection)
		{
			if (!SONG.notes[curSection].mustHitSection)
			{
				healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
				FlxColor.fromRGB(boyfriend.healthColorArray[0], boyfriend.healthColorArray[1], boyfriend.healthColorArray[2]));
			}
			else
			{
				healthBar.createFilledBar(FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2]),
				FlxColor.fromRGB(gf.healthColorArray[0], gf.healthColorArray[1], gf.healthColorArray[2]));
			}
		}

		healthBar.updateBar();
	}

	public function addCharacterToList(newCharacter:String, type:Int) {
		switch(type) {
			case 0:
				if(!boyfriendMap.exists(newCharacter)) {
					var newBoyfriend:Boyfriend = new Boyfriend(0, 0, newCharacter);
					boyfriendMap.set(newCharacter, newBoyfriend);
					boyfriendGroup.add(newBoyfriend);
					startCharacterPos(newBoyfriend);
					newBoyfriend.alpha = 0.00001;
					startCharacterLua(newBoyfriend.curCharacter);
				}

			case 1:
				if(!dadMap.exists(newCharacter)) {
					var newDad:Character = new Character(0, 0, newCharacter);
					dadMap.set(newCharacter, newDad);
					dadGroup.add(newDad);
					startCharacterPos(newDad, true);
					newDad.alpha = 0.00001;
					startCharacterLua(newDad.curCharacter);
				}

			case 2:
				if(gf != null && !gfMap.exists(newCharacter)) {
					var newGf:Character = new Character(0, 0, newCharacter);
					newGf.scrollFactor.set(0.95, 0.95);
					gfMap.set(newCharacter, newGf);
					gfGroup.add(newGf);
					startCharacterPos(newGf);
					newGf.alpha = 0.00001;
					startCharacterLua(newGf.curCharacter);
				}
		}
	}

	function startCharacterLua(name:String)
	{
		#if LUA_ALLOWED
		var doPush:Bool = false;
		var luaFile:String = 'characters/' + name + '.lua';
		#if MODS_ALLOWED
		if(FileSystem.exists(Paths.modFolders(luaFile))) {
			luaFile = Paths.modFolders(luaFile);
			doPush = true;
		} else {
			luaFile = Paths.getPreloadPath(luaFile);
			if(FileSystem.exists(luaFile)) {
				doPush = true;
			}
		}
		#else
		luaFile = Paths.getPreloadPath(luaFile);
		if(Assets.exists(luaFile)) {
			doPush = true;
		}
		#end

		if(doPush)
		{
			for (script in luaArray)
			{
				if(script.scriptName == luaFile) return;
			}
			luaArray.push(new FunkinLua(luaFile));
		}
		#end
	}

	public function getLuaObject(tag:String, text:Bool=true):FlxSprite {
		if(modchartSprites.exists(tag)) return modchartSprites.get(tag);
		if(text && modchartTexts.exists(tag)) return modchartTexts.get(tag);
		return null;
	}

	function startCharacterPos(char:Character, ?gfCheck:Bool = false) {
		if(gfCheck && char.curCharacter.startsWith('gf')) { //IF DAD IS GIRLFRIEND, HE GOES TO HER POSITION
			char.setPosition(GF_X, GF_Y);
			char.scrollFactor.set(0.95, 0.95);
			char.danceEveryNumBeats = 2;
		}
		if(char.curCharacter.startsWith('idiot'))
		{
			char.danceEveryNumBeats = 2;
		}
		char.x += char.positionArray[0];
		char.y += char.positionArray[1];
	}

	public function startVideo(name:String)
	{
		#if VIDEOS_ALLOWED
		inCutscene = true;

		var filepath:String = Paths.video(name);
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find video file: ' + name);
			startAndEnd();
			return;
		}

		var video:VideoHandlerVolFix = new VideoHandlerVolFix();
		video.playVideo(filepath);
		video.finishCallback = function()
		{
			startAndEnd();
			return;
		}
		
		#else
		FlxG.log.warn('Platform not supported!');
		startAndEnd();
		return;
		#end
	}

	function startAndEnd()
	{
		if(endingSong)
			endSong();
		else
			startCountdown();
	}

	var dialogueCount:Int = 0;
	public var psychDialogue:DialogueBoxPsych;
	//You don't have to add a song, just saying. You can just do "startDialogue(dialogueJson);" and it should work
	public function startDialogue(dialogueFile:DialogueFile, ?song:String = null):Void
	{
		// TO DO: Make this more flexible, maybe?
		if(psychDialogue != null) return;

		if(dialogueFile.dialogue.length > 0) {
			inCutscene = true;
			precacheList.set('dialogue', 'sound');
			precacheList.set('dialogueClose', 'sound');
			psychDialogue = new DialogueBoxPsych(dialogueFile, song);
			psychDialogue.scrollFactor.set();
			if(endingSong) {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					endSong();
				}
			} else {
				psychDialogue.finishThing = function() {
					psychDialogue = null;
					startCountdown();
				}
			}
			psychDialogue.nextDialogueThing = startNextDialogue;
			psychDialogue.skipDialogueThing = skipDialogue;
			psychDialogue.cameras = [camHUD];
			add(psychDialogue);
		} else {
			FlxG.log.warn('Your dialogue file is badly formatted!');
			if(endingSong) {
				endSong();
			} else {
				startCountdown();
			}
		}
	}

	function schoolIntro(?dialogueBox:DialogueBox):Void
	{
		inCutscene = true;
		var black:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, FlxColor.BLACK);
		black.scrollFactor.set();
		add(black);

		var red:FlxSprite = new FlxSprite(-100, -100).makeGraphic(FlxG.width * 2, FlxG.height * 2, 0xFFff1b31);
		red.scrollFactor.set();

		var senpaiEvil:FlxSprite = new FlxSprite();
		senpaiEvil.frames = Paths.getSparrowAtlas('weeb/senpaiCrazy');
		senpaiEvil.animation.addByPrefix('idle', 'Senpai Pre Explosion', 24, false);
		senpaiEvil.setGraphicSize(Std.int(senpaiEvil.width * 6));
		senpaiEvil.scrollFactor.set();
		senpaiEvil.updateHitbox();
		senpaiEvil.screenCenter();
		senpaiEvil.x += 300;

		var songName:String = Paths.formatToSongPath(SONG.song);
		if (songName == 'roses' || songName == 'thorns')
		{
			remove(black);

			if (songName == 'thorns')
			{
				add(red);
				camHUD.visible = false;
			}
		}

		new FlxTimer().start(0.3, function(tmr:FlxTimer)
		{
			black.alpha -= 0.15;

			if (black.alpha > 0)
			{
				tmr.reset(0.3);
			}
			else
			{
				if (dialogueBox != null)
				{
					if (Paths.formatToSongPath(SONG.song) == 'thorns')
					{
						add(senpaiEvil);
						senpaiEvil.alpha = 0;
						new FlxTimer().start(0.3, function(swagTimer:FlxTimer)
						{
							senpaiEvil.alpha += 0.15;
							if (senpaiEvil.alpha < 1)
							{
								swagTimer.reset();
							}
							else
							{
								senpaiEvil.animation.play('idle');
								FlxG.sound.play(Paths.sound('Senpai_Dies'), 1, false, null, true, function()
								{
									remove(senpaiEvil);
									remove(red);
									FlxG.camera.fade(FlxColor.WHITE, 0.01, true, function()
									{
										add(dialogueBox);
										camHUD.visible = true;
									}, true);
								});
								new FlxTimer().start(3.2, function(deadTime:FlxTimer)
								{
									FlxG.camera.fade(FlxColor.WHITE, 1.6, false);
								});
							}
						});
					}
					else
					{
						add(dialogueBox);
					}
				}
				else
					startCountdown();

				remove(black);
			}
		});
	}

	function staticCutsceneIntro()
	{
		inCutscene = true;
	}

	function songCredit():Void
	{
		var titleCardBack:FlxSprite = new FlxSprite().makeGraphic(205, 130, FlxColor.BLACK);
		titleCardBack.antialiasing = ClientPrefs.globalAntialiasing;
		titleCardBack.cameras = [camOther];
		add(titleCardBack);

		var titleCardBase:FlxSprite = new FlxSprite().makeGraphic(200, 120, FlxColor.fromRGB(dad.healthColorArray[0], dad.healthColorArray[1], dad.healthColorArray[2])); //.loadGraphic(Paths.image('cardBase', 'shared'));
		titleCardBase.antialiasing = ClientPrefs.globalAntialiasing;
		titleCardBase.cameras = [camOther];
		titleCardBase.setPosition(-titleCardBase.width, 250); //setPos because it needa be -width which doesnt exist until its loaded
		titleCardBack.setPosition(titleCardBase.x, titleCardBase.y - 5);
		add(titleCardBase);

	/* scrapped for hotfix
		var titleCard:FlxSprite = new FlxSprite(titleCardBase.x + 2, titleCardBase.y + 3).loadGraphic(Paths.image('titleCards/${SONG.card}', 'shared'));
		titleCard.antialiasing = ClientPrefs.globalAntialiasing;
		titleCard.cameras = [camOther];
		add(titleCard);
	*/
		var songName:FlxTypeText = new FlxTypeText(/*120*/ 10, titleCardBase.y + 10, 200, '${SONG.credit}\n\n${SONG.song}');
		songName.setFormat(Paths.font("impact.otf"), 24, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		songName.cameras = [camOther];
		add(songName);

		//tween hell
		FlxTween.tween(titleCardBase, {x: 0}, 0.5, {onComplete: function(twn:FlxTween)
		{
			songName.start(0.04, true);

			new FlxTimer().start(5, function(tmr:FlxTimer)
			{
				songName.erase(0.02, true, null,
				function() //live footage of me figuring out how callbacks work for the first time proper
				{
					FlxTween.tween(titleCardBase, {x: -(titleCardBase.width)}, 0.25, {startDelay: 0.02, onComplete: function(twn:FlxTween)
					{
						titleCardBase.destroy();
						songName.destroy();
					}});
					FlxTween.tween(titleCardBack, {x: -(titleCardBase.width)}, 0.25, {startDelay: 0.02, onComplete: function(twn:FlxTween)
					{
						titleCardBack.destroy();
					}});
				//	FlxTween.tween(titleCard, {x: -(titleCardBase.width) + 2}, Conductor.crochet / 1000, {startDelay: 0.02, onComplete: function(twn:FlxTween)
				//	{
				//		titleCard.destroy();
				//	}});
				});
			});
		}});
		//FlxTween.tween(titleCard, {x: 2}, Conductor.crochet / 500);
		FlxTween.tween(titleCardBack, {x: 0}, 0.5);
	}

	var startTimer:FlxTimer;
	var finishTimer:FlxTimer = null;

	// For being able to mess with the sprites on Lua
	public var countdownReady:FlxSprite;
	public var countdownSet:FlxSprite;
	public var countdownGo:FlxSprite;
	public static var startOnTime:Float = 0;

	function cacheCountdown()
	{
		var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
		introAssets.set('default', ['ready', 'set', 'go']);
		introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

		var introAlts:Array<String> = introAssets.get('default');
		if (isPixelStage) introAlts = introAssets.get('pixel');
		
		for (asset in introAlts)
			Paths.image(asset);
		
		Paths.sound('intro3' + introSoundsSuffix);
		Paths.sound('intro2' + introSoundsSuffix);
		Paths.sound('intro1' + introSoundsSuffix);
		Paths.sound('introGo' + introSoundsSuffix);
	}

	public function startCountdown():Void
	{
		if(startedCountdown) {
			callOnLuas('onStartCountdown', []);
			return;
		}

		inCutscene = false;
		var ret:Dynamic = callOnLuas('onStartCountdown', [], false);
		if(ret != FunkinLua.Function_Stop) {
			if (skipCountdown || startOnTime > 0) skipArrowStartTween = true;

			generateStaticArrows(0);
			generateStaticArrows(1);
			for (i in 0...playerStrums.length) {
				setOnLuas('defaultPlayerStrumX' + i, playerStrums.members[i].x);
				setOnLuas('defaultPlayerStrumY' + i, playerStrums.members[i].y);
			}
			for (i in 0...opponentStrums.length) {
				setOnLuas('defaultOpponentStrumX' + i, opponentStrums.members[i].x);
				setOnLuas('defaultOpponentStrumY' + i, opponentStrums.members[i].y);
				//if(ClientPrefs.middleScroll) opponentStrums.members[i].visible = false;
			}

			startedCountdown = true;
			Conductor.songPosition = 0;
			Conductor.songPosition -= Conductor.crochet * 5;
			setOnLuas('startedCountdown', true);
			callOnLuas('onCountdownStarted', []);

			var swagCounter:Int = 0;


			if(startOnTime < 0) startOnTime = 0;

			if (startOnTime > 0) {
				clearNotesBefore(startOnTime);
				setSongTime(startOnTime - 350);
				return;
			}
			else if (skipCountdown)
			{
				setSongTime(0);
				return;
			}

			var daCountdownCam:FlxCamera = camHUD;
			if (camHUD.alpha < 1)
				daCountdownCam = camOther;

			startTimer = new FlxTimer().start(Conductor.crochet / 1000, function(tmr:FlxTimer)
			{
				if (gf != null && tmr.loopsLeft % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
				{
					gf.dance();
				}
				if (tmr.loopsLeft % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
				{
					boyfriend.dance();
				}
				if (tmr.loopsLeft % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
				{
					dad.dance();
				}

				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				if(isPixelStage) {
					introAlts = introAssets.get('pixel');
					antialias = false;
				}

				switch (swagCounter)
				{
					case 0:
						FlxG.sound.play(Paths.sound('intro3' + introSoundsSuffix), 0.6);
					case 1:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.cameras = [daCountdownCam];
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						insert(members.indexOf(notes), countdownReady);
						FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + introSoundsSuffix), 0.6);
					case 2:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.cameras = [daCountdownCam];
						countdownSet.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						insert(members.indexOf(notes), countdownSet);
						FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + introSoundsSuffix), 0.6);
					case 3:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.cameras = [daCountdownCam];
						countdownGo.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						insert(members.indexOf(notes), countdownGo);
						FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + introSoundsSuffix), 0.6);						
				}

				notes.forEachAlive(function(note:Note) {
					if(ClientPrefs.opponentStrums || note.mustPress)
					{
						note.copyAlpha = false;
						note.alpha = note.multAlpha;
						if(ClientPrefs.middleScroll && !note.mustPress) {
							note.alpha *= 0.35;
						}
					}
				});
				callOnLuas('onCountdownTick', [swagCounter]);

				swagCounter += 1;
				// generateSong('fresh');
			}, 5);
		}
	}

	public function addBehindGF(obj:FlxObject)
	{
		insert(members.indexOf(gfGroup), obj);
	}
	public function addBehindBF(obj:FlxObject)
	{
		insert(members.indexOf(boyfriendGroup), obj);
	}
	public function addBehindDad (obj:FlxObject)
	{
		insert(members.indexOf(dadGroup), obj);
	}

	public function clearNotesBefore(time:Float)
	{
		var i:Int = unspawnNotes.length - 1;
		while (i >= 0) {
			var daNote:Note = unspawnNotes[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				unspawnNotes.remove(daNote);
				daNote.destroy();
			}
			--i;
		}

		i = notes.length - 1;
		while (i >= 0) {
			var daNote:Note = notes.members[i];
			if(daNote.strumTime - 350 < time)
			{
				daNote.active = false;
				daNote.visible = false;
				daNote.ignoreNote = true;

				daNote.kill();
				notes.remove(daNote, true);
				daNote.destroy();
			}
			--i;
		}
	}

	public function updateScore(miss:Bool = false)
	{
		scoreTxt.text = 'Score: ' + songScore
		+ ' | Misses: ' + songMisses
		+ ' | Rating: ' + ratingName
		+ (ratingName != '?' ? ' (${Highscore.floorDecimal(ratingPercent * 100, 2)}%) - $ratingFC' : '');

		if(ClientPrefs.scoreZoom && !miss && !cpuControlled)
		{
			if(scoreTxtTween != null) {
				scoreTxtTween.cancel();
			}
			scoreTxt.scale.x = 1.075;
			scoreTxt.scale.y = 1.075;
			scoreTxtTween = FlxTween.tween(scoreTxt.scale, {x: 1, y: 1}, 0.2, {
				onComplete: function(twn:FlxTween) {
					scoreTxtTween = null;
				}
			});
		}
		callOnLuas('onUpdateScore', [miss]);
	}

	public function setSongTime(time:Float)
	{
		if(time < 0) time = 0;

		FlxG.sound.music.pause();
		vocals.pause();

		FlxG.sound.music.time = time;
		FlxG.sound.music.play();

		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = time;
		}
		vocals.play();
		Conductor.songPosition = time;
		songTime = time;
	}

	function startNextDialogue() {
		dialogueCount++;
		callOnLuas('onNextDialogue', [dialogueCount]);
	}

	function skipDialogue() {
		callOnLuas('onSkipDialogue', [dialogueCount]);
	}

	var previousFrameTime:Int = 0;
	var lastReportedPlayheadPosition:Int = 0;
	var songTime:Float = 0;

	function startSong():Void
	{
		startingSong = false;

		previousFrameTime = FlxG.game.ticks;
		lastReportedPlayheadPosition = 0;

		FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 1, false);
		FlxG.sound.music.onComplete = finishSong.bind();
		vocals.play();

		if(startOnTime > 0)
		{
			setSongTime(startOnTime - 500);
		}
		startOnTime = 0;

		if(paused) {
			//trace('Oopsie doopsie! Paused sound');
			FlxG.sound.music.pause();
			vocals.pause();
		}

		// Song duration in a float, useful for the time left feature
		songLength = FlxG.sound.music.length;
		FlxTween.tween(timeBar, {alpha: 1}, 0.5, {ease: FlxEase.circOut});
		FlxTween.tween(timeTxt, {alpha: 1}, 0.5, {ease: FlxEase.circOut});

		if ((SONG.card != '' || SONG.card != null) && !skipCredit)
			songCredit();

		// this was supposed to be used in way that it would pop up on any song with the notes but i ran out of time cant be bothered
		switch (curSong.toLowerCase())
		{
			case 'griefed':
				doSpecialNoteDisclaimer('bob', 3);
			case 'ragdoll':
				doSpecialNoteDisclaimer('grenade', 3.5);
		}

		#if desktop
		// Updating Discord Rich Presence (with Time Left)
		DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength);
		#end
		setOnLuas('songLength', songLength);
		callOnLuas('onSongStart', []);
	}

	var debugNum:Int = 0;
	private var noteTypeMap:Map<String, Bool> = new Map<String, Bool>();
	private var eventPushedMap:Map<String, Bool> = new Map<String, Bool>();
	private function generateSong(dataPath:String):Void
	{
		// FlxG.log.add(ChartParser.parse());
		songSpeedType = ClientPrefs.getGameplaySetting('scrolltype','multiplicative');

		switch(songSpeedType)
		{
			case "multiplicative":
				songSpeed = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1);
			case "constant":
				songSpeed = ClientPrefs.getGameplaySetting('scrollspeed', 1);
		}

		var songData = SONG;
		Conductor.changeBPM(songData.bpm);

		curSong = songData.song;

		if (SONG.needsVoices)
			vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
		else
			vocals = new FlxSound();

		FlxG.sound.list.add(vocals);
		FlxG.sound.list.add(new FlxSound().loadEmbedded(Paths.inst(PlayState.SONG.song)));

		notes = new FlxTypedGroup<Note>();
		add(notes);

		var noteData:Array<SwagSection>;

		// NEW SHIT
		noteData = songData.notes;

		var playerCounter:Int = 0;

		var daBeats:Int = 0; // Not exactly representative of 'daBeats' lol, just how much it has looped

		var songName:String = Paths.formatToSongPath(SONG.song);
		var file:String = Paths.json(songName + '/events');
		#if MODS_ALLOWED
		if (FileSystem.exists(Paths.modsJson(songName + '/events')) || FileSystem.exists(file)) {
		#else
		if (OpenFlAssets.exists(file)) {
		#end
			var eventsData:Array<Dynamic> = Song.loadFromJson('events', songName).events;
			for (event in eventsData) //Event Notes
			{
				for (i in 0...event[1].length)
				{
					var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
					var subEvent:EventNote = {
						strumTime: newEventNote[0] + ClientPrefs.noteOffset,
						event: newEventNote[1],
						value1: newEventNote[2],
						value2: newEventNote[3]
					};
					subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
					eventNotes.push(subEvent);
					eventPushed(subEvent);
				}
			}
		}

		for (section in noteData)
		{
			for (songNotes in section.sectionNotes)
			{
				var daStrumTime:Float = songNotes[0];
				var daNoteData:Int = Std.int(songNotes[1] % Main.ammo[mania]);

				var gottaHitNote:Bool = section.mustHitSection;

				if (songNotes[1] > Main.ammo[mania] - 1)
				{
					gottaHitNote = !section.mustHitSection;
				}

				var oldNote:Note;
				if (unspawnNotes.length > 0)
					oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];
				else
					oldNote = null;

				var swagNote:Note = new Note(daStrumTime, daNoteData, oldNote);
				swagNote.mustPress = gottaHitNote;
				swagNote.sustainLength = songNotes[2];
				swagNote.gfNote = (section.gfSection && (songNotes[1]<4));
				swagNote.noteType = songNotes[3];
				if(!Std.isOfType(songNotes[3], String)) swagNote.noteType = editors.ChartingState.noteTypeList[songNotes[3]]; //Backward compatibility + compatibility with Week 7 charts

				swagNote.scrollFactor.set();

				var susLength:Float = swagNote.sustainLength;

				susLength = susLength / Conductor.stepCrochet;
				unspawnNotes.push(swagNote);

				var floorSus:Int = Math.floor(susLength);
				if(floorSus > 0) {
					for (susNote in 0...floorSus+1)
					{
						oldNote = unspawnNotes[Std.int(unspawnNotes.length - 1)];

						var sustainNote:Note = new Note(daStrumTime + (Conductor.stepCrochet * susNote) + (Conductor.stepCrochet / FlxMath.roundDecimal(songSpeed, 2)), daNoteData, oldNote, true);
						sustainNote.mustPress = gottaHitNote;
						sustainNote.gfNote = (section.gfSection && (songNotes[1]<4));
						sustainNote.noteType = swagNote.noteType;
						sustainNote.scrollFactor.set();
						swagNote.tail.push(sustainNote);
						sustainNote.parent = swagNote;
						unspawnNotes.push(sustainNote);

						if (sustainNote.mustPress)
						{
							sustainNote.x += FlxG.width / 2; // general offset
						}
						else if(ClientPrefs.middleScroll)
						{
							sustainNote.x += 310;
							if(daNoteData > 1) //Up and Right
							{
								sustainNote.x += FlxG.width / 2 + 25;
							}
						}
					}
				}

				if (swagNote.mustPress)
				{
					swagNote.x += FlxG.width / 2; // general offset
				}
				else if(ClientPrefs.middleScroll)
				{
					swagNote.x += 310;
					if(daNoteData > 1) //Up and Right
					{
						swagNote.x += FlxG.width / 2 + 25;
					}
				}

				if(!noteTypeMap.exists(swagNote.noteType)) {
					noteTypeMap.set(swagNote.noteType, true);
				}
			}
			daBeats += 1;
		}
		for (event in songData.events) //Event Notes
		{
			for (i in 0...event[1].length)
			{
				var newEventNote:Array<Dynamic> = [event[0], event[1][i][0], event[1][i][1], event[1][i][2]];
				var subEvent:EventNote = {
					strumTime: newEventNote[0] + ClientPrefs.noteOffset,
					event: newEventNote[1],
					value1: newEventNote[2],
					value2: newEventNote[3]
				};
				subEvent.strumTime -= eventNoteEarlyTrigger(subEvent);
				eventNotes.push(subEvent);
				eventPushed(subEvent);
			}
		}

		// trace(unspawnNotes.length);
		// playerCounter += 1;

		unspawnNotes.sort(sortByShit);
		if(eventNotes.length > 1) { //No need to sort if there's a single one or none at all
			eventNotes.sort(sortByTime);
		}
		checkEventNote();
		generatedMusic = true;
	}

	function eventPushed(event:EventNote) {
		switch(event.event) {
			case 'Change Character':
				var charType:Int = 0;
				switch(event.value1.toLowerCase()) {
					case 'gf' | 'girlfriend' | '1':
						charType = 2;
					case 'dad' | 'opponent' | '0':
						charType = 1;
					default:
						charType = Std.parseInt(event.value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				var newCharacter:String = event.value2;
				addCharacterToList(newCharacter, charType);

			case 'Dadbattle Spotlight':
				dadbattleBlack = new BGSprite(null, -800, -400, 0, 0);
				dadbattleBlack.makeGraphic(Std.int(FlxG.width * 2), Std.int(FlxG.height * 2), FlxColor.BLACK);
				dadbattleBlack.alpha = 0.25;
				dadbattleBlack.visible = false;
				add(dadbattleBlack);

				dadbattleLight = new BGSprite('spotlight', 400, -400);
				dadbattleLight.alpha = 0.375;
				dadbattleLight.blend = ADD;
				dadbattleLight.visible = false;

				dadbattleSmokes.alpha = 0.7;
				dadbattleSmokes.blend = ADD;
				dadbattleSmokes.visible = false;
				add(dadbattleLight);
				add(dadbattleSmokes);

				var offsetX = 200;
				var smoke:BGSprite = new BGSprite('smoke', -1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(15, 22);
				smoke.active = true;
				dadbattleSmokes.add(smoke);
				var smoke:BGSprite = new BGSprite('smoke', 1550 + offsetX, 660 + FlxG.random.float(-20, 20), 1.2, 1.05);
				smoke.setGraphicSize(Std.int(smoke.width * FlxG.random.float(1.1, 1.22)));
				smoke.updateHitbox();
				smoke.velocity.x = FlxG.random.float(-15, -22);
				smoke.active = true;
				smoke.flipX = true;
				dadbattleSmokes.add(smoke);

			case 'Idiot Bluescreen':
				// heh heh boi
				precacheList.set('backgrounds/idiot/bsodNoSmile', 'image');
				precacheList.set('backgrounds/idiot/YAAIBlueScreen', 'image');
		}

		if(!eventPushedMap.exists(event.event)) {
			eventPushedMap.set(event.event, true);
		}
	}

	function eventNoteEarlyTrigger(event:EventNote):Float {
		var returnedValue:Float = callOnLuas('eventEarlyTrigger', [event.event]);
		if(returnedValue != 0) {
			return returnedValue;
		}

		switch(event.event) {
			case 'Kill Henchmen': //Better timing so that the kill sound matches the beat intended
				return 280; //Plays 280ms before the actual position
			case 'Cereal Spit':
				return 166; //4 frames of buildup before the spit = 1/6 of a second at 24 fps
		}
		return 0;
	}

	function sortByShit(Obj1:Note, Obj2:Note):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	function sortByTime(Obj1:EventNote, Obj2:EventNote):Int
	{
		return FlxSort.byValues(FlxSort.ASCENDING, Obj1.strumTime, Obj2.strumTime);
	}

	public var skipArrowStartTween:Bool = false; //for lua
	private function generateStaticArrows(player:Int):Void
	{
		for (i in 0...Main.ammo[mania])
		{
			// FlxG.log.add(i);
			var targetAlpha:Float = 1;
			if (player < 1)
			{
				if(!ClientPrefs.opponentStrums) targetAlpha = 0;
				else if(ClientPrefs.middleScroll) targetAlpha = 0.35;
			}

			var babyArrow:StrumNote = new StrumNote(ClientPrefs.middleScroll ? STRUM_X_MIDDLESCROLL : STRUM_X, strumLine.y, i, player);
			babyArrow.downScroll = ClientPrefs.downScroll;
			if (!isStoryMode && !skipArrowStartTween)
			{
				//babyArrow.y -= 10;
				babyArrow.alpha = 0;
				FlxTween.tween(babyArrow, {/*y: babyArrow.y + 10,*/ alpha: targetAlpha}, 1, {ease: FlxEase.circOut, startDelay: 0.5 + (0.2 * i)});
			}
			else
			{
				babyArrow.alpha = targetAlpha;
			}

			if (player == 1)
			{
				playerStrums.add(babyArrow);
			}
			else
			{
				if(ClientPrefs.middleScroll)
				{
					babyArrow.x += 310;
					if(i > 1) { //Up and Right
						babyArrow.x += FlxG.width / 2 + 25;
					}
				}
				opponentStrums.add(babyArrow);
			}

			strumLineNotes.add(babyArrow);
			babyArrow.postAddedToGroup();
		}
	}

	override function openSubState(SubState:FlxSubState)
	{
		if (paused)
		{
			if (FlxG.sound.music != null)
			{
				FlxG.sound.music.pause();
				vocals.pause();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = false;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = false;
			if (songSpeedTween != null)
				songSpeedTween.active = false;
			
			if (oilTimer != null)
				oilTimer.active = false;
			if (noteDisableTimer != null)
				noteDisableTimer.active = false;
			if (magnetTimer != null && !magnetTimer.finished)
				magnetTimer.active = false;

			//if(carTimer != null) carTimer.active = false;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = false;
				}
			}

			for (tween in modchartTweens) {
				tween.active = false;
			}
			for (timer in modchartTimers) {
				timer.active = false;
			}
		}

		super.openSubState(SubState);
	}

	override function closeSubState()
	{
		if (paused)
		{
			if (FlxG.sound.music != null && !startingSong)
			{
				resyncVocals();
			}

			if (startTimer != null && !startTimer.finished)
				startTimer.active = true;
			if (finishTimer != null && !finishTimer.finished)
				finishTimer.active = true;
			if (songSpeedTween != null)
				songSpeedTween.active = true;
			if (oilTimer != null)
				oilTimer.active = true;
			if (noteDisableTimer != null)
				noteDisableTimer.active = true;
			if (magnetTimer != null && !magnetTimer.finished)
				magnetTimer.active = true;

			//if(carTimer != null) carTimer.active = true;

			var chars:Array<Character> = [boyfriend, gf, dad];
			for (char in chars) {
				if(char != null && char.colorTween != null) {
					char.colorTween.active = true;
				}
			}

			for (tween in modchartTweens) {
				tween.active = true;
			}
			for (timer in modchartTimers) {
				timer.active = true;
			}
			paused = false;
			callOnLuas('onResume', []);

			#if desktop
			if (startTimer != null && startTimer.finished)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
			#end
		}

		super.closeSubState();
	}

	override public function onFocus():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			if (Conductor.songPosition > 0.0)
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter(), true, songLength - Conductor.songPosition - ClientPrefs.noteOffset);
			}
			else
			{
				DiscordClient.changePresence(detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
			}
		}
		#end

		super.onFocus();
	}

	override public function onFocusLost():Void
	{
		#if desktop
		if (health > 0 && !paused)
		{
			DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		}
		#end

		super.onFocusLost();
	}

	function resyncVocals():Void
	{
		if(finishTimer != null) return;

		vocals.pause();

		FlxG.sound.music.play();
		Conductor.songPosition = FlxG.sound.music.time;
		if (Conductor.songPosition <= vocals.length)
		{
			vocals.time = Conductor.songPosition;
		}
		vocals.play();
	}

	public var paused:Bool = false;
	public var canReset:Bool = true;
	var startedCountdown:Bool = false;
	var canPause:Bool = true;

	override public function update(elapsed:Float)
	{
		/*if (FlxG.keys.justPressed.NINE)
		{
			iconP1.swapOldIcon();
		}*/
		callOnLuas('onUpdate', [elapsed]);

		switch (curStage)
		{
			case 'troll-house-mad':
				if (ClientPrefs.shaking)
				{
					var sinThingamabober:Float = Math.sin((elapsed * 0.25) * Math.PI);
					evilPaintings.setPosition(-600 + FlxG.random.int(-2, 2) + sinThingamabober, -235 + FlxG.random.int(-2, 2) + sinThingamabober);
					evilScreen.setPosition(-155 + FlxG.random.int(-1, 1) + sinThingamabober, 270 + FlxG.random.int(-1, 1) + sinThingamabober);
					noEscape1.y += (songSpeed * 2) * (elapsed / (1 / 120));
					noEscape2.y += (songSpeed * 2) * (elapsed / (1 / 120));
				}
			case 'smile':
				if (ClientPrefs.flashing)
				{
					if (FlxG.random.int(1, 100) == 1)
					{
						light.animation.play('lights off');
						new FlxTimer().start(0.1, function(tmr:FlxTimer) {
							light.animation.play('lights on');
						});
					}
				}
		}

		if(!inCutscene) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 2.4 * cameraSpeed, 0, 1);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
			if(!startingSong && !endingSong && boyfriend.animation.curAnim != null && boyfriend.animation.curAnim.name.startsWith('idle')) {
				boyfriendIdleTime += elapsed;
				if(boyfriendIdleTime >= 0.15) { // Kind of a mercy thing for making the achievement easier to get as it's apparently frustrating to some playerss
					boyfriendIdled = true;
				}
			} else {
				boyfriendIdleTime = 0;
			}
		}

		super.update(elapsed);

		setOnLuas('curDecStep', curDecStep);
		setOnLuas('curDecBeat', curDecBeat);

		if(botplayTxt.visible) {
			botplaySine += 180 * elapsed;
			botplayTxt.alpha = 1 - Math.sin((Math.PI * botplaySine) / 180);
		}

		if (mlgShader != null)
			mlgShader.hue += elapsed * FlxG.random.int(0, 10);

		if (controls.PAUSE && startedCountdown && canPause)
		{
			var ret:Dynamic = callOnLuas('onPause', [], false);
			if(ret != FunkinLua.Function_Stop) {
				openPauseMenu();
			}
		}

		if (ragdollDead && controls.ACCEPT)
			ragdollEndBullshit();

		if (FlxG.keys.anyJustPressed(debugKeysChart) && !endingSong && !inCutscene)
		{
			openChartEditor();
		}

		// FlxG.watch.addQuick('VOL', vocals.amplitudeLeft);
		// FlxG.watch.addQuick('VOLRight', vocals.amplitudeRight);

		var mult:Float = FlxMath.lerp(1, iconP1.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP1.scale.set(mult, mult);
		iconP1.updateHitbox();

		var mult:Float = FlxMath.lerp(1, iconP2.scale.x, CoolUtil.boundTo(1 - (elapsed * 9), 0, 1));
		iconP2.scale.set(mult, mult);
		iconP2.updateHitbox();

		var iconOffset:Int = 26;

		iconP1.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) + (150 * iconP1.scale.x - 150) / 2 - iconOffset;
		iconP2.x = healthBar.x + (healthBar.width * (FlxMath.remapToRange(healthBar.percent, 0, 100, 100, 0) * 0.01)) - (150 * iconP2.scale.x) / 2 - iconOffset * 2;

		if (health > 2)
			health = 2;

		if (healthBar.percent < 20)
			iconP1.animation.curAnim.curFrame = 1;
		else
			iconP1.animation.curAnim.curFrame = 0;

		if (healthBar.percent > 80)
			iconP2.animation.curAnim.curFrame = 1;
		else
			iconP2.animation.curAnim.curFrame = 0;

		if (FlxG.keys.anyJustPressed(debugKeysCharacter) && !endingSong && !inCutscene) {
			persistentUpdate = false;
			paused = true;
			cancelMusicFadeTween();
			MusicBeatState.switchState(new CharacterEditorState(SONG.player2));
		}

		if (startingSong)
		{
			if (startedCountdown)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					startSong();
			}
		}
		else
		{
			Conductor.songPosition += FlxG.elapsed * 1000;

			if (!paused)
			{
				songTime += FlxG.game.ticks - previousFrameTime;
				previousFrameTime = FlxG.game.ticks;

				// Interpolation type beat
				if (Conductor.lastSongPos != Conductor.songPosition)
				{
					songTime = (songTime + Conductor.songPosition) / 2;
					Conductor.lastSongPos = Conductor.songPosition;
					// Conductor.songPosition += FlxG.elapsed * 1000;
					// trace('MISSED FRAME');
				}

				if(updateTime) {
					var curTime:Float = Conductor.songPosition - ClientPrefs.noteOffset;
					if(curTime < 0) curTime = 0;
					songPercent = (curTime / songLength);

					var songCalc:Float = (songLength - curTime);
					if(ClientPrefs.timeBarType == 'Time Elapsed') songCalc = curTime;

					var secondsTotal:Int = Math.floor(songCalc / 1000);
					if(secondsTotal < 0) secondsTotal = 0;

					if(ClientPrefs.timeBarType != 'Song Name')
						timeTxt.text = FlxStringUtil.formatTime(secondsTotal, false);
				}
			}

			// Conductor.lastSongPos = FlxG.sound.music.time;
		}

		if (camZooming)
		{
			FlxG.camera.zoom = FlxMath.lerp(defaultCamZoom, FlxG.camera.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
			camHUD.zoom = FlxMath.lerp(1, camHUD.zoom, CoolUtil.boundTo(1 - (elapsed * 3.125 * camZoomingDecay), 0, 1));
		}

		FlxG.watch.addQuick("secShit", curSection);
		FlxG.watch.addQuick("beatShit", curBeat);
		FlxG.watch.addQuick("stepShit", curStep);

		// RESET = Quick Game Over Screen
		if (!ClientPrefs.noReset && controls.RESET && canReset && !inCutscene && startedCountdown && !endingSong)
		{
			health = 0;
			trace("RESET = True");
		}
		doDeathCheck();

		if (unspawnNotes[0] != null)
		{
			var time:Float = spawnTime;
			if(songSpeed < 1) time /= songSpeed;
			if(unspawnNotes[0].multSpeed < 1) time /= unspawnNotes[0].multSpeed;

			while (unspawnNotes.length > 0 && unspawnNotes[0].strumTime - Conductor.songPosition < time)
			{
				var dunceNote:Note = unspawnNotes[0];
				notes.insert(0, dunceNote);
				dunceNote.spawned=true;
				callOnLuas('onSpawnNote', [notes.members.indexOf(dunceNote), dunceNote.noteData, dunceNote.noteType, dunceNote.isSustainNote]);

				var index:Int = unspawnNotes.indexOf(dunceNote);
				unspawnNotes.splice(index, 1);
			}
		}

		if (generatedMusic)
		{
			if (!inCutscene)
			{
				if(!cpuControlled)
				{
					if (!notesDisabled)
						keyShit();
				} 
				else if(boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * 0.0011 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
				{
					boyfriend.dance();
					//boyfriend.animation.curAnim.finish();
				}
			}

			var fakeCrochet:Float = (60 / SONG.bpm) * 1000;
			notes.forEachAlive(function(daNote:Note)
			{
				var strumGroup:FlxTypedGroup<StrumNote> = playerStrums;
				if(!daNote.mustPress) strumGroup = opponentStrums;

				var strumX:Float = strumGroup.members[daNote.noteData].x;
				var strumY:Float = strumGroup.members[daNote.noteData].y;
				var strumAngle:Float = strumGroup.members[daNote.noteData].angle;
				var strumDirection:Float = strumGroup.members[daNote.noteData].direction;
				var strumAlpha:Float = strumGroup.members[daNote.noteData].alpha;
				var strumScroll:Bool = strumGroup.members[daNote.noteData].downScroll;

				strumX += daNote.offsetX;
				strumY += daNote.offsetY;
				strumAngle += daNote.offsetAngle;
				strumAlpha *= daNote.multAlpha;

				if (strumScroll) //Downscroll
				{
					//daNote.y = (strumY + 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
				}
				else //Upscroll
				{
					//daNote.y = (strumY - 0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed);
					daNote.distance = (-0.45 * (Conductor.songPosition - daNote.strumTime) * songSpeed * daNote.multSpeed);
				}

				var swagWidth = Note.swidths[0] * Note.scales[mania];
				var center:Float = strumY + swagWidth / 2;
				
				var angleDir = strumDirection * Math.PI / 180;

				if (daNote.copyAngle)
					daNote.angle = strumDirection - 90 + strumAngle;

				if(daNote.copyAlpha)
					daNote.alpha = strumAlpha;

				if(daNote.copyX)
					daNote.x = strumX + Math.cos(angleDir) * daNote.distance;

				if(daNote.copyY)
				{
					daNote.y = strumY + Math.sin(angleDir) * daNote.distance;

					//Jesus fuck this took me so much mother fucking time AAAAAAAAAA
					if(strumScroll && daNote.isSustainNote)
					{
						if (daNote.animation.curAnim.name.endsWith('end')) {
							daNote.y += 10.5 * (fakeCrochet / 400) * 1.5 * songSpeed + (46 * (songSpeed - 1));
							daNote.y -= 46 * (1 - (fakeCrochet / 600)) * songSpeed;
							if(PlayState.isPixelStage) {
								daNote.y += 8 + (6 - daNote.originalHeightForCalcs) * PlayState.daPixelZoom;
							} else {
								daNote.y -= 19;
							}
						}
						daNote.y += (swagWidth / 2) - (60.5 * (songSpeed - 1));
						daNote.y += 27.5 * ((SONG.bpm / 100) - 1) * (songSpeed - 1);
					}
				}

				if (!daNote.mustPress && daNote.wasGoodHit && !daNote.hitByOpponent && !daNote.ignoreNote)
				{
					opponentNoteHit(daNote);
				}

				if(!daNote.blockHit && daNote.mustPress && cpuControlled && daNote.canBeHit) {
					if(daNote.isSustainNote) {
						if(daNote.canBeHit) {
							goodNoteHit(daNote);
						}
					} else if(daNote.strumTime <= Conductor.songPosition || daNote.isSustainNote) {
						goodNoteHit(daNote);
					}
				}

				if(strumGroup.members[daNote.noteData].sustainReduce && daNote.isSustainNote && (daNote.mustPress || !daNote.ignoreNote) &&
					(!daNote.mustPress || (daNote.wasGoodHit || (daNote.prevNote.wasGoodHit && !daNote.canBeHit))))
				{
					if (strumScroll)
					{
						if(daNote.y - daNote.offset.y * daNote.scale.y + daNote.height >= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.frameWidth, daNote.frameHeight);
							swagRect.height = (center - daNote.y) / daNote.scale.y;
							swagRect.y = daNote.frameHeight - swagRect.height;

							daNote.clipRect = swagRect;
						}
					}
					else
					{
						if (daNote.y + daNote.offset.y * daNote.scale.y <= center)
						{
							var swagRect = new FlxRect(0, 0, daNote.width / daNote.scale.x, daNote.height / daNote.scale.y);
							swagRect.y = (center - daNote.y) / daNote.scale.y;
							swagRect.height -= swagRect.y;

							daNote.clipRect = swagRect;
						}
					}
				}

				// Kill extremely late notes and cause misses
				if (Conductor.songPosition > noteKillOffset + daNote.strumTime)
				{
					if (daNote.mustPress && !cpuControlled &&!daNote.ignoreNote && !endingSong && (daNote.tooLate || !daNote.wasGoodHit)) {
						noteMiss(daNote);
					}

					daNote.active = false;
					daNote.visible = false;

					daNote.kill();
					notes.remove(daNote, true);
					daNote.destroy();
				}
			});
		}
		checkEventNote();
		#if debug
		if (FlxG.keys.justPressed.ONE) { 
			KillNotes();
			FlxG.sound.music.onComplete();
		}
		
		if(!endingSong && !startingSong) {
			if(FlxG.keys.justPressed.TWO) { //Go 10 seconds into the future :O
				setSongTime(Conductor.songPosition + 10000);
				clearNotesBefore(Conductor.songPosition);
			}
			if (FlxG.keys.justPressed.THREE)
			{
				if (FlxG.keys.pressed.SHIFT)
					defaultCamZoom -= 0.1;
				else
					defaultCamZoom += 0.1;
			}
		}
		#end

		setOnLuas('cameraX', camFollowPos.x);
		setOnLuas('cameraY', camFollowPos.y);
		setOnLuas('botPlay', cpuControlled);
		callOnLuas('onUpdatePost', [elapsed]);

	/*	@:privateAccess
        var dadFrame = dad._frame;
        
        if (dadFrame == null || dadFrame.frame == null) return; // prevents crashes (i think???)
            
        var rect = new Rectangle(dadFrame.frame.x, dadFrame.frame.y, dadFrame.frame.width, dadFrame.frame.height);
        
        dadScrollWin.scrollRect = rect;
        dadScrollWin.x = (((dadFrame.offset.x) - (dad.offset.x / 2)) * dadScrollWin.scaleX);
        dadScrollWin.y = (((dadFrame.offset.y) - (dad.offset.y / 2)) * dadScrollWin.scaleY);  

		var popupFrame = popupFlxSprite._frame;

		if (popupFrame == null || popupFrame.frame == null) return; // prevents crashes (i think???)
            
        var rect = new Rectangle(popupFrame.frame.x, popupFrame.frame.y, popupFrame.frame.width, popupFrame.frame.height);
        
        popupSprite.scrollRect = rect;
        popupSprite.x = (((popupFrame.offset.x) - (popupFlxSprite.offset.x / 2)) * popupSprite.scaleX);
        popupSprite.y = (((popupFrame.offset.y) - (popupFlxSprite.offset.y / 2)) * popupSprite.scaleY); */
	}

	function openPauseMenu()
	{
		persistentUpdate = false;
		persistentDraw = true;
		paused = true;
		
		// 1 / 1000 chance for Gitaroo Man easter egg
		/*if (FlxG.random.bool(0.1))
		{
			// gitaroo man easter egg
			cancelMusicFadeTween();
			MusicBeatState.switchState(new GitarooPause());
		}
		else {*/
		if(FlxG.sound.music != null) {
			FlxG.sound.music.pause();
			vocals.pause();
		}
		openSubState(new PauseSubState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));
		//}

		#if desktop
		DiscordClient.changePresence(detailsPausedText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
		#end
	}

	function openChartEditor()
	{
		persistentUpdate = false;
		paused = true;
		cancelMusicFadeTween();
		MusicBeatState.switchState(new ChartingState());
		chartingMode = true;

		#if desktop
		DiscordClient.changePresence("Chart Editor", null, null, true);
		#end
	}

	public var isDead:Bool = false; //Don't mess with this on Lua!!!
	function doDeathCheck(?skipHealthCheck:Bool = false) {
		if (((skipHealthCheck && instakillOnMiss) || health <= 0) && !practiceMode && !isDead)
		{
			var ret:Dynamic = callOnLuas('onGameOver', [], false);
			if(ret != FunkinLua.Function_Stop) {
				boyfriend.stunned = true;
				deathCounter++;

				paused = true;

				vocals.stop();
				FlxG.sound.music.stop();

				persistentUpdate = false;
				persistentDraw = false;
				for (tween in modchartTweens) {
					tween.active = true;
				}
				for (timer in modchartTimers) {
					timer.active = true;
				}
				
				if (FlxG.camera.bgColor != FlxColor.BLACK)
					FlxG.camera.bgColor = FlxColor.BLACK;

				switch (curSong)
				{
					case "Impending Doom":
						openSubState(new GameOverSubstateImpendingDoom(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));
					case "Alone Forever":
						aloneForeverGameOver();
					case "Obey":
						weegeeGameOver();
					case "Controlling Yourself":
						openSubState(new GameOverSubstateCY());
					case "IDIOT":
						openSubState(new GameOverSubstateIDIOT());
					case "Trodding":
						troddingGameOver();
					case "Awestruck" | "Baldstruck":
						openSubState(new GameOverSubstateAwestruck());
					case "Ragdoll":
						ragdollGameOver();
					default:
						openSubState(new GameOverSubstate(boyfriend.getScreenPosition().x - boyfriend.positionArray[0], boyfriend.getScreenPosition().y - boyfriend.positionArray[1], camFollowPos.x, camFollowPos.y));
				}

			// MusicBeatState.switchState(new GameOverState(boyfriend.getScreenPosition().x, boyfriend.getScreenPosition().y));

				#if desktop
				// Game Over doesn't get his own variable because it's only used here
				DiscordClient.changePresence("Game Over - " + detailsText, SONG.song + " (" + storyDifficultyText + ")", iconP2.getCharacter());
				#end
				isDead = true;
				return true;
			}
		}
		return false;
	}

	function aloneForeverGameOver()
	{
		KillNotes();
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.destroy();
			vocals.destroy();
		}
		canPause = false;
		cameraSpeed = 2;
		camFollow.x = 1365;
		camFollow.y = 300;
		isCameraOnForcedPos = true;
		boyfriend.playAnim('death', true);
		boyfriend.specialAnim = true;
		FlxTween.tween(camHUD, {alpha: 0}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(FlxG.camera, {zoom: 1.5}, 1, {ease: FlxEase.quadOut, 
		onComplete: function(twn:FlxTween) 
		{
			camGame.alpha = 0;
			openSubState(new StaticImageEndingSubstate(['lonely'], camOther, true));
		}});
	}

	function weegeeGameOver()
	{
		var gameoverMusicName:String = 'gameOverWeegee';
		if (dad.curCharacter == 'omega-weegee')
			gameoverMusicName = 'gameOverGigaWeegee';
		if (gf.curCharacter == 'guiyii')
			gameoverMusicName = 'gameOverGuiyii';
		
		callOnLuas('onGameOverStart', []);
		KillNotes();
		//setSongTime(0);
		if (FlxG.sound.music != null)
		{
			// i really thought just destroying them would make it crash somehow but it doesnt so fuck it we ball!
			//never fucking mind this fucks it up bad LMAO
			// update i think its ok uh
			FlxG.sound.music.destroy();
			vocals.destroy();
		}
		canPause = false;
		FlxG.sound.play(Paths.sound('fnf_loss_shortened'));
		cameraSpeed = 100;
		FlxG.camera.zoom = defaultCamZoom;
		isCameraOnForcedPos = true;
		//moveCamera(false);
		triggerEventNote('Change Character', 'bf', 'bf-weegee-dead');
		boyfriend.playAnim('static', true);
		boyfriend.specialAnim = true;

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{	
			boyfriend.playAnim('idle', true);
			FlxG.sound.play(Paths.music(gameoverMusicName));
			FlxTween.tween(boyfriend, {y: boyfriend.y - 500}, 0.5, {ease: FlxEase.sineInOut});
			new FlxTimer().start(0.5, function(tmr:FlxTimer)
			{
				FlxTween.tween(boyfriend, {y: boyfriend.y + 1500}, 1, {ease: FlxEase.sineInOut});
				new FlxTimer().start(1, function(tmr:FlxTimer)
				{
					FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
					{
						callOnLuas('onGameOverConfirm', [true]);
						MusicBeatState.resetState();
					});
				});
			});	
		});
	}

	function troddingGameOver()
	{
		callOnLuas('onGameOverStart', []);
		#if VIDEOS_ALLOWED
		KillNotes();
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.destroy();
			vocals.destroy();
		}
		canPause = false;
		var youtoozDeathVideo:VideoSpriteVolFix = new VideoSpriteVolFix();
		youtoozDeathVideo.playVideo(Paths.video('youtoozresized'));
		youtoozDeathVideo.cameras = [camOther];
		youtoozDeathVideo.finishCallback = function()
		{
			MusicBeatState.resetState();
			callOnLuas('onGameOverConfirm', [true]);
		}
		add(youtoozDeathVideo);
		#else
		FlxG.log.warn('Platform not supported!');
		callOnLuas('onGameOverConfirm', [true]);
		MusicBeatState.resetState();
		return;
		#end
	}

	var ragdollDead:Bool = false;

	function ragdollGameOver():Void
	{
		ragdollDead = true;
		callOnLuas('onGameOverStart', []);
		KillNotes();
		if (FlxG.sound.music != null)
		{
			FlxG.sound.music.destroy();
			vocals.destroy();
		}
		canPause = false;
		cameraSpeed = 2;
		camFollow.x = 1220;
		camFollow.y = 700;
		isCameraOnForcedPos = true;
		FlxG.sound.play(Paths.sound('gmod_bf_dies'));
		boyfriend.playAnim('firstDeath', true);
		boyfriend.specialAnim = true;
		boyfriend.startedDeath = true;
		camHUD.alpha = 0;

		var redOuch:FlxSprite = new FlxSprite().makeGraphic(Std.int(FlxG.width), Std.int(FlxG.height), FlxColor.RED);
		redOuch.cameras = [camOther];
		redOuch.alpha = 0.5;
		redOuch.blend = ADD;
		add(redOuch);
		FlxTween.tween(redOuch, {alpha: 0}, 3, {ease: FlxEase.quadOut});
		defaultCamZoom = 1.2;
		FlxTween.tween(FlxG.camera, {zoom: 1.2}, 5, {ease: FlxEase.quadOut, 
		onComplete: function(twn:FlxTween) 
		{
			defaultCamZoom = 1.2;
		}});
	}

	function ragdollEndBullshit():Void //brah
	{
		ragdollDead = false;
		boyfriend.playAnim('deathConfirm', true);
		boyfriend.specialAnim = true;
		FlxG.sound.play(Paths.music('gameOverUpbeatEnd'));
		new FlxTimer().start(0.7, function(tmr:FlxTimer)
		{
			FlxG.camera.fade(FlxColor.BLACK, 2, false, function()
			{
				MusicBeatState.resetState();
			});
		});
		PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
	}

	public function checkEventNote() {
		while(eventNotes.length > 0) {
			var leStrumTime:Float = eventNotes[0].strumTime;
			if(Conductor.songPosition < leStrumTime) {
				break;
			}

			var value1:String = '';
			if(eventNotes[0].value1 != null)
				value1 = eventNotes[0].value1;

			var value2:String = '';
			if(eventNotes[0].value2 != null)
				value2 = eventNotes[0].value2;

			triggerEventNote(eventNotes[0].event, value1, value2);
			eventNotes.shift();
		}
	}

	public function getControl(key:String) {
		var pressed:Bool = Reflect.getProperty(controls, key);
		//trace('Control result: ' + pressed);
		return pressed;
	}

	public function triggerEventNote(eventName:String, value1:String, value2:String) {
		switch(eventName) {
			case 'Dadbattle Spotlight':
				var val:Null<Int> = Std.parseInt(value1);
				if(val == null) val = 0;

				switch(Std.parseInt(value1))
				{
					case 1, 2, 3: //enable and target dad
						if(val == 1) //enable
						{
							dadbattleBlack.visible = true;
							dadbattleLight.visible = true;
							dadbattleSmokes.visible = true;
							defaultCamZoom += 0.12;
						}

						var who:Character = dad;
						if(val > 2) who = boyfriend;
						//2 only targets dad
						dadbattleLight.alpha = 0;
						new FlxTimer().start(0.12, function(tmr:FlxTimer) {
							dadbattleLight.alpha = 0.375;
						});
						dadbattleLight.setPosition(who.getGraphicMidpoint().x - dadbattleLight.width / 2, who.y + who.height - dadbattleLight.height + 50);

					default:
						dadbattleBlack.visible = false;
						dadbattleLight.visible = false;
						defaultCamZoom -= 0.12;
						FlxTween.tween(dadbattleSmokes, {alpha: 0}, 1, {onComplete: function(twn:FlxTween)
						{
							dadbattleSmokes.visible = false;
						}});
				}

			case 'Hey!':
				var value:Int = 2;
				switch(value1.toLowerCase().trim()) {
					case 'bf' | 'boyfriend' | '0':
						value = 0;
					case 'gf' | 'girlfriend' | '1':
						value = 1;
				}

				var time:Float = Std.parseFloat(value2);
				if(Math.isNaN(time) || time <= 0) time = 0.6;

				if(value != 0) {
					if(dad.curCharacter.startsWith('gf')) { //Tutorial GF is actually Dad! The GF is an imposter!! ding ding ding ding ding ding ding, dindinding, end my suffering
						dad.playAnim('cheer', true);
						dad.specialAnim = true;
						dad.heyTimer = time;
					} else if (gf != null) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = time;
					}
				}
				if(value != 1) {
					boyfriend.playAnim('hey', true);
					boyfriend.specialAnim = true;
					boyfriend.heyTimer = time;
				}

			case 'Set GF Speed':
				var value:Int = Std.parseInt(value1);
				if(Math.isNaN(value) || value < 1) value = 1;
				gfSpeed = value;

			case 'Add Camera Zoom':
				if(ClientPrefs.camZooms) { //&& FlxG.camera.zoom < 1.35) {
					var camZoom:Float = Std.parseFloat(value1);
					var hudZoom:Float = Std.parseFloat(value2);
					if(Math.isNaN(camZoom)) camZoom = 0.015;
					if(Math.isNaN(hudZoom)) hudZoom = 0.03;

					FlxG.camera.zoom += camZoom;
					camHUD.zoom += hudZoom;
				}

			case 'Play Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.specialAnim = true;
				}
			
			case 'Play Uninterruptable Animation':
				//trace('Anim to play: ' + value1);
				var char:Character = dad;
				switch(value2.toLowerCase().trim()) {
					case 'bf' | 'boyfriend':
						char = boyfriend;
					case 'gf' | 'girlfriend':
						char = gf;
					default:
						var val2:Int = Std.parseInt(value2);
						if(Math.isNaN(val2)) val2 = 0;

						switch(val2) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.playAnim(value1, true);
					char.uninterruptableAnim = true;
				}

			case 'Camera Follow Pos':
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 0;
				if(Math.isNaN(val2)) val2 = 0;

				isCameraOnForcedPos = false;
				if(!Math.isNaN(Std.parseFloat(value1)) || !Math.isNaN(Std.parseFloat(value2))) {
					camFollow.x = val1;
					camFollow.y = val2;
					isCameraOnForcedPos = true;
				}

			case 'Alt Idle Animation':
				var char:Character = dad;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						char = gf;
					case 'boyfriend' | 'bf':
						char = boyfriend;
					default:
						var val:Int = Std.parseInt(value1);
						if(Math.isNaN(val)) val = 0;

						switch(val) {
							case 1: char = boyfriend;
							case 2: char = gf;
						}
				}

				if (char != null)
				{
					char.idleSuffix = value2;
					char.recalculateDanceIdle();
				}

			case 'Screen Shake':
				if (!ClientPrefs.shaking)
					return;
				var valuesArray:Array<String> = [value1, value2];
				var targetsArray:Array<FlxCamera> = [camGame, camHUD];
				for (i in 0...targetsArray.length) {
					var split:Array<String> = valuesArray[i].split(',');
					var duration:Float = 0;
					var intensity:Float = 0;
					if(split[0] != null) duration = Std.parseFloat(split[0].trim());
					if(split[1] != null) intensity = Std.parseFloat(split[1].trim());
					if(Math.isNaN(duration)) duration = 0;
					if(Math.isNaN(intensity)) intensity = 0;

					if(duration > 0 && intensity != 0) {
						targetsArray[i].shake(intensity, duration);
					}
				}

			case 'Change Character':
				var charType:Int = 0;
				switch(value1.toLowerCase().trim()) {
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType)) charType = 0;
				}

				switch(charType) {
					case 0:
						if(boyfriend.curCharacter != value2) {
							if(!boyfriendMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var lastAlpha:Float = boyfriend.alpha;
							boyfriend.alpha = 0.00001;
							boyfriend = boyfriendMap.get(value2);
							boyfriend.alpha = lastAlpha;
							iconP1.changeIcon(boyfriend.healthIcon);
						}
						setOnLuas('boyfriendName', boyfriend.curCharacter);

					case 1:
						if(dad.curCharacter != value2) {
							if(!dadMap.exists(value2)) {
								addCharacterToList(value2, charType);
							}

							var wasGf:Bool = dad.curCharacter.startsWith('gf');
							var lastAlpha:Float = dad.alpha;
							dad.alpha = 0.00001;
							dad = dadMap.get(value2);
							if(!dad.curCharacter.startsWith('gf')) {
								if(wasGf && gf != null) {
									gf.visible = true;
								}
							} else if(gf != null) {
								gf.visible = false;
							}
							dad.alpha = lastAlpha;
							iconP2.changeIcon(dad.healthIcon);
						}
						setOnLuas('dadName', dad.curCharacter);

					case 2:
						if(gf != null)
						{
							if(gf.curCharacter != value2)
							{
								if(!gfMap.exists(value2))
								{
									addCharacterToList(value2, charType);
								}

								var lastAlpha:Float = gf.alpha;
								gf.alpha = 0.00001;
								gf = gfMap.get(value2);
								gf.alpha = lastAlpha;
							}
							setOnLuas('gfName', gf.curCharacter);
						}
				}
				reloadHealthBarColors();

			case 'Change Scroll Speed':
				if (songSpeedType == "constant")
					return;
				var val1:Float = Std.parseFloat(value1);
				var val2:Float = Std.parseFloat(value2);
				if(Math.isNaN(val1)) val1 = 1;
				if(Math.isNaN(val2)) val2 = 0;

				var newValue:Float = SONG.speed * ClientPrefs.getGameplaySetting('scrollspeed', 1) * val1;

				if(val2 <= 0)
				{
					songSpeed = newValue;
				}
				else
				{
					songSpeedTween = FlxTween.tween(this, {songSpeed: newValue}, val2, {ease: FlxEase.linear, onComplete:
						function (twn:FlxTween)
						{
							songSpeedTween = null;
						}
					});
				}

			case 'Default Cam Zoom':
				var value:Float = Std.parseFloat(value1);
				if (Math.isNaN(value))
					value = 1.05;

				defaultCamZoom = value;

			case 'Singing Shakes':
				if (!ClientPrefs.shaking)
					return;
				var charType:Int = 0;
				switch(value2.toLowerCase().trim())
				{
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value1);
						if(Math.isNaN(charType))
							charType = 0;
				}
				switch (value1.toLowerCase().trim())
				{
					case 'on' | 'true':
						singingShakeArray[charType] = true;
					case 'off' | 'false':
						singingShakeArray[charType] = false;
				}

			case 'Opponent Drain':
				switch (value1.toLowerCase().trim())
				{
					case 'on' | 'true':
						opponentHealthDrain = true;
					case 'off' | 'false':
						opponentHealthDrain = false;
				}

				var drain:Float = Std.parseFloat(value2);
				if (Math.isNaN(drain) || value2 == null)
					drain = 0.023;
				
				opponentHealthDrainAmount = drain;
			
			case 'Camera Visibility':
				var camType:Int = 0;
				
				switch(value2.toLowerCase().trim())
				{
					case 'hud' | 'camhud':
						camType = 1;
					default:
						camType = Std.parseInt(value2);
						if(Math.isNaN(camType)) camType = 0;
				}
				
				var split:Array<String> = value1.split(',');
				var newAlpha:Float = 0;
				var duration:Float = 0;
				if (split[0] != null) newAlpha = Std.parseFloat(split[0].trim());
				if (split[1] != null) duration = Std.parseFloat(split[1].trim());
				if (Math.isNaN(newAlpha)) newAlpha = 0;
				if (Math.isNaN(duration)) duration = 0;

				if (duration != 0)
				{
					switch(camType)
					{
						case 0:
							FlxTween.tween(camGame, {alpha: newAlpha}, duration);
						case 1:
							FlxTween.tween(camHUD, {alpha: newAlpha}, duration);
					}
				}

			case 'Character Visibility':
				var charType:Int = 0;
				
				switch(value2.toLowerCase().trim())
				{
					case 'gf' | 'girlfriend':
						charType = 2;
					case 'dad' | 'opponent':
						charType = 1;
					default:
						charType = Std.parseInt(value2);
						if(Math.isNaN(charType)) charType = 0;
				}
				
				var split:Array<String> = value1.split(',');
				var newAlpha:Float = 0;
				var duration:Float = 0;
				if (split[0] != null) newAlpha = Std.parseFloat(split[0].trim());
				if (split[1] != null) duration = Std.parseFloat(split[1].trim());
				if (Math.isNaN(newAlpha)) newAlpha = 0;
				if (Math.isNaN(duration)) duration = 0;

				trace (charType);
				trace (newAlpha);
				trace (duration);

				if (duration != 0)
				{
					switch(charType)
					{
						case 0:
							FlxTween.tween(boyfriend, {alpha: newAlpha}, duration);
						case 1:
							FlxTween.tween(dad, {alpha: newAlpha}, duration);
						case 2:
							FlxTween.tween(gf, {alpha: newAlpha}, duration);
					}
				}

			case 'Screen Flash':
				if (ClientPrefs.flashing)
				{
					var durationGame:Float = 0;
					if(value1 != null) durationGame = Std.parseFloat(value1.trim());
					if(Math.isNaN(durationGame)) durationGame = 0;
					if(durationGame > 0)
						camGame.flash(FlxColor.WHITE, durationGame, null, true);

					var durationHUD:Float = 0;
					if(value2 != null) durationHUD = Std.parseFloat(value2.trim());
					if(Math.isNaN(durationHUD)) durationHUD = 0;
					if(durationHUD > 0)
						camHUD.flash(FlxColor.WHITE, durationHUD, null, true);
				}

			case 'Stalkers Walk In':
				idiotStalkers.forEach(function(spr:BGSprite)
				{
					if (spr.ID == 0)
						FlxTween.tween(spr, {x: -50}, 5);
					else
						FlxTween.tween(spr, {x: (FlxG.width - spr.width) + 50}, 5);
				});
			
			case 'Background Flash':
				if (ClientPrefs.flashing)
				{
					blackCover.alpha = 0;
					var duration:Float = 0;
					if(value1 != null) duration = Std.parseFloat(value1.trim());
					if(Math.isNaN(duration)) duration = 0;
					FlxTween.tween(blackCover, {alpha: 0}, 0.05, {ease: FlxEase.quadInOut, onComplete:
						function (twn:FlxTween)
						{
							FlxTween.tween(blackCover, {alpha: 1}, duration, {ease: FlxEase.quadInOut});
						}});
				}
			
			case 'Idiot Text Scroll':
				var txtArray:Array<String> = ['you are an idiot', 'ha haha ha ha ha haaa', 'ah hahaha haa'];

				var text1:FlxText = new FlxText(-FlxG.width * 1.5, FlxG.random.int(-200, 400), 0, txtArray[FlxG.random.int(0, 2)]);
				text1.setFormat('vcr.ttf', 128, FlxColor.BLACK, RIGHT);
				addBehindGF(text1);
				FlxTween.tween(text1, {x: FlxG.width * 2 + text1.width}, 2, {onComplete:
					function (twn:FlxTween)
					{
						text1.destroy();
					}
				});

				var text2:FlxText = new FlxText(FlxG.width * 2, FlxG.random.int(-200, 400), 0, txtArray[FlxG.random.int(0, 2)]);
				text2.setFormat('vcr.ttf', 128, FlxColor.BLACK, LEFT);
				addBehindGF(text2);
				FlxTween.tween(text2, {x: -FlxG.width * 1.5 - text2.width}, 2, {onComplete: 
					function (twn:FlxTween)
					{
						text2.destroy();
					}
				});

			case 'Idiot Bluescreen':
				idiotBluescreen(); // fascinating 

			case 'Idiot Invert':
				if(!ClientPrefs.shaders || !ClientPrefs.photosensitivity) return;
					
				if (value1.toLowerCase() == 'on')
				{
					shadersGame.push(new ShaderFilter(new Shaders.InvertColorShader()));
					camGame.setFilters(shadersGame);
					if (curStage == 'idiot')
					{
						idiotCats.forEach(function(spr:BGSprite)
						{
							spr.shader = new Shaders.InvertColorShader();
						});
						idiotStalkers.forEach(function(spr:BGSprite)
						{
							spr.shader = new Shaders.InvertColorShader();
						});
						// should i like... make this a group? or does it not fucking matter because its just for this
						iconP1.shader = new Shaders.InvertColorShader();
						iconP2.shader = new Shaders.InvertColorShader();
						healthBar.shader = new Shaders.InvertColorShader();
						healthBarBG.shader = new Shaders.InvertColorShader();
						scoreTxt.shader = new Shaders.InvertColorShader();
						timeBar.shader = new Shaders.InvertColorShader();
						timeBarBG.shader = new Shaders.InvertColorShader();
						timeTxt.shader = new Shaders.InvertColorShader();
					}
				}
				else
				{
					shadersGame = [];
					camGame.setFilters(shadersGame);
					if (curStage == 'idiot')
					{
						idiotCats.forEach(function(spr:BGSprite)
						{
							spr.shader = null;
						});
						idiotStalkers.forEach(function(spr:BGSprite)
						{
							spr.shader = null;
						});
						iconP1.shader = null;
						iconP2.shader = null;
						healthBar.shader = null;
						healthBarBG.shader = null;
						scoreTxt.shader = null;
						timeBar.shader = null;
						timeBarBG.shader = null;
						timeTxt.shader = null;
					}
				}

			case 'Tween Window Size':
				if(!ClientPrefs.shaking) return;

				var newWidth:Float = Std.parseFloat(value1.split(',')[0].trim());
				if (newWidth == 0 || Math.isNaN(newWidth))
					newWidth = Application.current.window.width;
				var newHeight:Float = Std.parseFloat(value1.split(',')[1].trim());
				if (newHeight == 0 || Math.isNaN(newHeight))
					newHeight = Application.current.window.height;
				FlxTween.tween(Application.current.window, {width: newWidth, height: newHeight}, Std.parseFloat(value2));
			
			case 'Tween Window Position':
				if(!ClientPrefs.shaking) return;
				
				var newX:Float = Std.parseFloat(value1.split(',')[0].trim());
				if (newX == 0 || Math.isNaN(newX))
					newX = Application.current.window.x;
				var newY:Float = Std.parseFloat(value1.split(',')[1].trim());
				if (newY == 0 || Math.isNaN(newY))
					newY = Application.current.window.y;
				FlxTween.tween(Application.current.window, {x: newX, y: newY}, Std.parseFloat(value2));

			case 'Create Idiot Popup':
				//Lib.application.window.id
				popupWindow(280, 300, FlxG.random.int(0, 2000), FlxG.random.int(0, 1000), 'You are an idiot!');
				//popupFunction();
				
			//	var fuck:Fuck = new Fuck();
			//	FlxG.camera.bgColor = FlxColor.TRANSPARENT;
			//	Lib.current.stage.color = 0x00FFFFFF;
			//	trace ('poo');
			//	FlxG.stage.visible = false;
			//	Transparency.setTransparency("Friday Night Funkin': Psych Engine", 0x00000000);

			case 'Cereal Spit':
				var healthToTake:Float = Std.parseFloat(value1);
				if (Math.isNaN(healthToTake))
					healthToTake = 0.5;
				trace (healthToTake);
				dad.playAnim('spit', true);
				dad.specialAnim = true;
				new FlxTimer().start(0.25, function(tmr:FlxTimer) {
					if (SONG.needsVoices && vocals != null)
						vocals.volume = 1;
					boyfriend.playAnim('hurt', true);
					boyfriend.specialAnim = true;
					var erm:ColorSwap = new ColorSwap();
					erm.saturation = -1.0;
					erm.brightness = 0.2;
					boyfriend.shader = erm.shader;
					health -= healthToTake;
					FlxTween.tween(erm, {saturation: 0, brightness: 0}, 5);
				});

			case 'Cereal Table Flip End':
				cerealChair.alpha = 1;
				spoonAndBowl.alpha = 1;
				thrownTable.alpha = 1;
				FlxTween.tween(thrownTable, {x: 2000, y: 800}, 4, {ease: FlxEase.quartOut, onComplete: function(tween:FlxTween){thrownTable.destroy();}});

			case 'Set Haxe Shader':
				if(!ClientPrefs.shaders) return;

				switch (value2.toLowerCase())
				{
					case 'invert':
						if (ClientPrefs.photosensitivity)
						{
							if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
								shadersHUD.push(new ShaderFilter(new Shaders.InvertColorShader()));
							else
								shadersGame.push(new ShaderFilter(new Shaders.InvertColorShader()));
						}
					case 'chrom' | 'chroma' | 'chromatic' | 'chromatic abberation':
						if (ClientPrefs.photosensitivity)
							if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
								addChroma(0.002, true);
							else
								addChroma(0.002, false);
					case 'static' | 'vcr':
						if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
							shadersHUD.push(new ShaderFilter(new Shaders.Static()));
						else
							shadersGame.push(new ShaderFilter(new Shaders.Static()));
					case 'ntsc':
						if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
							shadersHUD.push(new ShaderFilter(new Shaders.NtscFX().shader));
						else
							shadersGame.push(new ShaderFilter(new Shaders.NtscFX().shader));
					case 'red':
						if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
							shadersHUD.push(new ShaderFilter(new Shaders.RedColorShaderTest()));
						else
							shadersGame.push(new ShaderFilter(new Shaders.RedColorShaderTest()));
					case 'mlg':
						if (mlgShader == null)
							mlgShader = new ColorSwap();

						if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
							shadersHUD.push(new ShaderFilter(mlgShader.shader));
						else
							shadersGame.push(new ShaderFilter(mlgShader.shader));

					case 'clear' | 'null' | 'none':
						if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
							shadersHUD = [];
						else
							shadersGame = [];
				}

				if (value1.toLowerCase() == 'camhud' || value1.toLowerCase() == 'hud')
					camHUD.setFilters(shadersHUD);
				else
					camGame.setFilters(shadersGame);
			
			case 'Change Icon':
				var iconToSwitch:HealthIcon = 
				switch(value1.toLowerCase().trim())
				{
					case 'dad' | 'opponent' | 'p2':
						iconP2;
					default:
						iconP1;
				}

				iconToSwitch.changeIcon(value2);
				reloadHealthBarColors();

			case 'Chromatic Bump':
				if(!ClientPrefs.shaders || !ClientPrefs.photosensitivity) return;

				var split:Array<String> = value1.split(',');
				var peak:Float = 0.01;
				var end:Float = 0;
				var decay:Float = 1;
				if(split[0] != null) peak = Std.parseFloat(split[0].trim());
				if(split[1] != null) end = Std.parseFloat(split[1].trim());
				if(split[2] != null) decay = Std.parseFloat(split[2].trim());
				if (value2.toLowerCase() == 'camhud' || value2.toLowerCase() == 'hud')
					chromaBump(peak, end, decay, true);
				else
					chromaBump(peak, end, decay, false);

			case 'Display Credit':
				songCredit();

			case 'Set Cam On Character':
				moveCamera(
				switch(value1.toLowerCase().trim())
				{
					case 'dad' | 'opponent' | 'p2':
						true;
					default:
						false;
				}
				);

			case 'Weegee Video Controls':
				switch(value1.toLowerCase().trim())
				{
					case 'play':
						canPause = false;
						#if VIDEOS_ALLOWED
						var filepath:String = Paths.video('mama_luigi_for_you_mario');
						#if sys
						if(!FileSystem.exists(filepath))
						#else
						if(!OpenFlAssets.exists(filepath))
						#end
						{
							FlxG.log.warn('Couldnt find the YTP :(');
							return;
						}
						weegeeVideo.playVideo(Paths.video('mama_luigi_for_you_mario'));
						weegeeVideo.finishCallback = function()
						{
							weegeeVideo.destroy();
						}
						#else
						FlxG.log.warn('Platform not supported!');
						return;
						#end
					case 'reveal':
						#if VIDEOS_ALLOWED
						weegeeVideo.alpha = 1;
						#end
					
					case 'remove':
						canPause = true;
						#if VIDEOS_ALLOWED
						weegeeVideo.visible = false;
						weegeeVideo.alpha = 0.00001; //fraction alphas dont work ithink 
						#end
				}
			
			case 'HealthBar InOut':
				healthBar.fillDirection = HORIZONTAL_INSIDE_OUT;

			case 'Countdown':
				var countdownSuffix:String = value2.trim();
				var countdownNum:Int = Std.parseInt(value1.trim());
				if (Math.isNaN(countdownNum))
					countdownNum = 0;
				
				//this is dumb ill fix it later idc rn 
				var introAssets:Map<String, Array<String>> = new Map<String, Array<String>>();
				introAssets.set('default', ['ready', 'set', 'go']);
				introAssets.set('pixel', ['pixelUI/ready-pixel', 'pixelUI/set-pixel', 'pixelUI/date-pixel']);

				var introAlts:Array<String> = introAssets.get('default');
				var antialias:Bool = ClientPrefs.globalAntialiasing;
				var daCountdownCam:FlxCamera = camHUD;
				if (camHUD.alpha < 1)
					daCountdownCam = camOther;
				switch (countdownNum)
				{
					case 3:
						FlxG.sound.play(Paths.sound('intro3' + countdownSuffix), 0.6);
					case 2:
						countdownReady = new FlxSprite().loadGraphic(Paths.image(introAlts[0]));
						countdownReady.cameras = [daCountdownCam];
						countdownReady.scrollFactor.set();
						countdownReady.updateHitbox();

						if (PlayState.isPixelStage)
							countdownReady.setGraphicSize(Std.int(countdownReady.width * daPixelZoom));

						countdownReady.screenCenter();
						countdownReady.antialiasing = antialias;
						insert(members.indexOf(notes), countdownReady);
						FlxTween.tween(countdownReady, {/*y: countdownReady.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownReady);
								countdownReady.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro2' + countdownSuffix), 0.6);
					case 1:
						countdownSet = new FlxSprite().loadGraphic(Paths.image(introAlts[1]));
						countdownSet.cameras = [daCountdownCam];
						countdownSet.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownSet.setGraphicSize(Std.int(countdownSet.width * daPixelZoom));

						countdownSet.screenCenter();
						countdownSet.antialiasing = antialias;
						insert(members.indexOf(notes), countdownSet);
						FlxTween.tween(countdownSet, {/*y: countdownSet.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownSet);
								countdownSet.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('intro1' + countdownSuffix), 0.6);
					case 0:
						countdownGo = new FlxSprite().loadGraphic(Paths.image(introAlts[2]));
						countdownGo.cameras = [daCountdownCam];
						countdownGo.scrollFactor.set();

						if (PlayState.isPixelStage)
							countdownGo.setGraphicSize(Std.int(countdownGo.width * daPixelZoom));

						countdownGo.updateHitbox();

						countdownGo.screenCenter();
						countdownGo.antialiasing = antialias;
						insert(members.indexOf(notes), countdownGo);
						FlxTween.tween(countdownGo, {/*y: countdownGo.y + 100,*/ alpha: 0}, Conductor.crochet / 1000, {
							ease: FlxEase.cubeInOut,
							onComplete: function(twn:FlxTween)
							{
								remove(countdownGo);
								countdownGo.destroy();
							}
						});
						FlxG.sound.play(Paths.sound('introGo' + countdownSuffix), 0.6);						
				}

			case 'Set New Note Keys':
				setKeys(Std.int(Std.parseFloat(value1)), (value2.toLowerCase() == 'true' ? true : false));

			case 'Add Spacebar Button':
				spacebarButton.alpha = 1;
				new FlxTimer().start((Std.parseFloat(value1) == Math.NaN ? 4 : Std.parseFloat(value1)), function(tmr:FlxTimer) 
				{
					FlxTween.tween(spacebarButton, {alpha: 0}, 1);
				});

			case "We're Not Done Here Yet.":
				var text1:FlxText = new FlxText(50, 50, 0, "We're", 64);
				text1.setFormat(Paths.font("impact.otf"), 64, FlxColor.WHITE, LEFT);
				text1.cameras = [camOther];

				var text2:FlxText = new FlxText(0, 0, 0, "not", 64);
				text2.setFormat(Paths.font("impact.otf"), 64, FlxColor.WHITE, RIGHT);
				text2.cameras = [camOther];
				text2.setPosition((FlxG.width - 50) - text2.width, 50);

				var text3:FlxText = new FlxText(0, 0, 0, "done", 128);
				text3.setFormat(Paths.font("impact.otf"), 128, FlxColor.WHITE, CENTER);
				text3.cameras = [camOther];
				text3.screenCenter();

				var text4:FlxText = new FlxText(0, 0, 0, "here", 64);
				text4.setFormat(Paths.font("impact.otf"), 64, FlxColor.WHITE, LEFT);
				text4.cameras = [camOther];
				text4.setPosition(50, (FlxG.height - 50) - text4.height);

				var text5:FlxText = new FlxText(0, 0, 0, "yet.", 64);
				text5.setFormat(Paths.font("impact.otf"), 64, FlxColor.WHITE, RIGHT);
				text5.cameras = [camOther];
				text5.setPosition((FlxG.width - 50) - text5.width, (FlxG.height - 50) - text5.height);

				add(text1);
				new FlxTimer().start((0.18), function(tmr:FlxTimer) 
				{
					add(text2);
					new FlxTimer().start((0.29), function(tmr:FlxTimer) 
					{
						add(text3);
						new FlxTimer().start((0.29), function(tmr:FlxTimer) 
						{
							add(text4);
							new FlxTimer().start((0.23), function(tmr:FlxTimer) 
							{
								add(text5);
								new FlxTimer().start((0.58), function(tmr:FlxTimer) 
								{
									text1.destroy();
									text2.destroy();
									text3.destroy();
									text4.destroy();
									text5.destroy();
								});
							});
						});
					});
				});
				
			//	FlxTween.tween(text1, {x: FlxG.width * 2 + text1.width}, 2, {onComplete:
			//		function (twn:FlxTween)
			//		{
			//			text1.destroy();
			//		}
			//	});
			
			case 'Set Property':
				var killMe:Array<String> = value1.split('.');
				if(killMe.length > 1) {
					FunkinLua.setVarInArray(FunkinLua.getPropertyLoopThingWhatever(killMe, true, true), killMe[killMe.length-1], value2);
				} else {
					FunkinLua.setVarInArray(this, value1, value2);
				}
		}
		callOnLuas('onEvent', [eventName, value1, value2]);
	}

	var windowPopup:Window;
	var dadWin = new Sprite();
	var dadScrollWin = new Sprite();
	var popupSprite = new Sprite();
	var popupScrollWin = new Sprite();

	function popupFunction()
	{
		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.fromRGB(0, 255, 0));
		if (defaultCamZoom < 1)
		{
		  bg.scale.scale(1 / defaultCamZoom);
		}
		bg.scrollFactor.set();
		add(bg);
		FlxTransWindow.getWindowsTransparent();
	}

	function popupWindow(customWidth:Int, customHeight:Int, ?customX:Int, ?customY:Int, ?customName:String) {
        var display = Application.current.window.display.currentMode;
        var m = new Matrix();

		if(customName == '' || customName == null){
			customName = 'Opponent.json';
		}
		
        windowPopup = Lib.application.createWindow({
            title: customName,
            width: customWidth,
            height: customHeight,
            borderless: true,
            alwaysOnTop: true

        });

		if(customX == null)
			customX = -10;
		
		if(customY == null)
			customY = -10;

        windowPopup.x = customX;
		windowPopup.y = customY;
        windowPopup.stage.color = 0xFF00FF00;

        @:privateAccess
        windowPopup.stage.addEventListener("keyDown", FlxG.keys.onKeyDown);
        @:privateAccess
        windowPopup.stage.addEventListener("keyUp", FlxG.keys.onKeyUp);

        // Application.current.window.x = Std.int(display.width / 2) - 640;
        // Application.current.window.y = Std.int(display.height / 2);

        // var bg = Paths.image(PUT YOUR IMAGE HERE!!!!).bitmap;
        // var spr = new Sprite();

        
        // spr.graphics.beginBitmapFill(bg, m);
        // spr.graphics.drawRect(0, 0, bg.width, bg.height);
        // spr.graphics.endFill();
        
        //Application.current.window.resize(640, 480);

		popupSprite = new Sprite();
		popupSprite.graphics.beginBitmapFill(popupFlxSprite.pixels, m);
		popupSprite.graphics.drawRect(0, 0, popupFlxSprite.width, popupFlxSprite.height);
		popupSprite.graphics.endFill();

		popupScrollWin.scrollRect = new Rectangle();
		windowPopup.stage.addChild(popupScrollWin);
        popupScrollWin.addChild(popupSprite);

		//windowPopup.stage.addChild(popupSprite);

    /*   dadWin.graphics.beginBitmapFill(dad.pixels, m);
        dadWin.graphics.drawRect(0, 0, dad.pixels.width, dad.pixels.height);
        dadWin.graphics.endFill();

        dadScrollWin.scrollRect = new Rectangle();
		windowPopup.stage.addChild(dadScrollWin);
        dadScrollWin.addChild(dadWin);
        dadScrollWin.scaleX = 0.7;
        dadScrollWin.scaleY = 0.7;*/

        // dadGroup.visible = false;
        // uncomment the line above if you want it to hide the dad ingame and make it visible via the windoe

        Application.current.window.focus();
	    FlxG.autoPause = false;
		FlxG.mouse.useSystemCursor = true;
    }

	function moveCameraSection():Void {
		if(SONG.notes[curSection] == null) return;

		if (gf != null && SONG.notes[curSection].gfSection)
		{
			camFollow.set(gf.getMidpoint().x, gf.getMidpoint().y);
			camFollow.x += gf.cameraPosition[0] + girlfriendCameraOffset[0];
			camFollow.y += gf.cameraPosition[1] + girlfriendCameraOffset[1];
			tweenCamIn();
			callOnLuas('onMoveCamera', ['gf']);
			return;
		}

		if (!SONG.notes[curSection].mustHitSection)
		{
			moveCamera(true);
			callOnLuas('onMoveCamera', ['dad']);
		}
		else
		{
			moveCamera(false);
			callOnLuas('onMoveCamera', ['boyfriend']);
		}
	}

	var cameraTwn:FlxTween;
	public function moveCamera(isDad:Bool)
	{
		if(isDad)
		{
			//FlxTween.tween(camFollow, {
			//	x: (dad.getMidpoint().x + 150) += (dad.cameraPosition[0] + opponentCameraOffset[0]), 
			//	y: (dad.getMidpoint().y - 100) += (dad.cameraPosition[1] + opponentCameraOffset[1])
			//}, (0.5), {ease: FlxEase.sineInOut}); //meh

			camFollow.set(dad.getMidpoint().x + 150, dad.getMidpoint().y - 100);
			camFollow.x += dad.cameraPosition[0] + opponentCameraOffset[0];
			camFollow.y += dad.cameraPosition[1] + opponentCameraOffset[1];
			tweenCamIn();
		}
		else
		{
			//FlxTween.tween(camFollow, {
			//	x: (boyfriend.getMidpoint().x - 100) -= (boyfriend.cameraPosition[0] - boyfriendCameraOffset[0]), 
			//	y: (boyfriend.getMidpoint().y - 100) += (boyfriend.cameraPosition[1] + boyfriendCameraOffset[1])
			//}, (0.5), {ease: FlxEase.sineInOut});

			camFollow.set(boyfriend.getMidpoint().x - 100, boyfriend.getMidpoint().y - 100);
			camFollow.x -= boyfriend.cameraPosition[0] - boyfriendCameraOffset[0];
			camFollow.y += boyfriend.cameraPosition[1] + boyfriendCameraOffset[1];

			if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1)
			{
				cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
					function (twn:FlxTween)
					{
						cameraTwn = null;
					}
				});
			}
		}
	}

	function tweenCamIn() {
		if (Paths.formatToSongPath(SONG.song) == 'tutorial' && cameraTwn == null && FlxG.camera.zoom != 1.3) {
			cameraTwn = FlxTween.tween(FlxG.camera, {zoom: 1.3}, (Conductor.stepCrochet * 4 / 1000), {ease: FlxEase.elasticInOut, onComplete:
				function (twn:FlxTween) {
					cameraTwn = null;
				}
			});
		}
	}

	function snapCamFollowToPos(x:Float, y:Float) {
		camFollow.set(x, y);
		camFollowPos.setPosition(x, y);
	}

	public function finishSong(?ignoreNoteOffset:Bool = false):Void
	{
		var finishCallback:Void->Void = endSong; //In case you want to change it in a specific song.

		updateTime = false;
		FlxG.sound.music.volume = 0;
		vocals.volume = 0;
		vocals.pause();
		if(ClientPrefs.noteOffset <= 0 || ignoreNoteOffset) {
			finishCallback();
		} else {
			finishTimer = new FlxTimer().start(ClientPrefs.noteOffset / 1000, function(tmr:FlxTimer) {
				finishCallback();
			});
		}
	}


	public var transitioning = false;
	public function endSong():Void
	{
		if (windowPopup != null) // note to self, once a new window is created, there appears to be no real way to access former windowPopups, create seperate instances for each window
			windowPopup.close();

		//Should kill you if you tried to cheat
		if(!startingSong) {
			notes.forEach(function(daNote:Note) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			});
			for (daNote in unspawnNotes) {
				if(daNote.strumTime < songLength - Conductor.safeZoneOffset) {
					health -= 0.05 * healthLoss;
				}
			}

			if(doDeathCheck()) {
				return;
			}
		}

		timeBarBG.visible = false;
		timeBar.visible = false;
		timeTxt.visible = false;
		canPause = false;
		endingSong = true;
		camZooming = false;
		inCutscene = false;
		updateTime = false;

		deathCounter = 0;
		seenCutscene = false;

		#if ACHIEVEMENTS_ALLOWED
		if(achievementObj != null) {
			return;
		} else {
			var achieve:String = checkForAchievement(['week1_nomiss', 'week2_nomiss', 'week3_nomiss', 'week4_nomiss',
				'week5_nomiss', 'week6_nomiss', 'week7_nomiss', 'ur_bad',
				'ur_good', 'hype', 'two_keys', 'toastie', 'debugger']);

			if(achieve != null) {
				startAchievement(achieve);
				return;
			}
		}
		#end

		var ret:Dynamic = callOnLuas('onEndSong', [], false);
		if(ret != FunkinLua.Function_Stop && !transitioning) {
			if (SONG.validScore)
			{
				#if !switch
				var percent:Float = ratingPercent;
				if(Math.isNaN(percent)) percent = 0;
				Highscore.saveScore(SONG.song, songScore, storyDifficulty, percent);
				#end
			}

			if (chartingMode)
			{
				openChartEditor();
				return;
			}

			if (isStoryMode)
			{
				campaignScore += songScore;
				campaignMisses += songMisses;

				storyPlaylist.remove(storyPlaylist[0]);

				if (storyPlaylist.length <= 0)
				{
					WeekData.loadTheFirstEnabledMod();
					
					cancelMusicFadeTween();
					if(FlxTransitionableState.skipNextTransIn) {
						CustomFadeTransition.nextCamera = null;
					}

					switch (curSong)
					{
						case 'Introllduction':
							//new FlxTimer().start(0.5, function(tmr:FlxTimer) {
								FlxTransitionableState.skipNextTransIn = true;
								FlxTransitionableState.skipNextTransOut = true;
								MusicBeatState.switchState(new IntrollductionPostState2());
							//});
						case 'Tomfoolery':
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							openSubState(new StaticImageEndingSubstate(['End1', 'End2', 'End3'], camOther, true));
						default:
							FlxG.sound.playMusic(Paths.music('freakyMenu'));
							MusicBeatState.switchState(new MainMenuState());
					}

					if(!ClientPrefs.getGameplaySetting('practice', false) && !ClientPrefs.getGameplaySetting('botplay', false)) {
						StoryMenuState.weekCompleted.set(storyWeek, true);

						if (SONG.validScore)
						{
							Highscore.saveWeekScore(WeekData.getWeekFileName(), campaignScore, storyDifficulty);
						}

						FlxG.save.data.weekCompleted = StoryMenuState.weekCompleted;
						FlxG.save.flush();
					}
					changedDifficulty = false;
				}
				else
				{
					var difficulty:String = CoolUtil.getDifficultyFilePath();

					trace('LOADING NEXT SONG');
					trace(Paths.formatToSongPath(PlayState.storyPlaylist[0]) + difficulty);

					FlxTransitionableState.skipNextTransIn = true;
					FlxTransitionableState.skipNextTransOut = true;

					prevCamFollow = camFollow;
					prevCamFollowPos = camFollowPos;

					PlayState.SONG = Song.loadFromJson(PlayState.storyPlaylist[0] + difficulty, PlayState.storyPlaylist[0]);
					FlxG.sound.music.stop();

					switch (curSong)
					{
						case 'Trolling':
							var blackShit:FlxSprite = new FlxSprite(-FlxG.width * FlxG.camera.zoom,
								-FlxG.height * FlxG.camera.zoom).makeGraphic(FlxG.width * 3, FlxG.height * 3, FlxColor.BLACK);
							blackShit.scrollFactor.set();
							blackShit.alpha = 0.00001;
							add(blackShit);
							FlxTween.tween(blackShit, {alpha: 1}, 1, {ease: FlxEase.linear, onComplete:
							function (twn:FlxTween) 
							{	
								cancelMusicFadeTween();
								LoadingState.loadAndSwitchState(new PlayState());
							}});
							FlxTween.tween(camHUD, {alpha: 0}, 1, {ease: FlxEase.linear});
						default:
							cancelMusicFadeTween();
							LoadingState.loadAndSwitchState(new PlayState());
					}
				}
			}
			else
			{
				trace('WENT BACK TO FREEPLAY??');
				WeekData.loadTheFirstEnabledMod();
				cancelMusicFadeTween();
				if(FlxTransitionableState.skipNextTransIn) {
					CustomFadeTransition.nextCamera = null;
				}
				trace (curSong);
				switch (curSong)
				{
					case 'Alone Forever':
						var daEnding:String = 'escape';
						if (ratingFC == 'SFC' || ratingFC == 'GFC' || ratingFC == 'FC')
							daEnding == 'friends';
						
						openSubState(new StaticImageEndingSubstate([daEnding], camOther, true));
					case 'Spooky Scary':
						MusicBeatState.switchState(new FreeplaySelectState());
					default:
						MusicBeatState.switchState(new FreeplayState(songCategory));
				}
				FlxG.sound.playMusic(Paths.music('freakyMenu'));
				changedDifficulty = false;
			}
			transitioning = true;
		}
	}

	#if ACHIEVEMENTS_ALLOWED
	var achievementObj:AchievementObject = null;
	function startAchievement(achieve:String) {
		achievementObj = new AchievementObject(achieve, camOther);
		achievementObj.onFinish = achievementEnd;
		add(achievementObj);
		trace('Giving achievement ' + achieve);
	}
	function achievementEnd():Void
	{
		achievementObj = null;
		if(endingSong && !inCutscene) {
			endSong();
		}
	}
	#end

	public function KillNotes() {
		while(notes.length > 0) {
			var daNote:Note = notes.members[0];
			daNote.active = false;
			daNote.visible = false;

			daNote.kill();
			notes.remove(daNote, true);
			daNote.destroy();
		}
		unspawnNotes = [];
		eventNotes = [];
	}

	function doGhostAnim(char:String, animToPlay:String, fadeTime:Float) // i love you vs impostor <3
	{
		var ghost:FlxSprite = dadGhost;
		var player:Character = dad;
		var trueFadeTime:Float = 0.6 + (fadeTime / 1000);

		switch(char.toLowerCase().trim()){
			case 'bf' | 'boyfriend' | '0':
				ghost = bfGhost;
				player = boyfriend;
			case 'dad' | 'opponent' | '1':
				ghost = dadGhost;
				player = dad;
			case 'gf' | 'girlfriend' | '2':
				ghost = gfGhost;
				player = gf;
		}
					
		ghost.frames = player.frames;
		ghost.animation.copyFrom(player.animation);
		ghost.x = player.x;
		ghost.y = player.y;
		ghost.animation.play(animToPlay, true);
		ghost.offset.set(player.animOffsets.get(animToPlay)[0], player.animOffsets.get(animToPlay)[1]);
		ghost.flipX = player.flipX;
		ghost.flipY = player.flipY;
		ghost.blend = HARDLIGHT;
		ghost.alpha = 0.8;
		ghost.angle = player.angle;
		ghost.visible = true;

		switch (char.toLowerCase().trim())
		{
			case 'bf' | 'boyfriend' | '0':
				if (bfGhostTween != null)
					bfGhostTween.cancel();
				ghost.color = FlxColor.fromRGB(boyfriend.healthColorArray[0] + 50, boyfriend.healthColorArray[1] + 50, boyfriend.healthColorArray[2] + 50);
				bfGhostTween = FlxTween.tween(bfGhost, {alpha: 0}, trueFadeTime, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						bfGhostTween = null;
					}
				});
			case 'dad' | 'opponent' | '1':
				if (dadGhostTween != null)
					dadGhostTween.cancel();
				ghost.color = FlxColor.fromRGB(dad.healthColorArray[0] + 50, dad.healthColorArray[1] + 50, dad.healthColorArray[2] + 50);
				dadGhostTween = FlxTween.tween(dadGhost, {alpha: 0}, trueFadeTime, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						dadGhostTween = null;
					}
				});
			case 'gf' | 'girlfriend' | '2':
				if (gfGhostTween != null)
					gfGhostTween.cancel();
				ghost.color = FlxColor.fromRGB(gf.healthColorArray[0] + 50, gf.healthColorArray[1] + 50, gf.healthColorArray[2] + 50);
				gfGhostTween = FlxTween.tween(gfGhost, {alpha: 0}, trueFadeTime, {
					ease: FlxEase.linear,
					onComplete: function(twn:FlxTween)
					{
						gfGhostTween = null;
					}
				});	
		}
	}

	public var totalPlayed:Int = 0;
	public var totalNotesHit:Float = 0.0;

	public var showCombo:Bool = false;
	public var showComboNum:Bool = true;
	public var showRating:Bool = true;

	private function cachePopUpScore()
	{
		var pixelShitPart1:String = '';
		var pixelShitPart2:String = '';
		if (isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		Paths.image(pixelShitPart1 + "sick" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "good" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "bad" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "shit" + pixelShitPart2);
		Paths.image(pixelShitPart1 + "combo" + pixelShitPart2);
		
		for (i in 0...10) {
			Paths.image(pixelShitPart1 + 'num' + i + pixelShitPart2);
		}
	}

	private function popUpScore(note:Note = null):Void
	{
		var noteDiff:Float = Math.abs(note.strumTime - Conductor.songPosition + ClientPrefs.ratingOffset);
		//trace(noteDiff, ' ' + Math.abs(note.strumTime - Conductor.songPosition));

		// boyfriend.playAnim('hey');

		var placement:String = Std.string(combo);

		var coolText:FlxText = new FlxText(0, 0, 0, placement, 32);
		coolText.screenCenter();
		coolText.x = FlxG.width * 0.35;
		//

		var rating:FlxSprite = new FlxSprite();
		var score:Int = 350;

		//tryna do MS based judgment due to popular demand
		var daRating:Rating = Conductor.judgeNote(note, noteDiff);

		totalNotesHit += daRating.ratingMod;
		note.ratingMod = daRating.ratingMod;
		if(!note.ratingDisabled) daRating.increase();
		note.rating = daRating.name;
		score = daRating.score;

		if(daRating.noteSplash && !note.noteSplashDisabled)
		{
			spawnNoteSplashOnNote(note);
		}

		if(!practiceMode && !cpuControlled) {
			songScore += score;
			if(!note.ratingDisabled)
			{
				songHits++;
				totalPlayed++;
				RecalculateRating(false);
			}
		}

		var pixelShitPart1:String = "";
		var pixelShitPart2:String = '';

		if (PlayState.isPixelStage)
		{
			pixelShitPart1 = 'pixelUI/';
			pixelShitPart2 = '-pixel';
		}

		rating.loadGraphic(Paths.image(pixelShitPart1 + daRating.image + pixelShitPart2));
		rating.cameras = [camHUD];
		rating.screenCenter();
		rating.x = coolText.x - 40;
		rating.y -= 60;
		rating.acceleration.y = 550;
		rating.velocity.y -= FlxG.random.int(140, 175);
		rating.velocity.x -= FlxG.random.int(0, 10);
		rating.visible = (!ClientPrefs.hideHud && showRating);
		rating.x += ClientPrefs.comboOffset[0];
		rating.y -= ClientPrefs.comboOffset[1];

		var comboSpr:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'combo' + pixelShitPart2));
		comboSpr.cameras = [camHUD];
		comboSpr.screenCenter();
		comboSpr.x = coolText.x;
		comboSpr.acceleration.y = FlxG.random.int(200, 300);
		comboSpr.velocity.y -= FlxG.random.int(140, 160);
		comboSpr.visible = (!ClientPrefs.hideHud && showCombo);
		comboSpr.x += ClientPrefs.comboOffset[0];
		comboSpr.y -= ClientPrefs.comboOffset[1];
		comboSpr.y += 60;
		comboSpr.velocity.x += FlxG.random.int(1, 10);

		insert(members.indexOf(strumLineNotes), rating);

		if (!PlayState.isPixelStage)
		{
			rating.setGraphicSize(Std.int(rating.width * 0.7));
			rating.antialiasing = ClientPrefs.globalAntialiasing;
			comboSpr.setGraphicSize(Std.int(comboSpr.width * 0.7));
			comboSpr.antialiasing = ClientPrefs.globalAntialiasing;
		}
		else
		{
			rating.setGraphicSize(Std.int(rating.width * daPixelZoom * 0.85));
			comboSpr.setGraphicSize(Std.int(comboSpr.width * daPixelZoom * 0.85));
		}

		comboSpr.updateHitbox();
		rating.updateHitbox();

		var seperatedScore:Array<Int> = [];

		if(combo >= 1000) {
			seperatedScore.push(Math.floor(combo / 1000) % 10);
		}
		seperatedScore.push(Math.floor(combo / 100) % 10);
		seperatedScore.push(Math.floor(combo / 10) % 10);
		seperatedScore.push(combo % 10);

		var daLoop:Int = 0;
		var xThing:Float = 0;
		if (showCombo)
		{
			insert(members.indexOf(strumLineNotes), comboSpr);
		}
		for (i in seperatedScore)
		{
			var numScore:FlxSprite = new FlxSprite().loadGraphic(Paths.image(pixelShitPart1 + 'num' + Std.int(i) + pixelShitPart2));
			numScore.cameras = [camHUD];
			numScore.screenCenter();
			numScore.x = coolText.x + (43 * daLoop) - 90;
			numScore.y += 80;

			numScore.x += ClientPrefs.comboOffset[2];
			numScore.y -= ClientPrefs.comboOffset[3];

			if (!PlayState.isPixelStage)
			{
				numScore.antialiasing = ClientPrefs.globalAntialiasing;
				numScore.setGraphicSize(Std.int(numScore.width * 0.5));
			}
			else
			{
				numScore.setGraphicSize(Std.int(numScore.width * daPixelZoom));
			}
			numScore.updateHitbox();

			numScore.acceleration.y = FlxG.random.int(200, 300);
			numScore.velocity.y -= FlxG.random.int(140, 160);
			numScore.velocity.x = FlxG.random.float(-5, 5);
			numScore.visible = !ClientPrefs.hideHud;

			//if (combo >= 10 || combo == 0)
			if(showComboNum)
				insert(members.indexOf(strumLineNotes), numScore);

			FlxTween.tween(numScore, {alpha: 0}, 0.2, {
				onComplete: function(tween:FlxTween)
				{
					numScore.destroy();
				},
				startDelay: Conductor.crochet * 0.002
			});

			daLoop++;
			if(numScore.x > xThing) xThing = numScore.x;
		}
		comboSpr.x = xThing + 50;
		/*
			trace(combo);
			trace(seperatedScore);
		 */

		coolText.text = Std.string(seperatedScore);
		// add(coolText);

		FlxTween.tween(rating, {alpha: 0}, 0.2, {
			startDelay: Conductor.crochet * 0.001
		});

		FlxTween.tween(comboSpr, {alpha: 0}, 0.2, {
			onComplete: function(tween:FlxTween)
			{
				coolText.destroy();
				comboSpr.destroy();

				rating.destroy();
			},
			startDelay: Conductor.crochet * 0.002
		});
	}

	public var strumsBlocked:Array<Bool> = [];
	private function onKeyPress(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		//trace('Pressed: ' + eventKey);

		if (!cpuControlled && startedCountdown && !paused && key > -1 && (FlxG.keys.checkStatus(eventKey, JUST_PRESSED) || ClientPrefs.controllerMode) && !notesDisabled)
		{
			if(!boyfriend.stunned && generatedMusic && !endingSong)
			{
				//more accurate hit time for the ratings?
				var lastTime:Float = Conductor.songPosition;
				Conductor.songPosition = FlxG.sound.music.time;

				var canMiss:Bool = !ClientPrefs.ghostTapping;

				// heavily based on my own code LOL if it aint broke dont fix it
				var pressNotes:Array<Note> = [];
				//var notesDatas:Array<Int> = [];
				var notesStopped:Bool = false;

				var sortedNotesList:Array<Note> = [];
				notes.forEachAlive(function(daNote:Note)
				{
					if (strumsBlocked[daNote.noteData] != true && daNote.canBeHit && daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.isSustainNote && !daNote.blockHit)
					{
						if(daNote.noteData == key)
						{
							sortedNotesList.push(daNote);
							//notesDatas.push(daNote.noteData);
						}
						canMiss = true;
					}
				});
				sortedNotesList.sort(sortHitNotes);

				if (sortedNotesList.length > 0) {
					for (epicNote in sortedNotesList)
					{
						for (doubleNote in pressNotes) {
							if (Math.abs(doubleNote.strumTime - epicNote.strumTime) < 1) {
								doubleNote.kill();
								notes.remove(doubleNote, true);
								doubleNote.destroy();
							} else
								notesStopped = true;
						}

						// eee jack detection before was not super good
						if (!notesStopped) {
							goodNoteHit(epicNote);
							pressNotes.push(epicNote);
						}

					}
				}
				else{
					callOnLuas('onGhostTap', [key]);
					if (canMiss) {
						noteMissPress(key);
					}
				}

				// I dunno what you need this for but here you go
				//									- Shubs

				// Shubs, this is for the "Just the Two of Us" achievement lol
				//									- Shadow Mario
				keysPressed[key] = true;

				//more accurate hit time for the ratings? part 2 (Now that the calculations are done, go back to the time it was before for not causing a note stutter)
				Conductor.songPosition = lastTime;
			}

			var spr:StrumNote = playerStrums.members[key];
			if(strumsBlocked[key] != true && spr != null && spr.animation.curAnim.name != 'confirm')
			{
				spr.playAnim('pressed');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyPress', [key]);
		}
		//trace('pressed: ' + controlArray);
	}

	function sortHitNotes(a:Note, b:Note):Int
	{
		if (a.lowPriority && !b.lowPriority)
			return 1;
		else if (!a.lowPriority && b.lowPriority)
			return -1;

		return FlxSort.byValues(FlxSort.ASCENDING, a.strumTime, b.strumTime);
	}

	private function onKeyRelease(event:KeyboardEvent):Void
	{
		var eventKey:FlxKey = event.keyCode;
		var key:Int = getKeyFromEvent(eventKey);
		if(!cpuControlled && startedCountdown && !paused && key > -1)
		{
			var spr:StrumNote = playerStrums.members[key];
			if(spr != null)
			{
				spr.playAnim('static');
				spr.resetAnim = 0;
			}
			callOnLuas('onKeyRelease', [key]);
		}
		//trace('released: ' + controlArray);
	}

	private function getKeyFromEvent(key:FlxKey):Int
	{
		if(key != NONE)
		{
			for (i in 0...keysArray.length)
			{
				for (j in 0...keysArray[i].length)
				{
					if(key == keysArray[i][j])
					{
						return i;
					}
				}
			}
		}
		return -1;
	}

	// Hold notes
	private function keyShit():Void
	{
		// HOLDING
		var parsedHoldArray:Array<Bool> = parseKeys();

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode)
		{
			var parsedArray:Array<Bool> = parseKeys('_P');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] && strumsBlocked[i] != true)
						onKeyPress(new KeyboardEvent(KeyboardEvent.KEY_DOWN, true, true, -1, keysArray[i][0]));
				}
			}
		}

		// FlxG.watch.addQuick('asdfa', upP);
		if (startedCountdown && !boyfriend.stunned && generatedMusic)
		{
			// rewritten inputs???
			notes.forEachAlive(function(daNote:Note)
			{
				// hold note functions
				if (strumsBlocked[daNote.noteData] != true && daNote.isSustainNote && parsedHoldArray[daNote.noteData] && daNote.canBeHit
				&& daNote.mustPress && !daNote.tooLate && !daNote.wasGoodHit && !daNote.blockHit) {
					goodNoteHit(daNote);
				}
			});

			if (parsedHoldArray.contains(true) && !endingSong) {
				#if ACHIEVEMENTS_ALLOWED
				var achieve:String = checkForAchievement(['oversinging']);
				if (achieve != null) {
					startAchievement(achieve);
				}
				#end
			}
			else if (boyfriend.animation.curAnim != null && boyfriend.holdTimer > Conductor.stepCrochet * 0.0011 * boyfriend.singDuration && boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.animation.curAnim.name.endsWith('miss'))
			{
				boyfriend.dance();
				//boyfriend.animation.curAnim.finish();
			}
		}

		// TO DO: Find a better way to handle controller inputs, this should work for now
		if(ClientPrefs.controllerMode || strumsBlocked.contains(true))
		{
			var parsedArray:Array<Bool> = parseKeys('_R');
			if(parsedArray.contains(true))
			{
				for (i in 0...parsedArray.length)
				{
					if(parsedArray[i] || strumsBlocked[i] == true)
						onKeyRelease(new KeyboardEvent(KeyboardEvent.KEY_UP, true, true, -1, keysArray[i][0]));
				}
			}
		}
	}

	private function parseKeys(?suffix:String = ''):Array<Bool>
	{
		var ret:Array<Bool> = [];
		for (i in 0...controlArray.length)
		{
			ret[i] = Reflect.getProperty(controls, controlArray[i] + suffix);
		}
		return ret;
	}

	/**
	 * Set key controls per mania count
	 * 
	 * 0 = 4k
	 * 
	 * 1 = 6k
	 * 
	 * 2 = 7k
	 * 
	 * 3 = 9k
	 */
	private function setKeys(setCount:Int = 0, showKeybindsOnStrums:Bool = false):Void
	{
		switch (setCount)
		{
			default: //fallback in case we set it to anything other than 0 1 2 or 3
				keysArray = [
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_left')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_down')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_up')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('note_right'))

				];
				controlArray = [
					'NOTE_LEFT',
					'NOTE_DOWN',
					'NOTE_UP',
					'NOTE_RIGHT'
				];
			case 1:
				keysArray = [
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a1')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a2')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a3')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a5')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a6')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a7'))
				];
				controlArray = [
					'A1',
					'A2',
					'A3',
					'A5',
					'A6',
					'A7'
				];
			case 2:
				keysArray = [
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a1')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a2')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a3')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a4')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a5')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a6')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('a7'))
				];
				controlArray = [
					'A1',
					'A2',
					'A3',
					'A4',
					'A5',
					'A6',
					'A7'
				];	
			case 3:
				keysArray = [
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b1')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b2')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b3')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b4')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b5')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b6')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b7')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b8')),
					ClientPrefs.copyKey(ClientPrefs.keyBinds.get('b9'))
				];
				controlArray = [
					'B1',
					'B2',
					'B3',
					'B4',
					'B5',
					'B6',
					'B7',
					'B8',
					'B9'
				];
		}
		if (showKeybindsOnStrums == true)
		{
			new FlxTimer().start(0.1, function(tmr:FlxTimer) 
			{
				for (i in 0...keysArray.length)
				{
					trace(InputFormatter.getKeyName(keysArray[i][0]));
					var keyTxt:FlxText = new FlxText(0, 0, 0, InputFormatter.getKeyName(keysArray[i][0]), 32);
					keyTxt.setFormat(Paths.font("impact.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
					keyTxt.borderSize = 2;
					keyTxt.cameras = [camHUD];
					keyTxt.setPosition(playerStrums.members[i].x + (playerStrums.members[i].width / 2), playerStrums.members[i].getGraphicMidpoint().y + ((ClientPrefs.downScroll ? -0.8 : 0.8) * (playerStrums.members[i].height / 2)));
					add(keyTxt);
					FlxTween.tween(keyTxt, {alpha: 0}, 0.5, {startDelay: 5 + (i * 0.2), onComplete: function(twn:FlxTween){keyTxt.destroy();}});
				}
			});
		}
	}

	var currentlyOiled:Bool = false; 
	var oilTimer:FlxTimer;
	var oilLoop:Int = 0;
	function oilNoteHit(daNote:Note):Void
	{
		if (!currentlyOiled)
		{
			FlxG.sound.play(Paths.soundRandom('badnoise', 1, 3), FlxG.random.float(0.4, 0.5));
			pissStain.alpha = 1;
			pissStain.animation.play('open');
			pissStain.animation.finishCallback = function(open:String)
				pissStain.alpha = 0.00001;

			currentlyOiled = true;
			oilTimer = new FlxTimer().start(0.05, function(tmr:FlxTimer)
			{
				oilLoop++;
				health -= 0.05;
			//	trace(oilLoop);

				if (oilLoop >= 20)
				{
					oilLoop = 0;
					currentlyOiled = false;
				}
			}, 20);
		}
		else
			noteMiss(daNote);
	}

	var noteDisableTimer:FlxTimer;
	var notesDisabled:Bool = false;
	function minetrollerNoteHit(daNote:Note):Void
	{
		notesDisabled = true;
		notes.forEachAlive(function(note:Note)
		{
			if (note.mustPress)
				note.alpha -= 0.5;
		});
		playerStrums.forEachAlive(function(note:StrumNote)
		{
			note.alpha -= 0.5;
		});

		noteDisableTimer = new FlxTimer().start(1, function(tmr:FlxTimer)
		{
			notesDisabled = false;
			notes.forEachAlive(function(note:Note)
			{
				if (note.mustPress)
					note.alpha += 0.5;
			});
			playerStrums.forEachAlive(function(note:StrumNote)
			{
				note.alpha += 0.5;
			});
		});
	}

	var magnetTimer:FlxTimer = new FlxTimer();
	function magnetNoteHit(daNote:Note):Void //tweenstweenstweenstweenstweenstweenstweenstweenstweenstweenstweenstweenstweenstweenstweens
	{
		if (magnetTimer.active)
			return;

		var timCorrectionValue:Int = 50;
		if (curMagnetScroll != Std.int(Math.abs(daNote.noteData)))
		{
			magnetTimer.start(3, function(tmr:FlxTimer)
			{
				if (magnetTimer.loopsLeft == 1)
					tim.animation.play('outro', true);
			}, 2);
			switch (Math.abs(daNote.noteData))
			{
				case 0: //left
					tim.setPosition(0 - timCorrectionValue, 92 - Note.posRest[(SONG.mania)] - timCorrectionValue);
					tim.angle = 90;
				case 1: //down
					tim.setPosition(((92 + (Note.swidths[(SONG.mania)] * Note.swagWidth) + (FlxG.width / 2)) - Note.posRest[(SONG.mania)]) - timCorrectionValue, (FlxG.height - tim.height) + timCorrectionValue);
					tim.angle = 0;
				case 2: //up
					tim.setPosition(((92 + (Note.swidths[(SONG.mania)] * Note.swagWidth * 2) + (FlxG.width / 2)) - Note.posRest[(SONG.mania)]) - timCorrectionValue, 0 - timCorrectionValue);
					tim.angle = 180;
				case 3: //right
					tim.setPosition((FlxG.width - tim.width) + timCorrectionValue, ((92 + (Note.swidths[(SONG.mania)] * Note.swagWidth * 3)) - Note.posRest[(SONG.mania)]) - 40);
					tim.angle = -90;
			}
			tim.alpha = 1;
			tim.animation.play('intro', true);
			tim.animation.finishCallback = function(anim:String)
			{
				switch (anim)
				{
					case 'intro':
						switch (Math.abs(daNote.noteData))
						{
							case 0: //left
								opponentStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {alpha: 0}, 0.8, {ease: FlxEase.quadOut});
								});
								playerStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {
										x: 50, 
										y: (92 + (Note.swidths[(SONG.mania)] * Note.swagWidth * Math.abs(spr.noteData))) - Note.posRest[(SONG.mania)],
										angle: 0,
										direction: 0
									}, 0.8, {ease: FlxEase.elasticOut});
									spr.downScroll = false;
								});
								for (note in unspawnNotes) 
								{
									if (note.mustPress)
									{
										note.offsetAngle = 90;
										if (note.isSustainNote)
											note.angle = 90;
									}
								}
								notes.forEachAlive(function(spr:Note)
								{
									if (spr.mustPress)
									{
										FlxTween.tween(spr, {offsetAngle: 90}, 0.8, {ease: FlxEase.elasticOut});
										if (spr.isSustainNote)
											spr.angle = 90;
											//FlxTween.tween(spr, {angle: 90}, 0.8, {ease: FlxEase.elasticOut});
									}
								});
							case 1: //down
								opponentStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {alpha: ClientPrefs.middleScroll ? 0.35 : 1}, 0.8, {ease: FlxEase.quadOut});
								});
								playerStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {
										x: (92 + (Note.swidths[(SONG.mania)] * Note.swagWidth * Math.abs(spr.noteData)) + (FlxG.width / 2)) - Note.posRest[(SONG.mania)], 
										y: FlxG.height - 150,
										angle: 0,
										direction: 90
									}, 0.8, {ease: FlxEase.elasticOut});
									spr.downScroll = true;
								});
								for (note in unspawnNotes)
								{	
									if (note.mustPress)
									{
										note.offsetAngle = 0;
										if (note.isSustainNote)
											note.angle = 0;
									}
								}
								notes.forEachAlive(function(spr:Note)
								{
									if (spr.mustPress)
									{
										FlxTween.tween(spr, {offsetAngle: 0}, 0.8, {ease: FlxEase.elasticOut});
										if (spr.isSustainNote)
											spr.angle = 0;
											//FlxTween.tween(spr, {angle: 0}, 0.8, {ease: FlxEase.elasticOut});
									}
								});
							case 2: //up
								opponentStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {alpha: ClientPrefs.middleScroll ? 0.35 : 1}, 0.8, {ease: FlxEase.quadOut});
								});
								playerStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {
										x: (92 + (Note.swidths[(SONG.mania)] * Note.swagWidth * Math.abs(spr.noteData)) + (FlxG.width / 2)) - Note.posRest[(SONG.mania)], 
										y: 50,
										angle: 0,
										direction: 90
									}, 0.8, {ease: FlxEase.elasticOut});
									spr.downScroll = false;
								});
								for (note in unspawnNotes) 
								{
									if (note.mustPress)
									{
										note.offsetAngle = 0;
										if (note.isSustainNote)
											note.angle = 0;
									}
								}
								notes.forEachAlive(function(spr:Note)
								{
									if (spr.mustPress)
									{
										FlxTween.tween(spr, {offsetAngle: 0}, 0.8, {ease: FlxEase.elasticOut});
										if (spr.isSustainNote)
											spr.angle = 0;
											FlxTween.tween(spr, {angle: 0}, 0.8, {ease: FlxEase.elasticOut});
									}
								});
							case 3: //right
								opponentStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {alpha: 0}, 0.8, {ease: FlxEase.quadOut});
								});
								playerStrums.forEachAlive(function(spr:StrumNote) {
									FlxTween.tween(spr, {
										x: (FlxG.width - (Note.swidths[(SONG.mania)] * Note.swagWidth)) - 50, 
										y: (92 + (Note.swidths[(SONG.mania)] * Note.swagWidth * Math.abs(spr.noteData))) - Note.posRest[(SONG.mania)],
										angle: 0,
										direction: 0
									}, 0.8, {ease: FlxEase.elasticOut});
									spr.downScroll = true;
								});
								for (note in unspawnNotes) 
								{
									if (note.mustPress)
									{
										note.offsetAngle = 90;
										if (note.isSustainNote)
											note.angle = -90;
									}
								}
								notes.forEachAlive(function(spr:Note)
								{
									if (spr.mustPress)
									{
										FlxTween.tween(spr, {offsetAngle: 90}, 0.8, {ease: FlxEase.elasticOut});
										if (spr.isSustainNote)
											spr.angle = -90;
											//FlxTween.tween(spr, {angle: 90}, 0.8, {ease: FlxEase.elasticOut});
									}
								});
						}
						tim.animation.play('idle', true);
					case 'miss':
						tim.animation.play('idle', true);
					case 'outro':
						tim.alpha = 0.00001;
				}
			}


			curMagnetScroll = Std.int(Math.abs(daNote.noteData));
		}
	}

	function noteMiss(daNote:Note):Void { //You didn't hit the key and let it go offscreen, also used by Hurt Notes

		//Dupe note remove

		notes.forEachAlive(function(note:Note) {
			if (daNote != note && daNote.mustPress && daNote.noteData == note.noteData && daNote.isSustainNote == note.isSustainNote && Math.abs(daNote.strumTime - note.strumTime) < 1) {
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		});
		combo = 0;
		health -= daNote.missHealth * healthLoss;
		
		if(instakillOnMiss)
		{
			vocals.volume = 0;
			doDeathCheck(true);
		}

		//For testing purposes
		//trace(daNote.missHealth);
		songMisses++;
		vocals.volume = 0;
		if(!practiceMode) songScore -= 10;

		totalPlayed++;
		RecalculateRating(true);

		var char:Character = boyfriend;
		if(daNote.gfNote) {
			char = gf;
		}

		if(char != null && !daNote.noMissAnimation && char.hasMissAnimations)
		{
			var animToPlay:String = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(daNote.noteData))]] + 'miss';
			char.playAnim(animToPlay, true);
		}

		if (tim != null && tim.animation.curAnim.name == 'idle')
			tim.animation.play('miss', true);

		callOnLuas('noteMiss', [notes.members.indexOf(daNote), daNote.noteData, daNote.noteType, daNote.isSustainNote]);
	}

	function noteMissPress(direction:Int = 1):Void //You pressed a key when there was no notes to press for this key
	{
		if(ClientPrefs.ghostTapping) return; //fuck it

		if (!boyfriend.stunned)
		{
			health -= 0.05 * healthLoss;
			if(instakillOnMiss)
			{
				vocals.volume = 0;
				doDeathCheck(true);
			}

			if (combo > 5 && gf != null && gf.animOffsets.exists('sad'))
			{
				gf.playAnim('sad');
			}
			combo = 0;

			if(!practiceMode) songScore -= 10;
			if(!endingSong) {
				songMisses++;
			}
			totalPlayed++;
			RecalculateRating(true);

			FlxG.sound.play(Paths.soundRandom('missnote', 1, 3), FlxG.random.float(0.1, 0.2));
			// FlxG.sound.play(Paths.sound('missnote1'), 1, false);
			// FlxG.log.add('played imss note');

			/*boyfriend.stunned = true;

			// get stunned for 1/60 of a second, makes you able to
			new FlxTimer().start(1 / 60, function(tmr:FlxTimer)
			{
				boyfriend.stunned = false;
			});*/

			if(boyfriend.hasMissAnimations) {
				boyfriend.playAnim(singAnimations[Std.int(Math.abs(direction))] + 'miss', true);
			}
			vocals.volume = 0;
		}
		callOnLuas('noteMissPress', [direction]);
	}

	function opponentNoteHit(note:Note):Void
	{
		if (opponentHealthDrain && health >= opponentHealthDrainAmount && !note.gfNote && note.noteType != 'GF Sing')
			health -= opponentHealthDrainAmount;

		if (singingShakeArray[1])
		{
			camGame.shake(0.005, 0.2);
			camHUD.shake(0.005, 0.2);
		}
		
		camZooming = true;

		if(note.noteType == 'Hey!' && dad.animOffsets.exists('hey')) {
			dad.playAnim('hey', true);
			dad.specialAnim = true;
			dad.heyTimer = 0.6;
		} else if(!note.noAnimation) {
			var altAnim:String = note.animSuffix;

			if (SONG.notes[curSection] != null)
			{
				if (SONG.notes[curSection].altAnim && !SONG.notes[curSection].gfSection) {
					altAnim = '-alt';
				}
			}

			var char:Character = dad;
			var animToPlay:String = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(note.noteData))]];
			if(note.gfNote) {
				char = gf;
			}

			if(char != null)
			{
				char.holdTimer = 0;

				if (dad.mostRecentHitNote != null && dad.mostRecentHitNote.strumTime == note.strumTime && char != gf)
				{
					if (dad.mostRecentHitNote.sustainLength > note.sustainLength)
					{
						note.noAnimation = true;
						if (!note.isSustainNote)
							doGhostAnim('dad', animToPlay, note.sustainLength);
					}
					else
					{
						char.playAnim(animToPlay, true);
						animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(char.mostRecentHitNote.noteData))]];
						char.mostRecentHitNote.noAnimation = true;
						if (!dad.mostRecentHitNote.isSustainNote)
							doGhostAnim('dad', animToPlay, dad.mostRecentHitNote.sustainLength);
					}
				}
				else if (gf != null && gf.mostRecentHitNote != null && gf.mostRecentHitNote.strumTime == note.strumTime && char == gf)
				{
					if (gf.mostRecentHitNote.sustainLength > note.sustainLength)
					{
						note.noAnimation = true;
						if (!note.isSustainNote)
							doGhostAnim('gf', animToPlay, note.sustainLength);
					}
					else
					{
						char.playAnim(animToPlay, true);
						animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(char.mostRecentHitNote.noteData))]];
						char.mostRecentHitNote.noAnimation = true;
						if (!gf.mostRecentHitNote.isSustainNote)
							doGhostAnim('gf', animToPlay, gf.mostRecentHitNote.sustainLength);
					}
				}
				else
					char.playAnim(animToPlay, true);
				
				if (!note.isSustainNote)
					if (char == gf)
						gf.mostRecentHitNote = note;
					else
						dad.mostRecentHitNote = note;					
			}
		}

		if (SONG.needsVoices && vocals != null)
			vocals.volume = 1;

		var time:Float = 0.15;
		if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
			time += 0.15;
		}
		StrumPlayAnim(true, Std.int(Math.abs(note.noteData)) % Main.ammo[mania], time);
		note.hitByOpponent = true;

		callOnLuas('opponentNoteHit', [notes.members.indexOf(note), Math.abs(note.noteData), note.noteType, note.isSustainNote]);

		if (!note.isSustainNote)
		{
			note.kill();
			notes.remove(note, true);
			note.destroy();
		}
	}

	function goodNoteHit(note:Note):Void
	{
		if (!note.wasGoodHit)
		{
			if(cpuControlled && (note.ignoreNote || note.hitCausesMiss)) return;

			if (ClientPrefs.hitsoundVolume > 0 && !note.hitsoundDisabled)
			{
				FlxG.sound.play(Paths.sound('hitsound'), ClientPrefs.hitsoundVolume);
			}

			if(note.hitCausesMiss)
			{
				switch (note.noteType)
				{
					case 'Bob':
						minetrollerNoteHit(note);
					case 'Oil':
						oilNoteHit(note);
						noteMiss(note);
					case 'Magnet':
						magnetNoteHit(note);
						noteMiss(note);
					default:
						noteMiss(note);
				}					

				if(!note.noteSplashDisabled && !note.isSustainNote)
					spawnNoteSplashOnNote(note);

				if(!note.noMissAnimation)
				{
					switch(note.noteType) {
						case 'Hurt Note': //Hurt note
							if(boyfriend.animation.getByName('hurt') != null) {
								boyfriend.playAnim('hurt', true);
								boyfriend.specialAnim = true;
							}
					}
				}

				note.wasGoodHit = true;
				if (!note.isSustainNote)
				{
					note.kill();
					notes.remove(note, true);
					note.destroy();
				}
				return;
			}

			if (!note.isSustainNote)
			{
				combo += 1;
				if(combo > 9999) combo = 9999;
				popUpScore(note);
			}
			health += note.hitHealth * healthGain;

			if (singingShakeArray[0])
			{
				camGame.shake(0.005, 0.2);
				camHUD.shake(0.005, 0.2);
			}

			if(!note.noAnimation) {
				var animToPlay:String = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(note.noteData))]];

				if(note.gfNote)
				{
					if(gf != null)
					{
						gf.holdTimer = 0;

						if (gf.mostRecentHitNote != null && gf.mostRecentHitNote.strumTime == note.strumTime)
						{
							if (gf.mostRecentHitNote.sustainLength > note.sustainLength)
							{
								note.noAnimation = true;
								if (!note.isSustainNote)
									doGhostAnim('gf', animToPlay + note.animSuffix, note.sustainLength);
							}
							else
							{
								gf.playAnim(animToPlay + note.animSuffix, true);
								animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(gf.mostRecentHitNote.noteData))]];
								gf.mostRecentHitNote.noAnimation = true;
								if (!gf.mostRecentHitNote.isSustainNote)
									doGhostAnim('gf', animToPlay + gf.mostRecentHitNote.animSuffix, gf.mostRecentHitNote.sustainLength);
							}
						}
						else
							gf.playAnim(animToPlay + note.animSuffix, true);
					}
				}
				else
				{
					boyfriend.holdTimer = 0;

					if (boyfriend.mostRecentHitNote != null && boyfriend.mostRecentHitNote.strumTime == note.strumTime)
					{
						if (boyfriend.mostRecentHitNote.sustainLength > note.sustainLength)
						{
							note.noAnimation = true;
							if (!note.isSustainNote)
								doGhostAnim('bf', animToPlay + note.animSuffix, note.sustainLength);
						}
						else
						{
							boyfriend.playAnim(animToPlay + note.animSuffix, true);
							animToPlay = 'sing' + Main.charDir[Main.gfxHud[mania][Std.int(Math.abs(boyfriend.mostRecentHitNote.noteData))]];
							boyfriend.mostRecentHitNote.noAnimation = true;
							if (!boyfriend.mostRecentHitNote.isSustainNote)
								doGhostAnim('bf', animToPlay + boyfriend.mostRecentHitNote.animSuffix, boyfriend.mostRecentHitNote.sustainLength);
						}
					}
					else
						boyfriend.playAnim(animToPlay + note.animSuffix, true);
				}

				if (!note.isSustainNote)
					boyfriend.mostRecentHitNote = note;

				if(note.noteType == 'Hey!') {
					if(boyfriend.animOffsets.exists('hey')) {
						boyfriend.playAnim('hey', true);
						boyfriend.specialAnim = true;
						boyfriend.heyTimer = 0.6;
					}

					if(gf != null && gf.animOffsets.exists('cheer')) {
						gf.playAnim('cheer', true);
						gf.specialAnim = true;
						gf.heyTimer = 0.6;
					}
				}
			}

			if(cpuControlled) {
				var time:Float = 0.15;
				if(note.isSustainNote && !note.animation.curAnim.name.endsWith('end')) {
					time += 0.15;
				}
				StrumPlayAnim(false, Std.int(Math.abs(note.noteData)), time);
			} else {
				var spr = playerStrums.members[note.noteData];
				if(spr != null)
				{
					spr.playAnim('confirm', true);
				}
			}
			note.wasGoodHit = true;
			if (SONG.needsVoices && vocals != null)
				vocals.volume = 1;

			var isSus:Bool = note.isSustainNote; //GET OUT OF MY HEAD, GET OUT OF MY HEAD, GET OUT OF MY HEAD
			var leData:Int = Math.round(Math.abs(note.noteData));
			var leType:String = note.noteType;
			callOnLuas('goodNoteHit', [notes.members.indexOf(note), leData, leType, isSus]);

			if (!note.isSustainNote)
			{
				note.kill();
				notes.remove(note, true);
				note.destroy();
			}
		}
	}

	public function spawnNoteSplashOnNote(note:Note) {
		if(ClientPrefs.noteSplashes && note != null && mania == 0) { //no splashes for songs with mania > 0 im too lazy idgaf
			var strum:StrumNote = playerStrums.members[note.noteData];
			if(strum != null) {
				spawnNoteSplash(strum.x, strum.y, note.noteData, note);
			}
		}
	}

	public function spawnNoteSplash(x:Float, y:Float, data:Int, ?note:Note = null) {
		var skin:String = 'noteSplashes';
		if(PlayState.SONG.splashSkin != null && PlayState.SONG.splashSkin.length > 0) skin = PlayState.SONG.splashSkin;

		var hue:Float = 0;
		var sat:Float = 0;
		var brt:Float = 0;
		if (data > -1 && data < ClientPrefs.arrowHSV.length)
		{
			hue = ClientPrefs.arrowHSV[data][0] / 360;
			sat = ClientPrefs.arrowHSV[data][1] / 100;
			brt = ClientPrefs.arrowHSV[data][2] / 100;
			if(note != null) {
				skin = note.noteSplashTexture;
				hue = note.noteSplashHue;
				sat = note.noteSplashSat;
				brt = note.noteSplashBrt;
			}
		}

		var splash:NoteSplash = grpNoteSplashes.recycle(NoteSplash);
		splash.setupNoteSplash(x, y, data, skin, hue, sat, brt);
		grpNoteSplashes.add(splash);
	}

	override function destroy() {
		for (lua in luaArray) {
			lua.call('onDestroy', []);
			lua.stop();
		}
		luaArray = [];

		#if hscript
		if(FunkinLua.hscript != null) FunkinLua.hscript = null;
		#end

		if(!ClientPrefs.controllerMode)
		{
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPress);
			FlxG.stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyRelease);
		}

		if (FlxG.camera.bgColor != FlxColor.BLACK)
			FlxG.camera.bgColor = FlxColor.BLACK;

		// song shitted all over the place gotta clean it up a bit !!!
		if (SONG.song.toLowerCase() == 'idiot')
		{
			Application.current.window.resizable = true;
			//Application.current.window.title = Application.current.meta.get('title'); poo
			Application.current.window.title = "Funkin' Physics v2.0.0";
			Main.fpsVar.visible = ClientPrefs.showFPS;
		}
		super.destroy();
	}

	public static function cancelMusicFadeTween() {
		if(FlxG.sound.music.fadeTween != null) {
			FlxG.sound.music.fadeTween.cancel();
		}
		FlxG.sound.music.fadeTween = null;
	}

	var lastStepHit:Int = -1;
	override function stepHit()
	{
		super.stepHit();
		if (Math.abs(FlxG.sound.music.time - (Conductor.songPosition - Conductor.offset)) > 20
			|| (SONG.needsVoices && Math.abs(vocals.time - (Conductor.songPosition - Conductor.offset)) > 20))
		{
			resyncVocals();
		}

		if(curStep == lastStepHit) {
			return;
		}

		lastStepHit = curStep;
		setOnLuas('curStep', curStep);
		callOnLuas('onStepHit', []);
	}

	var lastBeatHit:Int = -1;
	override function beatHit()
	{
		super.beatHit();

		if(lastBeatHit >= curBeat) {
			//trace('BEAT HIT: ' + curBeat + ', LAST HIT: ' + lastBeatHit);
			return;
		}

		if (generatedMusic)
		{
			notes.sort(FlxSort.byY, ClientPrefs.downScroll ? FlxSort.ASCENDING : FlxSort.DESCENDING);
		}

		iconP1.scale.set(1.2, 1.2);
		iconP2.scale.set(1.2, 1.2);

		iconP1.updateHitbox();
		iconP2.updateHitbox();

		if (gf != null && curBeat % Math.round(gfSpeed * gf.danceEveryNumBeats) == 0 && gf.animation.curAnim != null && !gf.animation.curAnim.name.startsWith("sing") && !gf.stunned)
		{
			gf.dance();
		}
		if (curBeat % boyfriend.danceEveryNumBeats == 0 && boyfriend.animation.curAnim != null && !boyfriend.animation.curAnim.name.startsWith('sing') && !boyfriend.stunned)
		{
			boyfriend.dance();
		}
		if (curBeat % dad.danceEveryNumBeats == 0 && dad.animation.curAnim != null && !dad.animation.curAnim.name.startsWith('sing') && !dad.stunned)
		{
			dad.dance();
		}

		switch (curStage)
		{
			case 'graveyard':
				if (curBeat % 2 == 0)
				{
					trollSkele.dance(true);
					mcSkele.dance(true);
					frontSkele1.dance(true);
					frontSkele2.dance(true);
					overlay.dance(true);
				}
			case 'idiot':
				if (curBeat % 2 == 0)
				{
					idiotSun.dance(true);
					idiotStalkers.forEach(function(spr:BGSprite)
					{
						spr.dance(true);
					});
				}
				catDanec = !catDanec;
				idiotCats.forEach(function(spr:BGSprite)
				{
					if (catDanec)
						spr.animation.play('danceLeft', true);
					else
						spr.animation.play('danceRight', true);
				});
			case 'mlg-studio':
				if (curBeat % 2 == 0)
				{
					grooby.dance(true);
					bfWatching.dance(false);
				}
			case 'tgt':
				if (curBeat % 2 == 0)
				{
					sonic.dance(true);
					shadow.dance(true);
					knuckles.dance(true);
				}
			case 'awesome':
				awesomeBoppers.forEach(function(spr:BGSprite)
				{
					spr.dance(true);
				});
				awesomeBG2.visible = !awesomeBG2.visible;
			case 'bikini-bottom-new':
				if (curBeat % 2 == 0)
					malleo.dance(true);
		}
		lastBeatHit = curBeat;

		setOnLuas('curBeat', curBeat); //DAWGG?????
		callOnLuas('onBeatHit', []);
	}

	override function sectionHit()
	{
		super.sectionHit();

		if (SONG.notes[curSection] != null)
		{
			if (generatedMusic && !endingSong && !isCameraOnForcedPos)
			{
				moveCameraSection();
			}

			if (camZooming && /*FlxG.camera.zoom < 1.35 &&*/ ClientPrefs.camZooms)
			{
				FlxG.camera.zoom += 0.015 * camZoomingMult;
				camHUD.zoom += 0.03 * camZoomingMult;
			}

			if (SONG.notes[curSection].changeBPM)
			{
				Conductor.changeBPM(SONG.notes[curSection].bpm);
				setOnLuas('curBpm', Conductor.bpm);
				setOnLuas('crochet', Conductor.crochet);
				setOnLuas('stepCrochet', Conductor.stepCrochet);
			}
			setOnLuas('mustHitSection', SONG.notes[curSection].mustHitSection);
			setOnLuas('altAnim', SONG.notes[curSection].altAnim);
			setOnLuas('gfSection', SONG.notes[curSection].gfSection);
		}
		
		setOnLuas('curSection', curSection);
		callOnLuas('onSectionHit', []);
	}

	public function callOnLuas(event:String, args:Array<Dynamic>, ignoreStops = true, exclusions:Array<String> = null):Dynamic {
		var returnVal:Dynamic = FunkinLua.Function_Continue;
		#if LUA_ALLOWED
		if(exclusions == null) exclusions = [];
		for (script in luaArray) {
			if(exclusions.contains(script.scriptName))
				continue;

			var ret:Dynamic = script.call(event, args);
			if(ret == FunkinLua.Function_StopLua && !ignoreStops)
				break;
			
			// had to do this because there is a bug in haxe where Stop != Continue doesnt work
			var bool:Bool = ret == FunkinLua.Function_Continue;
			if(!bool) {
				returnVal = cast ret;
			}
		}
		#end
		//trace(event, returnVal);
		return returnVal;
	}

	public function setOnLuas(variable:String, arg:Dynamic) {
		#if LUA_ALLOWED
		for (i in 0...luaArray.length) {
			luaArray[i].set(variable, arg);
		}
		#end
	}

	function StrumPlayAnim(isDad:Bool, id:Int, time:Float) {
		var spr:StrumNote = null;
		if(isDad) {
			spr = strumLineNotes.members[id];
		} else {
			spr = playerStrums.members[id];
		}

		if(spr != null) {
			spr.playAnim('confirm', true);
			spr.resetAnim = time;
		}
	}

	public var ratingName:String = '?';
	public var ratingPercent:Float;
	public var ratingFC:String;
	public function RecalculateRating(badHit:Bool = false) {
		setOnLuas('score', songScore);
		setOnLuas('misses', songMisses);
		setOnLuas('hits', songHits);

		var ret:Dynamic = callOnLuas('onRecalculateRating', [], false);
		if(ret != FunkinLua.Function_Stop)
		{
			if(totalPlayed < 1) //Prevent divide by 0
				ratingName = '?';
			else
			{
				// Rating Percent
				ratingPercent = Math.min(1, Math.max(0, totalNotesHit / totalPlayed));
				//trace((totalNotesHit / totalPlayed) + ', Total: ' + totalPlayed + ', notes hit: ' + totalNotesHit);

				// Rating Name
				if(ratingPercent >= 1)
				{
					ratingName = ratingStuff[ratingStuff.length-1][0]; //Uses last string
				}
				else
				{
					for (i in 0...ratingStuff.length-1)
					{
						if(ratingPercent < ratingStuff[i][1])
						{
							ratingName = ratingStuff[i][0];
							break;
						}
					}
				}
			}

			// Rating FC
			ratingFC = "";
			if (sicks > 0) ratingFC = "SFC";
			if (goods > 0) ratingFC = "GFC";
			if (bads > 0 || shits > 0) ratingFC = "FC";
			if (songMisses > 0 && songMisses < 10) ratingFC = "SDCB";
			else if (songMisses >= 10) ratingFC = "Clear";
		}
		updateScore(badHit); // score will only update after rating is calculated, if it's a badHit, it shouldn't bounce -Ghost
		setOnLuas('rating', ratingPercent);
		setOnLuas('ratingName', ratingName);
		setOnLuas('ratingFC', ratingFC);
	}

	#if ACHIEVEMENTS_ALLOWED
	private function checkForAchievement(achievesToCheck:Array<String> = null):String
	{
		if(chartingMode) return null;

		var usedPractice:Bool = (ClientPrefs.getGameplaySetting('practice', false) || ClientPrefs.getGameplaySetting('botplay', false));
		for (i in 0...achievesToCheck.length) {
			var achievementName:String = achievesToCheck[i];
			if(!Achievements.isAchievementUnlocked(achievementName) && !cpuControlled) {
				var unlock:Bool = false;
				switch(achievementName)
				{
					case 'week1_nomiss' | 'week2_nomiss' | 'week3_nomiss' | 'week4_nomiss' | 'week5_nomiss' | 'week6_nomiss' | 'week7_nomiss':
						if(isStoryMode && campaignMisses + songMisses < 1 && CoolUtil.difficultyString() == 'HARD' && storyPlaylist.length <= 1 && !changedDifficulty && !usedPractice)
						{
							var weekName:String = WeekData.getWeekFileName();
							switch(weekName) //I know this is a lot of duplicated code, but it's easier readable and you can add weeks with different names than the achievement tag
							{
								case 'week1':
									if(achievementName == 'week1_nomiss') unlock = true;
								case 'week2':
									if(achievementName == 'week2_nomiss') unlock = true;
								case 'week3':
									if(achievementName == 'week3_nomiss') unlock = true;
								case 'week4':
									if(achievementName == 'week4_nomiss') unlock = true;
								case 'week5':
									if(achievementName == 'week5_nomiss') unlock = true;
								case 'week6':
									if(achievementName == 'week6_nomiss') unlock = true;
								case 'week7':
									if(achievementName == 'week7_nomiss') unlock = true;
							}
						}
					case 'ur_bad':
						if(ratingPercent < 0.2 && !practiceMode) {
							unlock = true;
						}
					case 'ur_good':
						if(ratingPercent >= 1 && !usedPractice) {
							unlock = true;
						}
					case 'roadkill_enthusiast':
						if(Achievements.henchmenDeath >= 100) {
							unlock = true;
						}
					case 'oversinging':
						if(boyfriend.holdTimer >= 10 && !usedPractice) {
							unlock = true;
						}
					case 'hype':
						if(!boyfriendIdled && !usedPractice) {
							unlock = true;
						}
					case 'two_keys':
						if(!usedPractice) {
							var howManyPresses:Int = 0;
							for (j in 0...keysPressed.length) {
								if(keysPressed[j]) howManyPresses++;
							}

							if(howManyPresses <= 2) {
								unlock = true;
							}
						}
					case 'toastie':
						if(/*ClientPrefs.framerate <= 60 &&*/ ClientPrefs.lowQuality && !ClientPrefs.globalAntialiasing) {
							unlock = true;
						}
					case 'debugger':
						if(Paths.formatToSongPath(SONG.song) == 'test' && !usedPractice) {
							unlock = true;
						}
				}

				if(unlock) {
					Achievements.unlockAchievement(achievementName);
					return achievementName;
				}
			}
		}
		return null;
	}
	#end

	var curLight:Int = -1;
	var curLightEvent:Int = -1;

	/**Literally ADD chroma, will add on more chromatic abberation on each use.**/ 
	function addChroma(value:Float = 0.002, hud:Bool = false)
	{
		if (hud)
		{
			ShadersHandler.setChrome2(value);
			shadersHUD.push(ShadersHandler.chromaticAberration2);
			camHUD.setFilters(shadersHUD);
		}
		else
		{
			ShadersHandler.setChrome(value);
			shadersGame.push(ShadersHandler.chromaticAberration);
			camGame.setFilters(shadersGame);
		}
	}

	function chromaBump(peakValue:Float = 0.01, endValue:Float = 0, decayTime:Float = 1, hud:Bool = false)
	{
		if (hud)
		{
			if (!shadersHUD.contains(ShadersHandler.chromaticAberration2))
			{
				shadersHUD.push(ShadersHandler.chromaticAberration2);
				camHUD.setFilters(shadersHUD);
			}
		}
		else
		{
			if (!shadersGame.contains(ShadersHandler.chromaticAberration))
			{
				shadersGame.push(ShadersHandler.chromaticAberration);
				camGame.setFilters(shadersGame);
			}
		}

		//this took me a while to figure out but works so noice :)
		FlxTween.num(peakValue, endValue, decayTime, {ease: FlxEase.quadInOut}, (hud ? ShadersHandler.setChrome2 : ShadersHandler.setChrome));
	}

	var stupidGotten = false;
	var stupidImages:Array<String> = [];
	function getStupid()
	{
		var funnyImageDirectory:String = Paths.getPreloadPath('the-vault/images/');
		if(FileSystem.exists(funnyImageDirectory)) 
		{
			for (file in FileSystem.readDirectory(funnyImageDirectory)) 
			{
				var path = haxe.io.Path.join([funnyImageDirectory, file]);
				if (!FileSystem.isDirectory(path) && file.endsWith('.png')) 
				{
					var check:String = file.substr(0, file.length - 4);
					stupidImages.push(check);
				}
			}
		}
		stupidGotten = true;
		trace (stupidImages);
	}

	// funniest shit ive ever seen
	function createStupid()
	{
		if (!stupidGotten)
			getStupid();

		var randomStupid:String = stupidImages[FlxG.random.int(0, stupidImages.length)];
		var stupid:FlxSprite = new FlxSprite().loadGraphic(Paths.image(randomStupid, 'the-vault'));
		stupid.setPosition(FlxG.random.int(-690, (2060 - Std.int(stupid.width))), FlxG.random.int(-390, (1100 - Std.int(stupid.height))));
		stupid.antialiasing = ClientPrefs.globalAntialiasing;
		stupid.scrollFactor.set(0, 0);

		//sometimes we add it in front of characters because its funny
		switch (FlxG.random.int(0, 10))
		{
			case 0:
				add(stupid);
			case 1:
				addBehindDad(stupid);
			case 2:
				addBehindBF(stupid);
			default:
				addBehindGF(stupid);
		}

		trace ('created stupid image named $randomStupid');
	}

	function initiateYTP()
	{
		#if VIDEOS_ALLOWED

		var filepath:String = Paths.video('mama_luigi_for_you_mario');
		#if sys
		if(!FileSystem.exists(filepath))
		#else
		if(!OpenFlAssets.exists(filepath))
		#end
		{
			FlxG.log.warn('Couldnt find the YTP :(');
			return;
		}

		var video:VideoSpriteVolFix = new VideoSpriteVolFix();
		video.playVideo(filepath);
		add(video);
		video.finishCallback = function()
		{
			return;
		}
		
		#else
		FlxG.log.warn('Platform not supported!');
		return;
		#end
	}

	var vignette:FlxSprite;
	/**Creates and adds a black vignette to camOther with a chosen starting alpha**/
	function addVignetteToStage(?startingAlpha:Float = 1)
	{
		vignette = new FlxSprite(0, 0, Paths.image('backgrounds/vignette'));
		vignette.antialiasing = ClientPrefs.globalAntialiasing;
		vignette.cameras = [camOther];
		vignette.alpha = startingAlpha;
		add(vignette);
	}

	function idiotBluescreen()
	{
		canPause = false;
		Main.fpsVar.visible = false;
		
		var bsod:FlxSprite = new FlxSprite(0, 0, Paths.image('backgrounds/idiot/bsodNoSmile'));
		bsod.antialiasing = ClientPrefs.globalAntialiasing;
		bsod.setGraphicSize(FlxG.width, FlxG.height);
		bsod.screenCenter();
		bsod.cameras = [camOther];
		add(bsod);
		
		var bsodFace:FlxSprite = new FlxSprite();
		bsodFace.frames = Paths.getSparrowAtlas('backgrounds/idiot/YAAIBlueScreen');
		bsodFace.antialiasing = ClientPrefs.globalAntialiasing;
		bsodFace.setGraphicSize(Std.int(bsodFace.width / 1.5));
		bsodFace.updateHitbox();
		bsodFace.setPosition(135, 123);
		bsodFace.setPosition(0, 0);
		bsodFace.cameras = [camOther];
		bsodFace.animation.addByIndices('idle', 'BlueScreenFace', [0], '', 24, true);
		bsodFace.animation.addByPrefix('flip', "BlueScreenFace", 24, true);
		bsodFace.animation.play('idle');
		add(bsodFace);
		new FlxTimer().start(0.56, function(tmr:FlxTimer)
		{
			bsodFace.animation.play('flip', true);
		});
	}

	var spacebarButton:BGSprite;
	var spaceMashImage:BGSprite;
	
	/**Sets up some needed things for Obey and Absurde's space bar mashing mechanic,
	 * 
	 * You'll have to do other things like make the space bar visible and set the properties (i did it in LUA for simplicity) for when things work and how this is just the setup
	**/
	function setUpSpacebarMashMechanic(coverImageName:String = '', ?spinning:Bool = false)
	{
		spacebarButton = new BGSprite('space', 0, 0, 1, 1, ['space'], true);
		spacebarButton.screenCenter();
		spacebarButton.cameras = [camHUD];
		spacebarButton.alpha = 0.00001;
		add(spacebarButton);

		spaceMashImage = new BGSprite(coverImageName, 0, 0, 1, 1);
		spaceMashImage.setGraphicSize(Std.int(spaceMashImage.width * 1.5));
		spaceMashImage.updateHitbox();
		spaceMashImage.screenCenter();
		spaceMashImage.cameras = [camOther];
		spaceMashImage.alpha = 0.00001;
		if (spinning)
		{
			spaceMashImage.active = true;
			spaceMashImage.angularVelocity = 150;
		}
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{add(spaceMashImage);});
	}

	function doSpecialNoteDisclaimer(type:String = '', length:Float = 2)
	{
		var disclaimer:FlxSprite = new FlxSprite(FlxG.width).loadGraphic(Paths.image('notes/noteDisclaimer_$type', 'shared'));
		disclaimer.antialiasing = ClientPrefs.globalAntialiasing;
		disclaimer.cameras = [camOther];
		disclaimer.screenCenter(Y);
		add(disclaimer);
		FlxTween.tween(disclaimer, {x: FlxG.width - (disclaimer.width)}, Conductor.crochet / 500);
		new FlxTimer().start(length, function(tmr:FlxTimer)
		{
			FlxTween.tween(disclaimer, {x: FlxG.width}, 0.25, {onComplete: function(twn:FlxTween)
			{
				disclaimer.destroy();
			}});
		});
	}
}