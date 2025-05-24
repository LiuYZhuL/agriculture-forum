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
│   │       │   ├── po/              # 数据库实体
│   │       │   └── dto/             # 数据传输实体  
│   │       ├── config/              # 配置类（Spring、MyBatis）  
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
    ├── WEB-INF/  
    │   └── views/               # JSP页面  
    │    
    └── web.xml  
        
```

#### 数据库设计：
##### role 角色表：
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
| create_time     | DATETIME     |         | 注册时间          |
| last_login_time | DATETIME     |         | 最后登录时间        |

##### category 分类表：
| 列名          | 数据类型         | 约束       | 描述           |
|-------------|--------------|----------|--------------|
| id`         | INT          | PRIMARY  | 分类id         |
| name        | VARCHAR(50)  | NOT NULL | 分类名称（如种植/养殖） |
| description | VARCHAR(255) |          | 分类描述         |

##### post 帖子表：
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
| create_time | DATETIME     |           | 创建时间                   |
| update_time | DATETIME |           | 最后更新时间 |
| view_count  | INT      | DEFAULT 0 | 浏览数    |

##### comment 评论表：
| 列名          | 数据类型     | 约束      | 描述            |
|-------------|----------|---------|---------------|
| id          | INT      | PRIMARY | 评论id          |
| post_id     | INT      | FOREIGN | 所属帖子ID        |
| user_id     | INT      | FOREIGN | 评论者ID         |
| content     | TEXT     |         | 评论内容          |
| parent_id   | INT      | FOREIGN | 父评论ID（实现二级回复） |
| create_time | DATETIME |         | 评论时间          |

##### interaction 用户行为表：
| 列名          | 数据类型     | 约束       | 描述            |
|-------------|----------|----------|---------------|
| id          | INT      | PRIMARY  | 行为id          |
| post_id     | INT      | FOREIGN  | 帖子ID          |
| user_id     | INT      | FOREIGN  | 用户ID          |
| type        | TINYINT  | NOT NULL | 类型：1-点赞, 2-收藏 |
| create_time | DATETIME |          | 互动时间          |


##### attachment 附件表：
| 列名          | 数据类型         | 约束       | 描述                          |
|-------------|--------------|----------|-----------------------------|
| id          | INT          | PRIMARY  | 附件id                        |
| post_id     | INT          | FOREIGN  | 关联帖子ID                      |
| file_path   | VARCHAR(255) | NOT NULL | 文件存储路径                      |
| file_type   | VARCHAR(50)  |          | 文件类型（image/jpeg, video/mp4） |
| upload_time | DATETIME     |          | 上传时间                        |

##### audit_log 审核日志表：
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
