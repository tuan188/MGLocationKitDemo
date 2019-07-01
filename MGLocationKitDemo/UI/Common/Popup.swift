//
//  Popup.swift
//  MGLocationKitDemo
//
//  Created by Tuan Truong on 6/6/16.
//  Copyright © 2016 Framgia. All rights reserved.
//

import UIKit

protocol PopupDelegate: class {
    func popupDidTapBackground(sender: AnyObject)
}

class Popup: NSObject {
    var backgroundView: UIView!
    var interactionView: UIView!
    var contentView: UIView!
    var height: CGFloat = 200
    var animationTime = 0.2
    
    weak var delegate: PopupDelegate?
    
    init(contentView: UIView, height: CGFloat = 200) {
        assert(height > 0)
        self.contentView = contentView
        self.height = height
    }
    
    func show() {
        let screenSize: CGRect = UIScreen.main.bounds
        
        backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        backgroundView.frame = screenSize
        
        interactionView = UIView()
        interactionView.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height - height)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(Popup.tapBackground))
        interactionView.addGestureRecognizer(tapGesture)
        backgroundView.addSubview(interactionView)
        
        contentView.frame = CGRect(x: 0, y: screenSize.height, width: screenSize.width, height: height)
        backgroundView.addSubview(contentView)
        
        if let window = UIApplication.shared.delegate?.window {
            window!.addSubview(backgroundView)
        }
        UIView.animate(withDuration: animationTime) { [unowned self] in
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            self.contentView.frame = CGRect(x: 0,
                                            y: screenSize.height - self.height,
                                            width: self.contentView.frame.width,
                                            height: self.contentView.frame.height)
        }
    }
    
    func tapBackground() {
        delegate?.popupDidTapBackground(sender: self)
    }
    
    func close(completion: (() -> Void)?) {
        let screenSize: CGRect = UIScreen.main.bounds
        UIView.animate(withDuration: animationTime, animations: { [unowned self] in
            self.contentView.frame = CGRect(x: 0,
                y: screenSize.height,
                width: self.contentView.frame.width,
                height: self.contentView.frame.height)
            self.backgroundView.backgroundColor = UIColor.black.withAlphaComponent(0.0)
        }) { [unowned self](completed) in
//            self.contentView.removeFromSuperview()
//            self.contentView = nil
            self.interactionView.removeFromSuperview()
            self.interactionView = nil
            self.backgroundView.removeFromSuperview()
            
            completion?()
        }
    }
    
    deinit {
        print("Popup deinit")
    }
}
