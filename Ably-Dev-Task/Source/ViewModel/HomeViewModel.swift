//
//  HomeViewModel.swift
//  Ably-Dev-Task
//
//  Created by 진태우 on 2022/06/18.
//

import RxCocoa
import RxSwift


class HomeViewModel {
    
    enum Action {
        case fetchHomeData
        case fetchGoods
        case refresh
        case bookmark(Goods)
        case unbookmark(Goods)
        case fetchBookmarkedGoodsList
    }
    
    enum Mutation {
        case setHomeData(HomeData?)
        case setGoods([Goods])
        case setIsRefresh(Bool)
        case setBookmarkedGoods(Goods?)
        case setBookmarkedGoodsList([Goods])
        case setUnbookmarkedGoods(Goods?)
    }
    
    struct Store {
        var homeData: HomeData?
        var goods: [Goods] = []
        var isRefresh: Bool = false
        var bookmarkedGoods: Goods?
        var bookmarkedGoodsList: [Goods] = []
        var unbookmarkedGoods: Goods?
    }
    
    
    // MARK: Properties
    
    var disposeBag = DisposeBag()
    
    private(set) var store: Store
    
    let action = PublishRelay<Action>()
    
    lazy var currentStore = BehaviorRelay<Store>(value: store)
    
    let service: HomeServiceProtocol
    
    
    // MARK: Initializing
    
    init(service: HomeServiceProtocol = HomeService()) {
        self.service = service
        self.store = Store()
        
        action
            .flatMap(mutate)
            .flatMap(reduce)
            .bind(to: currentStore)
            .disposed(by: disposeBag)
    }
    
    private func mutate(_ action: Action) -> Observable<Mutation> {
        switch action {
            
        case .fetchHomeData:
            return service
                    .fetchHomeData()
                    .asObservable()
                    .flatMap { data -> Observable<Mutation> in
                        var data = data
                        let goods = self.checkBookmarking(with: data?.goods ?? [])
                        data?.goods = goods
                    
                        return Observable.merge([
                            .just(.setHomeData(data)),
                            .just(.setIsRefresh(false))
                        ])
                    }
            
        case .fetchGoods:
            guard let lastId = store.homeData?.goods.last?.id else {
                return .just(.setGoods([]))
            }
            
            return service
                .fetchGoods(with: lastId)
                .asObservable()
                .flatMap { goods -> Observable<Mutation> in
                    let goods = self.checkBookmarking(with: goods)
                    return .just(.setGoods(goods))
                }
            
        case .refresh:
            return .just(.setIsRefresh(true))
            
        case .bookmark(let goods):
            return service.bookmark(with: goods)
                .asObservable()
                .map { $0 ? .setBookmarkedGoods(goods) : .setBookmarkedGoods(nil) }
            
        case .unbookmark(let goods):
            return service.unbookmark(with: goods)
                .asObservable()
                .map { $0 ? .setUnbookmarkedGoods(goods) : .setUnbookmarkedGoods(nil) }
            
        case .fetchBookmarkedGoodsList:
            return service.fetchBookmarkedGoodsList()
                .asObservable()
                .map { .setBookmarkedGoodsList($0) }
            
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setHomeData(let data):
            store.homeData = data
            
        case .setGoods(let goods):
            store.homeData?.goods.append(contentsOf: goods)
            
        case .setIsRefresh(let isRefresh):
            store.isRefresh = isRefresh
            
        case .setBookmarkedGoods(let goods):
            guard let goods = goods,
                  let index = store.homeData?.goods.firstIndex(where: { $0 == goods }) else {
                break
            }
            
            store.bookmarkedGoodsList.append(goods)
            store.homeData?.goods[index].isBookmark = true
            
        case .setBookmarkedGoodsList(let goodsList):
            store.bookmarkedGoodsList = goodsList
            
        case .setUnbookmarkedGoods(let goods):
            guard let goods = goods,
                  let index = store.homeData?.goods.firstIndex(of: goods) else {
                break
            }
        
            store.bookmarkedGoodsList = store.bookmarkedGoodsList.filter { $0.id != goods.id }
            store.homeData?.goods[index].isBookmark = false
            
        }
        
        return .just(store)
    }
    
    private func checkBookmarking(with goodsList: [Goods]) -> [Goods] {
        var list = goodsList
        list.indices.forEach {
            list[$0].isBookmark = store.bookmarkedGoodsList.contains(list[$0])
        }
        return list
    }
    
}
