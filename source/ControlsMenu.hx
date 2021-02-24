package;

import Controls.Control;
import flash.text.TextField;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.addons.display.FlxGridOverlay;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.input.keyboard.FlxKey;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import flixel.util.FlxColor;
import lime.utils.Assets;
import sys.io.File;
import extype.OrderedMap;

class ControlsMenu extends MusicBeatState
{
	var selector:FlxText;
	var curSelected:Int = 0;
	var past:Float = 0;

	var controlMap:OrderedMap<String, String> = new OrderedMap<String, String>();
	var controlOrder:Array<String> = [];

	private var grpControls:FlxTypedGroup<Alphabet>;

	override function create()
	{
		var menuBG:FlxSprite = new FlxSprite().loadGraphic('assets/images/menuDesat.png');
		controlMap = CoolUtil.cMapFromSArray(CoolUtil.coolTextFile('assets/data/controls.txt'));
		menuBG.color = 0xFFea71fd;
		menuBG.setGraphicSize(Std.int(menuBG.width * 1.1));
		menuBG.updateHitbox();
		menuBG.screenCenter();
		menuBG.antialiasing = true;
		add(menuBG);

		grpControls = new FlxTypedGroup<Alphabet>();
		add(grpControls);

		var y:Int = 0;
		for (ctrl => bind in controlMap)
		{
			var controlLabel:Alphabet = new Alphabet(0, (70 * y) + 30, ctrl + ': ' + bind, true, false);
			controlLabel.isMenuItem = true;
			controlLabel.targetY = y;
			grpControls.add(controlLabel);
			y++;
			// DONT PUT X IN THE FIRST PARAMETER OF new ALPHABET() !!
		}

		super.create();
	}

	override function update(elapsed:Float)
	{
		super.update(elapsed);
		past += elapsed;

		if (isSettingControl && (past - timeOfKeyBindN) > 0.2)
			waitingInput();
		else
		{
			if (controls.ACCEPT)
				changeBinding();
			if (controls.BACK) {
				File.saveContent("assets/data/controls.txt", CoolUtil.cStringFromMap(controlMap));
				FlxG.switchState(new OptionsMenu());
			}	
			if (controls.UP_P)
				changeSelection(-1);
			if (controls.DOWN_P)
				changeSelection(1);
		}
	}

	var isSettingControl:Bool = false;
	var timeOfKeyBindN:Float;

	function waitingInput():Void
	{
		if (FlxG.keys.getIsDown().length > 0)
		{
			/* for (i in grpControls.iterator()) { // generating array of control names
				var y:Int = 0;
				var funnyArray:Array<String> = i.text.split(": ");
				var ctrl:String = funnyArray[0];
				var bind:String = funnyArray[1];
				controlOrder[y] = ctrl;
				y++;
			} */
			for (a in grpControls.iterator()) {
				var funnyArray:Array<String> = a.text.split(": ");
				var ctrl:String = funnyArray[0];
				var bind:String = funnyArray[1];

				if (a.targetY == 0) {
					trace(CoolUtil.parseControlString(ctrl) + " is now bound to " + FlxG.keys.getIsDown()[0].ID);
					isSettingControl = false;
					timeOfKeyBindN = 0;
					var controlLabel:Alphabet = new Alphabet(0, 0, CoolUtil.parseControlString(ctrl) + ': ' + FlxG.keys.getIsDown()[0].ID, true, false);
					controlLabel.isMenuItem = true;
					controlLabel.targetY = 0;
					PlayerSettings.player1.controls.replaceBinding(CoolUtil.parseControlString(ctrl), Keys, FlxG.keys.getIsDown()[0].ID, FlxKey.fromString(bind));
					grpControls.replace(a, controlLabel);
					controlMap.set(ctrl, FlxG.keys.getIsDown()[0].ID);
					break;
				}	
			}
		}
		// PlayerSettings.player1.controls.replaceBinding(Control)
	}

	function changeBinding():Void
	{
		if (!isSettingControl)
		{
			isSettingControl = true;
			timeOfKeyBindN = past;
		}
	}

	function changeSelection(change:Int = 0)
	{
		FlxG.sound.play('assets/sounds/scrollMenu' + TitleState.soundExt, 0.4);

		curSelected += change;

		if (curSelected < 0)
			curSelected = grpControls.length - 1;
		if (curSelected >= grpControls.length)
			curSelected = 0;


		// selector.y = (70 * curSelected) + 30;

		var bullShit:Int = 0;

		for (item in grpControls.members)
		{
			item.targetY = bullShit - curSelected;
			bullShit++;

			item.alpha = 0.6;
			// item.setGraphicSize(Std.int(item.width * 0.8));

			if (item.targetY == 0)
			{
				item.alpha = 1;
				// item.setGraphicSize(Std.int(item.width));
			}
		}
	}
}
