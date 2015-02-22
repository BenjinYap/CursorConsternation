package Screens {
	import flash.display.*;
	import flash.events.*;
	
	public class HelpScreen extends MovieClip {
		
		public function HelpScreen () {
			addEventListener (Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
		
		private function onAdded (e:Event) {
			removeEventListener (Event.ADDED_TO_STAGE, onAdded);
			Activate ();
		}
		
		private function onBackClick (e:MouseEvent) {
			bttBack.removeEventListener (MouseEvent.CLICK, onBackClick);
			Deactivate ();
			Destroy ();
		}
		
		private function Activate () {
			bttBack.addEventListener (MouseEvent.CLICK, onBackClick, false, 0, true);
		}
		
		private function Deactivate () {
		
		}
		
		private function Destroy () {
			parent.removeChild (this);
			dispatchEvent (new Event ("ChildScreenDestroy"));
		}
	}
}