package Classes.Jogo.Som 
{
	
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	
	/**
	 * ...
	 * @author David Rosini
	 */
	
	public class EfeitosSX
	{
		private static var shoot:Shoot = new Shoot();
		private static var canal:SoundChannel;
		private static var controlsound:SoundTransform;
		
		public function EfeitosSX() 
		{}
		
		public static function somTiro():void
		{
			
			canal = shoot.play();
			
			controlsound = canal.soundTransform;
			controlsound.volume = 0.4;
			canal.soundTransform = controlsound;
		}
		
	}

}