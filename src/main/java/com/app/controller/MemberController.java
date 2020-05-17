package com.app.controller;

import com.app.service.MemberService;
import com.app.vo.MemberVo;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/member")
public class MemberController {
  @Autowired
  MemberService memberService;

  @GetMapping(produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<List<MemberVo>> getAllmembers() {
    List<MemberVo> member = memberService.findAll();
    return new ResponseEntity<List<MemberVo>>(member, HttpStatus.OK);
  }

  @DeleteMapping(value = "/{mbrNo}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<Void> deleteMember(@PathVariable("mbrNo") Long mbrNo) {
    memberService.deleteById(mbrNo);
    return new ResponseEntity<Void>(HttpStatus.NO_CONTENT);
  }

  @PutMapping(value = "/{mbrNo}", produces = {MediaType.APPLICATION_JSON_VALUE})
  public ResponseEntity<MemberVo> updateMember(@PathVariable("mbrNo") Long mbrNo, MemberVo member) {
    memberService.updateById(mbrNo, member);
    return new ResponseEntity<MemberVo>(member, HttpStatus.OK);
  }

  @PostMapping
  public ResponseEntity<MemberVo> save(MemberVo member) {
    return new ResponseEntity<MemberVo>(memberService.save(member), HttpStatus.OK);
  }
}
