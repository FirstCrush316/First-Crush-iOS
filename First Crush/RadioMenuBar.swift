//
//  RadioMenuBar.swift
//  First Crush
//
//  Created by Sumit Johri on 08/01/19.
//  Copyright © 2019 Sumit Johri. All rights reserved.
//

import UIKit

class RadioMenuBar:UIView , UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    let radioCellId="CellId"
    let tabNames = ["Radio","Bollywood","Hollywood","Punjabi","EDM"]
    var radioController:RadioViewControllerNew?
    var parentView:UICollectionView?
    
    lazy var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        let cv = UICollectionView(frame: CGRect(x: 0,y: 0,width: self.frame.width,height: 45), collectionViewLayout: layout)
        cv.dataSource=self
        cv.delegate=self
        cv.backgroundColor=UIColor.black
        cv.allowsSelection=true
        cv.contentMode = .scaleAspectFit
        cv.translatesAutoresizingMaskIntoConstraints=false
        return cv
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        //let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        //collectionView = UICollectionView(frame:CGRect(x: 0,y: 0,width: self.frame.width,height: 45), collectionViewLayout: layout)
        collectionView.register(MenuRadioCell.self, forCellWithReuseIdentifier: radioCellId)
        //backgroundColor = UIColor.black
        collectionView.backgroundColor=UIColor.black
        //collectionView.dataSource=self
        //collectionView.delegate=self
        //collectionView.allowsSelection=true
        //collectionView.contentMode = .scaleToFill
        //collectionView.translatesAutoresizingMaskIntoConstraints=true
        addSubview(collectionView)
        setupHorizontalBar()
        collectionView.translatesAutoresizingMaskIntoConstraints=false
        collectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0.0).isActive=true
        collectionView.widthAnchor.constraint(equalTo: self.widthAnchor, constant: 0.0).isActive=true
        collectionView.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant:0.0).isActive=true
        collectionView.trailingAnchor.constraint(equalTo: self.trailingAnchor,constant:0.0).isActive=true
        collectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor,constant:0.0).isActive=true
        collectionView.heightAnchor.constraint(equalToConstant: 45.0).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //Select First Cell by default
        //collectionView.collectionViewLayout.invalidateLayout()
        let selectedIndexPath = IndexPath(item: 0, section: 0)
        collectionView.selectItem(at: selectedIndexPath, animated: false, scrollPosition: [])
    }
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
        return true
    }
    var horizontalBarLeftAnchorConstraint:NSLayoutConstraint?
    
    func setupHorizontalBar(){
        let horizontalBarView = UIView()
        horizontalBarView.translatesAutoresizingMaskIntoConstraints=false
        horizontalBarView.contentMode = .scaleToFill
        horizontalBarView.backgroundColor=#colorLiteral(red: 0.6576176882, green: 0.7789518833, blue: 0.2271372974, alpha: 1)
        addSubview(horizontalBarView)
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive=true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier:1/4).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 3.0).isActive = true
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        /*print("123")
         let x = CGFloat(indexPath.item) * frame.width/4
         horizontalBarLeftAnchorConstraint?.constant=x
         horizontalBarLeftAnchorConstraint?.isActive = true
         UIView.animate(withDuration: 0.1, delay: 0, options: .curveEaseOut, animations: {
         self.layoutIfNeeded()
         }, completion:nil)*/
        radioController?.scrollToRadioMenuIndex(menuIndex: indexPath.item)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: radioCellId, for: indexPath) as! MenuRadioCell
        cell.contentView.frame=cell.bounds
        cell.contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        cell.backgroundColor=UIColor.black
        cell.wordLabel.text="\(tabNames[indexPath.item])"
        cell.wordLabel.textAlignment = .center
        
        cell.wordLabel.font = UIFont.preferredFont(forTextStyle: .body)
        cell.wordLabel.textColor = UIColor.darkGray
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cell.prepareForReuse()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: bounds.width/4, height: bounds.height-20)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class MenuRadioCell:UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupViews()
    }
    
    let wordLabel: UILabel = {
        let label = UILabel()
        //label.text = "Featured"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool{
        didSet{
            wordLabel.textColor=isHighlighted ? UIColor.white:UIColor.darkGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            wordLabel.textColor=isSelected ? UIColor.white:UIColor.darkGray
        }
    }
    
    func setupViews() {
        //addSubview(textView!)
        backgroundColor = UIColor.black;
        addSubview(wordLabel)
        //wordLabel.translatesAutoresizingMaskIntoConstraints=true
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":wordLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0":wordLabel]))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
