<?php
defined('BASEPATH') OR exit('No direct script access allowed');
header('Content-Type: text/html; charset=utf-8');
include_once './vendor/autoload.php';
use Khill\Duration\Duration;

require APPPATH . '/libraries/BaseController.php';

class Audio extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('audio_model');
    }


		public function index(){
        $this->load->template('audio/listing', []); // this will load the view file
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


			$audios = $this->audio_model->audioListing($columnName,$columnSortOrder,$searchValue,$start, $length);
			$total_audios = $this->audio_model->get_total_audios($searchValue);
			//var_dump($users); die;
			$dat = array();

			 $count = $start + 1;
        foreach($audios as $r) {
             $dat[] = array(
							    $count,//'.site_url()."stream?m=".$r->id.'
									'<audio controls preload="none">
									  <source src="'.$r->source.'" type="audio/mpeg">
									Your browser does not support the audio element.
									</audio>',
									$r->title,
                  $r->description,
									'<a href="'.site_url().'editAudio/'.$r->id.'" type="button" class="btn btn-primary btn-sm m-l-15 waves-effect" style="float: none;">'.
									'<i style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">create</i></a>'.
									'<button onclick="delete_item(event)" data-type="audio" data-id="'.$r->id.'" type="button" class="btn btn-danger btn-sm m-l-15 waves-effect" style="float: none;">'.
									'<i style="margin-bottom:5px;"  class="material-icons list-icon" data-type="audio" data-id="'.$r->id.'">delete</i></button>'
             );
						 $count++;
        }

        $output = array(
             "draw" => $draw,
               "recordsTotal" => $total_audios,
               "recordsFiltered" => $total_audios,
               "data" => $dat
          );
        echo json_encode($output);
    }

		public function newAudio()
    {
			$this->load->model('categories_model');
			$data['categories'] = $this->categories_model->categoriesListing("audios");
      $this->load->template('audio/new', $data); // this will load the view file
    }

    public function editAudio($id=0)
    {
        $data['audio'] = $this->audio_model->getAudioInfo($id);
        if(count((array)$data['audio'])==0)
        {
            redirect('audioListing');
        }
				$_duration = new Duration;
				$data['audio']->duration = $_duration->formatted(($data['audio']->duration)/1000);
				$this->load->model('categories_model');
				$data['categories'] = $this->categories_model->categoriesListing("audios");
				$data['subcategories'] = $this->categories_model->subcategoriesListing($data['audio']->category_id);
        $this->load->template('audio/edit', $data); // this will load the view file
    }


		public function saveNewAudio(){
			 $data = $this->get_data();
			 if(isset($data) && isset($data->title)){
				 //var_dump($data); die;

				 $media_type = 0;
				 if(isset($data->media_type)){
						$media_type = $data->media_type;
				 }
				 $title = $data->title;
				 $category = 0;
				 if(isset($data->category)){
						$category = $data->category;
				 }
				 $subcategory = 0;
				if(isset($data->category)){
					 $subcategory = $data->subcategory;
				}

				 $description = "";
				 if(isset($data->description)){
						$description = $data->description;
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
				 $can_preview = 1;
				 if(isset($data->can_preview)){
						$can_preview = $data->can_preview;
				 }
				 $preview_duration = 0;
				 if(isset($data->preview_duration)){
						$preview_duration = $data->preview_duration;
				 }


				 $notify = false;
				 if(isset($data->notify)){
						$notify = $data->notify;
				 }
          $_duration = new Duration;
					$info = array(
						'category' => $category,
						'title' => $title,
						'description'=> $description,
						'is_free'=> $is_free,
						'can_download'=> $can_download,
						'can_preview'=> $can_preview,
						'preview_duration' => $preview_duration,
						'sub_category' => $subcategory,
					 'duration' => $_duration->toSeconds($duration) * 1000,
						'type' => 'audio'
					);

					if($media_type==0){
	 				 //upload image file
	 					$thumb_upload = $this->upload_thumbnail();
	 					//upload video file
	 					$audio_upload = $this->upload_audio();

	 					//if there are any error, display to user
	 					if($audio_upload[0]=='error' || $thumb_upload[0]=='error'){
	 						 $msg = $audio_upload[0]=='error'?"Audio upload error: ".$audio_upload[1]:"";
	 						 $msg .= $thumb_upload[0]=='error'?"\nThumbnail upload error: ".$thumb_upload[1]:"";
	 							echo json_encode(array("status" => "error","msg" => $msg));
	 						exit;
	 					}

	 					$info['cover_photo'] = $thumb_upload[1];
	 					$info['source'] = $audio_upload[1];
	 			 }else{
	 				 $info['cover_photo'] = $data->thumbnail_link;
	 				 $info['source'] = $data->media_link;
	 			 }

				 $id = $this->audio_model->addNewAudio($info);
				 if($notify){
					 $this->load->model('settings_model');
					 $server_key = $this->settings_model->getFcmServerKey();
					 $this->load->model('fcm_model');
					 $title = "Tap to listen to ".$title;
					 $this->load->model('media_model');
					 $media = $this->media_model->fetchPlayableMedia($id);
					 $this->fcm_model->newMediaNotification($server_key,$title,$media);
				 }
		 }
		echo json_encode(array("status" => $this->audio_model->status,"msg" => $this->audio_model->message));
    }


		public function editAudioData(){
			$data = $this->get_data();
			if(!isset($data) || !isset($data->title)){
				echo json_encode(array("status" => $this->audio_model->status,"msg" => $this->audio_model->message));
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
 				 $can_preview = 1;
 				 if(isset($data->can_preview)){
 						$can_preview = $data->can_preview;
 				 }
 				 $preview_duration = 0;
 				 if(isset($data->preview_duration)){
 						$preview_duration = $data->preview_duration;
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
 							'title' => $title,
							'category' => $category,
 						 'description'=> $description,
 						'is_free'=> $is_free,
 						'can_download'=> $can_download,
 						'can_preview'=> $can_preview,
 						'preview_duration' => $preview_duration,
						'sub_category' => $subcategory,
					 'duration' =>  $_duration->toSeconds($duration) * 1000,
 					);

					$thumbnail_link = "";
 				 if(isset($data->thumbnail_link)){
 						$thumbnail_link = $data->thumbnail_link;
 				 }
				 $original_thumb = "";
				 if(isset($data->original_thumb)){
						$original_thumb = $data->original_thumb;
				 }
				 $media_link = "";
				 if(isset($data->media_link)){
						$media_link = $data->media_link;
				 }
				 $original_video = "";
				 if(isset($data->original_video)){
						$original_video = $data->original_video;
				 }

				 if($thumbnail_link != $original_thumb){
					 $info['cover_photo'] = $data->thumbnail_link;
				 }

				 if($original_video != $media_link){
	 				 $info['source'] = $data->media_link;
				 }

 				 $this->audio_model->editAudioData($info, $id);

				 //we send a fcm broadcast to users to automatically edit medias on their device
				 $this->load->model('settings_model');
				 $server_key = $this->settings_model->getFcmServerKey();
				 $this->load->model('media_model');
				 $media = $this->media_model->fetchPlayableMedia($id);
				// $this->load->model('fcm_model');
				// $this->fcm_model->editMediaNotification($server_key,$media);

		    echo json_encode(array("status" => $this->audio_model->status,"msg" => $this->audio_model->message));
    }


    function deleteAudio($id=0){
      $this->load->library('session');
			$audio = $this->audio_model->getAudioInfo($id);
			if(count((array)$audio)>0)
			{
				@unlink('./uploads/audios/'.$audio->source);
				@unlink('./uploads/thumbnails/'.$audio->cover_photo);
			}
      $this->audio_model->deleteAudio($id);
      if($this->audio_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->audio_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->audio_model->message);
      }
      redirect('audioListing');
    }

		public function upload_audio(){
			$path = $_FILES['audio']['name'];
      $file_name = "audio_".time().".".pathinfo($path, PATHINFO_EXTENSION);
      $config['upload_path']          = './uploads/audios';
			$config['file_name'] = $file_name;
      //$config['max_size']             = 10000;
      $config['allowed_types']        = 'mp3';
      $config['overwrite'] = FALSE; //overwrite file

      //var_dump($config);
			$this->load->library('upload');
      $this->upload->initialize($config);

      if ( ! $this->upload->do_upload('audio')){
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



}
