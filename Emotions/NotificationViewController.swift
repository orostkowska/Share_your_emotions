//  NotificationViewController.swift
//  Emotions
//
//  Created by Olga on 18.07.2014.
//  Copyright (c) 2014 Olga. All rights reserved.
//

import UIKit

let parse_sent_messages = "sentMessage"

class NotificationViewController: UIViewController, NotificationDelegate, APIDelegate, UIScrollViewDelegate{
    
    func nacisniecieButtonu() {
        sequeButtonu()
    }
    
    func newMessages(message: PFObject) {
        trescFromParse = message
        refreshUI()
    }
    
    
    let contentOffset = CGPoint(x: 0, y: 200)
    
    var arrayMessagy = NSArray()
    var query:PFQuery = PFQuery(className: parse_sent_messages)
    var trescFromParse: PFObject?
    var count = Int()
    var elementParsowyZArraya: PFObject!
    var messageZParsa: NSMutableDictionary!
    
    var mainObjectApi: KomunikacjaApi!
    var widokStartowy: UIView?
    var licznikArrayOfMessage = 0
    
    var scrollView: UIScrollView!
    var buttonDoIT = UIButton()
    var mainImageView = UIImageView()
    var mainTextField = UITextField()
    var nadawca = "Nadawca"
    var ilKropekk: Int?
    var mainPageControl = UIPageControl()

    var mainCurrentPage = 0
    
    @IBOutlet var scrollView2: UIScrollView!
    
    func wlasciwosciScrollView() {
        scrollView2.backgroundColor = UIColor.blackColor()
        scrollView2.delegate = self
        scrollView2.pagingEnabled = true
        scrollView2.showsHorizontalScrollIndicator = false
    }
    
    
    func stworzWidok() {
        mainObjectApi.delegate = self
        
        if !trescFromParse && !widokStartowy {
            widokStartowy = utworzWidokStartowy()
        } else if trescFromParse {
            widokStartowy?.removeFromSuperview()
        }
    }
    
    func refreshUI(){
        println("refreshuje")
        var xx: CGFloat = 0
        var object: PFObject!
        var elementZParsaDict: AnyObject? = trescFromParse?.objectForKey("Wiadomosc")
        var elementZParsa = elementZParsaDict as NSMutableDictionary
        
      
        query.orderByDescending("createdAt")
        query.whereKeyExists("Wiadomosc")
        
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !error {
                
                self.arrayMessagy = objects
                NSLog("Masz \(self.arrayMessagy.count) wiadomosci")
                
                for i in 0 ..< self.arrayMessagy.count{
                    
                    self.elementParsowyZArraya = self.arrayMessagy[i] as PFObject
                    self.messageZParsa = self.elementParsowyZArraya["Wiadomosc"] as NSMutableDictionary
                    println(self.messageZParsa)
                    
                    var mainMessage = Message(dictionary: self.messageZParsa)
                    var nadawca = mainMessage.nadawca
                    var tresc = mainMessage.tresc
                    var data = mainMessage.data
                    var color = mainMessage.color
                    var textForLabel = "\(tresc)"
            
                    var nv = NotificationView(frame: CGRect(x: xx, y: 0, width: 320, height: self.view.frame.size.height), color: UIColor.colorWithHexString(color), tekst: textForLabel, data: data, nadawca: nadawca)
                    nv.delegate = self
                    
                    self.scrollView2.addSubview(nv)
                    self.scrollView2.contentSize = CGSizeMake(self.view.frame.size.width * CGFloat(self.arrayMessagy.count), 500)
                    self.scrollView2.frame = CGRectMake (0, 0, self.scrollView2.frame.size.width, self.scrollView2.frame.size.height)
                    
                    xx += 320
                    println(nv)
                    self.refreshPC()
                }
            } else {
                NSLog("Error: %@ %@", error, error.userInfo)
            }
        }
        
    }
    
    func utworzWidokStartowy() -> UIScrollView {
        scrollView = UIScrollView()
        scrollView.frame = CGRect(x: 0, y: 0, width: 320, height: view.frame.size.height)
        scrollView.backgroundColor = UIColor.whiteColor()
        scrollView.contentSize = CGSize(width: 320, height: 1000)
        
        var button = buttonDoIT
        button.frame = CGRect(x: 20, y: view.frame.size.height * 0.8, width: 280, height: 60)
        button.setTitle("start", forState: UIControlState())
        button.backgroundColor = UIColor.colorWithHexString("4948d4")
        button.titleLabel.font = UIFont.boldSystemFontOfSize(35)
        scrollView.addSubview(button)
        self.view.addSubview(scrollView)
        button.addTarget(self, action: "wpiszImieiZrobTo", forControlEvents: UIControlEvents.TouchUpInside)
        
        let emotion_title = UIImage(named: "emotion_title")
        var imageView = mainImageView
        imageView.contentMode = .Center
        imageView.image = emotion_title
        imageView.frame = CGRect(x: 10, y: 10, width: 320, height: 500)
        scrollView.addSubview(imageView)
        return scrollView
    }
    
    func wpiszImieiZrobTo(){
        UIView.animateWithDuration(0.3, animations: {
            self.mainImageView.alpha = 0.0
            self.scrollView.contentOffset = self.contentOffset
        })
        
        var textField = mainTextField
        textField.frame = CGRect(x: 20, y: 300, width: 280, height: 60)
        textField.borderStyle = .RoundedRect
        textField.placeholder = ("Your name")
        textField.font = UIFont.systemFontOfSize(40)
        textField.textAlignment = .Center
        nadawca = textField.text
        
        scrollView.addSubview(textField)
        
        var responder = textField.becomeFirstResponder()
        
        buttonDoIT.setTitle("ok, let's do it", forState: UIControlState())
        
        if !textField.text.isEmpty {
        buttonDoIT.addTarget(self, action: "sequeButtonu", forControlEvents: UIControlEvents.TouchUpInside)
            var nad = mainObjectApi.ustawNadawce(nadawca) }
    }
    
    func sequeButtonu(){
        let bundle = NSBundle.mainBundle()
        let storyboard = UIStoryboard(name: "Main", bundle: bundle)
        let viewController = storyboard.instantiateViewControllerWithIdentifier("ViewController") as ViewController
        viewController.api = mainObjectApi
        navigationController.pushViewController(viewController, animated:true)
    }
    
    func createPageControl(){
        var pageControl = mainPageControl
        pageControl.numberOfPages = arrayMessagy.count
        pageControl.frame = CGRect(x: 0, y: scrollView2.frame.size.height * 0.95, width: 320, height: 10)
        pageControl.currentPage = mainCurrentPage
        pageControl.updateCurrentPageDisplay()
        self.view.addSubview(pageControl)
    }
    
    func refreshPC(){
        if licznikArrayOfMessage > arrayMessagy.count || licznikArrayOfMessage < arrayMessagy.count {
            mainPageControl.numberOfPages = arrayMessagy.count
        }
        licznikArrayOfMessage = arrayMessagy.count
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainObjectApi = KomunikacjaApi()
        createPageControl()
        wlasciwosciScrollView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        stworzWidok()
       
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }

    func scrollViewDidScroll(scrollView: UIScrollView!){
        mainPageControl.currentPage = Int(scrollView2.contentOffset.x / scrollView2.frame.size.width)
    }
    
}





