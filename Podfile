# Uncomment this line to define a global platform for your project
# platform :ios, "6.0"
source 'https://github.com/CocoaPods/Specs'

target "Karten" do


    pod "KMCollectionView", :path => '~/github/KMCollectionView'
    pod "EDColor"
    pod "GoogleAnalytics-iOS-SDK"
    pod "BlocksKit", :head
    pod 'MDCSwipeToChoose', '~> 0.2.0'
    pod "BugSense"
    pod "MagicalRecord"
    pod "AFNetworking"
    pod "Facebook-iOS-SDK"
    pod "Masonry", '~> 0.5.0'
    pod "SWRevealViewController", '~> 2.3.0'
    pod 'RNBlurModalView', '~> 0.1.0'
    pod 'PureLayout'
end

target "KartenUnitTests" do
    pod "MagicalRecord"
    pod "AFNetworking"
end

post_install do |installer_representation|
    installer_representation.project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['SDKROOT'] = 'iphoneos8.0'
        end
    end
end
