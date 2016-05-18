

import UIKit

class ViewController: UIViewController,UIPickerViewDataSource,UIPickerViewDelegate {

    //MARK: pickerView & 確認按鈕 & label 相關宣告
    var m_lockPickerView:UIPickerView? //解鎖pickerView
    var m_pickerViewDic:[String : [String]] = [String : [String]]()
    var ary_numbers:[String] = [String]() //0~9的數字包
    var m_bt:UIButton? //確認按鈕
    var ary_answer:[String] = [String]()//隨機生成四個數字(不可重覆),放入此陣列
    var aryShowNums:[UILabel] = [UILabel]()//顯示 user 選到的 picker 數字
    var m_messageLabel:UILabel? //顯示?綠?紅的數字
    var m_messageBackground:UIView? //顯示?綠?紅的背景
    var m_messageBar:UIView? //顯示?綠?紅的bar條
    var m_messageSeparatedLine:UIView? //顯示條的分隔線
    var m_aryMessageLED = [UIView]() //顯示?綠?紅的LED燈
    var m_aryMessageLabel = [UILabel]() //顯示?綠?紅的訊息
    
    var aryMessageLabel:[UILabel] = [UILabel]()//用來儲存 m_messageLabel 的陣列
    var ary_checkReapt = [String]() //防止確認按鈕一直被重覆按下
    
    //MARK: 動畫相關宣告
    var m_ImgView:UIImageView? //顯示動畫的 imageView
    var aryImgView:[UIImage] = [UIImage]() //lock to Unlock
    var aryLockImgView:[UIImage] = [UIImage]() // unlock to lock
    var isLock:Bool = true //設定一開始鎖住
    var isComplete:Bool = false //猜對 或 中途重玩
    
    //MARK: 選單按鈕相關宣告
    var menuBtbackView:UILabel! //選單背景
    var menuBt:UIButton? //選單按鈕
    var isMenuAppear:Bool = false //判斷菜單是否已顯示
    var blurView:UIVisualEffectView? //產生模糊畫面
    var btAgain:UIButton! //再玩一次按鈕
    var btNumber:UIButton! //猜數字2 按鈕
    var btGuess:UIButton! //猜數字1 按鈕
    var btTip:UIButton! //說明按鈕
    
    //MARK: 其它頁面相關宣告
    var guessView:ThirdViewController? //猜數字1 的頁面
    var numView:NextViewController? //猜數字2 的頁面
    var tipView:TipViewController? //提示頁面
    
