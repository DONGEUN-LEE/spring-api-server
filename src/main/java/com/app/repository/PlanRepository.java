package com.app.repository;

import com.app.vo.PlanVo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface PlanRepository extends JpaRepository<PlanVo, Long> {
}
