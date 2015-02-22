package Screens {
	import flash.display.*;
	import flash.events.*;
	
	public class BigScreen extends MovieClip {
		protected var _main:Main;
		
		public function BigScreen () {
			addEventListener (Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
		
		protected function onAdded (e:Event) {
			removeEventListener (Event.ADDED_TO_STAGE, onAdded);
			_main = Main (parent);
		}
		
		public function Initialize () {
		
		}
		
		public function Activate () {
		
		}
		
		public function Deactivate () {
		
		}
		
		public function PrepareToDie () {
		
		}
	}
}