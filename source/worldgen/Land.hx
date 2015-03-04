package worldgen;
import com.nodename.delaunay.Voronoi;
import flixel.FlxG;
import flixel.FlxSprite;

/**
 * ...
 * @author Masadow
 */
class Land
{
	private var polygons : Polygons;
	private var tinfo : ITile;
    private var config : Config;
    private var widthInTiles : Int;
    private var heightInTiles : Int;
    private var noise : Array<Array<Float>>;
    private var sprite : FlxSprite; //Sprite use to map voronoi to tiles idx
    private var detailedPolys : Array<Polygon>; //Save this var because it will be destroyed after generation. useful to draw debug only
    public var mapData(default, null) : Array<Int>;

	public function new(world : World, widthInTiles : Int, heightInTiles : Int, polygons : Polygons)
	{
		this.tinfo = world.tinfo;
        this.config = world.config;
        this.polygons = polygons;
        this.widthInTiles = widthInTiles;
        this.heightInTiles = heightInTiles;


        sprite = new FlxSprite();
        sprite.makeGraphic(Std.int(config.layerBounds.width), Std.int(config.layerBounds.height));

	}
    
    public function make2DTerrain() {
        //Need improvement !
        //Actually write the voronoi to a bitmap so we can check which region pixels belongs to
        mapData = new Array<Int>();
        var widthScale : Int = Std.int(config.layerBounds.width / widthInTiles);
        var heightScale : Int = Std.int(config.layerBounds.height / heightInTiles);
        for (tj in 0... heightInTiles) { //for each tiles
            for (ti in 0... widthInTiles) {
                var counters = new Map<Int, Int>();
                for (j in 0...heightScale) {//for pixels in tile
                    for (i in 0...widthScale) {
                        var x : Int = Std.int(ti * (config.layerBounds.width / widthInTiles) + i);
                        var y : Int = Std.int(tj * (config.layerBounds.height / heightInTiles) + j);
                        var pixel = sprite.pixels.getPixel(x, y);
                        if (counters.exists(pixel)) {
                            counters.set(pixel, counters.get(pixel) + 1);
                        }
                        else {
                            counters.set(pixel, 1);
                        }
                    }
                }
                //Most averaged value will constitute the tile value
                var bestKey = counters.keys().next();
                var bestValue = counters[bestKey];
                for (key in counters.keys()) {
                    if (bestValue < counters[key]) {
                        bestKey = key;
                        bestValue = counters[key];
                    }
                }
                mapData.push(bestKey);
            }
        }
    }
    
    public function makeNoise() {
		noise = config.noise.compute(config);
    }

    public function convertNoise() {
        detailedPolys = polygons.detailedPoly();
        for (polygon in detailedPolys)
		{
			if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.mountainLevel)
				polygon.kind = tinfo.mountain();
			else if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.waterLevel)
				polygon.kind = tinfo.grass();
			else if (noise[Std.int(polygon.x)][Std.int(polygon.y)] > config.deepWaterLevel)
				polygon.kind = tinfo.coast();
            //Draw 
            polygon.draw(sprite, tinfo, false);
		}
    }


	public function draw(sprite : FlxSprite)
	{
		for (polygon in detailedPolys)
		{
			polygon.draw(sprite, tinfo);
		}
	}
}