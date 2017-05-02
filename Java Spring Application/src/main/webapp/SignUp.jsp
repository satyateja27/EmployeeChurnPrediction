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
    
    <title>ChurnPrediction | SignUp</title>
    
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
	<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
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
		<p>${error}</p>
		<br/><br/>
		<h3>Sign Up for an Account</h3>
		<br/><br/>
		<form method="post" action="/api/user/register">
			<div><input type="text" class="form-control" placeholder="First Name" name="first_name"><br></div>
			<div><input type="text" class="form-control" placeholder="Last Name" name="last_name"><br></div>
			<div><input type="email" class="form-control" placeholder="Email id" name="email"><br></div>
			<div><input type="password" class="form-control" placeholder="Password" name="password"><br></div>
			<div><input type="text" class="form-control" placeholder="Organization" name="org"><br></div>
			<div><input type="submit" class="btn btn-primary" value="Sign Up"/></div>
		</form>
		<br/>
		<div><p>Already have an account?  <a href="/">Login here</a></p></div>
	</div>	
</body>
</html>