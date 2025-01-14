//
//  Storage.swift
//  CacheX
//
//  Created by Condy on 2023/3/23.
//  

import Foundation

/// Mixed storge transfer station.
public final class Storage<T: Codable> {
    
    public lazy var disk: Disk = Disk()
    public lazy var memory: Memory = Memory()
    
    public lazy var caches: [String: Cacheable] = [
        Memory.named: memory,
        Disk.named: disk
    ]
    
    public let backgroundQueue: DispatchQueue
    
    lazy var transformer = TransformerFactory<T>.forCodable()
    
    /// Initialize the object.
    /// - Parameter queue: The default thread is the background thread.
    public init(queue: DispatchQueue? = nil) {
        self.backgroundQueue = queue ?? {
            /// Create a background thread.
            DispatchQueue(label: "com.condy.CacheX.cached.queue", attributes: [.concurrent])
        }()
    }
    
    /// Caching object.
    public func storeCached(_ object: T, forKey key: String, options: CachedOptions) {
        guard let data = try? transformer.toData(object) else {
            return
        }
        write(key: key, value: data, options: options)
    }
    
    /// Read cached object.
    public func fetchCached(forKey key: String, options: CachedOptions) -> T? {
        guard let data = read(key: key, options: options) else {
            return nil
        }
        return try? transformer.fromData(data)
    }
    
    /// Read disk data or memory data.
    public func read(key: String, options: CachedOptions) -> Data? {
        for named in options.cacheNameds() where self.caches[named] != nil {
            return self.caches[named]!.read(key: key)
        }
        return nil
    }
    
    /// Write data asynchronously to disk and memory.
    public func write(key: String, value: Data, options: CachedOptions) {
        backgroundQueue.async {
            for named in options.cacheNameds() {
                self.caches[named]?.store(key: key, value: value)
            }
        }
    }
    
    /// Remove the specified data.
    public func removed(forKey key: String, options: CachedOptions) {
        for named in options.cacheNameds() {
            self.caches[named]?.removeCache(key: key)
        }
    }
    
    /// Remove disk cache and memory cache.
    public func removedDiskAndMemoryCached(completion: SuccessComplete? = nil) {
        backgroundQueue.async {
            self.disk.removedCached { isSuccess in
                DispatchQueue.main.async { completion?(isSuccess) }
            }
            self.memory.removedAllCached()
        }
    }
}
