package com.agriculture.model.po;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import java.util.Date;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class AuditLog {

    private Integer id;

    private Integer postId;


    private Integer auditorId;

    private Integer action; // 1-通过 2-拒绝

    private Date auditTime;

    private String reason;
    public static final Integer ACTION_PASS = 1;
    public static final Integer ACTION_REJECT = 2;
}