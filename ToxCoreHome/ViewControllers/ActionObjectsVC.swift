//
//  ActionObjectsVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 02/09/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import Intents

class ActionObjectsVC: UIViewController, HasCustomView {
    typealias CustomView = ActionObjectsView
    override func loadView() {
        let customView = CustomView()
        view = customView
    }
    
    var actionObjects : [ToxObject] = []
    var selectedAction : ToxAction?
    
    override func viewDidLoad() {
        rootView.tableView.backgroundColor = UIColor.white.darker(by: 7)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.register(ToxAnyObjectCell.self, forCellReuseIdentifier: "cell")
        rootView.refreshControl.addTarget(self, action: #selector(reloadObjects), for: .valueChanged)
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addObjectButtonPressed))
        self.navigationItem.setRightBarButton(addButton, animated: true)
        
        self.title = selectedAction?.name
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadAllObjects()
    }
    @objc private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func segmentTouched(_ sender: UISegmentedControl) {
        self.reloadAllObjects()
    }
    
    @objc private func addObjectButtonPressed() {
        let alert = UIAlertController(title: "Creazione oggetto", message: "Vuoi creare un oggetto da zero o vuoi inserirne uno già esistente?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Crea da zero", style: .default, handler: { [weak self] (action) in
            let vc = CreateObjectVC()
            vc.actionID = self?.selectedAction?.id
            let nav = UINavigationController(rootViewController: vc)
            DispatchQueue.main.async {
                self?.present(nav, animated: true)
            }
        }))
        alert.addAction(UIAlertAction(title: "Aggiungine uno esistente", style: .default, handler: { [weak self] (action) in
            let vc = AddObjectToListVC()
            vc.selectedAction = self?.selectedAction
            let nav = UINavigationController(rootViewController: vc)
            DispatchQueue.main.async {
                self?.present(nav, animated: true)
            }
        }))
        self.present(alert, animated: true)
    }
    
    private func startLoadingAnimation() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.tableView.refreshControl?.beginRefreshing()
        }
    }
    
    private func stopLoadingAnimation() {
        DispatchQueue.main.async { [weak self] in
            self?.rootView.tableView.refreshControl?.endRefreshing()
        }
    }
    
    private func reloadTableView() {
        DispatchQueue.main.async { [weak self] in
            let contentOffset = self?.rootView.tableView.contentOffset ?? CGPoint.zero
            self?.rootView.tableView.reloadData()
            self?.rootView.tableView.layoutIfNeeded()
            self?.rootView.tableView.setContentOffset(contentOffset, animated: false)
        }
    }
    
    @objc private func reloadAllObjects() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.reloadObjects()
        }
    }
    
    @objc public func reloadObjects() {
        guard let action = selectedAction else { return }
        ToxContainer.shared.fetchObjectsOfAction(action: action) { (error, optionalObjects) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                if optionalObjects != nil {
                    actionObjects = optionalObjects!
                    self.reloadTableView()
                }
            }
        }
    }
    
    
    @objc fileprivate func showMessages(_ sender: UIButton) {
        let index = sender.tag
        let object = actionObjects[index]
        
        
        let alert = UIAlertController(title: "Azioni", message: "Seleziona un'azione da svolgere", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        for key in object.messages ?? [""] {
            let action = UIAlertAction(title: key, style: .default) { (action) in
                object.execute(message: action.title ?? "", completionHandler: { (error) in
                    if error != nil {
                        print("Error showMessages: \(error!)")
                        self.showError(message: error!.localizedDescription)
                    } else {
                        print("Messaggio eseguito!")
                        self.donateInteraction(objID: object.id ?? 0, message: action.title ?? "NULL")
                    }
                })
            }
            alert.addAction(action)
        }
        present(alert, animated: true)
    }
    
    fileprivate func donateInteraction(objID: Int, message: String) {
        var objectName : String
        
        guard let name = actionObjects.get(by: objID)?.name else {
            print("Errore nell'ottenere il nome dell'oggetto per l'intent")
            return
        }
        objectName = name
        
        
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
                self.showError(message: error!.localizedDescription)
            } else {
                print("Intent donato con successo!")
            }
        }
    }
    
    private func removeIntentsAfterDeletion(of object: ToxObject) {
        guard let messages = object.messages else {
            print("Non ho potuto trovare i messaggi quindi non elimino gli intents")
            return
        }
        
        guard let objID = object.id else {
            print("Non ho potuto trovare l'objID quindi non elimino gli intents")
            return
        }
        
        var objectIntents = [String]()
        for message in messages {
            let intentID = "\(objID).\(message)"
            objectIntents.append(intentID)
        }
        
        INInteraction.delete(with: objectIntents) { (error) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                print("Intents rimossi con successo!")
            }
        }
        
    }
}

extension ActionObjectsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return actionObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ToxAnyObjectCell
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        
        cell?.object = actionObjects[indexPath.row]
        
        cell?.messagesButton.tag = indexPath.row
        cell?.messagesButton.addTarget(self, action: #selector(showMessages(_:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditObjectVC()
        vc.selectedObject = actionObjects[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let changePropertiesAction = UITableViewRowAction(style: .normal, title: "Modifica") { [weak self] (action, indexPath) in
            guard let object : ToxObject = self?.actionObjects[indexPath.row] else {
                return
            }
            
            let vc = ChangeObjectPropertiesVC()
            vc.selectedObject = object
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }
        
        let deleteObjectFromAction = UITableViewRowAction(style: .destructive, title: "Rimuovi") { [weak self] (rowAction, indexPath) in
            guard let object : ToxObject = self?.actionObjects[indexPath.row] else {
                print("objectDaTogliere dalla list == NULL")
                return
            }
            
            guard let action = self?.selectedAction else {
                print("Azione == NULL")
                return
            }
            
            action.removeObjectFromMyList(object, completion: { (error) in
                if error != nil {
                    print(error!)
                    self?.showError(message: error!.localizedDescription)
                } else {
                    self?.reloadObjects()
                }
            })
            
            
        }
        return [deleteObjectFromAction, changePropertiesAction]
    }
}














