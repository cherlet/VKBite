import Foundation

extension Int {
    func getMaxRectangle() -> (height: Int, residue: Int) {
        var rows = Int(sqrt(Double(2*self)))
        rows = rows % 2 == 0 ? rows : rows - 1
        let columns = rows / 2
        let residue = self - (rows * columns)
        return (rows, residue)
    }
}
