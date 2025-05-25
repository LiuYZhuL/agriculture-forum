package com.agriculture.dao;

import com.agriculture.model.po.AuditLog;
import org.apache.ibatis.annotations.Mapper;

import java.util.List;

@Mapper
public interface AuditLogMapper {
    int insertAuditLog(AuditLog auditLog);
    void batchInsertAuditLog(List<AuditLog> auditLogs);
    void deleteAuditLogById(Integer id);
    void deleteAuditLogByPostId(Integer postId);
    void updateAuditLog(AuditLog auditLog);
    AuditLog selectAuditLogById(Integer id);
    List<AuditLog> selectAuditLogByPostId(Integer postId);
    List<AuditLog> selectAuditLogByAuditorId(Integer auditorId);
    List<AuditLog> selectAuditLogByAction(String action);
    List<AuditLog> selectAuditLogByCondition(AuditLog auditLog);
    int countAuditLog();
    AuditLog selectLatestAuditLogByPostId(Integer postId);

}
