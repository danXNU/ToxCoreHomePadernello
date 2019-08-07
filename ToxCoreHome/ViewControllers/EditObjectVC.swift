//
//  EditObjectVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 02/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

class EditObjectVC : UIViewController, HasCustomView {
    typealias CustomView = EditObjectView
    override func loadView() {
        let customView = CustomView()
        view = customView
    }
    
    var selectedObject : ToxObject? /*{
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.rootView.tableView.reloadData()
            }
        }
    }*/

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Handlers"
        
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.tableView.register(ToxHandlerCell.self, forCellReuseIdentifier: "cell")
        
        let buttonItem = UIBarButtonItem(title: "Aggiungi", style: .done, target: self, action: #selector(showHandlerAddedView(_:)))
        navigationItem.setRightBarButton(buttonItem, animated: true)
        
        rootView.siriButton.addTarget(self, action: #selector(showSiriVC), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchHandlers()
    }
    
    private func fetchHandlers() {
        guard let object = self.selectedObject else {
            return
        }
        
        object.fetchHandlers { (error) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                print("Handlers fetchati con successo!")
                DispatchQueue.main.async { [weak self] in
                    self?.relaodTableView()
                }
            }
        }
        
        
    }
    
    private func relaodTableView() {
        let contentOffset = self.rootView.tableView.contentOffset
        self.rootView.tableView.reloadData()
        self.rootView.tableView.layoutIfNeeded()
        self.rootView.tableView.setContentOffset(contentOffset, animated: false)
    }
    
    @objc fileprivate func showHandlerAddedView(_ sender: UITabBarItem) {
        let vc = AddHandlerVC()
        vc.selectedObject = self.selectedObject
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    fileprivate func removeHandlerWith(id : Int) {
        guard let object = selectedObject else { print("selectedObject == NULL"); return }
        object.remove(handler: id) { (error) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                print("Handler rimosso con successo")
                DispatchQueue.main.async { [weak self] in
                    self?.fetchHandlers()
                }
            }
        }
    }
    
    @objc private func showSiriVC() {
        guard let object = selectedObject else {
            print("selectedObject == null")
            return
        }
        guard let messages = object.messages else {
            print("object.messages == null")
            return
        }
        
        let alert = UIAlertController(title: "Seleziona l'azione", message: "Scegli quale delle azioni di questo oggetto vuoi aggiungere a Siri", preferredStyle: .actionSheet)
        
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        for i in 0..<messages.count {
            alert.addAction(UIAlertAction(title: messages[i], style: .default, handler: { [weak self] (action) in
                self?.createIntent(with: messages[i], completion: { (optionalIntent, errorString) in
                    if errorString != nil {
                        print("\(String(describing: errorString))")
                        return
                    }
                    guard let intent = optionalIntent else {
                        print("intent == NULL")
                        return
                    }
                    if let shortcut = INShortcut(intent: intent) {
                        DispatchQueue.main.async {
                            let viewController = INUIAddVoiceShortcutViewController(shortcut: shortcut)
                            viewController.modalPresentationStyle = .formSheet
                            viewController.delegate = self
                            self?.present(viewController, animated: true)
                        }
                        
                    } else {
                        print("Error creating shortcut")
                    }
                })
            }))
        }
        present(alert, animated: true)
        
    }
    
    private func createIntent(with message : String, completion: @escaping (ExecuteObjectMessageIntent?, String?) -> Void) {
        guard let objectName = self.selectedObject?.name else {
            completion(nil, "objectName == NULL")
            return
        }
        guard let objID = selectedObject?.id else {
            completion(nil, "object.id == NULL")
            return
        }
        
        let intent = ExecuteObjectMessageIntent()
        intent.objectName = objectName
        intent.message = message
        intent.objectID = objID as NSNumber
        intent.suggestedInvocationPhrase = "\(objectName), \(message)!"
        let interaction = INInteraction(intent: intent, response: nil)
        interaction.identifier = "\(objID).\(message)"
        
        interaction.donate { (error) in
            if error != nil {
                print(error!)
                completion(nil, "\(String(describing: error))")
            } else {
                completion(intent, nil)
                print("Intent donato con successo!")
            }
        }
    }
    
}

extension EditObjectVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let dictKeys = selectedObject?.handlers.keys else { return 0 }
        let keys = Array(dictKeys)
        let key = keys[section]
        guard let handlers = selectedObject?.handlers else { return 0 }
        guard let realHandlers = handlers[key] else { return 0 }
        return realHandlers.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return selectedObject?.handlers.keys.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ToxHandlerCell
        cell?.selectionStyle = .none
        guard let dictKeys = selectedObject?.handlers.keys else { return cell! }
        let keys = Array(dictKeys)
        let key = keys[indexPath.section]
        if let handlers = selectedObject?.handlers, let realHandlers = handlers[key] {
            let handler = realHandlers[indexPath.row]
            cell?.handler = handler
            
            cell?.removeButton.tag = handler.id
        }
        
        cell?.removeButton.addTarget(self, action: #selector(showRemoveAction(_:)), for: .touchUpInside)
        return cell!
    }
    
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let dictKeys = selectedObject?.handlers.keys else { return nil }
        return Array(dictKeys)[section]
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    @objc fileprivate func showRemoveAction(_ sender : UIButton) {
        if sender.tag == 0 { print("Errore: sender.tag == 0"); return }
        let alert = UIAlertController(title: "Elimina handler", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        let action = UIAlertAction(title: "Elimina", style: .destructive) { [weak self] (action) in
            self?.removeHandlerWith(id: sender.tag)
        }
        alert.addAction(action)
        present(alert, animated: true)
    }
}

extension EditObjectVC : INUIAddVoiceShortcutViewControllerDelegate {
    func addVoiceShortcutViewController(_ controller: INUIAddVoiceShortcutViewController, didFinishWith voiceShortcut: INVoiceShortcut?, error: Error?) {
        if error != nil {
            print(error!)
            self.showError(message: error!.localizedDescription)
        } else {
            print("Shortcut aggiunta a Siri con successo!")
            controller.dismiss(animated: true, completion: nil)
        }
    }
    
    func addVoiceShortcutViewControllerDidCancel(_ controller: INUIAddVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    
}
