//
//  StatusMessage.swift
//  SwiftCodingWork
//
//  Created by Christopher Rhode on 4/26/20.
//  Copyright © 2020 Christopher Rhode. All rights reserved.
//

import UIKit

enum MESSAGE_TYPES
{
    case isInProgress
    case isSuccessful
    case isError
}

class StatusMessage: NSObject {
    
    var parentView: UIView?
    var progressView: UIView? = nil;
    var lblView: UILabel? = nil;
    
    init(withView: UIView)
    {
        parentView = withView
        super.init()
    }
    
    func setMessage(theMessage: String, withMessageType: MESSAGE_TYPES, isLastMessage: Bool)
    {
        if (progressView == nil)
        {
            let ourContentFrame = parentView!.bounds
            // 11 pro max (x: 0, y: -88, width: 414, height: 896)
            // 8: (x: 0, y: -64, width: 375, height 667
            // iPad Air 3: (x:0, y: -74, width: 834, height: 1112
            // changing to do animation "sliding down" for initial message
            //progressView = UIView(frame: CGRect(x: 2, y: 2, width: ourContentFrame.width - 4, height: 32))
            progressView = UIView(frame: CGRect(x: 2, y: -30, width: ourContentFrame.width - 4, height: 32))
            lblView = UILabel(frame: CGRect(x: 4, y: 4, width: ourContentFrame.width-8, height: 24))
            DispatchQueue.main.async
                {
                    self.progressView?.backgroundColor = self.getColorMaskForMessageType(theMessageType: withMessageType)
                    self.lblView?.text = theMessage
                    self.progressView!.addSubview(self.lblView!)
                    self.parentView!.addSubview(self.progressView!)
                    let anim = UIViewPropertyAnimator(duration:0.5, curve:.linear)
                    {
                        self.progressView?.frame.origin.y = 2
                    }
                    anim.addCompletion({_ in
                        if (isLastMessage)
                        {
                            DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
                            {
                                let anim = UIViewPropertyAnimator(duration:0.5, curve: .linear)
                                {
                                    self.progressView?.frame.origin.y = -30
                                }
                                anim.addCompletion({_ in
                                    self.progressView?.removeFromSuperview()})
                                anim.startAnimation()
                            }
                        }
                    })
                    anim.startAnimation()
            }
        }
        else
        {
            DispatchQueue.main.async
                {
                    self.progressView?.backgroundColor = self.getColorMaskForMessageType(theMessageType: withMessageType)
                    self.lblView!.text = theMessage
                    if (isLastMessage)
                    {
                        DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
                        {
                            let anim = UIViewPropertyAnimator(duration:0.5, curve: .linear)
                            {
                                self.progressView?.frame.origin.y = -30
                            }
                            anim.addCompletion({_ in
                                self.progressView?.removeFromSuperview()})
                            anim.startAnimation()
                        }
                    }
            }
        }
    }
    
    func getColorMaskForMessageType(theMessageType: MESSAGE_TYPES) -> UIColor
    {
        switch(theMessageType)
        {
        case .isInProgress:
            return UIColor(displayP3Red: 1.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .isSuccessful:
            return UIColor(displayP3Red: 0.0, green: 1.0, blue: 0.0, alpha: 1.0)
        case .isError:
            return UIColor(displayP3Red: 1.0, green: 0.0, blue: 0.0, alpha: 1.0)
        }
    }
}
