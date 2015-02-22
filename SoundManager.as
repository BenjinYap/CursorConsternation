package {
	import flash.media.*;
	import flash.events.Event;
	import flash.net.*;
	
	public class SoundManager {
		private var _channels:Array = new Array ();
		private var _sounds:Array = new Array ();
		private var _positions:Array = new Array ();
		
		public function SoundManager () {
			
		}
		
		public function PlayNewSound (sound:Sound) {
			var channel:SoundChannel = sound.play ();
			channel.addEventListener (Event.SOUND_COMPLETE, onSoundPlayComplete, false, 0, true);
			_channels.push (channel);
			_sounds.push (sound);
			_positions.push (0);
		}
		
		public function PlayNewSoundURL (url:String) {
			var sound:Sound = new Sound ();
			sound.load (new URLRequest (url));
			sound.addEventListener (Event.COMPLETE, onSoundLoadComplete, false, 0, true);
		}
		
		private function onSoundLoadComplete (e:Event) {
			e.target.removeEventListener (Event.COMPLETE, onSoundLoadComplete);
			var channel:SoundChannel = e.target.play ();
			channel.addEventListener (Event.SOUND_COMPLETE, onSoundPlayComplete, false, 0, true);
			_channels.push (channel);
			_sounds.push (e.target);
			_positions.push (0);
		}
		
		private function onSoundPlayComplete (e:Event) {
			e.target.removeEventListener (Event.SOUND_COMPLETE, onSoundPlayComplete);
			var index:Number = _channels.indexOf (e.target);
			_channels.splice (index, 1);
			_sounds.splice (index, 1);
			_positions.splice (index, 1);
		}
		
		public function PauseAllSounds () {
			for (var i = 0; i < _channels.length; i++) {
				_positions [i] = _channels [i].position;
				_channels [i].stop ();
			}
		}
		
		public function StopAllSounds () {
			for (var i = 0; i < _channels.length; i++) {
				_channels [i].stop ();
				_channels [i].removeEventListener (Event.SOUND_COMPLETE, onSoundPlayComplete);
			}
			
			_channels = new Array ();
			_sounds = new Array ();
			_positions = new Array ();
		}
		
		public function ResumeAllSounds () {
			for (var i = 0; i < _channels.length; i++) {
				_channels [i] = _sounds [i].play (_positions [i]);
			}
		}
	}
}