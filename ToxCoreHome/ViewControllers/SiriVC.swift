//
//  SiriVC.swift
//  ToxCoreHome
//
//  Created by Dani Tox on 04/09/18.
//  Copyright © 2018 Dani Tox. All rights reserved.
//

import UIKit
import Intents
import IntentsUI

class SiriVC: UIViewController, HasCustomView {
    typealias CustomView = SiriView
    override func loadView() {
        super.loadView()
        view = CustomView()
    }
    
    var shorcutsInstalled : [INVoiceShortcut] = [] {
        didSet {
            DispatchQueue.main.async { [weak self] in
                self?.rootView.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Siri"
        rootView.backgroundColor = UIColor.white.darker(by: 7)
        rootView.tableView.register(SiriShortcutCell.self, forCellReuseIdentifier: "cell")
        rootView.tableView.delegate = self
        rootView.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchShortcuts()
    }
    
    private func fetchShortcuts() {
        INVoiceShortcutCenter.shared.getAllVoiceShortcuts { (optionalVoiceShortcuts, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let voiceShortcuts = optionalVoiceShortcuts else {
                print("voiceshurtcuts == null")
                return
            }
            
            self.shorcutsInstalled = voiceShortcuts
            
        }
    }

}
extension SiriVC : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shorcutsInstalled.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as? SiriShortcutCell
        let shortcut = shorcutsInstalled[indexPath.row]
        cell?.mainLabel.text = shortcut.invocationPhrase
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let shortcut = shorcutsInstalled[indexPath.row]
        let vc = INUIEditVoiceShortcutViewController(voiceShortcut: shortcut)
        vc.delegate = self
        present(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Seleziona la scorciatoia da modificare"
    }
    
}

extension SiriVC: INUIEditVoiceShortcutViewControllerDelegate {
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didUpdate voiceShortcut: INVoiceShortcut?, error: Error?) {
        if error != nil {
            print(error!)
            
            controller.dismiss(animated: true) {
                self.showError(message: error!.localizedDescription)
            }
            
            
        } else {
            print("Una shortcut è stata modificata con successo!")
            controller.dismiss(animated: true, completion: nil)
            self.fetchShortcuts()
        }
    }
    
    func editVoiceShortcutViewController(_ controller: INUIEditVoiceShortcutViewController, didDeleteVoiceShortcutWithIdentifier deletedVoiceShortcutIdentifier: UUID) {
        print("INUIEditVoiceShortcutViewController ha rimosso una shortcut")
        controller.dismiss(animated: true, completion: nil)
        self.fetchShortcuts()
    }
    
    func editVoiceShortcutViewControllerDidCancel(_ controller: INUIEditVoiceShortcutViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
