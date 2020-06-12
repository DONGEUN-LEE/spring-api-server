package com.app.service;

import com.app.repository.PlanRepository;
import com.app.vo.PlanVo;
import com.app.vo.RowVo;
import com.app.vo.TaskVo;
import com.app.util.LocalDateTimeRange;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.TreeMap;
import java.util.stream.Collectors;

import static java.util.stream.Collectors.groupingBy;

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

  public List<RowVo> findRows() {
    List<RowVo> rows = new ArrayList<RowVo>();
    if (PlanService.plans == null) {
      PlanService.plans = planRepository.findAll();
    }
    TreeMap<RowVo, List<PlanVo>> collect = GroupByPlan(PlanService.plans);
    collect.forEach((key, value) -> {
      List<TaskVo> tasks = value.stream().map(plan -> {
        TaskVo task = new TaskVo();
        task.setStartTime(plan.getStartTime());
        task.setEndTime(plan.getEndTime());
        task.setKey(plan.getProductId());
        task.setText(plan.getProductId());
        task.setItem(plan);
        return task;
      }).collect(Collectors.toList());
      Collections.sort(tasks, new Comparator<TaskVo>() {
        @Override
        public int compare(TaskVo t1, TaskVo t2) {
          return t1.getStartTime().compareTo(t2.getStartTime());
        }
      });
      List<LocalDateTimeRange> prevRanges = new ArrayList<LocalDateTimeRange>();
      tasks.forEach(task -> {
        LocalDateTimeRange taskRange =
            new LocalDateTimeRange(task.getStartTime(), task.getEndTime());
        if (prevRanges.size() > 0) {
          int idx = 0;
          for (LocalDateTimeRange prevRange : prevRanges) {
            if (!prevRange.overlaps(taskRange)) {
              break;
            }
            idx++;
          }
          if (prevRanges.size() > idx) {
            prevRanges.set(idx, taskRange);
          } else {
            prevRanges.add(taskRange);
          }
          task.setLevel(idx);
        } else {
          prevRanges.add(taskRange);
        }
      });
      key.setTasks(tasks);
      key.setMaxLevel(prevRanges.size());
      rows.add(key);
    });
    return rows;
  }

  private TreeMap<RowVo, List<PlanVo>> GroupByPlan(List<PlanVo> plans) {
    TreeMap<RowVo, List<PlanVo>> collect = plans.stream().collect(groupingBy(plan -> {
      RowVo key = new RowVo();
      key.setSiteId(plan.getSiteId());
      key.setOperId(plan.getOperId());
      key.setStageId(plan.getStageId());
      key.setResourceId(plan.getResourceId());
      return key;
    }, TreeMap::new, Collectors.toList()));
    return collect;
  }

  // public List<PlanVo> findAll() {
  // List<PlanVo> plans = planRepository.findAll();
  // return plans;
  // }
}
