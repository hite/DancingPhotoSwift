source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '11.0'

target "DancingPhotoSwift" do
    pod 'SnapKit'
    pod 'LayoutKit'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '4.0'
        end
    end
end