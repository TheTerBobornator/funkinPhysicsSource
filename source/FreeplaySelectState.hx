package;

import flixel.util.FlxTimer;
#if desktop
import Discord.DiscordClient;
#end
import flixel.FlxG;
import flixel.FlxObject;
import flixel.FlxSprite;
import flixel.FlxCamera;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import lime.app.Application;
import Achievements;
import editors.MasterEditorMenu;
import flixel.input.keyboard.FlxKey;

using StringTools;

class FreeplaySelectState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var selectedMenuItems:FlxTypedGroup<FlxSprite>;
	var titleTxts:FlxTypedGroup<FlxText>;
	var lightThing:FlxSprite;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['incidents', 'internet'];

	//var camFollow:FlxObject;
	//var camFollowPos:FlxObject;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		camGame = new FlxCamera();
		camAchievement = new FlxCamera();
		camAchievement.bgColor.alpha = 0;

		FlxG.cameras.reset(camGame);
		FlxG.cameras.add(camAchievement, false);
		FlxG.cameras.setDefaultDrawTarget(camGame, true);

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

	//	var yScroll:Float = Math.max(0.25 - (0.05 * (optionShit.length - 4)), 0.1);
		
	//	camFollow = new FlxObject(0, 0, 1, 1);
	//	camFollowPos = new FlxObject(0, 0, 1, 1);
	//	add(camFollow);
	//	add(camFollowPos);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		selectedMenuItems = new FlxTypedGroup<FlxSprite>();
		add(selectedMenuItems);

		titleTxts = new FlxTypedGroup<FlxText>();

		/*var scale:Float = 1;
		if(optionShit.length > 6) {
			scale = 6 / optionShit.length;
		}*/

		for (i in 0...optionShit.length)
		{
			var box:FlxSprite = new FlxSprite(0, 0).loadGraphic(Paths.image('freeplay-select/' + optionShit[i] + '1'));
			box.x = (i == 0 ? (FlxG.width * 0.02) : ((FlxG.width * 0.98) - box.width));
			box.ID = i;
			box.setGraphicSize(Std.int(box.width * 0.8));
			//box.updateHitbox();
			menuItems.add(box);

			var boxSelected:FlxSprite = new FlxSprite(box.x - 10, box.y - 10).loadGraphic(Paths.image('freeplay-select/' + optionShit[i] + '2'));
			boxSelected.ID = i;
			boxSelected.setGraphicSize(Std.int((boxSelected.width * 0.8) + 20));
			//boxSelected.updateHitbox();
			boxSelected.alpha = 0;
			selectedMenuItems.add(boxSelected);

			var title:FlxText = new FlxText(box.x + 200, FlxG.height - 50, 0, optionShit[i].toUpperCase(), 32);
			titleTxts.add(title);
		}

		lightThing = new FlxSprite(titleTxts.members[0].x - 90, titleTxts.members[0].y - 100).loadGraphic(Paths.image('freeplay-select/fuckYouShrub'));
		add(lightThing);

		add(titleTxts);

	//	FlxG.camera.follow(camFollowPos, null, 1);

		// NG.core.calls.event.logEvent('swag').send();

		changeItem();

		super.create();
	}

	var selectedSomethin:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		var lerpVal:Float = CoolUtil.boundTo(elapsed * 7.5, 0, 1);
	//	camFollowPos.setPosition(FlxMath.lerp(camFollowPos.x, camFollow.x, lerpVal), FlxMath.lerp(camFollowPos.y, camFollow.y, lerpVal));

		if (!selectedSomethin)
		{
			if (controls.UI_LEFT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_RIGHT_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(1);
			}

			if (controls.BACK)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('cancelMenu'));
				MusicBeatState.switchState(new MainMenuState());
			}

			if (controls.ACCEPT)
			{
				selectedSomethin = true;
				FlxG.sound.play(Paths.sound('confirmMenu'));

			/*	titleTxts.forEach(function(spr:FlxText)
				{
					FlxTween.tween(spr, {alpha: 0}, 0.4, {
						ease: FlxEase.quadOut,
						onComplete: function(twn:FlxTween)
						{
							spr.kill();
						}
					});
				});*/

				FlxTween.tween(lightThing, {alpha: 0}, 0.6, {
					ease: FlxEase.quadOut,
					onComplete: function(twn:FlxTween)
					{
						lightThing.kill();
						
						titleTxts.forEach(function(spr:FlxText)
						{
							spr.kill();
						});
					}
				});

				menuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected != spr.ID)
					{
						FlxTween.tween(spr, {alpha: 0}, 0.4, {
							ease: FlxEase.quadOut,
							onComplete: function(twn:FlxTween)
							{
								spr.kill();
							}
						});
					}
					else
					{
						FlxFlicker.flicker(spr, 1, 0.06, false, false, function(flick:FlxFlicker)
						{
							var daChoice:String = optionShit[curSelected];

							switch (daChoice)
							{
								case 'incidents':
									MusicBeatState.switchState(new FreeplayState());
								case 'internet':
								//	MusicBeatState.switchState(new StoryMenuState());
								PlayState.isStoryMode = false;
								PlayState.storyDifficulty = 2;
								PlayState.SONG = Song.loadFromJson('spooky-scary-hard', 'spooky-scary');
								PlayState.campaignScore = 0;
								PlayState.campaignMisses = 0;
								//PlayState.storyWeek = 8;
								//PlayState.storyPlaylist = ['Tomfoolery'];
								new FlxTimer().start(1, function(tmr:FlxTimer)
								{
									LoadingState.loadAndSwitchState(new PlayState(), true);
									FreeplayState.destroyFreeplayVocals();
								});
									
							}
						});
					}
				});

				selectedMenuItems.forEach(function(spr:FlxSprite)
				{
					if (curSelected == spr.ID)
						FlxFlicker.flicker(spr, 1, 0.06, false);
				});
			}
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		lightThing.setPosition(titleTxts.members[curSelected].x - 90, titleTxts.members[curSelected].y - 100);

		selectedMenuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
				spr.alpha = 1;
				
			else
				spr.alpha = 0;
		});

		titleTxts.forEach(function(spr:FlxText)
		{
			if (spr.ID == curSelected)
				spr.color = 0xFFFF0000;
			else
				spr.color = 0xFF000000;
		});
	}
}