<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';
/*
* This class handles some of the requests from the android client app
*/
class Api extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->check_headers();
    }

		function test_email(){
			$this->sendMail("envisionaps@gmail.com","test email","Hello ");
		}

    //discover media
		function discover(){
			  $data = $this->get_data();
				$this->load->model('inbox_model');
				$this->load->model('livestreams_model');
				$this->load->model('radio_model');
				$this->load->model('events_model');
				$this->load->model('settings_model');
				$this->load->model('media_model');

				//$last_seen_event = isset($data->last_seen_event)?filter_var($data->last_seen_event, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$last_seen_inbox = isset($data->last_seen_inbox)?filter_var($data->last_seen_inbox, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";

				$livestreams = $this->livestreams_model->getLiveStreams();
				$radios = $this->radio_model->getRadio();
				$facebook_page = $this->settings_model->getFacebookPage();
				$youtube_page = $this->settings_model->getYoutubePage();
				$twitter_page = $this->settings_model->getTwitterPage();
				$instagram_page = $this->settings_model->getInstagramPage();
				$ads_interval = $this->settings_model->getAdvertsInterval();
				$events = $this->events_model->get_total_events(date("Y-m-d"));
				$inbox = $this->inbox_model->get_total_inbox($last_seen_inbox);

				$website_url = $this->settings_model->getWebsiteUrl();
				$image_one = $this->settings_model->getHomePageImage("image_one");
				$image_two = $this->settings_model->getHomePageImage("image_two");
				$image_three = $this->settings_model->getHomePageImage("image_three");
				$image_four = $this->settings_model->getHomePageImage("image_four");
				$image_five = $this->settings_model->getHomePageImage("image_five");
				$image_six = $this->settings_model->getHomePageImage("image_six");
				$image_seven = $this->settings_model->getHomePageImage("image_seven");
				$image_eight = $this->settings_model->getHomePageImage("image_eight");
				$slider_media = $this->media_model->fetchRandom($email);

				echo json_encode(array("status" => "ok"
				,"slider_media" => $slider_media
				,"livestream" => $livestreams
				,"facebook_page" => $facebook_page
				,"youtube_page" => $youtube_page
				,"twitter_page" => $twitter_page
				,"instagram_page" => $instagram_page
				,"ads_interval" => $ads_interval
				,"inbox" => $inbox
				,"website_url" => $website_url
				,"image_one" => $image_one
				,"image_two" => $image_two
				,"image_three" => $image_three
				,"image_four" => $image_four
				,"image_five" => $image_five
				,"image_six" => $image_six
				,"image_seven" => $image_seven
				,"image_eight" => $image_eight
				,"events" => $events
				,"radios" => $radios));
		}

		//categories listing
		function devotionals(){
			$data = $this->get_data();
		  $this->load->model('devotionals_model');
		  $date = isset($data->date)?filter_var($data->date, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):date("Y-m-d");
			$devotional = $this->devotionals_model->getDevotional(date('Y-m-d', strtotime($date)));
			if($devotional){
				echo json_encode(array("status" => "ok","devotional" => $devotional));
			}else{
				echo json_encode(array("status" => "error"));
			}
		}

		//fetch radios
		function fetch_radios(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}
				$this->load->model('radio_model');
				$results = $this->radio_model->fetchRadio($page);
				$total_items = $this->radio_model->get_total_radio();
				$isLastPage = (($page + 1) * 20) >= $total_items;
				echo json_encode(array("status" => "ok","radios" => $results,"isLastPage" => $isLastPage));
		}

		//fetch albums
		function fetch_events(){
			   $data = $this->get_data();
			   $date = isset($data->date)?filter_var($data->date, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):date("Y-m-d");
				$this->load->model('events_model');
				$results = $this->events_model->fetchEvents(date('Y-m-d', strtotime($date)));
				echo json_encode(array("status" => "ok","events" => $results));
		}

		//categories listing
		function categories(){
			  $data = $this->get_data();
				$this->load->model('categories_model');
				$categories = $this->categories_model->categoriesListing();
				echo json_encode(array("status" => "ok","categories" => $categories));
		}

		//fetch audios/videos
		function fetch_media(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				if(isset($data->media_type)){
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";
					$type = $data->media_type;
					$page = 0;
					if(isset($data->page)){
	          $page = $data->page;
	        }

					$this->load->model('media_model');
					$results = $this->media_model->fetch_media($type,$page,$email);
					$total_items = $this->media_model->get_total_media($type);
					$isLastPage = (($page + 1) * 20) >= $total_items;
				}

				echo json_encode(array("status" => "ok","media" => $results,"isLastPage" => $isLastPage));
		}

		//fetch audios/videos
		function fetch_hymns(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$query = isset($data->query)?filter_var($data->query, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('hymns_model');
				$results = $this->hymns_model->fetch_hymns($page,$query);
				$total_items = $this->hymns_model->get_total_hymns($query);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","hymns" => $results,"isLastPage" => $isLastPage));
		}

		//fetch inbox
		function fetch_inbox(){
			$data = $this->get_data();
			$results = [];
			$isLastPage = false;
			$page = 0;
			if(isset($data->page)){
				$page = $data->page;
			}
			$this->load->model('inbox_model');
			$results = $this->inbox_model->fetchInbox($page);
			$total_items = $this->inbox_model->get_total_inbox();
			$isLastPage = (($page + 1) * 20) >= $total_items;
			echo json_encode(array("status" => "ok","isLastPage" => $isLastPage,"inbox" => $results));
		}

		//fetch categories audios/videos
		function fetch_categories_media(){
				$data = $this->get_data();
				$results = [];
				$subcategories = [];
				$isLastPage = false;
				if(isset($data->category)){
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";
					$category = $data->category;
					$version = isset($data->version)?$data->version:"v1";
					$page = 0;
					if(isset($data->page)){
	          $page = $data->page;
	        }
					$sub = 0;
					if(isset($data->sub)){
	          $sub = $data->sub;
	        }
					$media_type = "all";
					if(isset($data->media_type)){
	          $media_type = $data->media_type;
	        }
					$this->load->model('media_model');
					$results = $this->media_model->fetch_categories_media($category,$page,$email,$sub,$media_type);
					$total_items = $this->media_model->total_categories_media($category,$sub,$media_type);
					$isLastPage = (($page + 1) * 20) >= $total_items;

					if($page==0){
						$this->load->model('categories_model');
						$subcategories = $this->categories_model->subcategoriesListing($category);
					}
				}
				echo json_encode(array("status" => "ok","subcategories" => $subcategories,"isLastPage" => $isLastPage,"media" => $results));
		}


		//fetch categories audios/videos
		function getTrendingMedia(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";
				$version = isset($data->version)?$data->version:"v1";
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$this->load->model('media_model');
				$results = $this->media_model->getTrendingMedia($page,$email,"",$version);
				$total_items = $this->media_model->total_trending_media($version);
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","isLastPage" => $isLastPage,"media" => $results));
		}

		//process user like or unlike media
				public function update_media_total_views(){
					$data = $this->get_data();
					$this->load->model('media_model');
					if(!empty($data)){
						  $media = isset($data->media)?filter_var($data->media, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

						  if($media !=""){
								 $this->media_model->update_media_total_views($media);
						  }
					 }
					 echo json_encode(array("status" => $this->media_model->status));
				}

				//process user like or unlike media
						public function update_ebooks_articles_views(){
							$data = $this->get_data();
							$id = isset($data->id)?filter_var($data->id, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
							$type = isset($data->type)?filter_var($data->type, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
							if($type=="ebooks"){
								 	$this->load->model('ebooks_model');
								 $this->ebooks_model->update_ebooks_total_views($id);
							}else if($type=="articles"){
								 	$this->load->model('articles_model');
								 $this->articles_model->update_articles_total_views($id);
							}
							 echo json_encode(array("status" => "ok"));
						}

//process user like or unlike media
		public function likeunlikemedia(){
			$data = $this->get_data();
			$this->load->model('media_model');
			if(!empty($data)){
				  $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				  $media = isset($data->media)?filter_var($data->media, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$action = isset($data->action)?filter_var($data->action, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($email!="" && $media !=""){
						 $this->media_model->likeunlikemedia($media,$email,$action);
				  }
			 }
			 echo json_encode(array("status" => $this->media_model->status,"message" => $this->media_model->message));
		}

//get total likes and comments for a media
		public function getmediatotallikesandcommentsviews(){
			$data = $this->get_data();
			$this->load->model('media_model');
			$total_likes = 0;
			$total_comments = 0;
			if(!empty($data)){
				  $media = isset($data->media)?filter_var($data->media, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

				  if($media !=""){
						 $total_comments = $this->media_model->get_total_comments($media);
						 $total_likes = $this->media_model->getMediaTotalLikes($media);
						 $total_views = $this->media_model->getMediaTotalViews($media);
				  }
			 }
			 echo json_encode(array("status" => 'ok'
			 ,"total_likes" => $total_likes
			 ,"total_comments" => $total_comments
		   ,"total_views" => $total_views));
		}

    //search audios/videos
		function search(){
				$data = $this->get_data();
				$result = [];
				if(isset($data->query)){
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";
					$query = $data->query;

					$offset = 0;
					if(isset($data->offset)){
	          $offset = $data->offset;
	        }
					$this->load->model('search_model');
					$result = $this->search_model->searchListing($query,$offset,$email);
				}
				echo json_encode(array("status" => "ok","search" => $result));
		}

		//download media
		function download(){
			$this->load->model('download_model');
			if(isset($_GET['m'])){
				$this->download_model->load($_GET['m']);
			}else{
				echo "invalid url";
			}
		}

	//store user fcm token
	function storeFcmToken(){
			$data = $this->get_data();
			$this->load->model('fcm_model');
			if(isset($data->token) && $data->token!=""){
				$token = $data->token;
				$version = isset($data->version)?$data->version:"v1";
				$data = array("token"=>$token,"app_version"=>$version);
			  $this->fcm_model->storeUserFcmToken($data);
			}
			echo json_encode(array("status" => $this->fcm_model->status
			,"msg" => $this->fcm_model->message));
	}

	//store user fcm token
	function updateFcmToken(){
			$data = $this->get_data();
			$this->load->model('fcm_model');
			if(isset($data->token) && $data->token!=""){
				$token = $data->token;
				$version = isset($data->token)?$data->token:"v1";
			  $this->fcm_model->updateUserFcmToken($token,$version);
			}
			echo json_encode(array("status" => $this->fcm_model->status
			,"msg" => $this->fcm_model->message));
	}

	function send_feedback(){
		$data = $this->get_data();
			if(!empty($data)){
				  $name = isset($data->name)?filter_var($data->name, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
					$phone = isset($data->phone)?filter_var($data->phone, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
				    $message = isset($data->message)?filter_var($data->message, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

					//check for empty or invalid fields
					$_name_error = $name==""?"Name is empty!":"";
					$_email_error = $this->validateEmail($email)==TRUE?"":"Email Address Is not valid!";
					$_password_error = $message==""?"Message is empty!":"";
					if($_name_error !="" || $_email_error !="" || $_password_error != ""){
						 $this->response("error",$_name_error."\n".$_email_error."\n".$_password_error);
                         exit;
					}
					$subject = "App Feedback";
						 $htmlContent = '<p>From '.$name.',</p>';
				         $htmlContent = '<p>Email '.$email.',</p>';
				         $phone = '<p>From '.$phone.',</p>';
						 $htmlContent .= '<br><br>';
						 $htmlContent .= '<p>'.$message.'</p>';
						 $this->sendMail($email,$subject,$htmlContent);
			 }
			 $this->response("ok","Thank your feedback, We will attend to it shortly");
	}

	public function get_article_content(){
		$data = $this->get_data();
		if(!empty($data)){
				$id = isset($data->id)?$data->id:0;
				if($data->type == "inbox"){
					$this->load->model('inbox_model');
					$content = $this->inbox_model->getArticleContent($id);
				}else{
					$this->load->model('events_model');
					$content = $this->events_model->getArticleContent($id);
				}
				echo json_encode(array("content" => $content));
		 }else{
			 echo json_encode(array("content" => ""));
		 }
	}

	public function saveDonation(){
		 $data = $this->get_data();
		 //var_dump($data); die;
		 if(!empty($data)){
			 $reason = isset($data->reason)?filter_var($data->reason, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			 $method = isset($data->method)?filter_var($data->method, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			 $email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			 $name = isset($data->name)?filter_var($data->name, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";
			 $amount = isset($data->amount)?filter_var($data->amount, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):0;
			 $reference = isset($data->reference)?filter_var($data->reference, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"";

			 $this->load->model('donations_model');
			 $pay_ref['email'] = $email;
			 $pay_ref['name'] = $name;
			 $pay_ref['reason'] = $reason;
			 $pay_ref['reference'] = $reference;
			 $pay_ref['amount'] = $amount;
			 $pay_ref['method'] = $method;
				$this->donations_model->recordDonation($pay_ref);


			 echo json_encode(array("status" => $this->donations_model->status,"message" => $this->donations_model->message));
			 exit;
	 }else{
		 echo json_encode(array("status" => "error","message" => "No data found for this transaction"));
	 }

 }

}
