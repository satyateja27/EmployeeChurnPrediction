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
    
    <title>MSCIaaS | User</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
	  
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
	<div ng-app="myApp" ng-controller="myCtrl" ng-init="stop=false; terminate=false">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUser_id()}/dashBoard" style="color:white">User Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUser_id()}/createInstance"style="color:white">Create Instances</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUser_id()}/monitorInstance" style="color:white">Monitor Instances</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUser_id()}/userProfile" style="color:white">User Profile</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUser_id()}/userBilling" style="color:white">User Billing</a>
                        </li>
                     </ul>
                     <ul class="nav navbar-nav navbar-right">
                     	<li class="nav-item">
                           <a class="nav-link" href="#" style="color:white">Hi, ${user.getFirst_name() }</a>
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
         		<h1>User Dashboard</h1><br/><br/>
         		<h3>Existing Instances</h3>
         		<table>
         			<tr>
         				<th>Instance ID</th>
         				<th>Instance Name</th>
         				<th>AMI ID</th>
         				<th>Number of Instances</th>
         				<th>Instance Status</th>
         				<th>Operation</th>
         			</tr>
         			
         			<c:forEach items="${Instance}" var="instance">
         			<tr>
         			<form method="" action="">
         				<td>${instance.getInstance_id()}</td>
         				<td>${instance.getInstance_name()}</td>
         				<td>${instance.getAmi_name()}</td>
         				<td>${instance.getNum_instance()}</td>
         				<td><label ng-show="${instance.getInstance_active()}" style="color:green"><b>Active</b></label>
         				<label ng-show="${instance.getInstance_stopped()}" style="color:#f44242"><b>Stopped</b></label>
         				<label ng-show="${instance.getInstance_terminated()}"><b>Terminated</b></label></td>
         				<td><button ng-click="stopReq(${instance.getInstance_id()})">Stop</button>
         				<button ng-click="terminateReq(${instance.getInstance_id()})">Terminate</button>
         				<button ng-click="startReq(${instance.getInstance_id()})">Start</button></td>
         			</form>
         			</tr>
         			</c:forEach>	
         		</table>
         		
         	</div>
         	<div class="col-sm-1"></div>
         </div>
	</div>
	<script>
		var app = angular.module('myApp',[]);
		app.controller('myCtrl',function($scope, $http){
			var start = 
			$scope.stopReq = function(instanceId){
				console.log('Stop: ' + instanceId);
				$http({
					method:"POST",
					url:"/api/instance/stopInstance",
					params:{instanceId:instanceId},
					header:{'Content-Type': 'application/json'}
				}).success(function(data){
					window.location.href="/user/${user.getUser_id()}/dashBoard";
				});
			};
			$scope.terminateReq = function(instanceId){
				console.log('terminate: ' + instanceId);
				$http({
					method:"POST",
					url:"/api/instance/terminateInstance",
					params:{instanceId:instanceId},
					header:{'Content-Type': 'application/json'}
				}).success(function(data){
					window.location.href="/user/${user.getUser_id()}/dashBoard";
					
				});
			};
			$scope.startReq = function(instanceId){
				console.log('Start: ' + instanceId);
				$http({
					method:"POST",
					url:"/api/instance/startInstance",
					params:{instanceId:instanceId},
					header:{'Content-Type': 'application/json'}
				}).success(function(data){
					window.location.href="/user/${user.getUser_id()}/dashBoard";
					
				});
			};
			$scope.active = function(input){
				console.log(input);
				return false;
			};
		});
	</script>
</body>
</html>