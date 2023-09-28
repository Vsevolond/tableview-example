//
//  ViewController.swift
//  TableView
//
//  Created by Vsevolod Donchenko on 29.07.2023.
//

import UIKit


enum Action: String {
    case save
    case delete
}

class ViewController: UIViewController {
    
    private enum Section {
        case main
    }
    
    private struct Item {
        var id: Int
        var title: String
        var subtitle: String
    }
    
    private var items: [Item] = (0...10).map {
        Item(id: $0, title: "Item \($0)", subtitle: "\($0)")
    }
    
    private lazy var tableView = UITableView()
    
    private lazy var dataSource = UITableViewDiffableDataSource<Section, Int>(tableView: tableView) { tableView, indexPath, itemIdentifier in
        let cell = tableView.dequeueReusableCell(withIdentifier: "\(UITableViewCell.self)", for: indexPath)
        let item = self.items[indexPath.row]
        var configuration = cell.defaultContentConfiguration()
        configuration.text = item.title
        configuration.secondaryText = item.subtitle
        cell.contentConfiguration = configuration
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: tableView.topAnchor),
            view.leadingAnchor.constraint(equalTo: tableView.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: tableView.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: tableView.trailingAnchor)
        ])
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "\(UITableViewCell.self)")
        tableView.dataSource = dataSource
        tableView.delegate = self
        
        updateDataSource(animated: false)
    }

    override func viewWillLayoutSubviews() {
        navigationItem.title = "Context Menu"
        
        let saveAction = UIAction(title: "Save", image: UIImage(systemName: "square.and.arrow.down")) { [weak self] action in
            self?.didSelectAction(action: .save)
        }
        let deleteAction = UIAction(title: "Delete", image: UIImage(systemName: "trash")) { [weak self] action in
            self?.didSelectAction(action: .delete)
        }
        
        let items = [saveAction, deleteAction]
        let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: items)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: nil, image: UIImage(systemName: "ellipsis"), primaryAction: nil, menu: menu)
    }
    
    private func didSelectAction(action: Action) {
        print(action.rawValue)
    }
    
    private func shuffle() {
        items.shuffle()
        tableView.reloadData()
        updateDataSource(animated: true)
    }
    
    private func updateDataSource(animated: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map { $0.id })
        dataSource.apply(snapshot, animatingDifferences: animated)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        shuffle()
    }
    
    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let item = items[indexPath.row]
        
        let config = UIContextMenuConfiguration(identifier: nil) {
            let previewController = PreviewViewController()
            previewController.configure(with: item.title)
            
            return previewController
        } actionProvider: { _ in
            let action = UIAction(title: "Some action") { action in
                print("some action")
            }
            
            return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [action])
        }
        
        return config
    }
    
    func tableView(_ tableView: UITableView, willPerformPreviewActionForMenuWith configuration: UIContextMenuConfiguration, animator: UIContextMenuInteractionCommitAnimating) {
        animator.addCompletion { [weak self] in
            print("tap on view controller")
            if let viewController = animator.previewViewController {
                self?.present(viewController, animated: true)
            }
        }
    }
}

