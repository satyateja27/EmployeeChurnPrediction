package bootsample.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import bootsample.model.User;
import bootsample.service.UserService;

@RestController
public class UserController {

	@Autowired
	private UserService userService;
	
	@PostMapping("/api/user/register")
	public ModelAndView registerUser(@RequestParam(value="first_name",required=true) String f_name,
			@RequestParam(value="last_name",required=true) String l_name,
			@RequestParam(value="email",required=true) String email,
			@RequestParam(value="password",required=true) String password,
			@RequestParam(value="org",required=true) String org)
	{
		ModelMap model=new ModelMap();
		try{
			userService.saveUser(f_name, l_name, email, password, org);
		}
		catch(Exception e){
			model.addAttribute("error","Duplicate Id's found!");
			return new ModelAndView("SignUp",model);	
		}
		model.addAttribute("message","User resgistered sucessfully");
		return new ModelAndView("LogIn",model);
		
	}
	
	@PostMapping("/api/user/login")
	public void login(
			@RequestParam(value="email",required=true) String email,
			@RequestParam(value="password",required=true) String password,
			HttpServletResponse response,
			HttpServletRequest request
	) throws IOException
	{
		ModelMap model=new ModelMap();	
		User user;
		
		user=userService.findUser(email, password);
		if(user==null){
			model.addAttribute("error","Invalid Login");
			response.sendRedirect("/");
		}
		else{
			response.sendRedirect("/user/"+user.getUserId()+"/dashBoard");		
		}
		
	}
	
	@GetMapping("/user/{userId}/dashBoard")		
	public ModelAndView getDashBoard(@PathVariable(value="userId") int userId){
		ModelMap model = new ModelMap();
		User user = userService.findUserbyId(userId);
		model.addAttribute("user", user);
		return new ModelAndView("AdminDashboard",model);
	}
	
	@GetMapping("/user/{userId}/profile")		
	public ModelAndView getProfile(@PathVariable(value="userId") int userId){
		
		ModelMap model = new ModelMap();
		User user = userService.findUserbyId(userId);
		model.addAttribute("user", user);
		return new ModelAndView("AdminProfile",model);
	}
	
}
