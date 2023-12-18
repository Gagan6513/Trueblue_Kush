# Uncomment the next line to define a global platform for your project
#platform :ios, '13.0'

target 'TrueBlue' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  
  

  # Pods for TrueBlue
  pod 'Alamofire', '~> 5.4'
  pod 'Toast-Swift', '~> 5.0.1'
  pod 'IQKeyboardManagerSwift'
  pod 'JVFloatLabeledTextField'
  pod 'SVProgressHUD'
  pod 'AASignatureView'
  pod 'SideMenu', '~> 6.0'
  pod 'Kingfisher'#, '~> 7.0'
  pod 'DZNEmptyDataSet'
  #pod 'ImageViewer'
  pod 'DKImagePickerController'
  #pod 'DateTextField'
  
  post_install do |installer|
      installer.generated_projects.each do |project|
          project.targets.each do |target|
              target.build_configurations.each do |config|
                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
              end
          end
      end
  end
end
