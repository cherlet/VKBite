import UIKit

protocol HomeViewProtocol: AnyObject {}

class HomeViewController: UIViewController, HomeViewProtocol {
    // MARK: Properties
    var presenter: HomePresenterProtocol?
    let defaultConfiguration = Configuration(groupSize: 100, infectionFactor: 3, timestamp: 1)

    // MARK: UI Elements
    private lazy var appLabel: UILabel = {
        let label = UILabel()
        label.text = "VKBite"
        label.textColor = .systemBlue
        label.font = UIFont.systemFont(ofSize: 32, weight: .semibold)
        return label
    }()
    
    private lazy var groupSizeLabel: UILabel = {
        let label = UILabel()
        label.text = "Group size"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var groupSizeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(defaultConfiguration.groupSize)
        textField.backgroundColor = .systemGray5
        textField.indent(size: 16)
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private lazy var infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.text = "Infection factor"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var infectionFactorTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(defaultConfiguration.infectionFactor)
        textField.backgroundColor = .systemGray5
        textField.indent(size: 16)
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private lazy var timestampLabel: UILabel = {
        let label = UILabel()
        label.text = "Timestamp"
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private lazy var timestampTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = String(defaultConfiguration.timestamp)
        textField.backgroundColor = .systemGray5
        textField.indent(size: 16)
        textField.layer.cornerRadius = 8
        textField.font = UIFont.systemFont(ofSize: 20)
        return textField
    }()
    
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemBlue
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        button.setTitle("RUN SIMULATION", for: .normal)
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(handleStart), for: .touchUpInside)
        return button
    }()

    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }
}

// MARK: - Setup
private extension HomeViewController {
    func initialize() {
        view.backgroundColor = .white
        setupLayout()
    }
    
    private func setupLayout() {
        [appLabel, groupSizeLabel, groupSizeTextField, infectionFactorLabel, infectionFactorTextField, timestampLabel, timestampTextField, startButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            appLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 200),
            appLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            groupSizeLabel.topAnchor.constraint(equalTo: appLabel.bottomAnchor, constant: 32),
            groupSizeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            groupSizeTextField.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 48),
            groupSizeTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            groupSizeTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 8),
            
            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 16),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            infectionFactorTextField.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 48),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            infectionFactorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 8),
            
            timestampLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 16),
            timestampLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            timestampTextField.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            timestampTextField.heightAnchor.constraint(equalToConstant: 48),
            timestampTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            timestampTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            timestampTextField.topAnchor.constraint(equalTo: timestampLabel.bottomAnchor, constant: 8),
            
            startButton.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor),
            startButton.heightAnchor.constraint(equalToConstant: 48),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.topAnchor.constraint(equalTo: timestampTextField.bottomAnchor, constant: 20)
        ])
    }
}

// MARK: - Actions
private extension HomeViewController {
    @objc func handleStart() {
        let fields = [groupSizeTextField, infectionFactorTextField, timestampTextField]
        
        fields.forEach {
            $0.handleNonIntegerInput(for: self)
        }
        
        let groupSize = groupSizeTextField.getInteger() ?? defaultConfiguration.groupSize
        let infectionFactor = infectionFactorTextField.getInteger() ?? defaultConfiguration.infectionFactor
        let timestamp = timestampTextField.getInteger() ?? defaultConfiguration.timestamp
        
        let configuration = Configuration(groupSize: groupSize, infectionFactor: infectionFactor, timestamp: timestamp)
        
        presenter?.didSetting(with: configuration)
    }
}
