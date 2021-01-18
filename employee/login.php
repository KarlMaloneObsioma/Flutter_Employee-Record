<?php

require "connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    $response = array();

    $username = $_POST['username'];
    $password = $_POST['password'];
 

    $check = "SELECT * FROM tbl_users WHERE username='$username' and password='$password'";
    $result = mysqli_fetch_array(mysqli_query($con,$check));

    if (isset($result)) {
        $response['value'] = 1;
        $response['message'] = "Login Successfully";
        $response['username'] = $result['username'];
        $response['email'] = $result['email'];
        $response['userid'] = $result['userid'];
        
        echo json_encode($response);
        
    }
    else
    {
        $response['value'] = 0;
        $response['message'] = "Login Failed";
        echo json_encode($response);
    }

    

   
}

?>