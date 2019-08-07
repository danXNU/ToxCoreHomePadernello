//
//  Extensions.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 31/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

var serverAddress : String? {
    get {
        if let dataGroup = UserDefaults(suiteName: "group.toxHome.app") {
            return dataGroup.string(forKey: "IP")
        } else {
           return UserDefaults.standard.string(forKey: "IP")
        }
    }
    set {
        if let dataGroup = UserDefaults(suiteName: "group.toxHome.app") {
            dataGroup.set(newValue, forKey: "IP")
        } else {
            UserDefaults.standard.set(newValue, forKey: "IP")
        }
    }
}

var serverPort : Int {
    get {
        if let dataGroup = UserDefaults(suiteName: "group.toxHome.app") {
            return dataGroup.integer(forKey: "PORT")
        } else {
            return UserDefaults.standard.integer(forKey: "PORT")
        }
    }
    set {
        if let dataGroup = UserDefaults(suiteName: "group.toxHome.app") {
            dataGroup.set(newValue, forKey: "PORT")
        } else {
            UserDefaults.standard.set(newValue, forKey: "PORT")
        }
    }
}

extension String {
    static func randomString(length: Int) -> String {
        
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func showError(message: String) {
        let alert = UIAlertController(title: "Errore", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
}


extension UIView {
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
}


extension UIColor {
    
    func lighter(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    func darker(by percentage:CGFloat=30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    func adjust(by percentage:CGFloat=30.0) -> UIColor? {
        var r:CGFloat=0, g:CGFloat=0, b:CGFloat=0, a:CGFloat=0;
        if(self.getRed(&r, green: &g, blue: &b, alpha: &a)){
            return UIColor(red: min(r + percentage/100, 1.0),
                           green: min(g + percentage/100, 1.0),
                           blue: min(b + percentage/100, 1.0),
                           alpha: a)
        }else{
            return nil
        }
    }
}

extension Array where Element : ToxObject {
    var names : [String] {
        var arr = [String]()
        for item in self {
            arr.append(item.name)
        }
        return arr
    }
    
    func get(by name: String) -> ToxObject? {
        for object in self {
            if object.name == name {
                return object
            }
        }
        return nil
    }
    
    func get(by id: Int) -> ToxObject? {
        for object in self {
            if (object.id ?? 0) == id {
                return object
            }
        }
        return nil
    }
}




