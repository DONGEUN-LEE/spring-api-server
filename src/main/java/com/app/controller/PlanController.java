package com.app.controller;

import com.app.service.PlanService;
import com.app.vo.PlanVo;
import com.app.vo.RowVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/plan")
public class PlanController {
  @Autowired
  PlanService planService;

  @GetMapping(produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<PlanVo>> getAllplans() {
    List<PlanVo> plan = planService.findAll();
    return new ResponseEntity<List<PlanVo>>(plan, HttpStatus.OK);
  }

  @GetMapping(value = "/row", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<RowVo>> getRows() {
    List<RowVo> rows = planService.findRows();
    return new ResponseEntity<List<RowVo>>(rows, HttpStatus.OK);
  }
}
