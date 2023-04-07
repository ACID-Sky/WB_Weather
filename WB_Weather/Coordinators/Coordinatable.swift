//
//  Coordinatable.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 05.04.2023.
//

import UIKit

import UIKit

protocol Coordinatable: AnyObject {
    var childCoordinators: [Coordinatable] { get }

    func start() -> UIViewController
    func addChildCoordinator(_ coordinator: Coordinatable)
    func removeChildCoordinator(_ coordinator: Coordinatable)
}

protocol ModuleCoordinatable: Coordinatable {
    var module: Module? { get }
    var moduleType: Module.ModuleType { get }
}

extension Coordinatable {
    func addChildCoordinator(_ coordinator: Coordinatable) {}
    func removeChildCoordinator(_ coordinator: Coordinatable) {}
}
