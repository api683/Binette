package ca.qc.cegepstefoy.HATeam.observateur{
	import ca.qc.cegepstefoy.HATeam.observateur.Observateur;
	/**
	 * @author mrouleau
	 */
	public class GroupeBoutonRadio extends Observateur {
		
		//Propriété de la la sélection actuelle parmis le groupe
		protected var _selectionCourrante:uint=0;
		private var _groupe:String;
		
		public function GroupeBoutonRadio(nomGroupe:String) {
			super();
			this._groupe=nomGroupe;
		}
		
		//Accesseur/Mutateurs
		//Mutateur de la sélection courrante
		public function set selectionCourrante(id:uint):void{
			//Avertissement à l'ensemble des objets du groupe
			this.notifierObjets();
			//Nouvelle sélection dans le groupe
			this._selectionCourrante=id;
		}
		
		//Accesseur de la sélection courrante
		public function get selectionCourrante():uint
		{
			return this._selectionCourrante;
		}
		
		public function get nomGroupe():String
		{
		 	return this._groupe;
		}
		
		public function get nbBoutons():uint{
			return 4;
		}
	}
}
