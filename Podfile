

target 'Aceros' do
    use_frameworks!
    
    pod 'Kingfisher', '~> 4.7.0'
    pod 'ObjectMapper', '~> 3.4'
    pod 'Moya', '~> 12.0.1'
    pod 'IQKeyboardManagerSwift', '~> 6.2.0'
    pod 'NVActivityIndicatorView'
    pod 'IBAnimatable','~> 5.2.1'
    pod 'SwiftMessages', '~> 6.0.2'
    pod 'Parchment', '~> 1.5.0'
    pod 'R.swift', '~> 4.0.0'
    pod 'RMMapper', '~> 1.1.5'
    pod 'GoogleMaps', '~> 3.1.0'
    pod 'GooglePlaces', '~> 3.1.0'
    pod 'SideMenu' , '~> 5.0.3'
    pod 'PullUpController' , '~> 0.7.0'
    pod 'ActionSheetPicker-3.0'
    pod 'Lightbox', '~> 2.3'
    
    #pod 'RealmSwift' , '~> 3.14.2'
    #pod 'Material', '~> 2.16.4'
    #pod 'UICircularProgressRing', '~> 6.1'
    #pod 'ActiveLabel', '~> 1.0.1'
    #pod 'CountryList', '~> 1.1'
    
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
        end
    end
end
