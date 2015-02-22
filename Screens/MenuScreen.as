package Screens {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import Enums.*;
	import Screens.*;
	import Game.*;
	
	public class MenuScreen extends BigScreen {
	
		public function MenuScreen () {
		
		}
		
		protected override function onAdded (e:Event) {
			super.onAdded (e);
			Activate ();
		}
		
		private function onBttClick (e:MouseEvent) {
			switch (e.target.name) {
				case "bttPlay":
					GameData.Reset ();
					_main.NewBigScreen (BigScreenType.Game);
					break;
				case "bttHelp":
					Deactivate ();
					var hs:HelpScreen = new HelpScreen ();
					hs.addEventListener ("ChildScreenDestroy", onChildScreenDestroy, false, 0, true);
					addChild (hs);
					break;
				case "bttMe":
					navigateToURL (new URLRequest ("http://www.benjyap.99k.org"));
					break;
			}
		}
		
		private function onChildScreenDestroy (e:String) {
			Activate ();
		}
		
		public override function Activate () {
			var btts:Array = new Array (bttPlay, bttHelp, bttMe);
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].addEventListener (MouseEvent.CLICK, onBttClick, false, 0, true);
			}
		}
		
		public override function Deactivate () {
			var btts:Array = new Array (bttPlay, bttHelp);
			
			for (var i = 0; i < btts.length; i++) {
				btts [i].removeEventListener (MouseEvent.CLICK, onBttClick);
			}
		}
	}
}