-- V2: portal permission-key mapping (C-02裁定：独立映射表，代码为权限键单一事实源)
-- 来源：HIA-ASPNETPortal src/Setup/PortalCfg_RolePermissions.sql，按 MySQL 5.7 与 W-hry-P7 裁定转换。
-- 转换说明：
--   1. 外键目标由旧 [Portal_Roles] 改为若依 sys_role（C-04：不照搬旧账号角色表，避免双身份源）。
--   2. SQL Server 特性转换：NVARCHAR -> VARCHAR、DATETIME2 -> DATETIME、SYSUTCDATETIME() -> CURRENT_TIMESTAMP()、ROWVERSION -> 版本号 BIGINT。
--      MySQL 5.7 不允许函数作为列默认值，故 DEFAULT CURRENT_TIMESTAMP()。
--   3. MySQL 5.7 忽略 CHECK（W-hry-P8-CHECK实测记录），权限键非空白改由应用层校验；此处不写 CHECK 约束。
--   4. 不复制任何样例数据、密码哈希与凭据。

CREATE TABLE IF NOT EXISTS PortalCfg_RolePermissions (
    role_id         BIGINT(20)   NOT NULL COMMENT '若依 sys_role.role_id',
    permission_key  VARCHAR(120) NOT NULL COMMENT '权限键：域.对象.动作，语义在代码定义',
    is_enabled      TINYINT(1)   NOT NULL DEFAULT 1 COMMENT '是否启用',
    updated_utc     DATETIME     NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间（UTC，由服务端时区决定）',
    updated_by      VARCHAR(100) NOT NULL DEFAULT 'system' COMMENT '更新人',
    notes           VARCHAR(400) NULL COMMENT '备注',
    row_version     BIGINT(20)   NOT NULL DEFAULT 0 COMMENT '版本号（替代 SQL Server ROWVERSION）',
    PRIMARY KEY (role_id, permission_key),
    KEY idx_permission_key (permission_key),
    CONSTRAINT fk_portal_role_perm_role FOREIGN KEY (role_id) REFERENCES sys_role(role_id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='角色到权限键映射；库只存映射，语义在代码';
