# 网吧会员管理系统 - 项目工作分解与网页清单
# Internet Cafe Member Management System

## 一、 项目概述
基于Bootstrap、HTML5、JavaScript、JQuery、CSS、Servlet、JSP、MySQL等技术栈，开发一个具备会员管理、充值消费、设备管理等核心功能的网吧会员管理系统。项目采用6人小组协作模式，需实现管理员与普通会员两类用户角色及相应功能模块[1,6](@ref)。

## 二、 技术栈明细
- **前端技术**: Bootstrap（响应式布局）[1,3](@ref)、HTML5、JavaScript、JQuery、CSS
- **后端技术**: Servlet、JSP
- **数据库**: MySQL 8.0[1,3](@ref)
- **开发工具**: IntelliJ IDEA 2024.3[1,3](@ref)（数据库管理）
- **服务器**: Tomcat 8.0+[1,3](@ref)

## 三、 功能模块分解
### 1. 公共模块
- **用户注册与登录**[1,6](@ref)
   - 管理员账号：初始化固定（不开放注册）
   - 普通会员注册：字段包括用户名、昵称、密码、联系方式（电话/QQ/微信/邮箱）、性别等[6](@ref)
- **首页与个人中心**[1,6](@ref)
   - 首页展示网吧信息、功能导航
   - 个人中心支持信息修改（密码、联系方式等）

### 2. 管理员模块[1,6,7](@ref)
- **会员管理**
   - 会员信息查看与搜索（按等级、电话、性别等）
   - 会员列表展示（账户名、等级、消费金额等）
   - 会员详情页面跳转
- **充值与资金管理**
   - 线下充值（临时卡充值、会员卡充值）
   - 资金统计（当日/当月收入清单、退费统计）
- **设备与上机管理**[1,7](@ref)
   - 开机/包房功能（资金划转、账单同步）
   - 电脑状态监控（空闲/使用中）
- **退费流程**
   - 退费审批列表
   - 人工退费（会员/临时卡退费）

### 3. 会员模块[1,6](@ref)
- **个人信息管理**：修改账户名、密码、联系方式
- **消费查询**：按日期、类型（包时/包房）检索消费记录
- **线上充值**：模拟支付流程，更新账户余额
- **退费申请**：发起退费请求，显示余额信息

### 4. 数据库设计[4,7](@ref)
- **核心表结构**：
   - 会员表（会员账号、密码、余额、积分、注册时间等）[4,7](@ref)
   - 电脑信息表（电脑编号、状态、位置、费用）[7](@ref)
   - 消费记录表（上机时间、费用、充值记录等）[7](@ref)
   - 管理员表（账号、密码、权限）[4](@ref)
- **初始化文件**：提供SQL脚本创建表及初始数据[3](@ref)

## 四、 开发与交付清单
### 1. 项目文档（组长负责讲解）[1](@ref)
- **技术栈说明**：Servlet/JSP+MySQL+Bootstrap架构
- **模块划分图**：绘制系统功能模块图[1,6](@ref)
- **任务分配表**：明确各组员负责的模块（如会员管理、充值模块等）
- **问题总结**：开发中遇到的典型问题及解决方案（如数据库连接、权限控制）

### 2. 源码与配置[3](@ref)
- **包结构规范**：
   - `com.example.controller`（Servlet层）
   - `com.example.service`（业务逻辑层）
   - `com.example.dao`（数据库操作层）
   - `WebContent/`（JSP/HTML/CSS/JS文件）
- **配置文件**：`web.xml`、数据库连接配置、Bootstrap资源引用

### 3. 演示准备[1,6](@ref)
- **功能演示流程**：
   1. 会员注册与登录
   2. 管理员搜索会员、充值、开机结算
   3. 会员消费查询、线上充值
   4. 资金统计报表展示
- **自适应界面验证**：在不同屏幕尺寸下测试页面布局[3](@ref)

## 五、 参考网页资源清单
1. **系统功能设计参考**：[1,6](@ref)（会员管理、电脑管理、充值模块）
2. **数据库表结构参考**：[4,7](@ref)（会员表、电脑表、消费记录表）
3. **界面设计参考**：[1,3](@ref)（Bootstrap响应式布局、登录/首页样式）
4. **项目架构参考**：[3,6](@ref)（SSM框架替代方案中的分层思路）
5. **流程逻辑参考**：[1,7](@ref)（上机/下机流程、充值退费流程）

