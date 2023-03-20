//
//  StarRatingView.swift
//  FLEEKR
//
//  Created by Joshua Hart on 3/17/23.
//

import UIKit

class StarRatingView: UIView {
    let rating: Double
    let emptyStarImage = #imageLiteral(resourceName: "empty_star")
    let quarterStarImage = #imageLiteral(resourceName: "quarter_star")
    let halfStarImage = #imageLiteral(resourceName: "half_star")
    let threeQuarterStarImage = #imageLiteral(resourceName: "three_quarter_star")
    let filledStarImage = #imageLiteral(resourceName: "filled_star")

    init(rating: Double) {
        self.rating = rating
        super.init(frame: CGRect(x: 0, y: 0, width: 32.5, height: 160))
        setupImageViews()
    }

    @available(*, unavailable) required init?(coder: NSCoder) { nil }

    private func setupImageViews() {
        let integerImages = getIntegerImages()
        let fiveStarRating = addAdditionalImageViews(images: integerImages)
        let starHeight = bounds.height / 5.0

        // Create an image view for each star and add it to the view hierarchy
        for i in 0..<5 {
            let imageView = UIImageView(image: fiveStarRating[i])
            imageView.layer.shadowColor = UIColor.darkGray.cgColor
            imageView.layer.shadowOffset = CGSize(width: 0, height: 1.0)
            imageView.layer.shadowRadius = 2.5
            imageView.layer.shadowOpacity = 0.50
            imageView.contentMode = .scaleAspectFit
            addSubview(imageView)

            // Set the frame of the image view to display the star image in the correct position
            imageView.frame = CGRect(x: 0, y: CGFloat(i) * starHeight, width: bounds.width, height: starHeight)
        }
    }

    private func getIntegerImages() -> [UIImage] {
        switch Int(rating) {
        case 1: return [filledStarImage]
        case 2: return [filledStarImage, filledStarImage]
        case 3: return [filledStarImage, filledStarImage, filledStarImage]
        case 4: return [filledStarImage, filledStarImage, filledStarImage, filledStarImage]
        case 5: return [filledStarImage, filledStarImage, filledStarImage, filledStarImage, filledStarImage]
        default: return []
        }
    }

    private func addAdditionalImageViews(images: [UIImage]) -> [UIImage] {
        let fractionalFloat = rating.truncatingRemainder(dividingBy: 1.0)
        var startImages = images

        switch fractionalFloat {
        case ..<0.125: startImages.append(emptyStarImage)
        case 0.125..<0.375: startImages.append(quarterStarImage)
        case 0.375..<0.625: startImages.append(halfStarImage)
        case 0.625..<0.9: startImages.append(threeQuarterStarImage)
        case 0.9...: startImages.append(filledStarImage)
        default: startImages.append(emptyStarImage)
        }
        // Add empty stars until there are 5 images
        while startImages.count < 5 {
            startImages.append(emptyStarImage)
        }

        return startImages
    }
}
