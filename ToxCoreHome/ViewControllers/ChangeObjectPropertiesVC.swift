//
//  ChangeObjectPropertiesVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 16/08/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit

class ChangeObjectPropertiesVC: UIViewController, HasCustomView {
    typealias CustomView = ChangeObjectPropertiesView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var selectedObject : ToxObject? {
        didSet {
            guard let variables = selectedObject?.customVariables else { return }
            self.properties = variables
        }
    }
    
    var properties = [String : ToxValue]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Parametri"
        
        let saveButton = UIBarButtonItem(title: "Salva", style: .done, target: self, action: #selector(save))
        let cancelButton = UIBarButtonItem(title: "Annulla", style: .plain, target: self, action: #selector(cancel))
        
        navigationItem.setRightBarButton(saveButton, animated: true)
        navigationItem.setLeftBarButton(cancelButton, animated: true)
        
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
        
        rootView.tableView.register(ObjectPropertyCell.self, forCellReuseIdentifier: "cell")
        
        print(selectedObject?.customVariables as Any)
    }

    @objc private func cancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc private func save() {
        let tableView = rootView.tableView
        let maxCount = properties.count
        
        var propertiesDict = [String : ToxArbitraryValueType]()
        
        for i in 0...maxCount {
            guard let cell = tableView.cellForRow(at: IndexPath(row: i, section: 0)) as? ObjectPropertyCell else { continue }
            guard let value = cell.valueTextField.text else { continue }
            guard let key = cell.propertyNameLabel.text else { continue }
            
            if let type = properties[key]?.valueType {
                if type == "Int" {
                    if let typedProperty = Int(value) {
                        propertiesDict[key] = ToxArbitraryValueType.int(typedProperty)
                    }
                } else if type == "Float" {
                    //propertiesDict[key] = Float(value)
                    if let typedProperty = Float(value) {
                        propertiesDict[key] = ToxArbitraryValueType.float(typedProperty)
                    }
                } else {
                    propertiesDict[key] = ToxArbitraryValueType.string(value)
                }
            } else {
                propertiesDict[key] = nil
            }
            
        }
        
        print(propertiesDict)
        selectedObject?.change(properties: propertiesDict, completion: { (error) in
            if error != nil {
                print(error!)
                self.showError(message: error!.localizedDescription)
            } else {
                print("Properties modificate con successo!")
                DispatchQueue.main.async { [weak self] in
                    self?.dismiss(animated: true, completion: nil)
                }
            }
        })
        
    }

}

extension ChangeObjectPropertiesVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? ObjectPropertyCell
        let keys = Array(properties.keys)
        let key = keys[indexPath.row]
        guard let value = properties[key] else { return cell! }
        
        let property = ToxObjectProperty(propertyName: key, value: value)
        cell?.objectProperty = property

        return cell!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return properties.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
