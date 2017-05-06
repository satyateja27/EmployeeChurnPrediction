<!DOCTYPE HTML>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<html>
<head>
	<meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta http-equiv="Pragma" content="no-cache"> 
    <meta http-equiv="Cache-Control" content="no-cache"> 
    <meta http-equiv="Expires" content="Sat, 01 Dec 2001 00:00:00 GMT">
    
    <title>ChurnPrediction | Employee</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	  <script src="https://cdn.plot.ly/plotly-latest.min.js"></script> 
	  
	  <style>
		table {
		    border-collapse: collapse;
		    width: 100%;
		}
		
		th, td {
		    text-align: left;
		    padding: 8px;
		}
		
		tr:nth-child(even){background-color: #f2f2f2}
		
		th {
		    background-color: #5784cc;
		    color: white;
		}
	</style>
	  
</head>
<body>
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="hide=true; simulation=true">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/dashBoard" style="color:white">Admin Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/churnPrediction" style="color:white">Churn Prediction</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="" style="color:white">Churn Recommendation</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/profile" style="color:white">Admin Profile</a>
                        </li>
                     </ul>
                     <ul class="nav navbar-nav navbar-right">
                     	<li class="nav-item">
                           <a class="nav-link" href="#" style="color:white">Hi, ${user.getFirstName() }</a>
                        </li>
                     	<li class="nav-item">
                           <a class="nav-link" href="/" style="color:white"><span class="glyphicon glyphicon-off"></span> Logout</a>
                        </li>
                     </ul>
                  </div>
               </nav>
            </div>
         </div>
         <div>
         	<div class="col-sm-1"></div>
         	<div class="col-sm-10">
         		<div><h3><b>Prediction Module</b></h3></div><br/><br/>
         		<div class="row">
         			<div class="col-lg-2">Enter the employee ID: </div>	
         			<div class="col-lg-2"><input type="text" ng-model="searchContent" class="form-control"/></div>
         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="searchEmployee()">Search Employee</button></div>
         		</div><br/><br/>
         		<div class="row">
	         		<div class="row col-sm-6" ng-hide="hide">
	         			<h4>Employee Details</h4>
						<div class="panel panel-default">
							  <div class="panel-body">
							    <p><h3>{{employee.first_name}} {{employee.first_name}}</h3></p>
							  </div>
							  <ul class="list-group">
							    <li class="list-group-item"><b> Date of Birth: </b>{{employee.dob}}</li>
							    <li class="list-group-item"><b>Department: </b>{{employee.department}}</li>
							    <li class="list-group-item"><b>Satisfaction Level: </b>{{employee.satisfaction_level}}</li>
							    <li class="list-group-item"><b>Number of Projects: </b>{{employee.number_projects}}</li>
							    <li class="list-group-item"><b>Avg.Monthly Hours:</b>{{employee.average_montly_hours}}</li>
							    <li class="list-group-item"><b>Time Spend(Yrs): </b>{{employee.time_spend_company}}</li>
							  </ul>
						</div>
	         			<div style="text-align:center"><button class="btn btn-primary" ng-click="getPrediction()">Get Prediction</button></div>
	         		</div>
	         		<div class="col-sm-1"></div>
	         		<div ng-hide="prediction" class="col-sm-5">
		         		<h4>Simulation Module</h4>
		         		<div class="panel panel-default">
							  <div class="panel-body">
							    <p><h3>{{employee.first_name}} {{employee.first_name}}</h3></p>
							  </div>
							  <div class = "row">
							  	<div class="col-sm-1"></div>
							  	<div class="col-sm-9">
							  		<label for="fader">Number of Projects</label>
									<input type="range" min="1" max="9" value="{{employee.number_projects}}" id="fader" step="1" oninput="outputUpdate1(value)">
									<output for="fader" id="projects">{{employee.number_projects}}</output>
									<br/>
									<label for="fader">Salary</label>
									<input type="range" min="0" max="2" value="{{employee.salary}}" id="fader" step="1" oninput="outputUpdate2(value)">
									<output for="fader" id="salary">{{employee.salary}}</output>
									<br/>
									<label for="fader">Promotion</label>
									<input type="range" min="0" max="1" value="0" id="fader" step="1" oninput="outputUpdate3(value)">
									<output for="fader" id="promotion">{{employee.promotion}}</output>
							  	</div>
							  	<div class="col-sm-2"></div>
							  </div>
		         		</div>
		         		<div style="text-align:center"><button class="btn btn-primary" ng-click="performSimulation()">Simulate</button></div>
	         		</div>
         		</div>
         		<br/><br/>
         		<div class="row">
         			<div class="col-sm-6">
         				<div ng-model="decision" style="color:green; text-align:center" ng-hide="prediction1"><h4><b>Prediction: {{employee.first_name}} will stay at the Company for next 6 Months</b></h4></div>
         				<div ng-model="decision" style="color:red; text-align:center" ng-hide="prediction2"><h4><b>Prediction: {{employee.first_name}} will leave the Company in next 6 Months</b></h4></div>
         			</div>
         			<div class="col-sm-1"></div>
         			<div class="col-sm-5">
         				<div ng-hide="simulation" style="color: #e242f4;text-align:center"><h4><b>Simulation: {{simulateOutput}}</b></h4></div>
         			</div>
         		</div>
         		
         	</div>
         	<div class="col-sm-1"></div>
         </div>
	</div>
	<script>
	var employeeData;
	var simulateProject;
	var simulateSalary;
	var simulatePromotion;
	
	function outputUpdate1(vol) {
			document.querySelector('#projects').value = vol;
			simulateProject = vol;
		}
		function outputUpdate2(vol) {
			document.querySelector('#salary').value = vol;
			simulateSalary = vol;
		}
		function outputUpdate3(vol) {
			document.querySelector('#promotion').value = vol;
			simulatePromotion = vol+employeeData.promotion;
		}				
	var app = angular.module('myApp',[]);
 	app.controller('myCtrl', function($scope, $http, $window){
 		var dept = {'sales':0, 'accounting':1, 'hr':2, 'technical':3, 'support':4, 'management':5,
                'IT':6, 'product_mng':7, 'marketing':8, 'RandD':9};
 		var salaryMapping = {'low':0,'medium':1,'high':2};
 		$scope.prediction = true;
 		$scope.prediction1 = true;
 		$scope.prediction2= true;
 		
 		$scope.performSimulation = function(){
 			console.log('Vimal');
 			console.log(simulateProject);
 			console.log(simulateSalary);
 			console.log(simulatePromotion);
 			var a = employeeData.department;
 			var dep = dept[a];
 			$http({
 				method: "POST",
 				url: 'http://52.53.150.216:80/predict',
 				data: {
 					satisfaction_level:employeeData.satisfaction_level,	
 					last_evaluation:employeeData.last_evaluation,
 					number_project:simulateProject,
 					average_montly_hours:employeeData.average_montly_hours,
 					time_spend_company:employeeData.time_spend_company,
 					Work_accident:employeeData.work_accident,
 					promotion_last_5years:simulatePromotion,
 					sales:dep,
 					salary:simulateSalary
 					},
 				headers : {'Content-Type' : 'application/json'}
 			}).success(function(response){
 				$scope.result = response.prediction;
 				if($scope.result==0){
 					$scope.simulateOutput = "Employee will Stay";
 				}else{
 					$scope.simulateOutput = "Employee will Leave";
 				}
 				$scope.simulation = false;
 			});
 			
 			
 		};
 		
 		$scope.searchEmployee = function(){
 			$http({
 				method:"GET",
 				url:'/api/getEmployee/' + $scope.searchContent,
 				params: {id : $scope.searchContent},
 	            headers : {'Content-Type': 'application/json'}
 			}).success(function(response){
 				$scope.employee = response.Employee;
 				employeeData = $scope.employee
 				
 				simulateProject = employeeData.number_projects;
 				var b = employeeData.salary;
 	 			var sal = salaryMapping[b]; 				
 				simulateSalary = sal;
 				simulatePromotion = employeeData.promotion
 				$scope.hide = false;
 				$scope.simulation = true;
 				$scope.prediction = true;
 				$scope.prediction1 = true;
 				$scope.prediction2 = true;
 	
 			});
 		};
 		
 		$scope.getPrediction = function(){
 			console.log(employeeData);
 			var a = employeeData.department;
 			var dep = dept[a];
 			var b = employeeData.salary;
 			var sal = salaryMapping[b];
 			
 			$http({
 				method: "POST",
 				url: 'http://52.53.150.216:80/predict',
 				data: {
 					satisfaction_level:employeeData.satisfaction_level,	
 					last_evaluation:employeeData.last_evaluation,
 					number_project:employeeData.number_projects,
 					average_montly_hours:employeeData.average_montly_hours,
 					time_spend_company:employeeData.time_spend_company,
 					Work_accident:employeeData.work_accident,
 					promotion_last_5years:employeeData.promotion,
 					sales:dep,
 					salary:sal
 					},
 				headers : {'Content-Type' : 'application/json'}
 			}).success(function(response){
 				$scope.result = response.prediction;
 				$scope.prediction = false;
 				if($scope.result==0){
 					$scope.prediction1 = false;
 				}else{
 					$scope.prediction2 = false;
 				} 				
 			});
 		}
 		
 	});
	</script>
</body>
</html>