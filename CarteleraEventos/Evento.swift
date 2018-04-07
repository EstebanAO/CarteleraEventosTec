//
//  Evento.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/13/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit

class Evento{
    
    var id : Int
    var foto : UIImage?
    var name : String?
    var startDate : Date
    var startTime : String
    var location : String?
    var favorites : Bool
    
    init( ide: String, fotoURL: String? = "", name: String? = "", startDate: String? = "", startTime: String, location: String? = "" )
    {
        self.id = Int(ide)!
        
            let url = URL(string: fotoURL!)
            let imgData = try? Data(contentsOf: url!)
        if(imgData != nil)
        {
            self.foto = UIImage(data: imgData!)!
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/mm/yyyy"
        //dateFormatter.timeZone = TimeZone(abbreviation: "GMT+0:00")
        self.startDate = dateFormatter.date(from: startDate!)!
        
        //dateFormatter.dateFormat = "HH:mm"
        //self.startTime = dateFormatter.date(from: startTime)!
        self.startTime = startTime
        if (location != nil)
        {
            self.location = location!
        }
        self.name = name!
        self.favorites = false
    }
}





















