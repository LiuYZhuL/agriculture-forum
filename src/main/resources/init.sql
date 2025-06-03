create database if not exists agriculture_forum;

use agriculture_forum;

-- 1. 角色表：区分用户权限
CREATE TABLE `role` (
                        `id` INT PRIMARY KEY AUTO_INCREMENT,
                        `name` VARCHAR(20) NOT NULL UNIQUE COMMENT '角色名称（user/expert/admin）',
                        `description` VARCHAR(255) COMMENT '角色描述'
);

-- 初始角色数据
INSERT INTO `role` (name, description) VALUES
                                           ('user', '普通用户：发帖、评论、互动'),
                                           ('admin', '系统管理员：管理用户、分类、全局设置');

-- 2. 用户表：存储用户基本信息
CREATE TABLE `user` (
                        `id` INT PRIMARY KEY AUTO_INCREMENT,
                        `username` VARCHAR(50) UNIQUE NOT NULL COMMENT '用户名',
                        `password` VARCHAR(255) NOT NULL COMMENT '加密后的密码',
                        `email` VARCHAR(100) UNIQUE NOT NULL COMMENT '邮箱',
                        `avatar` VARCHAR(255) DEFAULT 'default_avatar.png' COMMENT '头像路径',
                        `role_id` INT NOT NULL DEFAULT 1 COMMENT '角色ID',
                        `status` TINYINT DEFAULT 1 COMMENT '状态：0-封禁, 1-正常',
                        `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '注册时间',
                        `last_login_time` DATETIME COMMENT '最后登录时间',

                        FOREIGN KEY (`role_id`) REFERENCES `role`(`id`)
);

-- 3. 分类表：支持多级农业知识分类
CREATE TABLE `category` (
                            `id` INT PRIMARY KEY AUTO_INCREMENT,
                            `name` VARCHAR(50) NOT NULL COMMENT '分类名称（如种植/养殖）',
                            `description` VARCHAR(255) COMMENT '分类描述'
);

-- 4. 帖子表：核心内容存储
CREATE TABLE `post` (
                        `id` INT PRIMARY KEY AUTO_INCREMENT,
                        `user_id` INT NOT NULL COMMENT '发帖用户ID',
                        `category_id` INT NOT NULL COMMENT '所属分类ID',
                        `title` VARCHAR(255) NOT NULL COMMENT '标题',
                        `content` TEXT NOT NULL COMMENT '正文内容',
                        `status` TINYINT DEFAULT 0 COMMENT '状态：0-待审核, 1-已发布, 2-已拒绝',
                        `is_top` TINYINT DEFAULT 0 COMMENT '是否置顶（0否, 1是）',
                        `is_essence` TINYINT DEFAULT 0 COMMENT '是否精华帖（0否, 1是）',
                        `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
                        `update_time` DATETIME ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
                        `view_count` INT DEFAULT 0 COMMENT '浏览数',

                        FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
                        FOREIGN KEY (`category_id`) REFERENCES `category`(`id`)
);

-- 5. 评论表：支持层级化讨论
CREATE TABLE `comment` (
                           `id` INT PRIMARY KEY AUTO_INCREMENT,
                           `post_id` INT NOT NULL COMMENT '所属帖子ID',
                           `user_id` INT NOT NULL COMMENT '评论者ID',
                           `content` TEXT NOT NULL COMMENT '评论内容',
                           `parent_id` INT DEFAULT NULL COMMENT '父评论ID（实现二级回复）',
                           `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '评论时间',
                           FOREIGN KEY (`post_id`) REFERENCES `post`(`id`),
                           FOREIGN KEY (`user_id`) REFERENCES `user`(`id`),
);

-- 6. 互动表：记录用户点赞/收藏行为
CREATE TABLE `interaction` (
                               `id` INT PRIMARY KEY AUTO_INCREMENT,
                               `post_id` INT NOT NULL COMMENT '帖子ID',
                               `user_id` INT NOT NULL COMMENT '用户ID',
                               `type` TINYINT NOT NULL COMMENT '类型：1-点赞, 2-收藏',
                               `create_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '互动时间',
                               UNIQUE KEY `uniq_interaction` (`post_id`,`user_id`,`type`), -- 防止重复互动
                               FOREIGN KEY (`post_id`) REFERENCES `post`(`id`),
                               FOREIGN KEY (`user_id`) REFERENCES `user`(`id`)
);

-- 7. 附件表：存储帖子相关多媒体文件
CREATE TABLE `attachment` (
                              `id` INT PRIMARY KEY AUTO_INCREMENT,
                              `post_id` INT NOT NULL COMMENT '关联帖子ID',
                              `file_path` VARCHAR(255) NOT NULL COMMENT '文件存储路径',
                              `file_type` VARCHAR(50) COMMENT '文件类型（image/jpeg, video/mp4）',
                              `upload_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '上传时间',
                              FOREIGN KEY (`post_id`) REFERENCES `post`(`id`)
);

-- 8. 审核日志表：记录管理员/专家的审核操作
CREATE TABLE `audit_log` (
                             `id` INT PRIMARY KEY AUTO_INCREMENT,
                             `post_id` INT NOT NULL COMMENT '被审核帖子ID',
                             `auditor_id` INT NOT NULL COMMENT '审核人ID',
                             `action` TINYINT NOT NULL COMMENT '操作：1-通过, 2-拒绝',
                             `audit_time` DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '审核时间',
                             `reason` VARCHAR(255) COMMENT '审核意见（拒绝时填写）',
                             FOREIGN KEY (`post_id`) REFERENCES `post`(`id`),
                             FOREIGN KEY (`auditor_id`) REFERENCES `user`(`id`)
);

alter table `user` add column `score` decimal(10, 2) default 0.00 not null comment '用户积分';
alter table `post` add column `is_settlement` TINYINT DEFAULT 0 COMMENT '是否结算（0否, 1是）';
