//
//  PreviewViewController.swift
//  TableView
//
//  Created by Vsevolod Donchenko on 29.07.2023.
//

import UIKit


final class PreviewViewController: UIViewController {
    private let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        label.frame = .init(x: 0, y: view.center.y, width: view.frame.width, height: 60)
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 24)
        view.addSubview(label)
    }
    
    func configure(with text: String) {
        label.text = text
    }
}

