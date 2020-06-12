package com.app.vo;

import java.util.ArrayList;
import java.util.List;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class RowVo implements Comparable<RowVo> {
  private String siteId;
  private String stageId;
  private String operId;
  private String resourceId;
  private int maxLevel;
  private List<TaskVo> tasks;

  public RowVo() {
    this.tasks = new ArrayList<TaskVo>();
  }

  @Override
  public int compareTo(RowVo o) {
    int result = this.getSiteId().compareTo(o.getSiteId());
    if (result == 0) {
      result = this.getStageId().compareTo(o.getStageId());
      if (result == 0) {
        result = this.getOperId().compareTo(o.getOperId());
        if (result == 0) {
          result = this.getResourceId().compareTo(o.getResourceId());
        }
      }
    }
    return result;
  }
}
