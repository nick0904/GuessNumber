

import UIKit

class NextViewController: UIViewController {

    //playBt 相關宣告
    var playBt:UIButton?
    
    //rotationBt 相關宣告
    var ary_circleNum = [UILabel]()
    var m_rotationBt:RotationBtView?
    var bradgeIndex:Int?
    
    //slider相關宣告
    var m_slider:UISlider? //選項滑桿
    var ary_sliderNumIndex = [UILabel]() //顯示滑桿數字
    var m_currentSliderIntValue:Int = 1 //讀取滑桿目前的值
    
    //顯示數字的label
    var ary_numLabel = [UILabel]()
    var ary_currentValue = [String]()
    
    //顯示?A?B的訊息
    var m_message:MyImgView?
    
    
    var ary_numbers:[String] = [String]() //0~9的數字包
    var ary_answer:[String] = [String]()//隨機生成四個數字(不可重覆),放入此陣列
    
    //選單 相關宣告
    var menuBtbackView:UILabel! //選單背景
    var menuBt:UIButton? //選單按鈕
    var isMenuAppear:Bool = false //判斷菜單是否已顯示
    var btAgain:UIButton! //再玩一次按鈕
    var btLetter:UIButton! //猜字母按鈕
    var btGuess:UIButton! //猜數字1 按鈕
    var btTip:UIButton! //說明按鈕
    var blurView:UIVisualEffectView? //產生模糊畫面
    
    //切換頁面 相關宣告
    var guessView:ThirdViewController?
    var letterView:ViewController?
    var tipView:TipViewController?
    
    //計時器是否在運作
    var m_timer:NSTimer?
    var isTimerActivity:Bool = false
    
    
    
//MARK: - Override Function
//-------------------------
    override func prefersStatusBarHidden() -> Bool { //隱藏狀態列
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.blackColor()
        
        //****************  m_message  ****************
        m_message = MyImgView()
        m_message?.refreashWithFrame(CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height/3))
        self.view.addSubview(m_message!)
        
        
        //****************  playBt  ****************
        playBt = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width/4, height: self.view.frame.size.width/4))
        playBt?.center = CGPoint(x: self.view.frame.size.width/4*3, y: self.view.frame.size.height/8*5)
        playBt?.setImage(UIImage(named: "playBt_0.png"), forState: UIControlState.Normal)
        playBt?.setImage(UIImage(named: "playBt_1.png"), forState: UIControlState.Highlighted)
        playBt?.enabled = false
        playBt?.addTarget(self, action: #selector(NextViewController.onPlayBtAction(_:)), forControlEvents: .TouchUpInside)
        self.view.addSubview(playBt!)
        
        //****************  create NumberAround 生成環形數字  ****************
        let angle =  CGFloat (M_PI * 2 / 10) //間隔30度
        
        let labelWidth:CGFloat = self.view.frame.size.width/5.5
        
        for circleNum in 0 ..< 10 {
            
            let label = UILabel(frame: CGRect(x: 0, y: 0, width:labelWidth , height:labelWidth))
            
            label.center = CGPoint(x: self.view.frame.size.width/3.5 + label.frame.size.width * CGFloat(sinf(Float(angle * CGFloat(circleNum+5)))), y: self.view.frame.size.height/8*5 + label.frame.size.height * CGFloat(cosf(Float(angle * CGFloat(circleNum+5)))))
            
            label.font = UIFont.systemFontOfSize(label.frame.size.height/3.5)
            label.textAlignment = NSTextAlignment.Center
            label.textColor = UIColor.whiteColor()
            label.text = String(circleNum)
            ary_circleNum.append(label)
            self.view.addSubview(label)
        }
        
        //****************  rotationBt 旋轉按鈕  ****************
        let rotationBtR:CGFloat = self.view.frame.size.width/2.8
        m_rotationBt = RotationBtView(frame: CGRect(x: 0, y: 0, width: rotationBtR, height: rotationBtR))
        m_rotationBt?.center = CGPoint(x: self.view.frame.size.width/3.5, y: self.view.frame.size.height/8*5)
        m_rotationBt?.userInteractionEnabled = false
        self.view.addSubview(m_rotationBt!)
        
        //****************  m_slider  ****************
        m_slider = UISlider(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width*0.88, height: 50))
        m_slider?.center = CGPoint(x: self.view.frame.size.width/2, y: self.view.frame.size.height/10*8.15)
        m_slider?.setThumbImage(UIImage(named: "thumb_0.png"), forState: UIControlState.Normal)
        m_slider?.setThumbImage(UIImage(named: "thumb_1.png"), forState: UIControlState.Highlighted)
        m_slider?.tintColor = UIColor.redColor()
        m_slider?.minimumValue = 1.0
        m_slider?.maximumValue = 4.9
        m_slider?.value = 1.0
        m_slider?.addTarget(self, action: #selector(NextViewController.onSliderAction(_:)), forControlEvents: UIControlEvents.ValueChanged)
        self.view.addSubview(m_slider!)
        
        //****************  ary_numLabel  ****************
        self.createNumLabel()
        
        //****************  ary_sliderNumIndex  ****************
        let sliderNumIndexLabelW = m_slider!.frame.size.width/4
        let spaceX = (self.view.frame.size.width - m_slider!.frame.size.width) / 2
        let spaceY = self.view.frame.size.height/10
        for row in 0 ..< 2 {
            
            for column in 0 ..< 4 {
                
                let label = UILabel(frame: CGRect(x: spaceX + sliderNumIndexLabelW * CGFloat(column), y: self.view.frame.size.height/10*7.5 + spaceY*CGFloat(row), width:sliderNumIndexLabelW, height: sliderNumIndexLabelW/4))
                label.text = "\(column+1)"
                label.textColor = UIColor.whiteColor()
                label.textAlignment = NSTextAlignment.Center
                label.font = UIFont.boldSystemFontOfSize(label.frame.size.height)
                ary_sliderNumIndex.append(label)
                self.view.addSubview(label)
            }
            
        }
        
        //****************  menuBt & menuBtbackView  ****************
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
        menuBt?.addTarget(self, action: #selector(NextViewController.onMenuBtAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(menuBt!)
        
        //****************  ary_numbers 0~9的數字包  ****************
        for numIndex in 0 ..< 10 {
            
            ary_numbers.append(String(numIndex))
        }
        
        //****************  ary_checkReapt 先給訂一組預設值  ****************
        for _ in 0 ..< 4 {
            
            ary_checkReapt.append("")
        }
        
        self.produceNums()
    }
    
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        m_timer?.invalidate()
        isTimerActivity = false
        bradgeIndex = nil
        m_rotationBt?.userInteractionEnabled = false
    }
    
