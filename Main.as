package {
	import flash.display.*;
	import flash.events.*;
	import flash.utils.*;
	import Enums.*;
	import Screens.*;
	import mochi.as3.*;
	
	public class Main extends MovieClip {
		public var _board:MovieClip = new MovieClip;
		
		public function Main () {
		addChild (_board);
		setTimeout (awd, 1000);
			//NewBigScreen (BigScreenType.Splash);
			NewBigScreen (BigScreenType.Menu);
			//NewBigScreen (BigScreenType.Game);
		}
		
		private function awd () {
			//MochiServices.connect("b7f865eada6ca861", _board);
		}
		
		public function NewBigScreen (screenType:String) {
			if (getChildByName ("bigScreen") != null) {
				var oldScreen:BigScreen = BigScreen (getChildByName ("bigScreen"));
				oldScreen.Deactivate ();
				oldScreen.PrepareToDie ();
				removeChild (oldScreen);
			}
			
			var screenTypes:Array = new Array ("splash", "menu", "game", "gameover");
			var screenClasses:Array = new Array (SplashScreen, MenuScreen, GameScreen, GameOverScreen);
			var screen:BigScreen = new screenClasses [screenTypes.indexOf (screenType)] ();
			screen.name = "bigScreen";
			addChild (screen);
		}
	}
}