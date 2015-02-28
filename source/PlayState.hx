package;

import flixel.FlxCamera;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.group.FlxGroup;
import flixel.math.FlxAngle;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.math.FlxMath;
import flixel.FlxObject;
import flixel.util.FlxPath;
import openfl.Assets;
import flixel.math.FlxPoint;
import worldgen.noise.PerlinNoise;
import worldgen.World;
import worldgen.Config;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class PlayState extends FlxState
{
	
	private var world : World<Tile>;
	private var dirtyWorld : Bool;
	private var drawVoronoi : Bool;
    private var drawTilemap : Bool;
	
	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		var sincos = FlxAngle.sinCosGenerator();
		
		// Set a background color
		FlxG.cameras.bgColor = 0xff131c1b;
		// Show the mouse (in case it hasn't been disabled)
		#if !FLX_NO_MOUSE
		FlxG.mouse.visible = true;
		#end
        
		super.create();
        
		world = new World<Tile>();

		world.config.layerBounds.width = 400;
		world.config.layerBounds.height = 400;
		world.config.node = 200;
		world.config.lloydIteration = 4;
		world.config.randomness = PSEUDORANDOM;
		var perlin = new PerlinNoise();
		perlin.persistance = 0.1;
		perlin.octave = 7;
		perlin.amplitude = 8;
		perlin.interpolation = CUBIC;
		world.config.noise = perlin;
		world.config.waterLevel = 0.35;

		world.create(12, 12);
		dirtyWorld = true;

//		add(world.tilemap);
		add(world.debugSprite);

		drawVoronoi = false;
        drawTilemap = false;

		add(new FlxText(FlxG.width - 220, 0, 220, "R: Randomize\nI: Zoom In\nO: Zoom Out\nArrow Keys: Move around\nV: Enable/Disable Voronoi\nM: Enable/Disable Tilemap", 12));
		
		Controls.world = world;
		Controls.perlin = perlin;
		add(new FlxText(FlxG.width - 220, 120, 220, "Generator configuration"));
		add(new Control(Controls.changeNode, "Nodes", FlxG.width - 220, 140));
		add(new Control(Controls.changeLloyd, "Lloyd iterations", FlxG.width - 220, 160));
		add(new Control(Controls.changeWaterLevel, "Water level", FlxG.width - 220, 180));
		add(new Control(Controls.changeMountainLevel, "Mountain level", FlxG.width - 220, 200));
		add(new Control(Controls.changeRandomness, "Randomness", FlxG.width - 220, 220));
		add(new FlxText(FlxG.width - 220, 240, 220, "Perlin noise configuration"));
		add(new Control(Controls.changeInterpolation, "Interpolation", FlxG.width - 220, 260));
		add(new Control(Controls.changeAmplitude, "Amplitude", FlxG.width - 220, 280));
		add(new Control(Controls.changeOctave, "Octaves", FlxG.width - 220, 300));
		add(new Control(Controls.changePersistance, "Persistance", FlxG.width - 220, 320));
	}

	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}
	
	override public function draw():Void
	{
		super.draw();

        if (drawTilemap) {
            world.drawTilemap();
        }
		else if (dirtyWorld)
		{
			dirtyWorld = false;
            world.beginDraw();
            world.drawNoise();
            if (drawVoronoi)
                world.drawVoronoi();
		}
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update(elapsed:Float):Void
	{
		super.update(elapsed);

		if (FlxG.keys.pressed.LEFT)
			FlxG.camera.scroll.x -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.RIGHT)
			FlxG.camera.scroll.x += 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.UP)
			FlxG.camera.scroll.y -= 300 * FlxG.elapsed;
		if (FlxG.keys.pressed.DOWN)
			FlxG.camera.scroll.y += 300 * FlxG.elapsed;

		//if (FlxG.keys.pressed.I)
			//FlxG.camera.zoom *= 1.1;
		//if (FlxG.keys.pressed.O)
			//FlxG.camera.zoom /= 1.1;
			
		if (FlxG.keys.justPressed.R)
		{
			dirtyWorld = true;
			world.create(10, 10);
		}
		
		if (FlxG.keys.justPressed.V)
		{
			drawVoronoi = !drawVoronoi;
			dirtyWorld = true;
		}

		if (FlxG.keys.justPressed.M)
		{
            trace("Test");
			drawTilemap = !drawTilemap;
			dirtyWorld = true;
		}
    }
	
}
