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
	var spookyIcon:FlxSprite;
	
	var optionShit:Array<String> = ['story', 'incidents', 'internet'];
	var completedItemTween:Bool = false;

	override function create()
	{
		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		FlxG.mouse.visible = true;

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		
		selectedMenuItems = new FlxTypedGroup<FlxSprite>();
		add(selectedMenuItems);

		titleTxts = new FlxTypedGroup<FlxText>();
		add(titleTxts);

		for (i in 0...optionShit.length)
		{
			var box:FlxSprite = new FlxSprite(0, FlxG.height).loadGraphic(Paths.image('freeplay-select/' + optionShit[i]));
			box.ID = i;
			box.antialiasing = ClientPrefs.globalAntialiasing;
		/*	switch (i)
			{
				case 2:
					box.x = FlxG.width * 0.1;
				case 0:
					box.x = (FlxG.width * 0.5) - (box.width * 0.5);
				case 1:
					box.x = (FlxG.width * 0.9) - box.width;
			}*/
			menuItems.add(box);
			FlxTween.tween(box, {y: 150}, 0.4 + (i * 0.1), {ease: FlxEase.quartInOut});
			var title:FlxText = new FlxText(box.x, box.y + box.height + 40, box.width, optionShit[i].toUpperCase(), 32);
			title.setFormat(Paths.font("impact.otf"), 32, FlxColor.WHITE, CENTER, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			title.antialiasing = ClientPrefs.globalAntialiasing;
			titleTxts.add(title);
			FlxTween.tween(title, {alpha: 1}, 0.2 + (i * 0.1), {ease: FlxEase.quartInOut, startDelay: 1.0});
			
			var box2:FlxSprite = new FlxSprite(0, 150).loadGraphic(Paths.image('freeplay-select/' + optionShit[i]));
			box2.ID = i;
			box2.alpha = 0;
			box2.antialiasing = ClientPrefs.globalAntialiasing;
			selectedMenuItems.add(box2);
		}

		//whatever
		var tweenTargets:Array<Int> = [];
		switch (curSelected)
		{
			case 0: //story
				tweenTargets = [2, 0, 1];
			case 1: //incidents
				tweenTargets = [0, 1, 2];
			case 2: //internet
				tweenTargets = [1, 2, 0];
		}
		FlxTween.tween(menuItems.members[tweenTargets[0]], {x: FlxG.width * 0.1}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(menuItems.members[tweenTargets[1]], {x: (FlxG.width * 0.5) - (menuItems.members[tweenTargets[1]].width * 0.5)}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(menuItems.members[tweenTargets[2]], {x: (FlxG.width * 0.9) - menuItems.members[tweenTargets[2]].width}, 0.5, {ease: FlxEase.quadOut,
		onComplete: function(twn:FlxTween)
		{
			changeItem();
			completedItemTween = true;
		}});

		var spookyText:FlxSprite = new FlxSprite(FlxG.width * 0.9, FlxG.height - (FlxG.height * 0.025)).loadGraphic(Paths.image('freeplay-select/spookyTxt'));
		spookyText.y -= spookyText.height;
		spookyText.antialiasing = ClientPrefs.globalAntialiasing;
		FlxTween.tween(spookyText, {alpha: 1}, 1, {ease: FlxEase.quartInOut, startDelay: 0.5});
		add(spookyText);

		spookyIcon = new FlxSprite(spookyText.x + 26, spookyText.y + 49).loadGraphic(Paths.image('freeplay-select/spookyIcon'));
		spookyIcon.antialiasing = ClientPrefs.globalAntialiasing;
		FlxTween.tween(spookyIcon, {alpha: 1}, 1, {ease: FlxEase.quartInOut, startDelay: 0.6});
		add(spookyIcon);

		var backButton:MenuBackButton = new MenuBackButton(new MainMenuState());
		add(backButton);

		super.create();
	}

	var selectedSomethin:Bool = false;
	var spookySelected:Bool = false;

	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.8)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
			if(FreeplayState.vocals != null) FreeplayState.vocals.volume += 0.5 * elapsed;
		}

		for (i in 0...menuItems.members.length)
		{
			selectedMenuItems.members[i].setPosition(menuItems.members[i].x, menuItems.members[i].y);
			titleTxts.members[i].setPosition(menuItems.members[i].x, menuItems.members[i].y + menuItems.members[i].height + 20);
		}
		
		if (!selectedSomethin && completedItemTween)
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
				acceptItem();

			if (FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-FlxG.mouse.wheel);
			}

			if (FlxG.mouse.overlaps(spookyIcon))
			{
				if (!spookySelected)
				{
					FlxG.sound.play(Paths.sound('scrollMenu'));
					spookyIcon.setGraphicSize(70);
					spookyIcon.offset.set();
				}

				if (FlxG.mouse.justPressed)
				{
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = 2;
					PlayState.SONG = Song.loadFromJson('spooky-scary-hard', 'spooky-scary');
					LoadingState.loadAndSwitchState(new PlayState(), true);
				}

				spookySelected = true;
			}
			else
			{
				spookySelected = false;
				spookyIcon.setGraphicSize(53);
				spookyIcon.offset.set();
			}

			if (FlxG.mouse.overlaps(menuItems.members[curSelected]) && FlxG.mouse.justPressed)
				acceptItem();
		}

		super.update(elapsed);
	}

	function changeItem(huh:Int = 0)
	{
		completedItemTween = false;
		curSelected += huh;

		if (curSelected >= menuItems.length)
			curSelected = 0;
		if (curSelected < 0)
			curSelected = menuItems.length - 1;

		var tweenTargets:Array<Int> = [];
		//lowkey wanna kms for this one 
		switch (curSelected)
		{
			case 0: //story
				tweenTargets = [2, 0, 1];
			case 1: //incidents
				tweenTargets = [0, 1, 2];
			case 2: //internet
				tweenTargets = [1, 2, 0];
		}

		FlxTween.tween(menuItems.members[tweenTargets[0]], {x: FlxG.width * 0.1}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(menuItems.members[tweenTargets[1]], {x: (FlxG.width * 0.5) - (menuItems.members[tweenTargets[1]].width * 0.5)}, 0.5, {ease: FlxEase.quadOut});
		FlxTween.tween(menuItems.members[tweenTargets[2]], {x: (FlxG.width * 0.9) - menuItems.members[tweenTargets[2]].width}, 0.5, {ease: FlxEase.quadOut,
		onComplete: function(twn:FlxTween)
		{
			completedItemTween = true;
		}});
		
		selectedMenuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
			{
				spr.alpha = 1;
				spr.setGraphicSize(320);
			}
			else
			{
				spr.alpha = 0;
				spr.setGraphicSize(300);
			}
		});
	}

	function acceptItem()
	{
		FlxG.cameras.flash(FlxColor.WHITE, 1, null, true);
		selectedSomethin = true;
		FlxG.sound.play(Paths.sound('confirmMenu'));

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected != spr.ID)
			{
				FlxTween.tween(spr, {y: 1280}, 0.5, {
					ease: FlxEase.quadOut,
					startDelay: 1,
					onComplete: function(twn:FlxTween)
					{
						spr.kill();
					}
				});
			}
			else
			{
				FlxFlicker.flicker(spr, 1, 0.05, true, false, function(flick:FlxFlicker)
				{
					var daChoice:String = optionShit[curSelected];
					MusicBeatState.switchState(new FreeplayState(daChoice));
				});
			}
		});

		selectedMenuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected == spr.ID)
				FlxFlicker.flicker(spr, 1, 0.05, true);
		});

		titleTxts.forEach(function(spr:FlxText)
		{
			if (curSelected == spr.ID)
				FlxFlicker.flicker(spr, 1, 0.05, true);
		});
	}
}