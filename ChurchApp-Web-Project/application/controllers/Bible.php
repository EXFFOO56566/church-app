<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';
/*
* This class handles some of the requests from the android client app
*/
class Bible extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->load->model('bible_model');
    }

		//categories listing
		function getBibleVersions(){
			  $data = $this->get_data();
				$versions = $this->bible_model->biblesListing();
				echo json_encode(array("status" => "ok","versions" => $versions));
		}


		public function index(){
				$this->isLoggedIn();
        $data['bibles'] = $this->bible_model->biblesListing();
        $this->load->template('bibles/listing', $data); // this will load the view file
    }

		public function newBible()
    {
			   	$this->isLoggedIn();
        $this->load->template('bibles/new', []); // this will load the view file
    }

    public function editBible($id=0)
    {
			  	$this->isLoggedIn();
        $data['bible'] = $this->bible_model->getBibleInfo($id);
        if(count((array)$data['bible'])==0)
        {
            redirect('biblesListing');
        }
        $this->load->template('bibles/edit', $data); // this will load the view file
    }

    function savenewbible()
    {
			      	$this->isLoggedIn();
            //var_dump($_POST); die;
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('name','Bible Version Name','trim|required|xss_clean');
						$this->form_validation->set_rules('description','Bible Version Description','trim|required|xss_clean');
						$this->form_validation->set_rules('shortcode','Bible Version Short Name','trim|required|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newBranch');
            }else if(empty($_FILES['bible']['name'])){
							$this->session->set_flashdata('error', "Bible File is empty");
							redirect('newBible');
						}
            else
            {
							$upload = $this->upload_bible();
							if($upload[0]=='ok'){
								$name = $this->input->post('name');
								$shortcode = $this->input->post('shortcode');
								$description = $this->input->post('description');
								$info = array(
										'name' => $name,
										'shortcode' => $shortcode,
										'description' => $description,
										'source' => $upload[1]
								);
                                //var_dump($info); die;
								$this->bible_model->addNewBible($info);
								if($this->bible_model->status == "ok")
								{
										$this->session->set_flashdata('success', $this->bible_model->message);
								}
								else
								{
										$this->session->set_flashdata('error', $this->bible_model->message);
								}
							}else{
								$this->session->set_flashdata('error', $upload[1]);
							}
              redirect('newBible');
            }

    }


    function editBibleData()
    {
				$this->isLoggedIn();
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');
			$this->form_validation->set_rules('name','Bible Name','trim|required|xss_clean');
	   $this->form_validation->set_rules('description','Bible Version Description','trim|required|xss_clean');
		 $this->form_validation->set_rules('shortcode','Bible Version Short Name','trim|required|xss_clean');

			if($this->form_validation->run() == FALSE)
			{
					redirect('editBranch/'.$id);
			} else
			{

					$name = $this->input->post('name');
					$shortcode = $this->input->post('shortcode');
					$description = $this->input->post('description');
					$info = array(
						'name' => $name,
						'shortcode' => $shortcode,
						'description' => $description
					);

					$this->bible_model->editBible($info,$id);
					if($this->bible_model->status == "ok")
					{
							$this->session->set_flashdata('success', $this->bible_model->message);
					}
					else
					{
							$this->session->set_flashdata('error', $this->bible_model->message);
					}
					redirect('editBible/'.$id);

			}
    }


    function deleteBible($id=0)
    {
				$this->isLoggedIn();
      $this->load->library('session');
      $this->bible_model->deleteBible($id);
      if($this->bible_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->bible_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->bible_model->message);
      }
      redirect('biblesListing');
    }


		public function upload_bible(){
      $path = $_FILES['bible']['name'];
      $ext = pathinfo($path, PATHINFO_EXTENSION);
      $new_name = "bible_".time().".".$ext;

      $config['file_name'] = $new_name;
      $config['upload_path']          = './uploads';
      $config['max_size']             = 1000000;
      $config['allowed_types']        = '*';
      $config['overwrite'] = TRUE; //overwrite thumbnail


      //var_dump($config);

      $this->load->library('upload', $config);

      if ( ! $this->upload->do_upload('bible'))
      {
          //$error = array('error' => $this->upload->display_errors());
          return ['error',strip_tags($this->upload->display_errors())];
      }
      else{
          $bible_data = $this->upload->data();
					return ['ok',$new_name];
      }
    }


}
