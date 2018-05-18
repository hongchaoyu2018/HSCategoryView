Pod::Spec.new do |s|

# 名称 使用的时候pod search [name]
s.name = "HSCategoryView"

# 代码库的版本
s.version = "1.2.0"

# 简介
s.summary = "弹出左右tableView列表筛选框."
# 主页
s.homepage = "https://github.com/hongchaoyu2018/HSCategoryView.git"

# 许可证书类型，要和仓库的LICENSE 的类型一致
s.license = "MIT"

# 作者名称 和 邮箱
s.author = { "Hong" => "13450258899@163.com" }

# 作者主页 s.social_media_url ="xxx"

# 代码库最低支持的版本
s.platform = :ios, "11.0"

# 代码的Clone 地址 和 tag 版本
s.source = { :git => "https://github.com/hongchaoyu2018/HSCategoryView.git", :tag => s.version.to_s }

# 如果使用pod 需要导入哪些资源
s.source_files = "CategoryView/**/*.{swift}"
s.resources = ['CategoryView/LeftRightTableView.xib', 'CategoryView/icons']

# 框架是否使用的ARC
s.requires_arc = true

end


