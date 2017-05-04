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
         		<div class="panel-body" style="text-align:center">
				<h1>Profile</h1><br/><br/>
				<img src="/image.jpg" style="width:200px; heigth:300px"> <br/><br/>
				<h4><span class="glyphicon glyphicon-user"></span> First Name: ${user.getFirstName()}</h4>
				<h4><span class="glyphicon glyphicon-user"></span> Last Name: ${user.getLastName()}</h4>
				<h4><span class="glyphicon glyphicon-envelope"></span> Email: ${user.getEmail()}</h4>
				<h4><span class="glyphicon glyphicon-map-marker"></span> Organization: ${user.getOrg()}</h4>
			</div>
         	</div>
         	<div class="col-sm-1"></div>
         </div>
	
</body>
</html>