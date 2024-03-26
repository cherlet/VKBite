import Foundation

class Human {
    // MARK: Properties
    let id: UUID
    var neighbors = Set<UUID>()
    var isInfected = false
    
    // MARK: Initialize
    init(id: UUID) {
        self.id = id
    }
    
    // MARK: Methods
    func setInfected() {
        isInfected = true
    }
    
    func append(neighbor: UUID) {
        neighbors.insert(neighbor)
    }
    
    func getNeighbors(limit: Int) -> [UUID] {
        Array(neighbors.prefix(limit))
    }
}
