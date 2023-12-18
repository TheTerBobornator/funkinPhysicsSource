package;

import flixel.addons.display.FlxBackdrop;
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

class CommunityMenuState extends MusicBeatState
{
	public static var curSelected:Int = 0;

	var backdrop:FlxBackdrop;
	var terry:FlxSprite;
	var itemBG:FlxSprite;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var optionShit:Array<String> = ['twitter', 'youtube', 'discord'];

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

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xff6acbff);
		add(bg);

		backdrop = new FlxBackdrop(Paths.image('trollface'), 0, 0, true, true, 0, 0);
		backdrop.antialiasing = ClientPrefs.globalAntialiasing;
		add(backdrop);

		terry = new FlxSprite(846, FlxG.height + 10).loadGraphic(Paths.image('communitymenu/terry'));
		terry.antialiasing = ClientPrefs.globalAntialiasing;
		FlxTween.tween(terry, {y: 392}, 0.5, {ease: FlxEase.elasticInOut, startDelay: 1});
		add(terry);

		itemBG = new FlxSprite(377, -1000).loadGraphic(Paths.image('communitymenu/background_w_text'));
		itemBG.y = -itemBG.height;
		itemBG.antialiasing = ClientPrefs.globalAntialiasing;
		FlxTween.tween(itemBG, {y: 9}, 0.4, {ease: FlxEase.quartInOut});
		add(itemBG);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);

		for (i in 0...optionShit.length)
		{
			var item:FlxSprite = new FlxSprite(420, 127).loadGraphic(Paths.image('communitymenu/' + optionShit[i]));
			item.ID = i;
			item.alpha = 0.00001;
			item.antialiasing = ClientPrefs.globalAntialiasing;
			switch (i)
			{
				case 1:
					item.y = 261;
				case 2:
					item.y = 398;
			}
			FlxTween.tween(item, {alpha: 1}, 0.4 + (i * 0.1), {ease: FlxEase.quartInOut, startDelay: 0.4,
			onComplete: function(twn:FlxTween)
			{
				changeItem();
				if (i == optionShit.length - 1)
					completedItemTween = true;
			}});
			menuItems.add(item);
		}
		
		var backButton:MenuBackButton = new MenuBackButton(new MainMenuState());
		add(backButton);

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

		backdrop.x += 0.5 * (elapsed / (1 / 120));
		backdrop.y += 0.5 * (elapsed / (1 / 120));

		if (!selectedSomethin && completedItemTween)
		{
			if (controls.UI_UP_P)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'));
				changeItem(-1);
			}

			if (controls.UI_DOWN_P)
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
				acceptOption();
			}

			menuItems.forEach(function(spr:FlxSprite)
			{
				if (FlxG.mouse.overlaps(spr))
				{
					if (curSelected != spr.ID)
					{
						FlxG.sound.play(Paths.sound('scrollMenu'));
						changeItem(spr.ID, true);
					}
					if (FlxG.mouse.justPressed)
						acceptOption();
				}
			});
		}

		super.update(elapsed);
	}

	function acceptOption()
	{
		FlxG.sound.play(Paths.sound('confirmMenu'));
		menuItems.forEach(function(spr:FlxSprite)
		{
			if (curSelected == spr.ID)
			{
				FlxFlicker.flicker(spr, 0.5, 0.05, true, false, function(flick:FlxFlicker)
				{
					var daChoice:String = optionShit[curSelected];
					switch (daChoice)
					{
						case 'twitter':
							CoolUtil.browserLoad('https://twitter.com/funkinphysics');
						case 'youtube':
							CoolUtil.browserLoad('https://www.youtube.com/@funkinphysics');
						case 'discord':
							CoolUtil.browserLoad('https://discord.com/invite/e66PDPKNNN');
					}
					return;
				});
			}
		});
	}

	function changeItem(huh:Int = 0, ?mouseChange:Bool = false)
	{
		if (!mouseChange)
		{
			curSelected += huh;

			if (curSelected >= menuItems.length)
				curSelected = 0;
			if (curSelected < 0)
				curSelected = menuItems.length - 1;
		}
		else
			curSelected = huh;

		menuItems.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
				spr.setGraphicSize(Std.int(375 * 1.1), Std.int(118 * 1.1));
				//FlxTween.tween(spr, {width: (375 * 1.2), height: (118 * 1.2)}, 0.25, {ease: FlxEase.quartInOut});
			else
				spr.setGraphicSize(375, 118);
				//FlxTween.tween(spr, {width: 375, height: 118}, 0.25, {ease: FlxEase.quartInOut});
		});
	}
}