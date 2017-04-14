## 1. 初始化Rails App
```
rails new SteamBlogDemo
cd SteamBlogDemo
```

## 2. 在github创建项目，并把代码推送到github
以下为根据github创建repository之后的提示内容更改：
```
git init
git add .
git commit -m "first commit"
git remote add origin git@github.com:sundevilyang/SteamBlogDemo.git
git push -u origin master
```

## 3.  制作首页(静态页面)
 1. 在 <kbd>config/routes.rb</kbd>文件中添加 `root to: 'visitors#index'`
 2. `rails s` 启动服务器，访问 `http://localhost:3000`。 遇到报错，提示 `没有初始化的常量 VisitorsController` （记得git commit）
 插入报错图片
 3. 命令行运行 `rails g controller visitors index`； 再访问 `http://localhost:3000`， 无报错信息。
 4. 使用[Bootstrap](http://getbootstrap.com)制作前端
    - 观看[Gorails视频](https://gorails.com/episodes/styling-with-bootstrap-sass) （观看时把字幕打开）， 以及参考 [bootstrap-sass](https://github.com/twbs/bootstrap-sass)
      - 在Gemfiel中添加 `gem 'bootstrap-sass', '~> 3.3.7'` , 再在命令行运行 `bundle install`
      - 命令行运行 `mv app/assets/stylesheets/application.css app/assets/stylesheets/application.scss`
      - 在 `app/assets/stylesheets/application.scss` 文件中添加如下内容：
        ```
        @import "bootstrap-sprockets";
        @import "bootstrap";
        ```
      - 在 `app/assets/javascripts/application.js` 文件中添加：
        ```
        //= require bootstrap-sprockets
        ```
      - `git commit -m 'add bootstrap'`
    - `http://www.bootcss.com/p/layoutit/` 可视化布局首页
    插入图片
    - 下载代码，粘贴到 `app/views/visitors/index.html.erb`
    - 修改上一步的代码，并把引用的图片放到 `app/assetts/images`文件夹中
      - 创建共享文件夹 `mkdir app/views/shared`
      - 在shared文件夹中创建nav和footer文件 `touch app/views/shared/_nav.html.erb app/views/shared/_footer.html.erb`
      - 把上一步中的nav、footer内容移到 <kbd>nav.html.erb & footer.html.erb</kbd>
      - 在   <kbd>app/views/layouts/application.html.erb</kbd> 修改body如下：
        ```
        <body>
          <%= render 'shared/nav' %>
          <%= yield %>
          <%= render 'shared/footer' %>
        </body>
        ```

> 至此，我们使用bootstrap完成了一个 **静态页面**， 静态页面没有数据交互。即MVC中没有M。


## 4. 用户注册&登录
使用[devise](https://github.com/plataformatec/devise)配置用户注册和登录功能。
 看「GEtting started」完成登录功能：
1. 在Gemfile文件中添加 `gem 'devise'`, 然后在命令行运行 `bundle install`
2. 在命令行运行 `rails g devise:install`;
3. 在文件<kbd>config/environments/development.rb</kbd> 中添加：  
`config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }`
4. 在命令行运行命令 `rails g devise User`;
5. `rails g migration AddUsernameToUser username:string`
6. `rails generate devise:views`, 修改<kbd>app/views/devise/registrations/</kbd>中的两个文件，分别添加：      
    ```
    <div class="field">
      <%= f.label :username %><br />
      <%= f.email_field :username, autofocus: true %>
    </div>
    ```
      然后在运行 `rails db:migrate` 迁移数据库
7.  permit additional parameters (the lazy way™), you can do so using a simple before filter in your ApplicationController:
    ```
    class ApplicationController < ActionController::Base
      before_action :configure_permitted_parameters, if: :devise_controller?

      protected

      def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
      end
    end
    ```
7. 在命令行输入 `rake routes` ，可以看到安装devise之后允许的路径，如下图：
6. 修改导航栏中的用户和注册路径，启动服务器，测试注册和登录功能
7. git commit

## 5. Articles MVC实践
1. 修改导航栏中Articles的路径   
    ```
    <li class="btn btn-white btn-simple">
    <%= link_to('Articles', articles_path ) %>
    </li>
    ```
2. 刷新浏览器，点击导航栏<kbd>Articles</kbd>，跳转到 `http://localhost:3000/articles`，报错，如下图：
3.  `routes.rb` 中添加 `resources :articles`
4. 启动服务器 `rails s`， 访问 `http://localhost:3000/articles`, **找不到路径**错误已解决。但有一个新的 **找不到controller** 报错，报错如下图
 插入图
5. 在命令行输入 `rails g controller articles`, 刷新浏览器。报错，提示controller里面没有 ‘index’ action，如下图：
6. 在 <kbd>app/controllers/articles_controller.rb</kbd> 文件夹中添加index方法
    ```
    class ArticlesController < ApplicationController
      def index
      end
    end
    ```
    再刷新浏览器。报错，提示：没有 index template

7. 在命令行中输入 `touch app/views/articles/index.html.erb`
8. 再使用[可视化bootstrap工具](http://www.bootcss.com/p/layoutit/)制作文章页面，把代码复制过来。如下图效果：
9. 上面的还都是静态页面，没有model。现在我们开始**建立artile的model及其与其他模型的关联**:   

  -  在命令行输入 `rails g model Article title:string content:text is_public:boolean category:references user:belongs_to`
  - `rails model Category name:string` : Article模型和Category模型是关联模型
  - `rails db:migrate`
  - 在 <kbd>app/models/category.rb</kbd> 添加内容如下
    ```
    class Category < ApplicationRecord
      has_many :articles
    end
    ```
  - 在<kbd>app/models/uesr.rb</kbd> 添加内容如下：
    ```
    class User < ApplicationRecord
      # Include default devise modules. Others available are:
      # :confirmable, :lockable, :timeoutable and :omniauthable
      devise :database_authenticatable, :registerable,
             :recoverable, :rememberable, :trackable, :validatable
      has_many :articles
    end
    ```
  - 在<kbd>db/seeds.rb</kbd> 中添加如下内容
    ```
    Category.find_or_create_by(name: "Science")
    Category.find_or_create_by(name: "Technology")
    Category.find_or_create_by(name: "Engineering")
    Category.find_or_create_by(name: "Art")
    Category.find_or_create_by(name: "Math")
    ```
     在命令行运行 `rails db:seed`  初始化categories表格的数据
  - 完善<kbd>articles_controller.rb</kbd>中的index方法：从数据库中读入数据（C-M的数据交流）
    ```
    def index
      @articles = Article.where(is_public: true).order('created_at DESC')    
    end
    ```
    - 完善 <kbd>app/views/articles/index.html.erb</kbd>
10. 做完article的CRUD功能, 从controller到view的顺序更新。分别是：`show -> edit -> update -> new -> create -> destroy`
- show
  - 分享插件： http://www.jiathis.com
- edit
  - 开源编辑器 simditor： https://github.com/mycolorway/simditor
  - 我以前也没有用过这个插件，自行搜索「rails simditor」以后找到这些教程：
    - http://simditor.tower.im/docs/doc-usage.html
    - http://www.printshit.me/blog/2016/05/30/how-to-use-simditor-in-rails/
    - https://ruby-china.org/topics/28467

6. Comment 实践（Polymorphic Association）
    1. Creating a Single Comment Model
    `rails g model comment content:text commentable_id:integer commentable_type:string`
    2. 修改 migration, 使用多态技巧polymorphic如下：
      ```
    class CreateComments < ActiveRecord::Migration[5.0]
      def change
        create_table :comments do |t|
          t.text :content
          t.belongs_to :commentable, polymorphic: true

          t.timestamps
        end
        add_index :comments, [:commentable_id, :commentable_type]
      end
    end
    ```
    然后 `rails db:migrate`

    http://railscasts.com/episodes/154-polymorphic-association-revised?view=asciicast
    https://rubyplus.com/articles/3901-Polymorphic-Association-in-Rails-5
    https://gorails.com/episodes/comments-with-polymorphic-associations
    https://github.com/gorails-screencasts/gorails-episode-36
