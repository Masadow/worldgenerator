package worldgen;

/**
 * ...
 * @author Masadow
 */
interface ITile
{
	public function tileset() : String;
	public function width() : Int;
	public function height() : Int;

	public function deepOcean() : Int;
	public function coast() : Int;
	public function sand() : Int;
	public function grass() : Int;
	public function mountain() : Int;
    public function village() : Int;
}