package bootsample.dao;

import bootsample.model.User;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface UserRepository extends CrudRepository<User, Integer>{

	@Query(value="select * from EmployeeChurnPrediction.user where email=?",nativeQuery=true)
	public User retrieveUsersByEmail(String email);
	
}
