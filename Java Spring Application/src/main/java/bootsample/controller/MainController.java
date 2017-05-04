package bootsample.controller;

import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class MainController {

	@GetMapping("/")
	public String getLogin(HttpServletRequest request){
		return "LogIn";
	}
	
	@GetMapping("/signup")
	public String getSignUp(HttpServletRequest request){
		return "SignUp";
	}
	
}
