package bootsample.model;
import java.io.Serializable;
import java.sql.Date;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;


@SuppressWarnings("serial")
@Entity(name = "employee")
public class Employee implements Serializable {
	
	@Id
	@GeneratedValue(strategy=GenerationType.AUTO)
	private int id;
	private String first_name;
	private String last_name;
	private Date dob;
	private float satisfaction_level;
	private float last_evaluation;
	private int number_projects;
	private int average_montly_hours;
	private int time_spend_company;
	private int work_accident;
	private int promotion;
	private String department;
	private String salary;
	
	public Employee(){
		
	}
	public Employee(String first_name, String last_name, Date dob, float satisfaction_level, float last_evaluation,
			int number_projects, int average_montly_hours, int time_spend_company, int work_accident, int promotion,
			String department, String salary) {
		this.first_name = first_name;
		this.last_name = last_name;
		this.dob = dob;
		this.satisfaction_level = satisfaction_level;
		this.last_evaluation = last_evaluation;
		this.number_projects = number_projects;
		this.average_montly_hours = average_montly_hours;
		this.time_spend_company = time_spend_company;
		this.work_accident = work_accident;
		this.promotion = promotion;
		this.department = department;
		this.salary = salary;
	}
	public String getFirst_name() {
		return first_name;
	}
	public void setFirst_name(String first_name) {
		this.first_name = first_name;
	}
	public String getLast_name() {
		return last_name;
	}
	public void setLast_name(String last_name) {
		this.last_name = last_name;
	}
	public Date getDob() {
		return dob;
	}
	public void setDob(Date dob) {
		this.dob = dob;
	}
	public float getSatisfaction_level() {
		return satisfaction_level;
	}
	public void setSatisfaction_level(float satisfaction_level) {
		this.satisfaction_level = satisfaction_level;
	}
	public float getLast_evaluation() {
		return last_evaluation;
	}
	public void setLast_evaluation(float last_evaluation) {
		this.last_evaluation = last_evaluation;
	}
	public int getNumber_projects() {
		return number_projects;
	}
	public void setNumber_projects(int number_projects) {
		this.number_projects = number_projects;
	}
	public int getAverage_montly_hours() {
		return average_montly_hours;
	}
	public void setAverage_montly_hours(int average_montly_hours) {
		this.average_montly_hours = average_montly_hours;
	}
	public int getTime_spend_company() {
		return time_spend_company;
	}
	public void setTime_spend_company(int time_spend_company) {
		this.time_spend_company = time_spend_company;
	}
	public int getWork_accident() {
		return work_accident;
	}
	public void setWork_accident(int work_accident) {
		this.work_accident = work_accident;
	}
	public int getPromotion() {
		return promotion;
	}
	public void setPromotion(int promotion) {
		this.promotion = promotion;
	}
	public String getDepartment() {
		return department;
	}
	public void setDepartment(String department) {
		this.department = department;
	}
	public String getSalary() {
		return salary;
	}
	public void setSalary(String salary) {
		this.salary = salary;
	}
	
	
	

}
