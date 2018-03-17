//
//  APIManager.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/15/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit
import Alamofire

class APIManager{
    
    static let sharedInstance = APIManager()
    
    let jsonUrlString = "https://cartelera-api.herokuapp.com/events/"
    
    
    func getEvents(completion: @escaping ([Evento]) -> Void) {
        var arrEventos = [Evento]()
        
        Alamofire.request(jsonUrlString).validate().responseJSON { (response) in
            if let arrEveJson = response.value as? [[String : Any]] {
                for eve in arrEveJson
                {
                    let eventoTemp = Evento(ide: String(eve["id"] as! Int),
                                            fotoURL: eve["photo"] as? String,
                                            name: eve["name"] as? String,
                                            startDate: eve["startDate"] as? String,
                                            startTime: eve["startTime"] as! String,
                                            location: eve["location"] as? String)
                    arrEventos.append(eventoTemp)
                }
                completion(arrEventos)
            }
        }
    }
}













