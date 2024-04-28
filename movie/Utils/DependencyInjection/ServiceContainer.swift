//
//  ServiceContainer.swift
//  movieTests
//
//  Created by Jan Sebastian on 28/04/24.
//

import Foundation

final class ServiceContainer {
    
    private static var cache: [String: Any] = [:]
    private static var generators: [String: () -> Any] = [:]
    
    static func register<Service>(type: Service.Type, as serviceType: ServiceType = .automatic, _ factory: @autoclosure @escaping () -> Service) {
        generators[String(describing: type.self)] = factory
        
        if serviceType == .singleton {
            cache[String(describing: type.self)] = factory()
        }
    }
    
    static func resolve<Service>(dependencyType: ServiceType = .automatic, _ type: Service.Type) -> Service? {
        let key = String(describing: type.self)
        switch dependencyType {
        case .singleton:
            if let cachedService = cache[key] as? Service {
                return cachedService
            } else {
//                fatalError("\(String(describing: type.self)) is not registeres as singleton")
                print("\(String(describing: type.self)) is not registeres as singleton")
                return nil
            }
            
        case .automatic:
            if let cachedService = cache[key] as? Service {
                return cachedService
            } else {
                print("\(String(describing: type.self)) is trouble on automatic")
            }
            fallthrough
            
        case .newInstance:
            if let service = generators[key]?() as? Service {
                cache[String(describing: type.self)] = service
                return service
            } else {
                return nil
            }
        }
    }
}
