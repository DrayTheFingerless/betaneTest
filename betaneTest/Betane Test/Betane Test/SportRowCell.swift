//
//  SportRowCell.swift
//  Betane Test
//
//  Created by Robert Ferreira on 29/11/2022.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class SportRowCell : UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, SportDelegate {
   
    
    var collectionHeightConstraint : NSLayoutConstraint?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.estimatedItemSize = .zero
        let collectionview = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionview.translatesAutoresizingMaskIntoConstraints = false
        collectionview.clipsToBounds = false
        collectionview.showsHorizontalScrollIndicator = false
        collectionview.backgroundColor = .clear
        return collectionview
    }()
    
    var headerView : UIView = {
        let header = UIView()
        header.backgroundColor = .black.withAlphaComponent(0.2)
        header.translatesAutoresizingMaskIntoConstraints = false
        return header
    }()
    
    var headerLabel : UILabel = {
        var label = UILabel()
        label.textColor = UIColor.white.withAlphaComponent(0.8)
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    var headerCollapseButton = {
        let button = UIButton(type: .custom)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .clear
        button.tintColor = .white
        button.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        return button
    }()
    
    var events : [Event] = []
    var eventIdentifier = "eventIdentifier"
    var collectionDelegate: CollectionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func commonInit(){
        setupViews()
        registerCells()
    }
    
    func setupViews(){
        self.collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        self.addSubview(self.collectionView)
        self.addSubview(self.headerView)

        headerView.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        headerView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        headerView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        headerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.headerView.addSubview(self.headerLabel)
        self.headerView.addSubview(self.headerCollapseButton)

        headerLabel.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 10).isActive = true
        headerLabel.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerLabel.rightAnchor.constraint(lessThanOrEqualTo: headerCollapseButton.leftAnchor).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true

        headerCollapseButton.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -10).isActive = true
        headerCollapseButton.centerYAnchor.constraint(equalTo: headerView.centerYAnchor).isActive = true
        headerCollapseButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        headerCollapseButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        headerCollapseButton.addTarget(self, action: #selector(collapsePress(_:)), for: .primaryActionTriggered)

        collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 5).isActive = true
        collectionView.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        collectionView.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        collectionHeightConstraint = collectionView.heightAnchor.constraint(equalToConstant: 100)
        collectionHeightConstraint?.isActive = true
        
        contentView.isUserInteractionEnabled = false
    }
    
    func registerCells() {
        self.collectionView.register(EventCell.self, forCellWithReuseIdentifier: eventIdentifier)
    }
    
    func setupData(events: [Event], title: String, collapse: Bool) {
        self.events = events
        self.headerLabel.text = title
        if collapse {
            collectionHeightConstraint?.constant = 0
            headerCollapseButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
        } else {
            collectionHeightConstraint?.constant = 105
            headerCollapseButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
        }
        
        self.collectionView.reloadData()
        self.collectionView.layoutIfNeeded()
        self.collectionView.setNeedsFocusUpdate()
    }
    
    @objc func collapsePress(_ sender: UIButton) {
        var superview = sender.superview
        while let view = superview, !(view is SportRowCell) {
           superview = view.superview
        }
        if collectionHeightConstraint?.constant == 0 {
            collectionHeightConstraint?.constant = 105
            headerCollapseButton.setImage(UIImage(systemName: "chevron.up"), for: .normal)
            if let cell = superview as? SportRowCell {
                self.collectionDelegate?.collapseSport(forCell: cell, collapse: false)
            }
        } else {
            collectionHeightConstraint?.constant = 0
            headerCollapseButton.setImage(UIImage(systemName: "chevron.down"), for: .normal)
            if let cell = superview as? SportRowCell {
                self.collectionDelegate?.collapseSport(forCell: cell, collapse: true)
            }
        }
     
      
        self.setNeedsUpdateConstraints()
        self.layoutIfNeeded()
    }
    
    func setFavourite(forCell: UICollectionViewCell) {
        if let index = self.collectionView.indexPath(for: forCell)?.row {
            self.events[index].favourite = !(self.events[index].favourite ?? false)
            self.events.sort(by: {$0.favourite ?? false && !($1.favourite ?? false)} )
            self.collectionDelegate?.setFavourite(forCell: self, indexEvent: index, favourite: self.events[index].favourite ?? true)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.collectionView.setNeedsLayout()
                self.collectionView.layoutIfNeeded()
            }
        }
        
    }
}

@available(iOS 13.0, *)
extension SportRowCell {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: eventIdentifier, for: indexPath) as! EventCell
        
//        in order to set favourite back in the data source, we need the cell to be able to callback its parent
        cell.collectionDelegate = self
        
        let event = events[indexPath.row]
//            setup data
        var name = event.d
        var countValue = event.tt
       
        let fav = event.favourite
        cell.setup(name: name, countdown: countValue, favourite: fav)
        
        
        return cell
        
    }
}

//layout
@available(iOS 13.0, *)
extension SportRowCell : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 200, height: 100)
    }
}


public protocol SportDelegate: AnyObject {
    func setFavourite(forCell: UICollectionViewCell)
}
