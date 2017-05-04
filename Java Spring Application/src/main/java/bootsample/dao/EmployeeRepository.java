package bootsample.dao;

import org.springframework.data.repository.CrudRepository;

import bootsample.model.Employee;
import bootsample.model.User;

public interface EmployeeRepository extends CrudRepository<Employee, Integer>{

}
