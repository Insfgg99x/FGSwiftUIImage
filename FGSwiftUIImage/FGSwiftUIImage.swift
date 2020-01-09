
//
//  FGSwiftUIImage.swift
//  FGSwiftUIImage
//
//  Created by xgf on 2020/1/9.
//  Copyright © 2020 xgf. All rights reserved.
//

import SwiftUI
import CommonCrypto
#if os(macOS)
    import AppKit
    public typealias FGImage = NSImage
#else
    import UIKit
    public typealias FGImage = UIImage
    #if os(watchOS)
        import WatchKit
    #endif
#endif

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
struct FGSwiftUIImage: View {
    private var url : String
    private var placeholder : AnyView?
    @ObservedObject private var loader: FGImageLoader
    
    init(_ url : String) {
        self.url = url
        loader = FGImageLoader.init()
        loader.loadData(url: url)
    }
    
    var body: some View {
        Group {
            if loader.data == nil || (loader.data != nil && FGImage(data: loader.data!) == nil) {
                Group {
                    if placeholder == nil {
                        Image(fgImage: FGImage.init())
                    } else {
                        placeholder!
                    }
                }
            } else {
                Image(fgImage: FGImage(data: loader.data!)!)
            }
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension FGSwiftUIImage {
    public func placeholder<Content: SwiftUI.View>(@ViewBuilder _ content: () -> Content) -> FGSwiftUIImage {
        let v = content()
        var s = self
        s.placeholder = AnyView(v)
        return s
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Image {
    init(fgImage: FGImage) {
        #if canImport(UIKit)
        self.init(uiImage: fgImage)
        #elseif canImport(AppKit)
        self.init(nsImage: fgImage)
        #endif
    }
}

#if DEBUG
struct FGSwiftUIImage_Previews: PreviewProvider {
    static var previews: some View {
        FGSwiftUIImage("http://ww1.sinaimg.cn/large/0065oQSqly1ft3fna1ef9j30s210skgd.jpg")
    }
}
#endif

//MARK: - Loader
final class FGImageLoader : ObservableObject {
    private var queue = OperationQueue.init()
    @Published var data : Data? = nil
    
    func loadData(url : String) {
        guard let imageUrl = URL.init(string: url) else {
            return
        }
        let key = url.sha256()
        if let data = FGImageCache.shared.data(forKey: key) {
            DispatchQueue.main.async {
                self.data = data
            }
            return
        }
        var op = queue.operations.first {
            $0.name == key
        }
        if op != nil {
            if op!.isExecuting {
                return
            }
        }
        op = BlockOperation.init {
            let data = try? Data.init(contentsOf: imageUrl)
            if data != nil {
                FGImageCache.shared.cache(data: data!, forKey: key)
            }
            DispatchQueue.main.async {
                self.data = data
            }
        }
        op?.name = key
        queue.addOperation(op!)
    }
    
    deinit {
        queue.cancelAllOperations()
    }
}

//MARK: - Cache
final class FGImageCache {
    static let shared = FGImageCache.init()
    private var manager = FileManager.default
    private let fileCacheTime = TimeInterval(7 * 24 * 3600)
    private var cache = [String : Data]()
    private let cacheDirect = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0].appending("/fg.image.cache")
    
    init() {
        var isDirect = ObjCBool.init(false)
        let exist = manager.fileExists(atPath: cacheDirect, isDirectory: &isDirect)
        if !exist {
            try? manager.createDirectory(atPath: cacheDirect, withIntermediateDirectories: true, attributes: nil)
        } else {
            if !isDirect.boolValue {
                try? manager.removeItem(atPath: cacheDirect)
                try? manager.createDirectory(atPath: cacheDirect, withIntermediateDirectories: true, attributes: nil)
            }
        }
    }
    
    func data(forKey key : String) -> Data? {
        var d = cache[key]
        if d != nil {
            return d
        }
        let path = cacheDirect + "/" + key
        let exist = manager.fileExists(atPath: path)
        if exist {
            let attributes = try? manager.attributesOfItem(atPath: path)
            if let createDate = attributes?[.creationDate] as? Date {
                let now = Date.init()
                let seconds = now.timeIntervalSince(createDate)
                if seconds < fileCacheTime {
                    let url = URL.init(fileURLWithPath: path)
                    d = try? Data.init(contentsOf: url)
                    if d != nil {
                        cache[key] = d!
                        return d
                    }
                }
            }
        }
        return nil
    }
    
    func cache(data : Data, forKey key : String) {
        cache[key] = data
        let path = cacheDirect + "/" + key
        let exist = manager.fileExists(atPath: path)
        if exist {
            try? manager.removeItem(atPath: path)
        }
        manager.createFile(atPath: path, contents: data, attributes: nil)
    }
}

//MARK: - Hash
public extension String {
    func sha256() -> String {
        let str = self.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_SHA256_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_SHA256(str!, strLen, result)
        var hash = ""
        for i in 0 ..< digestLen {
            hash.append(.init(format: "%02x", result[i]))
        }
        free(result)
        return hash
    }
}
