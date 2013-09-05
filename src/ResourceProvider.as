package  {
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Alexey Malyavkin <a@malyavk.in>
	 */
	internal class ResourceProvider {
		
		/**
		 * Hello.
		 * I left this message here to say that
		 * this code below is just a HUGE PILE OF SHIT;
		 * a cancerous tumor of the project.
		 *
		 * I just needed to find a way to keep all resources in one place
		 * to be able to manage and control them at once.
		 *
		 * Please forgive me for such a bad code.
		 */
		
		//raw resources
		[Embed(source="../res/font.png")]
		private static const fontResource:Class;
		[Embed(source="../res/grid.png")]
		private static const gridResource:Class;
		[Embed(source="../res/map.xml",mimeType="application/octet-stream")]
		private static const xmldoc:Class;
		
		//fried resources
		public static var font:BitmapData;
		public static var grid:BitmapData;
		public static var mapping:XML;
		
		//fryin' resources
		public function ResourceProvider() {
			init()
		}
		public static function init():void {
			font = new fontResource().bitmapData;
			grid = new gridResource().bitmapData;
			var x:ByteArray = new xmldoc();
			mapping = new XML(x.readUTFBytes(x.length))
		}
		
	}

}