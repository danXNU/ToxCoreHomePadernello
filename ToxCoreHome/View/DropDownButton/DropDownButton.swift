import UIKit

class DropDownButton : UIButton {
    
    var options : [String] = [String]() {
        didSet {
            dropView.dropDownOptions = options
        }
    }
    
    var showHandler : ((Bool, DropDownButton) -> Void)?
    var buttonWasTapped : ((String) -> Void)?
    var dropView = DropDownView()
    var height : NSLayoutConstraint?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .darkGray
        
        dropView = DropDownView.init(frame: CGRect.zero)
        dropView.rowSelectedAction = { [weak self] (stringSelected) in
            DispatchQueue.main.async {
                self?.setTitle(stringSelected, for: .normal)
                self?.buttonWasTapped?(stringSelected)
                self?.dismissDropDown()
            }
        }
        dropView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        self.superview?.addSubview(dropView)
        self.superview?.bringSubviewToFront(dropView)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        dropView.topAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        dropView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        dropView.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        if height == nil {
            height = dropView.heightAnchor.constraint(equalToConstant: 0)
        }
    }
    
    var isOpen = false
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        isOpen ? dismissDropDown() : openDropDown()
    }
    
    fileprivate func openDropDown() {
        isOpen = true
        self.height?.isActive = false
        
        let tableViewHeight = self.dropView.tableView.contentSize.height
        self.height?.constant = (tableViewHeight > 150) ? 150 : tableViewHeight
        self.height?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.layoutIfNeeded()
            self.dropView.center.y += self.dropView.frame.height / 2
        }, completion: nil)
        
        showHandler?(true, self)
    }
    
    fileprivate func dismissDropDown() {
        isOpen = false
        self.height?.isActive = false
        self.height?.constant = 0
        self.height?.isActive = true
        
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseInOut, animations: {
            self.dropView.center.y -= self.dropView.frame.height / 2
            self.dropView.layoutIfNeeded()
        }, completion: nil)
        
        showHandler?(false, self)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
