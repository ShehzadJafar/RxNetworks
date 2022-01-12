# RxNetworks

[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/yangKJ/RxNetworks)
[![Releases Compatible](https://img.shields.io/github/release/yangKJ/RxNetworks.svg?style=flat&label=Releases&colorA=28a745&&colorB=4E4E4E)](https://github.com/yangKJ/RxNetworks/releases)
[![CocoaPods Compatible](https://img.shields.io/cocoapods/v/RxNetworks.svg?style=flat&label=CocoaPods&colorA=28a745&&colorB=4E4E4E)](https://cocoapods.org/pods/RxNetworks)
[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20macOS%20%7C%20watchOS-4E4E4E.svg?colorA=28a745)](#installation)

<font color=red>**🧚. RxSwift + Moya + HandyJSON + Plugins.👒👒👒**</font>

-------

[**English**](README.md) | 简体中文

基于 **RxSwift + Moya** 搭建响应式数据绑定网络API架构

### MoyaNetwork
该模块是基于Moya封装的网络API架构

- 主要分为3部分：
    - [NetworkConfig](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaNetwork/NetworkConfig.swift)：在程序最开始处设置配置信息，全局通用
        - baseURL：根路径地址
        - baseParameters：默认基本参数，类似：userID，token等
        - baseMethod：默认请求类型
        - updateBaseParametersWithValue：更新默认基本参数数据
    - [RxMoyaProvider](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaNetwork/RxMoyaProvider.swift)：对网络请求添加响应式，返回`Single`序列
    - [NetworkAPI](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaNetwork/NetworkAPI.swift)：在`TargetType`基础上增加协议属性和封装基础网络请求
        - ip：根路径地址
        - parameters：请求参数
        - plugins：插件
        - stubBehavior：是否走测试数据
        - request：网络请求方法

🌰 - 使用示例1:

```
class MoyaViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    let data = PublishRelay<String>()
    
    /// 请求配置
    let APIProvider: MoyaProvider<MultiTarget> = {
        let configuration = URLSessionConfiguration.default
        configuration.headers = .default
        configuration.timeoutIntervalForRequest = 30
        let session = Moya.Session(configuration: configuration, startRequestsImmediately: false)
        return MoyaProvider<MultiTarget>(session: session)
    }()
    
    func loadData() {
        APIProvider.rx.request(api: MoyaAPI.test)
            .asObservable()
            .compactMap{ (($0 as! NSDictionary)["origin"] as? String) }
            .bind(to: data)
            .disposed(by: disposeBag)
    }
}
```

🌰 - 使用示例2:

```
enum LoadingAPI {
    case test2(String)
}

extension LoadingAPI: NetworkAPI {
    
    var ip: APIHost {
        return NetworkConfig.baseURL
    }
    
    var path: String {
        return "/post"
    }
    
    var parameters: APIParameters? {
        switch self {
        case .test2(let string): return ["key": string]
        }
    }
    
    var plugins: APIPlugins {
        let loading = NetworkLoadingPlugin.init()
        return [loading]
    }
}


class LoadingViewModel: NSObject {
    
    let disposeBag = DisposeBag()
    
    let data = PublishRelay<NSDictionary>()
    
    func loadData() {
        LoadingAPI.test2("666").request()
            .asObservable()
            .subscribe { [weak self] (event) in
                guard let dict = event.element as? NSDictionary else { return }
                self?.data.accept(dict)
            }.disposed(by: disposeBag)
    }
}
```

🌰 - 使用示例3:

```
class CacheViewModel: NSObject {

    let disposeBag = DisposeBag()
    
    struct Input {
        let count: Int
    }

    struct Output {
        let items: Driver<[CacheModel]>
    }
    
    func transform(input: Input) -> Output {
        let elements = BehaviorRelay<[CacheModel]>(value: [])
        
        let output = Output(items: elements.asDriver())
        
        request(input.count)
            .asObservable()
            .bind(to: elements)
            .disposed(by: disposeBag)
        
        return output
    }
}

extension CacheViewModel {
    
    func request(_ count: Int) -> Driver<[CacheModel]> {
        CacheAPI.cache(count).request()
            .asObservable()
            .mapHandyJSON(HandyDataModel<[CacheModel]>.self)
            .compactMap { $0.data }
            .observe(on: MainScheduler.instance) // 结果在主线程返回
            .delay(.seconds(1), scheduler: MainScheduler.instance) // 延时1秒返回
            .asDriver(onErrorJustReturn: []) // 错误时刻返回空
    }
}
```

### MoyaPlugins
该模块主要就是基于moya封装网络相关插件

- 目前已封装4款插件供您使用：
    - [Cache](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaPlugins/Cache/NetworkCachePlugin.swift)：网络数据缓存插件
    - [Loading](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaPlugins/Loading/NetworkLoadingPlugin.swift)：加载动画插件
    - [Indicator](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaPlugins/Indicator/NetworkIndicatorPlugin.swift)：指示器插件
    - [Warning](https://github.com/yangKJ/RxNetworks/blob/master/Sources/MoyaPlugins/Warning/NetworkWarningPlugin.swift)：网络失败提示插件

🏠 - 简单使用，在API协议当中实现该协议方法，然后将插件加入其中即可：

```
var plugins: APIPlugins {
    let cache = NetworkCachePlugin(cacheType: .networkElseCache)
    let loading = NetworkLoadingPlugin.init(delayHideHUD: 0.5)
    return [loading, cache]
}
```

### HandyJSON
该模块是基于`HandyJSON`封装网络数据解析

- 大致分为以下3个部分：
    - [HandyDataModel](https://github.com/yangKJ/RxNetworks/blob/master/Sources/HandyJSON/HandyDataModel.swift)：网络外层数据模型
    - [HandyJSONError](https://github.com/yangKJ/RxNetworks/blob/master/Sources/HandyJSON/HandyJSONError.swift)：解析错误相关
    - [RxHandyJSON](https://github.com/yangKJ/RxNetworks/blob/master/Sources/HandyJSON/RxHandyJSON.swift)：HandyJSON数据解析，目前提供两种解析方案
        - 方案1: 结合`HandyDataModel`模型使用解析出`data`数据
        - 方案2: 根据`keyPath`解析出指定key的数据，前提条件数据源必须字典形式

🌰 - 结合网络部分使用示例：

```
func request(_ count: Int) -> Driver<[CacheModel]> {
    CacheAPI.cache(count).request()
        .asObservable()
        .mapHandyJSON(HandyDataModel<[CacheModel]>.self)
        .compactMap { $0.data }
        .observe(on: MainScheduler.instance) // 结果在主线程返回
        .delay(.seconds(1), scheduler: MainScheduler.instance) // 延时1秒返回
        .asDriver(onErrorJustReturn: []) // 错误时刻返回空
}
```

### CocoaPods Install
```
Ex: 导入网络架构API
- pod 'RxNetworks/MoyaNetwork'

Ex: 导入数据解析
- pod 'RxNetworks/HandyJSON'

Ex: 导入加载动画插件
- pod 'RxNetworks/MoyaPlugins/Loading'
```

-----

> <font color=red>**觉得有帮助的老哥们，请帮忙点个星 ⭐..**</font>

**救救孩子吧，谢谢各位老板。**

🥺 - [**传送门**](https://github.com/yangKJ/RxNetworks)

-----