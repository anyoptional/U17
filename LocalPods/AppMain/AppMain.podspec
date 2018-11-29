#
# Be sure to run `pod lib lint AppMain.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    
    s.name             = 'AppMain'
    s.version          = '1.0.0'
    s.summary          = 'Application main module.'
    
    s.homepage         = 'Coming soon...'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Archer' => 'code4archer@163.com' }
    s.source           = { :git => 'Coming soon...', :tag => s.version.to_s }
    
    s.ios.deployment_target = '9.0'
    
    s.dependency 'Mediator'
    
    s.resource_bundles = {
        'AppMain' => ['AppMain/Assets/*.png']
    }
    
    s.subspec "Controller" do |cs|
        cs.source_files  = "AppMain/Classes/Controller"
    end
        
    s.subspec "Router" do |cs|
        cs.source_files  = "AppMain/Classes/Router"
    end
    
    s.subspec "View" do |cs|
        cs.source_files  = "AppMain/Classes/View"
    end
    
end
