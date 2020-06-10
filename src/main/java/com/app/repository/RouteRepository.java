package com.app.repository;

import java.util.List;
import com.app.vo.RouteVo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface RouteRepository extends JpaRepository<RouteVo, Long> {
  List<RouteVo> findByFromProductId(String productId);

  List<RouteVo> findByFromProductIdIn(List<String> products);

  List<RouteVo> findByFromOperId(String operId);

  List<RouteVo> findByToProductId(String productId);

  List<RouteVo> findByToProductIdIn(List<String> products);

  List<RouteVo> findByOperId(String operId);
}
