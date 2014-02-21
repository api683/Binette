package ca.qc.cegepstefoy.HATeam.modele {
	/**
	 * @author alex perron isabelle
	 */

	 	 
	public class Modele {
		
		private var _donneeXML:XML;
		private var _personnageXML:XML;
		private var _personnageCourante:int=0;
		
		public function Modele()
		{
			this._donneeXML=
			<Personnages>
			</Personnages>;
		}
		
		//Acesseurs/mutateurs
		public function set donnees(xml:XML):void{
			this._donneeXML=xml;
		}
		public function get donnees():XML{
			return this._donneeXML;
		}
		public function set personnage(xml:XML):void{
			this._personnageXML=xml;
		}
		public function get personnage():XML{
			return this._personnageXML;
		}
		public function set personnageCourant(n:int):void{
			this._personnageCourante=n;
		}
		public function get personnageCourant():int{
			return this._personnageCourante;
		}
		
		public function get nbPages():uint{
			return 4;
		}
		
		public function ajouterEnregistrement(xml:XML):void{
			if(this._donneeXML==""){
				this._donneeXML=
				<Personnages>
				</Personnages>;
			}
			this._donneeXML.appendChild(xml);
		}
		
		public function supprimerEnregistrement(index:uint):void{
			if(this._donneeXML.personnage.length()>0){
				delete this._donneeXML.children()[index];
			}
		}
	}
}
