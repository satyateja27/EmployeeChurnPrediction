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
    
    <title>ChurnPrediction | Dashboard</title>
    
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
         <div class="row" style="text-align:center"><h1>Admin Dashboard</h1><br/></div>
         <div class="row">
         	<div class="col-sm-5">
         		<div id="div1" ng-init="promotion()"></div>
         		<div id="div2" ng-init="departmentTrends()"></div>
         		<div id="div3" ng-init="featureTrends()"></div>
         		<div id="div4" ng-init="goodEmployeeChurn()"></div>
         		<div id="div5" ng-init="meanData()"></div>
         	</div>
         	<div class="col-sm-1"></div>
         	<div class="col-sm-5">
         		<div id="div6" ng-init="employeeLeftDepartmentStats()"></div>
         		<div id="div7" ng-init="stayingEmployeeSalary()"></div>
         		<div id="div8" ng-init="leftEmployeeSalary()"></div>
         		<div id="div9" ng-init="getProjectStats()"></div>
         		<div id="div10" ng-init="getTimeSpendStats()"></div>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
	
	<script>
	var app = angular.module('myApp',[]);
    app.controller('myCtrl', function($scope, $http){
    	$scope.getTimeSpendStats = function(){
    		var output;
    	    $http({
    			url:"http://52.53.150.216:80/getTimeSpendCompany",
    			dataType: "json",
    			data: '',
    			method: "GET",
    			headers: {
    				"Content-Type": "application/json"
    			}}).then( function(response)
    			{
    	               $scope.getTimeSpendCompanyData = response.data;
    				   console.log($scope.getTimeSpendCompanyData)
    				   var xData = []
    				   var y1Data = []
    				   var y2Data = []

    				   for(var j in $scope.getTimeSpendCompanyData["0"]){
    				       xData.push(j)
    				       y1Data.push($scope.getTimeSpendCompanyData["0"][j])
    				   }

    				   for(var j in $scope.getTimeSpendCompanyData["1"]){
    				       y2Data.push($scope.getTimeSpendCompanyData["1"][j])
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
    					title: 'Number of years spend at Company Stats ',
    					height: 450,
    					width:  600,
    					barmode: 'group'
    					};

    					Plotly.newPlot('div10', data, layout);

    	         });
    	}
    	$scope.getProjectStats = function(){
    		var output;
    	    $http({
    			url:"http://52.53.150.216:80/getProjectStats",
    			dataType: "json",
    			data: '',
    			method: "GET",
    			headers: {
    				"Content-Type": "application/json"
    			}}).then( function(response)
    			{
    	               $scope.getProjectStatsData = response.data;
    				   console.log($scope.getProjectStatsData)
    				   var xData = []
    				   var y1Data = []
    				   var y2Data = []

    				   for(var j in $scope.getProjectStatsData["0"]){
    				       xData.push(j)
    				       y1Data.push($scope.getProjectStatsData["0"][j])
    				   }

    				   for(var j in $scope.getProjectStatsData["1"]){
    				       y2Data.push($scope.getProjectStatsData["1"][j])
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
    					title: 'Employee working on number of Project Stats',
    					height: 450,
    					width:  600,
    					barmode: 'group'
    					};

    					Plotly.newPlot('div9', data, layout);

    	         });
    	}
    	$scope.leftEmployeeSalary = function(){
    		var output;
    	    $http({
    			url:"http://52.53.150.216:80/getSalaryStats",
    			dataType: "json",
    			data: '',
    			method: "GET",
    			headers: {
    				"Content-Type": "application/json"
    			}}).then( function(response)
    			{
    	               $scope.leftEmployeeSalaryStats = response.data;
    				   console.log($scope.leftEmployeeSalaryStats)
    				   var xData = []
    				   var y1Data = []
    				   var y2Data = []
    				   var y3Data = []

    				   for(var j in $scope.leftEmployeeSalaryStats["1"]["low"]){
    				       xData.push(j)
    				       y1Data.push($scope.leftEmployeeSalaryStats["1"]["low"][j])
    				   }

    				   for(var j in $scope.leftEmployeeSalaryStats["1"]["medium"]){
    				       y2Data.push($scope.leftEmployeeSalaryStats["1"]["medium"][j])
    				   }

    				   for(var j in $scope.leftEmployeeSalaryStats["1"]["high"]){
    				       y3Data.push($scope.leftEmployeeSalaryStats["1"]["high"][j])
    				   }
    					var trace1 = {
    					x: xData,
    					y: y1Data,

    					name: 'Low Salary',
    					type: 'bar'
    					};

    					var trace2 = {
    					x: xData,
    					y: y2Data,
    					name: 'Medium Salary',
    					type: 'bar'
    					};
    					var trace3 = {
    					x: xData,
    					y: y3Data,
    					name: 'High Salary',
    					type: 'bar'
    					};

    					var data = [trace1, trace2, trace3];

    					var layout = {
    					title: 'Left Employee Salary Stats	',
    					height: 450,
    					width:  600,
    					barmode: 'stack'
    					};

    					Plotly.newPlot('div8', data, layout);

    	         });
    	}
    	$scope.stayingEmployeeSalary = function(){
    		var output;
    	    $http({
    			url:"http://52.53.150.216:80/getSalaryStats",
    			dataType: "json",
    			data: '',
    			method: "GET",
    			headers: {
    				"Content-Type": "application/json"
    			}}).then( function(response)
    			{
    	               $scope.stayingEmployeeSalary = response.data;
    				   console.log($scope.stayingEmployeeSalary)
    				   var xData = []
    				   var y1Data = []
    				   var y2Data = []
    				   var y3Data = []

    				   for(var j in $scope.stayingEmployeeSalary["0"]["low"]){
    				       xData.push(j)
    				       y1Data.push($scope.stayingEmployeeSalary["0"]["low"][j])
    				   }

    				   for(var j in $scope.stayingEmployeeSalary["0"]["medium"]){
    				       y2Data.push($scope.stayingEmployeeSalary["0"]["medium"][j])
    				   }

    				   for(var j in $scope.stayingEmployeeSalary["0"]["high"]){
    				       y3Data.push($scope.stayingEmployeeSalary["0"]["high"][j])
    				   }
    					var trace1 = {
    					x: xData,
    					y: y1Data,

    					name: 'Low Salary',
    					type: 'bar'
    					};

    					var trace2 = {
    					x: xData,
    					y: y2Data,
    					name: 'Medium Salary',
    					type: 'bar'
    					};
    					var trace3 = {
    					x: xData,
    					y: y3Data,
    					name: 'High Salary',
    					type: 'bar'
    					};

    					var data = [trace1, trace2, trace3];

    					var layout = {
    					title: 'Current Employee Salary Stats	',
    					height: 450,
    					width:  600,
    					barmode: 'stack'
    					};

    					Plotly.newPlot('div7', data, layout);

    	         });
    	}
    	
    	$scope.employeeLeftDepartmentStats = function(){
    		var output;
    	    $http({
    			url:"http://52.53.150.216:80/getEmpByDept",
    			dataType: "json",
    			data: '',
    			method: "GET",
    			headers: {
    				"Content-Type": "application/json"
    			}}).then( function(response)
    			{
    	               $scope.employeeByDeptData = response.data;
    				   console.log($scope.employeeByDeptData)
    				   var xData = []
    				   var y1Data = []
    				   var y2Data = []
    	               var y3Data = []
    				   for( var i in $scope.employeeByDeptData){
    						xData.push(i)
    						y1Data.push($scope.employeeByDeptData[i][0])
    						y2Data.push($scope.employeeByDeptData[i][1])
    	                    y3Data.push($scope.employeeByDeptData[i][2])

    					}
    					var trace1 = {
    					x: xData,
    					y: y1Data,

    					name: 'Winners',
    					type: 'bar'
    					};

    					var trace2 = {
    					x: xData,
    					y: y2Data,
    					name: 'Frustrated',
    					type: 'bar'
    					};
    					var trace3 = {
    					x: xData,
    					y: y3Data,
    					name: 'Bad Match',
    					type: 'bar'
    					};

    					var data = [trace1, trace2, trace3];

    					var layout = {
    					title: 'Employees Left Department Statistics',
    					height: 450,
    					width:  600,
    					barmode: 'group'
    					};

    					Plotly.newPlot('div6', data, layout);

    	         });
    	}
    	$scope.meanData = function(){
    	
    	var output;
	    $http({
			url:"http://52.53.150.216:80/getMeanData",
			dataType: "json",
			data: '',
			method: "GET",
			headers: {
				"Content-Type": "application/json"
			}}).then( function(response) 
			{
	               $scope.meanData = response.data;
				   console.log($scope.meanData)
				   var xData = []
				   var y1Data = []
				   var y2Data = []
				   for( var i in $scope.meanData){
					   	if(i=='left') continue;
					   	if(i=='average_montly_hours'){
					   		xData.push(i)
							y2Data.push(($scope.meanData[i][0])/100)
							y1Data.push(($scope.meanData[i][1])/100)
					   	}else{
					   		xData.push(i)
							y2Data.push($scope.meanData[i][0])
							y1Data.push($scope.meanData[i][1])
	
					   	}
					}
					var trace1 = {
					x: xData,
					y: y1Data,
					name: 'Left Employees',
					type: 'bar'
					};
					var trace2 = {
					x: xData,
					y: y2Data,
					name: 'Current Employees',
					type: 'bar'
					};
					var data = [trace1, trace2];
					var layout = {
					title: 'Mean Employee Statistics for feature vectors',
					height: 450,
					width:  600,
					barmode: 'group'
					};
					Plotly.newPlot('div5', data, layout);
	         });
    	}
    	$scope.goodEmployeeChurn = function(){
    		var output;
	    	$http({
				url:"http://52.53.150.216:80/getGoodEmployeeChurn",
				dataType: "json",
				data: '',
				method: "GET",
				headers: {
							"Content-Type": "application/json"
			}}).then( function(response) 
			{
	               $scope.getGoodEmployeeStats = response.data;
				   console.log($scope.getGoodEmployeeStats)
				   var xData = []
				   var yData = []
				   for( var i in $scope.getGoodEmployeeStats){
						xData.push(i)
						yData.push($scope.getGoodEmployeeStats[i])
					}
					console.log(yData)
					console.log(xData)
					var data = [{
						y: yData,
						x: xData,
						name: 'Department',
						type: 'bar'
					}];
					var layout = {
						title: 'Possible Churn of Good Employees per Deparment (Top 100)',
						height: 450,
						width: 550
					};
					Plotly.newPlot('div4', data, layout);
	         });
    	}
    	
    	$scope.promotion = function(){
    		var output;
	    	$http({
				url:"http://52.53.150.216:80/getPromotionStats",
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
    	$scope.featureTrends = function(){
    		var output;
	    	$http({
				url:"http://52.53.150.216:80/getFeatureImportance",
				dataType: "json",
				data: '',
				method: "GET",
				headers: {
							"Content-Type": "application/json"
			}}).then( function(response) 
			{
	               $scope.featureStats = response.data;
				   console.log($scope.featureStats)
				   var xData = []
				   var yData = []
				   for( var i in $scope.featureStats){
						xData.push(i)
						yData.push($scope.featureStats[i])
					}
					console.log(yData)
					console.log(xData)
					var data = [{
						values: yData,
						labels: xData,
						type: 'pie'
					}];
					var layout = {
						title: 'Feature Relevance of Churn',
						height: 450,
						width: 550
					};
					Plotly.newPlot('div3', data, layout);
	         });
    	}
    	
    	$scope.promotion = function(){
    		var output;
	    	$http({
				url:"http://52.53.150.216:80/getPromotionStats",
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
			url:"http://52.53.150.216:80/getDeptTrends",
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