<?php
defined('BASEPATH') OR exit('No direct script access allowed');

require APPPATH . '/libraries/BaseController.php';

class Coupons extends BaseController {

	public function __construct()
    {
        parent::__construct();
				$this->load->model('coupons_model');
    }

		public function index(){
			$this->isLoggedIn();
        $data['coupons'] = $this->coupons_model->couponsListing();
        $this->load->template('coupons/listing', $data); // this will load the view file
    }


		public function newCoupon()
    {
			  $this->isLoggedIn();
        $this->load->template('coupons/new', []); // this will load the view file
    }

		function subscribeCoupon(){
				$data = $this->get_data();
				if(isset($data->code) && isset($data->email)){
					$email = isset($data->email)?filter_var($data->email, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";
					$code = isset($data->code)?filter_var($data->code, FILTER_SANITIZE_STRING, FILTER_FLAG_STRIP_HIGH):"null";
					$coupon = $this->coupons_model->fetchCoupon($code);
					//var_dump($coupon); die;
					if($coupon){
             $today = strtotime('today');
						 $expiry = strtotime($coupon->expiry);
						 //echo $expiry>=$today;
						 //die;
						 if($expiry>=$today){
							 //if date is valid
               $duration = "null";
							 $sub_expiry_date = 0;
							 switch ($coupon->duration) {
								case 'One Week':
									$duration = "one_week_sub";
									break;
								case 'One Month':
								  $duration = "one_month_sub";
									break;
								case 'Three Months':
								  $duration = "3_months_sub";
								  break;
							  case 'Six Months':
									 $duration = "6_months_sub";
									break;
								case 'One Year':
							   	$duration = "1_year_sub";
									break;
							 }

							 $sub_expiry_date = $this->get_expiry($duration);
							 $this->load->model('account_model');
							 $details = array("sub_type"=>1,"subscribed"=>0,"subscribe_plan"=>$duration,"subscribe_expiry_date"=>$sub_expiry_date);
							 $this->account_model->updateUserSubscription($details,$email);
							 $this->coupons_model->deleteCouponWithCode($code);
               echo json_encode(array("status" => "ok","period"=>$duration,"expiry_date"=>$sub_expiry_date,"message" =>"Subscription was successful"));

						 }else{
							 echo json_encode(array("status" => "error","msg" => "The coupon code you entered have expired."));
						 }
					}else{
						echo json_encode(array("status" => "error","msg" => "The coupon code you entered is not valid."));
					}
				}else{
					echo json_encode(array("status" => "error","msg" => "Invalid inputs detected."));
				}
		}



    function generateCoupon()
    {

			      $this->isLoggedIn();
            //var_dump($_FILES); die;
            $this->load->library('session');
            $this->load->library('form_validation');
						$data['print_data'] = [];

            $this->form_validation->set_rules('duration','Coupon Duration','trim|required|xss_clean');
						$this->form_validation->set_rules('amount','Coupon Amount','trim|required|xss_clean');
						$this->form_validation->set_rules('total','Total Coupon Codes','trim|required|xss_clean');
						$this->form_validation->set_rules('expiry','Coupon expiry','trim|required|xss_clean');

            if($this->form_validation->run() == FALSE)
            {
                redirect('newCoupon');
            }
            else
            {
							$duration = $this->input->post('duration');
							$amount = $this->input->post('amount');
							$total = $this->input->post('total');
							$expiry = $this->input->post('expiry');
							$currency = $this->input->post('currency');

              $a = 1;
							while ($a <= $total) {
								$code = $this->random_code(8);
								if($this->coupons_model->checkCouponCodeExists($code) == FALSE){
									$info = array(
											'code' => $code,
											'duration' => $duration,
											'amount' => $amount,
											'expiry' => $expiry
									);
									$this->coupons_model->addNewCoupon($info);
									$info['currency'] = $currency;
									array_push($data['print_data'], $info);
								}

								$a++;
							}

            }
         $this->load->view('coupon_print',$data);
    }

		function random_code($limit){
       return substr(base_convert(sha1(uniqid(mt_rand())), 16, 36), 0, $limit);
    }




    function deleteCoupon($id=0){
			$this->isLoggedIn();
      $this->load->library('session');
      $this->coupons_model->deleteCoupon($id);
      if($this->coupons_model->status == "ok"){
          $this->session->set_flashdata('success', $this->coupons_model->message);
      }else{
          $this->session->set_flashdata('error', $this->coupons_model->message);
      }
      redirect('coupons');
    }


		public function printcoupons(){
			$this->isLoggedIn();
		  	$duration = $this->input->post('duration');
				$currency = $this->input->post('currency');
				$start = $this->input->post('start');
				$limit = $this->input->post('limit');
        $data['print_data'] = $this->coupons_model->couponsDurationListing($duration,$currency,$start,$limit);
        $this->load->view('coupon_print',$data);
    }

		public function deleteGroupCoupons(){
			   $this->isLoggedIn();
		  	$duration = $this->input->post('duration');
				$this->coupons_model->deleteGroupCoupons($duration);
	      if($this->coupons_model->status == "ok"){
	          $this->session->set_flashdata('success', $this->coupons_model->message);
	      }else{
	          $this->session->set_flashdata('error', $this->coupons_model->message);
	      }
	      redirect('coupons');
    }



		public function get_expiry($duration){
			//echo $duration; die;
			$expiry = 0;
			switch ($duration) {
			 case 'one_week_sub':
				 $sum = strtotime('+1 week');
				 $expiry = $sum * 1000;
				 break;
			 case 'one_month_sub':
				 $sum = strtotime('+1 month');
				 $expiry = $sum * 1000;
				 break;
			 case '3_months_sub':
				 $sum = strtotime('+3 month');
				 $expiry = $sum * 1000;
				break;
			case '6_months_sub':
					$sum = strtotime('+6 month');
					$expiry = $sum * 1000;
				 break;
			 case '1_year_sub':
				 $sum = strtotime('+1 year');
				 $expiry = $sum * 1000;
				 break;
			}
      //echo $expiry; die;
			return $expiry;
		}
}
