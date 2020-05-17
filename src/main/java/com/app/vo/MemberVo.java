package com.app.vo;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import lombok.AccessLevel;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@Entity(name = "member")
public class MemberVo {
  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long mbrNo;
  private String id;
  private String name;

  @Builder
  public MemberVo(String id, String name) {
    this.id = id;
    this.name = name;
  }
}
