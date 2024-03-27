import UIKit

class StatusBar: UIView {
    // MARK: Properties
    var healthy: Int {
        didSet {
            self.healthyLabel.text = String(self.healthy)
        }
    }
    var infected: Int = 0 {
        didSet {
            self.infectedLabel.text = String(self.infected)
        }
    }
    
    // MARK: UI Elements
    private lazy var healthySubview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var healthyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .systemBlue
        label.text = String(healthy)
        return label
    }()
    
    private lazy var infectedSubview: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var infectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .red
        label.text = String(infected)
        return label
    }()
    
    // MARK: Initialize
    init(groupSize: Int) {
        self.healthy = groupSize
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Setup
    
    func setup() {
        backgroundColor = .systemGray5
        
        setupSubviews()
        setupLayout()
    }
    
    func setupLayout() {
        [infectedSubview, healthySubview].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            infectedSubview.widthAnchor.constraint(equalToConstant: 64),
            infectedSubview.heightAnchor.constraint(equalToConstant: 32),
            infectedSubview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            infectedSubview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            
            healthySubview.widthAnchor.constraint(equalToConstant: 64),
            healthySubview.heightAnchor.constraint(equalToConstant: 32),
            healthySubview.trailingAnchor.constraint(equalTo: infectedSubview.leadingAnchor, constant: -8),
            healthySubview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
        ])
    }
    
    func setupSubviews() {
        healthyLabel.translatesAutoresizingMaskIntoConstraints = false
        healthySubview.addSubview(healthyLabel)
        
        infectedLabel.translatesAutoresizingMaskIntoConstraints = false
        infectedSubview.addSubview(infectedLabel)
        
        NSLayoutConstraint.activate([
            healthyLabel.centerXAnchor.constraint(equalTo: healthySubview.centerXAnchor),
            healthyLabel.centerYAnchor.constraint(equalTo: healthySubview.centerYAnchor),
            
            infectedLabel.centerXAnchor.constraint(equalTo: infectedSubview.centerXAnchor),
            infectedLabel.centerYAnchor.constraint(equalTo: infectedSubview.centerYAnchor),
        ])
    }
}

// MARK: - Actions
extension StatusBar {
    func clock() {
        infected += 1
        healthy -= 1
    }
}
