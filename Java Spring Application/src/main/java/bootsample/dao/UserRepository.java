package bootsample.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import bootsample.model.User;

public interface UserRepository extends CrudRepository<User, Integer> {

	@Query(value = "select * from lab2.user where user.id not in (SELECT u.id FROM lab2.user u join lab2.phone_users up on u.id=up.users_id where phone_phone_id=?)", nativeQuery = true)
	List<User> findUserPhoneNotAssigned(int phoneid);
	
	@Query(value = "select * from lab2.user where id in (select pu.users_id from lab2.phone p join lab2.phone_users pu on p.phone_id=pu.phone_phone_id where p.phone_id=?)", nativeQuery = true)
	List<User> findUserPhoneNum(int phoneid);

}
