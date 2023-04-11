<?php
if(!defined('BASEPATH')) exit('No direct script access allowed');
header('Content-Type: text/html; charset=utf-8');
require APPPATH . '/libraries/BaseController.php';
/**
* Class for managing user accounts
* edit/delete/block/verify_email/change_password functions
*/
class Account extends BaseController {
	

	public function __construct(){
        parent::__construct();
        $this->load->model('account_model');
        $this->load->model('verify_model');
    }

		public function users()
    {   $this->isLoggedIn();
        $this->load->template('android/listing', []); // this will load the view file
    }


		function getUsersAjax(){
      // Datatables Variables

        $draw = intval($_POST['draw']);
        $start = intval($_POST['start']);
        $length = intval($_POST['length']);
				$columnIndex = $_POST['order'][0]['column']; // Column index
				$columnName = $_POST['columns'][$columnIndex]['data']; // Column name
				$columnSortOrder = $_POST['order'][0]['dir']; // asc or desc
				$searchValue="";
				if(isset($_POST['search']['value'])){
					$searchValue = $_POST['search']['value']; // Search value
				}

				$columnName="";
				if(isset($_POST['columns'][$columnIndex]['data'])){
					$columnSortOrder = $_POST['columns'][$columnIndex]['data']; // Search value
				}

        $columnSortOrder = "ASC";
				if(isset($_POST['order'][0]['dir'])){
					$columnSortOrder = $_POST['order'][0]['dir']; // Search value
				}


        $users = $this->account_model->userListing($columnName,$columnSortOrder,$searchValue,$start, $length);
				$total_users = $this->account_model->get_total_android_users($searchValue);
        //var_dump($users); die;
        $dat = array();

				 $count = $start + 1;
        foreach($users as $r) {
					$block_status = $r->blocked==0?'unblock user':'block user';
					$color = $r->blocked==0?'color:purple;':'color:grey;';

             $dat[] = array(
							    $count,
                  $r->name,
                  $r->email,
									'<button title="'.$block_status.'" data-action="block" data-id="'.$r->id.'" data-blocked="'.$r->blocked.'" onclick="user_action(event)"  type="button" class="btn btn-default btn-lg m-l-15 waves-effect" style="float: none;">'.
									'<i style="'.$color.'" data-action="block" data-blocked="'.$r->blocked.'" style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">block</i></button>'.
									'<button data-action="delete" onclick="user_action(event)" data-id="'.$r->id.'" type="button" class="btn btn-danger btn-lg m-l-15 waves-effect" style="float: none;">'.
									'<i data-action="delete" onclick="user_action(event)" data-id="'.$r->id.'" style="color:red;margin-bottom:5px;"  class="material-icons list-icon" data-type="audio" data-id="'.$r->id.'">delete</i></button>'
             );
						 $count++;

        }

        $output = array(
             "draw" => $draw,
               "recordsTotal" => $total_users,
               "recordsFiltered" => $total_users,
               "data" => $dat
          );
        echo json_encode($output);
    }

