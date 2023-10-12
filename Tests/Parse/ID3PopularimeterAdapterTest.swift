//
//  ID3GenreStringAdapterTest.swift
//
//  Created by Fabrizio Duroni on 04/03/2018.
//  2018 Fabrizio Duroni.
//

import XCTest
@testable import ID3TagEditor

class ID3PopularimeterAdapterTest: XCTestCase {
    private let id3RatingAdapter = ID3RatingAdapter()
    
    func testAdaptPopularimeterRatingTo5Star() {
        var rating = PopularimeterRating(ratingValue: 0)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 0))
        
        rating = PopularimeterRating(ratingValue: 1)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 1))
        
        rating = PopularimeterRating(ratingValue: 64)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 2))
        
        rating = PopularimeterRating(ratingValue: 128)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 3))
        
        rating = PopularimeterRating(ratingValue: 196)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 4))
        
        rating = PopularimeterRating(ratingValue: 255)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 5))
        
        //Try some out-of-range values
        rating = PopularimeterRating(ratingValue: 3)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 0))
        
        rating = PopularimeterRating(ratingValue: 300)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(ratingValue: 0))
        
    }
    
    func testAdapt5StarToPopularimeter() {
        var rating = FiveStarRating(ratingValue: 0)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 0))
        
        rating = FiveStarRating(ratingValue: 1)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 1))
        
        rating = FiveStarRating(ratingValue: 2)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 64))
        
        rating = FiveStarRating(ratingValue: 3)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 128))
        
        rating = FiveStarRating(ratingValue: 4)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 196))
        
        rating = FiveStarRating(ratingValue: 5)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 255))
        
        //Try some out-of-range values
        rating = FiveStarRating(ratingValue: 6)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 0))
        
        rating = FiveStarRating(ratingValue: 60)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(ratingValue: 0))
        
    }
}

