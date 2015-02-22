package Screens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	import flash.ui.*;
	import flash.media.*;
	import flash.system.*;
	import Game.*;
	import Enums.*;
	
	public class GameScreen extends BigScreen {	
		private var _blockGen:BlockGenerator = new BlockGenerator ();
		
		private var _soundMg:SoundManager = new SoundManager ();
		
		private var _fakeCursors:FakeCursors = new FakeCursors ();
		
		private var _lastCursorPoint:Point = new Point (175, 275);
		
		private var _cheatingSeconds:Number = 20;
		private var _cheatingFrames:Number = _cheatingSeconds * 30;
		
		private var _dialogLeft:String = "";
		private var _dialogStayFrames:Number = 0;
		
		private var _hideSeconds:Number = 2;
		private var _hideFrames:Number = _hideSeconds * 30;
		private var _hiding:Boolean = false;
		private var _hideRechargeSeconds:Number = 10;
		private var _hideRecharging:Boolean = false;
		
		private var _gameStarted:Boolean = false;
		private var _gameOver:Boolean = false;
		
		private var _music:SoundChannel;
		private var _musicPosition:Number = 0;
		
		private var _checkCollisionCounter:Number = 0;
		
		private var _aaa:Number = 0;
		
		public function GameScreen () {
			var timer:Timer = new Timer (1, 0);
			timer.addEventListener (TimerEvent.TIMER, dwa);
			//timer.start ();
		}
		
		private function dwa (e:TimerEvent) {
			//mcCursor.x = mouseX;
			//	mcCursor.y = mouseY;
			//	mcHideBar.x = mouseX;
			//	mcHideBar.y = mouseY;
		}
		
		protected override function onAdded (e:Event) {
			super.onAdded (e);
			Initialize ();
			mcStartRegion.addEventListener (MouseEvent.MOUSE_OVER, onStartRegionOver, false, 0, true);
		}
		
		private function onFrame (e:Event) {
			Mouse.hide ();
			
			if (_gameOver == false) {
				var blocks:Array = _blockGen.GetBlocks ();
				
				if (blocks [blocks.length - 1].y >= -22) {
					var blocksToRemove:Array = _blockGen.DestroyOldPath ();
					
					/*while (blocksToRemove.length > 0) {
						//removeChild (blocksToRemove [0]);
						blocksToRemove.splice (0, 1);
					}*/
					
					_blockGen.CreateMainPath ();
					_blockGen.CreateFakePaths ();
					
					blocks = _blockGen.GetBlocks ();
					
					for (var i = 0; i < blocks.length; i++) {
						if (blocks [i].parent == null) {
							addChildAt (blocks [i], 1);
							blocks [i].visible = false;
						}
					}
				}
				
				blocks = _blockGen.GetBlocks ();
				
				for (var i = 0; i < blocks.length; i++) {
					blocks [i].y += GameData.speed;
					
					if (blocks [i].y > 450 && blocks [i].parent == this) {
						//blocks [i].visible = false;
						removeChild (blocks [i]);
					} else if (blocks [i].y > -100 && blocks [i].visible == false) {
						blocks [i].visible = true;
					}
				}
				
				if (mcCursor.currentLabel == "Idle") {
					var mult:Number = (402 - stage.mouseY) / 402 + 1;
					GameData.score += mult;
					txtMult.text = "x" + mult.toFixed (1).toString ();
					txtScore.text = Math.floor (GameData.score).toString ();
					
					if (GameData.scoreMilestones.length > 0) {
						if (GameData.score >= GameData.scoreMilestones [0]) {
							if (GameData.hasSound) {
								_soundMg.PlayNewSound (new snd_cursorLevelUp ());
							}
							
							if (GameData.blockFrames < GameData.frameMilestones [0]) {
								mcLevelBar.gotoAndPlay ("Level");
								GameData.blockFrames = GameData.frameMilestones [0];
							}
							
							if (GameData.speed < GameData.speedMilestones [0]) {
								mcLevelBar.gotoAndPlay ("Level");
								GameData.speed = GameData.speedMilestones [0];
							}
							
							if (GameData.specialMilestones [0] == "fog") {
								mcFog.gotoAndPlay ("Show");
							}
							
							if (GameData.milestoneDialogs [0].length > 0) {
								SetDialog (GameData.milestoneDialogs [0]);
							}
							
							GameData.scoreMilestones.splice (0, 1);
							GameData.frameMilestones.splice (0, 1);
							GameData.specialMilestones.splice (0, 1);
							GameData.milestoneDialogs.splice (0, 1);
							GameData.speedMilestones.splice (0, 1);
						}
					}
				}
				
				mcCursor.x = mouseX;
				mcCursor.y = mouseY;
				mcHideBar.x = mouseX;
				mcHideBar.y = mouseY;
				
				if (mcCursor.currentLabel == "Idle") {
					_checkCollisionCounter++;
					
					if (_checkCollisionCounter == 1) {
						CheckCollisions ();
						CheckCheating ();
						_checkCollisionCounter = 0;
					}
				}
				
				_lastCursorPoint = new Point (mouseX, mouseY);
				
				if (_hiding) {
					if (_hideFrames > 0) {
						_hideFrames--;
					} else {
						_hiding = false;
						_hideRecharging = true;
						
						if (GameData.hasSound) {
							_soundMg.PlayNewSound (new snd_cursorShow ());
						}
						
						mcHideBar.visible = false;
						mcCursor.gotoAndPlay ("Show");
					}
				}
				
				if (_hideRecharging) {
					if (_hideFrames < _hideRechargeSeconds * 30) {
						_hideFrames++;
					} else {
						_hideFrames = _hideSeconds * 30;
						_hideRecharging = false;
						mcHideIcon.visible = true;
					}
				}
			}
			
			if (_dialogLeft.length > 0) {
				mcDialog.visible = true;
				mcDialog.txtText.appendText (_dialogLeft.charAt (0));
				_dialogLeft = _dialogLeft.substr (1);
			} else {
				if (_dialogStayFrames <= 0) {
					mcDialog.visible = false;
					
					if (_gameOver) {
						Deactivate ();
						_main.NewBigScreen (BigScreenType.GameOver);
					}
				} else {
					_dialogStayFrames--;
				}
			}
		}
		
		private function CheckCollisions () {
			var blocksToCheck:Array = new Array ();
			var firstPoint:Point = _lastCursorPoint;
			
			blocksToCheck.push (GetBlockUnderPoint (firstPoint));
			
			var lastPoint:Point = new Point (mouseX, mouseY);
			var pathToCheck:Sprite = new Sprite ();
			
			for (var i = 1; i < 10; i++) {
				var interPoint:Point = Point.interpolate (firstPoint, lastPoint, i / 10);
				var testBlock:MovieClip = GetBlockUnderPoint (interPoint);
				
				if (blocksToCheck.indexOf (testBlock) == -1) {
					blocksToCheck.push (testBlock);
				}
			}
			
			for (var i = 0; i < blocksToCheck.length; i++) {
				var block:MovieClip = new _mcBlock ();
				block.x = testBlock.x;
				block.y = testBlock.y;
				block.gotoAndStop (testBlock.currentFrame);
				var shape:Shape = Shape (block.getChildAt (1));
				shape.x = block.x;
				shape.y = block.y;
				pathToCheck.addChild (shape);
			}
			
			addChild (pathToCheck);
			
			if (pathToCheck.hitTestPoint (mouseX, mouseY, true)) {         //If new point hits the wall
				GameOver ();
			} else {                                                                           //If not, check starting from the last point to the new point
				var angle:Number = Math.atan2 (mouseY - _lastCursorPoint.y, mouseX - _lastCursorPoint.x);
				
				for (var i = 0; i < 500; i += 2) {
					var interPoint:Point = new Point (_lastCursorPoint.x + i * Math.cos (angle), _lastCursorPoint.y + i * Math.sin (angle));
					
					//If you checked beyond the current point, stop checking
					if (Point.distance (new Point (mouseX, mouseY), interPoint) > Point.distance (new Point (mouseX, mouseY), _lastCursorPoint)) {
						break;
					}
					
					if (pathToCheck.hitTestPoint (interPoint.x, interPoint.y, true)) {
						mcCursor.x = interPoint.x;
						mcCursor.y = interPoint.y;
						GameOver ();
						break;
					}
				}
			}
			
			removeChild (pathToCheck);
		}
		
		private function CheckCheating () {
			if (_lastCursorPoint.x == mcCursor.x && _lastCursorPoint.y == mcCursor.y) {   //If cursor hasn't moved
				_cheatingFrames--;
				
				if (_cheatingFrames <= 0) {                                                           //If cursor hasn't moved for number of seconds, cheating
					GameOver ();
				}
			} else {                                                                                  //If cursor moved
				_cheatingFrames = _cheatingSeconds * 30;                                                  //Reset cheating time
			}
		}
		
		private function GetBlockUnderPoint (point:Point):MovieClip {
			var column:Number = Math.floor (point.x / 50);
			var block:MovieClip;
			var blocks:Array = _blockGen.GetBlocks ();
			
			for (var i = 0; i < (_blockGen._maxRows + 1) * 2; i++) {
				block = blocks [i * _blockGen._blocksPerRow + column];
				
				if (block != null) {
					var rect:Rectangle = new Rectangle (block.x - 25, block.y - 25, 50, 50);
					
					if (rect.containsPoint (point)) {
						break;
					}
				}
			}
			
			return block;
		}
		
		private function SetDialog (dialog:String) {
			if (GameData.hasSound) {
				_soundMg.PlayNewSound (new snd_cpuSound ());
			}
			
			_dialogLeft = dialog;
			_dialogStayFrames = 60;
			mcDialog.txtText.text = "";
		}
		
		private function GameOver () {
			_gameOver = true;
			
			_music.stop ();
			
			if (GameData.hasSound) {
				_soundMg.PlayNewSound (new snd_cursorDie ());
			}
			
			mcCursor.gotoAndPlay ("Die");
			SetDialog ("CPU: Cursor eliminated.");
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		private function onStartRegionOver (e:MouseEvent) {
			if (_gameStarted == false) {
				txtStart.visible = false;
				SetDialog ("CPU: Cursors elimination process activated.");
				_gameStarted = true;
			}
			
			_music = new snd_cursorMusic ().play (_musicPosition);
			_music.addEventListener (Event.SOUND_COMPLETE, onMusicLoopComplete, false, 0, true);
			
			if (GameData.hasSound) {
					
			} else {
				var st:SoundTransform = new SoundTransform ();
				st.volume = 0;
				_music.soundTransform = st;
			}
			
			Activate ();
		}
		
		private function onMusicLoopComplete (e:Event) {
			_music.removeEventListener (Event.SOUND_COMPLETE, onMusicLoopComplete);
			_music = new snd_cursorMusic ().play ();
			
			if (GameData.hasSound) {
					
			} else {
				var st:SoundTransform = new SoundTransform ();
				st.volume = 0;
				_music.soundTransform = st;
			}
			
			_music.addEventListener (Event.SOUND_COMPLETE, onMusicLoopComplete, false, 0, true);
		}
		
		private function onKeyDown (e:KeyboardEvent) {
			if (e.keyCode == Keyboard.ESCAPE) {
				Deactivate ();
				var ps:PauseScreen = new PauseScreen ();
				ps.Initialize ();
				ps.addEventListener ("ChildScreenDestroy", onChildScreenDestroy, false, 0, true);
				addChild (ps);
			} else if (e.keyCode == Keyboard.SPACE) {
				if (_hideRecharging == false && _hideFrames == _hideSeconds * 30) {
					_hiding = true;
					
					if (GameData.hasSound) {
						_soundMg.PlayNewSound (new snd_cursorHide ());
					}
					
					mcHideBar.visible = true;
					mcHideBar.gotoAndPlay (1);
					mcCursor.gotoAndPlay ("Hide");
					mcHideIcon.visible = false;
				}
			}
		}
		
		private function onChildScreenDestroy (e:String) {			
			mcStartRegion.addEventListener (MouseEvent.MOUSE_OVER, onStartRegionOver, false, 0, true);
			stage.focus = stage;
			
			var blocks:Array = _blockGen.GetBlocks ();
			
			for (var i = 0; i < blocks.length; i++) {
				var ct:ColorTransform = new ColorTransform ();
				ct.color = GameData.wallColor;
				blocks [i].lines.transform.colorTransform = ct;
			}
		}
		
		public override function Initialize () {
			txtStart.background = true;
			txtStart.backgroundColor = 0x000000;
			
			stage.focus = stage;
			
			graphics.lineStyle (1, 0x003300);
			graphics.moveTo (0.5, 0);
			graphics.lineTo (0.5, 502);
			graphics.moveTo (_blockGen._blocksPerRow * 50 + 0.5, 0);
			graphics.lineTo (_blockGen._blocksPerRow * 50 + 0.5, 502);

			_blockGen.Initialize ();
			
			var blocks:Array = _blockGen.GetBlocks ();
			
			for (var i = 0; i < blocks.length; i++) {
				addChildAt (blocks [i], 1);
			}
			
			mcHideIcon.gotoAndStop (1);
			
			mcCursor.x = 175;
			mcCursor.y = 375;
			addChildAt (mcCursor, numChildren - 9);
			
			mcDialog.visible = false;
			mcDialog.txtText.text = "";
			
			mcHideBar.visible = false;
			
			var cm:ContextMenu = new ContextMenu ();
			cm.hideBuiltInItems ();
			contextMenu = cm;
		}
		
		public override function Activate () {
			mcStartRegion.removeEventListener (MouseEvent.MOUSE_OVER, onStartRegionOver);
			mcStartRegion.visible = false;
			Mouse.hide ();
			_soundMg.ResumeAllSounds ();
			mcHideIcon.play ();
			mcHideBar.play ();
			
			if (mcLevelBar.currentLabel == "Level") {
				mcLevelBar.play ();
			}
			
			if (mcCursor.currentLabel == "Show" || mcCursor.currentLabel == "Hide") {
				mcCursor.play ();
			}
			
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
			stage.addEventListener (KeyboardEvent.KEY_DOWN, onKeyDown, false, 0, true);
		}
		
		public override function Deactivate () {
			mcStartRegion.addEventListener (MouseEvent.MOUSE_OVER, onStartRegionOver, false, 0, true);
			mcStartRegion.x = mcCursor.x;
			mcStartRegion.y = mcCursor.y
			mcStartRegion.visible = true;
			_musicPosition = _music.position;
			_music.stop ();
			Mouse.show ();
			_soundMg.PauseAllSounds ();
			mcHideIcon.stop ();
			mcHideBar.stop ();
			mcLevelBar.stop ();
			mcCursor.stop ();
			removeEventListener (Event.ENTER_FRAME, onFrame);
			stage.removeEventListener (KeyboardEvent.KEY_DOWN, onKeyDown);
		}
		
		public override function PrepareToDie () {
			_soundMg.StopAllSounds ();
			mcStartRegion.removeEventListener (MouseEvent.MOUSE_OVER, onStartRegionOver);
			mcStartRegion.visible = false;
		}
	}
}