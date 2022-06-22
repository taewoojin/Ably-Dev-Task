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
        case fetchWishlist
        case addWishlist(Goods)
        case removeWishlist(Goods)
    }
    
    enum Mutation {
        case setHomeData(HomeData?)
        case setGoods([Goods])
        case setIsRefresh(Bool)
        case setWishlist([Goods])
        case setAddedWishlist(Goods?)
        case setRemovedWishlist(Goods?)
    }
    
    struct Store {
        var homeData: HomeData?
        var isLoadableGoods: Bool = true        // 상품 로드 가능 여부(로드할 상품이 없을 경우, false)
        var isRefresh: Bool = false
        var wishlist: [Goods] = []
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
                    .flatMap { result -> Observable<Mutation> in
                        switch result {
                        case .success(let data):
                            return Observable.merge([
                                .just(.setHomeData(data)),
                                .just(.setIsRefresh(false))
                            ])
                            
                        case .failure(let error):
                            // TODO: 상황에 따른 에러 처리
                            return .just(.setIsRefresh(false))
                            
                        }
                    }
            
        case .fetchGoods:
            guard let lastId = store.homeData?.goods.last?.id else {
                return .just(.setGoods([]))
            }
            
            return service
                .fetchGoods(with: lastId)
                .asObservable()
                .flatMap { result -> Observable<Mutation> in
                    switch result {
                    case .success(let goods):
                        let goods = self.checkBookmarking(with: goods)
                        return .just(.setGoods(goods))
                        
                    case .failure(let error):
                        // TODO: 상황에 따른 에러 처리
                        return .empty()
                        
                    }
                }
            
        case .refresh:
            return .just(.setIsRefresh(true))
            
        case .addWishlist(let goods):
            return service.addWishlist(with: goods)
                .asObservable()
                .map { $0 ? .setAddedWishlist(goods) : .setAddedWishlist(nil) }
            
        case .removeWishlist(let goods):
            return service.removeWishlist(with: goods)
                .asObservable()
                .map { $0 ? .setRemovedWishlist(goods) : .setRemovedWishlist(nil) }
            
        case .fetchWishlist:
            return service.fetchWishlist()
                .asObservable()
                .map { .setWishlist($0) }
            
        }
    }
    
    private func reduce(_ mutation: Mutation) -> Observable<Store> {
        switch mutation {
        case .setHomeData(let data):
            store.homeData = data
            
        case .setGoods(let goods):
            store.isLoadableGoods = !goods.isEmpty
            store.homeData?.goods.append(contentsOf: goods)
            
        case .setIsRefresh(let isRefresh):
            store.isRefresh = isRefresh
            
        case .setWishlist(let wishlist):
            store.wishlist = wishlist
            
        case .setAddedWishlist(let goods):
            guard let goods = goods,
                  let index = store.homeData?.goods.firstIndex(where: { $0 == goods }) else {
                break
            }
            
            store.wishlist.append(goods)
            store.homeData?.goods[index].isWish = true
            
        case .setRemovedWishlist(let goods):
            guard let goods = goods,
                  let index = store.homeData?.goods.firstIndex(of: goods) else {
                break
            }
        
            store.wishlist = store.wishlist.filter { $0.id != goods.id }
            store.homeData?.goods[index].isWish = false
            
        }
        
        return .just(store)
    }
    
    private func checkBookmarking(with goodsList: [Goods]) -> [Goods] {
        var list = goodsList
        list.indices.forEach {
            list[$0].isWish = store.wishlist.contains(list[$0])
        }
        return list
    }
    
}
