package;

import flixel.FlxBasic;
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
	
	private var world : World;
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

		world = new World(new Tile());

		world.config.layerBounds.width = 640;
		world.config.layerBounds.height = 640;
		world.config.node = 200;
		world.config.lloydIteration = 4;
		world.config.randomness = PSEUDORANDOM;
		var perlin = new PerlinNoise();
		perlin.persistance = 0.1;
		perlin.octave = 7;
		perlin.amplitude = 8;
		perlin.interpolation = CUBIC;
		world.config.noise = perlin;
        world.config.villages.nameBank = [
            "Paris",
            "Dublin",
            "London",
            "Madrid",
            "Bordeaux",
            "Munich",
            "Montreal",
            "New York",
            "San Francisco",
            "Amsterdam",
            "Rome"
        ];
        world.config.villages.shape = RANDOM;

		world.create(100, 100);
//        world.scale.set(0.46875, 0.46875);
		dirtyWorld = true;

        world.tilemap.scale.x = 0.5;
        world.tilemap.scale.y = 0.5;
//		add(world.tilemap);
//		add(world.debugSprite);

		drawVoronoi = false;
        drawTilemap = true;
        
        var hud = new FlxGroup();
        
        var hudBG = new FlxSprite();
        hudBG.makeGraphic(220, FlxG.height, 0xff131c1b);
        hud.add(hudBG);

		hud.add(new FlxText(0, 0, 220, "R: Randomize\nI/O: Zoom In/Out\nArrow Keys: Move around\nV: Enable/Disable Voronoi\nM: Enable/Disable Tilemap\nV: Enable/Disable cities", 12));
		
		Controls.world = world;
		Controls.perlin = perlin;
		hud.add(new FlxText(0, 120, 220, "Generator configuration"));
		hud.add(new Control(Controls.changeNode, "Nodes", 0, 140));
		hud.add(new Control(Controls.changeLloyd, "Lloyd iterations", 0, 160));
		hud.add(new Control(Controls.changeWaterLevel, "Water level", 0, 180));
		hud.add(new Control(Controls.changeDeepWaterLevel, "Deep Water level", 0, 200));
		hud.add(new Control(Controls.changeMountainLevel, "Mountain level", 0, 220));
		hud.add(new Control(Controls.changeRandomness, "Randomness", 0, 240));
		hud.add(new FlxText(0, 260, 220, "Perlin noise configuration"));
		hud.add(new Control(Controls.changeInterpolation, "Interpolation", 0, 280));
		hud.add(new Control(Controls.changeAmplitude, "Amplitude", 0, 300));
		hud.add(new Control(Controls.changeOctave, "Octaves", 0, 320));
		hud.add(new Control(Controls.changePersistance, "Persistance", 0, 340));
		hud.add(new FlxText(0, 360, 220, "Cities configuration"));
		hud.add(new Control(Controls.changeMinDistance, "Min distance", 0, 380));
		hud.add(new Control(Controls.changeMinSize, "Min size", 0, 400));
		hud.add(new Control(Controls.changeMaxSize, "Max size", 0, 420));
		hud.add(new Control(Controls.changeSpawnRate, "Spawn rate", 0, 440));
		hud.add(new Control(Controls.changeShape, "Shape", 0, 460));

        var f : FlxBasic -> Void = null;
        f = function(bas:FlxBasic) {
            if (Std.is(bas, FlxGroup)) {
                var g : FlxGroup = cast bas;
                g.forEach(f);
            }
            else {
                var spr : FlxObject = cast bas;
                spr.scrollFactor.set();
                spr.x += FlxG.width - 220;
            }
        };
        hud.forEach(f);
        
        add(world);
        add(hud);
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
//            world.drawTilemap();
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

		if (FlxG.keys.pressed.I) {
			world.tilemap.scale.x *= 1.1;
			world.tilemap.scale.y *= 1.1;
        }
		if (FlxG.keys.pressed.O) {
			world.tilemap.scale.x /= 1.1;
			world.tilemap.scale.y /= 1.1;
        }
			
		if (FlxG.keys.justPressed.R)
		{
			dirtyWorld = true;
			world.create(100, 100);
		}
		
		if (FlxG.keys.justPressed.V)
		{
			drawVoronoi = !drawVoronoi;
			dirtyWorld = true;
		}

		if (FlxG.keys.justPressed.M)
		{
            world.tilemap.visible = !world.tilemap.visible;
//			drawTilemap = !drawTilemap;
			dirtyWorld = true;
		}
        
        if (FlxG.keys.justPressed.C) {
            world.config.villages.enable = !world.config.villages.enable;
        }
    }
	
}
