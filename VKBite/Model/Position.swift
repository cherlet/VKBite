import Foundation

struct Position {
    let x: Int
    let y: Int
}

extension Position {
    func getNeighborPosition(on position: NeighborPosition, bottomRightCorner: Position, residue: Int) -> Position? {
        let residueLine = Array(0..<residue)
        
        switch position {
        case .top:
            guard y > 0 else { return nil }
            return Position(x: x, y: y - 1)
        case .topRight:
            guard y > 0, x < bottomRightCorner.x else { return nil }
            return Position(x: x + 1, y: y - 1)
        case .right:
            guard x < bottomRightCorner.x else { return nil}
            return Position(x: x + 1, y: y)
        case .bottomRight:
            guard (y < bottomRightCorner.y && x < bottomRightCorner.x) || (residueLine.firstIndex(of: x + 1) != nil && y < bottomRightCorner.y + 1) else { return nil}
            return Position(x: x + 1, y: y + 1)
        case .bottom:
            guard y < bottomRightCorner.y || (residueLine.firstIndex(of: x) != nil && y < bottomRightCorner.y + 1) else { return nil }
            return Position(x: x, y: y + 1)
        case .bottomLeft:
            guard (y < bottomRightCorner.y && x > 0) || (residueLine.firstIndex(of: x - 1) != nil && y < bottomRightCorner.y + 1) else { return nil }
            return Position(x: x - 1, y: y + 1)
        case .left:
            guard x > 0 else { return nil }
            return Position(x: x - 1, y: y)
        case .topLeft:
            guard y > 0, x > 0 else { return nil }
            return Position(x: x - 1, y: y - 1)
        }
    }
}

enum NeighborPosition {
    case top
    case topRight
    case right
    case bottomRight
    case bottom
    case bottomLeft
    case left
    case topLeft
}
