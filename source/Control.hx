package ;
import flixel.addons.ui.FlxButtonPlus;
import flixel.group.FlxGroup;
import flixel.text.FlxText;
import flixel.ui.FlxButton;

/**
 * ...
 * @author Masadow
 */
class Control extends FlxGroup
{
	private var rcv : Int -> String;
	private var valueDisplay : FlxText;

	public function new(event : Int -> String, key : String, x : Int, y : Int)
	{
		super();

		rcv = event;
		add(new FlxText(x, y, 80, key));
		valueDisplay = new FlxText(x + 80, y, 90, event(0));
		add(valueDisplay);

		add(new FlxButtonPlus(x + 170, y, plus, "+", 25));
		add(new FlxButtonPlus(x + 195, y, minus, "-", 25));
	}
	
	public function plus()
	{
		valueDisplay.text = rcv(1);
	}
	
	public function minus()
	{
		valueDisplay.text = rcv(-1);
	}
}