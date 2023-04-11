<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';
/*
* This class handles some of the requests from the android client app
*/
class Socials extends BaseController {

	public function __construct()
    {
        parent::__construct();
    }

		function userBioInfo(){
			$data = $this->get_data();
			$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			$viewer = isset($data->viewer)?filter_var($data->viewer, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				$this->load->model('socials_model');
				$user = $this->socials_model->getuserBioInfo($email);
				if($user){
					if($user->date_of_birth!=""){
						$date = date_create($user->date_of_birth);
		        $user->date_of_birth = date_format($date, 'jS F Y');
					}

					//do some checks here
					if($email!=$viewer){
						if($user->show_phone!=0){
							  $user->phone = "";
						}
						if($user->show_dateofbirth!=0){
							if($user->date_of_birth!=""){
								$date = date_create($user->date_of_birth);
								$user->date_of_birth = date_format($date, 'jS F');
							}
						}
					}
				}

				echo json_encode(array("status" => "ok", "user" => $user));
		}

		function userBioInfoFlutter(){
			$data = $this->get_data();
			$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			$viewer = isset($data->viewer)?filter_var($data->viewer, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				$this->load->model('socials_model');
				$user = $this->socials_model->getuserBioInfo($email);
				$post_count = $this->socials_model->get_total_posts($email);
				$followers_count = $this->socials_model->getUsersFollowersCount($email);
				$following_count = $this->socials_model->getUsersFollowingCount($email);
				$isFollowing = $this->socials_model->getFollowStatus($email,$viewer);
				if($user){
					if($user->date_of_birth!=""){
						$date = date_create($user->date_of_birth);
		        $user->date_of_birth = date_format($date, 'jS F Y');
					}

					//do some checks here
					if($email!=$viewer){
						if($user->show_phone!=0){
							  $user->phone = "";
						}
						if($user->show_dateofbirth!=0){
							if($user->date_of_birth!=""){
								$date = date_create($user->date_of_birth);
								$user->date_of_birth = date_format($date, 'jS F');
							}
						}
					}
				}

				echo json_encode(array("status" => "ok", "user" => $user, "post_count" => $post_count
				, "followers_count" => $followers_count , "following_count" => $following_count , "isFollowing" => $isFollowing));
		}

		function userFollowPostCount(){
			$data = $this->get_data();
			$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			$viewer = isset($data->viewer)?filter_var($data->viewer, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				$this->load->model('socials_model');
				$post_count = $this->socials_model->get_total_posts($email);
				$followers_count = $this->socials_model->getUsersFollowersCount($email);
				$following_count = $this->socials_model->getUsersFollowingCount($email);
				$isFollowing = $this->socials_model->getFollowStatus($email,$viewer);

				echo json_encode(array("status" => "ok", "post_count" => $post_count
				, "followers_count" => $followers_count , "following_count" => $following_count , "isFollowing" => $isFollowing));
		}

		//fetch audios/videos
		function fetch_posts(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->fetch_posts($page,$email);
				$total_items = $this->socials_model->get_total_posts($email);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","posts" => $results,"isLastPage" => $isLastPage));
		}

		//fetch audios/videos
		function fetch_posts_flutter(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->fetch_posts_flutter($page,$email);
				$total_items = $this->socials_model->get_total_posts($email);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","posts" => $results,"isLastPage" => $isLastPage));
		}

		function fetchUserPins(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$data = $this->get_data();
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->fetchUserPins($page,$email);
				$total_items = $this->socials_model->get_user_total_pins($email);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","posts" => $results,"isLastPage" => $isLastPage));
		}

		function fetchUserPinsFlutter(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$data = $this->get_data();
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->fetchUserPinsFlutter($page,$email);
				$total_items = $this->socials_model->get_user_total_pins($email);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","posts" => $results,"isLastPage" => $isLastPage));
		}

		function fetchUserPosts(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$data = $this->get_data();
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$viewer = isset($data->viewer)?filter_var($data->viewer, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$me = FALSE;
				if($email == $viewer){
					$me = TRUE;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->fetch_user_posts($page,$email, $viewer,$me);
				$total_items = $this->socials_model->get_user_total_posts($email,$me);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","posts" => $results,"isLastPage" => $isLastPage));
		}

		function fetchUserPostsflutter(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$data = $this->get_data();
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$viewer = isset($data->viewer)?filter_var($data->viewer, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$me = FALSE;
				if($email == $viewer){
					$me = TRUE;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->fetch_user_posts_fluter($page,$email, $viewer,$me);
				$total_items = $this->socials_model->get_user_total_posts($email,$me);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","posts" => $results,"isLastPage" => $isLastPage));
		}


		//process user like or unlike media
				public function likeunlikepost(){
					$data = $this->get_data();
					$this->load->model('socials_model');
					$count = 0;
					if(!empty($data)){
						  $user = isset($data->user)?filter_var($data->user, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
						  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
						  $id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
							$action = isset($data->action)?filter_var($data->action, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

						  if($email!="" && $id !=0){
								 $this->socials_model->likeunlikepost($id,$email,$action);
								 $count = $this->socials_model->getUsersPostLikesCount($id);
								 if($action == "like"){
									 $this->check_notify_user($id, "like", $user, $email);
								 }
						  }
					 }
					 echo json_encode(array("status" => $this->socials_model->status,"message" => $this->socials_model->message, "count" => $count));
				}

				//process user like or unlike media
						public function pinunpinpost(){
							$data = $this->get_data();
							$this->load->model('socials_model');
							if(!empty($data)){
								  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
								  $id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
									$action = isset($data->action)?filter_var($data->action, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

								  if($email!="" && $id !=0){
										 $this->socials_model->pinunpinpost($id,$email,$action);
								  }
							 }
							 echo json_encode(array("status" => $this->socials_model->status,"message" => $this->socials_model->message));
						}

		//fetch audios/videos
		function get_users_to_follow(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$query = isset($data->query)?filter_var($data->query, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->usersToFollowListing($page,$query,$email);
				$total_items = $this->socials_model->get_total_users($email,$query);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","users" => $results,"isLastPage" => $isLastPage));
		}

		//fetch audios/videos
		function users_follow_people(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$option = isset($data->option)?filter_var($data->option, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$user = isset($data->user)?filter_var($data->user, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');

				if($option == "followers"){
					$results = $this->socials_model->users_followers_people($page,$user,$email);
					$total_items = $this->socials_model->getUsersFollowersCount($user);
				}else{
					$results = $this->socials_model->users_following_people($page,$user,$email);
					$total_items = $this->socials_model->getUsersFollowingCount($user);
				}
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","users" => $results,"isLastPage" => $isLastPage));
		}

		function post_likes_people(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$post = isset($data->post)?filter_var($data->post, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->post_likes_people($page,$post,$email);
				$total_items = $this->socials_model->getUsersPostLikesCount($post);
				$isLastPage = (($page + 1) * 20) >= $total_items;
				echo json_encode(array("status" => "ok","users" => $results,"isLastPage" => $isLastPage));
		}

		function userNotifications(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('socials_model');
				$results = $this->socials_model->userNotifications($page,$email);
				$total_items = $this->socials_model->getUsersNotificationCount($email);
				$isLastPage = (($page + 1) * 20) >= $total_items;
				echo json_encode(array("status" => "ok","notifications" => $results,"isLastPage" => $isLastPage));
		}

		function getUnSeenNotifications(){
				$data = $this->get_data();
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$this->load->model('socials_model');
				$total_items = $this->socials_model->getUsersNotificationCount($email,TRUE);
				echo json_encode(array("status" => "ok","count" => $total_items));
		}

		//fetch audios/videos
		function follow_unfollow_user(){
				$data = $this->get_data();
				$user = isset($data->user)?filter_var($data->user, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$follower = isset($data->follower)?filter_var($data->follower, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$action = isset($data->action)?filter_var($data->action, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

        if($user == "" || $follower == ""){
					echo json_encode(array("status" => "error","msg" =>"No matching users found."));
					exit;
				}

				$this->load->model('socials_model');
				if($action=="follow"){
					 $info['user_email'] = $user;
					 $info['follower_email'] = $follower;
           $this->socials_model->followUser($info);
					 $this->check_notify_user(0, "follow", $user, $follower);
					 echo json_encode(array("status" => "ok","action" =>$action));
				}else if($action=="unfollow"){
           $this->socials_model->unfollowUser($user,$follower);
					 echo json_encode(array("status" => "ok","action" =>$action));
				}
		}

		function update_user_settings(){
				$data = $this->get_data();
				//var_dump($data); die;
				$this->load->model('socials_model');
				$show_dateofbirth = isset($data->show_dateofbirth)?filter_var($data->show_dateofbirth, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):1;
				$show_phone = isset($data->show_phone)?filter_var($data->show_phone, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):1;
				$notify_follows = isset($data->notify_follows)?filter_var($data->notify_follows, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$notify_comments = isset($data->notify_comments)?filter_var($data->notify_comments, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$notify_likes = isset($data->notify_likes)?filter_var($data->notify_likes, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$settings = array("show_dateofbirth"=>$show_dateofbirth,"show_phone"=>$show_phone
				,"notify_follows"=>$notify_follows,"notify_comments"=>$notify_comments,"notify_likes"=>$notify_likes);

				$this->socials_model->updateUserSettings($settings,$email);
				echo json_encode(array("status" => $this->socials_model->status
				,"msg" => $this->socials_model->message));
		}

		function fetch_user_settings(){
		  	$data = $this->get_data();
			  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$this->load->model('socials_model');
				$user = $this->socials_model->fetch_user_settings($email);
				echo json_encode(array("status" => "ok", "user" => $user));
		}


	function updateUserSocialFcmToken(){
			$data = $this->get_data();
			//var_dump($data); die;
			$this->load->model('socials_model');
			if(isset($data->token) && $data->token!="" && isset($data->email) && $data->email!=""){
				$token = $data->token;
				$email = $data->email;
				$data = array("token"=>$token,"email"=>$email);
				//delete existing token
				$this->socials_model->deleteSocialToken($token);
				//add new
				$this->socials_model->updateUserSocialFcmToken($data);
			}
			echo json_encode(array("status" => $this->socials_model->status
			,"msg" => $this->socials_model->message));
	}

	function updateUserProfile(){
		$email = $this->input->post('email');
		$fullname = $this->input->post('fullname');
		$date_of_birth = $this->input->post('date_of_birth');
		$phone =$this->input->post('phone');
		$gender = $this->input->post('gender');
		$location = $this->input->post('location');
		$qualification =$this->input->post('qualification');
		$about_me =$this->input->post('about_me');
		$facebook = $this->input->post('facebook');
		$twitter =$this->input->post('twitter');
		$linkedln =$this->input->post('linkedln');
		$notify_token = $this->input->post('notify_token');

		$info = array(
		   	'email' => $email,
				'date_of_birth' => $date_of_birth,
				'phone' => $phone,
				'gender' => $gender,
				'location' => $location,
				'qualification' => $qualification,
				'about_me' => $about_me,
				'facebook' => $facebook,
				'twitter' => $twitter,
				'linkdln' => $linkedln,
				'notify_token' => $notify_token
		);

		$name = array(
				'name' => $fullname
		);

		if(!empty($_FILES['avatar'])){
			//var_dump($_FILES['avatar']);
			$upload = $this->upload_file("avatar");
			if($upload[0]=='ok'){
				$info['avatar'] =  $upload[1];
			}else{
				echo json_encode(array("status" => "error","msg" => $upload[1]));
				exit;
			}
		}

		if(!empty($_FILES['cover_photo'])){
			$upload = $this->upload_file("cover_photo");
			if($upload[0]=='ok'){
				$info['cover_photo'] =  $upload[1];
			}else{
				echo json_encode(array("status" => "error","msg" => $upload[1]));
				exit;
			}
		}

			$this->load->model('socials_model');
			$status = $this->socials_model->getUserSocialProfile($email);

		  if($status==TRUE){
        $this->socials_model->editUserProfile($info,$email);
				$this->socials_model->editUserName($name,$email);
			}else{
        $this->socials_model->addNewUserProfile($info);
				$this->socials_model->editUserName($name,$email);
			}
			$follow_status = $this->socials_model->getFollowStatus($email,$email);
			if($follow_status==1){
				$foldata['user_email'] = $email;
				$foldata['follower_email'] = $email;
					$foldata['_ignore'] = 1;
				$this->socials_model->followUser($foldata);
			}
			$user = $this->socials_model->getUpdatedUserProfile($email);

			echo json_encode(array("status" => "ok","msg" => "Profile was updated successfully", "user" => $user));
	}

	public function editpost(){
		$data = $this->get_data();
		//var_dump($data); die;
		if(!empty($data)){
				$content = isset($data->content)?filter_var($data->content, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$visibility = isset($data->visibility)?filter_var($data->visibility, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"public";
				$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				if($content != "" && $id != ""){
					 $this->load->model('socials_model');
					 $this->socials_model->editpost($id,$content,$visibility);
				}
		 }
		 echo json_encode(array("status" => $this->socials_model->status,"message" => $this->socials_model->message));
	}

	public function deletepost(){
		$data = $this->get_data();
		$comment = [];
		$total_count = 0;
		if(!empty($data)){
				$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				if($id != ""){
					 $this->load->model('socials_model');
					 $this->socials_model->deletepost($id);
				}
		 }
		 echo json_encode(array("status" => $this->socials_model->status,"message" => $this->socials_model->message));
	}

	public function deleteNotification(){
		$data = $this->get_data();
			$this->load->model('socials_model');
		if(!empty($data)){
				$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				if($id != ""){
					 $this->socials_model->deleteNotification($id);
				}
		 }
		 echo json_encode(array("status" => $this->socials_model->status,"message" => $this->socials_model->message));
	}

	public function setSeenNotifications(){
		$data = $this->get_data();
		$this->load->model('socials_model');
		if(!empty($data)){
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				if($email != ""){
					 $this->socials_model->setSeenNotifications($email);
				}
		 }
		 echo json_encode(array("status" => $this->socials_model->status,"message" => $this->socials_model->message));
	}

	function make_post(){
		$email = $this->input->post('email');
		$text = $this->input->post('content');
		$visibility = $this->input->post('visibility');
		$uploaded_files = $this->do_post_uploads();

		$post = array(
			  'email' => $email,
		   	'content' => $text,
				'visibility' => $visibility,
				'timestamp' => time(),
				'media' => json_encode($uploaded_files)
		);

		//var_dump($post); die;

		$this->load->model('socials_model');
		$id = $this->socials_model->saveUserPost($post);
		echo json_encode(array("status" => "ok"));
	}

	function make_post_flutter(){
		$email = $this->input->post('email');
		$text = $this->input->post('content');
		$visibility = $this->input->post('visibility');
		$uploaded_files = $this->do_post_uploads_flutter();

		$post = array(
			  'email' => $email,
		   	'content' => $text,
				'visibility' => $visibility,
				'timestamp' => time(),
				'media' => json_encode($uploaded_files)
		);

		//var_dump($post); die;

		$this->load->model('socials_model');
		$id = $this->socials_model->saveUserPost($post);
		echo json_encode(array("status" => "ok"));
	}

	public function upload_file($file){
		$path = $_FILES[$file]['name'];
		$ext = pathinfo($path, PATHINFO_EXTENSION);

		if($file=="avatar"){
			$new_name = uniqid()."_avatar_".time().".".$ext;
			$config['file_name'] = $new_name;
			$config['upload_path'] = './uploads/socials/avatars';
		}else{
			$new_name = uniqid()."_cover_".time().".".$ext;
			$config['file_name'] = $new_name;
			$config['upload_path']   = './uploads/socials/coverphotos';
		}
		$config['max_size']             = 10000;
		$config['allowed_types']        = '*';
		$config['overwrite'] = TRUE; //overwrite thumbnail
		$this->load->library('upload');
		$this->upload->initialize($config);
    //$this->upload->initialize($config);
		//var_dump($config);
		//$this->load->library('upload', $config);
		if ( ! $this->upload->do_upload($file))
		{
				//$error = array('error' => $this->upload->display_errors());
				return ['error',strip_tags($this->upload->display_errors())];
		}
		else{
				$image_data = $this->upload->data();
				return ['ok',$new_name];
		}
	}

	public function check_user(){
		$this->load->model('socials_model');
		$user = $this->socials_model->getUpdatedUserProfile("sales.envisionapps@gmail.com");
		var_dump($user);
	}

	public function do_post_uploads(){
		// Count total files
		 $countfiles = count($_FILES);
		 //var_dump($_FILES); die;
		 //var_dump($_FILES); die;
		 $upload_files = [];
		 // Looping all files
		 for($i=0;$i<$countfiles;$i++){
       $filedata = $_FILES['files_'.$i];
			 $path = $filedata['name'];
			 //echo $path; die;
			 $ext = pathinfo($path, PATHINFO_EXTENSION);
			 //print($filedata['type']); die;
			 // Set preference
			 if($filedata['type'] == "video/mp4"){
				 $new_name = uniqid()."_video_".time().".".$ext;
				$config['file_name'] = $new_name;
				$config['upload_path'] = './uploads/socials/videos';
			 }else{
				 $new_name = uniqid()."_photo_".time().".".$ext;
				$config['file_name'] = $new_name;
				$config['upload_path']   = './uploads/socials/photos';
			 }

			 //$config['max_size']             = 10000;
			 $config['allowed_types']        = 'mp4|jpeg|jpg|png|JPEG|PNG';
			 $config['max_size'] = '10000'; // max_size in kb equals to 10MB

			 //Load upload library
			 $this->load->library('upload');
			 $this->upload->initialize($config);



			 if ( ! $this->upload->do_upload('files_'.$i))
			 {
					 echo json_encode(array("status" => "error","msg" => strip_tags($this->upload->display_errors())));
					 exit;
			 }
			 else{
					 $image_data = $this->upload->data();
					 $filename = $image_data['file_name'];
					 array_push($upload_files,$filename);
			 }

		 }

		 return $upload_files;
	}


	public function do_post_uploads_flutter(){
		// Count total files
		 $countfiles = count($_FILES);
		// var_dump($_FILES); die;
		 //var_dump($_FILES); die;
		 $upload_files = [];
		 // Looping all files
		 for($i=0;$i<$countfiles;$i++){
       $filedata = $_FILES['files_'.$i];
			 $path = $filedata['name'];
			 //echo $path; die;
			 $ext = pathinfo($path, PATHINFO_EXTENSION);
			 //print($filedata['type']); die;
			 // Set preference
			 if($ext == "mp4"){
				 $new_name = uniqid()."_video_".time().".".$ext;
				$config['file_name'] = $new_name;
				$config['upload_path'] = './uploads/socials/videos';
			 }else{
				 $new_name = uniqid()."_photo_".time().".".$ext;
				$config['file_name'] = $new_name;
				$config['upload_path']   = './uploads/socials/photos';
			 }

			 //$config['max_size']             = 10000;
			 $config['allowed_types']        = 'mp4|jpeg|jpg|png|JPEG|PNG';
			 $config['max_size'] = '10000'; // max_size in kb equals to 10MB

			 //Load upload library
			 $this->load->library('upload');
			 $this->upload->initialize($config);


			 if ( ! $this->upload->do_upload('files_'.$i))
			 {
					 echo json_encode(array("status" => "error","msg" => strip_tags($this->upload->display_errors())));
					 exit;
			 }
			 else{
					 $image_data = $this->upload->data();
					 $filename = $image_data['file_name'];
					 array_push($upload_files,$filename);
			 }

		 }

		 return $upload_files;
	}

}
