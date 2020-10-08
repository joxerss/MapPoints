# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

target 'MapPoints' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for MapPoints
  pod 'Firebase/Core'#, '~> 6.13.0'
  pod 'Firebase/Analytics'
  pod 'Firebase/Auth'#, '~> 6.13.0'
  pod 'GoogleSignIn'#, '~> 5.0.2'
  pod 'Firebase/Database'#, '~> 6.13.0'

  # GoogleMaps Pods
  pod 'GoogleMaps'#, '~> 3.8.0'
  pod 'GooglePlaces'#, '~> 3.8.0'

  # MatreialIO
  pod 'MaterialComponents'#, '~> 107.3.0'

  # Animations
  pod 'lottie-ios'#, '~> 3.1.5'

  post_install do |installer|
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.2'
      end
    end
  end
  
end
