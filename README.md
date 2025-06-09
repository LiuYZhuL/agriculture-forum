# agriculture-forum

#### 介绍
软件框架Ⅱ

#### 软件架构
软件架构说明

```
├── main/  
│   ├── java/  
│   │   └── com/agriculture/  
│   │       ├── controller/          # 控制层  
│   │       ├── service/             # 服务层接口  
│   │       │   └── impl/            # 服务层实现  
│   │       ├── dao/                 # Mapper接口  
│   │       ├── model/               # 实体类  
│   │       │   ├── vo/              # 视图实体
│   │       │   ├── po/              # 数据库实体
│   │       │   └── dto/             # 数据传输实体  
│   │       ├── exception/           # 自定义异常  
│   │       ├── interceptor/         # 权限拦截器  
│   │       └── util/                # 工具类（文件上传、邮件发送等）  
│   └── resources/   
│           ├── mapper/                  # MyBatis映射文件  
│           ├── spring/                  # Spring配置文件  
│           ├── init.sql                 # 数据库sql
│           ├── mybatis-config.xml  
│           └── log4j2.xml  
├── test/                            # 单元测试  
└── webapp/  
    ├── static/                  # 静态资源  
    │   ├── css/  
    │   ├── js/  
    │   └── uploads/             # 上传文件存储目录  
    │           ├── img/                  # MyBatis映射文件  
    │           └── attachments/         # 附件存储目录 
    │                    ├── img/             # 上传图片存储目录  
    │                    ├── file/             # 上传文件存储目录  
    │                    └── video/             # 上传视频存储目录  
    ├── WEB-INF/  
    │   └── views/               # JSP页面  
    │    
    └── web.xml  
        
```
# 农业论坛系统接口文档

## 用户模块 (UserController)
**基础路径**: `/api/user`

| 接口名称         | 请求方式 | 路径                  | 参数                                                                 | 功能说明                     |
|------------------|----------|-----------------------|----------------------------------------------------------------------|------------------------------|
| 用户登录页面     | GET      | /login                | 无                                                                  | 跳转登录页面                 |
| 用户登录         | POST     | /login                | username, password                                                  | 执行登录操作                 |
| 用户注册页面     | GET      | /register             | 无                                                                  | 跳转注册页面                 |
| 用户注册         | POST     | /register             | username, password, email                                           | 执行注册操作                 |
| 用户注销         | GET      | /logout               | 无                                                                  | 退出登录状态                 |
| 个人中心         | GET      | /home                 | section(可选)                                                       | 查看收藏帖子和知识           |
| 密码重置页面     | GET      | /reset                | 无                                                                  | 跳转密码重置页面             |
| 密码重置         | POST     | /reset                | username, email                                                     | 通过邮箱重置密码             |
| 头像修改         | POST     | /avatar               | avatar文件                                                          | 上传新头像                   |
| 个人信息修改     | POST     | /update               | username, email                                                     | 更新用户基本信息             |
| 密码修改         | POST     | /change               | password, newPassword                                               | 修改账户密码                 |
| 用户帖子管理     | GET      | /post                 | pageNum, pageSize, title, sts, categoryId                           | 分页查询用户发布的帖子       |
| 用户知识管理     | GET      | /knowledge            | pageNum, pageSize, ktitle, ksts, kcategory                          | 分页查询用户发布的知识       |
| 用户评论管理     | GET      | /comment              | pageNum, pageSize                                                   | 查看用户发表的评论           |
| 积分计算         | GET      | /score                | 无                                                                  | 计算用户互动积分             |

## 管理员模块 (AdminController)
**基础路径**: `/api/admin`

| 接口名称         | 请求方式 | 路径                      | 参数                          | 功能说明                     |
|------------------|----------|---------------------------|-------------------------------|------------------------------|
| 用户修改页面     | GET      | /user/update              | userId                        | 跳转用户信息修改页           |
| 用户信息更新     | POST     | /user/update              | id, avatar, username, roleId  | 更新用户详细信息             |
| 密码重置         | GET      | /user/reset               | userId                        | 管理员重置用户密码           |
| 分类删除         | DELETE   | /category/delete          | categoryId                    | 删除指定分类                 |
| 分类新增         | POST     | /category/add             | categoryName, categoryDesc    | 创建新分类                   |
| 分类修改页面     | GET      | /category/update          | categoryId                    | 跳转分类修改页               |
| 分类修改         | POST     | /category/update          | id, name, description         | 更新分类信息                 |

## 帖子模块 (PostController)
**基础路径**: `/api/post`

