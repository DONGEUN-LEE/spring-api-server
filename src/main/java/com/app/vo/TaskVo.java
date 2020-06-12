package com.app.vo;

import java.time.LocalDateTime;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PUBLIC)
public class TaskVo {
  private String key;
  private String text;
  private PlanVo item;
  private LocalDateTime startTime;
  private LocalDateTime endTime;
  private int level;
  private String backgroundColor;
  private String borderColor;
  private String tooltip;
}
