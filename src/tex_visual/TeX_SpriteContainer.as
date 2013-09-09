package tex_visual {
	import com.am_devcorp.mathtricks.mathtricks
	/**
	 * ...
	 * @author Malyavkin Alexey <a@malyavk.in>
	 */
	public class TeX_SpriteContainer {
		private var baseline:int
		public var pieces:Vector.<TeX_Sprite>
		public function TeX_SpriteContainer(vec:Vector.<TeX_Sprite>, baseline:int) {
			this.baseline = baseline
			this.pieces = vec
		}

		public function get aboveBaseline():int {
			return height-baseline
		}
		
		public function get beneathBaseline():int {
			return baseline
		}
		
		public function get height():uint {
			return mathtricks.Max(function (a:TeX_Sprite):uint {
				return a.height+a.position.y
			},pieces) [1]
		}
		public function get width():uint {
			return mathtricks.Max(function (a:TeX_Sprite):uint {
				return a.width+a.position.x
			},pieces) [1]
		}
	}

}