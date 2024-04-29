//
//  AppDelegate.swift
//  movie
//
//  Created by Jan Sebastian on 27/04/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow(frame: UIScreen.main.bounds)
        
        #if DEBUG
            if ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] == nil {
                // Code only executes when tests are running
                CoreDataStack.shared.doTestSetup()
                registerDependInjec()
            } else {
                registerDependInjec()
                print("work on unit test mode")
            }
        #else
            CoreDataStack.shared.doTestSetup()
            registerDependInjec()
        #endif
        
        let vc = UINavigationController(rootViewController: HomeViewController())
        vc.navigationBar.isHidden = true
        self.window?.rootViewController = vc
        self.window?.makeKeyAndVisible()
        
        
        return true
    }

    private func registerDependInjec() {
        ServiceContainer.register(type: GenreUseCase.self, GenreUseCaseImpl())
        ServiceContainer.register(type: LanguageUseCase.self, LanguageUseCaseImpl())
        ServiceContainer.register(type: CastUseCase.self, CastUseCaseImpl())
        ServiceContainer.register(type: MovieUseCase.self, MovieUseCaseImpl())
        ServiceContainer.register(type: MovieLocalUseCase.self, MovieLocalUseCaseImpl())
        ServiceContainer.register(type: GenreLocalUseCase.self, GenreLocalUseCaseImpl())
        ServiceContainer.register(type: CastLocalUseCase.self, CastLocalUseCaseImpl())
    }

}

