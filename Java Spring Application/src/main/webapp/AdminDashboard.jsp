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
    
    <title>ChurnPrediction | User</title>
    
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
	<div ng-app="myApp" ng-controller="myCtrl">
	<div class = "panel panel-default">
            <div class = "panel-body bg-primary" style=" height:65px">
               <nav class="navbar navbar-light">
                  <div class="container-fluid">
                     <ul class="nav navbar-nav">
                        <li class="nav-item">
                           <a class="nav-link" href="/user/${user.getUserId()}/dashBoard" style="color:white">Admin Dashboard</a>
                        </li>
                        <li class="nav-item">
                           <a class="nav-link" href="" style="color:white">Churn Prediction</a>
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
         		<h1>Admin Dashboard</h1><br/><br/>
         		<div id="div1" ng-init="promotion()"></div>
         		<div id="div2" ng-init="departmentTrends()"></div>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
	
	<script>
	var app = angular.module('myApp',[]);
    app.controller('myCtrl', function($scope, $http){
    	$scope.promotion = function(){
    		var output;
	    	$http({
				url:"http://localhost:80/getPromotionStats",
				dataType: "json",
				data: '',
				method: "GET",
				headers: {
							"Content-Type": "application/json"
			}}).then( function(response) 
			{
	               $scope.promotionStats = response.data;
				   console.log($scope.promotionStats)
				   var xData = []
				   var yData = []
				   for( var i in $scope.promotionStats){
						xData.push(i)
						yData.push($scope.promotionStats[i])
					}
					console.log(yData)
					console.log(xData)
					var data = [{
						values: yData,
						labels: xData,
						type: 'pie'
					}];

					var layout = {
						title: 'Promotions per Department',
						height: 450,
						width: 550
					};

					Plotly.newPlot('div1', data, layout);
	         });
    	}

    	$scope.departmentTrends = function(){
    		var output;
	    $http({
			url:"http://localhost:80/getDeptTrends",
			dataType: "json",
			data: '',
			method: "GET",
			headers: {
				"Content-Type": "application/json"
			}}).then( function(response) 
			{
	               $scope.departmentData = response.data;
				   console.log($scope.departmentData)
				   var xData = []
				   var y1Data = []
				   var y2Data = []
				   for( var i in $scope.departmentData){
						xData.push(i)
						y2Data.push($scope.departmentData[i][0])
						y1Data.push($scope.departmentData[i][1]-$scope.departmentData[i][0])
					}
					var trace1 = {
					x: xData,
					y: y1Data,
					name: 'Current Employees',
					type: 'bar'
					};

					var trace2 = {
					x: xData,
					y: y2Data,
					name: 'Left Employees',
					type: 'bar'
					};

					var data = [trace1, trace2];

					var layout = {
					title: 'Employees Count Statistics per Department',
					height: 450,
					width:  600,
					barmode: 'stack'
					};

					Plotly.newPlot('div2', data, layout);
	         });
    	}
        
    });
	</script>
	</div>
</body>
</html>