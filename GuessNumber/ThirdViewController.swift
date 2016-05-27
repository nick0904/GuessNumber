

import UIKit

class ThirdViewController: UIViewController,UITextFieldDelegate {

    // Basic 相關宣告
    var aryImgView = [UIImageView]()
    var answer:Int?
    var answerLabel:UILabel?
    var guessNum:UITextField?
    var guessBt:UIButton?
    var m_min:Int = 1
    var m_max:Int = 100
    var rangeLabel:UILabel?
    var messageLabel:UILabel?
    var count:Int? = 0
    var num:Int?
    
    // 選單 相關宣告
    var isMenuAppear:Bool = false //設定選單一開始關閉
    var menuBtbackView:UIView? //選單背景
    var menuBt:UIButton? //選單按鈕
    var btAgain:UIButton! //再玩一次按鈕
    var btLetter:UIButton! //猜字母按鈕
    var btTip:UIButton!  //說明按鈕
    var btNumber:UIButton! //猜數字2 按鈕
    var blurView:UIVisualEffectView? //產生模糊畫面
    
    // 其它頁面相關宣告
    var letterView:ViewController? //猜字母頁面
    var numView:NextViewController? //猜數字2頁面
    var tipView:TipViewController?
    var m_parentObj:AnyObject?
    
//MARK: - Normal function
//-----------------------
    func refreashFrame(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor(red: 0.0, green: 0.7, blue: 0.9, alpha: 1.0)
        
        //cloud and sun 生成雲朵及太陽公公
        for i in 0 ..< 3 {
            
            let imgView:UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
            aryImgView.append(imgView)
            aryImgView[i].image = UIImage(named: String(format:"cloud_%d.png",i))
            self.view.addSubview(aryImgView[i])
        }
        aryImgView[0].center = CGPoint(x: self.view.frame.size.width/2, y: 110)
        aryImgView[1].center = CGPoint(x: aryImgView[0].center.x - 50, y: aryImgView[0].center.y + 30)
        aryImgView[2].center = CGPoint(x: aryImgView[0].center.x + 66, y: aryImgView[0].center.y - 10)
        
        //guessNum
        guessNum = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        guessNum?.center = CGPoint(x: aryImgView[0].center.x, y: aryImgView[0].center.y + 180)
        guessNum?.backgroundColor = UIColor.whiteColor()
        guessNum?.layer.cornerRadius = 10.0
        guessNum?.font = UIFont.boldSystemFontOfSize(45)
        guessNum?.textAlignment = NSTextAlignment.Center
        guessNum?.keyboardType = .NumberPad
        guessNum?.keyboardAppearance = UIKeyboardAppearance.Dark
        guessNum?.placeholder = "輸入數字"
        guessNum?.clearsOnBeginEditing = true
        guessNum?.delegate = self
        self.view.addSubview(guessNum!)
        
        //guessBt
        guessBt = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        guessBt!.center = CGPoint(x: guessNum!.center.x + 145 , y: guessNum!.center.y)
        guessBt!.layer.cornerRadius = guessBt!.frame.size.width/2
        guessBt!.backgroundColor = UIColor.orangeColor()
        guessBt!.setTitle("確定", forState: UIControlState.Normal)
        guessBt!.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        guessBt!.addTarget(self, action: #selector(ThirdViewController.guessBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(guessBt!)
        
        //rangeLabel
        rangeLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        rangeLabel?.center = CGPoint(x: guessNum!.center.x, y: guessNum!.center.y + 100)
        rangeLabel?.text = "請猜一個數字:1~100"
        rangeLabel?.textAlignment = NSTextAlignment.Center
        rangeLabel?.textColor = UIColor.yellowColor()
        rangeLabel?.font = UIFont.boldSystemFontOfSize(rangeLabel!.frame.size.height*0.58)
        rangeLabel?.adjustsFontSizeToFitWidth = true
        self.view.addSubview(rangeLabel!)
        
        //messageLabel
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        messageLabel!.center = CGPoint(x: self.view.frame.size.width/2, y: (guessNum?.center.y)! + 180)
        messageLabel!.textColor = UIColor.whiteColor()
        messageLabel!.font = UIFont.boldSystemFontOfSize(messageLabel!.frame.size.height*0.58)
        messageLabel!.textAlignment = NSTextAlignment.Center
        
        //answer
        answer = Int(arc4random() % 100 + 1)
        print("init:\(answer!)")
        
        //MARK: menuBt & menuBtbackView
        let menuBtR:CGFloat = self.view.frame.size.height/4.5
        //menuBtbackView
        menuBtbackView = UIView(frame: CGRect(x: 0, y: 0, width: menuBtR, height: menuBtR))
        menuBtbackView?.center = CGPoint(x: 0, y: self.view.frame.size.height)
        menuBtbackView?.layer.cornerRadius = menuBtbackView!.frame.size.width/2
        self.view.addSubview(menuBtbackView!)
        self.gradient(menuBtbackView!)
        
        
        //menuBt
        menuBt = UIButton(frame: CGRect(x: 0, y: 0  , width: menuBtR/2, height: menuBtR/2))
        menuBt?.center = CGPoint(x: 0 + menuBtR/6, y: self.view.frame.size.height - menuBtR/5)
        menuBt?.backgroundColor = UIColor.clearColor()
        menuBt?.setTitle("選單", forState: UIControlState.Normal)
        menuBt?.addTarget(self, action: #selector(ThirdViewController.onMenuBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBt!)
    }
    
    
//MARK: - 限制輸入的數字長度
//-----------------------
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        
        if textField == guessNum {
            
            if textField.text!.characters.count + string.characters.count > 3 && string.characters.count > 0 {
                
                let alert:UIAlertController = UIAlertController(title: "注 意", message: "最多輸入3個數字", preferredStyle: UIAlertControllerStyle.Alert)
                let cancelAction:UIAlertAction = UIAlertAction(title: "確 定", style: UIAlertActionStyle.Default, handler: { (UIAlertAction) -> Void in})
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
                
                return false
            }
            
        }
        
        return true
    }
    
//MARK: - BtAction
//----------------
    func guessBtAction(sender:UIButton){
        
        guessNum?.resignFirstResponder()//鍵盤消失
        
        num = Int(guessNum!.text!)
        
        if num == nil {
            
            messageLabel?.text = "請先輸入數字"
            self.view.addSubview(messageLabel!)
            return
            
        }
        
        count! += 1
        guessBt?.enabled = false
        
        if num < m_min || num > m_max {
            
            guessNum?.clearsOnBeginEditing = true
            messageLabel?.text = "超出範圍 請重新輸入"
            self.guessBtReAction()
        }
        else if m_min <= num && num <= m_max {
            
            if num == answer {
                
                rangeLabel?.text = "正確答案"
                
                //answerLabel
                answerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
                answerLabel?.center = CGPoint(x: 100, y: 100)
                answerLabel?.textColor = UIColor.whiteColor()
                answerLabel?.textAlignment = NSTextAlignment.Center
                answerLabel?.font = UIFont.systemFontOfSize(answerLabel!.frame.size.width * 0.58)
                answerLabel?.adjustsFontSizeToFitWidth = true
                answerLabel?.text = "\(num!)"
                aryImgView[0].addSubview(answerLabel!)
                
                //雲朵動畫
                self.viewMove(aryImgView[1], centerLocationTo: CGPoint(x: 0, y: aryImgView[1].center.y))
                self.viewMove(aryImgView[2], centerLocationTo: CGPoint(x: self.view.frame.size.width, y: aryImgView[2].center.y))
                
                messageLabel?.text = "一共猜了\(count!)次"
                
                answer = nil
                
                guessNum?.enabled = false
            }
            else if num < answer {
                
                guessNum?.clearsOnBeginEditing = true
                m_min = num!
                rangeLabel?.text = "數字介於 \(m_min) ~ \(m_max)"
                messageLabel?.text = "猜錯了 再猜一次"
                self.guessBtReAction()
                
            }
            else if num > answer {
                
                guessNum?.clearsOnBeginEditing = true
                m_max = num!
                rangeLabel?.text = "數字介於 \(m_min) ~ \(m_max)"
                messageLabel?.text = "猜錯了 再猜一次"
                self.guessBtReAction()
            }
            
        }
        
        self.view.addSubview(messageLabel!)
    }
    
//MARK: - onRestartAction (再玩一次)
//---------------------------------
    func onRestartAction(sender:UIButton){
        
        isMenuAppear = false
        self.removeBts()
        
        //雲朵太陽歸位
        self.viewMove(aryImgView[1], centerLocationTo: CGPoint(x:aryImgView[0].center.x - 50, y: aryImgView[0].center.y + 30))
        self.viewMove(aryImgView[2], centerLocationTo: CGPoint(x:  aryImgView[0].center.x + 66, y: aryImgView[0].center.y - 10))
        
        rangeLabel?.text = "請猜一個數字:1~100"
        guessNum?.text = ""
        messageLabel?.removeFromSuperview()
        self.guessBtReAction()
        guessNum?.enabled = true
        answerLabel?.removeFromSuperview()
        
        m_max = 100
        m_min = 1
        count = 0
        
        //answer重置
        answer = Int(arc4random() % 100 + 1)
        print("restart:\(answer!)")
        
    }
    
//MARK: - 讓guessBt恢復功能
//------------------------
    func guessBtReAction(){
        
        guessBt?.enabled = true
    }
    
//MARK: - viewMove (雲朵移動)
//--------------------------
    func viewMove(imageView:UIImageView, centerLocationTo:CGPoint){
        
        UIView.beginAnimations("cloudMove", context: nil)
        UIView.setAnimationDuration(2.0)
        imageView.center = CGPoint(x: centerLocationTo.x, y: centerLocationTo.y)
        UIView.commitAnimations()
        
    }
    
    
//MARK: - Override Function
//-------------------------
    override func prefersStatusBarHidden() -> Bool {
        
        return true
    }
    
//MARK: - onMenuBtAction 菜單按鈕的方法
//----------------------------------
    func onMenuBtAction(sender:UIButton) {
        
        isMenuAppear = isMenuAppear == false ? true : false
        
        self.blurEffectAction()
        self.showSelectedView()
        self.view.bringSubviewToFront(menuBtbackView!)
        self.view.bringSubviewToFront(menuBt!)
        
    }
    
//MARK: - showSelectedView 產生菜單
//------------------------------
    func showSelectedView() {
        
        if isMenuAppear == true {
            
            menuBt?.setTitle("返回", forState: UIControlState.Normal)
            let btD:CGFloat = self.view.frame.size.width/5 //設定圓形按鈕的直徑
            
            //btTip
            let btTip_position = self.getPosition(btD*3.5, angle: 15)
            btTip = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btTip.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btTip.layer.cornerRadius = btTip.frame.size.width/2
            btTip.setTitle("提示", forState: UIControlState.Normal)
            btTip.addTarget(self, action: #selector(ThirdViewController.onChanegeViewAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btTip)
            self.view.addSubview(btTip)
            
            
            //btAgain
            let btAgain_position = self.getPosition(btD*3.5, angle: 35) //取得 bt1 的展開座標
            btAgain = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btAgain.layer.cornerRadius = btAgain.frame.size.width/2
            btAgain.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btAgain.setTitle("再一次", forState: UIControlState.Normal)
            btAgain.addTarget(self, action: #selector(ThirdViewController.onRestartAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btAgain)
            self.view.addSubview(btAgain)
            
            //btLetter
            let btLetter_position = self.getPosition(btD*3.5, angle: 55) //取得 bt2 的展開座標
            btLetter = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btLetter.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btLetter.layer.cornerRadius = btLetter.frame.size.width/2
            btLetter.setTitle("猜字母", forState: UIControlState.Normal)
            btLetter.addTarget(self, action: #selector(ThirdViewController.onChanegeViewAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btLetter)
            self.view.addSubview(btLetter)
            
            //btLetter
            let btNum_position = self.getPosition(btD*3.5, angle: 75) //取得 bt2 的展開座標
            btNumber = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btNumber.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btNumber.layer.cornerRadius = btNumber.frame.size.width/2
            btNumber.setTitle("猜數字2", forState: UIControlState.Normal)
            self.gradient(btNumber)
            btNumber.addTarget(self, action: #selector(ThirdViewController.onChanegeViewAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(btNumber)
            
            //選單出現時的動畫
            UIView.beginAnimations("btShowAnimation", context: nil)
            UIView.setAnimationDuration(0.38)
            btLetter.center = CGPoint(x: btLetter_position.x, y:  btLetter_position.y)
            btAgain.center = CGPoint(x: btAgain_position.x, y: btAgain_position.y)
            btNumber.center = CGPoint(x: btNum_position.x, y:  btNum_position.y)
            btTip.center = CGPoint(x: btTip_position.x, y: btTip_position.y)
            UIView.commitAnimations()
        }
        else{
            
            //選單關閉時的動畫
            menuBt?.setTitle("選單", forState: UIControlState.Normal)
            UIView.beginAnimations("btHideAnimation", context: nil)
            UIView.setAnimationDuration(0.38)
            btAgain.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btLetter.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btTip.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btNumber.center = CGPoint(x: 0, y: self.view.frame.size.height)
            UIView.commitAnimations()
            self.performSelector(#selector(ThirdViewController.removeBts), withObject: nil, afterDelay: 0.39)
        }
    }
    
//MARK: - onChanegeViewAction 切換至其它頁面
//----------------------------------------
    func onChanegeViewAction(sender:UIButton) {
        
        isMenuAppear = false
        self.removeBts()
        
        if sender == btTip { //切換至提示頁面
            
            if tipView == nil {
                
                tipView = TipViewController()
            }
            
            tipView?.m_parentObj = self
            self.presentViewController(tipView!, animated: true, completion: nil)
        }
        else if sender == btLetter { //切換至猜字母頁面
            
            if letterView == nil {
                
                letterView = ViewController()
                letterView?.refreash(self.view.frame)
            }
            
            self.presentViewController(letterView!, animated: true, completion: nil)
        }
        else if sender == btNumber { //切換至猜數字2 頁面
            
            if numView == nil {
                
                numView = NextViewController()
            }
            
            self.presentViewController(numView!, animated: true, completion: nil)
        }
    }
    
//MARK: - removeBts 移除按鈕
//-------------------------
    func removeBts() {
        
        if btAgain != nil && btLetter != nil {
            
            btAgain.removeFromSuperview()
            btLetter.removeFromSuperview()
            btTip.removeFromSuperview()
            btNumber.removeFromSuperview()
            blurView?.removeFromSuperview() //移除模糊畫面
            menuBt?.setTitle("選單", forState: UIControlState.Normal)
        }
    }
    
//MARK: - blurEffectAction 產生模糊畫面
//-----------------------------------
    func blurEffectAction(){
        
        if isMenuAppear == true {
            
            if blurView == nil {
                
                //生成一個模糊效果 , 有 ExtraLight  Light  Dark 可選
                let blurEffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                
                //生成一個可呈現(掛載)某些視覺效果的 UIVisualEffectview
                blurView = UIVisualEffectView(effect: blurEffect)
                blurView?.frame = self.view.frame
                blurView?.center = self.view.center
            }
            
            //將UIVisualEffectView 加到 self.view
            self.view.addSubview(blurView!)
        }
        
    }
    
//MARK: - getPosition (取得圓弧形座標)
//---------------------------------
    func getPosition(r:CGFloat,angle:CGFloat) -> CGPoint {
        
        let originPosition = CGPoint(x: 0, y: self.view.frame.size.height)
        let radian = angle * CGFloat(M_PI) / 180
        
        var endPosition:CGPoint = CGPoint(x: 0, y: self.view.frame.size.height)
        endPosition.y = originPosition.y - sin(radian)*r
        endPosition.x = originPosition.x + cos(radian)*r
        
        return endPosition
    }
    
//MARK: - gradient 漸層顏色 (圓形)
//------------------------------
    func gradient(view:UIView){
        
        let color1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.98)
        let color2 = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 1.0)
        let color3 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.98)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [color1.CGColor,color2.CGColor,color3.CGColor]
        gradient.cornerRadius = view.frame.size.width/2
        view.layer.insertSublayer(gradient, atIndex: 0)
    }

}
