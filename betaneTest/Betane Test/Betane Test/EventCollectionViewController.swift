//
//  EventCollectionViewController.swift
//  Betane Test
//
//  Created by Robert Ferreira on 29/11/2022.
//

import Foundation
import UIKit

@available(iOS 13.0, *)
class EventCollectionViewController : UICollectionViewController, CollectionDelegate {
 
    var sportsIdentifier = "sportsIdentifier"

    var sports: [Sport] = []
    
    override func viewDidLoad() {
        self.navigationItem.title = "Sports Calendar"
        registerCells()
        getData()
    }
    
    func registerCells() {
        self.collectionView.register(SportRowCell.self, forCellWithReuseIdentifier: sportsIdentifier)
    }
    
    func getData() {
        Services.getSports() { result in
            switch result {
            case let .success(data):
                self.sports = data
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            default: break
            }
        }
    }
    
    func collapseSport(forCell: UICollectionViewCell, collapse: Bool) {
        if let index = self.collectionView.indexPath(for: forCell)?.row {
            sports[index].collapsed = collapse
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func setFavourite(forCell: UICollectionViewCell, indexEvent: Int, favourite: Bool) {
        if let index = self.collectionView.indexPath(for: forCell)?.row {
            self.sports[index].e[indexEvent].favourite = favourite
            
            self.sports[index].e.sort(by: {$0.favourite ?? false && !($1.favourite ?? false)} )
        }
    }
    
}
//data source
@available(iOS 13.0, *)
extension EventCollectionViewController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "sectionheader", for: indexPath)
            // do any programmatic customization, if any, here
            return view
        }
        fatalError("Unexpected kind")
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        sports.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: sportsIdentifier, for: indexPath) as! SportRowCell
        cell.collectionDelegate = self
        cell.setupData(events: sports[indexPath.row].e, title: sports[indexPath.row].d ?? "", collapse: sports[indexPath.row].collapsed ?? false)
        return cell
    }
    
}

//layout
@available(iOS 13.0, *)
extension EventCollectionViewController : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if sports[indexPath.row].collapsed ?? false {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 40)
        } else {
            return CGSize(width: UIScreen.main.bounds.size.width, height: 155)
        }
    }
}

protocol CollectionDelegate {
    func collapseSport(forCell: UICollectionViewCell, collapse: Bool)
    func setFavourite(forCell: UICollectionViewCell,indexEvent: Int, favourite: Bool)

}
