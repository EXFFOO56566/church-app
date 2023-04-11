<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Donations extends BaseController {

	public function __construct()
    {
        parent::__construct();

				$this->load->model('donations_model');
    }

		public function index(){
			$this->isLoggedIn();
        $this->load->template('donations', []); // this will load the view file
    }


		function donationslisting(){
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


				$users = $this->donations_model->donationsListing($columnName,$columnSortOrder,$searchValue,$start, $length);
				$total_users = $this->donations_model->get_total_donations($searchValue);
				//var_dump($users); die;
				$dat = array();

				 $count = $start + 1;
				foreach($users as $r) {
						 $dat[] = array(
									$count,
									$r->reason,
									$r->email,
									$r->name,
									$r->reference,
									$r->amount,
									$r->method,
									$r->date
						 );
						 $count++;

				}

				$output = array(
						 "draw" => $draw,
							 "recordsTotal" => $total_users,
							 "recordsFiltered" => $total_users,
							 "data" => $dat
					);
				echo json_encode($output);
		}

		function donate(){
			  $this->load->model('donations_model');
				$data['settings'] = $this->donations_model->getSettings();
				$this->load->view('donate',$data);
		}

		function thank_you(){
				$this->load->view('thank_you');
		}


		public function update_donations_api()
    {
			$this->isLoggedIn();
			$this->load->model('donations_model');
			$data['settings'] = $this->donations_model->getSettings();
      $this->load->template('donation_settings', $data); // this will load the view file
    }


    function updatedonationSettings()
    {
            $this->load->library('session');
            $this->load->library('form_validation');

            $this->load->model('donations_model');

            $data = array('paystack_key'=>$this->input->post('paystack_key')
            ,'flutterwaves_key'=>$this->input->post('flutterwaves_key')
            ,'flutterwaves_currency_code'=>$this->input->post('flutterwaves_currency_code')
					  ,'paypal_link'=>$this->input->post('paypal_link'));
            $this->donations_model->updateSettings($data);
            if($this->donations_model->status == "ok")
            {
                $this->session->set_flashdata('success', $this->donations_model->message);
            }
            else
            {
                $this->session->set_flashdata('error', $this->donations_model->message);
            }

            redirect('update_donations_api');

    }
}
