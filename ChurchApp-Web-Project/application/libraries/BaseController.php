<?php defined ( 'BASEPATH' ) or exit ( 'No direct script access allowed' );

/**
 * Class : BaseController
 * Base Class to control over all the classes
 */
class BaseController extends CI_Controller {

	protected $data = [];

	public function __construct()
	 {
			// Ensure you run parent constructor
			parent::__construct();
	 }

	 public function check_notify_user($itm_id, $type, $user, $email){
 		  if($user == $email)return;
				$this->load->model('socials_model');
 		  $settings = $this->socials_model->fetch_user_settings($user);
			//var_dump($settings); die;
 			$user_data = $this->socials_model->getUpdatedUserProfile($email);
 			$msg = "New Notification";
       if($type == "follow"){
           $msg = $user_data->name." started following you";
 					$this->socials_model->saveNotificationData($itm_id,$type,$email,$user);
					if($settings->notify_follows == 0){
						$this->notify_user($user,$user_data->avatar,  $msg);
					}
 			}else if($type == "comment"){
           $msg = $user_data->name." commented on your post";
 					$this->socials_model->saveNotificationData($itm_id,$type,$email,$user);
					if($settings->notify_comments == 0){
						$this->notify_user($user,$user_data->avatar,  $msg);
					}
 			}else if($type == "like"){
           $msg = $user_data->name." liked your post";
 					$this->socials_model->saveNotificationData($itm_id,$type,$email,$user);
					if($settings->notify_likes == 0){
						$this->notify_user($user,$user_data->avatar,  $msg);
					}
 			}
 	}

 	public function notify_user($email, $avatar, $msg){
 		$this->load->model('settings_model');
 		$API_SERVER_KEY = $this->settings_model->getFcmServerKey();
 		$this->load->model('fcm_model');
 		$this->fcm_model->userActionsNotification($API_SERVER_KEY, $email, $avatar,$msg);
 	}

	/**
	 * This function used to check the user is logged in or not
	 */
	function isLoggedIn() {
		$this->load->library('session');
		$isLoggedIn = $this->session->userdata ( 'isLoggedIn' );

		if (! isset ( $isLoggedIn ) || $isLoggedIn != TRUE) {
			redirect ( base_url().'login' );
		}
	}


	public function auth($headers){
		/*
		 * Look for the 'authorization' header
		 */
		if (array_key_exists('Authorization', $headers)) {
		$authHeader = $headers['Authorization'];

		/*
				 * Extract the jwt from the Bearer
				 */
				list($jwt) = sscanf( $authHeader, 'Bearer %s');

				if ($jwt) {
						try {

								/*
								 * decode the jwt using the key from config
								 */
								$secretKey = base64_decode(JWT_KEY);

								$token = JWT::decode($jwt, $secretKey, array('HS512'));

								return array("errors"=>false);


						} catch (Exception $e) {
								/*
								 * the token was not able to be decoded.
								 * this is likely because the signature was not able to be verified (tampered token)
								 */
								http_response_code(401);
								echo json_encode(array("errors"=>true, "status"=>"error", "message"=>"Unauthorized")); exit;
						}
				} else {
						/*
						 * No token was able to be extracted from the authorization header
						 */
								http_response_code(401);
								echo json_encode(array("errors"=>true, "status"=>"error",  "message"=>"No request token found. Sign in and try again.")); exit;
				}
		} else {
				/*
				 * The request lacks the authorization token
				 */
					 http_response_code(401);
					 echo json_encode(array("errors"=>true, "status"=>"error",  "message"=>"No request token found. Sign in and try again.")); exit;
		}
	}

	/**
	 * This function used to get and sanitize input data
	 */
	 public function get_data(){
		 $data = [];
		 if(isset($_POST['data'])){
			 $data = json_decode($_POST['data']);
		 }else{
			 if(null != file_get_contents('php://input')){
				  $data = (object) json_decode(file_get_contents('php://input'), TRUE)['data'];
			 }

		 }

		 if(isset($data->email)){
			 $data->email = filter_var($this->cleanup($data->email), FILTER_SANITIZE_STRING);
		 }
		 if(isset($data->name)){
			 $data->name = filter_var($this->cleanup($data->name), FILTER_SANITIZE_STRING);
		 }
    if(isset($data->password)){
		     $data->password = filter_var($this->cleanup($data->password), FILTER_SANITIZE_STRING);
		 }
		 if(isset($data->token)){
 		     $data->token = filter_var($this->cleanup($data->token), FILTER_SANITIZE_STRING);
 		 }
		 if(isset($data->plan)){
 		     $data->plan = filter_var($this->cleanup($data->plan), FILTER_SANITIZE_STRING);
 		 }
		 if(isset($data->date)){
 		     $data->date = filter_var($this->cleanup($data->date), FILTER_SANITIZE_STRING);
 		 }


		 return $data;
	 }

