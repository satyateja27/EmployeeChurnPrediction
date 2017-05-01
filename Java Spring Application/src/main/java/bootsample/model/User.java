package bootsample.model;

import java.io.Serializable;
import java.util.List;
import java.util.Set;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.ManyToMany;
import javax.persistence.OneToOne;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonProperty;

@Entity(name="user")
public class User implements Serializable {

	@GeneratedValue(strategy=GenerationType.AUTO)
	@Id
	@Column(name="id")
	private int id;
	@Column(name="firstname")
	private String firstname;
	@Column(name="lastname")
	private String lastname;
	@Column(name="title")
	private String title;
	@ManyToMany(targetEntity=Phone.class)
	@JoinTable(name="phone_users", joinColumns={@JoinColumn(name="users_id", referencedColumnName="id")},
	inverseJoinColumns={@JoinColumn(name="phone_phone_id", referencedColumnName="phone_id")})
	private Set phones;
	
	@OneToOne
	private Address address;
	
	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public User(){
	}
	
	public User(String firstname, String lastname, String title,Address address) {
		super();
		this.firstname = firstname;
		this.lastname = lastname;
		this.title = title;
		this.address = address;
	}


	public String getFirstname() {
		return firstname;
	}

	public String getLastname() {
		return lastname;
	}

	public String getTitle() {
		return title;
	}

	public void setFirstname(String firstname) {
		this.firstname = firstname;
	}

	public void setLastname(String lastname) {
		this.lastname = lastname;
	}

	public void setTitle(String title) {
		this.title = title;
	}
	public Set getPhones() {
		return phones;
	}
	public void setPhones(Set phones) {
		this.phones = phones;
	}

	public Address getAddress() {
		return address;
	}

	public void setAddress(Address address) {
		this.address = address;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", firstname=" + firstname + ", lastname=" + lastname + ", title=" + title
				+ ", phones="  +phones+ "]";
	}

}
