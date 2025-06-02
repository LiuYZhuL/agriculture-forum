package com.agriculture.exception;

import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.servlet.ModelAndView;
@ControllerAdvice
public class GlobalExceptionHandler {
    @ExceptionHandler(AuthException.class)
    public ModelAndView handleAuthException(AuthException e) {
        ModelAndView mav = new ModelAndView("login");
        mav.addObject("error", e.getMessage());
        return mav;
    }
    @ExceptionHandler(AdminException.class)
    public ModelAndView handleAdminException(AdminException e) {
        ModelAndView mav = new ModelAndView("redirect:/");
        mav.addObject("error", e.getMessage());
        return mav;
    }
}
