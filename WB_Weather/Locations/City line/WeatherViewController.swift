//
//  WeatherViewController.swift
//  WB_Weather
//
//  Created by Лёха Небесный on 17.04.2023.
//

import UIKit
import CoreData
import CoreLocation.CLLocationManager

final class WeatherViewController: UIPageViewController {
    private let userDefaults = UserDefaults.standard

    private var pageControl = UIPageControl()

    private let cLLocationManager = CLLocationManager()
    private var coreDataLocationService: CoreDataLocationService?
    let networkService: NetworkServicePorotocol

    init(networkService: NetworkServicePorotocol) {
        self.networkService = networkService
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.coreDataLocationService = CoreDataLocationServiceImp(delegate: self)

        NotificationCenter.default.addObserver(self, selector: #selector(userDefaultsDidChange), name: UserDefaults.didChangeNotification, object: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = self
        self.cLLocationManager.delegate = self
        self.setupView()
        self.requestAccessToLocation()
        self.setupFirstController()
        self.updateLocations()
        self.getWaetherForAllLocations()
    }

    /// Устанавливает фон, кнопки в навигейшнвью и pageController
    private func setupView() {
        self.view.backgroundColor = Palette.selectedCellBackgroundColor
        self.navigationItem.title = "WeatherViewController.navigationItem.title".localized
        self.navigationItem.titleView?.tintColor = Palette.textColor
        self.navigationController?.navigationBar.tintColor = Palette.textColor //???

        let leftBarButton = UIBarButtonItem(
            image: UIImage(systemName: "text.alignright"),
            style: .done,
            target: self,
            action: #selector(didTapLeftButton)
        )
        self.navigationItem.leftBarButtonItem = leftBarButton
        let rightBarButton1 = UIBarButtonItem(
            image: UIImage(systemName: "location.magnifyingglass"),
            style: .done,
            target: self,
            action: #selector(didTapRightButton1)
        )
        let rightBarButton2 = UIBarButtonItem(
            image: UIImage(systemName: "list.bullet.circle"),
            style: .done,
            target: self,
            action: #selector(didTapRightButton2)
        )
        self.navigationItem.rightBarButtonItems = [rightBarButton1, rightBarButton2]

        let navigationBarSize = navigationController?.navigationBar.bounds.size ?? CGSize(width: 0, height: 0)
        let navigationBarOriginY = self.navigationController?.navigationBar.frame.origin.y ?? 0

        let pageControlOriginY = navigationBarOriginY + navigationBarSize.height/2
        let pageControlWidth = 150

        self.navigationController?.navigationItem.titleView?.frame.origin.y = navigationBarOriginY
        self.pageControl = UIPageControl(frame: CGRectMake(
            (navigationBarSize.width - CGFloat(pageControlWidth))/2,
            pageControlOriginY + 6,
            CGFloat(pageControlWidth),
            20
        ))

        self.pageControl.currentPageIndicatorTintColor = Palette.textColor
        self.pageControl.pageIndicatorTintColor = Palette.cellBackgroundColor
        self.pageControl.numberOfPages = self.coreDataLocationService?.getNubersObject(section: 0) ?? 1
        self.pageControl.currentPage = 0
        self.navigationController?.navigationBar.addSubview(pageControl)
    }

    /// Проверяем доступ к локации телефона
    private func requestAccessToLocation() {

        let locationStatus = self.cLLocationManager.authorizationStatus

        switch locationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            self.cLLocationManager.requestLocation()
        case .notDetermined:
            self.deleteSelfLocation()
            let vc = AutorizationViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: true)
            break
        case .denied, .restricted:
            self.deleteSelfLocation()
            break
        @unknown default:
            break
        }
    }

    /// Устанавливаем первый контроллер
    private func setupFirstController() {
        guard let vc = self.pageViewController(for: 0) else {
            setViewControllers(
                [EmptyViewController()],
                direction: .forward,
                animated: false
            )
            return
        }
        setViewControllers(
            [vc],
            direction: .forward,
            animated: false
        )
    }

    /// Определяем какой pageViewController вернуть и вернуть ли
    /// - Parameter index: индекс страницы
    /// - Returns: LocationWeatherViewController or nil
    private func pageViewController(for index: Int) -> LocationWeatherViewController? {
        if index < 0 {return nil}
        let count = self.coreDataLocationService?.getObjects()?.count ?? 0
        guard  count > 0 && index < count  else {return nil}

        guard let locationModel = self.coreDataLocationService?.getObject(index: [0,index]) else {return nil}

        if index == 0 && locationModel.locationID == 0 {

            self.pageControl.setIndicatorImage(UIImage(systemName: "location.fill"), forPage: 0)
        }

        let location = Locations(
            id: locationModel.locationID,
            locationName: locationModel.locationName  ?? "Unknow Location",
            locationLatitude: locationModel.locationLatitude ?? "00",
            locationLongitude: locationModel.locationLongitude ?? "00"
        )

        let vc = LocationWeatherViewController(
            for: location,
            delegate: self
        )
        vc.index = index
        return vc
    }

    /// Получение ответа от яндекса  координаты и название места + обновление локации в кордате
    /// - Parameters:
    ///   - requestype: тип запроса:
    ///      - Case:  getGeocodeLocation - получить название локации по координатам
    ///      - Case:  getCoordinate -  получить координаты и название по названию локации
    ///   - location: указывается локация для которой нужно определить название и координаты
    private func getGeoCode(requestype: Requestype, location: Locations) {
        let endPoint = self.networkService.urlComponentsForCoordinate(for: requestype, location: location)

        self.networkService.fetchLocation(usingEndPoint: endPoint) { result in
            switch result {
            case .success(let answer):
                guard answer.response.geoObjectCollection.featureMember.count != 0 else {

                    DispatchQueue.main.async {
                        self.coreDataLocationService?.deleteLocation(for: location.id)
                        let messageTemplate = "WeatherViewController.getGeoCode.alert.message".localized
                        let message = String(format: messageTemplate, location.locationName)

                        let alert = Alerts().showAlert(
                            with: "WeatherViewController.getGeoCode.alert.title".localized,
                            message: message,
                            preferredStyle: .alert
                        )

                        self.present(alert, animated: true)
                    }
                    return
                }
                let coordinate = answer.response.geoObjectCollection.featureMember[0].geoObject.point.pos

                // преобразовываем String координат в ответе в две отдельных координаты
                let indexForLat = coordinate.firstIndex(of: " ") ?? coordinate.endIndex
                let lat = coordinate[..<indexForLat]
                let longitude = String(lat)

                let range = coordinate.startIndex..<coordinate.index(after: indexForLat)
                var lattitude = coordinate
                lattitude.removeSubrange(range)

                let region = {
                    guard let description = answer.response.geoObjectCollection.featureMember[0].geoObject.description else { return "" }
                    return description + ", "

                }()
                let name = answer.response.geoObjectCollection.featureMember[0].geoObject.name
                let locationName = region + name

                let location = Locations(
                    id: location.id,
                    locationName: locationName,
                    locationLatitude: lattitude,
                    locationLongitude: longitude
                )
                self.coreDataLocationService?.updateLocation(for: location)
                self.getWeatherForecast(for: location)

            case .failure(let error):
                print("🛑", error.debugDescription)
            }
        }
    }

    /// Получаем и сохраняем прогноз погоды на 5 дней по 3 часа и текущую  для локации
    /// - Parameter location: локация для которой нужно получить и сохранить погоду
    private func getWeatherForecast(for location: Locations) {

        let endPointForCurrent = self.networkService.urlComponentsForCoordinate(for: .cuurentForecast, location: location)

        self.networkService.fetchCurrentWeather(usingEndPoint: endPointForCurrent) { result in
            switch result {
            case .success(let answer):
                self.coreDataLocationService?.updateWeather(for: location.id, listWether: nil, currentWeather: answer)

            case .failure(let error):
                print("❌ ,\(endPointForCurrent) - ", error.debugDescription)

            }
        }

        let endPointForForecast = self.networkService.urlComponentsForCoordinate(for: .daysForecast, location: location)

        self.networkService.fetchWeather(usingEndPoint: endPointForForecast) { result in
            switch result {
            case .success(let answer):
                self.coreDataLocationService?.updateWeather(for: location.id, listWether: answer.list, currentWeather: nil)

            case .failure(let error):
                print("❌ , \(endPointForForecast) - ", error.debugDescription)

            }
        }
    }

    /// получение прогнозов погоды для всех локаций из кор даты
    private func getWaetherForAllLocations(){
        guard let locations = self.coreDataLocationService?.getObjects() else {return}

        for locationModel in locations {
            let location = Locations(
                id: locationModel.locationID,
                locationName: locationModel.locationName ?? "Unknow Location",
                locationLatitude: locationModel.locationLatitude ?? "0",
                locationLongitude: locationModel.locationLongitude ?? "0"
            )

            if locationModel.locationLatitude == "lat" {
                self.getGeoCode(requestype: .getCoordinate, location: location)
            } else {
                self.getWeatherForecast(for: location)
            }
        }
    }

    private func deleteSelfLocation(){
        self.coreDataLocationService?.deleteLocation(for: 0)
    }

    private func setPage(for vc: UIViewController, index: Int) {
        let direction:  UIPageViewController.NavigationDirection = {
            if index == 0 {
                return .forward
            } else {
                return .reverse
            }
        }()
        setViewControllers(
            [vc],
            direction: direction,
            animated: false
        )
    }

    /// Обновляем локации, если поменялось их название или изменилась локализация языка на устройстве
    private func updateLocations() {
        guard let locationsInCoreData = self.coreDataLocationService?.getObjects(), locationsInCoreData.isEmpty == false else {return}

        locationsInCoreData.forEach({
            let locatoin = Locations(
                id: $0.locationID,
                locationName: $0.locationName ?? "Unknow",
                locationLatitude: $0.locationLatitude ?? "lat",
                locationLongitude: $0.locationLongitude ?? "long"
            )
            self.getGeoCode(requestype: .getGeocodeLocation, location: locatoin)
        })

    }

    @objc func userDefaultsDidChange(_ notification: Notification) {
        let index = self.pageControl.currentPage
        guard let vc = self.pageViewController(for: index) else { return }
        self.setPage(for: vc, index: index)
    }

    /// Показываем экран настройки
    @objc private func didTapLeftButton () {
        let vc = SettingsViewController()
        vc.delegate = self
        let uvc = UINavigationController(rootViewController: vc)
        uvc.modalPresentationStyle = .fullScreen
        present(uvc, animated: true)
        self.pageControl.isHidden = true
    }

    /// Добавление новой локации
    @objc private func didTapRightButton1()  {
        self.navigationItem.rightBarButtonItems?[0].isEnabled = false

        let alertController = UIAlertController(
            title: "WeatherViewController.didTapRightButton1.alert.title".localized,
            message: "WeatherViewController.didTapRightButton1.alert.message".localized,
            preferredStyle: .alert
        )

        let createAction = UIAlertAction(title: "add.button".localized, style: .default) { _ in

            guard let locationName = alertController.textFields?.first?.text else {
                self.navigationItem.rightBarButtonItems?[0].isEnabled = true
                return
            }

            if locationName.count >= 4 {
                var assumedId: Int32 = 1
                if let locationsModel = self.coreDataLocationService?.getObjects() {

                    for locationModel in locationsModel {
                        if locationModel.locationID != 0 && locationModel.locationID == assumedId {
                            assumedId += 1
                        } else if locationModel.locationID != 0 && locationModel.locationID != assumedId {
                            break
                        }
                    }
                }
                let location = Locations(
                    id: assumedId,
                    locationName: locationName,
                    locationLatitude: "lat",
                    locationLongitude: "long"
                )

                self.coreDataLocationService?.updateLocation(for: location)
                self.getGeoCode(requestype: .getCoordinate, location: location)
            }
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
        }

        let cancelAction = UIAlertAction(title: "cancel.button".localized, style: .destructive) { _ in
            self.navigationItem.rightBarButtonItems?[0].isEnabled = true
        }

        alertController.addTextField() {
            $0.placeholder = "WeatherViewController.didTapRightButton1.alert.textField.placeholder".localized
            $0.keyboardType = .asciiCapable
            $0.returnKeyType = .done
            $0.autocapitalizationType = .sentences
        }
        alertController.addAction(cancelAction)
        alertController.addAction(createAction)

        self.present(alertController, animated: true)
    }


    /// Показать список доступных локаций, чтобы можно было удалить ненужную
    @objc private func didTapRightButton2() {
        let vc = ListOfLocationsViewController()
        self.modalPresentationStyle = .custom
        present(vc, animated: true)
    }
}

