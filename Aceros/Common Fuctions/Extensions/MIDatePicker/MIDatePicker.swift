

import UIKit

protocol MIDatePickerDelegate: class {
    
    func miDatePicker(amDatePicker: MIDatePicker, didSelect date: NSDate)
    func miDatePickerDidCancelSelection(amDatePicker: MIDatePicker)
    
}

class MIDatePicker: UIView {
    
    // MARK: - Config
    struct Config {
        
         let contentHeight: CGFloat =  200
         let bouncingOffset: CGFloat = 20
        
        var startDate: NSDate?
        var maximumDate: NSDate?
        
        var confirmButtonTitle = "Confirm"
        var cancelButtonTitle = "Cancel"
        
        var headerHeight: CGFloat = 48
        
        var animationDurationDatePicker : TimeInterval = 0.5
        
        var contentBackgroundColor: UIColor = UIColor.lightGray
        var headerBackgroundColor: UIColor = UIColor.white
        var confirmButtonColor: UIColor = UIColor.black.withAlphaComponent(0.6)
        var cancelButtonColor: UIColor = UIColor.black.withAlphaComponent(0.6)
        
        var overlayBackgroundColor: UIColor = UIColor.black.withAlphaComponent(0.6)
        
    }
    
    var config = Config()
    
    weak var delegate: MIDatePickerDelegate?
    
    // MARK: - IBOutlets
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var headerViewHeightConstraint: NSLayoutConstraint!
    
    var bottomConstraint1: NSLayoutConstraint!
    var overlayButton: UIButton!
    
    // MARK: - Init
    static func getFromNib() -> MIDatePicker {
        return UINib.init(nibName: "MIDatePicker" , bundle: nil).instantiate(withOwner: self, options: nil).last as! MIDatePicker
    }
    
    // MARK: - IBAction
    
    @IBAction func confirmButtonDidTapped(_ sender: Any) {
        
        config.startDate = datePicker.date as NSDate
        
        dismiss()
        delegate?.miDatePicker(amDatePicker: self, didSelect: datePicker.date as NSDate)
        
    }
    
    @IBAction func cancelButtonDidTapped(_ sender: Any) {
        
        dismiss()
        delegate?.miDatePickerDidCancelSelection(amDatePicker: self)
    }
    
  
    
    // MARK: - Private
    private func setup(parentVC: UIViewController) {
        
        // Loading configuration
        
        if let startDate = config.startDate {
            datePicker.date = startDate as Date
        }
        
        if let maximumDate = config.maximumDate {
            datePicker.date = maximumDate as Date
        }
        
        headerViewHeightConstraint.constant = config.headerHeight
        
        confirmButton.setTitle(config.confirmButtonTitle, for: .normal)
        cancelButton.setTitle(config.cancelButtonTitle, for: .normal)
        
        confirmButton.setTitleColor(config.confirmButtonColor, for: .normal)
        cancelButton.setTitleColor(config.cancelButtonColor, for: .normal)
        
        headerView.backgroundColor = config.headerBackgroundColor
        backgroundView.backgroundColor = config.contentBackgroundColor
        
        // Overlay view constraints setup
        
        overlayButton = UIButton(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        overlayButton.backgroundColor = config.overlayBackgroundColor
        overlayButton.alpha = 0
        
        overlayButton.addTarget(self, action: #selector(cancelButtonDidTapped), for: .touchUpInside)
        
        if !overlayButton.isDescendant(of: parentVC.view) { parentVC.view.addSubview(overlayButton) }
        
        overlayButton.translatesAutoresizingMaskIntoConstraints = false
        
        parentVC.view.addConstraints([
            NSLayoutConstraint(item: overlayButton, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .top, relatedBy: .equal, toItem: parentVC.view, attribute: .top, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: overlayButton, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        
        // Setup picker constraints
        
        frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: UIScreen.main.bounds.width, height: config.contentHeight + config.headerHeight)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        bottomConstraint1 = NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: parentVC.view, attribute: .bottom, multiplier: 1, constant: 0)
        
        if !isDescendant(of: parentVC.view) { parentVC.view.addSubview(self) }
        
        parentVC.view.addConstraints([
            bottomConstraint1,
            NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: parentVC.view, attribute: .leading, multiplier: 1, constant: 0),
            NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: parentVC.view, attribute: .trailing, multiplier: 1, constant: 0)
            ]
        )
        addConstraint(
            NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: frame.height)
        )
        
        move(goUp: false)
        
        datePicker.maximumDate = datePicker.date
        
    }
    private func move(goUp: Bool) {
        bottomConstraint1.constant = goUp ? config.bouncingOffset : config.contentHeight + config.headerHeight
    }
    
    // MARK: - Public
    func show(inVC parentVC: UIViewController, completion: (() -> ())? = nil) {
        
        parentVC.view.endEditing(true)
        
        setup(parentVC: parentVC)
        move(goUp: true)
        
        UIView.animate(
            withDuration: config.animationDurationDatePicker, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 5, options: .curveEaseIn, animations: {
                
                parentVC.view.layoutIfNeeded()
                self.overlayButton.alpha = 1
                
            }, completion: { (finished) in
                completion?()
            }
        )
        
    }
    func dismiss(completion: (() -> ())? = nil) {
        
        move(goUp: false)
        
        UIView.animate(
            withDuration: config.animationDurationDatePicker, animations: {
                
                self.layoutIfNeeded()
                self.overlayButton.alpha = 0
                
            }, completion: { (finished) in
                completion?()
                self.removeFromSuperview()
                self.overlayButton.removeFromSuperview()
            }
        )
        
    }
    
}

extension MIDatePicker {
    
    func set18YearValidation() {
        let currentDate: Date = Date()
        var calendar: Calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        calendar.timeZone = TimeZone(identifier: "UTC")!
        var components: DateComponents = DateComponents()
        components.calendar = calendar
        components.year = -18
       // let maxDate: Date = calendar.date(byAdding: components, to: currentDate)!
       // components.year = -150
        let minDate: Date = calendar.date(byAdding: components, to: currentDate)!
        self.config.startDate = minDate as NSDate
       // self.maximumDate = maxDate
    }
    
}
