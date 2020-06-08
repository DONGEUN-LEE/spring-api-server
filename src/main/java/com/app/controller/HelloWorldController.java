package com.app.controller;

import java.util.ArrayList;
import java.util.List;
import com.app.service.PlanService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

@RestController
public class HelloWorldController {
  @Autowired
  PlanService planService;

  @RequestMapping("/")
  public String home() {
    return "Hello World!";
  }

  @RequestMapping("/valueTest")
  public String valueTest() {
    return "테스트 String";
  }

  @RequestMapping("/test")
  public ModelAndView test() throws Exception {
    ModelAndView mav = new ModelAndView("test");
    mav.addObject("name", "Spring!");
    List<String> testList = new ArrayList<String>();
    testList.add("a");
    testList.add("b");
    testList.add("c");
    mav.addObject("list", testList);
    return mav;
  }

  @RequestMapping("/gantt")
  public ModelAndView gantt() throws Exception {
    ModelAndView mav = new ModelAndView("gantt");
    mav.addObject("name", "Gantt Test");
    return mav;
  }
}
