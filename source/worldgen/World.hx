package worldgen;

import com.nodename.delaunay.Voronoi;
import com.nodename.geom.Polygon;
import flash.geom.Point;
import flash.geom.Rectangle;
import flixel.addons.util.FlxAsyncLoop;
import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.input.FlxPointer;
import flixel.math.FlxPoint;
import flixel.math.FlxRandom;
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
	
    public var progressBar : FlxBar;
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
		debugSprite = new FlxSprite();
        villages = new FlxTypedGroup<Village>();
        progressBar = new FlxBar();
        progressBar.setGraphicSize(250, 50);
        step = LAST_STEP + 1;
	}
	
	public function create(width : Int, height : Int, callback : World -> Void = null)
	{
		if (created) {
			destroy();
        }

        progressBar.revive();
        progressBar.setRange(0, LAST_STEP);
        progressBar.value = 0;

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
        FlxG.log.error("Start");
        
        if (!created && step <= LAST_STEP) {
            var back = false;
            switch (step++) {
                case 0:
                    polygons.randomizeNodes();
                    lloydIterations = config.lloydIteration;
                case 1:
                    polygons.generateVoronoi();
                case 2:
                    if (--lloydIterations >= 0) {
                        polygons.smoothRegions();
                        step = 1;
                    }
                case 3:
                    land.makeNoise();
                case 4:
                    land.convertNoise();
                case 5:
                    land.make2DTerrain();
                case 6:
                    tilemap = new FlxTilemap();
                case 7:
                    tilemap.loadMapFromArray(land.mapData, width, height, tinfo.tileset(), tinfo.width(), tinfo.height(), OFF, 0, 0, 0);
                case 8:
                    Village.spawn(this);
                case LAST_STEP:
                    //Game is created, we can remove the progress bar
                    created = true;
                    for (i in this) {
                        i.destroy();
                    }
                    clear();
                    progressBar.kill();
                    add(debugSprite);
                    add(tilemap);
                    add(villages);
                    if (callback != null)
                        callback(this);
            }
            progressBar.value = step;
        }
        
    }
    
    //Function to call when you change tilemap's scale
    public function rescale() {
        tilemap.updateBuffers();
        for (village in villages) {
            village.rescale();
        }
    }

	override public function destroy()
	{
		tilemap.destroy();
		polygons.destroy();
        for (village in villages)
            village.destroy();
        villages.clear();
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