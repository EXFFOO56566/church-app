<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Events extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('events_model');
    }

		public function index(){
        $data['events'] = $this->events_model->eventsListing();
        $this->load->template('events/listing', $data); // this will load the view file
    }

		public function newEvent()
    {
        $this->load->template('events/new', []); // this will load the view file
    }

    public function editEvent($id=0)
    {
        $data['event'] = $this->events_model->getEventInfo($id);
        if(count((array)$data['event'])==0)
        {
            redirect('events');
        }
				$data['event']->time = str_replace("AM","",$data['event']->time);
				$data['event']->time = str_replace("PM","",$data['event']->time);
				$data['event']->time = trim($data['event']->time);
        $this->load->template('events/edit', $data); // this will load the view file
    }

    public function savenewevent()
    {

            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('title','Event Title','trim|required|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newEvent');
            } if(empty($_FILES['thumbnail']['name'])){
							$this->session->set_flashdata('error', "Thumbnail is empty");
							redirect('newEvent');
						}
            else
            {
							$upload = $this->upload_thumbnail('./uploads/thumbnails/events');
							if($upload[0]=='ok'){
								$title = ucwords(strtolower($this->input->post('title')));
								$details = $this->input->post('details');
								$date = $this->input->post('date');
								$time = $this->input->post('time');
								$mer = intval($time) < 12 ? 'AM' : 'PM';
								$time = $time. " ".$mer;
								$info = array(
										'title' => $title,
										'details' => $details,
										'date' => $date,
										'time' => $time,
										'thumbnail' => $upload[1]
								);
								//var_dump($info); die;

								$event_id = $this->events_model->addNewEvent($info);
								if($event_id!=0 && $this->input->post('notify') == 0){
									$event = $this->events_model->getEventsData($event_id);
						      //var_dump($article); die;
						      if(count((array)$event)>0){
						          $this->load->model('settings_model');
						          $server_key = $this->settings_model->getFcmServerKey();
						          //echo $server_key; die;
						          $this->load->model('fcm_model');
						          $this->fcm_model->push_event_data($server_key,$event);
						      }
								}
								if($this->events_model->status == "ok")
								{
										$this->session->set_flashdata('success', $this->events_model->message);
								}
								else
								{
										$this->session->set_flashdata('error', $this->events_model->message);
								}
							}else{
								$this->session->set_flashdata('error', $upload[1]);
							}
              redirect('newEvent');
            }

    }


    function editEventData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');
			$this->form_validation->set_rules('title','Event Title','trim|required|xss_clean');

			if($this->form_validation->run() == FALSE)
			{
					redirect('editEvent/'.$id);
			} else
			{

					$title = ucwords(strtolower($this->input->post('title')));
					$details = $this->input->post('details');
					$time = $this->input->post('time');
					$mer = intval($time) < 12 ? 'AM' : 'PM';
					$time = $time. " ".$mer;
					$info = array(
							'title' => $title,
							'time' => $time,
							'details' => $details
					);

					if(!empty($_FILES['thumbnail']['name'])){
						$upload = $this->upload_thumbnail('./uploads/thumbnails/events');

						if($upload[0]=='ok'){
               $info['thumbnail'] = $upload[1];
						}else{
							$this->session->set_flashdata('error', $upload[1]);
							redirect('editEvent/'.$id);
							return;
						}
					}

					$this->events_model->editEvent($info,$id);
					if($this->events_model->status == "ok")
					{
							$this->session->set_flashdata('success', $this->events_model->message);
					}
					else
					{
							$this->session->set_flashdata('error', $this->events_model->message);
					}
					redirect('editEvent/'.$id);

			}
    }

		public function upload_thumbnail($uploadpath){
			$path = $_FILES['thumbnail']['name'];
			$ext = pathinfo($path, PATHINFO_EXTENSION);
			$new_name = time().".".$ext;

			$config['file_name'] = $new_name;
			$config['upload_path']          = $uploadpath;
			$config['max_size']             = 10000;
			$config['allowed_types']        = 'jpg|png|jpeg|PNG';
			$config['overwrite'] = TRUE; //overwrite thumbnail


			//var_dump($config);

			$this->load->library('upload', $config);

			if ( ! $this->upload->do_upload('thumbnail'))
			{
					//$error = array('error' => $this->upload->display_errors());
					return ['error',strip_tags($this->upload->display_errors())];
			}
			else{
					$image_data = $this->upload->data();
					return ['ok',$new_name];
			}
		}


    function deleteEvent($id=0)
    {
      $this->load->library('session');
      $this->events_model->deleteEvent($id);
      if($this->events_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->events_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->events_model->message);
      }
      redirect('events');
    }
}
