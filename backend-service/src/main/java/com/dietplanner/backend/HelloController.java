package com.dietplanner.backend;

import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@CrossOrigin(origins = "http://localhost:4200")
@RestController
public class HelloController {
    @GetMapping("/hello")
    public String hello() {
        return "Diet Planner Backend is working!";
    }
}
