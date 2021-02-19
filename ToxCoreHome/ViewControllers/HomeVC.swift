//
//  HomeVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 28/07/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import Intents

class HomeVC: UIViewController, HasCustomView {
    typealias CustomView = HomeView
    
    override func loadView() {
        let customView = CustomView()
        view = customView
    }
    
    
    var objectToShowChoice : Int {
        return self.rootView.objectChoiceSegment.selectedSegmentIndex
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Home"
        let barItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(barButtonTouched))
        self.navigationItem.setRightBarButton(barItem, animated: true)
        
        if #available(iOS 13, *) {
            let ipBarButton = UIBarButtonItem(image: UIImage(systemName: "slider.horizontal.3"), style: .done, target: self, action: #selector(editIPButtonTouched))
            self.navigationItem.setLeftBarButton(ipBarButton, animated: true)
        } else {
            let ipBarButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(editIPButtonTouched))
            self.navigationItem.setLeftBarButton(ipBarButton, animated: true)
        }
        
        if #available(iOS 13, *) {
            rootView.backgroundColor = .systemBackground
        } else {
            rootView.backgroundColor = UIColor.white.darker(by: 7)
        }
        
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.register(ToxAnyObjectCell.self, forCellReuseIdentifier: "cell")
        rootView.refreshControl.addTarget(self, action: #selector(reloadAllObjects), for: .valueChanged)
        
        rootView.objectChoiceSegment.addTarget(self, action: #selector(segmentTouched(_:)), for: .valueChanged)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        reloadAllObjects()
    }
    
    @objc private func segmentTouched(_ sender: UISegmentedControl) {
        self.reloadAllObjects()
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
    
    @objc private func editIPButtonTouched() {
        let alert = UIAlertController(title: "Indirizzo IP", message: "Inserisci l'indirizzo IP e la porta del server:", preferredStyle: .alert)
        alert.addTextField { (textField) in
            if serverAddress == nil {
                textField.placeholder = "IP"
            } else {
                textField.text = serverAddress!
            }
        }
        
        alert.addTextField { (textField) in
            textField.text = "\(serverPort)"
        }
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action) in
            guard let address = alert.textFields?[0].text else { return }
            guard let portString = alert.textFields?[1].text else { return }
            guard let port = Int(portString) else { return }
            
            serverAddress = address
            serverPort = port
            
            print("Address: \(address)\t\tPort:\(port)")
        }))
        self.present(alert, animated: true)
    }
    
    @objc private func barButtonTouched() {
        let alertMessage = "Seleziona il tipo di oggetto che desideri creare"
        let alert = UIAlertController(title: "Cosa vuoi creare?", message: alertMessage, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "ToxObject", style: .default, handler: { [weak self] (action) in
            self?.showObjectCreationVC()
        }))
        alert.addAction(UIAlertAction(title: "ToxAction", style: .default, handler: { [weak self] (alert) in
            self?.showActionCreationVC()
        }))
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    private func showObjectCreationVC() {
        DispatchQueue.main.async { [weak self] in
            let vc = CreateObjectVC()
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }
    }
    
    private func showActionCreationVC() {
        DispatchQueue.main.async { [weak self] in
            let vc = CreateActionVC()
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }
    }
    
    private func reloadTableView() {
        let contentOffset = self.rootView.tableView.contentOffset
        self.rootView.tableView.reloadData()
        self.rootView.tableView.layoutIfNeeded()
        self.rootView.tableView.setContentOffset(contentOffset, animated: false)
    }
    
    @objc private func reloadAllObjects() {
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            self?.reloadObjects()
            self?.reloadActions()
        }
    }
    
    public func reloadObjects() {
        ToxContainer.shared.fetchObjects { (error) in
            DispatchQueue.main.async { [weak self] in
                if error != nil {
                    print("\(error!)")
                    self?.showError(message: error!.localizedDescription)
                } else {
                    self?.reloadTableView()
                }
                self?.rootView.refreshControl.endRefreshing()
            }
        }
    }
    
    private func reloadActions() {
        ToxContainer.shared.fecthActions { (error) in
            DispatchQueue.main.async { [weak self] in
                if error != nil {
                    print(error!)
                    self?.showError(message: error!.localizedDescription)
                } else {
                    self?.reloadTableView()
                }
                self?.stopLoadingAnimation()
            }
        }
    }
    
    @objc fileprivate func showMessages(_ sender: UIButton) {
        var objects : [ToxObject]
        if objectToShowChoice == 0 {
            objects = ToxContainer.shared.allObjects
        } else {
            objects = ToxContainer.shared.allActions
        }
        
        let index = sender.tag
        let object = objects[index]
        
        
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
        if objectToShowChoice == 0 {
            guard let name = ToxContainer.shared.allObjects.get(by: objID)?.name else {
                print("Errore nell'ottenere il nome dell'oggetto per l'intent")
                self.showError(message: "Errore nell'ottenere il nome dell'oggetto per l'intent")
                return
            }
            objectName = name
        } else {
            guard let name = ToxContainer.shared.allActions.get(by: objID)?.name else {
                self.showError(message: "Errore nell'ottenere il nome dell'Azione per l'intent")
                print("Errore nell'ottenere il nome dell'Azione per l'intent")
                return
            }
            objectName = name
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
    
    private func removeObject(_ object: ToxObject, at indexPath: IndexPath) {
        guard let objectID = object.id else {
            print("objectID == null in HomeVC.editActionsForRowAt:")
            return
        }
        
        let body = ["object_id" : objectID]
        let request = ToxRequest(type: ToxRequestEnum.removeObject, body: body)
        do {
            let server = try ToxSocket<[String:Int], String>()
            server.send(request: request, completionHandler: { (returnMsg, error) in
                if error != nil {
                    print(error!)
                    self.showError(message: error!.localizedDescription)
                } else {
                    DispatchQueue.main.async { [weak self] in
                        self?.removeIntentsAfterDeletion(of: object)
    
                        if self?.objectToShowChoice == 0 {
                            ToxContainer.shared.allObjects.remove(at: indexPath.row)
                            print("Oggetto rimosso con successo!")
                        } else {
                            ToxContainer.shared.allActions.remove(at: indexPath.row)
                            print("Azione rimossa con successo!")
                        }
                        self?.rootView.tableView.deleteRows(at: [indexPath], with: .fade)
                    }
                }
            })
        } catch {
            print(error)
            self.showError(message: error.localizedDescription)
        }
    }
    
    private func showActionObjectsContainer(_ action: ToxAction) {
        DispatchQueue.main.async { [weak self] in
            let vc = ActionObjectsVC()
            vc.selectedAction = action
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if objectToShowChoice == 0 {
            return ToxContainer.shared.allObjects.count
        } else {
            return ToxContainer.shared.allActions.count
        }
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ToxAnyObjectCell
        cell?.backgroundColor = .clear
        cell?.selectionStyle = .none
        
        var objects : [ToxObject] = []
        if self.objectToShowChoice == 0 {
            objects = ToxContainer.shared.allObjects
        } else {
            objects = ToxContainer.shared.allActions
        }
        cell?.object = objects[indexPath.row]
        
        cell?.messagesButton.tag = indexPath.row
        cell?.messagesButton.addTarget(self, action: #selector(showMessages(_:)), for: .touchUpInside)
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = EditObjectVC()
        if objectToShowChoice == 0 {
            vc.selectedObject = ToxContainer.shared.allObjects[indexPath.row]
        } else {
            vc.selectedObject = ToxContainer.shared.allActions[indexPath.row]
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 250
    }
    
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let changePropertiesAction = UITableViewRowAction(style: .normal, title: "Modifica") { [weak self] (action, indexPath) in
            var object : ToxObject
            if self?.objectToShowChoice == 0 {
                object = ToxContainer.shared.allObjects[indexPath.row]
            } else {
                object = ToxContainer.shared.allActions[indexPath.row]
            }
            let vc = ChangeObjectPropertiesVC()
            vc.selectedObject = object
            let nav = UINavigationController(rootViewController: vc)
            self?.present(nav, animated: true)
        }
        
        let deleteObjectAction = UITableViewRowAction(style: .destructive, title: "Elimina") { [weak self] (action, indexPath) in
            var object : ToxObject
            if self?.objectToShowChoice == 0 {
                object = ToxContainer.shared.allObjects[indexPath.row]
            } else {
                object = ToxContainer.shared.allActions[indexPath.row]
            }
            self?.removeObject(object, at: indexPath)
        }
        
        let addObjectsToAction = UITableViewRowAction(style: .normal, title: "Oggetti") { [weak self] (action, indexPath) in
            let toxAction : ToxAction = ToxContainer.shared.allActions[indexPath.row]
            self?.showActionObjectsContainer(toxAction)
        }
        
        addObjectsToAction.backgroundColor = UIColor.green
        
        if objectToShowChoice == 0 {
            return [deleteObjectAction, changePropertiesAction]
        } else {
            return [deleteObjectAction, changePropertiesAction, addObjectsToAction]
        }
        
    }
}













