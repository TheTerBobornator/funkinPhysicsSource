package;

import sys.FileSystem;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.text.FlxTypeText;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxKeyManager;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import flixel.util.FlxTimer;

using StringTools;
/**
 * Class for creating a cutscene that uses a set of images that take up the whole screen
 * 
 * Can use sounds also !!! 
 */

class StaticImageCutscene extends FlxSpriteGroup
{
	public var finishThing:Void->Void;
	var bgFade:FlxSprite;
	var cutsceneImages:Array<FlxSprite> = [];
	var nextButton:FlxSprite;
	// correct order of noises on this corresponds each image
	var soundArray:Array<String> = [];
	var curSound:Int = 0;

	public function new()
	{
		super();

		FlxG.mouse.visible = true;

		switch (PlayState.SONG.song.toLowerCase())
		{
			case 'trolling':
				FlxG.sound.playMusic(Paths.music("Trolling_Cutscene"), 0.8);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				soundArray = ['TrollingLine1', 'Knocking', 'TrollingLine2', 'DoorOpens', 'Terrys_Appearance', 'TrollingLine3'];
			case 'tomfoolery':
				FlxG.sound.playMusic(Paths.music("Tomfoolery_Cutscene"), 0.6);
				FlxG.sound.music.fadeIn(1, 0, 0.8);
				soundArray = ['1_year_later', '', 'Knocking', 'tries_to_open_1st', 'tries_to_open_2nd', 'opens_it_congrats_dude'];
		}

		bgFade = new FlxSprite(-200, -200).makeGraphic(Std.int(FlxG.width * 1.3), Std.int(FlxG.height * 1.3), FlxColor.BLACK);
		bgFade.scrollFactor.set();
		add(bgFade);
		
		var cutsceneArray:Array<String> = [];
		var cutsceneImageDirectory:String = Paths.getPreloadPath('shared/images/cutscenes/' + PlayState.SONG.song.toLowerCase());
		if (FileSystem.exists(cutsceneImageDirectory)) 
		{
			for (file in FileSystem.readDirectory(cutsceneImageDirectory)) 
			{
				var path = haxe.io.Path.join([cutsceneImageDirectory, file]);
				if (!FileSystem.isDirectory(path) && file.endsWith('.png')) 
				{
					var check:String = file.substr(0, file.length - 4);
					cutsceneArray.unshift(check); // reverse order for proper layering
				}
			}
		}
		else 
			return;

		trace (cutsceneArray);

		for (i in 0...cutsceneArray.length)
		{
			var cutscene:FlxSprite = new FlxSprite().loadGraphic(Paths.image('cutscenes/' + PlayState.SONG.song.toLowerCase() + "/" + cutsceneArray[i]));
            cutscene.antialiasing = ClientPrefs.globalAntialiasing;
			cutscene.setGraphicSize(FlxG.width, FlxG.height);
			cutscene.updateHitbox();
			cutscene.screenCenter();
			cutscene.ID = i;
            add(cutscene);
			cutsceneImages.push(cutscene);
		}

		new FlxTimer().start(0.8, function(tmr:FlxTimer)
		{
			playCurrentSound();
		});

		nextButton = new FlxSprite().loadGraphic(Paths.image('cutscenes/cutsceneNext'));
		nextButton.setPosition(FlxG.width - nextButton.width - 20, FlxG.height - nextButton.height - 10);
		nextButton.antialiasing = ClientPrefs.globalAntialiasing;
		FlxTween.tween(nextButton, {alpha: 1}, 1, {ease: FlxEase.quartInOut, startDelay: 1});
		add(nextButton);
	}

	var isEnding:Bool = false;
	var nextSelected:Bool = false;

	override function update(elapsed:Float)
	{
		if (!isEnding)
		{	
			if(PlayerSettings.player1.controls.ACCEPT)
				proceedCutscene();

			if (FlxG.mouse.overlaps(nextButton))
			{
				if (!nextSelected)
				{
					nextButton.setGraphicSize(240);
					nextButton.updateHitbox();
					nextButton.offset.set();
				}

				if (FlxG.mouse.justPressed)
					proceedCutscene();

				nextSelected = true;
			}
			else
			{
				nextSelected = false;
				nextButton.setGraphicSize(210);
				nextButton.updateHitbox();
				nextButton.offset.set();
			}
		}

	/*	if (dialogueOpened && !dialogueStarted)
		{
			startDialogue();
			dialogueStarted = true;
		}

		if(PlayerSettings.player1.controls.ACCEPT)
		{
			if (dialogueEnded)
			{
				remove(dialogue);
				if (dialogueList[1] == null && dialogueList[0] != null)
				{
					if (!isEnding)
					{
						isEnding = true;
						FlxG.sound.play(Paths.sound('clickText'), 0.8);	

						if (PlayState.SONG.song.toLowerCase() == 'senpai' || PlayState.SONG.song.toLowerCase() == 'thorns')
							FlxG.sound.music.fadeOut(1.5, 0);

						new FlxTimer().start(0.2, function(tmr:FlxTimer)
						{
							bgFade.alpha -= 1 / 5 * 0.7;
							swagDialogue.alpha -= 1 / 5;
						}, 5);

						new FlxTimer().start(1.5, function(tmr:FlxTimer)
						{
							finishThing();
							kill();
						});
					}
				}
				else
				{
					dialogueList.remove(dialogueList[0]);
					startDialogue();
					FlxG.sound.play(Paths.sound('clickText'), 0.8);
				}
			}
			else if (dialogueStarted)
			{
				FlxG.sound.play(Paths.sound('clickText'), 0.8);
				swagDialogue.skip();
				
				if(skipDialogueThing != null) {
					skipDialogueThing();
				}
			}
		}
		*/
		super.update(elapsed);
	}

	function proceedCutscene()
	{
		FlxG.sound.play(Paths.sound('cutscenes/cutscene-page-flip'), 0.8);	

		playCurrentSound();
		
		var target = cutsceneImages[cutsceneImages.length - 1];
		FlxTween.tween(target, {alpha: 0}, 0.75, {ease: FlxEase.quadInOut, onComplete: function(tween:FlxTween){
			target.destroy();
		}});
		cutsceneImages.pop();
		if (cutsceneImages.length == 0)
		{
			isEnding = true;
			FlxG.sound.music.fadeOut(1.25, 0);
			FlxTween.tween(nextButton, {alpha: 0}, 0.75, {ease: FlxEase.quartInOut});
			FlxG.mouse.visible = false;
			FlxTween.tween(bgFade, {alpha: 0}, 0.75, {startDelay: 0.5, ease: FlxEase.quadInOut, onComplete: function(tween:FlxTween){
				bgFade.destroy();
				finishThing();
				kill();
			}});
		}
	}

	function playCurrentSound()
	{
		if (soundArray[curSound] != '')
			FlxG.sound.play(Paths.sound('cutscenes/' + PlayState.SONG.song.toLowerCase() + "/" + soundArray[curSound]));

		// didnt wanna do it this way dumb lame temp fix for now
		switch (soundArray[curSound])
		{
			case 'tries_to_open_1st':
				FlxG.cameras.shake(0.005, 1);
			case 'tries_to_open_2nd':
				FlxG.cameras.shake(0.01, 0.5);
			case 'opens_it_congrats_dude':
				FlxG.cameras.shake(0.02, 1);
		}
		++curSound;
	}
}