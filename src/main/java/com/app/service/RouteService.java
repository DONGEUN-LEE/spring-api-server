package com.app.service;

import com.app.repository.RouteRepository;
import com.app.vo.RouteVo;
import com.app.vo.ProductRouteVo;
import com.app.vo.RouteResultVo;
import com.app.vo.StepRouteVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

@Service
public class RouteService {
  @Autowired
  private RouteRepository routeRepository;

  public List<RouteVo> findAll() {
    List<RouteVo> routes = routeRepository.findAll();
    return routes;
  }

  public RouteResultVo findRoutesByProduct(String productId) {
    RouteResultVo result = new RouteResultVo();
    List<ProductRouteVo> productRoutes = new ArrayList<ProductRouteVo>();
    List<StepRouteVo> stepRoutes = new ArrayList<StepRouteVo>();
    findFromProductRouter(productRoutes, stepRoutes, productId, 0);
    findToProductRouter(productRoutes, stepRoutes, productId, -1);
    result.setProductRoutes(productRoutes.stream().distinct().collect(Collectors.toList()));
    result.setStepRoutes(stepRoutes.stream().distinct().collect(Collectors.toList()));
    return result;
  }

  private void findFromProductRouter(List<ProductRouteVo> productRoutes,
      List<StepRouteVo> stepRoutes, String productId, int seq) {
    List<RouteVo> routes = routeRepository.findByFromProductId(productId);
    if (routes.size() > 0) {
      productRoutes.addAll(routes.stream().map(r -> {
        ProductRouteVo pr = new ProductRouteVo();
        pr.setFrom(r.getFromProductId());
        pr.setTo(r.getToProductId());
        pr.setSeq(seq);
        StepRouteVo srf = new StepRouteVo();
        srf.setFrom(r.getFromOperId());
        srf.setProduct(r.getFromProductId());
        srf.setSeq(0);
        StepRouteVo srt = new StepRouteVo();
        srt.setFrom(r.getOperId());
        srt.setProduct(r.getToProductId());
        srt.setSeq(0);
        stepRoutes.add(srf);
        stepRoutes.add(srt);
        findFromProductRouter(productRoutes, stepRoutes, r.getToProductId(), seq + 1);
        return pr;
      }).collect(Collectors.toList()));
    }
  }

  private void findToProductRouter(List<ProductRouteVo> productRoutes, List<StepRouteVo> stepRoutes,
      String productId, int seq) {
    List<RouteVo> routes = routeRepository.findByToProductId(productId);
    if (routes.size() > 0) {
      productRoutes.addAll(routes.stream().map(r -> {
        ProductRouteVo pr = new ProductRouteVo();
        pr.setFrom(r.getFromProductId());
        pr.setTo(r.getToProductId());
        pr.setSeq(seq);
        StepRouteVo srf = new StepRouteVo();
        srf.setFrom(r.getFromOperId());
        srf.setProduct(r.getFromProductId());
        srf.setSeq(0);
        StepRouteVo srt = new StepRouteVo();
        srt.setFrom(r.getOperId());
        srt.setProduct(r.getToProductId());
        srt.setSeq(0);
        stepRoutes.add(srf);
        stepRoutes.add(srt);
        findToProductRouter(productRoutes, stepRoutes, r.getFromProductId(), seq - 1);
        return pr;
      }).collect(Collectors.toList()));
    }
  }
}
