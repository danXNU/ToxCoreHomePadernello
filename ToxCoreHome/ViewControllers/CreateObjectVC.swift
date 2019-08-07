//
//  CreateObjectVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 28/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class CreateObjectVC: UIViewController, HasCustomView {
    typealias CustomView = CreateObjectView
    override func loadView() {
        let customView = CustomView()
        view = customView
    }
    
    var actionID : Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nuovo Oggetto"
        
        self.hideKeyboardWhenTappedAround()

        let tabButton = UIBarButtonItem(title: "Annulla", style: .done, target: self, action: #selector(dismissVC))
        navigationItem.setRightBarButton(tabButton, animated: true)
        
        rootView.createButton.addTarget(self, action: #selector(handleCreateTap), for: .touchUpInside)
        rootView.classButton.addTarget(self, action: #selector(showClassList), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchClasses()
    }
    
    @objc private func showClassList() {
        let alert = UIAlertController(title: "Classi di Oggetto", message: "Seleziona la classe di oggetto che vuoi creare", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        for classe in rootView.classButton.options {
            alert.addAction(UIAlertAction(title: classe, style: .default, handler: { (action) in
                DispatchQueue.main.async { [weak self] in
                    self?.rootView.classButton.setTitle(action.title, for: .normal)
                }
            }))
        }
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
    fileprivate func fetchClasses() {
        ToxContainer.shared.fetchClasses { (error) in
            if error != nil {
                print("\(String(describing: error))")
                self.showError(message: error!.localizedDescription)
            } else {
                rootView.classButton.options = ToxContainer.shared.allClasses
            }
        }
    }

    @objc private func dismissVC() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc fileprivate func handleCreateTap() {
        guard let name = rootView.nomeField.text else {
            print("name == null")
            return
        }
        guard let description = rootView.descriptionField.text else {
            print("description == null")
            return
        }
        guard let className = rootView.classButton.titleLabel?.text else {
            print("className == null")
            return
        }
        if className == "Tipo di Oggetto" {
            print("Classe oggetto non valida")
            return
        }
        
        let object = ToxObject(name: name, desc: description, className: className)
        object.actionID = self.actionID
        object.addMeOnServer { (error) in
            if error != nil {
                self.showError(message: error!.localizedDescription)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    print("Oggetto aggiunto con successo")
                }
            }
        }
    }
   
    
}

class CreateActionVC : CreateObjectVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Nuova Action"
        
        rootView.classButton.options = ["ToxAction"]
        rootView.classButton.setTitle("ToxAction", for: .normal)
    }
    
    
    
    override func handleCreateTap() {
        guard let actionName = rootView.nomeField.text else {
            print("actionName == null")
            return
        }
        guard let descriptionName = rootView.descriptionField.text else {
            print("description == null")
            return
        }
        if actionName.isEmpty {
            print("actionName.isEmpty = YES")
            return
        }
        if descriptionName.isEmpty {
            print("description.isEmpty = YES")
            return
        }
        
        let action = ToxAction(name: actionName, desc: descriptionName)
        action.addMeOnServer { (error) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                    print("Azione aggiunta con successo")
                }
            }
        }
        
    }
    
    override func fetchClasses() {}
}
