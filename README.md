# 网吧会员管理系统 (Internet Cafe Member Management System)

## 项目简介

本项目是一个基于Java Web技术栈开发的网吧会员管理系统，实现了会员管理、设备管理、上机管理、退费管理等核心功能。系统采用B/S架构，使用Servlet+JSP技术实现，前端采用Bootstrap框架实现响应式设计。

## 技术栈

### 后端技术
- Java 8
- Servlet 4.0.1
- JSP 2.3.3
- JSTL 1.2
- MySQL 8.0

### 前端技术
- HTML5
- CSS3
- JavaScript
- Bootstrap 5.1.3
- jQuery 3.6.0
- Font Awesome 6.0.0

### 开发工具
- IntelliJ IDEA 2024.3
- Apache Tomcat 8.0+
- Maven 3.6+

## 系统功能

### 公共模块
- 用户注册与登录
- 首页导航
- 个人中心

### 管理员功能（已实现）
- 会员管理（查看、搜索、编辑、删除）
- 设备管理（电脑列表、添加、编辑、删除、状态管理）
- 上机管理（开机上机、下机结算、费用计算）
- 退费管理（退费申请审批、处理）
- 统计报表（日统计、月统计、会员等级分布）
- 首页统计（会员总数、今日收入、上机电脑数、待处理退费数）

### 会员功能（已实现）
- 个人信息管理
- 会员中心首页
- 消费记录查询（按日期、类型筛选）
- 退费申请提交

### 充值功能
- 充值功能正在重写中，当前显示"即将上线"页面

### 待实现功能
- 修改密码功能
- 临时卡消费记录功能

## 数据库设计

系统包含以下主要数据表：
- `admin` - 管理员表
- `member` - 会员表
- `computer` - 电脑信息表
- `consumption` - 消费记录表
- `recharge` - 充值记录表
- `refund` - 退费记录表
- `temp_card` - 临时卡表
- `temp_card_consumption` - 临时卡消费记录表

## 项目结构

```
Internet Cafe Member Management System/
├── src/                                    # Java源代码目录
│   └── main/
│       ├── java/
│       │   └── com/yourcompany/netbarmanager/
│       │       ├── controller/             # 控制层(Servlet)
│       │       ├── service/                # 业务逻辑层
│       │       ├── dao/                    # 数据访问层
│       │       ├── bean/                   # 实体类(JavaBean)
│       │       ├── util/                   # 工具类
│       │       └── filter/                 # 过滤器
│       └── webapp/
│           ├── pages/                      # 动态视图文件(JSP)
│           │   ├── admin/                  # 管理员功能相关页面
│           │   ├── member/                 # 会员功能相关页面
│           │   ├── common/                 # 公共页面
│           │   └── error/                  # 错误页面
│           ├── WEB-INF/
│           │   └── web.xml                 # Web应用配置
│           ├── css/                        # CSS样式文件
│           └── js/                         # JavaScript文件
├── database_init.sql                       # 数据库初始化脚本
├── pom.xml                                 # Maven配置文件
└── README.md                               # 项目说明文档
```

## 项目完成度

| 层级 | 总规划 | 已实现 | 未实现 | 完成率 |
|-----|--------|--------|--------|--------|
| Bean实体类 | 7 | 7 | 0 | 100% |
| DAO层 | 8 | 7 | 1 | 87.5% |
| Service层 | 6 | 3 | 3 | 50% |
| Controller层 | 16 | 15 | 1 | 93.75% |
| JSP页面 | 18 | 18 | 0 | 100% |
| **总体** | **55** | **50** | **5** | **90.9%** |

## 部署说明

### 环境要求
- JDK 8 或以上版本
- MySQL 8.0 或以上版本
- Apache Tomcat 8.0 或以上版本

### 部署步骤

1. **数据库配置**
   ```sql
   -- 创建数据库
   CREATE DATABASE netbar_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

   -- 导入数据
   mysql -u root -p netbar_management < database_init.sql
   ```

2. **修改数据库连接配置**
   编辑 `src/main/java/com/yourcompany/netbarmanager/util/DBUtil.java` 文件，修改数据库连接信息：
   ```java
   private static final String URL = "jdbc:mysql://localhost:3306/netbar_management?useSSL=false&serverTimezone=UTC&characterEncoding=utf8";
   private static final String USERNAME = "root";
   private static final String PASSWORD = "your_password";
   ```

3. **编译项目**
   ```bash
   mvn clean compile
   ```

4. **打包项目**
   ```bash
   mvn clean package
   ```

5. **部署到Tomcat**
   - 将生成的 `Internet_Cafe_Member_Management_System-1.0-SNAPSHOT.war` 文件复制到Tomcat的webapps目录
   - 启动Tomcat服务器

6. **访问系统**
   打开浏览器访问：http://localhost:8080/Internet_Cafe_Member_Management_System-1.0-SNAPSHOT/

## 测试账号

### 管理员账号
- 用户名：admin
- 密码：admin123456
- 真实姓名：系统管理员

- 用户名：manager
- 密码：manager123
- 真实姓名：王经理

### 会员账号
- 用户名：testuser1
- 密码：user123
- 昵称：张三

- 用户名：testuser2
- 密码：user123
- 昵称：李四

- 用户名：testuser3
- 密码：user123
- 昵称：王五

### 临时卡
- 卡号：TEMP001，余额：¥50.00
- 卡号：TEMP002，余额：¥30.00
- 卡号：TEMP003，余额：¥0.00

## 开发团队

本项目由单人开发，采用标准的MVC分层架构，代码结构清晰，便于维护和扩展。
使用Claude + GLM-4模型进行开发

## 注意事项

1. Bootstrap框架通过CDN在线调用，确保网络连接正常
2. 数据库默认字符集为utf8mb4，支持存储emoji表情
3. 系统默认Session超时时间为30分钟
4. 建议在生产环境中修改默认管理员密码
5. 充值功能正在重写中，当前显示"即将上线"占位页面

## 联系方式

如有问题或建议，请联系开发团队。

---

*项目创建时间：2024年12月18日*
*最后更新：2026年1月2日*
*项目完成度：90.9%*