| 接口名称         | 请求方式 | 路径                  | 参数                                      | 功能说明                     |
|------------------|----------|-----------------------|-------------------------------------------|------------------------------|
| 帖子创建         | POST     | /add                  | title, content, categoryId, attachments   | 创建新帖子                   |
| 帖子删除         | DELETE   | /delete/{postId}      | 无                                        | 删除指定帖子                 |
| 帖子详情         | GET      | /detail               | postId                                    | 查看帖子详情                 |
| 状态修改         | POST     | /status               | postId, status                            | 更新帖子状态                 |
| 置顶设置         | POST     | /top                  | postId, isTop                             | 设置帖子置顶                 |
| 精华设置         | POST     | /essence              | postId, isEssence                         | 设置精华帖子                 |
| 修改页面         | GET      | /update               | postId                                    | 跳转帖子修改页               |
| 内容更新         | POST     | /update               | postId, title, content, attachments       | 更新帖子内容                 |
| 点赞操作         | POST     | /like                 | postId                                    | 点赞/取消点赞                |
| 收藏操作         | POST     | /collect              | postId                                    | 收藏/取消收藏                |
| 帖子列表         | GET      | /more                 | 无                                        | 跳转帖子列表页               |
| 帖子搜索         | GET      | /search               | page, size, keyword, category             | 分页搜索帖子                 |

## 知识模块 (KnowledgeController)
**基础路径**: `/api/knowledge`

| 接口名称         | 请求方式 | 路径                      | 参数                                      | 功能说明                     |
|------------------|----------|---------------------------|-------------------------------------------|------------------------------|
| 知识创建         | POST     | /add                      | title, content, categoryId, attachments   | 创建新知识条目               |
| 知识详情         | GET      | /detail                   | postId                                    | 查看知识详情                 |
| 知识列表         | GET      | /more                     | 无                                        | 跳转知识列表页               |
| 知识搜索         | GET      | /search                   | page, size, keyword, category             | 分页搜索知识                 |
| 知识删除         | DELETE   | /delete/{postId}          | 无                                        | 删除指定知识                 |
| 状态修改         | GET      | /status                   | postId, status                            | 更新审核状态                 |
| 置顶设置         | GET      | /top                      | postId, isTop                             | 设置知识置顶                 |
| 精华设置         | GET      | /essence                  | postId, isEssence                         | 设置精华知识                 |

## 评论模块 (CommentController)
**基础路径**: `/api/comment`

| 接口名称         | 请求方式 | 路径                  | 参数                                      | 功能说明                     |
|------------------|----------|-----------------------|-------------------------------------------|------------------------------|
| 评论添加         | POST     | /add                  | postId, userId, content, parentId(可选)  | 添加主评论/子评论            |
| 分页查询         | GET      | /page                 | postId, page, size                        | 获取分页的树形结构评论       |
| 评论删除         | DELETE   | /delete/{commentId}   | 无                                        | 删除指定评论                 |

## 根路径模块 (RootController)

| 接口名称         | 请求方式 | 路径              | 参数  | 功能说明                     |
|------------------|----------|-------------------|-------|------------------------------|
| 首页入口         | GET      | /                 | 无    | 展示精华帖子和知识           |
| 仪表盘           | GET      | /api/dashboard    | 无    | 同首页入口                   |
| 头部导航         | GET      | /api/header       | 无    | 获取头部导航信息             |

## 管理界面模块 (ManageController)
**基础路径**: `/api/admin/manage`

| 接口名称         | 请求方式 | 路径                  | 参数                                      | 功能说明                     |
|------------------|----------|-----------------------|-------------------------------------------|------------------------------|
| 用户管理         | GET      | /usermgt              | pageNum, pageSize, username, roleId       | 分页用户管理                 |
| 分类管理         | GET      | /categorymgt          | pageNum, pageSize, searchCategory         | 分类列表管理                 |
| 帖子管理         | GET      | /postmgt              | pageNum, pageSize, title, status          | 帖子审核管理                 |
| 知识管理         | GET      | /knowledgemgt         | pageNum, pageSize, ktitle, kcategory      | 知识条目管理                 |




# 数据库设计：
## role 角色表：
| 列名          | 数据类型         | 约束      | 描述    |
|-------------|--------------|---------|-------|
| id          | INT          | PRIMARY | 角色id    |
| name        | VARCHAR(20)  | UNIQUE  | 角色权限名 |
| description | VARCHAR(255) |         | 角色描述    |

##### user 用户表：
| 列名              | 数据类型         | 约束      | 描述            |
|-----------------|--------------|---------|---------------|
| id              | INT          | PRIMARY | 用户id          |
| username        | VARCHAR(50)  | UNIQUE  | 用户名           |
| password        | VARCHAR(255) | NOT NULL | 加密密码          |
| email           | VARCHAR(100) | UNIQUE  | 邮箱            |
| avatar          | VARCHAR(255) |         | 头像URL         |
| role_id         | INT          | FOREIGN | 角色id          |
| status          | TINYINT      |         | 状态：0-封禁, 1-正常 |
|score            | DECIMAL(10, 2) |NOT NULL | 用户积分          |
| create_time     | DATETIME     |         | 注册时间          |
| last_login_time | DATETIME     |         | 最后登录时间        |

