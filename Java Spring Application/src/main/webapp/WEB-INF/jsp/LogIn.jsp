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
    
    <title>ChurnPrediction | Login</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	  <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>
	  <script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.0/jquery.min.js"></script>
</head>
<body>
		<div>
			<nav class="navbar navbar-dark bg-primary" style="padding:10px">
				<h4 style="text-align:center">Employee Churn Analysis and Prediction</h4>
				<p style="text-align:center">Protect your most valued employee</p>
			</nav>
		</div>
		<div class="col-sm-4" style="text-align:center"></div>
		<div class="col-sm-4" style="text-align:center">
		<p>${message}</p>
		<h3>Log in to fing Employee Churn Analysis</h3><br>
		<form method="post" action="/api/user/login">
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">
				<button type="button" class="btn btn-default">
					<span class="glyphicon glyphicon-user"></span>
				</button>
			</span>
			<input type="email" class="form-control" placeholder="Email id" name="email" aria-describedby="basic-addon1" style="height:50px"><br>
		</div>
		<br>
		<div class="input-group">
			<span class="input-group-addon" id="basic-addon1">
				<button type="button" class="btn btn-default">
					<span class="glyphicon glyphicon-lock"></span>
				</button>
			</span>
			<input type="password" class="form-control" placeholder="Password" name="password" aria-describedby="basic-addon1" style="height:50px"><br>
		</div>
		<br>
		<div><input type="submit" class="btn btn-primary" value="Login" /></div>
		</form>
		<br>
		<div><p>Don't have an account?  <a href="/signup">Signup here</a></p></div>
		</div>
	
</body>
</html>