package com.app.service;

import com.app.repository.PlanRepository;
import com.app.vo.PlanVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class PlanService {
  @Autowired
  private PlanRepository planRepository;

  private static List<PlanVo> plans;

  public List<PlanVo> findAll() {
    if (PlanService.plans == null) {
      PlanService.plans = planRepository.findAll();
    }
    return PlanService.plans;
  }

  // public List<PlanVo> findAll() {
  // List<PlanVo> plans = planRepository.findAll();
  // return plans;
  // }
}