## category 分类表：
| 列名          | 数据类型         | 约束       | 描述           |
|-------------|--------------|----------|--------------|
| id`         | INT          | PRIMARY  | 分类id         |
| name        | VARCHAR(50)  | NOT NULL | 分类名称（如种植/养殖） |
| description | VARCHAR(255) |          | 分类描述         |

## post 帖子表：
| 列名          | 数据类型         | 约束        | 描述                     |
|-------------|--------------|-----------|------------------------|
| id          | INT          | PRIMARY   | 帖子id                   |
| user_id     | INT          | FOREIGN   | 发帖用户id                 |
| category_id | INT          | FOREIGN   | 分类id                   |
| title       | VARCHAR(255) | NOT NULL  | 标题                     |
| content     | TEXT         | NOT NULL  | 正文内容                   |
| status      | TINYINT      | DEFAULT 0 | 状态：0-待审核, 1-已发布, 2-已拒绝 |
| is_top      | TINYINT      | DEFAULT 0 | 是否置顶（0否, 1是）           |
| is_essence  | TINYINT      | DEFAULT 0 | 是否精华帖（0否, 1是）          |
| is_settlement | TINYINT      | DEFAULT 0 | 是否结算（0否, 1是）          |
| create_time | DATETIME     |           | 创建时间                   |
| update_time | DATETIME |           | 最后更新时间 |
| view_count  | INT      | DEFAULT 0 | 浏览数    |

## comment 评论表：
| 列名          | 数据类型     | 约束      | 描述            |
|-------------|----------|---------|---------------|
| id          | INT      | PRIMARY | 评论id          |
| post_id     | INT      | FOREIGN | 所属帖子ID        |
| user_id     | INT      | FOREIGN | 评论者ID         |
| content     | TEXT     |         | 评论内容          |
| parent_id   | INT      | FOREIGN | 父评论ID（实现二级回复） |
| create_time | DATETIME |         | 评论时间          |

## interaction 用户行为表：
| 列名          | 数据类型     | 约束       | 描述            |
|-------------|----------|----------|---------------|
| id          | INT      | PRIMARY  | 行为id          |
| post_id     | INT      | FOREIGN  | 帖子ID          |
| user_id     | INT      | FOREIGN  | 用户ID          |
| type        | TINYINT  | NOT NULL | 类型：1-点赞, 2-收藏 |
| create_time | DATETIME |          | 互动时间          |


## attachment 附件表：
| 列名          | 数据类型         | 约束       | 描述                          |
|-------------|--------------|----------|-----------------------------|
| id          | INT          | PRIMARY  | 附件id                        |
| post_id     | INT          | FOREIGN  | 关联帖子ID                      |
| file_path   | VARCHAR(255) | NOT NULL | 文件存储路径                      |
| file_type   | VARCHAR(50)  |          | 文件类型（image/jpeg, video/mp4） |
| upload_time | DATETIME     |          | 上传时间                        |

## audit_log 审核日志表：
| 列名         | 数据类型         | 约束       | 描述            |
|------------|--------------|----------|---------------|
| id         | INT          | PRIMARY  | 日志id          |
| post_id    | INT          | FOREIGN  | 被审核帖子ID       |
| auditor_id | INT          | FOREIGN  | 审核人ID         |
| action     | TINYINT      | NOT NULL | 操作：1-通过, 2-拒绝 |
| audit_time | DATETIME     |          | 审核时间          |
| reason     | VARCHAR(255) |          | 审核意见（拒绝时填写）   |





#### 安装教程

1.  xxxx
2.  xxxx
3.  xxxx

#### 使用说明

1.  xxxx
2.  xxxx
3.  xxxx

#### 参与贡献

1.  Fork 本仓库
2.  新建 Feat_xxx 分支
3.  提交代码
4.  新建 Pull Request


#### 特技

1.  使用 Readme\_XXX.md 来支持不同的语言，例如 Readme\_en.md, Readme\_zh.md
2.  Gitee 官方博客 [blog.gitee.com](https://blog.gitee.com)
3.  你可以 [https://gitee.com/explore](https://gitee.com/explore) 这个地址来了解 Gitee 上的优秀开源项目
4.  [GVP](https://gitee.com/gvp) 全称是 Gitee 最有价值开源项目，是综合评定出的优秀开源项目
5.  Gitee 官方提供的使用手册 [https://gitee.com/help](https://gitee.com/help)
6.  Gitee 封面人物是一档用来展示 Gitee 会员风采的栏目 [https://gitee.com/gitee-stars/](https://gitee.com/gitee-stars/)
