import Foundation

extension Set {
    func containsAll<T: Hashable>(_ array: [T]) -> Bool {
        for element in array {
            if !self.contains(element as! Element) {
                return false
            }
        }
        return true
    }
}
