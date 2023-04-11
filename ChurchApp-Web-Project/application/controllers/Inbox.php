<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Inbox extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->isLoggedIn();
				$this->load->model('inbox_model');
    }

		public function index(){
        $data['inbox'] = $this->inbox_model->inboxListing();
        $this->load->template('inbox/listing', $data); // this will load the view file
    }

		public function newInbox()
    {
        $this->load->template('inbox/new', []); // this will load the view file
    }

    public function editInbox($id=0)
    {
        $data['inbox'] = $this->inbox_model->getInboxInfo($id);
        if(count((array)$data['inbox'])==0)
        {
            redirect('inbox');
        }
        $this->load->template('inbox/edit', $data); // this will load the view file
    }

    public function savenewinbox()
    {

            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('title','Message Title','trim|required|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newInbox');
            } else
            {
							$title = ucwords(strtolower($this->input->post('title')));
							$message = $this->input->post('message');
							$date = time();
							$info = array(
									'title' => $title,
									'message' => $message,
									'date' => $date
							);
							//var_dump($info); die;

							$inbox_id = $this->inbox_model->addNewInbox($info);
							if($inbox_id!=0){
								$inbox = $this->inbox_model->getInboxData($inbox_id);
								//var_dump($article); die;
								if(count((array)$inbox)>0){
										$this->load->model('settings_model');
										$server_key = $this->settings_model->getFcmServerKey();
										//echo $server_key; die;
										$this->load->model('fcm_model');
										$this->fcm_model->push_inbox_data($server_key,$inbox);
								}
								if($this->inbox_model->status == "ok")
								{
										$this->session->set_flashdata('success', $this->inbox_model->message);
								}
								else
								{
										$this->session->set_flashdata('error', $this->inbox_model->message);
								}
							}else{
								$this->session->set_flashdata('error', $upload[1]);
							}
              redirect('newInbox');
            }

    }


    function editInboxData()
    {
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');
			$this->form_validation->set_rules('title','Inbox Title','trim|required|xss_clean');

			if($this->form_validation->run() == FALSE)
			{
					redirect('editInbox/'.$id);
			} else
			{

					$title = ucwords(strtolower($this->input->post('title')));
					$message = $this->input->post('message');
					$info = array(
							'title' => $title,
							'message' => $message
					);

					$this->inbox_model->editInbox($info,$id);
					if($this->inbox_model->status == "ok")
					{
							$this->session->set_flashdata('success', $this->inbox_model->message);
					}
					else
					{
							$this->session->set_flashdata('error', $this->inbox_model->message);
					}
					redirect('editInbox/'.$id);

			}
    }


    function deleteInbox($id=0)
    {
      $this->load->library('session');
      $this->inbox_model->deleteInbox($id);
      if($this->inbox_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->inbox_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->inbox_model->message);
      }
      redirect('inbox');
    }
}
