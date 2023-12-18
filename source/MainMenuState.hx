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

class MainMenuState extends MusicBeatState
{
	public static var psychEngineVersion:String = '0.6.2'; //This is also used for Discord RPC
	public static var curSelected:Int = 0;

	var menuItems:FlxTypedGroup<FlxSprite>;
	var menuIcons:FlxTypedGroup<FlxSprite>;
	var menuTxts:FlxTypedGroup<FlxText>;
	var menuChars:FlxTypedGroup<FlxSprite>;
	private var camGame:FlxCamera;
	private var camAchievement:FlxCamera;
	
	var optionShit:Array<String> = ['week1', 'week2', 'extras', 'credits', 'options', 'community'];
	var unlockedArray:Array<Bool> = [true, false, false, true, true, true];//FlxG.save.data.mainMenuUnlocks;

	var debugKeys:Array<FlxKey>;

	var completedItemTween:Bool = false;
//anchors away

	override function create()
	{
		#if MODS_ALLOWED
		Paths.pushGlobalMods();
		#end
		WeekData.loadTheFirstEnabledMod();
		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();

		FlxG.mouse.visible = true;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end
		debugKeys = ClientPrefs.copyKey(ClientPrefs.keyBinds.get('debug_1'));

		transIn = FlxTransitionableState.defaultTransIn;
		transOut = FlxTransitionableState.defaultTransOut;

		persistentUpdate = persistentDraw = true;

		trace (StoryMenuState.weekCompleted);

		if (StoryMenuState.weekCompleted != null)
		{
			if (StoryMenuState.weekCompleted.get(1) == true)
			{
				unlockedArray[1] = true;
				if (StoryMenuState.weekCompleted.get(2) == true)
					unlockedArray[2] = true;
			}
		}

		var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, 0xffffffff);
		add(bg);

		menuItems = new FlxTypedGroup<FlxSprite>();
		add(menuItems);
		menuTxts = new FlxTypedGroup<FlxText>();
		add(menuTxts);
		menuIcons = new FlxTypedGroup<FlxSprite>();
		add(menuIcons);
		menuChars = new FlxTypedGroup<FlxSprite>();
		add(menuChars);

		for (i in 0...optionShit.length)
		{
			var item:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/item'));
			item.setPosition(-item.width - 10, 25 * (i + 1) + (i * item.height));
			item.ID = i;
			item.antialiasing = ClientPrefs.globalAntialiasing;
			FlxTween.tween(item, {x: -70}, 0.4 + (i * 0.1), {ease: FlxEase.quartInOut});
			
			var icon:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/' + (unlockedArray[i] ? optionShit[i] : 'lock')));
			icon.setPosition(item.x + 290, item.y);
			icon.alpha = 0;
			icon.ID = i;
			icon.antialiasing = ClientPrefs.globalAntialiasing;
			FlxTween.tween(icon, {alpha: 1}, 0.2 + (i * 0.1), {ease: FlxEase.quartInOut, startDelay: 1.0,
			onComplete: function(twn:FlxTween)
			{
				changeItem();
				if (i == optionShit.length - 1)
					completedItemTween = true;
			}});

			var displayText:String = '';
			switch (i) 
			{
				case 0:
					displayText = 'Week 1';
					icon.offset.set(-19, 16);
				case 1:
					displayText = 'Week 2';
					icon.offset.set(-43, 5);
				case 2:
					displayText = 'Extras';
					icon.offset.set(0, 18);
				case 3:
					displayText = 'Credits';
					icon.offset.set(-33, 9);
				case 4:
					displayText = 'Options';
					icon.offset.set(-48, 10);
				case 5:
					displayText = 'Community';
					icon.offset.set(-27, 6);
			}

			if (unlockedArray[i] == false)
				icon.offset.set(-33, 8);

			var txt:FlxText = new FlxText(item.x + 80, item.y + 8, 0, displayText, 60);
			txt.setFormat(Paths.font("impact.otf"), 60, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
			txt.borderSize = 3;
			txt.ID = i;
			txt.antialiasing = ClientPrefs.globalAntialiasing;

			var char:FlxSprite = new FlxSprite().loadGraphic(Paths.image('mainmenu/' + optionShit[i] + '-char'));
			char.setPosition(FlxG.width - char.width, FlxG.height - char.height);
			char.ID = i;
			char.antialiasing = ClientPrefs.globalAntialiasing;
			char.alpha = 0.00001;

			menuItems.add(item);
			menuTxts.add(txt);
			menuIcons.add(icon);
			menuChars.add(char);
		}

		var versionShit:FlxText = new FlxText(12, FlxG.height - 44, 0, "Psych Engine v" + psychEngineVersion, 12);
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);
		var versionShit:FlxText = new FlxText(12, FlxG.height - 24, 0, "Funkin' Physics v" + Application.current.meta.get('version'), 12);
		versionShit.setFormat("VCR OSD Mono", 16, FlxColor.WHITE, LEFT, FlxTextBorderStyle.OUTLINE, FlxColor.BLACK);
		add(versionShit);

