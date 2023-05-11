//
//  ListOfLocations.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 09.05.2023.
//

import UIKit
import CoreData

class ListOfLocationsViewController: UIViewController {
    enum Constants {
        static let locationCellID = "LocationCellID"
        static let defaultCellID = "DefaultCellID"
    }

    private lazy var coreDataLocationService: CoreDataLocationService = CoreDataLocationServiceImp(delegate: self)
    private lazy var  tableView = UITableView(frame: .zero, style: .grouped)

    init(){
        super.init(nibName: nil, bundle: nil)
        self.view.alpha = 0.9
        self.view.backgroundColor = #colorLiteral(red: 0.1248925701, green: 0.3067729473, blue: 0.781540215, alpha: 1)
        self.setupTableView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTableView() {
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 144
        self.tableView.register(LocationTableViewCell.self, forCellReuseIdentifier: Constants.locationCellID)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.defaultCellID)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.backgroundColor = .clear
        self.tableView.allowsSelection = false

        self.view.addSubview(self.tableView)

        NSLayoutConstraint.activate([
            self.tableView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 16),
            self.tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 16),
            self.tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -16),
            self.tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -16),
        ])
    }

}

extension ListOfLocationsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        guard let numberOfRows = self.coreDataLocationService.getObjects()?.count else { return 0 }
        return numberOfRows
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.locationCellID, for: indexPath) as? LocationTableViewCell else {
            let cell = tableView.dequeueReusableCell(withIdentifier: Constants.defaultCellID, for: indexPath)
            return cell
        }
        let indexForLocation = IndexPath(row: indexPath.section, section: indexPath.row)

        guard let locationModel = self.coreDataLocationService.getObject(index: indexForLocation) else { return cell}

        if locationModel.locationID == 0 {
            cell.isUserInteractionEnabled = false
        } else {
            cell.isUserInteractionEnabled = true
        }

        cell.setupLocation(for: locationModel)
        return cell
    }
}

extension ListOfLocationsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let locationIndex = IndexPath(row: indexPath.section, section: 0)
        guard let deletedLocation = self.coreDataLocationService.getObject(index: locationIndex) else { return nil}
        guard deletedLocation.locationID != 0 else { return nil}

        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { _, _, _ in
            self.coreDataLocationService.deleteLocation(for: deletedLocation.locationID)

        }
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }
}

extension ListOfLocationsViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .delete:
            guard let indexPath = indexPath else { return }

            let indexSet = IndexSet(arrayLiteral: indexPath.row)

            self.tableView.deleteSections(indexSet, with: .right)

        case .update, .move, .insert:
            return
        @unknown default:
            fatalError()
        }    }
}
