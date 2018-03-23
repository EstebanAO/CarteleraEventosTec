//
//  DetalleViewController.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/14/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit
import FacebookShare

protocol protocoloModificarFavorito{
    func modificaFavorito(fav: Bool  )
}

class DetalleViewController: UIViewController {
    
    var eveTemp : Evento!
    var eveName : String!
    var delegado : protocoloModificarFavorito!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLugar: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbHora: UILabel!
    
    @IBOutlet weak var pruebafav: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        foto.image = eveTemp.foto
        lbName.text = eveTemp.name
        lbLugar.text = eveTemp.location
        lbFecha.text = String(describing: eveTemp.startDate)
        lbHora.text = eveTemp.startTime
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func modificaFavButton(_ sender: Any) {
        if (eveTemp.favorites)
        {
            eveTemp.favorites = false
            pruebafav.text = "No soy fav"
        }
        else
        {
            eveTemp.favorites = true
            pruebafav.text = "Soy fav"
        }
        delegado.modificaFavorito( fav: eveTemp.favorites )
        
    }
    
    @IBAction func shareFacebook(_ sender: Any) {
        var hola = UIApplication.shared.canOpenURL(URL(string: "fbauth2://")!)
        if hola
        {
            let shareEvent = ShareDialog(content: PhotoShareContent(photos: [Photo(image: eveTemp.foto!, userGenerated: true)]))
            shareEvent.mode = .native
            shareEvent.failsOnInvalidData = true
            shareEvent.completion = { result in
                
            }
            do {
                try shareEvent.show()
            } catch {
                print("Error displaying share dialog")
            }
        }
        else{
            let alertController = UIAlertController(title: "Facebook no instalado", message:
                "No se ha podido compartir el evento porque la aplicación de fácebook no está instalada.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
