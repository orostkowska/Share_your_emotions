//
//  ViewController.swift
//  Emotions
//
//  Created by Olga on 17.07.2014.
//  Copyright (c) 2014 Olga. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    var array: [Message] = []
    var api: KomunikacjaApi?
    
    func spakujMessage (sender: UIButton) {
        var data = NSDate()
        var nadawca = "\(api!.mainNadawca) is"
        var komunikat:String
        
        komunikat = ("\(sender.currentTitle)")
        var ktoryButton = sender.tag
        var color = ""
        if let buttonZTablicy = myArray[ktoryButton] as? [String: String]{
            var dict = buttonZTablicy
            color = dict["color"]!
        }
        var message = Message(nadawca: nadawca, tresc: komunikat, data: data, color: color)
        api?.wyslijWiadomosc(message)
    }
    
    @IBOutlet var scrollView: UIScrollView!
    
    let myArray = NSArray(contentsOfFile: NSBundle.mainBundle().pathForResource("allButtonsEmotionAndColor", ofType: "plist"))
    var buttonCount: CGFloat = 9
    
    func makeButton(){
        var yy:CGFloat = 0
        var hh: CGFloat = view.frame.size.height / 9
        var nrElementuWArrayu = 0
        
        for i in 0 ..< buttonCount {
            if let arrayElem =  myArray[nrElementuWArrayu] as? [String:String] {
                var myDictionary = arrayElem
                
                var button = UIButton()
                button.frame = CGRect(x: 0, y: yy, width: view.frame.size.width, height: hh)
                button.backgroundColor = UIColor.colorWithHexString(myDictionary["color"])
                button.setTitle(myDictionary["name"], forState: UIControlState())
                button.titleLabel.font = UIFont.boldSystemFontOfSize(30)
                button.tag = nrElementuWArrayu
                self.scrollView.addSubview(button)
                button.addTarget(self, action: "spakujMessage:", forControlEvents: UIControlEvents.TouchUpInside)
                yy += hh
                nrElementuWArrayu++
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()        
        makeButton()
        var sizeOfButton = view.frame.size.height / 9
        var heightOfScrollView = sizeOfButton * buttonCount
        self.scrollView.frame = CGRectMake (0, 0, 320, 567.5)
        self.scrollView.contentSize = CGSizeMake(view.frame.size.width, heightOfScrollView)
        
    }
}