	 public function cleanup($data)
	 {
		   $data = $this->security->xss_clean($data);
			 $data = trim($data);
			 $data = stripslashes($data);
			 $data = htmlspecialchars($data);
			 return $data;
	 }

  /**
	* uncomment the lines in this function to support check headers
	*/
	 public function check_headers(){
		 //$headers = $this->input->request_headers();
		 //$this->auth($headers)["errors"];
	 }

	 public function json_response($data){
     echo json_encode($data);
   }


	 public function response($status,$message){
     echo json_encode(array("status" => $status,"message" => $message));
   }

   public function validateEmail($email)   {
     // SET INITIAL RETURN VARIABLES
         $emailIsValid = FALSE;
        // MAKE SURE AN EMPTY STRING WASN'T PASSED
         if (!empty($email)){
             // GET EMAIL PARTS
             $domain = ltrim(stristr($email, '@'), '@') . '.';
             $user   = stristr($email, '@', TRUE);
             // VALIDATE EMAIL ADDRESS
             if(!empty($user) && !empty($domain) && checkdnsrr($domain)){
               $emailIsValid = TRUE;
             }
         }
     // RETURN RESULT
       return $emailIsValid;
   }

   //function to process link for both email activation and password reset
   public function getVerificationLink($email){
		 $this->load->model('verify_model');
		 $encoded_email = urlencode($email);
		 $data = array('email' => $email,'activation_id' => $this->generate_string(),'agent' => $_SERVER['HTTP_USER_AGENT'],'client_ip' => $_SERVER['REMOTE_ADDR']);
		 //save details to database
		 $this->verify_model->insertData($data);

		 //return url to be sent to user email
		 return $this->getBaseUrl() . "verifyEmailLink/" . $data['activation_id'] . "/" . $encoded_email;
   }

   public function getPasswordResetLink($email){
		 $this->load->model('verify_model');
     $encoded_email = urlencode($email);
     	$data = array('email' => $email,'activation_id' => $this->generate_string(),'agent' => $_SERVER['HTTP_USER_AGENT'],'client_ip' => $_SERVER['REMOTE_ADDR']);
     //save details to database
     $this->verify_model->insertData($data);

     //return url to be sent to user email
     return $this->getBaseUrl() . "resetLink/" . $data['activation_id'] . "/" . $encoded_email;
   }


 //function to generate random string
   private function generate_string($strength = 15) {
     $chars = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ';
     $input_length = strlen($chars);
     $random_string = '';
     for($i = 0; $i < $strength; $i++) {
         $random_character = $chars[mt_rand(0, $input_length - 1)];
         $random_string .= $random_character;
     }
     return $random_string;
   }

   //function to return base url
   public function getBaseUrl(){
     $base  = "http://".$_SERVER['HTTP_HOST'];
     return $base .= str_replace(basename($_SERVER['SCRIPT_NAME']),"",$_SERVER['SCRIPT_NAME']);
   }

 //function for saving success n error messages to session
   function flash_message($status, $message) {
     $this->load->library('session');
     $_SESSION['message'] = array('status' => $status, 'message' => $message);
 }

 public function sendMail($recipient,$subject,$body){
 //Load email library
	 $this->load->library('email');

	 //SMTP & mail configuration
	 $this->load->model('settings_model');
	 $settings = $this->settings_model->getSettings();
	 //var_dump($settings); die;
	 $config = array(
		 'protocol'  => $settings->mail_protocol,
		 'smtp_host' => $settings->mail_smtp_host,
		 'smtp_port' => $settings->mail_port,
		 'smtp_user' => $settings->mail_username,
		 'smtp_pass' => $settings->mail_password,
		 'mailtype'  => 'html',
		 'charset'   => 'utf-8'
	 );
	 $this->email->initialize($config);
	 $this->email->set_mailtype("html");
	 $this->email->set_newline("\r\n");


	 $this->email->to($recipient);
	 $this->email->from($settings->mail_username, $settings->mail_username);
	 $this->email->subject($subject);
	 $this->email->message($body);

	 //Send email
	 $r = $this->email->send();
	 //var_dump($r); die;
	 //echo $this->email->print_debugger(); die;
	 return $r;
}
}
