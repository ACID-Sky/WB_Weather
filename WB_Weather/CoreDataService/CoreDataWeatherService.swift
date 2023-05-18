//
//  CoreDataWeatherService.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 26.04.2023.
//

import Foundation
import CoreData
import UIKit

protocol CoreDataWeatherService: AnyObject {
    /// Установить предикат для экземпляра сервиса
    /// - Parameter predicate: предикат
    func setupPredicate(predicate: NSPredicate)

    /// Получить все объекты
    /// - Returns: массив WeatherForecastCoreDataModel
    func getObjects() -> [WeatherForecastCoreDataModel]?

    /// Получить обект по индексу
    /// - Parameter index: индекспаф [х,х]
    /// - Returns: объект типа WeatherForecastCoreDataModel
    func getObject(index: IndexPath) -> WeatherForecastCoreDataModel?

    /// Получение количества обектов
    /// - Parameter section: номер секции
    /// - Returns: количество обектов `Int или 0`
    func getNubers(section: Int) -> Int
}

final class CoreDataWeatherServiceImp {

    private var context: NSManagedObjectContext?
    private var fecthedResultsController: NSFetchedResultsController<WeatherForecastCoreDataModel>?

    init(delegate: NSFetchedResultsControllerDelegate?, predicate: NSPredicate?) {
        self.setupFecthedResultsController()
        self.fecthedResultsController?.delegate = delegate
        self.fetchWeather(predicate: predicate)
    }


    /// Созадние fecthedResultsController с сортировкой по дате прогноза
    private func setupFecthedResultsController() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

        guard let context = self.context else { fatalError() }

        let fetchRequest = WeatherForecastCoreDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "dateOfForecast", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]

        self.fecthedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

//        Возможно стоит добавить вызов self.fetchLocations(predicate: nil)
    }

    /// Запуск работы с fetchedResultController
    /// - Parameter predicate: критерии поиска
    private func fetchWeather(predicate: NSPredicate?) {
        self.fecthedResultsController?.fetchRequest.predicate = predicate
        do {
            try self.fecthedResultsController?.performFetch()

        } catch {
            fatalError("Can't fetch data from db")
        }
    }

}

extension CoreDataWeatherServiceImp {

    /// Инициализация для создания предиката по поиску локации в модели
    /// - Parameters:
    ///   - delegate: делегат
    ///   - locationID: id локации
    convenience init(delegate: NSFetchedResultsControllerDelegate?, locationID: Int32)
    {
        let predicate = NSPredicate(format: "%K == %i", #keyPath(WeatherForecastCoreDataModel.location.locationID),
                                locationID)
        self.init(delegate: delegate, predicate: predicate)

    }

    /// Инициализация для создания предиката по поиску локации и даты в модели
    /// - Parameters:
    ///   - delegate: делегат
    ///   - locationID: id локации
    ///   - date: дата поиска
    convenience init(delegate: NSFetchedResultsControllerDelegate?, locationID: Int32, date: Date)
    {
        let startDayUnix = date.timeIntervalSince1970 - 10800
        let finishDayUnix = startDayUnix + 97200
        let predicate = NSPredicate(
            format: "%K == %i AND %K >= %lf AND %K <= %lf",
            #keyPath(WeatherForecastCoreDataModel.location.locationID),
            locationID,
            #keyPath(WeatherForecastCoreDataModel.dateOfForecast),
            startDayUnix,
            #keyPath(WeatherForecastCoreDataModel.dateOfForecast),
            finishDayUnix
        )
        self.init(delegate: delegate, predicate: predicate)

    }
}

extension CoreDataWeatherServiceImp: CoreDataWeatherService {
    func setupPredicate(predicate: NSPredicate) {
        self.fetchWeather(predicate: predicate)
    }


    func getObjects() -> [WeatherForecastCoreDataModel]? {
        guard let weather = self.fecthedResultsController?.fetchedObjects else { return nil }

        return weather
    }

    func getObject(index indexPath: IndexPath) -> WeatherForecastCoreDataModel? {
        guard let location = self.fecthedResultsController?.object(at: indexPath) else { return nil }
        return location
    }

    func getNubers(section: Int) -> Int {
        guard let sections = self.fecthedResultsController?.sections else { return 0 }

        return sections[section].numberOfObjects
    }
}

