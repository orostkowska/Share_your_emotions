//
//  PojedynczaWiadomosc.swift
//  Emotions
//
//  Created by Olga on 21.07.2014.
//  Copyright (c) 2014 Olga. All rights reserved.
//

import Foundation

class Message {
    var nadawca: String
    var tresc: String
    var data: NSDate
    var color: String
    var dictionary = NSMutableDictionary()
    
    init(nadawca: String, tresc: String, data: NSDate, color: String){
        self.nadawca = nadawca
        self.tresc = tresc
        self.data = data
        self.color = color
    }
    
    init(dictionary: NSMutableDictionary){
        data = dictionary["Data"] as NSDate
        nadawca = dictionary["Nadawca"] as String
        tresc = dictionary["Tresc"] as String
        color = dictionary["Kolor"] as String
    }
    
    func export() -> NSMutableDictionary{
        var myDictionary = dictionary
        myDictionary["Nadawca"] = nadawca
        myDictionary["Tresc"] = tresc
        myDictionary["Data"] = data
        myDictionary["Kolor"] = color
        
        return myDictionary
    }
    
    
}