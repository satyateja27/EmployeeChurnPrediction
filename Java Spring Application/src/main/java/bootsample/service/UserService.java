package bootsample.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import bootsample.dao.UserRepository;
import bootsample.model.User;

@Service
@Transactional
public class UserService {
	
	private final UserRepository userRepository;

	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}
	public void addUsertoPhone(int user_id,int phone_id){
		
		User user = userRepository.findOne(user_id);
/*		Phone phone = phoneService.getPhone(phone_id);
		if(user.getPhones()==null){
			Set<Phone> phones = new HashSet<Phone>();
			user.setPhones(phones);
		}else{
			user.getPhones().add(phone);
		}*/
		
		userRepository.save(user);
	}
	
	
	
	public List<User> findUserbyPhone(int id){
		return userRepository.findUserPhoneNum(id);
	}
	public List<User> findUserNotAssigned(int id){
		return userRepository.findUserPhoneNotAssigned(id);
	}
	
	
	public List<User> findAll(){
		List<User> user = new ArrayList<>();
		List<User> user1=(List<User>)userRepository.findAll();
		//for( User users : user1){
			//user.add(users);
		//}
		return user1;
	}
	public void save(User user){
		userRepository.save(user);
	}
	public void delete(int id){
		userRepository.delete(id);
	}
	public User getUser(int id){
		return userRepository.findOne(id);
	}
	public void updateUser(int id,String fname, String lname, String title, String street, String city, String state,
			String zip) {
		
		User user = userRepository.findOne(id);
		if(!(fname==null)){
			user.setFirstname(fname);
		}
		if(!(lname==null)){
			user.setLastname(lname);
		}
		if(!(title==null)){
			user.setTitle(title);
		}
		userRepository.save(user);	
	}

}
