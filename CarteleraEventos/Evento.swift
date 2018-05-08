//
//  Evento.swift
//  CarteleraEventos
//
//  Created by Esteban Arocha Ortuño on 3/13/18.
//  Copyright © 2018 ESCAMA. All rights reserved.
//

import UIKit

func makeDate(year: Int, month: Int, day: Int, hr: Int, min: Int, sec: Int) -> Date {
    var calendar = Calendar(identifier: .gregorian)
    //calendar.timeZone = TimeZone(secondsFromGMT: -5*3600)!
    let components = DateComponents(year: year, month: month, day: day, hour: hr, minute: min, second: sec)
    return calendar.date(from: components)!
}

class Evento{
    
    var id : Int
    var foto : UIImage?
    var name : String?
    var startDate : Date
    var startTime : String
    var location : String?
    var favorites : Bool
    var contactEmail : String?
    var description: String?
    var requirements: String?
    var schedule: String?
    var petFriendly: Int?
    var contactPhone: String?
    var category: String?
    var contactName: String?
    var cost: String?
    var hasRegistration: String?
    var cancelled: String?
    var hasDeadline: String?
    var prefix: String?
    var registrationDeadline: String?
    var registrationUrl: String?
    var cancelMessage: String?
    var campus: String?
    var registrationMessage: String?
    
    init( ide: String, fotoURL: String? = "", name: String? = "", startDate: String? = "",  location: String? = "", contactEmail: String? = "", description: String? = "", requirements: String? = "", schedule: String? = "", petFriendly: Int? = 0, contactPhone: String? = "", category: String? = "", contactName: String? = "", cost: String? = "", hasRegistration: String? = "", cancelled: String? = "", hasDeadline: String? = "", prefix: String? = "", registrationDeadline: String? = "", registrationUrl: String? = "", cancelMessage: String? = "",campus: String? = "", registrationMessage: String? = "")
    {
        self.id = Int(ide)!
        
        let url = URL(string: fotoURL!)
        let imgData = try? Data(contentsOf: url!)
        if(imgData != nil)
        {
            self.foto = UIImage(data: imgData!)!
        }

        let arrDateTime = startDate?.components(separatedBy: "T")
        let arrDate = arrDateTime![0].components(separatedBy: "-")
        let arrHour = arrDateTime![1].components(separatedBy: ":")
        self.startTime = arrHour[0] + ":" + arrHour[1]
        let year = Int(arrDate[0])
        let month = Int(arrDate[1])
        let day = Int(arrDate[2])
        let hr = Int(arrHour[0])
        let min = Int(arrHour[1])
        let sec = 0
        self.startDate = makeDate(year: year!, month: month!, day: day!, hr: hr!, min: min!, sec: sec)
        self.name = name!
        self.favorites = false
        
        if (location != nil)
        {
            self.location = location!
        }
        if (description != nil)
        {
            self.description = description!
        }
        if (contactEmail != nil)
        {
            self.contactEmail = contactEmail!
        }
        if (requirements != nil)
        {
            self.requirements = requirements!
        }
        if (schedule != nil)
        {
            self.schedule = schedule!
        }
        if ( petFriendly != nil )
        {
            self.petFriendly = petFriendly!
        }
        if ( contactPhone != nil)
        {
            self.contactPhone = contactPhone!
        }
        if ( category != nil)
        {
            self.category = category!
        }
        if ( contactName != nil)
        {
            self.contactName = contactName!
        }
        if ( cost != nil)
        {
            self.cost = cost!
        }
        if ( hasRegistration != nil)
        {
            self.hasRegistration = hasRegistration!
        }
        if ( cancelled != nil)
        {
            self.cancelled = cancelled!
        }
        if ( cancelled != nil)
        {
            self.cancelled = cancelled!
        }
        if ( hasDeadline != nil)
        {
            self.hasDeadline = hasDeadline!
        }
        if ( prefix != nil)
        {
            self.prefix = prefix!
        }
        if ( registrationDeadline != nil)
        {
            self.registrationDeadline = registrationDeadline!
        }
        if ( registrationUrl != nil)
        {
            self.registrationUrl = registrationUrl!
        }
        if ( cancelMessage != nil)
        {
            self.cancelMessage = cancelMessage!
        }
        if ( campus != nil)
        {
            self.campus = campus!
        }
        if ( registrationMessage != nil)
        {
            self.registrationMessage = registrationMessage!
        }
    }
}
