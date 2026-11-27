-- 回滚脚本：V2__portal_cfg_role_permissions.sql 的补偿迁移
-- 机制：Flyway 社区版无 undo；回滚 = 手动执行本脚本 + 迁移前快照恢复（快照不入库）。
-- 存放于 db/rollback/，不被 Flyway 自动扫描（locations 仅 classpath:db/migration）。
-- 执行前须确认：无业务依赖该表；已备份当前库；维护者明确指令。

DROP TABLE IF EXISTS PortalCfg_RolePermissions;
