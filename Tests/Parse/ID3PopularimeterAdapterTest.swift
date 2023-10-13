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
        var rating = PopularimeterRating(0)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(0))
        
        rating = PopularimeterRating(1)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(1))
        
        rating = PopularimeterRating(64)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(2))
        
        rating = PopularimeterRating(128)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(3))
        
        rating = PopularimeterRating(196)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(4))
        
        rating = PopularimeterRating(255)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(5))
        
        //Try some out-of-range values
        rating = PopularimeterRating(3)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(0))
        
        rating = PopularimeterRating(300)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), FiveStarRating(0))
        
    }
    
    func testAdapt5StarToPopularimeter() {
        var rating = FiveStarRating(0)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(0))
        
        rating = FiveStarRating(1)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(1))
        
        rating = FiveStarRating(2)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(64))
        
        rating = FiveStarRating(3)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(128))
        
        rating = FiveStarRating(4)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(196))
        
        rating = FiveStarRating(5)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(255))
        
        //Try some out-of-range values
        rating = FiveStarRating(6)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(0))
        
        rating = FiveStarRating(60)
        XCTAssertEqual(id3RatingAdapter.adapt(rating), PopularimeterRating(0))
        
    }
}

