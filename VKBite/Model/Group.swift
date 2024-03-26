import Foundation

struct Group {
    var humans: [[Human]] = []
    var information = (bottomRightCorner: Position(x: 0, y: 0), residue: 0)
    
    
    init(size: Int) {
        let response = getGroup(with: size.getMaxRectangle())
        self.humans = response.humans
        self.information = (response.bottomRightCorner, response.residue)
    }
}

// MARK: - Methods
private extension Group {
    func getGroup(with pattern: (height: Int, residue: Int)) -> (humans: [[Human]], bottomRightCorner: Position, residue: Int) {
        var matrix: [[Human]] = []
        
        guard pattern.height != 0 else { return (matrix, Position(x: 0, y: 0), 0) }
        
        var height = pattern.height
        let width = height / 2
        var residue = pattern.residue
        
        while residue > width {
            residue -= width
            height += 1
        }
        
        // Setup rectangle
        for rowIterator in 0..<height {
            var row: [Human] = []
            
            for columnIterator in 0..<width {
                let human = Human(x: columnIterator, y: rowIterator)
                row.append(human)
            }
            
            matrix.append(row)
        }
        
        let bottomRightCorner = Position(x: width - 1, y: height - 1)
        
        // Setup residue
        var residueRow: [Human] = []
        
        for iterator in 0..<residue {
            let human = Human(x: iterator, y: height)
            residueRow.append(human)
        }
        
        // Rectangle + residue -> return
        matrix.append(residueRow)
        
        return (matrix, bottomRightCorner, residue)
    }
}
