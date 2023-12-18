package;

import options.GraphicsSettingsSubState;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import flixel.tweens.FlxEase;
#if desktop
import Discord.DiscordClient;
#end
import editors.ChartingState;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.addons.transition.FlxTransitionableState;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.tweens.FlxTween;
import lime.utils.Assets;
import flixel.system.FlxSound;
import openfl.utils.Assets as OpenFlAssets;
import WeekData;
import sys.FileSystem;
import flixel.addons.display.FlxBackdrop;

using StringTools;

class FreeplayState extends MusicBeatState
{
	var songs:Array<SongMetadata> = [];

	var selector:FlxText;
	private static var curSelected:Int = 0;
	var curDifficulty:Int = -1;
	private static var lastDifficultyName:String = '';

	var scoreBG:FlxSprite;
	var scoreText:FlxText;
	var diffText:FlxText;
	var lerpScore:Int = 0;
	var lerpRating:Float = 0;
	var intendedScore:Int = 0;
	var intendedRating:Float = 0;

	private var grpSongThumbs:FlxTypedGroup<FlxSprite>;
	private var grpSongs:FlxTypedGroup<Alphabet>;
	private var curPlaying:Bool = false;

	private var iconArray:Array<HealthIcon> = [];

	var bg:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.WHITE);
	var intendedColor:Int;
	var colorTween:FlxTween;

	var oldSongSelected:Bool = false;
	var songAgeSelected:String = '';
	private var oldSongs:Array<String> = [];
	private var oldSongNames:Array<String> = [];
	private var olderSongs:Array<String> = [];
	private var olderSongNames:Array<String> = [];
	public var type:String = 'incidents';
	private var sensitiveSongs:Array<String> = ['Impending Doom', 'Idiot', 'Speed', 'Absurde'];
	var lockedShader:ColorSwap;
	var curAge:Int = 0;

	var inputAttempt:String = '';
	var secretCodes:Array<String> = ['BALDI', 'SKIBIDI'];
	var warningOpen:Bool = false;

	public function new(type:String = 'incidents')
	{
		// is there a reason to not just use public function new instead of create? im still learning, i really don't know but this is fine ?
		super();
		this.type = type;
	}

	override function create()
	{
		//Paths.clearStoredMemory();
		//Paths.clearUnusedMemory();
		
		persistentUpdate = true;
		PlayState.isStoryMode = false;
		PlayState.songCategory = type;
		WeekData.reloadWeekFiles(false);
		FlxG.mouse.visible = true;

		#if desktop
		// Updating Discord Rich Presence
		DiscordClient.changePresence("In the Menus", null);
		#end

		/*for (i in 0...WeekData.weeksList.length) {
			if(weekIsLocked(WeekData.weeksList[i])) continue;

			var leWeek:WeekData = WeekData.weeksLoaded.get(WeekData.weeksList[i]);
			var leSongs:Array<String> = [];
			var leChars:Array<String> = [];

			for (j in 0...leWeek.songs.length)
			{
				leSongs.push(leWeek.songs[j][0]);
				leChars.push(leWeek.songs[j][1]);
			}

			WeekData.setDirectoryFromWeek(leWeek);
			for (song in leWeek.songs)
			{
				var colors:Array<Int> = song[2];
				if(colors == null || colors.length < 3)
				{
					colors = [146, 113, 253];
				}
				addSong(song[0], i, song[1], FlxColor.fromRGB(colors[0], colors[1], colors[2]));
			}
		}
		WeekData.loadTheFirstEnabledMod();*/

		var initSonglist = CoolUtil.coolTextFile(Paths.txt(type + (type != '' ? 'FreeplaySongList' : 'freeplaySongList')));

		for (i in 0...initSonglist.length)//woo yea woo this works woo
		{
			var pooping:Array<String> = initSonglist[i].split(', ');
			// 0 is the song name, 1 is the week (kind of messy loling), 2 is the icon name, 3 is whether or not it has an "old" version, 4 is whether or not it has an "older" version
			songs.push(new SongMetadata(pooping[0], Std.parseInt(pooping[1]), pooping[2], FlxColor.fromString(pooping[5])));
			if (pooping[3] != 'null')
			{
				oldSongs.push(pooping[0]);
				oldSongNames.push(pooping[3]);
			}
			if (pooping[4] != 'null')
			{
				olderSongs.push(pooping[0]);
				olderSongNames.push(pooping[3]);
			}
		}

		/*		//KIND OF BROKEN NOW AND ALSO PRETTY USELESS//

		var initSonglist = CoolUtil.coolTextFile(Paths.txt('freeplaySonglist'));
		for (i in 0...initSonglist.length)
		{
			if(initSonglist[i] != null && initSonglist[i].length > 0) {
				var songArray:Array<String> = initSonglist[i].split(":");
				addSong(songArray[0], 0, songArray[1], Std.parseInt(songArray[2]));
			}
		}*/

		add(bg);

		var bgArt:FlxSprite = new FlxSprite().loadGraphic(Paths.image('freeplay/${type}BG'));
		bgArt.antialiasing = ClientPrefs.globalAntialiasing;
		add(bgArt);

		grpSongThumbs = new FlxTypedGroup<FlxSprite>();
		add(grpSongThumbs);
		grpSongs = new FlxTypedGroup<Alphabet>();
		add(grpSongs);


		lockedShader = new ColorSwap();
		lockedShader.saturation = -1.0;
		lockedShader.brightness = -0.2;

		for (i in 0...songs.length)
		{
			var songText:Alphabet = new Alphabet(0, FlxG.height * i, songs[i].songName, true, false);
			songText.isMenuItem = true;
			songText.targetY = i * 2;
			grpSongs.add(songText);

			if (songText.width > 980)
			{
				var textScale:Float = 980 / songText.width;
				songText.scale.x = textScale;
				for (letter in songText.lettersArray)
				{
					letter.x *= textScale;
					letter.offset.x *= textScale;
				}
				//songText.updateHitbox();
				//trace(songs[i].songName + ' new scale: ' + textScale);
			}

			Paths.currentModDirectory = songs[i].folder;
			var icon:HealthIcon = new HealthIcon(songs[i].songCharacter);
			icon.sprTracker = songText;

			// using a FlxGroup is too much fuss!
			iconArray.push(icon);
			add(icon);

			// songText.x += 40;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
			// songText.screenCenter(X);

			var songName:String = (songs[i].songName).toLowerCase();

			if (Paths.image('freeplay-covers/' + songName) == null)
				songName = 'noSong';

			var songThumbNail:FlxSprite = new FlxSprite();
			songThumbNail.antialiasing = ClientPrefs.globalAntialiasing;

			if (FileSystem.exists(Paths.getPreloadPath('images/freeplay-covers/' + songName + '.xml')))
			{
				songThumbNail.frames = Paths.getSparrowAtlas('freeplay-covers/' + songName);
				songThumbNail.animation.addByPrefix('idle', "idle", 24, true);
				songThumbNail.animation.play('idle', true);
			}
			else
				songThumbNail.loadGraphic(Paths.image('freeplay-covers/' + songName));

			songThumbNail.screenCenter(Y);
			songThumbNail.x = ((FlxG.width * 0.9) - songThumbNail.width);
			songThumbNail.ID = i;
			songThumbNail.alpha = 0.00001;
			grpSongThumbs.add(songThumbNail);
			
			if (Highscore.getScore(songs[i].songName, 2) <= 0)
			{
				//icon.shader = lockedShader.shader;
				//songThumbNail.shader = lockedShader.shader;
			}
		}
		WeekData.setDirectoryFromWeek();

		scoreText = new FlxText(FlxG.width * 0.7, 5, 0, "", 32);
		scoreText.setFormat(Paths.font("impact.otf"), 32, FlxColor.WHITE, RIGHT);
		scoreText.antialiasing = ClientPrefs.globalAntialiasing;

		scoreBG = new FlxSprite(scoreText.x - 6, 0).makeGraphic(1, 72, 0xFF000000);
		scoreBG.alpha = 0.6;
		add(scoreBG);

		diffText = new FlxText(scoreText.x, scoreText.y + 36, 0, "", 24);
		diffText.font = scoreText.font;
		diffText.antialiasing = ClientPrefs.globalAntialiasing;
		add(diffText);
		add(scoreText);

		if(curSelected >= songs.length) curSelected = 0;
		bg.color = songs[curSelected].daColor;
		intendedColor = bg.color;

		if(lastDifficultyName == '')
		{
			lastDifficultyName = CoolUtil.defaultDifficulty;
		}
		curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(lastDifficultyName)));
		
		changeSelection();
		changeDiff();

		// JUST DOIN THIS SHIT FOR TESTING!!!
		/* 
			var md:String = Markdown.markdownToHtml(Assets.getText('CHANGELOG.md'));

			var texFel:TextField = new TextField();
			texFel.width = FlxG.width;
			texFel.height = FlxG.height;
			// texFel.
			texFel.htmlText = md;

			FlxG.stage.addChild(texFel);

			// scoreText.textField.htmlText = md;

			trace(md);
		 */

		var textBG:FlxSprite = new FlxSprite(0, FlxG.height - 26).makeGraphic(FlxG.width, 26, 0xFF000000);
		textBG.alpha = 0.6;
		add(textBG);

		#if PRELOAD_ALL
		var leText:String = "Press SPACE to listen to the Song / Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 16;
		#else
		var leText:String = "Press CTRL to open the Gameplay Changers Menu / Press RESET to Reset your Score and Accuracy.";
		var size:Int = 18;
		#end
		var text:FlxText = new FlxText(textBG.x, textBG.y + 4, FlxG.width, leText, size);
		text.setFormat(Paths.font("impact.otf"), size, FlxColor.WHITE, RIGHT);
		text.scrollFactor.set();
		text.antialiasing = ClientPrefs.globalAntialiasing;
		add(text);

		var backButton:MenuBackButton = new MenuBackButton(new FreeplaySelectState());
		add(backButton);

		inputAttempt = '';

		super.create();
	}

	override function closeSubState() {
		changeSelection(0, false);
		persistentUpdate = true;
		super.closeSubState();
	}

	public function addSong(songName:String, weekNum:Int, songCharacter:String, songColor:FlxColor)
	{
		songs.push(new SongMetadata(songName, weekNum, songCharacter, songColor));
	}

