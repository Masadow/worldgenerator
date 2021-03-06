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
	public function mountain() : Int { return 4; }
    public function village() : Int { return 12; }
}

class Tile16 implements ITile
{
	public function new() {}
	
	public function tileset() : String { return "images/tileset16.png"; }
	public function width() : Int { return 16; }
	public function height() : Int { return 16; }

	public function deepOcean() : Int { return 70;}
	public function coast() : Int { return 70;}
	public function sand() : Int { return 51;}
	public function grass() : Int { return 52; }
	public function mountain() : Int { return 16; }
    public function village() : Int { return 74; }
}
