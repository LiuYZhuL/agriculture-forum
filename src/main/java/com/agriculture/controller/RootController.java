package com.agriculture.controller;

import com.agriculture.model.po.Category;
import com.agriculture.service.CategoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.servlet.ModelAndView;

import java.util.List;

@Controller
public class RootController {
    @Autowired
    private CategoryService categoryService;

    @GetMapping({"/", "/api/dashboard"})
    public ModelAndView root() {
        ModelAndView modelAndView = new ModelAndView();
        modelAndView.setViewName("dashboard");
        try {
            List<Category> categories = categoryService.listCategories();
            modelAndView.addObject("categories", categories);
        }catch (RuntimeException e){
            modelAndView.addObject("error", e.getMessage());
            return modelAndView;
        }
        return modelAndView;
    }
}
