//
//  EventCell.swift
//  Betane Test
//
//  Created by Robert Ferreira on 29/11/2022.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class EventCell : UICollectionViewCell {
    
    var collectionDelegate: SportDelegate?
    var countdownTimer: Timer?
    var startTime : Int?
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.numberOfLines = 2
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.preferredFont(forTextStyle: .callout)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.4
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let countdownLabel: UILabel = {
        let label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.minimumScaleFactor = 0.5
        
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let favouriteButton: UIButton = {
        let button = UIButton(type: .custom)
        button.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .orange
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        commonInit()
    }
    
    func commonInit(){
        setupViews()
        setTimer()
    }
    
    deinit {
        invalidateCountdownTimer()
    }
    
    func setupViews(){
        self.layer.cornerRadius = 5

        self.addSubview(nameLabel)
        self.addSubview(countdownLabel)
        self.addSubview(favouriteButton)
        
        nameLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 10).isActive = true
        nameLabel.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        countdownLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -5).isActive = true
        countdownLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        countdownLabel.widthAnchor.constraint(equalToConstant: 150).isActive = true
        countdownLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        favouriteButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        favouriteButton.bottomAnchor.constraint(equalTo: countdownLabel.topAnchor ,constant: -5).isActive = true
        favouriteButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        favouriteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favouriteButton.addTarget(self, action: #selector(favouritePress(_:)), for: .primaryActionTriggered)
        
        self.backgroundColor = .white.withAlphaComponent(0.2)
    }
    
    func setup(name: String?, countdown: Int?, favourite: Bool?) {
        nameLabel.text = name
        startTime = countdown
        
        if let time = self.startTime {
            var countdown = time - Int(Date().timeIntervalSince1970)
            if countdown > 0 {
                var days = countdown / (60 * 60 * 24);
                countdown -= days * (60 * 60 * 24);
                var hours = countdown / (60 * 60);
                countdown -= hours * (60 * 60);
                var minutes = countdown / 60;
                let seconds = countdown % 60

                let clockCountdown = String(format: "%02dd %02dh %02dm",days, hours, minutes)
                self.countdownLabel.text = clockCountdown
            } else { self.countdownLabel.text = "Started" }
        } else {self.countdownLabel.text = "Started"}
        
        if favourite == nil || favourite == false {
            favouriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        } else {
            favouriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        }
    }
    
    @objc func favouritePress(_ sender: UIButton) {
        var superview = sender.superview
           while let view = superview, !(view is EventCell) {
               superview = view.superview
           }
        if let cell = superview as? EventCell {
            self.collectionDelegate?.setFavourite(forCell: cell)
        }
    }
 
    
    func setTimer() {
        countdownTimer = Timer(timeInterval: 0.1, repeats: true) { [weak self] _ in
            if let time = self?.startTime {
                var countdown = time - Int(Date().timeIntervalSince1970)
                if countdown > 0 {

                    var days = countdown / (60 * 60 * 24);
                    countdown -= days * (60 * 60 * 24);
                    var hours = countdown / (60 * 60);
                    countdown -= hours * (60 * 60);
                    var minutes = countdown / 60;
                    let seconds = countdown % 60

                    let clockCountdown = String(format: "%02dd %02dh %02dm",days, hours, minutes)
                    self?.countdownLabel.text = clockCountdown
                } else { self?.countdownLabel.text = "Started" }
            } else {self?.countdownLabel.text = "Started"}
        }
        if let timer = countdownTimer{
            RunLoop.current.add(timer, forMode: .common)
        }
    }
    
    private func invalidateCountdownTimer() {
        self.countdownTimer?.invalidate()
        self.countdownTimer = nil
    }
    
  
    
}
