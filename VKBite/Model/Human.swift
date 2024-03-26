import Foundation

class Human {
    let position: Position
    var isInfected = false
    
    init(x: Int, y: Int) {
        self.position = Position(x: x, y: y)
    }
    
    func setInfected() {
        isInfected = true
    }
}
