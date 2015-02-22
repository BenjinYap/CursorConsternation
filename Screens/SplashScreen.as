package Screens {
	import flash.display.*;
	import flash.events.*;
	import Enums.*;
	
	public class SplashScreen extends BigScreen {
	
		public function SplashScreen () {
			
		}
		
		protected override function onAdded (e:Event) {
			super.onAdded (e);
			Initialize ();
		}
		
		private function onClick (e:MouseEvent) {
			_main.NewBigScreen (BigScreenType.Menu);
		}
		
		private function onFrame (e:Event) {
			if (currentFrame == totalFrames) {
				_main.NewBigScreen (BigScreenType.Menu);
			}
		}
		
		public override function Initialize () {
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			stage.addEventListener (MouseEvent.CLICK, onClick, false, 0, true);
		}
		
		public override function PrepareToDie () {
			removeEventListener (Event.ENTER_FRAME, onFrame);
			stage.removeEventListener (MouseEvent.CLICK, onClick);
		}
	}
}