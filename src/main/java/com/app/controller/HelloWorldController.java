package com.app.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class HelloWorldController {
  @RequestMapping("/")
  public String home() {
    return "Hello World!";
  }

  @RequestMapping("/valueTest")
  public String valueTest() {
    return "테스트 String";
  }
}
