//
//  LiveVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 05/09/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import Intents

class LiveVC: UIViewController, HasCustomView {
    typealias CustomView = LiveView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var liveObjects : [ToxObject] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.reloadTableView()
            }
        }
    }
    
    var thisTableView : UITableView {
        return rootView.tableView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.backgroundColor = UIColor.white.darker(by: 7)
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        rootView.tableView.register(LiveObjectCell.self, forCellReuseIdentifier: "cell")
        rootView.refreshControl.addTarget(self, action: #selector(reloadObjects), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.fetchLiveObjects()
        }
    }
    
    @objc private func reloadObjects() {
        fetchLiveObjects()
        
    }
    
    private func reloadTableView() {
        let contentOffset = self.rootView.tableView.contentOffset
        self.rootView.tableView.reloadData()
        self.rootView.tableView.layoutIfNeeded()
        self.rootView.tableView.setContentOffset(contentOffset, animated: false)
    }
    
    private func fetchLiveObjects() {
        ToxContainer.shared.fetchLiveObjects { [weak self] (optionalLiveObjects, error) in
            DispatchQueue.main.async {
                self?.rootView.refreshControl.endRefreshing()
            }
            if error != nil {
                print(error!)
                self?.showError(message: error!.localizedDescription)
                return
            }
            guard let liveObjects = optionalLiveObjects else {
                print("liveObjects == NULL")
                return
            }
            print("LiveObjects fetchati con successo!")
            self?.liveObjects = liveObjects
        }
    }
    
    fileprivate func donateInteraction(object: ToxObject, message: String) {
    
        let objectName = object.name
        guard let objID = object.id else { return }
    
        
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

}

extension LiveVC : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return liveObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? LiveObjectCell
        cell?.selectionStyle = .none
        let object = liveObjects[indexPath.row]
        cell?.objectOfCell = object
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let object = liveObjects[indexPath.row]
        guard let messages = object.messages else {
            return
        }
        
        let alert = UIAlertController(title: "Esegui Azione", message: "Seleziona il messaggio da eseguire", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Annulla", style: .cancel, handler: nil))
        for message in messages {
            let action = UIAlertAction(title: message, style: .default) { (action) in
                object.execute(message: action.title ?? "", completionHandler: { (error) in
                    if error != nil {
                        print("Error showMessages: \(error!)")
                        self.showError(message: error!.localizedDescription)
                    } else {
                        print("Messaggio eseguito!")
                        self.donateInteraction(object: object, message: message)
                        DispatchQueue.global(qos: .userInitiated).asyncAfter(deadline: .now() + 2, execute: {
                            self.fetchLiveObjects()
                        })
                    }
                })
            }
            alert.addAction(action)
        }
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true)
        }
    }
    
}
