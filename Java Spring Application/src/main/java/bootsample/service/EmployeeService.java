package bootsample.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;
import bootsample.dao.EmployeeRepository;
import bootsample.model.Employee;
import bootsample.model.User;

@Transactional
@Service

public class EmployeeService {
	
	@Autowired
	private EmployeeRepository employeeRepository;
	
	public EmployeeService(EmployeeRepository employeeRepository) {
		this.employeeRepository = employeeRepository;
	}
	
	public Employee findUserbyEmployeeId(int user_id){
		return employeeRepository.findOne(user_id);
	}

}
