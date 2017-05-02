package bootsample.service;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.mysql.jdbc.exceptions.MySQLIntegrityConstraintViolationException;

import bootsample.dao.UserRepository;
import bootsample.model.User;

@Transactional
@Service
public class UserService {

	@Autowired
	private UserRepository userRepository;
	
	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}
	
	public User findUserbyId(int user_id){
		return userRepository.findOne(user_id);
	}
	
	public void saveUser(String f_name,String l_name,String email,String pswrd,String org) throws MySQLIntegrityConstraintViolationException, Exception
	{
		User user=new User(f_name,l_name,email,pswrd,org);
		userRepository.save(user);
	}
	
	public User findUser(String email,String pswrd)
	{
		User user=userRepository.retrieveUsersByEmail(email);
		if(user==null){
			return null;
		}
		if(pswrd.equals(user.getPassword())){
			return user;
		}else{
			return null;
		}
	}
	
}
