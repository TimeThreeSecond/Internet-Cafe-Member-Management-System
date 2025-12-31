-- 网吧会员管理系统数据库初始化脚本
-- Internet Cafe Member Management System Database Initialization
DROP DATABASE IF EXISTS netbar_management ;
-- 创建数据库
CREATE DATABASE IF NOT EXISTS netbar_management CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE netbar_management;

-- 管理员表
CREATE TABLE IF NOT EXISTS admin (
    admin_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    real_name VARCHAR(50),
    phone VARCHAR(20),
    email VARCHAR(100),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    status TINYINT DEFAULT 1 COMMENT '1-正常 0-禁用'
);

-- 会员表
CREATE TABLE IF NOT EXISTS member (
    member_id INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    nickname VARCHAR(50),
    gender TINYINT COMMENT '1-男 2-女 0-未知',
    phone VARCHAR(20),
    qq VARCHAR(20),
    wechat VARCHAR(50),
    email VARCHAR(100),
    balance DECIMAL(10,2) DEFAULT 0.00,
    points INT DEFAULT 0,
    level INT DEFAULT 1 COMMENT '会员等级',
    total_consumption DECIMAL(10,2) DEFAULT 0.00,
    register_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP,
    status TINYINT DEFAULT 1 COMMENT '1-正常 0-禁用'
);

-- 电脑信息表
CREATE TABLE IF NOT EXISTS computer (
    computer_id INT PRIMARY KEY AUTO_INCREMENT,
    computer_no VARCHAR(20) NOT NULL UNIQUE,
    location VARCHAR(100),
    computer_type TINYINT DEFAULT 1 COMMENT '1-普通 2-包房',
    hourly_rate DECIMAL(5,2) DEFAULT 5.00,
    status TINYINT DEFAULT 0 COMMENT '0-空闲 1-使用中 2-维护中',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 消费记录表
CREATE TABLE IF NOT EXISTS consumption (
    consumption_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    computer_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INT COMMENT '分钟',
    amount DECIMAL(10,2),
    consumption_type TINYINT DEFAULT 1 COMMENT '1-上机 2-包房 3-商品',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id)
);

-- 充值记录表
CREATE TABLE IF NOT EXISTS recharge (
    recharge_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT DEFAULT NULL COMMENT '会员ID，临时卡充值时为NULL',
    amount DECIMAL(10,2),
    recharge_type TINYINT DEFAULT 1 COMMENT '1-现金 2-线上 3-其他',
    operator_id INT,
    remark VARCHAR(255),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (operator_id) REFERENCES admin(admin_id)
    -- 注意：移除了 member_id 的外键约束，允许临时卡充值时 member_id 为 NULL
);

-- 退费记录表
CREATE TABLE IF NOT EXISTS refund (
    refund_id INT PRIMARY KEY AUTO_INCREMENT,
    member_id INT,
    amount DECIMAL(10,2),
    reason VARCHAR(255),
    status TINYINT DEFAULT 0 COMMENT '0-待审批 1-已通过 2-已拒绝',
    operator_id INT,
    process_time TIMESTAMP,
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(member_id),
    FOREIGN KEY (operator_id) REFERENCES admin(admin_id)
);

-- 临时卡表
CREATE TABLE IF NOT EXISTS temp_card (
    card_id VARCHAR(20) PRIMARY KEY,
    balance DECIMAL(10,2) DEFAULT 0.00,
    deposit DECIMAL(10,2) DEFAULT 10.00 COMMENT '押金',
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status TINYINT DEFAULT 1 COMMENT '1-正常 0-已退还'
);

-- 临时卡消费记录表
CREATE TABLE IF NOT EXISTS temp_card_consumption (
    record_id INT PRIMARY KEY AUTO_INCREMENT,
    card_id VARCHAR(20),
    computer_id INT,
    start_time TIMESTAMP,
    end_time TIMESTAMP,
    duration INT COMMENT '分钟',
    amount DECIMAL(10,2),
    create_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (card_id) REFERENCES temp_card(card_id),
    FOREIGN KEY (computer_id) REFERENCES computer(computer_id)
);

-- 插入默认管理员账号
INSERT INTO admin (username, password, real_name, phone, email) VALUES
('admin', 'admin123456', '系统管理员', '13800138000', 'admin@netbar.com'),
('manager', 'manager123', '王经理', '13800138001', 'manager@netbar.com');

-- 插入测试会员账号
INSERT INTO member (username, password, nickname, gender, phone, qq, email, balance, points, level) VALUES
('testuser1', 'user123', '张三', 1, '13800138002', '123456', 'zhangsan@email.com', 100.00, 100, 2),
('testuser2', 'user123', '李四', 1, '13800138003', '234567', 'lisi@email.com', 50.00, 50, 1),
('testuser3', 'user123', '王五', 2, '13800138004', '345678', 'wangwu@email.com', 200.00, 200, 3);

-- 插入电脑信息
INSERT INTO computer (computer_no, location, computer_type, hourly_rate, status) VALUES
('PC001', '大厅A区', 1, 5.00, 0),
('PC002', '大厅A区', 1, 5.00, 0),
('PC003', '大厅B区', 1, 5.00, 0),
('PC004', '大厅B区', 1, 5.00, 0),
('PC005', '包房1', 2, 10.00, 0),
('PC006', '包房2', 2, 10.00, 0),
('PC007', '包房3', 2, 15.00, 0),
('PC008', '大厅C区', 1, 5.00, 0);

-- 插入临时卡
INSERT INTO temp_card (card_id, balance, deposit) VALUES
('TEMP001', 50.00, 10.00),
('TEMP002', 30.00, 10.00),
('TEMP003', 0.00, 10.00);

-- 插入充值记录
INSERT INTO recharge (member_id, amount, recharge_type, operator_id, remark) VALUES
(1, 100.00, 1, 1, '会员充值'),
(2, 50.00, 1, 1, '会员充值'),
(3, 200.00, 2, 1, '线上充值'),
(1, 500.00, 1, 2, '大额充值'),
(2, 30.00, 1, 1, '续费充值'),
(3, 100.00, 2, 1, '活动充值');

-- 插入消费记录
INSERT INTO consumption (member_id, computer_id, start_time, end_time, duration, amount, consumption_type) VALUES
(1, 1, '2024-01-18 14:00:00', '2024-01-18 17:00:00', 180, 25.00, 1),
(1, 5, '2024-01-17 16:00:00', '2024-01-17 22:00:00', 360, 60.00, 2),
(2, 2, '2024-01-17 10:00:00', '2024-01-17 14:30:00', 270, 22.50, 1),
(3, 3, '2024-01-18 09:00:00', '2024-01-18 12:00:00', 180, 25.00, 1),
(1, 1, '2024-01-16 15:00:00', '2024-01-16 19:00:00', 240, 30.00, 1),
(2, 6, '2024-01-16 18:00:00', '2024-01-16 23:00:00', 300, 50.00, 2),
(3, 4, '2024-01-15 10:00:00', '2024-01-15 16:00:00', 360, 40.00, 1);

-- 插入退费申请
INSERT INTO refund (member_id, amount, reason, status, operator_id) VALUES
(1, 200.00, '不再使用', 0, NULL),
(2, 50.00, '临时退费', 0, NULL),
(3, 100.00, '账号注销', 1, 1);

