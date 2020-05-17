package com.app.vo;

import java.time.LocalDateTime;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity(name = "plan")
public class PlanVo {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long planNo;
  private String siteId;
  private String stageId;
  private String operId;
  private String resourceId;
  private String productId;
  private int planQty;
  private LocalDateTime startTime;
  private LocalDateTime endTime;
}
