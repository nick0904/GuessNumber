//
//  TipViewController.swift
//  GuessNumber
//
//  Created by 曾偉亮 on 2016/5/19.
//  Copyright © 2016年 TSENG. All rights reserved.
//

import UIKit

class TipViewController: UIViewController {

    var m_tittle:UILabel!
    var m_scrollerView:UIScrollView!
    var m_textLabel:UILabel!
    var m_parentObj:AnyObject?
    
//MARK: - Override Function
//-------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        //m_tittle
        m_tittle = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height:  self.view.frame.size.width/4))
        m_tittle.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.width/4)
        m_tittle.textColor = UIColor.orangeColor()
        m_tittle.textAlignment = NSTextAlignment.Center
        m_tittle.font = UIFont.boldSystemFontOfSize(m_tittle.frame.size.height*0.38)
        m_tittle.adjustsFontSizeToFitWidth = true
        m_tittle.text = self.showTitle()
        self.view.addSubview(m_tittle)
        
        //buttomView scrollerView底色
        let buttomView:UIView = UIView(frame: CGRect(x: 0, y: 0, width:  self.view.frame.size.width*0.88, height:  self.view.frame.size.height/2.5))
        buttomView.center = CGPoint(x:  self.view.frame.size.width/2, y:  self.view.frame.size.height/2)
        buttomView.backgroundColor = UIColor.blueColor()
        buttomView.layer.cornerRadius = buttomView.frame.size.width/15
        self.view.addSubview(buttomView)
        
        //m_scrollerView
        m_scrollerView = UIScrollView(frame: CGRect(x: 0, y: 0, width: buttomView.frame.size.width*0.98, height: buttomView.frame.size.height*0.98))
        m_scrollerView.center = CGPoint(x: self.view.frame.size.width/2, y:  self.view.frame.size.height/2)
        m_scrollerView.backgroundColor = UIColor.blackColor()
        m_scrollerView.contentSize = CGSize(width:  m_scrollerView.frame.size.width * 1.5, height: m_scrollerView.frame.size.height)
        m_scrollerView.layer.cornerRadius = m_scrollerView.frame.size.width/15
        m_scrollerView.showsHorizontalScrollIndicator = true
        m_scrollerView.indicatorStyle = UIScrollViewIndicatorStyle.White
        self.view.addSubview(m_scrollerView)
        
        //m_textLabel
        m_textLabel = UILabel(frame: CGRect(x: 0, y: 0, width: m_scrollerView.contentSize.width, height: m_scrollerView.contentSize.height))
        m_textLabel.backgroundColor = UIColor.blackColor()
        m_textLabel.textColor = UIColor.whiteColor()
        m_textLabel.textAlignment = NSTextAlignment.Left
        m_textLabel.text = self.showTips()
        m_textLabel.numberOfLines = 0
        m_scrollerView.addSubview(m_textLabel)
        
        
        //exitBt 離開按鈕
        let exitBt:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/3, height: self.view.frame.size.width/6))
        exitBt.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/7*6)
        exitBt.setTitle("返回遊戲", forState: UIControlState.Normal)
        exitBt.backgroundColor = UIColor.orangeColor()
        exitBt.layer.cornerRadius = exitBt.frame.size.width/10
        exitBt.titleLabel?.font = UIFont.boldSystemFontOfSize(exitBt.frame.size.height*0.38)
        exitBt.addTarget(self, action: #selector(TipViewController.onExitBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(exitBt)
    }
    
    override func prefersStatusBarHidden() -> Bool {
        
        return true
    }
    
//MARK: - onExitBtAction
//----------------------
    func onExitBtAction(sender:UIButton) {
        
        if m_parentObj != nil {
            
            m_parentObj?.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
//MARK: - showTitle
//------------------
    func showTitle() -> String {
        
        var title:String!
        
        if m_parentObj != nil {
            
            if m_parentObj!.isMemberOfClass(ViewController) {
                
                title = "猜字母解鎖"
            }
            else if m_parentObj!.isMemberOfClass(NextViewController) {
                
                title = "猜數字 2"
            }
            else if m_parentObj!.isMemberOfClass(ThirdViewController) {
                
                title = "猜數字 1"
            }
        }
        
        return title
    }
    
//MARK: - showTips
//-----------------
    func showTips() -> String {
        
        var message:String!
        
        if m_parentObj != nil {
            
            if m_parentObj!.isMemberOfClass(ViewController) {
                
                message = " 1.本單元為猜字母(不是猜單字喔)解鎖的遊戲\n\n 2.捲動鎖頭上面的字母,選擇欲填入的字母\n\n 3.綠點表示字母及位置正確,紅點則是字母正確但位置不對\n\n 4.四個綠點表示解鎖成功"
            }
            else if m_parentObj!.isMemberOfClass(NextViewController) {
                
                message = " 1.本單元為猜數字遊戲\n\n 2.藉由下方的滑桿選擇欲編輯的數字框\n\n 3.選定數字框後,再使用旋轉鈕選擇欲填入的數字 0~9\n\n 4.按下play鍵後隨即顯示數字對錯的訊息\n\n 5.'A' 表示數字及位置都正確,'B' 表示數字正確但位置不對"
            }
            else if m_parentObj!.isMemberOfClass(ThirdViewController) {
                
                m_scrollerView.showsHorizontalScrollIndicator = false
                m_scrollerView.contentSize = CGSize(width: m_scrollerView.frame.size.width, height: m_scrollerView.frame.size.height)
                message = " 1.本單元為猜單一數字遊戲\n\n 2.數字範圍:1~100\n\n 3.直到猜對為止"
            }
        }
        return message
    }
    

}
