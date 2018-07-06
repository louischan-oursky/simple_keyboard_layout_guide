import UIKit

public struct KeyboardInfo {
    var duration: Double
    // UIViewAnimationCurve(rawValue: (notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! NSNumber).intValue)
    // returns nil and I do not know why
    var curve: Int
    var startFrame: CGRect
    var endFrame: CGRect
    init?(notification: Notification) {
        if
            let a = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue,
            let b = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue,
            let c = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber,
            let d = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
        {
            self.startFrame = a.cgRectValue
            self.endFrame = b.cgRectValue
            self.duration = c.doubleValue
            self.curve = d.intValue
        } else {
            return nil
        }
    }
}

public class KeyboardLayoutGuide : NSObject, UILayoutSupport {
    public var length: CGFloat {
        return self.keyboardHeight
    }
    public var topAnchor: NSLayoutYAxisAnchor {
        return self.guide.topAnchor
    }
    public var bottomAnchor: NSLayoutYAxisAnchor {
        return self.guide.bottomAnchor
    }
    public var heightAnchor: NSLayoutDimension {
        return self.guide.heightAnchor
    }
    private var keyboardHeight: CGFloat {
        didSet {
            if self.keyboardHeight > 0 {
                // The keyboard height reported by the system includes bottomLayoutGuide.length
                // So we need to offset it
                self.topConstraint.constant = -self.keyboardHeight + (self.viewController?.bottomLayoutGuide.length ?? 0)
            } else {
                self.topConstraint.constant = -self.keyboardHeight
            }
            self.heightConstraint.constant = self.keyboardHeight
        }
    }
    private var guide: UILayoutGuide
    private var topConstraint: NSLayoutConstraint
    private var heightConstraint: NSLayoutConstraint
    private var observers: [NSObjectProtocol]
    private weak var viewController: UIViewController?
    public init(viewController: UIViewController) {
        self.viewController = viewController
        self.keyboardHeight = 0
        self.guide = UILayoutGuide()
        viewController.view.addLayoutGuide(self.guide)
        self.topConstraint = self.guide.topAnchor.constraint(equalTo: viewController.bottomLayoutGuide.topAnchor)
        self.topConstraint.isActive = true
        self.guide.bottomAnchor.constraint(equalTo: viewController.bottomLayoutGuide.bottomAnchor).isActive = true
        self.heightConstraint = self.guide.heightAnchor.constraint(equalToConstant: self.keyboardHeight)
        self.heightConstraint.isActive = true
        self.observers = [NSObjectProtocol]()
        super.init()
        self.observers.append(
            NotificationCenter.default.addObserver(forName: .UIKeyboardWillChangeFrame, object: nil, queue: .main) { (notification) in
                self.keyboardWillChangeFrame(notification)
            }
        )
        self.observers.append(
            NotificationCenter.default.addObserver(forName: .UIKeyboardWillShow, object: nil, queue: .main, using: { (notification) in
                self.keyboardWillShow(notification)
            })
        )
        self.observers.append(
            NotificationCenter.default.addObserver(forName: .UIKeyboardWillHide, object: nil, queue: .main, using: { (notification) in
                self.keyboardWillHide(notification)
            })
        )
    }
    deinit {
        self.observers.forEach { (observer) in
            NotificationCenter.default.removeObserver(observer)
        }
    }
    @objc private func keyboardWillChangeFrame(_ notification: Notification) {
        if let keyboardInfo = KeyboardInfo(notification: notification) {
            UIView.animate(withDuration: keyboardInfo.duration) {
                self.keyboardHeight = keyboardInfo.endFrame.height
                self.viewController?.view.layoutIfNeeded()
            }
        }
    }
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardInfo = KeyboardInfo(notification: notification) {
            UIView.animate(withDuration: keyboardInfo.duration) {
                self.keyboardHeight = keyboardInfo.endFrame.height
                self.viewController?.view.layoutIfNeeded()
            }
        }
    }
    @objc private func keyboardWillHide(_ notification: Notification) {
        if let keyboardInfo = KeyboardInfo(notification: notification) {
            UIView.animate(withDuration: keyboardInfo.duration) {
                self.keyboardHeight = 0
                self.viewController?.view.layoutIfNeeded()
            }
        }
    }
}
