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
		
		private function onGetHiscoreComplete (e:Event) {
			mcTopPlayerLoading.visible = false;
			var name:String = e.target.data.substr (0, e.target.data.indexOf (","));
			var score:String = Number (e.target.data.substr (e.target.data.indexOf (",") + 1)).toFixed (0).toString ();
			txtTopPlayer.text = name + "   " + score;
		}
		
		private function onSubmitComplete (e:Event) {
			mcSubmitLoading.visible = false;
		
			if (e.target.data.indexOf ("success") != -1) {
				txtResult.text = "You are #" + e.target.data.replace ("success", "") + " in the hiscores!";
			} else if (e.target.data == "error") {
				txtResult.text = "An error has occured!";
			} else if (e.target.data.indexOf ("error") != -1) {
				txtResult.text = "You need a score of " + e.target.data.replace ("error", "") + "!";
			}
		}
		
		private function onSubmitClick (e:MouseEvent) {
			if (txtName.text.length > 0) {
				bttSubmit.visible = false;
				txtName.visible = false;
				mcSubmitLoading.visible = true;
			
				var vars:URLVariables = new URLVariables ();
				vars.reason = "set";
				vars.player = txtName.text;
				vars.score = GameData.score.toFixed (5);
				
				var req:URLRequest = new URLRequest ("http://benjyap_99k@benjyap.99k.org/Cursor Consternation/cursor_hiscores.php");
				req.method = URLRequestMethod.POST;
				req.data = vars;
				
				var loader:URLLoader = new URLLoader (req);
				loader.addEventListener (IOErrorEvent.IO_ERROR, onSubmitError, false, 0, true);
				loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onSubmitError, false, 0, true);
				loader.addEventListener (Event.COMPLETE, onSubmitComplete, false, 0, true);
				loader.load (req);
			}
		}
		
		private function onGetHiscoreError (e:Event) {
			mcTopPlayerLoading.visible = false;
			txtTopPlayer.text = "An error has occured!";
		}
		
		private function onSubmitError (e:Event) {
			mcSubmitLoading.visible = false;
			txtResult.text = "An error has occured!";
		}
		
		private function onMenuClick (e:MouseEvent) {
			_main.NewBigScreen (BigScreenType.Menu);
		}
		
		public override function Initialize () {
			txtScore.visible = false;
			txtName.visible = false;
			txtResult.visible = false;
			mcTopPlayerLoading.visible = false;
			mcSubmitLoading.visible = false;
		
			txtScore.text = GameData.score.toFixed (0).toString ();
			txtName.restrict = "a-zA-Z0-9";
			mcSubmitLoading.visible = false;
			
			txtName.border = true;
			txtName.borderColor = 0x990000;
			
			var vars:URLVariables = new URLVariables ();
			vars.reason = "get";
			var req:URLRequest = new URLRequest ("http://benjyap_99k@benjyap.99k.org/Cursor Consternation/cursor_hiscores.php");
			req.method = URLRequestMethod.POST;
			req.data = vars;
			var loader:URLLoader = new URLLoader (req);
			loader.addEventListener (IOErrorEvent.IO_ERROR, onGetHiscoreError, false, 0, true);
			loader.addEventListener (SecurityErrorEvent.SECURITY_ERROR, onGetHiscoreError, false, 0, true);
			loader.addEventListener (Event.COMPLETE, onGetHiscoreComplete, false, 0, true);
			loader.load (req);
			
			MochiServices.connect("b7f865eada6ca861", this);
			
var o:Object = { n: [2, 4, 9, 0, 5, 8, 4, 9, 3, 15, 1, 1, 10, 0, 6, 6], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
var boardID:String = o.f(0,"");
MochiScores.showLeaderboard({boardID: boardID, score: GameData.score});
		}
		
		public override function Activate () {
			bttSubmit.addEventListener (MouseEvent.CLICK, onSubmitClick, false, 0, true);
			bttMenu.addEventListener (MouseEvent.CLICK, onMenuClick, false, 0, true);
		}
		
		public override function Deactivate () {
			bttSubmit.removeEventListener (MouseEvent.CLICK, onSubmitClick);
			bttMenu.removeEventListener (MouseEvent.CLICK, onMenuClick);
		}
	}
}