package worldgen;

import com.nodename.delaunay.Voronoi;
import com.nodename.geom.Polygon;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.addons.util.FlxAsyncLoop;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
import flixel.text.FlxText;
import flixel.tile.FlxTilemap;
import flixel.FlxSprite;
import flixel.ui.FlxBar;
import flixel.util.FlxColor;
import flixel.util.FlxSpriteUtil;
import flixel.tile.FlxBaseTilemap;
import flixel.FlxBasic;
import flixel.FlxObject;

/**
 * ...
 * @author Masadow
 */
class World extends FlxGroup
{
    private static inline var LAST_STEP = 9;
    
	public var tilemap(default, null) : FlxTilemap;
	public var created(default, null) : Bool;
	
    public var progressBar : FlxSpriteGroup;
    public var _progressBar : FlxBar;
    public var _progressText : FlxText;
	private var polygons : Polygons;
	private var land : Land;
    public var villages : FlxTypedGroup<Village>;
    public var tinfo : ITile;
    
    public var random : FlxRandom;
	
	public var debugSprite(default, null) : FlxSprite;
    
    private var asyncLoop : FlxAsyncLoop;
    
    private var step : Int; //Keep track of the current step during world creation process
    private var lloydIterations : Int;
    private var width : Int;
    private var height : Int;
    private var callback : World -> Void;
    
	/**
	 * Config generator
	 */
	public var config(default, null) : Config;

	public function new(tileInfo : ITile) 
	{
        super();
        random = new FlxRandom();
		created = false;
        tinfo = tileInfo;
		config = new Config();
        progressBar = new FlxSpriteGroup();
        _progressBar = new FlxBar();
        _progressText = new FlxText();
        _progressBar.setGraphicSize(250, 50);
        _progressText.y += 40;
        progressBar.add(_progressBar);
        progressBar.add(_progressText);
        step = LAST_STEP + 1;
	}
	
	public function create(width : Int, height : Int, callback : World -> Void = null)
	{
		if (created) {
			destroy();
        }

        progressBar.revive();
        _progressBar.setRange(0, LAST_STEP);
        _progressBar.value = 0;

        villages = new FlxTypedGroup<Village>();
        debugSprite = new FlxSprite();
		debugSprite.makeGraphic(Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));
			
		var mapData : Array<Int> = new Array<Int>();
        
        step = 0;

		polygons = new Polygons(this);
        land = new Land(this, width, height, polygons);
        
        this.width = width;
        this.height = height;
        this.callback = callback;
//		land = new Land(polygons.detailedPoly(), polygons.voronoi, config, tinfo, width, height);

//        tilemap.loadMapFromArray(land.mapData, width, height, tinfo.tileset(), tinfo.width(), tinfo.height(), OFF, 0, 0, 0);

//        Village.spawn(this);

	}

    override public function update(elapsed:Float) 
    {
        super.update(elapsed);
        
        if (!created && step <= LAST_STEP) {
            var back = false;
            switch (step++) {
                case 0:
                    _progressText.text = "1/" + (LAST_STEP + 1) + " Welcoming God";
                    polygons.randomizeNodes();
                    lloydIterations = config.lloydIteration;
                case 1:
                    _progressText.text = "2/" + (LAST_STEP + 1) + " Doing some weird maths";
                    polygons.generateVoronoi();
                case 2:
                    _progressText.text = "3/" + (LAST_STEP + 1) + " Polishing the mountains";
                    if (--lloydIterations >= 0) {
                        polygons.smoothRegions();
                        step = 1;
                    }
                case 3:
                    _progressText.text = "4/" + (LAST_STEP + 1) + " God have a break";
                    land.makeNoise();
                case 4:
                    _progressText.text = "5/" + (LAST_STEP + 1) + " God try to resume working";
                    land.convertNoise();
                case 5:
                    _progressText.text = "6/" + (LAST_STEP + 1) + " God finally resumed working";
                    land.make2DTerrain();
                case 6:
                    _progressText.text = "7/" + (LAST_STEP + 1) + " Give a toy to God";
                    tilemap = new FlxTilemap();
                case 7:
                    _progressText.text = "8/" + (LAST_STEP + 1) + " Putting silly creations altogether";
                    tilemap.loadMapFromArray(land.mapData, width, height, tinfo.tileset(), tinfo.width(), tinfo.height(), OFF, 0, 0, 0);
                case 8:
                    _progressText.text = "9/" + (LAST_STEP + 1) + " Bringing ugly humans";
                    Village.spawn(this);
                case LAST_STEP:
                    _progressText.text = "10/" + (LAST_STEP + 1) + " Cleaning all that mess";
                    //Game is created, we can remove the progress bar
                    for (i in this) {
                        i.destroy();
                    }
                    clear();
                    progressBar.kill();
                    add(debugSprite);
                    add(tilemap);
                    add(villages);
                    created = true;
                    if (callback != null)
                        callback(this);
            }
            _progressBar.value = step;
        }
        
    }
    
    //Function to call when you change tilemap's scale
    public function rescale() {
        if (created) {
            tilemap.updateBuffers();
            for (village in villages) {
                village.rescale();
            }
        }
    }

	override public function destroy()
	{
		polygons.destroy();
        var f : FlxBasic -> Void = null;
        f = function(bas:FlxBasic) {
            if (Std.is(bas, FlxGroup)) {
                var g : FlxGroup = cast bas;
                g.forEach(f);
            }
            bas.destroy();
        };
        forEach(f);
        clear();
		created = false;
	}

    //Debug from here
	public function beginDraw()
	{
		if (created)
		{
			//Fill with white
			FlxSpriteUtil.fill(debugSprite, FlxColor.WHITE);
		}
	}
	
	public function drawVoronoi()
	{
		if (created)
		{
			polygons.draw(debugSprite);
		}
	}
	
	public function drawNoise()
	{
		if (created)
		{
			land.draw(debugSprite);
		}
	}
}