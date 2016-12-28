//
//  KotenViewController.swift
//  ProjectIOS
//
//  Created by Arno Lambert on 28/12/2016.
//  Copyright © 2016 Arno Lambert. All rights reserved.
//

import UIKit

class KotenViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var errorView: UIView!
    
    fileprivate var koten: [Kot] = []
    private var currentTask: URLSessionTask?
    
    override func viewDidLoad() {
        
        splitViewController!.delegate = self
        
        errorView.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(errorView)
        tableView.addConstraints([
            errorView.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            errorView.centerYAnchor.constraint(equalTo: tableView.centerYAnchor),
            errorView.widthAnchor.constraint(equalTo: tableView.widthAnchor),
            errorView.heightAnchor.constraint(equalTo: tableView.heightAnchor)
            ])
        hideErrorView()
        
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        tableView.addSubview(activityIndicator)
        tableView.addConstraints([
            NSLayoutConstraint(item: activityIndicator,
                               attribute: .centerX,
                               relatedBy: .equal,
                               toItem: tableView,
                               attribute: .centerX,
                               multiplier: 1, constant: 0),
            NSLayoutConstraint(item: activityIndicator,
                               attribute: .centerY,
                               relatedBy: .equal,
                               toItem: tableView,
                               attribute: .centerY,
                               multiplier: 1, constant: 0)
            ])
        activityIndicator.startAnimating()
        
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let koten):
                self.hideErrorView()
                self.koten = koten
                self.tableView.reloadData()
            case .failure(let error):
                print(error)
                self.showErrorView()
                self.tableView.reloadData() // to hide separators
            }
            activityIndicator.stopAnimating()
        }
        currentTask!.resume()
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }
    
    private func showErrorView() {
        tableView.separatorStyle = .none
        errorView.isHidden = false
    }
    
    private func hideErrorView() {
        tableView.separatorStyle = .singleLine
        errorView.isHidden = true
    }
    
    func refreshTableView() {
        currentTask?.cancel()
        currentTask = Service.shared.loadDataTask {
            result in
            switch result {
            case .success(let koten):
                self.tableView.reloadData()
                self.koten = koten
                self.hideErrorView()
            case .failure(let error):
                print(error)
                self.showErrorView()
                self.tableView.reloadData() // to hide separators
            }
            self.tableView.refreshControl!.endRefreshing()
        }
        currentTask!.resume()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let navigationController = segue.destination as! UINavigationController
        let kotViewController = navigationController.topViewController as! KotViewController
        let selectedIndex = tableView.indexPathForSelectedRow!.row
        kotViewController.kot = koten[selectedIndex]
    }
}


extension KotenViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return koten.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "kotCell", for: indexPath)
        let kot = koten[indexPath.row]
        cell.textLabel!.text = "\(kot.straatnaam) \(kot.huisnummer)"
        cell.detailTextLabel!.text = "€ \(kot.totalePrijs)"
        return cell
    }
}

extension KotenViewController: UITableViewDelegate {
    
}

extension KotenViewController: UISplitViewControllerDelegate {
    
    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        print(splitViewController.traitCollection)
        print(secondaryViewController.traitCollection)
        return true
    }
}