		// NG.core.calls.event.logEvent('swag').send();

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

		for (i in 0...menuIcons.members.length)
		{
			menuIcons.members[i].setPosition(menuItems.members[i].x + 290, menuItems.members[i].y);
		}
		for (i in 0...menuTxts.members.length)
		{
			menuTxts.members[i].setPosition(menuItems.members[i].x + 80, menuItems.members[i].y + 8);
		}

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
				MusicBeatState.switchState(new TitleState());
			}

			if (controls.ACCEPT)
				acceptOption();

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

			#if desktop
		//	else if (FlxG.keys.anyJustPressed(debugKeys)) //no :)
		//	{
		//		selectedSomethin = true;
		//		MusicBeatState.switchState(new MasterEditorMenu());
		//	}
			#end
		}

		super.update(elapsed);
	}

	function acceptOption()
	{
		if (unlockedArray[curSelected])
		{
			FlxG.cameras.flash(FlxColor.WHITE, 1, null, true);
			selectedSomethin = true;
			FlxG.sound.play(Paths.sound('confirmMenu'));
			menuItems.forEach(function(spr:FlxSprite)
			{
				if (curSelected != spr.ID)
				{
					FlxTween.tween(spr, {x: -spr.width - 80}, 0.8 - -(spr.ID * 0.05), {
						ease: FlxEase.quartInOut,
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
						switch (daChoice)
						{
							case 'week1':
								PlayState.isStoryMode = true;
								PlayState.storyDifficulty = 2;
								PlayState.SONG = Song.loadFromJson('trolling-hard', 'trolling');
								PlayState.campaignScore = 0;
								PlayState.campaignMisses = 0;
								PlayState.storyWeek = 1;
								PlayState.storyPlaylist = ['Trolling', 'Foretoken', 'Impending Doom'];
								LoadingState.loadAndSwitchState(new PlayState(), true);
								FreeplayState.destroyFreeplayVocals();
							case 'week2':
								PlayState.isStoryMode = true;
								PlayState.storyDifficulty = 2;
								PlayState.SONG = Song.loadFromJson('tomfoolery-hard', 'tomfoolery');
								PlayState.campaignScore = 0;
								PlayState.campaignMisses = 0;
								PlayState.storyWeek = 2;
								PlayState.storyPlaylist = ['Tomfoolery'];
								LoadingState.loadAndSwitchState(new PlayState(), true);
								FreeplayState.destroyFreeplayVocals();
							case 'extras':
								MusicBeatState.switchState(new FreeplaySelectState());
							case 'credits':
								MusicBeatState.switchState(new CreditsState());
							case 'options':
								LoadingState.loadAndSwitchState(new options.OptionsState());
							case 'community':
								MusicBeatState.switchState(new CommunityMenuState());
						}
					});
				}
			});
			menuIcons.forEach(function(icon:FlxSprite)
			{
				if (icon.ID == curSelected)
					FlxFlicker.flicker(icon, 1, 0.05, true, false);
			});
			menuTxts.forEach(function(txt:FlxSprite)
			{
				if (txt.ID == curSelected)
					FlxFlicker.flicker(txt, 1, 0.05, true, false);
			});
		}
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
				FlxTween.tween(spr, {x: 0}, 0.1, {ease: FlxEase.quartInOut});
			else
				FlxTween.tween(spr, {x: -70}, 0.1, {ease: FlxEase.quartInOut});
		});
		menuChars.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
				spr.alpha = 1;
			else
				spr.alpha = 0.00001;
		});
	}
}