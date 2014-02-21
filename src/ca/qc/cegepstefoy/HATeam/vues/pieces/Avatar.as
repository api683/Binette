package ca.qc.cegepstefoy.HATeam.vues.pieces {
	import assets.ui.persoAvatar;
	import flash.display.MovieClip;

	public class Avatar {
		
		//Conserve l'occurence de la première instanciation du singleton
		static private  var instance:Avatar;
		static private var _avatar:MovieClip;
		static private var _avatarNom:String = "Entrer un nom de Super-héro";
		static private var _avatarTete:String = "vide";
		static private var _avatarCorps:String = "vide";
		static private var _avatarJambes:String = "vide";
		static private var _elementSelectionne:Array = new Array(-1, -1, -1);
		static private var _section_actuelle:int = 1;
		static private var _lastSection:int = 1;

		//Constructeur de la classe avec renfort 
		//(impossible de passer des arguments et d'appeler le constructeur seul)
		public function Avatar(renfort:AvatarRenfort):void {	
		}
		
		//Fonction de retour de l'instance
		public static function getInstance():Avatar {
			//Vérifie si l'instance est nulle (non initialisée)
			if (Avatar.instance==null) {
				//Si oui crée une instance
				Avatar.instance=new Avatar(new AvatarRenfort());
				Avatar._avatar = new persoAvatar();
				Avatar._avatar.x = 225;
				Avatar._avatar.y = 170;
				Avatar._avatar.avatarTete.gotoAndStop(_avatarTete);
				Avatar._avatar.avatarCorps.gotoAndStop(_avatarCorps);
				Avatar._avatar.avatarJambes.gotoAndStop(_avatarJambes);
			}
			//Retourne l'instance créée
			return Avatar.instance;
		}
		
		//Fonction de test de création
		public function get avatar():MovieClip{
			return _avatar;
		}
		
		public function get avatarNom():String{
			return _avatarNom;
		}
		public function set avatarNom(nom:String):void{
			_avatarNom = nom;
		}
		
		public function get avatarTete():String{
			return _avatarTete;
		}
		public function set avatarTete(tete:String):void{
			_avatarTete = tete;
			Avatar._avatar.avatarTete.gotoAndStop(_avatarTete);
		}
		
		public function get avatarCorps():String{
			return _avatarCorps;
		}
		public function set avatarCorps(corps:String):void{
			_avatarCorps = corps;
			Avatar._avatar.avatarCorps.gotoAndStop(_avatarCorps);
		}
		
		public function get avatarJambes():String{
			return _avatarJambes;
		}
		public function set avatarJambes(jambes:String):void{
			_avatarJambes = jambes;
			Avatar._avatar.avatarJambes.gotoAndStop(_avatarJambes);
		}
		
		public function get elementSelectionne():Array{
			return _elementSelectionne;
		}
		
		public function get lastSection():int{
			return _lastSection;
		}
		public function set lastSection(newSection:int):void{
			_lastSection = newSection;
		}
		
		public function get section_actuelle():int{
			return _section_actuelle;
		}
		public function set section_actuelle(nouvelleSection:int):void{
			_section_actuelle = nouvelleSection;
		}
	}
}

class AvatarRenfort {
}