//	function weekIsLocked(name:String):Bool {
//		var leWeek:WeekData = WeekData.weeksLoaded.get(name);
//		return (!leWeek.startUnlocked && leWeek.weekBefore.length > 0 && (!StoryMenuState.weekCompleted.exists(leWeek.weekBefore) || !StoryMenuState.weekCompleted.get(leWeek.weekBefore)));
//	}

	/*public function addWeek(songs:Array<String>, weekNum:Int, weekColor:Int, ?songCharacters:Array<String>)
	{
		if (songCharacters == null)
			songCharacters = ['bf'];

		var num:Int = 0;
		for (song in songs)
		{
			addSong(song, weekNum, songCharacters[num]);
			this.songs[this.songs.length-1].color = weekColor;

			if (songCharacters.length != 1)
				num++;
		}
	}*/

	var instPlaying:Int = -1;
	public static var vocals:FlxSound = null;
	var holdTime:Float = 0;
	override function update(elapsed:Float)
	{
		if (FlxG.sound.music.volume < 0.7)
		{
			FlxG.sound.music.volume += 0.5 * FlxG.elapsed;
		}

		checkForPasscode();

		lerpScore = Math.floor(FlxMath.lerp(lerpScore, intendedScore, CoolUtil.boundTo(elapsed * 24, 0, 1)));
		lerpRating = FlxMath.lerp(lerpRating, intendedRating, CoolUtil.boundTo(elapsed * 12, 0, 1));

		if (Math.abs(lerpScore - intendedScore) <= 10)
			lerpScore = intendedScore;
		if (Math.abs(lerpRating - intendedRating) <= 0.01)
			lerpRating = intendedRating;

		var ratingSplit:Array<String> = Std.string(Highscore.floorDecimal(lerpRating * 100, 2)).split('.');
		if(ratingSplit.length < 2) { //No decimals, add an empty space
			ratingSplit.push('');
		}
		
		while(ratingSplit[1].length < 2) { //Less than 2 decimals in it, add decimals then
			ratingSplit[1] += '0';
		}

		scoreText.text = 'PERSONAL BEST: ' + lerpScore + ' (' + ratingSplit.join('.') + '%)';
		positionHighscore();

		if (songs[curSelected].songName == 'Impending Doom' && warningOpen == false)
		{
			if (ClientPrefs.shaking)
				FlxG.cameras.shake(0.001, 0.1);
			
			if(ClientPrefs.shaders)
			{
				FlxG.camera.setFilters([ShadersHandler.chromaticAberration]);
				ShadersHandler.setChromeWackyMode(0.003);
			}
		}
		else
			FlxG.camera.setFilters([]);

		var upP = controls.UI_UP_P;
		var downP = controls.UI_DOWN_P;
		var accepted = controls.ACCEPT;
		var space = FlxG.keys.justPressed.SPACE;
		var ctrl = FlxG.keys.justPressed.CONTROL;

		var shiftMult:Int = 1;
		if(FlxG.keys.pressed.SHIFT) shiftMult = 3;

		if(songs.length > 1)
		{
			if (upP)
			{
				changeSelection(-shiftMult);
				holdTime = 0;
			}
			if (downP)
			{
				changeSelection(shiftMult);
				holdTime = 0;
			}

			if(controls.UI_DOWN || controls.UI_UP)
			{
				var checkLastHold:Int = Math.floor((holdTime - 0.5) * 10);
				holdTime += elapsed;
				var checkNewHold:Int = Math.floor((holdTime - 0.5) * 10);

				if(holdTime > 0.5 && checkNewHold - checkLastHold > 0)
				{
					changeSelection((checkNewHold - checkLastHold) * (controls.UI_UP ? -shiftMult : shiftMult));
					changeDiff();
				}
			}

			if(FlxG.mouse.wheel != 0)
			{
				FlxG.sound.play(Paths.sound('scrollMenu'), 0.2);
				changeSelection(-shiftMult * FlxG.mouse.wheel, false);
				changeDiff();
			}
		}

		if (controls.UI_LEFT_P)
			changeDiff(-1);
		else if (controls.UI_RIGHT_P)
			changeDiff(1);
		else if (upP || downP) 
			changeDiff();

		if (controls.BACK)
		{
			persistentUpdate = false;
			if(colorTween != null) {
				colorTween.cancel();
			}
			FlxG.sound.play(Paths.sound('cancelMenu'));
			MusicBeatState.switchState(new FreeplaySelectState());
			//MusicBeatState.switchState(new MainMenuState());
		}

		if(ctrl)
		{
			persistentUpdate = false;
			openSubState(new GameplayChangersSubstate());
		}
		else if(space)
		{
			if(instPlaying != curSelected)
			{
				#if PRELOAD_ALL
				destroyFreeplayVocals();
				FlxG.sound.music.volume = 0;
				Paths.currentModDirectory = songs[curSelected].folder;
				var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase() + (songAgeSelected != '' ? '-(' + songAgeSelected.toLowerCase() + ')' : ''), curDifficulty);
				PlayState.SONG = Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase() + (songAgeSelected != '' ? '-(' + songAgeSelected.toLowerCase() + ')' : ''));
				
				if (PlayState.SONG.needsVoices)
					vocals = new FlxSound().loadEmbedded(Paths.voices(PlayState.SONG.song));
				else
					vocals = new FlxSound();

				FlxG.sound.list.add(vocals);
				FlxG.sound.playMusic(Paths.inst(PlayState.SONG.song), 0.7);
				vocals.play();
				vocals.persist = true;
				vocals.looped = true;
				vocals.volume = 0.7;
				instPlaying = curSelected;
				#end
			}
		}
		else if (accepted)
		{
			acceptItem();
		}
		else if(controls.RESET)
		{
			persistentUpdate = false;
			openSubState(new ResetScoreSubState(songs[curSelected].songName, curDifficulty, songs[curSelected].songCharacter));
			FlxG.sound.play(Paths.sound('scrollMenu'));
		}

		if (FlxG.mouse.overlaps(grpSongs.members[curSelected]) && FlxG.mouse.justPressed)
			acceptItem();

		super.update(elapsed);
	}

	public static function destroyFreeplayVocals() {
		if(vocals != null) {
			vocals.stop();
			vocals.destroy();
		}
		vocals = null;
	}

	function changeDiff(change:Int = 0)
	{
		if (oldSongs.contains(songs[curSelected].songName) || olderSongs.contains(songs[curSelected].songName))
		{
			trace ('found song with old variant');
			curAge += change;

			if (olderSongs.contains(songs[curSelected].songName))
			{
				trace ('found song with older variant');
				if (curAge < 0)
					curAge = 2;
				if (curAge >= 3)
					curAge = 0;
			}
			else
			{
				if (curAge < 0)
					curAge = 1;
				if (curAge >= 2)
					curAge = 0;
			}

			switch (curAge)
			{
				case 0:
					songAgeSelected = '';
				case 1:
					songAgeSelected = 'Old';
				case 2:
					songAgeSelected = 'Older';
			}

			var poop:String = Highscore.formatSong(songs[curSelected].songName.toLowerCase() + (songAgeSelected != '' ? ' (' + songAgeSelected + ')' : ''), curDifficulty);

			grpSongs.members[curSelected].changeText(Song.loadFromJson(poop, songs[curSelected].songName.toLowerCase() + (songAgeSelected != '' ? ' (' + songAgeSelected + ')' : '')).song); 
		}
		else
			songAgeSelected = '';

	//	curDifficulty += change;

	//	if (curDifficulty < 0)
	//		curDifficulty = CoolUtil.difficulties.length-1;
	//	if (curDifficulty >= CoolUtil.difficulties.length)
	//		curDifficulty = 0;

		lastDifficultyName = CoolUtil.difficulties[curDifficulty];

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName + (songAgeSelected != '' ? ' (' + songAgeSelected + ')' : ''), curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName + (songAgeSelected != '' ? ' (' + songAgeSelected + ')' : ''), curDifficulty);
		#end

		grpSongThumbs.forEach(function(spr:FlxSprite)
		{
			if (spr.ID == curSelected)
				spr.alpha = 1;
			else
				spr.alpha = 0.00001;
		});

		PlayState.storyDifficulty = curDifficulty;
		diffText.text = oldSongs.contains(songs[curSelected].songName) ? ('< ' + (songAgeSelected != '' ? songAgeSelected.toUpperCase() : CoolUtil.difficultyString()) + ' >') : '';
		positionHighscore();
	}

	function changeSelection(change:Int = 0, playSound:Bool = true)
	{
		if(playSound) 
			FlxG.sound.play(Paths.sound('scrollMenu'), 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = songs.length - 1;
		if (curSelected >= songs.length)
			curSelected = 0;
			
		var newColor:Int = songs[curSelected].daColor;
		if(newColor != intendedColor) {
			if(colorTween != null) {
				colorTween.cancel();
			}
			intendedColor = newColor;
			colorTween = FlxTween.color(bg, 1, bg.color, intendedColor, {
				onComplete: function(twn:FlxTween) {
					colorTween = null;
				}
			});
		}

		// selector.y = (70 * curSelected) + 30;

		#if !switch
		intendedScore = Highscore.getScore(songs[curSelected].songName, curDifficulty);
		intendedRating = Highscore.getRating(songs[curSelected].songName, curDifficulty);
		#end

		var bullShit:Int = 0;

		for (i in 0...iconArray.length)
		{
			iconArray[i].alpha = 0.6;
		}

		iconArray[curSelected].alpha = 1;

		for (item in grpSongs.members)
		{
			item.targetY = (bullShit - curSelected) * 2;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
		
		Paths.currentModDirectory = songs[curSelected].folder;
		PlayState.storyWeek = songs[curSelected].week;

		CoolUtil.difficulties = CoolUtil.defaultDifficulties.copy();
		var diffStr:String = WeekData.getCurrentWeek().difficulties;
		if(diffStr != null) diffStr = diffStr.trim(); //Fuck you HTML5

		if(diffStr != null && diffStr.length > 0)
		{
			var diffs:Array<String> = diffStr.split(',');
			var i:Int = diffs.length - 1;
			while (i > 0)
			{
				if(diffs[i] != null)
				{
					diffs[i] = diffs[i].trim();
					if(diffs[i].length < 1) diffs.remove(diffs[i]);
				}
				--i;
			}

			if(diffs.length > 0 && diffs[0].length > 0)
			{
				CoolUtil.difficulties = diffs;
			}
		}
		
		if(CoolUtil.difficulties.contains(CoolUtil.defaultDifficulty))
		{
			curDifficulty = Math.round(Math.max(0, CoolUtil.defaultDifficulties.indexOf(CoolUtil.defaultDifficulty)));
		}
		else
		{
			curDifficulty = 0;
		}

		var newPos:Int = CoolUtil.difficulties.indexOf(lastDifficultyName);
		//trace('Pos of ' + lastDifficultyName + ' is ' + newPos);
		if(newPos > -1)
		{
			curDifficulty = newPos;
		}
	}

	private function positionHighscore() {
		scoreText.x = FlxG.width - scoreText.width - 6;

		scoreBG.scale.x = FlxG.width - scoreText.x + 6;
		scoreBG.x = FlxG.width - (scoreBG.scale.x / 2);
		diffText.x = Std.int(scoreBG.x + (scoreBG.width / 2));
		diffText.x -= diffText.width / 2;
	}

	function acceptItem()
	{
		persistentUpdate = false;
		var songLowercase:String = Paths.formatToSongPath(songs[curSelected].songName + (songAgeSelected != '' ? ' (' + songAgeSelected + ')' : ''));
		var poop:String = Highscore.formatSong(songLowercase, curDifficulty);

		/*#if MODS_ALLOWED
		if(!sys.FileSystem.exists(Paths.modsJson(songLowercase + '/' + poop)) && !sys.FileSystem.exists(Paths.json(songLowercase + '/' + poop))) {
		#else
		if(!OpenFlAssets.exists(Paths.json(songLowercase + '/' + poop))) {
		#end
			poop = songLowercase;
			curDifficulty = 1;
			trace('Couldnt find file');
		}*/
		trace(poop);

		PlayState.SONG = Song.loadFromJson(poop, songLowercase);
		PlayState.isStoryMode = false;
		PlayState.storyDifficulty = curDifficulty;

		trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
		if(colorTween != null) {
			colorTween.cancel();
		}
		
		if (FlxG.keys.pressed.SHIFT)
		{
			LoadingState.loadAndSwitchState(new ChartingState());
			FlxG.sound.music.volume = 0;
		}
		else
		{
			trace(songs[curSelected].songName);
			if (sensitiveSongs.contains(songs[curSelected].songName) && !FlxG.save.data.freeplayWarning)
			{
				warningOpen = true;
				new FlxTimer().start(0.01, function(tmr:FlxTimer)
				{
					openSubState(new FreeplayWarningSubstate());
					FlxG.sound.music.fadeOut(1, 0.5);
				});
			}
			else
			{
				LoadingState.loadAndSwitchState(new PlayState());
				FlxG.sound.music.volume = 0;
			}
		}
				
		destroyFreeplayVocals();
	}

	//ok so like TECHNICALLY i copied this from vs retrospecter but i thought to do this in the same exact way anyway i just wanted tosee if they had a more efficient way at all (they didnt)
	function checkForPasscode()
	{
		if (FlxG.keys.justPressed.ANY)
		{
			if (FlxG.keys.justPressed.A)
				inputAttempt += 'A';
			else if (FlxG.keys.justPressed.B)
				inputAttempt += 'B';
			else if (FlxG.keys.justPressed.C)
				inputAttempt += 'C';
			else if (FlxG.keys.justPressed.D)
				inputAttempt += 'D';
			else if (FlxG.keys.justPressed.E)
				inputAttempt += 'E';
			else if (FlxG.keys.justPressed.F)
				inputAttempt += 'F';
			else if (FlxG.keys.justPressed.G)
				inputAttempt += 'G';
			else if (FlxG.keys.justPressed.H)
				inputAttempt += 'H';
			else if (FlxG.keys.justPressed.I)
				inputAttempt += 'I';
			else if (FlxG.keys.justPressed.J)
				inputAttempt += 'J';
			else if (FlxG.keys.justPressed.K)
				inputAttempt += 'K';
			else if (FlxG.keys.justPressed.L)
				inputAttempt += 'L';
			else if (FlxG.keys.justPressed.M)
				inputAttempt += 'M';
			else if (FlxG.keys.justPressed.N)
				inputAttempt += 'N';
			else if (FlxG.keys.justPressed.O)
				inputAttempt += 'O';
			else if (FlxG.keys.justPressed.P)
				inputAttempt += 'P';
			else if (FlxG.keys.justPressed.Q)
				inputAttempt += 'Q';
			else if (FlxG.keys.justPressed.R)
				inputAttempt += 'R';
			else if (FlxG.keys.justPressed.S)
				inputAttempt += 'S';
			else if (FlxG.keys.justPressed.T)
				inputAttempt += 'T';
			else if (FlxG.keys.justPressed.U)
				inputAttempt += 'U';
			else if (FlxG.keys.justPressed.V)
				inputAttempt += 'V';
			else if (FlxG.keys.justPressed.W)
				inputAttempt += 'W';
			else if (FlxG.keys.justPressed.X)
				inputAttempt += 'X';
			else if (FlxG.keys.justPressed.Y)
				inputAttempt += 'Y';
			else if (FlxG.keys.justPressed.Z)
				inputAttempt += 'Z';
			else if (FlxG.keys.justPressed.ZERO)
				inputAttempt += '0';
			else if (FlxG.keys.justPressed.ONE)
				inputAttempt += '1';
			else if (FlxG.keys.justPressed.TWO)
				inputAttempt += '2';
			else if (FlxG.keys.justPressed.THREE)
				inputAttempt += '3';
			else if (FlxG.keys.justPressed.FOUR)
				inputAttempt += '4';
			else if (FlxG.keys.justPressed.FIVE)
				inputAttempt += '5';
			else if (FlxG.keys.justPressed.SIX)
				inputAttempt += '6';
			else if (FlxG.keys.justPressed.SEVEN)
				inputAttempt += '7';
			else if (FlxG.keys.justPressed.EIGHT)
				inputAttempt += '8';
			else if (FlxG.keys.justPressed.NINE)
				inputAttempt += '9';

			if (inputAttempt.contains('BALDI'))
			{
				if (inputAttempt == 'BALDI')
				{
					persistentUpdate = false;
					var poop:String = Highscore.formatSong('baldstruck', curDifficulty);
			
					trace(poop);
				
					PlayState.SONG = Song.loadFromJson(poop, 'baldstruck');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
				
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
					if(colorTween != null) {
						colorTween.cancel();
					}
				
					trace(songs[curSelected].songName);
		
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
					
					destroyFreeplayVocals();
				}
			}
			else if (inputAttempt.contains('SKIBIDI'))
			{
				if (inputAttempt == 'SKIBIDI')
				{
					persistentUpdate = false;
					var poop:String = Highscore.formatSong('skibidi', curDifficulty);
			
					trace(poop);
					
					PlayState.SONG = Song.loadFromJson(poop, 'skibidi');
					PlayState.isStoryMode = false;
					PlayState.storyDifficulty = curDifficulty;
				
					trace('CURRENT WEEK: ' + WeekData.getWeekFileName());
					if(colorTween != null) {
						colorTween.cancel();
					}
				
					trace(songs[curSelected].songName);
		
					LoadingState.loadAndSwitchState(new PlayState());
					FlxG.sound.music.volume = 0;
					
					destroyFreeplayVocals();
				}
			}
		}
	}
}

class SongMetadata
{
	public var songName:String = "";
	public var week:Int = 0;
	public var songCharacter:String = "";
	public var folder:String = "";
	public var daColor:FlxColor = FlxColor.WHITE;

	public function new(song:String, week:Int, songCharacter:String, color:FlxColor)
	{
		this.songName = song;
		this.week = week;
		this.songCharacter = songCharacter;
		this.folder = Paths.currentModDirectory;
		this.daColor = color;
		if(this.folder == null) this.folder = '';
	}
}