class NotificationView: UIView {
    
    var delegate: NotificationDelegate?
    
    var mainObjectApi: KomunikacjaApi!
    
    init(frame: CGRect, color: UIColor, tekst: String, data: NSDate, nadawca: String){
        super.init(frame: frame)
        self.backgroundColor = color
        createLabel(tekst)
        createLabelWithData(data)
        createLabelNadawca(nadawca)
        createButton(color)
    }
    
    func createButton(color: UIColor){
        var button = UIButton()
        button.frame = CGRect(x: 20, y: 400, width: 280, height: 60)
        button.backgroundColor = UIColor.whiteColor()
        button.setTitle("strike back", forState: UIControlState())
        button.titleLabel.font = UIFont.boldSystemFontOfSize(35)
        button.setTitleColor(color, forState: UIControlState())
        addSubview(button)
        button.addTarget(self, action: "powiedzDelegatowi", forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func powiedzDelegatowi(){
        delegate?.nacisniecieButtonu()
    }
    
    func createLabel(tekst: String){
        var label = UILabel()
        label.frame = CGRect(x: 0, y: 200, width: 320, height: 100)
        label.text = tekst
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(70)
        label.textAlignment = NSTextAlignment.Center
        addSubview(label)
    }
    
    func createLabelNadawca(nadawca: String){
        var labelWithData = UILabel()
        labelWithData.frame = CGRect (x: 0, y: 170, width: 320, height: 50)
        labelWithData.textColor = UIColor.whiteColor()
        labelWithData.text = "\(nadawca)"
        labelWithData.font = UIFont.boldSystemFontOfSize(30)
        labelWithData.textAlignment = NSTextAlignment.Center
        addSubview(labelWithData)
    }
    
    func createLabelWithData(data: NSDate){
        var dat = NSDateFormatter ()
        var time = NSDateFormatter ()
        dat.dateStyle = NSDateFormatterStyle.MediumStyle
        time.timeStyle = NSDateFormatterStyle.MediumStyle
        var dataString = dat.stringFromDate(data)
        var timeString = time.stringFromDate(data)
        
        var labelWithData = UILabel()
        labelWithData.frame = CGRect (x: 0, y: 40, width: 320, height: 100)
        labelWithData.textColor = UIColor.whiteColor()
        labelWithData.text = "\(dataString) \(timeString)"
        labelWithData.textAlignment = NSTextAlignment.Center
        addSubview(labelWithData)
    }
    
}

protocol NotificationDelegate{
    func nacisniecieButtonu()
}



