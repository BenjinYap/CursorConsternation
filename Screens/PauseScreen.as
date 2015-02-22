package Screens {
	import flash.display.*;
	import flash.events.*;
	import Game.*;
	
	public class PauseScreen extends MovieClip {
		
		public function PauseScreen () {
			addEventListener (Event.ADDED_TO_STAGE, onAdded, false, 0, true);
		}
		
		private function onAdded (e:Event) {
			removeEventListener (Event.ADDED_TO_STAGE, onAdded);
			Activate ();
		}
		
		private function onResumeClick (e:MouseEvent) {
			Deactivate ();
			dispatchEvent (new Event ("ChildScreenDestroy"));
			parent.removeChild (this);
		}
		
		private function onHelpClick (e:MouseEvent) {
			Deactivate ();
			var hs:HelpScreen = new HelpScreen ();
			hs.addEventListener ("ChildScreenDestroy", onChildScreenDestroy, false, 0, true);
			addChild (hs);
		}
		
		private function onSoundToggleClick (e:MouseEvent) {
			if (GameData.hasSound) {
				GameData.hasSound = false;
				mcSoundToggle.gotoAndStop ("NoSound");
			} else {
				GameData.hasSound = true;
				mcSoundToggle.gotoAndStop ("HasSound");
			}
		}
		
		private function onChildScreenDestroy (e:String) {
			Activate ();
		}
		
		private function onSpectrumDown (e:MouseEvent) {
			GameData.wallColor = "0x" + Bitmap (mcColorSpectrum.getChildAt (0)).bitmapData.getPixel (mcColorSpectrum.mouseX, mcColorSpectrum.mouseY).toString (16);
			txtColor.textColor = GameData.wallColor;
			mcColorSpectrum.addEventListener (MouseEvent.MOUSE_MOVE, onSpectrumMove, false, 0, true);
		}
		
		private function onSpectrumMove (e:MouseEvent) {
			GameData.wallColor = "0x" + Bitmap (mcColorSpectrum.getChildAt (0)).bitmapData.getPixel (mcColorSpectrum.mouseX, mcColorSpectrum.mouseY).toString (16);
			txtColor.textColor = GameData.wallColor;
		}
		
		private function onStageUp (e:MouseEvent) {
			mcColorSpectrum.removeEventListener (MouseEvent.MOUSE_MOVE, onSpectrumMove);
		}
		
		public function Initialize () {
			mcSoundToggle.buttonMode = true;
			
			if (GameData.hasSound) {
				mcSoundToggle.gotoAndStop ("HasSound");
			} else {
				mcSoundToggle.gotoAndStop ("NoSound");
			}
			
			
		}
		
		private function Activate () {
			bttResume.addEventListener (MouseEvent.CLICK, onResumeClick, false, 0, true);
			bttHelp.addEventListener (MouseEvent.CLICK, onHelpClick, false, 0, true);
			mcSoundToggle.addEventListener (MouseEvent.CLICK, onSoundToggleClick, false, 0, true);
			mcColorSpectrum.addEventListener (MouseEvent.MOUSE_DOWN, onSpectrumDown, false, 0, true);
			stage.addEventListener (MouseEvent.MOUSE_UP, onStageUp, false, 0, true);
		}
		
		private function Deactivate () {
			bttResume.removeEventListener (MouseEvent.CLICK, onResumeClick);
			bttHelp.removeEventListener (MouseEvent.CLICK, onHelpClick);
			mcSoundToggle.removeEventListener (MouseEvent.CLICK, onSoundToggleClick);
			mcColorSpectrum.removeEventListener (MouseEvent.MOUSE_DOWN, onSpectrumDown);
			stage.removeEventListener (MouseEvent.MOUSE_UP, onStageUp);
		}
	}
}