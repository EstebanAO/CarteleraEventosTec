//
//  DetalleViewController.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/14/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit
import EventKit
import GoogleAPIClientForREST
import GoogleSignIn

protocol protocoloModificarFavorito{
    func modificaFavorito(fav: Bool, ide: Int )
}

class DetalleViewController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    var eveTemp : Evento!
    var eveName : String!
    var delegado : protocoloModificarFavorito!
    @IBOutlet weak var foto: UIImageView!
    @IBOutlet weak var lbName: UILabel!
    @IBOutlet weak var lbLugar: UILabel!
    @IBOutlet weak var lbFecha: UILabel!
    @IBOutlet weak var lbHora: UILabel!
    
    private let scopes = [kGTLRAuthScopeCalendar]
    
    private let service = GTLRCalendarService()
    let signInButton = GIDSignInButton()
    let output = UITextView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        foto.image = eveTemp.foto
        lbName.text = eveTemp.name
        lbLugar.text = eveTemp.location
        lbFecha.text = String(describing: eveTemp.startDate)
        lbHora.text = eveTemp.startTime
        
        // Configure Google Sign-in.
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().scopes = scopes
        GIDSignIn.sharedInstance().signInSilently()
        
        // Add the sign-in button.
        view.addSubview(signInButton)
        
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
        }
        else
        {
            delegado.modificaFavorito(fav: true, ide: eveTemp.id)
            eveTemp.favorites = true
        }        
    }
    
    @IBAction func guardarEventoIOS(_ sender: Any) {
        let calendar = Calendar.current
        
        
        //addEventToCalendar(title: eveTemp.name!, description: "Evento Cool", startDate: eveTemp.startDate, endDate: endDate!)
        
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let stDate = self.eveTemp.startDate
                //let endDate = calendar.date(byAdding: .minute, value: 60, to: stDate)
                let event = EKEvent(eventStore: eventStore)
                event.title = self.eveTemp.name
                event.startDate = self.eveTemp.startDate
                event.endDate = self.eveTemp.startDate
                event.notes = "Evento Cool"
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    let alertController = UIAlertController(title: "¡Evento Agendado!", message:
                        "El evento ha sido guardado en el calendario de tu iPhone.", preferredStyle: UIAlertControllerStyle.alert)
                    alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
                    self.present(alertController, animated: true, completion: nil)
                } catch let error as NSError {
                    print("error : \(error)")
                    return
                }
                
                
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
    
    // MARK - Google Calendar
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            let alertController = UIAlertController(title: "Error", message:
                "No se ha podido iniciar sesión", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
            self.service.authorizer = nil
        } else {
            self.signInButton.isHidden = true
            self.service.authorizer = user.authentication.fetcherAuthorizer()
        }
    }

    @IBAction func guardarGoogle(_ sender: UIButton) {
        if GIDSignIn.sharedInstance().hasAuthInKeychain() {
            let newEvent: GTLRCalendar_Event = GTLRCalendar_Event()
            
            newEvent.summary = (self.eveTemp.name)
            let startDateTime: GTLRDateTime = GTLRDateTime(date: self.eveTemp.startDate)
            let startEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
            startEventDateTime.dateTime = startDateTime
            newEvent.start = startEventDateTime
            print(newEvent.start!)
            
            let endDateTime: GTLRDateTime = GTLRDateTime(date: self.eveTemp.startDate, offsetMinutes: 60)
            let endEventDateTime: GTLRCalendar_EventDateTime = GTLRCalendar_EventDateTime()
            endEventDateTime.dateTime = endDateTime
            newEvent.end = endEventDateTime
            
            let query =
                GTLRCalendarQuery_EventsInsert.query(withObject: newEvent, calendarId:"primary")
            query.fields = "id";
            self.service.executeQuery(
                query,
                completionHandler: {(_ callbackTicket:GTLRServiceTicket,
                    _  event:GTLRCalendar_Event,
                    _ callbackError: Error?) -> Void in}
                    as? GTLRServiceCompletionHandler
            )
            let alertController = UIAlertController(title: "¡Evento Agendado!", message:
                "El evento ha sido guardado en el calendario de Google.", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        } else {
            let alertController = UIAlertController(title: "Error", message:
                "No se ha iniciado sesión", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default,handler: nil))
            
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
    @IBAction func shareNative(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: [self.eveTemp.foto as Any], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
}
    
    
    
    

