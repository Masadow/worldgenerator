package ;
import worldgen.ITile;

/**
 * ...
 * @author Masadow
 */
class Tile implements ITile
{
	public function new() {}
	
	public function tileset() : String { return "images/tileset.png"; }
	public function width() : Int { return 32; }
	public function height() : Int { return 32; }

	public function deepOcean() : Int { return 2;}
	public function coast() : Int { return 1;}
	public function sand() : Int { return 3;}
	public function grass() : Int { return 0; }
	public function mountain() : Int { return 5; }
}