package com.app.vo;

import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PUBLIC)
public class StepRouteVo {
  private String from;
  private String to;
  private String product;
  private int seq;
}
