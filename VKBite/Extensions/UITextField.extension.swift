import UIKit

extension UITextField {
    func indent(size: CGFloat) {
        self.leftView = UIView(frame: CGRect(x: self.frame.minX, y: self.frame.minY, width: size, height: self.frame.height))
        self.leftViewMode = .always
    }
    
    func handleNonIntegerInput(for vc: UIViewController) {
        if let text = text, !text.isEmpty {
            guard let _ = Int(text) else {
                let alertController = UIAlertController(title: "Error", message: "Settings must be integers", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                vc.present(alertController, animated: true, completion: nil)
                return
            }
        }
    }
    
    func getInteger() -> Int? {
        if let text = text, let number = Int(text), !text.isEmpty {
            return number
        } else {
            return nil
        }
    }
}
