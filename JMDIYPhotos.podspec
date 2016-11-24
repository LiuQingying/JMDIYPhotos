
Pod::Spec.new do |s|


  s.name         = "JMDIYPhotos"
  s.version      = "0.0.1"
  s.summary      = "给图片添加贴纸、气泡、滤镜"

  s.description  = <<-DESC
	编辑图片，给图片添加贴纸、气泡、滤镜
                   DESC

  s.homepage     = "https://github.com/LiuQingying/JMDIYPhotos"
  
  s.license      = "MIT"
  s.author       = { "LiuQingying" => "648501626@qq.com" }
  s.platform     = :ios, '7.0'

  s.source       = { :git => "https://github.com/LiuQingying/JMDIYPhotos.git", :tag => s.version }

  s.source_files  = 'JMDIYPhotos/*.{h,m}'

  s.requires_arc = true

end