extension WeatherViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let locationWeatherViewController = viewController as? LocationWeatherViewController else { return nil }
        let index = locationWeatherViewController.index - 1
        return self.pageViewController(for: index)
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let locationWeatherViewController = viewController as? LocationWeatherViewController else { return nil }
        let index = locationWeatherViewController.index + 1
        return self.pageViewController(for: index)
    }
}

extension WeatherViewController: LocationWeatherViewControllerDelegete {
    func setTitle(for index: Int, equal locationName: String) {
        self.navigationItem.title = locationName
        self.pageControl.currentPage = index
    }

    func changeIsHidePageController(to value: Bool) {
        self.pageControl.isHidden = value
    }
}

extension WeatherViewController: CLLocationManagerDelegate {

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("🚨", error)
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last! as CLLocation
        let currentLocation = Locations(
            id: 0,
            locationName: "Unknow",
            locationLatitude: String(userLocation.coordinate.latitude),
            locationLongitude: String(userLocation.coordinate.longitude)
        )
        self.getGeoCode(requestype: .getGeocodeLocation, location: currentLocation)
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.requestAccessToLocation()
    }
}

extension WeatherViewController: AutorizationViewControllerDelegate {
    func openAuthorizationView() {
        self.cLLocationManager.requestWhenInUseAuthorization()
    }

