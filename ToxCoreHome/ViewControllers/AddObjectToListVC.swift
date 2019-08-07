//
//  AddObjectToListVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 02/09/2018.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class AddObjectToListVC: UIViewController, HasCustomView {
    typealias CustomView = AddObjectToListView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var thisTableView : UITableView {
        return rootView.tableView
    }
    
    var allObjects : [ToxObject] = []
    var selectedAction : ToxAction?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allObjects = ToxContainer.shared.allTypesOfObjects
        rootView.backgroundColor = UIColor.white.darker(by: 7)
        
        thisTableView.delegate = self
        thisTableView.dataSource = self
        thisTableView.register(ObjectMiniCell.self, forCellReuseIdentifier: "cell")
        
        self.title = "Oggetti da aggiungere"
        
        let cancelButton = UIBarButtonItem(title: "Annulla", style: .plain, target: self, action: #selector(cancel))
        navigationItem.setLeftBarButton(cancelButton, animated: true)
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        navigationItem.setRightBarButton(doneButton, animated: true)
    }
    
    @objc private func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func doneButtonTapped() {
        addObjectsToAction()
    }
    
    private func addObjectsToAction() {
        //TODO: Implementrae questa funzione
        guard let action = selectedAction else {
            print("selectedAction == nil")
            return
        }
        
        var objectsIDs : [Int] = []
        
        for i in 0..<allObjects.count {
            guard let cell = thisTableView.cellForRow(at: IndexPath(row: i, section: 0)) as? ObjectMiniCell else {
                continue
            }
            if cell.accessoryType == .checkmark {
                if let objectID = cell.objectOfCell?.id {
                    objectsIDs.append(objectID)
                }
            }
        }
        
        action.addExistingObjectsToMyList(objectsIDs) { [weak self] (error) in
            if error != nil {
                print(error!)
                self?.showError(message: error!.localizedDescription)
            } else {
                print("Oggetti aggiunti all'azione in modo corretto")
                DispatchQueue.main.async {
                    self?.cancel()
                }
            }
        }
        
    }
    
}

extension AddObjectToListVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allObjects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ObjectMiniCell
        cell?.selectionStyle = .none
        let object = allObjects[indexPath.row]
        cell?.mainLabel.text = "\(object.className): \(object.name)"
        cell?.objectOfCell = object
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
}
