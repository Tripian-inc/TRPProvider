//
//  ExperiencesViewModel.swift
//  TRPCoreKit
//
//  Created by Evren Yaşar on 15.09.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
import TRPProvider


struct ExperiencesCellModel {
    var title: String
    var datas: [GYGTour] //Generic yapılabiir
}

protocol ExperiencesViewModelDelegate: ViewModelDelegate {
    func experiencesViewModelShowEmptyWarning()
}


final class ExperiencesViewModel: TableViewViewModelProtocol {
    
    
    typealias T = ExperiencesCellModel
    
    weak var delegate: ExperiencesViewModelDelegate?
    
    var cellViewModels: [ExperiencesCellModel] = [] {
        didSet {
            delegate?.viewModel(dataLoaded: true)
        }
    }
    var cityName: String
    private var gygApi: GetYourGuideApi
    
    var numberOfCells: Int {
        return cellViewModels.count
    }
    
    private var requestCount = 0
    
    //-----USE CASES
    //public var tripModeUseCase: ObserveTripModeUseCase?
    
    
    //Settings
    public var uniqueToursWithCategory = true
    public var showLimitByCategory = 20
    private let addStarDayToEnd = 7
    
    
    public init(cityName: String, gygApi: GetYourGuideApi) {
        self.cityName = cityName
        self.gygApi = gygApi
    }
    
    public func start() {
        let tourDates = calculateDates()
        //fetchTours(startDate: tourDates.startDate, endDate: tourDates.endDate)
        fetchTours()
    }
    
    func getCellViewModel(at indexPath: IndexPath) -> ExperiencesCellModel {
        return cellViewModels[indexPath.row]
    }
    
}

extension ExperiencesViewModel {
    
    private func calculateDates() -> (startDate: String?, endDate: String?) {
        //TODO: - FRAMEWORK AYRILIRKEN KOD KAPATILDI
        /*
        if let startTime = tripModeUseCase?.trip.value?.getArrivalDate()?.toDate {
            guard let start = startTime.setHour(0, minutes: 0), let added7day = start.addDay(addStarDayToEnd), let end = added7day.setHour(23, minutes: 59) else {
                print("[Error] Date can not conveted")
                return (nil,nil)
            }
            let startDate = start.toString(format: "yyyy-MM-dd'T'HH:mm:ss", dateStyle: nil, timeStyle: nil)
            let endDate = end.toString(format: "yyyy-MM-dd'T'HH:mm:ss", dateStyle: nil, timeStyle: nil)
            print("Start Date \(startDate)")
            print("End Date \(endDate)")
            return (startDate: startDate, endDate: endDate)
        }*/
        return (nil,nil)
    }
    
    
    private func fetchTours(startDate: String? = nil, endDate: String? = nil) {
        delegate?.viewModel(showPreloader: true)
        gygApi.tours(cityName: cityName, fromDate: startDate, toDate: endDate, limit: 90) { [weak self] result in
            self?.delegate?.viewModel(showPreloader: false)
            switch result {
            case .success(let tours):
                self?.seperateWithCategory(tours: tours)
            case .failure(let error):
                self?.delegate?.viewModel(error: error)
            }
        }
    }
    
    private func seperateWithCategory(tours: [GYGTour]) {
        let sorted = sortTours(tours)
        var mainTour = filterTours(sorted)
        for category in GYGCatalogCategory.allCases {
            let categoriestTour = mainTour.filter { (tour) -> Bool in
                return tour.categories.contains(where: {$0.categoryID == category.id()})
            }
            
            let limitedTours = limitTours(categoriestTour)
            if uniqueToursWithCategory {
                createCellModel(tours: limitedTours, category: category)
                limitedTours.forEach { tour in
                    mainTour.removeAll(where: {$0.tourID == tour.tourID})
                }
            }else {
                createCellModel(tours: limitedTours, category: category)
            }
        }
        delegate?.experiencesViewModelShowEmptyWarning()
    }
    
    private func createCellModel(tours: [GYGTour], category: GYGCatalogCategory) {
        guard tours.count > 0 else {return}
        let cellModel = ExperiencesCellModel(title: category.rawValue, datas: tours)
        cellViewModels.append(cellModel)
    }
    
    private func sortTours(_ data: [GYGTour]) -> [GYGTour]{
        let sortedTours = data.sorted { (lhs, rhs) -> Bool in
            return lhs.numberOfRatings > rhs.numberOfRatings
        }
        return sortedTours
    }
    
    private func limitTours(_ data: [GYGTour]) -> [GYGTour] {
        guard data.count > showLimitByCategory else {
            return data
        }
        return Array(data[0..<showLimitByCategory])
    }
    
    private func filterTours(_ data: [GYGTour]) -> [GYGTour] {
        data.filter { tour -> Bool in
            guard let durations = tour.durations else {return true}
            var show = true
            durations.forEach { duration in
                if let unit = duration.unit, let time = duration.duration, unit == "day", time > 1 {
                    show = false
                }
            }
            return show
        }
    }
    
}
