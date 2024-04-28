# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'movie' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for movie
  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'RxSwift'
  pod 'RxCocoa'
  
  post_install do |installer|
      installer.pods_project.build_configurations.each do |config|
          config.build_settings['GCC_OPTIMIZATION_LEVEL'] = '1'
          config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-O'
          config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
      
      installer.pods_project.targets.each do |target|
        if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
          target.build_configurations.each do |config|
              config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
              config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
              
          end
        end
        target.build_configurations.each do |config|
          config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
        end
        target.build_configurations.each do |config|
          xcconfig_path = config.base_configuration_reference.real_path
          xcconfig = File.read(xcconfig_path)
          xcconfig_mod = xcconfig.gsub(/DT_TOOLCHAIN_DIR/, "TOOLCHAIN_DIR")
          File.open(xcconfig_path, "w") { |file| file << xcconfig_mod }
        end
      end

    end

end
