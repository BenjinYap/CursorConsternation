package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	public class FakeCursors extends MovieClip {
		
		public function FakeCursors () {
			
		}
		
		private function onFrame (e:Event) {
			
		}
		
		public function Initialize () {
			
		}
		
		public function Activate () {
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
		}
		
		public function Deactivate () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
		}
	}
}