    //MARK: - Normal function
    //----------------------------
    func refreash(frame:CGRect) {
        
        self.view.frame = frame
        self.view.backgroundColor = UIColor.darkGrayColor()
        let m_viewFrameW = self.view.frame.size.width
        let m_viewFrameH = self.view.frame.size.height
        
        //m_ImgView
        m_ImgView = UIImageView(frame: CGRect(x: 0, y: 0, width: m_viewFrameW, height:m_viewFrameW))
        m_ImgView?.image = UIImage(named: "lock00.png")
        m_ImgView?.contentMode = UIViewContentMode.ScaleAspectFit
        m_ImgView?.userInteractionEnabled = true
        self.view.addSubview(m_ImgView!)
        
        //m_lockPickerView
        m_lockPickerView = UIPickerView(frame: CGRect(x: 0, y:  m_ImgView!.frame.size.height/4*2.5, width:m_viewFrameW * 0.56, height: m_viewFrameH/7))
        m_lockPickerView?.center.x = m_ImgView!.center.x
        m_lockPickerView?.delegate = self
        m_lockPickerView?.dataSource = self
        m_lockPickerView?.backgroundColor = UIColor.clearColor()
        m_lockPickerView?.showsSelectionIndicator = true
        m_ImgView?.addSubview(m_lockPickerView!)
        
        //m_messageBackground 顯示?綠?紅的背景
        m_messageBackground = UIView(frame: CGRect(x: 0, y: m_ImgView!.frame.size.height/2.2 , width: m_ImgView!.frame.size.width*0.38, height: m_ImgView!.frame.size.height/7))
        m_messageBackground?.center.x = m_ImgView!.center.x
        m_messageBackground?.backgroundColor = UIColor.blackColor()
        m_messageBackground?.layer.cornerRadius = m_messageBackground!.frame.size.width/12
        m_messageBackground?.alpha = 0.5
        m_ImgView?.addSubview(m_messageBackground!)
        
        //m_messageSeparatedLine 顯示條的分隔線
        m_messageSeparatedLine = UIView(frame: CGRect(x: 0, y: 0, width: m_messageBackground!.frame.size.width/77, height: m_messageBackground!.frame.size.height*0.78))
        m_messageSeparatedLine?.center = m_messageBackground!.center
        m_messageSeparatedLine?.backgroundColor = UIColor.blackColor()
        m_messageSeparatedLine?.alpha = 0.38
        self.view.addSubview(m_messageSeparatedLine!)
        
        //m_messageLED
        for  _ in 0 ..< 2 {
            
            let light = UIView(frame: CGRect(x: 0, y: 0, width: m_messageBackground!.frame.size.width/12, height:  m_messageBackground!.frame.size.width/12))
            light.layer.cornerRadius = light.frame.size.width/2
            m_aryMessageLED.append(light)
            self.view.addSubview(light)
        }
        m_aryMessageLED[0].center = CGPoint(x: m_messageBackground!.center.x - m_messageBackground!.frame.size.width/4, y: m_messageBackground!.center.y + m_aryMessageLED[0].frame.size.height)
        m_aryMessageLED[0].backgroundColor = UIColor.greenColor()
        m_aryMessageLED[1].center = CGPoint(x: m_messageBackground!.center.x + m_messageBackground!.frame.size.width/4, y: m_aryMessageLED[0].center.y)
        m_aryMessageLED[1].backgroundColor = UIColor.redColor()
        
        //m_aryMessageLabel
        for label in 0 ..< m_aryMessageLED.count {
            
            let message = UILabel(frame: CGRect(x: 0, y: 0, width: m_messageBackground!.frame.size.width/6, height: m_messageBackground!.frame.size.width/6))
            message.center = CGPoint(x: m_aryMessageLED[label].center.x, y:  m_messageBackground!.center.y - message.frame.size.height/2)
            message.backgroundColor = UIColor.clearColor()
            message.textColor = UIColor.whiteColor()
            message.text = "0"
            message.font = UIFont.boldSystemFontOfSize(message.frame.size.height*0.8)
            message.textAlignment = NSTextAlignment.Center
            m_aryMessageLabel.append(message)
            self.view.addSubview(message)
        }
        
        //m_bt
        m_bt = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/4, height: self.view.frame.size.width/8))
        m_bt?.center = CGPoint(x: self.view.frame.size.width/2, y: frame.size.height/10*6.8)
        m_bt?.layer.cornerRadius = m_bt!.frame.size.width/8
        m_bt?.backgroundColor = UIColor(red: 0.88, green: 0.0, blue: 0.0, alpha: 1.0)
        m_bt?.setTitle("確定", forState: UIControlState.Normal)
        m_bt?.titleShadowColorForState(UIControlState.Highlighted)
        m_bt?.addTarget(self, action: #selector(ViewController.onBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(m_bt!)
        
        //ary_numbers 存放26個字母的陣列
        ary_numbers = ["A","B","C","D","E","F","G","H","I","J","K","L","M",
                       "N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]
        
        //m_pickerViewDic
        m_pickerViewDic = ["0":ary_numbers,
                           "1":ary_numbers,
                           "2":ary_numbers,
                           "3":ary_numbers]
        
        //aryImgView
        for appendPhoto in 0 ..< 4 {
            
            aryImgView.append(UIImage(named: "lock0\(appendPhoto).png")!)
        }
        
        //ary_checkReapt 先給訂一組預設值
        for _ in 0 ..< m_pickerViewDic.keys.count {
            
            ary_checkReapt.append("")
        }
        
        //aryUnImgView
        for  appendUnPhoto in (0...4).reverse() {
            
            aryLockImgView.append(UIImage(named: "lock0\(appendUnPhoto).png")!)
        }
        
        //MARK: menuBt & menuBtbackView
        let menuBtR:CGFloat = self.view.frame.size.height/4.5
        
        //menuBtbackView
        menuBtbackView = UILabel(frame: CGRect(x: -menuBtR/2 , y: self.view.frame.size.height - menuBtR/2 , width: menuBtR, height: menuBtR))
        menuBtbackView.layer.cornerRadius = menuBtbackView.frame.size.width/2
        self.gradient(menuBtbackView)
        self.view.addSubview(menuBtbackView)
        
        //menuBt
        menuBt = UIButton(frame: CGRect(x: 0, y: 0  , width: menuBtR/2, height: menuBtR/2))
        menuBt?.center = CGPoint(x: 0 + menuBtR/6, y: self.view.frame.size.height - menuBtR/5)
        //menuBt?.backgroundColor = UIColor.lightGrayColor()
        menuBt?.backgroundColor = UIColor.clearColor()
        menuBt?.setTitle("選單", forState: UIControlState.Normal)
        menuBt?.addTarget(self, action: #selector(ViewController.onMenuBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBt!)
        
        m_bt?.enabled = true
        self.produceNums()
        self.creatSelectedLabel()//顯示數字的標籤
        m_lockPickerView?.userInteractionEnabled = true
        self.animationPickerViewRow()
        
        
    }
    
    
    //MARK: - Override function
    //----------------------------
    
    override func prefersStatusBarHidden() -> Bool { //隱藏狀態列
        
        return true
    }
    
    //MARK: - UIPickerView DataSource & Delegate
    //-----------------------------------------
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        
        return m_pickerViewDic.keys.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        
        return m_pickerViewDic[ [String](m_pickerViewDic.keys)[component] ]!.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return m_pickerViewDic[[String](m_pickerViewDic.keys)[component]]![row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if aryShowNums.count == m_pickerViewDic.keys.count {
            
            aryShowNums[component].text = m_pickerViewDic[[String](m_pickerViewDic.keys)[component]]![row]
            
        }
        
    }
    
    func pickerView(pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        
        return m_lockPickerView!.frame.size.height/3
    }
    
    
    //MARK: - onBtAction
    //----------------------------
    func onBtAction(sender:UIButton) {
        
        //先確認 ary_answer的元素數量 與 m_pickerViewDic.keys 一樣
        if ary_answer.count == m_pickerViewDic.keys.count {
            
            //判斷四個label是否都有數字
            if self.checkAryShowNums() == true {
                
                //再判斷四個數字是否有重覆
                if self.checkAryshowNumsTextdifferent() == true {//無重覆
                    
                    if self.checkReapetForBt() == true {
                        
                        return
                    }
                    else {
                        
                        m_aryMessageLabel[0].alpha = 0
                        m_aryMessageLabel[1].alpha = 0
                        self.determineResult()
                        self.performSelector(#selector(ViewController.recoverMessageLabelAlpha), withObject: nil, afterDelay: 0.28)
                    }
                    
                }
                else {//其中任兩個數字重覆
                    
                    self.alertShow("密碼不可有重覆的字母")
                    self.removeMessageLabel()
                }
                
            }
            else {
                
                self.alertShow("尚有密碼未選擇")
            }
            
        }
        
    }//end onBtAction
    
    //MARK: - recoverMessageLabelAlpha
    func recoverMessageLabelAlpha () {
        
        m_aryMessageLabel[0].alpha = 1.0
        m_aryMessageLabel[1].alpha = 1.0
    }
    
    
    //MARK: - checkAryshowNums 判斷四個label.text是否都有數字
    //---------------------------------------------------
    func checkAryShowNums() -> Bool {
        
        var isReady:Bool?
        var count:Int = 0
        
        for check in 0 ..< m_pickerViewDic.keys.count {
            
            if aryShowNums[check].text != nil {
                
                count += 1
            }
            
        }
        
        //四個label.text都有數字
        if count == 4 {
            
            isReady = true
        }
        else{
            
            isReady = false
        }
        
        return isReady!
    }
    
    
    //MARK: - checkAryshowNumsdifferent 判斷四個label數字是否有重覆
    //---------------------------------------------------------
    func checkAryshowNumsTextdifferent() -> Bool {
        
        var allDifferent:Bool?
        var count:Int = 0
        var check:Int = 0
        
        for round in 0 ... aryShowNums.count - 1 {
            check = aryShowNums.count - 1
            while check > round {
                
                if aryShowNums[round].text == aryShowNums[check].text {
                    
                    count += 1
                }
                
                check -= 1
            }
            
        }
        
        if count > 0 {
            
            allDifferent = false
        }
        else {
            
            allDifferent = true
        }
        
        return allDifferent!
        
    }//end checkAryshowNumsdifferent function
    
    
    //MARK: - produceNums 隨機產生四個數字
    //----------------------------
    func produceNums() {
        
        var ary_total = ary_numbers
        var total:Int = ary_total.count
        
        //隨機產生四個數字,不可重覆
        for _ in 0 ..< m_pickerViewDic.keys.count {
            
            let num:Int = Int(arc4random() % UInt32(total))
            ary_answer.append(ary_total[num])
            ary_total[num] = ary_total[total-1]
            total -= 1
        }
        
        print("\(ary_answer)")
    }
    
    //MARK: - messageLabel 顯示訊息的標籤
    //----------------------------
    func messageLabel(text:String) {
        
        UIView.beginAnimations("showMessage", context: nil)
        UIView.setAnimationDuration(0.58)
        
        //m_messageLabel
        m_messageLabel = UILabel(frame: CGRect(x: 0, y: self.view.frame.size.height/10*8 -  self.view.frame.size.width/8, width: self.view.frame.size.width/2, height: self.view.frame.size.width/6))
        m_messageLabel?.center = CGPoint(x: self.view.center.x, y: self.view.frame.size.height/10*8)
        m_messageLabel?.backgroundColor = self.view.backgroundColor
        m_messageLabel?.textAlignment = NSTextAlignment.Center
        m_messageLabel?.font = UIFont.boldSystemFontOfSize(m_messageLabel!.frame.size.height * 0.88)
        m_messageLabel?.adjustsFontSizeToFitWidth = true
        m_messageLabel?.textColor = UIColor.cyanColor()
        m_messageLabel?.text = text
        self.view.addSubview(m_messageLabel!)
        aryMessageLabel.append(m_messageLabel!)
        
        UIView.commitAnimations()
        
        
    }
    
    //MARK: - determineResult
    //------------------------
    func determineResult() {
        
        var a:Int = 0 //a代表位置正確且密碼正確
        var b:Int = 0 //b代表密碼正確但位置不對; 如果密碼位置都不對,顯示 0 A 0 B
        
        for compare in 0 ..< ary_answer.count {
            
            //先判斷幾個A
            if aryShowNums[compare].text == ary_answer[compare] {
                
                a += 1
            }
            
            for compareB in 0 ..< ary_answer.count {
                
                //再判斷幾個B
                if aryShowNums[compare].text == ary_answer[compareB] {
                    
                    b += 1
                }
            }
        }
        
        //b要扣除重覆a的次數
        b -= a
        
        //顯示?A?B
        if a == 4 {
            
            m_aryMessageLabel[0].text = "\(a)"
            m_aryMessageLabel[1].text = "\(b)"
            isLock = false
            isComplete = true
            m_lockPickerView?.userInteractionEnabled = false //picker 暫時失效
            m_bt?.enabled = false
            
            //動畫開始
            self.animationStart(aryImgView)
            
        }
        else{
            
            m_aryMessageLabel[0].text = "\(a)"
            m_aryMessageLabel[1].text = "\(b)"
        }
        
        
    }//end determineResult function
    
    
    //MARK: - alertShow
    //----------------------------
    func alertShow(message:String) {
        
        let alert = UIAlertController(title: "注意!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in}))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    //MARK: - checkReapetForBt
    //----------------------------
    func checkReapetForBt() -> Bool {
        
        var checkCount = 0
        var isReapet:Bool?
        
        //判斷有幾個重覆
        for checkIndex in 0 ..< ary_checkReapt.count {
            
            if ary_checkReapt[checkIndex] == aryShowNums[checkIndex].text {
                
                checkCount += 1
            }
        }
        
        if checkCount == 4 { //如果四個數字都沒有變動過
            
            isReapet = true
        }
        else {
            
            for i in 0 ..< ary_checkReapt.count {
                
                ary_checkReapt[i] = aryShowNums[i].text!
            }
            
            isReapet = false
        }
        
        return isReapet!
    }
    
    
    //MARK: - animationView
    //----------------------------
    func animationView(view:UIView) {
        
        view.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height)
        UIView.beginAnimations("animation", context: nil)
        UIView.setAnimationDuration(0.58)
        self.view.addSubview(view)
        view.frame.origin = CGPoint(x: 0, y: self.view.frame.size.height/10*9)
        UIView.commitAnimations()
    }
    
    //MARK: - removeMessageLabelFromSuperViewAndArray
    //----------------------------
    func removeMessageLabel() {
        
        for removeObj in 0 ..< aryMessageLabel.count {
            
            aryMessageLabel[removeObj].removeFromSuperview()
        }
        
        aryMessageLabel.removeAll()
    }
    
    //MARK: - creatSelectedLabel
    //----------------------------
    func creatSelectedLabel() {
        
        //aryShowNums
        let labelWidth:CGFloat =  self.view.frame.size.width/8
        
        for labelIndex in 0 ..< m_pickerViewDic.keys.count {
            
            let label:UILabel = UILabel()
            label.frame = CGRect(x: 0, y: 0, width: labelWidth, height:labelWidth)
            label.center = CGPoint(x:self.view.frame.size.width * CGFloat((labelIndex+2)*2 + 1)/16 , y: self.view.frame.size.height/10*5.8)
            label.backgroundColor = UIColor.clearColor()
            label.textColor = UIColor.whiteColor()
            label.textAlignment = NSTextAlignment.Center
            label.font = UIFont.systemFontOfSize(label.frame.size.height * 0.88)
            aryShowNums.append(label)
            self.view.addSubview(label)
        }
    }
    
    //MARK: - animationPickerViewRow pikcerView歸零
    //--------------------------------------------
    func animationPickerViewRow() {
        
        if m_lockPickerView != nil && m_pickerViewDic.keys.count != 0 {
            
            for component in 0 ..< m_pickerViewDic.keys.count {
                
                m_lockPickerView?.selectRow(10, inComponent: component, animated: true)
            }
        }
    }
    
    //MARK: - animationStart
    //----------------------------
    func animationStart(ary:[UIImage]) {
        
        m_ImgView?.image = nil
        m_ImgView?.animationImages = ary
        m_ImgView?.animationDuration = 0.88
        m_ImgView?.startAnimating()
        
        NSTimer.scheduledTimerWithTimeInterval(0.86, target: self, selector: #selector(ViewController.animationStop(_:)), userInfo: nil, repeats: false)
    }
    
    //MARK: - animationStop
    //----------------------------
    func animationStop(sender:NSTimer) {
        
        m_ImgView?.stopAnimating()
        
        if isLock == false {
            
            m_ImgView?.image = UIImage(named: "lock04.png")
        }
        else if isLock == true {
            
            m_ImgView?.image = UIImage(named: "lock00.png")
            isComplete = false
        }
        
    }
    
    //MARK: - onMenuBtAction 菜單按鈕的方法
    //------------------------------
    func onMenuBtAction(sender:UIButton) {
        
        isMenuAppear = isMenuAppear == false ? true : false
        
        self.blurEffectAction()
        self.showSelectedView()
        self.view.bringSubviewToFront(menuBtbackView)
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
            btTip.addTarget(self, action: #selector(ViewController.onChanegeViewAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btTip)
            self.view.addSubview(btTip)
            
            //btAgain
            let btAgain_position = self.getPosition(btD*3.5, angle: 35) //取得 bt1 的展開座標
            btAgain = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btAgain.layer.cornerRadius = btAgain.frame.size.width/2
            btAgain.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btAgain.setTitle("再一次", forState: UIControlState.Normal)
            btAgain.addTarget(self, action: #selector(ViewController.onAgainBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btAgain)
            self.view.addSubview(btAgain)
            
            //btLetter
            let btNum_position = self.getPosition(btD*3.5, angle: 55) //取得 bt2 的展開座標
            btNumber = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btNumber.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btNumber.layer.cornerRadius = btNumber.frame.size.width/2
            btNumber.setTitle("猜數字2", forState: UIControlState.Normal)
            self.gradient(btNumber)
            btNumber.addTarget(self, action: #selector(ViewController.onChanegeViewAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.view.addSubview(btNumber)
            
            //btGuess
            let btGuess_position = self.getPosition(btD*3.5, angle: 75)
            btGuess = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btGuess.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btGuess.layer.cornerRadius = btGuess.frame.size.width/2
            btGuess.setTitle("猜數字1", forState: UIControlState.Normal)
            btGuess.addTarget(self, action: #selector(ViewController.onChanegeViewAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btGuess)
            self.view.addSubview(btGuess)
            
            //選單出現時的動畫
            UIView.beginAnimations("btShowAnimation", context: nil)
            UIView.setAnimationDuration(0.38)
            btNumber.center = CGPoint(x: btNum_position.x, y:  btNum_position.y)
            btAgain.center = CGPoint(x: btAgain_position.x, y: btAgain_position.y)
            btTip.center = CGPoint(x: btTip_position.x, y: btTip_position.y)
            btGuess.center = CGPoint(x: btGuess_position.x, y: btGuess_position.y)
            UIView.commitAnimations()
        }
        else{
            
            //選單關閉時的動畫
            menuBt?.setTitle("選單", forState: UIControlState.Normal)
            UIView.beginAnimations("btHideAnimation", context: nil)
            UIView.setAnimationDuration(0.38)
            btAgain.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btNumber.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btTip.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btGuess.center = CGPoint(x: 0, y: self.view.frame.size.height)
            UIView.commitAnimations()
            
            //延遲
            self.performSelector(#selector(ViewController.removeBts), withObject: nil, afterDelay: 0.39)
            
        }
    }
    
    //MARK: - onChanegeViewAction 切換至其它頁面
    //----------------------------
    func onChanegeViewAction(sender:UIButton) {
        
        isMenuAppear = false
        isLock = true
        self.removeBts()
        
        if sender == btGuess {
            
            if guessView == nil {
                
                guessView = ThirdViewController()
                guessView?.refreashFrame(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
            }
            
            guessView?.m_parentObj = self
            self.presentViewController(guessView!, animated: true, completion: nil)
        }
        else if sender == btNumber {
            
            if numView == nil {
                
                numView = NextViewController()
            }
            
            self.presentViewController(numView!, animated: true, completion: nil)
        }
        else if sender == btTip {
            
            if tipView == nil {
                
                tipView = TipViewController()
            }
            
            tipView?.m_parentObj = self
            self.presentViewController(tipView!, animated: true, completion: nil)
        }
        
        
    }
    
    
    
    //MARK: - onAgainBtAction 再玩一次
    //----------------------------
    func onAgainBtAction(sender:UIButton) {
        
        isMenuAppear = false
        isLock = true
        
        self.removeBts()
        ary_answer.removeAll() //刪除舊的四個隨機數字
        
        //刪除顯示在標籤上的數字
        for removeFromIndex in 0 ..< aryShowNums.count {
            
            aryShowNums[removeFromIndex].removeFromSuperview()
        }
        
        aryShowNums.removeAll()
        
        self.produceNums() //產生新的四個隨機數字
        
        self.removeMessageLabel()
        
        self.creatSelectedLabel()
        
        self.animationPickerViewRow()
        
        m_bt?.enabled = true
        m_lockPickerView?.userInteractionEnabled = true
        
        m_aryMessageLabel[0].text = "0"
        m_aryMessageLabel[1].text = "0"
        
        if isComplete == true {//有全程玩完且答對
            
            //unLock to lock animation動畫
            self.animationStart(aryLockImgView)
        }
    }
    
    
    
    //MARK: - blurEffectAction 產生模糊畫面
    //------------------------------
    func blurEffectAction(){
        
        if isMenuAppear == true {
            
            if blurView == nil {
                
                //生成一個模糊效果 , 有 ExtraLight  Light  Dark 可選
                let blurEffect:UIBlurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
                
                //生成一個可呈現(掛載)某些視覺效果的 UIVisualEffectview
                blurView = UIVisualEffectView(effect: blurEffect)
                blurView?.frame = self.view.frame
                blurView?.center = self.view.center
                blurView?.alpha = 0.88
            }
            
            //將UIVisualEffectView 加到 self.view
            self.view.addSubview(blurView!)
        }
    }
    
    //MARK: - removeBts 移除按鈕
    //------------------------------
    func removeBts() {
        
        if btAgain != nil && btNumber != nil {
            
            btAgain.removeFromSuperview()
            btNumber.removeFromSuperview()
            btTip.removeFromSuperview()
            btGuess.removeFromSuperview()
            blurView?.removeFromSuperview() //移除模糊畫面
            menuBt?.setTitle("選單", forState: UIControlState.Normal)
        }
    }
    
    //MARK: - getPosition (取得圓弧形座標)
    //------------------------------
    func getPosition(r:CGFloat,angle:CGFloat) -> CGPoint {
        
        let originPosition = CGPoint(x: 0, y: self.view.frame.size.height)
        let radian = angle * CGFloat(M_PI) / 180 //角度轉弧度(徑度)
        
        let endPosition:CGPoint = CGPoint(x: originPosition.x + cos(radian)*r, y:originPosition.y - sin(radian)*r)
        //endPosition.y = originPosition.y - sin(radian)*r
        //endPosition.x = originPosition.x + cos(radian)*r
        
        return endPosition
    }
    
    //MARK: - gradient 漸層顏色 (圓形)
    //------------------------------
    func gradient(view:UIView){
        
        let color1 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.98)
        let color2 = UIColor(red: 1.0, green: 0.45, blue: 0.0, alpha: 1.0)
        let color3 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.98)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [color1.CGColor,color2.CGColor,color3.CGColor]
        gradient.cornerRadius = view.frame.size.width/2
        view.layer.insertSublayer(gradient, atIndex: 0)
    }
    

}//end class

