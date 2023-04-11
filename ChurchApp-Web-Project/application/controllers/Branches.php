<?php
defined('BASEPATH') OR exit('No direct script access allowed');
header('Content-Type: text/html; charset=utf-8');
require APPPATH . '/libraries/BaseController.php';

class Branches extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->load->model('branches_model');
    }

		//fetch audios/videos
		function church_branches(){
				$data = $this->get_data();
				$results = [];
				$isLastPage = false;
				$page = 0;
				if(isset($data->page)){
					$page = $data->page;
				}

				$results = $this->branches_model->fetch_branches($page);
				$total_items = $this->branches_model->get_total_branches();
				$isLastPage = (($page + 1) * 20) >= $total_items;

				echo json_encode(array("status" => "ok","branches" => $results,"isLastPage" => $isLastPage));
		}

		public function index(){
				$this->isLoggedIn();
        $data['branches'] = $this->branches_model->branchesListing();
        $this->load->template('branches/listing', $data); // this will load the view file
    }

		public function loadbranches(){
				$this->isLoggedIn();
			$branches = $this->branches_model->branchesListing();
			echo json_encode(array("status" => "ok","branches" => $branches));
		}

		public function newBranch()
    {
			   	$this->isLoggedIn();
        $this->load->template('branches/new', []); // this will load the view file
    }

    public function editBranch($id=0)
    {
			  	$this->isLoggedIn();
        $data['branch'] = $this->branches_model->getBranchInfo($id);
        if(count((array)$data['branch'])==0)
        {
            redirect('branchesListing');
        }
        $this->load->template('branches/edit', $data); // this will load the view file
    }

    function savenewbranch()
    {
			      	$this->isLoggedIn();
            //var_dump($_POST); die;
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->form_validation->set_rules('name','Branch Name','trim|required|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newBranch');
            }else
            {
							$name = $this->input->post('name');
							$phone = $this->input->post('phone');
							$email = $this->input->post('email');
							$address = $this->input->post('address');
							$pastor = $this->input->post('pastor');
							$latitude = $this->input->post('latitude');
							$longitude = $this->input->post('longitude');
							$info = array(
								'name' => $name,
								'phone' => $phone,
								'email' => $email,
								'address' => $address,
								'pastor' => $pastor,
								'latitude' => $latitude,
								'longitude' => $longitude
							);
															//var_dump($info); die;
							$this->branches_model->addNewBranch($info);
							if($this->branches_model->status == "ok")
							{
									$this->session->set_flashdata('success', $this->branches_model->message);
							}
							else
							{
									$this->session->set_flashdata('error', $this->branches_model->message);
							}
              redirect('newBranch');
            }

    }


    function editBranchData()
    {
				$this->isLoggedIn();
			//var_dump($_FILES); die;
			$this->load->library('session');
			$this->load->library('form_validation');
      $id = $this->input->post('id');
			$this->form_validation->set_rules('name','Branch Name','trim|required|xss_clean');

			if($this->form_validation->run() == FALSE)
			{
					redirect('editBranch/'.$id);
			} else
			{

					$name = $this->input->post('name');
					$phone = $this->input->post('phone');
					$email = $this->input->post('email');
					$address = $this->input->post('address');
					$pastor = $this->input->post('pastor');
					$latitude = $this->input->post('latitude');
					$longitude = $this->input->post('longitude');
					$info = array(
						'name' => $name,
						'phone' => $phone,
						'email' => $email,
						'address' => $address,
						'pastor' => $pastor,
						'latitude' => $latitude,
						'longitude' => $longitude
					);

					$this->branches_model->editBranch($info,$id);
					if($this->branches_model->status == "ok")
					{
							$this->session->set_flashdata('success', $this->branches_model->message);
					}
					else
					{
							$this->session->set_flashdata('error', $this->branches_model->message);
					}
					redirect('editBranch/'.$id);

			}
    }


    function deleteBranch($id=0)
    {
				$this->isLoggedIn();
      $this->load->library('session');
      $this->branches_model->deleteBranch($id);
      if($this->branches_model->status == "ok")
      {
          $this->session->set_flashdata('success', $this->branches_model->message);
      }
      else
      {
          $this->session->set_flashdata('error', $this->branches_model->message);
      }
      redirect('branchesListing');
    }
}