    func refusalToUseLocation() {
        self.deleteSelfLocation()
    }
}


extension WeatherViewController: NSFetchedResultsControllerDelegate {
    func controller(
        _ controller: NSFetchedResultsController<NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {

        switch type {
        case .insert:
            guard anObject is LocationsCoreDataModel else {return}
            guard let index = newIndexPath?.row else {return}
            self.pageControl.numberOfPages = self.coreDataLocationService?.getNubersObject(section: 0) ?? 1
            self.pageControl.currentPage = index
            guard let vc = self.pageViewController(for: index) else { return }
            self.setPage(for: vc, index: index)


        case .delete:
            guard let index = indexPath?.row else {return}
            if self.pageControl.currentPage == index {
                let vc: UIViewController = {
                    if let vc = self.pageViewController(for: index) {
                        self.pageControl.currentPage = index
                        return vc
                    } else if let vc = self.pageViewController(for: index-1){
                        self.pageControl.currentPage = index-1
                        return vc
                    } else {
                        self.pageControl.currentPage = 0
                        self.navigationItem.title = "WeatherViewController.navigationItem.emptiTitle".localized
                        return EmptyViewController()
                    }
                }()
                self.setPage(for: vc, index: index)
            }
            self.pageControl.numberOfPages = self.coreDataLocationService?.getNubersObject(section: 0) ?? 1

        case .move, .update:
            return

        @unknown default:
            fatalError()
        }
    }
}
