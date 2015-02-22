package Screens {
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import Enums.*;
	import Game.*;
	import mochi.as3.*;
	
	public class GameOverScreen extends BigScreen {
		
		public function GameOverScreen () {
			
		}
		
		protected override function onAdded (e:Event) {
			super.onAdded (e);
			Initialize ();
			Activate ();
		}
		
		
		private function onMenuClick (e:MouseEvent) {
			_main.NewBigScreen (BigScreenType.Menu);
		}
		
		public override function Initialize () {
addChild (_main._board);
			
			
var o:Object = { n: [2, 4, 9, 0, 5, 8, 4, 9, 3, 15, 1, 1, 10, 0, 6, 6], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
var boardID:String = o.f(0,"");
//MochiScores.showLeaderboard({boardID: boardID, score: GameData.score});
		}
		
		public override function Activate () {
			
			bttMenu.addEventListener (MouseEvent.CLICK, onMenuClick, false, 0, true);
		}
		
		public override function Deactivate () {
		
			bttMenu.removeEventListener (MouseEvent.CLICK, onMenuClick);
		}
	}
}