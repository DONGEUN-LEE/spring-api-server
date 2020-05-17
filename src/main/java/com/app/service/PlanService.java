package com.app.service;

import com.app.repository.PlanRepository;
import com.app.vo.PlanVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;

@Service
public class PlanService {
  @Autowired
  private PlanRepository planRepository;

  public List<PlanVo> findAll() {
    List<PlanVo> plans = new ArrayList<>();
    planRepository.findAll().forEach(e -> plans.add(e));
    return plans;
  }
}
