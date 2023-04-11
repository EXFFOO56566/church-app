<?php
defined('BASEPATH') OR exit('No direct script access allowed');
header('Content-Type: text/html; charset=utf-8');
include_once './vendor/autoload.php';
use Khill\Duration\Duration;

require APPPATH . '/libraries/BaseController.php';
class Video extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('video_model');
    }


		public function index(){
        $this->load->template('video/listing', []); // this will load the view file
    }

		function fetch(){
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


			$videos = $this->video_model->videoListing($columnName,$columnSortOrder,$searchValue,$start, $length);
			$total_videos = $this->video_model->get_total_videos($searchValue);
			//var_dump($users); die;
			$dat = array();

			 $count = $start + 1;

        foreach($videos as $r) {
					$vid = "";
					if($r->video_type=="mp4_video"){
							$vid = '<video  controls preload="none" width="300" height="200">
								<source src="'.$r->source.'" type="video/mp4">
							Your browser does not support the audio element.
							</video >';
						}else if($r->video_type=="dailymotion_video"){
							$vid = '<iframe frameborder="0" width="300" height="200" src="//www.dailymotion.com/embed/video/'.$r->source.'" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
						}else if($r->video_type=="vimeo_video"){
							$vid = '<iframe frameborder="0" width="300" height="200" src="//player.vimeo.com/video/'.$r->source.'" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
						}else if($r->video_type=="youtube_video"){
							$vid = '<iframe frameborder="0" width="300" height="200" src="//www.youtube.com/embed/'.$r->source.'" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>';
						}else if($r->video_type=="mpd_video"){
							$vid = '<video data-dashjs-player width="300" height="200" src="'.$r->source.'" controls></video>';
						}else if($r->video_type=="m3u8_video"){
							$vid = "<video-js class='video-js vjs-default-skin' controls preload='auto' width='300' height='200'
											data-setup='{}'>
												<source src='".$r->source."' type='application/x-mpegURL'>
											</video-js>";
						}
             $dat[] = array(
							    $count,
									$vid,
									$r->title,
                  $r->description,
									'<a href="'.site_url().'editVideo/'.$r->id.'" type="button" class="btn btn-primary btn-sm m-l-15 waves-effect" style="float: none;">'.
									'<i style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">create</i></a>'.
									'<button onclick="delete_item(event)" data-type="video" data-id="'.$r->id.'" type="button" class="btn btn-danger btn-sm m-l-15 waves-effect" style="float: none;">'.
									'<i style="margin-bottom:5px;"  class="material-icons list-icon" data-type="video" data-id="'.$r->id.'">delete</i></button>'
             );
						 $count++;
        }

        $output = array(
             "draw" => $draw,
               "recordsTotal" => $total_videos,
               "recordsFiltered" => $total_videos,
               "data" => $dat
          );
        echo json_encode($output);
    }

		public function newVideo()
    {
			$this->load->model('categories_model');
			$data['categories'] = $this->categories_model->categoriesListing("videos");
      $this->load->template('video/new', $data); // this will load the view file
    }

    public function editVideo($id=0)
    {
        $data['video'] = $this->video_model->getVideoInfo($id);
        if(count((array)$data['video'])==0)
        {
            redirect('videoListing');
        }
				$_duration = new Duration;
				$data['video']->duration = $_duration->formatted(($data['video']->duration)/1000);
				$this->load->model('categories_model');
				$data['categories'] = $this->categories_model->categoriesListing("videos");
				$data['subcategories'] = $this->categories_model->subcategoriesListing($data['video']->category_id);
				//var_dump($data);die;
        $this->load->template('video/edit', $data); // this will load the view file
    }


		public function saveNewVideo(){
			$data = $this->get_data();
			 if(isset($data) && isset($data->title)){

				 $media_type = "mp4_video";
				 if(isset($data->media_type)){
						$media_type = $data->media_type;
				 }
				 $title = $data->title;
				 $description = "";
				 if(isset($data->description)){
						$description = $data->description;
				 }
				 $category = 0;
				 if(isset($data->category)){
						$category = $data->category;
				 }
				 if(isset($data->category)){
 					 $subcategory = $data->subcategory;
 				}
				$duration = 0;
				if(isset($data->duration)){
					 $duration = $data->duration;
				}
				 $is_free = 1;
				 if(isset($data->is_free)){
						$is_free = $data->is_free;
				 }
				 $can_download = 1;
				 if(isset($data->can_download)){
						$can_download = $data->can_download;
				 }


				 $notify = false;
				 if(isset($data->notify)){
						$notify = $data->notify;
				 }

          $_duration = new Duration;
					$info = array(
							'title' => $title,
							'category' => $category,
						 'description'=> $description,
						'is_free'=> $is_free,
						'can_download'=> $can_download,
						'sub_category' => $subcategory,
					 'duration' =>  $_duration->toSeconds($duration) * 1000,
						'type' => 'video'
					);

					if($media_type=="mp4_video"){
	 				 //upload image file
	 					$thumb_upload = $this->upload_thumbnail();
	 					//upload video file
	 					$video_upload = $this->upload_video();

	 					//if there are any error, display to user
	 					if($video_upload[0]=='error' || $thumb_upload[0]=='error'){
							$msg = $video_upload[0]=='error'?"Video upload error: ".$video_upload[1]:"";
						 $msg .= $thumb_upload[0]=='error'?"\nThumbnail upload error: ".$thumb_upload[1]:"";
							echo json_encode(array("status" => "error","msg" => $msg));
	 						exit;
	 					}

	 					$info['cover_photo'] = $thumb_upload[1];
	 					$info['source'] = $video_upload[1];
	 			 }else{
	 				 $info['cover_photo'] = $data->thumbnail_link;
	 				 $info['source'] = $data->media_link;
					 $info['video_type'] = $media_type;
	 			 }


				 $id = $this->video_model->addNewVideo($info);
 				//send an fcm broadcast to users
 				if($notify){
 					$this->load->model('settings_model');
 					$server_key = $this->settings_model->getFcmServerKey();
 					$this->load->model('fcm_model');
 					$title = "Tap to watch ".$title;
 					$this->load->model('media_model');
 					$media = $this->media_model->fetchPlayableMedia($id);
 					$this->fcm_model->newMediaNotification($server_key,$title,$media);
 				}
		 }
		echo json_encode(array("status" => $this->video_model->status,"msg" => $this->video_model->message));
    }


		public function editVideoData(){
			$data = $this->get_data();
			if(!isset($data) || !isset($data->title)){
				echo json_encode(array("status" => $this->video_model->status,"msg" => $this->video_model->message));
				exit;
		   }

         $id = isset($data->id)?$data->id:0;
				 $category = 0;
				 if(isset($data->category)){
						$category = $data->category;
				 }
				 $title = $data->title;
 				 $description = "";
 				 if(isset($data->description)){
 						$description = $data->description;
 				 }
 				 $is_free = 1;
 				 if(isset($data->is_free)){
 						$is_free = $data->is_free;
 				 }
 				 $can_download = 1;
 				 if(isset($data->can_download)){
 						$can_download = $data->can_download;
 				 }

				 $subcategory = 0;
				 if(isset($data->category)){
						$subcategory = $data->subcategory;
				 }
				 $duration = 0;
				 if(isset($data->duration)){
						$duration = $data->duration;
				 }

          $_duration = new Duration;
 					$info = array(
						'category' => $category,
 							'title' => $title,
 						 'description'=> $description,
 						'is_free'=> $is_free,
 						'can_download'=> $can_download,
						'sub_category' => $subcategory,
					 'duration' =>  $_duration->toSeconds($duration) * 1000,
 					);

 				 $this->video_model->editVideoData($info, $id);

				 //we send a fcm broadcast to users to automatically edit medias on their device
				 $this->load->model('settings_model');
				 $server_key = $this->settings_model->getFcmServerKey();
				 $this->load->model('media_model');
				 $media = $this->media_model->fetchPlayableMedia($id);

				 $this->load->model('fcm_model');
				 $this->fcm_model->editMediaNotification($server_key,$media);

		    echo json_encode(array("status" => $this->video_model->status,"msg" => $this->video_model->message));
    }


    function deleteVideo($id=0){
      $this->load->library('session');
			$video = $this->video_model->getVideoInfo($id);
			if(count((array)$video)>0)
			{
				@unlink('./uploads/videos/'.$video->source);
				@unlink('./uploads/thumbnails/'.$video->cover_photo);
			}
      $this->video_model->deleteVideo($id);
      if($this->video_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->video_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->video_model->message);
      }
      redirect('videoListing');
    }

		public function upload_video(){
			$path = $_FILES['video']['name'];
      $file_name = "video_".time().".".pathinfo($path, PATHINFO_EXTENSION);
      $config['upload_path']          = './uploads/videos';
			$config['file_name'] = $file_name;
      //$config['max_size']             = 10000;
      $config['allowed_types']        = 'mp4';
      $config['overwrite'] = TRUE; //overwrite file


      //var_dump($config);
			$this->load->library('upload');
      $this->upload->initialize($config);

      if ( ! $this->upload->do_upload('video'))
      {
          //$error = array('error' => $this->upload->display_errors());
          return ['error',strip_tags($this->upload->display_errors())];
      }
      else{
					return ['ok',$file_name];
      }
    }

		public function upload_hd(){
			$path = $_FILES['hd']['name'];
      $file_name = "hd_".time().".".pathinfo($path, PATHINFO_EXTENSION);
      $config['upload_path']          = './uploads/videos';
			$config['file_name'] = $file_name;
      //$config['max_size']             = 10000;
      $config['allowed_types']        = '*';
      $config['overwrite'] = TRUE; //overwrite file


      //var_dump($config);
			$this->load->library('upload');
      $this->upload->initialize($config);

      if ( ! $this->upload->do_upload('hd'))
      {
          //$error = array('error' => $this->upload->display_errors());
          return ['error',strip_tags($this->upload->display_errors())];
      }
      else{
					return ['ok',$file_name];
      }
    }

		public function upload_sd(){
			$path = $_FILES['sd']['name'];
      $file_name = "sd_".time().".".pathinfo($path, PATHINFO_EXTENSION);
      $config['upload_path']          = './uploads/videos';
			$config['file_name'] = $file_name;
      //$config['max_size']             = 10000;
      $config['allowed_types']        = '*';
      $config['overwrite'] = TRUE; //overwrite file


      //var_dump($config);
			$this->load->library('upload');
      $this->upload->initialize($config);

      if ( ! $this->upload->do_upload('sd'))
      {
          //$error = array('error' => $this->upload->display_errors());
          return ['error',strip_tags($this->upload->display_errors())];
      }
      else{
					return ['ok',$file_name];
      }
    }

		public function upload_mp3(){
			$path = $_FILES['mp3']['name'];
      $file_name = "mp3_".time().".".pathinfo($path, PATHINFO_EXTENSION);
      $config['upload_path']          = './uploads/videos';
			$config['file_name'] = $file_name;
      //$config['max_size']             = 10000;
      $config['allowed_types']        = 'mp3';
      $config['overwrite'] = FALSE; //overwrite file

      //var_dump($config);
			$this->load->library('upload');
      $this->upload->initialize($config);

      if ( ! $this->upload->do_upload('mp3')){
          //$error = array('error' => $this->upload->display_errors());
          return ['error',strip_tags($this->upload->display_errors())];
      }else{
				  $upload_data = $this->upload->data(); //Returns array of containing all of the data related to the file you uploaded.
					return ['ok',$file_name];
      }
    }

		function upload_thumbnail(){
			$config['upload_path']          = './uploads/thumbnails';
			//$config['max_size']             = 10000;
			$config['allowed_types']        = 'jpeg|jpg|png|JPEG|PNG';
			$config['overwrite'] = TRUE; //overwrite file

			$this->load->library('upload');
      $this->upload->initialize($config);
			if ( ! $this->upload->do_upload('thumbnail'))
			{
					//$error = array('error' => $this->upload->display_errors());
					return ['error',strip_tags($this->upload->display_errors())];
			}
			else{
				 $upload_data = $this->upload->data(); //Returns array of containing all of the data related to the file you uploaded.
					$file_name = $upload_data['file_name'];
				 return ['ok',$file_name];
			}
		}

		/***
		*test function to batch index media
		***/
		function batch_index(){
			$this->load->model('media_model');
				$media = $this->media_model->get_all_medias();
				foreach($media as $r) {
					//add this row to elastic search index
					$this->load->model('search_model');
					$this->search_model->indexRow($r);
				}
		}



}
