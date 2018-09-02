source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'MerHouse' do
#pod 'MMSegmentControl'
pod 'TZSegmentedControl'

pod 'TextFieldEffects'
pod 'IQKeyboardManagerSwift'
pod 'Alamofire', '~> 4.0'
pod 'ARSLineProgress', '~> 2.0'
pod 'DGElasticPullToRefresh'
pod 'SDWebImage', '~>3.8'
pod 'StatusProvider'
pod 'BubbleTransition', '~> 2.0.0'
pod 'RealmSwift'
pod 'GSImageViewerController'
pod 'BIZPopupView'
pod 'TransitionButton'
pod 'GoogleMaps', '~> 2.3.0'
pod 'GooglePlaces', '~> 2.3.0'
pod 'Fabric'
pod 'Crashlytics'
pod 'SHViewPager', '~> 2.0'
pod 'YSLContainerViewController'
pod 'FAPaginationLayout'
pod 'AASegmentedControl'
pod 'Popover'
pod 'AKSideMenu'
pod 'CRNotifications'

#pod 'SideMenu'
pod 'Firebase/Core'
pod 'Firebase/Auth'
pod 'Firebase/Messaging'
pod 'IBAnimatable'


end
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
