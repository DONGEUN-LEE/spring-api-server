package com.app.vo;

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
@Entity(name = "route")
public class RouteVo {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long routeNo;
  private String fromProductId;
  private String fromOperId;
  private String toProductId;
  private String operId;
}