## 六， 参考项目树
<div class="tree">
            <ul class="tree-root">
                <li class="folder open">
                    <div><span class="toggle"></span>Internet-Cafe-Member-Management-System/ <span class="file-path">项目根目录</span></div>
                    <ul>
                        <li class="folder open">
                            <div><span class="toggle"></span>src/ <span class="file-path">Java源代码目录</span></div>
                            <ul>
                                <li class="folder">
                                    <div><span class="toggle"></span>com/</div>
                                    <ul>
                                        <li class="folder">
                                            <div><span class="toggle"></span>yourcompany/</div>
                                            <ul>
                                                <li class="folder open">
                                                    <div><span class="toggle"></span>netbarmanager/ <span class="file-path">主包</span></div>
                                                    <ul>
                                                        <li class="package">
                                                            <div><span class="toggle"></span>controller/ <span class="file-path">控制层 (Servlet)</span></div>
                                                        </li>
                                                        <li class="package">
                                                            <div><span class="toggle"></span>service/ <span class="file-path">业务逻辑层</span></div>
                                                        </li>
                                                        <li class="package">
                                                            <div><span class="toggle"></span>dao/ <span class="file-path">数据访问层</span></div>
                                                        </li>
                                                        <li class="package">
                                                            <div><span class="toggle"></span>bean/ <span class="file-path">实体类 (JavaBean)</span></div>
                                                        </li>
                                                        <li class="package">
                                                            <div><span class="toggle"></span>util/ <span class="file-path">工具类</span></div>
                                                        </li>
                                                    </ul>
                                                </li>
                                            </ul>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li class="folder open">
                            <div><span class="toggle"></span>WebContent/ <span class="file-path">Web应用根目录</span></div>
                            <ul>
                                <li class="folder">
                                    <div><span class="toggle"></span>css/ <span class="file-path">层叠样式表文件</span></div>
                                </li>
                                <li class="folder">
                                    <div><span class="toggle"></span>js/ <span class="file-path">JavaScript脚本文件</span></div>
                                </li>
                                <li class="folder">
                                    <div><span class="toggle"></span>img/ <span class="file-path">图像资源</span></div>
                                </li>
                                <li class="folder">
                                    <div><span class="toggle"></span>lib/ <span class="file-path">前端第三方库</span></div>
                                </li>
                                <li class="folder open">
                                    <div><span class="toggle"></span>WEB-INF/ <span class="file-path">受保护目录</span></div>
                                    <ul>
                                        <li class="config">
                                            <div><span class="toggle"></span>web.xml <span class="file-path">Web应用部署描述文件</span></div>
                                        </li>
                                        <li class="folder">
                                            <div><span class="toggle"></span>lib/ <span class="file-path">Java第三方依赖包</span></div>
                                        </li>
                                    </ul>
                                </li>
                                <li class="folder open">
                                    <div><span class="toggle"></span>pages/ <span class="file-path">动态视图文件 (JSP)</span></div>
                                    <ul>
                                        <li class="folder">
                                            <div><span class="toggle"></span>admin/ <span class="file-path">管理员功能相关页面</span></div>
                                        </li>
                                        <li class="folder">
                                            <div><span class="toggle"></span>member/ <span class="file-path">会员功能相关页面</span></div>
                                        </li>
                                    </ul>
                                </li>
                            </ul>
                        </li>
                        <li class="file">
                            <div><span class="toggle"></span>README.md <span class="file-path">项目说明文档</span></div>
                        </li>
                        <li class="file">
                            <div><span class="toggle"></span>pom.xml <span class="file-path">Maven配置文件</span></div>
                        </li>
                    </ul>
                </li>
            </ul>
        </div>

## 七，注意事项
1. Bootstrap需要直接在线调用，不允许下载到本地
2. 项目树中的文件为空则仅创建文件夹即可
3. 仅允许查询或修改C:\Users\27453\vscode javafiles\Internet Cafe Member Management System目录下的文件，其他文件不允许操作
4. 完成工作后创建说明工作记录的报告markdown文件放在Internet Cafe Member Management System目录下供我检查
5. 生成默认管理员账号和默认用户账号供我测试，将账号写入报告中