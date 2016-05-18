

import UIKit

class RotationBtView: UIImageView {

    var backView:UIImageView!
    var thumb:UIView!
    let r:CGFloat = 35
    var currentAngle:CGFloat = 270
    var radian:CGFloat = 0 //設定弧度
    var rotationValue:String = "0"
    //MARK: - Override Function
    //--------------------------
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.frame = frame
        
        backView = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.width))
        backView.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2)
        backView.image = UIImage(named: "rotationBt_0.png")
        self.addSubview(backView)
        
        //thumb
        let thumbW:CGFloat = self.frame.size.width/9
        thumb = UIView(frame: CGRect(x: 0, y: 0, width: thumbW , height: thumbW ))
        thumb.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2 - r)
        thumb.backgroundColor = UIColor.redColor()
        thumb.layer.cornerRadius = thumb.frame.size.width/2
        self.addSubview(thumb)
        
        self.userInteractionEnabled = true
        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        let currentPoint = touches.first?.locationInView(self)
        let center = backView.center
        
        if self.getDistance(center, touchPoint: currentPoint!) <= backView.frame.size.width/2.5 {
            
            backView.image = UIImage(named: "rotationBt_1.png")
        }
        
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        var previousPoint = touches.first?.previousLocationInView(self)
        let currentPoint = touches.first?.locationInView(self)
        let center = backView.center
        let angle02 = self.getAngleFromDifferentArea(center, location: currentPoint!)
        let angle01 = self.getAngleFromDifferentArea(center, location: previousPoint!)
        let angle = angle02 - angle01
        currentAngle += angle
        
        if self.getDistance(center, touchPoint: currentPoint!) <= backView.frame.size.width/2.5 {
            
            let location = self.getLocation(center, angle:currentAngle, r: r)
            thumb.center = CGPoint(x: location.x, y: location.y)
            previousPoint = currentPoint
            self.referenceValue()
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        backView.image = UIImage(named: "rotationBt_0.png")
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    //MARK: - 中心點與碰觸點的距離
    //---------------------------------------
    func getDistance(center:CGPoint,touchPoint:CGPoint) -> CGFloat {
        
        let dx = center.x - touchPoint.x
        let dy = center.y - touchPoint.y
        return sqrt(dx*dx + dy*dy)
    }
    
    
    //MARK: - 已知中心點及角度,反求座標 (ios app)
    //---------------------------------------
    func getLocation(center:CGPoint,angle:CGFloat,r:CGFloat) -> CGPoint {
        
        let radian = angle * CGFloat(M_PI) / 180
        let point:CGPoint = CGPoint(x: center.x + r*cos(radian), y: center.y + r*sin(radian))
        return point
    }
    
    //MARK: - 不同象限座標點與中心點的夾角
    //-------------------------------
    func getAngleFromDifferentArea(center:CGPoint,location:CGPoint) -> CGFloat {
        
        if center.x <= location.x { //中心點的x座標 < 碰觸點的x座標
            
            if center.y <= location.y { //中心點的y座標 < 碰觸點的y座標
                
                radian = atan((location.y-center.y) / (location.x - center.x))
            }
            else { //中心點的y座標 > 碰觸點的y座標
                
                radian = CGFloat(2*M_PI) - atan((center.y - location.y) / (location.x - center.x))
            }
        }
        else if center.x > location.x { //中心點的x座標 > 碰觸點的x座標
            
            if center.y <= location.y { //中心點的y座標 < 碰觸點的y座標
                
                radian = CGFloat(M_PI) - atan((location.y - center.y) / (center.x - location.x))
            }
            else { //中心點的y座標 > 碰觸點的y座標
                
                radian = CGFloat(M_PI) + atan((center.y - location.y) / (center.x - location.x))
            }
        }
        
        return radian * 180 / CGFloat(M_PI) // 回傳角度
    }
    
    //MARK: - referenceValue
    //-------------------------
    func referenceValue() {
        
        switch currentAngle {
            
        case 0..<36:
            rotationValue = "7"
        case 36..<72:
            rotationValue = "6"
        case 72..<108:
            rotationValue = "5"
        case 108..<144:
            rotationValue = "4"
        case 144..<180:
            rotationValue = "3"
        case 180..<216:
            rotationValue = "2"
        case 216..<252:
            rotationValue = "1"
        case 252..<288:
            rotationValue = "0"
        case 288..<324:
            rotationValue = "9"
        case 324..<360:
            rotationValue = "8"
        default:
            break
            
        }
    }
    
    //MARK: - referenceAngle
    //-------------------------
    func referenceAngle(valueStr:String) {
        
        switch valueStr {
            
        case "0":
            currentAngle = 270
        case "1":
            currentAngle = 234
        case "2":
            currentAngle = 198
        case "3":
            currentAngle = 162
        case "4":
            currentAngle = 126
        case "5":
            currentAngle = 90
        case "6":
            currentAngle = 54
        case "7":
            currentAngle = 18
        case "8":
            currentAngle = 342
        case "9":
            currentAngle = 306
        default:
            break
            
        }
        
        let center = backView.center
        let location = self.getLocation(center, angle:currentAngle, r: r)
        thumb.center = CGPoint(x: location.x, y: location.y)
        
    }
    

}
