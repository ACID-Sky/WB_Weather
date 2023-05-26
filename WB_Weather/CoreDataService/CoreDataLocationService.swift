//
//  CoreDataService.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 10.04.2023.
//

import CoreData
import UIKit

protocol CoreDataLocationService: AnyObject {
    /// Получаем все имеющиеся объекты
    func getObjects() -> [LocationsCoreDataModel]?

    /// Получаем объекты для индекса
    func getObject(index: IndexPath) -> LocationsCoreDataModel?

    /// получаем количество объектов для секции
    func getNubersObject(section: Int) -> Int
    
    ///Если локация есть, то обновляем её, если локации нет, то создаём её
    func updateLocation(for location: Locations)

    /// Обновляем погоду для локации
    /// - Parameters:
    ///   - locationID: ID локации, для которой нужно обновить прогноз
    ///   - listWether: массив прогнозов, которые нужно занести для локации (если общий прогноз обновлять не нужно, передать nil)
    ///   - currentWeather: текущий прогноз, который нужно занести для локации (если текущий прогноз обновлять не нужно, передать nil)
    func updateWeather(for locationID: Int32, listWether: [List]?, currentWeather: CurrentWeather?)

    /// Удаление локации
    /// - Parameter locationID: ID локации,  которую нужно удалить
    func deleteLocation(for locationID: Int32)
}

final class CoreDataLocationServiceImp {

    private var context: NSManagedObjectContext?
    private var fecthedResultsController: NSFetchedResultsController<LocationsCoreDataModel>?
    let locationID: Int32?

    init(delegate: NSFetchedResultsControllerDelegate?, locationID: Int32?) {
        self.locationID = locationID
        self.setupFecthedResultsController()
        self.fecthedResultsController?.delegate = delegate
        self.fetchLocations(for: locationID)
    }

    /// Созадние fecthedResultsController с сортировкой по locationID
    private func setupFecthedResultsController() {
        self.context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext

        guard let context = self.context else { fatalError() }

        let fetchRequest = LocationsCoreDataModel.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "locationID", ascending: true)
        fetchRequest.sortDescriptors = [
            sortDescriptor
        ]

        self.fecthedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
    }

    /// Запуск работы с fetchedResultController
    /// - Parameter locationID: location ID rfr критерии поиска
    private func fetchLocations(for locationID: Int32?) {
            var predicate: NSPredicate? = nil
        if locationID != nil {
            predicate = NSPredicate(
                format: "%K == %i",
                #keyPath(LocationsCoreDataModel.locationID),
                locationID!
            )
        }

        self.fecthedResultsController?.fetchRequest.predicate = predicate
        do {
            try self.fecthedResultsController?.performFetch()

        } catch {
            fatalError("Can't fetch data from db")
        }
    }

    ///Сохранение изменений контекста
    private func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()

        } catch {
            fatalError()
        }
    }

    /// Создание новой локации
    private func createLocation(_ location: Locations) {
        guard let context = self.context else { return }

        let locationModel = LocationsCoreDataModel(context: context)
        locationModel.locationID = location.id
        locationModel.locationName = location.locationName
        locationModel.locationLatitude = location.locationLatitude
        locationModel.locationLongitude = location.locationLongitude

        self.saveContext(context: context)
    }
}

extension CoreDataLocationServiceImp {
    convenience init(delegate: NSFetchedResultsControllerDelegate?){
        self.init(delegate: delegate, locationID: nil)
    }
}

extension CoreDataLocationServiceImp: CoreDataLocationService {

    func getObjects() -> [LocationsCoreDataModel]? {
        guard let locations = self.fecthedResultsController?.fetchedObjects else { return nil }
        return locations
    }

    func getObject(index indexPath: IndexPath) -> LocationsCoreDataModel? {
        guard let location = self.fecthedResultsController?.object(at: indexPath) else { return nil }
        return location
    }

    func getNubersObject(section: Int) -> Int {
        guard let sections = self.fecthedResultsController?.sections else { return 0 }

        return sections[section].numberOfObjects
    }

