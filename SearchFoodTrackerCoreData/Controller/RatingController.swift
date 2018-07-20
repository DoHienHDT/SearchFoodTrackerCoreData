//
//  RatingControl.swift
//  Foodtracker
//
//  Created by dohien on 6/7/18.
//  Copyright © 2018 hiền hihi. All rights reserved.
//

import UIKit
// fix contraint @IBDesignable hien thi o ngoai man hinh strory
@IBDesignable class RatingControl: UIStackView {
    private var ratingButtons = [UIButton]()
    var rating: Int = 0 {
        didSet {
            updateButtonSelectionSates()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    required init(coder: NSCoder){
        super.init(coder : coder)
        setupButtons()
    }
    @objc func ratingButtonTapped(button: UIButton){
        guard let index = ratingButtons.index(of: button)  else {
            fatalError("The Button, \(button), is not in the ratingButtons array: \(ratingButtons)")
        }
        /*  index (of) : tìm nút đã chọn trong mảng các nút  và trả về khi nó đc tìm thấy*/
        // tính toán xếp hạng các nút
        let selectedRating = index + 1
        if selectedRating == rating{
            // mặc địng là 0 khi chưa xếp hạng
            rating = 0
        }else{
            // ngược lại phải xếp hạng cho ngôi sao đã chọn
            rating = selectedRating
        }
    }
    private func setupButtons(){
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        ratingButtons.removeAll()
        
        // tải nút ảnh
        let bundle = Bundle(for : type(of: self))
        let filledStar = UIImage(named: "filledStar", in: bundle, compatibleWith: self.traitCollection)
        let emptyStar = UIImage(named: "emptyStar", in: bundle, compatibleWith: self.traitCollection)
        let highlightedStar = UIImage(named: "highlightedStar", in: bundle, compatibleWith: self.traitCollection)
        
        for index in 0..<starCount {
            let button = UIButton()
            // đặt hình ảnh nút
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected  ])
            // tạo nút
            button.translatesAutoresizingMaskIntoConstraints = false
            //tạo contraint
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
            
            button.accessibilityLabel = "Set \(index + 1) star rating"
            
            button.addTarget(self, action: #selector(RatingControl.ratingButtonTapped(button:)), for: .touchUpInside)
            addArrangedSubview(button)
            //thêm nút
            ratingButtons.append(button)
        }
        updateButtonSelectionSates()
    }
    // xác định kích thước và số nút trong dao diện
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0){
        didSet{
            setupButtons()
        }
    }
    
    @IBInspectable var starCount: Int = 5 {
        didSet{
            setupButtons()
        }
    }
    // cập nhật trạng thái lựa chọn các nút
    private func updateButtonSelectionSates(){
        for (index , button) in ratingButtons.enumerated(){
            button.isSelected = index < rating
            // đặt chuỗi gợi ý cho ngôi sao hiện được chọn
            let hinString: String?
            if rating == index + 1{
                hinString = "Tap to reset the rating to zero."
            }else{
                hinString = nil
            }
            // tính chuỗi giá trị
            let valueString: String
            switch (rating) {
            case 0:
                valueString = "No rating set."
            case 1:
                valueString = "1 star set."
            default:
                valueString = "\(rating) stars set."
            }
            button.accessibilityHint = hinString
            button.accessibilityValue = valueString
        }
    }
    
}

