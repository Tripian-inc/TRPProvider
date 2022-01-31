//
//  TRPBookingCoordinater.swift
//  TRPCoreKit
//
//  Created by Evren Yaşar on 2020-12-31.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import Foundation
import TRPUIKit

final public class TRPExperiencesCoordinater {
    
    enum ViewState {
        case experince, experienceDetail(tourId: Int, isFromTripDetail: Bool? = false), review(tourId: Int), availability(tourId: Int), billing, payment
        case requiredParameters(bookingParameters: [GYGBookingParameter],
                                language: GYGCondLanguage?,
                                pickUp: String?)
    }
    
    private let navigationController: UINavigationController
    private let cityName: String
    private var tourId: Int?
    
    private(set) var currentViewState: ViewState = .experince {
        didSet {
            self.applyViewState(self.currentViewState)
        }
    }
    
    //public var tripModeUseCases: TRPTripModeUseCases?
    //public var reservationUseCases: TRPReservationUseCases?
    
    private lazy var tourOptionsUseCases: TRPTourOptionsUseCases = {
        return TRPTourOptionsUseCases()
    }()
    
    private lazy var bookingUseCases: TRPMakeBookingUseCases = {
        let useCases = TRPMakeBookingUseCases()
        useCases.optionDataHolder = tourOptionsUseCases
        return useCases
    }()
    
    public init(navigationController: UINavigationController, cityName: String, tourId: Int?) {
        self.navigationController = navigationController
        self.cityName = cityName
        self.tourId = tourId
    }
    
    public func start() {
        if let tourId = tourId {
            currentViewState = .experienceDetail(tourId: tourId, isFromTripDetail: true)
        }else {
            currentViewState = .experince
        }
    }
    
    private func applyViewState(_ state: ViewState) {
        var viewController: UIViewController?
        switch state {
        case .experince:
            viewController = makeExperience()
        case .experienceDetail(let tourId, let isFromTripDetail):
            viewController = makeExperienceDetail(tourId: tourId, isFromTripDetail: isFromTripDetail ?? false)
        case .review(let tourId):
            viewController = makeReviewsView(tourId: tourId)
        case .availability(let tourId):
            viewController = makeAvailability(tourId: tourId)
        case .requiredParameters(let bookingParams, let language, let pickup):
            viewController = makeRequirementField(bookingParameters: bookingParams, language: language, pickUp: pickup)
        case .billing:
            viewController = makeBilling()
        case .payment:
            viewController = makePaymentViewController()
        }
        
        if let vc = viewController {
            navigationController.pushViewController(vc, animated: true)
        }
    }
    
}

//MARK: - Experiences VC
extension TRPExperiencesCoordinater: ExperiencesViewControllerDelegate {
    
    private func makeExperience() -> UIViewController? {
        let viewModel = ExperiencesViewModel(cityName: cityName)
        //TODO: - TRPPROVİDER İÇİN KAPATILDI
        //viewModel.tripModeUseCase = tripModeUseCases
        let viewController = ExperiencesViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewController.delegate = self
        return viewController
    }
    
    public func experiencesVCOpenTour(_ navigationController: UINavigationController?, viewController: UIViewController, tourId: Int) {
        currentViewState = .experienceDetail(tourId: tourId)
    }
}

extension TRPExperiencesCoordinater: ExperienceDetailViewControllerDelegate {
    
    private func makeExperienceDetail(tourId: Int, isFromTripDetail: Bool) -> UIViewController {
        let viewModel = ExperienceDetailViewModel(tourId: tourId, isFromTripDetail: isFromTripDetail)
        let viewController = ExperienceDetailViewController(viewModel: viewModel)
        viewController.useCases = bookingUseCases
        viewModel.delegate = viewController
        viewController.delegate = self
        return viewController
    }
    
    public func experienceDetailVCOpenReviews(_ navigationController: UINavigationController?, viewController: UIViewController, tourId: Int) {
        currentViewState = .review(tourId: tourId)
    }
    
    public func experienceDetailVCOpenAvailability(_ navigationController: UINavigationController?, viewController: UIViewController, tourId: Int) {
        currentViewState = .availability(tourId: tourId)
    }
    
