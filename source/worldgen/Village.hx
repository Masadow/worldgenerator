package worldgen;
import flixel.math.FlxPoint;

/**
 * ...
 * @author Masadow
 */
class Village
{
    
    public static function isBuildable(tile : Int, tinfo : ITile) {
        return tile == tinfo.grass();
    }
    
    public static function spawn(world : World) : Array<Village> {
        var villages = new Array<Village>();
        var mapData = world.tilemap.getData();
        for (i in 0...mapData.length) {
            if (isBuildable(mapData[i], world.tinfo) && Math.random() < world.config.villages.spawnRate) {
                var x = i % world.tilemap.widthInTiles;
                var y = Math.floor(i / world.tilemap.widthInTiles);
                if (Helper.checkTilesInCircle(x, y, world.config.villages.minDistance, function (x, y) {
                    return world.tilemap.getTile(x, y) != world.tinfo.village();
                }))
                    villages.push(new Village(world, new FlxPoint(x, y)));
            }
        }
        return villages;
    }
   
    //World coordinates of the village
    private var worldPos : FlxPoint;

    public function new(world : World, coords : FlxPoint)
    {
        worldPos = coords;
        world.tilemap.setTile(Std.int(coords.x), Std.int(coords.y), world.tinfo.village());
    }
    
}