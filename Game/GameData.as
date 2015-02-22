package Game {
	public class GameData {
		public static var blockFrames:Number;
		public static var speed:Number;
		
		public static var scoreMilestones:Array;
		public static var frameMilestones:Array;
		public static var specialMilestones:Array;
		public static var milestoneDialogs:Array;
		public static var speedMilestones:Array;
		public static var score:Number;
		
		public static var hasSound:Boolean = true;
		public static var wallColor:* = 0x003300;
		
		public static function Reset () {
			blockFrames = 6;
			speed = 2;
			
			scoreMilestones = new Array (1000, 3000, 5000, 6000, 8000, 10000);
			//scoreMilestones = new Array (10, 20, 30, 40, 50, 60, 70);
			frameMilestones = new Array (14, 15, 19, 19, 23, 24, 28);
			specialMilestones = new Array ("", "", "", "fog", "", "", "", "");
			milestoneDialogs = new Array ("", "", "", "CPU: Consternation fog process activated.", "", "", "");
			//speedMilestones = new Array (1.2, 1.4, 1.6, 1.6, 1.8, 2, 2, 2);
			speedMilestones = new Array (2, 2, 2, 2, 2, 2, 2);
			score = 0;
		}
	}
}