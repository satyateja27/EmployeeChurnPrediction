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
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import bootsample.model.Employee;
import bootsample.model.User;
import bootsample.service.EmployeeService;

@RestController
public class EmployeeController {

	@Autowired
	private EmployeeService employeeService;
	
	@GetMapping("/api/getEmployee/{userId}")
	public ModelAndView login(@PathVariable(value="userId") int userId) throws IOException
	{
		ModelMap model = new ModelMap();
		Employee employee = employeeService.findUserbyEmployeeId(userId);
		model.addAttribute("Employee",employee);
		return new ModelAndView(new MappingJackson2JsonView(),model);
	}
	
}
