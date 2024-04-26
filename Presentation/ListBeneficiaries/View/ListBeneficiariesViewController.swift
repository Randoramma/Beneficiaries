//
//  ViewController.swift
//  Beneficiaries
//
//  Created by Randy McLain on 4/19/24.
//

import UIKit
import Combine

final class ListBeneficiariesViewController: UIViewController {
    
    private enum Constraints {
        static let estimatedRowHeight: CGFloat = 80
    }
    
    // - MARK:  Properties
    private var cancellables: Set<AnyCancellable> = []
    private var viewModel: ListBeneficiariesViewModel
    private var activityIndicator: UIActivityIndicatorView!
    private let overlay = UIView()
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()

    // - MARK: Initializers
    init(viewModel: ListBeneficiariesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required internal init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // - MARK:  Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindViewModel()
        self.setupActivityIndicator()
        self.viewModel.viewDidLoad()
        self.setupViews()
        
        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor), // handling the notch
            self.tableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            self.tableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            self.tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    
    deinit {
        cancellables.removeAll()
    }

    // - MARK: UI Setup
    private func setupViews() {
        self.tableView.estimatedRowHeight = Constraints.estimatedRowHeight
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.register(BenefitsListItemTableViewCell.self, forCellReuseIdentifier: BenefitsListItemTableViewCell.reuseIdentifier)
        
        view.addSubview(self.tableView)
        view.backgroundColor = .systemBackground
        title = GlobalConstants.beneficiariesTitle
        configureNavigationBar()
    }
    
    private func configureNavigationBar() {
        if let navigationBar = navigationController?.navigationBar {
            let textAttributes = [NSAttributedString.Key.foregroundColor: UIColor.label]
            navigationBar.titleTextAttributes = textAttributes
            navigationBar.barTintColor = .systemBackground
            navigationBar.prefersLargeTitles = true
            navigationBar.largeTitleTextAttributes = textAttributes
        }
    }
    
    // - MARK: Combine setup
    private func bindViewModel() {
        viewModel.$content
            .receive(on: RunLoop.main)
            .sink { [weak self] state in
            guard let self = self else { return }
            switch state {
            case .items( _):
                self.activityIndicator.stopAnimating()
                self.tearDownActivityIndicator()
                self.tableView.reloadData()
            case .empty, .loading:
                self.activityIndicator.startAnimating()
                self.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.$error
            .receive(on: RunLoop.main)
            .sink { [weak self] error in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.tearDownActivityIndicator()
                if let error {
                    self.showAlert(withMessage: error.debugDescription)
                }
        }.store(in: &cancellables)
    }
    
    // - MARK: Detail View
    private func showDetailModal(for item: ListBeneficiariesViewModel, at index: Int) {
        let modalViewModel = BeneficiaryDetailModalViewModel(model: item.items[index])
        let detailVC = BeneficiaryDetailModalViewController(viewModel: modalViewModel)
        detailVC.modalPresentationStyle = .overCurrentContext
        detailVC.configure()
        self.present(detailVC, animated: true, completion: nil)
    }
    
    func showAlert(withMessage message: String) {
        let alertController = UIAlertController(title: GlobalConstants.errorTitle, message: message, preferredStyle: .alert)
         alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
         self.present(alertController, animated: true, completion: nil)
     }
}

extension ListBeneficiariesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard case .items(let items) = viewModel.content else {
            // viewModel.content can return 0 objects where we would not require cells.. i.e .loading or empty states
            return 0
        }
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: BenefitsListItemTableViewCell.reuseIdentifier, for: indexPath) as? BenefitsListItemTableViewCell else {
            fatalError("Invalid Reuse identifier for BenefitsListItemTableViewCell")
        }
        
        self.configureCellAt(indexPath, cell)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.showDetailModal(for: viewModel, at: indexPath.row)
    }
    
    fileprivate func configureCellAt(_ indexPath: IndexPath, _ cell: BenefitsListItemTableViewCell) {
        if case .items( _) = viewModel.content {
            let item = viewModel.items[indexPath.row]
            let viewModel = BeneficiariesListCellItemViewModel(model: item)
            cell.configure(viewModel)
            cell.selectionStyle = .none
        }
    }
}

// - MARK: Activity Indicator
extension ListBeneficiariesViewController {
    
    private func setupActivityIndicator() {
        self.activityIndicator = UIActivityIndicatorView(style: .large)
        self.activityIndicator.color = .gray
        self.activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(self.activityIndicator)
        
        self.overlay.translatesAutoresizingMaskIntoConstraints = false
        self.overlay.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.addSubview(self.overlay)
        self.overlay.addSubview(self.activityIndicator)
           
       NSLayoutConstraint.activate([
        self.overlay.topAnchor.constraint(equalTo: view.topAnchor),
        self.overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        self.overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        self.overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),
           
        self.activityIndicator.centerXAnchor.constraint(equalTo: self.overlay.centerXAnchor),
        self.activityIndicator.centerYAnchor.constraint(equalTo: self.overlay.centerYAnchor)
       ])
    }
    
    private func tearDownActivityIndicator() {
        self.activityIndicator.removeFromSuperview()
        self.overlay.removeFromSuperview()
    }
}
