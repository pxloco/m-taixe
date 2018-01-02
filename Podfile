# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
ENV["COCOAPODS_DISABLE_STATS"] = "true"

platform :ios, '9.0'

install! 'cocoapods',
:deterministic_uuids => false

target 'M-Taixe' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  pod 'HPXibDesignable'
  pod 'HPUIViewExtensions'
  pod 'NVActivityIndicatorView'
  pod 'DropDown'
  pod 'Firebase/Core'
  pod 'Firebase/Database'
  pod 'M13Checkbox'
  pod 'UICheckbox.Swift'

  # Pods for M-Taixe

  target 'M-TaixeTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'M-TaixeUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end





