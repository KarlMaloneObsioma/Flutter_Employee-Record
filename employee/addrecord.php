<?php

require "connect.php";

if($_SERVER['REQUEST_METHOD']=="POST"){
    $data = json_decode(file_get_contents('php://input'), true);
    $response = array();
    $employee_id = $data['employee_id'];
    $employee_name = $data['employee_name'];
    $employee_position = $data['employee_position'];
    $employee_address = $data['employee_address'];
    $clientid = $data['clientid'];


    $insert ="INSERT INTO tbl_employee VALUE(NULL,'$employee_id','$employee_name','$employee_position','$employee_address','$clientid')";
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