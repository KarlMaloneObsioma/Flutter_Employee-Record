<?php

require "connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
   
    $response = array();
    $employee_id = $_POST['employee_id'];
    $employee_name = $_POST['employee_name'];
    $employee_position = $_POST['employee_position'];
    $employee_address = $_POST['employee_address'];
    $clientid = $_POST['clientid'];


    $insert = "UPDATE tbl_employee SET employee_id ='$employee_id',employee_name ='$employee_name', employee_position = '$employee_position',employee_address = '$employee_address' WHERE id='$clientid'";
    if (mysqli_query($con,$insert))
    {
        $response['value'] = 1;
        $response['message'] = "Record Successfully";
        echo json_encode($response);
    }
    else
    {
        $response['value'] = 0;
        $response['message'] = "Record Failed";
        echo json_encode($response);
    }
     
    
    

  
   
 
}

?>