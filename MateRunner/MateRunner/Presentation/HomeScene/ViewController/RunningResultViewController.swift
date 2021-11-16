//
//  RunningResultViewController.swift
//  MateRunner
//
//  Created by 김민지 on 2021/11/01.
//

import CoreLocation
import MapKit
import UIKit

import RxCocoa
import RxSwift

class RunningResultViewController: UIViewController {
    var viewModel: RunningResultViewModel?
    private let disposeBag = DisposeBag()
    
    private lazy var scrollView = UIScrollView()
    
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        let xImage = UIImage(systemName: "xmark")
        button.setImage(xImage, for: .normal)
        button.tintColor = .black
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        return button
    }()
    
    private lazy var dateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "2020. 6. 10. - 오후 4:32"
        label.font = .notoSans(size: 18, family: .medium)
        label.textColor = .systemGray
        return label
    }()
    
    private lazy var korDateTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "수요일 오후"
        label.font = .notoSans(size: 24, family: .medium)
        return label
    }()
    
    private lazy var runningModeLabel: UILabel = {
        let label = UILabel()
        label.text = "혼자 달리기"
        label.font = .notoSans(size: 24, family: .medium)
        return label
    }()
    
    private lazy var upperSeparator = self.createSeparator()
    
    private lazy var distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "5.00"
        label.font = .notoSansBoldItalic(size: 64)
        label.layer.shadowOffset = CGSize(width: 0, height: 3)
        label.layer.shadowOpacity = 1.0
        label.layer.shadowRadius = 2
        label.layer.shadowColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 0.5)
        return label
    }()
    
    private lazy var calorieLabel: UILabel = {
        let label = UILabel()
        label.text = "128"
        label.font = .notoSans(size: 24, family: .black)
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "24:50"
        label.font = .notoSans(size: 24, family: .black)
        return label
    }()
    
    lazy var myResultView = MyResultView(
        distanceLabel: self.distanceLabel,
        calorieLabel: self.calorieLabel,
        timeLabel: self.timeLabel
    )
    
    lazy var mapView = MKMapView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.configureUI()
        self.configureMap()
        self.bindViewModel()
    }
    
    func createSeparator() -> UIView {
        let view = UIView()
        view.backgroundColor = .systemGray4
        view.snp.makeConstraints { make in
            make.height.equalTo(1)
        }
        return view
    }
    
    func configureDifferentSection() {
        self.configureMapView()
    }
    
    func configureMapView() {
        self.contentView.addSubview(self.mapView)

        self.mapView.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            
            make.top.equalTo(self.myResultView.snp.bottom).offset(15)
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.height.equalTo(400)
            make.bottom.equalToSuperview().offset(-15)
        }
    }
}

// MARK: - Private Functions

private extension RunningResultViewController {
    func configureMap() {
        self.mapView.delegate = self
        self.mapView.mapType = .standard
        self.mapView.showsUserLocation = true
    }
    
    func configureUI() {
        self.view.backgroundColor = .systemBackground
        self.navigationController?.isNavigationBarHidden = true
        
        self.configureCommonSection()
        self.configureDifferentSection()
    }
    
    func configureCommonSection() {
        self.configureScrollView()
        self.configureCloseButton()
        self.configureDateTimeLabel()
        self.configureKorDateTimeLabel()
        self.configureRunningTypeLabel()
        self.configureUpperSeparator()
        self.configureMyResultView()
    }
    
    func configureScrollView() {
        self.view.addSubview(self.scrollView)
        
        self.scrollView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        
        self.scrollView.addSubview(self.contentView)
        
        self.contentView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.centerX.top.bottom.equalToSuperview()
        }
    }
    
    func configureCloseButton() {
        self.contentView.addSubview(self.closeButton)
        self.closeButton.snp.makeConstraints { make in
            make.top.right.equalToSuperview().inset(15)
            make.width.height.equalTo(25)
        }
    }
    
    func configureDateTimeLabel() {
        self.contentView.addSubview(self.dateTimeLabel)
        self.dateTimeLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().inset(15)
        }
    }
    
    func configureKorDateTimeLabel() {
        self.contentView.addSubview(self.korDateTimeLabel)
        
        self.korDateTimeLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            
            make.top.equalTo(self.dateTimeLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    func configureRunningTypeLabel() {
        self.contentView.addSubview(self.runningModeLabel)
        
        self.runningModeLabel.snp.makeConstraints { [weak self] make in
            guard let self = self else { return }
            
            make.top.equalTo(self.korDateTimeLabel.snp.bottom)
            make.left.equalToSuperview().offset(15)
        }
    }
    
    func configureUpperSeparator() {
        self.contentView.addSubview(self.upperSeparator)
        self.upperSeparator.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(self.runningModeLabel.snp.bottom).offset(15)
        }
    }
    
    func configureMyResultView() {
        self.contentView.addSubview(self.myResultView)
        self.myResultView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(self.upperSeparator.snp.bottom)
        }
    }
    
    func configureMapViewLocation(from region: Region) {
        let coordinateLocation = region.center
        let spanValue = MKCoordinateSpan(latitudeDelta: region.span.0, longitudeDelta: region.span.1)
        let locationRegion = MKCoordinateRegion(center: coordinateLocation, span: spanValue)
        self.mapView.setRegion(locationRegion, animated: true)
    }
    
    func popToRootViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func showAlert() {
        let message = "달리기 결과 저장 중 오류가 발생했습니다."
        
        let alert = UIAlertController(title: "오류 발생", message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "취소", style: .default, handler: { _ in
            self.popToRootViewController()
        })
        alert.addAction(cancel)
        present(alert, animated: false, completion: nil)
    }
    
    func bindViewModel() {
        guard let viewModel = self.viewModel else { return }
        let input = RunningResultViewModel.Input(
            viewDidLoadEvent: Observable.just(()),
            closeButtonDidTapEvent: self.closeButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input, disposeBag: self.disposeBag)
        
        output.dateTime
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.dateTimeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.korDateTime
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.korDateTimeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.mode
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.runningModeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.distance
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.distanceLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.calorie
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.calorieLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.time
            .asDriver(onErrorJustReturn: "Error")
            .drive(self.timeLabel.rx.text)
            .disposed(by: self.disposeBag)
        
        output.$points
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] points in
                let lineDraw = MKPolyline(coordinates: points, count: points.count)
                self?.mapView.addOverlay(lineDraw)
            })
            .disposed(by: self.disposeBag)
        
        output.$region
            .asDriver(onErrorJustReturn: Region())
            .drive(onNext: { [weak self] region in
                self?.configureMapViewLocation(from: region)
            })
            .disposed(by: self.disposeBag)
        
        output.isClosable
            .asDriver(onErrorJustReturn: false)
            .drive(onNext: { [weak self] isClosable in
                if isClosable == true {
                    self?.popToRootViewController()
                } else if isClosable == false {
                    self?.showAlert()
                }
            })
            .disposed(by: self.disposeBag)
    }
}

extension RunningResultViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        guard let polyLine = overlay as? MKPolyline else { return MKOverlayRenderer() }

        let renderer = MKPolylineRenderer(polyline: polyLine)
        renderer.strokeColor = .mrPurple
        renderer.lineWidth = 5.0
        renderer.alpha = 1.0

        return renderer
    }
}
