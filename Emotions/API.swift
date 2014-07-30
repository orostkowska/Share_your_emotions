//  WiadomosciDoWyswietlenia.swift
//  Emotions
//
//  Created by Olga on 21.07.2014.
//  Copyright (c) 2014 Olga. All rights reserved.
//

import Foundation

class KomunikacjaApi: NSObject {
    
    var delegate: APIDelegate? = nil
    var mainNadawca = ""
    var sentMessage = PFObject(className: "sentMessage")
    
    func messagesAreComing () {
        if let d = delegate {
            println("********** \(sentMessage)")
            d.newMessages(sentMessage)
        }
    }
    
    func ustawNadawce(nadawca: String) -> String{
        mainNadawca = nadawca
        return mainNadawca
    }
    
    func wyslijWiadomosc(wiadomosc: Message){
        println("Wysylam \(wiadomosc.tresc)")
        
        sentMessage["Wiadomosc"] = wiadomosc.export()
        sentMessage.saveInBackground()
            
        
        messagesAreComing() 
    }
    

}

protocol APIDelegate {
    func newMessages(message: PFObject)
}