package ca.qc.cegepstefoy.HATeam.observateur {
	/**
	 * ...
	 * @author Michel Rouleau
	 */
	public class Observateur
	{
		//Liste d'objet gérée par l'observateur
		private var _listeObjet:Array;
		
		//Constructeur de l'observateur
		public function Observateur() 
		{
			//Initialisation de la liste d'objet
			this._listeObjet = new Array();
		}
		
		//Fonction d'ajout d'un objet supervisé par l'observateur
		public function ajouterObjet(obj:Object):Boolean { 
			//Est-ce que l'objet est déjà dans la liste?
			var index:int = this._listeObjet.indexOf(obj);
			//Sinon, ben ajoute-le!!!
			if (index == -1) 
			{
				this._listeObjet.push(obj);
				//Retourne réussite de l'ajout
				return true;
			}
			//Sinon, ben il était déjà dans la liste
			return false;
		}
		
		//Fonction de retrait d'un objet supervisé par l'observateur
		public function retirerObjet(obj:Object):Boolean {
			//Est-ce que l'objet est déjà dans la liste?
			var index:uint = this._listeObjet.indexOf(obj);
			//Sioui, ben retire-le!!!
			if (index != -1) 
			{
				this._listeObjet.splice(index, 0);
				//Retourne réussite du retrait
				return true;
			}
			//Sinon, ben connait pas l'objet???
			return false;
		}
		
		//Fonction de notification des objets supervisés
		public function notifierObjets():void {
			//Commence par le premier objet entré dans la liste, mettons... pas toujours dans le même ordre!
			this._listeObjet.reverse();
			//Selon le nombre d'objet dans la liste
			//trace(this._listeObjet);
			for (var index:uint = 0; index < this._listeObjet.length; index++) {
				//Avertir l'objet de se mettre à jour!!!
				this._listeObjet[index].mettreAjour();
			}
		}
	}
}