# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'Heroes Stats' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Heroes Stats
  pod 'Alamofire', '~> 4.7'
  pod 'AlamofireImage'
  # pod 'Shiny'
  # pod 'StatusAlert'
  #pod 'HanekeSwift'
  #pod 'LGButton'
  pod 'SwiftVideoBackground', '~> 3.0'
  pod 'DropDown'
  pod 'Alertift', '~> 3.0'
  pod 'Zip'
  pod 'SKActivityIndicatorView'
  pod 'Kanna'
  # pod 'Cards'
  # pod 'PeekPop'
end

# Disable signing
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['EXPANDED_CODE_SIGN_IDENTITY'] = ""
            config.build_settings['CODE_SIGNING_REQUIRED'] = "NO"
            config.build_settings['CODE_SIGNING_ALLOWED'] = "NO"
        end
    end
    end
