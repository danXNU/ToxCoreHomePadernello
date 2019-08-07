//
//  ToxObjectCell.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 31/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ToxObjectCell: UITableViewCell {
    
    var object : ToxObject? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.nameLabel.text = self?.object?.name
                self?.descriptionLabel.text = "Descrizione: \(self?.object?.description ?? "nessuna")"
                self?.objectTypeLabel.text = "Tipo di Oggetto: \(self?.object?.className ?? "nessuno")"
                self?.locationLabel.text = "Location: \(self?.object?.realLocation ?? "non impostata")"
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    let boxView : UIView = {
        let boxView = UIView()
        boxView.backgroundColor = UIColor.black.lighter(by: 10)
        boxView.layer.cornerRadius = 10
        boxView.translatesAutoresizingMaskIntoConstraints = false
        return boxView
    }()
    
    let nameLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .red
        return l
    }()
    
    let descriptionLabel : UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    let messagesButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Azioni", for: .normal)
        return b
    }()
    
    let bottomLine : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white
        return line
    }()
    
    let objectTypeLabel : UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    let locationLabel : UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    
//    let removeButton : UIButton = {
//        let button = UIButton()
//        button.setTitle("", for: .normal)
//        button.backgroundColor = .darkGray
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 12.5
//        button.layer.masksToBounds = true
//        return button
//    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(boxView)
        boxView.addSubview(nameLabel)
        boxView.addSubview(descriptionLabel)
        boxView.addSubview(messagesButton)
        boxView.addSubview(bottomLine)
        boxView.addSubview(objectTypeLabel)
        boxView.addSubview(locationLabel)
        boxView.addSubview(stackView)
        
//        boxView.addSubview(removeButton)
        
        [descriptionLabel, objectTypeLabel, locationLabel].forEach({ stackView.addArrangedSubview($0) })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        nameLabel.topAnchor.constraint(equalTo: boxView.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        messagesButton.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        messagesButton.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        messagesButton.bottomAnchor.constraint(equalTo: boxView.bottomAnchor).isActive = true
        messagesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: messagesButton.topAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        stackView.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10).isActive = true
        
        
//        removeButton.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -5).isActive = true
//        removeButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
//        removeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
//        removeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

}

class ToxAnyObjectCell<T : ToxObject> : UITableViewCell {
    
    var object : T? {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.topLabel.text = self?.object?.name
                self?.firstLabel.text = "Descrizione: \(self?.object?.description ?? "nessuna")"
                self?.secondLabel.text = "Tipo di Oggetto: \(self?.object?.className ?? "nessuno")"
                self?.thirdLabel.text = "Location: \(self?.object?.realLocation ?? "non impostata")"
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    let boxView : UIView = {
        let boxView = UIView()
        boxView.backgroundColor = UIColor.black.lighter(by: 10)
        boxView.layer.cornerRadius = 10
        boxView.translatesAutoresizingMaskIntoConstraints = false
        return boxView
    }()
    
    let topLabel : UILabel = {
        let l = UILabel()
        l.textAlignment = .center
        l.font = UIFont.boldSystemFont(ofSize: 20)
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .red
        return l
    }()
    
    let firstLabel : UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .white
        return l
    }()
    
    let messagesButton : UIButton = {
        let b = UIButton()
        b.translatesAutoresizingMaskIntoConstraints = false
        b.setTitle("Azioni", for: .normal)
        return b
    }()
    
    let bottomLine : UIView = {
        let line = UIView()
        line.translatesAutoresizingMaskIntoConstraints = false
        line.backgroundColor = .white
        return line
    }()
    
    let secondLabel : UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    
    let thirdLabel : UILabel = {
        let l = UILabel()
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    var stackView : UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 7
        return stackView
    }()
    
    //    let removeButton : UIButton = {
    //        let button = UIButton()
    //        button.setTitle("", for: .normal)
    //        button.backgroundColor = .darkGray
    //        button.translatesAutoresizingMaskIntoConstraints = false
    //        button.layer.cornerRadius = 12.5
    //        button.layer.masksToBounds = true
    //        return button
    //    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.addSubview(boxView)
        boxView.addSubview(topLabel)
        boxView.addSubview(firstLabel)
        boxView.addSubview(messagesButton)
        boxView.addSubview(bottomLine)
        boxView.addSubview(secondLabel)
        boxView.addSubview(thirdLabel)
        boxView.addSubview(stackView)
        
        //        boxView.addSubview(removeButton)
        
        [firstLabel, secondLabel, thirdLabel].forEach({ stackView.addArrangedSubview($0) })
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        boxView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10).isActive = true
        boxView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10).isActive = true
        boxView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10).isActive = true
        boxView.topAnchor.constraint(equalTo: topAnchor, constant: 10).isActive = true
        
        topLabel.topAnchor.constraint(equalTo: boxView.topAnchor).isActive = true
        topLabel.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        topLabel.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        topLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        messagesButton.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        messagesButton.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        messagesButton.bottomAnchor.constraint(equalTo: boxView.bottomAnchor).isActive = true
        messagesButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        bottomLine.leadingAnchor.constraint(equalTo: boxView.leadingAnchor).isActive = true
        bottomLine.trailingAnchor.constraint(equalTo: boxView.trailingAnchor).isActive = true
        bottomLine.bottomAnchor.constraint(equalTo: messagesButton.topAnchor).isActive = true
        bottomLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        
        stackView.topAnchor.constraint(equalTo: topLabel.bottomAnchor, constant: 10).isActive = true
        stackView.bottomAnchor.constraint(equalTo: bottomLine.topAnchor, constant: -10).isActive = true
        stackView.leadingAnchor.constraint(equalTo: boxView.leadingAnchor, constant: 10).isActive = true
        stackView.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -10).isActive = true
        
        
        //        removeButton.trailingAnchor.constraint(equalTo: boxView.trailingAnchor, constant: -5).isActive = true
        //        removeButton.centerYAnchor.constraint(equalTo: nameLabel.centerYAnchor).isActive = true
        //        removeButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        //        removeButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
