<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Notifications extends BaseController {

	public function __construct(){
        parent::__construct();
				//$this->isLoggedIn();
				$this->load->model('notifications_model');
    }

		//rss links methods
		public function devotionalsListing(){
        $this->load->template('notifications/listing', []); // this will load the view file
    }

		function getNotifications(){
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


        $feeds = $this->notifications_model->adminDevotionalsListing($columnName,$columnSortOrder,$searchValue,$start, $length);
				$total_feeds = $this->notifications_model->get_total_devotionals($searchValue);
        //var_dump($feeds); die;
        $dat = array();

				 $count = $start + 1;
        foreach($feeds as $r) {
					//var_dump($r); die;
          //$title = substr($r->title,0,10 );
          //$content = substr($r->content,0,50 );

             $dat[] = array(
							    $count,
									$r->title,
									$r->date,
									'<div class="btn-group btn-group-sm" style="float: none;">'.
									'<a href="'.site_url().'editNotification/'.$r->id.'" type="button" class="tabledit-edit-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="margin-bottom:5px;" class="material-icons list-icon" data-id="'.$r->id.'">create</i></a>'.
									'<button onclick="delete_item(event)" data-type="notification" data-id="'.$r->id.'" type="button" class="tabledit-delete-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="color:red;margin-bottom:5px;"  class="material-icons list-icon" data-type="notification" data-id="'.$r->id.'">delete</i></button>'.
									'<button onclick="push_item(event)" data-type="notification" data-id="'.$r->id.'" type="button" class="tabledit-delete-button btn btn-sm btn-default" style="float: none;">'.
									'<i style="color:blue;margin-bottom:5px;"  class="material-icons list-icon" data-type="notification" data-id="'.$r->id.'">send</i></button></div>'
             );
						 $count++;
        }

        $output = array(
             "draw" => $draw,
               "recordsTotal" => $total_feeds,
               "recordsFiltered" => $total_feeds,
               "data" => $dat
          );
        $this->response($output);
    }


		public function newNotification(){
        $this->load->template('notifications/new', []); // this will load the view file
    }

    public function editNotification($id=0)
    {

        $data['notification'] = $this->notifications_model->getNotificationInfo($id);
        if(count((array)$data['notification'])==0)
        {
            redirect('notificationsListing');
        }
        $this->load->template('notifications/edit', $data); // this will load the view file
    }



    function saveNewNotification()
    {

            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('date','Notification Date','trim|required');
						$this->form_validation->set_rules('title','Notification Title','trim|required');

            if($this->form_validation->run() == FALSE)
            {
							  $this->session->set_flashdata('error', "Some fields were left empty");
                redirect('newNotification');
            }else {

							$date = $this->input->post('date');
							$title = $this->input->post('title');
							$thumbnail =$this->input->post('_thumbnail');
							$interest = $this->input->post('category');
							$article_type = $this->input->post('article_type');
							$content =$this->input->post('content');
							$media_type =$this->input->post('media_type');
							$video_source = $this->input->post('_video');
							if($article_type == "link"){
								$content =$this->input->post('link');
							}

							$info = array(
									'date' => $date,
									'title' => $title,
									'thumbnail' => $thumbnail,
									'content' => $content,
									'feed_type' => $article_type,
									'video_type' => $media_type,
									'video_source' => $video_source,
									'interest' => $interest
							);


							 $feed_id = $this->notifications_model->addNewNotification($info);
							}

							if($this->notifications_model->status == "ok")
							{
									$this->session->set_flashdata('success', $this->notifications_model->message);
							}
							else
							{
									$this->session->set_flashdata('error', $this->notifications_model->message);
							}
                redirect('newNotification');
            }

    }



    function editNotificationlData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');

			$this->form_validation->set_rules('date','Notification Date','trim|required');
			$this->form_validation->set_rules('title','Notification Title','trim|required');

			if($this->form_validation->run() == FALSE)
			{
					$this->session->set_flashdata('error', "Some fields were left empty");
					redirect('editNotification/'.$id);
			}else {

				$date = $this->input->post('date');
				$title = $this->input->post('title');
				$thumbnail =$this->input->post('_thumbnail');
				$interest = $this->input->post('category');
			 $article_type = $this->input->post('article_type');
				$content =$this->input->post('content');
				if($article_type == "link"){
					$content =$this->input->post('link');
				}
					$video_source = $this->input->post('_video');

				$info = array(
						'date' => $date,
						'title' => $title,
						'thumbnail' => $thumbnail,
						'content' => $content,
						'feed_type' => $article_type,
						'video_source' => $video_source,
						'interest' => $interest
				);

				 $this->notifications_model->editNotification($info,$id);
				 if($this->notifications_model->status == "ok")
				 {
						 $this->session->set_flashdata('success', $this->notifications_model->message);
				 }
				 else
				 {
						 $this->session->set_flashdata('error', $this->notifications_model->message);
				 }
				redirect('editNotification/'.$id);
			}
    }


    function deleteNotification($id=0)
    {
      $this->load->library('session');
      $this->notifications_model->deleteNotification($id);
      if($this->notifications_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->notifications_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->notifications_model->message);
      }
      redirect('notificationsListing');
    }
}
