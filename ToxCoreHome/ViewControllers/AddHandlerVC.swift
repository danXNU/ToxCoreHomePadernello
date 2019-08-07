//
//  AddHandlerVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 03/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class AddHandlerVC: UIViewController, HasCustomView {
    typealias CustomView = AddHandlerView
    override func loadView() {
        let customView = CustomView()
        view = customView
    }

    var selectedObject: ToxObject? {
        didSet {
            guard let object = selectedObject else { return }
            let dictKeys = object.handlers.keys
            let keys = Array(dictKeys)
            rootView.handlerKeyButton.options = keys
            
            rootView.objectToAddButton.options =  ToxContainer.shared.allTypesOfObjects.names
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = selectedObject?.name
        rootView.handlerKeyButton.setTitle("Gruppo di Handlers", for: .normal)
        rootView.objectToAddButton.setTitle("Nome dell'oggetto", for: .normal)
        rootView.messageObjectToAddButton.setTitle("Funzione dell'oggetto", for: .normal)
        
        rootView.objectToAddButton.buttonWasTapped = { [weak self] (stringTapped) in
            if let objectToAddHandler = ToxContainer.shared.allTypesOfObjects.get(by: stringTapped), let messages = objectToAddHandler.messages {
                self?.rootView.messageObjectToAddButton.options = messages
            } else {
                self?.rootView.messageObjectToAddButton.options = [""]
            }
        }
        
        rootView.dropButtons.forEach({
            $0.showHandler = { [weak self] (isOpening, button) in
                self?.handleButtonsShowing(isOpening: isOpening, button: button)
            }
        })
        
        rootView.addHandlerButton.addTarget(self, action: #selector(addHandler), for: .touchUpInside)
    }

    func handleButtonsShowing(isOpening: Bool, button : DropDownButton) {
        let buttons = rootView.dropButtons
        
        if isOpening {
            for b in buttons {
                if b != button {
                    b.isHidden = true
                }
            }
        } else {
            for b in buttons {
                if b != button {
                    b.isHidden = false
                }
            }
        }
    }

    
    @objc private func addHandler() {
        guard
            let handlerKey = rootView.handlerKeyButton.titleLabel?.text,
            let objectName = rootView.objectToAddButton.titleLabel?.text,
            let objectMessage = rootView.messageObjectToAddButton.titleLabel?.text
        else {
            print("Manca qualche parametro")
            return
        }
        
        guard let objectOfFunction = ToxContainer.shared.allTypesOfObjects.get(by: objectName) else {
            print("Nessun oggetto trovato con questo nome")
            return
        }
        
        guard let idObject = objectOfFunction.id else {
            print("Per qualche strano motivo, questo oggetto non ha un ID")
            return
        }
        
        let function = ToxFunction()
        function.functionName = objectMessage
        function.objectID = idObject
        
        let handler = ToxHandler(funct: function)
        handler.idObjectOwner = selectedObject?.id
        handler.key = handlerKey
        
        selectedObject?.addHandlerOnServer(handler, completion: { (error) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                print("Handler aggiunto con successo")
                navigationController?.popViewController(animated: true)
            }
        })
        
        
    }

}