		/**
		 * This function used to authenticate user
		 */
		public function loginUser(){
			$data = $this->get_data();
			if(!empty($data)){
				  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $password = isset($data->password)?filter_var($data->password, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$packageName = isset($data->packageName)?filter_var($data->packageName, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$name = isset($data->name)?filter_var($data->name, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$type = isset($data->type)?filter_var($data->type, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

          if($type!="" && $name!=""){
             $this->account_model->socialLogin($email,$type,$name,$packageName);
					}else{
					  $_email_error = $email!=""?"":"Email Address Is not valid!";
					  $_password_error = $password==""?"Password is empty!":"";
					  if($_email_error !="" || $_password_error != ""){
							 $this->response("error",$_email_error."\n".$_password_error);
	             exit;
					  }
						$this->account_model->authenticateUser($email,$password,$packageName);
				 }

			 }
			 echo json_encode(array("status" => $this->account_model->status
			 ,"message" => $this->account_model->message,"user" => $this->account_model->user));
		}


		/**
		 * This function used to register user
		 */
		public function registerUser(){
			$data = $this->get_data();
			if(!empty($data)){
				  $name = isset($data->name)?filter_var($data->name, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$password = isset($data->password)?filter_var($data->password, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

					//check for empty or invalid fields
					$_name_error = $name==""?"Name is empty!":"";
					$_email_error = $email!=""?"":"Email Address Is not valid!";
					$_password_error = $password==""?"Password is empty!":"";
					if($_name_error !="" || $_email_error !="" || $_password_error != ""){
						 $this->response("error",$_name_error."\n".$_email_error."\n".$_password_error);
             exit;
					}
					//insert into database
					$this->account_model->registerUser($name,$email,$password);
					if($this->account_model->status == "ok"){
             //if user registration was successful
						 //send email verification link
						 $link = $this->getVerificationLink($email);
						 $subject = "User Registration";
						 $htmlContent = '<p>Hi '.$name.',</p>';
						 $htmlContent .= '<p>Thank you for registering on our platfrom. ';
						 $htmlContent .= '<p>Please click on the link to verify your email : <a href="'.$link.'">VERIFY EMAIL</a>.</p><br>';
						 $htmlContent .= '<p>Kind Regards,</p>';
						 $htmlContent .= '<p>Management Team.</p>';
						 $this->sendMail($email,$subject,$htmlContent);
					}
			 }
			 $this->response($this->account_model->status,$this->account_model->message);
		}

    /**
    * resend verification email to users email Address
    */
    public function resendVerificationMail(){
      $data = $this->get_data();
     if(!empty($data)){
         $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

         //check for empty or invalid fields
         $_email_error = $this->validateEmail($email)==TRUE?"":"Email Address Is not valid!";
         if($_email_error !=""){
            $this->response("error",$_email_error);
            exit;
         }
         if($this->account_model->verifyEmailExists($email,"email") == TRUE){
             //if user registration was successful
            //send email verification link
            $link = $this->getVerificationLink($email);
            $subject = "User Registration";
            $htmlContent = '<p>Hi '.$email.',</p>';
            $htmlContent .= '<p>Thank you for registering on our platfrom. ';
            $htmlContent .= '<p>Please click on the link to verify your email : <a href="'.$link.'">VERIFY EMAIL</a>.</p><br>';
            $htmlContent .= '<p>Kind Regards,</p>';
            $htmlContent .= '<p>Management Team.</p>';
            $this->sendMail($email,$subject,$htmlContent);
            $this->response("ok","A verification link was sent to your mail, follow the link to verify your email address.");
         }else{
           $this->response("error","Sorry, email address doesnt exist");
         }
      }else{
        $this->response($this->account_model->status,$this->account_model->message);
      }

    }

		/**
		 * This function used to send reset password link
		 */
		public function resetPassword(){
			$data = $this->get_data();
			if(!empty($data)){
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

					//check for empty or invalid fields
					$_email_error = $this->validateEmail($email)==TRUE?"":"Email Address Is not valid!";
					if($_email_error !=""){
						 $this->response("error",$_email_error);
             exit;
					}
					if($this->account_model->verifyEmailExists($email,"email") == TRUE){
             //if user email exists in the database
						 //send password reset link
						 $link = $this->getPasswordResetLink($email);
						 $subject = "Password Reset";
						 $htmlContent = '<p>Hi '.$email.',</p>';
						 $htmlContent .= '<p>Please click on the link to reset your password : <a href="'.$link.'">RESET PASSWORD</a>.</p><br>';
						 $htmlContent .= '<p>Kind Regards,</p>';
						 $htmlContent .= '<p>Management Team.</p>';
						 $this->sendMail($email,$subject,$htmlContent);
             $this->response("ok","A password reset link was sent to your mail, please click on the link to reset your password.");
					}else{
						$this->response("error","Sorry, email address doesnt exist");
					}
			 }else{
         $this->response($this->account_model->status,$this->account_model->message);
       }

		}

		//verify email when user clicks on the link
		function verifyEmailLink(){
			// Get email and activation code from URL values at index 2-3
			//if you are using your IP-ADDRESS, this should be 3-4
				$r = $_SERVER['REQUEST_URI'];
        $r = explode('/', $r);
				$email = isset($r[3])?filter_var(urldecode($r[3]), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$activation_id = isset($r[2])?filter_var($r[2], FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				if($this->validateEmail($email)==FALSE || $activation_id==""){
					  //redirect to message page with message for user
            $data['status'] = 'Error';
            $data['message'] = 'Your email address cannot be verified at the moment.';
            $this->load->views('message', $data); // this will load the view file
					 exit;
				}
				// Check activation id in database
				if($this->verify_model->checkActivationDetails($email, $activation_id) == TRUE){
					//delete activation details
					$this->verify_model->deleteActivationDetails($email, $activation_id);
					//update user to verified
					$this->account_model->updateUserVerfication($email);
					//redirect to message page with message for user
					$data['status'] = 'ok';
					$data['message'] = 'Your account have been successfully verified.';
					$this->load->views('message', $data); // this will load the view file
				}else{
					 //redirect to message page with message for user
          $data['status'] = 'Error';
          $data['message'] = 'Your email address cannot be verified at the moment.';
          $this->load->views('message', $data); // this will load the view file
				}
		}

		function resetLink(){
      $this->load->library('session');
			// Get email and activation code from URL values at index 2-3
			//if you are using your IP-ADDRESS, this should be 3-4
		  $r = $_SERVER['REQUEST_URI'];
			$r = explode('/', $r);
			$email = isset($r[3])?filter_var(urldecode($r[3]), FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			$activation_id = isset($r[2])?filter_var($r[2], FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			if($this->validateEmail($email)==FALSE || $activation_id==""){
				 //redirect to message page with message for user

        $data['status'] = 'Error';
        $data['message'] = 'Password reset failed, invalid inputs detected.';
        $this->load->views('message', $data); // this will load the view file
				 exit;
			}
			// Check activation id in database
			if($this->verify_model->checkActivationDetails($email, $activation_id) == TRUE){

				//take user to where he/she will update his password
        $data['email'] = $email;
        $data['activation_id'] = $activation_id;
        $this->load->views('resetPasswordForm', $data);
			}else{

         $data['status'] = 'Error';
         $data['message'] = 'Password reset failed, wrong inputs detected.';
         $this->load->views('message', $data); // this will load the view file
			}
		}

		//change user password
		public function changeUserPassword(){
      $this->load->library('session');
      $this->load->library('form_validation');

      $this->form_validation->set_rules('password1','Password','required|min_length[6]|xss_clean');
      $this->form_validation->set_rules('password2','Confirm Password','trim|required|matches[password1]|min_length[6]|xss_clean');

      $email = $this->input->post('email')==""?"":$this->input->post('email');
      $activation_id = $this->input->post('activation_id')==""?"":$this->input->post('activation_id');

      if($this->form_validation->run() == FALSE)
      {
        $data['email'] = $email;
        $data['activation_id'] = $activation_id;
        $this->load->views('resetPasswordForm', $data);
      }else{
        $password1 = $this->input->post('password1');

        // Check activation id in database
        if($this->verify_model->checkActivationDetails($email, $activation_id) == TRUE){
          //update user password
          $this->account_model->updateUserPassword($email,$password1);
          //delete code in database
          $this->verify_model->deleteActivationDetails($email, $activation_id);
          //redirect with a message for the user
          $data['status'] = 'ok';
          $data['message'] = 'Password changed successfully.';
          $this->load->views('message', $data); // this will load the view file
        }else{
           //redirect with a message for the user
          $data['status'] = 'Error';
          $data['message'] = 'Password reset failed, You are not authorized.';
          $this->load->views('message', $data); // this will load the view file
        }
      }
		}

		function deleteUser($id=0)
    {
      $this->load->library('session');
      $this->account_model->deleteUser($id);
      if($this->account_model->status == "ok")
      {
				//send push action to user
				$user = $this->account_model->get_android_user($id);
				if(count((array)$user)>0){
					$this->load->model('settings_model');
					$server_key = $this->settings_model->getFcmServerKey();
					$this->load->model('fcm_model');
					$this->fcm_model->sendUserRelatedPushNotification($server_key,$user->email,"delete");
				}
          $this->session->set_flashdata('success', $this->account_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->account_model->message);
      }
      redirect('androidUsers');
    }

		function blockUser($id=0)
    {
      $this->load->library('session');
			if($id!=0){
				$this->account_model->blockOrUnblockUser($id,0);
	      if($this->account_model->status == "ok"){
					  //send push action to user
						$user = $this->account_model->get_android_user($id);
						if(count((array)$user)>0){
							$this->load->model('settings_model');
							$server_key = $this->settings_model->getFcmServerKey();
							$this->load->model('fcm_model');
						  $this->fcm_model->sendUserRelatedPushNotification($server_key,$user->email,"block");
						}

	        $this->session->set_flashdata('success', $this->account_model->message);
	      }else{
	          $this->session->set_flashdata('error', $this->account_model->message);
	      }
			}else{
          $this->session->set_flashdata('error', $this->account_model->message);
			}

      redirect('androidUsers');
    }

		function unBlockUser($id=0)
    {
      $this->load->library('session');
			if($id!=0){
				$this->account_model->blockOrUnblockUser($id,1);
	      if($this->account_model->status == "ok"){
					$user = $this->account_model->get_android_user($id);
					if(count((array)$user)>0){
						$this->load->model('settings_model');
						$server_key = $this->settings_model->getFcmServerKey();
						$this->load->model('fcm_model');
						$this->fcm_model->sendUserRelatedPushNotification($server_key,$user->email,"unblock");
					}
	          $this->session->set_flashdata('success', $this->account_model->message);
	      }else{
	          $this->session->set_flashdata('error', $this->account_model->message);
	      }
			}else{
				$this->session->set_flashdata('error', $this->account_model->message);
			}
      redirect('androidUsers');
    }
}
