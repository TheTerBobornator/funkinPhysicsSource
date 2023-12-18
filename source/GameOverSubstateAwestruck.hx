package;

import flixel.system.FlxSound;
import flixel.FlxCamera;
import flixel.effects.FlxFlicker;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSubState;
import flixel.math.FlxMath;
import flixel.math.FlxPoint;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;

class GameOverSubstateAwestruck extends MusicBeatSubstate
{
	var canEnd:Bool = false;
	var stupid:FlxCamera = new FlxCamera();
	var camFollow:FlxPoint;
	var camFollowPos:FlxObject;
	var updateCamera:Bool = false;

	var wtfMadnessCombat:VideoSpriteVolFix;
	var deadBF:FlxSprite;
	var buttonRetry:FlxSprite;
	var buttonLeave:FlxSprite;
	var retrySelected:Bool = false;

	public static var instance:GameOverSubstateAwestruck;

	override function create()
	{
		instance = this;
		PlayState.instance.callOnLuas('onGameOverStart', []);

		super.create();
	}

	public function new()
	{
		super();

		PlayState.instance.setOnLuas('inGameOver', true);

		Conductor.songPosition = 0;

		FlxG.camera.bgColor = FlxColor.BLACK;
		FlxG.camera.zoom = 1;
		stupid.bgColor.alpha = 0;
		FlxG.cameras.add(stupid, false);
		stupid.scroll.set();
		stupid.target = null;

		wtfMadnessCombat = new VideoSpriteVolFix(160);
		new FlxTimer().start(2, function(tmr:FlxTimer)
		{
			wtfMadnessCombat.playVideo(Paths.video('${PlayState.SONG.song.toLowerCase()}GameOver'));
		});
		wtfMadnessCombat.cameras = [stupid];
		//wtfMadnessCombat.setGraphicSize(Std.int(wtfMadnessCombat.width * 1.5)); //why does this just not work
		//wtfMadnessCombat.updateHitbox();
		wtfMadnessCombat.finishCallback = function()
		{
			endVidBullshit();
		}
		add(wtfMadnessCombat);

		deadBF = new FlxSprite(555, 403);
		deadBF.frames = Paths.getSparrowAtlas('gameOver/awestruckGAMEOVERbf_assets');
		deadBF.animation.addByPrefix('confirm', "bf_confirm", 24, false);
		deadBF.animation.addByPrefix('loop', "bf_loop", 24, true);
		deadBF.animation.play('loop', true);
		deadBF.antialiasing = ClientPrefs.globalAntialiasing;
		deadBF.alpha = 0.00001;
		deadBF.cameras = [stupid];
		deadBF.setGraphicSize(Std.int(deadBF.width * 1.5));
		deadBF.updateHitbox();
		deadBF.offset.set();
		//deadBF.offset.set();
		//deadBF.screenCenter();
		add(deadBF);

		buttonRetry = new FlxSprite();
		buttonRetry.frames = Paths.getSparrowAtlas('gameOver/awestruckGAMEOVERretryBTN_assets');
		buttonRetry.animation.addByPrefix('appear', "retrybtn_appear", 24, false);
		buttonRetry.animation.addByPrefix('loop', "retrybtn_loop", 24, true);
		buttonRetry.animation.addByPrefix('hover', "retrybtn_hover", 24, true);
		buttonRetry.animation.addByPrefix('press', "retrybtn_press", 24, false);
		buttonRetry.animation.play('loop', true); 
		buttonRetry.antialiasing = ClientPrefs.globalAntialiasing;
		buttonRetry.alpha = 0.00001;
		buttonRetry.cameras = [stupid];
		buttonRetry.setGraphicSize(Std.int(buttonRetry.width * 1.5));
		buttonRetry.updateHitbox();
		buttonRetry.offset.set();
		//buttonRetry.offset.set();
		//buttonRetry.screenCenter(Y);
		//buttonRetry.x = 50;
		buttonRetry.setPosition((deadBF.x - buttonRetry.width - 300) + 160, deadBF.y + 20);
		add(buttonRetry);

		buttonLeave = new FlxSprite();
		buttonLeave.frames = Paths.getSparrowAtlas('gameOver/awestruckGAMEOVERleaveBTN_assets');
		buttonLeave.animation.addByPrefix('appear', "leavebtn_appear", 24, false);
		buttonLeave.animation.addByPrefix('loop', "leavebtn_loop", 24, true);
		buttonLeave.animation.addByPrefix('hover', "leavebtn_hover", 24, true);
		buttonLeave.animation.addByPrefix('press', "leavebtn_press", 24, false);
		buttonLeave.animation.play('loop', true); 
		buttonLeave.antialiasing = ClientPrefs.globalAntialiasing;
		buttonLeave.alpha = 0.00001;
		buttonLeave.cameras = [stupid];
		buttonLeave.setGraphicSize(Std.int(buttonLeave.width * 1.5));
		buttonLeave.updateHitbox();
		buttonLeave.offset.set();
		//buttonLeave.offset.set();
		//buttonLeave.screenCenter(Y);
		//buttonLeave.x = FlxG.width - buttonLeave.width; //- 50;
		buttonLeave.setPosition((deadBF.x + deadBF.width + 300) + 160, deadBF.y + 20);
		add(buttonLeave);

		camFollow = new FlxPoint(deadBF.getGraphicMidpoint().x, deadBF.getGraphicMidpoint().y);
		camFollowPos = new FlxObject(0, 0, 1, 1);
		camFollowPos.setPosition(stupid.scroll.x + (stupid.width / 2), stupid.scroll.y + (stupid.height / 2));
		add(camFollowPos);

		//if (PlayState.deathCounter > 1)
			//canEnd = true;
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);