    func updateLocation(for location: Locations) {
        guard let context = self.context else { return }

        self.fetchLocations(for: location.id)
        guard let locations = self.getObjects() else { return }
        if locations.count != 0 {
            let savedLocation = locations[0]
            savedLocation.setValue(location.locationLatitude, forKey: "locationLatitude")
            savedLocation.setValue(location.locationLongitude, forKey: "locationLongitude")
            savedLocation.setValue(location.locationName, forKey: "locationName")

            self.saveContext(context: context)
            self.fetchLocations(for: nil)
        } else {
            self.fetchLocations(for: nil)
            self.createLocation(location)
        }
    }

    func updateWeather(for locationID: Int32, listWether: [List]?, currentWeather: CurrentWeather?) {
        guard let context = self.context else { return }

        self.fetchLocations(for: locationID)

        guard let locations = self.getObjects() else {
            self.fetchLocations(for: self.locationID)
            return
        }

        if locations.count != 0 {

            let savedLocation = locations[0]

            if listWether != nil {
                var arrayWeatherForecast: [WeatherForecastCoreDataModel] = []

                for forecast in listWether! {

                    let weatherForecastModel = WeatherForecastCoreDataModel(context: context)

                    weatherForecastModel.cloudsAll = forecast.clouds.all
                    weatherForecastModel.dateOfForecast = forecast.dt
                    weatherForecastModel.dateOfForecastText = forecast.dt_txt
                    weatherForecastModel.feelsLike = forecast.main.feelsLike
                    weatherForecastModel.humidity = forecast.main.humidity
                    weatherForecastModel.partOfDay = forecast.sys.pod
                    weatherForecastModel.probabilityOfPrecipitation = forecast.pop
                    weatherForecastModel.temp = forecast.main.temp
                    weatherForecastModel.tempMin = forecast.main.tempMin
                    weatherForecastModel.tempMax = forecast.main.tempMax
                    weatherForecastModel.weatherMain = forecast.weather[0].main
                    weatherForecastModel.weatherDescription = forecast.weather[0].description
                    weatherForecastModel.weatherIcon = forecast.weather[0].icon
                    weatherForecastModel.windDeg = forecast.wind.deg
                    weatherForecastModel.windSpeed = forecast.wind.speed

                    arrayWeatherForecast.append(weatherForecastModel)
                }

                savedLocation.weatherForecast = NSSet(array: arrayWeatherForecast)
            }

            if currentWeather != nil {
                let currentWeatherModel = CurrentWeatherCoreDataModel(context: context)

                currentWeatherModel.cloudsAll = currentWeather!.clouds.all
                currentWeatherModel.dateOfForecast = currentWeather!.dt
                currentWeatherModel.mainFeelsLike = currentWeather!.main.feelsLike
                currentWeatherModel.mainHumidity = currentWeather!.main.humidity
                currentWeatherModel.mainTemp = currentWeather!.main.temp
                currentWeatherModel.mainTempMin = currentWeather!.main.tempMin
                currentWeatherModel.mainTempMax = currentWeather!.main.tempMax
                currentWeatherModel.sysSunrise = currentWeather!.sys.sunrise
                currentWeatherModel.sysSunset = currentWeather!.sys.sunset
                currentWeatherModel.timezone = currentWeather!.timezone
                currentWeatherModel.weatherDescription = currentWeather!.weather[0].description
                currentWeatherModel.weatherIcon = currentWeather!.weather[0].icon
                currentWeatherModel.windSpeed = currentWeather!.wind.speed

                savedLocation.currentWeather = currentWeatherModel
            }

            self.saveContext(context: context)
        }
        self.fetchLocations(for: self.locationID)
    }

    func deleteLocation(for locationID: Int32) {
        guard let context = self.context else { return }

        self.fetchLocations(for: locationID)
        guard let locations = self.getObjects() else {
            self.fetchLocations(for: self.locationID)
            return
        }
        self.fetchLocations(for: self.locationID)
        if locations.count != 0 {
            let savedLocation = locations[0]
            context.delete(savedLocation)
            self.saveContext(context: context)
        }
    }
}
