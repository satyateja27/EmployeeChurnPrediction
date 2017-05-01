package bootsample.service;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;


import bootsample.dao.UserRepository;
import bootsample.model.Address;
import bootsample.model.Phone;
import bootsample.model.User;

@Service
@Transactional
public class UserService {
	
	@Autowired
	private PhoneService phoneService;
	
	@Autowired
	private AddressService addressService;
	
	
	
	private final UserRepository userRepository;

	public UserService(UserRepository userRepository) {
		this.userRepository = userRepository;
	}
	public void addUsertoPhone(int user_id,int phone_id){
		
		User user = userRepository.findOne(user_id);
		Phone phone = phoneService.getPhone(phone_id);
		if(user.getPhones()==null){
			Set<Phone> phones = new HashSet<Phone>();
			user.setPhones(phones);
		}else{
			user.getPhones().add(phone);
		}
		
		userRepository.save(user);
	}
	public void removeUsertoPhone(int user_id,int phone_id){
		User user = userRepository.findOne(user_id);
		Phone phone = phoneService.getPhone(phone_id);
		user.getPhones().remove(phone);
		userRepository.save(user);
	}
	
	public User createUser(String fname,String lname, String title,String street,
			String city,String state,long zip,String no1,String desc1,String no2,
			String desc2,String no3,String desc3)
	{	
		Address address = new Address(street,city,state,zip);
		addressService.saveAddress(address);
		User user = new User(fname,lname,title,address);
		Set<Phone> phones = new HashSet<>();
		if(!(no1.isEmpty())){
		long phoneNumber = Long.parseLong(no1); 
		Phone phone1 = new Phone(phoneNumber,desc1,address);
		phoneService.save(phone1);
		userRepository.save(user);		
		phones.add(phone1);
		}
		// If Second Number Exists
		
		if(!(no2.isEmpty())){
			long phoneNumber2 = Long.parseLong(no2); 
			Phone phone2 = new Phone(phoneNumber2,desc2,address);
			phoneService.save(phone2);
			phones.add(phone2);
		}
		// If Third Number Exists
		if(!(no3.isEmpty())){
			long phoneNumber3 = Long.parseLong(no3); 
			Phone phone3 = new Phone(phoneNumber3,desc3,address);
			phoneService.save(phone3);
			phones.add(phone3);
		}
		userRepository.save(user);		
		user.setPhones(phones);
		userRepository.save(user);
		return user;
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
	public void assignPhone(int id,int phone_id){
		User user = userRepository.findOne(id);
		Phone phone = phoneService.getPhone(phone_id);
		user.getPhones().add(phone);
		userRepository.save(user);
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
		if(!(street==null)){
			user.getAddress().setStreet(street);
		}
		if(!(city==null)){
			user.getAddress().setCity(city);
		}
		if(!(state==null)){
			user.getAddress().setState(state);
		}
		if(!(zip==null)){
			user.getAddress().setZip(Long.parseLong(zip));
		}
		userRepository.save(user);	
	}

}