		PlayState.instance.callOnLuas('onUpdate', [elapsed]);
		if(updateCamera) {
			var lerpVal:Float = CoolUtil.boundTo(elapsed * 0.6, 0, 0.5);
			camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));
		}

		if (canEnd && !isEnding)
		{
			if (controls.ACCEPT)
			{
				if (retrySelected)
					endBullshit();
				else
					menuReturn();
			}
			if (controls.UI_LEFT_P || controls.UI_RIGHT_P)
				changeSelection();
		}
		PlayState.instance.callOnLuas('onUpdatePost', [elapsed]);
	}

	override function beatHit()
	{
		super.beatHit();
	}

	var isEnding:Bool = false;

	function endBullshit():Void
	{
		isEnding = true;
		FlxG.sound.music.stop();
		FlxG.sound.play(Paths.music('gameOverUpbeatEnd'));

		buttonRetry.animation.play('press', true); 
		buttonLeave.animation.play('appear', true, true);
		deadBF.offset.set(0, 4);
		deadBF.animation.play('confirm', true);	
		PlayState.SONG.player1 = 'bf-awesome-bandaged'; //lol

		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			stupid.fade(FlxColor.BLACK, 2, false, function()
			{
				MusicBeatState.resetState();
			});
		});
		PlayState.instance.callOnLuas('onGameOverConfirm', [true]);
	}

	function menuReturn():Void
	{
		buttonLeave.animation.play('press', true); 
		buttonRetry.animation.play('appear', true, true);

		PlayState.deathCounter = 0;
		PlayState.seenCutscene = false;
		PlayState.chartingMode = false;

		WeekData.loadTheFirstEnabledMod();

		if(PlayState.isStoryMode) 
			MusicBeatState.switchState(new MainMenuState());
		else
			MusicBeatState.switchState(new FreeplayState(PlayState.songCategory));

		FlxG.sound.playMusic(Paths.music('freakyMenu'));
		PlayState.instance.callOnLuas('onGameOverConfirm', [false]);
	}

	function changeSelection()
	{
		retrySelected = !retrySelected;
		if (retrySelected)
		{
			buttonRetry.animation.play('hover', true); 
			buttonLeave.animation.play('loop', true); 
		}
		else
		{
			buttonLeave.animation.play('hover', true); 
			buttonRetry.animation.play('loop', true); 
		}
	}

	function endVidBullshit():Void
	{
		deadBF.alpha = 1;
		buttonRetry.animation.play('appear', true);	
		buttonRetry.alpha = 1;
		buttonLeave.animation.play('appear', true);	
		buttonLeave.alpha = 1;
		new FlxTimer().start(0.5, function(tmr:FlxTimer)
		{
			changeSelection();
			canEnd = true;
		});
		//var camFollowPoint:FlxPoint = new FlxPoint();
		//camFollowPoint.screenCenter

		FlxTween.tween(stupid, {zoom: 0.5/*, x: deadBF.getMidpoint().x, y: deadBF.getMidpoint().y*/}, 1.5, {ease: FlxEase.quadInOut});
		//var camFollowPoint:FlxPoint = new FlxPoint(deadBF.getMidpoint().x, deadBF.getMidpoint().y);
		//stupid.follow(deadBF);
		stupid.follow(camFollowPos, LOCKON, 1);
		updateCamera = true;
	}
}