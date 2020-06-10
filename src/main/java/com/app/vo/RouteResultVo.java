package com.app.vo;

import java.util.List;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PUBLIC)
public class RouteResultVo {
  List<ProductRouteVo> productRoutes;
  List<StepRouteVo> stepRoutes;
}