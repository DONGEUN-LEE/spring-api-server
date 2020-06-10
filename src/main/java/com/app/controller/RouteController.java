package com.app.controller;

import com.app.service.RouteService;
import com.app.vo.RouteResultVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.HashMap;

@RestController
@RequestMapping("/api/route")
public class RouteController {
  @Autowired
  RouteService routeService;

  @PostMapping(produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<RouteResultVo> getRoutes(@RequestBody HashMap<String, Object> map) {
    RouteResultVo routes = routeService.findRoutesByProduct(map.get("productId").toString());
    return new ResponseEntity<RouteResultVo>(routes, HttpStatus.OK);
  }
}