//MARK: - createNumLabel
//----------------------
    func createNumLabel() {
        
        //****************  ary_numLabel 顯示數字的標籤  ****************
        let sideLength:CGFloat = self.view.frame.size.width/4 * 3/4
        let space:CGFloat = (self.view.frame.size.width - 4*sideLength)/5
        
        for labelIndex in 0 ..< 4 {
            
            let label:UILabel = UILabel(frame: CGRect(x: space*CGFloat(labelIndex+1) + sideLength*CGFloat(labelIndex), y: self.view.frame.size.height/3 + space, width: sideLength, height: sideLength))
            label.layer.cornerRadius = label.frame.size.width*0.18
            label.layer.masksToBounds = true //UILAbel 圓角設置重點
            label.backgroundColor = UIColor.darkGrayColor()
            label.textColor = UIColor.whiteColor()
            label.text = "" //label.text 預設為空值
            label.font = UIFont.boldSystemFontOfSize(label.frame.size.height*0.68)
            label.textAlignment = NSTextAlignment.Center
            ary_numLabel.append(label)
            ary_currentValue.append(label.text!)
            self.view.addSubview(label)
        }
    }
    
//MARK: - onSliderAction 滑桿移動時呼叫的方法
//----------------------------------------
    func onSliderAction(sender:UISlider) {
        
        m_timer = NSTimer.scheduledTimerWithTimeInterval(1/20, target: self, selector: #selector(NextViewController.labelStrByRotationBt), userInfo: nil, repeats: true)
        isTimerActivity = true
        
        m_rotationBt?.userInteractionEnabled = true
        playBt?.enabled = true
        m_currentSliderIntValue = Int(m_slider!.value)
        
        //slider上的數字變色
        for check in 0 ..< ary_sliderNumIndex.count {
            
            if String(m_currentSliderIntValue) == ary_sliderNumIndex[check].text {
                
                ary_sliderNumIndex[check].textColor = UIColor.redColor()
            }
            else {
                
                ary_sliderNumIndex[check].textColor = UIColor.whiteColor()
            }
        }
        
        //label顯示數字框變色
        for changeColor in 0 ..< ary_numLabel.count {
            
            if ary_sliderNumIndex[changeColor].textColor == UIColor.redColor() {
                
                ary_numLabel[changeColor].backgroundColor = UIColor.redColor()
                bradgeIndex = changeColor
                if ary_currentValue[changeColor] != "" {
                    
                    m_rotationBt?.rotationValue = ary_currentValue[changeColor]
                    m_rotationBt?.referenceAngle(m_rotationBt!.rotationValue)
                }
            }
            else {
                
                ary_numLabel[changeColor].backgroundColor = UIColor.darkGrayColor()
            }
        }
        
    }
    
    

    var date:NSDate = NSDate(timeIntervalSinceNow: 0.1)
    
//MARK: - labelStrByRotationBt
//--------------------------------
    func labelStrByRotationBt() {
        
        
        if bradgeIndex == nil || m_rotationBt?.userInteractionEnabled == false {
            
            return
        }
        
        if isTimerActivity == true {
            
            if ary_numLabel[bradgeIndex!].text == "" {
                
                m_rotationBt?.rotationValue = "0"
                m_rotationBt?.referenceAngle("0")
                self.getRotationBtValue()
                ary_circleNum[0].textColor = UIColor.redColor()
            }
            else {
                
                self.getRotationBtValue()
                
                //環形數字變色
                for numberAroundIndex in 0 ..< ary_circleNum.count {
                    
                    if String(numberAroundIndex) == m_rotationBt?.rotationValue {
                        
                        ary_circleNum[numberAroundIndex].textColor = UIColor.redColor()
                    }
                    else {
                        
                        ary_circleNum[numberAroundIndex].textColor = UIColor.whiteColor()
                    }
                    
                }
                
            }

            
        }
        
    }
    
    
    func getRotationBtValue(){
        
        ary_numLabel[bradgeIndex!].text = m_rotationBt!.rotationValue
        ary_currentValue[bradgeIndex!] = ary_numLabel[bradgeIndex!].text!
        
    }
    
    
    
//MARK: - onPlayBtAction
//-----------------------
    func onPlayBtAction(sender:UIButton) {
        
        if self.checkAryNumLabels() == true {// 是否都有數字
            
            if self.checkAryNumLabelsDifferent() == true { //是否有重覆的數字
                
                if self.checkReapetForBt() == true {
                    
                    return
                }
                else {
                    
                    m_message?.messageLabel.alpha = 0.0
                    self.performSelector(#selector(NextViewController.recoverMessageLabelAlpha), withObject: nil, afterDelay: 0.08)
                    self.determineResult()
                }
                
            }
            else {
                
                self.alertShow("數字不可重覆")
            }
            
        }
        else {
            
            self.alertShow("尚有數字未選擇")
        }
        
    }
    
    func recoverMessageLabelAlpha(){
        
        m_message?.messageLabel.alpha = 1.0
    }
    
//MARK: - produceNums 隨機產生四個數字
//----------------------------
    func produceNums() {
        
        var ary_total = ary_numbers
        var total:Int = ary_total.count
        
        //隨機產生四個數字,不可重覆
        for _ in 0 ..< 4 {
            
            let num:Int = Int(arc4random() % UInt32(total))
            ary_answer.append(ary_total[num])
            ary_total[num] = ary_total[total-1]
            total -= 1
        }
        
        print("\(ary_answer)")
    }
    
    
//MARK: - checkAryNumLabelsDifferent 判斷四個label數字是否有重覆
//----------------------------------------------------------
    func checkAryNumLabelsDifferent() -> Bool {
        
        var allDifferent:Bool?
        var count:Int = 0
        var check:Int = 0
        
        for round in 0 ..< ary_numLabel.count - 1 {
            
            check = ary_numLabel.count - 1
            
            while check > round {
                
                if ary_numLabel[round].text == ary_numLabel[check].text {
                    
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
        
    }
    
    
//MARK: - checkAryNumLabels 判斷四個label.text是否都有數字
//-----------------------------------------------------
    func checkAryNumLabels() -> Bool {
        
        var isReady:Bool?
        var count:Int = 0
        
        for check in 0 ..< ary_numLabel.count {
            
            if ary_numLabel[check].text != "" {
                
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
    
    
//MARK: - checkReapetForBt 避免playBt被重覆按下(防呆用)
//-------------------------------------------------
    var ary_checkReapt = [String]() //防止playBt一直被重覆按下
    
    func checkReapetForBt() -> Bool {
        
        var checkCount = 0
        var isReapet:Bool?
        
        //判斷有幾個重覆
        for checkIndex in 0 ..< ary_checkReapt.count {
            
            if ary_checkReapt[checkIndex] == ary_numLabel[checkIndex].text {
                
                checkCount += 1
            }
        }
        
        
        if checkCount == 4 { //如果四個數字都沒有變動過
            
            isReapet = true
        }
        else {
            
            for i in 0 ..< ary_checkReapt.count {
                
                ary_checkReapt[i] = ary_numLabel[i].text!
            }
            
            isReapet = false
        }
        
        return isReapet!
    }
    
//MARK: - determineResult 判斷?A?B
//-------------------------------
    func determineResult() {
        
        var a:Int = 0 //a代表位置正確且密碼正確
        var b:Int = 0 //b代表密碼正確但位置不對; 如果密碼位置都不對,顯示 0 A 0 B
        
        for compare in 0 ..< ary_answer.count {
            
            //先判斷幾個A
            if ary_numLabel[compare].text == ary_answer[compare] {
                
                a += 1
            }
            
            for compareB in 0 ..< ary_answer.count {
                
                //再判斷幾個B
                if ary_numLabel[compare].text == ary_answer[compareB] {
                    
                    b += 1
                }
            }
        }
        
        //b要扣除重覆a的次數
        b -= a
        
        //顯示?A?B
        if a == 4 {
            
            m_message?.messageLabel.text = "\(a) A \(b) B"
            m_message?.image = UIImage(named: "spotlight_1.png")
            m_message?.answerLabel.text = ary_answer[0]+ary_answer[1]+ary_answer[2]+ary_answer[3]
            playBt!.enabled = false
            m_rotationBt?.userInteractionEnabled = false
            m_slider?.enabled = false
            
            //停止計時
            m_timer!.invalidate()
            isTimerActivity = false
        }
        else{
            
            m_message?.messageLabel.text = "\(a) A \(b) B"
        }
        
        
    }//end determineResult function
    
    
    
//MARK: - alertShow 警示訊息
//----------------------------
    func alertShow(message:String) {
        
        let alert = UIAlertController(title: "注意!", message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "知道了", style: UIAlertActionStyle.Default, handler: { (action:UIAlertAction) -> Void in}))
        self.presentViewController(alert, animated: true, completion: nil)
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
            btTip.addTarget(self, action: #selector(NextViewController.ChanegeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btTip)
            self.view.addSubview(btTip)
            
            //btAgain
            let btAgain_position = self.getPosition(btD*3.5, angle: 35) //取得 bt1 的展開座標
            btAgain = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btAgain.layer.cornerRadius = btAgain.frame.size.width/2
            btAgain.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btAgain.setTitle("再一次", forState: UIControlState.Normal)
            btAgain.addTarget(self, action: #selector(NextViewController.onBtAgainAction(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btAgain)
            self.view.addSubview(btAgain)
            
            //btLetter
            let btLetter_position = self.getPosition(btD*3.5, angle: 55) //取得 bt2 的展開座標
            btLetter = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btLetter.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btLetter.layer.cornerRadius = btLetter.frame.size.width/2
            btLetter.setTitle("猜字母", forState: UIControlState.Normal)
            btLetter.addTarget(self, action: #selector(NextViewController.ChanegeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btLetter)
            self.view.addSubview(btLetter)
            
            //btGuess
            let btGuess_position = self.getPosition(btD*3.5, angle: 75)
            btGuess = UIButton(frame: CGRect(x: 0, y: 0, width: btD, height: btD))
            btGuess.center = CGPoint(x: 0, y: self.view.frame.size.height)
            btGuess.layer.cornerRadius = btGuess.frame.size.width/2
            btGuess.setTitle("猜數字1", forState: UIControlState.Normal)
            btGuess.addTarget(self, action: #selector(NextViewController.ChanegeView(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            self.gradient(btGuess)
            self.view.addSubview(btGuess)
            
            
            //選單出現時的動畫
            UIView.beginAnimations("btShowAnimation", context: nil)
            UIView.setAnimationDuration(0.38)
            btLetter.center = CGPoint(x: btLetter_position.x, y:  btLetter_position.y)
            btAgain.center = CGPoint(x: btAgain_position.x, y: btAgain_position.y)
            btGuess.center = CGPoint(x: btGuess_position.x, y: btGuess_position.y)
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
            btGuess.center = CGPoint(x: 0, y: self.view.frame.size.height)
            UIView.commitAnimations()
            self.performSelector(#selector(NextViewController.removeBts), withObject: nil, afterDelay: 0.39)
        }
    }
    
    
//MARK: - onBtAgainAction 再玩一次方法
//----------------------------------
    func onBtAgainAction(sender:UIButton) {
        
        //停止計時
        isTimerActivity = false
        bradgeIndex = nil
        if m_timer != nil {
            
            m_timer!.invalidate()
        }
        
        isMenuAppear = false
        m_message?.messageLabel.text = ""
        m_message?.answerLabel.text = ""
        m_message?.image = UIImage(named: "spotlight_0.png")
        m_slider?.enabled = true
        m_slider?.value = 1.0
        
        //旋轉按鈕歸零
        m_rotationBt?.rotationValue = "0"
        m_rotationBt?.referenceAngle("0")
        m_rotationBt?.userInteractionEnabled = false
        
        for circleIndex in 0 ..< ary_circleNum.count {
            
            if circleIndex == 0 {
                
                ary_circleNum[circleIndex].textColor = UIColor.redColor()
            }
            else {
                ary_circleNum[circleIndex].textColor = UIColor.whiteColor()
            }
        }
        
        for sliderIndex in 0 ..< ary_sliderNumIndex.count {
            
            //sliderIndext 歸零
            ary_sliderNumIndex[sliderIndex].textColor = UIColor.whiteColor()
        }
        
        self.ary_currentValue.removeAll()
        self.ary_numLabel.removeAll()
        ary_answer.removeAll()
        
        //重新產生四個不重覆隨機數字
        self.produceNums()
        
        self.removeBts()
        
        self.createNumLabel()
    }
    
//MARK: - 切換到不同頁面的BtAction
//------------------------------
    func ChanegeView(sender:UIButton) {
        
        isMenuAppear = false
        self.removeBts()
        
        if sender == btLetter {
            
            if letterView == nil {
                
                letterView = ViewController()
                letterView?.refreash(self.view.frame)
            }
            
            self.presentViewController(letterView!, animated: true, completion: nil)
        }
        else if sender == btGuess {
            
            if guessView == nil {
                
                guessView = ThirdViewController()
                guessView?.refreashFrame(self.view.frame)
            }
            
            self.presentViewController(guessView!, animated: true, completion: nil)
        }
        else if sender == btTip {
            
            if tipView == nil {
                
                tipView = TipViewController()
            }
            
            tipView?.m_parentObj = self
            self.presentViewController(tipView!, animated: true, completion: nil)
            
        }
    }
    
//MARK: - removeBts 移除按鈕
//-------------------------
    func removeBts() {
        
        if btAgain != nil && btLetter != nil {
            
            btGuess.removeFromSuperview()
            btTip.removeFromSuperview()
            btAgain.removeFromSuperview()
            btLetter.removeFromSuperview()
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
        let color2 = UIColor(red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        let color3 = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.98)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        gradient.colors = [color1.CGColor,color2.CGColor,color3.CGColor]
        gradient.cornerRadius = view.frame.size.width/2
        view.layer.insertSublayer(gradient, atIndex: 0)
    }

}
