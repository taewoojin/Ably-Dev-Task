//
//  HomeViewTests.swift
//  Ably-Dev-TaskTests
//
//  Created by 진태우 on 2022/06/22.
//

@testable import Ably_Dev_Task

import Nimble
import Quick


class HomeViewTests: QuickSpec {
    
    override func spec() {
        
        var viewModel: HomeViewModel!
        
        var viewController: HomeViewController!
        
        
        describe("홈 화면에서") {
            beforeEach {
                viewModel = HomeViewModel()
                viewController = HomeViewController(viewModel: viewModel)
                _ = viewController.view
            }
            
            context("뷰가 로드 되면") {
                it("10개 상품이 로드된다") {
                    expect(viewModel.store.homeData?.goods.count).toEventually(equal(10))
                }
            }
        }
        
        describe("화면이 로드 되면") {
            describe("상품 목록의 가장 하단으로 스크롤 한다.") {
                
                context("추가로 상품이 로드되면") {
                    beforeEach {
                        viewModel.action.accept(.fetchGoods)
                    }
                    
                    it("추가로 로드되어 상품 개수는 20개가 된다.") {
                        expect(viewModel.store.homeData?.goods.count).toEventually(equal(20))
                    }
                    
                }
            }
        }
        
    }
}
