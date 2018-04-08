//
//  DetalleViewController.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/14/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit
import FacebookShare
import EventKit

protocol protocoloModificarFavorito{
    func modificaFavorito(fav: Bool, ide: Int )
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
        if (eveTemp.favorites)
        {
            pruebafav.text = "Soy fav"
        }
        else
        {
            pruebafav.text = "No soy fav"
        }
        
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
            delegado.modificaFavorito(fav: false, ide: eveTemp.id)
            eveTemp.favorites = false
            pruebafav.text = "No soy fav"
        }
        else
        {
            delegado.modificaFavorito(fav: true, ide: eveTemp.id)
            eveTemp.favorites = true
            pruebafav.text = "Soy fav"
        }        
    }
    
    @IBAction func shareFacebook(_ sender: Any) {
        let hola = UIApplication.shared.canOpenURL(URL(string: "fbauth2://")!)
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
    
    @IBAction func guardarEventoIOS(_ sender: Any) {
        let calendar = Calendar.current
        
        
        //addEventToCalendar(title: eveTemp.name!, description: "Evento Cool", startDate: eveTemp.startDate, endDate: endDate!)
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let stDate = self.eveTemp.startDate
                let endDate = calendar.date(byAdding: .minute, value: 60, to: stDate)
                let event = EKEvent(eventStore: eventStore)
                event.title = self.eveTemp.name
                event.startDate = self.eveTemp.startDate
                event.endDate = endDate
                event.notes = "Evento Cool"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let error as NSError {
                    print("error : \(error)")
                    return
                }
                let alertController = UIAlertController(title: "¡Evento Agendado!", message:
                    "El evento ha sido guardado en el calendario de tu iPhone.", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                
                self.present(alertController, animated: true, completion: nil)
            } else {
                print("error : \(String(describing: error))")
            }
        })
        
    }
    
    func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                } catch let e as NSError {
                    completion?(false, e)
                    return
                }
                completion?(true, nil)
            } else {
                completion?(false, error as NSError?)
            }
        })
    }
    
}
