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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="hide=true">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/dashBoard" style="color:white">Admin Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/churnPrediciton" style="color:white">Churn Prediction</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="" style="color:white">Churn Recommendation</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/profile" style="color:white">User Profile</a>
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
         		<h3>Enter the employee id to get the churn prediction</h3><br/><br/>
         		<div class="row">
         			<div class="col-lg-2">Enter the employee ID: </div>	
         			<div class="col-lg-4"><input type="text" ng-model="searchContent" class="form-control"/></div>
         			<div class="col-lg-2"><button class="btn btn-primary" ng-click="searchEmployee()">Search Employee</button></div>
         		</div><br/>
         		<div class="row" ng-hide="hide">
         		
         			<div class="row"><button class="btn btn-primary" ng-click="getPrediction()">Get Prediction</button></div>
         		</div>
         		<div class="row" ng-hide="prediction">The Employee will <div ng-model="decision" style="color:red"></div></div>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
	</div>
	<script>
	var app = angular.module('myApp',[]);
 	app.controller('myCtrl', function($scope, $http, $window){
 		
 		$scope.searchEmployee = function(){
 			$http({
 				method:"GET",
 				url:'/api/getEmployee/' + $scope.searchContent,
 				params: {id : $scope.searchContent},
 	            headers : {'Content-Type': 'application/json'}
 			}).success(function(response){
 				$scope.hide = false;
 	
 			});
 		};
 		
 		$scope.getPrediction = function(){
 			$http({
 				method: "GET",
 				url: '/api/getPrediction',
 				params: {id : $scope.id},
 				headers : {'Content-Type' : 'application/json'}
 			}).success(function(response){
 				$scope.prediction = false;
 				if(response.data == 1){
 					$scope.decision = "leave";
 				}else{
 					$scope.decision = "stay";
 				}
 			});
 		}
 		
 	});
	</script>
</body>
</html>