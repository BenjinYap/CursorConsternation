package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	
	public class BlockGenerator {
		public var _blocksPerRow:Number = 7//7;
		public var _maxRows:Number = 8//8;
		private var _blocks:Array = new Array (_blocksPerRow * (_maxRows + 1) * 2);
		private var _testBlocks:Array = new Array (_blocksPerRow * (_maxRows + 1) * 2);
		private var _lastOpenIndex:Number;
		private var _mainBlockIndexes:Array = new Array ();
		private var _redoPath:Boolean = false;
		
		public function BlockGenerator () {
		
		}
		
		private function CreateMainBlock (currentIndex:Number) {
			var block:MovieClip = new _mcBlock ();
			block.x = currentIndex % _blocksPerRow * 50 + 25 + 0.5;
			block.y = _maxRows * 50 - Math.floor (currentIndex / _blocksPerRow) * 50 - 25 + 1 + 2;
			_testBlocks [currentIndex] = block;
			var blockInvalid:Boolean = true;
			var validOpenings:String = "";
			
			while (true) {
				block.gotoAndStop (Math.floor (Math.random () * GameData.blockFrames) + 1);
				
				if (IsBlockConnected (block, currentIndex, _lastOpenIndex, _testBlocks) == true) {
					validOpenings = GetBlockOpenings (block, currentIndex, _testBlocks);
					
					if (validOpenings.length == 0) {
						_redoPath = true;
					}
					
					break;
				}
			}
			
			block.lines.gotoAndStop (block.currentFrame);
			var ct:ColorTransform = new ColorTransform ();
			ct.color = GameData.wallColor;
			block.lines.transform.colorTransform = ct;
			
			if (_redoPath == false) {
				_lastOpenIndex = currentIndex;
				_mainBlockIndexes.push (currentIndex);
				var nextDirection:String = validOpenings.charAt (Math.floor (Math.random () * validOpenings.length));
			
				if (nextDirection == "l") {
					CreateMainBlock (currentIndex - 1);
				} else if (nextDirection == "r") {
					CreateMainBlock (currentIndex + 1);
				} else if (nextDirection == "t") {
					if (Math.floor (currentIndex / _blocksPerRow) < (_maxRows + 1) * 2 - 1) {
						CreateMainBlock (currentIndex + _blocksPerRow);
					}
				} else if (nextDirection == "b") {
					CreateMainBlock (currentIndex - _blocksPerRow);
				}
			}
		}
		
		private function CreateFakeBlock (currentIndex:Number, lastIndex:Number) {
			var block:MovieClip = new _mcBlock ();
			block.x = currentIndex % _blocksPerRow * 50 + 25 + 0.5;
			block.y = _maxRows * 50 - Math.floor (currentIndex / _blocksPerRow) * 50 - 25 + 1 + 2;
			_blocks [currentIndex] = block;
			var validOpenings:String = "";
			
			while (true) {
				block.gotoAndStop (Math.floor (Math.random () * GameData.blockFrames) + 1);
				
				if (IsBlockConnected (block, currentIndex, lastIndex, _blocks) == true) {
					validOpenings = GetBlockOpenings (block, currentIndex, _blocks);
					break;
				}
			}
			
			block.lines.gotoAndStop (block.currentFrame);
			var ct:ColorTransform = new ColorTransform ();
			ct.color = GameData.wallColor;
			block.lines.transform.colorTransform = ct;
			
			for (var i = 0; i < validOpenings.length; i++) {
				var nextDirection:String = validOpenings.charAt (i);
				
				if (nextDirection == "l") {
					CreateFakeBlock (currentIndex - 1, currentIndex);
				} else if (nextDirection == "r") {
					CreateFakeBlock (currentIndex + 1, currentIndex);
				} else if (nextDirection == "t") {
					if (Math.floor (currentIndex / _blocksPerRow) < (_maxRows + 1) * 2 - 1) {
						CreateFakeBlock (currentIndex + _blocksPerRow, currentIndex);
					}
				} else if (nextDirection == "b") {
					if (Math.floor (currentIndex / _blocksPerRow) > _maxRows + 1) {
						CreateFakeBlock (currentIndex - _blocksPerRow, currentIndex);
					}
				}
			}
		}
		
		private function IsBlockConnected (block:MovieClip, currentIndex:Number, lastIndex:Number, blocks:Array):Boolean {
			var openings:String = block.getChildAt (0).name;
			var connected:Boolean;
			
			if (currentIndex == lastIndex - 1) {
				if (openings.indexOf ("r") != -1) {
					connected = true;
				} else {
					connected = false;
				}
			} else if (currentIndex == lastIndex + 1) {
				if (openings.indexOf ("l") != -1) {
					connected = true;
				} else {
					connected = false;
				}
			} else if (currentIndex == lastIndex + _blocksPerRow) {
				if (openings.indexOf ("b") != -1) {
					connected = true;
				} else {
					connected = false;
				}
			} else if (currentIndex == lastIndex - _blocksPerRow) {
				if (openings.indexOf ("t") != -1) {
					connected = true;
				} else {
					connected = false;
				}
			}
			
			return connected;
		}
		
		private function GetBlockOpenings (block:MovieClip, currentIndex:Number, blocks:Array):String {
			var openings:String = block.getChildAt (0).name;
			var validOpenings:String = "";
			
			for (var i = 0; i < openings.length; i++) {
				var direction:String = openings.charAt (i);
				
				if (direction == "l") {
					if (currentIndex % _blocksPerRow > 0 && blocks [currentIndex - 1] == null) {
						validOpenings += direction;
					}
				} else if (direction == "r") {
					if (currentIndex % _blocksPerRow < _blocksPerRow - 1 && blocks [currentIndex + 1] == null) {
						validOpenings += direction;
					}
				} else if (direction == "t") {
					if (Math.floor (currentIndex / _blocksPerRow) < (_maxRows + 1) * 2 - 1 && blocks [currentIndex + _blocksPerRow] == null) {
						validOpenings += direction;
					} else if (Math.floor (currentIndex / _blocksPerRow) == (_maxRows + 1) * 2 - 1) {
						validOpenings = direction;
						break;
					}
				} else if (direction == "b") {
					if (Math.floor (currentIndex / _blocksPerRow) > 0 && blocks [currentIndex - _blocksPerRow] == null) {
						validOpenings += direction;
					}
				}
			}
			
			return validOpenings;
		}
		
		public function CreateMainPath () {
			for (var i = 0; i < _blocksPerRow * (_maxRows + 1); i++) {
				_blocks.push (null);
			}
			
			_lastOpenIndex -= _blocksPerRow * (_maxRows + 1);
			var lastOpenIndex:Number = _lastOpenIndex;
			
			do {
				_testBlocks = new Array ();
				_testBlocks = _testBlocks.concat (_blocks);
				_lastOpenIndex = lastOpenIndex;
				_mainBlockIndexes = new Array ();
				_redoPath = false;
				CreateMainBlock (_lastOpenIndex + _blocksPerRow);
			} while (_redoPath);
			
			for (var i = _blocksPerRow * (_maxRows + 1); i < _blocksPerRow * (_maxRows + 1) * 2; i++) {
				if (_testBlocks [i] != null) {
					_blocks [i] = _testBlocks [i];
				}
			}
		}
		
		public function CreateFakePaths () {
			for (var j = 0; j < _mainBlockIndexes.length; j++) {
				var i:Number = _mainBlockIndexes [j];
				var validOpenings:String = GetBlockOpenings (_blocks [i], i, _blocks);
				
				for (var k = 0; k < validOpenings.length; k++) {
					var direction:String = validOpenings.charAt (k);
					
					if (direction == "l") {
						CreateFakeBlock (i - 1, i);
					} else if (direction == "r") {
						CreateFakeBlock (i + 1, i);
					} else if (direction == "t") {
						if (Math.floor (i / _blocksPerRow) < (_maxRows + 1) * 2 - 1) {
							CreateFakeBlock (i + _blocksPerRow, i);
						}
					} else if (direction == "b") {
						if (Math.floor (i / _blocksPerRow) > _maxRows + 1) {
							CreateFakeBlock (i - _blocksPerRow, i);
						}
					}
				}
			}
			
			for (var i = _blocksPerRow * (_maxRows + 1); i < _blocksPerRow * (_maxRows + 1) * 2; i++) {
				if (_blocks [i] == null) {
					var block:MovieClip = new _mcBlock ();
					block.gotoAndStop (Math.floor (Math.random () * GameData.blockFrames) + 1);
					block.x = i % _blocksPerRow * 50 + 25 + 0.5;
					block.y = _maxRows * 50 - Math.floor (i / _blocksPerRow) * 50 - 25 + 1 + 2;
					block.lines.gotoAndStop (block.currentFrame);
					var ct:ColorTransform = new ColorTransform ();
					ct.color = GameData.wallColor;
					block.lines.transform.colorTransform = ct;
					_blocks [i] = block;
				}
			}
		}
		
		public function DestroyOldPath ():Array {
			/*for (var i = 0; i < _blocksPerRow * (_maxRows + 1); i++) {
				if (_blocks [i] != null) {
					//_blocks [i].Deactivate ();
				}
			}*/
			
			return _blocks.splice (0, _blocksPerRow * (_maxRows + 1));
		}
		
		public function GetBlocks ():Array {
			return _blocks;
		}
		
		public function Initialize () {
			var pathNumber:Number = (_blocksPerRow % 2 == 0) ? _blocksPerRow / 2 - 1 : Math.ceil (_blocksPerRow / 2) - 1;
			
			for (var i = 0; i < _maxRows + 1; i++) {
				var block:MovieClip = new _mcBlock ();
				block.gotoAndStop (1);
				block.lines.gotoAndStop (block.currentFrame);
				var ct:ColorTransform = new ColorTransform ();
				ct.color = GameData.wallColor;
				block.lines.transform.colorTransform = ct;
				_blocks [i * _blocksPerRow + _blocksPerRow * (_maxRows + 1) + pathNumber] = block;
			}
			
			for (var i = 0; i < (_maxRows + 1) * 2 - 1; i++) {
				for (var j = 0; j < _blocksPerRow; j++) {
					if (_blocks [j + i * _blocksPerRow] == null) {
						var block:MovieClip = new _mcBlock ();
						block.gotoAndStop (Math.floor (Math.random () * 6) + 1);
						_blocks [j + i * _blocksPerRow] = block;
						block.lines.gotoAndStop (block.currentFrame);
						var ct:ColorTransform = new ColorTransform ();
						ct.color = GameData.wallColor;
						block.lines.transform.colorTransform = ct;
					}
				}
			}
			
			for (var i = 0; i < _blocksPerRow; i++) {
				if (i != pathNumber) {
					var block:MovieClip = new _mcBlock ();
					block.gotoAndStop (8);
					_blocks [i + _blocksPerRow * (_maxRows + 1) * 2 - _blocksPerRow] = block;
					block.lines.gotoAndStop (block.currentFrame);
					var ct:ColorTransform = new ColorTransform ();
					ct.color = GameData.wallColor;
					block.lines.transform.colorTransform = ct;
				}
			}
			
			for (var i = 0; i < _blocksPerRow * (_maxRows + 1) * 2; i++) {
				if (_blocks [i] != null) {
					_blocks [i].x = i % _blocksPerRow * 50 + 25 + 0.5;
					_blocks [i].y = _maxRows * 50 - Math.floor (i / _blocksPerRow) * 50 - 25 + 1 + _maxRows * 50 + 50;
				}
			}
			
			_lastOpenIndex = _blocksPerRow * (_maxRows + 1) * 2 - (pathNumber + 1);
		}
	}
}