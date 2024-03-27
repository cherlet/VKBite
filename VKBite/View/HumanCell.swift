import UIKit

class HumanCell: UICollectionViewCell {
    // MARK: Properties
    static let identifier = "HumanCell"
    
    // MARK: UI Elements
    private lazy var circleImage: UIImageView = {
        let image = UIImage(systemName: "person.crop.circle")
        let imageView = UIImageView(image: image)
        imageView.tintColor = .green
        return imageView
    }()
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.layer.cornerRadius = 24
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    private func setupLayout() {
        [circleImage].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            contentView.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            circleImage.topAnchor.constraint(equalTo: contentView.topAnchor),
            circleImage.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            circleImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            circleImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    func configure(status isInfected: Bool) {
        let imageName = isInfected ? "person.crop.circle.badge.minus" : "person.crop.circle"
        circleImage.tintColor = isInfected ? .red : .systemBlue
        circleImage.image = UIImage(systemName: imageName)
    }
}