    public func experienceDetailVCOpenMoreInfo(_ navigationController: UINavigationController?, viewController: UIViewController, tour: GYGTour) {
        let viewModel = ExperienceMoreInfoViewModel(tour: tour)
        let viewController = ExperienceMoreInfoViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewModel.start()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    private func makeReviewsView(tourId id: Int) -> UIViewController {
        let viewModel = ReviewsViewModel(tourId: id)
        let viewController = ReviewsViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        return viewController
    }
}

//MARK: - AVAILIBILITY
extension TRPExperiencesCoordinater: ExperienceAvailabilityViewControllerDelegate {
    
    private func makeAvailability(tourId id: Int) -> UIViewController {
        let currentDate = Date().toString(format: "d MMM yyyy", dateStyle:nil, timeStyle: nil)
        let viewModel = ExperienceAvailabilityViewModel(tourId: id, date: currentDate)
        viewModel.fetchTourOption = tourOptionsUseCases
        viewModel.bookingOptionUseCase = bookingUseCases
        let viewController = ExperienceAvailabilityViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewController.delegate = self
        return viewController
    }
    
    
    func experienceAvailabilityOpenBilling(_ navigationController: UINavigationController?, viewController: UIViewController) {
        currentViewState = .billing
    }
    
    func experienceAvailabilityOpenBooking(_ navigationController: UINavigationController?, viewController: UIViewController, bookingParameters: [GYGBookingParameter], language: GYGCondLanguage?, pickUp: String?) {
        currentViewState = .requiredParameters(bookingParameters: bookingParameters, language: language, pickUp: pickUp)
    }
    
    
}

//MARK: - BILLING
extension TRPExperiencesCoordinater: ExperienceBillingDelegate{
    
    
    func makeBilling() -> UIViewController {
        let viewModel = ExperienceBillingViewModel()
        viewModel.billingUseCases = bookingUseCases
        viewModel.paymentUseCases = bookingUseCases
        viewModel.checkBookingInCardUseCase = bookingUseCases
        
        let viewController = ExperienceBillingViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewModel.start()
        viewController.delegate = self
        return viewController
    }
    
    public func experienceBillingOpenPaymentVC(_ navigationController: UINavigationController?, viewController: UIViewController) {
        currentViewState = .payment
    }
}

//MARK: - REQUIREMENTFIELD
extension TRPExperiencesCoordinater: ExperienceRequirementFieldVCDelegate {
    
    
    
    func makeRequirementField(bookingParameters: [GYGBookingParameter],
                              language: GYGCondLanguage?,
                              pickUp: String?) -> UIViewController {
        let viewModel = ExperienceRequirementFieldViewModel(bookingParameters: bookingParameters, language: language,pickUp: pickUp)
        viewModel.postBookingUseCase = bookingUseCases
        viewModel.bookingParametersUseCase = bookingUseCases
        
        let viewController = ExperienceRequirementFieldViewController(viewModel: viewModel)
        viewModel.delegate = viewController
        viewController.delegate = self
        viewModel.start()
        return viewController
    }
    
    func experienceRequirementFieldOpenBillingVC(_ navigationController: UINavigationController?, viewController: UIViewController) {
        currentViewState = .billing
    }
}

//MARK: - PAYMENT
extension TRPExperiencesCoordinater: PaymentViewControllerProtocol {
    
    private func makePaymentViewController() -> UIViewController {
        //TODO: - TRPPROVİDER İÇİN KAPATILDI
        let viewModel = PaymentViewModel()
        viewModel.paymentUseCases = bookingUseCases
        viewModel.toursUseCase = tourOptionsUseCases
        //viewModel.tripModeUseCases = tripModeUseCases
        viewModel.bookingUseCases = bookingUseCases
        //viewModel.reservationUseCases = reservationUseCases
        
        let viewController = PaymentViewController(viewModel: viewModel)
        viewController.delegate = self
        viewModel.delegate = viewController
        
        return viewController
    }
    
    func setupNavigationBar(_ navigationBar: UINavigationBar, barTintColor: UIColor = UIColor.white) {
        navigationBar.barTintColor = barTintColor
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for:.default)
        navigationBar.shadowImage = UIImage()
        navigationBar.layoutIfNeeded()
    }
    
    public func paymentViewControllerPaymentResult(_ vc: PaymentViewController, _ response: GYGPaymentResult?) {
        NotificationCenter.default.post(name: .GYGBookPaymentResult, object: ["BookPayment": response])
    }
    
}
