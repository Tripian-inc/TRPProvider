//
//  ReservationAlternativeHour.swift
//  TRPProvider
//
//  Created by Evren Yaşar on 7.07.2020.
//  Copyright © 2020 Tripian Inc. All rights reserved.
//

import UIKit
class ReservationAlternativeHour: ReservationBaseCell {
    
    var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize(width: 150, height: 180)
        flowLayout.minimumLineSpacing = 2.0
        flowLayout.minimumInteritemSpacing = 5.0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        return collection
    }()
    
    
    override func setupCustom(stack: UIStackView) {
        stack.addArrangedSubview(collectionView)
        setupCollectionView()
    }
    
}

extension ReservationAlternativeHour: UICollectionViewDataSource, UICollectionViewDelegate {
    
    
    private func setupCollectionView() {
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionCell")
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        self.collectionView.widthAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as UICollectionViewCell
        cell.contentView.backgroundColor = UIColor.red
        return cell
        
    }
}

