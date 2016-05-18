

import UIKit

class MyImgView: UIImageView {

    var messageLabel:UILabel!
    var answerLabel:UILabel!
    
    func refreashWithFrame(frame:CGRect) {
        
        self.frame = frame
        self.image = UIImage(named: "spotlight_0.png")
        self.contentMode = UIViewContentMode.ScaleAspectFill
        
        //messageLabel
        messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: frame.size.width*0.5, height: frame.size.height*0.5))
        messageLabel.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/2.5)
        messageLabel.backgroundColor = UIColor.clearColor()
        messageLabel.textColor = UIColor.whiteColor()
        messageLabel.textAlignment = NSTextAlignment.Center
        messageLabel.font = UIFont.boldSystemFontOfSize(messageLabel.frame.size.height*0.38)
        messageLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(messageLabel)
        
        //answerLabel
        answerLabel = UILabel(frame: messageLabel.frame)
        answerLabel.center = CGPoint(x: self.frame.size.width/2, y: self.frame.size.height/6)
        answerLabel.textColor = UIColor.darkGrayColor()
        answerLabel.textAlignment = NSTextAlignment.Center
        answerLabel.font = UIFont.systemFontOfSize(answerLabel.frame.size.height*0.28)
        answerLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(answerLabel)
        
    }
    
    

}
